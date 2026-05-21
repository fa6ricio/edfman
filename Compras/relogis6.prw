#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELOGIS06   ºAutor  ³Alexandre Santos  º Data ³  19/07/13   º±±
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

User Function Relogis6()
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
cTes     := ""   // Alexandre Santos - 24/07/2013 - De Para da TES      
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
                     
    //@090,20 SAY "Contrato:" SIZE 60, 8 OF oDlg PIXEL
    //@090,90 MSGET oVar2 VAR cContra PICTURE "@!" SIZE 80,9 F3 "CN9" OF oDlg PIXEL 
    
    //@115,20 SAY "Data de referência:" SIZE 60, 8 OF oDlg PIXEL
    //@115,90 COMBOBOX oCombocor VAR cCorEmb ITEMS aCombocor SIZE 80,9 PIXEL OF oDlg PIXEL         

    @115,20 Say "TES:"  Pixel Of oDlg                                                                             // Alexandre Santos - 24/07/2013 - De Para da TES 
    @115,90 MSGet oVar7  Var cTES  size 050,10 Picture "@!" Size 052,10 F3 "SF4" VALID NAOVAZIO() OF oDlg PIXEL   //     

    @130,20 Say "Data inicial:" Pixel Of oDlg                                                    
    @130,90 MSGet oVar7 Var dDTfecha1 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
    @145,20 Say "Data final:" Pixel Of oDlg                                                    
    @145,90 MSGet oVar7 Var dDTfecha2 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
    @180,20 Button oBtnOk     Prompt "&Consulta"       Size 30,15 Pixel Action (U_gerlog06(), oDlg:End()) Of oDlg
    @180,90 Button oBtnCancel Prompt "C&ancelar"       Size 30,15 Pixel Action ( oDlg:End(),lContinua := .F.) Cancel Of oDlg

Activate MSDialog oDlg Centered        

Return .T.                                                                               

user Function Gerlog06
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

nvltotal:=0
nvlDesfu:=0
nvlSegur:=0
nvlReale:=0

nsvltotal:=0
nsvlDesfu:=0
nsvlSegur:=0
nsvlReale:=0
                           
dbSelectArea("SC5")
dbSetOrder(2)
dbSeek(xFilial("SC5")+DTOS(dDTfecha1),.T.)
AAdd(aDados ,{"Pedidos de Vendas"," "," "," "," "," "," "," ","","",""," "," "," "})
AAdd(aDados ,{"Data", "Contrato", "Pedido", "Cliente", "Navio", "R.E.", "Booking", "Nr.Média", "Taxa USD", "Vl.Final", "Desc.Extra", "Cód.Produto","Nome Produto","Quant.","Tons.", "Armazém","Preco","Valor Total","NF", "Tipo", "Valor R$", "CFOP" })
nsoma :=0
nsomag:=0
nsoma1 :=0
nsomag1:=0
nsoma2 :=0
nsomag2:=0
aDEV:={}
Do While !SC5->(EOF()) .AND. SC5->C5_EMISSAO>=dDTfecha1 .AND. SC5->C5_EMISSAO<=dDTfecha2 //.AND. SC5->C5_CONTRAT==cContra  
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
       dbSelectArea("SD2")
	   dbSetOrder(3)             
	   dbseek(xFilial("SD2")+SC6->C6_NOTA)
	   If SD2->D2_CF="5503" .OR. SD2->D2_CF="6503" .OR. SD2->D2_CF="5505" .OR. SD2->D2_CF="5551" .OR. SD2->D2_CF="6905" .OR. SD2->D2_CF="7949" .OR. SD2->(EOF()) .OR. SD2->D2_CF="5556"
          dbSelectArea("SC5")
          SC5->(dbSkip())    
          Loop
	   EndIf
	   dbSelectArea("SC6")
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
	
	nVlnfR:=0           
	cTiponf:=" "
    cCFOP:=""
	If !Empty(cnf)
		dbSelectArea("SF2")
		dbSetOrder(1)
		If dbseek(xFilial("SF2")+cnf)
           nVlnfR :=SF2->F2_VALMERC
		   cTiponf:=SF2->F2_TIPO
		   dbSelectArea("SD2")
		   dbSetOrder(3)             
		   dbseek(xFilial("SD2")+cnf)
		   If !SD2->(EOF())  
		      cCFOP:=SD2->D2_CF
		   EndIf
		EndIf
	EndIf
	
	dbSelectArea("SC5")
	nsoma1   +=SC5->C5_QTDTON
	nsomag1  +=SC5->C5_QTDTON
	
	nsoma2   +=nVLTOTAL
	nsomag2  +=nVLTOTAL
	
	cmedia:=SC5->C5_NRMEDIA
	
	AAdd(aDados ,{SC5->C5_EMISSAO, SC5->C5_CONTRAT, SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_NAVIO, SC5->C5_BAURE, SC5->C5_BOOK, SC5->C5_NRMEDIA, SC5->C5_TAXAUSD,;
	SC5->C5_VLFINAL, SC5->C5_DESCEXT, cPRODUTO,cNOMPROD,nQTD,SC5->C5_QTDTON, cArmaz,nPRECO,nVLTOTAL, cnf, cTiponf, nVlnfR, cCFOP})
	
	
	//NESSE PONTO BUSCAR NOTAS DE DEVOLUÇÃO
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	Endif
	cQuery:="SELECT *"
	cQuery+=" FROM "+RetSqlname("SD1")
	cQuery+=" INNER JOIN "+RetSqlname("SF1")+" ON F1_DOC = D1_DOC"
	cQuery+=" WHERE D1_NFORI='"+SC5->C5_NOTA+"' AND D1_TES='"+cTes+"' AND "+RetSqlname("SF1")+".D_E_L_E_T_='' AND "+RetSqlname("SD1")+".D_E_L_E_T_=''"
	// cQuery+=" WHERE D1_NFORI='"+SC5->C5_NOTA+"' AND D1_TES='010' AND "+RetSqlname("SF1")+".D_E_L_E_T_='' AND "+RetSqlname("SD1")+".D_E_L_E_T_=''"
	cQuery+=" ORDER BY F1_EMISSAO"
	cQuery := ChangeQuery(cQuery)
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbselectarea("TRB")
	TRB->(dbGoTop())     
	nvltotald:=0
	If ! TRB->(EOF()) .AND. TRB->D1_CF<>"6503" .AND. TRB->D1_CF<>"5503" .AND. TRB->D1_CF<>"5551" .AND. TRB->D1_CF<>"6905" .AND. TRB->D1_CF<>"7949" 
  	    
        nFator := U_EDFFATOR(TRB->D1_COD) 	  // Alexandre Santos - 19/07/2013 - Alteracao para retirar o valor pre-fixado                          	                                       
  	   
 	    nvltotald:=(nPRECO*nFator)*((TRB->D1_QUANT/nFator)*-1)  // Alexandre Santos - 19/07/2013
 	    // nvltotald:=(nPRECO*20)*((TRB->D1_QUANT/20)*-1)  // Alexandre Santos - 19/07/2013

		AAdd(aDados,{TRB->F1_EMISSAO, SC5->C5_CONTRAT, "DEVOLUÇÃO", TRB->F1_FORNECE, , ,;
		, , , , ,TRB->D1_COD, Posicione("SB1",1,xFilial("SB1")+TRB->D1_COD,"B1_DESC"), (TRB->D1_QUANT)*-1,(TRB->D1_QUANT/nFator)*-1, TRB->D1_LOCAL,TRB->D1_VUNIT,  nvltotald  , TRB->F1_DOC, TRB->F1_TIPO,(TRB->D1_TOTAL)*-1,TRB->D1_CF}) // Alexandre Santos - 19/07/2013
		//AAdd(aDados,{TRB->F1_EMISSAO, SC5->C5_CONTRAT, "DEVOLUÇÃO", TRB->F1_FORNECE, , ,;
		//, , , , ,TRB->D1_COD, Posicione("SB1",1,xFilial("SB1")+TRB->D1_COD,"B1_DESC"), (TRB->D1_QUANT)*-1,(TRB->D1_QUANT/20)*-1, TRB->D1_LOCAL,TRB->D1_VUNIT,  nvltotald  , TRB->F1_DOC, TRB->F1_TIPO,(TRB->D1_TOTAL)*-1,TRB->D1_CF}) // Alexandre Santos - 19/07/2013


		nsoma    -=TRB->D1_QUANT
		nsoma1   -=(TRB->D1_QUANT/nFator)  // Alexandre Santos - 19/07/2013
		nsomag1  -=(TRB->D1_QUANT/nFator)  // Alexandre Santos - 19/07/2013
		//nsoma1   -=(TRB->D1_QUANT/20)  // Alexandre Santos - 19/07/2013
		//nsomag1  -=(TRB->D1_QUANT/20)  // Alexandre Santos - 19/07/2013
		
		nsoma2   -=TRB->D1_TOTAL
		nsomag2  -=TRB->D1_TOTAL
	EndIf
	TRB->(dbCloseArea())
	SC5->(dbSkip())

	/*
	If cmedia<>SC5->C5_NRMEDIA .OR. SC5->(EOF()) .OR. SC5->C5_CONTRAT<>cContra
		AAdd(aDados ,{" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "," ",nsoma,nsoma1," ",nsoma2," "})
		nsoma :=0
		nsoma1:=0
		nsoma2:=0
	EndIf
	*/
EndDo
AAdd(aDados ,{" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "," "," "," "," "," "," "})


                
DlgToExcel( { { "ARRAY", "Relatório", aCabec, aDados} })                                  

//TRB->(dbcloseArea())

Return Nil
                             

      
