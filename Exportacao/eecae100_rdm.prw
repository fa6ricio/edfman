#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EecAe100ºAutor  ³Luis Felipe Nascimento ³Data ³  15/04/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EDFV001                                                    º±±
±±º          ³ Executado a partir do campo Z6_PRICING                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                         08/04/2015  º±±
±±º          ³ Recalculo do preço final a partir da confirmação da        º±±
±±º          ³ polarização nos embarques (FECHAMENTO_EMBARQUE).           º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
Função......: EecAe100()
Parametros..: Nenhum
Retorno.....: Nil
Objetivo....: Ponto de entrada do programa EECAE100, antes de chamar a função MBrouse.
Autor.......: Julio de Paula Paz
Data/Hora...: 03/08/2012 - 10:00
Observação..:
*/
*********************************
User Function EecAe100()
	*********************************
	Local lRet := .T., cParam := If(Type("PARAMIXB")== "A",ParamIxb[1],ParamIxb)
	Local aOrd := SaveOrd({"ZZ1"})
	Local cProcesso
	Local nPos := 0
	Local aContrato := {}
	Local aArea:= GetArea()
	Local aAreaEE9:= EE9->(GetArea())

	*** Luiz Fernando - 04/05/2015
	*********************************
	Local cEmbEEC    := EEC->EEC_PREEMB
	Local xFilialEEC := EEC->EEC_FILIAL
	Local cPedEECCapa:= xFilial("EE9")+Substr(EE9->EE9_PEDIDO,1,6)
	Local nPESLIQ :=nPESBRU:=nTotVOLUME1:=nVOLUME1:= 0
	Local cESPECI1:=cReEEC:=cSDEEC:=""
	Local nX
	Private nTotPESLIQ := 0
	Private nTotPESBRU := 0

	//12-01-2026 - Thiago Reis
	EE9->(DbSetOrder(2))
	EE9->(Dbseek(xFilial("EE9")+EEC->EEC_PREEMB)) //EE9_FILIAL+EE9_PREEMB

	if Posicione("SB1",1,xFilial("SB1")+AllTrim(EE9->EE9_COD_I),"B1_XCONTCT") == "2" //2-Não
		
		RestArea(aArea)
		RestArea(aAreaEE9)
		Return lRet
	endif

	//

	Begin Sequence

		Do Case

		Case cParam == "PE_EXC"
			If nRadio == 2 // Exclusão física do processo.
				cProcesso := ParamIxb[2]
				ZZ1->(DbSetOrder(1))
				ZZ1->(DbSeek(xFilial("ZZ1")+cProcesso))
				While ! ZZ1->(Eof()) .And. ZZ1->(ZZ1_FILIAL+ZZ1_PREEMB) == xFilial("ZZ1")+cProcesso
					ZZ1->(RecLock("ZZ1",.F.))
					ZZ1->(DbDelete())
					ZZ1->(MsUnlock())
					ZZ1->(DbSkip())
				End
				RestOrd(aOrd)
			EndIf

		Case cParam == "FECHAMENTO_EMBARQUE" // .and. EEC->EEC_STATUS == "6" // 27/03/17 - Luis Felipe

			EE9->(DbSetOrder(2))
			EE9->(Dbseek(xFilial("EE9")+EEC->EEC_PREEMB))

			cPREEMB := EEC->EEC_PREEMB
			xFilial := EEC->EEC_FILIAL

			While cPREEMB == EE9->EE9_PREEMB .and. xFilial == EE9->EE9_FILIAL .and. EE9->(!Eof())

				If Select("TMPEE9")>0
					dbSelectArea("TMPEE9")
					("TMPEE9")->(dbCloseArea())
				EndIf

				nPos := AScan(aContrato, {|x| x[1] == EE9->EE9_COD_I})
				If	nPos == 0
					AAdd(aContrato,{EE9->EE9_COD_I})
					cQuery := "SELECT EE9_FILIAL, EE9_PREEMB, EE9_PEDIDO, EE9_COD_I, EE9_QTDEM1, EE8_XPOLDP "
					cQuery += "FROM "+RetSqlName("EE9") + " EE9, "+RetSqlName("EEC") + " EEC, "+RetSqlName("EE8") + " EE8 "
					cQuery += "WHERE "
					cQuery += "EE9.EE9_FILIAL = EEC.EEC_FILIAL AND "
					cQuery += "EE9.EE9_PREEMB = EEC.EEC_PREEMB AND "
					cQuery += "EE9.EE9_FILIAL = EE8.EE8_FILIAL AND "
					cQuery += "EE9.EE9_PEDIDO = EE8.EE8_PEDIDO AND "
					cQuery += "EE9.EE9_COD_I  = EE8.EE8_COD_I AND "
					cQuery += "EE9.EE9_COD_I  = '"+EE9->EE9_COD_I+"' AND "
					//				cQuery += "EEC.EEC_STATUS = '6' AND "  // 25/09/15 - Luis Felipe
					cQuery += "EE8.D_E_L_E_T_ = '' AND "
					cQuery += "EE9.D_E_L_E_T_ = '' AND "
					cQuery += "EEC.D_E_L_E_T_ = '' "

					MemoWrite("C:\Tmp\EECAE100.txt",cQuery)

					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPEE9",.F.,.T.)

					DBSELECTAREA("TMPEE9")
					("TMPEE9")->(DbGoTop())

					If ("TMPEE9")->(!EOF())
						cContra := ""
						cPer 	:= ""
						lContra := .f.
						For nx:=1 to Len(("TMPEE9")->EE9_COD_I)
							If SubStr(("TMPEE9")->EE9_COD_I,nx,1) $ "P0123456789" .and. !lContra
								cContra := cContra + SubStr(("TMPEE9")->EE9_COD_I,nx,1)
							Else
								lContra := .t.
								If SubStr(("TMPEE9")->EE9_COD_I,nx,1) $ "0123456789"
									cPer := cPer + SubStr(("TMPEE9")->EE9_COD_I,nx,1)
								EndIf
							EndIf
						Next
						cContra := cContra + Space(TamSx3("Z3_CONTRA")[1] - Len(cContra))
						cPer    := cPer + Space(TamSx3("Z3_PERIODO")[1] - Len(cPer))
						SZ3->(DbSetOrder(1))
						If SZ3->(DbSeek(xFilial("SZ3")+cContra+cPer))
							nEmbarq	:= 0
							nSomaPol:= 0
							lPol	:= .t.
							While ("TMPEE9")->(!Eof())
								If !Empty(("TMPEE9")->EE8_XPOLDP)
									nSomaPol += (("TMPEE9")->EE8_XPOLDP/100) * (("TMPEE9")->EE9_QTDEM1 / SZ3->Z3_QUANT)
									nEmbarq += ("TMPEE9")->EE9_QTDEM1
								Else
									lPol	:= .f.
								EndIf
								("TMPEE9")->(DbSkip())
							End
							nMedia := nSomaPol * 100
							If	nEmbarq >= SZ3->Z3_QUANT .and. nMedia <> SZ3->Z3_POLDP .and. lPol
								RecLock("SZ3",.f.)
								SZ3->Z3_POLDP := nMedia
								Msunlock()
								u_EDFV002("","",cContra,cPer,SZ3->Z3_POLDP)
							EndIf
						EndIf
					EndIf
				EndIf

				EE9->(DbSkip())

			End

			*********************** Luiz Fernando - 04/05/2015 ********************
		Case cParam == "ANTES_PARCELA" // Luiz Fernando - 04/05/2015

			cEECArea := GetArea()

			*********************************************************************************
			**** Correçao de Informações de Invoice na Capa do processo - Luiz 27/07/2015
			*********************************************************************************
			DbSelectArea("EXP")
			DbSetOrder(1)
			If EXP->(DbSeek(xFilial("EXP")+EEC->EEC_PREEMB))
				cInvEXP   := EXP->EXP_NRINVO
				dDtInvEXP := EXP->EXP_DTINVO

				RestArea(cEECArea)

				RecLock("EEC",.F.)
				EEC->EEC_NRINVO := cInvEXP
				EEC->EEC_DTINVO := dDtInvEXP
				MsUnlock("EEC")

			Endif
			***************************** Fim Luiz Fernando **********************************

			RestArea(cEECArea)

			EE9->(DbSetOrder(2))
			EE9->(Dbseek(xFilial("EE9")+cEmbEEC))

			While cEmbEEC == EE9->EE9_PREEMB .and. xFilialEEC == EE9->EE9_FILIAL .and. EE9->(!Eof())

				**** Alterado Luiz Pereira 05/06/15
				If Alltrim(EE9->EE9_EMBAL1) = "001"
					nPESLIQ     := EE9->EE9_PSLQTO //EEC->EEC_PESLIQ
					nPESBRU     := EE9->EE9_PSLQTO //EEC->EEC_PESBRU
					nVOLUME1    := EE9->EE9_PSLQTO / 1000
					nTotVOLUME1 += nVOLUME1
				Else
					nPESLIQ     := EE9->EE9_PSLQTO //EEC->EEC_PESLIQ
					nPESBRU     := EE9->EE9_PSBRTO //EEC->EEC_PESBRU
					nVOLUME1    := EE9->EE9_QTDEM1
					nTotVOLUME1 += EE9->EE9_QTDEM1
				Endif

				cESPECI1    := EEC->EEC_PACKAG
				cReEEC      := EE9->EE9_RE
				cSDEEC      := EE9->EE9_NRSD

				If Alltrim(EE9->EE9_EMBAL1) = "001"
					nTotPESLIQ  += EE9->EE9_PSLQTO
					nTotPESBRU  += EE9->EE9_PSLQTO
				Else
					nTotPESLIQ  := EEC->EEC_PESLIQ
					nTotPESBRU  := EEC->EEC_PESBRU
				Endif

				cPedEEC     := xFilial("SC6")+Substr(EE9->EE9_PEDIDO,1,6)+Substr(EE9->EE9_SEQUEN,1,2)+EE9->EE9_COD_I
				cPedEECCapa := xFilial("EE9")+Substr(EE9->EE9_PEDIDO,1,6)

				cEE9Area := GetArea()

				SC6->(DbSelectArea("SC6"))
				SC6->(DbSetOrder(1))

				If SC6->(DbSeek(cPedEEC))
					SC6->(RecLock("SC6",.F.))
					SC6->C6_XPESO   := nPESLIQ
					SC6->C6_XPESOBR := nPESBRU
					SC6->C6_XQTDEM1 := nVOLUME1
					SC6->(Msunlock("SC6"))
				EnDif

				SC5->(DbSelectArea("SC5"))
				SC5->(DbSetOrder(1))

				If SC5->(DbSeek(cPedEECCapa))
					SC5->(RecLock("SC5",.F.))
					SC5->C5_PESOL   := nTotPESLIQ
					SC5->C5_PBRUTO  := nTotPESBRU
					SC5->C5_VOLUME1 := nTotVOLUME1
					IIF(!Empty(cReEEC),SC5->C5_RE:=cReEEC, SC5->C5_RE:="")
					IIF(!Empty(cSDEEC),SC5->C5_SD:=cSDEEC, SC5->C5_SD:="")
					SC5->(Msunlock("SC5"))
				EnDif

				nTotPESLIQ := 0
				nTotPESBRU := 0

				RestArea(cEE9Area)

				EE9->(DbSkip())

			End

			RestArea(cEECArea)
			************************ Fim Luiz Fernando ****************

			*********************** Luis Felipe  - 12/06/2018 ********************
		Case cParam == "ALTERA_FILTRO"

			aAdd(aHDEnchoice, "EEC_NRODUE")
			aAdd(aEECCamposEditaveis,"EEC_NRODUE")

			aAdd(aHDEnchoice, "EEC_NRORUC")
			aAdd(aEECCamposEditaveis,"EEC_NRORUC")

			//12-01-2026 - Thiago Reis
		Case cParam == "VALID_EMB"

			if Empty(AllTrim(EEC->EEC_EMBARC))
				FwAlertError("Campo obrigatório Embarque não informado")
				lRet := .F.
			endif
			//12-01-2026 - Thiago Reis
						
			***********************  Fabrício Antunes  - 06/02/2026 ********************			
			//Geracao de amarração de NF-e lote para simplefarm
		Case cParam == "GRV_CPOS_CUSTOM" .AND. INCLUI

			cQuery := " SELECT ZX1_FILIAL, ZX1_EXPORT, ZX1_NOTA, ZX1_SERIE, ZX1_CHAVE, ZX1_ITEM, ZX1_QUANTI, ZX1_TIPO, ZX1_ITEMEX FROM "+RetSqlName("ZX1")
			cQuery += " WHERE ZX1_EXPORT = '"+EEC->EEC_PEDREF+"' AND D_E_L_E_T_ = '' AND ZX1_TIPO = 'R'"
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cZX1A",.T.,.T.)

			cZX1A->(dbGoTop())
			While !cZX1A->(EOF()) .AND. cZX1A->ZX1_EXPORT = EEC->EEC_PEDREF
				nRec 		:= 0
				cQuery:= "SELECT R_E_C_N_O_ AS REC FROM "+RetSqlName("SF2")+" WHERE F2_CHVNFE ='"+cZX1A->ZX1_CHAVE+"' AND D_E_L_E_T_ = ''"
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cSF2A",.T.,.T.)
				nRec:= cSF2A->REC
				cSF2A->(dbCloseArea())

				IF nRec > 0
					dbSelectArea("SF2")
					SF2->(dbSetOrder(1))
					SF2->(dbGoTo(nRec))

					dbSelectArea("SE2")
					SD2->(dbSetOrder(3)) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
					SD2->(dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+"ALGODAO                  "+cZX1A->ZX1_ITEM))

					dbSelectArea("EE7")
					EE7->(dbSetOrder(1))
					EE7->(dbSeek(xFilial('EE7')+EEC->EEC_PEDREF))

					dbSelectArea("EK6")
					EK6->(dbSetOrder(1))

					RecLock("EK6",.T.)
						EK6->EK6_FILIAL		:= xFilial("EK6")
						EK6->EK6_NF			:= cZX1A->ZX1_NOTA
						EK6->EK6_SERIE		:= cZX1A->ZX1_SERIE
						EK6->EK6_CLIENT		:= SF2->F2_CLIENTE
						EK6->EK6_LOJACL		:= SF2->F2_LOJA
						EK6->EK6_COD_I		:= SD2->D2_COD
						EK6->EK6_ITEM		:= cZX1A->ZX1_ITEM
						EK6->EK6_CHVNFE		:= cZX1A->ZX1_CHAVE
						EK6->EK6_QUANT		:= cZX1A->ZX1_QUANTI
						EK6->EK6_UMNF		:= SD2->D2_UM
						EK6->EK6_CFOP		:= SD2->D2_CF
						EK6->EK6_QTUMIT		:= 0
						EK6->EK6_PREEMB		:= EEC->EEC_PREEMB
						EK6->EK6_NFSD		:= Posicione("SC5",1,xFilial("SC5")+EE7->EE7_PEDFAT,"C5_NOTA")		//Numero da nota de exportacao
						EK6->EK6_SENFSD		:= Posicione("SC5",1,xFilial("SC5")+EE7->EE7_PEDFAT,"C5_SERIE")		//Serie da nota de exportação
						EK6->EK6_PDNFSD		:= EE7->EE7_PEDIDO					//Pedido vinculado a NF Exp
						EK6->EK6_SQPDNF		:= PadL(Alltrim(Str(Val(cZX1A->ZX1_ITEMEX))),6)		//Seq.do Item no Ped.Export
						EK6->EK6_SQFTSD		:= cZX1A->ZX1_ITEMEX				//Seq.Fat.Item na NF Export
					msUnLock()

					cZX1A->(dbSkip())

				Else
					FwAlertError("Nota fiscal de formação de lote com chave "+cZX1A->ZX1_CHAVE+" informada na integracao, não foi encontrada no sistema! Verfique a amarração de notas fiscais")
					cZX1A->(dbSkip())
				EndIF
			EndDo
			cZX1A->(dbCloseArea())
			************************ Fabrício Antunes ****************
		End Case

	End Sequence

	RestArea(aArea)
	RestArea(aAreaEE9)

Return lRet

/*
"EK6_FILIAL" 	"0109"
"EES_FILIAL"  	"0109"
"EK6_PREEMB"	"842                  
"EES_PREEMB"	"842                 "
"EK6_PDNFSD"	"842                 "
"EES_PEDIDO" 	"842                 "
"EK6_SQPDNF"	"2     "		//ajustar
"EES_SEQUEN" 	"     1"
"EK6_NFSD" 		"000000022" 
"EEM_NRNF"  	"000000022"
"EK6_SENFSD" "2  "
"EEM_SERIE"  "2  "
"EK6_SQFTSD" "02  "
"EES_FATSEQ" "01"


EES_FILIAL+EES_PREEMB+EES_NRNF+EES_SERIE+EES_PEDIDO+EES_SEQUEN+EES_FATSEQ   */
