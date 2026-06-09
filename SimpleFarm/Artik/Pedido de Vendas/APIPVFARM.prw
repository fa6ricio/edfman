#Include "Protheus.ch"
#Include "TOTVS.ch"
#Include "RESTFUL.CH"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} APIFARM
API de Pedido de Vendas - Integração SimpleFarm
@author Bruno Mendes
@since 05/12/2025
@version 13.26 (Ajuste Campo Memo C5_XMENNOT)
/*/

WSRESTFUL APIFARM DESCRIPTION "API de Pedidos Layout Farm (Final)"
	WsMethod POST INCLUIR Description 'Incluir Pedido' WSSYNTAX "/api/v1/farm/orders"
END WSRESTFUL

/*/{Protheus.doc} POST INCLUIR
Método de inclusão de pedidos
/*/
WSMETHOD POST INCLUIR WsService APIFARM
	Local cBody        := self:GetContent()
	Local oJsonRaw     := JsonObject():New()
	Local aPedidos     := {}
	Local aRetBatch    := {}
	Local aArea        := GetArea()
	Local nY, jOrder, jRet
	Local lHasError    := .F.
	Local xRetJson

	// Variáveis privadas necessárias para o ExecAuto
	Private lMsErroAuto    := .F.
	Private lMsHelpAuto    := .T.
	Private lAutoErrNoFile := .T.

	self:SetContentType("application/json")
	cBody := DecodeUtf8(cBody)

	If Empty(cBody)
		SetRestFault(400, 'Body vazio')
		RestArea(aArea)
		Return .F.
	EndIf

	xRetJson := oJsonRaw:FromJson(cBody)

	If ValType(xRetJson) == 'U'
		If oJsonRaw:HasProperty("data") .And. ValType(oJsonRaw["data"]) == "A"
			aPedidos := oJsonRaw["data"]
		Else
			SetRestFault(400, 'JSON invalido. Estrutura esperada: { "data": [...] }')
			RestArea(aArea)
			Return .F.
		EndIf

		For nY := 1 To Len(aPedidos)
			jOrder := aPedidos[nY]
			jRet   := ProcessaPedido(jOrder)

			If jRet['status'] == 'error'
				lHasError := .T.
			EndIf

			aAdd(aRetBatch, jRet)
		Next nY

		self:SetResponse(FWJsonSerialize(aRetBatch))

		If lHasError
			self:SetStatus(400)
		Else
			self:SetStatus(201)
		EndIf
	Else
		SetRestFault(400, 'Erro no Parse do JSON')
		Return .F.
	EndIf

	RestArea(aArea)
Return .T.

/*/{Protheus.doc} ProcessaPedido
Orquestra a troca de filial, validação e gravação
/*/
Static Function ProcessaPedido(jOrder)
	Local oResponse    := JsonObject():New()
	Local aValidacao   := {}
	Local cFilialJson  := ""

	// --- CORREÇÃO: TROCA DE AMBIENTE ---
	If jOrder:HasProperty("filial")
		cFilialJson := jOrder['filial']

		// Se a filial enviada for válida e diferente da atual, troca o ambiente.
		If !Empty(cFilialJson) .And. cFilialJson != cFilial
			RpcSetEnv("01", cFilialJson)
		EndIf
	EndIf
	// ------------------------------------

	ConOut(">>> INICIO PEDIDO - Filial Atual: " + cFilial + " | Cliente: " + jOrder['codCli'])

	aValidacao := ValidarRegras(jOrder)

	If !aValidacao[1]
		oResponse['status']  := "error"
		oResponse['message'] := "Validacao Falhou"
		oResponse['errors']  := aValidacao[2]
		Return oResponse
	EndIf

Return GravarPedido(jOrder)

/*/{Protheus.doc} ValidarRegras
Valida integridade dos cadastros
/*/
Static Function ValidarRegras(jOrder)
	Local lRet      := .T.
	Local aErros    := {}
	Local cCondPag  := jOrder['condPag']
	Local aItens    := jOrder['itens']
	Local nX        := 0
	Local cProd, cTes
	Local cCnpjAux  := ""
	Local aAux      := {}

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	// 1. Cliente Principal
	If jOrder:HasProperty("codCli")
		If !FmGetCli(jOrder['codCli'], jOrder['loja'], .F.)
			If !Eof() .And. SA1->A1_MSBLQL == "1"
				lRet := .F.
				aAdd(aErros, "Cliente Principal (" + jOrder['codCli'] + ") bloqueado.")
			EndIf
		EndIf
	EndIf

	// 2. Local de Retirada
	If jOrder:HasProperty("cnpjRetirada") .And. !Empty(jOrder['cnpjRetirada'])
		cCnpjAux := FmClean(jOrder['cnpjRetirada'])
		aAux := FmGetCGC(cCnpjAux)

		If Empty(aAux)
			lRet := .F.
			aAdd(aErros, "Local de Retirada nao encontrado para o CNPJ: " + jOrder['cnpjRetirada'])
		Else
			SA1->(MsSeek(xFilial("SA1") + aAux[1] + aAux[2]))
			If SA1->A1_MSBLQL == "1"
				lRet := .F.
				aAdd(aErros, "Cliente de Retirada (" + aAux[1] + ") encontra-se bloqueado.")
			EndIf
		EndIf
	EndIf

	// 3. Local de Entrega
	If jOrder:HasProperty("cnpjEntrega") .And. !Empty(jOrder['cnpjEntrega'])
		cCnpjAux := FmClean(jOrder['cnpjEntrega'])
		aAux := FmGetCGC(cCnpjAux)

		If Empty(aAux)
			lRet := .F.
			aAdd(aErros, "Local de Entrega nao encontrado para o CNPJ: " + jOrder['cnpjEntrega'])
		Else
			SA1->(MsSeek(xFilial("SA1") + aAux[1] + aAux[2]))
			If SA1->A1_MSBLQL == "1"
				lRet := .F.
				aAdd(aErros, "Cliente de Entrega (" + aAux[1] + ") encontra-se bloqueado.")
			EndIf
		EndIf
	EndIf

	// 4. Transportadora
	If jOrder:HasProperty("transportadoraCnpjCpf") .And. !Empty(jOrder['transportadoraCnpjCpf'])
		cCnpjAux := FmClean(jOrder['transportadoraCnpjCpf'])
		If Empty(FmGetTrp(cCnpjAux))
			lRet := .F.
			aAdd(aErros, "Transportadora nao encontrada para o CNPJ: " + jOrder['transportadoraCnpjCpf'])
		EndIf
	EndIf

	// 5. Condição de Pagamento e Itens
	DbSelectArea("SE4"); SE4->(DbSetOrder(1))
	If !SE4->(MsSeek(xFilial("SE4") + cCondPag))
		lRet := .F.; aAdd(aErros, "Condicao Pagamento " + cCondPag + " nao existe.")
	EndIf

	If ValType(aItens) != "A" .Or. Len(aItens) == 0
		lRet := .F.; aAdd(aErros, "Lista de itens vazia.")
	Else
		For nX := 1 To Len(aItens)
			cProd := aItens[nX]['codProduto']
			cTes  := aItens[nX]['tipoSaida']

			DbSelectArea("SB1"); SB1->(DbSetOrder(1))
			If !SB1->(MsSeek(xFilial("SB1") + cProd))
				lRet := .F.; aAdd(aErros, "Item " + cValToChar(nX) + ": Produto " + cProd + " nao existe.")
			ElseIf SB1->B1_MSBLQL == "1"
				lRet := .F.; aAdd(aErros, "Item " + cValToChar(nX) + ": Produto " + cProd + " bloqueado.")
			EndIf

			DbSelectArea("SF4"); SF4->(DbSetOrder(1))
			If !SF4->(MsSeek(xFilial("SF4") + cTes))
				lRet := .F.; aAdd(aErros, "Item " + cValToChar(nX) + ": TES " + cTes + " invalida.")
			ElseIf SF4->F4_MSBLQL == "1"
				lRet := .F.; aAdd(aErros, "Item " + cValToChar(nX) + ": TES " + cTes + " bloqueada.")
			EndIf
		Next
	EndIf

Return {lRet, aErros}

/*/{Protheus.doc} GravarPedido
Prepara arrays e executa MATA410
AJUSTADO: Gravação do campo Memo C5_XMENNOT via RecLock
/*/
Static Function GravarPedido(jOrder)
	Local oResponse    := JsonObject():New()
	Local cCnpjTransp  := ""
	Local cCodTransp   := ""

	Local aCliMain     := {}
	Local aCliRet      := {}
	Local aCliRem      := {}

	Local aUpdRet      := {}
	Local aUpdRem      := {}

	Local aCab         := {}
	Local aItens       := {}
	Local aLinha       := {}
	Local aItensJson   := {}
	Local nX           := 0
	Local dEmissao     := dDataBase
	Local cCampoData   := ""
	Local cObsNota     := ""
	Local cInfItem     := ""
	Local cNumPed      := ""
	Local aErro        := {}
	Local cErro        := ""
	Local i            := 0
	Local cLojFix      := ""

	// Variável para armazenar o conteúdo completo do MEMO
	Local cMemoNf      := ""

	// --- IDENTIFICAÇÃO DOS PARCEIROS ---

	aCliMain := FmGetCli(jOrder['codCli'], jOrder['loja'], .T.)
	If Empty(aCliMain)
		oResponse['status']  := "error"
		oResponse['message'] := "Cliente Principal nao encontrado"
		Return oResponse
	EndIf

	// Busca Retirada
	If jOrder:HasProperty("cnpjRetirada") .And. !Empty(jOrder['cnpjRetirada'])
		aCliRet := FmGetCGC(FmClean(jOrder['cnpjRetirada']))
		If Empty(aCliRet)
			oResponse['status'] := "error"; oResponse['message'] := "Erro Retirada"; Return oResponse
		EndIf
	EndIf

	// Busca Entrega
	If jOrder:HasProperty("cnpjEntrega") .And. !Empty(jOrder['cnpjEntrega'])
		aCliRem := FmGetCGC(FmClean(jOrder['cnpjEntrega']))
		If Empty(aCliRem)
			oResponse['status'] := "error"; oResponse['message'] := "Erro Entrega"; Return oResponse
		EndIf
	EndIf

	// Busca Transportadora
	If jOrder:HasProperty("transportadoraCnpjCpf") .And. !Empty(jOrder['transportadoraCnpjCpf'])
		cCnpjTransp := FmClean(jOrder['transportadoraCnpjCpf'])
		cCodTransp  := FmGetTrp(cCnpjTransp)
	EndIf

	// --- CAPTURA A MENSAGEM LONGA PARA O MEMO ---
	If jOrder:HasProperty("msgNf")
		cMemoNf := jOrder['msgNf']
	EndIf

	// --- MONTAGEM DO CABEÇALHO ---

	If jOrder:HasProperty("dtEmissao")
		cCampoData := jOrder['dtEmissao']
		If Len(cCampoData) >= 10; dEmissao := SToD(StrTran(SubStr(cCampoData, 1, 10), "-", "")); EndIf
		EndIf

		aAdd(aCab, {"C5_TIPO"     , jOrder['tipo']     , Nil})
		aAdd(aCab, {"C5_CLIENTE"  , aCliMain[1]        , Nil})
		aAdd(aCab, {"C5_TPFRETE"  , 'C'                , Nil})
		aAdd(aCab, {"C5_LOJACLI"  , aCliMain[2]        , Nil})
		aAdd(aCab, {"C5_CONDPAG"  , jOrder['condPag']  , Nil})
		aAdd(aCab, {"C5_EMISSAO"  , dEmissao           , Nil})
		aAdd(aCab, {"C5_FECENT"   , DaySum(dEmissao,7) , Nil})
		aAdd(aCab, {"C5_MOEDA"    , jOrder['moeda']    , Nil})

		// PREPARA DADOS RETIRADA (Update Posterior)
		If !Empty(aCliRet)
			cLojFix := aCliRet[2]
			If Empty(cLojFix) .Or. AllTrim(cLojFix) == ""; cLojFix := "01"; EndIf
				cLojFix := PadL(AllTrim(cLojFix), 2, "0")
				aUpdRet := {aCliRet[1], cLojFix}
			EndIf

			// PREPARA DADOS ENTREGA (Update Posterior)
			If !Empty(aCliRem)
				cLojFix := aCliRem[2]
				If Empty(cLojFix) .Or. AllTrim(cLojFix) == ""; cLojFix := "01"; EndIf
					cLojFix := PadL(AllTrim(cLojFix), 2, "0")
					aUpdRem := {aCliRem[1], cLojFix}
				EndIf

				If !Empty(cCodTransp); aAdd(aCab, {"C5_TRANSP", cCodTransp, Nil}); EndIf

					If jOrder:HasProperty("fretePorConta");     aAdd(aCab, {"C5_TPFRETE", SubStr(jOrder['fretePorConta'],1,1), Nil}); EndIf

						// Mantemos no Array para o ExecAuto, mas a gravação final confiável será via RecLock abaixo
						If jOrder:HasProperty("pesoBrutoTotal");    aAdd(aCab, {"C5_PBRUTO", jOrder['pesoBrutoTotal'], Nil}); EndIf
							If jOrder:HasProperty("pesoLiquidoTotal");  aAdd(aCab, {"C5_PESOL", jOrder['pesoLiquidoTotal'], Nil}); EndIf

								If jOrder:HasProperty("volumesQuantidade"); aAdd(aCab, {"C5_VOLUME1", jOrder['volumesQuantidade'], Nil}); EndIf
									If jOrder:HasProperty("volumesEspecie");    aAdd(aCab, {"C5_ESPECI1", SubStr(jOrder['volumesEspecie'], 1, 10), Nil}); EndIf

										// --- MONTAGEM DO RESUMO LOGÍSTICO (C5_MENNOTA) ---
										// Apenas dados importantes para visualização em tela, limitado a 254 caracteres.
										If jOrder:HasProperty("placaVeiculo") .And. !Empty(jOrder['placaVeiculo'])
											cObsNota += "Placa: " + jOrder['placaVeiculo'] + ". "
										EndIf

										cObsNota += CRLF + "ENT: " + AllTrim(jOrder['entregaNome']) + " " + AllTrim(jOrder['entregaMunicipio']) + "/" + AllTrim(jOrder['entregaUf'])
										cObsNota += CRLF + "RET: " + AllTrim(jOrder['retiradaNome']) + " " + AllTrim(jOrder['retiradaMunicipio']) + "/" + AllTrim(jOrder['retiradaUf'])

										aAdd(aCab, {"C5_MENNOTA", SubStr(cObsNota, 1, 254), Nil})

										// Itens
										aItensJson := jOrder['itens']
										For nX := 1 To Len(aItensJson)
											aLinha   := {}
											cInfItem := ""
											aAdd(aLinha, {"C6_PRODUTO", aItensJson[nX]['codProduto'], Nil})
											aAdd(aLinha, {"C6_QTDVEN" , aItensJson[nX]['qtd'], Nil})
											aAdd(aLinha, {"C6_PRCVEN" , aItensJson[nX]['precoUn'], Nil})
											aAdd(aLinha, {"C6_VALOR"  , aItensJson[nX]['total'], Nil})
											aAdd(aLinha, {"C6_TES"    , aItensJson[nX]['tipoSaida'], Nil})
											aAdd(aLinha, {"C6_LOCAL"  , aItensJson[nX]['codLoc'], Nil})
											aAdd(aLinha, {"C6_UM"     , aItensJson[nX]['unMedida'], Nil})
											aAdd(aLinha, {"C6_XPESOBR", aItensJson[nX]['pesBruto'], Nil})
											aAdd(aLinha, {"C6_XQTDEM1", aItensJson[nX]['volume'], Nil})
											If !Empty(aItensJson[nX]['lote']);     aAdd(aLinha, {"C6_LOTECTL", aItensJson[nX]['lote'], Nil}); EndIf
												If aItensJson[nX]:HasProperty("qtdFardos") .And. aItensJson[nX]['qtdFardos'] > 0
													cInfItem += "Vol: " + cValToChar(aItensJson[nX]['qtdFardos']) + ". "
												EndIf
												If !Empty(cInfItem); aAdd(aLinha, {"C6_INFAD", SubStr(cInfItem, 1, 80), Nil}); EndIf
													aAdd(aItens, aLinha)
												Next

												ConOut("DEBUG: CHAMANDO EXEC AUTO (SEM DADOS DE ENTREGA/RETIRADA E MEMO COMPLETO)")
												lMsErroAuto := .F.
												MSExecAuto({|x,y,z| MATA410(x,y,z)}, aCab, aItens, 3)

												If lMsErroAuto
													aErro := GetAutoGRLog()
													cErro := ""
													For i := 1 To Len(aErro)
														cErro += aErro[i] + " | "
													Next i

													oResponse['status']    := "error"
													oResponse['message']   := cErro
													oResponse['codCliExt'] := jOrder['codCli']
												Else
													cNumPed := SC5->C5_NUM

													// --- SUCESSO: UPDATE DINÂMICO E GRAVAÇÃO DO MEMO ---
													DbSelectArea("SC5")
													SC5->(DbSetOrder(1))
													If SC5->(MsSeek(xFilial("SC5") + cNumPed))
														RecLock("SC5", .F.)

														// 1. Atualiza Dados de Entrega / Retirada
														If !Empty(aUpdRet)
															If SC5->(FieldPos("C5_CLIRET")) > 0; SC5->C5_CLIRET := aUpdRet[1]; EndIf
																If SC5->(FieldPos("C5_LOJARET")) > 0
																	SC5->C5_LOJARET := aUpdRet[2]
																ElseIf SC5->(FieldPos("C5_LOJRET")) > 0
																	SC5->C5_LOJRET := aUpdRet[2]
																EndIf
															EndIf

															If !Empty(aUpdRem)
																If SC5->(FieldPos("C5_CLIREM")) > 0; SC5->C5_CLIREM := aUpdRem[1]; EndIf

																	If SC5->(FieldPos("C5_LOJAREM")) > 0
																		SC5->C5_LOJAREM := aUpdRem[2]
																	ElseIf SC5->(FieldPos("C5_LOJREM")) > 0
																		SC5->C5_LOJREM := aUpdRem[2]
																	ElseIf SC5->(FieldPos("C5_LOJAENT")) > 0
																		SC5->C5_LOJAENT := aUpdRem[2]
																	EndIf
																EndIf

																// 2. Forçar Pesos
																If jOrder:HasProperty("pesoBrutoTotal");    SC5->C5_PBRUTO := jOrder['pesoBrutoTotal']; EndIf
																	If jOrder:HasProperty("pesoLiquidoTotal");  SC5->C5_PESOL  := jOrder['pesoLiquidoTotal']; EndIf

																		// 3. Forçar Volumes
																		If jOrder:HasProperty("volumesQuantidade"); SC5->C5_VOLUME1 := jOrder['volumesQuantidade']; EndIf
																			If jOrder:HasProperty("volumesEspecie");    SC5->C5_ESPECI1 := SubStr(jOrder['volumesEspecie'], 1, 10); EndIf

																				// 4. GRAVAÇÃO DO MEMO (C5_XMENNOT)
																				// Aqui gravamos o conteúdo completo do JSON, sem truncar.
																				If !Empty(cMemoNf) .And. SC5->(FieldPos("C5_XMENNOT")) > 0
																					SC5->C5_XMENNOT := cMemoNf
																				EndIf
																				SC5->C5_CLIENT  := SC5->C5_CLIREM
																				SC5->C5_LOJAENT := SC5->C5_LOJAREM
																				SC5->C5_TPFRETE := 'C'
																				SC5->(MsUnlock())
																			EndIf

																			oResponse['status']     := "success"
																			oResponse['pedido']     := cNumPed
																			oResponse['codCliExt']  := jOrder['codCli']
																			oResponse['filial']     := cFilial
																			ConOut("DEBUG: SUCESSO FINAL: " + cNumPed)
																		EndIf

																		Return oResponse

/*/{Protheus.doc} FmGetCli
Busca Híbrida Segura
/*/
Static Function FmGetCli(cCodInput, cLojaInput, lReturnData)
	Local aRet      := {}
	Local cQuery    := ""
	Local cAliasQry := GetNextAlias()
	Local lHasFld   := .F.

	If Empty(cCodInput); Return IIf(lReturnData, {}, .T.); EndIf
		If Empty(cLojaInput); cLojaInput := "01"; EndIf

			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))

			If SA1->(MsSeek(xFilial("SA1") + cCodInput + cLojaInput))
				If lReturnData; Return {SA1->A1_COD, SA1->A1_LOJA}; Else; Return .T.; EndIf
				EndIf

				lHasFld := SA1->(FieldPos("A1_XCODFAR")) > 0

				If lHasFld
					cQuery := "SELECT A1_COD, A1_LOJA FROM " + RetSqlName("SA1") + " "
					cQuery += "WHERE A1_XCODFAR = '" + cCodInput + "' AND D_E_L_E_T_ = ' ' "
					cQuery := ChangeQuery(cQuery)

					DbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAliasQry, .F., .T.)
					If !(cAliasQry)->(EoF())
						aRet := {AllTrim((cAliasQry)->A1_COD), AllTrim((cAliasQry)->A1_LOJA)}
						If !lReturnData; SA1->(MsSeek(xFilial("SA1") + aRet[1] + aRet[2])); EndIf
						EndIf
						(cAliasQry)->(DbCloseArea())
					EndIf

					Return IIf(lReturnData, aRet, !Empty(aRet))

/*/{Protheus.doc} FmGetCGC
Busca Cliente por CNPJ
/*/
Static Function FmGetCGC(cCGC)
	Local aRet      := {}
	Local cQuery    := ""
	Local cAliasQry := GetNextAlias()

	If Empty(cCGC); Return {}; EndIf

		cQuery := "SELECT A1_COD, A1_LOJA FROM " + RetSqlName("SA1") + " "
		cQuery += "WHERE A1_CGC = '" + cCGC + "' AND D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)

		DbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAliasQry, .F., .T.)
		If !(cAliasQry)->(EoF())
			aRet := {AllTrim((cAliasQry)->A1_COD), AllTrim((cAliasQry)->A1_LOJA)}
		EndIf
		(cAliasQry)->(DbCloseArea())

		Return aRet

/*/{Protheus.doc} FmGetTrp
Busca Transportadora
/*/
Static Function FmGetTrp(cCgc)
	Local cRet      := ""
	Local cQry      := ""
	Local cAliasTRP := GetNextAlias()

	If Empty(cCgc); Return ""; EndIf

		cQry := "SELECT A4_COD FROM " + RetSqlName("SA4") + " WHERE A4_CGC = '" + cCgc + "' AND D_E_L_E_T_ = ' ' "
		cQry := ChangeQuery(cQry)

		DbUseArea(.T., "TOPCONN", TCGenQry(,, cQry), cAliasTRP, .F., .T.)
		If !(cAliasTRP)->(EoF())
			cRet := AllTrim((cAliasTRP)->A4_COD)
			SA4->(DbSetOrder(1)); SA4->(MsSeek(xFilial("SA4") + cRet))
		EndIf
		(cAliasTRP)->(DbCloseArea())
		Return cRet

Static Function FmClean(cStr)
	cStr := StrTran(cStr, ".", "")
	cStr := StrTran(cStr, "-", "")
	cStr := StrTran(cStr, "/", "")
Return cStr
