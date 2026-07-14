#Include "Totvs.ch"

/*
______________________________________________________________________________
| Programa  | CNTEDF04                                                       |
| Função    | EnvBxaSF                                                       |
| Autor     | Alex Silva (Refatorado via Comparacao F0113160)                |
| Descrição | Motor centralizador de integração financeira:                  |
|           | 1. Atualiza tabelas locais de Contrato (ZX5 e ZX3).            |
|           | 2. Envia a notificação de Baixa/Estorno ao TOTVS iPaas.        |
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
    Local cQryZX3      := ""
    Local cAliasZX5    := GetNextAlias()
    Local cAliasZX3    := GetNextAlias() 
    Local cQryZX5      := ""
    Local nCalcPerc := 0
    
    // Segurança: Só processa se o título veio do SimpleFarm
    If Empty(cIdTit)
        Return .F.
    EndIf


    cQryZX5 := "SELECT R_E_C_N_O_ AS RECNO_ZX5 FROM " + RetSqlName("ZX5") + " "
    cQryZX5 += "WHERE ZX5_IDTIT = '" + cIdTit + "' AND D_E_L_E_T_ = ' '"
    
    cQryZX5 := ChangeQuery(cQryZX5)
    DBUseArea( .T., "TOPCONN", TcGenQry(,,cQryZX5), cAliasZX5, .F., .T. )
    
    If !(cAliasZX5)->(Eof())
        DbSelectArea("ZX5")
        ZX5->(DbGoTo((cAliasZX5)->RECNO_ZX5))
        
        RecLock("ZX5", .F.)
        If Upper(cTipoMov) == "BAIXA"
            If (ZX5->ZX5_SALDO - nValMov) < 0
                ZX5->ZX5_SALDO := 0
            Else
                ZX5->ZX5_SALDO := ZX5->ZX5_SALDO - nValMov
            EndIf
            ZX5->ZX5_DTBAIX := dDataMov 
        Else // ESTORNO
            ZX5->ZX5_SALDO  := ZX5->ZX5_SALDO + nValMov        
            ZX5->ZX5_DTBAIX := CtoD("//") 
        EndIf
        ZX5->(MsUnlock())
    EndIf
    (cAliasZX5)->(DbCloseArea())

    If !Empty(cContrat)

        // Monta a Query buscando apenas pelo código do contrato (Ignorando a Filial)
        cQryZX3 := "SELECT R_E_C_N_O_ AS RECNO_ZX3 FROM " + RetSqlName("ZX3") + " "
        cQryZX3 += "WHERE ZX3_CODIGO = '" + AllTrim(cContrat) + "' "
        cQryZX3 += "AND D_E_L_E_T_ = ' '"

        cQryZX3 := ChangeQuery(cQryZX3)
        DBUseArea( .T., "TOPCONN", TcGenQry(,,cQryZX3), cAliasZX3, .F., .T. )

        If !(cAliasZX3)->(Eof())
            DbSelectArea("ZX3")
            ZX3->(DbGoTo((cAliasZX3)->RECNO_ZX3))
            
            RecLock("ZX3", .F.)
            
            // 1. ATUALIZA O SALDO EM MOEDA
            If Upper(cTipoMov) == "BAIXA"
                If (ZX3->ZX3_SALDO - nValMov) < 0
                    ZX3->ZX3_SALDO := 0
                Else
                    ZX3->ZX3_SALDO := ZX3->ZX3_SALDO - nValMov
                EndIf
            Else // ESTORNO
                ZX3->ZX3_SALDO := ZX3->ZX3_SALDO + nValMov
            EndIf
            
            // 2. RECALCULA O SALDO PERCENTUAL (O que falta pagar)
            If ZX3->ZX3_VALOR > 0 
                
                // Calcula na memória primeiro para não dar 'Data width error'
                nCalcPerc := (ZX3->ZX3_SALDO / ZX3->ZX3_VALOR) * 100
                
                // Travas de Segurança (Garante que fique entre 0% e 100%)
                If nCalcPerc > 100
                    nCalcPerc := 100
                ElseIf nCalcPerc < 0
                    nCalcPerc := 0
                EndIf
                
                ZX3->ZX3_SLDPER := nCalcPerc
            Else
                // Se o contrato estiver sem valor total, zera a porcentagem por segurança
                ZX3->ZX3_SLDPER := 0
            EndIf
            
            ZX3->(MsUnlock())
        EndIf
        
        // Fecha o alias temporário da consulta
        (cAliasZX3)->(DbCloseArea())
    EndIf
    
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
    oJsonReq['Parcela']       := 1                        
    oJsonReq['SeqPagamento']  := nSeqPag                  
    oJsonReq['DataPagto']     := cDataBxa                 
    oJsonReq['ValorPagto']    := nValMov                  
    oJsonReq['ReferenciaERP'] := AllTrim(cIdTit) 
    oJsonReq['NumPagamento']  := AllTrim(cNumPag)         
    oJsonReq['TipoMovto']     := cTipoMov                 

    cJsonPost := oJsonReq:ToJson()


    cUrlUnica := StrTran(StrTran(AllTrim(GetMv("MV_ZZSFURL")), CRLF, ""), Chr(10), "")

    If Empty(cUrlUnica)
        MsgStop("A URL da API nao foi encontrada. Verifique o parametro MV_ZZSFURL.", "Erro de Parametro")
        Return .F.
    EndIf

    // 1. Passa a URL inteira (com o token api-key embutido nela)
    oRest := FWRest():New(cUrlUnica)
    oRest:SetPath("")
    
    // 2. Passa o JSON puro sem EncodeUTF8 (Igual ao VTEX)
    oRest:SetPostParams(cJsonPost) 

    // 3. Post enviando APENAS o Content-Type 
    If oRest:Post({"Content-Type: application/json"})
        
        // 4. Validação pelo Status Code (VTEX = 202, Sucesso)
        If oRest:GetHTTPCode() == "202" .Or. oRest:GetHTTPCode() == "200"
            FWLogMsg("INFO",, "CNTEDF04", "BaixaTitulo", "", "01", "Movimento de " + cTipoMov + " integrado ao SimpleFarm com SUCESSO. Titulo " + SE2->E2_NUM)
        Else
            lRet := .F.
            cResponse := oRest:GetResult()
            FWLogMsg("ERROR",, "CNTEDF04", "BaixaTitulo", "", "01", "Erro API SimpleFarm: Http Code " + oRest:GetHTTPCode() + " - " + cResponse)
            MsgStop("Falha ao integrar com o iPaas. Verifique o log (Http Code: " + oRest:GetHTTPCode() + ")", "Aviso de Integracao")
        EndIf
        
    Else
        lRet := .F.
        cErroConexao := oRest:GetLastError()
        MsgStop("O Protheus nao conseguiu se conectar ao iPaas." + CRLF + "URL: " + cUrlUnica + CRLF + "Erro tecnico: " + cErroConexao, "Erro de Conexao REST")
        FWLogMsg("ERROR",, "CNTEDF04", "BaixaTitulo", "", "01", "Falha de conexao com: " + cUrlUnica + ". Erro: " + cErroConexao)
    EndIf

    FreeObj(oJsonReq)
Return lRet
