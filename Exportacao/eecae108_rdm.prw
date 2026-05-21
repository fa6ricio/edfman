#INCLUDE 'PROTHEUS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ EECAE108_RDM ³ Autor ³ Luis Felipe Mattos³ Data ³ 24.09.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada executado após a seleção da	opção de ex-  ³±±
±±³          ³ clusão sobre a rotina de invoice.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ Invoice Complementar                                 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo: ³ Para garantir que a Nota Complementar de Preco e Invoice   ³±±
±±³          ³ complementar sejam canceladas a paritr da rotina geradora, ³±± 
±±³          ³ onde são realizadas os estornos de todas as movimentações, ³±± 
±±³          ³ inclusive contabilização, apresentamos mensagem de crítica ³±±
±±³          ³ e indicamos o caminho para realização do cancelamento.     ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EECAE108

	Local	lRet 	:= .t.
	Local aArea		:= GetArea()
	Local aAreaEE9	:= EE9->(GetArea())

	If ValType(ParamIXB) == "C"
		cParam1 := ParamIXB
		cParam2 := ParamIXB

	ElseIf ValType(ParamIXB) == "A"
		cParam1:= ParamIXB[1]
		cParam2:= ParamIXB[2]
	Else
		cParam1 := ""
		cParam2 := ""
	EndIf

	//12-01-2026 - Thiago Reis
	EE9->(DbSetOrder(2))
	EE9->(Dbseek(xFilial("EE9")+EEC->EEC_PREEMB))//EE9_FILIAL+EE9_PREEMB

	if Posicione("SB1",1,xFilial("SB1")+AllTrim(EE9->EE9_COD_I),"B1_XCONTCT") == "2" //2-Não
		RestArea(aArea)
		RestArea(aAreaEE9)
		Return lRet
	endif
	//

	If Alltrim(cParam1) == "VALINV" .And. Int(cParam2) == 6

		If !Empty(EEC->EEC_XINVCP)
			Aviso("Atenção","Não é permitido excluir a Invoice Complementar a partir desta rotina! Favor sair optando por Fechar, retorne a tela inicial da rotina de Embarque, selecione 'Ações Relacionas' e, em seguida, opte por Inv. Compl. Preço. Ao confirmar esta opção será apresentada uma pergunta quanto ao cancelamento da Invoice Complementar.",{"Voltar"})
			lRet := .f.
		EndIf

	EndIf

	RestArea(aArea)
	RestArea(aAreaEE9)

Return lRet

/*
Public _cPREEMB := ""
Public _cNRINVO := "" 
Public _SEQEMB  := ""

DbSelectArea("EXR")
EXR->(dbSetOrder(1))
EXR->(dbSeek(xFilial("EXR")+EEC->EEC_PREEMB+EEC->EEC_XINVCP))
_cPREEMB := EEC->EEC_PREEMB
_cNRINVO := EEC->EEC_XINVCP
_SEQEMB	 := EXR->EXR_SEQEMB
*/
