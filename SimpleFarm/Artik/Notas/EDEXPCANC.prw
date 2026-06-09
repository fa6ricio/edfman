#Include 'Protheus.ch'
#Include 'Restful.ch'

WsRestful EDEXPCANC Description 'API de Notas Canceladas (Exportação).'

	WSDATA Page     AS INTEGER OPTIONAL
	WSDATA PageSize AS INTEGER OPTIONAL

	WsMethod GET 1 Description 'Retorna notas canceladas (Exportação).' WSSYNTAX "/v1/outbound-docs" PATH '/'
	WsMethod PUT 2 Description 'Atualiza Nota Cancelada (Exportação).' WSSYNTAX "/v1/outbound-docs" PATH '/'

END WsRestful

// Retorna todos os pedidos de venda
WsMethod GET 1 WsRestful EDEXPCANC

Local oResp       := JsonObject():New()
Local aData       := {}

Local cAliasMain  := GetNextAlias()
Local cAliasItens := ""

Local cQuery      := ""
Local cQueryItens := ""

Local oErr        := Nil

// Parâmetros
Local nPage       := IIf(Empty(Self:Page) .Or. Self:Page <= 0, 1, Self:Page)
Local nPageSize   := IIf(Empty(Self:PageSize) .Or. Self:PageSize <= 0, 50, Self:PageSize)

// Cursor (keyset por RECNO SF2)
Local cCursor     := ''

// Filtro data (>= 20250101)
Local cDtIni      := "20260215"

// Saída de paginação
Local cNextCursor := ""
Local lHasNext    := .F.

// Controle
Local nRead       := 0
Local nWanted     := nPageSize
Local nStart      := (nPage - 1) * nPageSize
Local nSkipped    := 0

// Empresa (opcional)
Local cEmpCorrente := IIf(Type("cEmpAnt") == "C", cEmpAnt, "")

                /* ------------------------ Monta JSON --------------------------- */
Local oWrap   := JsonObject():New()
Local oNf     := JsonObject():New()
Local aMap    := {}
Local cCodSef := ""
Local cProt   := ""
Local cSts    := ""
Local cMsg    := ""
Local cChRaw  := ""
Local cChave  := ""
Local oItem := JsonObject():New()

Private Retorn := ''

Self:SetContentType("application/json")

BEGIN SEQUENCE

	cQuery := " SELECT DISTINCT "
	cQuery += "   SF2.R_E_C_N_O_  AS REC_SF2, SC5.C5_NUM,SF2.F2_FILIAL,"
	cQuery += "   SF2.F2_FILIAL, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_CLIENTE, SF2.F2_LOJA, "
	cQuery += "   SF2.F2_EMISSAO, SF2.F2_VALMERC, SF2.F2_CHVNFE, "
	cQuery += "   SF2.F2_PLIQUI, SF2.F2_PBRUTO, SF2.F2_TRANSP, SF2.F2_COND, "
	cQuery += "   SD2.D2_PEDIDO, "
	cQuery += "   SF3.F3_CHVNFE, SF3.F3_CODRSEF, SF3.F3_PROTOC,SC5.C5_PEDEXP "
	cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
	cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 "
	cQuery += "   ON SD2.D_E_L_E_T_ = '*' "
	cQuery += "  AND SD2.D2_FILIAL  = SF2.F2_FILIAL "
	cQuery += "  AND SD2.D2_DOC     = SF2.F2_DOC "
	cQuery += "  AND SD2.D2_SERIE   = SF2.F2_SERIE "
	cQuery += "  AND SD2.D2_PEDIDO <> '' "
	cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 "
	cQuery += "  ON SC5.C5_NUM  = SD2.D2_PEDIDO "
	cQuery += " LEFT JOIN " + RetSqlName("SF3") + " SF3 "
	cQuery += "   ON SF3.D_E_L_E_T_  = ' ' "
	cQuery += "  AND SF3.F3_FILIAL   = SF2.F2_FILIAL "
	cQuery += "  AND SF3.F3_NFISCAL  = SF2.F2_DOC "
	cQuery += "  AND SF3.F3_SERIE    = SF2.F2_SERIE "
	cQuery += "  AND SF3.F3_CLIEFOR  = SF2.F2_CLIENTE "
	cQuery += "  AND SF3.F3_LOJA     = SF2.F2_LOJA "
	cQuery += "  AND SF3.F3_ESPECIE  = SF2.F2_ESPECIE "
	cQuery += " WHERE SF2.D_E_L_E_T_ = '*' "
	cQuery += "  AND SF2.F2_ESPECIE  = 'SPED' "
	cQuery += "  AND SF2.F2_CHVNFE  <> '' "
	cQuery += "  AND SF2.F2_EMISSAO >= '" + cDtIni + "' "
	cQuery += "  AND SD2.D2_CF IN ('7504')"
	cQuery += "  AND SF3.F3_DTCANC  <> ' ' "
	cQuery += "  AND SF3.F3_CODRSEF  = '101' "
	cQuery += "  AND SF3.F3_XFCANC  <> 'S' "

	// Keyset (cursor)
	If !Empty(cCursor)
		cQuery += " AND SF2.R_E_C_N_O_ > " + _SqlSanitize(cCursor) + " "
	EndIf

	cQuery += " ORDER BY SF2.R_E_C_N_O_ "

	cQuery := ChangeQuery(cQuery)

	_Log("GET|QUERY_MAIN|page=" + cValToChar(nPage) + ;
		"|pageSize=" + cValToChar(nPageSize) + ;
		"|cursor=" + cCursor + ;
		"|dtIni=" + cDtIni)

	MPSysOpenQuery(cQuery, cAliasMain)

        /* ------------------------------------------------------------------ */
        /* Se NÃO tem cursor, aplicamos Page via DbSkip (compatibilidade).     */
        /* Obs: Se você usar sempre Cursor no middleware, fica mais performático. */
        /* ------------------------------------------------------------------ */
	If Empty(cCursor) .And. nStart > 0
		While (cAliasMain)->(!Eof()) .And. nSkipped < nStart
			(cAliasMain)->(DbSkip())
			nSkipped++
		EndDo
	EndIf

        /* ------------------------------------------------------------------ */
        /* Lê pageSize + 1 para determinar hasNext e nextCursor corretamente   */
        /* ------------------------------------------------------------------ */
	While (cAliasMain)->(!Eof()) .And. nRead < (nWanted + 1)

		oWrap   := JsonObject():New()
		oNf     := JsonObject():New()
		oItem   := JsonObject():New()

		// Se for o registro extra (pageSize+1), não adiciona em data
		If nRead >= nWanted
			lHasNext := .T.
			cNextCursor := cValToChar((cAliasMain)->REC_SF2) // cursor do "próximo" começo
			Exit
		EndIf



		// Chave: prioriza SF3
		If (cAliasMain)->(FieldPos("F3_CHVNFE")) > 0 .And. !Empty(AllTrim((cAliasMain)->F3_CHVNFE))
			cChRaw := (cAliasMain)->F3_CHVNFE
		Else
			cChRaw := (cAliasMain)->F2_CHVNFE
		EndIf
		cChave := _OnlyDigits(cChRaw)

		If Len(cChave) <> 44
			_Log("GET|WARN|CHAVE_INVALIDA|rec=" + cValToChar((cAliasMain)->REC_SF2) + ;
				"|doc=" + AllTrim((cAliasMain)->F2_DOC) + ;
				"|serie=" + AllTrim((cAliasMain)->F2_SERIE) + ;
				"|len=" + cValToChar(Len(cChave)))
		EndIf

		// SEFAZ: via SF3 quando existir; senão pendente
		cCodSef := IIf((cAliasMain)->(FieldPos("F3_CODRSEF")) > 0, AllTrim((cAliasMain)->F3_CODRSEF), "")
		cProt   := IIf((cAliasMain)->(FieldPos("F3_PROTOC")) > 0, AllTrim((cAliasMain)->F3_PROTOC), "")

		If Empty(cCodSef)
			cCodSef := "000"
		EndIf

		aMap := _MapSefazStatus(cCodSef)
		cSts := aMap[1]
		cMsg := aMap[2]

		oNf["Filial"]         := AllTrim((cAliasMain)->F2_FILIAL)
		oNf["NfChave"]        := cChave
		oNf["CodNf"]          := AllTrim((cAliasMain)->F2_DOC)
		oNf["NfSerie"]        := AllTrim((cAliasMain)->F2_SERIE)
		oNf["TipoNf"]         := "1"
		oNf["ValorTotal"]     := (cAliasMain)->F2_VALMERC
		oNf["DataEmissaoNf"]  := _ToIsoDate((cAliasMain)->F2_EMISSAO)
		oNf["NfDoc"]          := AllTrim((cAliasMain)->C5_PEDEXP)

		oNf["NfStatus"]       := cSts
		oNf["CodSefaz"]       := cCodSef
		oNf["MsgSefaz"]       := cMsg
		oNf["Protocolo"]      := cProt

		oNf["NfRecerenceErp"] := cValToChar((cAliasMain)->REC_SF2)
		oNf["tipo_venda"]     := "811"
		oNf["NrDocumento"]    := AllTrim((cAliasMain)->F2_DOC)
		oNf["PesoLiquido"]    := (cAliasMain)->F2_PLIQUI
		oNf["PesoBruto"]      := (cAliasMain)->F2_PBRUTO

		If !Empty(cEmpCorrente)
			oNf["CodEmitente"] := "F" + cEmpCorrente
		Else
			oNf["CodEmitente"] := "F" + SubStr((cAliasMain)->F2_FILIAL, 1, 2)
		EndIf

		oNf["CodDestinatario"]   := "C" + AllTrim((cAliasMain)->F2_CLIENTE)
		oNf["CodTransportadora"] := AllTrim((cAliasMain)->F2_TRANSP)
		oNf["CodCondPagto"]      := AllTrim((cAliasMain)->F2_COND)

		oNf["UnidadeMedQtd"] := "KG"
		oNf["QtdFardos"]     := 1

		oNf["Itens"]    := {}
		oNf["Parcelas"] := {}

            /* Itens (SD2) da NF */
		cAliasItens := GetNextAlias()
		cQueryItens := " SELECT D2_ITEM, D2_COD, D2_QUANT, D2_PRCVEN, D2_LOCAL, D2_UM, D2_PEDIDO, D2_ITEMPV "
		cQueryItens += " FROM " + RetSqlName("SD2") + " SD2 "
		cQueryItens += " WHERE SD2.D_E_L_E_T_ = '*' "
		cQueryItens += "   AND SD2.D2_FILIAL = '" + _SqlSanitize((cAliasMain)->F2_FILIAL) + "' "
		cQueryItens += "   AND SD2.D2_DOC    = '" + _SqlSanitize((cAliasMain)->F2_DOC)    + "' "
		cQueryItens += "   AND SD2.D2_SERIE  = '" + _SqlSanitize((cAliasMain)->F2_SERIE)  + "' "
		cQueryItens += " ORDER BY D2_ITEM "

		cQueryItens := ChangeQuery(cQueryItens)
		MPSysOpenQuery(cQueryItens, cAliasItens)

		While (cAliasItens)->(!Eof())

			oItem["NrRemessa"]        := "1"
			oItem["ItemRemessa"]      := AllTrim((cAliasItens)->D2_ITEM)
			oItem["Ordem"]            := AllTrim((cAliasItens)->D2_PEDIDO)
			oItem["ItemOrdem"]        := AllTrim((cAliasItens)->D2_ITEMPV)
			oItem["CodItem"]          := AllTrim((cAliasItens)->D2_COD)
			oItem["Quantidade"]       := (cAliasItens)->D2_QUANT
			oItem["ValorUnit"]        := (cAliasItens)->D2_PRCVEN
			oItem["LocalEstoque"]     := AllTrim((cAliasItens)->D2_LOCAL)
			oItem["UnidadeMedidaQtd"] := AllTrim((cAliasItens)->D2_UM)

			AAdd(oNf["Itens"], oItem)
			(cAliasItens)->(DbSkip())
		EndDo
		(cAliasItens)->(DbCloseArea())

		oWrap["NfCompra"] := oNf
		AAdd(aData, oWrap)

		// Cursor da última NF entregue nesta página
		cNextCursor := cValToChar((cAliasMain)->REC_SF2)

		nRead++
		(cAliasMain)->(DbSkip())
	EndDo

	(cAliasMain)->(DbCloseArea())

	// Se não encontrou registro extra, hasNext fica .F. e nextCursor deve ser "" (ou o último cursor entregue)
	// Para evitar reprocessamento no middleware:
	// - Se hasNext = .F., nextCursor = "" (fim)
	If !lHasNext
		cNextCursor := ""
	EndIf

	oResp["page"]      := nPage
	oResp["pageSize"]  := nPageSize
	oResp["count"]     := Len(aData)
	oResp["hasNext"]   := lHasNext
	oResp["nextCursor"]:= cNextCursor
	oResp["data"]      := aData

	Self:SetStatus(200)
	Self:SetResponse(oResp:ToJson())

	RECOVER USING oErr

	If Select(cAliasItens) > 0
		(cAliasItens)->(DbCloseArea())
	EndIf
	If Select(cAliasMain) > 0
		(cAliasMain)->(DbCloseArea())
	EndIf

	_Log("GET|ERROR|" + IIf(ValType(oErr)=="O", oErr:Description, "unknown"))
	_JsonError(Retorn, 500, "UNEXPECTED_ERROR", "Erro inesperado ao processar GET /v1/outbound-docs")
Return .F.

END SEQUENCE

Return .T.

/* -------------------------------------------------------------------------- */

/* PUT: Atualiza Nota De Entrada para evitar enviar novamente para o GET      */

/* -------------------------------------------------------------------------- */

WSMETHOD PUT 2 WSRESTFUL EDEXPCANC

Local cBody     := Self:GetContent()
Local oJsonBody := JsonObject():New()
Local oJsonResp := JsonObject():New()
Local cDoc      := ""
Local cQuery    := ""
Local cAliasSF3 := ""
Local lEncontrou:= .F.
// VariÃ¡veis para garantir formataÃ§Ã£o correta no SQL
Local cDocSQL   := ""

Self:SetContentType("application/json")

If oJsonBody:FromJson(cBody) != NIL
	Self:SetStatus(400)
	Self:SetResponse('{"error": "JSON invalido"}')
Return .F.
EndIf
// ValidaÃ§Ã£o de Payload
If !oJsonBody['NfCompra']:HasProperty("NfChave") .Or. !oJsonBody['NfCompra']:HasProperty("CodNf")
	Self:SetStatus(400)
	Self:SetResponse('{"error": "Campos obrigatorios: CodNf, NfChave"}')
Return .F.
EndIf
cDoc    := oJsonBody['NfCompra']['CodNf']
cChave  := oJsonBody['NfCompra']['NfChave']
cDocSQL   := PadL(AllTrim(cDoc), 9, "0")
ConOut("API_PUT_DEBUG: Buscando Nota Filial: " + " Doc: " + cDocSQL)

cAliasSF3 := GetNextAlias()
cQuery := " SELECT R_E_C_N_O_ AS RECNO"
cQuery += " FROM " + RetSqlName("SF3") + " SF3 "
cQuery += " WHERE F3_DTCANC <> ' '"
cQuery += " AND F3_CHVNFE = '" + cChave + "' "
cQuery += " AND F3_XFCANC  = ' '"
cQuery += " AND SF3.F3_CODRSEF  = '101' "
cQuery += " AND SF3.F3_CFO IN ('7504')"

MPSysOpenQuery(cQuery, cAliasSF3)

ConOut("API_PUT_DEBUG: Query SF3: " + cQuery)

If (cAliasSF3)->(Eof())
	ConOut("API_PUT_DEBUG: Query SF3 retornou vazio.")
	Self:SetStatus(404)
	Self:SetResponse('{"error": "Nota Fiscal nao encontrada na tabela SF3, verifique."}')
	(cAliasSF3)->(DbCloseArea())
	FreeObj(oJsonBody)
	FreeObj(oJsonResp)
Return .T.
EndIf

DbSelectArea("SF3")
SF3->(DbSetOrder(1))

While (cAliasSF3)->(!Eof())

	SF3->(DbGoTo((cAliasSF3)->RECNO))

	If RecLock("SF3", .F.)
		// Atualiza campos de controle
		SF3->F3_XFCANC := 'S' // Data Atual
		SF3->(MsUnlock())
		lEncontrou := .T.
		ConOut("API_PUT_DEBUG: SF3 Atualizado com sucesso.")
	Else
		ConOut("API_PUT_DEBUG: Falha no RecLock da SF3.")
	EndIf

	(cAliasSF3)->(DbSkip())
EndDo

(cAliasSF3)->(DbCloseArea())
If lEncontrou
	Self:SetStatus(200)
	oJsonResp['message'] := "Nota fiscal" + cDoc + " atualizada com sucesso."
	Self:SetResponse(oJsonResp:ToJson())
Else
	Self:SetStatus(404)
	Self:SetResponse('{"error": "NÃ£o foi possÃ­vel atualizar o status da nota."}')
EndIf
FreeObj(oJsonBody)
FreeObj(oJsonResp)
Return .T.

/* -------------------------------------------------------------------------- */
/* Helper: Formata Data ISO 8601                                              */
/* -------------------------------------------------------------------------- */
Static Function DateToISO(uParam, cTime)
	Local cRet  := ""
	Local cDate := ""

	// Verifica se Ã© Data mesmo ou String que veio do SQL
	If ValType(uParam) == "D"
		cDate := DtoS(uParam)
	ElseIf ValType(uParam) == "C"
		cDate := AllTrim(uParam)
	EndIf

	If Empty(cDate)
		Return ""
	EndIf

	If Empty(cTime)
		cTime := "00:00:00"
	EndIf

	cRet := Transform(cDate, "@R 9999-99-99") + "T" + cTime + ".000Z"
Return cRet

/* ========================================================================== */
/* Helpers                                                                    */
/* ========================================================================== */

Static Function _Log(cMsg)
	ConOut("WSAPIINT|" + cMsg)
Return Nil

Static Function _SqlSanitize(cValue)
	Local c := IIf(ValType(cValue) == "C", cValue, cValToChar(cValue))
Return StrTran(c, "'", "''")

Static Function _OnlyDigits(c)
	Local i, ch, out := ""
	c := IIf(ValType(c)=="C", c, cValToChar(c))
	For i := 1 To Len(c)
		ch := SubStr(c, i, 1)
		If ch >= "0" .And. ch <= "9"
			out += ch
		EndIf
	Next
Return out

Static Function _ToIsoDate(xDate)
	Local cRet := ""
	Do Case
	Case ValType(xDate) == "D"
		cRet := Transform(DtoS(xDate), "@R 9999-99-99")
	Case ValType(xDate) == "C" .And. Len(AllTrim(xDate)) >= 8
		// YYYYMMDD
		cRet := SubStr(xDate,1,4) + "-" + SubStr(xDate,5,2) + "-" + SubStr(xDate,7,2)
	Otherwise
		cRet := ""
	EndCase
Return cRet

Static Function _JsonError(Retorn, nHttp, cErrorCode, cMessage)
	Local oErro := JsonObject():New()
	oErro["statusCode"] := nHttp
	oErro["errorCode"]  := cErrorCode
	oErro["message"]    := cMessage

	Self:SetContentType("application/json")
	Self:SetStatus(nHttp)
	Self:SetResponse(o:ToJson())
Return Nil

Static Function _MapSefazStatus(cCod)
	// Retorna: { NfStatus, MsgSefaz }
	Local aRet := {"E", "Retorno SEFAZ: " + cCod}

	Do Case
	Case cCod == "100"
		aRet := {"A", "Autorizado"}
	Case cCod == "101"
		aRet := {"C", "Cancelado"}
	Case cCod == "102"
		aRet := {"I", "Inutilizado"}
	Case cCod == "302"
		aRet := {"D", "Denegado"}
	Case cCod == "000"
		aRet := {"P", "Pendente/sem retorno (verificar monitoramento)"}
	EndCase

Return aRet
