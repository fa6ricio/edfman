#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EECFAT3 ºAutor  ³Luis Felipe Nascimento  ³Data ³  25/07/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Permitir alterar a quantidade devolvida devido a unidade   º±±
±±           ³ devolvida estar diferente da unidade do embarque.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³                                          ³Data ³    /  /   º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EECFAT3()

Local _cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))
Local _aArea  := GetArea()
Public _aEE9   := {}
Public _aEE8   := {}
Public _lEmbarc:= .f.
Public _nQtdDev:= 0

If Alltrim(_cParam) == "ALTERA_QTD_DEVOLVIDA"
	EEC->(DbSetOrder(1))
	If EEC->(DbSeek(xFilial("EEC")+SD2->D2_PREEMB))
		// Conforme definições da rotina padrão EECFAT3, só são permitidas alterações do saldo do embarque
		// ,em função da quantidade devolvida, quando o mesmo estiver em aberto.
		EE8->(DbSetOrder(1))
		If EE8->(DbSeek(xFilial("EE8")+SD2->D2_PEDIDO))
			If Empty(EEC->EEC_DTEMBA)

				nQtdDev := SD1->D1_QUANT * EE8->EE8_QE
				SD1->(RecLock("SD1",.F.))
				SD1->D1_QTDEDEV := nQtdDev
				MsUnlock()
			
				// Guarda a posição do Embarque e do Pedido de Exportação antes
				// da rotina padrão fazer os calculos da devolução.
				
				EE9->(DbSetOrder(2))
				If EE9->(DbSeek(xFilial("EE9")+SD2->D2_PREEMB))
					While EE9->(!Eof()) .and. EE9->EE9_PREEMB == SD2->D2_PREEMB
						Aadd(_aEE9,{EE9->(Recno("EE9")),SD2->D2_PEDIDO,EE9->EE9_SLDINI,nQtdDev,EE9->(EE9_FILIAL+EE9_PEDIDO+EE9_COD_I),SD2->(Recno("SD2"))})
						EE9->(DbSkip())
					End
				EndIf
				
				_Status := EEC->EEC_STATUS
				
				For _nx:=1 to Len(_aEE9)
					EE8->(DbSetOrder(6))
					If EE8->(DbSeek(_aEE9[_nx][5]))
						Aadd(_aEE8,{EE8->(Recno("EE8")),EE8->EE8_PEDIDO,EE8->EE8_SLDATU})
					EndIf
				Next   
				
			Else
				_lEmbarc:= .t.
			EndIf
		EndIf
	EndIf
Endif

Restarea(_aArea)

Return Nil