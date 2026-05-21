#Include "rwmake.ch"
#Include "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#Define cEnt Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410TOK  ºAutor  ³Yttalo P. Martins   º Data ³  12/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ponto de entrada é executado ao clicar no botão OK e pode ser±±
±±º           usado para validar as operações: incluir,alterar, copiar e  º±±
±±º           excluir.                                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Validar existência de item com TES fiscal e TES física no  º±±
±±ºUso       ³ mesmo pedido de venda                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³          ºAutor  ³ Luis Felipe Mattos º Data ³  02/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Adicionada validação para a classe de valor quanto o produ-º±±
±±º          ³ to fizer referência a produtos comercializados pela ED&FMANº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³          ºAutor  ³ Luis Felipe Mattos º Data ³  12/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Alterado para tratar somente quando o Pedido for Normal.   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT410TOK()

	Local lRet      := .T.
//Local cMsg      := "" // Wilbis Paulo 12/01/2026
	Local xOpc      := PARAMIXB[1]//Número referente a opção de manutenção que está sendo utilizada. Ex: 2-Visualização, 3-Inclusão, 4-Alteração
//Local aRecTiAdt := PARAMIXB[2]// Array com registros de adiantamento // Wilbis Paulo 12/01/2026
	Local ni := 1
	Local nPosTes   := aScan(aHeader,{|x|x[2]="C6_TES"})
//Local nPosIt    := aScan(aHeader,{|x|x[2]="C6_ITEM"}) // Wilbis Paulo 12/01/2026
	Local nPosProd  := aScan(aHeader,{|x|x[2]="C6_PRODUTO"})
	Local nPosClas  := aScan(aHeader,{|x|x[2]="C6_XCLVL"})
	Local xTesDev   := GetMV("MV_XTESDEV")//TES para saldo físico
	Local xlTesDev  := .F.
	Local xTesFis   := GetMV("MV_XTESFIS")////TES para saldo físcal
	Local xlTesFis  := .F.
	Local cTexto    := "Não é possível atualizar PV com TES saldo fiscal e físico no mesmo pedido."+ cEnt+ cEnt
	Local cTexto2   := "É obrigatório informar a classe de valor no PV quando o produto for comercializado pela ED&F MAN !"+ cEnt+ cEnt
	Local aArea     := GetArea()

	cTexto += "Verifique parâmetros: MV_XTESDEV e MV_XTESFIS"+ cEnt

	SB1->(DbSetOrder(1))

	If xOpc == 3 .Or. xOpc == 4

		For ni := 1 to Len(aCols)

			If !(aCols[ni][len(aCols[ni])])

				If aCols[ni][nPosTes] == xTesDev
					xlTesDev := .T.
				EndIf

				If aCols[ni][nPosTes] == xTesFis
					xlTesFis := .T.
				EndIf

			Endif

			SB1->(DbSeek(xFilial("SB1")+aCols[ni][nPosProd]))

			// Wilbis Paulo - 12/01/2026
			if SB1->B1_XCONTCT == "2" 
				Return lRet
			endif
			// Wilbis Paulo - Fim

			If Procname(12) <> "B004GRV"
				If Alltrim(SB1->B1_GRUPO) $ "001/002/003/004" .and. Empty(aCols[ni][nPosClas]) .and. M->C5_TIPO == 'N'
					ApMsgInfo(cTexto2)
					lRet := .F.
				EndIf
			EndIf
		Next ni

	EndIf

	If xlTesDev == .T. .AND. xlTesFis == .T.
		ApMsgInfo(cTexto)
		lRet := .F.
	EndIf

	IF ALLTRIM(FUNNAME()) $ "MATA410"

		If Empty(M->C5_ESPECI1) // Luiz Pereira - 15/07/15
			ApMsgInfo("Atenção! Espécie 1 do Pedido deve ser informado!")
			lRet := .F.
		Endif

	Endif

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

	RestArea(aArea)

Return(lRet)
