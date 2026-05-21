#INCLUDE "rwmake.ch"
#Include "eec.ch"
#INCLUDE "APWIZARD.CH"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xCAPAEEC   º Autor ³ Luiz Pereira      º Data ³  08/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Correcao de alguns campos na capa do embarque e fabricante º±±
±±º          ³ nos itens de embarque                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ED & Fman                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Funcao      : xCAPAEEC
Parametros  : cOrigem
Retorno     : .T./.F.
Objetivos   : Alteracao de Informações no processo
Autor       : Luiz Pereira
Data/Hora   : 10/07/2015
/*/

******************************
User Function xCAPAEEC()
******************************

Local cAlias  := "EEC"
Local oDlg, bOk, bCancel, nOpcA := 0
Local lRet

Local bNavio := "EEC_EMBARC" // F3 = EE6
Local bForn  := "EEC_FORN"   // EEC_FOLOJA
Local bFabr  := "EE9_FABR"   // EE9_FALOJA
Local bDest  := "EEC_DEST"   // F3 = SY9 - Destino
Local bMarc  := "EEC_MARCAC"
Local bObsPed:= "EEC_OBSPED"

Local aObjPC := { "oSayNavioP", "oSayFornP" , "oSayFabrP", "oSayDest"  , "oSayMarc" , "oSayObs" } 			  ,;
	  aObjPD := { "oSayNavioD", "oGetNavioD", "oSayFornD", "oGetFornD" , "oGetLJFrD", "oGetNoFrD"			  ,;
			      "oSayFabrD" , "oGetFabrD" , "oSayDestD", "oGetNoDstD", "oGetDestD","oGetLJFbD", "oGetNoFbD" ,;
			      "oSayMarcD" , "oGetMarcD", "oSayObsD"  , "oGetObsD"  }

Local cAliasWork := IF(cAlias == "EEC","WorkIP","WorkIt")
Local nRecWork := (cAliasWork)->(RecNo())

Private aRadio   := {}
Private oRadio   := NIL
Private nRadio   := 1
Private lDetail  := .T.
Private oDlgEE9  := NIL
Private cCodEE9  := Space(Len(EE9->EE9_COD_I))
Private nQtdEE9  := 0 //Space(Len(EE9->EE9_SLDINI))
Private nVlrEE9  := 0 //Space(Len(EE9->EE9_PRECO))
Private cNumProc := Space(15)

Private xEE7Navio := ""
Private xSC5Book  := ""
Private lInfProc  := .F.,;  //Valor Lógico do Objeto CheckBox Dados Informados no Processo.
		lInfDigit := .T.,;  //Valor Lógico do Objeto CheckBox Dados Digitados para Ajustes.
		lEECDigit := .F.

Private cNavio  := EEC->EEC_EMBARC,;
		cForn   := EEC->EEC_FORN  ,;
		cLjFor  := EEC_FOLOJA     ,;
		cNomFor := Posicione("SA2",1,xFilial("SA2")+cForn+cLjFor   				  	,"A2_NREDUZ"  ),;
		cFabr   := Posicione("EE9",2,xFilial("EE9")+EEC->EEC_PREEMB+EEC->EEC_PEDREF	,"EE9_FABR"   ),;
		cLjFabr := Posicione("EE9",2,xFilial("EE9")+EEC->EEC_PREEMB+EEC->EEC_PEDREF	,"EE9_FALOJA" ),;
		cNomFab := Posicione("SA2",1,xFilial("SA2")+cFabr+cLjFabr  				  	,"A2_NREDUZ"  ),;
		cDest   := EEC->EEC_DEST  																   ,;
		cNDest  := Posicione("SY9",1,xFilial("SY9")+cDest          				  	,"Y9_DESCR"   )

cMarcEec := ""
mMarcEec:= MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO),,,LERMEMO)
		   	For i:=1 To MlCount(mMarcEec,AVSX3("EEC_MARCAC",AV_TAMANHO))
				cMarcEec := cMarcEec+MemoLine(mMarcEec,AVSX3("EEC_MARCAC",AV_TAMANHO),i)+chr(13)+chr(10)
          	Next
cObsEec := ""
mObsEec := MSMM(EEC->EEC_CODOBP,AVSX3("EEC_OBSPED",AV_TAMANHO),,,LERMEMO)
			For i:=1 To MlCount(mObsEec,AVSX3("EEC_OBSPED",AV_TAMANHO))
				cObsEec := cObsEec+MemoLine(mObsEec,AVSX3("EEC_OBSPED",AV_TAMANHO),i)+chr(13)+chr(10)
			Next
 
Private cNavioD  := EEC->EEC_EMBARC,;
		cFornD   := EEC->EEC_FORN  ,;
		cLjForD  := EEC_FOLOJA     ,;
		cNomForD := Posicione("SA2",1,xFilial("SA2")+cFornD+cLjForD 				 ,"A2_NREDUZ"  ),;
		cFabrD   := Posicione("EE9",2,xFilial("EE9")+EEC->EEC_PREEMB+EEC->EEC_PEDREF ,"EE9_FABR"   ),;
		cLjFabrD := Posicione("EE9",2,xFilial("EE9")+EEC->EEC_PREEMB+EEC->EEC_PEDREF ,"EE9_FALOJA" ),;
		cNomFabD := Posicione("SA2",1,xFilial("SA2")+cFabrD+cLjFabrD				 ,"A2_NREDUZ"  ),;
		cDestD   := EEC->EEC_DEST  ,;
		cNDestD  := Posicione("SY9",1,xFilial("SY9")+cDestD         				 ,"Y9_DESCR"   )

cMarcEecD := ""
mMarcEecD := MSMM(EEC->EEC_CODMAR,AVSX3("EEC_MARCAC",AV_TAMANHO),,,LERMEMO)
			 For i:=1 To MlCount(mMarcEecD,AVSX3("EEC_MARCAC",AV_TAMANHO))
				cMarcEecD := cMarcEecD+MemoLine(mMarcEecD,AVSX3("EEC_MARCAC",AV_TAMANHO),i)+chr(13)+chr(10)
			 Next
cObsEecD  := ""
mObsEecD  := MSMM(EEC->EEC_CODOBP,AVSX3("EEC_OBSPED",AV_TAMANHO),,,LERMEMO)
			 For i:=1 To MlCount(mObsEecD,AVSX3("EEC_OBSPED",AV_TAMANHO))
				cObsEecD := cObsEecD+MemoLine(mObsEecD,AVSX3("EEC_OBSPED",AV_TAMANHO),i)+chr(13)+chr(10)
			 Next

*************************
Begin Sequence

(cAliasWork)->(dbGoTo(nRecWork))

****************************************************************************
///***** FROM 20, 72 TO 43(tam linha ate rodape), 150 (tam coluna Direita)//
****************************************************************************

Define MSDialog oDlg TITLE "Manutenção de Dados do Embarque após Dta Encerramento" FROM 20, 42 TO 55, 150 OF oMainWnd

Private lInfProc  := .T.,;
		lInfDigit := .F.,;
		lEECDigit := .F.

//***********************************
//Informações Padroes doProcesso
//***********************************
@ 2.0, 0.65 To 17.5, 27

@ 18, 07   CheckBox oCBInfPro Var lInfProc Prompt "Dados Inf no Embarque" Size 75, 08 Of oDlg On Click;
			( Eval( { || lInfDigit := .F.                              ,;
						 lEE9Digit := .F.                              ,;
						 cNomForD:= Posicione("SA2",1,xFilial("SA2")+cFornD+cLjForD ,"A2_NREDUZ"  ),;
						 cNomFabD:= Posicione("SA2",1,xFilial("SA2")+cFabrD+cLjFabrD,"A2_NREDUZ"  ),;
						 cNDestD := Posicione("SY9",1,xFilial("SY9")+cDestD         ,"Y9_DESCR"   ),;
						 oCBInfPro:Refresh(),;
						 oCBInfDig:Refresh(),;
		aEval( aObjPD, { |x| &( x + ":Disable()" ) } ),;
		aEval( aObjPC, { |x| &( x + ":Enable()" ) } ) } ) )
					
@ 3.3, 1.8  Say   oSayNavioP  Var "Navio   Informado" OF oDlg SIZE 35,9
@ 3.3, 7.8  MSGet oGetNavioP  Var cNavio Picture AVSX3("EEC_EMBARC",AV_PICTURE) OF oDlg When .F.

@ 4.5, 1.8  Say   oSayFornP  Var "Fornec  Informado" OF oDlg SIZE 35,9
@ 4.5, 7.8  MSGet oGetForP   Var cForn   Picture AVSX3("EEC_FORN"  ,AV_PICTURE) OF oDlg When .F.
@ 4.5, 12.8 MSGet oGetForP   Var cLjFor  Picture AVSX3("EEC_FOLOJA",AV_PICTURE) OF oDlg When .F.
@ 5.5, 7.8  MSGet oGetForP   Var cNomFor Picture AVSX3("A2_NREDUZ" ,AV_PICTURE) OF oDlg When .F.

@ 6.5, 1.8  Say   oSayFabrP  Var "Fabric  Informado" OF oDlg SIZE 35,9
@ 6.5, 7.8  MSGet oGetFabrP  Var cFabr   Picture AVSX3("EE9_FABR"  ,AV_PICTURE) OF oDlg When .F.
@ 6.5, 12.8 MSGet oGetFabrP  Var cLjFabr Picture AVSX3("EEC_FOLOJA",AV_PICTURE) OF oDlg When .F.
@ 7.5, 7.8  MSGet oGetFabrP  Var cNomFab Picture AVSX3("A2_NREDUZ" ,AV_PICTURE) OF oDlg When .F.

@ 8.5, 1.8  Say   oSayDest   Var "Destino Informado" OF oDlg SIZE 35,9
@ 8.5, 7.8  MSGet oGetDestP  Var cDest  Picture AVSX3("EEC_DEST",AV_PICTURE) OF oDlg When .F.
@ 9.5, 7.8  MSGet oGetDestP  Var cNDest Picture AVSX3("Y9_DESCR",AV_PICTURE) OF oDlg When .F.

@ 11, 1.8     Say oSayMarc Var "Marcação"   OF oDlg SIZE 35,9
@ 140.5,060.0 Get oGetMarc Var cMarcEec MEMO SIZE 150,45 Pixel OF oDlg When .F.

@ 15, 1.8     Say oSayObs  Var "Obs.Doctos" OF oDlg SIZE 35,9
@ 193.5,060.0 Get oGetObs  Var cObsEec MEMO SIZE 150,45 Pixel OF oDlg When .F.

//*******************************************************
//Dados das novas informaçõe digitadas pós Encerramento
//*******************************************************
@ 2.0, 27.0 To 17.5, 53.2

@ 07, 235.9 CheckBox oCBEECDig Var lEECDigit Prompt "Altera Item Qtd e Valor" Size 70, 08 Of oDlg On Click DialogMov()

@ 18, 235.9 CheckBox oCBInfDig Var lInfDigit Prompt "Alterar Dados/Digitar" Size 70, 08 Of oDlg On Click;
			 ( Eval( { || lInfProc  := .F.                              ,;
						  cNomForD:= Posicione("SA2",1,xFilial("SA2")+cFornD+cLjForD ,"A2_NREDUZ"  ),;
						  cNomFabD:= Posicione("SA2",1,xFilial("SA2")+cFabrD+cLjFabrD,"A2_NREDUZ"  ),;
						  cNDestD := Posicione("SY9",1,xFilial("SY9")+cDestD         ,"Y9_DESCR"   ),;
						  oCBInfPro:Refresh(),;
						  oCBInfDig:Refresh(),;
					aEval( aObjPC, { |x| &( x + ":Disable()" ) } ),;
					aEval( aObjPD, { |x| &( x + ":Enable()") } ) } ) ) //"Dígitado"

@ 3.3, 28.0 Say oSayNavioD   Var "Navio Digitado" OF oDlg SIZE 35,9
@ 3.3, 34.0 MSGet oGetNavioD Var cNavioD Picture AVSX3("EEC_EMBARC",AV_PICTURE) F3 "E6_2" OF oDlg When cNavioD

@ 4.5, 28.0 Say   oSayFornD  Var "Fornec Digitado" OF oDlg SIZE 35,9
@ 4.5, 34.0 MSGet oGetFornD  Var cFornD   Picture AVSX3("EEC_FORN"  ,AV_PICTURE) F3 "SA2" Valid EECAtuInf(cFornD) OF oDlg When cFornD
@ 4.5, 39.8 MSGet oGetLJFrD  Var cLjForD  Picture AVSX3("EEC_FOLOJA",AV_PICTURE) OF oDlg  When  cLjFor
@ 5.5, 34.0 MSGet oGetNoFrD  Var cNomForD Picture AVSX3("A2_NREDUZ" ,AV_PICTURE) OF oDlg  When  .F.

@ 6.5, 28.0 Say   oSayFabrD  Var "Fabricante Digitado" OF oDlg SIZE 35,9                                                                   '
@ 6.5, 34.0 MSGet oGetFabrD  Var cFabrD   Picture AVSX3("EE9_FABR"  ,AV_PICTURE) F3 "SA2" Valid EECAtuInf(cFabrD) OF oDlg When cFabrD
@ 6.5, 39.8 MSGet oGetLJFbD  Var cLjFabrD Picture AVSX3("EEC_FOLOJA",AV_PICTURE) OF oDlg  When  cLjFabrD
@ 7.5, 34.0 MSGet oGetNoFbD  Var cNomFabD Picture AVSX3("A2_NREDUZ" ,AV_PICTURE) OF oDlg  When  .F.

@ 8.5, 28.0 Say   oSayDestD  Var "Destino Digitado" OF oDlg SIZE 35,9
@ 8.5, 34.0 MSGet oGetDestD  Var cDestD  Picture AVSX3("EEC_DEST",AV_PICTURE) F3 "SY9" Valid EECAtuInf(cDestD) OF oDlg When cDestD
@ 9.5, 34.0 MSGet oGetNoDstD Var cNDestD Picture AVSX3("Y9_DESCR",AV_PICTURE) OF oDlg  When .F.

@ 11, 28.0    Say oSayMarcD Var "Marcação"   OF oDlg SIZE 35,9
@ 140.5,270.0 Get oGetMarcD Var cMarcEecD MEMO SIZE 150,45 Pixel OF oDlg When cMarcEecD

@ 15, 28.0    Say oSayObsD  Var "Obs.Doctos" OF oDlg SIZE 35,9
@ 193.5,270.0 Get oGetObsD  Var cObsEecD MEMO SIZE 150,45 Pixel OF oDlg When cObsEecD

If ! lInfProc
	aEval( aObjPC, { |x| &( x + ":Disable()" ) } )
End If

If ! lInfDigit
	aEval( aObjPD, { |x| &( x + ":Disable()" ) } )
EndIf

bOk 	:= {|| nOpcA := 1, oDlg:End() }
bCancel := {|| oDlg:End() }

Activate MSDialog oDlg On Init EnchoiceBar(oDlg,bOk,bCancel) Centered

IF nOpcA == 0
	Break
Endif

End Sequence
*************************

IF nOpcA == 1
	
	cOldArea := GetArea()
	
	*******************************************
	**** Corrigindo Inf. Capa do Embarque
	*******************************************
	RecLock("EEC",.F.)
		cEECPed			:= EEC->EEC_PEDREF
		EEC->EEC_EMBARC := cNavioD
		EEC->EEC_FORN   := cFornD
		EEC->EEC_FOLOJA := cLjForD
		EEC->EEC_DEST   := cDestD
		MSMM(,TAMSX3("EEC_MARCAC")[1],,cMarcEecD,INCMEMO,,,"EEC","EEC_CODMAR")
		MSMM(,TAMSX3("EEC_OBSPED")[1],,cObsEecD ,INCMEMO,,,"EEC","EEC_CODOBP")
	MsUnlock("EEC")
	*************************************
	**** Corrigindo Itens do Embarque
	*************************************
	RecLock("EE9",.F.)
		cEE9Cod			:= EE9->EE9_COD_I
		EE9->EE9_FABR   := cFabrD
		EE9->EE9_FALOJA := cLjFabrD
	MsUnlock("EE9")
	
	***********************************************
	**** Corrigindo Inf. Capa do Pedido Export
	***********************************************
	DbSelectArea("EE7")
	DbSetOrder(1)
	If DbSeek(xFilial("EE7")+cEECPed)
		RecLock("EE7",.F.)
			EE7->EE7_FORN   := cFornD
			EE7->EE7_FOLOJA := cLjForD
			EE7->EE7_DEST   := cDestD
			MSMM(,TAMSX3("EE7_MARCAC")[1],,cMarcEecD,INCMEMO,,,"EE7","EE7_CODMAR")
			MSMM(,TAMSX3("EE7_OBSPED")[1],,cObsEecD ,INCMEMO,,,"EE7","EE7_CODOBP")
		MsUnlock("EE7")
		
		xEE7Navio := EE7->EE7_XNAVIO + Space(11)
		
		If Empty(xEE7Navio)
			xEE7Navio := Substr(EEC->EEC_PREEMB,1,9)+SPACE(11)
		Endif
		
		****************************************
		**** Corrigindo Itens do Pedido Export
		****************************************
		DbSelectArea("EE8")
		DbSetOrder(6)
		If DbSeek(xFilial("EE8")+cEECPed+cEE9Cod)
			RecLock("EE8",.F.)
				EE8->EE8_FABR   := cFabrD
				EE8->EE8_FALOJA := cLjFabrD
			MsUnlock("EE8")
		Endif
	Endif
	
	***********************************************
	**** Corrigindo Inf. Capa do Pedido Venda
	***********************************************
	DbSelectArea("SC5")
	DbSetOrder(1)
	If DbSeek(xFilial("SC5")+cEECPed)
		RecLock("SC5",.F.)
			SC5->C5_NAVIO   := cNavioD
		MsUnlock("SC5")
	Endif
	
	xSC5Book := AllTrim(SC5->C5_BOOK)
	
	***********************************************
	**** Corrigindo Inf. Centro de Custo
	***********************************************
	DbSelectArea("CTH")
	DbSetOrder(1)
	If DbSeek(xFilial("CTH")+xEE7Navio)
		RecLock("CTH",.F.)
			CTH->CTH_DESC01  := xSC5Book+" - "+AllTrim(cNavioD)
			CTH->CTH_VESSEL  := cNavioD
		MsUnlock("CTH")
	Endif
	
	RestArea(cOldArea)

   MsgAlert("Informações do Processo Corrigida com Sucesso!"+chr(13)+chr(10)+"Correção efetuada nos Dados do P.Expor, P.Venda,Embarque e Cl.Valor!","Atenção !")
Else	
	MsgAlert("Informações do Processo Não Foram alteradas!","Atenção !")
Endif

Return (nOpcA == 1)

***********************************
Static Function EECAtuInf(cInf)
***********************************

cNomForD:= Posicione("SA2",1,xFilial("SA2")+cFornD+cLjForD ,"A2_NREDUZ"  )
cNomFabD:= Posicione("SA2",1,xFilial("SA2")+cFabrD+cLjFabrD,"A2_NREDUZ"  )
cNDestD := Posicione("SY9",1,xFilial("SY9")+cDestD         ,"Y9_DESCR"   )
oCBInfPro:Refresh()
oCBInfDig:Refresh()

Return(cInf)


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Dialog_Move.prw      | AUTOR | Luiz         | DATA | 31/07/2015 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - DialogMov()
//|           | Funcao que prepara tela inicial                                 |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
******************************
Static FUNCTION DialogMov()
******************************

aAdd(aRadio,"Não Altera Item")
aAdd(aRadio,"Alterar Item")

nRadio   := 1

DEFINE MSDIALOG oDlgEE9 FROM 0,0 TO 60,227 PIXEL TITLE "O que deseja fazer ?"

@ 001,003 TO 020,070 LABEL "" OF oDlgEE9 PIXEL

@ 002,008 RADIO oRadio VAR nRadio ITEMS aRadio[1],aRadio[2] SIZE 050,009 ;
PIXEL OF oDlgEE9 ON CHANGE Detail(oDlgEE9,nRadio)
DEFINE SBUTTON FROM 001,084 TYPE 1 OF oDlgEE9 ENABLE ONSTOP "Confirmar as alterações" ACTION GravaEE9()
DEFINE SBUTTON FROM 015,084 TYPE 2 OF oDlgEE9 ENABLE ONSTOP "Sair..." ACTION oDlgEE9:End()

oDlgEE9:bStart:={||DigEE9(@cCodEE9,@nQtdEE9,@nVlrEE9,@oDlgEE9)}

ACTIVATE MSDIALOG oDlgEE9 CENTER VALID Iif(nRadio==2,!Empty(cCodEE9),.T.)
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Dialog_Move.prw      | AUTOR | Luiz         | DATA | 31/07/2015 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Detail()3                                               |//
//|           | Funcao que expande ou nao o msdialog                            |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
********************************************************
STATIC FUNCTION Detail(oDlgEE9,nRadio)
********************************************************
oDlgEE9:CoorsUpdate()
If nRadio == 2
	If EXP->(DbSeek(xFilial("EXP")+EEC->EEC_PREEMB))
			MsgAlert("Para manutenção de Quantidades e Valores do Embarque!"+chr(13)+chr(10)+"É necessáro Excluir a Invoice! "+chr(13)+chr(10)+"Após as correções favor incluir a invoice !","Atenção !")
			oDlgEE9:End()
		Return
	Else
		oDlgEE9:Move(oDlgEE9:nTop,oDlgEE9:nLeft,235,169)
	Endif
Else
	oDlgEE9:Move(oDlgEE9:nTop,oDlgEE9:nLeft,235,087)
	cCodEE9  := Space(Len(EE9->EE9_COD_I))
	nQtdEE9  := 0
	nVlrEE9  := 0
Endif
Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Dialog_Move.prw      | AUTOR | Luiz         | DATA | 31/07/2015 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - DigEE9()                                               |//
//|           | Funcao que disponibiliza os campos caso o MsDialog for expandido|//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
********************************************************
STATIC FUNCTION DigEE9(cCodEE9,nQtdEE9,nVlrEE9,oDlgEE9)
********************************************************
	@ 034,003 TO 070,112 LABEL "" OF oDlgEE9 PIXEL
	@ 036,006 SAY "Cod Prod" SIZE 25,7 PIXEL OF oDlgEE9
	@ 047,006 SAY "Quant"    SIZE 20,7 PIXEL OF oDlgEE9
	@ 047,058 SAY "Valor"    SIZE 15,7 PIXEL OF oDlgEE9
	@ 036,045 MSGET cCodEE9  F3 "EE9"  VALID VldEE9(cCodEE9) PICTURE "@!" SIZE 60,7 PIXEL OF oDlgEE9
	@ 056,006 MSGET nQtdEE9  		   VALID nQtdEE9 != 0 	 PICTURE AVSX3("EE9_SLDINI",AV_PICTURE) SIZE 50,7 PIXEL OF oDlgEE9
	@ 056,058 MSGET nVlrEE9  		   VALID nVlrEE9 != 0 	 PICTURE AVSX3("EE9_PRECO" ,AV_PICTURE) SIZE 50,7 PIXEL OF oDlgEE9
Return

****************************
Static Function VldEE9()
****************************

If !Empty(cCodEE9)
	nQtdEE9 := EE9->EE9_SLDINI
	nVlrEE9 := EE9->EE9_PRECO
Endif

Return

****************************
Static Function GravaEE9()
****************************  

Local nSaca := 0 

If nQtdEE9 < EE9->EE9_SLDINI .and. !Empty(cCodEE9)
	If !Empty(cCodEE9) .and. nQtdEE9 != 0 .and. nVlrEE9 <> 0
		// 30/09/16 - Luis  Felipe - Inicio
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("EE9")+EE9->E9_COD_I))
		nSaca := 1 / SB1->B1_CONV
		// 30/09/16 - Luis  Felipe - Fim
		Reclock("EE9",.F.)
			If Alltrim(EE9->EE9_EMBAL1) != "001" // Se For diferente de Granel
				If EE9->EE9_SLDINI != nQtdEE9
					EE9->EE9_XQTDEV := EE9->EE9_SLDINI - nQtdEE9 // N - 15,3
					EE9->EE9_XVRDEV := EE9->EE9_PRCTOT - (nQtdEE9 * nSaca)*nVlrEE9 // N - 16,2  
				Endif
				EE9->EE9_SLDINI := nQtdEE9
				EE9->EE9_PRECO  := nVlrEE9  
				EE9->EE9_SLDINI := nQtdEE9
				EE9->EE9_QTDEM1 := nQtdEE9 * nSaca
				EE9->EE9_PRCINC := (nQtdEE9 * nSaca)*nVlrEE9
				EE9->EE9_PRCTOT := (nQtdEE9 * nSaca)*nVlrEE9
				EE9->EE9_PSLQTO := (nQtdEE9 * EE9->EE9_PSLQUN)
				EE9->EE9_PSBRTO := (nQtdEE9 * nSaca) * EE9->EE9_PSBRUN
			Else
				If EE9->EE9_SLDINI != nQtdEE9
					Alert(EE9->EE9_EMBAL1)
					EE9->EE9_XQTDEV := EE9->EE9_SLDINI - nQtdEE9
					EE9->EE9_XVRDEV := EE9->EE9_PRCTOT - (nQtdEE9 * nVlrEE9)
				Endif
				EE9->EE9_SLDINI := nQtdEE9
				EE9->EE9_QTDEM1 := nQtdEE9
				EE9->EE9_PRCINC := (nQtdEE9 * nVlrEE9)
				EE9->EE9_PRCTOT := (nQtdEE9 * nVlrEE9)
				EE9->EE9_PSLQTO := (nQtdEE9 * EE9->EE9_PSLQUN)
				EE9->EE9_PSBRTO := (nQtdEE9 * EE9->EE9_PSBRUN)
			Endif
		MsUnlock("EE9")
		cNumProc := EE9->EE9_PREEMB
	Endif
	*************************************
	*** Correção da Capa do Processo
	*************************************
	cOldAreaEEC := GetArea()
	
	DbSelectArea("EE9")
	DbSetOrder(3)
	nVrTot := 0
	nPstLiq:= 0
	nPstBru:= 0
	If DbSeek(xFilial("EE9")+cNumProc+Space(5)+"1")
		While EE9->EE9_FILIAL+EE9->EE9_PREEMB == xFilial("EE9")+cNumProc
				nVrTot  += EE9->EE9_PRCTOT
				nPstLiq += EE9->EE9_PSLQTO
				nPstBru += EE9->EE9_PSBRTO
			DbSkip()
		EndDo
	Endif
	
	DbSelectArea("EEC")
	DbSetOrder(1)
	If DbSeek(xFilial("EEC")+cNumProc)
		RecLock("EEC",.F.)
			EEC->EEC_TOTPED := nVrTot
			EEC->EEC_PARCEL := nVrTot
			EEC->EEC_VLFOB  := nVrTot                                                                                                      
			EEC->EEC_TOTLIQ := nVrTot
			EEC->EEC_TOTFOB := nVrTot
			EEC->EEC_PESLIQ := nPstLiq
			EEC->EEC_PESBRU := nPstBru
		MsUnlock("EEC")
	Endif

		MsgAlert("Informações de Quant/Valor do Processo Corrigida com Sucesso!"+chr(13)+chr(10)+"Correção efetuada somente nos Dados de Embarque!","Atenção !")
		oDlgEE9:End()
		lEECDigit := .F.
		oCBEECDig:Refresh()
	
	RestArea(cOldAreaEEC)
	*************************************

Else  

	If nQtdEE9 >= EE9->EE9_SLDINI
		MsgAlert("Devolução apenas para quantidades Menores do que o Processo!"+chr(13)+chr(10)+"Quant/Valor Não Foram alteradas!","Atenção !")
	Endif
	If Empty(cCodEE9)
		MsgAlert("O Produto deve ser informado para alteração!"+chr(13)+chr(10)+"Quant/Valor Não Foram alteradas!","Atenção !")
	Endif
	
	oDlgEE9:End()
	lEECDigit := .F.
	oCBEECDig:Refresh()

Endif

Return