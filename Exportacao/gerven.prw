#INCLUDE "APWEBEX.CH"
#INCLUDE "PROTHEUS.CH"
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
#DEFINE STR0009 "Geração das Informações de Venda"
#DEFINE STR0015 "A Gerar"
#DEFINE STR0016 "Gerado Automatico"
#DEFINE STR0017 "Gerado Manual"
#DEFINE STR0019 "Busca Tabela Do Contrato"
#DEFINE STR0020 "Busca"
#DEFINE STR0021 "Status"
Static aUltResult
                            

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Função    ³ GERVEN     ³ Autor ³ ADRIANO MIGOTO PINTO       - 27/01/2011 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descrição ³ Rotina de Gweração de Preço do Pedido de VENDA              ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ gerven(ExpN1,ExpA1,ExpA2)                                  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ ExpN1 = opcional - Numero da opcao selecionada               ³±±
//±±³          ³ ExpA1 = opcional - array cabec.p/ uso na rotina autom.       ³±±
//±±³          ³ ExpA1 = opcional - array itens p/ uso na rotina autom.       ³±±    
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºAlteração ³ Alexandre Santos - 24/07/2013 - De Para da TES             º±±
//±±º          ³ De 005 Para 018                                            º±±
//±±º          ³ De 006 Para 006                                            º±±
//±±º          ³ De 008 Para 002                                            º±±
//±±º          ³ De 009 Para 017                                            º±±  
//±±º          ³ De 501 Para 504                                            º±±
//±±º          ³ De 506 Para 501                                            º±±
//±±º          ³ De 598 Para 507                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºAlteracao ³          ºAutor  ³ Luis Felipe Mattos º Data ³  05/06/14   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±º          ³ Adicionada validação para a classe de valor quanto o produ-º±±
//±±º          ³ to fizer referência a produtos comercializados pela ED&FMANº±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function GerVen(cAlias,nReg,nOpc)

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
					{ STR0004	,"U_vb04Brw"	    ,0,4, ,.F.},;  //"Gerar Pedido de Compra"
					{ STR0008	,"vbau04Leg"	,0,5, ,.F.} }  //"Legenda"

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
DbSeek( xFilial("SZ7") )
SET FILTER TO SZ7->Z7_SALDO > 0 .AND. SZ7->Z7_TPCTO="002"                                            

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
STATIC Function vbau04Leg()

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
User Function vb04Brw()
Local nOpca     := 0
Local aCampos   := {}
Local aCampos1  := {}    
Local cTitulo2  := "Parametro do Pedido de Venda"
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
Private cContra  := Space(TamSX3("CN9_NUMERO")[1])       
Private cNavio   := SPACE(10)
Private cBooking := SPACE(20)    
Private n_Qtde   := 0 
Private cCorEmb  := SPACE(20)          
Private nTxUSD   := 0                    
Private nqtdcont := 0   
Private cArmazem := SPACE(02)              

Private cMarca   := GetMark()     

Private cTes     := space(3) //"501"    

Private cRE      := Space(20)         

Private nPrepagto:= 0 // Adriano - nessa variável armazena o valor do pré-pagamento pra gravar na SC5 - Pedido de Vendas
                        
Private nDesconto := 0 //Adriano - desconto que pode ser dado na geração do pedido de venda

Private nAcrescimo := 0 // Adriano - acréscimo

nTxUSD := Posicione("SM2",1,dtoS(dDatabase),"M2_MOEDA2")

cTes     := "504"   // Alexandre Santos - 24/07/2013 - De Para da TES     
// cTes     := "501"  


aAdd( aCombocor, "MARROM" )
aAdd( aCombocor, "BRANCA" )

AADD(aCampos,{"Z7_STATUS"  ,"C",TamSX3("Z7_STATUS")[1],0})
AADD(aCampos,{"Z7_CONTRA"  ,"C",TamSX3("Z7_CONTRA")[1],0})
AADD(aCampos,{"Z7_QTDE"    ,"N",TamSX3("Z7_QTDE")[1],3})
AADD(aCampos,{"Z7_MEDIA"   ,"C",TamSX3("Z7_MEDIA")[1],0})

// INCLUIR CAMPOS Z7_PRECO E Z7_VLFINAL

AADD(aCampos,{"Z7_PRECO"   ,"N",TamSX3("Z7_SALDO")[1],3})
AADD(aCampos,{"Z7_VLFINAL"   ,"N",TamSX3("Z7_SALDO")[1],3})

AADD(aCampos,{"Z7_EMISSAO" ,"D",TamSX3("Z7_EMISSAO")[1],0})
AADD(aCampos,{"Z7_SALDO"   ,"N",TamSX3("Z7_SALDO")[1],3})
AADD(aCampos,{"Z7_NAVIO"   ,"C",TamSX3("Z7_NAVIO")[1],0})
AADD(aCampos,{"Z7_BOOK"    ,"C",TamSX3("Z7_BOOK")[1],0}) 
AADD(aCampos,{"Z7_PERDE"    ,"C",TamSX3("Z7_PERDE")[1],0}) 

AADD(aCampos1,{"Z7_STATUS"  ,"","Status",""})
AADD(aCampos1,{"Z7_CONTRA"  ,"","Número do Contrato","@!"})
AADD(aCampos1,{"Z7_QTDE"    ,"","Quantidade Liberada","@e 999,999,999.999"})
AADD(aCampos1,{"Z7_MEDIA"   ,"","Media","@!"})
AADD(aCampos1,{"Z7_PRECO"   ,"","Vl Ponderado" ,"@E 999,999.999"})
AADD(aCampos1,{"Z7_VLFINAL"   ,"","Vl Final USD" ,"@E 999,999,999.999"})
AADD(aCampos1,{"Z7_EMISSAO" ,"","Data","@e 999,999,999.999"})
AADD(aCampos1,{"Z7_SALDO"   ,"","Saldo" ,"@E 999,999,999.999"})
AADD(aCampos1,{"Z7_NAVIO"  ,"","Navio","@!"})
AADD(aCampos1,{"Z7_BOOK"  ,"","Booking","@!"})
                                                                                              

cContra:=SZ7->Z7_CONTRA

DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo2) FROM  165,115 TO /*245*/750,500/*430*/ PIXEL        

@ 05,10 SAY OemToAnsi(cTitulo3) SIZE 60, 8 OF oDlg PIXEL
@ 05,70 MSGET oGet VAR cContra PICTURE "@!" SIZE 80,9 F3 "CN9" VALID ExistChav("CN9",cContra) .AND. NAOVAZIO() OF oDlg PIXEL 

@ 25,10 SAY "QTD. TONS.:" SIZE 60, 8 OF oDlg PIXEL
@ 25,70 MSGET oGet VAR n_Qtde  PICTURE "@e 999,999,999.999" SIZE 80,9 VALID n_Qtde>0 OF oDlg PIXEL        

@ 50,10 SAY "Navio" SIZE 60, 8 OF oDlg PIXEL
@ 50,70 MSGET oGet VAR cNavio  PICTURE "@!" SIZE 80,9 F3 "CTH" VALID cNavio<>'' .AND. U_BUSCABK(cNavio) OF oDlg PIXEL

@ 75,10 SAY "Booking" SIZE 60, 8 OF oDlg PIXEL
@ 75,70 MSGET oGet VAR cBooking PICTURE "@!" SIZE 80,9 VALID cBooking<>'' OF oDlg PIXEL       

@ 95,10 SAY "Cor da Embalagem" SIZE 60, 8 OF oDlg PIXEL
@ 95, 70 COMBOBOX oCombocor VAR cCorEmb ITEMS aCombocor SIZE 80,9 PIXEL OF oDlg PIXEL         


@ 115,10 SAY "Taxa USD:" SIZE 60, 8 OF oDlg PIXEL
@ 115,70 MSGET oGet VAR nTxUSD  PICTURE "@e 9,999,999.9999" SIZE 80,9 VALID nTxUSD>0 OF oDlg PIXEL             

//@ 140,10 SAY "Qtd.Containers:" SIZE 60, 8 OF oDlg PIXEL
//@ 140,70 MSGET oGet VAR nqtdcont  PICTURE "@e 999,999,999.999" SIZE 80,9 VALID nqtdcont>0 OF oDlg PIXEL     

@ 140,10 SAY "Armazém:" SIZE 60,8 OF oDlg PIXEL
@ 140,70 MSGET oGet VAR cArmazem  PICTURE "99" SIZE 10,9 VALID NAOVAZIO() .and. len(alltrim(cArmazem))>1 OF oDlg PIXEL   
                                                                  
@ 165,10 Say "TES:"  Pixel Of oDlg
@ 165,70 MSGet oGet Var cTES  size 050,10 Picture "@!" Size 052,10 F3 "SF4" VALID NAOVAZIO() OF oDlg PIXEL  
     
@ 180,10 SAY "Desconto:" SIZE 60, 8 OF oDlg PIXEL
@ 180,70 MSGET oGet VAR nDesconto  PICTURE "@e 999,999,999.999" SIZE 80,9 OF oDlg PIXEL     

@ 195,10 SAY "Acréscimo:" SIZE 60, 8 OF oDlg PIXEL
@ 195,70 MSGET oGet VAR nAcrescimo  PICTURE "@e 999,999,999.999" SIZE 80,9 OF oDlg PIXEL     

@ 210,10 Say "R.E.:"  Pixel Of oDlg
@ 210,70 MSGet oGet Var cRE  size 050,10 Picture "@!" Size 052,10 VALID cRe<>'' OF oDlg PIXEL  
       

DEFINE SBUTTON FROM 225, 070 TYPE 1 ACTION (if(!empty(cContra),oDlg:End(),)) ENABLE OF oDlg
DEFINE SBUTTON FROM 225, 123 TYPE 2 ACTION (cContra:="",oDlg:End(),nOpcTp := 2) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg


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
dbsetorder(1)
dbgotop()
SZ7->( dbSeek(xFilial("SZ7")+cContra ) )
//dbGoTop()
Do While !SZ7->(Eof()) .AND. SZ7->Z7_CONTRA == cContra    
    if SZ7->Z7_SALDO>0
  	   RecLock("TRB",.T.)
	   TRB->Z7_STATUS  := '  '
	   TRB->Z7_CONTRA  := SZ7->Z7_CONTRA
	   TRB->Z7_QTDE    := SZ7->Z7_QTDE
	   TRB->Z7_SALDO   := SZ7->Z7_SALDO
	   TRB->Z7_EMISSAO := SZ7->Z7_EMISSAO
	   TRB->Z7_MEDIA   := SZ7->Z7_MEDIA             
	   TRB->Z7_PRECO   := SZ7->Z7_PRECO
	   TRB->Z7_VLFINAL := SZ7->Z7_VLFINAL
	   TRB->Z7_NAVIO   := cNavio
	   TRB->Z7_BOOK    := cBooking
	   TRB->Z7_PERDE	:=SZ7->Z7_PERDE
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


Static Function b004GRV()
Local AvetM := {}

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



TRB->(Dbgotop())
ProcRegua(TRB->(Reccount()))

cCONTRA:=""
cPERIODO	:= ""
ndollar_dia := nTxUSD //Posicione("SM2",1,dtoS(dDatabase-1),"M2_MOEDA2")

While !TRB->(Eof())
	IncProc("Analisando ... Contrato: " +TRB->Z7_CONTRA) 
	If TRB->Z7_STATUS==cMarca   // se foi selecionado na markbrowse
	
	   cCONTRA  := TRB->Z7_CONTRA
	   cCHAVE   := TRB->Z7_CONTRA                  
	   cMEDIA   := TRB->Z7_MEDIA    
	   cPERIODO	:= TRB->Z7_PERDE
	
       // Adriano - SZ7 - É a tabela onde ficam armazenadas as médias e saldos disponíveis.
	   Dbselectarea("SZ7")
	   //DbSetOrder(2)   
	   //SZ7->( Dbseek(xFilial("SZ7")+cCHAVE+cMEDIA) )     
	    DbSetOrder(3)   
	   If Dbseek(xFilial("SZ7")+cCHAVE+cPERIODO+cMEDIA)
		   nVLFINAL := SZ7->Z7_VLFINAL                                                         
		   nVLMedia := SZ7->Z7_PRECO       
		   nPrepagto:= SZ7->Z7_PREMIO2
		   aVetM[1] += SZ7->Z7_QTDE
		   aVetM[2] += SZ7->Z7_SALDO               

		   nDesReal := Posicione("SZ5",1,xFilial("SZ5")+cCHAVE,"Z5_DESREAL")
	        
		   // 16/2/2011 - Adriano - A alteração abaixo foi necessária pra gerar o pedido de vendas em DÓLAR. (Troquei o valor do Dólar por 1)
		   //aVetM[3] =  (iif(nDesReal>0,(SZ7->Z7_VLFINAL*ndollar_dia)+nDesReal,(SZ7->Z7_VLFINAL*ndollar_dia)-(nDesReal*-1)))/20 // PRECO EM R$ PARA SEQUENCIA DO ERP
		   aVetM[3] =  (iif(nDesReal>0,((SZ7->Z7_VLFINAL-nDesconto)*1)/*+nDesReal*/,((SZ7->Z7_VLFINAL-nDesconto)*1)/*-(nDesReal*-1)*/))/U_EDFFATOR(SZ2->Z2_CODPRO) // PRECO EM R$ PARA SEQUENCIA DO ERP  // Alexandre Santos - 17/07/2013
		   //aVetM[3] =  (iif(nDesReal>0,((SZ7->Z7_VLFINAL-nDesconto)*1)/*+nDesReal*/,((SZ7->Z7_VLFINAL-nDesconto)*1)/*-(nDesReal*-1)*/))/20 // PRECO EM R$ PARA SEQUENCIA DO ERP  // Alexandre Santos - 17/07/2013
		   
		   aVetM[4] := cCHAVE
		   aVetM[5] := TRB->Z7_NAVIO
		   aVetM[6] := TRB->Z7_BOOK        
		   aVetM[7] := SZ7->Z7_PRECO
		   aVetM[8] := SZ7->Z7_VLFINAL-nDesconto
		   
		   //sacaria
	       //SZ2->( dbSetOrder(1) )
	       //SZ2->( dbSeek(xFilial("SZ2")+aVetM[4]) )
		              
		   cTpemb := Posicione("SB1",1,xFilial("SB1")+SZ2->Z2_CODPRO,"B1_SEGUM")
		   
		   
		   nSacos := (n_Qtde)/ U_EDFFATOR(SZ2->Z2_CODPRO)   // Alexandre Santos - 22/07/2013    
		   // nSacos := (n_Qtde * 1000)/ 50		            // Alexandre Santos - 22/07/2013    
		   
		   aVetM[9] := nSacos
	                   
	       aVetM[10] := cCorEmb  
	       aVetM[11] := cCHAVE
	   EndIf        
		
       /*
	   RecLock("SZ7" ,.F.) 
	   if SZ7->Z7_SALDO-n_Qtde=0
  	      SZ7->Z7_STATUS	:= "1"             
       endif
	   SZ7->Z7_SALDO   := SZ7->Z7_SALDO-n_Qtde //baixando saldo de produtos precificados por tonelada.Adriano
	   MsUnlock()
       */
       
       
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
//If dbSeek(xFilial("CNC")+cCONTRA)
//   cFORNEC :=CNC->CNC_CODIGO
//   cLOJAF  :=CNC->CNC_LOJA          
//   cCODPAG :=CNC->CNC_CODPAG           
//   //cCONTATO:=SUBSTR(CNC->CNC_NOME,1,15)
//Endif

      cFORNEC := Posicione("CN9",1,xFilial("CN9")+cCONTRA,"CN9_CLIENT")
      cLOJAF  := Posicione("CN9",1,xFilial("CN9")+cCONTRA,"CN9_LOJACL")
      cCODPAG := Posicione("SA1",1,xFilial("SA1")+cFORNEC+cLOJAF,"A1_CONDPAG") 
      IF EMPTY(cCODPAG)
         cCODPAG:="002"
      ENDIF
      
SZ2->( dbSetOrder(1) )
SZ2->( dbSeek(xFilial("SZ2")+aVetM[4]) )
// Criar o valor total com a media encontrada.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seta as variaveis de sistema para compra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nModulo := 2
cModulo := "COM"               

//cNumPed := GetSXENum( "SC5", "C5_NUM" )  
//ConfirmSx8()

dbSelectArea("SC5")
dbSetOrder(1)
MsSeek(xFilial("SC5")+"zzzzzz",.T.)
dbSkip(-1)
cNumPed := SC5->C5_NUM
If Empty(cNumPed)
   cNumPed := StrZero(1,Len(SC5->C5_NUM))
Else
   cNumPEd := Soma1(cNumPed)
EndIf

cPedido := cNumPed
//Default nMoeda := 1
nMoeda  := 1       
aItens  := {}                  
aCab    := {}

//cItem     := "0000"
//cItem := Soma1(cItem,4)  
cItem  := "01"                
LMSERROAUTO:=.F.

aCabec:={;	
				{"C5_NUM"	 ,cNumPed		,Nil},; // Numero do pedido
				{"C5_TIPO"	 ,"N"			,Nil},; // Tipo de pedido
				{"C5_TIPOCLI","R"			,Nil},; // Tipo do cliente
				{"C5_CLIENTE",cFornec    	,Nil},; // Codigo do cliente
				{"C5_LOJACLI",cLojaF     	,Nil},; // Loja do cliente
				{"C5_EMISSAO",dDatabase 	,Nil},; // Data de emissao
				{"C5_CONDPAG",cCodPag		,Nil},;
				{"C5_MOEDA"  ,2             ,Nil},; // MOEDA 2 É DÓLAR
				{"C5_MENPAD" ,"002"         ,Nil}}  // Codigo da condicao de pagamanto
  

	AAdd(aItens,{;
					{"C6_NUM"	 ,cNumped   				      ,Nil},; // Numero do Pedido
					{"C6_ITEM"   ,cItem			      	   	      ,Nil},; // Numero do Item no Pedido
					{"C6_PRODUTO",SZ2->Z2_CODPRO 		 	 	  ,Nil},; // Codigo do Produto
					{"C6_QTDVEN" ,n_Qtde*U_EDFFATOR(SZ2->Z2_CODPRO),Nil},; // Quantidade Vendida     // Alexandre Santos - 22/07/2013       				
					{"C6_PRCVEN" , aVetM[3] 					  ,Nil},; // Preco Unitario Liquido
					{"C6_VALOR"  , round(((n_Qtde*U_EDFFATOR(SZ2->Z2_CODPRO))*(aVetM[3])),2),Nil},; // Valor Total do Item    // Alexandre Santos - 22/07/2013    
					{"C6_ENTREG" ,dDataBase				 	      ,Nil},; // Data da Entrega
					{"C6_OBSITEM","Geração Automatica."		      ,Nil},; // Obs do Item                         
					{"C6_LOCAL"  , cArmazem                       ,Nil},; // Armazem
					{"C6_TES"    ,cTes						      ,Nil},; // Tipo de Entrada/Saida do Item
					{"C6_XCLVL"  ,cNavio					      ,Nil}}) // Classe de Valor  // 05/06/14 - Luís Felipe Nascimento

					//{"C6_QTDVEN" ,n_Qtde*20					   	  ,Nil},; // Quantidade Vendida	    // Alexandre Santos - 22/07/2013    							
					//{"C6_VALOR"  , round(((n_Qtde*20)*(aVetM[3])),2),Nil},; // Valor Total do Item	  // Alexandre Santos - 22/07/2013    				

		   
lMSErroAuto := .F.
MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabec,aItens,3)

If lMsErroAuto
	DisarmTransaction()
	MostraErro()
Else
	SC5->(dbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+cNumPed))
	IF !SC5->(EOF())
		RecLock( "SC5", .F.)
		SC5->C5_BAURE   := cRE
		SC5->C5_NAVIO   := cNAVIO
		SC5->C5_CONTRAT := cContra
		SC5->C5_NRMEDIA := cMEDIA
		
		*'yTTALO P MARTINS-INICIO--------'*
		SC5->C5_XPERIOD := cPERIODO
		*'yTTALO P MARTINS-FIM-----------'*        
		
		SC5->C5_BOOK    := cBooking
		SC5->C5_TAXAUSD := nTxUSD
		SC5->C5_MEDIA   := nVLMedia
		SC5->C5_VLFINAL := nVLFINAL //-nDesconto
		SC5->C5_QTDTON  := n_Qtde           
		
		SC5->C5_PREMIO2 := nPrepagto // PRÉ-PAGAMENTO      
		                              
		SC5->C5_DESCEXT := nDesconto  // Desconto extra concedido
		SC5->C5_ACREEXT := nAcrescimo // Acréscimo extra                        
		
		SC5->C5_RE      := cRE        // R.E. 
		
		
		SC5->(MsUnlock())
	ENDIF
	
	SC6->(dbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+cNumPed))
	DO WHILE !SC6->(EOF()) .and. cNumPed == SC6->C6_NUM   // 04/02/16 - Luis Felipe - Enquanto Pedido de Venda. 
  	   RecLock( "SC6", .F.)
  	   SC6->C6_XCLVL:=cNAVIO
   	   SC6->(MsUnlock())
	   SC6->(DBSKIP())
	ENDDO

	Dbselectarea("SZ7")
	//DbSetOrder(2)
	DbSetOrder(3)
	//SZ7->( Dbseek(xFilial("SZ7")+cCHAVE+cMEDIA) )
	If Dbseek(xFilial("SZ7")+cCHAVE+cPERIDO+cMEDIA)
		RecLock("SZ7" ,.F.)
		if SZ7->Z7_SALDO-n_Qtde=0
			SZ7->Z7_STATUS	:= "1"
		endif
		SZ7->Z7_SALDO   := SZ7->Z7_SALDO-n_Qtde //baixando saldo de produtos precificados por tonelada.Adriano
		MsUnlock()                                     
	Else
		Alert("Erro ao atualizar o saldo do contrato!")
	EndIf
   MSGALERT("PEDIDO DE VENDA GERADO: "+cNumPed)
	
ENDIF	
Return                                                        


