#include "Protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EECAF200ºAutor  ³Luiz Fernando           ³Data ³  17/06/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EECAF200_rdm                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                   ³Data ³  18/12/15 º±±
±±º          ³ RDM_059_Exportação_Diversos                                º±±
±±º          ³ Contabilização da invoice com taxa da data desta.          º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºAlteracao ³ Luis Felipe Nascimento                   ³Data ³  22/02/16 º±±
±±º          ³ Distribuição do histórico da Correção Monetária dos perío- º±±
±±º          ³ dos anteriores para as novas parcelas.                     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
Função......: EECAF200()
Parametros..: Nenhum
Retorno.....: Nil
Objetivo....: Ponto de entrada do programa EECAF200, apos gravar a tabela EEQ e corrigir o numero da duplicata do financeiro
Autor.......: Luiz Fernando
Data/Hora...: 17/06/2015 - 10:00
Observação..:
*/

******************************
User Function EECAF200()
	******************************
	Local lRet := .T., cParam := If(Type("PARAMIXB")== "A",ParamIxb[1],ParamIxb)
	Local cOLdEEQ:= GetArea()
	Local aOldEE9:= EE9->(GetArea())
	Local cEmbEEC    := EEC->EEC_PREEMB
	Local __cPreembe := ""
	Local __aCORRECNR := {}

	//12-01-2026 - Thiago Reis
	EE9->(DbSetOrder(2))
	EE9->(Dbseek(xFilial("EE9")+EEC->EEC_PREEMB))

	if Posicione("SB1",1,xFilial("SB1")+AllTrim(EE9->EE9_COD_I),"B1_XCONTCT") == "2" //2-Não
		RestArea(cOLdEEQ)
		RestArea(aOldEE9)
		Return lRet
	endif
	////12-01-2026 - Thiago Reis

	Begin Sequence

		IF Alltrim(cParam) == "PE_ALT_PARC"
			//AcertaParcelas()
			*'yTTALO P MARTINS-INICIO-GERAÇÃO DA PARCELA DA INVOICE COMPLEMENTAR-----------'*
		ELSEIF Alltrim(cParam) == "PE_GERPARC"
			xAtuEEQ()
			*'yTTALO P MARTINS-FIM-GERAÇÃO DA PARCELA DA INVOICE COMPLEMENTAR--------------'*
		Endif

//ENS 25/10/2012
/*
If Alltrim(cParam) == "PE_ENCHOICE_EEQ"
aAdd(aMostra,"EEQ_NROPAG")
aAdd(aAltera,"EEQ_NROPAG")
Endif
*/

		Do Case

			// Luiz 12/08/15
		Case cParam == "PE_ENCHOICE_EEQ"

/*
		// 18/12/15 - Luis Felipe - Inicio
		EXP->(DbSetOrder(1))
		EXP->(DbSeek(xFilial("EXP")+EEQ->EEQ_PREEMB+EEQ->EEQ_NRINVO)) 
		
		SM2->(DbSeek(DtoS(EXP->EXP_DTINVO)))
		// 18/12/15 - Luis Felipe - Fim
*/
			// 09/02/17 - Luis Felipe - Inicio
			// Passado da data invoice p/ data do embarque
//SM2->(DbSeek(DtoS(EEC->EEC_DTEMBA)))
			// 09/02/17 - Luis Felipe - Fim

			Public __nTxMoeda  	:= 0 // E1_TXMOEDA
			Public __nTxDolar  	:= 0 // E1_XDOLAR
			Public __nTxMDCor  	:= 0 // E1_TXMDCOR
			Public __cPreembe  	:= 0 // EEC_PREEMB
			Public __cInvoice  	:= 0 // EEQ_NRINVO
			Public __cNrTit    	:= 0 // EEQ_FINNUM
			Public __cParcela  	:= 0 // EEQ_PARC

			Public __nCORREC	:= 0 // E1_CORREC
			Public __dDTVARIA  	:= CtoD("  /  /  ") //E1_DTVARIA
			Public __nTXCONTR  	:= 0 // E1_TXCONTR
			Public __nValor		:= 0 // E1_VALOR
			Public __aCORRECNR  := {} // E5_VALOR // VM

			cAliasEEQ := GetArea()
			DbSelectArea("SE1")
			DbSetOrder(1)
			__cSeek:= 'SE1->(DbSeek(xFilial()+"EEC"+AvKey(M->EEQ_FINNUM, "E1_NUM")+AvKey(" ", "E1_PARCELA")+AvKey("NF","E1_TIPO")))'

			If &__cSeek
				__nTxMoeda  := SE1->E1_TXMOEDA
				__nTxDolar  := SE1->E1_XDOLAR
				__nTxMDCor  := SE1->E1_TXMDCOR
				__cPreembe  := EEC->EEC_PREEMB
				// 22/02/16 - Luis Felipe - Inicio
				__dDTVARIA  := SE1->E1_DTVARIA
				__nTXCONTR  := SE1->E1_TXCONTR
				__nValor	:= SE1->E1_VALOR
				__nCORREC	:= SE1->E1_CORREC
				DbSelectArea("SE5")
				DbSetOrder(2)
				If DbSeek(xFilial("SE5")+"VM"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
					cChave := "VM"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
					While cChave == "VM"+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO
						Aadd(__aCORRECNR,{SE5->E5_FILIAL,SE5->E5_DATA,SE5->E5_TIPO,SE5->E5_VALOR,SE5->E5_NATUREZA,SE5->E5_RECPAG,SE5->E5_HISTOR,SE5->E5_TIPODOC,SE5->E5_VLMOED2,SE5->E5_LA,SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_DTDIGIT,SE5->E5_DTDISPO})
						DbSkip()
					End
				EndIf
				// 22/02/16 - Luis Felipe - Fim
			Endif

			RestArea(cAliasEEQ)

			// Luiz 14/08/15
		Case cParam == "GERA_MOV_MS" // Altera na Quebra de parcelas de cambio (Controle de Cambio)

/*      09/02/17 - Luis Felipe - Inicio
		// 18/12/15 - Luis Felipe - Inicio
		EXP->(DbSetOrder(1))
		EXP->(DbSeek(xFilial("EXP")+EEQ->EEQ_PREEMB+EEQ->EEQ_NRINVO)) 
		
		SM2->(DbSeek(DtoS(EXP->EXP_DTINVO)))
		// 18/12/15 - Luis Felipe - Fim
       09/02/17 - Luis Felipe - Fim */

		// 09/02/17 - Luis Felipe - Inicio
		// Passado da data invoice p/ data do embarque
//SM2->(DbSeek(DtoS(EEC->EEC_DTEMBA)))
		// 09/02/17 - Luis Felipe - Fim 
 
 		__cPreembe  := EEC->EEC_PREEMB
		
		cOldEEQ2 := GetArea()
		
		DbSelectArea("EEQ")
		DbSetOrder(1)
		
		If DBSEEK(xFilial("EEQ")+__cPreembe+"01") .and. EEC->EEC_TOTPED <> EEQ->EEQ_VL 
			
			While !Eof() .and. EEQ->EEQ_PREEMB == __cPreembe
				
				__cInvoice  := EEQ->EEQ_NRINVO
				__cNrTit    := EEQ->EEQ_PREFIX+EEQ->EEQ_TPTIT+EEQ->EEQ_FINNUM+EEQ->EEQ_PARC   
				__cSeek     := 'SE1->(DbSeek(xFilial()+"EEC"+AvKey(EEQ->EEQ_FINNUM, "E1_NUM")+AvKey(" ", "E1_PARCELA")+AvKey("NF","E1_TIPO")))'
				
				Do Case
					Case alltrim(EEQ->EEQ_PARC) == "01"
						__cParcela   := "A"
					Case alltrim(EEQ->EEQ_PARC) == "02"
						__cParcela   := "B"
					Case alltrim(EEQ->EEQ_PARC) == "03"
						__cParcela   := "C"
					Case alltrim(EEQ->EEQ_PARC) == "04"
						__cParcela   := "D"
					Case alltrim(EEQ->EEQ_PARC) == "05"
						__cParcela   := "E"
					Case alltrim(EEQ->EEQ_PARC) == "06"
						__cParcela   := "F"
					Case alltrim(EEQ->EEQ_PARC) == "07"
						__cParcela   := "G"
					Case alltrim(EEQ->EEQ_PARC) == "08"
						__cParcela   := "H"
					Case alltrim(EEQ->EEQ_PARC) == "09"
						__cParcela   := "I"
					Case alltrim(EEQ->EEQ_PARC) == "10"
						__cParcela   := "J"
				EndCase
				
				DbSelectArea("SE1")
				DbSetOrder(1)
				
				If &__cSeek

					//Alert("Titulo => "+SE1->E1_NUM)

					RecLock("SE1",.F.)
					SE1->E1_NUM 	 := Alltrim(__cInvoice)+AllTrim(__cParcela)
					SE1->E1_TXMOEDA  := __nTxMoeda // 18/12/15 - Luis Felipe 

					//Alert("E1_TXMOEDA => "+Str(SE1->E1_TXMOEDA,15,4))
					
					//---------------------------------------------------------//22/06/2016 ENS
					If cParam == "GERA_MOV_MS"
//					   __nTxDolar:= BuscaTaxa('US$'  ,Ddatabase,.T.,.F.,.T.) // 13/06/18 - Luis Felipe
					   __nTxDolar:= BuscaTaxa('US$'  ,EEC->EEC_DTEMBA,.T.,.F.,.T.) 
					Else	
					   __nTxDolar:= SE1->E1_XDOLAR  
					EndIf
        			SE1->E1_XDOLAR	 := __nTxDolar

					//Alert("E1_XDOLAR  => "+Str(__nTxDolar,15,5))

 /*                 09/02/17 - Luis Felipe
        			If cParam == "GERA_MOV_MS"
        			   __nTxMDCor :=BuscaTaxa('US$'  ,dDataBase,.T.,.F.,.T.)
        			EndIf
 */
			SE1->E1_TXMDCOR	 := __nTxMDCor
			//-------------------------------------------------------------------------

			SE1->E1_VLCRUZ   := SE1->E1_VALOR * __nTxDolar // __nTxMoeda 22/07/16 - Luis Felipe

			//Alert("E1_VLCRUZ - (SE1->E1_VALOR * __nTxDolar) => "+Str(SE1->E1_VLCRUZ,15,4))

			// 22/02/16 - Luis Felipe - Inicio
			SE1->E1_CORREC   :=  (SE1->E1_VALOR * __nTxDolar) - (SE1->E1_VALOR * SM2->M2_MOEDA2) // __nCORREC * (SE1->E1_VALOR / __nValor)  //   (SE1->E1_VALOR * __nTxDolar) // 22/07/16 - Luis Felipe

			//Alert("E1_CORREC - (SE1->E1_VALOR * __nTxDolar) - (SE1->E1_VALOR * SM2->M2_MOEDA2) => "+Str(SE1->E1_CORREC,15,4))

			SE1->E1_DTVARIA  := Ddatabase // __dDTVARIA  // 22/07/16 - Luis Felipe
			SE1->E1_TXCONTR  := SM2->M2_MOEDA2 // __nTXCONTR // 22/07/16 - Luis Felipe
			MsUnlock("SE1")

			DbSelectArea("SE5")
			DbSetOrder(2)
			If !DbSeek(xFilial("SE5")+"VM"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
				For a:=1 to Len(__aCORRECNR)
					RecLock("SE5",.T.)
					SE5->E5_FILIAL 	:= __aCORRECNR[a][1]
					SE5->E5_DATA	:= __aCORRECNR[a][2]
					SE5->E5_TIPO	:= __aCORRECNR[a][3]
					SE5->E5_VALOR	:= __aCORRECNR[a][4] * (SE1->E1_VALOR / __nValor)
					SE5->E5_NATUREZA:= __aCORRECNR[a][5]
					SE5->E5_RECPAG	:= __aCORRECNR[a][6]
					SE5->E5_HISTOR	:= __aCORRECNR[a][7]
					SE5->E5_TIPODOC	:= __aCORRECNR[a][8]
					SE5->E5_VLMOED2	:= __aCORRECNR[a][9] * (SE1->E1_VALOR / __nValor)
					SE5->E5_LA		:= __aCORRECNR[a][10]
					SE5->E5_PREFIXO	:= __aCORRECNR[a][11]
					SE5->E5_NUMERO	:=   SE1->E1_NUM
					SE5->E5_PARCELA	:= __aCORRECNR[a][13]
					SE5->E5_CLIFOR	:= __aCORRECNR[a][14]
					SE5->E5_LOJA	:= __aCORRECNR[a][15]
					SE5->E5_DTDIGIT	:= __aCORRECNR[a][16]
					SE5->E5_DTDISPO	:= __aCORRECNR[a][17]
					MsUnlock("SE5")
				Next
			EndIf
			// 22/02/16 - Luis Felipe - Fim

		Endif

		DbSelectArea("EEQ")

		RecLock("EEQ",.F.)
		EEQ->EEQ_FINNUM := Alltrim(__cInvoice)+AllTrim(__cParcela)
		MsUnlock()

		EEQ->(DbSkip())

	Enddo

Endif

RestArea(cOldEEQ2)

// Luiz 17/06/2015
Case cParam == "PE_GERPARC" // Altera ao digitar a Data de Embarque/Encerramento (Embarque)

	EEQ->(dbSetOrder(1))
	EEQ->(DBSEEK(xFilial("EEQ")+cEmbEEC))
	Do While EEQ->(!EOF() .and. EEQ->(EEQ_FILIAL + EEQ_PREEMB) == xFilial("EEQ")+EEC->EEC_PREEMB)
		EEQ->(RecLock("EEQ",.F.))
		EEQ->EEQ_FINNUM := cInvoSE1
		EEQ->(MsUnlock())
		EEQ->(dbSkip())
	EndDo

End Case

End Sequence

RestArea(cOLdEEQ)

Return lRet


//------------------------------------------------------------------------------
Static Function AcertaParcelas
	//------------------------------------------------------------------------------
	Local i
	Local n         := Len(aParc)
	Local nValTot   := EEC->EEC_ZVL_COMP
	Local nValParc  := Round(nValTot/n,2)
	Local nValUsado := 0
	LOCAL xaParcInv := {}

	Begin Sequence

		IF Empty(nValTot)
			Break
		Endif

		IF Len(aParc) == 0
			Break
		Endif

		For i:=1 To Len(aParc)
			aParc[i,1] += nValParc
			nValUsado  += nValParc
		Next i

		IF nValUsado <> nValTot
			aParc[Len(aParc),1] += nValParc-nValUsado
		Endif

	End Sequence

Return

	********************************
STATIC FUNCTION xAtuEEQ()
	********************************
	LOCAL xcParc := ""
	LOCAL aTmp   := {}

	DbSelectArea("EXP")
	EXP->(dbSetOrder(1))
	IF EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB+PADR(EEC->EEC_XINVCP,TAMSX3("EXP_NRINVO")[1] )))

		dbSelectArea("EXR")
		EXR->(dbSetOrder(1))
		IF EXR->(dbSeek(xFilial("EXR")+EEC->EEC_PREEMB+EXP->EXP_NRINVO))

			dbSelectArea("EE9")
			EE9->(dbSetOrder(3))
			IF EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+EXR->EXR_SEQEMB))

				RecLock("EXP", .F.)
				EXP->EXP_TOTPED := EE9->EE9_PRECO
				EXP->EXP_VLFOB  := EE9->EE9_PRECO
				EXP->(MsUnlock())

				RecLock("EXR", .F.)
				EXR->EXR_PRCTOT := EE9->EE9_PRECO
				EXR->EXR_PRCINC := EE9->EE9_PRECO
				EXR->(MsUnlock())

				dbSelectArea("EEQ")
				EEQ->(dbSetOrder(1))
				IF EEQ->(dbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))

					WHILE EEQ->(!EOF()) .AND. EEQ->EEQ_FILIAL == xFilial("EEQ") .AND. EEQ->EEQ_PREEMB == EEC->EEC_PREEMB

						xcParc := EEQ->EEQ_PARC
						EEQ->(dbSKIP())
					ENDDO
					xcParc := SOMA1(xcParc)

					dbSelectArea("EEQ")
					EEQ->(dbSetOrder(1))
					EEQ->(dbSeek(xFilial("EEQ")+EEC->EEC_PREEMB))

					*-----------------------------------------------------------------------------------*
					*Transmite campos para o array
					*-----------------------------------------------------------------------------------*

					For nX:= 1 To FCount()
						Aadd(aTmp, {fieldname(nX), fieldget(nX)})
					Next

					*-----------------------------------------------------------------------------------*
					*Gera registro de Revisao, copiando o registro atual
					*-----------------------------------------------------------------------------------*

					DbSelectArea("EEQ")
					RecLock("EEQ",.T.)
					For i:=1 to Len(aTmp)
						&(aTmp[i][1]) :=  aTmp[i][2]
					Next i

					EEQ->EEQ_FILIAL	    := XFILIAL("EEQ")
					EEQ->EEQ_MOEDA	    := EEC->EEC_MOEDA
					EEQ->EEQ_NRINVO	    := EXP->EXP_NRINVO
					EEQ->EEQ_PARC	    := xcParc
					EEQ->EEQ_PARVIN	    := xcParc
					EEQ->EEQ_VCT	    := DDATABASE
					EEQ->EEQ_VL     	:= EE9->EE9_PRECO
					EEQ->EEQ_EMISSA    	:= DDATABASE

					MsunLock()

				ENDIF

			ENDIF

		ENDIF

	ENDIF

RETURN
