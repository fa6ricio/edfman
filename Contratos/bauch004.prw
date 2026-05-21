#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBEX.CH"

#DEFINE MAXGETDAD 99999
#DEFINE MAXSAVERESULT 999
#DEFINE STR0001	"Pesquisar"
#DEFINE STR0002	"Visualizar"
#DEFINE STR0003	"Incluir"
#DEFINE STR0004	"Gerar Pedido"
#DEFINE STR0005	"Excluir"
#DEFINE STR0006	"Envia Preço"
#DEFINE STR0007	"Reajuste"
#DEFINE STR0008	"Legenda"
#DEFINE STR0009 "Gerção das Informações de Compra"
#DEFINE STR0015 "A Gerar"
#DEFINE STR0016 "Gerado Automatico"
#DEFINE STR0017 "Gerado Manual"
#DEFINE STR0019 "Busca Tabela Do Contrato"
#DEFINE STR0020 "Busca"
#DEFINE STR0021 "Status"
#DEFINE cEnt	Chr(13)+Chr(10)
Static aUltResult
                            

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Função    ³ GERCOM     ³ Autor ³ Davi Jesus de Oliveira     - 22/11/2010 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descrição ³ Rotina de Geração de Preço do Pedido de compra               ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ gercom(ExpN1,ExpA1,ExpA2)                                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ ExpN1 = opcional - Numero da opcao selecionada               ³±±
//±±³          ³ ExpA1 = opcional - array cabec.p/ uso na rotina autom.       ³±±
//±±³          ³ ExpA1 = opcional - array itens p/ uso na rotina autom.       ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Alteração ³ Luis Felipe Nascimento                           05/11/15    ³±±
//±±³          ³ RDM_054_Contratos_em_Reais                                   ³±±
//±±³          ³                                                              ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


User Function GerCom(cAlias,nReg,nOpc)

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
Private aRotina := {{ STR0001	,"AxPesqui"		,0,1,0,.F.},;  //"Pesquisar"
					{ STR0002	,"AxVisual"		,0,2, ,.F.},;  //"Visualizar"
					{ STR0004	,"U_b04Brw"	    ,0,4, ,.F.},;  //"Gerar Pedido de Compra"
					{ STR0008	,"U_bau04Leg"	,0,5, ,.F.} }  //"Legenda"

cCadastro := STR0009
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as cores da MBrowse                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCores,{"Z7_STATUS == ' ' ","BR_VERDE"})     // A Gerar
Aadd(aCores,{"Z7_STATUS == '1' ","BR_VERMELHO"})  // Gerado Automatico
Aadd(aCores,{"Z7_STATUS == '2' ","BR_VERMELHO"})  // Gerado Manual

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Endereca para a funcao MBrowse                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

dbSelectArea("SZ7")   
dbSetOrder(1)
dbGoTop()
Do While ! SZ7->(EOF())            
   If Empty(SZ7->Z7_TPCTO)
      dbSelectArea("CN9")
      dbSetOrder(1)
      dbSeek(xFilial("CN9")+SZ7->Z7_CONTRA)
      If !CN9->(EOF())
         dbSelectArea("SZ7")      
         RecLock("SZ7",.F.)
         SZ7->Z7_TPCTO:=CN9->CN9_TPCTO
         Msunlock()
      EndIf
      dbSelectArea("SZ7")
   EndIf
   SZ7->(dbSkip())
EndDo

SZ7->(dbGoTop())
DbSeek( xFilial("SZ7") )
SET FILTER TO SZ7->Z7_SALDO > 0 .AND. SZ7->Z7_TPCTO="001"                                            

mBrowse(06,01,22,75,"SZ7",,,,,,aCores)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Integridade da Rotina                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ7")
dbSetOrder(1)
dbClearFilter()

Return(Nil)


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
//±±³Funcao    ³bau04Leg  ³ Autor ³ Davi Jesus de Oliveira ³ Data ³23.11.10 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³Legenda das tabelas                                         ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³Nenhum                                                      ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³Nenhum                                                       ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
STATIC Function bau04Leg()

Local aLegenda := { { "BR_VERDE"   ,STR0015},;     // "A Gerar "
					{ "BR_VERMELHO",STR0016},;     // "Gerado Automatico"
					{ "BR_AZUL"    ,STR0017} }     // "Gerado Manual"


BrwLegenda( cCadastro, STR0021, aLegenda  )   //"Status"

Return(.T.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ b03Brw  ºAutor  ³ Davi Jesus de Oliveira   ºData³ 28/11/10 º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Monta tela com a markbrowse para escolha dos preços a serem º±±
//±±º          ³enviados ao contrato.                                       º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function b04Brw()
Local nOpca     := 0
Local dData     := Date()
Local aCampos   := {}
Local aCampos1  := {}    
Local cTitulo2  := "Parametro do Pedido de Compra"
Local cTitulo3  := "Numero do Contrato"
Local aDim	    := {}	  
Local oDlg
Local oEnc01       
Local oGet  
Local oGet03                   

Local oCombocor  := Nil 

Local aCombocor  := {}


//Local n_Qtde  := 0 
Local oPanelDados      
Private cContra := Space(TamSX3("CN9_NUMERO")[1])       
Private cNavio  := SPACE(10)
Private cBooking:= SPACE(20)    
Private n_Qtde  := SZ7->Z7_SALDO    // 13/09/13 - Luis Felipe Nascimento
Private cCorEmb := SPACE(20)          
Private nTxUSD  := 0                    
Private nqtdcont:= 0   
Private cArmazem:= SPACE(02)              
//Private cCPgto  := Space(TamSX3("E4_CODIGO")[1]) // Alterado por Vagner Almeida - 19/07/2012
Private cCPgto  :="001" //ENS 03/03/16 
Private cObs    := SPACE(25)                     // Alterado por Vagner Almeida - 19/07/2012
Private cMarca  := GetMark() 
Private cFornece:= Space(TamSX3("A2_COD")[1])


aAdd( aCombocor, "MARROM" )
aAdd( aCombocor, "BRANCA" )

AADD(aCampos,{"Z7_STATUS"  ,"C",TamSX3("Z7_STATUS")[1],0})
AADD(aCampos,{"Z7_CONTRA"  ,"C",TamSX3("Z7_CONTRA")[1],0})
AADD(aCampos,{"Z7_PERDE"   ,"C",TamSX3("Z7_PERDE")[1],0})
AADD(aCampos,{"Z7_QTDE"    ,"N",TamSX3("Z7_QTDE")[1],3})
AADD(aCampos,{"Z7_MEDIA"   ,"C",TamSX3("Z7_MEDIA")[1],0})

// INCLUIR CAMPOS Z7_PRECO E Z7_VLFINAL

AADD(aCampos,{"Z7_PRECO"   ,"N",TamSX3("Z7_SALDO")[1],3})
AADD(aCampos,{"Z7_VLFINAL" ,"N",TamSX3("Z7_SALDO")[1],3})

AADD(aCampos,{"Z7_EMISSAO" ,"D",TamSX3("Z7_EMISSAO")[1],0})
AADD(aCampos,{"Z7_SALDO"   ,"N",TamSX3("Z7_SALDO")[1],3})
AADD(aCampos,{"Z7_NAVIO"   ,"C",TamSX3("Z7_NAVIO")[1],0})
AADD(aCampos,{"Z7_BOOK"    ,"C",TamSX3("Z7_BOOK")[1],0}) 
AADD(aCampos,{"Z7_CONTROL" ,"C",TamSX3("Z7_CONTROL")[1],0}) // 13/09/13 - Luis Felipe Nascimento
AADD(aCampos,{"REGISTRO"   ,"N",6,0}) // 13/11/14 - Luis Felipe Nascimento

AADD(aCampos1,{"Z7_STATUS" ,"","Status",""})
AADD(aCampos1,{"Z7_CONTRA" ,"","Número do Contrato","@!"})
AADD(aCampos1,{"Z7_PERDE"  ,"","Período","@!"})
AADD(aCampos1,{"Z7_QTDE"   ,"","Quantidade Liberada","@e 999,999,999.999"})
AADD(aCampos1,{"Z7_MEDIA"  ,"","Media","@!"})
AADD(aCampos1,{"Z7_PRECO"  ,"","Vl Ponderado" ,"@E 999,999.999"})
AADD(aCampos1,{"Z7_VLFINAL","","Vl Final USD" ,"@E 999,999,999.999"})
AADD(aCampos1,{"Z7_EMISSAO","","Data"         ,"@e 999,999,999.999"})
AADD(aCampos1,{"Z7_SALDO"  ,"","Saldo"        ,"@E 999,999,999.999"})
AADD(aCampos1,{"Z7_NAVIO"  ,"","Navio"        ,"@!"})
AADD(aCampos1,{"Z7_BOOK"   ,"","Booking"      ,"@!"})
AADD(aCampos1,{"Z7_CONTROL","","N.Controle"   ,"@!"})
                    
cContra:=SZ7->Z7_CONTRA


/***********************************
        Busca Taxa do Dolar  
   (Vagner Almeida - 19-07-2013)
***********************************/ 

// 10/10/2013 - Luís Felipe Nascimento
/* Desabilitado pois, não estavam alterando a taxa Pentax quando necessário.
dbSelectArea("SM2")
dbSetOrder(1)
if dbSeek(dData)
   nTxUSD   := M2_MOEDA2
Else                                                  
   nTxUSD   := 0
EndIf
dbCloseArea("SM2")      
*/

/***************************************************************************
            Verifica se o Contrato é de compras para poder liberar 
                       (Vagner Almeida - 19-07-2013)
***************************************************************************/ 

If !(SZ7->Z7_TPCTO = "001")

   Msgalert("Contrato Inválido. Favor Selecionar um Contrato de Compra.")

   Return                                                                   
   
EndIf

n_Qtde := SZ7->Z7_SALDO

/**************************************************************************/ 

//DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo2) FROM  80,115 /*115*/ TO /*245*/350,500/*430*/ PIXEL // Comentado por Vagner Almeida em 18-07-2013
DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo2) FROM  0,0 TO 350,400 PIXEL // Alterado por Vagner Almeida - 19/07/2013 (Início)

@ 05,010 SAY OemToAnsi(cTitulo3) SIZE 60, 8 OF oDlg PIXEL 
@ 05,070 MSGET oGet VAR cContra PICTURE "@!" SIZE 80,9 F3 "SZ3" VALID ExistCpo("CN9", cContra) .AND. NAOVAZIO() OF oDlg PIXEL WHEN .T. // Alterado por Vagner Almeida - 19/07/2013 (Início)
@ 05,155 SAY "Período: "+SZ7->Z7_PERDE SIZE 60, 8 OF oDlg PIXEL

@ 25,10 SAY "Quantidade :" SIZE 60, 8 OF oDlg PIXEL
@ 25,70 MSGET oGet VAR n_Qtde  PICTURE "@e 999,999,999.999" SIZE 80,9 VALID (n_Qtde>0 .and. fSaldo(n_Qtde)) OF oDlg PIXEL        

//@ 50,10 SAY "Navio" SIZE 60, 8 OF oDlg PIXEL
//@ 50,70 MSGET oGet VAR cNavio  PICTURE "@!" SIZE 80,9 F3 "CTH" VALID cNavio<>'' .AND. U_BUSCABK(cNavio) OF oDlg PIXEL

//@ 75,10 SAY "Booking" SIZE 60, 8 OF oDlg PIXEL
//@ 75,70 MSGET oGet VAR cBooking PICTURE "@!" SIZE 80,9 VALID cBooking<>'' OF oDlg PIXEL       

/* 26/08/13 - Luís Felipe Nascimento
@ 50,10 SAY "Cor da Embalagem" SIZE 60, 8 OF oDlg PIXEL
@ 50,70 COMBOBOX oCombocor VAR cCorEmb ITEMS aCombocor SIZE 80,9 PIXEL OF oDlg PIXEL         
*/

@ 50,10 SAY "Taxa USD:" SIZE 60, 8 OF oDlg PIXEL
@ 50,70 MSGET oGet VAR nTxUSD  PICTURE "@e 999,999,999.9999" SIZE 80,9 VALID nTxUSD>0 OF oDlg PIXEL WHEN .T. // Alterado por Vagner Almeida - 19/07/2013 (Início)

//@ 140,10 SAY "Qtd.Containers:" SIZE 60, 8 OF oDlg PIXEL
//@ 140,70 MSGET oGet VAR nqtdcont  PICTURE "@e 999,999,999.999" SIZE 80,9 VALID nqtdcont>0 OF oDlg PIXEL     

//@ 165,10 SAY "Armazém:" SIZE 60,8 OF oDlg PIXEL
//@ 165,70 MSGET oGet VAR cArmazem  PICTURE "99" SIZE 10,9 VALID NAOVAZIO() .and. len(alltrim(cArmazem)) > 1 OF oDlg PIXEL   

/*
    Alterado por Vagner Almeida - 19/07/2013 (Início)
*/
             
@ 75,10 SAY "Cond. Pagamento:" SIZE 60,8 OF oDlg PIXEL
@ 75,70 MSGET oGet VAR cCPgto  PICTURE "@!" SIZE 80,9 F3 "SE4" VALID ExistCpo("SE4",AllTrim(cCPgto)) .and. NAOVAZIO() OF oDlg PIXEL  WHEN .T.

@ 100,10 SAY "Observação:"      SIZE 60,8 OF oDlg PIXEL
@ 100,70 MSGET oGet VAR cObs    PICTURE "@!" SIZE 80,9  OF oDlg PIXEL WHEN .T.

@ 125,10 SAY "Fornecedor:" SIZE 60,8 OF oDlg PIXEL
@ 125,70 MSGET oGet VAR cFornece  PICTURE "@999" SIZE 80,9 F3 "CNCFOR" VALID NAOVAZIO() OF oDlg PIXEL  WHEN .T.

/*
    Alterado por Vagner Almeida - 19/07/2013 (Fim)
*/

DEFINE SBUTTON FROM 150, 070 TYPE 1 ACTION (if(!empty(cContra),oDlg:End(),))    ENABLE OF oDlg
DEFINE SBUTTON FROM 150, 123 TYPE 2 ACTION (cContra:="",oDlg:End(),nOpcTp := 2) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED


//ADRIANO - APÓS ESSE PASSO CRIAR UM MARKBROWSE PRA SELECIONAR OS PREÇOS INFORMADOS// VERIFICAR SE REALMENTE É NECESSÁRIO.

If empty(cContra)
   Msgalert("Cancelado pelo Operador")
   Return
Endif

DEFINE MSDIALOG oDlg TITLE "Seleção de Contratos para Geração" FROM 9,0 To 28,/*80*/100 OF oMainWnd   

If Select("TRB")>0
	dbSelectArea("TRB")
	dbCloseArea()
Endif

cAlias := "TRB"
oAlias:= FwTemporarytable():New(cAlias,aCampos)
oAlias:Create()

// ABASTECE TABELA TEMPORÁRIA
DbselectArea("SZ7")
SZ7->(DbSetOrder(3))
SZ7->( dbSeek(xFilial("SZ7")+cContra+SZ7->Z7_PERDE+SZ7->Z7_MEDIA) )

//dbGoTop()
Do While !SZ7->(Eof()) .AND. SZ7->Z7_CONTRA == cContra    
    if SZ7->Z7_SALDO>0
  	   RecLock("TRB",.T.)
	   TRB->Z7_STATUS  := '  '
	   TRB->Z7_CONTRA  := SZ7->Z7_CONTRA
	   TRB->Z7_PERDE   := SZ7->Z7_PERDE
	   TRB->Z7_QTDE    := SZ7->Z7_QTDE
	   TRB->Z7_SALDO   := SZ7->Z7_SALDO
	   TRB->Z7_EMISSAO := SZ7->Z7_EMISSAO
	   TRB->Z7_MEDIA   := SZ7->Z7_MEDIA             
	   TRB->Z7_PRECO   := SZ7->Z7_PRECO
	   TRB->Z7_VLFINAL := SZ7->Z7_VLFINAL
	   TRB->Z7_NAVIO   := cNavio
	   TRB->Z7_BOOK    := cBooking
	   TRB->Z7_CONTROL := SZ7->Z7_CONTROL
	   TRB->REGISTRO   := SZ7->(Recno()) // 13/11/14 - Luís Felipe
	   MsUnLock()
    Endif
	SZ7->(dbskip())
Enddo
                      
TRB->( dbGoTop() ) 
oMark:=MsSelect():New("TRB","Z7_STATUS",,aCampos1,,cMarca,{02,1,23,316})
oMark:oBrowse:lhasMark := .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := {|| b004Inverte(cMarca,@oMark)}
oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

DEFINE SBUTTON FROM /*126*/130,246.3 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM /*126*/130,274.4 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	
ACTIVATE MSDIALOG oDlg CENTERED

       
// Ao sair será gravada as informações...
If nOpca == 1
   	b04GRVTRB()
Endif

Return


// rotina para inverter a seleção do mark
Static Function b004Inverte(cMarca,oMark)

Local nReg := TRB->(Recno())
dbSelectArea("TRB")
dbGoTop()
While !Eof()
	RecLock("TRB")
	IF A1_OK == cMarca
		TRB->Z7_STATUS := " "
	Else
		TRB->Z7_STATUS := cMarca
	Endif
	dbSkip()
Enddo
TRB->(dbGoto(nReg))
oMark:oBrowse:Refresh(.t.)

Return Nil
 
// ----------------------------------------------------------
// Gera informações para SC7
// ---------------------------------------------------------- 
Static Function b04GRVTRB()
Local n_qtde:=0
   // colocar neste potno a informação de que será gerado o pedido com quantidades diferenciadas ou manuais ..
   // se ele quiser manual colcoar o status.
Processa({|lEnd| B004GRV(n_Qtde)},,"Gravando Informações")

Return
                                            

//
// rotina para geração do SC7
//
// Regra: 1)Toda vez que é feito um pedido de compra é baixado o saldo dos produtos precificados.
//        
//

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Função    ³ b004GRV    ³ Autor ³ Davi Jesus de Oliveira     - 02/11/2010 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descrição ³ Rotina de Gweração de Preço do Pedido de compra              ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³                                                              ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Alteracao ³ Luis Felipe Nascimento                 Data: 09/07/13        ³±±
//±±³          ³ Adicionado campo C7_XPERIOD                                  ³±±
//±±³          ³                                                              ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function b004GRV()

Local AvetM := {} 
Local cNum

aadd(aVetM, 0 )  // QUANTIDADE ORIGINAL
aadd(aVetM, 0 )  // QUANTIDADE SALDO
aadd(aVetM, 0 )  // MEDIA DE PRECO
aadd(aVetM, "" )  // Numero do Contrato
aadd(aVetM, "" ) // navio
aadd(aVetM, "" ) // booking
aadd(aVetM, 0 )  // media ponderada
aadd(aVetM, 0 )  // valor final
aadd(aVetM, 0 )  // qtde de sacos
aadd(aVetM, "" ) // cor da embalagem
aadd(aVetM, "" ) // contrato customizado.
aadd(aVetM, "" ) // Período do Contrato.



TRB->(Dbgotop())
ProcRegua(TRB->(Reccount()))

cCONTRA:=""
ndollar_dia := nTxUSD //Posicione("SM2",1,dtoS(dDatabase-1),"M2_MOEDA2")

While !TRB->(Eof())
	IncProc("Analisando ... Contrato: " +TRB->Z7_CONTRA) 
	If TRB->Z7_STATUS==cMarca   // se foi selecionado na markbrowse
	
	   cCONTRA  := TRB->Z7_CONTRA
	   cCHAVE   := TRB->Z7_CONTRA  
	   cPerde  := TRB->Z7_PERDE
	   cMEDIA  := TRB->Z7_MEDIA

	   Dbselectarea("SZ7")
       /* 13/11/14 - Luis Felipe Nascimento - Inicio
       // DbSetOrder(3)   
	   // SZ7->( Dbseek(xFilial("SZ7")+cCHAVE+cPerde+cMEDIA) )     
	   */ 
	   		   
	   DbGoto(TRB->REGISTRO)
       // 13/11/14 - Luis Felipe Nascimento - fim
	    
	   aVetM[1] += SZ7->Z7_QTDE
	   aVetM[2] += SZ7->Z7_SALDO               

	   *--------------------------------------------------------------*
       * Luis Felipe Nascimento                             05/11/15  *
       * RDM_054_Contratos_em_Reais                                   *
       * Obs.: Como a Precificação está em Real não será necessário   *
       *       converter o valor do pedido C7_PRECO.                  *
	   *--------------------------------------------------------------*
	   
//	   nDesReal := Posicione("SZ5",3,xFilial("SZ5")+cCHAVE,"Z5_DESREAL") // 05/11/15 - Luis Felipe
	   nDesReal := Posicione("SZ5",1,xFilial("SZ5")+cCHAVE+cPerde,"Z5_DESREAL")

	   CN9->(DbSetOrder(1))
	   CN9->(DbSeek(xFilial("CN9")+cCONTRA))
	   
	   If	CN9->CN9_MOEDA = 2 	
	   		aVetM[3] :=  iif(nDesReal>0,(SZ7->Z7_VLFINAL*ndollar_dia)+nDesReal,(SZ7->Z7_VLFINAL*ndollar_dia)-(nDesReal*-1)) // PRECO EM R$ PARA SEQUENCIA DO ERP
		   	aVetM[7] := SZ7->Z7_PRECO
		   	aVetM[8] := SZ7->Z7_VLFINAL
       Else
	   		aVetM[3] :=  iif(nDesReal>0,SZ7->Z7_VLFINAL+nDesReal,SZ7->Z7_VLFINAL-(nDesReal*-1)) // PRECO EM R$ PARA SEQUENCIA DO ERP
		   	aVetM[7] := SZ7->Z7_PRECO / ndollar_dia
		   	aVetM[8] := SZ7->Z7_VLFINAL / ndollar_dia
       EndIf
       
       // 05/11/15 - Luis Felipe - Fim
       
	   aVetM[4] := cCONTRA // cCHAVE // 17/09/13 - Luís Felipe Nascimento
	   aVetM[5] := cNAVIO    //TRB->Z7_NAVIO
	   aVetM[6] := cBooking  //TRB->Z7_BOOK        

       // 22/08/13 - Luís Felipe Nascimento - Inicio
	   cProduto := Alltrim(cCONTRA)+"-"+Alltrim(cPerde)
       cProduto := Padr(cProduto,TamSX3("B1_COD")[1])

	   SB1->(DbSetOrder(1))
	   If !SB1->(DbSeek(xFilial("SB1")+cProduto))
	   		Aviso("Atenção","Não será possível gerar o Pedido de Compras pois, está faltando criar o produto "+cProduto+" !",{"Voltar"})		
	   		Return 
	   EndIf
	   cTpemb 	:= SB1->B1_SEGUM
//	   cTpemb := Posicione("SB1",1,xFilial("SB1")+SZ2->Z2_CODPRO,"B1_SEGUM")
	   // 22/08/13 - Luís Felipe Nascimento - Fim

//	   cTpemb := Posicione("SB1",1,xFilial("SB1")+SZ2->Z2_CODPRO,"B1_SEGUM")
	    		   
	   nSacos := 0
	   If SB1->B1_UM == "SC"
		   nSacos := (n_Qtde * 1000) / 50  
	   EndIf
	   
	   aVetM[9] := nSacos
                   
//       aVetM[10] := cCorEmb   26/08/13 - Luís Felipe Nascimento
       aVetM[11] := cCHAVE
       aVetM[12] := cPerde
       
	Endif
	dbSelectArea("TRB")
	TRB->(Dbskip())                
	
Enddo                          

if n_Qtde>aVetM[2]
   msgalert("Quantidade não permitida!")
   Return Nil
endif

dbSelectArea("CNC")
dbSetOrder(1)
cFORNEC :=""                        
cLOJAF  :="" 
cCODPAG :=""                            
cCONTATO:=""

*'YTTALO P MARTINS-INICIO-CHAVE NÃO EXISTENTE-SERÁ TRATADO POR QUERY---'*
/*
If dbSeek(xFilial("CNC")+cCONTRA+cFornece)
   cFORNEC :=CNC->CNC_CODIGO
   cLOJAF  :=CNC->CNC_LOJA          
   cCODPAG :=CNC->CNC_CODPAG           
   //cCONTATO:=SUBSTR(CNC->CNC_NOME,1,15)
Endif
*/
IF SELECT("TMPCNC") > 0
	dbSelectArea("TMPCNC") 
   ("TMPCNC")->( dbCloseArea() )
Endif

cQuery3 := "SELECT * FROM "+RetSQLName("CNC")+" CNC "
cQuery3 += "WHERE CNC_FILIAL='"+xFilial("CNC")+"' "
cQuery3 += "AND CNC_NUMERO='"+cCONTRA+"' "
cQuery3 += "AND CNC_CODIGO='"+cFornece+"' "
cQuery3 += "AND CNC.D_E_L_E_T_ = ' ' "
cQuery3 := ChangeQuery(cQuery3)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),"TMPCNC",.T.,.T.)

dbSelectArea("TMPCNC")
("TMPCNC")->(dbGotop())
IF ("TMPCNC")->(!EOF())

   cFORNEC := ("TMPCNC")->CNC_CODIGO
   cLOJAF  := ("TMPCNC")->CNC_LOJA          
   cCODPAG := ("TMPCNC")->CNC_CODPAG

ENDIF

IF SELECT("TMPCNC") > 0
	dbSelectArea("TMPCNC") 
   ("TMPCNC")->( dbCloseArea() )
Endif

*'YTTALO P MARTINS-FIM-CHAVE NÃO EXISTENTE-SERÁ TRATADO POR QUERY-----'*
                 
cCODPAG:=cCPgto // Vagner - Substituir pela sua variável                     
    
SZ2->( dbSetOrder(1) )
SZ2->( dbSeek(xFilial("SZ2")+aVetM[4]) )
// Criar o valor total com a media encontrada.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seta as variaveis de sistema para compra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nModulo := 2
cModulo := "COM"               

//cNum    :=  GetSx8Num("SC7","C7_NUM") 


*Retirado pois tava levando em conta filiais e não deveria - Rafaela Trajano 19/11/13*  
/*dbSelectArea("SC7")
dbSetOrder(1)
MsSeek(xFilial("SC7")+"zzzzzz",.T.)
dbSkip(-1)
cNum := SC7->C7_NUM
If Empty(cNum)
   cNum := StrZero(1,Len(SC7->C7_NUM))
Else
   cNum := Soma1(cNum)
EndIf */

*Rafaela Trajano 19/11/13 --------------------------------------*    

cQuery  = "SELECT MAX(C7_NUM) as cNum"		+cEnt
cQuery += " FROM "+RetSqlName("SC7")+" SC7" +cEnt 
cQuery += " WHERE SC7.D_E_L_E_T_  = ' '"	+cEnt
cQuery := ChangeQuery(cQuery)   
 
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TMP", .F., .T.)  

DbSelectArea("TMP") 
	cNum := Soma1(TMP->cNum) 
	DbCloseArea("TMP")
*---------------------------------------------------------------*
//Default nMoeda := 1
nMoeda  := 1       
aItens  := {}                  
aCab    := {}

cItem     := "0000"
cItem := Soma1(cItem,4)                     
                      
aCab:={{"C7_NUM"       , cNum      ,Nil},;
       {"C7_EMISSAO"   , dDataBase ,Nil},; // Data de Emissao
       {"C7_FORNECE"   , cFORNEC   ,Nil},; // Fornecedor
       {"C7_LOJA"      , cLOJAF    ,Nil},; // Loja do Fornecedor
       {"C7_COND"      , cCODPAG   ,Nil},; // Condicao de pagamento
       {"C7_CONTATO"   , cCONTATO  ,Nil},; // Contato
       {"C7_CONTRA"    , aVetM[4]  ,nil},;
       {"C7_FILENT"    , xFilial() ,Nil}}

aadd(aItens,{{"C7_ITEM"   ,  cItem    			   ,nil},;
             {"C7_PRODUTO",  cProduto    	   ,nil},;   // SZ2->Z2_CODPRO // 20/08/13 - Luis Felipe Nascimento
             {"C7_QUANT"  ,  n_Qtde   	           ,nil},;
             {"C7_PRECO"  ,  Round((aVetM[3]),2)            ,nil},; 
             {"C7_TOTAL"  ,  (n_Qtde*Round(aVetM[3],2))     ,nil},;
             {"C7_DATPRF" ,  dDatabase+30		   ,nil},;
             {"C7_UM"     ,  SB1->B1_SEGUM         ,nil},;
             {"C7_LOCAL"  ,  cArmazem              ,nil},;
             {"C7_NAVIO"  ,  aVetM[5]              ,nil},;
             {"C7_BOOK"   ,  aVetM[6]              ,nil},;
             {"C7_TAXAUSD",  ndollar_dia           ,nil},;
             {"C7_MEDIA"  ,  aVetM[7]              ,nil},;
             {"C7_VLFINAL",  aVetM[8]              ,nil},;
             {"C7_QTDSC"  ,  aVetM[9]              ,nil},;
             {"C7_CONTRAT",  aVetM[11]			   ,nil},;
             {"C7_QTDCONT",  nqtdcont              ,nil},;      
             {"C7_CLVL"   ,  SUBSTR(aVetM[5],1,9)  ,nil},;
             {"C7_OBS"    , cObs                   ,Nil},;  // Alterado por Vagner Almeida - 19/07/2013
             {"C7_XPERIOD",  aVetM[12]             ,nil}})   
					 
//             {"C7_COREMB" ,  aVetM[10]             ,nil},; 26/08/13 - Luis Felipe Nascimento
lMSErroAuto := .F.
msExecAuto({|x,y,w,z|MATA120(x,y,w,z)},1,aCab,aItens,3)

If lMSErroAuto
   lRet     := .F.
   MostraErro()	//"Falha na atualizacao do pedido"
ELSE   
   //CONFIRMSX8("SC7","C7_NUM") 
   
   //ConfirmSX8()             
   
//   Dbselectarea("SZ7")
//   DbSetOrder(3) // 13/09/13 - Luis Felipe Nascimento  
//   SZ7->( Dbseek(xFilial("SZ7")+cCHAVE)) //+cPerde+cMEDIA) )     
   RecLock("SZ7" ,.F.) 
   if SZ7->Z7_SALDO-n_Qtde=0
  	  SZ7->Z7_STATUS	:= "1"             
   endif
   SZ7->Z7_SALDO   := SZ7->Z7_SALDO-n_Qtde //baixando saldo de produtos precificados por tonelada.Adriano
   MsUnlock()
	   
   DBSELECTAREA("SC7")
   DBSETORDER(1)
   DBSEEK(xFILIAL("SC7")+cNum)
   DO WHILE !SC7->(EOF()) .AND. SC7->C7_NUM==cNUM
      RecLock("SC7",.F.)
      SC7->C7_QTDSC   := aVetM[9]
      SC7->C7_NRMEDIA := cMEDIA   
      SC7->C7_NAVIO   := cNAVIO
      MSUNLOCK()
      SC7->(DBSKIP())
   ENDDO
     
   MSGALERT("PEDIDO DE COMPRAS GERADO: "+cNum)

EndIf                                         
Return                                                        


USER FUNCTION BUSCABK(cNavio)
DBSELECTAREA("CTH")
DBSETORDER(1)
DBSEEK(xFILIAL("CTH")+cNavio)
IF !CTH->(EOF())                                                         

   cBOOKING:=CTH->CTH_BOOKIN
ENDIF   
RETURN cBOOKING              

*---------------------------*
Static Function fSaldo(nQtde)
*---------------------------*

Local lRet := .t.

If nQtde > SZ7->Z7_SALDO
	Aviso("Atenção","Não é permitido gerar Pedidos de Compras que ultrapassem o saldo ! O saldo é de " + TRANSFORM(SZ7->Z7_SALDO,"@E 9,999,999.999"),{"Voltar"})
	lRet := .f.
EndIf

Return( lRet )
