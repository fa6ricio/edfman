#Include "Totvs.ch"

/*
______________________________________________________________________________
| Programa  | CNTEDF04                                                       |
| Função    | EnvBxaSF                                                       |
| Autor     | Alex Silva                                                     |
| Descrição | Motor de integração para envio de Baixas e Estornos para a     |
|           | API REST do SimpleFarm via TOTVS iPaas (URL Única).            |
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
    
    Local cJsonPost := ""
    Local cResponse := ""
    Local cQuery    := ""
    Local cAliasTmp := GetNextAlias()
    Local nSeqPag   := 1
    Local cDataBxa  := ""
    Local lRet      := .T.

    If Empty(SE2->E2_ZZIDTIT)
        Return .F.
    EndIf

    nPosBarra := At("/", StrTran(cUrlUnica, "://", "   "))
    If nPosBarra > 0
        cUrlBase := SubStr(cUrlUnica, 1, nPosBarra - 1) 
        cPath    := SubStr(cUrlUnica, nPosBarra)        
    Else
        cUrlBase := cUrlUnica
        cPath    := "/"
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
    
    // Monta o array de cabeçalhos
    AAdd(aHeader, "Content-Type: application/json")

    // Passa o array de cabeçalhos como parâmetro da função Post()
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
        FWLogMsg("ERROR",, "CNTEDF04", "BaixaTitulo", "", "01", "Falha de conexao com o iPaas. Status Code: " + cValToChar(oRest:GetStatusCode()))
    EndIf

    FreeObj(oJsonReq)
    FreeObj(oJsonRet)
Return lRet
