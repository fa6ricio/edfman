#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ COMXPROCºAutor  ³Luis Felipe Nascimento ³Data ³  31/03/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada utilizado para validação da geração de    º±±
±±º          ³ Documentos via TOTVS Colaboração.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFinalidade³ Checar o tipo de documento através da leitura do arquivo   º±±
±±º          ³ xml, onde o CFOP ?922 será NF Mae e o CFOP ?501 remessa.   º±±
±±º          ³ Se NF Mae : chama rotina de classificação PRENFE           º±±
±±º          ³ Se Remessa: Pesquisa documento através da chave do arqui-  º±±
±±º          ³ vo DS_ARQUIVO                                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                  ³Data ³  07/12/16  º±±
±±º          ³ Pesquisa automática do número do contrato nos dados adicio-º±±
±±º          ³ nais da NF.                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COMXPROC(__NFISCAL)

	Local cErro      := ""
	Local cAviso     := ""
	Local lRet       := .T.
	Local oXML
	Local aArea      := GetArea()
	Local cXML       := ""
	Local cCFOP      := ''
	Local cProd      := ''
	Local n_tam_det  := 0
	Local cAdic      := ''
	Local cContra    := 'P'
	Local lContra    := .f.
	Local lAchou     := .f.
	Local cDp        := ''
	Local nx         := 0
	Local cContraPad := "" //GetNewPar("MV_XCONPAD","")

	Private cContrato   := ''
	Private cTexto      := ""
	Private cEncodeUTF8 := ""
	Private cDecodeUTF8 := ""
	Private cMensagem   := ""
	Private cArquiv     := ""

	Public __NFISCAL   := Space(9)
	Public __TIPONF    := Space(1)
	Public _cDifPCxNFE := ''
		
	If Type("__aXML")== "U"
		Public __aXML  :=  {}
	EndIf

	CKO->(DbSetOrder(1))

	If !CKO->(DbSeek(PadR(SDS->DS_ARQUIVO, FWSX3Util():GetFieldStruct("CKO_ARQUIV")[3])))
		ApMsgStop("ID de conversão " + AllTrim(SDS->DS_ARQUIVO) + " não localizado na tabela CKO.", "COMXPROC")
		Return .F.
	EndIf	
	
	If Empty(CKO->CKO_ARQXML)
		cXML := CKO->CKO_ARQUIV
	Else
		cXML := CKO->CKO_ARQXML
	EndIf

	cXML := RetFileName(AllTrim(cXML))
	nPos := aScan(__aXML, {|x| Alltrim(x[1]) == Alltrim(cXML)})

	If  nPos == 0
		
		Aadd(__aXML,{cXML})
	
		If __NFISCAL == SDS->DS_DOC
			__NFISCAL := Nil
			Return .t.
		Else
			__NFISCAL := SDS->DS_DOC
		EndIf

		DBSelectArea("SA2")
		SA2->(DbSetOrder(3))
		SA2->(DbSeek(xFilial("SA2")+SDS->DS_CNPJ))
		
		If Alltrim(FunName()) <> 'COMXCOL' .or. !SA2->A2_XDESCGR $ '000003/000008' .or. !SDS->DS_TIPO $ 'N/C'
			RestArea(aArea)
			Return( lRet )
		EndIf
		
		oXML := XMLParser(CKO->CKO_XMLRET, "_",@cErro,@cAviso)

		If !( Empty(cErro) .And. Empty(cAviso) .And. oXml <> Nil)
			If	!Empty(cErro)
				ApMsgStop(cErro)
			Else  
				ApMsgStop("Documento inexistente sobre a pasta Neogrid ! ")
			EndIf
			Return(.f.)
		EndIf

		// 05/12/16 - Luis Felipe - Inicio

		If valtype(oxml:_NFEPROC:_NFE:_INFNFE:_DET) == 'A'
			n_tam_det := LEN(oxml:_NFEPROC:_NFE:_INFNFE:_DET)
		Else
			n_tam_det := 1
		Endif

		cProd := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[1]:_PROD:_CPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT)
		
		lCtr := .f.
		if AttIsMemberOf( oXML:_NFEPROC:_NFE:_INFNFE:_INFADIC, "_INFCPL") .OR. AttIsMemberOf( oXML:_NFEPROC:_NFE:_INFNFE:_INFADIC, "_INFADFISCO")
			IF AttIsMemberOf( oXML:_NFEPROC:_NFE:_INFNFE:_INFADIC, "_INFCPL")
				cAdic += oXML:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT
			ENDIF
			IF AttIsMemberOf( oXML:_NFEPROC:_NFE:_INFNFE:_INFADIC, "_INFADFISCO")
				cAdic += oXML:_NFEPROC:_NFE:_INFNFE:_INFADIC:_INFADFISCO:TEXT
			ENDIF
			For nx:=1 to Len(cAdic)
				If !lAchou
					If Substr(cAdic,nx,4) $ ("CTR:|CTR ") .and. !lAchou 
						nx += 4
						lAchou := .t.
					ElseIf Substr(cAdic,nx,9) $ ("CONTRATO:|CONTRATO ") .and. !lAchou 
						nx += 9
						lAchou := .t.
					ElseIf Substr(cAdic,nx,1) == "P" .and. Substr(cAdic,nx+1,1) $ "0123456789"
						lAchou := .t.
					EndIf
				Else
					If !Substr(cAdic,nx,1) $ 'P:' 
						If Substr(cAdic,nx,1) <> ' ' 
							If Substr(cAdic,nx,1) <> '-' .and. !lContra
								cContra += Substr(cAdic,nx,1)              
							Else
								lContra := .t.
								If !Substr(cAdic,nx,1) $ ',- ' 
									cDp += Substr(cAdic,nx,1)
									If Len(cDp) == 3             
										Exit
									EndIf
								EndIf	
							EndIf	
						Else
							If Len(cContra) > 4
								If Len(cDp) == 3 
									Exit
								Else 
									lContra := .t.
								EndIf	
							EndIf	
						EndIf  
					EndIf
				EndIf
			Next  
			//caso não encontre o contrato, deverá informar aqui o código do produto que deverá ser usado na importação
			cContrato := PadR(cContra +'-'+ cDP, TamSX3("B1_COD")[1])
			SB1->(DbSetOrder(1))
			If !SB1->(DbSeek(xFilial("SB1")+cContrato))
				if !empty(cContraPad)
					if !FWAlertYesNo("Deseja utilizar o contrato padrão "+cContraPad+" ?", "ATENÇÃO!")
						cContrato := cContraPad
					endif
				endif
				if empty(cContrato) .OR. !SB1->(DbSeek(xFilial("SB1")+cContrato))
					cContrato := AllTrim(ValidPerg())
					cContraPad := cContrato
				endif
			Endif

			If !empty(cContrato) .AND. SB1->(DbSeek(xFilial("SB1")+cContrato))
				SDT->(DbSetOrder(1))
				If SDT->(DbSeek(xFilial("SDT")+SDS->(DS_CNPJ+DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)))
					RecLock("SDT",.F.)
					SDT->DT_COD := cContrato
					Msunlock()
					SA5->(DbSetOrder(14))
					If SA5->(DbSeek(xFilial("SA5")+SDT->(DT_FORNEC+DT_LOJA)+cProd))
						SA5->(RecLock("SA5",.F.))
						SA5->A5_PRODUTO := cContrato
						Msunlock()
					Else
						SA2->(DbSetOrder(3))
						If SA2->(DbSeek(xFilial("SA2")+SDS->DS_CNPJ))
							SA5->(RecLock("SA5",.t.))
							SA5->A5_FILIAL	:= xFilial("SA5")
							SA5->A5_FORNECE	:= SDS->DS_FORNEC
							SA5->A5_LOJA 	:= SDS->DS_LOJA
							SA5->A5_NOMEFOR := SA2->A2_NOME
							SA5->A5_NOMPROD := SB1->B1_DESC
							SA5->A5_CODPRF	:= cProd
							SA5->A5_PRODUTO := cContrato
							Msunlock()
						EndIf
					EndIf
				EndIf
			Else
				ApMsgStop("Falta cadastrar o produto do contrato: "+cContrato)
			EndIf
		EndIf
		// 05/12/16 - Luis Felipe - Fim
		
		If AttIsMemberOf( oXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD, "_CFOP")
			cCFOP := SubStr(Alltrim(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT),2,3)
		Else
			ApMsgStop("Tag do CFOP inexistente !")
			Return(.f.)
		EndIf
		
		If	SDS->DS_TIPO == 'N'
			If	cCFOP $ "501|502" // NF Remessa 24/03/17 - Luis Felipe
				MemoWrite("\xml\nf_remessa\" + Lower(cXML) + ".xml", CKO->CKO_XMLRET)
				lRet := u_LXmlRem(cXML,cContra,cDP)
				If	lRet
					RecLock("SDS",.F.)
					SDS->DS_STATUS:= 'P'
					Msunlock()
					lRet := .f.
				EndIf
				If !Empty(_cDifPCxNFE)
					Alert(_cDifPCxNFE)
					_cDifPCxNFE := Nil
				EndIf
			ElseIf cCFOP == "922" // NF Mae
				__TipoNF := "M"
			EndIf
		EndIf
	Else	
		lRet := .f.
	EndIf

	RestArea(aArea)

Return( lRet )



/*/{Protheus.doc} ValidPerg
Função responsável por validar o número do contrato, caso não seja encontrado, será solicitado ao usuário que informe o mesmo.
@type function
@version  
@author 
@since 7/10/2026
@return variant, return_description
/*/
Static Function ValidPerg()

	Local aPergs  := {} As Array
	Local cContra := Space(TamSX3("B1_COD")[01]) As Character
	Local cRet    := "" As Character
	
	aAdd(aPergs, {1, "Número do Contrato",  cContra, "", ".T.", "SB1", ".T.", 80,  .F.})
	
	If ParamBox(aPergs, "Informe o número do contrato:")
		cRet := MV_PAR01
	EndIf

Return(cRet)
