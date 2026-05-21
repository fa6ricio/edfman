#INCLUDE "PROTHEUS.CH"

USER FUNCTION GERA_INVOICE()       

Private cAlias := "SE1"
Private aRotina   := {}
Private lRefresh  := .T.
Private cCadastro := "Contas a Receber"
Private aButtons := {}
Private oMenu


aAdd( aRotina, {"Pesquisar" ,"AxPesqui",0,1} )
aAdd( aRotina, {"Visualizar","AxVisual",0,2} )
aAdd( aRotina, {"Invoice"   ,"u_impinvo",0,5} )

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(,,,,cAlias)

Return Nil


USER FUNCTION impinvo           
Local oWord     := Nil
Local cTitulo1 := "Selecione o arquivo"
Local cExtens   := "Modelo Word | *.dot"
Local cFileOpen := ""
Local cFileSave := ""        
Local cMainPath := ""


Local nOpca     := 0
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
Local oPanelDados      

Private cContra := Space(TamSX3("CN9_NUMERO")[1])       
Private cNavio  := SPACE(10)
Private cBooking:= SPACE(20)    
Private n_Qtde  := 0 
Private cCorEmb := SPACE(20)          
Private nTxUSD  := 0                    
Private nqtdcont:= 0   
Private cArmazem:= SPACE(02)              
Private cMarca  := GetMark()          
Private cINVOICE:= space(20)    
Private cNOMENAVIO:=space(30)        
Private cCod    := space(3)                 
PRIVATE cAGENCIA:=SPACE(5)
PRIVATE cCONTA:=SPACE(10)   
PRIVATE cNOMBAN:=SPACE(40)
PRIVATE cSWIFT:=SPACE(15)

                     
cInvoice:=SE1->E1_NUM+space(6)
lContinua := .F.

DEFINE MSDIALOG oDlg TITLE OemtoAnsi(cTitulo2) FROM  165,115 TO 500,500 PIXEL        

@ 05,10 SAY "Invoice" SIZE 60, 8 OF oDlg PIXEL
@ 05,70 MSGET oGet VAR cINVOICE  PICTURE "@!" SIZE 80,9 VALID cINVOICE<>'' OF oDlg PIXEL

@ 25,10 SAY "Quantidade:" SIZE 60, 8 OF oDlg PIXEL
@ 25,70 MSGET oGet VAR n_Qtde  PICTURE "@e 999,999,999.999" SIZE 80,9 VALID n_Qtde>0 OF oDlg PIXEL          

@ 40,10 SAY "Banco" SIZE 60, 8 OF oDlg PIXEL
@ 40,70 MSGET oGet VAR cCOD  PICTURE "@!" SIZE 80,9 F3 "SA6" VALID cCod<>'' OF oDlg PIXEL    

@ 55,10 SAY "Agência" SIZE 60, 8 OF oDlg PIXEL
@ 55,70 MSGET oGet VAR cAGENCIA  PICTURE "@!" SIZE 80,9 VALID cAGENCIA<>'' OF oDlg PIXEL

@ 70,10 SAY "Conta" SIZE 60, 8 OF oDlg PIXEL
@ 70,70 MSGET oGet VAR cCONTA  PICTURE "@!" SIZE 80,9 VALID cCONTA<>'' OF oDlg PIXEL

DEFINE SBUTTON FROM 85, 070 TYPE 1 ACTION (lContinua := .T., oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 85, 123 TYPE 2 ACTION (cContra:="",oDlg:End(),lContinua := .F.) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg

If empty(cINVOICE) .OR. !lContinua
   Msgalert("Cancelado pelo Operador")
   Return
Endif                     

cNavio :=SE1->E1_NAVIO  
cContra:=SE1->E1_CONTRA
cPEDIDO:=SE1->E1_PEDIDO
                    
DBSELECTAREA("CTH")
DBSETORDER(1)
DBSEEK(xFILIAL("CTH")+cNavio)
IF !CTH->(EOF())                                                         
   cNOMENAVIO:=CTH->CTH_VESSEL 
   cFILEPARIS:=" - " + CTH->CTH_FILENU
ENDIF  

DBSELECTAREA("SA6")
DBSETORDER(1)
DBSEEK(xFilial("SA6")+cCOD+cAGENCIA+cCONTA)
IF !SA6->(EOF())        
   cNOMBAN:=SA6->A6_NOME
   cSWIFT :=SA6->A6_SWIFT
   cBancocor:=SA6->A6_BCCORRE
   cswiftcor:=SA6->A6_SWIFTC
   ccontacor:=SA6->A6_CTCORRE
   cabacor  :=SA6->A6_ABACORR
ENDIF
                    
                    
cQUERY:="SELECT C6_NUM, B1_COD, B1_PRODING FROM "+RETSQLNAME("SC6")+" "
cQUERY+=" INNER JOIN "+RETSQLNAME("SB1")+" ON  B1_COD=C6_PRODUTO "
cQUERY+=" WHERE C6_NUM='"+cPEDIDO+"' AND "
cQuery+=Retsqlname("SC6")+".D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbselectarea("TRB")   
dbgotop()
cPRODUTO:=""
IF !TRB->(EOF())
   cPRODUTO:=TRB->B1_PRODING
ENDIF
dbclosearea("TRB")             
             
                   
DBSELECTAREA("SE1")

oWord:=OLE_CreateLink()

//Alimentando documento

If SE1->E1_PREMIO2>0
   OLE_NewFile(oWord,"C:\INVOICE.dot")   
Else
   OLE_NewFile(oWord,"C:\INVOICE1.dot")   
EndIf   

//e:\protheus10tst\protheus_data\systemtst\arqdot\INVOICE.dot
//\\SRVDB\SmartClient\TotvsSmartClient.exe -m
OLE_SetDocumentVar(oWord,"INVOICE", "CI "+ALLTRIM(STR(VAL(cINVOICE),15)))  //cINVOICE)          
OLE_SetDocumentVar(oWord,"NOME_NAVIO", cNOMENAVIO)
OLE_SetDocumentVar(oWord,"E1_NAVIO", SE1->E1_NAVIO) 
OLE_SetDocumentVar(oWord,"FILEPARIS", cFILEPARIS)
OLE_SetDocumentVar(oWord,"QUANTIDADE",Transform(n_Qtde,"@E 999,999,999.99")+" METRIC TONS OF "+cPRODUTO)
OLE_SetDocumentVar(oWord,"CONTRATO",SE1->E1_CONTRA)            

dbSelectArea("CN9")
dbSetOrder(1)
If dbSeek(xFilial("CN9")+SE1->E1_CONTRA,.F.)
   OLE_SetDocumentVar(oWord,"REFERENCIA",(" -  "+CN9->CN9_REFCON))
EndIf

DBSELECTAREA("SE1")
                                                                       
OLE_SetDocumentVar(oWord,"DATA",DATE())

OLE_SetDocumentVar(oWord,"QTD1",Transform(n_Qtde,"@E 999,999,999.99")+" METRIC TONS") //PASSAR A QUANTIDADE INFORMADA NOS PARÂMETROS

OLE_SetDocumentVar(oWord,"VLFINAL",Transform(SE1->E1_VLFINAL,"@E 999,999,999.99")+" PER MT")   

If SE1->E1_PREMIO2>0

   OLE_SetDocumentVar(oWord,"VLTOTAL",Transform(SE1->E1_VLFINAL * n_Qtde,"@E 999,999,999.99"))

   OLE_SetDocumentVar(oWord,"PRE_PAGTO",Transform(SE1->E1_PREMIO2,"@E 999,999,999.99")+" PER MT")    

   OLE_SetDocumentVar(oWord,"TOTALPRE",Transform(SE1->E1_PREMIO2 * n_Qtde,"@E 999,999,999.99"))

EndIf

OLE_SetDocumentVar(oWord,"TOTAL_INVOICE",Transform((SE1->E1_VLFINAL * n_Qtde)-(SE1->E1_PREMIO2 * n_Qtde),"@E 999,999,999.99"))            

OLE_SetDocumentVar(oWord,"METODO1"," "+cNOMBAN)
OLE_SetDocumentVar(oWord,"METODO2"," SWIFT: "+cSWIFT)       
OLE_SetDocumentVar(oWord,"BANCOCORR", "CORR. BANK: " + cBancocor)       
OLE_SetDocumentVar(oWord,"SWIFTCOR", "CORR. SWIFT: " + cswiftcor)       
OLE_SetDocumentVar(oWord,"CONTACOR", "CORR. ACCOUNT NR.: " + ccontacor)       
OLE_SetDocumentVar(oWord,"ABA"     , "ABA: " + cabacor)       
OLE_SetDocumentVar(oWord,"METODO3"," IN FAVOUR OF BAUCHE ENERGY BRASIL TRADING SA")
OLE_SetDocumentVar(oWord,"METODO4"," ACCOUNT NR.: "+cCONTA)
OLE_SetDocumentVar(oWord,"METODO5"," BRANCH: "+cAGENCIA)

OLE_Updatefileds(oWord)

IF MSGYESNO("Fecha?")
   OLE_CloseFile(oWord)
   OLE_CloseLink(oWord)     
ENDIF     

Return
