#Include "Protheus.Ch"

// NOTAS FISCAIS X TอTULOS
// FACRI
// ADRIANO MIGOTO PINTO    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELFIN01  บAutor  ณAlexandre Santos    บ Data ณ  19/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAltera็ใo ณ Alterado para tratar fator de conversใo atraves da fun็ใo  บฑฑ
ฑฑบ          ณ  U_EDFFATOR(Par01)                                         บฑฑ
ฑฑบ          ณ  Par01 - C๓digo do produto                                 บฑฑ 
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAltera็ใo ณ Alexandre Santos - 24/07/2013 - De Para da TES             บฑฑ
ฑฑบ          ณ De 005 Para 018                                            บฑฑ
ฑฑบ          ณ De 006 Para 006                                            บฑฑ
ฑฑบ          ณ De 008 Para 002                                            บฑฑ
ฑฑบ          ณ De 009 Para 017                                            บฑฑ  
ฑฑบ          ณ De 501 Para 504                                            บฑฑ
ฑฑบ          ณ De 506 Para 501                                            บฑฑ
ฑฑบ          ณ De 598 Para 507                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/   


User Function RELFIN01()
Local oVar1, oVar2, oVar3, oVar4, oVar5, oVar6, oVar7, oVar8, oVar9, oVar10, oBtnOk, oBtnCancel                                      

                      
Private oDlg, cCondic, cNatur, cNavio, cTes, cNFMAE, cContra, cContrato, nPedido, dDTvencto, nTXUSD, nqtdton, xNUMTIT, nVLFINAL
Private cCorEmb   := SPACE(20)       
Private aCombocor := {}  

aAdd( aCombocor, "Data Emissใo" )
aAdd( aCombocor, "Data Chegada" )
                                                                                                               
xNUMTIT  := "         "

cCondicao:= "   "
cCondic  := "   "

cNatureza:= "101001"
cNatur   := "101001"

cNavio   := "               "
cReferen := ""
cContrato:= ""
cTes     := "018"    // Alexandre Santos - 24/07/2013 - De Para da TES       
// cTes     := "005"    
cNFMAE   := space(09)
cContra  := "               "

cPedido  := "      "                  
                                                                                                      
dDTvencto:= ctod(space(08))

nTxusd   := 0
nqtdton  := 0

cFornece  := space(06)
dDtFecha1 := ctod(space(8))
dDtFecha2 := ctod(space(8))          

cnavio    := space(09)      

cMedia    := Space(1)


Define MSDialog oDlg Title OemToAnsi("Parโmtros para relat๓rio:") From 0,0 To 420,540 Pixel         
                                                                                    
    //@060,20 Say "Contrato:" Pixel Of oDlg
    //@060,90 MSGet oVar1  Var cContra Picture "@!" size 100,10  F3 "CN9" OF oDlg PIXEL
    
    //@075,20 Say "Nota Fiscal Mใe:"  Pixel Of oDlg
    //@075,90 MSGet oVar5  Var cNFMAE  size 008,10 Picture "999999999" Size 010,10 Pixel  Of oDlg
    
    @075,20 Say "Fornecedor:" Pixel Of oDlg
    @075,90 MSGet oVar1  Var cFornece Picture "@!" size 100,10  F3 "SA2" OF oDlg PIXEL
    
    @090,20 SAY "Contrato:" SIZE 60, 8 OF oDlg PIXEL
    @090,90 MSGET oVar1 VAR cContra PICTURE "@!" SIZE 80,9 F3 "CN9" VALID ExistChav("CN9",cContra) OF oDlg PIXEL 

    @115,20 SAY "Data de refer๊ncia:" SIZE 60, 8 OF oDlg PIXEL
    @115,90 COMBOBOX oCombocor VAR cCorEmb ITEMS aCombocor SIZE 80,9 PIXEL OF oDlg PIXEL         
                                                                                                                  	
    @130,20 Say "Data inicial:" Pixel Of oDlg                                                    
    @130,90 MSGet oVar7 Var dDTfecha1 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
    @145,20 Say "Data final:" Pixel Of oDlg                                                    
    @145,90 MSGet oVar7 Var dDTfecha2 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg          
    
    @160,20 Say "M้dia:" Pixel Of oDlg
    @160,90 MSGet oVar7 Var cMedia size 20,10 Pixel Of oDlg
    

    @180,20 Button oBtnOk     Prompt "&Imprime"       Size 30,15 Pixel Action (U_gerfin01(), oDlg:End()) Of oDlg
    @180,90 Button oBtnCancel Prompt "C&ancelar"       Size 30,15 Pixel Action ( oDlg:End(),lContinua := .F.) Cancel Of oDlg

Activate MSDialog oDlg Centered        

Return .T.                                                                               

User Function GerFIN01 // gera consulta para negocia็ใo com o fornecedor.          
Local aDados := {}
Local aCampos:= {}
Local aCabec := {}

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Pedidos"
Local cPict          := ""
Local titulo       := "Pedidos"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}                                                 
Local nFator       := 1 // Alexandre Santos 19/07/2013 - Tratamento do fator
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SC5"
Private cQuery  :=""
            

If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif


/*
SELECT E2_XPEDIDO, E2_NAVIO,E2_NFMAE, E2_NUM, E2_EMISSAO AS EMISSAO_NF, E2_VENCTO AS VENCTIMENTO,E2_QTDTON, E2_QTDTON*20 AS SACAS, E2_VALOR AS VL_TITULO, E2_VLORIG AS VL_ORIGINAL,  E2_PREPGR AS PRE_PAGTO_R$, E2_VALOR -E2_VLORIG AS COMPL_PRECO
FROM SE2010
WHERE E2_XPEDIDO<>''
ORDER BY E2_NAVIO
*/

cQuery:="SELECT E2_XPEDIDO,E2_FORNECE, E2_NAVIO,E2_NFMAE, E2_NUM, E2_EMISSAO, E2_VENCTO, "
cQuery+="E2_QTDTON, E2_QTDTON AS SACAS, E2_VALOR, E2_VLORIG,  E2_PREPGR, C7_PRODUTO, "       // Alexandre Santos 19/07/2013 
// cQuery+="E2_QTDTON, E2_QTDTON*20 AS SACAS, E2_VALOR, E2_VLORIG,  E2_PREPGR, "             // Alexandre Santos 19/07/2013 
cQuery+="E2_VALOR-E2_VLORIG AS COMPLEMENTO, C7_NRMEDIA "
cQuery+="FROM "+RetSqlname("SE2")+" "                                                                                
cQuery+="INNER JOIN "+RetSqlname("SC7")+" ON C7_NUM = E2_XPEDIDO "
IF !EMPTY(cFORNECE)
   cQuery+="WHERE E2_FORNECE='"+cFORNECE+"' "
ENDIF                                           
if !EMPTY(cMEDIA)
   cQuery+=" AND C7_NRMEDIA = '"+cMEDIA+"' "
endif                       
if !EMPTY(cCONTRA)
   cQuery+=" AND C7_CONTRAT = '"+cCONTRA+"' "
ENDIF
if cCorEmb="Data Emissใo"
   cQuery+=" AND E2_EMISSAO>='"+dtos(dDTfecha1)+"' AND E2_EMISSAO<='"+dtos(dDTfecha2)+"' AND E2_XPEDIDO<>'' AND E2_NFMAE<>'' AND "+Retsqlname("SE2")+".D_E_L_E_T_ = ' ' "
   cQuery+=" ORDER BY E2_NAVIO, E2_EMISSAO"
else
   cQuery+=" AND E2_DTCHEGA>='"+dtos(dDTfecha1)+"' AND E2_DTCHEGA<='"+dtos(dDTfecha2)+"' AND E2_XPEDIDO<>'' AND E2_NFMAE<>'' AND "+Retsqlname("SE2")+".D_E_L_E_T_ = ' ' "
   cQuery+=" ORDER BY E2_NAVIO, E2_DTCHEGA"
endif

cQuery := ChangeQuery(cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//wnrel := SetPrint(cString,wnrel,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

//If nLastKey == 27                      
//    dbclosearea("TRB")
//	Return
//Endif

//SetDefault(aReturn,cString)

//If nLastKey == 27
//    dbclosearea("TRB")
//   Return
//Endif

//nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
dbclosearea("TRB")

Return Nil
                             


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  10/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)    
Local aDados := {}
Local aCampos:= {}
Local aCabec := {}


Local nOrdem

//dbSelectArea(cString)
dbselectArea("TRB")
//dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbGoTop()                                                                                

nSacos  =0
nTons   =0
nvlusd  =0
nvlreal =0
nprepg  =0         
nttt    =0
                            
WTOTTIT  :=0
WTOTTITG :=0
WTOTNFMAE:=0


WNAVIO:=SPACE(10)

WTONS =0
WTONSG=0

WSACAS =0
WSACASG=0

WVALOR =0
WVALORG=0

WVALORO =0
WVALOROG=0    

WPREPG =0
WPREPGG=0

WCOMPL =0
WCOMPLG=0

AAdd(aCabec ,"Pedido")
AAdd(aCabec ,"Fornec.")
AAdd(aCabec ,"Navio")
AAdd(aCabec ,"N.F. Mใe")
AAdd(aCabec ,"Tํtulo NF")
AAdd(aCabec ,"Emissใo")
AAdd(aCabec ,"Vencimento")
AAdd(aCabec ,"Tons.")
AAdd(aCabec ,"Sacas")
AAdd(aCabec ,"Vl.Tํtulo")
AAdd(aCabec ,"Vl.NF Filha")
AAdd(aCabec ,"Pr้-Pagto")
AAdd(aCabec ,"Complemento")

While !EOF()

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   //If lAbortPrint
   //   @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
   //   Exit
   //Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   /*
   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      @7,00  PSAY "Pedido"
      @7,10  PSAY "Fornec."
      @7,18  PSAY "Navio"
      @7,30  PSAY "N.F. Mใe"
      @7,40  PSAY "Tํtulo NF"
      @7,50  PSAY "Emissใo"
      @7,65  PSAY "Vencimento"
      @7,80  PSAY "Tons."
      @7,94  PSAY "Sacas"
      @7,109 PSAY "Vl.Tํtulo"
      @7,124 PSAY "Vl.NF Filha"
      @7,140 PSAY "Pr้-Pagto"
      @7,154 PSAY "Complemento"
      nLin := 8
   Endif                    
   */       
   
   nFator := U_EDFFATOR(TRB->C7_PRODUTO) 	  // Alexandre Santos - 19/07/2013 - Alteracao para retirar o valor pre-fixado     
   
   WNAVIO:=TRB->E2_NAVIO
   
   WTONS +=TRB->E2_QTDTON
   WTONSG+=TRB->E2_QTDTON
   
   WSACAS +=TRB->SACAS*nFator   // Alexandre Santos - 19/07/2013
   WSACASG+=TRB->SACAS*nFator   // Alexandre Santos - 19/07/2013
   //WSACAS +=TRB->SACAS   // Alexandre Santos - 19/07/2013
   //WSACASG+=TRB->SACAS   // Alexandre Santos - 19/07/2013
   
   WVALOR +=TRB->E2_VALOR
   WVALORG+=TRB->E2_VALOR
   
   WVALORO +=TRB->E2_VLORIG
   WVALOROG+=TRB->E2_VLORIG
                       
   WPREPG +=TRB->E2_PREPGR
   WPREPGG+=TRB->E2_PREPGR
   
   WCOMPL +=TRB->COMPLEMENTO
   WCOMPLG+=TRB->COMPLEMENTO

   //@nLin,00   PSAY TRB->E2_XPEDIDO
   //@nLin,10   PSAY TRB->E2_FORNECE
   //@nLin,18   PSAY SUBSTR(TRB->E2_NAVIO,1,11)
   //@nLin,30   PSAY TRB->E2_NFMAE
   //@nLin,40   PSAY TRB->E2_NUM
   //@nLin,50   PSAY TRB->E2_EMISSAO
   //@nLin,65   PSAY TRB->E2_VENCTO  
   //@nLin,80   PSAY TRANSFORM(TRB->E2_QTDTON  ,"@E 999,999,999.99")
   //@nLin,94   PSAY TRANSFORM(TRB->SACAS      ,"@E 999,999,999.99")
   //@nLin,109  PSAY TRANSFORM(TRB->E2_VALOR   ,"@E 999,999,999.99")
   //@nLin,124  PSAY TRANSFORM(TRB->E2_VLORIG  ,"@E 999,999,999.99")
   //@nLin,140  PSAY TRANSFORM(TRB->E2_PREPGR  ,"@E 999,999,999.99")
   //@nLin,154  PSAY TRANSFORM(TRB->COMPLEMENTO,"@E 999,999,999.99")
   
   AADD(aDados,{TRB->E2_XPEDIDO,TRB->E2_FORNECE,SUBSTR(TRB->E2_NAVIO,1,11),TRB->E2_NFMAE,TRB->E2_NUM,TRB->E2_EMISSAO,TRB->E2_VENCTO,TRANSFORM(TRB->E2_QTDTON  ,"@E 999,999,999.99"),TRANSFORM(TRB->SACAS,"@E 999,999,999.99"),TRANSFORM(TRB->E2_VALOR   ,"@E 999,999,999.99"),TRANSFORM(TRB->E2_VLORIG  ,"@E 999,999,999.99"),TRANSFORM(TRB->E2_PREPGR  ,"@E 999,999,999.99"),TRANSFORM(TRB->COMPLEMENTO,"@E 999,999,999.99")})
   
   TRB->(DBSKIP())
   if TRB->E2_NAVIO<>WNAVIO
      AADD(aDados,{"","","","","","","",TRANSFORM(WTONS   ,"@E 999,999,999.99"),TRANSFORM(WSACAS  ,"@E 999,999,999.99"),TRANSFORM(WVALOR  ,"@E 999,999,999.99"),TRANSFORM(WVALORO ,"@E 999,999,999.99"),TRANSFORM(WPREPG  ,"@E 999,999,999.99"),TRANSFORM(WCOMPL  ,"@E 999,999,999.99")})
      /*
      nLin := nLin + 1 // Avanca a linha de impressao
      @nLin,80   PSAY "--------------"
      @nLin,94   PSAY "--------------"
      @nLin,109  PSAY "--------------"
      @nLin,124  PSAY "--------------"
      @nLin,140  PSAY "--------------"
      @nLin,154  PSAY "--------------"
      nLin := nLin + 1 // Avanca a linha de impressao
      @nLin,80   PSAY TRANSFORM(WTONS   ,"@E 999,999,999.99")
      @nLin,94   PSAY TRANSFORM(WSACAS  ,"@E 999,999,999.99")
      @nLin,109  PSAY TRANSFORM(WVALOR  ,"@E 999,999,999.99")
      @nLin,124  PSAY TRANSFORM(WVALORO ,"@E 999,999,999.99")
      @nLin,140  PSAY TRANSFORM(WPREPG  ,"@E 999,999,999.99")
      @nLin,154  PSAY TRANSFORM(WCOMPL  ,"@E 999,999,999.99")
      nLin := nLin + 1 // Avanca a linha de impressao
      */
      WNAVIO  = SPACE(10)
      WTONS   = 0
      WSACAS  = 0
      WVALOR  = 0
      WVALORO = 0
      WPREPG  = 0
      WCOMPL  = 0
      
   ENDIF
   
   //nLin := nLin + 1 // Avanca a linha de impressao

   
EndDo
/*
nLin := nLin + 1 // Avanca a linha de impressao
@nLin,80   PSAY "--------------"
@nLin,94   PSAY "--------------"
@nLin,109  PSAY "--------------"
@nLin,124  PSAY "--------------"
@nLin,140  PSAY "--------------"
@nLin,154  PSAY "--------------"
nLin := nLin + 1 // Avanca a linha de impressao
@nLin,80   PSAY TRANSFORM(WTONSG   ,"@E 999,999,999.99")
@nLin,94   PSAY TRANSFORM(WSACASG  ,"@E 999,999,999.99")
@nLin,109  PSAY TRANSFORM(WVALORG  ,"@E 999,999,999.99")
@nLin,124  PSAY TRANSFORM(WVALOROG ,"@E 999,999,999.99")
@nLin,140  PSAY TRANSFORM(WPREPGG  ,"@E 999,999,999.99")
@nLin,154  PSAY TRANSFORM(WCOMPLG  ,"@E 999,999,999.99") 
*/
AADD(aDados,{"","","","","","","",TRANSFORM(WTONSg   ,"@E 999,999,999.99"),TRANSFORM(WSACASg  ,"@E 999,999,999.99"),TRANSFORM(WVALORg  ,"@E 999,999,999.99"),TRANSFORM(WVALOROg ,"@E 999,999,999.99"),TRANSFORM(WPREPGg  ,"@E 999,999,999.99"),TRANSFORM(WCOMPLg  ,"@E 999,999,999.99")})

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()
*/

DlgToExcel( { { "ARRAY", "Relat๓rio", aCabec, aDados} })                                  


Return
