// BIBLIOTECAS NECESSÁRIAS
#Include "TOTVS.ch"

/*/{Protheus.doc} JMFWS001
@description 	API de integração
@author			André Luiz Monteiro
@since			10/11/2025
@version			12.1.2410
/*/

// FUNÇÃO PARA CONSUMO DO SERVIÇO REST
User Function PUTEFENT()
	Local cURI      := "https://api-ipaas.totvs.app/ipaas/api" // URI DO SERVIÇO REST
	Local cResource := "/v1/integrations/6357cf03-f8de-4c72-8ecc-0f132524964c/api-key/68cb6602-1d1d-41e5-b728-43e4208e4d62"
	Local oRest     := FwRest():New(cURI)                            // CLIENTE PARA CONSUMO REST
	Local aHeader   := {}
	Local cJson

	// PREENCHE CABEÇALHO DA REQUISIÇÃO
	AAdd(aHeader, "Content-Type: application/json; charset=UTF-8")
	AAdd(aHeader, "Accept: application/json")

	// INFORMA O RECURSO
	oRest:SetPath(cResource)
	cJson := GetJson()
	oRest:SetPostParams(cJson)

	if !Empty(cJson)
		// REALIZA O MÉTODO POST E VALIDA O RETORNO
		If (oRest:Post(aHeader))
			ConOut("POST: " + oRest:GetResult())
		Else
			ConOut("POST: " + oRest:GetLastError())
		EndIf
	Endif
Return (NIL)

// CRIA O JSON QUE SERÁ ENVIADO NO CORPO (BODY) DA REQUISIÇÃO
Static Function GetJson()
	Local cNewSD1 := GetNextAlias()
	Local bObject := {|| JsonObject():New()}
	Local oJson   := Eval(bObject)
	Local oItem
	Local aTemp := {}
	Local cEmissao := ALLTRIM(SubStr(Dtos(SF1->F1_EMISSAO), 1, 4) + "-" + SubStr(Dtos(SF1->F1_EMISSAO), 5, 2) + "-" + SubStr(Dtos(SF1->F1_EMISSAO), 7, 2))
	Local nCount := 1
	Local nX

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial('SA2') + SF1->F1_FORNECE + SF1->F1_LOJA))

	DbSelectArea("SA4")
	SA4->(DbSetOrder(1))
	SA4->(DbSeek(xFilial('SA4') + SF1->F1_TRANSP))

	BeginSQL Alias cNewSD1
         select
		    SD1.D1_PEDIDO, 
            SD1.D1_ITEMPC, 
			SD1.D1_ITEM,
            SD1.D1_COD, 
            SD1.D1_QUANT,
            SD1.D1_VUNIT,
            SD1.D1_LOCAL,
            SD1.D1_UM,
			SD1.D1_TES
           from
            %table:SD1% SD1	 
			/*inner join
			   %table:SC7% SC7
			   ON SC7.%notDel%
			   AND SC7.C7_NUM = SD1.D1_PEDIDO
			   AND SC7.C7_ITEM = SD1.D1_ITEMPC
			   AND SC7.C7_FORNECE = SD1.D1_FORNECE
			   AND SC7.C7_LOJA = SD1.D1_LOJA
			   AND SC7.C7_FILIAL = SD1.D1_FILIAL */             
           where
			SD1.%notDel%
			AND SD1.D1_FILIAL = %exp:(SF1->F1_FILIAL)%
			AND SD1.D1_DOC = %exp:(SF1->F1_DOC)% 
			AND SD1.D1_SERIE = %exp:(SF1->F1_SERIE)% 
			AND SD1.D1_FORNECE = %exp:(SF1->F1_FORNECE)% 
			AND SD1.D1_LOJA = %exp:(SF1->F1_LOJA)% 
			//AND SC7.C7_XCONSI <> ''
	EndSQL

	(cNewSD1)->(dbGoTop())
	While !(cNewSD1)->(Eof())

		if nCount = 1
			oJson["NfFilialDest"]                       := SF1->F1_FILIAL
			oJson["NfChave"]                            := SF1->F1_CHVNFE
			oJson["CodNf"]                              := SF1->F1_DOC
			oJson["NfSerie"]                            := SF1->F1_SERIE
			oJson["ValorTotal"]                         := SF1->F1_VALMERC
			oJson["DataEmissaoNf"]                      := cEmissao
			oJson["NfStatus"]                           := SF1->F1_STATUS
			oJson["NfRecerenceErp"]                     := SF1->(Recno())
			oJson["PesoLiquido"]                        := SF1->F1_PLIQUI
			oJson["PesoBruto"]                          := SF1->F1_PBRUTO
			oJson["Placa"]                              := SF1->F1_PLACA
			oJson["CodFar"]                             := SA4->A4_XCODFAR
			oJson["CodEmitente"]                        := SA2->A2_XCODFAR
			oJson["Especie"]                         	:= SF1->F1_ESPECI1
			oJson["Volume"]                         	:= SF1->F1_VOLUME1
			oJson["CodCondPagto"]                       := SF1->F1_COND
			oJson["Itens"]                              := {}
		Endif
		oItem  := Eval(bObject)
		oItem["Ordem"]                     := (cNewSD1)->D1_PEDIDO
		oItem["Tes"]                       := (cNewSD1)->D1_TES
		oItem["ItemOrdem"]                 := (cNewSD1)->D1_ITEM
		oItem["CodItem"]                   := (cNewSD1)->D1_COD
		oItem["Quantidade"]                := (cNewSD1)->D1_QUANT
		oItem["ValorUnit"]                 := (cNewSD1)->D1_VUNIT
		oItem["LocalEstoque"]              := (cNewSD1)->D1_LOCAL
		oItem["UnidadeMedidaQtd"]          := (cNewSD1)->D1_UM
		AAdd(aTemp, oItem)
		(cNewSD1)->(DbSkip())
		nCount++
	End

	For nX := 1 to Len(aTemp)
		AAdd(oJson["Itens"], aTemp[nX])
	Next nX

	(cNewSD1)->(DbCloseArea())

Return (oJson:ToJson())
