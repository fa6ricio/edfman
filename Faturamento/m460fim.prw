#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460FIM   บAutor  ณLeandro Ribeiro     บ Data ณ  15/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada executado no momento da prepara็ใo do 	  บฑฑ
ฑฑบ          ณdocumento de saida para zerar os saldos e mudar o status da บฑฑ
ฑฑบ          ณna tabela SZD.											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M460FIM()

Local _aArea	:= GetArea() 
Local _cUpd  	:= ""
Local _cTesFis	:= Alltrim(SuperGetMV("MV_XTESFIS",.t.,"501"))
Local _cTesDev	:= Alltrim(SuperGetMV("MV_XTESDEV",.t.,"507"))

Public 	cNumSeqSD2  := SD2->D2_NUMSEQ

// Wilbis Paulo 12/01/2026
If Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD, "B1_XCONTCT") == "2"
	RestArea(_aArea)
	Return
EndIf
// Fim Wilbis Paulo 12/01/2026

If SD2->D2_TIPO == "D" .and. SD2->D2_TES $ _cTesFis+"|"+_cTesDev
	_cUpd := " Update "+RetSqlName("SD3")
	_cUpd += " Set D3_XD2NSEQ = '"+cNumSeqSD2+"'"
	_cUpd += " Where D_E_L_E_T_ <> '*'"
	_cUpd += " And D3_NUMSEQ = '"+SD3->D3_NUMSEQ+"'"
    TcSqlExec(_cUpd)
EndIf

If SF2->F2_TIPO $ "D"

	dbSelectArea("SC5")
	dbSetOrder(1)
	("SC5")->( dbSeek(xFilial("SC5")+SD2->D2_PEDIDO ))
	//------------------------------------------------------------------------------------------------------------------------------------//
	
	_cQuery := " SELECT D1_COD, D1_UM, D1_LOCAL, SUM(ZD_SALDO) AS MINIMO " + CRLF
	_cQuery += " FROM" +RETSQLNAME("SZD")+" SZD" + CRLF
	_cQuery += " INNER JOIN "+RETSQLNAME("SD1")+" SD1" + CRLF
	_cQuery += " ON ZD_FILIAL = D1_FILIAL" + CRLF
	_cQuery += " AND ZD_NFREMES = D1_DOC" + CRLF
	_cQuery += " AND ZD_SERIER = D1_SERIE" + CRLF
	_cQuery += " WHERE" + CRLF
	_cQuery += " ZD_FILIAL = '"+xFilial("SZD")+"'" + CRLF
	_cQuery += " AND ZD_QTDREC < ZD_QTDNFRE " + CRLF
	_cQuery += " AND ZD_SALDO <> 0 " + CRLF
	_cQuery += " AND ZD_STATUS = 'PL' " + CRLF
	_cQuery += " AND D1_FORNECE = (SELECT A2_COD
	_cQuery += " FROM" +RETSQLNAME("SA2")+" SA2" + CRLF
	_cQuery += " WHERE" + CRLF
	_cQuery += " A2_CGC = (SELECT ZD_CNPJUSI" + CRLF
	_cQuery += " FROM" +RETSQLNAME("SZD")+" SZD" + CRLF
	_cQuery += " WHERE" + CRLF
	_cQuery += " ZD_FILIAL = '"+xFilial("SZD")+"'" + CRLF
	_cQuery += " AND ZD_CONTRA = '"+SC5->C5_XNCONTR+"'" + CRLF
	_cQuery += " AND D_E_L_E_T_ = ''" + CRLF
	_cQuery += " GROUP BY ZD_CNPJUSI)" + CRLF
	_cQuery += " AND D_E_L_E_T_ = '')" + CRLF
	_cQuery += " AND SD1.D_E_L_E_T_ = ' '" + CRLF
	_cQuery += " AND SZD.D_E_L_E_T_ = ' '" + CRLF
	_cQuery += " GROUP BY D1_COD, D1_UM, D1_LOCAL" + CRLF
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasTR,.T.,.T.)
	
	DbSelectArea(_cAliasTR)
	If(!Eof())
		While (!Eof())
			_QuanTras  := _QuanTras+(_cAliasTR)->MINIMO
			_cxCodProd := (_cAliasTR)->D1_COD
			_cxUM	   := (_cAliasTR)->D1_UM
			_cxLocal   := (_cAliasTR)->D1_LOCAL
			DbSkip()
		Enddo
	EndIf
	
	TrSD2xSD3(_QuanTras,"2",_cxCodProd,_cxUM,_cxLocal)
	
	DbSelectArea("SZD")
	DbSetOrder(2)
	If(DbSeek(xFilial("SZD")+SC5->C5_XNCONTR+SC5->C5_XNFMAE+SC5->C5_XNSERIM))
		
		DbSelectArea("SC7")
		DbSetOrder(1)
		If(DbSeek(xFilial("SC7")+SZD->ZD_PEDIDOC))
			
			IF(SC7->C7_QUJE < SC7->C7_QUANT)
				
				MA235PC(10,1,SC7->C7_EMISSAO,SC7->C7_EMISSAO,SZD->ZD_PEDIDOC,SZD->ZD_PEDIDOC,SC7->C7_PRODUTO,SC7->C7_PRODUTO,;
				SC7->C7_FORNECE,SC7->C7_FORNECE,SC7->C7_DATPRF,SC7->C7_DATPRF,SC7->C7_ITEM,SC7->C7_ITEM,.T.)
				
			EndIf
			
		EndIf
		
	EndIf
	//------------------------------------------------------------------------------------------------------------------------------------//
	// Update para realizar a mudan็a de status na tabela SZD.
	//------------------------------------------------------------------------------------------------------------------------------------//
	
	cUpdate := " UPDATE "+RETSQLNAME("SZD")+" SET ZD_STATUS = 'BX', ZD_QTDDEV = ZD_SALDO, ZD_SALDO = 0, ZD_NFDEVOL = '"+SD2->D2_DOC+"', ZD_SERIEDV = '"+SD2->D2_SERIE+"' "+CRLF
	cUpdate += " WHERE"+CRLF
	cUpdate += " ZD_FILIAL = '"+xFilial("SZD")+"'"+CRLF
	cUpdate += " AND ZD_CONTRA = '"+SC5->C5_XNCONTR+"'"+CRLF
	cUpdate += " AND ZD_NFMAE  = '"+SC5->C5_XNFMAE+"'"+CRLF
	cUpdate += " AND ZD_SERIEM = '"+SC5->C5_XNSERIM+"'"+CRLF
	cUpdate += " AND ZD_PARC = (SELECT MAX(CAST(ZD_PARC AS DECIMAL)) AS MAXIMO FROM SZD010 SZD WHERE ZD_FILIAL = '"+xFilial("SZD")+"'"+CRLF
	cUpdate += " AND ZD_CONTRA = '"+SC5->C5_XNCONTR+"'"+CRLF
	cUpdate += " AND ZD_NFMAE  = '"+SC5->C5_XNFMAE+"'"+CRLF
	cUpdate += " AND ZD_SERIEM = '"+SC5->C5_XNSERIM+"')"+CRLF
	cUpdate += " AND ZD_STATUS = 'PL'"+CRLF
	cUpdate	+= " AND D_E_L_E_T_ = ' '"+CRLF
	
	IF(TcSqlExec(cUpdate) > 0)
		
		Conout( "Aten็ใo Nใo foi feito a baixa da NF "+Alltrim(SC5->C5_XNCONTR)+"da Serie "+Alltrim(SC5->C5_XNSERIM)+" do Contrato "+Alltrim(SC5->C5_XNCONTR))
		DbCloseArea()
		
	EndIf
	
	DbCloseArea()
	
	*'Yttalo P Martins-INICIO---------------------------------------------------------------------'*
	*'quantidade devolvida era feita no PE MT410STTS----------------------------------------------'*
	If SC5->C5_TIPO="D"
		
		nFator := U_EDFFATOR(SD2->D2_COD)
		
		cCHAVE    := ""
		cNRMEDIA  := ""
		n_Qtde    := SC6->C6_QTDVEN/nFator //SC6->C6_QTDVEN/20
		cNFORI    := SC6->C6_NFORI
		cSERIEORI := SC6->C6_SERIORI
		dbSelectArea("SF1")
		dbSetOrder(1)
		If dbSeek(xFilial("SF1")+cNFORI+cSERIEORI)
			cXPEDIDO := SF1->F1_XPEDIDO
			dbSelectArea("SC7")
			dbSetOrder(1)
			If dbSeek(xFilial("SC7")+cXPEDIDO)
				cCHAVE  :=SC7->C7_CONTRAT
				cNRMEDIA:=SC7->C7_NRMEDIA
				RecLock("SC7",.F.)
				SC7->C7_QUJE-=n_Qtde
				MSUnlock()
			EndIf
		EndIF
		Dbselectarea("SZ7")
		DbSetOrder(2)
		SZ7->( Dbseek(xFilial("SZ7")+cCHAVE+cNRMEDIA) )
		IF ! SZ7->(EOF())
			RecLock("SZ7" ,.F.)
			if SZ7->Z7_SALDO=0
				SZ7->Z7_STATUS	:= "1"
			endif
			SZ7->Z7_SALDO   := SZ7->Z7_SALDO+n_Qtde
			MsUnlock()
		ENDIF
		
	ENDIF
EndIf

RestArea(_aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460FIM   บAutor  ณMicrosiga           บ Data ณ  07/31/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ      													  บฑฑ
*----------------------------------------------------------------*        บฑฑ
* a260Processa - Gera lan็amento de transferencia entre armazens *        บฑฑ
* Tem que estar posicionado no item da NF Remessa                *        บฑฑ
*----------------------------------------------------------------*        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



Static Function TrSD2xSD3(nQtd,cTipo,_cCodProd,_cUM,_cLocal)

Local cCodOrig 		:= _cCodProd//SD1->D1_COD
Local cUmOrig  		:= _cUM//SD1->D1_UM
Local cLocOrig 		:= If(cTipo=="1",_cLocal,Alltrim(_cLocal)+"01")
Local cLoclzOrig	:= ""
Local cNumLote  	:= ""
Local cNumSerie 	:= ""
Local cCodDest 		:= _cCodProd//SD1->D1_COD
Local cUmDest  		:= _cUM//SD1->D1_UM
Local cLocDest 		:= If(cTipo=="1",Alltrim(_cLocal)+"01",_cLocal)
Local cLoclzDest	:= ""
Local nQuant260 	:= nQtd
Local nQuant260D	:= ConvUm(_cCodProd,nQtd,0,2)
Local cLoteDigi		:= ""
Local dDtValid 		:= CtoD("  /  /  ")
Local nPotencia 	:= 0
Local cDocto   		:= ""
Local dEmis260 		:= DdataBase
Local cLoteDigi		:= ""
Local dDtVldDest	:= CtoD("  /  /  ")
Local aArea			:= GetArea()

Private cCusMed  	:= GetMv("MV_CUSMED")
Private cCadastro	:= OemToAnsi("Transfer๊ncias")
Private aRegSD3  	:= {}
Private aHeader	 	:= {}
Private aCols 	 	:= {}

If cCusMed == "O"
	Private nHdlPrv 			// Endereco do arquivo de contra prova dos lanctos cont.
	Private lCriaHeader := .T. 	// Para criar o header do arquivo Contra Prova
	Private cLoteEst 			// Numero do lote para lancamentos do estoque
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona numero do Lote para Lancamentos do Faturamento     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SX5")
	DbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	Private nTotal := 0 		// Total dos lancamentos contabeis
	Private cArquivo			// Nome do arquivo contra prova
EndIf

a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,.F.,Nil,Nil,"MATA260",Nil,"",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,nPotencia,cLoteDigi,dDtVldDest)

RestArea(aArea)

Return
