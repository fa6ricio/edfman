#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³EDFA005 ³ Autor ³Yttalo P Martins         ³ Data ³ 17/17/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Còpia da Tabela de Preco                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Opcao da Gravacao sendo:                               ³±±
±±³          ³       [1] Inclusao                                           ³±±
±±³          ³       [2] Alteracao                                          ³±±
±±³          ³       [3] Exclusao                                           ³±±
±±³          ³ExpA1: aHeader                                                ³±±
±±³          ³ExpA2: aCols                                                  ³±±
±±³          ³ExpA3: contrato de venda                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Uso       ³Ao atualizar contrato de compra, verifica se existe contrato  ³±±
±±³          ³de venda, se existir atualiza o de venda com base no de compra³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alteracao ³ Luis Felipe Nascimento                       Data: 15/07/14  ³±±
±±³          ³ A pedido de Rafael Moreira foi retirado da copia os campos   ³±±
±±³          ³ Z5_PREMI04 e Z5_ELEVAC para vendas.                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alteracao ³ Luis Felipe Nascimento                       Data: 12/01/15  ³±±
±±³          ³ Recalculo da Precificação após inclusão e ou atualização do  ³±±
±±³          ³ Contrato de Vendas. Rafael MOreira - RDM_043                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Alteracao ³ Luis Felipe Nascimento                       Data: 06/11/15  ³±±
±±³          ³ RDM_054_Contratos_em_Reais                                   ³±±
±±³          ³ Conversão dos preços do Contrato de Compras p/ o Contrato de ³±±
±±³          ³ vendas a partir da taxa informada pelo operador.             ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function EDFA005(nOpcao,aHeader,aCols,cContraVen)

Local nX        := 0
Local nY        := 0
Local nCntfor   := 0
Local nPosRecNo := IF(SZ5->(EOF()),0,Len(aHeader))
Local bCampo 	:= {|nCPO| Field(nCPO) }
Local cItem     := "000"//Repl("0",Len(SZ6->Z6_CONTROL))
Local nCol		:= 0

Private	nPremio1:= 0
Private	nPremio2:= 0
Private	nPremio3:= 0
Private	nPremio4:= 0
Private	nPremio5:= 0
Private	nPremio6:= 0
Private	nPremio7:= 0
Private	nELEVAC := 0
Private	nPOLDP  := 0

Private nPosCtrat := aScan(aHeader,{|x| AllTrim(x[2]) == "Z6_CONTRA"})
Private nPosPerde := aScan(aHeader,{|x| AllTrim(x[2]) == "Z6_PERDE"})
Private nPosCtrol := aScan(aHeader,{|x| AllTrim(x[2]) == "Z6_CONTROL"})
Private nTaxaUS	  := 1

CN9->(DbSetOrder(1))
CN9->(DbSeek(xFilial("CN9")+M->Z5_CONTRA))

If	CN9->CN9_MOEDA == 1  
	nTaxaUS := FDialogo()
	If nTaxaUS == 0
		Aviso("Atenção","Operação cancelada !",{"Voltar"})
		Return
	EndIf
EndIf

Do Case
	
	// ROTINA PARA INCLUSÃO
	Case nOpcao <> 3
		dbSelectArea("SZ6")
		dbSetOrder(1)
		
		Begin Transaction
		
		DBSELECTAREA("SZ3")
		DBSETORDER(1)
		DBSEEK(xFilial("SZ3")+M->Z5_CONTRA+M->Z5_PERDE)
		nPremio1:=SZ3->Z3_PREMIO1 / nTaxaUS
		nPremio2:=SZ3->Z3_PREMIO2 / nTaxaUS
		nPremio3:=SZ3->Z3_PREMIO3 / nTaxaUS
		nPremio4:=If(Empty(cContraVen),SZ3->Z3_PREMIO4 / nTaxaUS,0) // 15/07/14 - Luis Felipe
		nPremio5:=SZ3->Z3_PREMIO5 / nTaxaUS
		nPremio6:=SZ3->Z3_PREMIO6 / nTaxaUS
		nPremio7:=SZ3->Z3_PREMIO7 / nTaxaUS
		nELEVAC :=If(Empty(cContraVen),SZ3->Z3_ELEVAC / nTaxaUS,0) // 15/07/14 - Luis Felipe // Não existe Elevação e Pol sobre os contratos de vendas.
		nPOLDP  :=If(Empty(cContraVen),SZ3->Z3_POLDP,0)  // 12/01/15 - Luís Felipe - RDM_043
		
		dbSelectArea("SZ5")
		dbSetOrder(1)
		If DbSeek( xFilial("SZ5")+cContraVen+M->Z5_PERDE )
			RecLock("SZ5",.F.)
		Else
			RecLock("SZ5",.T.)
		EndIf
		
		For nCntFor := 1 TO FCount()
			FieldPut(nCntFor,M->&(EVAL(bCampo,nCntFor)))
		Next nCntFor
		
		SZ5->Z5_FILIAL := xFilial("SZ5")
		SZ5->Z5_PREMIO1:= nPremio1
		SZ5->Z5_PREMIO2:= nPremio2
		SZ5->Z5_PREMIO3:= nPremio3
		SZ5->Z5_PREMIO4:= nPremio4  
		SZ5->Z5_PREMIO5:= nPremio5
		SZ5->Z5_PREMIO6:= nPremio6
		SZ5->Z5_PREMIO7:= nPremio7
		SZ5->Z5_ELEVAC := nELEVAC  
		SZ5->Z5_POLDP  := nPOLDP  
		SZ5->Z5_CONTRA := cContraVen
		MsUnLock()
		
		For nX := 1 To Len(aCols)
			
			If !aCols[nX,Len(aCols[nX])]
								
				dbSelectArea("SZ6")
				dbSetOrder(4)  //  ORDENADO POR FILIAL + NUMERO DO CONTRATO + CONTROLE
				If DbSeek( xFilial("SZ6")+cContraVen+aCols[nX][nPosCtrol] )
					
					RecLock("SZ6",.F.)
				Else
					RecLock("SZ6",.T.)
				EndIf
				
				For nY := 1 to Len(aHeader)
					If aHeader[nY][10] <> "V"
						SZ6->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
					EndIf
				Next nY
				SZ6->Z6_FILIAL := xFilial("SZ6")
				SZ6->Z6_CONTRA := cContraVen
				SZ6->Z6_PERDE  := SZ5->Z5_PERDE
				SZ6->Z6_PRICING :=  SZ6->Z6_PRICING / nTaxaUS
				SZ6->Z6_PRECO   :=  SZ6->Z6_PRECO   / nTaxaUS
				SZ6->Z6_TAXAUSD :=  SZ6->Z6_TAXAUSD / nTaxaUS
				SZ6->Z6_MDCENTS :=  SZ6->Z6_MDCENTS / nTaxaUS
				SZ6->Z6_MEDIAG  :=  SZ6->Z6_MEDIAG  / nTaxaUS
				SZ6->Z6_VLFINAL :=  SZ6->Z6_VLFINAL / nTaxaUS
				MsUnLock()
			EndIf
		
		Next nX
		
		// 12/01/15 - Luis Felipe Nascimento - Inicio - RDM_043
		//u_Edfv002("REPLICA","",SZ5->Z5_CONTRA,SZ5->Z5_PERDE) // 12/04/16 - Luis Felipe - Homologação 
		// 12/01/15 - Luis Felipe Nascimento - Fim - RDM_043
		
		End Transaction
		
	/*
	// ROTINA PARA EXCLUSÃO
	Case  nOpcao == 3
	
	Begin Transaction
	
	dbSelectArea("SZ6")
	dbSetOrder(1)
	DbSeek( xFilial("SZ6")+cContraVen+M->Z5_PERDE )
	
	While ( !Eof() .And. xFilial("SZ6") == SZ6->Z6_FILIAL .And. M->Z5_CONTRA == SZ6->Z6_CONTRA .And. M->Z5_PERDE == SZ6->Z6_PERDE)
	
	RecLock("SZ6")
	dbDelete()
	MsUnLock()
	
	dbSelectArea("SZ6")
	dbSkip()
	EndDo
	
	SZ6->(FkCommit())
	
	dbSelectArea("SZ5")
	dbSetOrder(1)
	If DbSeek( xFilial("SZ5")+cContraVen+M->Z5_PERDE )
	RecLock("SZ5",.F.)
	dbDelete()
	MsUnLock()
	EndIf
	End Transaction
	*/
		
EndCase

Return()

*-------------------------*
Static Function FDialogo()
*-------------------------*

Private oDlg  := Nil       
Private cRel  := "Dialogo rotina (EDFA005)" 
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
