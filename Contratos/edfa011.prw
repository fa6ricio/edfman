#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.Ch"
#DEFINE   cFimLn      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA011   ºAutor  ³Yttalo P Martins    º Data ³  05/09/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  EDFA011   - Realiza a replicação das alterações no contrato±±
±±º          ³              de compra para o de venda                     º±±
±±º          ³  fCopiaCN9 - Copia CN9                                     º±±
±±º          ³  fCopiaSZ2 - Copia SZ2                                     º±±
±±º          ³  fCopiaSZ3 - Copia SZ3                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BAUCH001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±³Alteracao ³ Luis Felipe Nascimento                       Data: 10/12/14³±±
±±³          ³ A pedido de Rafael Moreira foi retirado da copia os campos ³±±
±±³          ³ Z5_PREMIO4 e Z5_ELEVAC para o contrato de vendas.          ³±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±³Alteracao ³ Luis Felipe Nascimento                       Data: 08/01/15³±±
±±³          ³ A pedido de Rafael Moreira foi retirado da copia os campos ³±±
±±³          ³ Z2_INCOTER e Z2_RETERM  para o contrato de vendas.         ³±±
±±³          ³ E acrescida a função de recalculo da precificação. RDM_043 ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA011()

Local _aGeral        := GetArea()
Local _aAlias        := CN9->(GetArea())

Private aCN9         := {}
Private aSZ2         := {}
Private aSZ3         := {}
Private cNumContr    := Space(TamSx3("CN9_NUMERO")[1])
Private cNumTipo     := Space(TamSx3("CN9_TPCTO")[1])
Private _cCN9_NUMERO := CN9->CN9_NUMERO
Private _cCN9_REVISA := CN9->CN9_REVISA
Private _cCN9_TPCTO  := CN9->CN9_TPCTO
Private _aCli		 := {}
Private cContraVen   := Space(TamSx3("CN9_NUMERO")[1])

If SUBSTR(_cCN9_NUMERO,1,1) == "P"
	
	cContraVen := "S"+SUBSTR( _cCN9_NUMERO,2,LEN(_cCN9_NUMERO) )

	DbSelectArea("CN9")
	DbSetOrder(1)	
	If DbSeek(xFilial("CN9")+cContraVen)	
	
		Processa( {|| fAtuTab()},"Atualizando contrato de venda...")
		
		Aviso("Aviso","Rotina Finalizada com Sucesso! ",{"Ok"})
	
	EndIf	

	
EndIf


RestArea(_aAlias)
RestArea(_aGeral)

Return

**************************************************************************************************

Static Function fAtuTab()

ProcRegua(3)

fCopiaCN9()
fCopiaSZ2()
fCopiaSZ3()

Return



// --------------------------------------------------
// Copia do CN9
// --------------------------------------------------
Static Function fCopiaCN9()

Local nReg := 0
Local cTipContr := ""
Local cRefCon   := ""
Local cxCtROR   := ""
IncProc("Gravando CN9")

aCN9 := {}

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
	
	
	If DbSeek(xFilial("CN9")+cContraVen)
	    
		cTipContr 	:= CN9->CN9_TPCTO
		cRefCon   	:= CN9->CN9_REFCON
		cxCtROR   	:= CN9->CN9_XCTROR	
		cClient		:= CN9->CN9_CLIENT
		cLojaCl		:= CN9->CN9_LOJACL
	
		RecLock("CN9",.F.)
		CN9->(DbDelete())
		CN9->(MsUnlock())
		
		*-----------------------------------------------------------------------------------*
		*Gera registro de Revisao, copiando o registro atual
		*-----------------------------------------------------------------------------------*
		
		DbSelectArea("CN9")
		RecLock("CN9",.T.)
		For i:=1 to Len(aCN9)
			&(aCN9[i][1]) :=  aCN9[i][2]
		Next i
		
		CN9->CN9_NUMERO	    := cContraVen
  		CN9->CN9_XFORNE	    := Space(TamSx3("CN9_XFORNE")[1])
  		CN9->CN9_CLIENT		:= cClient
  		CN9->CN9_LOJACL		:= cLojaCl
		CN9->CN9_TPCTO      := cTipContr 
		CN9->CN9_REFCON     := cRefCon
		CN9->CN9_XCTROR		:= cxCtROR
		
		MsunLock()	
	
	EndIf
	
Endif


DbSelectArea("CN9")
DbSetOrder(1)

Return



// --------------------------------------------------
// Copia do SZ2
// --------------------------------------------------
Static Function fCopiaSZ2()   

Local nReg	  := 0                   

aSZ2 := {}

IncProc("Gravando SZ2")

*-----------------------------------------------------------------------------------*
*Cabecalho da Planilha do Contrato
*-----------------------------------------------------------------------------------*
DbSelectArea("SZ2")
DbSetOrder(1)
If DbSeek(xFilial("SZ2")+_cCN9_NUMERO)

	If DbSeek(xFilial("SZ2")+cContraVen)
		//---------------------------------------------
		While SZ2->Z2_CONTRA == cContraVen .and. !Eof()
			RecLock("SZ2",.F.)
			SZ2->(DbDelete())
			SZ2->(MsUnlock())
		
		SZ2->(DbSkip())
		EndDo   
	    //--------------------------------------------- 
	    
		DbSeek(xFilial("SZ2")+_cCN9_NUMERO)
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
			SZ2->Z2_CONTRA	  := cContraVen
			// 08/01/14 - Luis Felipe Nascimento - inicio
			SZ2->Z2_INCOTER   := "FOB"
			SZ2->Z2_RETERM    := 0    
			// 08/01/14 - Luis Felipe Nascimento - Fim
			MsunLock()
	        
			aSZ2 := {}
			DbGoto(nReg)
			SZ2->(DbSkip())
			
		End   
	
	EndIf
EndIf

DbSelectArea("SZ2")
DbSetOrder(1)

Return



// --------------------------------------------------
// Copia do SZ3
// --------------------------------------------------
Static Function fCopiaSZ3()

aSZ3 := {}

IncProc("Gravando SZ3")

*-----------------------------------------------------------------------------------*
*Cabecalho da Planilha do Contrato
*-----------------------------------------------------------------------------------*
DbSelectArea("SZ3")
DbSetOrder(1)
If DbSeek(xFilial("SZ3")+_cCN9_NUMERO)
    
	If DbSeek(xFilial("SZ3")+cContraVen)
		//---------------------------------------------
		While SZ3->Z3_CONTRA == cContraVen .and. !Eof()
			RecLock("SZ3",.F.)
			SZ3->(DbDelete())
			SZ3->(MsUnlock())
		
		SZ3->(DbSkip())
		EndDo   
	    //--------------------------------------------- 

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
			SZ3->Z3_CONTRA	  := cContraVen 
			SZ3->Z3_PREMIO4   := 0   // 10/12/14 - Luis Felipe
			SZ3->Z3_ELEVAC    := 0   // 10/12/14 - Luis Felipe
			SZ3->Z3_POLDP     := 0   // 13/01/14 - Luis Felipe - RDM_043
			MsunLock()
			
			aSZ3 := {}
			DbGoto(nReg)
			SZ3->(DbSkip())
		End
    
	EndIf
EndIf

DbSelectArea("SZ3")
DbSetOrder(1)

Return