#Include "Protheus.Ch"
//Posição contratos
               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Relogis5  ºAutor  ³Alexandre Santos    º Data ³  19/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³ Alterado para tratar fator de conversão atraves da função  º±±
±±º          ³  U_EDFFATOR(Par01)                                         º±±
±±º          ³  Par01 - Código do produto                                 º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³ Alexandre Santos - 24/07/2013 - De Para da TES             º±±
±±º          ³ De 005 Para 018                                            º±±
±±º          ³ De 006 Para 006                                            º±±
±±º          ³ De 008 Para 002                                            º±±
±±º          ³ De 009 Para 017                                            º±±  
±±º          ³ De 501 Para 504                                            º±±
±±º          ³ De 506 Para 501                                            º±±
±±º          ³ De 598 Para 507                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   


User Function Relogis5()
Local oVar1, oVar2, oVar3, oVar4, oVar5, oVar6, oVar7, oVar8, oVar9, oVar10, oBtnOk, oBtnCancel                                      
                      
Private oDlg, cCondic, cNatur, cNavio, cTes, cNFMAE, cContra, cContrato, nPedido, dDTvencto, nTXUSD, nqtdton, xNUMTIT, nVLFINAL
Private cCorEmb   := SPACE(20)       
Private aCombocor := {}  
xNUMTIT  := "         "
cCondicao:= "   "
cCondic  := "   "
cNatureza:= "101001"
cNatur   := "101001"
cNavio   := "               "
cReferen := ""
cContrato:= ""
cTes     := "018"   // Alexandre Santos - 24/07/2013 - De Para da TES
//cTes     := "005"            
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
cContra  := "               "
                           
aAdd( aCombocor, "Data Emissão" )
aAdd( aCombocor, "Data Chegada" )

Define MSDialog oDlg Title OemToAnsi("Parâmetros para relatório:") From 0,0 To 420,540 Pixel         
    
    //@015,20 Say "Fornecedor:" Pixel Of oDlg
    //@015,90 MSGet oVar1  Var cFornece Picture "@!" size 100,10  F3 "SA2" OF oDlg PIXEL

    //@040,20 Say "Pedido: " Pixel Of oDlg                                                    
    //@040,90 MSGet oVar6  Var cPEDIDO  size 036,10 Picture "@!" Size 38,10 F3 "SC7" VALID U_VER_PEDIDO(cPEDIDO) Pixel  Of oDlg              

    //@065,20 Say "Nota Fiscal Mãe:"  Pixel Of oDlg
    //@065,90 MSGet oVar5  Var cNFMAE  size 008,10 Picture "@!" Size 010,10 Pixel  Of oDlg
                     
    @015,20 SAY "Contrato:" SIZE 60, 8 OF oDlg PIXEL
    @015,90 MSGET oVar2 VAR cContra PICTURE "@!" SIZE 80,9 F3 "CN9" OF oDlg PIXEL 
    
    //@115,20 SAY "Data de referência:" SIZE 60, 8 OF oDlg PIXEL
    //@115,90 COMBOBOX oCombocor VAR cCorEmb ITEMS aCombocor SIZE 80,9 PIXEL OF oDlg PIXEL         

    //@130,20 Say "Data inicial:" Pixel Of oDlg                                                    
    //@130,90 MSGet oVar7 Var dDTfecha1 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
    //@145,20 Say "Data final:" Pixel Of oDlg                                                    
    //@145,90 MSGet oVar7 Var dDTfecha2 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
    @180,20 Button oBtnOk     Prompt "&Consulta"       Size 30,15 Pixel Action (U_gerlog05(), oDlg:End()) Of oDlg
    @180,90 Button oBtnCancel Prompt "C&ancelar"       Size 30,15 Pixel Action ( oDlg:End(),lContinua := .F.) Cancel Of oDlg

Activate MSDialog oDlg Centered        

Return .T.                                                                               

user Function Gerlog05
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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

Private cString    := "SC5"
Private cQuery     :=""

Private cTPCTO     :="C" //C=Compra, V=Venda

If Empty(cContra)
   Return Nil
endif

dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9")+cContra)
If !CN9->(EOF())                            
   If CN9->CN9_TPCTO="001"
      cTPCTO     :="C"
   ElseIf CN9->CN9_TPCTO="002"
      cTPCTO     :="V"   
   Endif
Else 
   Return Nil
EndIf

/*
If Select("TRB") > 0
	TRB->(dbCloseArea())
Endif        

cQuery:="SELECT"
cQuery+=" F1_NAVIO AS Navios, F1_NFMAE AS NF_Venda, F1_DOC AS NF_Remessa, F1_CONTRA AS CONTRATO, F1_XPEDIDO AS PEDIDO, "
cQuery+=" F1_EMISSAO AS EMISSAO,F1_DTCHEGA AS CHEGADA,D1_QUANT AS SACAS, D1_QUANT/20 AS TONS, C7_COREMB AS SACARIA, "
cQuery+=" C7_MEDIA AS MEDIA,C7_VLFINAL-C7_MEDIA AS PREMIO, C7_VLFINAL AS VL_FINAL, D1_FALTAS AS FALTAS, D1_AVARIAS AS AVARIAS, D1_SOBRAS AS SOBRAS,"
cQuery+=" (D1_QUANT/20)*C7_VLFINAL AS VL_LIQ, Z5_DESREAL AS DESC_REAL, Z5_DESREAL*D1_QUANT VALOR_REAIS, D1_LOCAL AS TERMINAL, F1_XNOMFOR "
cQuery+=" FROM "+RetSqlname("SF1")
cQuery+=" INNER JOIN "+RetSqlname("SD1")+" ON D1_DOC        = F1_DOC"
cQuery+=" INNER JOIN "+RetSqlname("SC7")+" ON C7_NUM        = F1_XPEDIDO"
cQuery+=" INNER JOIN "+RetSqlname("SZ5")+" ON Z5_CONTRA     = F1_CONTRA"
cQuery+=" WHERE"                 
cQuery+=" AND C7_CONTRAT = '"+cCONTRA+"' "

cQuery+=" ORDER BY F1_EMISSAO, F1_XNOMFOR, F1_CONTRA, D1_LOCAL "

cQuery := ChangeQuery(cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)



dbselectarea("TRB")  
*/

AAdd(aCabec ,"Contratos")             
AAdd(aDados ,{"Fornecedor(es) "," "," "," "," "," "," "," ","","",""," "," "," "})
                                                                       
// CRIADO DAVI JESUS PARA FILTRAR OS FORNECEDORES 
cForCTR := ""

dbSelectArea("CNC")
dbSetOrder(1)
dbseek(xFilial("CNC")+cContra)
Do While !CNC->(EOF()) .AND. CNC->CNC_NUMERO==cContra
   AAdd(aDados ,{CNC->CNC_CODIGO,Posicione("SA2",1,xFilial("SA2")+CNC->CNC_CODIGO+CNC->CNC_Loja,"A2_NOME") ," "," "," "," "," "," ","","",""," "," "," "})
   cForCTR += SA2->A2_COD
   CNC->(dbSkip())
Enddo   

AAdd(aDados ,{" "," "," "," "," "," "," "," ","","",""," "," "," "})


/*
AAdd(aCabec ,"Navios")
AAdd(aCabec ,"Fornecedor")
AAdd(aCabec ,"Pedidos")
AAdd(aCabec ,"NF Vendas")
AAdd(aCabec ,"NF Remessas")
AAdd(aCabec ,"Sacas")         
AAdd(aCabec ,"Terminal")     
AAdd(aCabec ,"Dt.Emissão")
AAdd(aCabec ,"Dt.Chegada")   
AAdd(aCabec ,"Sacaria")
AAdd(aCabec ,"Faltas")
AAdd(aCabec ,"Avarias")
AAdd(aCabec ,"Sobras")
*/
  
/*
if len(aCampos)=0
   msgalert("aCampos vazio")        
   TRB->(dbcloseArea())
   Return
endif

dbselectarea("TRB")  

dbGoTop()                 
if TRB->(EOF())
   msgalert("query vazia")
   TRB->(dbcloseArea())
   Return
endif
*/
nvltotal:=0
nvlDesfu:=0
nvlSegur:=0
nvlReale:=0

nsvltotal:=0
nsvlDesfu:=0
nsvlSegur:=0
nsvlReale:=0
                           


dbSelectArea("SZ2")
dbSetOrder(1)
dbSeek(xFilial("SZ2")+cContra)
AAdd(aDados ,{"Condição Comercial"," "," "," "," "," "," "," ","","",""," "," "," "})
AAdd(aDados ,{"Contrato","Cor","Produto"," ","Qtd.","Incoterm","","","","",""," "," "," "})
Do While !SZ2->(EOF())
   If SZ2->Z2_CONTRA==cContra              
      dbSelectarea("SB1")
      dbSetOrder(1)
      dbSeek(xFilial("SB1")+SZ2->Z2_CODPRO)
      cProduto:=" "
      If !SB1->(EOF())
         cProdduto:=SB1->B1_DESC
      EndIf                                          
      dbSelectArea("SZ2")
      AAdd(aDados ,{SZ2->Z2_CONTRA,SZ2->Z2_COR,SZ2->Z2_CODPRO,cProduto,SZ2->Z2_QTDTT,SZ2->Z2_INCOTER,"","","","",""," "," "," "})
   EndIf
   SZ2->(dbSkip())
EndDo

AAdd(aDados ,{" "," "," "," "," "," "," "," ","","",""," "," "," "})

dbSelectArea("SZ3")
dbSetOrder(1)
dbSeek(xFilial("SZ3")+cContra)
AAdd(aDados ,{"Cronograma"," "," "," "," "," "," "," ","","",""," "," "," "})
AAdd(aDados ,{"Contrato","Periodo","Dt.Inicio","Dt.Fim","Qtd.","Prm1/Des_USD","Prm4/Des_BR","Bolsa ","Tela","",""," "," "," "})
Do While !SZ3->(EOF())
   If SZ3->Z3_CONTRA==cContra              
      AAdd(aDados ,{SZ3->Z3_CONTRA,SZ3->Z3_PERIODO,SZ3->Z3_DTINIC,SZ3->Z3_DTFIM,SZ3->Z3_QTDLOT,SZ3->Z3_PREMIO1,SZ3->Z3_PREMIO4,SZ3->Z3_BOLSA,SZ3->Z3_TELA,"",""," "," "," "})
   EndIf
   SZ3->(dbSkip())
EndDo

AAdd(aDados ,{" "," "," "," "," "," "," "," ","","",""," "," "," "})


dbSelectArea("SZ7")
dbSetOrder(1)
dbSeek(xFilial("SZ7")+cContra)
AAdd(aDados ,{"Precificações"," "," "," "," "," "," "," ","","",""," "," "," "})
AAdd(aDados ,{"Contrato","Qtd.","Saldo","Vl.Final","Média"," "," "," ","","",""," "," "," "})
Do While !SZ7->(EOF())
   If SZ7->Z7_CONTRA==cContra              
      AAdd(aDados ,{SZ7->Z7_CONTRA,SZ7->Z7_QTDLOTE,SZ7->Z7_SALDO,SZ7->Z7_VLFINAL,SZ7->Z7_MEDIA," ","","",""," "," "," "})
   EndIf
   SZ7->(dbSkip())
EndDo

AAdd(aDados ,{" "," "," "," "," "," "," "," ","","",""," "," "," "})

If cTPCTO=="C"

   dbSelectArea("SC7")
   dbSetOrder(23)
   dbSeek(xFilial("SC7")+cContra)
   AAdd(aDados ,{"Pedidos de Compras"," "," "," "," "," "," "," ","","",""," "," "," "})
   AAdd(aDados ,{"Contrato","Pedido","Cód.Produto","Nome Produto","Qtd.","Qtd Entregue","Preço Unit.","Valor Total","Armazem","Navio","Booking","Taxa USD","Vl.Final","Média","NF Mãe","Usina"})
   cMd   :=""
   nSoma :=0
   nSomag:=0
   nSoma1 :=0
   nSomag1:=0
   Do While !SC7->(EOF()) 
      If SC7->C7_CONTRAT==cContra              
         dbSelectarea("SB1")
         dbSetOrder(1)
         dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
         cProduto:=" "
         If !SB1->(EOF())
            cProduto:=SB1->B1_DESC
         EndIf                                                                              
         
         /*
         dbSelectArea("SA2")
         dbSetOrder(1)
         dbSeek(xFilial("SA2")+SC7->C7_FORNECE)
         cFornec:=" "
         If !SA2->(EOF())
            cFornec:=SA2->A2_NOME
         EndIf 
         */
         cFornec:=" "
         dbSelectArea("SF1")
         dbSetOrder(10)
         dbSeek(xFilial("SF1")+SC7->C7_NFMAE)
         Do While !SF1->(EOF()) .AND. SF1->F1_NFMAE=SC7->C7_NFMAE
            If SF1->F1_CONTRA=cContra
               cFornec:=SF1->F1_XNOMFOR
               Exit
            EndIf                      
            SF1->(dbSkip())
         EndDo
         
         dbSelectArea("SC7")
         AAdd(aDados ,{SC7->C7_CONTRAT, SC7->C7_NUM, SC7->C7_PRODUTO, cProduto, SC7->C7_QUANT, SC7->C7_QUJE, SC7->C7_PRECO, SC7->C7_TOTAL,SC7->C7_LOCAL,;
         SC7->C7_CLVL, SC7->C7_BOOK, SC7->C7_TAXAUSD, SC7->C7_VLFINAL, SC7->C7_NRMEDIA, SC7->C7_NFMAE, cFornec})
         cMd:=SC7->C7_NRMEDIA
         nSoma+=SC7->C7_QUANT
         nSomag+=SC7->C7_QUANT
         nSoma1+=SC7->C7_QUJE
         nSomag1+=SC7->C7_QUJE
      EndIf
      SC7->(dbSkip())        
      If SC7->(EOF()) .OR. SC7->C7_CONTRAT<>cContra .OR. (SC7->C7_CONTRAT==cContra .AND. cMd<>SC7->C7_NRMEDIA)
         AAdd(aDados ,{" "," "," "," ",nSoma,nSoma1," "," "," "," "," "," "," "," "})     
         nSoma :=0             
         nSoma1:=0                     
         If SC7->C7_CONTRAT<>cContra
            AAdd(aDados ,{" "," "," "," ",nSomag,nSomag1," "," "," "," "," "," "," "," "})     
            Exit
         EndIf
      EndIf
   EndDo

   AAdd(aDados ,{" "," "," "," "," "," "," "," ","","",""," "," "," "})
   dbSelectArea("SF1")
   dbSetOrder(9) // 8 p/ 9 // 10/05/13 - Luis Felipe Nascimento
   dbSeek(xFilial("SF1")+cContra)
   AAdd(aDados ,{"Notas de Compras"," "," "," "," "," "," "," ","","",""," "," "," "})
   AAdd(aDados ,{"Contrato","NF Mãe","Data","Qtd.","Preço Unit.","Valor Total","Saldo","Média","","","","","","","",""})
   nSomamae :=0
   nSomamaeq:=0
   Do While !SF1->(EOF()) .AND. SF1->F1_CONTRA=cContra
      //IF EMPTY(SF1->F1_NFMAE)
         dbSelectArea("SD1")
         dbSetOrder(1)
         dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
         If !SD1->(EOF()) .AND. (SD1->D1_TES="002" .OR. SD1->D1_TES="017" .OR. SD1->D1_TES="004" .OR. SD1->D1_TES="104")  // Alexandre Santos - 24/07/2013 - De Para da TES
        // If !SD1->(EOF()) .AND. (SD1->D1_TES="002" .OR. SD1->D1_TES="009" .OR. SD1->D1_TES="004" .OR. SD1->D1_TES="104")  
           
            If Select("TRB") > 0
	           TRB->(dbCloseArea())
            Endif        
            cQuery:="SELECT E2_SALDO FROM "+RetSqlName("SE2")
            cQuery+=" WHERE D_E_L_E_T_= ' ' AND E2_NUM='"+SF1->F1_DOC+"' AND E2_FORNECE='"+SF1->F1_FORNECE+"' AND E2_LOJA='"+SF1->F1_LOJA+"'"
            DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
            dbselectarea("TRB")  
            TRB->(dbGoTop())
            nSaldoFin:=0
            If ! TRB->(EOF())
               nSaldoFin:=TRB->E2_SALDO
            EndIf
            TRB->(dbCloseArea())        
            
            cQuery:="SELECT C7_NRMEDIA FROM "+RetSqlName("SC7")
            cQuery+=" WHERE D_E_L_E_T_= ' ' AND C7_NFMAE='"+SF1->F1_DOC+"' AND C7_CONTRAT='"+cContra+"'"  // AND C7_FORNECE='"+SF1->F1_FORNECE+"' AND C7_LOJA='"+SF1->F1_LOJA+"'"
            DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
            dbselectarea("TRB")  
            TRB->(dbGoTop())
            cNRMEDIPED:=" "
            If ! TRB->(EOF())
               cNRMEDIPED:=TRB->C7_NRMEDIA
            EndIf
            TRB->(dbCloseArea())        
         
            dbSelectArea("SD1")
         
            AAdd(aDados ,{cContra,SF1->F1_DOC,SF1->F1_EMISSAO,SD1->D1_QUANT,SD1->D1_VUNIT,SD1->D1_TOTAL,nSaldoFin,cNRMEDIPED,"","","","","","","",""}) 

            /*
            If Select("TRB") > 0
	           TRB->(dbCloseArea())
            Endif        
            cQuery:="SELECT *"
            cQuery+=" FROM "+RetSqlname("SD2")
            cQuery+=" INNER JOIN "+RetSqlname("SF2")+" ON F2_DOC = D2_DOC"
            cQuery+=" WHERE D2_NFORI='"+SF1->F1_DOC+"' AND D2_TES='598'"
            cQuery+=" ORDER BY F2_EMISSAO"
            cQuery := ChangeQuery(cQuery)
            DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
            dbselectarea("TRB")  
            TRB->(dbGoTop())
            If ! TRB->(EOF())
               AAdd(aDados,{"DEVOLUÇÃO", TRB->D2_DOC, TRB->F2_EMISSAO, (TRB->D2_QUANT)*-1, TRB->D2_VUNIT,TRB->D2_TOTAL,"","","","","","","","","",""}) 
            Else
               nSomamae+=SD1->D1_TOTAL                 
               nSomamaeq+=SD1->D1_QUANT
            EndIf
            TRB->(dbCloseArea())
            */
            
            nSomamae+=SD1->D1_TOTAL                 
            nSomamaeq+=SD1->D1_QUANT
            
         EndIf
      //ENDIF
      dbSelectArea("SF1")
      SF1->(dbSkip())
   EndDo 
   AAdd(aDados ,{" "," "," ",nSomamaeq," ",nSomamae," "," ","","",""," "," "," "})
   AAdd(aDados ,{" "," "," "," "," "," "," "," ","","",""," "," "," "})
   
   dbSelectArea("SE2")
   dbSetOrder(17)
   dbSeek(xFilial("SE2")+alltrim(cContra))
   AAdd(aDados ,{"Pagamentos Realizados"," "," "," "," "," "," "," ","","",""," "," "," "})
   AAdd(aDados ,{"Contrato","Num","Emissão","Valor","Qtd.","Tx USD","Hist.","Vl. Original","Fornecedor", "Saldo"})
   nSomapg:=0   
   nSomqt :=0
   Do While !SE2->(EOF()) .AND. ALLTRIM(SE2->E2_CONTRA)=ALLTRIM(cContra)
      If ALLTRIM(SE2->E2_TIPO) == 'PA' //.AND. SE2->E2_FORNECE $ cForCTR
	      AAdd(aDados ,{SE2->E2_CONTRA,SE2->E2_NUM,SE2->E2_EMISSAO,SE2->E2_VALOR,SE2->E2_QTDTON,SE2->E2_TXUSD,SE2->E2_HIST,SE2->E2_VLORIG,SE2->E2_NOMFOR,SE2->E2_SALDO})
    	  nSomapg += SE2->E2_VALOR       
	      nSomqt  += SE2->E2_QTDTON
	  EndIf

      SE2->(dbSkip())

   EndDo
   AAdd(aDados ,{" "," "," ",nSomapg,nSomqt," "," "," ","","",""," "," "," "})                                                                    
   AAdd(aDados ,{" "," "," "," "," "," "," "," ","","",""," "," "," "})
   
   /*
   dbSelectArea("SE1")
   dbSetOrder(17)
   dbSeek(xFilial("SE1")+alltrim(cContra))
   AAdd(aDados ,{"DN"," "," "," "," "," "," "," ","","",""," "," "," "})
   AAdd(aDados ,{"Contrato","Num","Emissão","Valor","Qtd.","Tx USD","Hist.","Vl. Original","Fornecedor", "Saldo"})
   nSomadn:=0   
   nSomqtdn :=0
   Do While !SE2->(EOF()) .AND. ALLTRIM(SE2->E2_CONTRA)=ALLTRIM(cContra)
      If ALLTRIM(SE2->E2_TIPO) == 'DN' //.AND. SE2->E2_FORNECE $ cForCTR
	      AAdd(aDados ,{SE2->E2_CONTRA,SE2->E2_NUM,SE2->E2_EMISSAO,SE2->E2_VALOR,SE2->E2_QTDTON,SE2->E2_TXUSD,SE2->E2_HIST,SE2->E2_VLORIG,SE2->E2_NOMFOR,SE2->E2_SALDO})
    	  nSomadn += SE2->E2_VALOR       
	      nSomqtdn  += SE2->E2_QTDTON
	  EndIf

      SE2->(dbSkip())

   EndDo
   AAdd(aDados ,{" "," "," ",nSomadn,nSomqtdn," "," "," ","","",""," "," "," "})                                                                    
   */
   
   AAdd(aDados ,{"Notas - Pagamentos"," "," ",nSomapg-nSomamae," "," "," "," ","","",""," "," "," "})

   AAdd(aDados ,{" "," "," "," "," "," "," "," ","","",""," "," "," "})
   dbSelectArea("SF1")
   dbSetOrder(9) // 8 p/ 9 // 10/05/13 - Luis Felipe Nascimento
   dbSeek(xFilial("SF1")+cContra)

   AAdd(aDados ,{"Notas de Complemento"," "," "," "," "," "," "," ","","",""," "," "," "})
   AAdd(aDados ,{"Contrato","NF Mãe","Data","Preço Unit.","Valor Total","Saldo","","","","","","","","",""})
   nSomamae :=0
   nSomamaeq:=0
   Do While !SF1->(EOF()) .AND. SF1->F1_CONTRA=cContra          
 
      If Select("TRB") > 0
	     TRB->(dbCloseArea())
      Endif        
      cQuery:="SELECT E2_SALDO FROM "+RetSqlName("SE2")
      cQuery+=" WHERE D_E_L_E_T_= ' ' AND E2_NUM='"+SF1->F1_DOC+"' AND E2_FORNECE='"+SF1->F1_FORNECE+"' AND E2_LOJA='"+SF1->F1_LOJA+"'"
      DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
      dbselectarea("TRB")  
      TRB->(dbGoTop())
      nSaldoFin:=0
      If ! TRB->(EOF())
         nSaldoFin:=TRB->E2_SALDO
      EndIf
      TRB->(dbCloseArea())        
                      
    
      //IF EMPTY(SF1->F1_NFMAE)
         dbSelectArea("SD1")
         dbSetOrder(1)
         dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
         If !SD1->(EOF()) .AND. SD1->D1_TES="102"
            AAdd(aDados ,{cContra,SF1->F1_DOC,SF1->F1_EMISSAO,SD1->D1_VUNIT,SD1->D1_TOTAL,nSaldoFin,"","","","","","","","",""}) 
            nSomamae+=SD1->D1_TOTAL                 
            nSomamaeq+=SD1->D1_QUANT
         EndIf
      //ENDIF
      dbSelectArea("SF1")
      SF1->(dbSkip())
   EndDo 
   AAdd(aDados ,{" "," "," "," ",nSomamae," "," ","","",""," "," "," "})
   AAdd(aDados ,{" "," "," "," "," "," "," "," ","","",""," "," "," "})
   
   AAdd(aDados ,{"Notas de Crédito"," "," "," "," "," "," "," ","","",""," "," "," "})
   AAdd(aDados ,{"Contrato","Título","Emissão","Vencimento","Valor","Saldo","","","","","","","","",""})

   If Select("TRB") > 0
      TRB->(dbCloseArea())
   Endif        
   cQuery:="SELECT E1_NUM, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO FROM "+RetSqlName("SE1")
   cQuery+=" WHERE D_E_L_E_T_= ' ' AND E1_CONTRA='"+cCONTRA+"' "
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
   dbselectarea("TRB")  
   TRB->(dbGoTop())
   nValnc:=0
   Do While ! TRB->(EOF())
      AAdd(aDados ,{cContra,TRB->E1_NUM,TRB->E1_EMISSAO,TRB->E1_VENCREA,TRB->E1_VALOR,TRB->E1_SALDO,"","","","","","","","",""})
      nValnc+=TRB->E1_VALOR
      TRB->(dbSKIP())
   EndDo
   TRB->(dbCloseArea())        
   AAdd(aDados ,{" "," "," "," ",nValnc," "," ","","",""," "," "," "})
   

   AAdd(aDados ,{" "," "," "," "," "," "," "," ","","",""," "," "," "})
                                                                          
   
   
   
   AAdd(aDados ,{"DN"," "," "," "," "," "," "," ","","",""," "," "," "})
   AAdd(aDados ,{"Contrato","Título","Emissão","Vencimento","Valor","Saldo","","","","","","","","",""})

   If Select("TRB") > 0
      TRB->(dbCloseArea())
   Endif        
   cQuery:="SELECT E1_NUM, E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO FROM "+RetSqlName("SE1")
   cQuery+=" WHERE D_E_L_E_T_= ' ' AND E1_CONTRA LIKE '%"+ALLTRIM(STRTRAN(cCONTRA,"B",""))+"%' AND E1_TIPO='DN ' "
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
   dbselectarea("TRB")  
   TRB->(dbGoTop())
   nValnc:=0
   Do While ! TRB->(EOF())
      AAdd(aDados ,{cContra,TRB->E1_NUM,TRB->E1_EMISSAO,TRB->E1_VENCREA,TRB->E1_VALOR,TRB->E1_SALDO,"","","","","","","","",""})
      nValnc+=TRB->E1_VALOR
      TRB->(dbSKIP())
   EndDo
   TRB->(dbCloseArea())        
   AAdd(aDados ,{" "," "," "," ",nValnc," "," ","","",""," "," "," "})

   
   
   
   
   
ElseIf cTPCTO=="V"
   dbSelectArea("SC5")
   dbSetOrder(5)
   dbSeek(xFilial("SC5")+cContra)
   AAdd(aDados ,{"Pedidos de Vendas"," "," "," "," "," "," "," ","","",""," "," "," "})
   AAdd(aDados ,{"Contrato", "Pedido", "Cliente", "Navio", "R.E.", "Booking", "Nr.Média", "Taxa USD", "Vl.Final", "Desc.Extra", "Cód.Produto","Nome Produto","Quant.","Tons.", "Armazém","Preco","Valor Total","NF"})
   nsoma :=0
   nsomag:=0             
   nsoma1 :=0
   nsomag1:=0             
   nsoma2 :=0
   nsomag2:=0      
   aDEV:={}       
   Do While !SC5->(EOF()) .AND. SC5->C5_CONTRAT==cContra      
      dbSelectArea("SC6")
      dbSetOrder(1)
      dbseek(xFilial("SC6")+SC5->C5_NUM)                 
      cPRODUTO:=""
      cNOMPROD:=""
      nQTD    :=0
      nPreco  :=0
      nvltotal:=0                                                                            
      cnf     :=""
      cArmaz  :="  "
      If !SC6->(EOF())
         cPRODUTO:=SC6->C6_PRODUTO
         cNOMPROD:=Posicione("SB1",1,xFilial("SB1")+cPRODUTO,"B1_DESC")
         nQTD    :=SC6->C6_QTDVEN
         nsoma   +=SC6->C6_QTDVEN
         nsomag  +=SC6->C6_QTDVEN
         nPreco  :=SC6->C6_PRCVEN
         nvltotal:=SC6->C6_VALOR
         cnf     :=SC6->C6_NOTA      
         cArmaz  :=SC6->C6_LOCAL
      EndIf                                                                     
      dbSelectArea("SC5")    
      nsoma1   +=SC5->C5_QTDTON
      nsomag1  +=SC5->C5_QTDTON

      nsoma2   +=nVLTOTAL
      nsomag2  +=nVLTOTAL
          
      cmedia:=SC5->C5_NRMEDIA
      //inclusao do tratamento apos a mudanca do processo de exportacao
      cRE	:= SC5->C5_BAURE
      If Empty(SC5->C5_BAURE)
      	DbSelectArea("EE9")
   		DbSetOrder(1)
   		If DbSeek(xFilial("EE9")+SC5->C5_NUM)
   			cRE   := EE9->EE9_RE
		EndIf
	  EndIf
      AAdd(aDados ,{SC5->C5_CONTRAT, SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_NAVIO, cRE, SC5->C5_BOOK, SC5->C5_NRMEDIA, SC5->C5_TAXAUSD,;
      SC5->C5_VLFINAL, SC5->C5_DESCEXT, cPRODUTO,cNOMPROD,nQTD,SC5->C5_QTDTON, cArmaz,nPRECO,nVLTOTAL, cnf})
      
      //NESSE PONTO BUSCAR NOTAS DE DEVOLUÇÃO
      If Select("TRB") > 0
	     TRB->(dbCloseArea())
      Endif        
      cQuery:="SELECT *"
      cQuery+=" FROM "+RetSqlname("SD1")
      cQuery+=" INNER JOIN "+RetSqlname("SF1")+" ON F1_DOC = D1_DOC"
      cQuery+=" WHERE D1_NFORI='"+SC5->C5_NOTA+"' AND D1_TES='010' AND "+RetSqlname("SF1")+".D_E_L_E_T_='' AND "+RetSqlname("SD1")+".D_E_L_E_T_=''"
      cQuery+=" ORDER BY F1_EMISSAO"
      cQuery := ChangeQuery(cQuery)
      DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
      dbselectarea("TRB")  
      TRB->(dbGoTop())
      If ! TRB->(EOF())                       
                                    
      
         // Alexandre Santos - 19/07/2013 - Alteracao para retirar o valor pre-fixado           
         nFator := U_EDFFATOR(TRB->D1_COD) 	  
 
         AAdd(aDados,{SC5->C5_CONTRAT, "DEVOLUÇÃO", TRB->F1_FORNECE, , ,;
         , , , , ,TRB->D1_COD, Posicione("SB1",1,xFilial("SB1")+TRB->D1_COD,"B1_DESC"), (TRB->D1_QUANT)*-1,(TRB->D1_QUANT/nFator)*-1, TRB->D1_VUNIT, (TRB->D1_TOTAL)*-1, TRB->F1_DOC})
         nsoma    -=TRB->D1_QUANT
         nsoma1   -=(TRB->D1_QUANT/nFator)
         nsomag1  -=(TRB->D1_QUANT/nFator)

         //AAdd(aDados,{SC5->C5_CONTRAT, "DEVOLUÇÃO", TRB->F1_FORNECE, , ,;
         //, , , , ,TRB->D1_COD, Posicione("SB1",1,xFilial("SB1")+TRB->D1_COD,"B1_DESC"), (TRB->D1_QUANT)*-1,(TRB->D1_QUANT/20)*-1, TRB->D1_VUNIT, (TRB->D1_TOTAL)*-1, TRB->F1_DOC})
         //nsoma    -=TRB->D1_QUANT
         //nsoma1   -=(TRB->D1_QUANT/20)
         //nsomag1  -=(TRB->D1_QUANT/20)
         // Alexandre Santos - 19/07/2013 --------------------------------------------           

         nsoma2   -=TRB->D1_TOTAL
         nsomag2  -=TRB->D1_TOTAL
      EndIf                  
      TRB->(dbCloseArea())
      //


      SC5->(dbSkip())        
      If cmedia<>SC5->C5_NRMEDIA .OR. SC5->(EOF()) .OR. SC5->C5_CONTRAT<>cContra              
         AAdd(aDados ,{" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "," ",nsoma,nsoma1," ",nsoma2," "})
         nsoma :=0                                      
         nsoma1:=0
         nsoma2:=0
      EndIf
   EndDo                                                                                    
   AAdd(aDados ,{" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "," "," "," "," "," "," "})
   
   /*
   AAdd(aDados ,{" NOTAS DE DEVOLUÇÃO ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "," "," "," "," "," "," "})
   for xx:=1 to len(aDev)
	   AAdd(aDados , {aDev[xx][1],aDev[xx][2],aDev[xx][3],aDev[xx][5],aDev[xx][6],aDev[xx][7],aDev[xx][8],aDev[xx][9],aDev[xx][10],aDev[xx][11],aDev[xx][12],aDev[xx][13],aDev[xx][14],aDev[xx][15],aDev[xx][16],aDev[xx][17]})
   next XX
   AAdd(aDados ,{" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "," "," "," "," "," "," "})
   */
   
EndIf
                
DlgToExcel( { { "ARRAY", "Relatório", aCabec, aDados} })                                  

//TRB->(dbcloseArea())

Return Nil
                             

