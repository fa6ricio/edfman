#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#DEFINE   c_ent      CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma  ³M410STTS  ºAutor  ³ Luis Felipe Nascimento ³  13/07/13      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada executado no momento da inclusão, altera- º±±
±±º          ³ ção ou exclusão de um pedido de venda.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO BAUCHE                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                        02/06/15     º±±
±±º          ³ Criado tratamento para estorno do saldo dos contratos após º±±
±±º          ³ a exclusão dos pedidos de vendas. Podendo esse ter origem  º±±
±±º          ³ na rotina padrão de Pedidos de Vendas ou através da confir º±±
±±º          ³ mação de exclusão do Pedido de Exportação. (SZ7)           º±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ºAlteração ³  Luis Felipe                                    03/05/16   º±±
±±º          ³  Criado regitro de controle sobre o pedido de vendas a fim º±±
±±º          ³  estorna o saldo do contrato sobre o item certo da SZ7.    º±±
±±º          ³  nZ7REG                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410STTS()

Local _cM410STTS:= GetArea()
Local _cTesFis 	:= Alltrim(SuperGetMV("MV_XTESFIS",.t.,"501"))
Local _cTesDev 	:= Alltrim(SuperGetMV("MV_XTESDEV",.t.,"507"))
Local _cTes		:= GdFieldGet("C6_TES",1)
Local _nRegistro:= 0
Local nX // Wilbis Paulo 13/01/2026

// Wilbis Paulo 13/01/2026
SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

If Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO, "B1_XCONTCT") == "2"
	RestArea(_cM410STTS)
	Return
EndIf

// Fim Wilbis Paulo 13/01/2026

If SC5->C5_TIPO == "D" .and. _cTes $ _cTesFis+"|"+_cTesDev .and. !Empty(SC5->C5_XNCONTR)
	
	For nX:= 1 to Len(Acols)
		
		_nRegistro := u_BuscaSZD(SC5->C5_XNCONTR,SC5->C5_XNFMAE,SC5->C5_XNSERIM,GdFieldGet("C6_NFORI",nX),GdFieldGet("C6_SERIORI",nX))
		
		SZD->(DbGoto(_nRegistro))
		
		If((Inclui .Or. Altera) .Or. !(Inclui .Or. Altera))
			RecLock("SZD", .F.)
			If (Inclui .Or. Altera)         // Inclusão e ou alteração
				SZD->ZD_STATUS := "PL"      // Aguardando Geração da NF de Devolução
			ElseIf (!(Inclui .Or. Altera))  // Exclusão
				If SZD->ZD_QTDREC >= SZD->ZD_QTDNFRE
					SZD->ZD_STATUS  := "BX" // Baixa Total
				Else
					SZD->ZD_STATUS  := "BP" // Baixa Parcial
				EndIf
			EndIf
			MsUnlock()
		EndIf
		
	Next

EndIf

// ------------------------------------------- //
// Luis Felipe nascimento           02/06/2015 //
// Estorna o Saldo do Contrato                 //
// ------------------------------------------- //

If SC5->C5_TIPO == "N"

	If Inclui == .F. .and. Altera == .F.
	
		dbSelectArea("SZ7")
//		dbSetOrder(3) // 03/05/16 - Luis Felipe
//		If dbSeek(xFilial("SZ7")+SC5->C5_CONTRAT+SC5->C5_XPERIOD+SC5->C5_NRMEDIA+SC5->C5_XCONTRO)
		Go SC5->C5_XSZ7REG
		If 	SZ7->(Recno()) == SC5->C5_XSZ7REG         
			RecLock("SZ7",.F.)
			SZ7->Z7_SALDO+= SC6->C6_UNSVEN // SC6->C6_QTDVEN // 02/06/15 - Luis Felipe Nascimento
		         
			If SZ7->Z7_SALDO == SZ7->Z7_QTDE
				SZ7->Z7_STATUS	:= ""
			endif
			             
			MsUnLock()
		EndIf                             	

	EndIf
	
EndIf

IF ALLTRIM(FUNNAME()) $ "MATA410"

	If Type("_cPEDEXP") <> "U"
	
		If  !Empty(_cPEDEXP)
			RecLock("SC5",.F.)
			SC5->C5_PEDEXP := _cPEDEXP
			MsUnlock()
		EndIf
	
	EndIf

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

ENDIF

RestArea(_cM410STTS)

Return
