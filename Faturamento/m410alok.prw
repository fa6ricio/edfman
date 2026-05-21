#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#Include "TopConn.Ch"
#include "tbiconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ GCTPEDCPO º Autor ³ Luis Felipe nascimento   ³  15/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Ponto de Entrada usado para permitir a alteração de campos º±±
±±º          ³ nos pedidos gerados pelo módulo gestão de contratos.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M410ALOK()

Local   _lRet    := .t.
Public  _cPEDEXP := ""

// Wilbis Paulo 13/01/2026
aArea := GetArea()

SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

If Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO, "B1_XCONTCT") == "2"
	RestArea(aArea)
	Return (_lRet)
EndIf

RestArea(aArea)
// Fim Wilbis Paulo 13/01/2026

_cPEDEXP := SC5->C5_PEDEXP 

If !Empty(SC5->C5_PEDEXP)
	RecLock("SC5",.F.)
	SC5->C5_PEDEXP := ""
	MsUnlock()
EndIf                 
               
IF ALLTRIM(FUNNAME()) $ "MATA410"
	************************************************************************************
	*** Tratamento de Notas de Complementos de Exportação - Luiz Pereira - 17/07/15  ***
	************************************************************************************
	If SC5->C5_TIPO == "C" .and. SC5->C5_TIPOCLI = "X"
		cSc5Alias := GetArea()
		c6NfOrig  := Posicione("SC6",1,xFilial("SC6")+SC5->C5_NUM,"C6_NFORI")+Posicione("SC6",1,xFilial("SC6")+SC5->C5_NUM,"C6_SERIORI")
		c5ProcExp := Posicione("SD2",3,xFilial("SD2")+c6NfOrig+SC5->C5_CLIENT+SC5->C5_LOJACLI,"D2_PREEMB")
		cOrigem    := Posicione("EEC",1,xFilial("EEC")+c5ProcExp,"EEC_ORIGEM")
		cPortoOrig := AllTrim(Posicione("SY9",2,xFilial("SY9")+cOrigem ,"Y9_DESCR"))
		cEstOrig   := AllTrim(Posicione("SY9",2,xFilial("SY9")+cOrigem ,"Y9_ESTADO"))
 		 RecLock("SC5",.F.)
			SC5->C5_XUFEMBA  := cEstOrig
			SC5->C5_XLOCEMB  := cPortoOrig
		 MsUnlock("SC5")
		RestArea(cSc5Alias)
	Endif
	************************************************************************************
Endif                                 
               
Return( _lRet )
