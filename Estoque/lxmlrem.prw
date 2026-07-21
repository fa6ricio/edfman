
#Include "TOTVS.CH"
#Include "RwMake.ch"
#Include "XMLXFUN.CH"
#Include "Font.ch"
#Include "Colors.ch"

#Define CRLF  Chr(13)+Chr(10)

/*/
Funcao     | LXmlRem
	Descricao  | Importa XML NF_REMESSA a partir da CKOCOL
	@param     | cXML    - nome do arquivo gravado em CKO_ARQUIV
	@param     | cContra - contrato
	@param     | cDP     - periodo
	@return    | lRet - .T. se processado com sucesso
	@author    | M, Felipi
	@since     | 28/05/2026
/*/
User Function LXmlRem(cXML, cContra, cDP)

	Local lRet       := .F.
	Local cNomXml    := AllTrim(If(ValType(cXML) == "C", cXML, ""))

	Private oProcess := Nil
	Private lExcJob  := IsBlind()
	Private cTContra := AllTrim(If(ValType(cContra) == "C", cContra, ""))
	Private cTDP     := AllTrim(If(ValType(cDP) == "C", cDP, ""))

	If Empty(cNomXml)
		Aviso("Atencao", "Informe o nome do arquivo gravado na CKOCOL.", {"Ok"})
		Return .F.
	EndIf

	If !lExcJob
		oProcess := MsNewProcess():New({|| lRet := fExecXml(cNomXml)}, ;
			"Processando", "Processando XML da CKO...", .T.)
		oProcess:Activate()
	Else
		lRet := fExecXml(cNomXml)
	EndIf

Return lRet



/*/
	Funcao     | fExecXml
	Descricao  | Carrega o XML da CKOCOL e executa o processamento
	@param     | cXML - nome do arquivo gravado em CKO_ARQUIV
	@return    | lOk - .T. se processado com sucesso, .F. caso contrario
	@author    | M, Felipi
	@since     | 28/05/2026
/*/
Static Function fExecXml(cXML)

	Local lRet      := .T.
	Local cErro     := ""
	Local cNomXml   := AllTrim(cXML)
	Local oXml      := Nil
	Local oError    := Nil
	Local aArea     := GetArea()

	Private cEmpPad := If(lExcJob,"01",cEmpAnt)
	Private cFilPad := If(lExcJob,"01",cFilAnt)
	Private cBody   := "<Htm><br>" + CRLF
	Private lOk     := .T.

	Begin Sequence

		If lExcJob
			RpcSetType(3)
			RpcSetEnv( cEmpPad , cFilPad , , , , "LE_XML" )
		EndIf

		If !lExcJob .And. oProcess <> Nil
			oProcess:SetRegua1(1)
			oProcess:IncRegua1("Carregando XML: " + cNomXml)
		EndIf

		ConOut(FunName() + " - Inicio processamento Arquivo: " + cNomXml + ;
			" em " + DtoC(Date()) + " - " + Time())

		cBody += "Processamento Arquivo : " + cNomXml + "<br>" + CRLF
		cBody += "<br>" + CRLF

		oXml := fCarXml(cNomXml, @cErro)

		If oXml == Nil
			lRet := .F.
			lOk  := .F.
			If Empty(cErro)
				cErro := "Nao foi encontrado XML na CKOCOL para o arquivo informado."
			EndIf
			cBody += "Arquivo com Erro : " + cErro + "<br>" + CRLF
			cBody      += "<br>"+CRLF
			ConOut( FunName()+" - Atencao Erro: " + cErro )
		ElseIf Type("oXml:_proccancnfe") == "U"
			Begin Transaction
				lOk  := fProcXml(oXml, cNomXml, @lOk)
				lRet := lOk
				If !lRet
					DisarmTransaction()
				EndIf
			End Transaction
		Else
			ConOut(FunName() + " - XML de cancelamento ignorado: " + cNomXml)
		EndIf

		Recover Using oError

		lRet := .F.
		lOk  := .F.
		cErro := If(ValType(oError) == "O", oError:Description, ;
			"Falha no processamento do XML.")
		cBody += "Arquivo com Erro : " + cErro + "<br>" + CRLF
		cBody += "<br>" + CRLF
		ConOut(FunName() + " - Atencao Erro: " + cErro)

	End Sequence

	If lExcJob
		RpcClearEnv()
	EndIf

	cBody += "</Htm>"
	ConOut(FunName() + " - Final processamento Arquivo: " + cNomXml + ;
		" em " + DtoC(Date()) + " - " + Time())

	If !lRet .And. !lExcJob .And. !Empty(cErro)
		Aviso("Atencao", cErro, {"Ok"})
	EndIf

	RestArea(aArea)

Return lRet



/*/
	Funcao     | fCarXml
	Descricao  | Carrega XML exclusivamente da CKOCOL
	@param     | cAliasXml - nome gravado em CKO_ARQUIV
	@param     | cErroXml  - retorna descricao do erro por referencia
	@return    | oXml (objeto parser) ou Nil em caso de erro
	@author    | M, Felipi
	@since     | 28/05/2026
/*/
Static Function fCarXml(cAliasXml, cErroXml)

	Local oXml      := Nil
	Local cAviso    := ""
	Local cAliasTmp := GetNextAlias()
	Local cAliasSql := AllTrim(SDS->DS_ARQUIVO)
	Local cQuery    := ""
	Local cXmlRet   := ""
	Local nRecCko   := 0
	Local oError    := Nil
	Local aAreaCko  := GetArea()

	cErroXml := ""

	Begin Sequence
		DbSelectArea("CKO")

		cQuery := "SELECT R_E_C_N_O_ AS RECCKO FROM " + RetSqlName("CKOCOL")
		cQuery += " WHERE CKO_FILIAL = '" + xFilial("CKOCOL") + "'"
		cQuery += " AND CKO_ARQUIV = '" + cAliasSql + "'"
		cQuery += " AND D_E_L_E_T_ = ' '"
		cQuery := ChangeQuery(cQuery)

		If Select(cAliasTmp) > 0
			(cAliasTmp)->(DbCloseArea())
		EndIf

		DbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), cAliasTmp, .F., .T.)

		If !(cAliasTmp)->(Eof())
			nRecCko := (cAliasTmp)->RECCKO
			CKO->(DbGoTo(nRecCko))
			cXmlRet := CKO->CKO_XMLRET
		EndIf

		(cAliasTmp)->(DbCloseArea())

		If Empty(cXmlRet)
			cErroXml := "Nao foi encontrado XML na CKOCOL para o arquivo " + cAliasXml
		Else
			oXml := XmlParser(cXmlRet, "_", @cAviso, @cErroXml)
			If oXml == Nil .And. Empty(cErroXml)
				cErroXml := "XmlParser retornou vazio para o arquivo " + cAliasXml
			EndIf

			If !Empty(cAviso) .And. Empty(cErroXml)
				ConOut(FunName() + " - Aviso XmlParser: " + cAviso)
			EndIf
		EndIf

		Recover Using oError
		cErroXml := "Falha ao carregar XML na CKOCOL: " + ;
			If(ValType(oError) == "O", oError:Description, "erro nao identificado")
		oXml := Nil
		If Select(cAliasTmp) > 0
			(cAliasTmp)->(DbCloseArea())
		EndIf
	End Sequence

	RestArea(aAreaCko)

Return oXml



/*/
    Funcao     | fProcXML
    Descricao  | Processa o XML parseado: extrai dados, cadastra transportador/fornecedor,
               | localiza nota mae/contrato e popula arquivo de trabalho para importacao
    @param     | oXml      - objeto XML parser
    @param     | cAliasXml - alias/nome do arquivo XML
    @param     | lOk       - flag de sucesso (por referencia)
    @return    | lOk - .T. se processado com sucesso
    @author    | M, Felipi
    @since     | 28/05/2026
/*/
Static Function fProcXML(oXml,cAliasXml,lOk)

	Local nRegXml    := 0
	Local cTpMov     := ""
	Local aMovim     := {}
	Local a          := 0
	Local nw         := 0
	Local X_X        := 0
	Local nMovim     := 0
	Local cAliasTrb  := ""
	Local aCampos    := {}
	Local aStru      := {}
	Local cArqTrb    := ""
	Local cArqInd    := ""
	Local cChave     := ""
	Local nRegs      := 1
	Local lFor       := .F.
	Local lProd      := .F.
	Local lTransp    := .F.
	Local lMAECONTRA := .T.
	Local n_tam_det  := 0
	Local X_futura   := ""
	Local cCFOP      := ""
	Local wcodtran   := ""
	Local xNatur     := ""
	Local xLSC7      := .F.
	Local cArmaz     := ""
	Local nTamSerie  := 0
	Local cSERIma    := ""
	Local xVlUnit    := ""
	Local cValor     := ""
	Local nValor     := 0
	Local nDifer     := 0
	Local cDifPcXNfe := ""
	Local cAliasCli  := ""
	Local cNFISCAL   := ""
	Local cSerie     := ""
	Local cProduto   := ""
	Local cUM        := ""
	Local cTexto     := ""
	Local cASSerie   := ""
	Local nQtd       := 0
	Local lKg        := .F.
	Local xVlun      := ""
	Local lErro      := .F.
	Local aAreaFpx   := GetArea()
	Local aRet       := {}

	Private cnfmae   := Space(TamSx3("F1_DOC")[1])
	Private cSERImae := Space(TamSx3("F1_SERIE")[1])
	Private xPedido  := Space(TamSx3("C7_NUM")[1])
	Private xContra  := Space(TamSx3("C7_CONTRAT")[1])
	Private XPeriod  := Space(TamSx3("C7_XPERIOD")[1])
	Private cCONTRA  := Space(TamSx3("C7_CONTRAT")[1])
	Private cPERIODO := Space(TamSx3("C7_XPERIOD")[1])
	Private nVOLUME  := ""
	Private XCNPJ    := ""
	Private XNOMFOR  := ""
	Private XCONDPAG := ""
	Private xNavio   := ""
	Private XQTDMAE  := 0
	Private XQTDREM  := 0
	Private lMae     := .T.
	Private cCliFor  := ""
	Private cLoja    := ""
	Private cTES     := ""
	Private nVlrMae  := 0

	If lExcJob
		RpcSetType(3)
		RpcSetEnv( cEmpPad , cFilPad , , , , "LE_XML" )
	EndIf

	cAliasTrb := GetNextAlias()

	// O parser consolida os dados do XML em arquivo de trabalho antes do ExecAuto.

	aCampos :={;
		{"TP_DE_NOTA", "C", 01, 0, "TIPO_DE_NOTA"  , "Left(@@,01)"},;
		{"FORM_PROP" , "C", 01, 0, "FORM_PROP"     , "Left(@@,01)"},;
		{"TP_MOVIMEN", "C", 03, 0, "TIPO_MOVIMENTO", "Left(@@,03)"},;
		{"NR_NFISCAL", "C", 09, 0, "NR_NFISCAL"    , "PadR(Right(@@,09),09)"},;
		{"SERIE"     , "C", 03, 0, "SERIE"         , "PadR(Left(@@,03),03)"},;
		{"DT_EMISSAO", "D", 08, 0, "DATA_EMISSAO"  , "SToD(@@)"},;
		{"CLI_FOR"   , "C", 06, 0, "CLI_FOR"       , "PadR(Right(@@,06),06)"},;
		{"LJ_CLI_FOR", "C", 02, 0, "LOJA_CLI_FOR"  , "PadR(Right(@@,02),02)"},;
		{"ESTADO"    , "C", 02, 0, "ESTADO"        , "PadR(Right(@@,02),02)"},;
		{"TP_ITEM"   , "C", 04, 0, "NUMERO ITEM"   , "Left(@@,04)"},;
		{"COD_PROD"  , "C", 30, 0, "COD_PRODUTO"   , "PadR(Left(@@,30),30)"},;
		{"UNIDADE"   , "C", 02, 0, "UNIDADE"       , "PadR(Left(@@,02),02)"},;
		{"QUANTIDADE", "N", 11, 3, "QUANTIDADE"    , "Val(@@)/10000"},;
		{"VLR_UNIT"  , "N", 18, 6, "VLR_UNITARIO"  ,},;
		{"VLR_TOTAL" , "N", 14, 2, "VLR_TOTAL"     , "Val(@@)/100"},;
		{"TES"       , "C", 03, 0, "TES"           , "PadR(Left(@@,03),03)"},;
		{"CFOP"      , "C", 05, 0, "CFOP"          , "PadR(Left(@@,03),03)"},;
		{"BASE_ICMS" , "N", 14, 2, "BASE_ICMS"     , "Val(@@)/100"},;
		{"VLR_ICMS"  , "N", 14, 2, "VLR_ICMS"      , "Val(@@)/100"},;
		{"ALIQ_ICMS" , "N", 06, 2, "ALIQUOTA_ICMS" , "Val(@@)/100"},;
		{"TRANSP"    , "C", 06, 0, "TRANSPORTADORA", "Val(@@)/100"},;
		{"VL_SEGURO" , "N", 14, 2, "VALOR_SEGURO"  , "Val(@@)/100"},;
		{"VL_FRETE"  , "N", 14, 2, "VALOR_FRETE"   , "Val(@@)/100"},;
		{"PESO_LIQUI", "N", 14, 3, "PESO_LIQUI"    , "Val(@@)/100"},;
		{"PESO_BRUTO", "N", 14, 3, "PESO_BRUTO"    , "Val(@@)/100"},;
		{"ESPECIE"   , "C", 20, 0, "ESPECIE"       , "PadR(Left(@@,20),20)"},;
		{"VOLUME"    , "N", 14, 3, "VOLUME"        , "PadR(Left(@@,20),20)"},;
		{"NATUREZA"  , "C", 10, 0, "NATUREZA"      , "PadR(Left(@@,10),10)"},;
		{"INFNEID"   , "C", 44, 0, "INFNEID"       , "PadR(Left(@@,44),44)"},;
		{"COND_PAG"  , "C", 03, 0, "CONDICAO_PAGTO", "PadR(Left(@@,03),03)"},;
		{"NF_CONTRA" , "C", 15, 0, "CONTRATO"      , "PadR(Left(@@,09),09)"},;
		{"NF_PERIODO", "C", 10, 0, "PERIODO"       , "PadR(Left(@@,03),03)"},;
		{"NF_LMAE"   , "C", 01, 0, "TEM NFMAE"     , "Left(@@,01)"},;
		{"NF_SERIMAE", "C", 03, 0, "SERIE MAE"     , "PadR(Left(@@,03),03)"},;
		{"NF_MAE"    , "C", 09, 0, "NF_MAE"        , "PadR(Right(@@,09),09)" }}


	aStru := {}
	aEval(aCampos,{|x| AAdd( aStru , {x[1],x[2],x[3],x[4]} ) } )

	cArqTrb  := CriaTrab(aStru,.T.)
	cArqInd  := CriaTrab(Nil,.F.)
	cChave   := "NR_NFISCAL+SERIE+CLI_FOR+LJ_CLI_FOR"

	If Select(cAliasTrb) > 0
		(cAliasTrb)->(DbCloseArea())
	Endif
	DbUseArea(.T.,,cArqTrb,cAliasTrb)

	(cAliasTrb)->(DbCreateIndex( cArqInd, cChave, {|| &cChave}, .F. ))
	(cAliasTrb)->(DbCommitAll())
	(cAliasTrb)->(dbGoTop())

	(cAliasTrb)->(DbClearInd())
	(cAliasTrb)->(DbSetIndex( cArqInd ))
	(cAliasTrb)->(dbSetOrder(1))

	nRegs := 1

	If !lExcJob
		oProcess:SetRegua2( nRegs*2 )
	EndIf

	lFor       := .F.     // indica se o fornecedor foi incluido automaticamente
	lProd      := .F.     // indica se o produto foi incluido automaticamente
	lTransp    := .F.     // indica se a transportadora foi incluida automaticamente
	lMAECONTRA := .T.     // indica se nota mae e contrato foram validados para a importacao

	For nRegXml := 1 To nRegs

		cnfmae := Space(TamSx3("F1_DOC")[1])

		If !lExcJob
			oProcess:IncRegua2()
		EndIf

		n_tam_det := 1
		For X_X := 1 to n_tam_det

			X_futura := iif(n_tam_det>1,alltrim(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CFOP:TEXT),alltrim(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT))
			cCFOP    := X_futura
			X_futura := substr(X_futura,2,4)
			If !X_futura $ "922/501/502/503/494" .AND. TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT")<>"U"

				// BUSCA TRANSPORTADOR
				SA4->( dbSetOrder(3) ) // ordem de CNPJ da transportadora
				If !SA4->( dbSeek(xFilial("SA4")+OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT ) )

					// cadastra novo quando o mesmo nao existe
					lTransp := .T.

					dbSelectArea("SA4")
					dbSetOrder(1)
					SA4->(dbGoBottom())
					wcodtran:=strzero(VAL(SA4->A4_COD)+1,6)

					RecLock("SA4",.T.)
					SA4->A4_FILIAL := xFilial("SA4")
					SA4->A4_COD    := wcodtran
					SA4->A4_NOME   := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_XNOME:TEXT
					SA4->A4_NREDUZ := SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_XNOME:TEXT,1,25)
					SA4->A4_END    := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_XENDER:TEXT
					SA4->A4_MUN    := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_XMUN:TEXT
					SA4->A4_EST    := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_UF:TEXT
					SA4->A4_CGC    := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT
					SA4->A4_INSEST := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_IE:TEXT
					MsUnLock()
				EndIf
			EndIf

			XCNPJ := ""
			XNOMFOR := ""

			// BUSCA FORNECEDOR
			SA2->( dbSetOrder(3) ) // ordem de CNPJ do FORNECEDOR
			If !SA2->( dbSeek(xFilial("SA2")+OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT ) )
				// O fluxo novo exige cadastro previo para evitar inclusao automatica fora da regra atual.
				lFor := .T.
				Alert("Fornecedor não cadastrado! Não será importado o XML.")
			Endif

			XCNPJ := SA2->A2_CGC
			XNOMFOR := SA2->A2_NREDUZ
			// Produto e TES precisam existir previamente; o fluxo novo nao autocadastra SA5/SB1/SF4.

			cCliFor:=SA2->A2_COD
			cLoja  :=SA2->A2_LOJA

			cTexto := ""
			Begin Sequence
				// TYPE() nao consegue avaliar cadeias de propriedades com ':'; acessa diretamente
				cTexto := OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT
				cASSerie := OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
			End Sequence

			IF !Empty(cTexto)
				// O fluxo novo nao reaproveita excecoes historicas de armazem por fornecedor.
				cArmaz	:= "01"

				// Identifica nota mae, pedido e contrato pela mensagem do XML ou por confirmacao manual.

				xPedido  := Space(TamSx3("C7_NUM")[1])
				xContra  := Space(TamSx3("C7_CONTRAT")[1])
				XPeriod  := Space(TamSx3("C7_XPERIOD")[1])
				xNatur   := ""
				xNavio   := ""
				XCONDPAG := ""
				XQTDMAE  := 0
				XQTDREM  := 0
				xLSC7    := .F.
				aRet     := { "", "" }

				If "NOTA FISCAL DE VENDA" $ cTexto

					cnfmae:= strtran(substr(cTexto,at("NOTA FISCAL DE VENDA", cTexto)+20,10),".","")

					if "-" $ cnfmae
						aRet := arrumaNumNF(cnfmae,cASSerie)
					else
						aRet[1] := Alltrim(LEFT((H:=strtran(substr(cTexto,at("NOTA FISCAL DE VENDA", cTexto)+20,10),".","")),at(",",H)-1))
						aRet[1] := PADL(aRet[1],TAMSX3("F1_DOC")[1],"0")
						aRet[2] := PADR(cASSerie,TAMSX3("F1_SERIE")[1])
					endif

					if len(aRet) > 0 .AND. empty(aRet[1]) .AND. empty(aRet[2])
						cnfmae:= PADR(ALLTRIM(cnfmae),TAMSX3("F1_DOC")[1])

						cSERImae:= strtran(substr( cTexto,at("NOTA FISCAL DE VENDA", cTexto)+31,2),".","")
						cSERImae:=PADR(ALLTRIM(cSERImae),TAMSX3("F1_SERIE")[1])

						nTamSerie:= TamSx3("F1_SERIE")[1]
						cSERIma  := Alltrim(cSERImae)
						cSERImae := ""
						For a:=1 to nTamSerie
							If Upper(SubStr(cSERIma,a,1)) $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
								If SubStr(cSERIma,a,1) <> " "
									cSERImae := cSERImae + SubStr(cSERIma,a,1)
								Else
									a:=100
								EndIf
							EndIf
						Next
						cSERImae := cSERImae + Space(nTamSerie-Len(cSERImae))
					else
						cnfmae   := aRet[1]
						cSERImae := aRet[2]
					endif

					SD1->(dbSetOrder(1))
					If !SD1->(dbSeek(xFilial("SD1")+cnfmae+cSERImae+cCliFor+cLoja))
						lMAECONTRA := LEINFCPL(cTexto,@cnfmae,@cSERImae,@cCONTRA,@cPERIODO,OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
					EndIf

					If lMAECONTRA
						dbSelectArea("SF1")
						dbSetOrder(1)
						If dbSeek(xFILIAL("SF1")+cnfmae+cSERImae)
							Do While !SF1->(EOF()).AND. SF1->F1_DOC=cnfmae
								If SF1->F1_FORNECE=cCliFor .AND. SF1->F1_LOJA=cLoja
									xPedido:=SF1->F1_XPEDIDO

									dbSelectArea("SD1")
									SD1->(dbSetOrder(1))
									If SD1->(dbSeek(xFilial("SD1")+cnfmae+cSERImae+cCliFor+cLoja) )
										nVlrMae := SD1->D1_TOTAL
										XQTDMAE := SD1->D1_QUANT
									EndIf

								EndIf
								SF1->(dbSkip())
							EndDo

							dbSelectArea("SC7")
							dbSetOrder(1)
							If dbSeek(xFILIAL("SC7")+xPEDIDO).And. !Empty(xPEDIDO)
								IF !SC7->(EOF())
									xLSC7    	:= .T.
									xContra		:=SC7->C7_CONTRAT
									XPeriod		:=SC7->C7_XPERIOD
									xNavio 		:=SC7->C7_NAVIO
									cCONTRA 	:= xContra
									cPERIODO	:= XPeriod
									XCONDPAG 	:= SC7->C7_COND
									// Nao ajusta quantidade do pedido durante a leitura do XML.
								ENDIF
							Else
								lMAECONTRA := .F.

							EndIf
						EndIf
					Else
						lMAECONTRA := .F.
					EndIF

				ELSE

					// Abre a tela para informar contrato, periodo, nota e serie.
					lMAECONTRA := LEINFCPL(cTexto,@cnfmae,@cSERImae,@cCONTRA,@cPERIODO,OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)

					If lMAECONTRA

						IF !EMPTY(cnfmae)

							dbSelectArea("SF1")
							dbSetOrder(1)
							If dbSeek(xFILIAL("SF1")+cnfmae)
								Do While !SF1->(EOF()).AND. SF1->F1_DOC=cnfmae
									If SF1->F1_FORNECE=cCliFor .AND. SF1->F1_LOJA=cLoja
										xPedido:=SF1->F1_XPEDIDO

										dbSelectArea("SD1")
										SD1->(dbSetOrder(1))
										If SD1->(dbSeek(xFilial("SD1")+cnfmae+cSERImae+cCliFor+cLoja) )
											nVlrMae := SD1->D1_TOTAL
											XQTDMAE := SD1->D1_QUANT
										EndIf

									EndIf
									SF1->(dbSkip())
								EndDo

								dbSelectArea("SC7")
								dbSetOrder(1)
								If dbSeek(xFILIAL("SC7")+xPEDIDO) .And. !Empty(xPEDIDO)
									IF !SC7->(EOF())
										xLSC7   := .T.
										xContra := SC7->C7_CONTRAT
										XPeriod := SC7->C7_XPERIOD
										xNavio  := SC7->C7_NAVIO
										cCONTRA := xContra
										cPERIODO:= XPeriod
										XCONDPAG:= SC7->C7_COND
										// Nao ajusta quantidade do pedido durante a leitura do XML.
									ENDIF
								Else
									lMAECONTRA := .F.
								EndIf

							Else
								lMAECONTRA := .F.
							EndIF

						EndIf

					EndIf

				EndIf

				// A NF remessa precisa estar vinculada a um pedido de compras.
				If Empty(xPEDIDO)
					lOk := .F.
					Aviso("Atencao", "Toda NF Remessa deve estar amarrada a um Pedido de Compras. Sendo assim, este documento nao sera importado", {"Continuar"})
					RestArea(aAreaFpx)
					Return lOk
				Else
					// Compara o preco unitario do XML com o pedido para registrar divergencia.

					xVlUnit := Iif(n_tam_det>1,alltrim(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNCOM:TEXT),alltrim(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT))

					cValor := ''
					nValor := 0
					For nw:=1 to Len(xVlUnit)
						If	SubStr(xVlUnit,nw,1) <> ','
							cValor += SubStr(xVlUnit,nw,1)
						Else
							nValor := Val(cValor)
							cValor := ''
						EndIf
					Next
					nValor := nValor + (Val(cValor) / Val('1'+Strzero(0,Len(cValor))))

					SB1->(dbSetOrder(1))
					If SB1->(dbSeek(xFilial("SB1") + SC7->C7_PRODUTO ) )
						nDifer := Round((SC7->C7_VLFINAL * SB1->B1_CONV) * SC7->C7_TAXAUSD,2) - nValor
						If nDifer > 0.01 .or. nDifer < -0.01
							If Empty(cDifPcXNfe)
								cDifPcXNfe := "Atenção: Existe diferença de R$ "+Str(nDifer,11,2)+" entre o preço unitário do documento de entrada "+OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT+" e o preço do Pedido de Compras "+SC7->C7_NUM+" !"
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf


			// A chave da remessa usa numero e serie vindos do XML.
			cNFISCAL := STRZERO( VAL(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9 )
			cSerie   := OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
			cSerie   := cSerie + Space(TamSx3("F1_SERIE")[1]-Len(cSerie ))

			// Garante que a NF mae esteja classificada e que o produto base exista no cadastro.
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1))
			If SD1->(dbSeek(xFilial("SD1")+cnfmae+cSERImae+cCliFor+cLoja) )
				If EMPTY(SD1->D1_TES)
					Alert("Nota mãe: "+cnfmae+"-"+cSERImae+" não foi classificada")
				EndIF
			EndIf

			SA5->(DBSETORDER(14))
			IF SA5->(DBSEEK(XFILIAL("SA5")+cCliFor+cLoja+iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT)))
				//ALERT('ENTREI NA SA5 PARA PEGAR PRODUTO')
				cProduto := SA5->A5_PRODUTO
			else
				alert('produto não encontrado na tabela SA5')
			ENDIF

			SB1->(dbSetOrder(1))
			If !SB1->(dbSeek(xFilial("SB1")+cProduto))
				cProduto := Alltrim(cCONTRA)+"-"+Alltrim(cPERIODO)
				cProduto := Padr(cProduto,TamSX3("B1_COD")[1])
				If !SB1->(dbSeek(xFilial("SB1")+cProduto))
					Alert("Produto não cadastrado "+cProduto+" !")
				EndIf
			EndIf

			// Normaliza quantidade e unidade conforme cadastro do produto.
			cUM      := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_UCOM:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)
			nQtd	 := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QCOM:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)))
			lKg      := .F.

			If SB1->B1_UM <> cUM
				// Converte KG para tonelada quando o cadastro do produto trabalha em TM.
				If cUM == "KG"
					nQtd := nQtd / 1000
					lKg  := .T.
				Else
					If cUM $ "TM/TO/TL/TON/SCS"
						If !SB1->B1_UM $ "TM/TO/TL/SC"
							Aviso("Atenção","A unidade de medida: "+cUM+" da Nota Fiscal de Remessa: "+cNFISCAL+" é diferente da Unidade de Medida do Produto: "+SD1->D1_COD+" ! A NF Remessa será importada com unidade de medida da ED&F MAN.",{"Voltar"})
						EndIf
					Else
						If SB1->B1_UM <> cUM
							Aviso("Atenção","A unidade de medida: "+cUM+" da Nota Fiscal de Remessa: "+cNFISCAL+" é diferente da Unidade de Medida do Produto: "+SD1->D1_COD+" ! A NF Remessa será importada com unidade de medida da ED&F MAN.",{"Voltar"})
						EndIf
					EndIf
				EndIf
			EndIf

			If !lFor .And. !lProd .And. !lTransp

				(cAliasTrb)->(RecLock(cAliasTrb,.T.))
				(cAliasTrb)->TP_DE_NOTA := "N"
				// os tipo de nota fiscais sao:
				//  - N = Normal
				//  - D = Devolucao
				//  - B = Beneficiamento
				//  - I = Complento de ICMS
				//  - C = Complemento de Preco

				(cAliasTrb)->TP_MOVIMEN := 'NFE'
				(cAliasTrb)->FORM_PROP  := '2'
				(cAliasTrb)->TP_ITEM    := STRZERO(X_X,4)
				(cAliasTrb)->NR_NFISCAL := STRZERO( VAL(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9 )
				(cAliasTrb)->SERIE      := OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT

				// Suporta XML antigo com DEMI e XML atual com DHEMI.
				IF Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT")<>"U"
					(cAliasTrb)->DT_EMISSAO := _CONVDTSPED(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT)
				Else
					(cAliasTrb)->DT_EMISSAO := _CONVDTSPED(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT)
				EndIf

				(cAliasTrb)->CLI_FOR    := SA2->A2_COD
				(cAliasTrb)->LJ_CLI_FOR := SA2->A2_LOJA
				(cAliasTrb)->ESTADO     := SA2->A2_EST
				(cAliasTrb)->COD_PROD   := SB1->B1_COD

				// Valor unitario segue VUNTRIB quando informado; senao usa VUNCOM do XML.

				xVlun := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT))
				if (cAliasTrb)->VLR_UNIT==0
					(cAliasTrb)->VLR_UNIT   := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNCOM:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT)))
				else
					(cAliasTrb)->VLR_UNIT   := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT)))
				endif

				(cAliasTrb)->VLR_TOTAL  := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VPROD:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT))

				(cAliasTrb)->BASE_ICMS  := VAL(OXML:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT)
				(cAliasTrb)->VLR_ICMS   := VAL(OXML:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT)
				(cAliasTrb)->ALIQ_ICMS  := 0
				(cAliasTrb)->TRANSP     := If( X_futura$"922/501/502/494","", SA4->A4_COD)
				(cAliasTrb)->VL_SEGURO  := 0
				(cAliasTrb)->VL_FRETE   := 0
				(cAliasTrb)->PESO_LIQUI := IIF(TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT")<>"U",val(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT),0)
				(cAliasTrb)->PESO_BRUTO := IIF(TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT")<>"U",val(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT),0)
				(cAliasTrb)->ESPECIE    := "NFE"
				(cAliasTrb)->VOLUME     := IIF(TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT")<>"U",VAL(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT),0)
				(cAliasTrb)->NATUREZA   := ''
				// Mantem 001 quando o contrato nao informa condicao de pagamento.
				(cAliasTrb)->COND_PAG   := IIF(EMPTY(XCONDPAG),"001",XCONDPAG)

				If lKg
					(cAliasTrb)->QUANTIDADE := nQtd
				Else
					(cAliasTrb)->QUANTIDADE  := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QCOM:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)))
				EndIf

				(cAliasTrb)->UNIDADE := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_UCOM:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)

				(cAliasTrb)->INFNEID := Substr(OXML:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,44)

				(cAliasTrb)->NF_MAE     := cnfmae
				(cAliasTrb)->NF_SERIMAE := cSERImae
				(cAliasTrb)->NF_CONTRA  := cCONTRA
				(cAliasTrb)->NF_PERIODO := cPERIODO
				(cAliasTrb)->NF_LMAE    := IIF(lMae == .T.,"S","N")

				(cAliasTrb)->(MsUnLock())

			ELSE
				lOk   := .F.
				lErro := .T.

				IF lMAECONTRA == .F.
					MsgStop("Verifique nota mãe/contrato informados. Nota: "+(cAliasTrb)->NR_NFISCAL+" não importada !!!")
				ENDIF

				// Fecha a tabela temporaria antes de abortar para nao deixar indice residual.
				(cAliasTrb)->(DbCloseArea())
				FErase(cArqInd+IndexExt())

				RestArea(aAreaFpx)
				Return lOk
			ENDIF

		Next X_X

		If AScan(aMovim,(cAliasTrb)->TP_MOVIMEN) == 0 .and. !lFor .and. !lProd .and. !lTransp
			AAdd( aMovim , (cAliasTrb)->TP_MOVIMEN )
		EndIf

		lFor    :=.F.
		lProd   :=.F.
		lTransp :=.F.

	Next nRegXml

	(cAliasTrb)->(DbCloseArea())
	FErase(cArqInd+IndexExt())

	If lExcJob
		RpcClearEnv()
	EndIf

	For nMovim := 1 To Len(aMovim)
		cTpMov  := Right(aMovim[nMovim],3)

		cEmpAnt := SM0->M0_CODIGO
		cFilAnt := SM0->M0_CODFIL

		If lExcJob
			RpcSetType(3)
			RpcSetEnv( cEmpAnt, cFilAnt, , , , "LE_XMLREM" )
		EndIf

		If Select(cAliasTrb) > 0
			(cAliasTrb)->(DbCloseArea())
		Endif
		DbUseArea(.T.,,cArqTrb,cAliasTrb)

		cArqInd  := CriaTrab(Nil,.F.)

		(cAliasTrb)->(DbCreateIndex( cArqInd, cChave, {|| &cChave}, .F. ))
		(cAliasTrb)->(DbCommitAll())
		(cAliasTrb)->(dbGoTop())

		(cAliasTrb)->(DbClearInd())
		(cAliasTrb)->(DbSetIndex( cArqInd ))
		(cAliasTrb)->(dbSetOrder(1))

		If cTpMov$"NFE|PRE"
			fProcNFE(cFilAnt,cTpMov,cAliasTrb,@lOk)
		ElseIf cTpMov$"NFS"
			fProcNFS(cFilAnt,cTpMov,cAliasTrb,@lOk)
		EndIf

		(cAliasTrb)->(DbCloseArea())
		FErase(cArqInd+IndexExt())

		If lExcJob
			RpcClearEnv()
		EndIf
	Next nMovim

	FErase(cArqTrb+GetDbExtension())
	FErase(cArqInd+IndexExt())

	RestArea(aAreaFpx)

Return lOk



/*/
    Funcao     | fProcNFE
    Descricao  | Gera documento de entrada (MATA140) a partir do arquivo de trabalho
    @param     | cFilReg   - filial de registro
    @param     | cTpMov    - tipo de movimento (NFE/PRE)
    @param     | cAliasTrb - alias da tabela de trabalho
    @param     | lOk       - flag de sucesso (por referencia)
    @return    | lOk - .T. se importado com sucesso
    @author    | M, Felipi
    @since     | 28/05/2026
/*/
Static Function fProcNFE(cFilReg,cTpMov,cAliasTrb,lOk)

	Local cFilSB1  := If( Empty(xFilial("SB1")) , Space(TAMSX3("B1_FILIAL")[1]) , cFilReg )
	Local cFilSF1  := If( Empty(xFilial("SF1")) , Space(TAMSX3("F1_FILIAL")[1]) , cFilReg )
	Local cFilSF4  := If( Empty(xFilial("SF4")) , Space(TAMSX3("F4_FILIAL")[1]) , cFilReg )
	Local aErros   := {}
	Local lPreNota := (cTpMov=="PRE")
	Local nErro    := 0
	Local aAreaFne := GetArea()
	Local cArmaz   := "55"

	Private lMsErroAuto := .F.
	// AtuSZD le estes valores no mesmo call stack; deixam de ser implicitos aqui.
	Private cNFiscal    := ""
	Private cSerie      := Space(TamSx3("F1_SERIE")[1])


	(cAliasTrb)->( dbGoTop() )

	While !(cAliasTrb)->( Eof() )

		lPreNota := (cTpMov=="PRE")
		lErro    := .F.
		cItem	 := StrZero(VAL((cAliasTrb)->TP_ITEM),4)//StrZero(VAL((cAliasTrb)->TP_ITEM),Len(SD1->D1_ITEM))
		cTipoNf  := (cAliasTrb)->TP_DE_NOTA
		cFormul  := "N"
		cSerNf   := (cAliasTrb)->SERIE
		cNFiscal := (cAliasTrb)->NR_NFISCAL
		cSerie   := (cAliasTrb)->SERIE
		cEspecie := (cAliasTrb)->ESPECIE
		cCliFor  := (cAliasTrb)->CLI_FOR
		cLoja	 := (cAliasTrb)->LJ_CLI_FOR
		dEmissao := (cAliasTrb)->DT_EMISSAO
		dDtDigit := Date()
		cEstado  := (cAliasTrb)->ESTADO
		cCondPag := (cAliasTrb)->COND_PAG
		cINFNEID := (cAliasTrb)->INFNEID
		cnfmae   := (cAliasTrb)->NF_MAE
		cSERImae := (cAliasTrb)->NF_SERIMAE
		cCONTRA   := (cAliasTrb)->NF_CONTRA
		cPERIODO := (cAliasTrb)->NF_PERIODO
		nVOLUME := (cAliasTrb)->VOLUME
		nBaseIcm := 0
		nValIcm  := 0
		nValMerc := 0
		nValBrut := 0
		XQTDREM  := (cAliasTrb)->QUANTIDADE
		aItem	 := {}

		ConOut( FunName()+" - Processando registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf )

		If AScan( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf ) > 0
			(cAliasTrb)->(DbSkip())
			Loop
		EndIf

		If cTipoNF $"DB"
			cAliasCli := "SA1"
			SA2->( dbSetOrder(1) )
		Else
			cAliasCli := "SA2"
			SA2->( dbSetOrder(1) )
		EndIf

		If !(cAliasCli)->(dbSeek(xFilial(cAliasCli)+cCliFor+cLoja))
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="Cliente/Fornecedor "+cCliFor+"/"+cLoja+" nao esta cadastrado!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf

		If cTipoNF $"DB"
			cTipoCli  := SA1->A1_TIPO
			cEstCli   := SA1->A1_EST
		Else
			cTipoCli  := SA2->A2_TIPO
			cEstCli   := SA2->A2_EST
		EndIf

		SF1->(dbSetOrder(1))
		If SF1->(dbSeek(cFilSF1+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf))
			lOk   := .F.
			lErro := .T.
			cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado, pois ja existe no sistema!<br>"+CRLF
			AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
			(cAliasTrb)->(DbSkip())
			Loop
		EndIf

		While !(cAliasTrb)->(Eof()) .And. (cAliasTrb)->SERIE == cSerNf  ;
				.And. (cAliasTrb)->NR_NFISCAL == cNFiscal;
				.And. (cAliasTrb)->CLI_FOR    == cCliFor ;
				.And. (cAliasTrb)->LJ_CLI_FOR == cLoja

			If !lExcJob
				oProcess:IncRegua2()
			EndIf

			lPreNota := Empty((cAliasTrb)->TES)

			If !SB1->(dbSeek(cFilSB1+(cAliasTrb)->COD_PROD))
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="O Produto "+(cAliasTrb)->COD_PROD+" nao esta cadastrado!<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf

			SF4->( dbSetOrder(1) )
			If !SF4->(dbSeek(cFilSF4+(cAliasTrb)->TES)).And.!lPreNota
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="A TES "+(cAliasTrb)->TES+" nao esta cadastrada!<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf

			If (cAliasTrb)->QUANTIDADE == 0
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="Quantidade nao informada<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf
			If (cAliasTrb)->VLR_UNIT == 0
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="Valor Unitario nao informado<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf
			If (cAliasTrb)->VLR_TOTAL == 0
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="Valor total nao informado!<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf

			If !lErro
				cUM := SB1->B1_UM

				_nValUnit	:= round(((cAliasTrb)->VLR_TOTAL / (cAliasTrb)->QUANTIDADE) ,TAMSX3("D1_VUNIT")[2])

				_cLocPad	:= SB1->B1_LOCPAD

				nQTD:=(cAliasTrb)->QUANTIDADE

				AAdd(aItem,{;
					{"D1_COD"    , (cAliasTrb)->COD_PROD  , Nil},;
					{"D1_ITEM"   , cItem                  , Nil},;
					{"D1_UM"     , cUm                    , Nil},;
					{"D1_QUANT"  , (cAliasTrb)->QUANTIDADE, Nil},;
					{"D1_VUNIT"  , _nValUnit              , Nil},;
					{"D1_TOTAL"  , (cAliasTrb)->VLR_TOTAL , Nil},;
					{"D1_IPI"    , 0                      , Nil},;
					{"D1_VALIPI" , 0                      , Nil},;
					{"D1_PICM"   , (cAliasTrb)->ALIQ_ICMS , Nil},;
					{"D1_VALICM" , 0                      , Nil},;
					{"D1_BASEICM", 0                      , Nil},;
					{"D1_BASEIPI", 0                      , Nil},;
					{"D1_RATEIO" , "2"                    , Nil},;
					{"D1_LOCAL"  , cArmaz                 , Nil},;
					{"D1_BRICMS" , 0                      , Nil},;
					{"D1_ICMSRET", 0                      , Nil}})

				cItem    := Soma1(cItem, 4)
				nBaseIcm += (cAliasTrb)->BASE_ICMS
				nValIcm  += (cAliasTrb)->VLR_ICMS
				nValMerc += (cAliasTrb)->VLR_TOTAL
				nValBrut += (cAliasTrb)->VLR_TOTAL
			EndIf
			(cAliasTrb)->(DbSkip())
		End

		If !lErro

			cEspecie:="SPED"

			aCab := {;
				{"F1_TIPO"   , cTipoNF   , NIL},;
				{"F1_FORMUL" , cFormul   , NIL},;
				{"F1_DOC"    , cNFiscal  , NIL},;
				{"F1_SERIE"  , cSerNf    , NIL},;
				{"F1_EMISSAO", dEmissao  , NIL},;
				{"F1_FORNECE", cCliFor   , NIL},;
				{"F1_LOJA"   , cLoja     , NIL},;
				{"F1_ESPECIE", cEspecie  , NIL},;
				{"F1_BASEICM", nBaseIcm  , NIL},;
				{"F1_VALICM" , nValIcm   , NIL},;
				{"F1_VALIPI" , nValIcm   , NIL},;
				{"F1_ICMSRET", 0         , NIL},;
				{"F1_VALMERC", nValBrut  , NIL},;
				{"F1_VALBRUT", nValBrut  , NIL},;
				{"F1_ORIGEM" , "LEXMLREM", NIL},;
				{"F1_TIPODOC", cTipoNf   , Nil},;
				{"F1_COND"   , cCondPag  , NIL}}

			lMsErroAuto := .F.
			ddatabase:=dDtDigit
			MSExecAuto({|x,y,z| Mata140(x,y,z) }, aCab, aItem, 3)

			If lMsErroAuto

				If !lExcJob
					MostraErro()
				EndIf

				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				aErros := GetAutoGrLog()
				For nErro := 1 To Len(aErros)
					cBody+= aErros[nErro]+"<br>"+CRLF
				Next nErro
				cBody+="<br>"+CRLF

			Else

				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" foi importado com sucesso!<br>"+CRLF
				cBody+="<br>"+CRLF

				dbSelectArea("SF1")
				dbSetOrder(1)
				dbSeek(xFILIAL("SF1")+cNFiscal+cSerNF+cCliFor+cLoja+cTipoNf)
				If !SF1->(EOF())
					RecLock("SF1",.F.)
					SF1->F1_VALMERC := nValBrut
					SF1->F1_VALBRUT := nValBrut
					SF1->F1_CHVNFE  := cINFNEID
					SF1->F1_XNOMFOR := Posicione("SA2",1,xFilial("SA2")+cCliFor+cLoja,"A2_NOME")
					SF1->F1_NFMAE   := cnfmae
					SF1->F1_CONTRA  := xCONTRA
					SF1->F1_NAVIO   := xNAVIO
					SF1->F1_XPEDIDO := xPEDIDO
					SF1->F1_XSERMAE := cSERImae
					SF1->F1_XPERIOD := cPERIODO

					MsUnLock()
				Endif

				// Atualiza a chave da NFe nas tabelas fiscais geradas.
				dbSelectArea("SFT")
				dbSetOrder(1)
				If dbSeek(xFILIAL("SFT")+'E'+cSerNF+cNFiscal+cCliFor+cLoja)
					RecLock("SFT",.F.)
					SFT->FT_CHVNFE:=cINFNEID
					MsUnLock()
				EndIf

				//SF3
				dbSelectArea("SF3")
				dbSetOrder(5)
				dbSeek(xFilial("SF3")+cSerNF+cNFiscal+cCliFor+cLoja)
				Do While !SF3->(EOF())
					If SF3->F3_SERIE=cSerNF .AND. SF3->F3_NFISCAL=cNFiscal .AND. SF3->F3_CLIEFOR=cCliFor .AND. SF3->F3_LOJA=cLoja
						IF EMPTY(SF3->F3_CHVNFE)
							RecLock("SF3",.F.)
							SF3->F3_CHVNFE:=cINFNEID
							MsUnLock()
						ENDIF
					EndIf
					SF3->(dbSkip())
				EndDo

				//atualiza tabela SZD, tabela de retaguarda
				AtuSZD()

			EndIf
		EndIf
	End

	RestArea(aAreaFne)

Return lOk



/*/
    Funcao     | fProcNFS
    Descricao  | Gera pedido de venda e nota fiscal de saida a partir do arquivo de trabalho
    @param     | cFilReg   - filial de registro
    @param     | cTpMov    - tipo de movimento (NFS)
    @param     | cAliasTrb - alias da tabela de trabalho
    @param     | lOk       - flag de sucesso (por referencia)
    @return    | lOk - .T. se processado com sucesso
    @author    | M, Felipi
    @since     | 28/05/2026
/*/
Static Function fProcNFS(cFilReg,cTpMov,cAliasTrb,lOk)

	Local cFilSB1   := If( Empty(xFilial("SB1")) , Space(02) , cFilReg )
	Local cFilSB2   := If( Empty(xFilial("SB2")) , Space(02) , cFilReg )
	Local cFilSC5   := If( Empty(xFilial("SC5")) , Space(02) , cFilReg )
	Local cFilSC6   := If( Empty(xFilial("SC6")) , Space(02) , cFilReg )
	Local cFilSC9   := If( Empty(xFilial("SC9")) , Space(02) , cFilReg )
	Local cFilSE4   := If( Empty(xFilial("SE4")) , Space(02) , cFilReg )
	Local cFilSF2   := If( Empty(xFilial("SF2")) , Space(02) , cFilReg )
	Local cFilSF4   := If( Empty(xFilial("SF4")) , Space(02) , cFilReg )
	Local cFilSD1   := If( Empty(xFilial("SD1")) , Space(02) , cFilReg )
	Local cFilSF1   := If( Empty(xFilial("SF1")) , Space(02) , cFilReg )
	Local cchavetrb := ""
	Local aErros    := {}
	Local aCab      := {}
	Local aItem     := {}
	Local aPvlNfs   := {}
	Local cItem     := ""
	Local cNota     := ""
	Local cNFiscal  := ""
	Local cSerNf    := ""
	Local nErro     := 0
	Local aAreaFns  := GetArea()

	Private lMsErroAuto := .F.


	(cAliasTrb)->(dbSeek(cEmpAnt + cFilReg + cTpMov))
	While !(cAliasTrb)->(Eof()) .And. (cAliasTrb)->COD_EMP    == cEmpAnt ;
			.And. (cAliasTrb)->COD_FIL    == cFilReg ;
			.And. (cAliasTrb)->TP_MOVIMEN == cTpMov

		lErro    := .F.
		cItem    := StrZero(1,Len(SC6->C6_ITEM))
		cTipoNf  := (cAliasTrb)->TP_DE_NOTA
		cSerNf   := (cAliasTrb)->SERIE
		cNFiscal := (cAliasTrb)->NR_NFISCAL
		cEspecie := (cAliasTrb)->ESPECIE
		cCliFor  := (cAliasTrb)->CLI_FOR
		cLoja	 := (cAliasTrb)->LJ_CLI_FOR
		dEmissao := (cAliasTrb)->DT_EMISSAO
		dDtDigit := (cAliasTrb)->DT_ENTRADA
		cEstado  := (cAliasTrb)->ESTADO
		cCondPag := (cAliasTrb)->COND_PAG
		cNFOri	 := (cAliasTrb)->NF_COMPRA
		cSerOri	 := (cAliasTrb)->SERIE_COM
		cItemOri := SPACE(4) //"00" + (cAliasTrb)->ITEM_COM
		cProduto := (cAliasTrb)->COD_PROD

		nValMerc := 0
		nValBrut := 0
		aItem	   := {}
		ConOut( FunName()+" - Processando registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf )

		If AScan( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf ) > 0
			(cAliasTrb)->(DbSkip())
			Loop
		EndIf

		If cTipoNF $ "DB"
			cAliasCli := "SA2"
			cTipoCli  := "R"
			cEstCli   := SA2->A2_EST
		Else
			dbSelectArea( "SA1" )
			dbSetOrder( 01 )
			dbSeek( xFilial( "SA1" ) + cCLiFor + cLoja )

			cAliasCli := "SA1"
			cTipoCli  := SA1->A1_TIPO
			cEstCli   := SA1->A1_EST
		EndIf

		If !(cAliasCli)->(dbSeek(xFilial(cAliasCli)+cCliFor+cLoja))
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="Cliente/Fornecedor "+cCliFor+"/"+cLoja+" nao esta cadastrado!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf

		If cTipoNF $ "D"
			SF1->(dbSetOrder(1))
			If !SF1->(dbSeek(cFilSF1+cNFOri+cSerOri+cCliFor+cLoja,.T.))
				lOk   := .F.
				lErro := .T.
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFORI+"/"+cSerORI+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado, pois nao existe nf de entrada !<br>"+CRLF
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				(cAliasTrb)->(DbSkip())
				Loop
			EndIf
		Endif

		SF2->(dbSetOrder(1))
		If SF2->(dbSeek(cFilSF2+cNFiscal+cSerNf+cCliFor+cLoja))
			lOk   := .F.
			lErro := .T.
			cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado, pois ja existe no sistema!<br>"+CRLF
			AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
			(cAliasTrb)->(DbSkip())
			Loop
		EndIf

		*-----------------------------*
		* Geracao do pedido de vendas *
		*-----------------------------*
		dbSelectArea(cAliasTrb)
		cPedido := GetSx8Num("SC5","C5_NUM")
		SC5->(dbSetOrder(1))
		While SC5->(dbSeek(cFilReg+cPedido))
			rollbacksx8()
			cPedido := GetSx8Num("SC5","C5_NUM")
		End

		While !(cAliasTrb)->(Eof()) .And. (cAliasTrb)->COD_EMP    == cEmpAnt ;
				.And. (cAliasTrb)->COD_FIL    == cFilReg ;
				.And. (cAliasTrb)->TP_MOVIMEN == cTpMov ;
				.And. (cAliasTrb)->TP_DE_NOTA == cTipoNf ;
				.And. (cAliasTrb)->SERIE      == cSerNf  ;
				.And. (cAliasTrb)->NR_NFISCAL == cNFiscal;
				.And. (cAliasTrb)->ESPECIE    == cEspecie;
				.And. (cAliasTrb)->CLI_FOR    == cCliFor ;
				.And. (cAliasTrb)->LJ_CLI_FOR == cLoja

			If !lExcJob
				oProcess:IncRegua2()
			EndIf

			If !SB1->(dbSeek(cFilSB1+(cAliasTrb)->COD_PROD))
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="O Produto "+(cAliasTrb)->COD_PROD+" nao esta cadastrado!<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf

			If !SF4->(dbSeek(cFilSF4+(cAliasTrb)->TES))
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="A TES "+(cAliasTrb)->TES+" nao esta cadastrada!<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf

			If (cAliasTrb)->QUANTIDADE == 0
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="Quantidade nao informada!<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf
			If (cAliasTrb)->VLR_UNIT == 0
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="Valor Unitario nao informado!<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf

			If (cAliasTrb)->VLR_TOTAL == 0
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="Valor total nao informado!<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf

			If (cAliasTrb)->TP_DE_NOTA $ "D"
				CChaveTrb:= (cAliasTrb)->(NF_COMPRA + SERIE_COM + CLI_FOR + LJ_CLI_FOR + COD_PROD)
				SD1->(dbSetOrder(1))
				If !SD1->(dbSeek(cFilSD1 + CChaveTrb ,.T.))
					cBody+="O Registro " + CChaveTrb + " nao foi importado, pois nao existe nf de entrada !<br>"+CRLF
					AAdd( aErros , cFilReg+cChaveTrb )
					lOk   := .F.
					lErro := .T.
				else
					cItemOri := SD1->D1_ITEM
				EndIf
			Endif

			If !lErro

				cUM := If(Empty((cAliasTrb)->UNIDADE),SB1->B1_UM,(cAliasTrb)->UNIDADE)

				_cLocPad	:= SB1->B1_LOCPAD

				If SB1->B1_CONV<=1
					AAdd( aItem  	, {;
						{"C6_FILIAL" , cFilSC6                , Nil},;
						{"C6_ITEM"   , cItem                  , Nil},; // 02
						{"C6_PRODUTO", (cAliasTrb)->COD_PROD  , Nil},; // 03
						{"C6_DESCRI" , SB1->B1_DESC           , Nil},; // 04
						{"C6_UNSVEN" , (cAliasTrb)->QUANTIDADE, Nil},; // 06
						{"C6_PRCVEN" , (cAliasTrb)->VLR_UNIT  , Nil},; // 07
						{"C6_UM"     , cUM                    , Nil},; // 09
						{"C6_QTDVEN" , (cAliasTrb)->QUANTIDADE, Nil},; // 10
						{"C6_TES"    , (cAliasTrb)->TES       , Nil},; // 11
						{"C6_QTDLIB" , (cAliasTrb)->QUANTIDADE, Nil},; // 12
						{"C6_LOCAL"  , _cLocPad               , Nil},; // 15
						{"C6_CLI"    , (cAliasTrb)->CLI_FOR   , Nil},; // 19
						{"C6_DESCONT", (cAliasTrb)->DESC_PERC , Nil},; // 20
						{"C6_VALDESC", (cAliasTrb)->DESC_VALOR, Nil},; // 21
						{"C6_ENTREG" , (cAliasTrb)->DT_EMISSAO, Nil},; // 22
						{"C6_NFORI"  , (cAliasTrb)->NF_COMPRA , Nil},; // 22
						{"C6_SERIORI", (cAliasTrb)->SERIE_COM , Nil},; // 22
						{"C6_ITEMORI", cItemOri               , Nil},; // 22
						{"C6_LOJA"   , (cAliasTrb)->LJ_CLI_FOR, Nil},; // 24
						{"C6_NUM"    , cPedido                , Nil},; // 28
						{"C6_PRUNIT" , (cAliasTrb)->VLR_UNIT  , Nil},; // 35
						{"C6_OP"     , "02"                   , Nil},; // 39
						{"C6_TPOP"   , "F"                    , Nil}} ) // 67
				Else
					AAdd( aItem  	, {;
						{"C6_FILIAL" , cFilSC6                , Nil},;
						{"C6_ITEM"   , cItem                  , Nil},; // 02
						{"C6_PRODUTO", (cAliasTrb)->COD_PROD  , Nil},; // 03
						{"C6_DESCRI" , SB1->B1_DESC           , Nil},; // 04
						{"C6_SEGUM"  , cUM                    , Nil},; // 05
						{"C6_UNSVEN" , (cAliasTrb)->QUANTIDADE, Nil},; // 06
						{"C6_PRCVEN" , (cAliasTrb)->VLR_UNIT  , Nil},; // 07
						{"C6_UM"     , cUM                    , Nil},; // 09
						{"C6_QTDVEN" , (cAliasTrb)->QUANTIDADE, Nil},; // 10
						{"C6_TES"    , (cAliasTrb)->TES       , Nil},; // 11
						{"C6_QTDLIB" , (cAliasTrb)->QUANTIDADE, Nil},; // 12
						{"C6_LOCAL"  , _cLocPad               , Nil},; // 15
						{"C6_CLI"    , (cAliasTrb)->CLI_FOR   , Nil},; // 19
						{"C6_DESCONT", (cAliasTrb)->DESC_PERC , Nil},; // 20
						{"C6_VALDESC", (cAliasTrb)->DESC_VALOR, Nil},; // 21
						{"C6_ENTREG" , (cAliasTrb)->DT_EMISSAO, Nil},; // 22
						{"C6_NFORI"  , (cAliasTrb)->NF_COMPRA , Nil},; // 22
						{"C6_SERIORI", (cAliasTrb)->SERIE_COM , Nil},; // 22
						{"C6_ITEMORI", cItemOri               , Nil},; // 22
						{"C6_LOJA"   , (cAliasTrb)->LJ_CLI_FOR, Nil},; // 24
						{"C6_NUM"    , cPedido                , Nil},; // 28
						{"C6_PRUNIT" , (cAliasTrb)->VLR_UNIT  , Nil},; // 35
						{"C6_OP"     , "02"                   , Nil},; // 39
						{"C6_TPOP"   , "F"                    , Nil}} ) // 67
				Endif

				cItem := Soma1(cItem,Len(SC6->C6_ITEM))
			EndIf
			(cAliasTrb)->(DbSkip())
		End

		If lErro
			rollbacksx8()
			DisarmTransaction()
			Loop
		EndIf

		// alterado Davi Jesus
		aCab := {;
			{"C5_FILIAL" , cFilSC5 , Nil},;
			{"C5_NUM"    , cPedido , Nil},;
			{"C5_TIPO"   , cTipoNF , Nil},;
			{"C5_CLIENTE", cCliFor , Nil},;
			{"C5_LOJAENT", cLoja   , Nil},;
			{"C5_LOJACLI", cLoja   , Nil},;
			{"C5_CONDPAG", cCondPag, Nil},; // 15
			{"C5_TIPLIB" , "1"     , Nil},; // 21
			{"C5_TIPOCLI", cTipoCli, Nil},; // 28
			{"C5_EMISSAO", dEmissao, Nil},; // 40
			{"C5_MOEDA"  , 1       , Nil},; // 53
			{"C5_LIBEROK", "S"     , Nil}}  // 71

		RegToMemory("SC5")
		M->C5_FILIAL := cFilSC5

		RegToMemory("SC6")
		M->C6_FILIAL := cFilSC6

		lMsErroAuto := .F.
		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItem,3)
		If lMsErroAuto
			rollbacksx8()
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			aErros := GetAutoGrLog()
			For nErro := 1 To Len(aErros)
				cBody+= aErros[nErro]+"<br>"+CRLF
			Next nErro
			cBody+="<br>"+CRLF
			DisarmTransaction()
		Else
			confirmsx8()
			cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" foi gerado o pedido "+cPedido+" com sucesso!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		dbSelectArea(cAliasTrb)

		If lErro
			Loop
		EndIf

		*------------------------------*
		* Liberacao do pedido de venda *
		*------------------------------*
		SC5->(dbSetOrder(1))
		SC6->(dbSetOrder(1))
		SE4->(dbSetOrder(1))
		SB1->(dbSetOrder(1))
		SB2->(dbSetOrder(1))
		SF4->(dbSetOrder(1))

		*--------------------------------------*
		* Define Variaveis usados pelo MATA440 *
		*--------------------------------------*
		lGerouPv 	:= .T.
		lLiber   	:= .T.
		lTrans   	:= .F.
		lCredito 	:= .F.
		lEstoque 	:= .F.
		lAvCred  	:= .T.
		lAvEst   	:= .T.
		lLiberOk 	:= .T.
		lItLib   	:= .T.
		aPvlNfs  	:= {}
		DDATABASE	:= dEmissao
		dbSelectArea(cAliasTrb)

		*-----------------------------*
		* Efetua a Liberacao por item *
		*-----------------------------*
		SC5->(dbSeek(cFilSC5+cPedido))
		SC6->(dbSeek(cFilSC6+cPedido))
		While !SC6->(Eof()) .And. SC6->C6_FILIAL == cFilSC6 .And. SC6->C6_NUM  == cPedido

			nQtdLib := SC6->C6_QTDVEN

			*----------------------------------------------*
			* Posiciona registros para efetuar a liberacao *
			*----------------------------------------------*
			SB1->(dbSeek(cFilSB1+SC6->C6_PRODUTO))

			nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdLib,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTrans)

			If nQtdLib != SC6->C6_QTDVEN
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lGerouPv := .F.
				lOk      := .F.
				lErro    := .T.
				cBody+="Nao foi possivel liberar o Produto "+Trim(SC6->C6_PRODUTO)+"!<br>"+CRLF
				cBody+="<br>"+CRLF
				DisarmTransaction()
				Exit
			EndIf

			SC9->( dbSetOrder(1) )
			IF SC9->(dbSeek(cFilSC9+SC6->C6_NUM+SC6->C6_ITEM))

				SC9->(RecLock("SC9",.F.))
				SC9->C9_BLEST  := ""
				SC9->C9_BLCRED := ""
				SC9->C9_DTENTR := DDATABASE

			ELSE

				SC9->(RecLock("SC9",.T.))
				SC9->C9_BLEST   := ""
				SC9->C9_BLCRED  := ""
				SC9->C9_DTENTR  := DDATABASE
				SC9->C9_FILIAL  := XFILIAL("SC9")
				SC9->C9_PEDIDO  := SC6->C6_NUM
				SC9->C9_ITEM    := SC6->C6_ITEM
				SC9->C9_CLIENTE := SC6->C6_CLI
				SC9->C9_LOJA    := SC6->C6_LOJA
				SC9->C9_PRODUTO := SC6->C6_PRODUTO
				SC9->C9_DATALIB := dDataBase
				SC9->C9_PRCVEN  := SC6->C6_PRCVEN
				SC9->C9_BLEST   := "10"
				SC9->C9_BLCRED  := "10"
				SC9->C9_Local   := SC6->C6_LOCAL
				SC9->C9_QTDLIB  := SC6->C6_QTDVEN

			ENDIF

			SC9->(MsUnLock())

			SE4->(dbSeek(cFilSE4+SC5->C5_CONDPAG) )
			SB1->(dbSeek(cFilSB1+SC6->C6_PRODUTO) )
			SB2->(dbSeek(cFilSB2+SC6->C6_PRODUTO+SC6->C6_LOCAL) )
			SF4->(dbSeek(cFilSF4+SC6->C6_TES) )

			Aadd(aPvlnfs, { SC9->C9_PEDIDO  ,;
				SC9->C9_ITEM    ,;
				SC9->C9_SEQUEN  ,;
				SC9->C9_QTDLIB  ,;
				SC9->C9_PRCVEN  ,;
				SC9->C9_PRODUTO ,;
				SF4->F4_ISS=="S",;
				SC9->(RecNo())  ,;
				SC5->(RecNo())  ,;
				SC6->(RecNo())  ,;
				SE4->(RecNo())  ,;
				SB1->(RecNo())  ,;
				SB2->(RecNo())  ,;
				SF4->(RecNo())  ,;
				SC9->C9_Local   })

			SC6->(DbSkip())
		End
		dbSelectArea(cAliasTrb)

		*---------------------------------*
		* Geracao da nota fiscal de saida *
		*---------------------------------*
		If lGerouPv .And. Len(aPvlnfs) > 0
			Pergunte("MT461A",.f.)

			lMostraCtb   	:= .F.
			lAglutCtb    	:= .F.
			lCtbOnLine   	:= .F.
			lCtbCusto    	:= .F.
			lReajuste    	:= .F.
			nCalAcrs     	:= 0
			nArredPrcLis 	:= 0
			lAtuSA7      	:= .F.
			lECF         	:= .F.

			cNota := MaPvlNfs(aPvlNfs,"XML",lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajuste,nCalAcrs,nArredPrcLis,lAtuSA7,lECF)

			If !Empty(cNota) .And. cNota != cNFiscal
				cBody += "NF de saida gerada com numero diferente do XML: " + cNFiscal + ;
					" -> " + cNota + "<br>" + CRLF
				cBody += "<br>" + CRLF
				cNFiscal := cNota
			EndIf

			If Empty(cNota) .Or. !SF2->(dbSeek(cFilSF2+cNota+cSerNf+cCliFor+cLoja))
				If !lErro
					AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
					cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
					cBody+="Erros :<br>"+CRLF
				EndIf
				lOk   := .F.
				lErro := .T.
				cBody+="Nao foi possivel gerar a nota fiscal de saida "+cSerNf+"-"+cNFiscal+" !<br>"+CRLF
				cBody+="<br>"+CRLF
			Else
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" foi gerado a NF "+cSerNf+"/"+cNota+" com sucesso!<br>"+CRLF
				cBody+="<br>"+CRLF
			EndIf
		EndIf

	End

	RestArea(aAreaFns)

Return lOk



/*/
    Funcao     | fRet
    Descricao  | Helper dinamico para acesso a campos do XML parser
    @param     | oXml      - objeto XML parser
    @param     | cAliasXml - alias da secao XML
    @param     | cItemXml  - sub-item da secao
    @param     | nItemXml  - indice do array (opcional)
    @param     | cVarXml   - campo/variable a acessar
    @param     | cFuncao   - funcao a aplicar (opcional)
    @return    | Valor do campo XML (dinamico via macro &)
    @author    | M, Felipi
    @since     | 28/05/2026
/*/
Static Function fRet(oXml,cAliasXml,cItemXml,nItemXml,cVarXml,cFuncao)

	Local xRet, lIsArray

	cAliasXml := If(cAliasXml==Nil,"",If(Left(cAliasXml,1)!="_","_","") + cAliasXml)
	cItemXml  := If(cItemXml ==Nil,"",If(Left(cItemXml ,1)!="_","_","") + cItemXml)
	nItemXml  := If(nItemXml ==Nil,"",AllTrim(Str(nItemXml)))
	cVarXml   := If(cVarXml  ==Nil,"",If(Left(cVarXml  ,1)!="_","_","") + cVarXml)
	cFuncao   := If(cFuncao  ==Nil,"",cFuncao)

	xRet := "oXml:"+cAliasXml + If(!Empty(cItemXml),":"+cItemXml    ,"")

	lIsArray := ValType(&xRet) == "A"

	If lIsArray
		xRet += If(!Empty(nItemXml),"["+nItemXml+"]","")
	EndIf

	xRet += If(!Empty(cVarXml) ,":"+cVarXml ,"") + If(Empty(cFuncao) ,":TEXT" ,"")

	If lIsArray
		xRet := If(!Empty(cFuncao),cFuncao+"(","") + xRet + If(!Empty(cFuncao),")","")
	Else
		If !Empty(cFuncao)
			xRet := "1"
		EndIf
	EndIf

Return &xRet



/*/
    Funcao     | fCfop
    Descricao  | Retorna o CFOP adequado com base na TES, tipo de cliente e estado
    @param     | cFilSF4   - filial da TES (SF4)
    @param     | cTes      - codigo da TES
    @param     | cTipoCli  - tipo do cliente
    @param     | cEstCli   - estado do cliente
    @return    | cRet - CFOP calculado
    @author    | M, Felipi
    @since     | 28/05/2026
/*/
Static Function fCfop(cFilSF4,cTes,cTipoCli,cEstCli)

	Local aAreaSF4 := SF4->(GetArea())
	Local cRet     := ""

	SF4->(dbSetOrder(1))
	If SF4->(dbSeek(cFilSF4+cTES,.F.))
		If SF4->F4_CODIGO >= "500"
			cRet := If(cTipoCli != "X",If(cEstCli == AllTrim(GetMv("MV_ESTADO")),SF4->F4_CF,"6"+;
				Subs(SF4->F4_CF,2,Len(SF4->F4_CF)-1)),"7"+Subs(SF4->F4_CF,2,Len(SF4->F4_CF)-1))
		Else
			cRet := If(cTipoCli != "X",If(cEstCli == AllTrim(GetMv("MV_ESTADO")),SF4->F4_CF,"2"+;
				Subs(SF4->F4_CF,2,Len(SF4->F4_CF)-1)),"3"+Subs(SF4->F4_CF,2,Len(SF4->F4_CF)-1))
		endif
	Endif
	RestArea(aAreaSF4)

Return cRet



/*/
    Funcao     | _CONVDTSPED
    Descricao  | Converte data do formato SPED (AAAAMMDD) para Date
    @param     | cData - data no formato AAAAMMDD
    @return    | dData - data convertida (tipo Date)
    @author    | M, Felipi
    @since     | 28/05/2026
/*/
Static Function _CONVDTSPED(cData)

	Local dData := Nil

	dData := CtoD(SubStr(cData, 9, 2) + "/" + SubStr(cData, 6, 2) + "/" + SubStr(cData, 1, 4))

Return dData



/*/
    Funcao     | LEINFCPL
    Descricao  | Exibe dialog para informar nota mae/contrato complementares
    @param     | xcmemo    - texto do campo infComplementar do XML
    @param     | cnfmae    - nota fiscal mae (por referencia)
    @param     | cSERImae  - serie da nota mae (por referencia)
    @param     | cCONTRA   - contrato (por referencia)
    @param     | cPERIODO  - periodo (por referencia)
    @param     | cCNPJFor  - CNPJ do fornecedor para validacao
    @return    | lRet - .T. se informado com sucesso
    @author    | M, Felipi
    @since     | 28/05/2026
/*/
Static Function LEINFCPL(xcmemo, cnfmae, cSERImae, cCONTRA, cPERIODO, cCNPJFor)

	Local oDlg, oMemo, cMemo := ""
	Local XCONTRAT := PADR(ALLTRIM(cTContra),TAMSX3("Z3_CONTRA")[1])
	Local XCPER    := PADR(ALLTRIM(cTDP),TAMSX3("Z3_PERIODO")[1])

	Local XCnf     := SPACE(9)
	Local XCseri   := SPACE(3)
	Local nOpc     := 0
	Local LRET     := .T.
	Local aArea    := GetArea()

	dbSelectArea("SZ3")
	dbSetOrder(1)
	dbSeek(xFilial("SZ3")+XCONTRAT+XCPER)

	cMemo := xcmemo

	DEFINE MSDIALOG oDlg TITLE "Informações complementares" From 000,000 TO 350,550 PIXEL
	@ 005,005 GET oMemo  VAR cMemo MEMO SIZE 150,150 OF oDlg PIXEL
	oMemo:bRClicked := {||.F.}//{||AllwaysTrue()}
	@ 001,020 SAY "Contrato:"
	@ 010,190 MSGET SZ3->Z3_CONTRA Picture PesqPict("SZ3","Z3_CONTRA") Size 70,10  F3 "SZ3" OF oDlg PIXEL //Valid (fValidaFor(cCNPJFor,XCONTRAT),XCnf:=SPACE(9),If(!Empty(XCPER),XCPER,Space(10)),dlgRefresh(oDlg)) OF oDlg PIXEL

	@ 003,020 SAY "Período:"
	@ 040,190 MSGET SZ3->Z3_PERIODO Picture PesqPict("SZ3","Z3_PERIODO") When .f. OF oDlg PIXEL

	@ 005,020 SAY "Nfiscal:"
	@ 065,190 MSGET XCnf Picture PesqPict("SF1","F1_DOC") OF oDlg PIXEL

	@ 007,020 SAY "Serie:"
	@ 095,190 MSGET XCSeri Picture PesqPict("SF1","F1_SERIE") OF oDlg PIXEL

	@ 009,020 SAY "Pedido:"
	@ 115,190 MSGET XPedido Picture PesqPict("SF1","F1_XPEDIDO") F3 "SC7_CZ" Valid (!Empty(XPedido)) OF oDlg PIXEL

	DEFINE SBUTTON  FROM 160,010 TYPE 1 ACTION (nOpc == 1,LRET:=.T.,oDlg:End()) ENABLE OF oDlg PIXEL
	DEFINE SBUTTON  FROM 160,040 TYPE 2 ACTION (nOpc == 0,LRET:=.F.,oDlg:End()) ENABLE OF oDlg PIXEL

	ACTIVATE MSDIALOG oDlg CENTER

	If nOpc == 0

		cnfmae   := iif(EMPTY(XCnf),"",PADR(ALLTRIM(XCnf),TAMSX3("F1_DOC")[1]) )
		cSERImae := iif(EMPTY(XCSeri),"",PADR(ALLTRIM(XCSeri),TAMSX3("F1_SERIE")[1]) )

		cCONTRA := iif(EMPTY(XCONTRAT),"",PADR(ALLTRIM(XCONTRAT),TAMSX3("Z3_CONTRA")[1]) )
		cPERIODO := iif(EMPTY(SZ3->Z3_PERIODO),"",PADR(ALLTRIM(SZ3->Z3_PERIODO),TAMSX3("Z3_PERIODO")[1]) )

		IF !EMPTY(cnfmae) .AND. !ExistChav("SZ3", xFilial("SZ3") + cCONTRA + cPERIODO)
			LRET := .F.
		ENDIF

		IF !EMPTY(cCONTRA) .AND.  !ExistChav("SF1", xFilial("SF1") + cnfmae + cSERImae + SA2->A2_COD + SA2->A2_LOJA)
			LRET := .F.
		ENDIF

		IF EMPTY(cnfmae)
			LRET := .F.
		ENDIF

		xContra := cCONTRA
		xPeriod := cPERIODO

	ENDIF

	RestArea(aArea)

Return lRet



/*/
    Funcao     | AtuSZD
    Descricao  | Atualiza tabela de retaguarda SZD com dados da NF remessa processada
    @author    | M, Felipi
    @since     | 28/05/2026
/*/
Static Function AtuSZD()

	Local aAreaSzd := GetArea()

	dbSelectArea("SZD")
	dbSetOrder(1)

	If dbSeek(xFilial("SZD")+cCONTRA+cPERIODO+cnfmae+cSERImae+cNFiscal+cSerie)
		If SZD->ZD_STATUS == "EX"
			RecLock("SZD",.f.)
			Delete
			MsUnLock()
		EndIf
	EndIf

	RecLock("SZD",.T.)

	SZD->ZD_FILIAL 		:= 	XFILIAL("SZD")
	SZD->ZD_CONTRA 		:= 	cCONTRA
	SZD->ZD_PERIODO 	:= 	cPERIODO
	SZD->ZD_NFMAE 		:= 	cnfmae
	SZD->ZD_SERIEM 		:= 	cSERImae
	SZD->ZD_NFREMES 	:= 	cNFiscal
	SZD->ZD_SERIER 		:= 	cSerie
	SZD->ZD_QTDNFRE 	:= 	XQTDREM
	SZD->ZD_QTDMAE 		:= 	XQTDMAE
	SZD->ZD_SALDO 		:= 	XQTDREM
	SZD->ZD_PEDIDOC 	:= 	xPedido
	SZD->ZD_STATUS 		:= 	"AT"
	SZD->ZD_PARC 		:= 	"01"
	SZD->ZD_CNPJUSI 	:=	XCNPJ
	SZD->ZD_NUSINA 		:=	XNOMFOR
	SZD->ZD_EMISREM		:=	SF1->F1_EMISSAO
	SZD->ZD_UM			:=	SB1->B1_UM
	SZD->ZD_VLRNFRE		:=	SF1->F1_VALBRUT
	SZD->ZD_VLRMAE		:=	nVlrMae
	("SZD")->(MsUnLock())

	RestArea(aAreaSzd)

Return



/*/
    Funcao     | fValidaFor
    Descricao  | Valida se o contrato pertence ao fornecedor da NF
    @param     | cCNPJ   - CNPJ do fornecedor
    @param     | cContra - contrato a validar
    @return    | lRet - .T. se contrato valido para o fornecedor
    @author    | M, Felipi
    @since     | 28/05/2026
/*/
Static Function fValidaFor(cCNPJ,cContra)

	Local lRet     := .T.
	Local cQuery3  := ""
	Local aAreaVal := GetArea()

	SA2->(dbSetOrder(3))
	SA2->(dbSeek(xFilial("SA2")+cCNPJ))
	If Select("TMPCNC") > 0
		DbSelectArea("TMPCNC")
		("TMPCNC")->( DbCloseArea() )
	EndIf

	cQuery3 := "SELECT * FROM "+RetSQLName("CNC")+" CNC "
	cQuery3 += "WHERE CNC_FILIAL='"+xFilial("CNC")+"' "
	cQuery3 += "AND CNC_NUMERO='"+cContra+"' "
	cQuery3 += "AND CNC_CODIGO='"+SA2->A2_COD+"' "
	cQuery3 += "AND CNC_LOJA='"+SA2->A2_LOJA+"' "
	cQuery3 += "AND CNC.D_E_L_E_T_ = ' ' "
	cQuery3 := ChangeQuery(cQuery3)
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery3), "TMPCNC", .T., .T.)

	DbSelectArea("TMPCNC")
	("TMPCNC")->(dbGoTop())

	If !("TMPCNC")->(Eof())

		If SA2->A2_COD <> ("TMPCNC")->CNC_CODIGO .OR. SA2->A2_LOJA <> ("TMPCNC")->CNC_LOJA
			Aviso("Aviso","O Contrato selecionado não foi criado para o fornecedor/loja desta Nota Fiscal !",{"Voltar"})
			lRet := .F.
		EndIf

	Else

		Aviso("Aviso","O Contrato selecionado não foi criado para o fornecedor/loja desta Nota Fiscal !",{"Voltar"})
		lRet := .F.

	EndIf

	If Select("TMPCNC") > 0
		DbSelectArea("TMPCNC")
		("TMPCNC")->( DbCloseArea() )
	EndIf

	RestArea(aAreaVal)

Return lRet



/*/{Protheus.doc} arrumaNumNF
Função responsável por arrumar o número da nota fiscal, retirando o sufixo e adicionando zeros à esquerda, caso necessário.
@type function
@version
@author Marcos Aleluia
@since 7/10/2026
@param cNumNota, character, param_description
@return variant, return_description
/*/
static function arrumaNumNF(cNumNota,cXSerie)

	Local aRet          := {"",""}
	Local nPosFinalNota := 0

	Default cNumNota    := ""
	Default cXSerie    := ""

	if ! empty(cNumNota)
		cNumNota      := AllTrim(cNumNota)
		nPosFinalNota := at("-", cNumNota) - 1
		aRet[1]       := Left(cNumNota, nPosFinalNota)
		aRet[1]       := PADL(aRet[1],TAMSX3("F1_DOC")[1],"0")
		if ! empty(cXSerie)
			aRet[2] := Right(cNumNota, Len(cNumNota) - at("-", cNumNota))
			aRet[2] := PADR(aRet[2],TAMSX3("F1_SERIE")[1])
		else
			aRet[2] := cXSerie
		endif
	endif

return(aRet)
