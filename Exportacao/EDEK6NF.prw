#include "protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "EEC.CH"
#INCLUDE "EECNF400.CH"
#Include "TOPCONN.CH"

User Function EDEK6NF()
	Local aArea     := GetArea()
	Local aAreaEE9  := EE9->(GetArea())
	Local lRet

	EE9->(DbSetOrder(2))
	EE9->(Dbseek(xFilial("EE9")+EEM->EEM_PREEMB)) //EE9_FILIAL+EE9_PREEMB

	if Posicione("SB1",1,xFilial("SB1")+AllTrim(EE9->EE9_COD_I),"B1_XCONTCT") == "2" //2-Não
		lRet := SK6SD2F3()
	else
		lRet := NF400SD2F3()
	endif

	RestArea(aAreaEE9)
	RestArea(aArea)

Return (lRet)


Static Function SK6SD2F3()
	Local nCont
	Local oDlg, oBrowse
	Local aDados:= {}
	Local aSeek := {}
	Local bOk:= {|| If( ValOkF3(aCampos, aDados[oBrowse:nAt]) , ( GrvDados(aCampos, aDados[oBrowse:nAt]), lRet:= .T.,  oDlg:End() ) , ) }
	Local bCancel:= {|| lRet:= .F., lExecConPad1:= .T., oDlg:End()}
	Local lRet:= .T.
	Local oModel
	Local oModelEES
	Private cTitulo:= STR0053 //"Itens de Notas Fiscais de Saída para formação de lote"
	Private aCampos:= {}
	Private aFilter:= {}
	Private aSaldoNFS := {}

	oModel    := FWModelActive()
	oModelEES := oModel:GetModel("EESDETAIL")

	Begin Sequence

		If !Empty( EasyGParam("MV_EEC0057",,"") )
			cTitulo += ", " + " que possuem CFOP's :" //" que possuem CFOP's :"
			cTitulo += Alltrim( EasyGParam("MV_EEC0057",,"") )
		EndIf

		aCampos:= {"D2_FILIAL","D2_DOC", "D2_SERIE", "D2_CLIENTE", "D2_LOJA", "D2_COD" , "D2_ITEM" , "D2_QUANT", "D2_EMISSAO", "D2_TES" , "D2_UM", "D2_CF", "F2_CHVNFE","R_E_C_N_O_"}

		AAdd(aSeek, {AvSx3("D2_FILIAL", AV_TITULO), {{"", AvSx3("D2_FILIAL", AV_TIPO), AvSx3("D2_FILIAL", AV_TAMANHO), AvSx3("D2_FILIAL", AV_DECIMAL), AvSx3("D2_FILIAL"    , AV_TITULO)}}})
		AAdd(aSeek, {AvSx3("D2_DOC"   , AV_TITULO), {{"", AvSx3("D2_DOC"   , AV_TIPO), AvSx3("D2_DOC"   , AV_TAMANHO), AvSx3("D2_DOC"   , AV_DECIMAL), AvSx3("D2_DOC"    , AV_TITULO)}}})
		AAdd(aSeek, {AvSx3("D2_CLIENTE", AV_TITULO), {{"", AvSx3("D2_CLIENTE", AV_TIPO), AvSx3("D2_CLIENTE", AV_TAMANHO), AvSx3("D2_CLIENTE", AV_DECIMAL), AvSx3("D2_CLIENTE" , AV_TITULO)}}})

		AAdd(aFilter, {AvSx3("D2_FILIAL" , AV_TITULO)  , AvSx3("D2_FILIAL" , AV_TITULO) , AvSx3("D2_FILIAL" , AV_TIPO) , AvSx3("D2_FILIAL" , AV_TAMANHO) , AvSx3("D2_FILIAL" , AV_DECIMAL), ""})
		AAdd(aFilter, {AvSx3("D2_DOC"    , AV_TITULO)  , AvSx3("D2_DOC"    , AV_TITULO) , AvSx3("D2_DOC"    , AV_TIPO) , AvSx3("D2_DOC"    , AV_TAMANHO) , AvSx3("D2_DOC"    , AV_DECIMAL), ""})
		AAdd(aFilter, {AvSx3("D2_SERIE"  , AV_TITULO)  , AvSx3("D2_SERIE"  , AV_TITULO) , AvSx3("D2_SERIE"  , AV_TIPO) , AvSx3("D2_SERIE"  , AV_TAMANHO) , AvSx3("D2_SERIE"  , AV_DECIMAL), ""})
		AAdd(aFilter, {AvSx3("D2_CLIENTE", AV_TITULO)  , AvSx3("D2_CLIENTE", AV_TITULO) , AvSx3("D2_CLIENTE", AV_TIPO) , AvSx3("D2_CLIENTE", AV_TAMANHO) , AvSx3("D2_CLIENTE", AV_DECIMAL), ""})
		AAdd(aFilter, {AvSx3("D2_LOJA"   , AV_TITULO)  , AvSx3("D2_LOJA"   , AV_TITULO) , AvSx3("D2_LOJA"   , AV_TIPO) , AvSx3("D2_LOJA"   , AV_TAMANHO) , AvSx3("D2_LOJA"   , AV_DECIMAL), ""})
		AAdd(aFilter, {AvSx3("D2_COD"    , AV_TITULO)  , AvSx3("D2_COD"    , AV_TITULO) , AvSx3("D2_COD"    , AV_TIPO) , AvSx3("D2_COD"    , AV_TAMANHO) , AvSx3("D2_COD"    , AV_DECIMAL), ""})
		AAdd(aFilter, {AvSx3("D2_ITEM"   , AV_TITULO ) , AvSx3("D2_ITEM"   , AV_TITULO) , AvSx3("D2_ITEM"   , AV_TIPO) , AvSx3("D2_ITEM"   , AV_TAMANHO) , AvSx3("D2_ITEM"   , AV_DECIMAL), ""})
		AAdd(aFilter, {AvSx3("D2_EMISSAO", AV_TITULO)  , AvSx3("D2_EMISSAO", AV_TITULO) , AvSx3("D2_EMISSAO", AV_TIPO) , AvSx3("D2_EMISSAO", AV_TAMANHO) , AvSx3("D2_EMISSAO", AV_DECIMAL), ""})
		AAdd(aFilter, {AvSx3("D2_CF"     , AV_TITULO)  , AvSx3("D2_CF"     , AV_TITULO) , AvSx3("D2_CF"     , AV_TIPO) , AvSx3("D2_CF"     , AV_TAMANHO) , AvSx3("D2_CF"     , AV_DECIMAL), ""})
		AAdd(aFilter, {AvSx3("D2_UM"     , AV_TITULO)  , AvSx3("D2_UM"     , AV_TITULO) , AvSx3("D2_UM"     , AV_TIPO) , AvSx3("D2_UM"     , AV_TAMANHO) , AvSx3("D2_UM"     , AV_DECIMAL), ""})

		aDados:= RetSD2(aCampos,oModelEES)

		If Len(aDados) == 0
			bOk:= bCancel
		EndIf

		Define MsDialog oDlg Title STR0049 From DLG_LIN_INI, DLG_COL_INI To DLG_LIN_FIM * 0.9, DLG_COL_FIM * 0.9 Of oMainWnd Pixel //"Notas fiscais de saída"

		oBrowse:= FWBrowse():New(oDlg)

		oBrowse:SetDataArray()
		oBrowse:SetArray(aDados)
		oBrowse:SetDescription(cTitulo)

		For nCont:= 1 To Len(aCampos)
			If aCampos[nCont] <> "R_E_C_N_O_"
				If aCampos[nCont] == "D2_QUANT"                                              //"Saldo Qtde. da Nota Fiscal"
					Add COLUMN oColumn Data &("{|| aDados[oBrowse:nAt][" + Str(nCont) + "]}") Title STR0054 Size AvSx3(aCampos[nCont], AV_TAMANHO) Picture AvSx3(aCampos[nCont], AV_PICTURE) Of oBrowse
				ElseIf aCampos[nCont] == "D2_UM"                                             //"Unidade de Medida da NF"
					Add COLUMN oColumn Data &("{|| aDados[oBrowse:nAt][" + Str(nCont) + "]}") Title STR0055 Size AvSx3(aCampos[nCont], AV_TAMANHO) Picture AvSx3(aCampos[nCont], AV_PICTURE) Of oBrowse
				Else
					Add COLUMN oColumn Data &("{|| aDados[oBrowse:nAt][" + Str(nCont) + "]}") Title AvSx3(aCampos[nCont], AV_TITULO) Size AvSx3(aCampos[nCont], AV_TAMANHO) Picture AvSx3(aCampos[nCont], AV_PICTURE) Of oBrowse
				EndIf
			EndIf
		Next

		oBrowse:SetSeek(, aSeek)

		oBrowse:SetUseFilter()
		oBrowse:SetFieldFilter(aFilter)

		oBrowse:Activate()

		Activate MsDialog oDlg On Init (EnchoiceBar(oDlg, bOk, bCancel,,,,,,,.F.))


	End Sequence

Return lRet

Static Function RetSD2(aCampos,oModel)
	Local cWhere:= "", cDelete:= "", cPrefixo:= ""
	Local nCont, nPos
	Local aDados:= {}, aReg:= {}
	Local aArea:= GetArea()
	Local nSldUsado
	Local nPosCpoUMD, nPosCpoSld
	Local cQuery := ""
	Local oStatement := FWPreparedStatement():New()
	Local sD2Tmp
	Local nEEC0050 := EasyGParam("MV_EEC0050",,0)

	Begin Sequence

		DBSelectArea("SD2")

		If TcSrvType() <> "AS/400"
			cDelete := " AND D2.D_E_L_E_T_ = ? AND F2.D_E_L_E_T_ = ? "
		EndIf

		cQuery:= "Select "
		For nCont:= 1 To Len(aCampos)

			If nCont > 1
				cQuery += ", "
			EndIf

			If aCampos[nCont] == "R_E_C_N_O_"
				cPrefixo:= "D2."
			ElseIf SubStr(aCampos[nCont], 1, 1) == "S"
				cPrefixo:= SubStr(aCampos[nCont], 1, 3) + "."
			Else
				cPrefixo:= SubStr(aCampos[nCont], 1, 2) + "."
			EndIf
			cQuery +=  ( cPrefixo + aCampos[nCont] )
		Next

		cQuery += " FROM " + RetSqlName("SD2") + " D2"
		cQuery += " INNER JOIN " + RetSqlName("SF2") + " F2"
		cQuery += " ON D2.D2_DOC = F2.F2_DOC"
		cQuery += " AND D2.D2_SERIE = F2.F2_SERIE"
		cQuery += " AND D2.D2_CLIENTE = F2.F2_CLIENTE"
		cQuery += " AND D2.D2_LOJA = F2.F2_LOJA"

		cWhere += " AND D2.D2_COD = ? "
		cWhere += " AND F2.F2_HAWB = ? "

		If !Empty(EasyGParam("MV_EEC0057",,""))
			cWhere  += " And D2.D2_CF IN ('" + StrTran( Alltrim(EasyGParam("MV_EEC0057",,"")) , "," , "','" ) + "')"
		EndIf

		cQuery += (cWhere + cDelete)

		If !Empty(nEEC0050)
			cQuery += " AND D2.D2_EMISSAO >= ? "
		Endif

		oStatement:SetQuery(cQuery)
		oStatement:SetString(1,oModel:GetValue("EES_COD_I"))
		oStatement:SetString(2,' ')
		oStatement:SetString(3,' ')
		oStatement:SetString(4,' ')
		If !Empty(nEEC0050)
			dDtEm := dDatabase - nEEC0050
			oStatement:SetDate(5,dDtEm)
		EndIf

		cQuery := oStatement:GetFixQuery()
		SD2Tmp := MPSysOpenQuery(cQuery)

		For nCont:= 1 To Len(aCampos)
			If aCampos[nCont] <> "R_E_C_N_O_"
				If AvSx3(aCampos[nCont], AV_TIPO) == "N"
					TcSetField(SD2TMP, aCampos[nCont], "N", AvSx3(aCampos[nCont], AV_TAMANHO), AvSx3(aCampos[nCont], AV_DECIMAL))
				ElseIf AvSx3(aCampos[nCont], AV_TIPO) == "C"
					TcSetField(SD2TMP, aCampos[nCont], "C", AvSx3(aCampos[nCont], AV_TAMANHO))
				ElseIf AvSx3(aCampos[nCont], AV_TIPO) == "D"
					TcSetField(SD2TMP, aCampos[nCont], "D")
				EndIf
			EndIf
		Next

		nPosCpoUMD := aScan(aCampos,"D2_UM")
		nPosCpoSld := aScan(aCampos,"D2_SLDEXP")

		(SD2TMP)->(DBGoTop())
		While (SD2TMP)->(!Eof())

			nSldUsado:= 0
			If (nPos:= AScan(aSaldoNFS, {|x| x[1] == (SD2TMP)->R_E_C_N_O_})) > 0
				nSldUsado:= aSaldoNFS[nPos][2]
			EndIf

			If ((SD2TMP)->D2_QUANT - nSldUsado) > 0
				aReg:= {}
				For nCont:= 1 To (SD2TMP)->(FCount())
					If (SD2TMP)->(FieldName(nCont)) <> "D2_QUANT"
						AAdd(aReg, (SD2TMP)->&(FieldName(nCont)))
					Else
						AAdd(aReg, (SD2TMP)->&(FieldName(nCont)) - nSldUsado)
					EndIf
				Next
				AAdd(aDados, AClone(aReg))
			EndIf

			(SD2TMP)->(DBSkip())
		EndDo

		(SD2TMP)->(DbCloseArea())
		oStatement:Destroy()

	End Sequence

	RestArea(aArea)
Return AClone(aDados)

/*
Função     : ValOkF3()
Objetivo   : Validar a vinculação via F3-Consulta
Parâmetros : Nenhum
Retorno    : lRet - resultado da validação
Autor      : Nilson César (adaptada da função ValOkF3, fonte: EECAE110)
Data       : Nov/2018
Revisão    :
*/
Static Function ValOkF3(aCampos, aDados)

	Local lRet := .T.
	Local aQtdEESEK6

	If EasyGParam("MV_EECFAT",,.F.) .And. !EK6CHVNFE(aDados[AScan(aCampos, "D2_FILIAL")], aDados[AScan(aCampos, "D2_DOC")], aDados[AScan(aCampos, "D2_SERIE")], aDados[AScan(aCampos, "D2_CLIENTE")], aDados[AScan(aCampos, "D2_LOJA")])
		lRet := .F.
	EndIf

Return lRet



/*
Função     : EK6CHVNFE
Objetivo   : Retorna .T. quando existir a chave da nota (F1_CHVNFE) e .F. quando nao existir ou quando nao for possivel verificar (fatam informacoes)
Parâmetros : cFilialSF2,cDocSF2,cSerieSF2,cClienSF2,cLojaSF2 - dados da chave parra posicionamento da nota fiscal de saida
             cChaveNFS - código default da chave eletrônica da SEFAZ para a NF.
Retorno    : .T. - Posicionou SF1 e existe F1_CHVNFE; .F. nao posicionou ou nao existe a informacao F1_CHVNFE
Autor      : Nilson César (adaptada da função EYYCHVNFE, fonte: EECAE110)
Data       : Nov/2018
*/
Static Function EK6CHVNFE(cFilialSF2,cDocSF2,cSerieSF2,cClienSF2,cLojaSF2,cChaveNFS)
	Local lRet        := .T.
	Local aAreaSF2    := SF2->(GetArea())

	Default cChaveNFS := ""

	If !Empty(cFilialSF2) .And. !Empty(cDocSF2) .And. !Empty(cSerieSF2) .And. !Empty(cClienSF2) .And. !Empty(cLojaSF2)
		SF2->(dbSetOrder(1))//F2_FILIAL + F2_DOC + F2_SERIE + F2_FORNECE + F2_LOJA + F2_TIPO
		If !AvFlags("EEC_LOGIX") .And. SF2->(DbSeek(AvKey(cFilialSF2,"F2_FILIAL") + AvKey(cDocSF2,"F2_DOC") + AvKey(cSerieSF2,"F2_SERIE") + AvKey(cClienSF2,"F2_CLIENTE") + AvKey(cLojaSF2,"F2_LOJA")))

			If Empty(SF2->F2_CHVNFE)
				MsgInfo( STR0056, STR0001) //"Esta nota fiscal não pode ser associada, pois não há chave de registro da Nota Fiscal na Sefaz. Efetue a transmissão para a Sefaz para efetuar a associação ao embarque." #### "Atenção"
				cChaveNFS := ""
				lRet := .F.
			Else
				cChaveNFS := SF2->F2_CHVNFE
			EndIf

		EndIf
	EndIf

	RestArea(aAreaSF2)
Return lRet



/*
Função     : GrvDados()
Objetivo   : Atualizar os dados da work WK_NFRem, controlar o saldo usado e
             posicionar a SD2 para retorno das demais informações
             - Deve controlar a inclusão/ exclusão da linha na work, de acordo com o  saldo
               vindo da tabela SD2
             - Deve controlar o saldo do item usado, para atualização da tabela SD2
             com o saldo que estiver vindo da
Parâmetros : aCampos - campos exibidos na consulta padrão
             aDados - array as informações da linha posicionada
Retorno    :
Autor      : Nilson César (adaptada da função GrvDados, fonte: EECAE110)
Data       : Nov/2018
Revisão    :
*/
Static Function GrvDados(aCampos, aDados)
	Local lRet:= .T.
	Local nPos:= 0
	Local nRecNoSD2
	Local nQuantidade, nQtdeUMEmb , nQtdeUMNFe
	Local cUMPesItEmb, cUMNFeIt, nQtdeBxSD2, i
	Local oModel
	Local oModelEK6

	oModel    := FWModelActive()
	oModelEK6 := oModel:GetModel("EK6DETAIL")

	Begin Sequence

		If Len(aDados) == 0
			Break
		EndIf

		nRecNoSD2  := aDados[AScan(aCampos, "R_E_C_N_O_")]
		nQtdeBxSD2 := SD2->D2_QUANT

		//SaldoTmpSD2(nRecNoSD2 , nQtdeBxSD2 , SUBTRAIR)
		//SaldoTmpSD2(nRecNoSD2 , nQtdeBxSD2 , SOMAR   )

		SD2->(DBGoTo(nRecNoSD2))

		SetPropEK6(.T.)

   /* Atualiza os valores da linha da EK6 */
		oModelEK6:LoadValue("EK6_NF"    ,SD2->D2_DOC)
		oModelEK6:LoadValue("EK6_SERIE" ,SD2->D2_SERIE)
		oModelEK6:LoadValue("EK6_CLIENT",SD2->D2_CLIENTE)
		oModelEK6:LoadValue("EK6_LOJACL",SD2->D2_LOJA)
		oModelEK6:LoadValue("EK6_COD_I" ,SD2->D2_COD)
		oModelEK6:LoadValue("EK6_ITEM"  ,SD2->D2_ITEM)
		oModelEK6:LoadValue("EK6_CHVNFE",Posicione("SF2", 1 , aDados[AScan(aCampos, "D2_FILIAL")] + SD2->(D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA) ,"F2_CHVNFE") )
		oModelEK6:LoadValue("EK6_QUANT" ,NF400QtSD2(SD2->D2_QUANT))
		oModelEK6:LoadValue("EK6_UMNF"  ,SD2->D2_UM)
		oModelEK6:LoadValue("EK6_CFOP"  ,SD2->D2_CF)

	End Sequence

Return lRet

Static Function SetPropEK6(lEnable)

	Local oModel    := FWModelActive()
	Local oEstModEK6 := oModel:GetModel("EK6DETAIL"):OFORMMODELSTRUCT
	Local nI, bBlock

	If EasyGParam("MV_EECFAT",,.F.)
		bBlock := FwBuildFeature(STRUCT_FEATURE_WHEN, If(lEnable,".T.",".F.") )
		For nI := 1 to Len(oEstModEK6:aFields)
			If !(oEstModEK6:aFields[nI][3] $ "EK6_FILIAL|EK6_NF|EK6_QUANT")
				oEstModEK6:SetProperty( oEstModEK6:aFields[nI][3] , MODEL_FIELD_WHEN , bBlock )
			EndIf
		Next nI
	EndIf

Return .T.
