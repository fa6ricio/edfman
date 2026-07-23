#Include "Totvs.ch"

/*/{Protheus.doc} Programa  - CNTEDF04
Ponto de entrada de validação de baixa de títulos de contas a pagar

@author Alex da Silva
@since  18/06/2026
/*/
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
    Local nContador    := 1 
    Local cDataBxa     := ""
    Local lRet         := .T.
    
    Local cContrat     := SE2->E2_ZZCONTR 
    Local cAliasZX5    := GetNextAlias()
    Local cAliasZX6    := GetNextAlias()
    
    Local nValMovOrig  := nValMov 
    Local nValAbater   := 0       
    Local cMoedaZX5    := "1"
    
    Local cTipoPagto    := Nil
    Local nCotacaoMoeda := Nil
    Local cZx6Tipo      := ""
    
    If Empty(cIdTit)
        Return .F.
    EndIf

    cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX5, ZX5_MOEDA, ZX5_PTAX FROM " + RetSqlName("ZX5") + " "
    cQuery += "WHERE ZX5_IDTIT = '" + cIdTit + "' "
    cQuery += "AND ZX5_FORNEC = '" + SE2->E2_FORNECE + "' " 
    cQuery += "AND ZX5_LOJA = '" + SE2->E2_LOJA + "' "
    cQuery += "AND D_E_L_E_T_ = ' '"
    
    cQuery := ChangeQuery(cQuery)
    DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZX5, .F., .T. )
    
    If !(cAliasZX5)->(Eof())
        cMoedaZX5 := (cAliasZX5)->ZX5_MOEDA
        
        If (cAliasZX5)->ZX5_PTAX > 0
            nValMovOrig := Round(nValMov / (cAliasZX5)->ZX5_PTAX, 2)
            nCotacaoMoeda := (cAliasZX5)->ZX5_PTAX // Grava a cotação para o JSON
        EndIf
    Else
        (cAliasZX5)->(DbCloseArea())
        Return .F. 
    EndIf

    cQuery := "SELECT SE5.E5_FORNECE, SE5.E5_LOJA, SE5.R_E_C_N_O_ AS RECNO_SE5 FROM " + RetSqlName("SE5") + " SE5 "
    cQuery += "INNER JOIN " + RetSqlName("SE2") + " SE2 ON SE5.E5_FILIAL = SE2.E2_FILIAL "
    cQuery += "AND SE5.E5_PREFIXO = SE2.E2_PREFIXO AND SE5.E5_NUMERO = SE2.E2_NUM "
    cQuery += "AND SE5.E5_PARCELA = SE2.E2_PARCELA AND SE5.E5_TIPO = SE2.E2_TIPO "
    cQuery += "AND SE5.E5_FORNECE = SE2.E2_FORNECE AND SE5.E5_LOJA = SE2.E2_LOJA "
    cQuery += "WHERE SE2.E2_ZZIDTIT = '" + AllTrim(cIdTit) + "' "
    cQuery += "AND SE5.E5_TIPODOC IN ('VP', 'VL', 'EP') " 
    cQuery += "AND SE5.D_E_L_E_T_ = ' ' AND SE2.D_E_L_E_T_ = ' ' "
    cQuery += "ORDER BY SE5.E5_DATA, SE5.R_E_C_N_O_ "
    
    cQuery := ChangeQuery(cQuery)
    DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasTmp, .F., .T. )
    
    nSeqPag   := 1
    nContador := 1
    
    While !(cAliasTmp)->(Eof())
        If AllTrim((cAliasTmp)->E5_FORNECE) == AllTrim(SE2->E2_FORNECE) .And. AllTrim((cAliasTmp)->E5_LOJA) == AllTrim(SE2->E2_LOJA)
            nSeqPag := nContador
        EndIf
        nContador++
        (cAliasTmp)->(DbSkip())
    EndDo
    
    (cAliasTmp)->(DbCloseArea())

    If !Empty(cContrat)
        cQuery := "SELECT ZX6_TIPO FROM " + RetSqlName("ZX6") + " "
        cQuery += "WHERE ZX6_CODIGO = '" + AllTrim(cContrat) + "' "
        cQuery += "AND ZX6_FORNEC = '" + SE2->E2_FORNECE + "' AND ZX6_LOJA = '" + SE2->E2_LOJA + "' "
        cQuery += "AND D_E_L_E_T_ = ' '"
        cQuery := ChangeQuery(cQuery)
        DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZX6, .F., .T. )
        
        If !(cAliasZX6)->(Eof())
            cZx6Tipo := AllTrim((cAliasZX6)->ZX6_TIPO)
        EndIf
        (cAliasZX6)->(DbCloseArea())

 
        If Upper(AllTrim(SE2->E2_TIPO)) == "PA"
            cTipoPagto := "3"
        ElseIf cZx6Tipo == "2"
            cTipoPagto := "2" 
        Else
            cTipoPagto := "1" 
        EndIf
    EndIf

    cDataBxa := StrZero(Year(dDataMov), 4) + "-" + StrZero(Month(dDataMov), 2) + "-" + StrZero(Day(dDataMov), 2)

    oJsonReq['NumTit']        := AllTrim(SE2->E2_NUM)   
    oJsonReq['Parcela']       := Val(SE2->E2_PARCELA)                      
    oJsonReq['SeqPagamento']  := nSeqPag                  
    oJsonReq['DataPagto']     := cDataBxa 
    oJsonReq['ValorPagto']    := IIf(cMoedaZX5 == "2", nValMovOrig, nValMov)
    oJsonReq['ReferenciaERP'] := AllTrim(cIdTit) 
    oJsonReq['NumPagamento']  := AllTrim(cNumPag)         
    oJsonReq['TipoMovto']     := cTipoMov
    oJsonReq['tipoPagto']     := cTipoPagto
    oJsonReq['cotacaoMoeda']  := nCotacaoMoeda                 

    cJsonPost := oJsonReq:ToJson()
    FreeObj(oJsonReq)

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

    nValAbater := IIf(cMoedaZX5 == "2", nValMovOrig, nValMov)

    DbSelectArea("ZX5")
    ZX5->(DbGoTo((cAliasZX5)->RECNO_ZX5))
    
    RecLock("ZX5", .F.)
    If Upper(cTipoMov) == "BAIXA"
        ZX5->ZX5_SALDO  := Max(0, ZX5->ZX5_SALDO - nValAbater)
        ZX5->ZX5_DTBAIX := dDataMov 
    Else 
        ZX5->ZX5_SALDO  := ZX5->ZX5_SALDO + nValAbater        
        ZX5->ZX5_DTBAIX := CtoD("//") 
    EndIf
    ZX5->(MsUnlock())
    (cAliasZX5)->(DbCloseArea())

    If !Empty(cContrat)
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
            Else 
                ZX6->ZX6_SLDCES := ZX6->ZX6_SLDCES + nValAbater
            EndIf
            ZX6->(MsUnlock())
        EndIf
        (cAliasZX6)->(DbCloseArea())
    EndIf
    
Return lRet
