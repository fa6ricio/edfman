#Include "Protheus.Ch"                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Negocia   ºAutor  ³Alexandre Santos    º Data ³  19/07/13   º±±
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


User Function Negocia()
Local oVar1, oVar2, oVar3, oVar4, oVar5, oVar6, oVar7, oVar8, oVar9, oVar10, oBtnOk, oBtnCancel                                      
                      
Private oDlg, cCondic, cNatur, cNavio, cTes, cNFMAE, cContra, cContrato, nPedido, dDTvencto, nTXUSD, nqtdton, xNUMTIT, nVLFINAL, nTaxa
Private cCorEmb   := SPACE(20)       
Private aCombocor := {}  

aAdd( aCombocor, "Data Emissão" )
aAdd( aCombocor, "Data Chegada" )
                                                                                                               
xNUMTIT  := "         "
cCondicao:= "   "
cCondic  := "   "
cNatureza:= "101001"
cNatur   := "101001"
cNavio   := "               "
cReferen := ""
cContrato:= SPACE(15)
cTes     := "018"       // Alexandre Santos - 24/07/2013 - De Para da TES
// cTes     := "005"           
cNFMAE   := 0                         
cContra  := "               "
cPedido  := "      "                  
dDTvencto:= ctod(space(08))
nTxusd   := 0
nqtdton  := 0
cFornece:=space(06)
dDtFecha1:=ctod(space(8))
dDtFecha2:=ctod(space(8))        
nTaxa:=0                        
cMedia    := Space(1)


Define MSDialog oDlg Title OemToAnsi("Parâmetros para o relatório:") From 0,0 To 420,540 Pixel         
    
    @015,20 Say "Fornecedor:" Pixel Of oDlg
    @015,90 MSGet oVar1  Var cFornece Picture "@!" size 100,10  F3 "SA2" OF oDlg PIXEL            
    
    @030,20 Say "Contrato:" Pixel Of oDlg
    @030,90 MSGet oVar1  Var cContra Picture "@!" size 100,10  F3 "CN9" OF oDlg PIXEL     

    @045,20 Say "Taxa USD:" Pixel Of oDlg                                                    
    @045,90 MSGet oVar8 Var nTaxa    size 036,10 Picture "@e 999,999.9999" size 38,10 Pixel Of oDlg
 
    @060,20 Say "Média:" Pixel Of oDlg
    @060,90 MSGet oVar7 Var cMedia size 20,10 Pixel Of oDlg
   
    @115,20 SAY "Data de referência:" SIZE 60, 8 OF oDlg PIXEL
    @115,90 COMBOBOX oCombocor VAR cCorEmb ITEMS aCombocor SIZE 80,9 PIXEL OF oDlg PIXEL         
    
    @130,20 Say "Data inicial:" Pixel Of oDlg                                                    
    @130,90 MSGet oVar7 Var dDTfecha1 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
    @145,20 Say "Data final:" Pixel Of oDlg                                                    
    @145,90 MSGet oVar7 Var dDTfecha2 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
    @180,20 Button oBtnOk     Prompt "&Consulta"       Size 30,15 Pixel Action (U_gercons(), oDlg:End()) Of oDlg
    @180,90 Button oBtnCancel Prompt "C&ancelar"       Size 30,15 Pixel Action ( oDlg:End(),lContinua := .F.) Cancel Of oDlg

Activate MSDialog oDlg Centered        


Return .T.                                                                               

User Function Gercons // gera consulta para negociação com o fornecedor.
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

Private cString := "SC5"
Private cQuery  :=""
            

If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif

cQuery:="SELECT"
cQuery+=" F1_NAVIO,F1_DOC AS NF, F1_CONTRA AS CONTRATO,   F1_XPEDIDO AS PEDIDO, D1_QUANT AS SACOS, D1_QUANT AS TONS, D1_COD, " // Alexandre Santos 19/07/2013
//cQuery+=" F1_NAVIO,F1_DOC AS NF, F1_CONTRA AS CONTRATO,   F1_XPEDIDO AS PEDIDO, D1_QUANT AS SACOS, D1_QUANT/20 AS TONS,"   // Alexandre Santos 19/07/2013
cQuery+=" C7_MEDIA AS MEDIA,C7_VLFINAL-C7_MEDIA AS PREMIO, C7_VLFINAL AS VL_FINAL, C7_NAVIO, F1_EMISSAO, "
//cQuery+=" (D1_QUANT/20)*C7_VLFINAL AS VL_LIQ, Z5_DESREAL AS DESC_REAL, Z5_DESREAL*(D1_QUANT/20) VALOR_REAIS, F1_SERIE, F1_FORNECE, F1_LOJA, "
cQuery+=" (D1_QUANT)*C7_VLFINAL AS VL_LIQ, F1_SERIE, F1_FORNECE, F1_LOJA, "  // Alexandre Santos 19/07/2013
// cQuery+=" (D1_QUANT/20)*C7_VLFINAL AS VL_LIQ, F1_SERIE, F1_FORNECE, F1_LOJA, "  // Alexandre Santos 19/07/2013
cQuery+=" F1_NFMAE, F1_EMISSAO,F1_VALBRUT, C7_NRMEDIA, D1_FORNECE, D1_XVDEFIN "
cQuery+=" FROM "+RetSqlname("SF1")
cQuery+=" INNER JOIN "+RetSqlname("SD1")+" ON D1_DOC        = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_TES IN ('006','017','104','002') "  // Alexandre Santos - 30/07/2013
//cQuery+=" INNER JOIN "+RetSqlname("SD1")+" ON D1_DOC        = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_TES IN ('006','009','104','002') "//002 incluido temporariamente
cQuery+=" INNER JOIN "+RetSqlname("SC7")+" ON C7_NUM        = F1_XPEDIDO"
//cQuery+=" INNER JOIN "+RetSqlname("SZ5")+" ON Z5_CONTRA     = F1_CONTRA"
cQuery+=" WHERE"                   
IF !EMPTY(cFORNECE)
   cQuery+=" F1_FORNECE='"+cFornece+"' AND "+RetSqlname("SF1")+".D_E_L_E_T_ <> '*' AND "+RetSqlName("SC7")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SD1")+".D_E_L_E_T_<>'*' AND D1_FORNECE='"+cFornece+"' AND "  //AND F1_LOJA='01' AND"
ELSE
   cQuery+="  "+RetSqlname("SF1")+".D_E_L_E_T_ <> '*' AND "+RetSqlName("SC7")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SD1")+".D_E_L_E_T_<>'*' AND "  //AND F1_LOJA='01' AND"
ENDIF
//Private cCorEmb := SPACE(20)          
//aAdd( aCombocor, "Data Emissão" )
//aAdd( aCombocor, "Data Chegada" )

if !empty(trim(ccontra))
   cQuery+=" F1_CONTRA='"+cContra+"' AND "
endif
     
if !EMPTY(cMEDIA)
   cQuery+=" C7_NRMEDIA = '"+cMEDIA+"' AND "
endif                       

if cCorEmb=="Data Chegada"
   //cQuery+=" F1_DTCHEGA>='"+dtos(dDTfecha1)+"' AND F1_DTCHEGA<='"+dtos(dDTfecha2)+"' AND F1_CP<>'1' AND F1_NFMAE<>'' "
   cQuery+=" F1_DTCHEGA>='"+dtos(dDTfecha1)+"' AND F1_DTCHEGA<='"+dtos(dDTfecha2)+"' AND F1_NFMAE<>'' "
else   
   //cQuery+=" F1_EMISSAO>='"+dtos(dDTfecha1)+"' AND F1_EMISSAO<='"+dtos(dDTfecha2)+"' AND F1_CP<>'1' AND F1_NFMAE<>'' "
   cQuery+=" F1_EMISSAO>='"+dtos(dDTfecha1)+"' AND F1_EMISSAO<='"+dtos(dDTfecha2)+"' AND F1_NFMAE<>'' "
endif                          


   
cQuery := ChangeQuery(cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbselectarea("TRB")  


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
dbclosearea("TRB")

Return Nil
                             


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local aDados := {}
Local aCampos:= {}
Local aCabec := {}
Local lProvisorio	:= .F.
Local nOrdem

//dbSelectArea(cString)
dbselectArea("TRB")
//dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbGoTop()                                                                                

nSacos  =0
nTons   =0
nvlusd  =0
nvlreal =0
nprepg  =0         
nttt    =0          
/*
AADD(ACABEC ,"MV")                        //1
AADD(ACABEC ,"Navio")                     //2
AADD(ACABEC ,"Booking")                   //3
AAdd(aCabec ,"N.F. Mãe")                  //4
AAdd(aCabec ,"N.F.")                      //5
AAdd(aCabec ,"Emissão")                   //6
AAdd(aCabec ,"Contrato")                  //7
AAdd(aCabec ,"Pedido")                    //8
AAdd(aCabec ,"Sacas")                     //9
AAdd(aCabec ,"Tons")                      //10
AAdd(aCabec	,"Preço")					 //novo
AAdd(aCabec ,"Média")                     //11
AAdd(aCabec ,"Prêmio")                    //12
AAdd(aCabec ,"Vl.Final")                  //13
AAdd(aCabec ,"Valor USD")                 //14
AAdd(aCabec ,"Desc.BRL")                  //15
AAdd(aCabec ,"Valor BRL")                 //16
AAdd(aCabec ,"Pp Tons")                   //17
AAdd(aCabec ,"Pp USD")                    //18
AAdd(aCabec ,"Vl Líq.USD")                //19
AADD(ACABEC ,"Vl N.F.Filha")              //20
AADD(ACABEC ,"Taxa")                      //21
AADD(ACABEC ,"Vl.Tít.BRL")                //22
AADD(ACABEC ,"Pp BRL")                    //24
AADD(ACABEC ,"Título - Pp")               //25
AADD(ACABEC ,"Comp.BRL")                  //23
*/                

AADD(ACABEC ,"Relatório para negociação")
AADD(aDados ,{"Data inicial",ddtfecha1,"Data Final", ddtfecha2,"Fornecedor",Posicione("SA2",1,xFilial("SA2")+cFornece,"A2_NOME")})
AADD(aDados ,{"N.F. Mãe","N.F.","Emissão","Contrato","Pedido","Sacas","Tons","Preço","Média","Prêmio","Vl.Final","Valor USD","Desc.BRL","Valor BRL","Pp Tons","Pp USD","Vl Líq.USD","Vl N.F.Filha","Taxa","Vl.Tít.BRL","Pp BRL","Título - Pp","Compl.BRL","Vl.Comp.PA","Nr.Média"})

nSacos   =0
nTons    =0
nvlusd   =0
nvlreal  =0
nTOTPRE  =0
nvlliqusd=0
nNFFILHA =0
nVLTITULO=0
nTOTPREr  =0
nTITPRE  =0
nCOMPL   =0
nvlcomp  =0

nSSacos   =0
nSTons    =0
nSvlusd   =0
nSvlreal  =0
nSTOTPRE  =0
nSvlliqusd=0
nSNFFILHA =0
nSVLTITULO=0
nSTOTPREr  =0
nSTITPRE  =0
nSCOMPL   =0
nsvlcomp  =0
nValliq		:= 0
While !EOF()      
	//nValliq		:= IIF(Empty(TRB->D1_XVDEFIN).And. lProvisorio,TRB->VL_LIQ,(TRB->D1_XVDEFIN+TRB->PREMIO)*TRB->TONS)
	
    nFator := U_EDFFATOR(TRB->D1_COD) 	  // Alexandre Santos - 19/07/2013 - Alteracao para retirar o valor pre-fixado                          	                                       
	
   dbSelectArea("SD2")
   dbSetOrder(10)
   dbSeek(xFilial("SD2")+TRB->NF+TRB->F1_SERIE)     
   If !SD2->(EOF()) .AND. SD2->D2_TES="507" .AND. SD2->D2_CLIENTE=TRB->F1_FORNECE .AND. SD2->D2_LOJA=TRB->F1_LOJA   // Alexandre Santos - 24/07/2013 - De Para da TES
   // If !SD2->(EOF()) .AND. SD2->D2_TES="598" .AND. SD2->D2_CLIENTE=TRB->F1_FORNECE .AND. SD2->D2_LOJA=TRB->F1_LOJA   
      TRB->(DBSKIP())
      LOOP
   ENDIF                   
   
	nDESC_REAL  :=0
   nVALOR_REAIS:=0
   cPERIOD     :=""
   dbSelectArea("SZ6")
   dbSetOrder(3)
   IF dbSeek(xFilial("SZ6")+ALLTRIM(TRB->CONTRATO),.F.)
      Do While !SZ6->(EOF()) .AND. SZ6->Z6_CONTRA=TRB->CONTRATO
         IF SZ6->Z6_MEDIA=TRB->C7_NRMEDIA
            cPERIOD:=SZ6->Z6_PERDE
            //Alteracao para verificar Preco Provisorio
            If SZ6->Z6_TIPOPRE == '1'
            	lProvisorio		:= .T.
            EndIf
         ENDIF   
         SZ6->(DBSKIP())
      ENDDO
	  dbSelectArea("SZ5")
	  dbSetOrder(1)
	  If dbSeek( xFilial("SZ5")+TRB->CONTRATO+cPERIOD,.F.)
	     //Z5_DESREAL AS DESC_REAL, Z5_DESREAL*(D1_QUANT/20) VALOR_REAIS
	     nDESC_REAL  := SZ5->Z5_DESREAL
	     nVALOR_REAIS:= SZ5->Z5_DESREAL*(TRB->TONS/nFator) // Alexandre Santos 19/07/2013
	     //nVALOR_REAIS:= SZ5->Z5_DESREAL*(TRB->TONS)      // Alexandre Santos 19/07/2013
	  ENDIF              

   ENDIF
	nValliq		:= IIF(Empty(TRB->D1_XVDEFIN),TRB->VL_LIQ/nFator,(TRB->D1_XVDEFIN+TRB->PREMIO)*TRB->TONS/nFator)   // Alexandre Santos 19/07/2013
	//nValliq		:= IIF(Empty(TRB->D1_XVDEFIN),TRB->VL_LIQ,(TRB->D1_XVDEFIN+TRB->PREMIO)*TRB->TONS)   // Alexandre Santos 19/07/2013
	
   DBSELECTAREA("SZ3")
   DBSETORDER(1)
   DBSEEK(xFILIAL("SZ3")+TRB->CONTRATO)
   ccol1:=""
   ccol2:=""
   
   nccol2:=0
   
   ccol3:=""
   IF !SZ3->(EOF())
      ccol1:=TRANSFORM(SZ3->Z3_PREMIO2,"@E 9,999,999.99")    
      
      // Alexandre Santos 19/07/2013 ------------------------------------------------      
      ccol2:=TRANSFORM((TRB->TONS/nFator) * SZ3->Z3_PREMIO2,"@E 9,999,999.99")               
      nccol2:=((TRB->TONS/nFator) * SZ3->Z3_PREMIO2)                                        
      ccol3:=TRANSFORM(nValliq - ((TRB->TONS/nFator) * SZ3->Z3_PREMIO2) ,"@E 9,999,999.99") 
      nprepg+=((TRB->TONS/nFator) * SZ3->Z3_PREMIO2)                                      
      nttt+=(nValliq - ((TRB->TONS/nFator) * SZ3->Z3_PREMIO2))      

      //ccol2:=TRANSFORM(TRB->TONS * SZ3->Z3_PREMIO2,"@E 9,999,999.99")               
      //nccol2:=(TRB->TONS * SZ3->Z3_PREMIO2)                                         
      //ccol3:=TRANSFORM(nValliq - (TRB->TONS * SZ3->Z3_PREMIO2) ,"@E 9,999,999.99")  
      //nprepg+=(TRB->TONS * SZ3->Z3_PREMIO2)                                                                
      //nttt+=(nValliq - (TRB->TONS * SZ3->Z3_PREMIO2))      
      // Alexandre Santos 19/07/2013 -------------------------------------------------     
      
   ENDIF                
   cNavio:=TRB->F1_NAVIO
   DBSELECTAREA("CTH")
   DBSETORDER(1)
   DBSEEK(xFILIAL("CTH")+cNavio)   
   cNAVIO  :=""
   cBOOKING:=""
   IF !CTH->(EOF())                                                         
      cNAVIO  :=CTH->CTH_VESSEL
      cBOOKING:=CTH->CTH_BOOKIN
   ENDIF   
   dbselectarea("TRB")
   WNFMAE:=TRB->F1_NFMAE                                             
   
   
   /*dbSelectArea("SZ6")
   dbSetOrder(3)
   IF dbSeek(xFilial("SZ6")+ALLTRIM(TRB->CONTRATO),.F.)
      Do While !SZ6->(EOF()) .AND. SZ6->Z6_CONTRA=TRB->CONTRATO
         IF SZ6->Z6_MEDIA=TRB->C7_NRMEDIA
            cPERIOD:=SZ6->Z6_PERDE
            //Alteracao para verificar Preco Provisorio
            If SZ6->Z6_TIPOPRE == '1'
            	lProvisorio		:= .T.
            EndIf
         ENDIF   
         SZ6->(DBSKIP())
      ENDDO
	  dbSelectArea("SZ5")
	  dbSetOrder(1)
	  If dbSeek( xFilial("SZ5")+TRB->CONTRATO+cPERIOD,.F.)
	     //Z5_DESREAL AS DESC_REAL, Z5_DESREAL*(D1_QUANT/20) VALOR_REAIS
	     nDESC_REAL  := SZ5->Z5_DESREAL
	     nVALOR_REAIS:= SZ5->Z5_DESREAL*(TRB->TONS)
	  ENDIF              

   ENDIF           */

   dbSelectArea("TRB")
    
   /*Alexandre Santos 19/07/2013*/
   /*Trocado => TRANSFORM(TRB->TONS,"@E 999,999.99"),;   
     Por     => TRANSFORM((TRB->TONS/nFator),"@E 999,999.99"),; */ 
   
   AADD(aDados,;
   {TRB->F1_NFMAE,;
   TRB->NF,;
   TRB->F1_EMISSAO,;
   SUBSTR(TRB->CONTRATO,1,15),;
   SUBSTR(TRB->PEDIDO,1,9),;
   TRANSFORM(TRB->SACOS,"@E 9,999,999"),;
   TRANSFORM((TRB->TONS/nFator),"@E 999,999.99"),;     
   IIF(Empty(TRB->D1_XVDEFIN).And. lProvisorio,"P","D"),;
   IIF(Empty(TRB->D1_XVDEFIN),TRANSFORM(TRB->MEDIA,"@E 9,999.99"),TRANSFORM(TRB->D1_XVDEFIN,"@E 9,999.99")),;
   TRANSFORM(TRB->PREMIO     ,"@E 999,999.99"),;
   IIF(Empty(TRB->D1_XVDEFIN),TRANSFORM(TRB->VL_FINAL   ,"@E 9,999.99"),TRANSFORM(TRB->D1_XVDEFIN+TRB->PREMIO,"@E 9,999.99")),;
   TRANSFORM(nValliq   ,"@E 99,999,999.99"),;
   /*TRANSFORM(TRB->DESC_REAL  ,"@E 9,999.99")*/   nDESC_REAL   ,;
   /*TRANSFORM(TRB->VALOR_REAIS,"@E 9,999,999.99")*/     nVALOR_REAIS           ,;
   ccol1,;
   ccol2,;
   ccol3,;
   TRANSFORM(TRB->F1_VALBRUT,"@E 9,999,999.99"),; 
   TRANSFORM(nTAXA,"@E 999.9999"),;
   TRANSFORM(((nValliq * nTAXA)+/*TRB->VALOR_REAIS*/nVALOR_REAIS),"@E 9,999,999.99"),;
   TRANSFORM(((nccol2)*nTAXA),"@E 9,999,999.99"),;
   TRANSFORM(((nValliq * nTAXA)+/*TRB->VALOR_REAIS*/nVALOR_REAIS) - ((nccol2)*nTAXA),"@E 9,999,999.99"),;
   TRANSFORM(((nValliq * nTAXA)+/*TRB->VALOR_REAIS*/nVALOR_REAIS) - TRB->F1_VALBRUT,"@E 9,999,999.99"),;
   TRANSFORM(TRB->F1_VALBRUT-((nccol2)*nTAXA),"@E 9,999,999.99"),;
   TRB->C7_NRMEDIA })
   
   dbselectArea("TRB")
   
   nSacos  +=TRB->SACOS      
   nTons   +=TRB->TONS/nFator     /*Alexandre Santos 19/07/2013*/    
   //nTons   +=TRB->TONS          /*Alexandre Santos 19/07/2013*/   
   nvlusd  +=nValliq                                
   
   nvlreal +=/*TRB->VALOR_REAIS*/nVALOR_REAIS
   
   nTOTPRE  +=nccol2 //total pré-pagto dólar                 
   
   nvlliqusd+=(nValliq - (nccol2)) // tot valor líq em dólar
   nNFFILHA +=TRB->F1_VALBRUT    // total notas filhas           
   nVLTITULO+=((nValliq * nTAXA)+/*TRB->VALOR_REAIS*/nVALOR_REAIS)  // total valor títulos em reais                         
   nTOTPREr  +=((nccol2) * nTaxa)  // total pré pagto em reais
   nTITPRE  +=(((nValliq * nTAXA)+/*TRB->VALOR_REAIS*/nVALOR_REAIS) - ((nccol2)*nTAXA)) // total titulo - pré-pagto
   nCOMPL   +=(((nValliq * nTAXA)+/*TRB->VALOR_REAIS*/nVALOR_REAIS) - TRB->F1_VALBRUT) // complemento
   
   nvlcomp  +=(TRB->F1_VALBRUT - ((nccol2)*nTAXA) )
   
   nSSacos  +=TRB->SACOS      
   nTons   +=TRB->TONS/nFator     /*Alexandre Santos 19/07/2013*/    
   //nTons   +=TRB->TONS          /*Alexandre Santos 19/07/2013*/        
   nSvlusd  +=nValliq                                
   nSvlreal +=/*TRB->VALOR_REAIS*/ nVALOR_REAIS
   
   nSTOTPRE  +=nccol2 //total pré-pagto dólar                 
   
   nSvlliqusd+=(nValliq - (nccol2)) // tot valor líq em dólar
   nSNFFILHA +=TRB->F1_VALBRUT    // total notas filhas           
   nSVLTITULO+=((nValliq * nTAXA)+/*TRB->VALOR_REAIS*/nVALOR_REAIS)  // total valor títulos em reais                         
   
   nSTOTPREr  +=((nccol2) * nTaxa)  // total pré pagto em reais
   
   nSTITPRE  +=(((nValliq * nTAXA)+/*TRB->VALOR_REAIS*/nVALOR_REAIS) - ((nccol2)*nTAXA)) // total titulo - pré-pagto
   nSCOMPL   +=(((nValliq * nTAXA)+/*TRB->VALOR_REAIS*/nVALOR_REAIS) - TRB->F1_VALBRUT) // complemento
   nsvlcomp  +=(TRB->F1_VALBRUT - ((nccol2)*nTAXA) )


   TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo

   IF WNFMAE<>TRB->F1_NFMAE                  
      AADD(aDados,;
      {"",;
      "",;
      "",;
      "",;
      "",;
      TRANSFORM(nSSacos ,"@E 999,999.99"),;
      TRANSFORM(nSTons  ,"@E 999,999.99"),;
      "",;
      "",;
      "",;
      "",;
      TRANSFORM(nSvlusd ,"@E 9,999,999.99"),;
      "",;
      TRANSFORM(nSvlreal,"@E 999,999,999.99"),;
      "",;
      TRANSFORM(nStotpre,"@E 9,999,999.99"),;
      TRANSFORM(nSVLLIQUSD,"@E 9,999,999.99"),;
      TRANSFORM(nSNFFILHA,"@E 9,999,999.99"),;
      "",;
      TRANSFORM(nSVLTITULO,"@E 9,999,999.99"),;
      TRANSFORM(nSTOTPREr,"@E 9,999,999.99"),;
      TRANSFORM(nSTITPRE,"@E 9,999,999.99"),;
      TRANSFORM(nSCOMPL,"@E 9,999,999.99"),;
      TRANSFORM(nsvlcomp,"@E 9,999,999.99"),;
      "" })
      
      nSSacos   =0
      nSTons    =0
      nSvlusd   =0
      nSvlreal  =0
      nSTOTPRE  =0
      nSvlliqusd=0
      nSNFFILHA =0
      nSVLTITULO=0
      nSTOTPREr =0
      nSTITPRE  =0
      nSCOMPL   =0
      nsvlcomp  =0
   ENDIF
EndDo

AADD(aDados,;
{"",;
"",;
"",;
"",;
"",;
TRANSFORM(nSacos ,"@E 999,999.99"),;
TRANSFORM(nTons  ,"@E 999,999.99"),;
"",;
"",;
"",;
"",;
TRANSFORM(nvlusd ,"@E 9,999,999.99"),;
"",;
TRANSFORM(nvlreal,"@E 999,999,999.99"),;
"",;
TRANSFORM(ntotpre,"@E 9,999,999.99"),;
TRANSFORM(nVLLIQUSD,"@E 9,999,999.99"),;
TRANSFORM(nNFFILHA,"@E 9,999,999.99"),;
"",;
TRANSFORM(nVLTITULO,"@E 9,999,999.99"),;
TRANSFORM(nTOTPREr,"@E 9,999,999.99"),;
TRANSFORM(nTITPRE,"@E 9,999,999.99"),;
TRANSFORM(nCOMPL,"@E 9,999,999.99"),;
TRANSFORM(nvlcomp,"@E 9,999,999.99");
})

DlgToExcel( { { "ARRAY", "Relatório", aCabec, aDados} })                                  

Return
