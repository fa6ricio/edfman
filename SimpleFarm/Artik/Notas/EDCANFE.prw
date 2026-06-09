#Include "Protheus.ch"
#Include "RestFul.ch"
#Include "TopConn.ch"

WSRESTFUL EDCANFE DESCRIPTION "API de Documentos de Entrada excluídos."

	WSDATA Page        AS INTEGER OPTIONAL
	WSDATA PageSize    AS INTEGER OPTIONAL
	WSDATA Cursor      AS STRING  OPTIONAL  // RECNO SF1 (keyset)

	WSMETHOD GET 1 DESCRIPTION "Lista NFs excluidas" WSSYNTAX "/v1/outbound-docs" PATH '/'
	WSMETHOD PUT 2 DESCRIPTION "Atualiza NFs excluidas" WSSYNTAX "/v1/outbound-docs" PATH '/'

END WSRESTFUL

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

Static Function _JsonError(Retorno, nHttp, cErrorCode, cMessage)
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

/* ========================================================================== */
/* GET                                                                         */
/* ========================================================================== */

	WSMETHOD GET 1 WSRESTFUL EDCANFE

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

	// Cursor (keyset por RECNO SF1)
	Local cCursor     := ''

	// Filtro data (>= 20250101)
	Local cDtIni      := "20260315"

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
	Local cChRaw  := ""
	Local cChave  := ""
	Local oItem := JsonObject():New()

	Private Retorno

	Self:SetContentType("application/json")

	BEGIN SEQUENCE

		cQuery := " SELECT DISTINCT "
		cQuery += "   SF1.R_E_C_N_O_  AS REC_SF1,SF1.F1_FILIAL,"
		cQuery += "   SF1.F1_DOC, SF1.F1_SERIE, SF1.F1_FORNECE, SF1.F1_LOJA, "
		cQuery += "   SF1.F1_EMISSAO, SF1.F1_VALMERC, SF1.F1_CHVNFE, "
		cQuery += "   SF1.F1_PLIQUI, SF1.F1_PBRUTO, SF1.F1_TRANSP, SF1.F1_COND, "
		cQuery += "   SD1.D1_NFORI,SD1.D1_SERIORI,SD1.D1_FORNECE,SD1.D1_LOJA"
		cQuery += " FROM " + RetSqlName("SF1") + " SF1 "
		cQuery += " INNER JOIN " + RetSqlName("SD1") + " SD1 "
		cQuery += "   ON SD1.D_E_L_E_T_ = '*' "
		cQuery += "  AND SD1.D1_FILIAL  = SF1.F1_FILIAL "
		cQuery += "  AND SD1.D1_DOC     = SF1.F1_DOC "
		cQuery += "  AND SD1.D1_SERIE   = SF1.F1_SERIE "
		cQuery += " WHERE SF1.D_E_L_E_T_ = '*' "
		cQuery += "  AND SF1.F1_ESPECIE  = 'SPED' "
		cQuery += "  AND SF1.F1_CHVNFE  <> '' "
		cQuery += "  AND SF1.F1_EMISSAO >= '" + cDtIni + "' "
		cQuery += "  AND SF1.F1_XPDINT = 'S'"
		cQuery += "  AND SF1.F1_XCANC  = '' "

		// Keyset (cursor)
		If !Empty(cCursor)
			cQuery += " AND SF1.R_E_C_N_O_ > " + _SqlSanitize(cCursor) + " "
		EndIf

		cQuery += " ORDER BY SF1.R_E_C_N_O_ "

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
				cNextCursor := cValToChar((cAliasMain)->REC_SF1) // cursor do "próximo" começo
				Exit
			EndIf

			cChRaw := (cAliasMain)->F1_CHVNFE
			cChave := _OnlyDigits(cChRaw)

			If Len(cChave) <> 44
				_Log("GET|WARN|CHAVE_INVALIDA|rec=" + cValToChar((cAliasMain)->REC_SF1) + ;
					"|doc=" + AllTrim((cAliasMain)->F1_DOC) + ;
					"|serie=" + AllTrim((cAliasMain)->F1_SERIE) + ;
					"|len=" + cValToChar(Len(cChave)))
			EndIf

			oNf["Filial"]         := AllTrim((cAliasMain)->F1_FILIAL)
			oNf["NfChave"]        := cChave
			oNf["CodNf"]          := AllTrim((cAliasMain)->F1_DOC)
			oNf["NfSerie"]        := AllTrim((cAliasMain)->F1_SERIE)
			oNf["TipoNf"]         := "1"
			oNf["ValorTotal"]     := (cAliasMain)->F1_VALMERC
			oNf["DataEmissaoNf"]  := _ToIsoDate((cAliasMain)->F1_EMISSAO)
			oNf["NfDoc"]          := AllTrim((cAliasMain)->F1_DOC)

			oNf["NfStatus"]       := ''
			oNf["CodSefaz"]       := '101'
			oNf["MsgSefaz"]       := ''
			oNf["Protocolo"]      := ''

			oNf["NfRecerenceErp"] := cValToChar((cAliasMain)->REC_SF1)
			oNf["tipo_venda"]     := ''
			oNf["NrDocumento"]    := AllTrim((cAliasMain)->F1_DOC)
			oNf["PesoLiquido"]    := (cAliasMain)->F1_PLIQUI
			oNf["PesoBruto"]      := (cAliasMain)->F1_PBRUTO

			If !Empty(cEmpCorrente)
				oNf["CodEmitente"] := "F" + cEmpCorrente
			Else
				oNf["CodEmitente"] := "F" + SubStr((cAliasMain)->F1_FILIAL, 1, 2)
			EndIf

			oNf["CodDestinatario"]   := "F" + AllTrim((cAliasMain)->F1_FORNECE)
			oNf["CodTransportadora"] := AllTrim((cAliasMain)->F1_TRANSP)
			oNf["CodCondPagto"]      := AllTrim((cAliasMain)->F1_COND)

			oNf["UnidadeMedQtd"] := "KG"
			oNf["QtdFardos"]     := 1

			oNf["Itens"]    := {}
			oNf["Parcelas"] := {}

            /* Itens (SD1) da NF */
			cAliasItens := GetNextAlias()
			cQueryItens := " SELECT D1_ITEM,D1_COD,D1_QUANT,D1_VUNIT,D1_LOCAL,D1_UM,D1_PEDIDO,D1_ITEMPC,D1_TES"
			cQueryItens += " FROM " + RetSqlName("SD1") + " SD1 "
			cQueryItens += " WHERE SD1.D_E_L_E_T_ = '*' "
			cQueryItens += " AND SD1.D1_FILIAL = '" + (cAliasMain)->F1_FILIAL + "' "
			cQueryItens += " AND SD1.D1_DOC    = '" + (cAliasMain)->F1_DOC    + "' "
			cQueryItens += " AND SD1.D1_SERIE  = '" + (cAliasMain)->F1_SERIE  + "' "
			cQueryItens += " ORDER BY D1_ITEM "

			cQueryItens := ChangeQuery(cQueryItens)
			MPSysOpenQuery(cQueryItens, cAliasItens)

			While (cAliasItens)->(!Eof())

				oItem["NrRemessa"]        := "1"
				oItem["ItemRemessa"]      := AllTrim((cAliasItens)->D1_ITEM)
				oItem["Ordem"]            := AllTrim((cAliasItens)->D1_PEDIDO)
				oItem["ItemOrdem"]        := AllTrim((cAliasItens)->D1_ITEMPC)
				oItem["CodItem"]          := AllTrim((cAliasItens)->D1_COD)
				oItem["Quantidade"]       := (cAliasItens)->D1_QUANT
				oItem["ValorUnit"]        := (cAliasItens)->D1_VUNIT
				oItem["LocalEstoque"]     := AllTrim((cAliasItens)->D1_LOCAL)
				oItem["UnidadeMedidaQtd"] := AllTrim((cAliasItens)->D1_UM)

				AAdd(oNf["Itens"], oItem)
				(cAliasItens)->(DbSkip())
			EndDo
			(cAliasItens)->(DbCloseArea())

			oWrap["NfCompra"] := oNf
			AAdd(aData, oWrap)

			// Cursor da última NF entregue nesta página
			cNextCursor := cValToChar((cAliasMain)->REC_SF1)

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
		_JsonError(Self, 500, "UNEXPECTED_ERROR", "Erro inesperado ao processar GET /v1/outbound-docs")
		Return .F.

	END SEQUENCE

Return .T.

/* -------------------------------------------------------------------------- */

/* PUT: Atualiza Pedido de Venda (SC5) vinculado à Nota                       */

/* -------------------------------------------------------------------------- */

	WSMETHOD PUT 2 WSRESTFUL EDCANFE

	Local cBody     := Self:GetContent()
	Local oJsonBody := JsonObject():New()
	Local oJsonResp := JsonObject():New()
	Local cDoc      := ""
	Local cQuery    := ""
	Local cAliasSF1 := ""
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

	cAliasSF1 := GetNextAlias()
	cQuery := " SELECT R_E_C_N_O_ AS RECNO"
	cQuery += " FROM " + RetSqlName("SF1") + " SF1 "
	cQuery += " WHERE F1_XCANC = ''"
	cQuery += " AND F1_CHVNFE = '" + cChave + "' "
	cQuery += " AND D_E_L_E_T_ = '*'"

	MPSysOpenQuery(cQuery, cAliasSF1)

	ConOut("API_PUT_DEBUG: Query SF1: " + cQuery)

	If (cAliasSF1)->(Eof())
		ConOut("API_PUT_DEBUG: Query SF1 retornou vazio.")
		Self:SetStatus(404)
		Self:SetResponse('{"error": "Nota Fiscal nao encontrada na tabela SF1, verifique."}')
		(cAliasSF1)->(DbCloseArea())
		FreeObj(oJsonBody)
		FreeObj(oJsonResp)
		Return .T.
	EndIf

	DbSelectArea("SF1")
	SF1->(DbSetOrder(1))

	While (cAliasSF1)->(!Eof())

		SF1->(DbGoTo((cAliasSF1)->RECNO))

		If RecLock("SF1", .F.)
			// Atualiza campos de controle
			SF1->F1_XCANC := 'S' // Data Atual
			SF1->(MsUnlock())
			lEncontrou := .T.
			ConOut("API_PUT_DEBUG: SF1 Atualizado com sucesso.")
		Else
			ConOut("API_PUT_DEBUG: Falha no RecLock da SF1.")
		EndIf
		(cAliasSF1)->(DbSkip())
	EndDo

	(cAliasSF1)->(DbCloseArea())
	If lEncontrou
		Self:SetStatus(200)
		oJsonResp['message'] := "Nota fiscal " + cDoc + " atualizada com sucesso."
		Self:SetResponse(oJsonResp:ToJson())
	Else
		Self:SetStatus(404)
		Self:SetResponse('{"error": "Não foi possí­vel atualizar o status da nota."}')
	EndIf
	FreeObj(oJsonBody)
	FreeObj(oJsonResp)
Return .T.
