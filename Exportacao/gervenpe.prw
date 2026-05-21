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
//±±ºAlteração ³  Alexandre Santos - 22/07/2014 Alterado para tratar fator  º±±
//±±º          ³  de conversão atraves da função U_EDFFATOR(Par01)          º±±
//±±º          ³  Par01 - Código do produto                                 º±±   
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºAlteração ³ Alexandre Santos - 24/07/2013 - De Para da TES             º±±
//±±º          ³ De 005 Para 018                                            º±±
//±±º          ³ De 006 Para 006                                            º±±
//±±º          ³ De 008 Para 002                                            º±±
//±±º          ³ De 009 Para 017                                            º±±  
//±±º          ³ De 501 Para 504                                            º±±
//±±º          ³ De 506 Para 501                                            º±±
//±±º          ³ De 598 Para 507                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºAlteração ³  Luis Felipe      - 17/02/2013 Adicionado campo C6_UNSVEN  º±±
//±±º          ³  MSExecAuto.                                               º±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±ºAlteração ³  Luis Felipe      - 17/09/2014                             º±±
//±±º          ³  Atualizações nas tabelas de exportação EE6 e EE7 a Pedido º±±
//±±º          ³  da Monica Nascimento e Willian Pangaio.                   º±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±ºAlteração ³  Luis Felipe                                    17/12/15   º±±
//±±º          ³  RDM058 - Obrigatoriedade Tp Descon                        º±±
//±±º          ³  Prenchidos os campos EE7_IMPORT, EE7_IMLOJA, EE7_PRECOA   º±±
//±±º          ³  EE7_TPDESC do Pedido de  Exportação.                      º±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±ºAlteração ³  Luis Felipe                                    23/04/16   º±±
//±±º          ³  RDM057 - Atualização do Protheus 11.8                      º±±
//±±º          ³  Sistema passou a validar durante o processo de imput dos  º±±
//±±º          ³  pedidos de exportação o preenchimento do status do proces-º±±
//±±º          ³  so de exportação (EE7_STATUS).                            º±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±ºAlteração ³  Luis Felipe                                    03/05/16   º±±
//±±º          ³  Criado regitro de controle sobre o pedido de vendas a fim º±±
//±±º          ³  estorna o saldo do contrato sobre o item certo da SZ7.    º±±
//±±º          ³  nZ7REG         	                                        º±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß      

User Function GerVenPE(cAlias,nReg,nOpc)

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
					{ STR0004	,"U_vb045rw"	,0,3, ,.F.},;  //"Gerar Pedido"
					{ STR0008	,"U_vbau04Leg"	,0,4, ,.F.} }  //"Legenda"

cCadastro := STR0009
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as cores da MBrowse                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCores,{"Z7_STATUS == '  ' ","BR_VERDE"})     // A Gerar
Aadd(aCores,{"Z7_STATUS == '1 ' ","BR_VERMELHO"})  // Gerado Automatico
Aadd(aCores,{"Z7_STATUS == '2 ' ","BR_VERMELHO"})  // Gerado Manual

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Endereca para a funcao MBrowse                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

dbSelectArea("SZ7")
DbSeek( xFilial("SZ7") )
SET FILTER TO SZ7->Z7_SALDO > 0 //.AND. SZ7->Z7_TPCTO="002"                                            

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
User Function vbau04Leg()

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
User Function vb045rw()
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

Local oComboTran  := Nil 
Local aComboTran  := {}

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

Private cIncoterm := "FOB"
Private cViTransp:= AVKEY(GETMV("MV_ZZGPEVT"), "EE7_VIA")
Private cOrigem  := Space(3)
Private cDestino := Space(3)
Private cTpTrans := "1"
Private cEmbala  := Space(20)
Private nQtdEmba := 0
Private cCodForn  := GetNewPar("MV_XEDFFOR","000082")//"000082"
Private cLojaForn := GetNewPar("MV_XEDFLOJ","01")    //"01"
private cPais    := Space(3)
private cWHENOD := Space(3)
private cVia    := AVKEY(GETMV("MV_ZZGPEVT"), "EE7_VIA")
private cIdioma  := "INGLES-INGLES"
private nSelecao := 0
private cNForn := ""

private lExterior := .T.//VerExter()

nTxUSD := Posicione("SM2",1,dtoS(dDatabase),"M2_MOEDA2")

cTes     := "504"    // Alexandre Santos - 24/07/2013 - De Para da TES 
// cTes     := "501"   


aAdd( aCombocor, "MARROM" )
aAdd( aCombocor, "BRANCA" )

aAdd( aComboTran, "1=Cheio" )
aAdd( aComboTran, "2=Picados" )
aAdd( aComboTran, "3=Carga Solta" )

AADD(aCampos,{"Z7_STATUS"  ,"C",TamSX3("Z7_STATUS")[1],0})
AADD(aCampos,{"Z7_CONTRA"  ,"C",TamSX3("Z7_CONTRA")[1],0})
AADD(aCampos,{"Z7_PERDE"    ,"C",TamSX3("Z7_PERDE")[1],0})
AADD(aCampos,{"Z7_QTDE"    ,"N",TamSX3("Z7_QTDE")[1],3})
AADD(aCampos,{"Z7_MEDIA"   ,"C",TamSX3("Z7_MEDIA")[1],0})

//Campo de hora da geração 07/03/16 ENS

AADD(aCampos,{"Z7_CONTROL"   ,"C",TamSX3("Z7_CONTROL")[1],0})
AADD(aCampos,{"Z7_HORAGER"   ,"C",TamSX3("Z7_HORAGER")[1],0})

// INCLUIR CAMPOS Z7_PRECO E Z7_VLFINAL

AADD(aCampos,{"Z7_PRECO"   ,"N",TamSX3("Z7_SALDO")[1],3})
AADD(aCampos,{"Z7_VLFINAL"   ,"N",TamSX3("Z7_SALDO")[1],3})

AADD(aCampos,{"Z7_EMISSAO" ,"D",TamSX3("Z7_EMISSAO")[1],0})
AADD(aCampos,{"Z7_SALDO"   ,"N",TamSX3("Z7_SALDO")[1],3})
AADD(aCampos,{"Z7_NAVIO"   ,"C",TamSX3("Z7_NAVIO")[1],0})
AADD(aCampos,{"Z7_BOOK"    ,"C",TamSX3("Z7_BOOK")[1],0}) 
//AADD(aCampos,{"Z7_PERDE"    ,"C",TamSX3("Z7_PERDE")[1],0}) 

AADD(aCampos1,{"Z7_STATUS"  ,"","Status",""})
AADD(aCampos1,{"Z7_CONTRA"  ,"","Número do Contrato","@!"}) 
AADD(aCampos1,{"Z7_PERDE"  ,"","Período","@!"}) 
AADD(aCampos1,{"Z7_QTDE"    ,"","Quantidade Liberada","@e 999,999,999.999"})
AADD(aCampos1,{"Z7_MEDIA"   ,"","Media","@!"})
AADD(aCampos1,{"Z7_PRECO"   ,"","Vl Ponderado" ,"@E 999,999.999"})
AADD(aCampos1,{"Z7_VLFINAL"   ,"","Vl Final USD" ,"@E 999,999,999.999"})
AADD(aCampos1,{"Z7_EMISSAO" ,"","Data","@e 999,999,999.999"})
AADD(aCampos1,{"Z7_SALDO"   ,"","Saldo" ,"@E 999,999,999.999"})
AADD(aCampos1,{"Z7_NAVIO"  ,"","Navio","@!"})
AADD(aCampos1,{"Z7_BOOK"  ,"","Booking","@!"})
                                                                                              

cContra:=SZ7->Z7_CONTRA

dbSelectArea("SA2")
dbSetOrder(3)
If dbSeek( xFilial("SA2")+SM0->M0_CGC )

	cCodForn  := SA2->A2_COD
	cLojaForn := SA2->A2_LOJA

EndIf


DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo2) FROM 165,200 TO 600,990 PIXEL   

@ 05,10 SAY OemToAnsi(cTitulo3) SIZE 60, 8 OF oDlg PIXEL
@ 05,70 MSGET oGet VAR cContra PICTURE "@!" SIZE 80,9 F3 "CN9" VALID ExistCpo("CN9",cContra) .AND. NAOVAZIO() OF oDlg PIXEL // ExistChav("CN9",cContra)

@ 25,10 SAY "Qtd. TONS.:" SIZE 60, 8 OF oDlg PIXEL
@ 25,70 MSGET oGet VAR n_Qtde  PICTURE "@e 999,999,999.999" SIZE 80,9 VALID n_Qtde>0 OF oDlg PIXEL        

@ 50,10 SAY "Navio" SIZE 60, 8 OF oDlg PIXEL
@ 50,70 MSGET oGet VAR cNavio  PICTURE "@!" SIZE 80,9 F3 "CTH" VALID (cNavio<>'' .AND. ExistCpo("CTH", cNavio, 1) .and. Book())  OF oDlg PIXEL

@ 75,10 SAY "Booking" SIZE 60, 8 OF oDlg PIXEL
@ 75,70 MSGET oGet VAR cBooking PICTURE "@!" SIZE 80,9 VALID cBooking<>'' OF oDlg PIXEL       

/* 27/08/13 - Luís Felipe Nascimento
@ 95,10 SAY "Cor da Embalagem" SIZE 60, 8 OF oDlg PIXEL
@ 95, 70 COMBOBOX oCombocor VAR cCorEmb ITEMS aCombocor SIZE 80,9 WHEN .F. PIXEL OF oDlg PIXEL         
*/

@ 095,10 SAY "Taxa USD:" SIZE 60, 8 OF oDlg PIXEL
@ 095,70 MSGET oGet VAR nTxUSD  PICTURE "@e 9,999,999.9999" SIZE 80,9 VALID nTxUSD>0 OF oDlg PIXEL             

//@ 140,10 SAY "Qtd.Containers:" SIZE 60, 8 OF oDlg PIXEL
//@ 140,70 MSGET oGet VAR nqtdcont  PICTURE "@e 999,999,999.999" SIZE 80,9 VALID nqtdcont>0 OF oDlg PIXEL     

@ 115,10 SAY "Armazém:" SIZE 60,8 OF oDlg PIXEL
@ 115,70 MSGET oGet VAR cArmazem  PICTURE "99" SIZE 10,9 F3 "SZE_1" VALID (NAOVAZIO() .and. len(alltrim(cArmazem))>1) OF oDlg PIXEL   
                                                                  
@ 140,10 Say "TES:"  Pixel Of oDlg
@ 140,70 MSGet oGet Var cTES  size 050,10 Picture "@!" Size 052,10 F3 "SF4" VALID NAOVAZIO() OF oDlg PIXEL  
     
@ 165,10 SAY "Desconto :" SIZE 60, 8 OF oDlg PIXEL
@ 165,70 MSGET oGet VAR nDesconto  PICTURE "@e 999,999,999.999" SIZE 80,9 OF oDlg PIXEL     

@ 180,10 SAY "Acréscimo :" SIZE 60, 8 OF oDlg PIXEL
@ 180,70 MSGET oGet VAR nAcrescimo  PICTURE "@e 999,999,999.999" SIZE 80,9 OF oDlg PIXEL     

*'Yttalo P Martins-INICIO-------------------------------------------------------------------------------------------------------'*
*'Conforme MIT041, Esse campo deverá ser retirado pois nesse momento ainda não se tem informação de Registro de Exportação( RE).'*
/*
@ 210,10 Say "R.E.:"  Pixel Of oDlg
@ 210,70 MSGet oGet Var cRE  size 050,10 Picture "@!" Size 052,10 VALID cRe<>'' OF oDlg PIXEL   
*/
*'Yttalo P Martins-FIM----------------------------------------------------------------------------------------------------------'*


//campos novos

@ 05,200 SAY "Exportador:" SIZE 60, 8 OF oDlg PIXEL

@ 05,300 MSGET oGet VAR cCodForn PICTURE "@!" SIZE 80,9 F3 "SA2A" VALID ExistCpo("SA2",cCodForn,1) .AND. NAOVAZIO() WHEN lExterior OF oDlg PIXEL 

@ 25,200 SAY "Loja:" SIZE 60, 8 OF oDlg PIXEL
@ 25,300 MSGET oGet VAR cLojaForn  PICTURE "@!" SIZE 80,9 WHEN .F. OF oDlg PIXEL        

@ 50,200 SAY "Incoterm" SIZE 60, 8 OF oDlg PIXEL
@ 50,300 MSGET oGet VAR cIncoterm  PICTURE "@!" SIZE 80,9 F3 "SYJ" VALID ExistCpo("SYJ",cIncoterm) .AND. NAOVAZIO()  WHEN lExterior OF oDlg PIXEL

@ 75,200 SAY "Embalagem" SIZE 60, 8 OF oDlg PIXEL
@ 75,300 MSGET oGet VAR cEmbala PICTURE "@!" SIZE 80,9 F3 "EE5" VALID ExistCpo("EE5",cEmbala) .AND. NAOVAZIO()  WHEN lExterior OF oDlg PIXEL       

@ 95,200 SAY "Qtd na Embalagem" SIZE 60, 8 OF oDlg PIXEL
@ 95,300 MSGET oGet VAR nQtdEmba  PICTURE "@e 9,999,999.9999" SIZE 80,9 VALID nQtdEmba>0 .AND. nQtdEmba<=999999999999 WHEN lExterior OF oDlg PIXE         

@ 115,200 SAY "Via de Transporte" SIZE 60, 8 OF oDlg PIXEL
@ 115,300 MSGET oGet VAR cVia  PICTURE "@!" SIZE 80,9 F3 "SYQ2" VALID ExistCpo("SYQ",cVia) .AND. NAOVAZIO() WHEN lExterior OF oDlg PIXEL             

@ 140,200 SAY "Origem" SIZE 60,8 OF oDlg PIXEL
@ 140,300 MSGET oGet VAR cWHENOD  PICTURE "@!" SIZE 80,9 F3 "EY9" VALID ValOriDes(cWhenod) .AND. NAOVAZIO() WHEN lExterior OF oDlg PIXEL   
                                                                  
@ 165,200 Say "Destino"  Pixel Of oDlg
@ 165,300 MSGet oGet Var cDestino Picture "@!" Size 052,10 F3 "EY9" VALID ValOriDes(cDestino) .AND. NAOVAZIO() WHEN lExterior  OF oDlg PIXEL  

*'Yttalo P Martins-INICIO----------------------------------------------------------------------------------------------------'*
*'COnforme MIT041, campo foi alterado para combobox--------------------------------------------------------------------------'*
/*
@ 180,200 SAY "Tipo de Transp:" SIZE 60, 8 OF oDlg PIXEL
@ 180,300 MSGet oGet Var cTpTrans Picture "@!" Size 052,10 VALID NAOVAZIO() WHEN lExterior  OF oDlg PIXEL      
*/       
@ 180,200 SAY "Tipo de Transp:" SIZE 60, 8 OF oDlg PIXEL
@ 180,300 COMBOBOX oComboTran VAR cTpTrans ITEMS aComboTran SIZE 80,9 PIXEL OF oDlg PIXEL
*'Yttalo P Martins-FIM-------------------------------------------------------------------------------------------------------'*

// Criada validação no botão "OK" para verificar se o armazem possui saldo antes de enviar a integração, evitando erro "help C6_LOCAL"  03/03/16 ENS
SB2->(DbSetorder(1)) 
cProdu := "P"+SubStr(Alltrim(SZ7->Z7_CONTRA)+"-"+Alltrim(SZ7->Z7_PERDE),2,24) 
																   
// DEFINE SBUTTON FROM 200, 300 TYPE 1 ACTION (if(!empty(cContra),oDlg:End(),)) ENABLE OF oDlg     //225, 070 // ENS 03/03/16
DEFINE SBUTTON FROM 200, 300 TYPE 1 ACTION (if(!empty(cContra).and.SB2->(dbSeek(xFilial("SB2")+AvKey(cProdu,"B2_COD")+AvKey(cArmazem,"B2_LOCAL"))) ,oDlg:End(),MsgAlert("Contrato não preenchido ou Armazem não possui saldo"))) ENABLE OF oDlg     //225, 070
DEFINE SBUTTON FROM 200, 340 TYPE 2 ACTION (cContra:="",oDlg:End(),nOpcTp := 2) ENABLE OF oDlg  //225, 123
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
	   TRB->Z7_STATUS  	:= '  '
	   TRB->Z7_CONTRA  	:= SZ7->Z7_CONTRA
	   TRB->Z7_QTDE    	:= SZ7->Z7_QTDE
	   TRB->Z7_PERDE   	:= SZ7->Z7_PERDE
	   TRB->Z7_SALDO   	:= SZ7->Z7_SALDO
	   TRB->Z7_CONTROL  := SZ7->Z7_CONTROL // 03/04/16 ENS
       TRB->Z7_HORAGER  := SZ7->Z7_HORAGER // 03/04/16 ENS
	   TRB->Z7_EMISSAO 	:= SZ7->Z7_EMISSAO
	   TRB->Z7_MEDIA   	:= SZ7->Z7_MEDIA                
	   TRB->Z7_PRECO   	:= SZ7->Z7_PRECO
	   TRB->Z7_VLFINAL 	:= SZ7->Z7_VLFINAL
	   TRB->Z7_NAVIO   	:= cNavio
	   TRB->Z7_BOOK    	:= cBooking
	   TRB->Z7_PERDE   	:=SZ7->Z7_PERDE
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
// Regra: 1) Toda vez que é feito um pedido de compra é baixado o saldo dos produtos precificados.
//        
//


Static Function b004GRV()
Local AvetM := {}        
Local nFator  := 1 	  // Alexandre Santos - 22/07/2013 - Alteracao para retirar o valor pre-fixado 

LOCAL cCONTROL := ""
LOCAL XSEQPV   := ""
Local cZ7Reg   := Space(10)

aadd(aVetM, 0 )  // QUANTIDADE ORIGINAL
aadd(aVetM, 0 )  // QUANTIDADE SALDO
aadd(aVetM, 0 )  // MEDIA DE PRECO
aadd(aVetM, "" ) // Numero do Contrato
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
   	   cControle:= TRB->Z7_CONTROL // 04/03/16 ENS
	   dHoraGer := TRB->Z7_HORAGER // 04/03/16 ENS 
	   
	   cProduto := "P"+SubStr(Alltrim(TRB->Z7_CONTRA)+"-"+Alltrim(TRB->Z7_PERDE),2,24)  // 26/09/13 - Luís Felipe Nascimento  
	   
       // Adriano - SZ7 - É a tabela onde ficam armazenadas as médias e saldos disponíveis.
	   Dbselectarea("SZ7")
	   DbSetOrder(3)   
	   //If Dbseek(xFilial("SZ7")+cCHAVE+cPERIODO+cMEDIA)  04/03/16 ENS Hora da geração pois a chave anterior poderia se repetir 
	   If Dbseek(xFilial("SZ7")+cCHAVE+cPERIODO+cMEDIA+cControle+dHoraGer)
		   nVLFINAL := SZ7->Z7_VLFINAL                                                         
		   nVLMedia := SZ7->Z7_PRECO       
		   nPrepagto:= SZ7->Z7_PREMIO2
		   aVetM[1] += SZ7->Z7_QTDE
		   aVetM[2] += SZ7->Z7_SALDO               

		   nDesReal := Posicione("SZ5",1,xFilial("SZ5")+cCHAVE,"Z5_DESREAL")   
		   
//         nFator := U_EDFFATOR(SZ2->Z2_CODPRO) 	  // Alexandre Santos - 22/07/2013 - Alteracao para retirar o valor pre-fixado  
	       nFator :=  U_EDFFATOR(cProduto) // 26/09/13 - Luís Felipe 
	       
		   // 16/2/2011 - Adriano - A alteração abaixo foi necessária pra gerar o pedido de vendas em DÓLAR. (Troquei o valor do Dólar por 1)
		   //aVetM[3] =  (iif(nDesReal>0,(SZ7->Z7_VLFINAL*ndollar_dia)+nDesReal,(SZ7->Z7_VLFINAL*ndollar_dia)-(nDesReal*-1)))/20 // PRECO EM R$ PARA SEQUENCIA DO ERP
	   	   //aVetM[3] :=  (iif(nDesReal>0,((SZ7->Z7_VLFINAL-nDesconto)*1)/*+nDesReal*/,((SZ7->Z7_VLFINAL-nDesconto)*1)/*-(nDesReal*-1)*/))/nFator // PRECO EM R$ PARA SEQUENCIA DO ERP     // Luis Felipe Nascimento - 08/10/2013 
		   //aVetM[3] =  (iif(nDesReal>0,((SZ7->Z7_VLFINAL-nDesconto)*1)/*+nDesReal*/,((SZ7->Z7_VLFINAL-nDesconto)*1)/*-(nDesReal*-1)*/))/20 // PRECO EM R$ PARA SEQUENCIA DO ERP   // Alexandre Santos - 22/07/2013 
		   
//         14/10/15 - Luis Felipe Nascimento
// 	       If nFator <> 1.00
//		   		aVetM[3] :=  (iif(nDesReal>0,((SZ7->Z7_VLFINAL-nDesconto)*1)/*+nDesReal*/,((SZ7->Z7_VLFINAL-nDesconto)*1)/*-(nDesReal*-1)*/))*nFator // PRECO EM R$ PARA SEQUENCIA DO ERP     // Luis Felipe Nascimento - 08/10/2013 
//		   Else		
//		   		aVetM[3] :=  (iif(nDesReal>0,((SZ7->Z7_VLFINAL-nDesconto)*1)/*+nDesReal*/,((SZ7->Z7_VLFINAL-nDesconto)*1)/*-(nDesReal*-1)*/)) // PRECO EM R$ PARA SEQUENCIA DO ERP     // Luis Felipe Nascimento - 08/10/2013 
//		   EndIf		
		    
	   	   aVetM[3] :=  (SZ7->Z7_VLFINAL+nAcrescimo-nDesconto) * nFator // PRECO EM US$ // Luis Felipe Nascimento - 14/10/2015 - Simplificar a adicionar o acrescimo
		   aVetM[4] := cProduto
		   aVetM[5] := TRB->Z7_NAVIO
		   aVetM[6] := TRB->Z7_BOOK        
		   aVetM[7] := SZ7->Z7_PRECO
		   aVetM[8] := SZ7->Z7_VLFINAL-nDesconto
		   
		   //sacaria
	       //SZ2->( dbSetOrder(1) )
	       //SZ2->( dbSeek(xFilial("SZ2")+aVetM[4]) )
		              
		   cTpemb := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_SEGUM")
		   
		   nSacos := (n_Qtde / nFator)          // Luis Felipe Nascimento - 08/10/2013      
		   // nSacos := (n_Qtde * nFator)          // Alexandre Santos - 22/07/2013      
		   // nSacos := (n_Qtde * 1000)/ 50     // Alexandre Santos - 22/07/2013  		   
		   
		   aVetM[9] := nSacos
	                   
//	       aVetM[10] := cCorEmb   // 27/08/13 - Luís Felipe Nascimento
	       aVetM[11] := cCHAVE
	       
	       cCONTROL := SZ7->Z7_CONTROL
		   nZ7Reg   := SZ7->(Recno())  // 03/05/16 - Luis Felipe 
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
           
/*if n_Qtde>aVetM[1]
   msgalert("Quantidade não permitida!")
   Return Nil
endif*/

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

/* 14/07/17 - Luis Felipe - Atualização P12 
      cFORNEC := Posicione("CN9",1,xFilial("CN9")+cCONTRA,"CN9_CLIENT")
      cLOJAF  := Posicione("CN9",1,xFilial("CN9")+cCONTRA,"CN9_LOJACL")
*/
      //cFORNEC := Posicione("CNC",1,xFilial("CNC")+cCONTRA,"CNC_CLIENT")
      //cLOJAF  := Posicione("CNC",1,xFilial("CNC")+cCONTRA,"CNC_LOJACL")
      cFORNEC := Posicione("CN9",1,xFilial("CN9")+cCONTRA,"CN9_CLIENT")
      cLOJAF  := Posicione("CN9",1,xFilial("CN9")+cCONTRA,"CN9_LOJACL")
      cCODPAG := Posicione("SA1",1,xFilial("SA1")+cFORNEC+cLOJAF,"A1_CONDPAG") 
      IF EMPTY(cCODPAG)
         cCODPAG:="002"
      ENDIF
      
// SZ2->( dbSetOrder(1) )
// SZ2->( dbSeek(xFilial("SZ2")+aVetM[4]) )
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
                
nFator := U_EDFFATOR(cProduto) 	  // Alexandre Santos - 22/07/2013 - Alteracao para retirar o valor pre-fixado  

// {"C6_QTDVEN" ,n_Qtde*20					   	  ,Nil},; // Quantidade Vendida     // Alexandre Santos - 22/07/2013 
// {"C6_VALOR"  , round(((n_Qtde*20)*(aVetM[3])),2),Nil},; // Valor Total do Item	// Alexandre Santos - 22/07/2013 				

// 08/10/2013 - Luis Felipe Nascimento - n_Qtde*nFator p/ n_Qtde/nFator - Onde 297 Ton / 0,05 => 5940 SC´s

aCabec:={;	
				{"C5_NUM"	 ,cNumPed		,Nil},; // Numero do pedido
				{"C5_TIPO"	 ,"N"			,Nil},; // Tipo de pedido
				{"C5_TIPOCLI","R"			,Nil},; // Tipo do cliente
				{"C5_CLIENTE",cFornec    	,Nil},; // Codigo do cliente
				{"C5_LOJACLI",cLojaF     	,Nil},; // Loja do cliente
				{"C5_EMISSAO",dDatabase 	,Nil},; // Data de emissao
				{"C5_CONDPAG",cCodPag		,Nil},;
				{"C5_MOEDA"  ,2             ,Nil},; // MOEDA do Contrat0
				{"C5_MENPAD" ,"002"         ,Nil},; // Codigo da condicao de pagamanto
				{"C5_XSZ7REG" ,nZ7Reg       ,Nil}}  // 03/05/16 - Luis Felipe 
					
	AAdd(aItens,{;
					{"C6_NUM"	 ,cNumped   				      ,Nil},; // Numero do Pedido
					{"C6_ITEM"   ,cItem			      	   	      ,Nil},; // Numero do Item no Pedido
					{"C6_PRODUTO",cProduto 		 	 	  ,Nil},; // Codigo do Produto
					{"C6_QTDVEN" ,n_Qtde/nFator					   	  ,Nil},; // Quantidade Vendida      // Alexandre Santos - 22/07/2013 - Incluido nFator
					{"C6_PRCVEN" , aVetM[3] 					  ,Nil},; // Preco Unitario Liquido
					{"C6_VALOR"  , round(((n_Qtde/nFator)*(aVetM[3])),2),Nil},; // Valor Total do Item   // Alexandre Santos - 22/07/2013 - Incluido nFator  
					{"C6_ENTREG" ,dDataBase				 	      ,Nil},; // Data da Entrega
					{"C6_OBSITEM","Geração Automatica."		      ,Nil},; // Obs do Item                         
					{"C6_LOCAL"  , cArmazem                       ,Nil},; // Armazem
					{"C6_TES"    ,cTes						      ,Nil},; // Tipo de Entrada/Saida do Item
					{"C6_UNSVEN" ,n_Qtde       				      ,Nil},; // Qtd. Segum  17/02/14 Luis Felipe Nascimento
					{"C6_XCLVL"  ,aVetM[5]     				      ,Nil}}) // Qtd. Segum  14/07/17 Luis Felipe Nascimento
		   
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
		XSEQPV          := XSEQPVEXP()
		
		SC5->C5_XPERIOD := cPERIODO
		SC5->C5_XORIGEM := "GERVENPE"
		SC5->C5_XCONTRO := cCONTROL
		SC5->C5_XSEQPV  := XSEQPV
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
  	   
		*'yTTALO P MARTINS-INICIO--------'*
		SC6->C6_XSEQPV  := XSEQPV
		*'yTTALO P MARTINS-FIM-----------'*        		  	   
  	   
   	   SC6->(MsUnlock())
	   SC6->(DBSKIP())
	ENDDO

	Dbselectarea("SZ7")
	//DbSetOrder(2)
	DbSetOrder(3)
	//SZ7->( Dbseek(xFilial("SZ7")+cCHAVE+cMEDIA) )
	//If Dbseek(xFilial("SZ7")+cCHAVE+cPERIODO+cMEDIA) 07/03/16 Chave trocada pois poderia ser repedida ENS
	If Dbseek(xFilial("SZ7")+cCHAVE+cPERIODO+cMEDIA+cControle+dHoraGer)
		RecLock("SZ7" ,.F.)
		if SZ7->Z7_SALDO-n_Qtde=0
			SZ7->Z7_STATUS	:= "1"
		endif
		SZ7->Z7_SALDO   := SZ7->Z7_SALDO-n_Qtde //baixando saldo de produtos precificados por tonelada.Adriano
		MsUnlock()                                     
	Else
		Alert("Erro ao atualizar o saldo do contrato!")
	EndIf
	if lExterior == .T.
		cNForn := GetnForn() 
		aAuxFab := GetFabr()
		
		if U_SV_Gerpe(cNumPed, cIdioma, cIncoterm, cCodForn, cLojaForn, cNForn, cVia, cWhenOd, cDestino, cTpTrans, cPais, cEmbala, nQtdEmba, aAuxFab[1][2], aAuxFab[1][1])
			MSGALERT("PEDIDO DE EXPORTAÇÃO GERADO")
		endif
	endif                                     

    // 17/09/14 - Luis Felipe Nascimento - Inicio
   	EE6->(dbSetOrder(1))
    //	If !EE6->(DbSeek(xFilial("EE6")+Alltrim(CTH->CTH_VESSEL)))  
	iF !EE6->(DBSeek(xFilial("EE6")+AvKey(CTH->CTH_VESSEL,"EE6_COD"))) // CAMPOS COM TAMANHO DIFERENTE PARA EFETUAR O SEEK ENS
		RecLock("EE6",.T.)
		EE6->EE6_FILIAL := xFilial("EE6")
		EE6->EE6_COD 	:= CTH->CTH_VESSEL
		EE6->EE6_VIAGEM := "0"
		EE6->EE6_NOME 	:= CTH->CTH_VESSEL
		MsUnlock()
	EndIf

   	EE7->(dbSetOrder(1))
	If EE7->(DbSeek(xFilial("EE7")+cNumPed))
		RecLock("EE7",.F.)
		EE7->EE7_EMBAFI := cEmbala
		EE7->EE7_CONDPA := "001"
		EE7->EE7_MPGEXP := "003"
		EE7->EE7_MOEDA  := "US$"
		EE7->EE7_XNAVIO := CTH->CTH_VESSEL              // 23/05/16 ENS
		EE7->EE7_PAISET := SY9->Y9_PAIS    
		// 17/12/15 - Luis Felipe - RDM058 - Obrigatoriedade Tp Descon - Inicio
		EE7->EE7_IMPORT := cFORNEC
		EE7->EE7_IMLOJA := cLOJAF
		EE7->EE7_CLIENT := cFORNEC    // Obs.: Como a Man usa filiais para intermediar as vendas e o campo EE7_IMLOJA = Loja do  Cliente 
		EE7->EE7_CLLOJA := cLOJAF     // é sobreposto pelo campo EE7_CLLOJA no ato da canfirmação do Pedido de Venda de Exportação estou 
		EE7->EE7_PRECOA := "2"        // preenchedo este também. Caso não faça isso o campo EE7_IMLOJA precisa ser redigitado. 
		// EE7->EE7_TPDESC := "0"
		// 17/12/15 - Luis Felipe - RDM058 - Obrigatoriedade Tp Descon - Fim
		
		EE7->EE7_TPDESC := "1" // Tp Desconto não pode ser preenchido com 0 pois, existe validação nos fontes padrão 08/03/16 ENS
		EE7->EE7_IDIOMA := "INGLES-INGLES"
//		EE7->EE7_IDIOMA := "INGLES"
		EE7->EE7_STATUS := "B"        // 23/04/16 - Luis Felipe  
		MsUnlock()
	EndIf
    // 17/09/14 - Luis Felipe Nascimento - Inicio
	
	MSGALERT("PEDIDO DE VENDA GERADO: "+cNumPed)
	
ENDIF	
Return

Static Function VerExter()
local nOldArea := Select()
Local cCliente := CN9->CN9_CLIENT
Local cLoja    := CN9->CN9_LOJACL
local lRet     := .F.

dbSelectArea("SA1")
SA1->(dbGoTop())
SA1->(dbSeek(xFilial("SA1")+cCliente+cLoja))

if !SA1->(EOF())
	if SA1->A1_EST == 'EX'
		lRet := .T.
		cPais := SA1->A1_PAIS
	endif
endif

SA1->(dbCloseArea())
dbSelectArea(nOldArea)

return lRet

Static Function ValLoja(cForn, cLoja)
local nOldArea := Select()
local lRet     := .F.

dbSelectArea("SA2")
SA2->(dbGoTop())
SA2->(dbSeek(xFilial("SA2")+cForn+cLoja))

if !SA2->(EOF())
	if SA2->A2_COD == cForn .AND. SA2->A2_LOJA == cLoja

		lRet := .T.
	endif
endif

SA2->(dbCloseArea())
dbSelectArea(nOldArea)

return lRet

*------------------------------------------------------------------------------------------------------------------*
Static Function GetnForn()
local cNome := ""

dbSelectArea("SA2")    
SA2->(dbSeek(xFilial("SA2")+cCodForn+cLojaForn))

if !SA2->(EOF())
	cNome := SA2->A2_NOME
endif

return cNOme

*------------------------------------------------------------------------------------------------------------------*
Static Function GetFabr()
Local nOldArea := Select()
local aFabric := {}

dbSelectArea("CNC")
CNC->(dbSetOrder(1))
if CNC->(dbSeek(xFilial()+"B "+ALLTRIM(cContra)))
	AADD(aFabric,{CNC->CNC_LOJA , CNC->CNC_CODIGO})  
elseif CNC->(dbSeek(xFilial()+"B"+ALLTRIM(cContra)))
	AADD(aFabric,{CNC->CNC_LOJA , CNC->CNC_CODIGO}) 
elseif CNC->(dbSeek(xFilial()+ALLTRIM(cContra)))
	AADD(aFabric,{CNC->CNC_LOJA , CNC->CNC_CODIGO})        // 03/03/16 ENS
else
	AADD(aFabric,{"" , ""})
endif

dbSelectArea(nOldArea)

return aFabric
*------------------------------------------------------------------------------------------------------------------*
Static Function ValOriDes(cSigla)
local lret := .F.

dbSelectArea("SY9")    
dbSetOrder(2)
SY9->(dbSeek(xFilial("SY9")+cSigla))

if !SY9->(EOF()) .AND. SY9->Y9_SIGLA == cSigla
	lRet := .T.
endif

return lRet

***************************************************************************************************************************************************
*'YTTALO P MARTINS-INICIO-----------------------------------------------------------------------------------------'*
STATIC FUNCTION XSEQPVEXP()

LOCAL cQuery  := ""
LOCAL cProx   := STRZERO( 0,TAMSX3("C5_XSEQPV")[1] )
 
If Select("TMPSC5")>0
	dbSelectArea("TMPSC5")
	("TMPSC5")->(dbCloseArea())
EndIf	

cQuery := "SELECT MAX(C5_XSEQPV) AS C5_XSEQPV FROM "
cQuery += RetSqlName("SC5") + " SC5 "
//cQuery += "WHERE SC5.D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSC5",.F.,.T.)
DBSELECTAREA("TMPSC5")
("TMPSC5")->(DbGoTop())

IF ("TMPSC5")->(!EOF())
    
	IF EMPTY( ("TMPSC5")->C5_XSEQPV )
		cProx   := STRZERO( 0,TAMSX3("C5_XSEQPV")[1] )
	ELSE
		cProx   := Soma1( ("TMPSC5")->C5_XSEQPV )
	ENDIF

ELSE
	cProx   := STRZERO( 0,TAMSX3("C5_XSEQPV")[1] )
ENDIF

If Select("TMPSC5")>0
	dbSelectArea("TMPSC5")
	("TMPSC5")->(dbCloseArea())
EndIf	
		 
RETURN(cProx) 
*'YTTALO P MARTINS-FIM--------------------------------------------------------------------------------------------'*            

*' 17/09/14 - Luis Felipe Nascimento -----------------------------------------------------------------------------'*            
Static Function Book() 

cBooking := CTH->CTH_BOOKIN

Return .t.
*' 17/09/14 - Luis Felipe Nascimento -----------------------------------------------------------------------------'*   
