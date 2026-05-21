#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELOGIS04   ºAutor  ³Alexandre Santos  º Data ³  19/07/13   º±±
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


User Function Relogis4()
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
cTes     := "018"     // Alexandre Santos - 24/07/2013 - De Para da TES      
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
    
    @015,20 Say "Fornecedor:" Pixel Of oDlg
    @015,90 MSGet oVar1  Var cFornece Picture "@!" size 100,10  F3 "SA2" OF oDlg PIXEL

    @040,20 Say "Pedido: " Pixel Of oDlg                                                    
    @040,90 MSGet oVar6  Var cPEDIDO  size 036,10 Picture "@!" Size 38,10 F3 "SC7" VALID U_VER_PEDIDO(cPEDIDO) Pixel  Of oDlg              

    @065,20 Say "Nota Fiscal Mãe:"  Pixel Of oDlg
    @065,90 MSGet oVar5  Var cNFMAE  size 008,10 Picture "@!" Size 010,10 Pixel  Of oDlg
                     
    @090,20 SAY "Contrato:" SIZE 60, 8 OF oDlg PIXEL
    @090,90 MSGET oVar2 VAR cContra PICTURE "@!" SIZE 80,9 F3 "CN9" VALID ExistChav("CN9",cContra) OF oDlg PIXEL 
    
    @115,20 SAY "Data de referência:" SIZE 60, 8 OF oDlg PIXEL
    @115,90 COMBOBOX oCombocor VAR cCorEmb ITEMS aCombocor SIZE 80,9 PIXEL OF oDlg PIXEL         

    @130,20 Say "Data inicial:" Pixel Of oDlg                                                    
    @130,90 MSGet oVar7 Var dDTfecha1 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
    @145,20 Say "Data final:" Pixel Of oDlg                                                    
    @145,90 MSGet oVar7 Var dDTfecha2 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
    @180,20 Button oBtnOk     Prompt "&Consulta"       Size 30,15 Pixel Action (U_gerlog04(), oDlg:End()) Of oDlg
    @180,90 Button oBtnCancel Prompt "C&ancelar"       Size 30,15 Pixel Action ( oDlg:End(),lContinua := .F.) Cancel Of oDlg

Activate MSDialog oDlg Centered        

Return .T.                                                                               

user Function Gerlog04
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

Private cString := "SC5"
Private cQuery  :=""
            
If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif

cQuery:="SELECT"
cQuery+=" F1_NAVIO AS Navios, F1_NFMAE AS NF_Venda, F1_DOC AS NF_Remessa, F1_CONTRA AS CONTRATO, F1_XPEDIDO AS PEDIDO, "
cQuery+=" F1_EMISSAO AS EMISSAO,F1_DTCHEGA AS CHEGADA,D1_QUANT AS SACAS, D1_QUANT/20 AS TONS, C7_COREMB AS SACARIA, "
cQuery+=" C7_MEDIA AS MEDIA,C7_VLFINAL-C7_MEDIA AS PREMIO, C7_VLFINAL AS VL_FINAL, D1_FALTAS AS FALTAS, D1_AVARIAS AS AVARIAS, D1_SOBRAS AS SOBRAS,"
cQuery+=" (D1_QUANT)*C7_VLFINAL AS VL_LIQ, Z5_DESREAL AS DESC_REAL, Z5_DESREAL*D1_QUANT VALOR_REAIS, D1_LOCAL AS TERMINAL, F1_XNOMFOR, D1_COD "        // Alexandre Santos - 19/07/2013 - Alteração para retirar o valor pre-fixado 
//cQuery+=" (D1_QUANT/20)*C7_VLFINAL AS VL_LIQ, Z5_DESREAL AS DESC_REAL, Z5_DESREAL*D1_QUANT VALOR_REAIS, D1_LOCAL AS TERMINAL, F1_XNOMFOR "   // Alexandre Santos - 19/07/2013 - Alteração para retirar o valor pre-fixado 

cQuery+=" FROM "+RetSqlname("SF1")
cQuery+=" INNER JOIN "+RetSqlname("SD1")+" ON D1_DOC        = F1_DOC AND D1_FORNECE=F1_FORNECE AND D1_TES IN ('006', '017') "     // Alexandre Santos - 24/07/2013 - De Para da TES
// cQuery+=" INNER JOIN "+RetSqlname("SD1")+" ON D1_DOC        = F1_DOC AND D1_FORNECE=F1_FORNECE AND D1_TES IN ('006', '009') "
cQuery+=" INNER JOIN "+RetSqlname("SC7")+" ON C7_NUM        = F1_XPEDIDO"
cQuery+=" INNER JOIN "+RetSqlname("SZ5")+" ON Z5_CONTRA     = F1_CONTRA"
cQuery+=" WHERE"                 
IF !EMPTY(cFORNECE)
   cQuery+=" F1_FORNECE='"+cFornece+"' AND"  //AND F1_LOJA='01' AND"
ENDIF   
if cCorEmb="Data Emissão"
   cQuery+=" F1_EMISSAO>='"+dtos(dDTfecha1)+"' AND F1_EMISSAO<='"+dtos(dDTfecha2)+"' AND  "+RetSqlName("SC7")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SD1")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SF1")+".D_E_L_E_T_<>'*' "
else 
   cQuery+=" F1_DTCHEGA>='"+dtos(dDTfecha1)+"' AND F1_DTCHEGA<='"+dtos(dDTfecha2)+"' AND  "+RetSqlName("SC7")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SD1")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SF1")+".D_E_L_E_T_<>'*' "
endif   
if !empty(cPEDIDO)
   cQuery+=" AND F1_XPEDIDO='"+TRIM(cPEDIDO)+"' "
ENDIF                                       
IF !EMPTY(cNFMAE)
   cQuery+=" AND F1_NFMAE='"+TRIM(cNFMAE)+"' "
ENDIF                
if !EMPTY(cCONTRA)
   cQuery+=" AND C7_CONTRAT = '"+cCONTRA+"' "
ENDIF

cQuery+=" ORDER BY F1_EMISSAO, F1_XNOMFOR, F1_CONTRA, D1_LOCAL "

cQuery := ChangeQuery(cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbselectarea("TRB")  

AAdd(aCampos, "TRB->NAVIOS")
AAdd(aCampos, "TRB->CONTRATO")
AAdd(aCampos, "TRB->F1_XNOMFOR")
AAdd(aCampos, "TRB->PEDIDO")
AAdd(aCampos, "TRB->NF_VENDA")
AAdd(aCampos, "TRB->NF_REMESSA")
AAdd(aCampos, "TRB->SACAS")                                                                            
AAdd(aCampos, "TRB->TERMINAL")                       
AAdd(aCampos, "TRB->EMISSAO")
AAdd(aCampos, "TRB->CHEGADA")           
AAdd(aCampos, "TRB->SACARIA")   
AAdd(aCampos, "TRB->FALTAS")
AAdd(aCampos, "TRB->AVARIAS")
AAdd(aCampos, "TRB->SOBRAS")

AAdd(aCabec ,"Navios")
AAdd(aCabec ,"Contratos")
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

nvltotal:=0
nvlDesfu:=0
nvlSegur:=0
nvlReale:=0

nsvltotal:=0
nsvlDesfu:=0
nsvlSegur:=0
nsvlReale:=0
                           
While !TRB->(EOF())               

   nFator := U_EDFFATOR(TRB->D1_COD) 	  // Alexandre Santos - 19/07/2013 - Alteracao para retirar o valor pre-fixado                        

   IF EMPTY(TRB->NF_Venda)
      TRB->(DBSKIP())
      LOOP
   ENDIF   
   xDados:={}          
   For n:=1 to Len(aCampos)              
       IF TRIM(aCampos[n])=="TRB->EMISSAO"
          AAdd(xDados, STOD(&(aCampos[n])))  
       ELSEIF TRIM(aCampos[n])=="TRB->CHEGADA"
          AAdd(xDados, STOD(&(aCampos[n])))         
       ELSEIF TRIM(aCampos[n])=="TRB->VL_LIQ"   // Alexandre Santos - 19/07/2013   
          AAdd(xDados, &(aCampos[n])/nFator)    // Alexandre Santos - 19/07/2013           
       ELSE
          AAdd(xDados, &(aCampos[n])) 
       ENDIF   
   Next                           
   AAdd(aDados, xDados)
   nvltotal+=TRB->SACAS
   nvlDesfu+=TRB->FALTAS
   nvlSegur+=TRB->AVARIAS
   nvlReale+=TRB->SOBRAS

   nsvltotal+=TRB->SACAS
   nsvlDesfu+=TRB->FALTAS
   nsvlSegur+=TRB->AVARIAS
   nsvlReale+=TRB->SOBRAS
   
   wdata =TRB->EMISSAO         
   wforn =TRB->F1_XNOMFOR                  
   wcontr=TRB->CONTRATO
   
   TRB->(dbSkip())      
   
   IF wdata<>TRB->EMISSAO .OR. TRB->(EOF()) .or. wforn<>TRB->F1_XNOMFOR .OR. wcontr<>TRB->CONTRATO            
      AAdd(aDados ,{" "," "," "," "," "," ",nsvltotal,nsvltotal/nFator,"","","",nsvlDesfu,nsvlSegur,nsvlReale})   // Alexandre Santos - 19/07/2013   
      // AAdd(aDados ,{" "," "," "," "," "," ",nsvltotal,nsvltotal/20,"","","",nsvlDesfu,nsvlSegur,nsvlReale})    // Alexandre Santos - 19/07/2013   
      nsvltotal:=0
      nsvlDesfu:=0
      nsvlSegur:=0
      nsvlReale:=0
   ENDIF
End                    
              
AAdd(aDados ,{" "," "," "," "," "," ",nvltotal,nvltotal/nFator,"","","",nvlDesfu,nvlSegur,nvlReale}) // Alexandre Santos - 19/07/2013
//AAdd(aDados ,{" "," "," "," "," "," ",nvltotal,nvltotal/20,"","","",nvlDesfu,nvlSegur,nvlReale}) // Alexandre Santos - 19/07/2013
                
DlgToExcel( { { "ARRAY", "Relatório", aCabec, aDados} })                                  

TRB->(dbcloseArea())

Return Nil
                             

