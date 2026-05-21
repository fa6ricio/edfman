#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.Ch"
#DEFINE   cFimLn      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA003   ºAutor  ³Alexandre Santos    º Data ³  10/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  EDFA003   - Realiza a copia do contrato ponteirado. A     º±±
±±º          ³              Rotina contempla a cópia das tabelas CN9, CNC,º±±
±±º          ³              CNN, SZ2 e SZ3.                               º±±
±±º          ³  fCopiaCN9 - Copia CN9                                     º±±
±±º          ³  fCopiaSZ2 - Copia SZ2                                     º±±
±±º          ³  fCopiaCNC - Copia CNC                                     º±±
±±º          ³  fCopiaSZ3 - Copia SZ3                                     º±±
±±º          ³  fCopiaCNN - Copia CNN                                     º±±
±±º          ³  EDFA003A  - Rotina utilizada no modo de edição do campo   º±±
±±º          ³              CN9_DTINIC, para liberar a edição quando o    º±±
±±º          ³              contrato for copiado.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteração ³ Luís Felipe Nascimento                           08/01/15 º±±
±±º          ³ Alterada a situação do contrato copiado de 05 vigente paraº±±
±±º          ³ 02 em elaboração e alterada a condição do campo X3_WHEN   º±±
±±º          ³ de INCLUI para INCLUI .or. M->CN9_SITUAC = '02'           º±±
±±º          ³                                                           º±±
±±º          ³ Solcitado o descarte da elevação sobre a copia de contra- º±±
±±º          ³ tos de vendas. Z3_ELEVAV = 0 (fCopiaSZ3)                  º±±
±±º          ³                                                           º±±
±±º          ³                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteração ³ Luís Felipe Nascimento                           05/11/15 º±±
±±º          ³ RDM_054 - Contratos em Real                               º±±
±±º          ³ Adequação na copia dos Contratos de Compras para Vendas.  º±±
±±º          ³ Quando o de origem for em Real o de Destino será con-     º±±
±±º          ³ vertido para dolar através da Taxa informada.             º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA003

Local _aGeral      := GetArea()
Local _aAlias      := CN9->(GetArea())

Private aCN9       := {}
Private aSZ2       := {}
Private aCNC       := {}
Private aSZ3       := {}
Private cNumContr  := Space(TamSx3("CN9_NUMERO")[1])
Private cNumTipo   := Space(TamSx3("CN9_TPCTO")[1])
Private _cCN9_NUMERO := CN9->CN9_NUMERO
Private _cCN9_REVISA := CN9->CN9_REVISA
Private _cCN9_TPCTO  := CN9->CN9_TPCTO
Private _cCN9_MOEDA  := CN9->CN9_MOEDA
Private _aCli		 := {}  
Private cEspCtr		 := ""
Private nTaxaUs		 := 1	

DEFINE MSDIALOG oDlg2 FROM 0,0 TO 220,470 TITLE "Copia de Contrato" PIXEL OF oMainWnd

@ 010, 005 To 045, 225 Label "Contrato Atual" OF oDlg2 PIXEL

@ 25, 010 SAY  "Número"  SIZE 80, 7 OF oDlg2 PIXEL
@ 25, 032 MSGET _cCN9_NUMERO When .F. SIZE 50,08 PIXEL OF oDlg2

@ 25, 085 SAY  "Tipo"  SIZE 20, 7 OF oDlg2 PIXEL
@ 25, 112 MSGET _cCN9_TPCTO When .F. SIZE 25,08 PIXEL OF oDlg2
@ 25, 142 SAY  Posicione("CN1", 1, xFilial("CN1") + _cCN9_TPCTO, "CN1_DESCRI" )  SIZE 70, 7 OF oDlg2 PIXEL

@ 050, 005 To 85, 225 Label "Novo Contrato" OF oDlg2 PIXEL

@ 65, 010 SAY  "Número"  SIZE 80, 7 OF oDlg2 PIXEL
@ 65, 032 MSGET cNumContr PICTURE "@!" SIZE 50,08 OF oDlg2 PIXEL

@ 65, 085 SAY  "Tipo"  SIZE 20, 7 OF oDlg2 PIXEL
@ 65, 112 MSGET cNumTipo PICTURE "@!" F3 "CN1" SIZE 25,08 OF oDlg2 PIXEL

@ 95,060 BUTTON " Ok " SIZE 45,12 Action ( lOk1 := ValidaCN9(), oDlg2:End()) OF oDlg2 PIXEL       // , oDlg2:End()
@ 95,135 BUTTON " Cancelar " SIZE 45,12 Action (lOk1 := .F., oDlg2:End()) OF oDlg2 PIXEL

ACTIVATE MSDIALOG oDlg2 CENTER

If lOk1
	
	CN1->(DbSetOrder(1))
	CN1->(DbSeek(xFilial("CN1")+cNumTipo))
	If "VENDA" $ CN1->(CN1_DESCRI)
		fCliente()
	EndIf
	
	Processa( {|| fCopiaTab(cNumContr)},"Iniciando Copia...")
	
	Aviso("Aviso","Rotina Finalizada com Sucesso! ",{"Ok"})
	
Endif

RestArea(_aAlias)
RestArea(_aGeral)

Return

Static Function fCopiaTab(cNumContr)

ProcRegua(5)

// 08/01/14 - Luís Felipe Nascimento - Inicio
cEspCtr := If(!Empty(CN1->CN1_ESPCTR),CN1->CN1_ESPCTR,"1")
// 08/01/14 - Luís Felipe Nascimento - Fim

// 05/11/15 - Luis Felipe  
// Caso seja realizada a copia de um Contrato de Compras, Moeda Real, para um Contrato de Vendas. O destino deverá ser convertido para doar a partir da taxa informada.
If cNumTipo == "002" .and. _cCN9_TPCTO == "001" .and. _cCN9_MOEDA == 1
   	nTaxaUs := FDialogo()
	If nTaxaUs == 0
		Return
	EndIf 
EndIf

fCopiaCN9(cNumContr)
fCopiaSZ2(cNumContr)
fCopiaCNC(cNumContr)
fCopiaSZ3(cNumContr)
fCopiaCNN(cNumContr)

Return

Static Function ValidaCN9()
Local _lRet  := .T.
Local cQuery := ""

If MsgYesno("Confirma a Cópia do Contrato? ")
	
	If Empty(Alltrim(cNumContr)).And._lRet
		Aviso("Aviso","O número do Contrato deve ser preenchido",{"Ok"})
		_lRet := .F.
	EndIf
	
	If Empty(Alltrim(cNumTipo)).And._lRet
		Aviso("Aviso","O Tipo do Contrato deve ser preenchido",{"Ok"})
		_lRet := .F.
	EndIf
	
	cQuery := " SELECT * FROM "+RetSQLName("CN9") 			+cFimLn
	cQuery += "	WHERE D_E_L_E_T_ = ' ' "                 	+cFimLn
	cQuery += "	AND CN9_FILIAL	 ='"+xFilial("CN9")  +"'" 	+cFimLn
	cQuery += "	AND CN9_NUMERO	 ='"+cNumContr+"'"       	+cFimLn
	
	If Select( "TMP" ) > 0
		DbSelectArea( "TMP" )
		DbCloseArea()
	End If
	
	TCquery cQuery New Alias "TMP"
	
	If !TMP->(Eof()).And._lRet
		_lRet := .F. 	// Existe o Registro
		Aviso("Aviso","O Contrato "+cNumContr+" já existe na base. Utilize outro Número de Contrato para realizar a cópia. " ,{"Ok"})
	EndIf
	
EndIf

Return _lRet

// --------------------------------------------------
// Copia do CN9
// --------------------------------------------------
Static Function fCopiaCN9(pNumContr)

IncProc("Gravando CN9")

*-----------------------------------------------------------------------------------*
*Cabecalho da Planilha do Contrato
*-----------------------------------------------------------------------------------*
DbSelectArea("CN9")
DbSetOrder(1)

*-----------------------------------------------------------------------------------*
*Transmite campos para o array
*-----------------------------------------------------------------------------------*

If DbSeek(xFilial("CN9")+_cCN9_NUMERO+_cCN9_REVISA)
	For nX:= 1 To FCount()
		Aadd(aCN9, {fieldname(nX), fieldget(nX)})
	Next
Endif

*-----------------------------------------------------------------------------------*
*Gera registro de Revisao, copiando o registro atual
*-----------------------------------------------------------------------------------*

DbSelectArea("CN9")
RecLock("CN9",.T.)
For i:=1 to Len(aCN9)
	&(aCN9[i][1]) :=  aCN9[i][2]
Next i

CN9->CN9_NUMERO	    := pNumContr
CN9->CN9_REVISA	    := "   "
CN9->CN9_TPCTO      := cNumTipo
//	CN9->CN9_DTINIC   := CTOD("//")
//	CN9->CN9_DTASSI   := CTOD("//")
CN9->CN9_XCTROR     := _cCN9_NUMERO  
//  08/01/15 - Luís Felipe Nascimento - Inicio
CN9->CN9_SITUAC     := "02"
//  08/01/15 - Luís Felipe Nascimento - Fim
If Len(_aCli) <> 0
	CN9->CN9_CLIENT		:= _aCli[1][1]
	CN9->CN9_LOJACL		:= _aCli[1][2]
	CN9->CN9_XFORNE		:= ""
EndIf

If cNumTipo == "002" .and. _cCN9_TPCTO == "001" .and. _cCN9_MOEDA == 1
	CN9->CN9_MOEDA := 2
EndIf

MsunLock()

Return

// --------------------------------------------------
// Copia do SZ2
// --------------------------------------------------
Static Function fCopiaSZ2(pNumContr)   

Local nReg	  := 0                   

IncProc("Gravando SZ2")

*-----------------------------------------------------------------------------------*
*Cabecalho da Planilha do Contrato
*-----------------------------------------------------------------------------------*
DbSelectArea("SZ2")
DbSetOrder(1)
If DbSeek(xFilial("SZ2")+_cCN9_NUMERO)
	
	While SZ2->Z2_CONTRA == _cCN9_NUMERO .and. !Eof()
		
		nReg := Recno()
		
		*-----------------------------------------------------------------------------------*
		*Transmite campos para o array
		*-----------------------------------------------------------------------------------*
		For nX:= 1 To FCount()
			Aadd(aSZ2, {fieldname(nX), fieldget(nX)})
		Next
		
		*-----------------------------------------------------------------------------------*
		*Gera registro de Revisao, copiando o registro atual
		*-----------------------------------------------------------------------------------*
		DbSelectArea("SZ2")
		RecLock("SZ2",.T.)
		For i:=1 to Len(aSZ2)
			&(aSZ2[i][1]) :=  aSZ2[i][2]
		Next i
		SZ2->Z2_CONTRA	  := pNumContr 
		// 08/01/14 - Luís Felipe Nascimento - Inicio
		If cEspCtr == "2"
			SZ2->Z2_INCOTER   := "FOB"
			SZ2->Z2_RETERM    := 0    
		EndIf	
		// 08/01/14 - Luís Felipe Nascimento - Fim
		MsunLock()

		DbGoto(nReg)
		SZ2->(DbSkip())
		
	End   
	
EndIf

Return

// --------------------------------------------------
// Copia do CNC
// --------------------------------------------------
Static Function fCopiaCNC(pNumContr)

Local aVetCNC := {}
Local j       := 0
Local cRevisa := Space(TamSx3("CN9_REVISA")[1])

DbSelectArea("CNC")
DbSetOrder(1)
DbSeek(xFilial("CNC")+_cCN9_NUMERO)

If	cNumTipo <> "001" 
	Return
EndIf

While CNC->CNC_FILIAL+CNC->CNC_NUMERO == xFilial("CNC")+_cCN9_NUMERO .and. !EOF()
	
	Aadd(aVetCNC, {CNC->CNC_NUMERO, CNC->CNC_CODIGO, CNC->CNC_LOJA })
	
	DbSelectArea("CNC")
	dbSkip()
Enddo

IncProc("Gravando CNC")

*-----------------------------------------------------------------------------------*
*Cabecalho da Planilha do Contrato
*-----------------------------------------------------------------------------------*
DbSelectArea("CNC")
DbSetOrder(1)

For j:= 1 to Len(aVetCNC)
	
	*-----------------------------------------------------------------------------------*
	*Transmite campos para o array
	*-----------------------------------------------------------------------------------*
	
	If DbSeek(xFilial("CNC")+_cCN9_NUMERO+cRevisa+aVetCNC[j][2]+aVetCNC[j][3])
		For nX:= 1 To FCount()
			Aadd(aCNC, {fieldname(nX), fieldget(nX)})
		Next
	Endif
	
	*-----------------------------------------------------------------------------------*
	*Gera registro de Revisao, copiando o registro atual
	*-----------------------------------------------------------------------------------*
	
	DbSelectArea("CNC")
	RecLock("CNC",.T.)
	For i:=1 to Len(aCNC)
		&(aCNC[i][1]) :=  aCNC[i][2]
	Next i
	
	If Len(_aCli) <> 0
		CNC->CNC_CODIGO := ""
		CNC->CNC_LOJA	:= ""
	EndIf
	
	CNC->CNC_NUMERO	  := pNumContr
	
	MsunLock()
	
Next j

Return

// --------------------------------------------------
// Copia do SZ3
// --------------------------------------------------
Static Function fCopiaSZ3(pNumContr)

Local aSZ3 := {}

IncProc("Gravando SZ3")

*-----------------------------------------------------------------------------------*
*Cabecalho da Planilha do Contrato
*-----------------------------------------------------------------------------------*
DbSelectArea("SZ3")
DbSetOrder(1)
DbSeek(xFilial("SZ3")+_cCN9_NUMERO)

While SZ3->Z3_CONTRA == _cCN9_NUMERO .And. !Eof()
	
	nReg := Recno()
	
	*-----------------------------------------------------------------------------------*
	*Transmite campos para o array
	*-----------------------------------------------------------------------------------*
	
	For nX:= 1 To FCount()
		Aadd(aSZ3, {fieldname(nX), fieldget(nX)})
	Next
	
	*-----------------------------------------------------------------------------------*
	*Gera registro de Revisao, copiando o registro atual
	*-----------------------------------------------------------------------------------*
	DbSelectArea("SZ3")
	RecLock("SZ3",.T.)
	For i:=1 to Len(aSZ3)
		&(aSZ3[i][1]) :=  aSZ3[i][2]
	Next i
	SZ3->Z3_CONTRA	  := pNumContr
	// 08/01/15 - Luís Felipe Nascimento - Inicio
	If cEspCtr == "2"
		SZ3->Z3_ELEVAC	  := 0
		SZ3->Z3_PREMIO4   := 0
		SZ3->Z3_POLDP 	  := 0    
		SZ3->Z3_PREMIO1 := SZ3->Z3_PREMIO1 / nTaxaUS
		SZ3->Z3_PREMIO2 := SZ3->Z3_PREMIO2 / nTaxaUS
		SZ3->Z3_PREMIO3 := SZ3->Z3_PREMIO3 / nTaxaUS
		SZ3->Z3_PREMIO5 := SZ3->Z3_PREMIO5 / nTaxaUS
		SZ3->Z3_PREMIO6 := SZ3->Z3_PREMIO6 / nTaxaUS
		SZ3->Z3_PREMIO7 := SZ3->Z3_PREMIO7 / nTaxaUS
	EndIf	
	MsunLock()
	// 08/01/15 - Luís Felipe Nascimento - Fim
	
	aSZ3 := {}
	DbGoto(nReg)
	SZ3->(DbSkip())
End

Return

// --------------------------------------------------
// Copia do CNN
// --------------------------------------------------
Static Function fCopiaCNN(pNumContr)

Local aVetCNN := {}
Local j       := 0

DbSelectArea("CNN")
DbSetOrder(1)
DbSeek(xFilial("CNN")+_cCN9_NUMERO)

While CNN->CNN_FILIAL+CNN->CNN_CONTRA == xFilial("CNN")+_cCN9_NUMERO .and. !EOF()
	
	Aadd(aVetCNN, {CNN->CNN_USRCOD, CNN->CNN_CONTRA, CNC->CNN_TRACOD })
	
	DbSelectArea("CNN")
	dbSkip()
Enddo

IncProc("Gravando CNN")

*-----------------------------------------------------------------------------------*
*Cabecalho da Planilha do Contrato
*-----------------------------------------------------------------------------------*
DbSelectArea("CNN")
DbSetOrder(1)

For j:= 1 to Len(aVetCNN)
	
	*-----------------------------------------------------------------------------------*
	*Transmite campos para o array
	*-----------------------------------------------------------------------------------*
	
	If DbSeek(xFilial("CNN")+aVetCNN[j][1]+aVetCNN[j][2]+aVetCNN[j][3])
		For nX:= 1 To FCount()
			Aadd(aCNN, {fieldname(nX), fieldget(nX)})
		Next
	Endif
	
	*-----------------------------------------------------------------------------------*
	*Gera registro de Revisao, copiando o registro atual
	*-----------------------------------------------------------------------------------*
	
	DbSelectArea("CNN")
	RecLock("CNN",.T.)
	For i:=1 to Len(aCNN)
		&(aCNN[i][1]) :=  aCNN[i][2]
	Next i
	
	CNN->CNN_CONTRA	  := pNumContr
	
	MsunLock()
	
Next j

Return

// Função para utlização no modo de edição do campo "CN9_DTINIC".
User Function EDFA003A
Local _lRet := .F.

If DTOC(CN9->CN9_DTINIC) = "  /  /    "
	_lRet := .T.
EndIf

Return _lRet

*---------------------------------------------------------------------------*
* Luís Felipe Nascimento										 22/08/2013 *
*---------------------------------------------------------------------------*

Static Function fCliente()

Local oVar1, oVar2, oVar3, oBtnOk
Local aCli := {}
Private oDlg, cCliente

cCliente := SPACE( TAMSX3("A1_COD")[1] )

Define MSDialog oDlg Title OemToAnsi("Seleção do Cliente") From 0,0 To 150,380 Pixel

@015,20 Say "Cliente :" Pixel Of oDlg
@015,90 MSGet oVar1  Var cCliente Picture "@!" Size 70,10  F3 "SA1" VALID NAOVAZIO(cCliente) OF oDlg PIXEL

@030,20 Say "Loja :" Pixel Of oDlg
@030,90 MSGet oVar2  Var SA1->A1_LOJA   Picture "@!" Size 70,10  When .f. OF oDlg PIXEL

@045,20 Say "Nome Fantasia :" Pixel Of oDlg
@045,90 MSGet oVar3  Var SA1->A1_NREDUZ  Picture "@!" Size 90,10  When .f. OF oDlg PIXEL

@060,150 Button oBtnOk   Prompt "&Ok"  Size 30,15 Pixel Action (fClient(cCliente,SA1->A1_LOJA),oDlg:End()) Of oDlg

Activate MSDialog oDlg Centered

Return

Static Function fClient(cCliente,cLoja)

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja))

Aadd(_aCli,{SA1->A1_COD,SA1->A1_LOJA})

Return

*-------------------------*
Static Function FDialogo()
*-------------------------*

Private oDlg  := Nil       
Private cRel  := "Dialogo rotina (EDFA003)" 
Private lRetor:= .T.
Private lSair := .F.
Private nTaxaUS := 0

DEFINE MSDIALOG oDlg TITLE cRel FROM 0,0 TO 135,220 OF oDlg PIXEL

@ 06,06 TO 35,106 LABEL "Taxa de Conversão em US$" OF oDlg PIXEL

@ 20, 10 SAY   "Taxa US$"  SIZE 45,7 PIXEL OF oDlg
@ 20, 35 MSGET nTaxaUS     SIZE 40,08 Picture "@e 999.9999" PIXEL OF oDlg

DEFINE SBUTTON FROM 45,10 TYPE 1  OF oDlg ACTION (ValiRel("ok")) ENABLE
DEFINE SBUTTON FROM 45,50 TYPE 2  OF oDlg ACTION (ValiRel("cancel")) ENABLE

ACTIVATE MSDIALOG oDlg CENTER

Return( nTaxaUS )   

**********************************
Static Function ValiRel(cValida)
**********************************

Local lCancela

If cValida = "ok"
	If Empty(nTaxaUS)
		MsgInfo("Favor informar a taxa do Dolar !","Atenção")
		lRetor := .F.
	Else
		oDlg:End()
		lRetor := .T.
	EndIf
Else
	lCancela := MsgYesNo("O não preenchimento da taxa em dolar implicará no cancelamento da copia do Contrato de Vendas, Confirma ?","Atenção")
	If lCancela
		oDlg:End()
		lRetor := .T.
		lSair  := .T.
	Else
		lRetor := .F.
	EndIf
EndIf

Return(lRetor)
