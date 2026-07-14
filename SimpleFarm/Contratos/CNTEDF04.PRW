#Include "Totvs.ch"

/*
______________________________________________________________________________
| Programa  | CNTEDF04                                                       |
| Função    | EnvBxaSF                                                       |
| Autor     | Alex Silva (Refatorado - Multi-Tabelas e Inteligência de Moedas|
| Descrição | Motor centralizador de integração financeira:                  |
|           | 1. Notifica o TOTVS iPaas PRIMEIRO (Prevenção de Rollback).    |
|           | 2. Verifica a moeda de cada tabela (ZX5, ZX3) e aplica o       |
|           |    abatimento na moeda correta, usando a PTAX salva na ZX5.    |
|____________________________________________________________________________|
*/
User Function EnvBxaSF(nValMov, dDataMov, cNumPag, cTipoMov, cIdTit)
    Local oRest
    Local oJsonReq     := JsonObject():New()
    Local cUrlUnica    := "" 
    Local cErroConexao := ""
    Local cJsonPost    := ""
    Local cResponse    := ""
    Local cQuery       := ""
    Local cAliasTmp    := GetNextAlias()
    Local nSeqPag      := 1
    Local cDataBxa     := ""
    Local lRet         := .T.
    
    Local cContrat     := SE2->E2_ZZCONTR 
    Local cAliasZX5    := GetNextAlias()
    Local cAliasZX3    := GetNextAlias()
    Local cAliasZX6    := GetNextAlias()
    
    Local nValMovOrig  := nValMov // Valor convertido para Dólar (se aplicável)
    Local nValAbater   := 0       // Valor dinâmico que será abatido em cada tabela
    Local nCalcPerc    := 0
    Local cMoedaZX5    := "1"
    
    // Segurança: Só processa se o título tiver ID de integração
    If Empty(cIdTit)
        Return .F.
    EndIf

    // =========================================================================
    // 1. CÁLCULO DA TAXA DE CÂMBIO (Fonte da Verdade: Tabela ZX5)
    // =========================================================================
    cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX5, ZX5_MOEDA, ZX5_PTAX FROM " + RetSqlName("ZX5") + " "
    cQuery += "WHERE ZX5_IDTIT = '" + cIdTit + "' AND D_E_L_E_T_ = ' '"
    cQuery := ChangeQuery(cQuery)
    DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZX5, .F., .T. )
    
    If !(cAliasZX5)->(Eof())
        cMoedaZX5 := (cAliasZX5)->ZX5_MOEDA
        
        // Se a ZX5 gravou PTAX, faz a conversão reversa (Reais -> Moeda Original)
        If (cAliasZX5)->ZX5_PTAX > 0
            nValMovOrig := Round(nValMov / (cAliasZX5)->ZX5_PTAX, 2)
        EndIf
    Else
        (cAliasZX5)->(DbCloseArea())
        Return .F. // Não encontrou a previsão, aborta a integração
    EndIf

    // =========================================================================
    // 2. CONTAGEM DE SEQUÊNCIA E MONTAGEM DO JSON
    // =========================================================================
    cQuery := "SELECT COUNT(*) AS QTD FROM " + RetSqlName("SE5") + " "
    cQuery += "WHERE E5_FILIAL = '" + SE2->E2_FILIAL + "' "
    cQuery += "AND E5_PREFIXO = '" + SE2->E2_PREFIXO + "' "
    cQuery += "AND E5_NUMERO = '" + SE2->E2_NUM + "' "
    cQuery += "AND E5_PARCELA = '" + SE2->E2_PARCELA + "' "
    cQuery += "AND E5_TIPO = '" + SE2->E2_TIPO + "' "
    cQuery += "AND E5_FORNECE = '" + SE2->E2_FORNECE + "' "
    cQuery += "AND E5_LOJA = '" + SE2->E2_LOJA + "' "
    cQuery += "AND E5_TIPODOC IN ('VP', 'VL', 'EP') " 
    cQuery += "AND D_E_L_E_T_ = ' '"
    
    cQuery := ChangeQuery(cQuery)
    DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasTmp, .F., .T. )
    If !(cAliasTmp)->(Eof()) .And. (cAliasTmp)->QTD > 0
        nSeqPag := (cAliasTmp)->QTD
    EndIf
    (cAliasTmp)->(DbCloseArea())

    cDataBxa := StrZero(Year(dDataMov), 4) + "-" + StrZero(Month(dDataMov), 2) + "-" + StrZero(Day(dDataMov), 2)

    oJsonReq['NumTit']        := AllTrim(SE2->E2_NUM)   
    oJsonReq['Parcela']       := AllTrim(SE2->E2_PARCELA)                      
    oJsonReq['SeqPagamento']  := nSeqPag                  
    oJsonReq['DataPagto']     := cDataBxa 

    oJsonReq['ValorPagto']    := IIf(cMoedaZX5 == "2", nValMovOrig, nValMov)
                   
    oJsonReq['ReferenciaERP'] := AllTrim(cIdTit) 
    oJsonReq['NumPagamento']  := AllTrim(cNumPag)         
    oJsonReq['TipoMovto']     := cTipoMov                 

    cJsonPost := oJsonReq:ToJson()
    FreeObj(oJsonReq)

    // =========================================================================
    // 3. CHAMADA DA API (Realizada ANTES de comitar os dados locais)
    // =========================================================================
    cUrlUnica := StrTran(StrTran(AllTrim(GetMv("MV_ZZSFURL")), CRLF, ""), Chr(10), "")

    If Empty(cUrlUnica)
        MsgStop("A URL da API nao foi encontrada. Verifique o parametro MV_ZZSFURL.", "Erro de Parametro")
        (cAliasZX5)->(DbCloseArea())
        Return .F.
    EndIf

    oRest := FWRest():New(cUrlUnica)
    oRest:SetPath("")
    oRest:SetPostParams(cJsonPost) 

    If oRest:Post({"Content-Type: application/json"})
        If oRest:GetHTTPCode() == "202" .Or. oRest:GetHTTPCode() == "200"
            FWLogMsg("INFO",, "CNTEDF04", "BaixaTitulo", "", "01", "Movimento de " + cTipoMov + " integrado ao SimpleFarm com SUCESSO. Titulo " + SE2->E2_NUM)
        Else
            cResponse := oRest:GetResult()
            FWLogMsg("ERROR",, "CNTEDF04", "BaixaTitulo", "", "01", "Erro API SimpleFarm: Http Code " + oRest:GetHTTPCode() + " - " + cResponse)
            MsgStop("Falha ao integrar com o iPaas. Verifique o log (Http Code: " + oRest:GetHTTPCode() + ")", "Aviso de Integracao")
            (cAliasZX5)->(DbCloseArea())
            Return .F. 
        EndIf
    Else
        cErroConexao := oRest:GetLastError()
        MsgStop("O Protheus nao conseguiu se conectar ao iPaas." + CRLF + "URL: " + cUrlUnica + CRLF + "Erro tecnico: " + cErroConexao, "Erro de Conexao REST")
        FWLogMsg("ERROR",, "CNTEDF04", "BaixaTitulo", "", "01", "Falha de conexao com: " + cUrlUnica + ". Erro: " + cErroConexao)
        (cAliasZX5)->(DbCloseArea())
        Return .F. 
    EndIf

    // =========================================================================
    // 4. ATUALIZAÇÃO LOCAL DAS TABELAS (Análise Individual de Moeda)
    // =========================================================================

    // 4.1. Atualiza ZX5 (Previsão)
    DbSelectArea("ZX5")
    ZX5->(DbGoTo((cAliasZX5)->RECNO_ZX5))
    
    // Define qual valor abater na ZX5 baseado na Moeda dela mesma
    nValAbater := IIf(cMoedaZX5 == "2", nValMovOrig, nValMov)

    RecLock("ZX5", .F.)
    If Upper(cTipoMov) == "BAIXA"
        ZX5->ZX5_SALDO := Max(0, ZX5->ZX5_SALDO - nValAbater)
        ZX5->ZX5_DTBAIX := dDataMov 
    Else // ESTORNO
        ZX5->ZX5_SALDO  := ZX5->ZX5_SALDO + nValAbater        
        ZX5->ZX5_DTBAIX := CtoD("//") 
    EndIf
    ZX5->(MsUnlock())
    (cAliasZX5)->(DbCloseArea())

    If !Empty(cContrat)
        // Busca o Contrato (ZX3)
        cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX3, ZX3_MOEDA FROM " + RetSqlName("ZX3") + " "
        cQuery += "WHERE ZX3_CODIGO = '" + AllTrim(cContrat) + "' AND D_E_L_E_T_ = ' '"
        cQuery := ChangeQuery(cQuery)
        DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZX3, .F., .T. )

        If !(cAliasZX3)->(Eof())
            DbSelectArea("ZX3")
            ZX3->(DbGoTo((cAliasZX3)->RECNO_ZX3))
            
            // Define o valor a abater no Contrato baseado na Moeda do Contrato
            nValAbater := IIf(ZX3->ZX3_MOEDA == "2", nValMovOrig, nValMov)

            // 4.2. Atualiza ZX6 (Parceiro)
            cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX6 FROM " + RetSqlName("ZX6") + " "
            cQuery += "WHERE ZX6_CODIGO = '" + AllTrim(cContrat) + "' "
            cQuery += "AND ZX6_FORNEC = '" + SE2->E2_FORNECE + "' AND ZX6_LOJA = '" + SE2->E2_LOJA + "' "
            cQuery += "AND D_E_L_E_T_ = ' '"
            cQuery := ChangeQuery(cQuery)
            DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZX6, .F., .T. )
            
            If !(cAliasZX6)->(Eof())
                DbSelectArea("ZX6")
                ZX6->(DbGoTo((cAliasZX6)->RECNO_ZX6))
                RecLock("ZX6", .F.)
                If Upper(cTipoMov) == "BAIXA"
                    ZX6->ZX6_SLDCES := Max(0, ZX6->ZX6_SLDCES - nValAbater)
                Else // ESTORNO
                    ZX6->ZX6_SLDCES := ZX6->ZX6_SLDCES + nValAbater
                EndIf
                ZX6->(MsUnlock())
            EndIf
            (cAliasZX6)->(DbCloseArea())

            // 4.3. Atualiza ZX3 (Contrato Geral)
            RecLock("ZX3", .F.)
            If Upper(cTipoMov) == "BAIXA"
                ZX3->ZX3_SALDO := Max(0, ZX3->ZX3_SALDO - nValAbater)
            Else // ESTORNO
                ZX3->ZX3_SALDO := ZX3->ZX3_SALDO + nValAbater
            EndIf
            
            // Recalcula a Porcentagem do Saldo
            If ZX3->ZX3_VLRTOT > 0 
                // Reflete a matemática exata: Saldo Restante dividido pelo Valor Total do Contrato
                nCalcPerc := Round((ZX3->ZX3_SALDO / ZX3->ZX3_VLRTOT) * 100, 2)
                ZX3->ZX3_SLDPER := nCalcPerc
            Else
                // Se o contrato estiver sem valor total (Zero), zera a porcentagem por segurança
                ZX3->ZX3_SLDPER := 0
            EndIf
            
            ZX3->(MsUnlock())
        EndIf
        (cAliasZX3)->(DbCloseArea())
    EndIf
    
Return lRet
