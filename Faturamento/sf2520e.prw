#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF2520E  ºAutor  ³Leandro Ribeiro     º Data ³  16/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada acionando no momento da exclusão da nota  º±±
±±º          ³ fiscal para realizar o estorno dos saldos na SZD.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF2520E()

Local _aMSD2520  := GetArea()
Local _cAliasD2  := GetNextAlias()
Local _cQuery    := ""
Local _cTesFis 	 := Alltrim(SuperGetMV("MV_XTESFIS",.t.,"501"))
Local _cTesDev 	 := Alltrim(SuperGetMV("MV_XTESDEV",.t.,"507"))
Local _cTESSD2	 := ""
// Local _cProduto  := ""
Local _nTotDev	 := 0
Local _cChave    := ""


// Wilbis Paulo 12/01/2026
aArea := GetArea()

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

If Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO, "B1_XCONTCT") == "2"
	RestArea(aArea)
	Return
EndIf

RestArea(aArea)
// Fim Wilbis Paulo 12/01/2026


If SD2->D2_TIPO == "D" .and. SD2->D2_TES $ _cTesFis+"|"+_cTesDev 
	
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))            
	
	If Empty(SC5->C5_XNCONTR)
		RestArea(_aMSD2520)
		Return
	EndIf

	BEGIN TRANSACTION
	
	*-------------------------------------------------------------------------------------*
	* Posiciona no primeiro registro da NF de Devolução                                   *
	*-------------------------------------------------------------------------------------*
	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
	_cChave := SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
	_cTESSD2:= SD2->D2_TES
	
	While SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == _cChave .and. !Eof()
		
		If _cTESSD2 == _cTesFis
			*-------------------------------------------------------------------------------------*
			* Gera estorno das movimentações internas - Estorno Fiscal                            *
			*-------------------------------------------------------------------------------------*
			_cQuery  := " SELECT MIN(R_E_C_N_O_) AS MINREC"+c_ent
			_cQuery  += " FROM "+RetSqlName("SD3")+" SD3 "+c_ent
			_cQuery  += " WHERE D3_FILIAL = '"+xFilial("SD3")+"'
			_cQuery  += " AND D3_XD2NSEQ  = '"+SD2->D2_NUMSEQ+"'"+c_ent
			_cQuery  += " AND D_E_L_E_T_  = ' '"+c_ent
			_cQuery  := ChangeQuery(_cQuery)
			
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasD2,.T.,.T.)
			
			DbSelectArea(_cAliasD2)
			If(!Eof())
				While (!Eof())
					_cEstorno := GetArea()
					U_EDFA008((_cAliasD2)->MINREC)
					RestArea(_cEstorno)
					DbSelectArea(_cAliasD2)
					DbSkip()
				Enddo
			EndIf
			
			(_cAliasD2)->(DbCloseArea())
		EndIf
		
		SZD->(DbSetOrder(2))
		nRegistro := u_BuscaSZD(SC5->C5_XNCONTR,SC5->C5_XNFMAE,SC5->C5_XNSERIM,SD2->D2_NFORI,SD2->D2_SERIORI)
		SZD->(DbGoto(nRegistro))
		If _cTESSD2 == _cTesFis
			*------------------------------------------------------------*
			* Devolução Fiscal - Será sempre do saldo total não recebido *
			*------------------------------------------------------------*
			If SZD->ZD_TOTDEV > SZD->ZD_QTDDEV
				RecLock("SZD", .F.)
				Delete 
				MsUnlock()
				SZD->(DbSkip(-1))
				RecLock("SZD", .F.)
				SZD->ZD_STATUS  := "PL"
			Else
				RecLock("SZD", .F.)
				SZD->ZD_STATUS  := "PL"
				SZD->ZD_NFDEVOL := ""
				SZD->ZD_SERIEDV := ""
				SZD->ZD_SALDO 	:= SD2->D2_QUANT
				SZD->ZD_TOTDEV	-= SD2->D2_QUANT
			EndIf
			MsUnlock()
		Else
			*----------------------------------------------------------------*
			* Caso exista mais de uma devolução o registro será excluido.    *
			* Posiciono no geristro anterior e muda o status.                *
			*----------------------------------------------------------------*
			If SZD->ZD_TOTDEV > SZD->ZD_QTDDEV
				RecLock("SZD", .F.)
				Delete 
				MsUnlock()
				SZD->(DbSkip(-1))
				RecLock("SZD", .F.)
				SZD->ZD_STATUS  := "PL"
			Else	
				RecLock("SZD", .F.)
				SZD->ZD_STATUS  := "PL"
				SZD->ZD_NFDEVOL := ""
				SZD->ZD_SERIEDV := ""
				SZD->ZD_TOTDEV	-= SD2->D2_QUANT
				SZD->ZD_QTDDEV  -= SD2->D2_QUANT
			EndIf
			MsUnlock()
		EndIf
		_nTotDev += SD2->D2_QUANT
		SD2->(DbSkip())
	End
	*----------------------------------------------------------------*
	* O Pedido de Compras sofre atualização somente quando houver    *
	* devoluções fisicas pois, nas devoluções Fiscais não há transi- *
	* tação de mercadoria.                                           *
	*----------------------------------------------------------------*
	SC7->(DbSetOrder(1))
	If SC7->(DbSeek(xFilial("SC7")+SZD->ZD_PEDIDOC))
		nFator := U_EDFFATOR(SC7->C7_PRODUTO) // 16/09/13 - Luis Felipe Nascimento
		RecLock("SC7",.F.)
		If _cTESSD2 == _cTesDev
			SC7->C7_QUJE    += _nTotDev * If(nFator<>0.00,nFator,1)
			SC7->C7_QTDACLA += _nTotDev * If(nFator<>0.00,nFator,1)
		EndIf
		If _cTESSD2 == _cTesFis
			*-------------------------------------------------------------------------*
			* Estorna a eliminação do residuo do pedido de Compras - Devolução Fiscal *
			*-------------------------------------------------------------------------*
			SC7->C7_RESIDUO := " "
		EndIf
		Msunlock()
	EndIf
	
	*----------------------------------------------------------------*
	* Os Saldos dos Contratos so sofreram atualização quando houver  *
	* devoluções fisicas pois, nas devoluções fiscais não há transi- *
	* tação de mercadoria. AMARRACAO CTR X PRECIFICACAO              *
	*----------------------------------------------------------------*
	If _cTESSD2 == _cTesDev
		SZ7->(DbSetOrder(2))
		SZ7->(Dbseek(xFilial("SZ7")+SC7->C7_CONTRAT+SC7->C7_NRMEDIA))
		If !SZ7->(EOF())
			RecLock("SZ7" ,.F.)
			If SZ7->Z7_SALDO=0
				SZ7->Z7_STATUS	:= "1"
			EndIf
			SZ7->Z7_SALDO -= _nTotDev
			MsUnlock()
		EndIf
	EndIf
	
	END TRANSACTION
	
	RestArea(_aMSD2520)
	
EndIf

Return()
