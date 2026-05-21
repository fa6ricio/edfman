#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELOGIS02   บAutor  ณAlexandre Santos  บ Data ณ  17/07/13   บฑฑ
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

User Function Relogis02()
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
cTes     := "598"  // Alexandre Santos - 24/07/2013 - De Para da TES          
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


Define MSDialog oDlg Title OemToAnsi("Parโmetros:") From 0,0 To 420,540 Pixel         
    
    @015,20 Say "Fornecedor:" Pixel Of oDlg
    @015,90 MSGet oVar1  Var cFornece Picture "@!" size 100,10  F3 "SA2" OF oDlg PIXEL

    @040,20 Say "Pedido: " Pixel Of oDlg                                                    
    @040,90 MSGet oVar6  Var cPEDIDO  size 036,10 Picture "@!" Size 38,10 F3 "SC7" VALID U_VER_PEDIDO(cPEDIDO) Pixel  Of oDlg              
    
    @065,20 Say "TES:"  Pixel Of oDlg                                                                             // Alexandre Santos - 24/07/2013 - De Para da TES 
    @065,90 MSGet oVar7  Var cTES  size 050,10 Picture "@!" Size 052,10 F3 "SF4" VALID NAOVAZIO() OF oDlg PIXEL   // 

    //@065,20 Say "Nota Fiscal Mใe:"  Pixel Of oDlg
    //@065,90 MSGet oVar5  Var cNFMAE  size 008,10 Picture "@!" Size 010,10 Pixel  Of oDlg

    //@ 65,20 SAY "Navio" SIZE 60, 8 OF oDlg PIXEL
    //@ 65,90 MSGET oGet VAR cNavio  PICTURE "@!" SIZE 80,9 F3 "CTH" OF oDlg PIXEL

    
    @130,20 Say "Emissใo inicial:" Pixel Of oDlg                                                    
    @130,90 MSGet oVar7 Var dDTfecha1 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg   
    
    @145,20 Say "Emissใo final:" Pixel Of oDlg                                                    
    @145,90 MSGet oVar7 Var dDTfecha2 size 036,10 Picture "@D" Size 038,10 Pixel Of oDlg       

    @ 165,20 SAY "Armaz้m:" SIZE 60,8 OF oDlg PIXEL
    @ 165,90 MSGET oGet VAR cArmazem  PICTURE "99" SIZE 80,9  OF oDlg PIXEL   
    
    
    @180,20 Button oBtnOk     Prompt "&Consulta"       Size 30,15 Pixel Action (U_gerlog02(), oDlg:End()) Of oDlg
    @180,90 Button oBtnCancel Prompt "C&ancelar"       Size 30,15 Pixel Action ( oDlg:End(),lContinua := .F.) Cancel Of oDlg

Activate MSDialog oDlg Centered        


Return .T.                                                                               

User Function Gerlog02 // gera consulta para	 negocia็ใo com o fornecedor.          
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

// Alexandre Santos - 19/07/2013 - adicionado campo c๓digo do produto.

cQuery:="SELECT  "
cQuery+=" F1_NAVIO AS Navios, F1_NFMAE AS NF_Venda, F1_DOC AS NF_Remessa, F1_SERIE, F1_CONTRA AS CONTRATO, F1_XPEDIDO AS PEDIDO, "
cQuery+=" F1_EMISSAO AS EMISSAO,F1_DTCHEGA AS CHEGADA,D1_QUANT AS SACAS, C7_QUANT AS TONS, D1_LOCAL AS ARMAZEM, D1_TES AS TES, " 
cQuery+=" F1_XNOMFOR AS FORNECEDOR, (C7_VLFINAL*C7_QUANT) AS VL_USD, C7_NRMEDIA AS MEDIA, C7_VLFINAL AS VL_FINAL, D1_LOCAL, "
cQuery+=" D1_FALTAS, D1_AVARIAS, D1_SOBRAS, D1_CLVL AS NAVIO, F1_FORNECE, F1_LOJA, D1_COD"
//, D1_QUANT/20 AS TONS, C7_COREMB AS SACARIA, "
//cQuery+=" C7_MEDIA AS MEDIA,C7_VLFINAL-C7_MEDIA AS PREMIO, C7_VLFINAL AS VL_FINAL, D1_FALTAS AS FALTAS, D1_AVARIAS AS AVARIAS, D1_SOBRAS AS SOBRAS,"
//cQuery+=" (D1_QUANT/20)*C7_VLFINAL AS VL_LIQ, Z5_DESREAL AS DESC_REAL, Z5_DESREAL*D1_QUANT VALOR_REAIS, D1_LOCAL AS TERMINAL"
cQuery+=" FROM "+RetSqlname("SF1")
cQuery+=" INNER JOIN "+RetSqlname("SD1")+" ON D1_DOC        = F1_DOC"
cQuery+=" INNER JOIN "+RetSqlname("SC7")+" ON C7_NUM        = F1_XPEDIDO AND C7_NFMAE=F1_NFMAE"
//cQuery+=" INNER JOIN "+RetSqlname("SZ5")+" ON Z5_CONTRA     = F1_CONTRA"
cQuery+=" WHERE"                 
IF !EMPTY(cFORNECE)
   cQuery+=" F1_FORNECE='"+cFornece+"' AND D1_FORNECE='"+cFornece+"' AND "  //AND F1_LOJA='01' AND"
ENDIF                                                                
if !empty(ddtfecha1) .and. !empty(ddtfecha2)
   cQuery+=" F1_EMISSAO>='"+dtos(dDTfecha1)+"' AND F1_EMISSAO<='"+dtos(dDTfecha2)+"' AND " 
endif
if !empty(cPEDIDO)
   cQuery+=" F1_XPEDIDO='"+TRIM(cPEDIDO)+"' AND "                
ENDIF                                       
if !empty(cNavio)
   //cQuery+=" F1_NAVIO='"+cNavio+"' AND "
   //cQuery+=" D1_CLVL='"+cNavio+"' AND "
endif                                                
if !empty(cArmazem)
   cQuery+=" D1_LOCAL='"+cArmazem+"' AND "
endif
cQuery+=" "+Retsqlname("SF1")+".D_E_L_E_T_ <> '*' AND F1_NFMAE<>'' AND "+RetSqlName("SC7")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SD1")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SF1")+".D_E_L_E_T_<>'*'" // AND F1_CP<>'1' "


//IF !EMPTY(cNFMAE)
//   cQuery+=" AND F1_NFMAE='"+TRIM(cNFMAE)+"' "
//ENDIF
cQuery+=" ORDER BY D1_CLVL, F1_XPEDIDO" //" ORDER BY F1_NAVIO, F1_XPEDIDO"

cQuery := ChangeQuery(cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbselectarea("TRB")  

//AAdd(aCampos, "TRB->NAVIOS")
AAdd(aCampos, "TRB->NAVIO") //D1_CLVL
AAdd(aCampos, "TRB->CONTRATO")
AAdd(aCampos, "TRB->PEDIDO")
AAdd(aCampos, "TRB->NF_VENDA")
AAdd(aCampos, "TRB->NF_REMESSA")
AAdd(aCampos, "TRB->SACAS")                                                                            
//AAdd(aCampos, "TRB->TERMINAL")                       
AAdd(aCampos, "TRB->EMISSAO")
AAdd(aCampos, "TRB->CHEGADA")           
//AAdd(aCampos, "TRB->SACARIA")   
//AAdd(aCampos, "TRB->FALTAS")
//AAdd(aCampos, "TRB->AVARIAS")
//AAdd(aCampos, "TRB->SOBRAS")
AADD(aCAMPOS, "TRB->TONS")                                                                                    

AADD(aCAMPOS, "TRB->ARMAZEM")                                                                                    
AADD(aCAMPOS, "TRB->TES")         
AADD(aCAMPOS, "TRB->VL_USD")
AADD(aCAMPOS, "TRB->FORNECEDOR")
AADD(aCAMPOS, "TRB->MEDIA")         
AADD(aCAMPOS, "TRB->VL_FINAL")             
AADD(aCAMPOS, "TRB->D1_FALTAS")
AADD(aCAMPOS, "TRB->D1_AVARIAS")
AADD(aCAMPOS, "TRB->D1_SOBRAS")
                                                                           


AAdd(aCabec ,"Navios")
AAdd(aCabec ,"Contratos")
AAdd(aCabec ,"Pedidos")
AAdd(aCabec ,"NF Vendas")
AAdd(aCabec ,"NF Remessas")
AAdd(aCabec ,"Sacas")         
//AAdd(aCabec ,"Terminal")     
AAdd(aCabec ,"Dt.Emissใo")
AAdd(aCabec ,"Dt.Chegada")   
//AAdd(aCabec ,"Sacaria")
//AAdd(aCabec ,"Faltas")
//AAdd(aCabec ,"Avarias")
//AAdd(aCabec ,"Sobras")  
AADD(ACABEC, "TONELADAS")

AADD(ACABEC, "Armaz้m")
AADD(ACABEC, "TES")         
AADD(ACABEC, "Vl. USD")
AADD(ACABEC, "Fornecedor") 
AADD(ACABEC, "M้dia")         
AADD(ACABEC, "Vl. Final USD")                
AADD(ACABEC, "Faltas")
AADD(ACABEC, "Avarias")
AADD(ACABEC, "Sobras")


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
nvltotalg:=0 
NFALTASG:=0
nvlDesfu:=0
nvlSegur:=0
nvlReale:=0        
wtons:=0
wtonsg:=0
wtonsaux:=0

WNAVIO:=SPAC(10)                           
IF !TRB->(EOF())        
   nFator := U_EDFFATOR(TRB->D1_COD) 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirar o valor pre-fixado                        
   wtons:=TRB->TONS*nFator
   //wtons:=TRB->TONS*20
ENDIF
While !TRB->(EOF())               

   dbSelectArea("SD2")
   dbSetOrder(10)
   dbSeek(xFilial("SD2")+TRB->NF_Remessa+TRB->F1_SERIE)     
   If !SD2->(EOF()) .AND. SD2->D2_TES=cTes .AND. SD2->D2_CLIENTE=TRB->F1_FORNECE .AND. SD2->D2_LOJA=TRB->F1_LOJA  // Alexandre Santos - 24/07/2013 - De Para da TES
   // If !SD2->(EOF()) .AND. SD2->D2_TES="598" .AND. SD2->D2_CLIENTE=TRB->F1_FORNECE .AND. SD2->D2_LOJA=TRB->F1_LOJA
      TRB->(DBSKIP())
      LOOP
   ENDIF                   
   
   dbSelectArea("TRB")

   xDados:={}                    
   
   For n:=1 to Len(aCampos)
       AAdd(xDados, &(aCampos[n])) 
   Next                           
   AAdd(aDados, xDados)
   nvltotal+=TRB->SACAS   
   nvltotalg+=TRB->SACAS   
                                       
   //wtons:=TRB->TONS*20

   WNAVIO :=&(aCampos[1])
   WNFMAE :=&(aCampos[4])      
   WPEDIDO:=&(aCampos[3])      

   nFator := U_EDFFATOR(TRB->D1_COD) 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirar o valor pre-fixado                        
   
   TRB->(dbSkip())
   IF WNAVIO<>&(aCampos[1]) .OR. TRB->(EOF())

      AAdd(aDados ,{" "," "," "," "," ",nvltotal," FALTAM Sacos:", WTONS-nvltotal," Tons. :",(WTONS-nvltotal)/nFator,"","","","","",""})  // Alexandre Santos - 17/07/2013  Incluido nFator   
      // AAdd(aDados ,{" "," "," "," "," ",nvltotal," FALTAM Sacos:", WTONS-nvltotal," Tons. :",(WTONS-nvltotal)/20,"","","","","",""}) // Alexandre Santos - 17/07/2013 - Alteracao para retirar o valor pre-fixado   
            
      IF WPEDIDO<>&(aCampos[3]) .AND. !TRB->(EOF())     
         NFALTASG+=(WTONS-nvltotal)
      ENDIF
      nvltotal:=0                 
      
      
      wtonsg+=wtons
      
      wtonsaux:=0                 
      wtons:=(TRB->TONS*nFator)   // Alexandre Santos - 17/07/2013  Incluido nFator    
      // wtons:=(TRB->TONS*20)           
      
      
      
   ENDIF                
   IF WNFMAE<>&(aCampos[4]) .AND. !TRB->(EOF()) .AND. WNAVIO==&(aCampos[1])
      WTONS+=(TRB->TONS*nFator) // Alexandre Santos - 17/07/2013  Incluido nFator 
      // WTONS+=(TRB->TONS*20)      
   ENDIF
   
End                    
              

AAdd(aDados ,{" "," "," "," "," ",nvltotalg," FALTAM Sacos:",NFALTASG," Sacos :",(NFALTASG)/nFator,"","","","","",""})  // Alexandre Santos - 17/07/2013  Incluido nFator      
// AAdd(aDados ,{" "," "," "," "," ",nvltotalg," FALTAM Sacos:",NFALTASG," Sacos :",(NFALTASG)/20,"","","","","",""})   // Alexandre Santos - 17/07/2013 - Alteracao para retirar o valor pre-fixado   
                
DlgToExcel( { { "ARRAY", "Rela็ใo", aCabec, aDados} })                                  

TRB->(dbcloseArea())


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


While !EOF()

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Verifica o cancelamento pelo usuario...                             ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      //Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      
      @7,00  PSAY "N.F."
      @7,10  PSAY "CONTRATO"
      @7,20  PSAY "PEDIDO"
      @7,30  PSAY "SACOS"
      @7,40  PSAY "TONS"
      @7,53  PSAY "MEDIA"
      @7,65  PSAY "PREMIO"
      @7,75  PSAY "VL_FINAL"
      @7,88  PSAY "VALOR USD"
      @7,101 PSAY "DESC_REAL"
      @7,113 PSAY "VALOR_REAIS"                               
      @7,126 PSAY "PRษ-PAGO TON."
      @7,139 PSAY "PRษ-PAGTO USD"
      @7,156 PSAY "VALOR LอQ."

      nLin := 8
   Endif                    


   @nLin,00  PSAY TRB->NF
   @nLin,10  PSAY SUBSTR(TRB->CONTRATO,1,10)
   @nLin,20  PSAY SUBSTR(TRB->PEDIDO,1,9)
   @nLin,30  PSAY TRANSFORM(TRB->SACOS      ,"@E 9,999,999")
   @nLin,40  PSAY TRANSFORM(TRB->TONS       ,"@E 999,999.99")
   @nLin,51  PSAY TRANSFORM(TRB->MEDIA      ,"@E 9,999.99")
   @nLin,60  PSAY TRANSFORM(TRB->PREMIO     ,"@E 999,999.99")
   @nLin,75  PSAY TRANSFORM(TRB->VL_FINAL   ,"@E 9,999.99")
   @nLin,85  PSAY TRANSFORM(TRB->VL_LIQ     ,"@E 9,999,999.99")
   @nLin,102 PSAY TRANSFORM(TRB->DESC_REAL  ,"@E 9,999.99")
   @nLin,112 PSAY TRANSFORM(TRB->VALOR_REAIS,"@E 9,999,999.99")    
   
   //DBSELECTAREA("SC7")
   //DBSETORDER(1)
   //DBSEEK(xFILIAL("SC7")+TRB->PEDIDO+"0001")
   //IF !SC7->(EOF())
   //   @nLin,126 PSAY TRANSFORM(SC7->C7_PREMIO2,"@E 9,999,999.99")
   //ENDIF
     
   DBSELECTAREA("SZ3")
   DBSETORDER(1)
   DBSEEK(xFILIAL("SZ3")+TRB->CONTRATO)
   IF !SZ3->(EOF())
      @nLin,126 PSAY TRANSFORM(SZ3->Z3_PREMIO2,"@E 9,999,999.99")
      @nLin,139 PSAY TRANSFORM(TRB->TONS * SZ3->Z3_PREMIO2,"@E 9,999,999.99")    
      @nLin,156 PSAY TRANSFORM(TRB->VL_LIQ - (TRB->TONS * SZ3->Z3_PREMIO2) ,"@E 9,999,999.99")
      
      nprepg+=(TRB->TONS * SZ3->Z3_PREMIO2)                                 
      nttt+=(TRB->VL_LIQ - (TRB->TONS * SZ3->Z3_PREMIO2))
      
      
   ENDIF
   
   dbselectArea("TRB")
   
   nSacos  +=TRB->SACOS      
   nTons   +=TRB->TONS       
   nvlusd  +=TRB->VL_LIQ                                
   nvlreal +=TRB->VALOR_REAIS                      

   nLin := nLin + 1 // Avanca a linha de impressao

   TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

@nLin,30  PSAY "---------"
@nLin,40  PSAY "----------"
@nLin,90  PSAY "----------"
@nLin,112 PSAY "------------"
nLin := nLin + 1 // Avanca a linha de impressao
@nLin,28  PSAY TRANSFORM(nSacos ,"@E 999,999.99")
@nLin,40  PSAY TRANSFORM(nTons  ,"@E 999,999.99")
@nLin,85  PSAY TRANSFORM(nvlusd ,"@E 9,999,999.99")
@nLin,112 PSAY TRANSFORM(nvlreal,"@E 9,999,999.99")
@nLin,139 PSAY TRANSFORM(nprepg,"@E 9,999,999.99")    
@nLin,156 PSAY TRANSFORM(nttt,"@E 9,999,999.99")    


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

Return
