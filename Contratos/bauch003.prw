#INCLUDE "APWEBEX.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE MAXGETDAD 99999
#DEFINE MAXSAVERESULT 999
#DEFINE STR0001	"Pesquisar"
#DEFINE STR0002	"Visualizar"
#DEFINE STR0003	"Incluir"
#DEFINE STR0004	"Atualizar"
#DEFINE STR0005	"Excluir"
#DEFINE STR0006	"Envia Preço"
#DEFINE STR0007	"Reajuste"
#DEFINE STR0008	"Legenda"
#DEFINE STR0009 "Manutenção da Tabela de Preço"
#DEFINE STR0014 "Em Negociação"
#DEFINE STR0015 "Contrato Ativo"
#DEFINE STR0016 "Contrato Encerrado"
#DEFINE STR0019 "Busca Produto na tabela"
#DEFINE STR0020 "Busca"
#DEFINE STR0021 "Status"   
#DEFINE STR0022 "Imprimir"       

Static aUltResult

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Função    ³ BAUCH0003  ³ Autor ³ Davi Jesus de Oliveira     - 22/11/2010 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descrição ³ Rotina de Manutencao da Tabela de Preco                      ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ BAUCH003(ExpN1,ExpA1,ExpA2)                                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ ExpN1 = opcional - Numero da opcao selecionada               ³±±
//±±³          ³ ExpA1 = opcional - array cabec.p/ uso na rotina autom.       ³±±
//±±³          ³ ExpA1 = opcional - array itens p/ uso na rotina autom.       ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±³Alteracoes³ Luis Felipe Nascimento                      Data: 05/11/2015 ³±±
//±±³          ³ Adequacoes para a geração / Envio de  Preços em Real.        ³±±
//±±³          ³                                                              ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±³Alteracoes³ Luis Felipe Nascimento                      Data: 20/06/2016 ³±±
//±±³          ³ Usuario Maíra Mattos solicitou que o tratamentos sobre o cam-³±±
//±±³          ³ po Z5_FIX100, onde antes o usuário informa o motivo pelo qual³±±
//±±³          ³ o contrato não fora 100 % fixado em uma única moeda,passasse ³±±
//±±³          ³ a contemplar todas as observações da precificação destes con-³±±
//±±³          ³ trato-dp. O campo que antes era alterado somente através de  ³±±
//±±³          ³ validação, foi alterado para que se permita alterar manual-  ³±±
//±±³          ³ mente. Sendo assim, ambas as observações serão preservadas.  ³±±
//±±³          ³ A descrição passa de 100 Fixado ? para Observações Complemen-³±±
//±±³          ³ tares.                                                        ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function Bauch003(nOpcAuto,xAutoCab,xAutoItens)

Local aCores     := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aAutoCab
PRIVATE aAutoItens
Private aRotina := {{ STR0001	,"AxPesqui"		,0,1,0,.F.},;  //"Pesquisar"
					{ STR0002	,"U_bau03Tab"	,0,2, ,.T.},;  //"Visualizar"
					{ STR0003	,"U_bau03Tab"	,0,3, ,.T.},;  //"Incluir"
					{ STR0004	,"U_bau03Tab"	,0,4, ,.T.},;  //"Atualizar"
					{ STR0005	,"U_bau03Tab"	,0,5, ,.T.},;  //"Excluir"
					{ STR0006	,"U_b03Brw"	    ,0,6, ,.T.},;  //"Enviar Preço"
					{ STR0008	,"U_bau03Leg"	,0,7, ,.T.},;  //"Legenda"
					{ STR0022   ,"U_IMPPRECO"   ,0,8, ,.T.}}  
					

cCadastro := STR0009
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as cores da MBrowse                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCores,{"Z5_STATUS == ' ' ","BR_VERDE"})     // Ativo
Aadd(aCores,{"Z5_STATUS == '1' ","BR_VERMELHO"})  // Encerrado
Aadd(aCores,{"Z5_STATUS == '2' ","BR_AZUL"})  // Complemento // 28/02/14 - Luis Felipe

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Endereca para a funcao MBrowse                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ5")
dbSetOrder(1)
DbSeek(xFilial("SZ5"))
If xAutoCab <> Nil
	aAutoCab   := xAutoCab
	aAutoItens := xAutoItens
	DEFAULT nOpcAuto := 3
	MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"SZ5")
Else
	mBrowse(06,01,22,75,"SZ5",,,,,,aCores)
EndIF          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Integridade da Rotina                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ5")
dbSetOrder(1)
dbClearFilter()




Return(Nil)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Função    ³bau03Tab ³ Autor ³ Davi Jesus             ³ Data ³ 23/11/2010 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³Rotina de Manutencao da Tabela de Preco                       ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³bau03Tab()                                                   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ExpC1: Alias do Arquivo                                       ³±±
//±±³          ³ExpN1: Numero do Registro                                     ³±±
//±±³          ³ExpN2: Opcao do aRotina                                       ³±±
//±±³          ³ExpL1: Comanda visualiz.:se por outra rotina atraves do produto±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
USER Function bau03Tab(cAlias,nReg,nOpc,lConsulta)

Local aArea     := GetArea()
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aInfo     := {}
Local aButtons  := { { "pesquisa"   , { || GdSeek(oGetDad,STR0019,,,If(Type("oGetDad:aIniCpos")=="A",.T.,)) }, STR0019, STR0020 } }
Local aStruSZ6  := {}

Local nStyle    := 0
Local nX        := 0
Local nOpcA     := 0
Local nCntFor   := 0
Local nSaveSx8  := GetSx8Len()

Local cCadastro := STR0009

//Local cQuery    := ""
//Local cSeek     := ""
//Local cWhile    := ""
//Local cAliasSZ6 := "SZ6"

Local lAltera   := nOpc==4             
Local lContinua := .T.
Local lQuery    := .F.

Local oDlg
//Local oGetD
Local aUsButtons:={} 
Local nLote 	:= 0
Local nQtd  	:= 0

Local cDelOk    := "U_bau03DEL" 

Private cQuery    := ""
Private cSeek     := ""
Private cWhile    := ""
Private cAliasSZ6 := "SZ6"
Private npos	  := 0	
Private oGetD

Private aTELA[0][0]
Private aGETS[0]
Private oGetDad    
Private aHeader := {}
Private aCols   := {}

Private nMediaenv:=0   

Private aPageCtrl1	:= {"Provisórios","Definitivos"}

DEFAULT nOpc      := 2
DEFAULT INCLUI    := .F.
DEFAULT ALTERA    := .F.
DEFAULT lConsulta := .F.
Do Case
Case INCLUI 
	nStyle := GD_INSERT+GD_UPDATE+GD_DELETE
Case ALTERA
	nStyle := GD_INSERT+GD_UPDATE+GD_DELETE
OtherWise
	nStyle := 0
EndCase
AADD(aButtons, { "Define PRECO"   , { || U_BCH003PR(SZ5->Z5_CONTRA,SZ5->Z5_PERDE,nPos)}, "Define PRECO", 'Define Prc.' } )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa as variaveis da Enchoice                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If INCLUI 
	RegToMemory( "SZ5", .T., .F. )
EndIf

If !INCLUI 		

	If SoftLock("SZ5")

		RegToMemory( "SZ5", .F., .F. )

		dbSelectArea("SZ6")
		dbSetOrder(1)										

		aStruSZ6 := SZ6->(dbStruct())

		cAliasSZ6 := "SZ6"
		lQuery    := .T.
		cQuery := "SELECT * FROM " + RetSqlName("SZ6")+ " SZ6 "
		cQuery += "WHERE "
		cQuery += "SZ6.Z6_FILIAL = '"+xFilial("SZ6")+"' AND "
		cQuery += "SZ6.Z6_CONTRA = '"+SZ5->Z5_CONTRA+"' AND "
		cQuery += "SZ6.Z6_PERDE = '"+SZ5->Z5_PERDE+"' AND "
		cQuery += "SZ6.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY 1"

		cQuery := ChangeQuery(cQuery)

		SZ6->(dbCloseArea())
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta aHeader e aCols utilizando a funcao FillGetDados.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Sintaxe da FillGetDados(nOpcX,Alias,nOrdem,cSeek,bSeekWhile,uSeekFor,aNoFields,aYesFields,lOnlyYes,cQuery,bMontCols,lEmpty,aHeaderAux,aColsAux,bAfterCols,bBeforeCols,bAfterHeader,cAliasQry |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		//FillGetDados(nOpc,"SZ6",1,cSeek,{|| &cWhile },,,,,cQuery,,,aHeader,aCols, {|aColsX| b03AfterC(aColsX,.f.,cAliasSZ6)} ,,,"SZ6")
		FillGetDados(nOpc,"SZ6",1,cSeek,{|| },,,,,cQuery,,,aHeader,aCols,,,,"SZ6")

		If lQuery
			dbSelectArea(cAliasSZ6)
			dbCloseArea()
			ChkFile("SZ6",.F.)
			dbSelectArea("SZ5")	
		EndIf	
	Else
		lContinua := .F.
	EndIf
Else
	If Empty(aCols)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Sintaxe da FillGetDados(nOpcX,Alias,nOrdem,cSeek,bSeekWhile,uSeekFor,aNoFields,aYesFields,lOnlyYes,cQuery,bMontCols,lEmpty,aHeaderAux,aColsAux,bAfterCols,bBeforeCols,bAfterHeader,cAliasQry |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FillGetDados(nOpc,"SZ6",1,,,,,,,,,.T.,aHeader,aCols,,,)
		aCols[1][aScan(aHeader,{|x| Trim(x[2])=="Z6_CONTROL"})] := GetSxeNum("SZ6","Z6_CONTROL")
	EndIf	
EndIf

// 05/11/2015 - Luis Felipe - Inicio
lReal := .f.
If INCLUI
	If MsgYesNo("Os preços digitados serão de um Contrato em Real ?")
		lReal := .t.
	EndIf
Else
	CN9->(DBSetOrder(1)) 
	CN9->(DbSeek(xFilial("CN9")+SZ5->Z5_CONTRA)) 
	If CN9->CN9_MOEDA == 1
		lReal := .t.
	EndIf
EndIf

If 	lReal  
	aHeader[7][1] := "Preco R$"
	aHeader[9][1] := "Taxa em BRL"
	aHeader[10][1]:= "Media BRL"
	aHeader[11][1]:= "Media Centavos"   
Else
	aHeader[7][1] := "Preco US$"
EndIf
// 05/11/2015 - Luis Felipe - Fim

If lContinua

	dbSelectArea("SZ5")
	SZ6->( dbGotop() )
    nFreeze := 1
	If Type("aAutoCab")=="U" .Or. aAutoCab == Nil
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz o calculo automatico de dimensoes de objetos     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize := MsAdvSize()
		AAdd( aObjects, { 100, 100, .T., .T. } )
		AAdd( aObjects, { 200, 200, .T., .T. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
		aPosObj 	:= MsObjSize( aInfo, aObjects,.T.)
                                    
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL       
		
		EnChoice( "SZ5", nReg, nOpc,,,,,aPosObj[1], , 3, , , , , ,.F. )	
   	  
   		*'YTTALO P MARTINS-INICIO-INCLUSÃO DE VAIDAÇÃO DA EXCLUSÃO DA LINHA-----------------------------------------------------------------------'*
   		//oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,"u_bau03LOk","u_bau03Tok","+Z6_CONTROL",/*acpos*/,nFreeze,MAXGETDAD,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,@aHeader,@aCols)
		oGetD := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nStyle,"u_bau03LOk","u_bau03Tok","+Z6_CONTROL",/*acpos*/,nFreeze,MAXGETDAD,/*fieldok*/,/*superdel*/,cDelOk,oDlg,@aHeader,@aCols)   		
   		*'YTTALO P MARTINS-FIM-INCLUSÃO DE VAIDAÇÃO DA EXCLUSÃO DA LINHA--------------------------------------------------------------------------'*   		
   		
		oGetDad := oGetD
		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||aCols:=oGetD:Acols,nOpcA := 1,If(oGetd:TudoOk(),If(!Obrigatorio(aGets,aTela),nOpcA := 0,oDlg:End()),nOpcA := 0)},{||oDlg:End()},,aButtons )
  	    
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ validando dados pela rotina automatica                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If EnchAuto(cAlias,aAutoCab,{|| Obrigatorio(aGets,aTela)}) .and. MsGetDAuto(aAutoItens,"u_bau03LOk",{||  .T. },aAutoCab,aRotina[nOpc][4])
			nOpcA := 1
		EndIf		
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Rotina de Gravacao da Tabela de preco                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcA == 1 .And. nOpc <> 2
		bau03Grv(nOpc-2,aHeader,aCols)
		While (GetSx8Len() > nSaveSx8 )
			ConfirmSx8()
		EndDo
		EvalTrigger()
	Else
		If nOpc <> 2
			While (GetSx8Len() > nSaveSx8 )		
				RollBackSx8()
			EndDo
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a entrada da Rotina                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsUnLockAll()
FreeUsedCode()
RestArea(aArea)         

If Select("TRB")>0
	dbSelectArea("TRB")
	dbCloseArea()
Endif      

*---------------------------------------------------*
* 18/07/13 - Luis Felipe Nascimento
* Refaz o calculo dos saldos de lotes e quantidades
*---------------------------------------------------*

SZ6->(DbSetOrder(1))
SZ6->(DbSeek(xFilial("SZ6")+SZ5->Z5_CONTRA+SZ5->Z5_PERDE))

While !SZ6->(Eof()) .and. SZ6->Z6_CONTRA+SZ6->Z6_PERDE == SZ5->Z5_CONTRA+SZ5->Z5_PERDE
    If SZ6->Z6_TIPOPRE == "2"
		nLote += SZ6->Z6_LOTE
		nQtd  += SZ6->Z6_TOTTONS
	EndIf	
    SZ6->(DbSkip())
End

// 05/11/2015 - Luis Felipe - Inicio
cMotivo := ""
If (nOpc == 3 .or. nOpc == 4) .And. SZ5->Z5_LOTEPER - nLote == 0 
	If !MsgYesNo("O contrato está 100% fixado na moeda informada ?")
		cMotivo := fDialogo()
	EndIf
EndIf            
// 05/11/2015 - Luis Felipe - Fim

DbSelectArea("SZ5")
RecLock("SZ5",.F.)
SZ5->Z5_SALOT	:= SZ5->Z5_LOTEPER - nLote
SZ5->Z5_SALDO	:= SZ5->Z5_QTDEPER - nQtd
SZ5->Z5_FIX100  := If(Empty(cMotivo),M->Z5_FIX100,cMotivo)  // 20/06/16 - Luis Felipe - Solicitado pela Maíra Mattos 
MsunLock()

Return(nOpcA)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡…o    ³B03AfterC ³ Autor ³davi Jesus de Oliveira ³Data  ³22/11/2010³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡„o ³A funcao trata a excecao na montagem do aCols pela FillGetDa³±±
//±±³          ³dos tratando os campos que deverao ser alterados.           ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ExpA1: aCols de Referencia para uso da funcao.              ³±±
//±±³          ³ExpA2: Array contendo as referencias de Impostos da Tabela  ³±±
//±±³          ³ExpL1: Logica indicando a opcao de Alteracao                ³±±
//±±³          ³ExpL2: Logica indicando a opcao de Exclusao                 ³±±
//±±³          ³ExpL3: Logica indicando a opcao de Copia                    ³±±
//±±³          ³ExpL4: Logica condicional para continuar o processo.        ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function B03AfterC(aColsX,lCopia,cAliasSZ6)

//  USADO PARA COLOCAR AS EXCEÇÕES DO PROGRAMA OU DA NECESSIDADE DA BAUCHE

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³bau03Grv ³ Autor ³ Davi Jesus de Oliveira ³ Data ³ 23/11/2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Gravacao da Tabela de Preco                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³bau03Grv                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Opcao da Gravacao sendo:                               ³±±
±±³          ³       [1] Inclusao                                           ³±±
±±³          ³       [2] Alteracao                                          ³±±
±±³          ³       [3] Exclusao                                           ³±±
±±³          ³ExpA1: aHeader                                                ³±±
±±³          ³ExpA2: aCols                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Alteracao³ Anslista: Luis Felipe nascimento           ³ Data: 05/07/13  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³          ³ Criados novos campos e formula de calculo do Valor Final     ³±±
±±³          ³ Campos Adic.: Z3_PREMIO4,Z3_PREMIO5 e Z3_ELEVAC				³±±
±±³          ³             : Z5_PREMIO4,Z5_PREMIO5 e Z5_ELEVAC				³±±
±±³          ³ Campos Des. : Z6_PREMIO2 e Z6_PREMIO2			         	³±±
±±³          ³ Calculo     : Z3_VLFINAL  					   				³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


static Function bau03Grv(nOpcao,aHeader,aCols)

Local lGravou   := .F.
Local lTravou   := .T.
Local nX        := 0
Local nY        := 0
Local nCntfor   := 0
Local nPosRecNo := IF(SZ5->(EOF()),0,Len(aHeader))
Local bCampo 	:= {|nCPO| Field(nCPO) }
Local cItem     := Repl("0",Len(SZ6->Z6_CONTROL))   
Local nCol		:= 0

Private nPremio2:=0
Private nPremio3:=0

*'Yttalo P Martins-INICIO--------------------------------------'*
Private cContraVen := ""                                         
cItem     := "000"
*'Yttalo P Martins-FIM-----------------------------------------'*

Do Case
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualizacao por Tabela                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// MODIFICADO DAVI JESUS 13/07/2011
// DIVIDIDO PARA INCLUI E EXCLUI, DEVIDO AO CONCEITO INFORMADO PELO ROBERTO DIP
Case nOpcao == 1
	dbSelectArea("SZ6")
	dbSetOrder(1)

	Begin Transaction

	    DBSELECTAREA("SZ3")
	    DBSETORDER(1)
//	    DBSEEK(xFilial("SZ3")+M->Z5_CONTRA) // 09/09/2015 - Luis Felipe
	    DBSEEK(xFilial("SZ3")+M->Z5_CONTRA+M->Z5_PERDE)
	    nPremio1:=SZ3->Z3_PREMIO1
	    nPremio2:=SZ3->Z3_PREMIO2    
	    nPremio3:=SZ3->Z3_PREMIO3
	    nPremio4:=SZ3->Z3_PREMIO4
	    nPremio5:=SZ3->Z3_PREMIO5
	    nPremio6:=SZ3->Z3_PREMIO6
	    nPremio7:=SZ3->Z3_PREMIO7
	    nELEVAC :=SZ3->Z3_ELEVAC 
	
		dbSelectArea("SZ5")
		dbSetOrder(1)    // ORDENADO POR FILIAL + NUMERO DO CONTRATO + PERIODO

		RecLock("SZ5",.T.)

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
		SZ5->Z5_POLDP  := M->Z5_POLDP
		    
		MsUnLock()                    
		
		dbSelectArea("SZ6")		
		dbSetOrder(1)  //  ORDENADO POR FILIAL + NUMERO DO CONTRATO
		If DbSeek( xFilial("SZ6")+SZ5->Z5_CONTRA+SZ5->Z5_PERDE )
			While SZ6->( !EOF() ) .AND. SZ6->(Z6_CONTRA+Z6_PERDE)==SZ5->(Z5_CONTRA+Z5_PERDE) //ADRIANO - ACRESCENTEI COMPARAÇÃO. .AND... 16/4/11
				RecLock("SZ6",.F.)
				dbDelete()
		        MsUnlock()
		        dbSkip()
		    End
		EndIf		
	
		nCol := ASCAN(aHeader, {|x| Alltrim(x[2]) == "Z6_CONTROL" })			
		
		For nX := 1 To Len(aCols)
				dbSelectArea("SZ6")		
				dbSetOrder(1)  //  ORDENADO POR FILIAL + NUMERO DO CONTRATO
				If !aCols[nX,Len(aCols[nX])]
	
					RecLock("SZ6",.T.)			
	
					For nY := 1 to Len(aHeader)
						If aHeader[nY][10] <> "V"
							SZ6->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
						EndIf
					Next nY
					SZ6->Z6_FILIAL := xFilial("SZ6")
					SZ6->Z6_CONTRA := SZ5->Z5_CONTRA       
					SZ6->Z6_PERDE  := SZ5->Z5_PERDE       
//					SZ6->Z6_PREMIO2:= nPremio2                      
//					SZ6->Z6_PREMIO3:= nPremio3

	                *'Yttalo P Martins-INICIO--------------------------------------'*
					cItem := SOMA1(cItem)
					SZ6->Z6_ITEM  := cItem                                                  
					*'Yttalo P Martins-FIM-----------------------------------------'*
					
					MsUnLock()
					
					lGravou := .T.
				EndIf
				MsUnLock()
		Next nX	
	End Transaction 		

// modificado DAVI JESUS 13/07/2011
// ROTINA PARA ALTERAÇÃO 
Case nOpcao == 2 
	dbSelectArea("SZ6")
	dbSetOrder(1)

	Begin Transaction

	    SZ3->(DBSETORDER(1))
	    SZ3->(DBSEEK(xFilial("SZ3")+M->Z5_CONTRA+M->Z5_PERDE))
	    nPremio1:=SZ3->Z3_PREMIO1
	    nPremio2:=SZ3->Z3_PREMIO2    
	    nPremio3:=SZ3->Z3_PREMIO3
	    nPremio4:=SZ3->Z3_PREMIO4
	    nPremio5:=SZ3->Z3_PREMIO5
	    nPremio6:=SZ3->Z3_PREMIO6
	    nPremio7:=SZ3->Z3_PREMIO7
	    nELEVAC :=SZ3->Z3_ELEVAC 
	
		SZ5->(DBSETORDER(1))
		SZ5->(DBSEEK(xFilial("SZ5")+M->Z5_CONTRA+M->Z5_PERDE))
		
		RecLock("SZ5",.F.)

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
		SZ5->Z5_POLDP  := M->Z5_POLDP 
		SZ5->Z5_FIX100 := M->Z5_FIX100 // 20/06/16 - Luis Felipe
		MsUnLock()                    
		
		dbSelectArea("SZ6")		
		dbSetOrder(1)  //  ORDENADO POR FILIAL + NUMERO DO CONTRATO
		If DbSeek( xFilial("SZ6")+SZ5->Z5_CONTRA+SZ5->Z5_PERDE )
			While SZ6->( !EOF() ) .AND. SZ6->(Z6_CONTRA+Z6_PERDE)==SZ5->(Z5_CONTRA+Z5_PERDE) //ADRIANO - ACRESCENTEI COMPARAÇÃO. .AND... 16/4/11
				RecLock("SZ6",.F.)
				dbDelete()
		        MsUnlock()
		        dbSkip()
		    End
		EndIf		
	
		nCol := ASCAN(aHeader, {|x| Alltrim(x[2]) == "Z6_CONTROL" })			
		
		For nX := 1 To Len(aCols)
				dbSelectArea("SZ6")		
				dbSetOrder(1)  //  ORDENADO POR FILIAL + NUMERO DO CONTRATO
				If !aCols[nX,Len(aCols[nX])]
	
					RecLock("SZ6",.T.)			
	
					For nY := 1 to Len(aHeader)
						If aHeader[nY][10] <> "V"
							SZ6->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
						EndIf
					Next nY
					SZ6->Z6_FILIAL := xFilial("SZ6")
					SZ6->Z6_CONTRA := SZ5->Z5_CONTRA       
					SZ6->Z6_PERDE  := SZ5->Z5_PERDE     
					MsUnLock()
					
	                *'Yttalo P Martins-INICIO--------------------------------------'*
					cItem := SOMA1(cItem)
					SZ6->Z6_ITEM  := cItem                                                  
					*'Yttalo P Martins-FIM-----------------------------------------'*
										
					lGravou := .T.
				EndIf
				MsUnLock()
		Next nX	
	End Transaction 		

Case  nOpcao == 3

	Begin Transaction

		dbSelectArea("SZ6")
		dbSetOrder(1)
		DbSeek( xFilial("SZ6")+M->Z5_CONTRA+M->Z5_PERDE ) 

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
		If DbSeek( xFilial("SZ5")+M->Z5_CONTRA+M->Z5_PERDE )
			RecLock("SZ5",.F.)
		    dbDelete()
			MsUnLock()
		EndIf
	End Transaction	
EndCase

*'Yttalo P Martins-INICIO--------------------------------------------------------------------------'*
If SUBSTR(M->Z5_CONTRA,1,1) == "P"
	cContraVen := "S"+SUBSTR( M->Z5_CONTRA,2,LEN(M->Z5_CONTRA) )
Else
	cContraVen := SPACE( TAMSX3("Z5_CONTRA")[1] )
EndIf

If !EMPTY(cContraVen)
                                        
	dbSelectArea("CN9")
	dbSetOrder(1)
	If dbSeek(xFilial("CN9")+M->Z5_CONTRA)
	
		If CN9->CN9_TPCTO="001"//COMPRA
	
			dbSelectArea("CN9")
			dbSetOrder(1)
			If dbSeek(xFilial("CN9")+cContraVen)
			
				If CN9->CN9_TPCTO="002"//VENDA
				
					If Aviso("Atencao", "Atualizar precificação do contrato de venda: "+cContraVen+" Período: "+M->Z5_PERDE+"?", {"Sim", "Nao"}) == 1			
								
						U_EDFA005(nOpcao,aHeader,aCols,cContraVen)
						
						Aviso("Aviso", "Precificação do contrato de venda: "+cContraVen+" atualizado! ", {"Ok"})			
								
					EndIf
				
				EndIF
				
			EndIf
		
		EndIf
		
	EndIf
		
EndIf                      
*'Yttalo P Martins-FIM-----------------------------------------------------------------------------'*

Return(lGravou)


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Função    ³bau03LOk ³ Autor ³ Davi Jesus de Oliveira ³ Data ³ 23/11/2010 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³Rotina de Validacao da linha Ok                               ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³bau03Lok())                                                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function bau03Lok()

Local aArea     := GetArea()
Local lRetorno  := .T.
Local nPosFaixa := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CONTROL"})
Local nUsado    := Len(aHeader)
Local nX        := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica os campos obrigatorios                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CheckCols(n,aCols)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se nao ha valores duplicados                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRetorno .And. !aCols[n][nUsado+1]
		For nX := 1 To Len(aCols)
			If nX <> N .And. !aCols[nX][nUsado+1]		
				If aCols[nX][nPosFaixa] == aCols[N][nPosFaixa]
					lRetorno := .F.
					Help(" ",1,"JAGRAVADO")
				EndIf
			EndIf
		Next nX
	EndIF	
EndIf

RestArea(aArea)
Return(lRetorno)


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Funcao    ³bau03Tok  ³ Autor ³Davi Jesus de Oliveira ³ Data ³23/11/2010³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³Rotina de Validacao da Tudok                                ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
USER Function bau03Tok()

Local aArea     := GetArea()
Local lRetorno  := .T.


RestArea(aArea)
Return(lRetorno)

*'Yttalo P Martins-INICIO---------------------------------------------------------------------------'*
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Função    ³bau03DEL ³ Autor ³ YTTALO P MARTINS       ³ Data ³ 25/09/2013 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³Rotina de Validacao da EXCLUSÃO DA linha                      ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³bau03DEL())                                                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function bau03DEL()

Local aArea     := GetArea()
Local lRetorno  := .T.
Local nPosFaixa := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_CONTROL"})
Local nPosMedia := aScan(aHeader,{|x| AllTrim(x[2])=="Z6_MEDIA"})
Local nUsado    := Len(aHeader)
Local nX        := 0
Local _aArea := GetArea()
LOCAL cQuery := ""

If !aCols[n][nUsado+1]		

	If Select("TMPSZ7") > 0
		dbSelectArea("TMPSZ7")
		("TMPSZ7")->(DbCloseArea())
	Endif
	
	cQuery:=" SELECT * FROM "+RetSqlname("SZ7")+" "                                                                                
	cQuery+=" WHERE Z7_FILIAL = '"+XFILIAL("SZ7")+"' "
	cQuery+=" AND Z7_CONTRA = '"+M->Z5_CONTRA+"' "
	cQuery+=" AND Z7_PERDE = '"+M->Z5_PERDE+"' "
	cQuery+=" AND Z7_MEDIA = '"+aCols[n][nPosMedia]+"' "
	cQuery+=" AND Z7_CONTROL = '"+aCols[n][nPosFaixa]+"' "			
	cQuery+=" AND Z7_QTDE <> Z7_SALDO "	
	
    MemoWrite("C:\Tmp\bau03DEL.txt",cQuery)
	
	cQuery := ChangeQuery(cQuery)
	
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMPSZ7",.F.,.T.)
	
	DbSelectArea("TMPSZ7")
	("TMPSZ7")->(dbGotop())
	
	If !("TMPSZ7")->(EOF())
		MsgStop("Item não pode ser excluído. Pedido já gerado, pois saldo do contrato está consumido!")	
		lRetorno := .F.
	ENDIF
	
	If Select("TMPSZ7") > 0
		dbSelectArea("TMPSZ7")
		("TMPSZ7")->(DbCloseArea())
	Endif	

EndIf

RestArea(aArea)
Return(lRetorno)
*'Yttalo P Martins-FIM-----------------------------------------------------------------------------'*

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Função    ³bau03Pk  ³ Autor ³ Davi Jesus             ³ Data ³ 23/11/2010 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³Rotina de Validacao da chave primaria                         ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³bau03PK()                                                    ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
STATIC Function bau03Pk()

Local aArea    := GetArea()
Local lRetorno := .T.
Local cReadVar := ReadVar()
Local cChave   := ""
Local cConteudo:= &(ReadVar())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trava a chave informada para não ser utilizada por outro usuario        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cConteudo) .And. !Empty(M->Z5_CONTRA) .And. !Empty(M->Z5_PERDE) 
	Leave1Code( "SZ5"+xFilial("SZ5")+M->Z5_CONTRA+M->Z5_PERDE )
	cChave += cConteudo

	If !MayIUseCode("SZ5"+xFilial("SZ5")+cChave)
		Help(" ",1,"JAGRAVADO")
		lRetorno := .F.
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a chave esta duplicada                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SZ5")
	dbSetOrder(1)
	If DbSeek(xFilial("SZ5")+cChave)
		Help(" ",1,"JAGRAVADO")
		lRetorno := .F.	
	EndIf
EndIf
RestArea(aArea)
Return(lRetorno)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
//±±³Funcao    ³bau03Leg  ³ Autor ³ Davi Jesus de Oliveira ³ Data ³23.11.10 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³Legenda das tabelas                                         ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³Nenhum                                                      ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³Nenhum                                                       ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function bau03Leg()

Local aLegenda := { { "BR_VERDE"   ,STR0015},;     // "Com Saldo "
					{ "BR_VERMELHO",STR0016} }     // "Sem Saldo/Encerrado "

BrwLegenda( cCadastro, STR0021, aLegenda  )   //"Status"

Return(.T.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
//±±³Funcao    ³bau03ret  ³ Autor ³ Davi Jesus de Oliveira ³ Data ³23.11.10 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³Retorna Informações para gatilho                            ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³Nenhum                                                      ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³Nenhum                                                       ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
USER Function bau03ret(cCampo)
Local cRet := " "                   
Local nX   := 0

If cCampo == "USINA"
   dbselectarea("CN9")
   dbsetorder(1)
   dbSeek( xFilial("CN9")+M->Z5_CONTRA )
   IF !CN9->(EOF())
      IF CN9->CN9_TPCTO=="001"
         CNC->( dbSetOrder(1) )
         CNC->( dbSeek( xFilial("CNC")+M->Z5_CONTRA) )
         IF !CNC->(EOF())
            SA2->( DBSetOrder(1) )
            SA2->( dbSeek(xFilial("SA2")+CNC->(CNC_CODIGO+CNC_LOJA) ))
            cRet := SA2->A2_NOME
         ENDIF
      ELSE                    
         cCLENTT:= Posicione("CN9",1,xFilial("CN9")+M->Z5_CONTRA,"CN9_CLIENT")
         cLOJAA := Posicione("CN9",1,xFilial("CN9")+M->Z5_CONTRA,"CN9_LOJACL")
         cRet   := Posicione("SA1",1,xFilial("SA1")+cCLENTT+cLOJAA,"A1_NOME")
      ENDIF
   ENDIF   
ElseIf cCampo == "PRODUTO"
   SZ2->( dbSetOrder(1) )
   SZ2->( dbSeek( xFilial("SZ2")+M->Z5_CONTRA) )

   SB1->( dbSetOrder(1) )
   SB1->( dbSeek(xFilial("SB1")+SZ2->Z2_CODPRO  ) )

   cRet := SB1->B1_DESC

ElseIf cCampo == "QTDE"                  
       cAux := "'"
       nX:=0
       For nX:=1 TO LEN(M->Z5_PERDE)
           If substr(M->Z5_PERDE,nX,1) <> ' '
	           If substr(M->Z5_PERDE,nX,1) $ '0123456789/ '
	              cAux += substr(M->Z5_PERDE,nX,1)
	           Else
	              cAux += "','"
	           Endif
	       Endif
       NEXT          
       
       If Select("TRB") > 0
          TRB->(dbCloseArea())	
       Endif
                     
       cAux += "'"
       cQuery := "SELECT SUM(Z3_QUANT) AS QUANT FROM "+RetSqlName("SZ3")+" SZ3"
	   cQuery += " WHERE  SZ3.D_E_L_E_T_ = ' ' "
  	   cQuery += " AND SZ3.Z3_CONTRA = '"+M->Z5_CONTRA+"'"
  	   cQuery += " AND SZ3.Z3_PERIODO IN ("+cAux+")"

       Open Query cQuery Alias "TRB"

       cRet := TRB->QUANT
       
       CLOSE QUERY "TRB"
       dbSelectArea("SZ5")

ElseIf cCampo == "LOTE"                  
       cAux := "'"
       nX:=0
       For nX:=1 TO LEN(M->Z5_PERDE)
           If substr(M->Z5_PERDE,nX,1) <> ' '
	           If substr(M->Z5_PERDE,nX,1) $ '0123456789/ '
	              cAux += substr(M->Z5_PERDE,nX,1)
	           Else
	              cAux += "','"
	           Endif
	       Endif
       NEXT nX                         
        cAux += "'"
        cQuery := "SELECT SUM(Z3_QTDLOT) AS LOTE FROM "+RetSqlName("SZ3")+" SZ3"
		cQuery += " WHERE  SZ3.D_E_L_E_T_ = ' ' "
  		cQuery += " AND SZ3.Z3_CONTRA = '"+M->Z5_CONTRA+"'"
  		cQuery += " AND SZ3.Z3_PERIODO IN ("+cAux+")"

//		dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TRB", .T., .T. )

        Open Query cQuery Alias "TRB"

        dbSelectArea("TRB")
        cRet := TRB->LOTE
       
//       TRB->( dbCloseArea() )
       CLOSE QUERY "TRB"
                            
       dbSelectArea("SZ5")
ElseIf cCampo == "USD"

        SZ3->( dbSetOrder(1) )
        SZ3->( dbSeek(xFilial("SZ3")+M->Z5_CONTRA+M->Z5_PERDE) )
        //While SZ3->Z3_CONTRA == M->Z5_CONTRA
        //    If ALLTRIM(SZ3->Z3_PERIODO ) $ M->Z5_PERDE         
    	//	   cRet := SZ3->Z3_PREMIO1
        //    Endif
        //    SZ3->( dbSkip() )             
        //End
        If !SZ3->(EOF())
           cRet:=0
           
           cRet=if(SZ3->Z3_PREMIO1>=0,cRet+SZ3->Z3_PREMIO1,cRet-(SZ3->Z3_PREMIO1*-1))
           
           //cRet=if(SZ3->Z3_PREMIO2>=0,cRet+SZ3->Z3_PREMIO2,cRet-(SZ3->Z3_PREMIO2*-1))
           
           cRet=if(SZ3->Z3_PREMIO3>=0,cRet+SZ3->Z3_PREMIO3,cRet-(SZ3->Z3_PREMIO3*-1))
        
        Endif
        dbSelectArea("SZ5")

ElseIf cCampo == "REAL"

        SZ3->( dbSetOrder(1) )
//        SZ3->( dbSeek(xFilial("SZ3")+M->Z5_CONTRA) ) // 09/09/15 - Luis Felipe - Alteradas somente estas duas linhas - Gatilho - Z5_PERDE - Seq-002 - Z5_DESREAL
        SZ3->( dbSeek(xFilial("SZ3")+M->Z5_CONTRA+M->Z5_PERDE) ) //  09/09/15 - Luis Felipe
        //While SZ3->Z3_CONTRA == M->Z5_CONTRA
        //    If ALLTRIM(SZ3->Z3_PERIODO ) $ M->Z5_PERDE
    	//	   cRet := SZ3->Z3_PREMIO4
        //    Endif
        //    SZ3->( dbSkip() )             
        //End
        
        If !SZ3->(EOF())
           cRet:=0
           cRet+=if(SZ3->Z3_PREMIO4>=0,cRet+SZ3->Z3_PREMIO4,cRet-(SZ3->Z3_PREMIO4*-1))
        Endif
        dbSelectArea("SZ5")
                           
EndIf

Return(cRet)       


// usado no gatilho do campo Z5_CONTRA, onde o mesmo só pode ser 
User Function b003VLDC( cRet )

If CN9->CN9_SITUAC <> "05"
   cRet := Space(15)
   MsgAlert("Somente pode ser incluso para contratos em vigência."+chr(13)+"Favor verificar!","ATENCAO")
Endif

Return ( cRet )

User Function _Vtotal(cRet)

If cRet > M->Z5_QTDEPER
   MSGAlert("Quantidade informada MAIOR que o saldo disponível no período."+chr(13)+"Favor Verificar! ","Atenção")
   cRet := 0
EndIf

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ b03Brw  ºAutor  ³ Davi Jesus de Oliveiraº Data ³ 28/11/10  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta tela com a markbrowse para escolha dos preços a serem º±±
±±º          ³enviados ao contrato.                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function b03Brw()
Local nOpca   := 0
Local aCampos := {}
Local aCampos1:= {}
Local aCampos2:= {}
Local aCampos3:= {}

Local aDim	  := {}	
Local oEnc01            
Local oGet03                   
Local n_Qtde  := 0 
Local oPanelDados   
Local aButtons := {}

Local cMEDIA_TP := ""

Private cMarca:= GetMark()
Private aEnviados:= {}

aadd(aCampos , {"Z6_OK"     , "C", TamSX3("Z6_OK")[1]     , 0})
aadd(aCampos , {"Z6_CONTRA" , "C", TamSX3("Z6_CONTRA")[1] , 0})
aadd(aCampos , {"Z6_PERDE"  , "C", TamSX3("Z6_PERDE")[1]  , 0})

aadd(aCampos , {"Z6_MEDIA"  , "C", TamSX3("Z6_MEDIA")[1]  , 0})
aadd(aCampos , {"Z6_PRECO"  , "N", TamSX3("Z6_PRECO")[1]  , 2})

aadd(aCampos1, {"Z6_OK"     , "" , "OK"                   , ""})
aadd(aCampos1, {"Z6_CONTRA" , "" , "Número do Contrato"   , "@!"})
aadd(aCampos1, {"Z6_PERDE"  , "" , "Período"              , "@!"})

aadd(aCampos1, {"Z6_MEDIA"  , "" , "M"                    , "X"})
aadd(aCampos1, {"Z6_PRECO"  , "" , "Preço Médio"          , "@E 999,999,999.99"})

//tabela que receberá dados
aadd(aCampos2, {"Z6_OK"     , "C", TamSX3("Z6_OK")[1]     , 0})
aadd(aCampos2, {"Z6_CONTRA" , "C", TamSX3("Z6_CONTRA")[1] , 0})
aadd(aCampos2, {"Z6_PERDE"  , "C", TamSX3("Z6_PERDE")[1]  , 0})

aadd(aCampos2, {"Z6_LOTE"   , "N", TamSX3("Z6_LOTE")[1]   , 0})
aadd(aCampos2, {"Z6_QTDE"   , "N", TamSX3("Z6_QTDE")[1]   , 3})

aadd(aCampos2, {"Z6_MEDIA"  , "C", TamSX3("Z6_MEDIA")[1]  , 0})
aadd(aCampos2, {"Z6_PRECO"  , "N", TamSX3("Z6_PRECO")[1]  , 2})
aadd(aCampos2, {"Z6_VLFINAL", "N", TamSX3("Z6_VLFINAL")[1], 2})
aadd(aCampos2, {"Z6_TIPOPRE", "C", TamSX3("Z6_VLFINAL")[1], 0})
aadd(aCampos2, {"Z6_CONTROL", "C", TamSX3("Z6_CONTROL")[1], 0})

aadd(aCampos3, {"Z6_OK"     , "" , "OK"                   , ""})
aadd(aCampos3, {"Z6_CONTRA" , "" , "Número do Contrato"   , "@!"})
aadd(aCampos3, {"Z6_PERDE"  , "" , "Período"              , "@!"})

aadd(aCampos3, {"Z6_LOTE"   , "" , "Qtd. Lotes"           , "@E 999,999.99"})
aadd(aCampos3, {"Z6_QTDE"   , "" , "Quantidade"           , "@E 999,999,999.999"})
aadd(aCampos3, {"Z6_MEDIA"  , "" , "Média"                , "@!"})
aadd(aCampos3, {"Z6_PRECO"  , "" , "Vl. Ponderado"        , "@E 999,999,999.99"})
aadd(aCampos3, {"Z6_VLFINAL", "" , "Vl. Final"            , "@E 999,999,999.99"})

oModal  := FWDialogModal():New()       
oModal:SetEscClose(.T.)
oModal:setTitle("Seleção de Preços para Média")
oModal:setSize(200, 380)

oModal:createDialog()
aAdd(aButtons, {1, "Confirmar", {|| nOpca := 1, oModal:DeActivate() }, "", 0, .T., .F.})
aAdd(aButtons, {1, "Cancelar" , {|| nOpca := 0, oModal:DeActivate() }, "", 0, .T., .F.})
oModal:addButtons(aButtons)
oContainer := TPanel():New( ,,, oModal:getPanelMain() )
oContainer:Align := CONTROL_ALIGN_ALLCLIENT

If Select("TRB")>0
	dbSelectArea("TRB")
	dbCloseArea()
Endif      

If Select("TRB1")>0
	dbSelectArea("TRB1")
	dbCloseArea()
Endif      

cQuery:="SELECT *"         
cQuery+=" FROM "+RETSQLNAME("SZ6")
cQuery+=" WHERE Z6_FILIAL = '"+xFilial("SZ6")+"' AND Z6_CONTRA = '"+SZ5->Z5_CONTRA+"' AND Z6_PERDE='"+SZ5->Z5_PERDE+"' AND "+RETSQLNAME("SZ6")+".D_E_L_E_T_=' ' AND Z6_STATUS <> '0'"
cQuery+=" ORDER BY Z6_MEDIA,Z6_TIPOPRE"

cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

cAlias := "TRB1"
oAlias:= FwTemporarytable():New(cAlias,aCampos2)
oAlias:Create()

DbselectArea("SZ5")
SZ5->( dbSeek(xFilial("SZ5")+SZ5->Z5_CONTRA+SZ5->Z5_PERDE ) )    

dbselectarea("TRB")         
dbGoTop()

While !TRB->(Eof()) 
	IF TRB->Z6_MEDIA+TRB->Z6_TIPOPRE<>cMEDIA_TP                          
       RecLock("TRB1",.T.)
	   TRB1->Z6_OK      := '  '
	   TRB1->Z6_LOTE    := TRB->Z6_TOTLOTE
	   TRB1->Z6_QTDE    := TRB->Z6_QTDE   
	   TRB1->Z6_MEDIA   := TRB->Z6_MEDIA
	   TRB1->Z6_PRECO   := TRB->Z6_MEDIAG      
	   TRB1->Z6_CONTRA  := TRB->Z6_CONTRA                   
	   TRB1->Z6_PERDE   := TRB->Z6_PERDE
       TRB1->Z6_VLFINAL := TRB->Z6_VLFINAL    
       TRB1->Z6_TIPOPRE := TRB->Z6_TIPOPRE    
       TRB1->Z6_CONTROL := TRB->Z6_CONTROL    
	   MsUnLock()                         
	   cControl := TRB->Z6_CONTROL
    ENDIF
    cMEDIA_TP := TRB->Z6_MEDIA+TRB->Z6_TIPOPRE
	Aadd(aEnviados,{cControl,TRB->R_E_C_N_O_})	
	TRB->(dbskip())
End
                      
TRB1->( dbGoTop() ) 
oMark:=MsSelect():New("TRB1","Z6_OK",,aCampos3,,cMarca,{02,1,23,316},,,oContainer)
oMark:oBrowse:lhasMark := .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := {|| b003Inverte(cMarca,@oMark)}
oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
oModal:Activate()
       
// Ao sair será gravada as informações...
If nOpca == 1
   dbselectarea("TRB1")         
   dbGoTop()
   n_qtde:=0                        
   Do While !TRB1->(Eof())
      IF TRB1->Z6_OK<>'  '
	     n_qtde+=TRB1->Z6_QTDE
      ENDIF
	  TRB1->(dbskip())
   Enddo
   //DEFINE MSDIALOG oDlg2 TITLE OemtoAnsi("Quantidade a ser Enviada") FROM  165,115 TO 245,430 PIXEL
   //@ 5, 10 SAY OemToAnsi("Quantidade : ") SIZE 60, 8 OF oDlg2 PIXEL
   //@ 5,70  MSGET oGet03 VAR n_qtde PICTURE "@e 999,999,999.999" valid u_VLQT(n_Qtde)  SIZE 55,9 OF oDlg2 PIXEL
   //DEFINE SBUTTON FROM 25, 93 TYPE 1 ACTION (if(!empty(n_qtde),oDlg2:End(),)) ENABLE OF oDlg2
   //DEFINE SBUTTON FROM 25, 123 TYPE 2 ACTION (n_Qtde:="",oDlg2:End(),nOpcTp := 2) ENABLE OF oDlg2
   //ACTIVATE MSDIALOG oDlg2
   
   if n_qtde>0
      b03GRVTRB(n_Qtde)
   endif
      
Endif

Return

*----------------------------------------*
Static Function b003Inverte(cMarca,oMark)
*----------------------------------------*

Local nReg := TRB1->(Recno())
dbSelectArea("TRB1")
dbGoTop()
While !Eof()
	RecLock("TRB1")
	IF A1_OK == cMarca
		TRB1->Z6_OK := "  "
	Else
		TRB1->Z6_OK := cMarca
	Endif
	dbSkip()
Enddo
TRB1->(dbGoto(nReg))
oMark:oBrowse:Refresh(.t.)

Return Nil
 
*--------------------------------------------------------------*
STATIC Function SZ6Visual(cAliasFile, oCont, nRecno, lForceKill)
*--------------------------------------------------------------*

Local oEnc01 := NIL
Private oArea := oCont:oArea
Default lForceKill := .T.

If ValType(oCont:oEnc01) == "O" .and. !lForceKill
	RegToMemory(cAliasFile, .F., .T., , , FunName())
	oCont:oEnc01:Refresh()
Else
	aButtonTxt := {} 
	oCont:oPanelVis:FreeChildren()
	AxVisual(cAliasFile, 1,2,,,,,,,,.T.,oCont:oPanelVis, @oEnc01,,,FunName()) 
	oCont:oEnc01 := oEnc01
EndIf

Return 

*--------------------------------*
Static Function b03GRVTRB(n_Qtde)
*--------------------------------*

Processa({|lEnd| B003GRV(n_Qtde)},,"Gravando Informações")

Return

*------------------------------*
Static Function b003GRV(n_Qtde)
*------------------------------*

Local n         := 0
Local nPosSA1   := 0
Local nOpca		:= 0
Local aTam		:= {}
Local aCampos	:= {}
Local oMark 	:= 0
Local lInverte  := .f.
Local aSize 	:= {}
Local oPanel
Local aNewParcs := {}
Local aVet      := {} 
Local cContra  	:= ""
Local nI		:= 0

aadd(aVet,0)
aadd(aVet,0)

TRB1->(Dbgotop())

nItensp:=0 // contador de preços informados

While !TRB1->(Eof())

	If TRB1->Z6_OK==cMarca   // se foi selecionado na markbrowse
		
		cMedia  := TRB1->Z6_MEDIA+TRB1->Z6_TIPOPRE
		
        For nI:=1 to Len(aEnviados)
    		If aEnviados[nI][1] == TRB1->Z6_CONTROL
				SZ6->(DbGoto(aEnviados[nI][2]))
    			SZ6->(RecLock("SZ6",.F.))
     			SZ6->Z6_CTRLSZ7 := aEnviados[nI][1] 
				SZ6->Z6_STATUS  := "0" 
				MsUnLock()    
			EndIf
        Next
		
	    n_Qtde     := TRB1->Z6_QTDE
	    c_Media    := TRB1->Z6_MEDIA
	    n_Media    := TRB1->Z6_PRECO
	    n_VLFINAL  := TRB1->Z6_VLFINAL 
	    n_Lotes    := TRB1->Z6_LOTE                            

        DBSELECTAREA("SZ3")
	    DBSETORDER(1)
	    DBSEEK(xFilial("SZ3")+SZ5->Z5_CONTRA+SZ5->Z5_PERDE) // 05/11/15 - Luis Felipe - Adicionado o período
	    nPremio2:=SZ3->Z3_PREMIO2
	    nPremio3:=SZ3->Z3_PREMIO3                  
	    
        dbSelectArea("CN9")
        dbSetOrder(1)
        dbSeek(xFilial("CN9")+SZ5->Z5_CONTRA)
	    
        // Criar o valor total com a media encontrada.
        SZ7->( RecLock("SZ7",.T.) )
   	    SZ7->Z7_FILIAL   := xFilial("SZ7")
        SZ7->Z7_CONTRA   := SZ5->Z5_CONTRA 
        SZ7->Z7_PERDE    := SZ5->Z5_PERDE   // incluso campo periodo para amarração do processo de preficicação
        SZ7->Z7_QTDE     := n_Qtde
        SZ7->Z7_MEDIA    := c_Media   		// NÚMERO DA MÉDIA UTILIZADA NA PRECIFICAÇÃO
        SZ7->Z7_PRECO    := n_MEDIA   		// MEDIA EM DOLLAR ENCONTRADA NA PRECIFICAÇÃO
        SZ7->Z7_VLFINAL  := n_VLFINAL 		// VALOR FINAL EM DOLLAR COM DESCONTO OU PREMIO ENCONTRADO NA PRECIFICAÇÃO
        SZ7->Z7_EMISSAO  := DATE()
        SZ7->Z7_HORAGER  := TIME()
        SZ7->Z7_SALDO    := n_Qtde  
        SZ7->Z7_QTDLOTE  := n_Lotes
        SZ7->Z7_PREMIO2  := nPremio2      	//ADRIANO VERIFICAR
        SZ7->Z7_PREMIO3  := nPremio3
        SZ7->Z7_TPCTO    := CN9->CN9_TPCTO
        SZ7->Z7_CONTROL	 := TRB1->Z6_CONTROL
        SZ7->( MsUnLock() ) 
	Endif
	dbSelectArea("TRB1")
	TRB1->(Dbskip())
Enddo
Return

// Rotina para validação do processo da quantidade digitada não pode ser maior que o total do contrato.
*-------------------------*
User Function VLQT(n_Qtde)
*-------------------------*
Local lRet := .T.
// colocar a validação da quantidade total disponível, pode ser por query ...
// exemplo Select sum(Z6_...    
SZ1->( dbSetOrder(1) )
If SZ1->( dbSeek(xFilial("SZ1")+SZ6->Z6_CONTRA ) )
   If n_qtde > SZ1->Z1_QTD
	   lRet  := .F.
   Endif
Endif
Return lRet                                                            

*------------------------------------------------------------*
* Luís Felipe Nascimento				   	  28/08/13       *
* Toda a rotina foi reescrito pois,o Calculo da Precificação *
* da ED&F MAN é diferente dos cálculos da Bauche             *
*------------------------------------------------------------*

*------------------------------------------------------------*
* Luís Felipe Nascimento				   	  05/11/15       *
* Função: GeraMedia                                          *
* Onde: Gatilho Z6_MEDIA                                     *
*------------------------------------------------------------*
User Function GeraMedia(cContra,cMedia,cTipo)

Local nConta  := 0
Local nPrecos := 0 //media dollar       
Local nPrecosc:= 0 //media cents
Local nMedia  := 0                                    
Local nTam    := Len(aCols)
Local nQtd    := 0
Local nTotTon := 0
Local nTotLot := 0
Local nLinhas := 0
Local nMedVlf := 0                    
Local nSldLot := 0 
Local nSldTon := 0	 
Local nI	  := 0

Private nPosDollar := GdFieldPos("Z6_TAXAUSD")
Private nPosLote   := GdFieldPos("Z6_LOTE")
Private nPosPric   := GdFieldPos("Z6_PRICING")
Private nPosQtde   := GdFieldPos("Z6_QTDE")
Private nPosPreco  := GdFieldPos("Z6_PRECO")
Private nPosMedia  := GdFieldPos("Z6_MEDIA")
Private nPosMdcent := GdFieldPos("Z6_MDCENTS")
Private nPosMediag := GdFieldPos("Z6_MEDIAG")
Private nPosTotlote:= GdFieldPos("Z6_TOTLOTE")
Private nPosTotTon := GdFieldPos("Z6_TOTTONS")
Private nPosTipo   := GdFieldPos("Z6_TIPOPRE")    
Private nPosVlFin  := GdFieldPos("Z6_VLFINAL")
Private nTamHeader := Len(aHeader)+1                                       

If ntam>0
   FOR nI:=1 TO ntam
       If !aCols[nI][nTamHeader] 
	       If aCols[nI][nPosMedia] == cMedia .And. aCols[nI][nPosTipo] == cTipo 	// Código da média que está sendo atualizada
	          nPrecos  	+= (aCols[nI][nPosDollar] * aCols[nI][nPosLote])  	// dollar
	          nPrecosc 	+= (aCols[nI][nPosPric]   * aCols[nI][nPosLote])    	// cents
	          nQtd    	+=  aCols[nI][nPosLote]       
	          nTotlot	+=  aCols[nI][nPosLote]      							// [4] quantidade de lotes 
	          nTotton	+=  aCols[nI][nPosTotTon]    							// [5] quantidade de toneladas 
	          nMedVlf	+=  aCols[nI][nPosVlFin]
	          nLinhas	+=  1
	       Endif                        
	       // Abate Saldo de Lotes e Qtde
	       If aCols[nI][nPosTipo] == "2" 
	          nSldLot	+=  aCols[nI][nPosLote]      							// [4] quantidade de lotes 
	          nSldTon	+=  aCols[nI][nPosTotTon] 								// [5] quantidade de toneladas 
	       EndIf
       EndIf
   Next                           
Endif

nMedia  := nPrecos/nQtd          
nMediac := nPrecosc/nQtd                           
nMedVlf := nMedVlf/nLinhas

FOR nI:=1 TO nTam
    If !aCols[nI][nTamHeader] 
	    If 	aCols[nI][nPosMedia]  == cMedia .And. aCols[nI][nPosTipo] == cTipo 
	       	aCols[nI][nPosPreco]  := nMedia 
	    	aCols[nI][nPosMediag] := nMedia    // Como será por Tipo + Média então serão iguais
	       	aCols[nI][nPosMdcent] := nMediac 
	       	aCols[nI][nPosTotlote]:= nTotlot
	       	aCols[nI][nPosQtde]   := nTotton 
	       	aCols[nI][nPosVlFin]  := nMedVlf
	    Endif
	EndIf    
Next

// Atualiza Saldo dos Lotes (Controle para checar o Fim da Precificação)
If nSldLot > M->Z5_LOTEPER .or. nSldTon > M->Z5_QTDEPER
	Aviso("Atenção","A quantidade em Lotes ou Toneladas é maior que o saldo do Contrato + Período",{"Voltar"})
EndIf
M->Z5_SALOT	:= M->Z5_LOTEPER - nSldLot
M->Z5_SALDO	:= M->Z5_QTDEPER - nSldTon

// oGetD:oBrowse:Refresh(.t.)
GetdRefresh()

Return( nMedia )

// função para tratamento da taxa 
*-------------------------------------*
//User Function Gerataxa(cBolsa,nPricing) // 22/08/17 - Luis Felipe
User Function Gerataxa(cBolsa,nPricing,cTela)
*-------------------------------------*

CN9->(DbSetOrder(1))
CN9->(DbSeek(xFilial("CN9")+GdFieldGet("Z6_CONTRA",n)))

nTx:=0
dbselectarea("SZ4")
dbsetorder(1)
dbseek(xFilial("SZ4")+cBolsa)

if !SZ4->(EOF())
//   nTx:=(If(CN9->CN9_MOEDA = 2 ,SZ4->Z4_CONVERS,1) * nPricing) // 22/08/17 - Luis Felipe
   nTx:=(If(CN9->CN9_MOEDA = 2 .and. Rtrim(cTela) <> 'FX',SZ4->Z4_CONVERS,1) * nPricing)
endif     

Return nTx

*------------------------------*
USER FUNCTION somasld(cContrato)     
*------------------------------*

Local nSaldoFim := 0

If !Empty(cContrato)
	SZ6->( dbSetOrder(1) )
	SZ6->( dbSeek( xFilial("SZ6")+cContrato ) )
	While SZ6->(!EOF()) .AND. SZ6->Z6_CONTRA+SZ6->Z6_PERDE == cContrato 
	      If SZ6->Z6_TIPOPRE == '2'
	         nSaldoFim += SZ6->Z6_QTDE
	      Endif
	      SZ6->( dbSkip() )
	End  
	nSaldoFim := SZ5->Z5_QTDEPER - nSaldoFim
Endif

Return nSaldoFim    

/*  03/09/13 - Luís Felipe Nascimento
*-----------------------------*
USER FUNCTION somalt(cContrato)     
*-----------------------------*

Local nSaldoFim := 0

If !Empty(cContrato)
	SZ6->( dbSetOrder(1) )
	SZ6->( dbSeek( xFilial("SZ6")+cContrato ) )
	While SZ6->(!EOF()) .AND. SZ6->Z6_CONTRA+SZ6->Z6_PERDE == cContrato 
	      If SZ6->Z6_TIPOPRE == '2'
	         nSaldoFim += SZ6->Z6_LOTE
	      Endif
	      SZ6->( dbSkip() )
	End  
	nSaldoFim := SZ5->Z5_LOTEPER - nSaldoFim
Endif

Return nSaldoFim      
*/
*---------------------*
User Function IMPPRECO 
*---------------------*

// 05/07/13 - Luis Felipe Nascimento - 
// Retirado campo TRB->Z6_MEDIAG - Projeto 004 - Mudanças no GCT

Private cPergsz7:="impsz7"                                                                         
Private aCabec:={}
Private aDados:={}

ValidPerg()
If pergunte(cPergsz7,.T.)   
   cQuery:="SELECT * FROM "+RetSqlName("SZ6")
   cQuery+=" WHERE Z6_CONTRA='"+mv_par01+"' AND "+RetSqlName("SZ6")+".D_E_L_E_T_=' ' ORDER BY Z6_MEDIA "
   
   cQuery := ChangeQuery(cQuery)

   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

   dbselectarea("TRB")  

   AAdd(aCabec ,"Contrato")
   AAdd(aCabec ,"Data")
   AAdd(aCabec ,"Lote")
   AAdd(aCabec ,"Qtd.")
   AAdd(aCabec ,"Pricing")
   AAdd(aCabec ,"Tx. USD")
   AAdd(aCabec ,"Tipo")                                    
   AAdd(aCabec ,"Média")
   AAdd(aCabec ,"Preço")     
   AAdd(aCabec ,"MD Cents")
   AAdd(aCabec ,"Média")
   AAdd(aCabec ,"Tot.Lote")
   AAdd(aCabec ,"Tot.Tons.")
   AAdd(aCabec ,"Vl.Final")
   AAdd(aCabec ,"Período")
   
   dbselectarea("TRB")  
   TRB->(dbGoTop())
   if TRB->(EOF())
      msgalert("query vazia")
      TRB->(dbcloseArea())
      Return
   endif

   Do While !TRB->(EOF())     
      dbSelectArea("SZ5")
      dbSelectArea("TRB")
      AADD(aDados,{TRB->Z6_CONTRA, TRB->Z6_DATA, TRB->Z6_LOTE, TRB->Z6_QTDE, TRB->Z6_PRICING, TRB->Z6_TAXAUSD, ;
           IIF(TRB->Z6_TIPOPRE="1","P.F.","P.P."), TRB->Z6_MEDIA, TRB->Z6_PRECO, TRB->Z6_MDCENTS, /*TRB->Z6_MEDIAG,TRB->Z6_TOTLOTE, TRB->Z6_TOTTONS,*/ ;
           TRB->Z6_VLFINAL, TRB->Z6_PERDE})
      TRB->(dbSkip())     
   EndDo

Endif
DlgToExcel( { { "ARRAY", "Relação", aCabec, aDados} })                                  

TRB->(dbcloseArea())
Return .T.
                          
*-------------------------------------*
Static Function ValidPerg()
*-------------------------------------*

PutSx1(cPergsz7,"01","Contrato Compra?","","","mv_ch1","C",15,0,0,"G","","","","","mv_par01")  

Return .T. 

*-------------------------*
Static Function FDialogo()
*-------------------------*

Private oDlg  := Nil       
Private cTit  := "Dialogo rotina (BAUCH003)" 
Private lRetor:= .T.
Private lSair := .F.
Private cMotivo:= SZ5->Z5_FIX100

DEFINE MSDIALOG oDlg TITLE cTit FROM 0,0 TO 80,580 OF oDlg PIXEL

@ 06,06 TO 35,247 LABEL "Motivo pela não Fixação da Moeda" OF oDlg PIXEL

@ 20, 10 SAY   "Motivo:"  SIZE 45,7 PIXEL OF oDlg                  
@ 20, 35 MSGET cMotivo    SIZE 210,08 Picture "@100" PIXEL OF oDlg

DEFINE SBUTTON FROM 10,256 TYPE 1  OF oDlg ACTION (ValiRel("ok")) ENABLE
DEFINE SBUTTON FROM 25,256 TYPE 2  OF oDlg ACTION (ValiRel("cancel")) ENABLE

ACTIVATE MSDIALOG oDlg CENTER

Return( cMotivo )   

**********************************
Static Function ValiRel(cValida)
**********************************

Local lCancela :=  .t.

If cValida = "ok"
	If Empty(cMotivo)
		MsgInfo("Favor informar o motivo da fixação na moeda !","Atenção")
		lRetor := .F.
	Else
		oDlg:End()
		lRetor := .T.
	EndIf
Else
	If Empty(cMotivo)
		lCancela := MsgYesNo("O não preenchimento do motivo da fixação na moeda implicará na ausência do registro histórico desta informação !, Confirma ?","Atenção")
		If lCancela
			oDlg:End()
			lRetor := .T.
			lSair  := .T.
		Else
			lRetor := .F.
		EndIf
	Else
		oDlg:End()
		lRetor := .T.
		lSair  := .T.
		cMotivo:= SZ5->Z5_FIX100
	EndIf
EndIf

Return(lRetor)
