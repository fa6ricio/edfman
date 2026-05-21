#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050GRV  º Autor ³ Luiz Pereira       º Data ³  15/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige informações do T.Pag.quando sao inclusos juros     º±±
±±º          ³ no modulo SIGAEFF                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************************
User Function FA050GRV()
*************************

Local aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Alltrim(FunName()) == "EFFEX400"
	
	Reclock("SE2",.F.)
	SE2->E2_TXMOEDA := EF1->EF1_TX_MOE
	SE2->E2_VLCRUZ  := SE2->E2_VALOR * EF1->EF1_TX_MOE
	SE2->E2_XDOLAR  := EF1->EF1_TX_MOE
	MsUnlock()

/*
	If SubStr(M->E2_NUM,1,5)="84474" .and. Inclui 
		SE2->E2_NUM := Alltrim(EF3->EF3_CONTRA)
		If WORKEF3->EF3_CODEVE == "620" .and. !Empty(WORKEF3->EF3_SEQPER)  
			SE2->E2_PARCELA := If(Val(WORKEF3->EF3_SEQPER)<10,SubStr(WORKEF3->EF3_SEQPER,2,1),fSeq(WORKEF3->EF3_SEQPER))
		EndIf	
	EndIf

	If WORKEF3->EF3_CODEVE == '620' .and. !Empty(WORKEF3->EF3_SEQPER)
		EF3->(DbSetOrder(1))
		If EF3->(DbSeek(WORKEF3->(EF3_FILIAL+EF3_TPMODU+EF3_CONTRA+EF3_BAN_FI+EF3_PRACA+EF3_SEQCNT+EF3_CODEVE+EF3_PARC))) 
			Reclock("EF3",.F.)
			EF3->EF3_TITFIN := SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)                                                                                               
			MsUnlock()
		EndIf
    EndIf
*/	
Endif

RestArea(aArea)

Return

*------------------------*
Static Function fSeq(cSeq)
*------------------------*

Local cSeqNew := "" 

If cSeq == "10"
	cSeqNew := "A" 
ElseIf cSeq == "11"
	cSeqNew := "B" 
ElseIf cSeq == "12"
	cSeqNew := "C" 
ElseIf cSeq == "13"
	cSeqNew := "D" 
ElseIf cSeq == "14"
	cSeqNew := "E" 
ElseIf cSeq == "15"
	cSeqNew := "F" 
ElseIf cSeq == "16"
	cSeqNew := "G" 
ElseIf cSeq == "17"
	cSeqNew := "H" 
ElseIf cSeq == "18"
	cSeqNew := "I" 
ElseIf cSeq == "19"
	cSeqNew := "J" 
ElseIf cSeq == "20"
	cSeqNew := "K" 
ElseIf cSeq == "21"
	cSeqNew := "L" 
ElseIf cSeq == "22"
	cSeqNew := "M" 
ElseIf cSeq == "23"
	cSeqNew := "N" 
ElseIf cSeq == "24"
	cSeqNew := "O" 
ElseIf cSeq == "25"
	cSeqNew := "P" 
ElseIf cSeq == "26"
	cSeqNew := "Q" 
ElseIf cSeq == "27"
	cSeqNew := "R" 
ElseIf cSeq == "28"
	cSeqNew := "S" 
ElseIf cSeq == "29"
	cSeqNew := "T" 
ElseIf cSeq == "30"
	cSeqNew := "U" 
ElseIf cSeq == "31"
	cSeqNew := "W" 
ElseIf cSeq == "32"
	cSeqNew := "X" 
ElseIf cSeq == "33"
	cSeqNew := "Y" 
ElseIf cSeq == "34"
	cSeqNew := "Z" 
EndIf 

Return( cSeqNew )