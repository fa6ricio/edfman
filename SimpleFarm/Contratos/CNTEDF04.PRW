#Include "Totvs.ch"

/*
______________________________________________________________________________
| Programa  | CNTEDF04                                                       |
| Função    | EnvBxaSF                                                       |
| Autor     | Alex Silva                                                     |
| Descrição | Motor centralizador de integração financeira:                  |
|           | 1. Atualiza tabelas locais de Contrato (ZX5 e ZX3).            |
|           | 2. Envia a notificação de Baixa/Estorno ao TOTVS iPaas.        |
|____________________________________________________________________________|
*/
User Function EnvBxaSF(nValMov, dDataMov, cNumPag, cTipoMov)
    Local oRest
    Local oJsonReq  := JsonObject():New()
    Local oJsonRet  := JsonObject():New()
    
    // Parâmetro com a URL completa do iPaas
    Local cUrlUnica := AllTrim(GetMv("MV_ZZSFURL")) 
    Local cUrlBase  := ""
    Local cPath     := ""
    Local nPosBarra := 0
    Local aHeader   := {}
    Local cErroConexao := ""
    
    Local cJsonPost := ""
    Local cResponse := ""
    Local cQuery    := ""
    Local cAliasTmp := GetNextAlias()
    Local nSeqPag   := 1
    Local cDataBxa  := ""
    Local lRet      := .T.
    Local cContrat  := SE2->E2_ZZCONTR // Recupera o número do contrato amarrado ao título

    // Segurança: Só processa se o título veio do SimpleFarm
    If Empty(SE2->E2_ZZIDTIT)
        Return .F.
    EndIf

    // =========================================================================
    // 1. ATUALIZAÇÃO REGRAS LOCAIS PROTHEUS (ZX5 e ZX3)
    // =========================================================================
    
    // --- Atualização da ZX5 (Títulos Fixados do Contrato) ---
    DbSelectArea("ZX5")
    ZX5->(DbSetOrder(3)) // Chave aproximada de busca: ZX5_FILIAL + ZX5_PREFIX + ZX5_NUM + ZX5_PARC + ZX5_TIPO
    If ZX5->(DbSeek(xFilial("ZX5") + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO))
        
        RecLock("ZX5", .F.)
        If Upper(cTipoMov) == "BAIXA"
            // Abate o saldo garantindo que não fique negativo
            ZX5->ZX5_SALDO   := Max(0, ZX5->ZX5_SALDO - nValMov) 
            ZX5->ZX5_DTBAIX  := dDataMov // Grava a data da baixa financeira
        Else // ESTORNO
            // Devolve o valor ao saldo do título se for estornado
            ZX5->ZX5_SALDO   := ZX5->ZX5_SALDO + nValMov        
            ZX5->ZX5_DTBAIX  := CtoD("//") // Limpa a data da baixa
        EndIf
        ZX5->(MsUnlock())
        
    EndIf

    // --- Atualização da ZX3 (Cabeçalho do Contrato / Saldo Geral Financeiro) ---
    If !Empty(cContrat)
        DbSelectArea("ZX3")
        ZX3->(DbSetOrder(1)) // ZX3_FILIAL + ZX3_CODIGO
        If ZX3->(DbSeek(xFilial("ZX3") + PadR(cContrat, TamSx3("ZX3_CODIGO")[1])))
            
            RecLock("ZX3", .F.)
            If Upper(cTipoMov) == "BAIXA"
                // O Saldo pendente do contrato diminui porque houve uma baixa efetiva
                ZX3->ZX3_SALDO := Max(0, ZX3->ZX3_SALDO - nValMov)
            Else // ESTORNO
                // O Saldo pendente volta a subir porque o pagamento foi cancelado
                ZX3->ZX3_SALDO := ZX3->ZX3_SALDO + nValMov
            EndIf
            ZX3->(MsUnlock())
            
        EndIf
    EndIf

    // =========================================================================
    // 2. DISPARO PARA O WEB SERVICE (TOTVS iPaas / SimpleFarm)
    // =========================================================================
    
    // Separador de URL inteligente
    nPosBarra := At("/", StrTran(cUrlUnica, "://", "   "))
    If nPosBarra > 0
        cUrlBase := SubStr(cUrlUnica, 1, nPosBarra - 1) 
        cPath    := SubStr(cUrlUnica, nPosBarra)        
    Else
        cUrlBase := cUrlUnica
        cPath    := "/"
    EndIf

    // Calcula SeqPagamento dinamicamente via SE5
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

    // Monta Payload JSON
    oJsonReq['NumTit']        := AllTrim(SE2->E2_ZZIDTIT)
    oJsonReq['Parcela']       := 1                        
    oJsonReq['SeqPagamento']  := nSeqPag                  
    oJsonReq['DataPagto']     := cDataBxa                 
    oJsonReq['ValorPagto']    := nValMov                  
    oJsonReq['ReferenciaERP'] := AllTrim(SE2->E2_NUM)     
    oJsonReq['NumPagamento']  := AllTrim(cNumPag)         
    oJsonReq['TipoMovto']     := cTipoMov                 

    cJsonPost := oJsonReq:ToJson()

    // Executa chamada HTTP REST
    oRest := FWRest():New(cUrlBase)
    oRest:SetPath(cPath)
    oRest:SetPostParams(cJsonPost)
    
    AAdd(aHeader, "Content-Type: application/json")

    If oRest:Post(aHeader)
        cResponse := oRest:GetResult()
        oJsonRet:ToObj(cResponse)
        
        If oJsonRet['Executed'] != Nil .And. oJsonRet['Executed'] == .T. .And. oJsonRet['HasErrors'] == .T.
            lRet := .F.
            If oJsonRet['Result'] != Nil .And. oJsonRet['Result']['Data'] != Nil
                FWLogMsg("ERROR",, "CNTEDF04", "BaixaTitulo", "", "01", "Erro na API SimpleFarm: " + oJsonRet['Result']['Data']['ErrorMessages'][1]['Message'])
            EndIf
        Else
            FWLogMsg("INFO",, "CNTEDF04", "BaixaTitulo", "", "01", "Movimento de " + cTipoMov + " integrado ao SimpleFarm para o Titulo " + SE2->E2_NUM)
        EndIf
    Else
        lRet := .F.
        cErroConexao := oRest:GetLastError()
        
        // Exibe o erro na tela do usuario (Temporario para debug de rede)
        MsgStop("O Protheus nao conseguiu se conectar ao iPaas." + CRLF + "Erro tecnico: " + cErroConexao, "Erro de Conexao REST")
        
        FWLogMsg("ERROR",, "CNTEDF04", "BaixaTitulo", "", "01", "Falha de conexao. Erro: " + cErroConexao)
    EndIf

    FreeObj(oJsonReq)
    FreeObj(oJsonRet)
Return lRet
