#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE   c_ent      CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460NUM  ºAutor  ³ Luis Felipe Nascim.º Data ³  12/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ O ponto de entrada é executado após a seleção da série na  º±±
±±º          ³ rotina de documento de saída.	  						  º±±
±±º          ³               										      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fazer a transferência entre armazens antes da geração da   º±±
±±º          ³ Nota Fiscal de Devolução (Devolução Fiscal).               º±±
±±º          ³ Atualizar tabela de retaguarda ambos os tipos de devolução º±±
±±º          ³ Fiscal ou Física.                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460NUM()

Local _aArea	:= GetArea()
Local _cPedido  := PARAMIXB[1][1]
Local _lRet 	:= .T.
Local _lFiscal  := .F.
Local _nTotDev  := 0
Local _cTesFis	:= Alltrim(SuperGetMV("MV_XTESFIS",.t.,"501"))
Local _cTesDev	:= Alltrim(SuperGetMV("MV_XTESDEV",.t.,"507"))
Local _cProduto := ""
Local _cTESSC6	:= ""
Local _aSZD 	:= {}

Public 	aNumSeqSD3  := {}

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+_cPedido))

SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

// Wilbis Paulo 12/01/2026
If Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO, "B1_XCONTCT") == "2"
	RestArea(_aArea)
	Return
EndIf
// Fim Wilbis Paulo 12/01/2026

_cTESSC6	:= SC6->C6_TES
_cProduto 	:= SC6->C6_PRODUTO

If SC5->C5_TIPO == "D" .and. SC6->C6_TES $ _cTesFis+"|"+_cTesDev .and. !Empty(SC5->C5_XNCONTR)
	BEGIN TRANSACTION
	SZD->(DbSetOrder(2))
	While SC5->C5_NUM == SC6->C6_NUM .and. !Eof()
		nRegistro := u_BuscaSZD(SC5->C5_XNCONTR,SC5->C5_XNFMAE,SC5->C5_XNSERIM,SC6->C6_NFORI,SC6->C6_SERIORI)
		SZD->(DbGoto(nRegistro))
		If SC6->C6_TES == _cTesFis
			*----------------------------------------------------------------*
			* Processa a transferência do produto do armazem ex.: 0301 p/ 03 *
			*----------------------------------------------------------------*
			Processa ( { ||  TrSD2xSD3(SC6->C6_QTDVEN,"2",SC6->C6_PRODUTO,SC6->C6_UM,SC6->C6_LOCAL)  } )
		EndIf
		*----------------------------------------------------------------*
		* Atualiza a tabela de retaguarda                                *
		*----------------------------------------------------------------*
		_aSZD := {}
		If !Empty(SZD->ZD_NFDEVOL)
			*--------------------------------------------------------------------------*
			* Altera o status do registro atual.                                       *
			*--------------------------------------------------------------------------*
			RecLock("SZD",.f.)
			If SZD->ZD_QTDREC >= SZD->ZD_QTDNFRE
				SZD->ZD_STATUS  := "BX" // Baixa Total
			Else
				SZD->ZD_STATUS  := "BP" // Baixa Parcial
			EndIf
			MsunLock()
			*--------------------------------------------------------------------------*
			* Nova devolução - Gera novo sequencial para não apagar devolução anterior *
			*--------------------------------------------------------------------------*
			cParc 		:= Soma1(SZD->ZD_PARC)
			cContra		:= SZD->ZD_CONTRA
			cPeriodo	:= SZD->ZD_PERIODO
			cCNPJUsi	:= SZD->ZD_CNPJUSI
			cNUsina 	:= SZD->ZD_NUSINA
			cNFMae		:= SZD->ZD_NFMAE
			cSerieM		:= SZD->ZD_SERIEM
			nQtdMae		:= SZD->ZD_QTDMAE
			cNFREMES	:= SZD->ZD_NFREMES
			cSerieR		:= SZD->ZD_SERIER
			nQtdNFRe	:= SZD->ZD_QTDNFRE
			nSaldo		:= SZD->ZD_SALDO
			cPedido		:= SZD->ZD_PEDIDOC
			nSaldo 		:= SZD->ZD_SALDO
			nQtdRec		:= SZD->ZD_QTDREC
			nTotDev 	:= SZD->ZD_TOTDEV
			cSeqTemp	:= SZD->ZD_SEQTEMP
			cCgcTerm 	:= SZD->ZD_CNPJTER
			cNomeTer 	:= SZD->ZD_NOMETER
			cLocal	 	:= SZD->ZD_LOCAL
			dDataTer 	:= SZD->ZD_DTETERM
			cPlaca		:= SZD->ZD_PLACA
			nQtdTerIn	:= SZD->ZD_QTDTERI
			cCNPJTeI	:= SZD->ZD_CNPJTEI
			dDataTeI	:= SZD->ZD_DTTERMI
			*-----------------------------*
			* Transmite campos para o array
			*-----------------------------*
			For nX:= 1 To FCount()
				Aadd(_aSZD, {fieldname(nX), fieldget(nX)})
			Next
			*--------------------------------------------------------------------------------------------------------*
			* Gera novo registro, a partir do registro atual                                                         *
			*--------------------------------------------------------------------------------------------------------*
			RecLock("SZD",.T.)
			For i:=1 to Len(_aSZD)
				&(_aSZD[i][1]) :=  _aSZD[i][2]
			Next i
			SZD->ZD_FILIAL	:= xFilial("SZD")
			SZD->ZD_CONTRA	:= cContra
			SZD->ZD_PERIODO	:= cPeriodo
			SZD->ZD_CNPJUSI	:= cCNPJUsi
			SZD->ZD_NUSINA	:= cNUsina
			SZD->ZD_NFMAE	:= cNFMae
			SZD->ZD_SERIEM	:= cSerieM
			SZD->ZD_QTDMAE	:= nQtdMae
			SZD->ZD_NFREMES	:= cNFREMES
			SZD->ZD_SERIER	:= cSerieR
			SZD->ZD_QTDNFRE	:= nQtdNFRe
			SZD->ZD_PEDIDOC := cPedido
			SZD->ZD_SEQTEMP := cSeqTemp
			SZD->ZD_DTTEMPL := Ddatabase
			SZD->ZD_PARC	:= cParc
			SZD->ZD_STATUS  := If(nQtdRec >= nSaldo,"BX","BP")
			SZD->ZD_CNPJTER := cCgcTerm
			SZD->ZD_NOMETER := cNomeTer
			SZD->ZD_LOCAL	:= cLocal
			SZD->ZD_DTETERM := dDataTer
			SZD->ZD_QTDTERI := nQtdTerIn
			SZD->ZD_CNPJTEI := cCNPJTeI
			SZD->ZD_DTTERMI := dDataTeI
			SZD->ZD_PLACA   := cPlaca
			SZD->ZD_SALDO   := nSaldo
			SZD->ZD_TOTDEV	:= nTotDev
			SZD->ZD_QTDREC	:= 0
			MsunLock()
		EndIf
		*----------------------------------------------------------------------------------------------------------*
		* Atualiza saldo da parcela atual                                                                          *
		*----------------------------------------------------------------------------------------------------------*
		RecLock("SZD",.f.)
		SZD->ZD_NFDEVOL := cNumero
		SZD->ZD_SERIEDV := cSerie
		SZD->ZD_QTDDEV	:= SC6->C6_QTDVEN
		SZD->ZD_TOTDEV	+= SC6->C6_QTDVEN
		If SC6->C6_TES == _cTesFis
			SZD->ZD_STATUS:= "BX"
			SZD->ZD_SALDO := 0
		Else
			If SZD->ZD_QTDREC >= SZD->ZD_QTDNFRE
				SZD->ZD_STATUS := "BX"
			Else
				SZD->ZD_STATUS := "BP"
			EndIf
		EndIf
		MsUnlock()
		
		_nTotDev += SC6->C6_QTDVEN
		SC6->(DbSkip())
	End
	*----------------------------------------------------------------*
	* O Pedido de Compras sofre atualização somente quando houver    *
	* devoluções fisicas pois, nas devoluções Fiscais não há transi- *
	* tação de mercadoria.                                           *
	*----------------------------------------------------------------*
	
	If _cTESSC6 == _cTesDev
		SC7->(DbSetOrder(1))
		If SC7->(DbSeek(xFilial("SC7")+SZD->ZD_PEDIDOC))
			nFator := U_EDFFATOR(SC7->C7_PRODUTO) // 16/09/13 - Luis Felipe Nascimento
			RecLock("SC7",.F.)
			SC7->C7_QUJE    -= (_nTotDev/If(nFator<>0.00,nFator,1))   				
			SC7->C7_QTDACLA -= (_nTotDev/If(nFator<>0.00,nFator,1))
			MSUnlock()
		EndIf
	EndIf
	*----------------------------------------------------------------*
	* Elimina residuo do pedido de Compras - Devolução Fiscal        *
	*----------------------------------------------------------------*
	If _cTESSC6 == _cTesFis
		IF SC7->C7_QUJE < SC7->C7_QUANT
			MA235PC(10,1,SC7->C7_EMISSAO,SC7->C7_EMISSAO,SZD->ZD_PEDIDOC,SZD->ZD_PEDIDOC,SC7->C7_PRODUTO,SC7->C7_PRODUTO,;
			SC7->C7_FORNECE,SC7->C7_FORNECE,SC7->C7_DATPRF,SC7->C7_DATPRF,SC7->C7_ITEM,SC7->C7_ITEM,.T.)
		EndIf
	EndIf
	*----------------------------------------------------------------*
	* Os Saldos dos Contratos so sofreram atualização quando houver  *
	* devoluções fisicas pois, nas devoluções fiscais não há transi- *
	* tação de mercadoria. AMARRACAO CTR X PRECIFICACAO              *
	*----------------------------------------------------------------*
	If _cTESSC6 == _cTesDev
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
EndIf

RestArea(_aArea)

Return

*----------------------------------------------------------------*
* Posiciona no registro que sofrera a devolução                  *
*----------------------------------------------------------------*

User Function BuscaSZD(cContra,cNFMae,cSerieM,cNFRem,cSerieR)

Local _nRegistro := 0
Local _cQuery	 := ""
Local _cAlias    := GetNextAlias()

_cQuery := " SELECT Max(R_E_C_N_O_) As REGISTRO "+c_ent
_cQuery += " FROM "+RetSqlName("SZD")+" SZD "+c_ent
_cQuery += " WHERE ZD_FILIAL= '"+xFilial("SZD")+"'"+c_ent
_cQuery += " AND ZD_CONTRA 	= '"+cContra+"'"+c_ent
_cQuery += " AND ZD_NFMAE  	= '"+cNFMae+"'"+c_ent
_cQuery += " AND ZD_SERIEM 	= '"+cSerieM+"'"+c_ent
_cQuery += " AND ZD_NFREMES	= '"+cNFRem+"'"+c_ent
_cQuery += " AND ZD_SERIER 	= '"+cSerieR+"'"+c_ent
_cQuery	+= " AND D_E_L_E_T_ = ' '"+c_ent

_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

_nRegistro := (_cAlias)->REGISTRO

DbcloseArea(_cAlias)

Return( _nRegistro )

*----------------------------------------------------------------*
* a260Processa - Gera lançamento de transferencia entre armazens *
* Tem que estar posicionado no item da NF Remessa                *
*----------------------------------------------------------------*

Static Function TrSD2xSD3(_nQtd,cTipo,_cCodProd,_cUM,_cLocal)

Local cCodOrig 		:= _cCodProd
Local cUmOrig  		:= _cUM
Local cLocOrig 		:= If(cTipo=="1",_cLocal,Alltrim(_cLocal)+"01")
Local cLoclzOrig	:= ""
Local cNumLote  	:= ""
Local cNumSerie 	:= ""
Local cCodDest 		:= _cCodProd
Local cUmDest  		:= _cUM
Local cLocDest 		:= If(cTipo=="1",Alltrim(_cLocal)+"01",_cLocal)
Local cLoclzDest	:= ""
Local nQuant260 	:= _nQtd
Local nQuant260D	:= ConvUm(_cCodProd,_nQtd,0,2)
Local cLoteDigi		:= ""
Local dDtValid 		:= CtoD("  /  /  ")
Local nPotencia 	:= 0
Local cDocto   		:= ""
Local dEmis260 		:= DdataBase
Local cLoteDigi		:= ""
Local dDtVldDest	:= CtoD("  /  /  ")
Local aArea			:= GetArea()

Private cCusMed  	:= GetMv("MV_CUSMED")
Private cCadastro	:= OemToAnsi("Transferências")
Private aRegSD3  	:= {}
Private aHeader	 	:= {}
Private aCols 	 	:= {}

If cCusMed == "O"
	Private nHdlPrv 			// Endereco do arquivo de contra prova dos lanctos cont.
	Private lCriaHeader := .T. 	// Para criar o header do arquivo Contra Prova
	Private cLoteEst 			// Numero do lote para lancamentos do estoque
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona numero do Lote para Lancamentos do Faturamento     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SX5")
	DbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	Private nTotal := 0 		// Total dos lancamentos contabeis
	Private cArquivo			// Nome do arquivo contra prova
EndIf

a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,.F.,Nil,Nil,"MATA260",Nil,"",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,nPotencia,cLoteDigi,dDtVldDest)

Aadd(aNumSeqSD3,SD3->D3_NUMSEQ)

RestArea(aArea)

Return
