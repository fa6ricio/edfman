#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Relogis3    ºAutor  ³Alexandre Santos  º Data ³  17/07/13   º±±
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

User Function Relogis3()
Local oVar1, oVar2, oVar3, oVar4, oVar5, oVar6, oVar7, oVar8, oVar9, oVar10, oBtnOk, oBtnCancel                                      
Private oDlg, cCondic, cNatur, cNavio, cTes, cNFMAE, cContra, cContrato, nPedido, dDTvencto, nTXUSD, nqtdton, xNUMTIT, nVLFINAL,cArmazem
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
cArmazem  := space(02)


Define MSDialog oDlg Title OemToAnsi("Parâmetros:") From 0,0 To 420,540 Pixel         
    
//    @015,20 Say "Fornecedor:" Pixel Of oDlg
//    @015,90 MSGet oVar1  Var cFornece Picture "@!" size 100,10  F3 "SA2" OF oDlg PIXEL

//    @040,20 Say "Pedido: " Pixel Of oDlg                                                    
//    @040,90 MSGet oVar6  Var cPEDIDO  size 036,10 Picture "@!" Size 38,10 F3 "SC7" VALID U_VER_PEDIDO(cPEDIDO) Pixel  Of oDlg              

    //@065,20 Say "Nota Fiscal Mãe:"  Pixel Of oDlg
    //@065,90 MSGet oVar5  Var cNFMAE  size 008,10 Picture "@!" Size 010,10 Pixel  Of oDlg

    @ 65,20 SAY "Navio" SIZE 60, 8 OF oDlg PIXEL
    @ 65,90 MSGET oGet VAR cNavio  PICTURE "@!" SIZE 80,9 F3 "CTH" OF oDlg PIXEL

    
//    @130,20 Say "Emissão inicial:" Pixel Of oDlg                                                    
//    @130,90 MSGet oVar7 Var dDTfecha1 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
//    @145,20 Say "Emissão final:" Pixel Of oDlg                                                    
//    @145,90 MSGet oVar7 Var dDTfecha2 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg       

//    @ 165,20 SAY "Armazém:" SIZE 60,8 OF oDlg PIXEL
//    @ 165,90 MSGET oGet VAR cArmazem  PICTURE "99" SIZE 80,9  OF oDlg PIXEL   
    
    
    @180,20 Button oBtnOk     Prompt "&Consulta"       Size 30,15 Pixel Action (U_gerlog03(), oDlg:End()) Of oDlg
    @180,90 Button oBtnCancel Prompt "C&ancelar"       Size 30,15 Pixel Action ( oDlg:End(),lContinua := .F.) Cancel Of oDlg

Activate MSDialog oDlg Centered        


Return .T.                                                                               

User Function Gerlog03 // gera consulta para negociação com o fornecedor.          
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
Local n
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

cQuery:="SELECT  "
//cQuery+=" F1_NAVIO AS Navios, F1_NFMAE AS NF_Venda, F1_DOC AS NF_Remessa, F1_CONTRA AS CONTRATO, F1_XPEDIDO AS PEDIDO, "
cQuery+=" D1_CLVL AS Navios, F1_NFMAE AS NF_Venda, F1_DOC AS NF_Remessa, F1_CONTRA AS CONTRATO, F1_XPEDIDO AS PEDIDO, F1_VALMERC, "
cQuery+=" F1_EMISSAO AS EMISSAO,F1_DTCHEGA AS CHEGADA,D1_QUANT AS SACAS, C7_QUANT AS TONS, D1_LOCAL AS ARMAZEM, D1_TES AS TES, " 
//cQuery+=" F1_XNOMFOR AS FORNECEDOR, (C7_VLFINAL*C7_QUANT) AS VL_USD, C7_NRMEDIA AS MEDIA, C7_VLFINAL AS VL_FINAL, D1_LOCAL "
 
cQuery+=" F1_XNOMFOR AS FORNECEDOR, (C7_VLFINAL*D1_QUANT) AS VL_USD, C7_NRMEDIA AS MEDIA, C7_VLFINAL AS VL_FINAL, D1_LOCAL, D1_COD " //Z3_PREMIO4 "        // Alexandre Santos - 17/07/2013 - Alteracao para retirar o valor pre-fixado 
// cQuery+=" F1_XNOMFOR AS FORNECEDOR, (C7_VLFINAL*D1_QUANT)/20 AS VL_USD, C7_NRMEDIA AS MEDIA, C7_VLFINAL AS VL_FINAL, D1_LOCAL " //Z3_PREMIO4 "  // Alexandre Santos - 17/07/2013 - Alteracao para retirar o valor pre-fixado 

//cQuery+=" D1_FALTAS, D1_AVARIAS, D1_SOBRAS "
//cQuery+=" FROM "+RetSqlname("SF1")
cQuery+=" FROM "+RetSqlname("SD1")
cQuery+=" INNER JOIN "+RetSqlname("SF1")+" ON F1_DOC        = D1_DOC"
cQuery+=" INNER JOIN "+RetSqlname("SC7")+" ON C7_NUM        = F1_XPEDIDO"
//cQuery+=" INNER JOIN "+RetSqlname("SZ3")+" ON Z3_CONTRA     = D1_DOC"
cQuery+=" WHERE"                 
IF !EMPTY(cFORNECE)
   cQuery+=" F1_FORNECE='"+cFornece+"' AND "  //AND F1_LOJA='01' AND"
ENDIF                                                                
if !empty(ddtfecha1) .and. !empty(ddtfecha2)
   cQuery+=" F1_EMISSAO>='"+dtos(dDTfecha1)+"' AND F1_EMISSAO<='"+dtos(dDTfecha2)+"' AND " 
endif
if !empty(cPEDIDO)
   cQuery+=" F1_XPEDIDO='"+TRIM(cPEDIDO)+"' AND "                
ENDIF                                       
if !empty(cNavio)                      
   //cQuery+=" F1_NAVIO='"+cNavio+"' AND "
   cQuery+=" D1_CLVL='"+cNavio+"' AND "
endif                                                
if !empty(cArmazem)
   cQuery+=" D1_LOCAL='"+cArmazem+"' AND "
endif
//cQuery+=" "+Retsqlname("SF1")+".D_E_L_E_T_ = ' ' AND F1_NFMAE<>''" // AND F1_CP<>'1' "
cQuery+=" "+Retsqlname("SF1")+".D_E_L_E_T_ = ' ' AND F1_NFMAE<>'' AND "+Retsqlname("SD1")+".D_E_L_E_T_ = ' ' AND "+Retsqlname("SC7")+".D_E_L_E_T_ = ' ' "


//IF !EMPTY(cNFMAE)
//   cQuery+=" AND F1_NFMAE='"+TRIM(cNFMAE)+"' "
//ENDIF
cQuery+=" ORDER BY F1_NAVIO, F1_XPEDIDO"

cQuery := ChangeQuery(cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbselectarea("TRB")  

AAdd(aCampos, "TRB->NAVIOS")
AAdd(aCampos, "TRB->CONTRATO")
AAdd(aCampos, "TRB->PEDIDO")
AAdd(aCampos, "TRB->NF_VENDA")
AAdd(aCampos, "TRB->NF_REMESSA")
AAdd(aCampos, "TRB->SACAS")                                                                            
AAdd(aCampos, "TRB->EMISSAO")
AAdd(aCampos, "TRB->CHEGADA")           
AADD(aCAMPOS, "TRB->TONS")                                                                                    
AADD(aCAMPOS, "TRB->ARMAZEM")                                                                                    
AADD(aCAMPOS, "TRB->TES")         
AADD(aCAMPOS, "TRB->VL_USD")
AADD(aCAMPOS, "TRB->FORNECEDOR")
AADD(aCAMPOS, "TRB->MEDIA")         
AADD(aCAMPOS, "TRB->VL_FINAL")      
AADD(aCAMPOS, "TRB->F1_VALMERC")
                                                                           
AAdd(aCabec ,"Navios")
AAdd(aCabec ,"Contratos")
AAdd(aCabec ,"Pedidos")
AAdd(aCabec ,"NF Vendas")
AAdd(aCabec ,"NF Remessas")
AAdd(aCabec ,"Sacas")         
AAdd(aCabec ,"Dt.Emissão")
AAdd(aCabec ,"Dt.Chegada")   
AADD(ACABEC, "Tons.")
AADD(ACABEC, "Armazém")
AADD(ACABEC, "TES")         
AADD(ACABEC, "Vl. USD")
AADD(ACABEC, "Fornecedor") 
AADD(ACABEC, "Média")         
AADD(ACABEC, "Vl. Final USD") 
AADD(ACABEC, "Vl. NF BRL")
AADD(ACABEC, "Desconto") 
AADD(ACABEC, "Desc. BRL")       

if len(aCampos)=0
   msgalert("aCampos vazio")        
   TRB->(dbcloseArea())
   Return
endif

dbselectarea("TRB")  

dbGoTop()                 
if TRB->(EOF())
   msgalert("query vazia 2")
   TRB->(dbcloseArea())
   Return
endif

nvltotal:=0 
nvltotalg:=0 
NFALTASG:=0
nvlDesfu:=0
nvlSegur:=0
nvlReale:=0        
wtons:=0
wtonsg:=0
wtonsaux:=0               
WTONUSD:=0
WTONUSDG:=0    
wsomprem4:=0
wsomprem4g:=0
wtotnf:=0

WNAVIO:=SPAC(10)                           
IF !TRB->(EOF()) 
   
   nFator := U_EDFFATOR(TRB->D1_COD) 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirar o valor pre-fixado                     
   wtons:=TRB->TONS*nFator
   // wtons:=TRB->TONS*20

ENDIF
            


While !TRB->(EOF())
   xDados:={}                    
                         
   nFator := U_EDFFATOR(TRB->D1_COD) 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirar o valor pre-fixado                     
   
   For n:=1 to Len(aCampos)
     
     // Alexandre Santos - 19/07/2013 - Tratamento do fator de conversão
     If aCampos[n] = "TRB->VL_USD"
       AAdd(xDados, &(aCampos[n])/nFator)       
     Else 
       AAdd(xDados, &(aCampos[n])) 
     EndIf  
     
     // AAdd(xDados, &(aCampos[n]))  
     // -----------------------------
       
   Next                           
                        
   WPREMIO4:=0
   DBSELECTAREA("SZ3")
   DBSETORDER(1)
   DBSEEK(xFILIAL("SZ3")+TRB->CONTRATO)
   IF ! SZ3->(EOF())
      WPREMIO4=SZ3->Z3_PREMIO4
   ENDIF                           
   AAdd(xDados, WPREMIO4)     
    // Alexandre Santos - 19/07/2013 - Alteracao para retirar o valor pre-fixado   
   AAdd(xDados, ((TRB->SACAS * WPREMIO4)/nFator))                 
   wsomprem4 +=((TRB->SACAS * WPREMIO4)/nFator)                  
   wsomprem4g+=((TRB->SACAS * WPREMIO4)/nFator)                      
   // AAdd(xDados, ((TRB->SACAS * WPREMIO4)/20))            
   // wsomprem4 +=((TRB->SACAS * WPREMIO4)/20)                     
   // wsomprem4g+=((TRB->SACAS * WPREMIO4)/20)                         
   // ---------------------------------------------------------------------------
   
   DBSELECTAREA("TRB")
   
   AAdd(aDados, xDados)
   nvltotal+=TRB->SACAS   
   nvltotalg+=TRB->SACAS   

   WTONUSD+=TRB->VL_USD
   WTONUSDG+=TRB->VL_USD  
   
   wtotnf+=TRB->F1_VALMERC
                                       
   //wtons:=TRB->TONS*20

   WNAVIO:=&(aCampos[1])
   WNFMAE:=&(aCampos[4])
   
   WCONTRA:=&(aCampos[2])
   WMEDIA :=&(aCampos[14])
   
   TRB->(dbSkip())
   //IF WNAVIO<>&(aCampos[1]) .OR. TRB->(EOF())
   
   IF WCONTRA<>&(aCampos[2]) .OR. WMEDIA<>&(aCampos[14]) .OR. TRB->(EOF())
      //AAdd(aDados ,{" "," "," "," "," ",nvltotal," FALTAM Sacos:", WTONS-nvltotal," Tons. :",(WTONS-nvltotal)/20,"","","","","",""})
      AAdd(aDados ,{" "," "," "," "," ",nvltotal,"", "",(nvltotal)/nFator,"","",WTONUSD,"","","",wtotnf,"",wsomprem4})  // Alexandre Santos - 19/07/2013
      // AAdd(aDados ,{" "," "," "," "," ",nvltotal,"", "",(nvltotal)/20,"","",WTONUSD,"","","",wtotnf,"",wsomprem4})   // Alexandre Santos - 19/07/2013
      NFALTASG+=(WTONS-nvltotal)

      nvltotal:=0                 
            
      wsomprem4:=0
      
      wtonsg+=wtons
      
      wtonsaux:=0                 
      wtons:=(TRB->TONS*20)        
      
      WTONUSD:=0
      
   ENDIF                
   IF WNFMAE<>&(aCampos[4]) .AND. !TRB->(EOF()) .AND. WNAVIO==&(aCampos[1])
      WTONS+=(TRB->TONS*20)
   ENDIF
   
End                    
              

//AAdd(aDados ,{" "," "," "," "," ",nvltotalg," FALTAM Sacos:",NFALTASG," Sacos :",(NFALTASG)/20,"","","","","",""})   
AAdd(aDados ,{" "," "," "," ","Total: ",nvltotalg," ","Tons.: ",(nvltotalg)/nFator,"","",WTONUSDG,"","","",wtotnf,"",wsomprem4g})  // Alexandre Santos - 19/07/2013
// AAdd(aDados ,{" "," "," "," ","Total: ",nvltotalg," ","Tons.: ",(nvltotalg)/20,"","",WTONUSDG,"","","",wtotnf,"",wsomprem4g})  // Alexandre Santos - 19/07/2013                                                                 
                    
WTOTTONS:=(nvltotalg)/20                    
                    
// fechando área de trabalho auxiliar
TRB->(dbcloseArea())
// salando linhas
AAdd(aDados ,{" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "})   
AAdd(aDados ,{"Venda "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "})
AAdd(aDados ,{" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "})       

// 4,6,7

//AAdd(aDados ,{"Navio","Contrato","Pedido","NF Venda"," ","Valor","Dt. Emissão","Armazem","Tons.","Cliente "," ","Tx USD"," ","Média","Vl Final","Vl.R$","R.E.","Data BL"})           

AAdd(aDados ,{"Navio"      , "Contrato"     ,"Pedido","NF Venda" , "Tx USD"       , " ","Dt. Emissão"  ," ","Tons."       , "Armazem","","Valor"      ,"Cliente ","Média"         ,"Vl Final"     ,"Vl.R$"        ,"R.E."     , "S.D."    ,"Data BL"       ,"BL Number"   })           

cQuery:="SELECT  C5_NOTA, F2_DOC, F2_SERIE, F2_VALBRUT, F2_EMISSAO, F2_CLIENTE, F2_LOJA, E1_VALOR, C5_NUM, C5_CONTRAT, C5_QTDTON, C5_NAVIO, "
cQUERY+=" C5_VLFINAL, C5_TAXAUSD, C5_MEDIA,C5_RE, CTH_DTBOOK, CTH_NUMBL, C5_SD, C5_NRMEDIA "
cQuery+=" FROM "+RetSqlname("SC5")    
cQuery+=" INNER JOIN "+RetSqlname("SF2")+" ON F2_DOC=C5_NOTA AND "+Retsqlname("SF2")+".D_E_L_E_T_ = ' '"
cQuery+=" INNER JOIN "+RetSqlname("SE1")+" ON E1_PEDIDO=C5_NUM AND "+Retsqlname("SE1")+".D_E_L_E_T_ = ' '"
cQuery+=" INNER JOIN "+RetSqlname("CTH")+" ON CTH_CLVL=C5_NAVIO AND "+Retsqlname("CTH")+".D_E_L_E_T_ = ' ' "
cQuery+=" WHERE"                 
cQuery+=" C5_NAVIO='"+cNavio+"' AND "
cQuery+=" "+Retsqlname("SC5")+".D_E_L_E_T_ = ' ' "
cQuery+=" ORDER BY C5_NOTA "
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
                        
WTONS:=0        
wvals:=0
wvalb:=0
dbselectarea("TRB")       
dbgotop()
DO WHILE !TRB->(EOF())   
   cFORN:=TRB->F2_CLIENTE
   cLOJA:=TRB->F2_LOJA     
   cPEDIDO:=TRB->C5_NUM                                                                     
   DBSELECTAREA("SA1")
   DBSETORDER(1)
   DBSEEK(xFILIAL("SA1")+cFORN+cLOJA)
   cFORNEC:=SPACE(30)
   IF !SA2->(EOF())
      cFORNEC:=SA1->A1_NOME 
   ENDIF                   
   DBSELECTAREA("SC6")
   DBSETORDER(1)
   DBSEEK(xFILIAL("SC6")+cPEDIDO)
   cARMAZEM:=" "
   IF !SC6->(EOF())
      cARMAZEM:=SC6->C6_LOCAL
   ENDIF
   DBSELECTAREA("TRB")
//   AADD(aDados,{TRB->C5_NAVIO,TRB->C5_CONTRAT,C5_NUM,TRB->F2_DOC," ",TRB->E1_VALOR,TRB->F2_EMISSAO, cARMAZEM,TRB->C5_QTDTON,cFORNEC,TRB->C5_TAXAUSD,TRB->C5_MEDIA,TRB->C5_VLFINAL,TRB->F2_VALBRUT, TRB->C5_RE, TRB->C5_SD, TRB->CTH_DTBOOK,TRB->CTH_NUMBL})        
   AADD(aDados ,{TRB->C5_NAVIO, TRB->C5_CONTRAT,C5_NUM  ,TRB->F2_DOC, TRB->C5_TAXAUSD, " ",TRB->F2_EMISSAO," ",TRB->C5_QTDTON, cARMAZEM ,"",TRB->E1_VALOR ,cFORNEC  , TRB->C5_NRMEDIA,TRB->C5_VLFINAL,TRB->F2_VALBRUT, TRB->C5_RE, TRB->C5_SD, TRB->CTH_DTBOOK,TRB->CTH_NUMBL})        
   WTONS+=TRB->C5_QTDTON                                                          
   wvals+=TRB->E1_VALOR
   wvalb+=TRB->F2_VALBRUT
   TRB->(DBSKIP())
ENDDO
AAdd(aDados ,{" "," "," "," "," "," "," "," ",WTONS," "," ",wvals," "," "," ",wvalb})       
AAdd(aDados ,{" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "})       

/////////////////
AAdd(aDados ,{"Custo "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "})       
AAdd(aDados ,{" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "})       
              
aCampos:={}

dbselectarea("TRB")  
If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif

cQuery:="SELECT  "
cQuery+=" F1_NAVIO AS NAVIOS, F1_NFMAE AS NF_Venda, F1_DOC AS NF, F1_CONTRA AS CONTRATO, F1_XPEDIDO AS PEDIDO, "
cQuery+=" F1_EMISSAO AS EMISSAO,F1_DTCHEGA AS CHEGADA,D1_QUANT AS QTD, D1_LOCAL AS ARMAZEM, D1_TES AS TES, " 
cQuery+=" F1_XNOMFOR AS FORNECEDOR, D1_LOCAL, D1_VUNIT AS VL_UNIT, F1_VALMERC AS VL_TOTAL,"
cQuery+=" D1_FALTAS, D1_AVARIAS, D1_SOBRAS, D1_CLVL AS NAVIO, F1_FORNECE, A2_COD, A2_NOME AS NOME, B1_DESC"    
cQuery+=" , D1_COD "     //
cQuery+=" FROM "+RetSqlname("SF1")
cQuery+=" INNER JOIN "+RetSqlname("SD1")+" ON D1_DOC        = F1_DOC"       
cQuery+=" INNER JOIN "+RetSqlname("SA2")+" ON A2_COD        = F1_FORNECE AND A2_LOJA=F1_LOJA" 
cQuery+=" INNER JOIN "+RetSqlname("SB1")+" ON B1_COD        = D1_COD AND B1_COD<>'000001' AND B1_COD<>'000002' AND B1_COD<>'000003' AND B1_COD<>'000091'"
cQuery+=" WHERE"                 
if !empty(cNavio)
   //cQuery+=" F1_NAVIO='"+cNavio+"' AND "
   cQuery+=" D1_CLVL='"+cNavio+"' AND F1_NAVIO='' AND "
endif                                                
cQuery+=" "+Retsqlname("SF1")+".D_E_L_E_T_ = ' ' AND F1_NFMAE='' AND "+Retsqlname("SD1")+".D_E_L_E_T_ = ' ' "

cQuery+=" ORDER BY NOME, NF"

cQuery := ChangeQuery(cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbselectarea("TRB")  

//AAdd(aCampos, "TRB->NAVIOS")
//AAdd(aCampos, "TRB->CONTRATO")
//AAdd(aCampos, "TRB->PEDIDO")
//AAdd(aCampos, "TRB->NF_VENDA") 

AAdd(aCampos, "TRB->NAVIO")
AAdd(aCampos, "TRB->NF")
AAdd(aCampos, "TRB->EMISSAO")
AADD(ACAMPOS, "TRB->NOME")     
AADD(ACAMPOS, "TRB->B1_DESC")
AAdd(aCampos, "TRB->QTD")                                        
AAdd(aCampos, "TRB->VL_UNIT")
AADD(ACAMPOS, "(TRB->VL_UNIT*TRB->QTD)")                                    
//AAdd(aCampos, "TRB->CHEGADA")           
//AADD(aCAMPOS, "TRB->TONS")                                                                                    
//AADD(aCAMPOS, "TRB->ARMAZEM")                                                                                    
//AADD(aCAMPOS, "TRB->TES")         
//AADD(aCAMPOS, "TRB->VL_USD")
//AADD(aCAMPOS, "TRB->FORNECEDOR")
//AADD(aCAMPOS, "TRB->MEDIA")         
//AADD(aCAMPOS, "TRB->VL_FINAL")             
//AADD(aCAMPOS, "TRB->D1_FALTAS")
//AADD(aCAMPOS, "TRB->D1_AVARIAS")
//AADD(aCAMPOS, "TRB->D1_SOBRAS")

if len(aCampos)=0
   msgalert("aCampos vazio")        
   TRB->(dbcloseArea())
   Return
endif

dbselectarea("TRB")  

dbGoTop()                 
//if TRB->(EOF())
//   msgalert("query vazia 3")
//   TRB->(dbcloseArea())
//   Return
//endif

nvltotal:=0 
nvltotalg:=0 
NFALTASG:=0
nvlDesfu:=0
nvlSegur:=0
nvlReale:=0        
wtons:=0
wtonsg:=0
wtonsaux:=0

WNAVIO:=SPAC(10)                           
//IF !TRB->(EOF())
//   wtons:=TRB->TONS*20
//ENDIF     
nSvltotal:=0
While !TRB->(EOF())

   nFator := U_EDFFATOR(TRB->D1_COD) 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirar o valor pre-fixado                     

   xDados:={}                    
   
   For n:=1 to Len(aCampos)
       AAdd(xDados, &(aCampos[n])) 
   Next                           
   AAdd(aDados, xDados)
   
   
   nvltotal+=(TRB->VL_UNIT*TRB->QTD)
   nSvltotal+=(TRB->VL_UNIT*TRB->QTD)
   
   /*
   nvltotal+=TRB->SACAS   
   nvltotalg+=TRB->SACAS   
                                       
   //wtons:=TRB->TONS*20

   WNAVIO:=&(aCampos[1])
   WNFMAE:=&(aCampos[4])
   */        
                           
   
   WFORNEC:=TRB->NOME
   WSERVIC:=TRB->B1_DESC
   
   TRB->(dbSkip())                                            
   
   //IF WNAVIO<>&(aCampos[1]) .OR. TRB->(EOF())
   IF WFORNEC<>&(aCampos[4]) .OR. WSERVIC<>&(aCampos[5])
      //AAdd(aDados ,{" "," "," "," "," ",nvltotal," FALTAM Sacos:", WTONS-nvltotal," Tons. :",(WTONS-nvltotal)/20,"","","","","",""})
      
      //NFALTASG+=(WTONS-nvltotal)

      //nvltotal:=0                 
      AAdd(aDados ,{" "," "," "," "," "," "," ", nSvltotal," "," "," "," "," "," "," "," "})       
      
      nSvltotal:=0

      //wtonsg+=wtons
      
      //wtonsaux:=0                 
      //wtons:=(TRB->TONS*20)        
      
      
      
   ENDIF                
   IF WNFMAE<>&(aCampos[4]) .AND. !TRB->(EOF()) .AND. WNAVIO==&(aCampos[1])
      WTONS+=(TRB->TONS*20) // Alexandre Santos - 19/07/2013  
      //WTONS+=(TRB->TONS*20) // Alexandre Santos - 19/07/2013      
   ENDIF
   */
   
End                    

AAdd(aDados ,{" "," "," "," "," "," "," ", nvltotal,(nvltotal/WTOTTONS)," "," "," "," "," "," "," "})       
                                                                                      
AAdd(aDados ,{" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "})       
AAdd(aDados ,{" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "})       
//////////////// 
DlgToExcel( { { "ARRAY", "Compra", aCabec, aDados} })                                  

TRB->(dbcloseArea())


Return Nil
                             
