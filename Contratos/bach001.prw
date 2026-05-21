#INCLUDE "PROTHEUS.CH"

//Situacoes de contrato
#DEFINE DEF_SCANC "01" //Cancelado
#DEFINE DEF_SELAB "02" //Em Elaboracao
#DEFINE DEF_SEMIT "03" //Emitido
#DEFINE DEF_SAPRO "04" //Em Aprovacao
#DEFINE DEF_SVIGE "05" //Vigente
#DEFINE DEF_SPARA "06" //Paralisado  
#DEFINE DEF_SSPAR "07" //Sol Fina.
#DEFINE DEF_SFINA "08" //Finalizado
#DEFINE DEF_SREVS "09" //Revisao
#DEFINE DEF_SREVD "10" //Revisado

//Tipos de Revisao
#DEFINE DEF_ADITI "1" //Aditivo
#DEFINE DEF_REAJU "2" //Reajuste
#DEFINE DEF_REALI "3" //Realinhamento
#DEFINE DEF_READQ "4" //Readequacao
#DEFINE DEF_PARAL "5" //Paralisacao
#DEFINE DEF_REINI "6" //Reinicio
#DEFINE DEF_CLAUS "7" //Alteracao de Clausula

#DEFINE DEF_TRANS "001" //Transacao de controle total do contrato
#DEFINE DEF_TRASIT "018"//Transacao de controle de situacoes
#DEFINE DEF_TRAVIS "037"//Transacao de visualizacao do contrato
#DEFINE DEF_TRABCO "038"//Transacao de controle sobre o banco de conhecimento
#DEFINE DEF_TRAEDT "039"//Transacao de controle sobre a edicao do contrato   
#DEFINE DEF_TRARET "040"//Transacao de controle sobre a baixa da retencao

#DEFINE FLD_BAIXA "BAIXA"//Campo de baixa da retencao
#DEFINE FLD_SALDO "SALDO"//Campo de saldo da retencao
#DEFINE FLD_PLANI "PLANI"//Campo de planilha da retencao   

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    ³ CNTA100  ³ Autor ³ Davi Jesus de Oliveira                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±ºPrograma  ³BACH001   ºAutor  ³Leandro Ribeiro     º Data ³  24/07/13   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³ Alterações na linhas 154, 342, 406, 416, 433 e 1025 para a º±±
//±±º          ³ realização da gravação na tabela SZF e a possibilidade de  º±±
//±±º          ³ visualização dos itens da SZF quando for visualizado o     º±±
//±±º          ³ contrato.                                                  º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ AP                                                        º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BACH001   ºAutor  ³Alexandre Santos    º Data ³  07/11/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³ Chamada da Função EDFA003 p/ realizar a copia do Contrato  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±   
±±ºAlteração ³ Crição de função para validação do cronograma do contrato  º±±
±±º          ³  Função: BC001lok                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³ Luis Felipe Nascimento                          25/03/14   º±±
±±º          ³ Por não existir registros para atualizar a tabela SZR      º±±
±±º          ³ o sistema era derrubado ao executar a função Confirmsx8.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function BAUCH001()
Local aCores := {	{ "Alltrim(CN9->CN9_SITUAC) == '01'", "BR_VERMELHO"  },;	// Cancelado
					{ "Alltrim(CN9->CN9_SITUAC) == '02'", "BR_AMARELO"	 },;	// Elaboracao
					{ "Alltrim(CN9->CN9_SITUAC) == '03'", "BR_AZUL"		 },;	// Emitido
					{ "Alltrim(CN9->CN9_SITUAC) == '04'", "BR_LARANJA"	 },;	// Em Aprovacao
					{ "Alltrim(CN9->CN9_SITUAC) == '05'", "BR_VERDE"	 },;	// Vigente
					{ "Alltrim(CN9->CN9_SITUAC) == '06'", "BR_CINZA"	 },;	// encerrado
					{ "Alltrim(CN9->CN9_SITUAC) == '07'", "BR_AMARELO"	 },;	// Sol. Finalização
					{ "Alltrim(CN9->CN9_SITUAC) == '08'", "BR_PRETO"	 }}	    // Finalizado

Private cCadastro := OemToAnsi("Manutencao de Contratos")
Private lVal	  := .T.          

//  Adicionado rotina U_EDFA003 - Alexandre Santos - 11/07/2013 */ 
PRIVATE aRotina	:= { 	{ OemToAnsi("Pesquisar"),   "AxPesqui"	  , 0, 1, 0, .F.},;
			 			{ OemToAnsi("Visualizar"),  "u_b001Manut" , 0, 2, 0, .F.},;
						{ OemToAnsi("Incluir"),     "u_b001Manut" , 0, 3, 0, .F.},;
						{ OemToAnsi("Atualizar"),   "u_b001Manut" , 0, 4, 0, .F.},; 
						{ OemToAnsi("Excluir"),     "u_b001Manut" , 0, 5, 0, .F.},; 
						{ OemToAnsi("Situacao"),    "u_b001Situac", 0, 6, 0, .F.},; 
						{ OemToAnsi("Gera P.C."),   "u_GerCom"    , 0, 7, 0, .F.},;         
						{ OemToAnsi("Gera P.V."),   "u_GerVenPE"    , 0, 7, 0, .F.},; 
						{ OemToAnsi("Copia Contrato"), "U_EDFA003"    , 0, 7, 0, .F.},;        						        
						{ OemToAnsi("Legenda"),     "U_b001Legenda" , 0, 7, 0, .F.},; 
						{ OemToAnsi("Acesso"),      "CN240Acesso" , 0, 8, 0, .F.},; 
						{ OemToAnsi("Conhecimento"),"MsDocument"  , 0, 4, 0, .F.} }    

Public xRotAuto := Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Mostra Lancamentos   S/N                          ³
//³ mv_par02 - Aglut Lancamentos    S/N                          ³
//³ mv_par03 - Lancamentos Online   S/N                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey(VK_F12,{|| Pergunte("CNT100",.T.)})

Pergunte("CNT100",.F.)

mBrowse(6,1,22,75,"CN9",,,,,,aCores)

SetKey( VK_F12 , Nil )

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    ³ b001Manut ³ Autor ³ Davi Jesus de Oliveira³ Data ³17.11.2010³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡ao ³ Rotina de manutencao de contrato                            ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function b001Manut(cAlias,nReg,nOpc)

Local aSize      := MsAdvSize()
Local aPosObj    := {}
Local aObjects   := {}
Local aArea      := GetArea()
Local aTitles    := {}
Local nGd1       := 0
Local nGd2       := 0
Local nGd3       := 0
Local nGd4       := 0
Local nOpcA      := 0
Local aCpos      := {}
Local lMedEve    := .F.//Med. Enventual
Local lContinua  := .T.
Local aButtons   := {}
Local oDlg
Local nX
Local lAntInc
Local lContraVld := .f.
Local lC100VlAt  := .f.
// criacao da tela de Tipo de contrato
Local oDlg2
Local oFnt2
Local oFnt22
Local oFnt32
Local oGroup2
Local oGet012
Local cTitulo2 := "Tipo de Contrato"
Local cTitulo3 := "Número Contrato"

//Campos nao exibidos para o contrato
Local aCpoN    := {}

//Planilhas
Local aPlani     := {}
Local aPlIt      := {}   
Local lAltPla    := (nOpc == 3 .Or. nOpc == 4)
Local nOpcTp     := 1
Local aHeaderCNB := {} //Armazena cabecalho da itens de planilha

Local lCaucRet   := (nOpc != 3 .And. (CN9->( FieldPos("CN9_TPCAUC") ) > 0) .And. CN9->CN9_FLGCAU == "1" .And. CN9->CN9_TPCAUC == "2")
Local nFldRet    := 0
Local nFldCtb    := 0

//Controle da numeracao sequencial
Local nStack    := GetSX8Len()

Local aUsButtons := {}  
Local ab001FLD   := {}
Local lb001Fol	 := .f.
Local lb001FLD   := .f.
Local nQtdVend   := Min(CntQtdVend("SC5"),CntQtdVend("SC6"))
Local _xxOpca    := nOpc // Preserva o valor nOpc // Leandro Ribeiro  24/07/2013  
Local _lContinua := .T.

nQtdVend := Min(CntQtdVend("SE1"),nQtdVend)

dbSelectArea("CN9")

If nOpc != 3 .And. !Empty(CN9->CN9_NUMERO)
//	lContinua := CN240VldUsr(CN9->CN9_NUMERO,If(nOpc==2,DEF_TRAVIS,DEF_TRAEDT),.T.)
EndIf


If lContinua
	PRIVATE lContab  := .T.
	PRIVATE aTela    := {}
	PRIVATE aGets    := {}

	Private Acols      := {}
	Private cEspCtr    := Space(TamSX3("CN1_ESPCTR")[1])
	Private cCodigo    := Space(TamSX3("CN1_CODIGO")[1])
	Private cContra    := Space(TamSX3("CN9_NUMERO")[1])
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montando a Tela de Pergunta para o tipo de contrato³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpc =3
		DEFINE MSDIALOG oDlg2 TITLE OemtoAnsi(cTitulo2) FROM  165,115 TO 245,430 PIXEL
		@ 05,10 SAY OemToAnsi(cTitulo2) SIZE 60, 8 OF oDlg2 PIXEL
		@ 05,70  MSGET oGet012 VAR cCodigo PICTURE "999" F3 "CN1" SIZE 25,9 VALID ExistCpo("CN1", cCodigo )  OF oDlg2 PIXEL

		@ 20,10 SAY OemToAnsi(cTitulo3) SIZE 60, 8 OF oDlg2 PIXEL
		@ 20,70  MSGET oGet012 VAR cContra PICTURE "@!" SIZE 50,9 VALID ExistChav("CN9",cContra) .AND. NAOVAZIO() OF oDlg2 PIXEL
		DEFINE SBUTTON FROM 10, 123 TYPE 1 ACTION (if(!empty(cCodigo),oDlg2:End(),)) ENABLE OF oDlg2
		DEFINE SBUTTON FROM 25, 123 TYPE 2 ACTION (cCodigo:="",oDlg2:End(),nOpcTp := 2) ENABLE OF oDlg2
		ACTIVATE MSDIALOG oDlg2
		
		CN1->( dbSetOrder(1) )
		CN1->( dbSeek(xFilial("CN1")+cCodigo) )
		
		cEspCtr := If(!Empty(CN1->CN1_ESPCTR),CN1->CN1_ESPCTR,"1")
		If  nOpcTp = 2  .Or. Empty(cCodigo)// cancelando a inclusao
			lContinua := .F.
		Endif  
		
		
		
	Else
		CN1->( dbSetOrder(1) )
		CN1->( dbSeek(xFilial("CN1")+CN9->CN9_TPCTO) )

		If !Empty(CN9->CN9_CLIENT)=.F.   // Verificar se for compra ou venda
			cEspCtr := "1"
		Else
			cEspCtr := "2"
		Endif
	Endif
		
	If lContinua 
		//Verifica se o contrato possui controle contabil
		lContab := (CN1->CN1_CROCTB == "1")
		
		If cEspCtr =="1"
			aTitles    := {OemtoAnsi("Fornecedores"),OemtoAnsi("Cronograma"),OemtoAnsi("Documentos Fiscais"),OemtoAnsi("Condição Comercial")}
			aCpoN      := {"CN9_JUSTIF","CN9_DESSTA","CN9_TIPREV","CN9_MOTPAR","CN9_DTFIMP","CN9_DTREIN","CN9_DTREAJ","CN9_VLREAJ","CN9_NUMTIT","CN9_ALTCLA","CN9_VLMEAC","CN9_TXADM","CN9_FORMA","CN9_DTENTR","CN9_LOCENT","CN9_CODENT","CN9_DESLOC","CN9_DESFIN","CN9_CONTFI","CN9_DTINPR","CN9_PERPRO","CN9_UNIPRO","CN9_VLRPRO","CN9_DTINCP","CN9_CLIENT","CN9_LOJACL"}
		Else
			aTitles    := {OemtoAnsi("Vendedores"),OemtoAnsi("Cronograma"),OemtoAnsi("Documento"),OemtoAnsi("Condição Comercial")}
			aCpoN      := {"CN9_JUSTIF","CN9_DESSTA","CN9_TIPREV","CN9_MOTPAR","CN9_DTFIMP","CN9_DTREIN","CN9_DTREAJ","CN9_VLREAJ","CN9_NUMTIT","CN9_ALTCLA","CN9_VLMEAC","CN9_TXADM","CN9_FORMA","CN9_DTENTR","CN9_LOCENT","CN9_CODENT","CN9_DESLOC","CN9_DESFIN","CN9_CONTFI","CN9_DTINPR","CN9_PERPRO","CN9_UNIPRO","CN9_VLRPRO","CN9_DTINCP"}
		Endif
		
		Private oFolder
		//Controles do fornecedor - CNC ou Vendedores
		Private aHeader1  := {}
		Private aCols1    := {}
		Private oGetDad1

		//Controles dos cronogramas - SZ3
		Private aHeader2  := {}
		Private aCols2    := {}
		Private oGetDad2

		//Controles dos documentos - SF2
		Private aHeader3  := {}
		Private aCols3    := {}
		Private oGetDad3	

		//Produtos / Condições Comerciais - SZ2
		Private aHeader4  := {}
		Private aCols4    := {}
		Private oGetDad4	
		
		dbSelectArea("SX3")
		dbSetOrder(2)
		
		/*	
		If lC100VlAt .And. nOpc == 4
			If !(ValType(uRet:=ExecBlock("C100VLAT",.F.,.F.,{CN9->CN9_SITUAC}))=="L" .And. uRet==.T.)
				Help(" ",1,"CNTA100ELB") //"Acao disponivel apenas para contratos em Elaboracao"
				Return .F.
			EndIf
		ElseIf (nOpc == 4 .OR. nOpc == 5) .And. AllTrim(CN9->CN9_SITUAC) != DEF_SELAB
			Help(" ",1,"CNTA100ELB") //"Acao disponivel apenas para contratos em Elaboracao"
			Return .F.
		EndIf
		*/
		
		dbSelectArea("SX3")
		MsSeek("CN9")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleciona os campos do cabecalho dos contratos     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCampos := RetCampos("CN9",.T.)
		For nx := 1 to len (aCampos)
			If X3Uso(GetSX3Cache(aCampos[nx],"X3_USADO")) .And. cNivel >= GetSX3Cache(aCampos[nx],"X3_NIVEL") .And. Ascan(aCpoN,{|x| x == alltrim(aCampos[nx])}) == 0
				Aadd(aCpos, aCampos[nx] )
			EndIF
			If	( GetSX3Cache(aCampos[nx],"X3_CONTEXT") == "V"  .Or. nOpc == 3  )
				M->&(aCampos[nx]) := CriaVar(aCampos[nx])
			Else
				M->&(aCampos[nx]) := CN9->(FieldGet(FieldPos(aCampos[nx])))
			EndIf
		Next nx
		If nOpc = 3
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualizando o campo Tipo de contrato    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			M->CN9_TPCTO :=cCodigo
            M->CN9_NUMERO :=cContra
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campos Memo do Contrato³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpc != 3
			M->CN9_OBJCTO := MSMM(M->CN9_CODOBJ)
			//Aadd(aCpos,"CN9_OBJCTO")
			M->CN9_JUSTIF := MSMM(M->CN9_CODJUS)
			Aadd(aCpos,"CN9_JUSTIF")
			M->CN9_ALTCLA := MSMM(M->CN9_CODCLA)
			Aadd(aCpos,"CN9_ALTCLA")
		EndIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem dos acols e aheaders dos folders 		     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		b001Acols(nOpc,lCaucRet,nFldRet)

		SETAPILHA()
		
		//Configura botoes de acesso ao cronograma e planilhas na alteracao
		Aadd(aButtons,{"BUDGET" ,{|| b001Cron(nOpc)},OemToAnsi("Crongoramas"),OemtoAnsi("Cronogramas")})
		Aadd(aButtons,{"NOTE"   ,{|| b001Hist(M->CN9_NUMERO)},OemtoAnsi("Historico")})

		If aRotina[ nOpc, 4 ] == 2
			AAdd(aButtons,{ "clips", {|| b001Conh()  }, "Banco de Conhecimento", "Conhecim." } )
			AAdd(aButtons,{ "bmpord1",   {|| b001Track() }, "System Tracker", "Tracker" } )
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta a Tela Principal										 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aObjects := {}
		aAdd( aObjects, {   0, 119, .t., .t. } )
		aAdd( aObjects, { 120, 101, .t., .t. } )
		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
		
		If(nOpc == 2)// Leandro Ribeiro  24/07/2013
 	      nOpc := 4
		Endif
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
		
		EnChoice( cAlias, nReg, nOpc, , , ,aCpos, aPosObj[1], , , , , , , , .T.)
		oFolder := TFolder():New(aPosObj[2,1],aPosObj[2,2],aTitles,,oDlg,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as posicoes da Getdados a partir do folder    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGd1 := 2
		nGd2 := 2
		nGd3 := aPosObj[2,3]-aPosObj[2,1]-15
		nGd4 := aPosObj[2,4]-aPosObj[2,2]-2
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta folder dos cronogramas                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oGetDad2 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,IIF(nOpc!=3 .And. nOpc!=4,0,GD_INSERT+GD_UPDATE+GD_DELETE),"U_BC001lok()",,,,,,,,,oFolder:aDialogs[2],aHeader2,aCols2)  // Alexandre Santos - 02/08/2013
		//oGetDad2 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,IIF(nOpc!=3 .And. nOpc!=4,0,GD_INSERT+GD_UPDATE+GD_DELETE),,,,,,,,,,oFolder:aDialogs[2],aHeader2,aCols2)

//		DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION b001Visual() ENABLE OF oFolder:aDialogs[2]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta das condicoes comerciais                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oGetDad4 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,IIF(nOpc!=3 .And. nOpc!=4,0,GD_INSERT+GD_UPDATE+GD_DELETE),,,,,,,,,,oFolder:aDialogs[4],aHeader4,aCols4)
//		DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION b001Visual() ENABLE OF oFolder:aDialogs[4]
		
		If cEspCtr =="1"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta folder dos fornecedores, permitindo insercao   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oGetDad1 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,IIF(nOpc!=3 .And. nOpc!=4,0,GD_INSERT+GD_UPDATE+GD_DELETE),,,,,,999,,,"b001DelFor()",oFolder:aDialogs[1],@aHeader1,@aCols1)
//			DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION b001Visual() ENABLE OF oFolder:aDialogs[1]
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta folder Dos vendedores                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oGetDad1 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,IIF(nOpc!=3 .And. nOpc!=4,0,GD_INSERT+GD_UPDATE+GD_DELETE),"b001VldVen()",,,,,nQtdVend,,,"b001DelVen()",oFolder:aDialogs[1],@aHeader1,@aCols1)
//			DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION b001Visual() ENABLE OF oFolder:aDialogs[1]
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta folder de visualizacao de documentos           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oGetDad3 := MsNewGetDados():New(nGd1,nGd2,nGd3-13,nGd4,0,,,,,,,,,,oFolder:aDialogs[3],@aHeader3,@aCols3)
//		DEFINE SBUTTON FROM nGd3-12,nGd4-29 TYPE 15 ACTION b001Visual() ENABLE OF oFolder:aDialogs[3]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui linha em branco das getdados de visualizacao  ³
		//³ quando nao houver informacao                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aCols3) == 0
			aDel(oGetDad3:aCols,1)
			aSize(oGetDad3:aCols,0)
		EndIf
		If Len(aCols2) == 0
			aDel(oGetDad2:aCols,1)
			aSize(oGetDad2:aCols,0)
		EndIf
		
		oFolder:bSetOption:={|nAtu| b001FoldCh(nAtu,oFolder:nOption,nFldCtb)}
//		ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||If(Obrigatorio(aGets,aTela) .And. If(cEspCtr=="1",.t.,b001VldVen()) .And. b001TudOk() .And. If(nOpc!=3 .And. nOpc!=2,b001VldPer(),.T.) .And. U_BC001lok(),(nOpcA:=1,oDlg:End()),nOpcA:=0)},{||(nOpcA:=2,oDlg:End())},,aButtons))    // Alexandre Santos - 02/08/2013
		ACTIVATE MSDIALOG oDlg CENTERED
		
		nOpc := _xxOpca // Leandro Ribeiro  24/07/2013

		If nOpcA == 1 .And. nOpc != 2 
			
			//Atualiza aCols
			aCols1 := oGetDad1:aCols
			aCols2 := oGetDad2:aCols
			aCols3 := oGetDad3:aCols
			aCols4 := oGetDad4:aCols
			
			b001Grv(nOpc,aPlani,aPlIt,aHeaderCNB)
			U_GrvEDFA006() // Leandro Ribeiro  24/07/2013
            
			If Select("TMPSZF") > 0 // 25/03/14 - Luís Felipe Nascimento
				While GetSX8Len() > nStack
					ConfirmSX8()
				EndDo
			EndIf
			EvalTrigger()
			msUnlockAll()
			
			//Atualiza campos MEMO
			If nOpc != 5
				MSMM(M->CN9_CODOBJ,,,M->CN9_OBJCTO,1,,,"CN9","CN9_CODOBJ")
				MSMM(M->CN9_ALTCLA,,,M->CN9_ALTCLA,1,,,"CN9","CN9_CODCLA")
			EndIf
			
			*'Yttalo P Martins-INICIO-------------------------------------------------'*
			*'Reflete alterações no contrato de venda---------------------------------'*
			If cEspCtr =="1" .and. Inclui
			
				If Aviso("Atencao", "Replicar atualização no contrato de venda?", {"Sim", "Nao"}) == 1			
								
					U_EDFA011()				
				EndIf

			EndIF
			*'Yttalo P Martins-FIM----------------------------------------------------'*
						
		Else
			While GetSX8Len() > nStack
				RollBackSX8()
			EndDo
				U_FecEDFA006()// Leandro Ribeiro  24/07/2013
		EndIf
	
	EndIf
EndIf

RestArea(aArea)
Return nOpcA


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    ³b001Acols ³ Autor ³ Davi Jesus de Oliveira                   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡ao ³ Monta acols para as getdados do folder                      ³±±
//±±³          ³ -Fornecedor                                                 ³±±
//±±³          ³ -Caucao                                                     ³±±
//±±³          ³ -Planilha                                                   ³±±
//±±³          ³ -Cronograma                                                 ³±±
//±±³          ³ -Multas                                                     ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001Acols(nOpc,lCaucRet,nFldRet)
Local aCpoNH     := Array(8)//Campos nao exibidos
Local nCntFor    := 0
Local cQuery

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuracao dos aHeaders	     	  	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Fornecedores/Vendedores
aCpoNH[1] := If(cEspCtr=="1",{"CNC_NUMERO"},{"CNU_CONTRA"})
//Caucao
aCpoNH[2] := {"CN8_CONTRA","CN8_REVISA"}
//Planilhas
aCpoNH[3] := If(cEspCtr=="1",{"CNA_CONTRA","CNA_REVISA","CNA_CLIENT","CNA_LOJACL","CNA_CRONCT"},{"CNA_FORNEC","CNA_LJFORN","CNA_CONTRA","CNA_REVISA","CNA_CRONCT"})
//Cronogramas
aCpoNH[4] := {"CNF_CONTRA","CNF_REVISA"}
//Multas
aCpoNH[5] := {"CNH_NUMERO"}
//Documentos
aCpoNH[6] := {"F1_DOC","F1_SERIE","F1_EMISSAO"}
//Adiantamentos
aCpoNH[7] := {"CNX_CONTRA","CNX_CLIENT","CNX_LOJACL"}

//CONDIÇÃO COMERCIAL
//aCpoNH[8] := {"Z2_CONTRA", "Z2_POLARI", "Z2_UMIDA", "Z2_COR", "Z2_CODPRO", "Z2_QTDTT", "Z2_EMBALA", "Z2_SEO", "Z2_INCOTER"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem dos aCols 										         	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cEspCtr="1"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CNC - Fornecedores											 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CNC")
	b001LdAl(nOpc,"CNC",aCols1,aHeader1,"CNC.CNC_NUMERO = '"+ M->CN9_NUMERO +"'",{"CNC_CODIGO","CNC_LOJA"},oGetDad1,aCpoNH[1])
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CNU - Vendedores                          						  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CNU")
	b001LdAl(nOpc,"CNU",aCols1,aHeader1,"CNU.CNU_CONTRA = '"+ M->CN9_NUMERO +"'",{"CNU_CODVD"},oGetDad1,aCpoNH[1])
Endif					
					
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CNF - Cronograma		               				 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
b001LdAl(nOpc,"SZ3",aCols2,aHeader2,"SZ3.Z3_CONTRA = '"+ M->CN9_NUMERO +"'",,oGetDad2,aCpoNH[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SZ2 - Condicoes Comerciais / Produtos                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Valdir Bigóde - Adriano - b001LdAl(nOpc,"SZ2",aCols4,aHeader4,"SZ2.Z2_CONTRA = '"+ M->CN9_NUMERO +"'",{"Z2_FILIAL", "Z2_CONTRA"},oGetDad4,aCpoNH[1])

//cQuery := "SELECT SZ2.* FROM "+ RetSQLName("SZ2") +" SZ2 WHERE "
//cQuery += "SZ2.Z2_FILIAL = '"+xFilial("SZ2")+"' AND "
//cQuery += "SZ2.Z2_CONTRA = '"+ M->CN9_NUMERO +"' AND "
//cQuery += "SZ2.D_E_L_E_T_ = ' '"
//b001LdAl(nOpc,"SZ2",aCols4,aHeader4,,,oGetDad4,/*aCpoNH[1]*/,cQuery)

b001LdAl(nOpc,"SZ2",aCols4,aHeader4,"SZ2.Z2_CONTRA = '"+ M->CN9_NUMERO +"'",,oGetDad4,aCpoNH[1])



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SF1 - Documentos Fiscais                        ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF1") 

cQuery := "SELECT SF1.* FROM "+ RetSQLName("SF1") +" SF1 WHERE "
cQuery += "SF1.F1_FILIAL = '"+xFilial("SF1")+"' AND "
cQuery += "SF1.F1_CONTRA = '"+ M->CN9_NUMERO +"' AND "
cQuery += "SF1.D_E_L_E_T_ = ' '"
		
b001LdAl(nOpc,"SF1",aCols3,aHeader3,,,oGetDad3,aCpoNH[3],cQuery)

Return(.T.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    ³b001VldPer³ Autor ³ Davi Jesus de Oliveira                   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡ao ³ Valida a vigencia contra os periodos dos cronogramas e      ³±±
//±±³          ³ planilhas cadastrados para o contrato                       ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ b001VldPer()                                               ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ CNTA100                                                     ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001VldPer()
Local lRet := .T.
Local dTermino := dDataBase+300
Local lVldVige := GetNewPar("MV_CNFVIGE","N") == "N"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida periodo contra os cronogramas               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lVldVige
	dbSelectArea("CNF")
	dbSetOrder(2)
	dbSeek(xFilial("CNF")+M->CN9_NUMERO+M->CN9_REVISA)
	While CNF->CNF_FILIAL == xFilial("CNF") .And. CNF->CNF_CONTRA == M->CN9_NUMERO .And. CNF->CNF_REVISA == M->CN9_REVISA
		If CNF->CNF_PRUMED > dTermino
			lRet := .F.
			Help(" ",1,"CNTA100VIG") //"Vigencia invalida para os cronogramas ja inclusos"
			Exit
		EndIf
		dbSkip()
	EndDo
EndIf

Return lRet

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001Grv    ³ Autor ³ Davi Jesus de Oliveira                  ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Realiza a gravacao do contrato                              ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001Grv(nExp01,aExp02,aExp03)                               ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ nExp01 - Opcao atual                                        ³±±
// ±±³          ³ aExp02 - Array com as planilhas adicionadas                 ³±±
// ±±³          ³ aExp03 - Array com os itens de planilhas adicionadas        ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001Grv(nOpc,aPlani,aPlIt,aHeaderCNB)
Local nCntFor  := 0
Local nCntFor2 := 0
Local nUsado   := 0
Local nCntVen  := 0
Local nCntVen2 := 0
Local lRet     := .T.
Local dTermino := ddatabase+300
Local cQuery   := ""
Local cArqTrb  := ""
Local cFilCNC  := xFilial("CNC")
Local cFilCN8  := xFilial("CN8")
Local cFilCNB  := xFilial("CNB")
Local cFilCNA  := xFilial("CNA")
Local cFilCNS  := xFilial("CNS")
Local cFilCNF  := xFilial("CNF")
Local cFilCNH  := xFilial("CNH")
Local cFilCN9  := xFilial("CN9")
Local cFilCNN  := xFilial("CNN")
Local cFilCNU  := xFilial("CNU")
Local cFilSC1  := xFilial("SC1")
Local cFilSF1  := xFilial("SF1")
Local cFilCNV  := xFilial("CNV")
Local cFilCNW  := xFilial("CNW")
Local lFixo    := .T.
Local lValor   := .T.

dbSelectArea("CN1")
dbSetOrder(1)
If (CN1->(FieldPos("CN1_CTRFIX")) > 0) .And. dbSeek(xFilial("CN1")+M->CN9_TPCTO)
	lFixo  := Empty(CN1->CN1_CTRFIX) .Or. (CN1->CN1_CTRFIX == "1")
	lValor := Empty(CN1->CN1_VLRPRV) .Or. (CN1->CN1_VLRPRV == "1")
EndIf

Do Case
	Case nOpc == 3  //Incluir
		Begin Transaction
		//Atualiza Contratos (Principal)
		dbSelectArea("CN9")
		Reclock("CN9",.T.)
		For nCntFor := 1 To FCount()            
			If (FieldName(nCntFor)!="CN9_FILIAL")
				FieldPut(nCntFor,M->&(FieldName(nCntFor)))
			EndIf
		Next nCntFor
		CN9->CN9_FILIAL := cFilCN9
		CN9->CN9_SITUAC := DEF_SELAB//Em elaboracao

		//Adriano - 29/2/12
		//CN9->CN9_DTFIM  := dTermino

		//Zera a vigencia quando indefinida
		If CN9->CN9_UNVIGE == "4"
			CN9->CN9_VIGE = 0
		EndIf
		
		//Verifica se o contrato possui planilha
		If !lFixo
			If lValor//Verifica se o contrato tem valor definido
				CN9->CN9_VLATU := CN9->CN9_VLINI
				CN9->CN9_SALDO := CN9->CN9_VLINI
			Else
				CN9->CN9_VLINI := 0
				CN9->CN9_VLATU := 0
				CN9->CN9_SALDO := 0
			EndIf
		EndIf

		MsUnlock()
		
		CN9->(FKCommit())
			
		//Atualiza Fornecedores
		nUsado := Len(aHeader1)
		For nCntFor := 1 To Len(aCols1)
			If ( !aCols1[nCntFor][nUsado+1] ) .And. !Empty(aCols1[nCntFor][1])
				dbSelectArea("CNC")
				Reclock("CNC",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeader1[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeader1[nCntFor2][2]),aCols1[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				CNC->CNC_FILIAL := cFilCNC
				CNC->CNC_NUMERO := CN9->CN9_NUMERO
				MsUnlock()
			EndIf
		Next
	
		CNC->(FKCommit())
	
	 
		//Atualiza Cronograma
		nUsado := Len(aHeader2)
		For nCntFor := 1 To Len(aCols2)
			If ( !aCols2[nCntFor][nUsado+1] ) .And. !Empty(aCols2[nCntFor][1])
				dbSelectArea("SZ3")
				Reclock("SZ3",.T.)
				For nCntFor2 := 1 To nUsado
					FieldPut(FieldPos(aHeader2[nCntFor2][2]),aCols2[nCntFor][nCntFor2])
				Next nCntFor2
				SZ3->Z3_FILIAL := xFilial("SZ3")
				SZ3->Z3_CONTRA := CN9->CN9_NUMERO
				MsUnlock()
			EndIf
		Next
	
		SZ3->(FKCommit())
		

		//Atualiza Condição comercial
		nUsado := Len(aHeader4)
		For nCntFor := 1 To Len(aCols4)
			If ( !aCols4[nCntFor][nUsado+1] ) .And. !Empty(aCols4[nCntFor][1])
				dbSelectArea("SZ2")
				Reclock("SZ2",.T.)
				For nCntFor2 := 1 To nUsado
					FieldPut(FieldPos(aHeader4[nCntFor2][2]),aCols4[nCntFor][nCntFor2])
				Next nCntFor2
				SZ2->Z2_FILIAL := xFilial("SZ2")
				SZ2->Z2_CONTRA := CN9->CN9_NUMERO
				MsUnlock()
			EndIf
		Next
	
		SZ2->(FKCommit())

		CNH->(FKCommit())
		
		If len(aPlani) > 0 .And. lFixo
			b001PlGr(aPlani,aPlIt,aHeaderCNB)
		EndIf
		
		CNA->(FKCommit())
		CNB->(FKCommit())
		
		MSMM(,,,M->CN9_OBJCTO,1,,,"CN9","CN9_CODOBJ")
		If AliasInDic("CNN")
			//Gera permissão de controle total sobre o contrato
			CNN->(DbSetOrder(1))
			If !DbSeek(xFilial("CNN")+RetCodUsr()+CN9_NUMERO+DEF_TRANS)
				RecLock("CNN",.T.)
				CNN->CNN_FILIAL := cFilCNN
				CNN->CNN_CONTRA := M->CN9_NUMERO
				CNN->CNN_USRCOD := RetCodUsr()
				CNN->CNN_TRACOD := DEF_TRANS
				MsUnlock()
			EndIf
		EndIf
		
		CNN->(FKCommit())

		//Atualiza Vendedores
     
        If cEspCtr="2"
			nUsado := Len(aHeader1)
			For nCntVen := 1 To Len(aCols1)
				If ( !aCols1[nCntVen][nUsado+1] ) .And. !Empty(aCols1[nCntVen][1])
					dbSelectArea("CNU")
					Reclock("CNU",.T.)
					For nCntVen2 := 1 To nUsado
						If ( aHeader1[nCntVen2][10] != "V" )
							FieldPut(FieldPos(aHeader1[nCntVen2][2]),aCols1[nCntVen][nCntVen2])
						EndIf
					Next nCntFor2
					CNU->CNU_FILIAL := cFilCNU
					CNU->CNU_CONTRA := CN9->CN9_NUMERO
					MsUnlock()
				EndIf
			Next
	    Endif
	   
	    CNU->(FKCommit())
	   
   	    End Transaction
	Case nOpc == 4  //Atualizar
		//Atualiza Contrato
		dbSelectArea("CN9")
		Reclock("CN9",.F.)
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)!="CN9_FILIAL")
				FieldPut(nCntFor,M->&(FieldName(nCntFor)))
			EndIf
		Next nCntFor
		CN9->CN9_FILIAL := cFilCN9
		
		//Adriano - 29/2/12
		//CN9->CN9_DTFIM  := dTermino
		
		//Zera a vigencia quando indefinida
		If CN9->CN9_UNVIGE == "4"
			CN9->CN9_VIGE = 0
		EndIf
		//Verifica se o contrato possui planilha
		If !lFixo
			If lValor//Verifica se o contrato tem valor definido
				CN9->CN9_VLATU := CN9->CN9_VLINI
				CN9->CN9_SALDO := CN9->CN9_VLINI
			Else
				CN9->CN9_VLINI := 0
				CN9->CN9_VLATU := 0
				CN9->CN9_SALDO := 0
			EndIf
		EndIf
		MsUnlock()
		
		MSMM(M->CN9_CODOBJ,,,M->CN9_OBJCTO,1,,,"CN9","CN9_CODOBJ")
		
	    If Empty(CN9->CN9_CLIENT)
			//Apaga Fornecedores
			dbSelectArea("CNC")
			dbSetOrder(1)
			If dbSeek(cFilCNC+M->CN9_NUMERO)
				While !Eof() .And. CNC->CNC_FILIAL = cFilCNC .And. CNC->CNC_NUMERO == M->CN9_NUMERO
					RecLock("CNC",.F.)
					CNC->(dbDelete())
					MsUnlock()
					CNC->(dbSkip())
				EndDo
			EndIf
		Else  
			//Apaga Vendedores
			dbSelectArea("CNU")
			dbSetOrder(1)
			If dbSeek(cFilCNU+M->CN9_NUMERO)
				While !Eof() .And. CNU->CNU_FILIAL = cFilCNU .And. CNU->CNU_CONTRA == M->CN9_NUMERO
					RecLock("CNU",.F.)
					CNU->(dbDelete())
					MsUnlock()
					CNU->(dbSkip())
				EndDo
			EndIf		
		Endif	
			
	   If cEspCtr == "1" .Or. Empty(cEspCtr)
			//Atualiza Fornecedores
			nUsado := Len(aHeader1)
			For nCntFor := 1 To Len(aCols1)
				If ( !aCols1[nCntFor][nUsado+1] ) .And. !Empty(aCols1[nCntFor][1])
					dbSelectArea("CNC")
					Reclock("CNC",.T.)
					For nCntFor2 := 1 To nUsado
						If ( aHeader1[nCntFor2][10] != "V" )
							FieldPut(FieldPos(aHeader1[nCntFor2][2]),aCols1[nCntFor][nCntFor2])
						EndIf
					Next nCntFor2
					CNC->CNC_FILIAL := cFilCNC
					CNC->CNC_NUMERO := CN9->CN9_NUMERO
					MsUnlock()
				EndIf
			Next
		Else
			//Atualiza Vendedores
			nUsado := Len(aHeader1)
			For nCntVen := 1 To Len(aCols1)
				If ( !aCols1[nCntVen][nUsado+1] ) .And. !Empty(aCols1[nCntVen][1])
					dbSelectArea("CNU")
					Reclock("CNU",.T.)
					For nCntVen2 := 1 To nUsado
						If ( aHeader1[nCntVen2][10] != "V" )
							FieldPut(FieldPos(aHeader1[nCntVen2][2]),aCols1[nCntVen][nCntVen2])
						EndIf
					Next nCntFor2
					CNU->CNU_FILIAL := cFilCNU
					CNU->CNU_CONTRA := CN9->CN9_NUMERO
					MsUnlock()
				EndIf
			Next
		Endif	
			
		//Apaga Cronograma
		dbSelectArea("SZ3")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ3")+M->CN9_NUMERO)
			While !Eof() .And. SZ3->Z3_FILIAL == xFilial("SZ3") .And. SZ3->Z3_CONTRA == M->CN9_NUMERO
				RecLock("SZ3",.F.)
				SZ3->(dbDelete())
				MsUnlock()
				SZ3->(dbSkip())
			EndDo
		EndIf

		//Apaga Condições comerciais
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ2")+M->CN9_NUMERO)
			While !Eof() .And. SZ2->Z2_FILIAL == xFilial("SZ2") .And. SZ2->Z2_CONTRA == M->CN9_NUMERO
				RecLock("SZ2",.F.)
				SZ2->(dbDelete())
				MsUnlock()
				SZ2->(dbSkip())
			EndDo
		EndIf

		//Atualiza Cronograma
		nUsado := Len(aHeader2)
		For nCntFor := 1 To Len(aCols2)
			If ( !aCols2[nCntFor][nUsado+1] ) .And. !Empty(aCols2[nCntFor][1])
				dbSelectArea("SZ3")
				Reclock("SZ3",.T.)
				For nCntFor2 := 1 To nUsado
					FieldPut(FieldPos(aHeader2[nCntFor2][2]),aCols2[nCntFor][nCntFor2])
				Next nCntFor2
				SZ3->Z3_FILIAL := xFilial("SZ3")
				SZ3->Z3_CONTRA := CN9->CN9_NUMERO
				MsUnlock()
			EndIf
		Next
	
		SZ3->(FKCommit())
		

		//Atualiza Condição comercial
		nUsado := Len(aHeader4)
		For nCntFor := 1 To Len(aCols4)
			If ( !aCols4[nCntFor][nUsado+1] ) .And. !Empty(aCols4[nCntFor][1])
				dbSelectArea("SZ2")
				Reclock("SZ2",.T.)
				For nCntFor2 := 1 To nUsado
					FieldPut(FieldPos(aHeader4[nCntFor2][2]),aCols4[nCntFor][nCntFor2])
				Next nCntFor2
				SZ2->Z2_FILIAL := xFilial("SZ2")
				SZ2->Z2_CONTRA := CN9->CN9_NUMERO
				MsUnlock()
			EndIf
		Next
	
		SZ2->(FKCommit())
		
	Case nOpc == 5  //Exclusao
		If allTrim(CN9->CN9_SITUAC) == DEF_SELAB//Permite exclusao apenas para contratos em elaboracao
			Begin Transaction
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui a amarracao com os conhecimentos                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MsDocument( "CN9", CN9->( RecNo() ), 2, , 3 ) 

			If Empty(CN9->CN9_CLIENT)
				//Apaga Fornecedores X Contratos
				dbSelectArea("CNC")
				dbSetOrder(1)
				If dbSeek(cFilCNC+CN9->CN9_NUMERO)
					While !Eof() .And. CNC->CNC_FILIAL = cFilCNC .And. CNC->CNC_NUMERO == CN9->CN9_NUMERO
						RecLock("CNC", .F.)
						dbDelete()
						MsUnLock()
						dbSelectArea("CNC")
						dbSkip()
					EndDo
				EndIf
				
				CNC->(FKCommit())
			Else
				//Apaga Vendedores
				dbSelectArea("CNU")
				dbSetOrder(1)
				If dbSeek(cFilCNU+M->CN9_NUMERO)
					While !Eof() .And. CNU->CNU_FILIAL = cFilCNU .And. CNU->CNU_CONTRA == M->CN9_NUMERO
						RecLock("CNU",.F.)
						CNU->(dbDelete())
						MsUnlock()
						CNU->(dbSkip())
					EndDo
				EndIf

				CNU->(FKCommit())
			EndIf
			
			//Apaga Planilhas
			dbSelectArea("CNA")
			dbSetOrder(3)
			If dbSeek(cFilCNA+CN9->CN9_NUMERO+CN9->CN9_REVISA)
				While !Eof() .And. CNA->CNA_FILIAL = cFilCNA .And. CNA->CNA_CONTRA == CN9->CN9_NUMERO .And. CNA->CNA_REVISA == CN9->CN9_REVISA
					RecLock("CNA", .F.)
					dbDelete()
					MsUnLock()
					
					dbSelectArea("CNA")
					dbSkip()
				EndDo
			EndIf
			
			CNA->(FKCommit())

			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Exclui pemissoes de acesso relacionadas ao contrato  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CNN") 
			
			cArqTrb	:= CriaTrab( nil, .F. )  
			cQuery := "SELECT R_E_C_N_O_ as RECNO "
			cQuery += "FROM "+RetSQLName("CNN")+" CNN "
			cQuery += "WHERE CNN.CNN_FILIAL = '"+cFilCNN+"' "
			cQuery += "AND CNN.CNN_CONTRA = '"+CN9->CN9_NUMERO+"' "
			cQuery += "AND CNN.D_E_L_E_T_ = ' ' "

			cQuery := ChangeQuery( cQuery )
	
			dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .T., .T. )

			While !(cArqTrb)->(Eof())	
				CNN->(dbGoTo((cArqTrb)->RECNO))
				RecLock("CNN",.F.)
				dbDelete()
				MsUnlock()
				
				(cArqTrb)->(dbSkip())
			EndDo
			
			(cArqTrb)->( dbCloseArea() )
			
			CNN->(FKCommit())

			//Apaga Cronograma
			dbSelectArea("SZ3")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ3")+M->CN9_NUMERO)
					While !Eof() .And. SZ3->Z3_FILIAL == xFilial("SZ3") .And. SZ3->Z3_CONTRA == M->CN9_NUMERO
					RecLock("SZ3",.F.)
					SZ3->(dbDelete())
					MsUnlock()
					SZ3->(dbSkip())
				EndDo
			EndIf
	
			//Apaga Condições comerciais
			dbSelectArea("SZ2")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ2")+M->CN9_NUMERO)
				While !Eof() .And. SZ2->Z2_FILIAL == xFilial("SZ2") .And. SZ2->Z2_CONTRA == M->CN9_NUMERO
					RecLock("SZ2",.F.)
					SZ2->(dbDelete())
					MsUnlock()
					SZ2->(dbSkip())
				EndDo
			EndIf
	
//-------------------------------------------------------------------------------------------------------------------------
// Apaga os Registros na SZF detalhamento dos premios // Leandro Ribeiro  24/07/2013
//-------------------------------------------------------------------------------------------------------------------------
			DbSelectArea("SZF")
			DbSetOrder(1)
			If DbSeek(xFilial("SZF")+M->CN9_NUMERO)
				While !Eof() .And. SZF->ZF_FILIAL == xFilial("SZF") .And. SZF->ZF_CONTRA == M->CN9_NUMERO
					RecLock("SZF",.F.)
					DbDelete()
					MsUnlock()
					dbSkip()
				EndDo
			EndIf
//-------------------------------------------------------------------------------------------------------------------------
			//Apaga Contratos
			dbSelectArea("CN9")
			MSMM(CN9_CODOBJ,,,,2)
			MSMM(CN9_CODJUS,,,,2)
			MSMM(CN9_CODCLA,,,,2)
			
			Reclock("CN9",.F.)
			dbDelete()
			MsUnlock()
			End Transaction
			
		Else
			Help(" ",1,"CNTA100EXC") //"Exclusao permitida apenas para contratos em elaboracao"
			lRet := .F.
		EndIf
EndCase
Return(lRet)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    ³ b001Visual³ Autor ³ Davi Jesus de Oliveira                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡ao ³ Executa a rotina de visualizacao dos elementos do contrato  ³±±
//±±³          ³ de acordo com o folder atual                                ³±±
//±±³          ³ 1 - Fornecedor                                              ³±±
//±±³          ³ 2 - Cronograma                                              ³±±
//±±³          ³ 3 - Documento                                               ³±±
//±±³          ³ 4 - Condicoes Comerciais                                    ³±±
//±±³          ³                                                             ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ b001Visual(nExp01,aExp02,aExp03)                            ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ nExp01 - Opcao atual                                        ³±±
//±±³          ³ aExp02 - Array com as planilhas adicionadas                 ³±±
//±±³          ³ aExp03 - Array com os itens das planilhas adicionadas       ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ CNTA100                                                     ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
static Function b001Visual(nOpc,aPlani,aPlIt)

Local aArea	  := GetArea()
Local nFolder := oFolder:nOption
Local lRotRevis:= .F.

Do Case
	Case nFolder == 1  //Fornecedores//Vendedores
      If cEspCtr="1"
			If Len(ogetDad1:aCols) > 0
				dbSelectArea("SA2")
				dbSetOrder(1) //A2_FILIAL+A2_COD+A2_LOJA
				if dbSeek(xFilial("SA2")+ogetDad1:aCols[ogetDad1:nAt][aScan(aHeader1,{|x| AllTrim(x[2]) == "CNC_CODIGO"})]+ogetDad1:aCols[ogetDad1:nAt][aScan(aHeader1,{|x| AllTrim(x[2])  == "CNC_LOJA"})])
					AxVisual("SA2",Recno(),2)
				EndIf
			Endif	
		Else	
			If Len(ogetDad1:aCols) > 0
				dbSelectArea("SA3")
				dbSetOrder(1) //A2_FILIAL+A2_COD+A2_LOJA
				if dbSeek(xFilial("SA3")+ogetDad1:aCols[ogetDad1:nAt][aScan(aHeader1,{|x| AllTrim(x[2]) == "CNU_CODVD"})])
					AxVisual("SA3",Recno(),2)
				EndIf
			EndIf
		EndIf
		
	Case nFolder == 2  //Cronograma
		If Len(ogetDad2:aCols) > 0
			dbSelectArea("SZ3")
			dbSetOrder(2)
			if dbSeek(xFilial("SZ3")+M->CN9_NUMERO+M->CN9_REVISA+ogetDad2:aCols[ogetDad2:nAt][aScan(aHeader2,{|x| AllTrim(x[2]) == "Z3_CONTRA"})])
				b_01Manut("SZ3",Recno(),2)
			EndIf
		EndIf
		
	Case nFolder == 3  //Documentos Fiscais
		If Len(ogetDad3:aCols) > 0
			dbSelectArea("SF1")
		    SF1->( dbOrderNickName("CTRT") )

			if dbSeek(xFilial("SF1")+ogetDad3:aCols[ogetDad3:nAt][aScan(aHeader3,{|x| AllTrim(x[2]) == "F1_CONTRA"})])
				CN170Manut("SF1",Recno(),2)
			EndIf
		EndIf   

	Case nFolder == 4  //Condicoes Comerciais
		If Len(ogetDad4:aCols) > 0
			dbSelectArea("SZ2")
			dbSetOrder(1)
			if dbSeek(xFilial("SZ2")+ogetDad4:aCols[ogetDad4:nAt][aScan(aHeader4,{|x| AllTrim(x[1]) == "Z2_CONTRA"})])
				b_01Manut("SZ2",Recno(),2)
			EndIf
		EndIf   
		
EndCase

RestArea(aArea)

Return .T.

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    |b001VlFor  ³ Autor ³ Davi Jesus de Oliveira                   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡ao ³Valida linha atual do fornecedor                              ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ X3_VALID do campo CNC_CODIGO                                 ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001VlFor()
Local lRet	:= .T.
Local cForn	:= M->CNC_CODIGO
Local cLoja := ogetDad1:aCols[n,aScan(aHeader1,{|x| AllTrim(x[2]) == "CNC_LOJA"})]

If !Empty(cForn) .and. !Empty(cLoja)
	lRet := ExistCpo("SA2",cForn+cLoja)
Endif

Return lRet

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    |b001VlLoj  ³ Autor ³ Davi Jesus de Oliveira                  ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³Valida linha atual do fornecedor                              ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³ Uso      ³ X3_VALID do campo CNC_LOJA                                   ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001VlLoj()
Local lRet	:= .T.
Local cForn	:= ogetDad1:aCols[n,aScan(aHeader1,{|x| AllTrim(x[2]) == "CNC_CODIGO"})]
Local cLoja := M->CNC_LOJA

If !Empty(cForn) .and. !Empty(cLoja)
	lRet := ExistCpo("SA2",cForn+cLoja)
Endif

Return lRet

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001VldVen³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Valida os Vendedores do Contrato                            ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001VldVen()                                               ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³ Uso      ³ CNTA100                                                     ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
static Function b001VldVen()
Local nI
Local lRepetido := .F.
Local lRet := .T.
Local nPosVen := Ascan( aheader1, {|x| TRIM(x[2]) == "CNU_CODVD"})
Local nPosPerc:= Ascan( aheader1, {|x| TRIM(x[2]) == "CNU_PERCCM"})
Local nPos    := oGetDad1:nAt
Local nLinhas := 0 // numero maximo de venderores
Local m := 0
Local nTotPerc := 0

If !Empty(oGetDad1:aCols[nPos,nPosVen])
	If !oGetDad1:aCols[nPos][len( aHeader1 ) + 1]
		lRet := ExistCpo("SA3",oGetDad1:aCols[nPos,nPosVen])
	EndIf
	
	If lRet .And. Len( oGetDad1:aCols ) > 1 .And. !oGetDad1:aCols[nPos][len( aHeader1 ) + 1]
		
		For nI:= 1 To Len( oGetDad1:aCols )
			If ( nI != nPos ) .and. !oGetDad1:aCols[nI][len( aHeader1 ) + 1]
				If oGetDad1:aCols[nI,nPosVen] == oGetDad1:aCols[nPos,nPosVen] 
					lRepetido := .T.
					Exit
				Endif               
			Endif
		Next nI
		
		If lRepetido
			lRet:=.F.
			Help(" ",1,"JAGRAVADO")
		End
	Endif
EndIf 

nTotPerc :=0

For nI:= 1 To Len(oGetDad1:aCols)
	nTotPerc +=oGetDad1:aCols[nI][nPosPerc]  // percentuais
   If nTotPerc > 100
  		lRet:=.F.
   	Help(" ",1,"CNTA100PVE")
	Endif
Next nI


Return lRet


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³ b001FoldCh³ Autor ³ Davi Jesus de Oliveira                  ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Executa a alteracao de folder                               ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001FoldCh(nExp01,nExp02)                                  ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ nExp01 - Folder de destino                                  ³±±
// ±±³          ³ nExp02 - Folder atual                                       ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³ Uso      ³ CNTA100                                                     ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001FoldCh(nFldDes,nFldAtu,nFldCtb)

Local lRet := .T.

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida destino	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CN1")
	dbSetOrder(1)
	If (CN1->(FieldPos("CN1_VLRPRV")) > 0) .And. dbSeek(xFilial("CN1")+M->CN9_TPCTO)
		lRet := (Empty(CN1->CN1_CTRFIX) .Or. CN1->CN1_CTRFIX == "1")
	EndIf
EndIf

Return lRet

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001Legenda³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Rotina de legenda do contrato                                ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001Legenda(nExp01,nExp02)                                  ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³ Uso      ³ CNTA100                                                      ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function b001Legenda()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com as cores que representam a situacao de cada Contrato na mBrowse.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aLegenda := {	{"BR_VERMELHO", OemtoAnsi("Cancelado")	    },;  
					{"BR_AMARELO" , OemtoAnsi("Em Elaboracao")	},;  
					{"BR_AZUL"    , OemtoAnsi("Emitido")	    },;  
					{"BR_LARANJA" , OemtoAnsi("Em Aprovacao")	},;  
					{"BR_VERDE"   , OemtoAnsi("Vigente")	    },;  
					{"BR_CINZA"   , OemtoAnsi("Encerrado")	    }}
					
Private cCadastro := OemToAnsi("Manutencao de Contratos") // 20/09/17 - Luis Felipe
					  


BrwLegenda(cCadastro, OemtoAnsi("Legendas"), aLegenda)

Return .T.


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³ b001TudOk  ³ Autor ³ Davi Jesu   s                           ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Valida o cabecalho do contrato                               ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001TudOk()                                                 ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³ Uso      ³ CNTA100                                                      ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001TudOk()
Local lRet := .T.
Local nPosForn
Local nPosLoja
Local lForn    := .T.
Local nX

If cEspCtr =="1"
	nPosForn := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_CODIGO"})
	nPosLoja := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_LOJA"})
	If Len(oGetDad1:aCols) == 1 .And. Empty(oGetDad1:aCols[1,nPosForn]) .And. Empty(oGetDad1:aCols[1,nPosForn])
		Help(" ",1,"CNTA100FOR") //"Inclua ao menos um fornecedor no contrato"
		lRet := .F.
	Else
		nI := 1
		//Verifica itens deletados
		while nI <= len(oGetDad1:aCols) .And. oGetDad1:aCols[nI][len(ogetDad1:aHeader)+1]
			nI++
		EndDo
		
		If nI > len(oGetDad1:aCols)
			Help(" ",1,"CNTA100FOR") //"Inclua ao menos um fornecedor no contrato"
			lRet := .F.
		EndIf
	EndIf
Endif	

If lRet .And. (M->CN9_MOEDA < 1) .Or. (M->CN9_MOEDA > MOEDFIN())
	Help(" ",1,"CNTA100MOE") //"Preencha a moeda corrente"
	lRet := .F.
EndIf

Return lRet

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³ b001SitCh³ Autor ³ Davi Jesus de Oliveira                  ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Altera situacao do contrato, executando todas as validacoes³±±
// ±±³          ³ necessarias                                                ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001SitCh(cExp01,cExp02,cExp03)                           ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ cExp01 - Numero do contrato                                ³±±
// ±±³          ³ cExp02 - Revisao do contrato                               ³±±
// ±±³          ³ cExp03 - Nova situacao do contrato                         ³±±
// ±±³          ³          1 - Cancelado                                     ³±±
// ±±³          ³          2 - Em elaboracao                                 ³±±
// ±±³          ³          3 - Emitido                                       ³±±
// ±±³          ³          4 - Em aprovacao                                  ³±±
// ±±³          ³          5 - Vigente                                       ³±±
// ±±³          ³          6 - Paralisado                                    ³±±
// ±±³          ³          7 - Sol Paralisacao                               ³±±
// ±±³          ³          8 - Finalizado                                    ³±±
// =±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001SitCh(cContra,cRevisa,cNewSituc)
Local lRet := .T.
Local lMedeve
Local lCaucao
Local lContab
Local lFisico
Local nPCauc
Local nTotPlan := 0//Quant de Planilhas
Local nMotPlan := 0//Montante das planilhas
Local nMotCron := 0//Montante dos cronogramas
Local nMotCrCt := 0//Montante dos cronogramas contabeis
Local nMotCauc := 0//Montante das caucoes
Local cFilCod
Local dDataAssi := dDataBase
Local cQuery    := ""
Local cAliasQry := ""  
Local uRet      := NIL
Local cLctoVige := "694"
Local cLctoCanc := "696"
Local lValor

//Informa variacao do contrato fixo/variavel
//através do ponto de entrada b001FIX
Private lFixo   := .T.

If lRet
	Do Case
		Case cNewSituc  = DEF_SEMIT
			dbSelectArea("CN9")
			dbSetOrder(1)
			//Inclui data de assinatura
			If	dbSeek(xFilial("CN9")+cContra+cRevisa)
				RecLock("CN9",.F.)
				CN9->CN9_SITUAC := cNewSituc
				CN9->CN9_DTULST := dDataBase
				msUnlock()
				Aviso("CNTA100",OemtoAnsi("Situacao alterada com sucesso"),{"Ok"})// 
			EndIf
		Case (cNewSituc  = DEF_SAPRO)//Atualiza situacao para "Em Aprovacao"
			dbSelectArea("CN9")
			dbSetOrder(1)
			If	dbSeek(xFilial("CN9")+cContra+cRevisa)
				RecLock("CN9",.F.)
				CN9->CN9_SITUAC := cNewSituc
				CN9->CN9_DTASSI := dDataAssi//Inclui data de assinatura
				CN9->CN9_DTULST := dDataBase
				msUnlock()
				Aviso("CNTA100",OemtoAnsi("Situacao alterada com sucesso"),{"Ok"})// 
			EndIf
		Case cNewSituc  = DEF_SVIGE//Atualiza situacao para Vigente
			dbSelectArea("CN9")
			dbSetOrder(1)
			If	dbSeek(xFilial("CN9")+cContra+cRevisa)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica situação atual do contrato                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AllTrim(CN9->CN9_SITUAC) == DEF_SELAB .Or. AllTrim(CN9->CN9_SITUAC) == DEF_SEMIT .Or. AllTrim(CN9->CN9_SITUAC) == DEF_SAPRO
					//Medicao Eventual
					lMedeve := (Posicione("CN1",1,xFilial("CN1")+CN9_TPCTO,"CN1_MEDEVE") == "1")
					
					//Previsao Financeira
					lValor := (Posicione("CN1",1,xFilial("CN1")+CN9_TPCTO,"CN1_VLRPRV") == "1")
					
					//Controla ou nao caucao
					lCaucao := (CN9->CN9_FLGCAU == "1" .And. If((CN9->(FieldPos("CN9_TPCAUC")) > 0),(CN9->CN9_TPCAUC == "1"),.T.))
	
					//Controla ou nao cronograma fisico
					lFisico := (CN1->CN1_CROFIS = "1")
	
					//Controla ou nao planilhas
					If (CN1->(FieldPos("CN1_CTRFIX")) > 0)
						lFixo := Empty(CN1->CN1_CTRFIX) .Or. CN1->CN1_CTRFIX = "1"
					EndIf
	
					//Controla ou nao contabil
					lContab := (Posicione("CN1",1,xFilial("CN1")+CN9_TPCTO,"CN1_CROCTB") == "1")
	
					If lCaucao
						nPCauc := CN9->CN9_MINCAU//Percentual minimo de caucao
					EndIf
					
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica cronogramas se nao for medicao eventual   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					if lRet .And. !lMedeve
					
						If !lFisico	
							dbSelectArea("CNF")
							dbSetOrder(2)
							cFilCod := xFilial("CNF")
							dbSeek(cFilCod+CN9->CN9_NUMERO+CN9->CN9_REVISA)
							
							while CNF->CNF_FILIAL = cFilCod .And. CNF->CNF_CONTRA = CN9->CN9_NUMERO .And. CNF->CNF_REVISA = CN9->CN9_REVISA
								//Soma montante dos cronogramas
								nMotCron+=CNF->CNF_VLPREV
								dbSkip()
							EndDo           
		
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Arredonda valores totais de cronograma e planilha    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
							nMotCron := Round(nMotCron,TamSX3("CNF_VLPREV")[2])
							nMotPlan := Round(nMotPlan,TamSX3("CNA_VLTOT")[2])
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica montante dos cronogramas contra montante    ³
							//³ das planilhas                                        ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nMotPlan != nMotCron
								Help(" ",1,"CNTA100MON") //"O montante das planilhas nao equivale ao montante dos cronogramas"
								lRet := .F.
							EndIf
						Else
							cAliasQry := GetNextAlias()
	
							cQuery := "SELECT CNS.CNS_CONTRA,CNS.CNS_REVISA,CNS.CNS_PLANI,CNS.CNS_ITEM,SUM(CNS.CNS_PRVQTD) AS CNS_PRVQTD "
							cQuery += "FROM "+ RetSQLName("CNS") +" CNS WHERE "
							cQuery += "CNS.CNS_FILIAL = '"+xFilial("CNS")+"' AND "
							cQuery += "CNS.CNS_CONTRA = '"+CN9->CN9_NUMERO+"' AND "
							cQuery += "CNS.CNS_REVISA = '"+CN9->CN9_REVISA+"' AND "
							cQuery += "CNS.D_E_L_E_T_ = ' ' "
							cQuery += "GROUP BY CNS.CNS_CONTRA,CNS.CNS_REVISA,CNS.CNS_PLANI,CNS.CNS_ITEM"
							
							cQuery := ChangeQuery( cQuery )			
							dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAliasQry, .T., .T. )
	
							TCSetField( cAliasQry, "CNS_PRVQTD", "N", TamSX3("CNS_PRVQTD")[1], TamSX3("CNS_PRVQTD")[2] )
							
							dbSelectArea("CNB")
							dbSetOrder(1)
							
							cFilCod := xFilial("CNB")
							While !(cAliasQry)->(Eof())
								If dbSeek(cFilCod+(cAliasQry)->CNS_CONTRA+(cAliasQry)->CNS_REVISA+(cAliasQry)->CNS_PLANI+(cAliasQry)->CNS_ITEM)
									If CNB->CNB_QUANT != (cAliasQry)->CNS_PRVQTD
										lRet := .F.
										Aviso("Atencao","O item "+(cAliasQry)->CNS_ITEM+" da planilha "+(cAliasQry)->CNS_PLANI+" possui saldo em aberto para distribuição no cronograma físico.",{"OK"},2)
										Exit
									EndIf
								EndIf
								(cAliasQry)->(dbSkip())
							EndDo
						EndIf
					EndIf
				Endif	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa alteracao quando todas as validacoes estiverem OK ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lRet
			
					if !Empty(CN9->CN9_DTASSI)
						dDataAssi := CN9->CN9_DTASSI
					EndIf
				
					RecLock("CN9",.F.)
					CN9->CN9_SITUAC := cNewSituc
					If Empty(CN9->CN9_DTASSI)
						CN9->CN9_DTASSI := dDataBase
					EndIf
					CN9->CN9_DTULST := dDataBase
					MsUnlock()
					Aviso("CNTA100",OemtoAnsi("Situacao alterada com sucesso"),{"Ok"})// 
				EndIf
			EndIf
			
		Case cNewSituc == DEF_SFINA
			dbSelectArea("CN9")
			dbSetOrder(1)
			If	dbSeek(xFilial("CN9")+cContra+cRevisa)
				RecLock("CN9",.F.)
				CN9->CN9_SITUAC := cNewSituc
				CN9->CN9_DTULST := dDataBase
				msUnlock()
				Aviso("CNTA100",OemtoAnsi("Situacao alterada com sucesso"),{"Ok"})
			EndIf		
		Otherwise
			dbSelectArea("CN9")
			dbSetOrder(1)
			If	dbSeek(xFilial("CN9")+cContra+cRevisa)
				RecLock("CN9",.F.)
				CN9->CN9_SITUAC := cNewSituc
				CN9->CN9_DTULST := dDataBase
				msUnlock()
				Aviso("CNTA100",OemtoAnsi("Situacao alterada com sucesso"),{"Ok"})
			endif
		EndCase
EndIf
Return lRet

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001DelFor³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Valida exclusao de fornecedor                               ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001DelFor                                                 ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³ Uso      ³ CNTA100                                                     ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001DelFor()
Local lRet := .T.
Local nPosForn := aScan(aHeader,{|x| AllTrim(x[2])  == "CNC_CODIGO"})
Local nPosLoja := aScan(aHeader,{|x| AllTrim(x[2])  == "CNC_LOJA"})
Local nPos := oGetDad1:nAt
//Verifica a existencia de planilhas para o fornecedor atual
Local nFornCNA := aScan(oGetDad3:aCols,{|x| x[aScan(aHeader3,{|x| AllTrim(x[2]) == "CNA_FORNEC"})] == oGetDad1:aCols[nPos,nPosForn] .And. x[aScan(aHeader3,{|x| AllTrim(x[2]) == "CNA_LJFORN"})] == oGetDad1:aCols[nPos,nPosLoja]})
Local nFornCN8

lRet := (nFornCNA == 0)

Return lRet   


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    ³b001DelVen³ Autor ³ Davi Jesus de Oliveira                   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡ao ³ Valida exclusao do Vendedor                                 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ b001DelVen                                                 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ CNTA100                                                     ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001DelVen()
Local lRet := .T.
Local nPosVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "CNU_CODVD"})
Local nPos := oGetDad1:nAt
//Verifica a existencia de planilhas para o fornecedor atual
Local nVenCNA := aScan(oGetDad1:aCols,{|x| x[aScan(aHeader1,{|x| AllTrim(x[2]) == "CNU_CODVD"})] == oGetDad1:aCols[nPos,nPosVen]})
Local nVenCN8


Return lRet


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001Hist  ³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Historico do contrato                                       ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001Hist(cExp01)                                           ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ cExp01 - Contrato                                           ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³ Uso      ³ CNTA100                                                     ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001Hist(cContra)
Local cAntCadastro := cCadastro
Local aAntRotina   := aRotina
Local cFilter      := 'CNG_FILIAL == "' + xFilial("CNG") + '" .And. CNG_CONTRA == "' + cContra + '"'
Local aIndCNG      := {}

Private cCadastro  := OemToAnsi("Historico")

Private aRotina := 	{ 	{ OemToAnsi("Pesquisar"), "AxPesqui", 0, 1},;
						{ OemToAnsi("Visualizar"), "AxVisual", 0, 2}} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra multas do contrato              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FilBrowse("CNG",@aIndCNG,cFilter)

mBrowse(6,1,22,75,"CNG")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retira filtro do arquivo de multas     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndFilBrw("CNG",aIndCNG)

cCadastro := cAntCadastro
aRotina   := aAntRotina
Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001Situac³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Controle de situacoes do contrato                           ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001Situac(cExp01,cExp02,nExp03)                           ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ cExp01 - Alias do arquivo                                   ³±±
// ±±³          ³ cExp02 - Registro atual                                     ³±±
// ±±³          ³ nExp03 - Opcao atual                                        ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³ Uso      ³ CNTA100                                                     ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User  Function b001Situac(cAlias,nReg,nOpc)
Local cCadastro := OemToAnsi("Controle de Situacoes")
Local aSituac   := RetSx3Box( Posicione("SX3", 2, "CN9_SITUAC", "X3CBox()" ),,, TamSX3("CN9_SITUAC")[1] )
Local aSitTx    := {}
Local oSituCb
Local oDlg
Local oGet01,oGet02,oGet03
Local cSitAtu
Local cSitOrg
Local nOpcA
Local cContra
Local cRevisa
Local lSituAll := (GetNewPar( "MV_CNSITAL", "S" ) == "S")

//If CN240VldUsr(CN9->CN9_NUMERO,DEF_TRASIT,.T.)
	dbSelectArea("SX3")
	dbSetOrder(2)
	
	//Situacao atual
	cSitOrg := CN9->CN9_SITUAC
	cSitAtu := AllTrim( aSituac[Ascan( aSituac, { |aBox| substr(aBox[1],1,At("=",aBox[1])-1) = AllTrim(cSitOrg)} )][3] )
	
	dbSelectArea("CN9")
	dbGoto(nReg)
	
	cContra := CN9->CN9_NUMERO
	cRevisa := CN9->CN9_REVISA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Disponibliza as situacoes de acordo    ³
	//³ com a atual                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ De: Elaboracao                         ³
		//³ Para: Emitido, Aprovacao, Vigente      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(CN9->CN9_SITUAC) == DEF_SELAB
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SEMIT})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SAPRO})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SVIGE})][1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ De: Emitido                                        ³
			//³ Para: Elaboracao, Aprovacao, Vigente, Cancelado    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(CN9->CN9_SITUAC) == DEF_SEMIT
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SELAB})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SAPRO})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SVIGE})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SCANC})][1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ De: Aprovacao                          ³
			//³ Para: Elaboracao, Vigente, Cancelado   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(CN9->CN9_SITUAC) == DEF_SAPRO
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SELAB})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SVIGE})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SCANC})][1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ De: Vigente                            ³
			//³ Para: Sol. Finalizacao, Cancelado      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(CN9->CN9_SITUAC) == DEF_SVIGE
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SSPAR})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SCANC})][1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ De: Sol Finalizacao                    ³
			//³ Para: Finalizado, Cancelado            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Case AllTrim(CN9->CN9_SITUAC) == DEF_SSPAR
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SFINA})][1])
			aAdd(aSitTx, aSituac[aScan(aSituac,{|x| AllTrim(x[2]) == DEF_SCANC})][1])
	EndCase
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From 165,115 TO 290,430 PIXEL
	
	@ 7,10 Say "Contrato" Of oDlg PIXEL
	@ 5,50 MsGet oGet01 Var cContra Picture PesqPict("CN9","CN9_NUMERO") When .F. PIXEL  Size 50,5 Of oDlg
	
	@ 7,102 Say "Revisão" Of oDlg PIXEL
	@ 5,125 MsGet oGet02 Var cRevisa Picture PesqPict("CN9","CN9_REVISA") When .F. PIXEL  Size 10,5 Of oDlg
	
	@ 22,10 Say "Situacao Atual" Of oDlg PIXEL
	@ 20,50 MsGet oGet03 Var cSitAtu When .F. Of oDlg PIXEL
	
	@ 37,10 Say "Nova Situacao" Of oDlg PIXEL
	@ 35,50 MsComboBox oSituCb ITEMS aSitTx When (len(aSitTx) > 0) SIZE 60,5 OF oDlg PIXEL
	                                                
	DEFINE SBUTTON FROM 50, 93 TYPE 1 When (len(aSitTx) > 0) ACTION (if(!Empty(oSituCb),(nopca:=1,oDlg:End()),Aviso("CNTA100",OemtoAnsi("STR0040"),{"Ok"}))) ENABLE OF oDlg
	DEFINE SBUTTON FROM 50, 123 TYPE 2 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpca == 1 .And. Aviso("CNTA100",OemtoAnsi("Confirma a mudanca de situacao do contrato?"),{"Sim","Nao"}) == 1 //.And. b001Doc(nReg,{oSituCb},.T.)
   
	   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Rotina de alteracao da situacao do contrato³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//If b001SitCh(CN9->CN9_NUMERO,CN9->CN9_REVISA,oSituCb)
		//	If (lSituAll .Or. oSituCb == DEF_SPARA .Or. oSituCb == DEF_SSPAR .Or. oSituCb == DEF_SFINA) .And. Empty(CN9->CN9_CLIENT)
		//		CN220Aval(cAlias,nReg,nOpc,,.F.,oSituCb)
		//	EndIf
		//EndIf

	    RecLock("CN9",.F.) 
		CN9->CN9_SITUAC:=oSituCb
		MSUnlock()
		
		
	EndIf
//EndIf 

Return  

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    ³b001FilCont³ Autor ³ Davi Jesus de Oliveira                   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡ao ³ Filtra consulta padrao CN9001 apenas com contratos vigentes  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ b001FilCont()                                                ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³                                                              ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ CNTA100                                                      ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001FilCont()

Return "@#CN9_SITUAC == '"+DEF_SVIGE+"'@#"//(AllTrim(CN9_SITUAC) == DEF_SVIGE)        


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Funcao    ³b001Conh ³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡…o ³Chamada da visualizacao do banco de conhecimento            ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³b001Conh()                                                 ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³Nenhum                                                      ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Retorno   ³.T.                                                         ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³          ³                                                            ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001Conh()

Local aRotBack := AClone( aRotina )
Local nBack    := 0

If Type( "N" ) == "N" 
	nBack := N	
EndIf 

Private aRotina := {}

Aadd(aRotina,{"Conhecimento","MsDocument", 0 , 2})

MsDocument( "CN9", CN9->( Recno() ), 1 )

aRotina := AClone( aRotBack )

If !Empty( nBack )
	N := nBack
EndIf 	

Return( .t. )


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Funcao    ³b001Track³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡…o ³ Faz o tratamento da chamada do System Tracker              ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Retorno   ³ .T.                                                        ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001Track()

Local aEnt     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percorre o acols                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd( aEnt, { "CN9", M->CN9_NUMERO + M->CN9_REVISA } )

MaTrkShow( aEnt )

Return( .T. )

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    ³b001IncDoc³ Autor ³ Davi Jesus de Oliveira                   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡ao ³ Visualiza o documento ou o banco de conhecimento do item    ³±±
//±±³          ³ selecionado na tree                                         ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ b001IncDoc(oExp01,aExp02,cExp03,lExp04)                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ oExp01 - Objeto dbTree                                      ³±±
//±±³          ³ aExp02 - Array com as informacoes dos documentos            ³±±
//±±³          ³ cExp03 - Codigo do contrato                                 ³±±
//±±³          ³ lExp04 - Valida banco de conhecimento                       ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001IncDoc(oTree,aDocs,cContra,lBcVld)
Local nPos   := 0
Local cCargo := oTree:GetCargo()
Local aArea  := GetArea()
Local nPosN  := 0
Local cCod   := ""
Local lValid :=.F.      
Local cRsrc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o item selecionado representa um grupo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "A" $ cCargo
	nPos := val(SubStr(cCargo,2,len(cCargo)))        
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama rotina de inclusao                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If CN170Manut("SF1",,3,,cContra,aDocs[nPos,1],@cCod)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleciona registro incluso                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SF1")		
		dbSetOrder(1)
		dbSeek(xFilial("SF1")+cCod)
		
		npos := aScan(aDocs,{|x| x[1] == SF1->F1_CONTRA})

		If nPos > 0 .And. SF1->F1_CONTRA == cContra
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o item se encontra vazio               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(aDocs[nPos,3])
				nPosN := nPos
				cCargo := "V"+AllTrim(str(nPos))
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Incrementa contadores dos documentos               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aEval(aDocs,{|x| If(x[1] == aDocs[nPos,1],(If(lValid,x[8]++,),x[9]++),)})
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Seleciona resource de acordo com a validacao       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			cRsrc := If(lValid,"LBTIK","LBNO")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona documento no array                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aDocs,{SF1->F1_CONTRA,aDocs[nPos,1],aDocs[nPos,2],SF1->F1_FORNECE,SF1->F1_EST,SF1->F1_VALMERC,SF1->F1_VALBRUT,SF1->F1_TIPO,SF1->F1_ESPECIE})
			
			oTree:BeginUpdate()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o grupo ja possui docs                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If oTree:TreeSeek("V"+AllTrim(str(nPos)))
				oTree:DelItem()
			EndIf
			oTree:TreeSeek("A"+AllTrim(str(nPos)))
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Altera resource da arvore qd o doc estiver valido  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lValid
				oTree:ChangeBmp("LBTIK","LBTIK")
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona item na dbtree                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oTree:AddItem(SF1->F1_DOC+"-"+SF1->F1_SERIE,alltrim(str(len(aDocs))),cRsrc,cRsrc,,,2)
			oTree:EndUpdate()	
			oTree:Refresh()
		EndIf
	EndIf
Else
	Aviso("CNTA100",OemtoAnsi("STR0081"),{"OK"})
EndIf

RestArea(aArea)
Return


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001VisDoc³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Visualiza o documento ou o banco de conhecimento do item    ³±±
// ±±³          ³ selecionado na tree                                         ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001VisDoc(oExp01,aExp02,lExp03)                            ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ oExp01 - Objeto dbTree                                      ³±±
// ±±³          ³ aExp02 - Array com as informacoes dos documentos            ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001VisDoc(oTree,aDocs,lVisBC)
Local nPos := 0
Local cCargo := oTree:GetCargo()
Local aArea := GetArea()

If "A" $ cCargo .OR. "V" $ cCargo
	nPos := val(SubStr(cCargo,2,len(cCargo)))
Else
	nPos := val(cCargo)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe documento para o grupo          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPos > 0 .And. !Empty(aDocs[nPos,3])
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial("SF1")+aDocs[npos,3])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chama banco de conhecimento ou visualizacao do doc ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lVisBC
			CN170Manut("SF1",SF1->(RECNO()),2)
		Else
			CN170Conh()
		EndIf
	EndIf
EndIf

RestArea(aArea)
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    ³b001Doc  ³ Autor ³ Davi Jesus de Oliveira                   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡ao ³ Rotina de validacao dos documentos, executada na alteracao ³±±
//±±³          ³ de situacao do contrato                                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ CNTA100Doc(nExp01,cExp02)                                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ nExp01 - Contrato selecionado                              ³±±
//±±³          ³ aExp02 - Situacoes para qual o contrato sera alterado      ³±±
//±±³          ³ lExp03 - Valida situacoes inferiores                       ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001Doc(nReg,aSituac,lAll)
Local oDlDoc
Local oTree       //Objeto dbtree
Local cCod        //Codigo do tipo de documento
Local lFirst      //Identifica varredura dos tipos de documento
Local cRsrc       //Resource usado
Local nTotTree    //Total de docs para cada tipo de documento
Local nTotDVld    //Total de docs validos para cada tipo de documento
Local cDescLib := ""     //Situacao de todos os documentos
Local cDescTpc := ""     //Tipo do Contrato
Local cCadastro:= "Check-List de Documentos"
Local aCtrs  := Array(11)//Array com os controles de tela
Local lBsCnh := (GetNewPar( "MV_CNDOCBC", "S" ) == "S")//Verifica se a validacao leva em consideracao o banco de conhec.
Local aSits  := RetSx3Box( Posicione("SX3", 2, "CN9_SITUAC", "X3CBox()" ),,, 1 )
Local cDescSt:= ""
Local aIfDoc := {}//Array com as informacoes de exibicao
Local cQuery := ""
Local aDocs  := {}
Local cAlias := GetNextAlias()
Local lBcoAc := CN240VldUsr(CN9->CN9_NUMERO,DEF_TRABCO,.F.)
Local nx                                              
Local nPos
Local cCargo
Local lLiber:= .T.
Local lContinua := .T.
Local nTotBc:=0
Local cSituac := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Controles visuais                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea     := GetArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fixa dimensao da dialog                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSize     := MsAdvSize( .F. )//{0,0,300,200,690,422,17}//MsAdvSize( .F. )
Local aObjects  := {}
Local aObjects2 := {}
Local aUsButtons:= {}
Local aPosObj1  := {}
Local aPosObj2  := {}
Local oPanel,oGroup1,oGroup2
Local lInc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta estrutura das situacoes para pesquisa ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If len(aSituac) > 1
	For nx:=1 to len(aSituac)
		cSituac+="'"+aSituac[nx]+"',"
		cDescSt+= AllTrim( aSits[Ascan( aSits, { |aBox| substr(aBox[1],1,At("=",aBox[1])-1) = AllTrim(aSituac[nx])} )][3] )+", "
	Next
	cSituac := SubStr(cSituac,1,len(cSituac)-1)
Else
	cDescSt:= AllTrim( aSits[Ascan( aSits, { |aBox| substr(aBox[1],1,At("=",aBox[1])-1) = AllTrim(aSituac[1])} )][3] )	
EndIf

dbSelectArea("AC9")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura do aIfDoc                                   ³
//³ aIfDoc[1] - Codigo do tipo de documento               ³
//³ aIfDoc[2] - Descricao do tipo de documento            ³
//³ aIfDoc[3] - Codigo do Documento                       ³
//³ aIfDoc[4] - Descricao do Documento                    ³
//³ aIfDoc[5] - Data de emissao do documento              ³
//³ aIfDoc[6] - Data de validacao do documento            ³
//³ aIfDoc[7] - Obs do documento                          ³
//³ aIfDoc[8] - Total de documentos do tipo de documento  ³
//³ aIfDoc[9] - Total de documentos validos do tipo de doc³
//³ aIfDoc[10]- Total de registros no banco de conhecim.  ³
//³ aIfDoc[11]- Situacao do documento                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aIfDoc := {"","","","",CTOD("  /  /  "),CTOD("  /  /  "),"",0,0,0,""}

dbSelectArea("CN9")
dbGoTo(nReg)

cDescTpc := Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_DESCRI")

dbSelectArea("SF1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna documentos requisitados pela nova situacao ³
//³ junto com os documentos ja cadastrados             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT SF1.* FROM "+ RetSQLName("SF1") +" SF1 WHERE "
cQuery += "SF1.F1_FILIAL = '"+xFilial("SF1")+"' AND "
cQuery += "SF1.F1_CONTRA = '"+ CN9->CN9_NUMERO +"' AND "
cQuery += "SF1.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY 2"
	
cQuery := ChangeQuery(cQuery)	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

TCSetField(cAlias,"F1_EMISSAO","D",08,0)
TCSetField(cAlias,"F1_DTDIGIT","D",08,0)

lContinua := !((cAlias)->(Eof()))

If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena documentos no array aDocs                     ³
	//³ Estrutura do aDocs                                     ³
	//³ aDocs[x,1] - Codigo do tipo de documento               ³
	//³ aDocs[x,2] - Descricao do tipo de documento            ³
	//³ aDocs[x,3] - Codigo do Documento                       ³
	//³ aDocs[x,4] - Descricao do Documento                    ³
	//³ aDocs[x,5] - Data de emissao do documento              ³
	//³ aDocs[x,6] - Data de validacao do documento            ³
	//³ aDocs[x,7] - Obs do documento                          ³
	//³ aDocs[x,8] - Total de documentos validos do tipo de doc³
	//³ aDocs[x,9] - Total de documentos do tipo de documento  ³
	//³ aDocs[x,10]- Total de registros no banco de conhecim.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !(cAlias)->(Eof())
		nTotBc:=0
				
		aAdd(aDocs,{(cAlias)->F1_EMISSAO,(cAlias)->F1_DOC,(cAlias)->F1_SERIE,(cAlias)->F1_FORNECE,(cAlias)->F1_LOJA,(cAlias)->F1_DTDIGIT,(cAlias)->F1_TON,0,0,nTotBc})
		
		(cAlias)->(dbSkip())
	EndDo
	
	(cAlias)->(dbCloseArea()) 

	dbSelectArea("CN9")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula posicao dos objetos na tela                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjects := {}
	AAdd( aObjects, { 230, 030, .T., .F., .T. } )//Painel superior
	AAdd( aObjects, { 120, 144, .T., .T., .F. } )//dbTree
	AAdd( aObjects, { 120, 20, .T., .F., .F. } )//Botoes
	
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj1 := MsObjSize( aInfo, aObjects, .T., .F. )
	
	AAdd( aObjects2, { 120, 144, .T., .T., .F. } )//Group: Tipo de Documento
	AAdd( aObjects2, { 170, 144, .F., .T., .F. } )//Group: Informacoes do documento
	
	aInfo    := { aPosObj1[2,2],aPosObj1[2,1], aPosObj1[2,4], aPosObj1[2,3], 3, 3 }
	aPosObj2 := MsObjSize( aInfo, aObjects2, .F., .T. )
	
	DEFINE MSDIALOG oDlDoc TITLE cCadastro From aSize[7],0 TO aSize[6],aSize[5] PIXEL
	
	@ aPosObj1[1,1], aPosObj1[1,2] MSPANEL oPanel PROMPT "" SIZE aPosObj1[1,3],aPosObj1[1,4] OF oDlDoc
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Situacao do contrato                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 001,000 Say RetTitle("CN9_SITUAC") Of oPanel PIXEL
	@ 000,024 MsGet oGetSit Var cDescSt When .F. PIXEL  Size 50,5 Of oPanel
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipo do contrato                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 001,082 Say RetTitle("CN9_TPCTO") Of oPanel PIXEL
	@ 000,122 MsGet oGetTCto Var cDescTpc When .F. PIXEL  Size 100,5 Of oPanel
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Situacao geral dos documentos                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 013,000 Say "Situação Geral" Of oPanel PIXEL
	@ 012,47 MsGet oGetSLib Var cDescLib When .F. PIXEL  Size 100,5 Of oPanel
	                    
	@ aPosObj1[2,1]-008,aPosObj1[2,2] Say "Documentos Requisitados" Of oDlDoc PIXEL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DBtree - Estrutura                                 ³
	//³ ÀÄNivel 1 - Tipos de Documentos                    ³
	//³ ÀÄÄÄNivel 2 - Documentos cadastrados               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	DEFINE DBTREE oTree ON CHANGE {b001AlDoc(@oTree,aDocs,aIfDoc,lBsCnh),aEval(aCtrs,{|x| If (x!=Nil,x:Refresh(),)})} FROM aPosObj2[1,1],aPosObj2[1,2] TO aPosObj2[1,3],aPosObj2[1,4] OF oDlDoc CARGO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Menu de visualizacao do documento                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MENU oMenuTree POPUP
		MENUITEM OemToAnsi("Visualizar") Action b001VisDoc(oTree,aDocs,.F.)
		MENUITEM OemToAnsi("STR0080") Action (b001IncDoc(oTree,aDocs,CN9->CN9_NUMERO,lBsCnh),If(aScan(aDocs,{|x| x[8] == 0})==0,(lLiber:=.T.,cDescLib:="Incluir Documento",oGetSLib:Refresh()),))//If((oTree:GetCargo() $ "A"),b001IncDoc(oTree,aDocs,.F.,CN9->CN9_NUMERO),Aviso("CNTA100",OemtoAnsi(STR0081),{"OK"}))//
		If lBcoAc//Quando o usuario possui acesso ao banco de conhecimento
			MENUITEM OemToAnsi("Banco de Conhecimento") ACTION b001VisDoc(oTree,aDocs,.T.)
		EndIf
	ENDMENU
	
	oTree:bRClicked   := { |oObject,nx,ny| oMenuTree:Activate( nX-80, nY-200, oObject ) }
	
	lFirst := .T.     
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Arvore principal                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	DBADDTREE oTree PROMPT cDescTpc OPEN OPENED CARGO "V0000"
	
	for nx:=1 to len(aDocs)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Primeiro registro do tipo de documento             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFirst
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o tipo de documento possui algum       ³
			//³ documento valido                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aScan(aDocs,{|x| x[1] = aDocs[nX,1] .And. x[5] <= dDataBase .And. x[6] >= dDataBase .And. If(lBsCnh,x[10]>0,.T.)}) > 0
				cRsrc := "LBTIK"
			Else
				cRsrc := "LBNO"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta arvore do tipo de documento com a identificacao³
			//³ "A" no cargo                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCargo := "A"+alltrim(str(nX))
//			DBADDTREE oTree PROMPT aDocs[nX,1]+"-"+aDocs[nX,2] RESOURCE cRsrc CARGO cCargo
			lFirst := .F.
			cCod :=  aDocs[nX,1]
			nTotTree:=0
			nTotDVld:=0
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera item do documento                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		If !Empty(aDocs[nx,5])
			If(aDocs[nx,5] <= dDataBase .And. aDocs[nx,6] >= dDataBase .And. If(lBsCnh,aDocs[nx,10]>0,.T.))
				nTotDVlD++
				cRsrc := "LBTIK"
			Else
				cRsrc := "LBNO"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Identifica cargo com a posicao do array aDocs      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			cCargo := alltrim(str(nX))
//			DBADDITEM oTree PROMPT aDocs[nx,3]+"-"+aDocs[nx,4] RESOURCE cRsrc CARGO cCargo
			nTotTree++
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se e o ultimo elemento do grupo           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If nx == len(aDocs) .Or. aDocs[nX+1,1] != cCod
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza campos totalizadores do grupo             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			aDocs := aEval(aDocs,{|x| If(x[1] == aDocs[nX,1],(x[8]:=nTotDVlD,x[9]:=nTotTree),)})
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gera item quando o grupo nao possuir documentos    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nTotTree==0
				cCargo := "V"+alltrim(str(nX))
//				DBADDITEM oTree PROMPT "Documento não fornecido" CARGO cCargo
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o tipo de documento foi liberado       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lLiber
				lLiber := (nTotTree > 0 .And. nTotDVlD>0)
			EndIf
			nTotTree:=0
//			DBENDTREE oTree
			lFirst := .T.
		EndIf
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera elemento quando nao houver estrutura          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If len(aDocs) == 0
//		DBADDITEM oTree PROMPT "Vazio" CARGO "V0000"
	EndIf
	
//	DBENDTREE oTree
	
	cDescLib := If(lLiber,"Docs Liberados","Docs Pendentes")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Componentes visuais de identificacao do documento  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ aPosObj2[2,1],aPosObj2[2,2] GROUP oGroup1 To aPosObj2[2,3],aPosObj2[2,4] Label OemToAnsi("Tipo do Documento" ) Of oDlDoc PIXEL
	
	@ aPosObj2[2,1]+008,aPosObj2[2,2]+005 Say oCdTDoc Var RetTitle("CN5_CODIGO") Size 50,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+008,aPosObj2[2,2]+060 MsGet aCtrs[1] Var aIfDoc[1] Picture PesqPict("CN5","CN5_CODIGO") When .F. Size 60,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+019,aPosObj2[2,2]+005 Say oNmTDoc Var RetTitle("CN5_DESCRI") Size 50,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+019,aPosObj2[2,2]+060 MsGet aCtrs[2] Var aIfDoc[2] Picture PesqPict("CN5","CN5_DESCRI") When .F. Size 60,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+032,aPosObj2[2,2]+005 Say aCtrs[9] Var OemToAnsi("Total de Documentos: ")+AllTrim(str(aIfDoc[9])) Size 100,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+032,aPosObj2[2,2]+075 Say aCtrs[10] Var OemToAnsi("Documentos Válidos: ")+AllTrim(str(aIfDoc[8])) Size __DlgWidth(oDlDoc)-42,8 Of oGroup1 PIXEL
	
	@ aPosObj2[2,1]+047,aPosObj2[2,2]+005 Say OemToAnsi("Detalhes do Documento") Size 100,8 Of oGroup1 PIXEL
//	@ aPosObj2[2,1]+057,aPosObj2[2,2]+005 Say oCdDoc Var RetTitle("CNK_CODIGO") Size 50,8 Of oGroup1 PIXEL
//	@ aPosObj2[2,1]+057,aPosObj2[2,2]+060 MsGet aCtrs[4] Var aIfDoc[3] Picture PesqPict("CNK","CNK_CODIGO") When .F. Size 60,5 Of oGroup1 PIXEL
//	@ aPosObj2[2,1]+068,aPosObj2[2,2]+005 Say oNmDoc Var RetTitle("CNK_DESCRI") Size 50,8 Of oGroup1 PIXEL
//	@ aPosObj2[2,1]+068,aPosObj2[2,2]+060 MsGet aCtrs[3] Var aIfDoc[4] Picture PesqPict("CNK","CNK_DESCRI") When .F. Size 60,5 Of oGroup1 PIXEL
//	@ aPosObj2[2,1]+079,aPosObj2[2,2]+005 Say oDeDoc Var RetTitle("CNK_DTEMIS") Size 50,8 Of oGroup1 PIXEL
//	@ aPosObj2[2,1]+079,aPosObj2[2,2]+060 MsGet aCtrs[5] Var aIfDoc[5] Picture PesqPict("CNK","CNK_DTEMIS") When .F. Size 60,5 Of oGroup1 PIXEL
//	@ aPosObj2[2,1]+090,aPosObj2[2,2]+005 Say oDvDoc Var RetTitle("CNK_DTVALI") Size 50,8 Of oGroup1 PIXEL
//	@ aPosObj2[2,1]+090,aPosObj2[2,2]+060 MsGet aCtrs[6] Var aIfDoc[6] Picture PesqPict("CNK","CNK_DTVALI") When .F. Size 60,5 Of oGroup1 PIXEL
//	@ aPosObj2[2,1]+101,aPosObj2[2,2]+005 Say oObDoc Var RetTitle("CNK_OBS") Size 50,8 Of oGroup1 PIXEL
//	@ aPosObj2[2,1]+101,aPosObj2[2,2]+060 MsGet aCtrs[7] Var aIfDoc[7] Picture PesqPict("CNK","CNK_OBS") When .F. Size 100,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+112,aPosObj2[2,2]+005 Say oStDoc Var OemToAnsi("Status") Size 50,8 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+112,aPosObj2[2,2]+060 MsGet aCtrs[8] Var aIfDoc[11] When .F. Size 100,5 Of oGroup1 PIXEL
	@ aPosObj2[2,1]+125,aPosObj2[2,2]+005 Say aCtrs[11] Var OemToAnsi("Base de Conhecimento: ")+AllTrim(str(aIfDoc[10]))+OemToAnsi(" registro(s)") Size __DlgWidth(oDlDoc)-42,8 Of oGroup1 PIXEL
	
	DEFINE SBUTTON FROM aPosObj1[3,1], aPosObj1[3,4]-55 TYPE 1 ACTION (If((nPos:=aScan(aDocs,{|x| x[8]==0})==0),(oDlDoc:End()),(Help(" ",1,"CNTA100DOC"),oDlDoc:End()))) ENABLE OF oDlDoc
	DEFINE SBUTTON FROM aPosObj1[3,1], aPosObj1[3,4]-25 TYPE 2 ACTION (lLiber:=.F.,oDlDoc:End()) ENABLE OF oDlDoc
	          
	ACTIVATE MSDIALOG oDlDoc CENTERED

Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Libera validacao quando nao houver documentos relacionados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lLiber:=.T.
	(cAlias)->(dbCloseArea()) 
EndIf

RestArea(aArea)
Return lLiber

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001AlDoc³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Atualiza valores de exibicao do elemento selecionado       ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001AlDoc(oExp01,aExp02,aExp03,lExp04)                    ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ oExp01 - DbTree                                            ³±±
// ±±³          ³ aExp02 - Array com as informacoes dos documentos           ³±±
// ±±³          ³ aExp03 - Array com os valores exibidos na dialog           ³±±
// ±±³          ³ aExp04 - Valida documento com base no banco de conhecimento³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001AlDoc(oTree,aDocs,aIfDoc,lBsCnh)
Local nPos := 0
Local cCargo := oTree:GetCargo()                       

aIfDoc := {}//Limpa array de exibicao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica posicao no array aDocs                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "A" $ cCargo .Or. "V" $ cCargo
	nPos := val(SubStr(cCargo,2,len(cCargo)))
Else
	nPos := val(cCargo)
EndIf
If nPos == 0
	aIfDoc := {"","","","",CTOD("  /  /  "),CTOD("  /  /  "),"",0,0,0,""}
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera copia do item do aDocs para o aIfDoc          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aIfDoc:=aClone(aDocs[nPos])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica situacao do documento quando o mesmo existir³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aDocs[nPos,3])
		If aDocs[nPos,5] <= dDataBase .And. aDocs[nPos,6] >= dDataBase
			If !lBsCnh
				aAdd(aIfDoc,"Válido")
			elseIf aDocs[nPos,10]==0
				aAdd(aIfDoc,"Não possui banco de conhecimento")
			else
				aAdd(aIfDoc,"Válido")
			EndIf
		Else
			aAdd(aIfDoc,"Vencido")
		EndIf
	Else
		aAdd(aIfDoc,"")//"Vencido"
	EndIf
EndIf
Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001IncArr³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Realiza a inclusao de planilhas no array aPlani, durante    ³±±
// ±±³          ³ a inclusao do contrato                                      ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001IncArr(nExp01,aExp02,aExp03)                           ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ nExp01 - Opcao atual                                        ³±±
// ±±³          ³ aExp02 - Array com as informacoes das planilhas             ³±±
// ±±³          ³ aExp03 - Array com os itens(acols) das planilhas            ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001IncArr(npc,aPlani,aPlIt,aHeaderCNB)
Local nTotPlan := len(aPlani)
Local ny
Local cPlani := strzero(1,TamSx3("CNA_NUMERO")[1])
Local nPosForn   
Local nPosLoja
Local nPosTotP := aScan(aHeader3,{|x| AllTrim(x[2]) == "CNA_VLTOT"})
Local dTermino
Local cCadBack := cCadastro
Local lIncBack := INCLUI
Local lAltBack := ALTERA
If cEspCtr =="1"
	nPosForn := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_CODIGO"})
	nPosLoja := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_LOJA"})
Endif	


cCadastro := "Cadastro de Planilhas"
INCLUI := .T.
ALTERA := .F.  
PRIVATE aForn

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera array de fornecedores usado na validacao da planilha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cEspCtr =="1"
   aForn := aEval(oGetDad1:aCols,{|x| {x[nPosForn],x[nPosLoja]}})
Endif   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula data de termino do contrato  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(M->CN9_UNVIGE)
	dTermino := ddatabase+300
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula numero sequencial da planilha com base nas planilhas existentes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If len(aPlani) > 0
	For ny:=1 to len(aPlani)
		If aPlani[ny,CNA->(FieldPos("CNA_NUMERO"))] >= cPlani
			cPlani := Soma1(aPlani[ny,CNA->(FieldPos("CNA_NUMERO"))])
		EndIf
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa rotina de manutencao das planilhas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CN200Manut("CNA",5000,npc,,.F.,.F.,aPlani,aPlIt,M->CN9_NUMERO,cPlani,M->CN9_DTINIC,dTermino,aHeaderCNB)
	If nTotPlan != len(aPlani)
		If len(aCols3)==0 .Or. len(aCols3)>1 .Or. !Empty(aCols3[1,1])
			aAdd(aCols3,Array(len(aHeader3)+1))
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza folder das planilhas com base na inclusao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For ny:=1 to len(aHeader3)
			If CNA->(FieldPos(aHeader3[ny,2])) > 0
				aCols3[len(aCols3),ny] := aPlani[len(aPlani),CNA->(FieldPos(aHeader3[ny,2]))]
			EndIf
		Next
		aCols3[len(aCols3),len(aHeader3)+1] := .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza totais do contrato         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->CN9_VLATU := M->CN9_SALDO := M->CN9_VLINI := M->CN9_VLINI + aCols3[len(aCols3),nPosTotP]
		
		oGetDad3:aCols := aCols3
		oGetDad3:oBrowse:Refresh()
		oGetDad3:Refresh()
	EndIf
EndIf

cCadastro := cCadBack
INCLUI := lIncBack
ALTERA := lAltBack

Return 

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001IncPla³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Realiza a inclusao de planilhas durante a edicao do contrato³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001IncPla()                                               ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³                                                             ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001IncPla()
Local nTotPlan := len(oGetDad3:aCols)
Local ny
Local cPlani := strzero(1,TamSx3("CNA_NUMERO")[1])
Local nPosForn
Local nPosLoja
Local nPosTotP := aScan(aHeader3,{|x| AllTrim(x[2]) == "CNA_VLTOT"})
Local nPosNumP := aScan(aHeader3,{|x| AllTrim(x[2]) == "CNA_NUMERO"})
Local dTermino
Local cCadBack := cCadastro
Local lIncBack := INCLUI
Local lAltBack := ALTERA
PRIVATE aForn

If cEspCtr =="1"
	nPosForn := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_CODIGO"})
	nPosLoja := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_LOJA"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera array de fornecedores usado na validacao da planilha ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   aForn := aEval(oGetDad1:aCols,{|x| {x[nPosForn],x[nPosLoja]}})
Endif	

cCadastro := "Cadastro de Planilhas"
INCLUI := .T.
ALTERA := .F.

aCols3 := oGetDad3:aCols

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula data de termino do contrato  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(M->CN9_UNVIGE) .And. !Empty(M->CN9_VIGE)
	dTermino := ddatabase+300
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica total de planilhas          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTotPlan == 1 .And. Empty(aCols3[1,nPosNumP])
	nTotPlan := 0
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula numero sequencial da planilha com base nas planilhas existentes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTotPlan > 0
	For ny:=1 to len(aCols3)
		If aCols3[ny,nPosNumP] >= cPlani
			cPlani := Soma1(aCols3[ny,nPosNumP])
		EndIf
	Next
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa rotina de manutencao das planilhas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If CN200Manut("CNA",5000,3,,.F.,.F.,,,M->CN9_NUMERO,@cPlani,M->CN9_DTINIC,dTermino)
	If len(aCols3) == 1 .And. Empty(aCols3[1,1])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui linha da planilha em branco              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aDel(aCols3,1)
		aSize(aCols3,0)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza item da planilha no folder             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CNA")
	dbSetOrder(1)
	If dbSeek(xFilial("CNA")+M->CN9_NUMERO+M->CN9_REVISA+cPlani)
		aAdd(aCols3,Array(len(aHeader3)+1))
		For nY	:= 1 To Len(aHeader3)
			cCampo := Alltrim(aHeader3[nY,2])
			If IsHeadRec(cCampo)
				aCols3[len(aCols3),ny] := CNA->(Recno())
			ElseIf IsHeadAlias(cCampo)
				aCols3[len(aCols3),ny] := "CNA"			
			ElseIf ( aHeader3[nY][10] != "V" )
				aCols3[len(aCols3),nY] := FieldGet(FieldPos(aHeader3[nY][2]))
			Else
				aCols3[len(aCols3),nY] := CriaVar(aHeader3[nY][2])
			EndIf
	 	Next nY
	  	aCols3[len(aCols3),Len(aHeader3)+1] := .F.
	EndIf
	oGetDad3:aCols := aCols3
	oGetDad3:oBrowse:Refresh()
	oGetDad3:Refresh()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza valores totais do contrato             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CN9")
	dbSetOrder(1)
	If dbSeek(xFilial("CN9")+M->CN9_NUMERO+M->CN9_REVISA)
		M->CN9_VLATU := CN9->CN9_VLATU
		M->CN9_SALDO := CN9->CN9_SALDO
		M->CN9_VLINI := CN9->CN9_VLINI
	EndIf
EndIf

cCadastro := cCadBack
INCLUI := lIncBack
ALTERA := lAltBack

Return 

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001AltArr³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Realiza a alteracao de planilhas no array aPlani, durante   ³±±
// ±±³          ³ a inclusao do contrato                                      ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001AltArr(nExp01,aExp02,aExp03)                           ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ nExp01 - Opcao atual                                        ³±±
// ±±³          ³ aExp02 - Array com as informacoes das planilhas             ³±±
// ±±³          ³ aExp03 - Array com os itens(acols) das planilhas            ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001AltArr(npc,aPlani,aPlIt,aHeaderCNB)
Local nTotPlan := len(aPlani)
Local ny
Local cPlani := strzero(1,TamSx3("CNA_NUMERO")[1])
Local nPosForn
Local nPosLoja
Local nPosPlan := aScan(aHeader3,{|x| AllTrim(x[2]) == "CNA_NUMERO"})
Local nPosTotP := aScan(aHeader3,{|x| AllTrim(x[2]) == "CNA_VLTOT"})
Local nPlan
Local cCadBack := cCadastro
Local lIncBack := INCLUI
Local lAltBack := ALTERA

If cEspCtr =="1"
	nPosForn := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_CODIGO"})
	nPosLoja := aScan(aheader1,{|x| AllTrim(x[2]) == "CNC_LOJA"})
Endif	

cCadastro := "Cadastro de Planilhas"
INCLUI := .F.
ALTERA := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera array de fornecedores usado na validacao da planilha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aForn
If cEspCtr =="1"
   aForn := aEval(oGetDad1:aCols,{|x| {x[nPosForn],x[nPosLoja]}})
Endif   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identifica planilha selecionada                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPlani := oGetDad3:aCols[oGetDad3:nAt,nPosPlan]
nPlan  := aScan(aPlani,{|x| x[CNA->(FieldPos("CNA_NUMERO"))] == cPlani})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa rotina de manutencao de planilhas       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if CN200Manut("CNA",5000,npc,,.F.,.F.,aPlani,aPlIt,M->CN9_NUMERO,cPlani,,,aHeaderCNB)

	If npc != 5//Alteracao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui valor antigo                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->CN9_VLATU := M->CN9_SALDO := M->CN9_VLINI := M->CN9_VLINI - aCols3[nPlan,nPosTotP]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza folder de planilhas                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For ny:=1 to len(aHeader3)
			If CNA->(FieldPos(aHeader3[ny,2])) > 0
				aCols3[nPlan,ny] := aPlani[nPlan,CNA->(FieldPos(aHeader3[ny,2]))]
			EndIf
		Next
		aCols3[nPlan,len(aHeader3)+1] := .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza totais do contrato                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->CN9_VLATU := M->CN9_SALDO := M->CN9_VLINI := M->CN9_VLINI + aCols3[nPlan,nPosTotP]
	Else//Exclusao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui valor da planilha dos totais do contrato ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->CN9_VLATU := M->CN9_SALDO := M->CN9_VLINI := M->CN9_VLINI - aCols3[nPlan,nPosTotP]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui planilha da folder                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aDel(aCols3,nPlan)
		aSize(aCols3,len(aCols3)-1)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza folder                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDad3:aCols := aCols3
	oGetDad3:oBrowse:Refresh()
	oGetDad3:Refresh()
EndIf

cCadastro := cCadBack
INCLUI := lIncBack
ALTERA := lAltBack

Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001AltPla³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Realiza a alteracao de planilhas durante a edicao do        ³±±
// ±±³          ³ contrato                                                    ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001AltPla(nExp01)                                         ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ nExp01 - Opcao atual                                        ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001AltPla(npc,aHeaderCNB)
Local nPlan
Local cPlan
Local nRecno := 0
Local nCntFor
Local cCampo
Local cCadBack := cCadastro
Local lIncBack := INCLUI
Local lAltBack := ALTERA 
Local nPos     := 0

cCadastro := "Cadastro de Planilhas"
INCLUI := .F.
ALTERA := .T.

aCols3 := oGetDad3:aCols

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identifica planilha selecionada                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPlan := oGetDad3:nAt
cPlan := aCols3[nPlan,aScan(aHeader3,{|x| AllTrim(x[2]) == "CNA_NUMERO"})]

dbSelectArea("CNA")
dbSetOrder(1)
dbSeek(xFilial("CNA")+M->CN9_NUMERO+M->CN9_REVISA+cPlan)

nRecNo := CNA->(RecNo())

If nRecno > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa rotina de manutencao da planilha        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If CN200Manut("CNA",CNA->(RecNo()),npc)
		If npc == 4//Alteracao
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Altera registro selecionado                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbGoto(nRecno)
			For nCntFor	:= 1 To Len(aHeader3)
				cCampo := Alltrim(aHeader3[nCntFor,2])
				If (nPos:=FieldPos(aHeader3[nCntFor][2])) > 0
					aCols3[nPlan,nCntFor] := FieldGet(nPos)
				EndIf
	 		Next nCntFor
	  		aCols3[nPlan,Len(aHeader3)+1] := .F.
		Else//Exclusao
			aDel(aCols3,nPlan)
			aSize(aCols3,len(aCols3)-1)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza folder das planilhas                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oGetDad3:aCols := aCols3
		oGetDad3:oBrowse:Refresh()
		oGetDad3:Refresh()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza campos totais do contrato              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CN9")+M->CN9_NUMERO+M->CN9_REVISA)
			M->CN9_VLATU  := CN9->CN9_VLATU
			M->CN9_SALDO  := CN9->CN9_SALDO
			M->CN9_VLINI  := CN9->CN9_VLINI
		EndIf
	EndIf
EndIf

cCadastro := cCadBack
INCLUI := lIncBack
ALTERA := lAltBack

Return

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001PlGr  ³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Executa gravacao do array de planilhas no banco             ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001PlGr(aExp01,aExp02)                                    ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ aExp01 - Opcao atual                                        ³±±
// ±±³          ³ aExp02 - Opcao atual                                        ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001PlGr(aPlani,aPlIt,aHeaderCNB)
Local nCntFor  := 0
Local nTam     := 0
Local nUsado   := 0
Local nCntFor2 := 0
Local nItem    := 0
Local nTot     := 0   
Local nTotAnt  := 0       
Local nQtAtd   := 0
Local aNoFields:= ""
Local nTotComis:= 0
Local cFilCod
Local cFilSC1  := xFilial("SC1")
Local nPosSC1  := 0
Local nPosItSC := 0
Local nPosQtSol:= 0
Local nPosQuant:= 0
Local nx
                                                                                                                  
nPosSC1  := aScan(aHeaderCNB,{|x| AllTrim(x[2])="CNB_NUMSC"})
nPosItSC := aScan(aHeaderCNB,{|x| AllTrim(x[2])="CNB_ITEMSC"})
nPosQtSol:= aScan(aHeaderCNB,{|x| AllTrim(x[2])="CNB_QTDSOL"})
nPosQuant:= aScan(aHeaderCNB,{|x| AllTrim(x[2])="CNB_QUANT"})
                                                                                                                  
For nx:=1 to len(aPlani)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche campos do cabecalho                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CNA")
	Reclock("CNA",.T.)
	For nCntFor := 1 To FCount()
		If (FieldName(nCntFor)=="CNA_FILIAL")
			CNA->CNA_FILIAL := xFilial()
		Else
			FieldPut(nCntFor,aPlani[nx,nCntFor])
		EndIf
	Next nCntFor
	CNA->CNA_CLIENT := CN9->CN9_CLIENT
	CNA->CNA_LOJACL := CN9->CN9_LOJACL
	MsUnlock()                      
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa lancamento do PCO    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoDetLan("000354","01","CNTA200")
	
	dbSelectArea("CNB")
	nUsado := Len(aHeaderCNB)        
	cFilCod := xFilial("CNB")
	
	nTotComis := 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche campos dos itens                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nCntFor := 1 To Len(aPlIt[nx])
		If ( !aPlIt[nx,nCntFor,nUsado+1] )
			dbSelectArea("CNB")
			Reclock("CNB",.T.)
			For nCntFor2 := 1 To nUsado
				If ( aHeaderCNB[nCntFor2][10] != "V" )
					FieldPut(FieldPos(aHeaderCNB[nCntFor2][2]),aPlIt[nx,nCntFor,nCntFor2])
				EndIf
			Next nCntFor2
			CNB->CNB_FILIAL := cFilCod
			CNB->CNB_NUMERO := CNA->CNA_NUMERO
			CNB->CNB_REVISA := CNA->CNA_REVISA
			CNB->CNB_CONTRA := CNA->CNA_CONTRA
			CNB->CNB_DTCAD  := dDataBase   
			CNB->CNB_SLDMED := CNB->CNB_QUANT
			CNB->CNB_SLDREC := CNB->CNB_QUANT
			nTot += CNB->CNB_VLTOT-CNB->CNB_VLDESC
			MsUnlock()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula total da comissao            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
			If CNB->CNB_FLGCMS = "1"
				nTotComis += CNB->CNB_VLTOT-CNB->CNB_VLDESC
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Executa lancamento PCO      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			PcoDetLan("000354","02","CNTA200")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza solicitacao de compra                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
			If !Empty(CNB->CNB_NUMSC)
				dbSelectArea("SC1")
				If dbSeek(cFilSC1+CNB->CNB_NUMSC+CNB->CNB_ITEMSC)
					nQtAtd := If(CNB->CNB_QUANT > (SC1->C1_QUANT-SC1->C1_QUJE),(SC1->C1_QUANT-SC1->C1_QUJE),CNB->CNB_QUANT)
					RecLock("SC1",.F.)   
					SC1->C1_QUJE+= nQtAtd
					SC1->C1_QUJE:= If(SC1->C1_QUJE>SC1->C1_QUANT,SC1->C1_QUANT,SC1->C1_QUJE)
					SC1->C1_FLAGGCT	:= "1" //Solicitacao bloqueada para SIGAGCT
					MsUnlock()
				EndIf					
			EndIf				
		EndIf
	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza valor da comissao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cEspCtr == "2"
		RecLock("CNA",.F.)
		CNA->CNA_VLCOMS := nTotComis
		MsUnlock()
	EndIf	
Next

Return


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001VldCauc³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Valida o fornecedor informado e calcula o valor retido       ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001VldCauc(cExp01,cExp02,cEpx03,nExp04)                    ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ cExp01 - Codigo do contrato                                  ³±±
// ±±³          ³ cExp02 - Codigo do fornecedor                                ³±±
// ±±³          ³ cExp03 - Codigo da loja                                      ³±±
// ±±³          ³ nExp04 - Valor efetivo - referencia                          ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001VldCauc(cContra,cForn,cLoja,nVlEft,oGetCNT)
Local cQuery    := ""
Local lRet      := .T.
Local aArea     := GetArea()
Local cAlias    := GetNextAlias()
Local nX
Local cNumMed	:= ""

Default cForn := ""
Default cLoja := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida o fornecedor                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cForn)
	lRet := ExistCpo("SA2",cForn+If(Empty(cLoja),"",cLoja))
EndIf

oGetCNT:aCols := {}

If lRet .And. ((!Empty(cForn) .And. !Empty(cLoja)) .OR. !Empty(CN9->CN9_CLIENT))
                                               
	cQuery := "SELECT CNT.*,(CNT.CNT_VLRET-CNT.CNT_VLBX) AS CNT_SALDO FROM "+RetSQLName("CNT")+" CNT WHERE "
	cQuery += "CNT.CNT_FILIAL = '"+xFilial("CNT")+"' AND "
	cQuery += "CNT.CNT_CONTRA = '"+cContra+"' AND "
	If !Empty(cForn)
		cQuery += "CNT.CNT_FORNEC = '"+cForn+"' AND "
	EndIf
	If !Empty(cLoja)
		cQuery += "CNT.CNT_LJFORN = '"+cLoja+"' AND "
	EndIf
	cQuery += "CNT.CNT_VLRET > CNT.CNT_VLBX AND "
	cQuery += "CNT.D_E_L_E_T_ = ' '
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

	aStrucCNT := CNT->(dbStruct())
	For nx:=1 to len(aStrucCNT)
		if (cAlias)->(FieldPos(aStrucCNT[nx,1])) > 0 .And. aStrucCNT[nx,2] <> "C"
			TCSetField( cAlias, aStrucCNT[nx,1], aStrucCNT[nx,2], aStrucCNT[nx,3], aStrucCNT[nx,4] )
		endif
	Next

	TCSetField(cAlias,"CNT_SALDO" ,"N",TamSX3("CNT_VLRET")[1],TamSX3("CNT_VLRET")[2])
	
	If (cAlias)->(Eof())
		lRet := .F.
		If Empty(CN9->CN9_CLIENT)
			Aviso( "Atencao", "O fornecedor selecionado não possui valor retido em caução!", {"OK"})
		Else
			Aviso( "Aviso", "Nao há valor retido para o contrato", {"OK"})
		EndIf
	Else
		While !(cAlias)->(Eof())
	  		aAdd(oGetCNT:aCols,Array(Len(oGetCNT:aHeader)+1))

  			For nx	:= 1 To Len(oGetCNT:aHeader)
		  		cCampo := Alltrim(oGetCNT:aHeader[nx,2])

				If cCampo == "CNT_NUMMED"
					cNumMed := (cAlias)->( FieldGet( (cAlias)->( FieldPos(oGetCNT:aHeader[nx][2]) ) ) )					
				Endif

  				If ( oGetCNT:aHeader[nx][10] != "V" )
					oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := (cAlias)->( FieldGet( (cAlias)->( FieldPos(oGetCNT:aHeader[nx][2]) ) ) )
				Else
					Do Case
						Case oGetCNT:aHeader[nx][2] == FLD_SALDO
							oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := (cAlias)->CNT_SALDO
						Case oGetCNT:aHeader[nx][2] == FLD_BAIXA
				 			oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := 0	
						Case oGetCNT:aHeader[nx][2] == FLD_PLANI
							DbSelectArea("CND")
							DbSetorder(4)
							If DbSeek(xFilial("CND")+cNumMed)
								oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := If(Empty(CND->CND_NUMERO),"------",CND->CND_NUMERO)
							EndIf
						OtherWise
							oGetCNT:aCols[Len(oGetCNT:aCols)][nX] := CriaVar(oGetCNT:aHeader[nx][2])
					EndCase
		 		EndIf
			Next nX
			oGetCNT:aCols[Len(oGetCNT:aCols), Len(oGetCNT:aHeader)+1] := .F.

			(cAlias)->( dbSkip() )
		EndDo
	EndIf
EndIf

oGetCNT:Refresh()

RestArea(aArea)

Return lRet

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001VldCauc³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Gera o titulo a pagar para o valor retido do contrato        ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001VldCauc(cExp01,cExp02,cEpx03,cExp04,cExp05,nExp06,cExp07³±±
// ±±³          ³              ,cExp08,cExp09,cExp10)                          ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ cExp01 - Fornecedor                                          ³±±
// ±±³          ³ cExp02 - Loja do fornecedor                                  ³±±
// ±±³          ³ cExp03 - Codigo do banco                                     ³±±
// ±±³          ³ cExp04 - Agencia                                             ³±±
// ±±³          ³ cExp05 - Conta                                               ³±±
// ±±³          ³ nExp06 - Valor do titulo                                     ³±±
// ±±³          ³ cExp07 - Natureza do titulo                                  ³±±
// ±±³          ³ cExp08 - Prefixo do titulo                                   ³±±
// ±±³          ³ cExp09 - Tipo do titulo                                      ³±±
// ±±³          ³ cExp10 - Numero do titulo - referencia                       ³±±
// ±±³          ³ cExp11 - Tipo da Transacao 1-Retencao,2-Adiantamento         ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001GerSE2(cForn,cLoja,cBco,cAgc,cCta,nVlRet,cRetNat,cRetPrf,cTpTit,cNumTit,cTipo,cParcela)
Local aRotAuto := {}
Local cQuery   := ""
Local cMaxTit  := ""        
Local aArea    := GetArea()
Local cMoeda   := ""
Local aAreaSub
Local nx
Local lRet     := .T.
Local aAfrBck  := {}
Local lExcPms  := IntePMS() .And. (GetNewPar( "MV_CNEXPMS", "N" ) == "S")
Local cFilSE2  := xFilial("SE2")

PRIVATE lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona sequencia dos titulos a pagar    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "Select MAX(SE2.E2_NUM) as E2_NUM from "+ RetSQLName("SE2") +" SE2 "
cQuery += "where SE2.E2_FILIAL = '"+xFilial("SE2")+"' AND "
cQuery += "SE2.E2_PREFIXO = '"+ cRetPrf +"' AND "
cQuery += "SE2.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SE2TMP",.F.,.T.)

cNumTit := Soma1(SE2TMP->E2_NUM)

cParcela := CriaVar("E2_PARCELA")
cMoeda   := CN9->CN9_MOEDA

SE2TMP->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe integracao com o PMS    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lExcPms
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Simula chamada do FINA050  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aRatAfr := {}
	Private lF050Auto := .T.
	Private M->E2_VALOR := nVlRet
	Private M->E2_MOEDA := cMoeda
	Private M->E2_EMISSAO := dDataBase
	Private M->E2_MDCONTR := CN9->CN9_NUMERO

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa Dialog para preenchimento do projeto  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAreaSub := GetArea()
	PmsDlgFS(3,cRetPrf,cNumTit,cParcela,cTpTit,cForn,cLoja)
	RestArea(aAreaSub)
	aAfrBck  := aRatAfr
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para validacao do rateio do projeto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CNTVLDPMS")
	lRet := ExecBlock("CNTVLDPMS",.F.,.F.,{nVlRet,"1"})
EndIf

If lRet
	dbSelectArea("SE2")
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica proximo codigo disponivel ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	While dbSeek(cFilSE2+cRetPrf+cNumTit)
		cNumTit += Soma1(cNumTit)
	EndDo

	BEGIN TRANSACTION
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera nota de debito ao fornecedor          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd( aRotAuto, { "E2_NUM"    , cNumTit, NIL } )
	AAdd( aRotAuto, { "E2_PREFIXO", cRetPrf, NIL } )
	AAdd( aRotAuto, { "E2_NATUREZ", cRetNat, NIL } )
	AAdd( aRotAuto, { "E2_PARCELA", cParcela, NIL } )
	AAdd( aRotAuto, { "E2_TIPO"   , cTpTit, NIL } )
	AAdd( aRotAuto, { "E2_FORNECE", cForn, NIL } )
	AAdd( aRotAuto, { "E2_LOJA"   , cLoja, NIL } )
	AAdd( aRotAuto, { "E2_VALOR"  , nVlRet, NIL } )
	AAdd( aRotAuto, { "E2_EMISSAO", dDataBase, NIL } )
	AAdd( aRotAuto, { "E2_VENCTO" , dDataBase, NIL } )
	AAdd( aRotAuto, { "E2_VENCREA", DataValida( dDataBase ), NIL } )
	AADD( aRotAuto, { "E2_VENCORI", DataValida( Ddatabase,.T.),NIL })
	AADD( aRotAuto, { "E2_MOEDA"  , cMoeda, NIL})
	AADD( aRotAuto, { "E2_MDCONTR", CN9->CN9_NUMERO, NIL})
	AADD( aRotAuto, { "E2_MDREVIS", CN9->CN9_REVISA, NIL})
	AADD( aRotAuto, { "E2_ORIGEM" , "CNTA100"      , NIL})
	AAdd( aRotAuto, { "AUTBANCO"  , cBco, NIL } )
	AAdd( aRotAuto, { "AUTAGENCIA", cAgc, NIL } )
	AAdd( aRotAuto, { "AUTCONTA"  , cCta, NIL } ) 
	
	MSExecAuto({|x, y| FINA050(x, y)}, aRotAuto, 3)
	
	If !lMsErroAuto
		aRatAfr := aAfrBck
		If !Empty(aRatAfr)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava informacao de despesa do projeto  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PmsWriteFI(1,"SE2")
			aRatAfr := {}		
		EndIf
	EndIf
	END TRANSACTION

	If lMsErroAuto 	
		MOSTRAERRO()
		lRet := .F.
	EndIf
EndIf

Return( lRet )

// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Fun‡ao    ³b001GerSE1 ³ Autor ³ Davi Jesus de Oliveira                   ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descri‡ao ³ Gera o titulo a receber para o valor retido do contrato      ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ b001GerSE1(cExp01,cExp02,cEpx03,cExp04,cExp05,nExp06,cExp07 ³±±
// ±±³          ³              ,cExp08,cExp09,cExp10)                          ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ cExp01 - Fornecedor                                          ³±±
// ±±³          ³ cExp02 - Loja do fornecedor                                  ³±±
// ±±³          ³ cExp03 - Codigo do banco                                     ³±±
// ±±³          ³ cExp04 - Agencia                                             ³±±
// ±±³          ³ cExp05 - Conta                                               ³±±
// ±±³          ³ nExp06 - Valor do titulo                                     ³±±
// ±±³          ³ cExp07 - Natureza do titulo                                  ³±±
// ±±³          ³ cExp08 - Prefixo do titulo                                   ³±±
// ±±³          ³ cExp09 - Tipo do titulo                                      ³±±
// ±±³          ³ cExp10 - Numero do titulo - referencia                       ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001GrSE1(cBco,cAgc,cCta,nVlRet,cRetNat,cRetPrf,cTpTit,cNumTit,lExbErro,cParcela)
Local aRotAuto := {}
Local cQuery   := ""
Local cMaxTit  := ""
Local aArea    := GetArea()
Local nx
Local aAreaSub
Local cMoeda   := ""
Local lRet     := .T.
Local aAftBck  := {}
Local lExcPms  := IntePMS() .And. (GetNewPar( "MV_CNEXPMS", "N" ) == "S")
Local aVend    := CtaVend(CN9->CN9_NUMERO)
Local cFilSE1  := xFilial("SE1")

Default lExbErro := .T.

PRIVATE lMsErroAuto := .F.

cParcela := CriaVar("E1_PARCELA")
cMoeda   := CN9->CN9_MOEDA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona sequencia dos titulos a pagar    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "Select MAX(SE1.E1_NUM) as E1_NUM from "+ RetSQLName("SE1") +" SE1 "
cQuery += "where SE1.E1_FILIAL = '"+xFilial("SE1")+"' AND "
cQuery += "SE1.E1_PREFIXO = '"+ cRetPrf +"' AND "
cQuery += "SE1.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SE1TMP",.F.,.T.)

cNumTit := Soma1(SE1TMP->E1_NUM)

SE1TMP->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe integracao com o PMS    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lExcPms
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Simula chamada do FINA040  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aRatAft := {}
	Private M->E1_VALOR := nVlRet
	Private M->E1_MOEDA := cMoeda
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa Dialog para preenchimento do projeto  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAreaSub := GetArea()
	PmsDlgRC(3,cRetPrf,cNumTit,cParcela,cTpTit,CN9->CN9_CLIENT,CN9->CN9_LOJACL)
	RestArea(aAreaSub)
	aAftBck  := aRatAft
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para validacao do rateio do projeto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CNTVLDPMS")
	lRet := ExecBlock("CNTVLDPMS",.F.,.F.,{nVlRet,"2"})
EndIf

If lRet
	dbSelectArea("SE1")
	dbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica codigo disponivel        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While dbSeek(cFilSE1+cRetPrf+cNumTit)
		cNumTit += Soma1(cNumTit)
	EndDo

	BEGIN TRANSACTION
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera nota de debito ao Cliente             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd( aRotAuto, { "E1_NUM"    , cNumTit, NIL } )
	AAdd( aRotAuto, { "E1_PREFIXO", cRetPrf, NIL } )
	AAdd( aRotAuto, { "E1_NATUREZ", cRetNat, NIL } )
	AAdd( aRotAuto, { "E1_TIPO"   , cTpTit, NIL } )
	AAdd( aRotAuto, { "E1_CLIENTE", CN9->CN9_CLIENT, NIL } )
	AAdd( aRotAuto, { "E1_LOJA"   , CN9->CN9_LOJACL, NIL } )
	AAdd( aRotAuto, { "E1_VALOR"  , nVlRet, NIL } )
	AAdd( aRotAuto, { "E1_EMISSAO", dDataBase, NIL } )
	AAdd( aRotAuto, { "E1_VENCTO" , dDataBase, NIL } )
	AAdd( aRotAuto, { "E1_VENCREA", DataValida( dDataBase ), NIL } )
	AADD( aRotAuto, { "E1_VENCORI", DataValida( Ddatabase,.T.),NIL })
	AADD( aRotAuto, { "E1_MOEDA"  , CN9->CN9_MOEDA, NIL})
	AADD( aRotAuto, { "E1_MDCONTR", CN9->CN9_NUMERO, NIL})
	AADD( aRotAuto, { "E1_MDREVIS", CN9->CN9_REVISA, NIL})
	AADD( aRotAuto, { "E1_ORIGEM" , "CNTA100"     , NIL})
	AADD( aRotAuto, { "AUTBANCO"  , cBco, NIL } )
	AADD( aRotAuto, { "AUTAGENCIA", cAgc, NIL } )
	AADD( aRotAuto, { "AUTCONTA"  , cCta, NIL } )

	MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3)

	If !lMsErroAuto
		aRatAft := aAftBck
		If !Empty(aRatAft)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava informacao de despesa do projeto  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PmsWriteRC(1,"SE1")
			aRatAft := {}		
		EndIf
	EndIf
	END TRANSACTION

	If lMsErroAuto .And. lExbErro
		MOSTRAERRO()
	EndIf
EndIf

RestArea(aArea)

Return( lRet )


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡ao    ³ b001LdAl  ³ Autor ³ Davi Jesus de Oliveira                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡ao ³ Rotina generica para preenchimento dos folders              ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ b001LdAl(nExp01,cExp02,aExp03,aExp04,cExp05,aExp06,oExp07  ³±±
//±±³          ³           cExp08,aExo09)                                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ nExp01 - Opcao Atual                                        ³±±
//±±³          ³ cExp02 - Alias consultado                                   ³±±
//±±³          ³ aExp03 - aCols                                              ³±±
//±±³          ³ aExp04 - aHeader                                            ³±±
//±±³          ³ cExp05 - Condicao where no formato SQL                      ³±±
//±±³          ³ aExp06 - Ordem da consulta                                  ³±±
//±±³          ³ oExp07 - GetDados                                           ³±±
//±±³          ³ cExp08 - Campos nao exibidos no aheader                     ³±±
//±±³          ³ aExp09 - Query especifica                                   ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function b001LdAl(nOpc,cAlias,aCols,aHeader,cWhere,aOrder,oGetDad,aNoFields,cQuery)
Local nX        := 0
Local lExec     := (cQuery == NIL)
Local cOrder    := ""

Default aOrder := {}
Default cWhere := ""

acols := {}

dbSelectArea(cAlias)

If nOpc != 3
	If lExec
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta Query  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT "+ cAlias +".* FROM "+ RetSQLName(cAlias) + " " + cAlias + " WHERE "
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra filial ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SubStr(cAlias,1,2) == "SZ"
			cQuery += cAlias+"."+substr(cAlias,2,2)+"_FILIAL = '"+xFilial(cAlias)+"' AND "
		Else
			cQuery += cAlias+"."+cAlias+"_FILIAL = '"+xFilial(cAlias)+"' AND "
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica condicao Where ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cWhere)
			cQuery += cWhere + " AND "
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra refistros deletados ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery += cAlias+".D_E_L_E_T_ = ' ' "
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta ordem dos registros  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aOrder) > 0
			For nX:=1 to len(aOrder)
				cOrder += aOrder[nX]+","
			next                  
			cQuery += "ORDER BY " + SubStr(cOrder,1,len(cOrder)-1)
		EndIf
	EndIf 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ          
	cSeek  := xFilial(cAlias)+M->CN9_NUMERO
    bWhile := {|| xFilial(cALIAS)+M->CN9_NUMERO }    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader e aCols                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FillGetDados( nOpcx, cAlias, nOrder, cSeekKey, bSeekWhile, uSeekFor, aNoFields, aYesFields, lOnlyYes,       ³
	//³				  cQuery, bMountFile, lInclui )                                                                ³
	//³nOpcx			- Opcao (inclusao, exclusao, etc).                                                         ³
	//³cAlias		- Alias da tabela referente aos itens                                                          ³
	//³nOrder		- Ordem do SINDEX                                                                              ³
	//³cSeekKey		- Chave de pesquisa                                                                            ³
	//³bSeekWhile	- Loop na tabela cAlias                                                                        ³
	//³uSeekFor		- Valida cada registro da tabela cAlias (retornar .T. para considerar e .F. para desconsiderar ³
	//³				  o registro)                                                                                  ³
	//³aNoFields	- Array com nome dos campos que serao excluidos na montagem do aHeader                         ³
	//³aYesFields	- Array com nome dos campos que serao incluidos na montagem do aHeader                         ³
	//³lOnlyYes		- Flag indicando se considera somente os campos declarados no aYesFields + campos do usuario   ³
	//³cQuery		- Query para filtro da tabela cAlias (se for TOP e cQuery estiver preenchido, desconsidera     ³
	//³	           parametros cSeekKey e bSeekWhiele)                                                              ³
	//³bMountFile	- Preenchimento do aCols pelo usuario (aHeader e aCols ja estarao criados)                     ³
	//³lInclui		- Se inclusao passar .T. para qua aCols seja incializada com 1 linha em branco                 ³
	//³aHeaderAux	-                                                                                              ³
	//³aColsAux		-                                                                                              ³
	//³bAfterCols	- Bloco executado apos inclusao de cada linha no aCols                                         ³
	//³bBeforeCols	- Bloco executado antes da inclusao de cada linha no aCols                                     ³
	//³bAfterHeader -                                                                                              ³
	//³cAliasQry	- Alias para a Query                                                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  
	IF cAlias="SZ2"
  	   FillGetDados(nOpc,cAlias,1,cSeek,bWhile,{|| Z2_CONTRA=M->CN9_NUMERO },aNoFields,,,cQuery,,   ,if(len(aHeader)>0,NIL,aHeader),aCols)
  	ElseIf cAlias="SF1"
  	   FillGetDados(nOpc,cAlias,1,cSeek,bWhile,{|| F1_CONTRA=M->CN9_NUMERO },aNoFields,,,cQuery,,   ,if(len(aHeader)>0,NIL,aHeader),aCols)
    Else
  	   FillGetDados(nOpc,cAlias,1,cSeek,bWhile,{|| .T. },aNoFields,,,cQuery,,   ,if(len(aHeader)>0,NIL,aHeader),aCols)
  	EndIf  
 
Else
	FillGetDados(nOpc,cAlias,1,     ,      ,         ,aNoFields,,,      ,,.T.,aHeader                       ,aCols)
EndIF                                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza a getdados com os cronogramas contabeis  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If oGetDad != Nil
	oGetDad:aCols := acols
	oGetDad:oBrowse:Refresh()
	oGetDad:Refresh()
EndIf

Return


// ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
// ±±³Funcao    ³ b_01Manut³ Autor ³ Davi Jesus de Oliveira                  ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Descricao ³ Manutencao de Cronogramas                                  ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Sintaxe   ³ CN110Manut(cExp01,nExp02,nExp03,aExp04,cExp05,cExo06)      ³±±
// ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
// ±±³Parametros³ cExp01 - Alias do arquivo                                  ³±±
// ±±³          ³ nExp02 - Registro atual                                    ³±±
// ±±³          ³ nExp03 - Opcao atual                                       ³±±
// ±±³          ³ nExp04 - Array com os campos                               ³±±
// ±±³          ³ nExp05 - Contrato selecionado na rotina CNTA100            ³±±
// ±±³          ³ nExp06 - Revisao do contrato selecionado na rotina CNTA100 ³±±
// ±±³          ³ lExp07 - Atualizacao de planilha                           ³±±
// ±±³          ³ lExp08 - Regera cronograma em atualizacao de planilha      ³±±
// ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
// ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
// ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function B_01Manut(cAlias,nReg,nOpcX,aCpos,cContra,cRevisa,lAtuPlan,lPlanReg)
Local aPlanilha := {}
Local cCompete  := strzero(Month(dDataBase),2)+"/"+strzero(Year(dDataBase),4)
Local dPrevista := dDataBase
Local nParcelas := 0
Local cCond     := ""
Local cCronog   := ""
Local lDist     := .F.
Local lArrasto  := .F.
Local nSaldCont := 0
Local nSaldPlan := 0
Local cFilCod   := ""
Local cQuery    := ""
Local aArea     := GetArea()
Local lRet      := .T.
Local oOk       := LoadBitmap( GetResources(), "LBTIK" )
Local oNo       := LoadBitmap( GetResources(), "LBNO" )
Local cCampos   := "CNF_FILIAL|CNF_NUMERO|CNF_CONTRA|CNF_MAXPAR|CNF_REVISA|CNF_PERANT|CNF_PERIOD|CNF_DIAPAR"// Campos excluidos da GetDados
Local oFont
Local oFnt
Local lContinua := .T.
Local aTpCron   := {"STR0007"}
Local lTpCron   := .F.
Local nParcel   := Space(3)
Local nPerc     := 0.00
Local oAntecipa
Local aAntecipa := {"STR0050","STR0051"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do painel de contratos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aStruCN9  := CN9->(dbStruct())
Local cArqCN9   := "TRBCN9"
Local oBrowse//Contratos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do cronograma                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aStruSZ3  := SZ3->(dbStruct())
Local cArqSZ3   := "TRBTZ3"
Local oBrowse//Contratos

Local oSaldCont
Local oSaldPlan

PRIVATE aTela := {}
PRIVATE aGets := {}

DEFAULT cContra := Space(TamSX3("CN9_NUMERO")[1])
DEFAULT cRevisa := Space(TamSX3("CN9_REVISA")[1])
DEFAULT lAtuPlan:=.F.
DEFAULT lPlanReg:=.F.
                       
Private nTotPlan  := 0
Private nTotCronog:= 0
Private oTotCronog
Private oSaldDist			//Saldo a ser distribuido
Private oGetDados			//Parcelas
Private aItVl     := {}	//Valores dos itens, usado pelo cronograma fisico
Private aHeader   := {}

aCampos := RetCampos("SZ3",.T.)
For nx := 1 to Len(aCampos)
	If ( X3USO(GetSX3Cache(aCampos[nx],"X3_USADO")) .And. cNivel >= GetSX3Cache(aCampos[nx],"X3_NIVEL")) .And. !(AllTrim(aCampos[nx]) $ cCampos)
		AAdd(aHeader,{AllTrim(GetSX3Cache(aCampos[nx],"X3_TITULO")),;
			AllTrim(aCampos[nx]),;
			GetSX3Cache(aCampos[nx],"X3_PICTURE"),;
			GetSX3Cache(aCampos[nx],"X3_TAMANHO"),;
			GetSX3Cache(aCampos[nx],"X3_DECIMAL"),;
			GetSX3Cache(aCampos[nx],"X3_VALID"),;
			GetSX3Cache(aCampos[nx],"X3_USADO"),;
			GetSX3Cache(aCampos[nx],"X3_TIPO"),;
			GetSX3Cache(aCampos[nx],"X3_F3"),;
			GetSX3Cache(aCampos[nx],"X3_CONTEXT") })
	Endif
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona os campos de Alias e Recno ao aHeader para WalkThru.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcX <> 3
	ADHeadRec("SZ3",aHeader)
EndIf	
If nOpcX == 3//Inclusao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo temporario para os contratos            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oArqCN9:= FwTemporarytable():New(cArqCN9,aStruCN9)
	oArqCN9:Create()
	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega informacoes do cronograma se nao for inclusao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cContra := SZ3->Z3_CONTRA
	cCronog := SZ3->Z3_NUMERO
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo temporario para os cronogramas          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oArqTZ3:= FwTemporarytable():New(cArqTZ3,aStruSZ3)
	oArqTZ3:Create()
	
	
EndIF
	

RestArea(aArea)

Return

User Function b01delcro()
Local lRet    := .T.           
Local nFor2   := 0
Local nFor4   := 0
Local nSoma2  := 0 
Local nSoma4  := 0 
Local nPosQTD := aScan(aHeader2,{|x| AllTrim(x[2]) == "Z3_QUANT"})       
Local nPosGER := aScan(aHeader4,{|x| AllTrim(x[2]) == "Z2_QTDTT"})       
                 
For nFor2 := 1 to Len(aCols2)
    nSoma2 += aCols2[nFor2,nPosQtd]
Next nFor2

For nFor4 := 1 to Len(aCols2)
    nSoma4 += aCols4[nFor4,nPosQtd]
Next nFor4
                         
If nSoma2 <> nSoma4
   MsgAlert("Soma dos períodos deve ser igual a ::Condição Comercial>Qtde Total")
   lRet := .f.
Endif                 

Return lRet

// *********************************************************************************       
// Validação do Cronograma do Contrato. - Alexandre Santos - 02/08/2013
// *********************************************************************************
User Function BC001lok()                            
 
Local nContr    := aScan(aHeader2,{|x| AllTrim(x[2]) == "Z3_CONTRA"} )
Local nQuant    := aScan(aHeader2,{|x| AllTrim(x[2]) == "Z3_QUANT"} )
Local lRetorno  := .T.
Local _nX       := 0
Local nSomaVal  := 0
Local nQtCont   := M->CN9_QTDTOT  
Local _aCols2   := {}  

If lRetorno
    
    _aCols2:= oGetDad2:aCols
  
  	nSomaVal := 0
	For _nX	:= 1 To Len(_aCols2)
		If !_aCols2[_nX][Len(_aCols2[_nX])]
			nSomaVal += _aCols2[_nX][nQuant]
		EndIf
	Next
	
	If nSomaVal > nQtCont
	   
	   lRetorno := .F.
	   MsgAlert("Não é possível incluir e ou alterar a quantidade contratada do cronograma, pois o somatório de todos os Contratos DP "+ Alltrim(Str(nSomaVal)) +" é maior do que o total do Contrato:"+ Alltrim(Str(nQtCont))+". Para tornar isso possível é preciso alterar o saldo total contratado." )     
	
	EndIf

EndIf


Return(lRetorno)

Static Function RetCampos(cArq, lVirtual)		
Local aCampos := {}
Local aCmpRet := {}
Local cUsado := ""
Local nx := 1

DEFAULT lVirtual := .F.

aCampos := FWSX3Util():GetAllFields(cArq,lVirtual)
	
For nx := 1 to Len (aCampos)
	IF !("USERLG" $ aCampos[nx]) 
		cUsado   := X3OBRIGAT(aCampos[nx])
		// Verifica se o campo é usado
		If !Empty(cUsado)
			AADD(aCmpRet,{aCampos[nx],FWSX3Util():GetDescription( aCampos[nx] )})
		EndIf
	Endif
Next nx
Return aCmpRet	
