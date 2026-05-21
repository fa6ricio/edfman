///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | GERARIEX.prw         | AUTOR | ADRIANO      | DATA | 23/09/2011 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Gera Riex a partir de n.f. selecionadas                         |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

#include 'rwmake.ch'
#include "protheus.ch"
#include "TOPCONN.ch"
#include "Fileio.ch"


User Function GERARIEX()    
                     
Local _lRetorno     := .F.                                                     //Validacao da dialog criada oDlg 
Local _nOpca        := 0                                                       //Opcao da confirmacao 
Local bOk           := {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() }               //botao de ok 
Local bCancel       := {|| _nOpca:=0,oDlg:End() }                              //botao de cancelamento 
Local _cArqEmp      := ""                                                      //Arquivo temporario com as empresas a serem escolhidas 
Local _aStruTrb     := {}                                                      //estrutura do temporario 
Local _aBrowse      := {}                                                      //array do browse para demonstracao das empresas 
Local _aEmpMigr     := {}                                                        //array de retorno com as empresas escolhidas   
Private lInverte    := .F.                                                     //Variaveis para o MsSelect 
Private cMarca      := GetMark()                                               //Variaveis para o MsSelect 
Private oBrwTrb                                                                   //objeto do msselect 
Private oDlg 

Private nSaldoTot :=0  // Controla o Saldo utilizado.               
Private nDiferen  :=0  // Controla a diferença que falta alocar. (ou seja, qtd que ainda falta pra zerar a n.f. de venda... na tela)      


private aFields   := {}
Private aButtons  :={}
private cCadastro := "Escolher Notas"
Private cPerg       := "Riex01"      
Private cAlias   
Private oQtda                                                


// Define campos temporários
aadd(aFields,{'OK', 'C', 02,0})
aadd(aFields,{'NF'   , 'C', 09,0})
aadd(aFields,{'SERIE','C',03,0})  
aadd(aFields,{'EMISSAO','D',08,0})
aadd(aFields,{'FORNEC','C',06,0})                        
aadd(aFields,{'LOJA','C',02,0})
aadd(aFields,{'UF','C',02,0})
aadd(aFields,{'TES'  , 'C', 03,0})                 
aadd(aFields,{'QTD'  , 'N', 14,2})   
aadd(aFields,{'UTILIZ','N',14,2})        
aadd(aFields,{'QTDTELA','N',14,2})   
aadd(aFields,{'PRODUTO','C',15,0})
aadd(aFields,{'VALOR','N',16,2})   
aadd(aFields,{'ITEM','C',4,0})   
// Cria arquivo

if SELECT("TMP") > 0 
   TMP->( dbCloseArea() )
Endif

cAliasTrb := "TMP"
oAliasTrb:= FwTemporarytable():New(cAliasTrb,aFields)
oAliasTrb:Create()      

aadd(_aBrowse,{'OK', , ''})        
aadd(_aBrowse,{'NF'   , , 'N.F.'})
aadd(_aBrowse,{'SERIE',,'Série'}) 
aadd(_aBrowse,{'EMISSAO',,'Emissão'})
aadd(_aBrowse,{'FORNEC', ,'Fornec.'})
aadd(_aBrowse,{'LOJA', ,'Loja'})
aadd(_aBrowse,{'UF', ,'Estado Forn.'})
aadd(_aBrowse,{'TES'  , , 'Tes' })
aadd(_aBrowse,{'QTD'  , , 'Qtd.'})
aadd(_aBrowse,{'UTILIZ'  , , 'Saldo Utilizado'})
aadd(_aBrowse,{'QTDTELA', , 'Utilizar?'})
aadd(_aBrowse,{'PRODUTO', ,'Produto'})
aadd(_aBrowse,{'VALOR', , 'Valor Total'})
aadd(_aBrowse,{'ITEM', , 'Item'})
dbselectarea('TMP')
dbgotop()

aadd(aButtons,{"CARGA", {|| ALTQTD()}, "Alterar Qtd."})
aadd(aButtons,{"HISTORIC", {|| LimpaHist()}, "Limpa Histórico"})

ValidPerg()
If pergunte(cPerg,.T.)

   cQuery := "SELECT C5_CONTRAT AS CONTRATO FROM "+RetSqlName("SC5")+" WHERE C5_NOTA = '"+MV_PAR07+"'"
   If Select("TRB") > 0
      TRB->(DbCloseArea())
   Endif
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
   dbselectarea("TRB")                                         

   If ALLTRIM(TRB->CONTRATO) <> ALLTRIM(MV_PAR06)
       MsgAlert("Nota: "+alltrim(MV_PAR07)+", está amarrada ao contrato: "+TRB->CONTRATO+". Processo Encerrado!"+chr(13)+chr(10)+"Solicitado contrato: "+ALLTRIM(MV_PAR06)) 
       Return .t.
   Endif

   dbSelectArea("SZU")
   dbSetorder(1)
   If dbSeek( xFilial("SZU")+mv_par07 )
       If !MsgYesNo("Nota Utilizada anteriormente, deseja continuar?") 
          Return .t.
       Endif
   Endif

   dbSelectArea("SF2")
   dbSetOrder(1)
   dbSeek(xFilial("SF2")+alltrim(mv_par07),.F.)
   IF SF2->(EOF()) .OR. Alltrim(SF2->F2_DOC)<>alltrim(mv_par07)
      MSGALERT("Nota fiscal de saída não existe!")
      RETURN .T.  
   ENDIF       

   cQuery:="SELECT F1_CONTRA AS CONTRATO, F1_DOC AS DOC,F1_SERIE AS SERIE,F1_EMISSAO AS EMISSAO,F1_FORNECE AS FORCLI,F1_LOJA AS LOJA, F1_EST, "
   cQuery+="D1_TES AS TES,D1_LOCAL AS ARMAZEM,D1_ITEM AS ITEM, D1_COD AS COD,D1_UM AS UM,D1_QUANT AS QUANT,D1_VUNIT AS VALOR,D1_TOTAL AS TOTAL, D1_SDUTIL, D1_QTDTELA "

   cQuery+=" FROM "+RetSqlname("SD1")
   cQuery+=" INNER JOIN "+RetSqlname("SF1")+" ON F1_DOC = D1_DOC AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA"
   cQuery+=" WHERE"                 
   cQuery+=" D1_TES IN ('006', '009') AND"
   cQuery+=" F1_EMISSAO>='"+dtos(mv_par01)+"' AND F1_EMISSAO<='"+dtos(mv_par02)+"' AND  "+RetSqlName("SF1")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SD1")+".D_E_L_E_T_<>'*' "
   cQuery+=" AND D1_LOCAL>='"+mv_par03+"' AND D1_LOCAL<='"+mv_par04+"' "
   If mv_par08=2
      cQuery+=" AND D1_QUANT>D1_SDUTIL "
   EndIf   
   IF !EMPTY(mv_par05)
      cQuery+=" AND F1_CONTRA='"+alltrim(mv_par05)+"' "
   ENDIF   
     
   cQuery+=" ORDER BY EMISSAO, TES "
   cQuery := ChangeQuery(cQuery)
   If Select("TRB") > 0
      TRB->(DbCloseArea())
   Endif
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
   dbselectarea("TRB")       
   While !TRB->(EOF())                         
	  DBUseArea(.T.,"TOPCONN",TCGENQRY(,,"SELECT ISNULL(COUNT(*),0) as SOMA FROM "+RetSqlName("SD2")+" where D_E_L_E_T_ = ' ' AND D2_NFORI = '"+TRB->DOC +"' AND D2_CLIENTE = '"+TRB->FORCLI+"'"),"AUXa",.F.,.T.)
      If AUXa->SOMA == 0 
	      RecLock("TMP",.T.)                   
	      TMP->NF := TRB->DOC 
	      TMP->SERIE:=TRB->SERIE         
	      TMP->EMISSAO:=STOD(TRB->EMISSAO)
	      TMP->TES:= TRB->TES
	      TMP->QTD:= TRB->QUANT          
	      TMP->FORNEC:= TRB->FORCLI  
	      TMP->LOJA:=TRB->LOJA      
	
	      dbSelectArea("SA2")
	      dbSetOrder(1)
	      dbseek(xFilial("SA2")+TRB->FORCLI+TRB->LOJA,.F.)
	      TMP->UF:=SA2->A2_EST
	      dbSelectArea("TMP")
	      
	      TMP->UTILIZ	:= TRB->D1_SDUTIL  //quantidade já utilizada para geração de Riex.
	      TMP->QTDTELA	:= 0                 
	      TMP->PRODUTO	:= TRB->COD             
	      TMP->ITEM		:= TRB->ITEM
	      TMP->VALOR	:= TRB->TOTAL
	      Msunlock()  
	  Endif
      AUXa->( dbCloseArea() ) 
      
      TRB->(dbSkip())

   End
    
   TMP->(dbGoTop())
   cAlias:=ALIAS()        
   nDiferen:=SF2->F2_VOLUME1
   
   @ 001,001 TO 600,1200 DIALOG oDlg TITLE OemToAnsi("Notas Fiscais para Riex") 
                                                                                            
   @230,350 SAY   "Nota Fiscal Venda: "+mv_par07 Size 240,13 COLOR CLR_GREEN OF oDlg PIXEL
   @245,350 SAY   "Qtd. n.f. venda  : "+Transform(SF2->F2_VOLUME1,"@E 999,999,999.99") Size 240,13 COLOR CLR_GREEN OF oDlg PIXEL
   @260,350 SAY   "Qtd.  Selecionada:" Size 240,13 COLOR CLR_GREEN OF oDlg PIXEL
   @260,450 MSGet oVar1  Var nSaldoTot Picture "@e 999,999,999.99" size 90,10  OF oDlg PIXEL
   @275,350 SAY   "Diferença:" Size 240,13 COLOR CLR_GREEN OF oDlg PIXEL
   @280,450 MSGet oVar2  Var nDiferen  Picture "@e 999,999,999.99" size 90,10  OF oDlg PIXEL
   
   oBrwTrb := MsSelect():New("TMP","OK","",_aBrowse,@lInverte,@cMarca,{025,001,230,600})   
   oBrwTrb:bMark := {||U_MarcaBx()} 
   
   Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,aButtons)) Centered VALID _lRetorno .and. v_dif(nDiferen)

   TMP->(DbGotop())   
   If _nOpca == 1 
      GERA_ARQ()
   Endif 
   
   TRB->(dbCloseArea())
   TMP->(dbCloseArea())
EndIf                                                           

Return .T.


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Adriano      | DATA | 18/01/2011 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_MarcaBox()                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function MarcaBx()

If TMP->OK==SPACE(2)	
   nSaldoTot  -= (TMP->QTD - TMP->UTILIZ)
   nDiferen   += (TMP->QTD - TMP->UTILIZ)

   RecLock("TMP",.F.)
   //TMP->UTILIZ := 0
   TMP->QTDTELA:=0
   MsUnLock()                             
Else               
   If (TMP->QTD - TMP->UTILIZ) == 0 
      Return .f.
   Endif
   nSaldoTot  += (TMP->QTD - TMP->UTILIZ)
   nDiferen   -= (TMP->QTD - TMP->UTILIZ)

   RecLock("TMP",.F.)
   TMP->QTDTELA:=TMP->QTD - TMP->UTILIZ
   MsUnLock()                             
Endif                    

oBrwTrb:oBrowse:Refresh()
oVar1:Refresh()            
oVar2:Refresh()
ObjectMethod(oDlg,"Refresh()")  
                                                                                
Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValidPerg ³ Autor ³Adriano Migoto Pinto   ³ Data ³ 14/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajuste de Perguntas (SX1)                 			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ValidPerg()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MP8                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidPerg()
PutSx1(cPerg,"01","De            ?" ,"","","mv_ch1","D", 8,0,0,"G","","","","","mv_par01")
PutSx1(cPerg,"02","Até           ?" ,"","","mv_ch2","D", 8,0,0,"G","","","","","mv_par02")
PutSx1(cPerg,"03","Do Armazém    ?" ,"","","mv_ch3","C", 2,0,0,"G","","","","","mv_par03")
PutSx1(cPerg,"04","Até o Armazém ?" ,"","","mv_ch4","C", 2,0,0,"G","","","","","mv_par04")  
PutSx1(cPerg,"05","Contrato Compra?","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05")  
PutSx1(cPerg,"06","Contrato Venda?" ,"","","mv_ch6","C",15,0,0,"G","","","","","mv_par06") 
PutSx1(cPerg,"07","Nota de Venda?"  ,"","","mv_ch7","C",09,0,0,"G","","","","","mv_par07")   
PutSx1(cPerg,"08","já utilizadas?"  ,"","","mv_ch8","N",01,0,0,"C","","",,,"mv_par08" ,"Sim",,,,"Nao",,,,,,,,,,,,,,,)    
//PutSx1(cPerg,"09","País destino ?","","","mv_ch9","C",30,0,0,"G","","","","","mv_par09")  
Return .T.                                                                                         



STATIC FUNCTION ALTQTD
Local oVar1, oBtnOk, oBtnCancel
Private oDlg1, nQuant
nQuant:=TMP->QTD
Define MSDialog oDlg1 Title OemToAnsi("Alteração da quantidade a utilizar:") From 0,0 To /*420*/100,540 Pixel
@15,20 Say "Qtd. a utilizar:"  Pixel Of oDlg1
@15,90 MSGet oVar1  Var nQuant     size 050,10 Picture "@e 999,999,999.99" Size 38,10 Pixel  Of oDlg1      
@15,180 Button oBtnOk     Prompt "&Grava"         Size 30,15 Pixel Action (GRAVALT01(), oDlg1:End()) Of oDlg1
@15,230 Button oBtnCancel Prompt "C&ancela"       Size 30,15 Pixel Action ( oDlg1:End(),lContinua := .F.) Cancel Of oDlg1
Activate MSDialog oDlg1 Centered
RETURN .T.
 
STATIC FUNCTION GRAVALT01   
If nQuant>TMP->QTD
   Msgalert("Quantidade não disponível")
   Return .T.
EndIf
nSaldoTot  -= TMP->QTDTELA        
nSaldoTot  += nQuant       
nDiferen   += TMP->QTDTELA       
nDiferen   -= nQuant       

RecLock("TMP",.F.)
TMP->QTDTELA := nQuant       
MsUnLock()                             

RETURN .T.
                                                                                                     


Static Function GERA_ARQ                               
Local lExisArq:=.F.
TMP->(dbGoTop())
Do While !TMP->(EOF())     
   If !EMPTY(TMP->OK) .AND. TMP->OK==cMARCA
      dbSelectarea("SD1")
      dbSetOrder(1)   
              //  D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
      If DBSEEK(xFILIAL("SD1")+TMP->NF+TMP->SERIE+TMP->FORNEC+TMP->LOJA+TMP->PRODUTO+TMP->ITEM)
      
         lExisArq:=.T.     
      
         //Abaixo temos duas situações, na SD1 gravo sempre o saldo já utilizado e o último Riex gerado com a nota de compra
         //na tabela SZU gravo um histórico de todos os Riex gerados.
                          
         RecLock("SD1",.F.)     
         SD1->D1_NFRIEX := ALLTRIM(mv_par07) // grava número da nota fiscal de venda usada no Riex. (último riex gerado com essa nota)

         if (SD1->D1_SDUTIL+TMP->QTDTELA)  > SD1->D1_QUANT
            SD1->D1_SDUTIL=TMP->QTDTELA   //saldo já utilizado no Riex.
         else
            SD1->D1_SDUTIL+=TMP->QTDTELA  //saldo já utilizado no Riex.
         endif
         MsUnLock()                             

         dbSelectArea("SF2")
         dbSetOrder(1)
         dbSeek(xFilial("SF2")+alltrim(mv_par07),.F.)
         
         RecLock("SZU",.T.)      // TABELA CRIADA PRA ARMAZENAR N.F. DE REMESSA (COMPRAS) UTILIZADAS NO RIEX.
         SZU->ZU_NOTA    := alltrim(mv_par07)
         SZU->ZU_SERIE   := SF2->F2_SERIE         // TROCAREI POR POSICIONE...
         SZU->ZU_NFR     := SD1->D1_DOC
         SZU->ZU_SRREM   := SD1->D1_SERIE
         SZU->ZU_FORNECE := SD1->D1_FORNECE
         SZU->ZU_LOJA    := SD1->D1_LOJA
         SZU->ZU_QTDUTZ  := TMP->QTDTELA // QUANTIDADE UTILIZADA NESSE RIEX.                                                                                    
         SZU->ZU_PRODUTO := SD1->D1_COD
         SZU->ZU_ITEM    := SD1->D1_ITEM
         SZU->ZU_DATA    := DATE()
         MsUnLock()                             
      ENDIF
      dbSelectarea("TMP")
   EndIf                   
   
   TMP->(dbSkip())
Enddo            
If lExisArq                       
   //Incluir aqui rotina que gera o xml
   Cria_XML()
Else
   MsgAlert("Arquivo não gerado!")
EndIf
Return .T.   
            
///  *****************************************************************************************************
Static Function Cria_XML             

If (nHandle:=FCREATE("C:\XML\RIEX_NFS_"+alltrim(mv_par07)+".xml",0))==-1
   MsgAlert("Arquivo não gerado!")
   Return .T.
Endif                           
If (nHandleX:=FCREATE("C:\XML\RIEX_NFS_"+alltrim(mv_par07)+".CSV",0))==-1
   MsgAlert("Arquivo não gerado!")
   Return .T.
Endif                           
//CRIANDO XLS
_cexcel=CHR(13)+CHR(10)
FWRITE(nHandleX, _cexcel)  
_cexcel="RIEX;"+CHR(13)+CHR(10)

FWRITE(nHandleX, _cexcel)  
//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Criando as TAG's - XML³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FWRITE(nHandle, "<?xml version='1.0' encoding='ISO-8859-1'?>"+CHR(13)+CHR(10))
FWRITE(nHandle, '<RegistroExportacao>'+CHR(13)+CHR(10))
dbSelectArea("SF2")
dbSetOrder(1)
//FILIAL+D0C+SERIE+CLIENTE+LOJA+FORMUL+TIPO

dbSeek(xFilial("SF2")+alltrim(mv_par07),.F.)
IF SF2->(EOF()) .OR. Alltrim(SF2->F2_DOC)<>alltrim(mv_par07)
   MSGALERT("Arquivo não gerado!")
   RETURN .T.  
ENDIF                  
dbSelectArea("SD2")
dbSetorder(3)         
dbSeek(xFilial("SD2")+alltrim(mv_par07),.F.)
cPedido:=SD2->D2_PEDIDO
cCF:=SD2->D2_CF
dbSelectArea("SC5")
dbSetorder(1)
dbSeek(xFilial("SC5")+cPedido,.F.)
cRE:=""                               
cREX:=""
cpaiscliente:=""
If !SC5->(EOF()) .AND. SC5->C5_NUM=cPedido
   cRE   :=StrTran(SC5->C5_RE,"/","")
   cRE   :=StrTran(cRE,"-","")
   cREX  :=SC5->C5_RE      
   cNAVIO:=SC5->C5_NAVIO
   //Incluido apos mudanca no processo de exportacao
   If Empty(cRE)
   		DbSelectArea("EE9")
   		DbSetOrder(1)
   		If DbSeek(xFilial("EE9")+cPedido)
   			cRE   := StrTran(EE9->EE9_RE,"/","")
		    cRE   := StrTran(cRE,"-","")
		    cREX  := EE9->EE9_RE
		EndIf
	EndIf
   DBSELECTAREA("CTH")
   DBSETORDER(1)
   DBSEEK(xFILIAL("CTH")+cNavio)
   IF !CTH->(EOF())                                                         
      cpaiscliente:=CTH->CTH_PAIS     
   ENDIF
EndIf
dbSelectArea("SA1")
dbSetorder(1)
dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)         
ccodpais:=""              

If !SA1->(EOF())
   ccodpais:=SA1->A1_PAIS
   ///// PESQUISAR PAIS
   dbSelectArea("SYA")
   dbSetOrder(1)
   dbseek(xFilial("SYA")+ccodpais,.F.)
EndIf

FWRITE(nHandle,"<NfExportacao CFOP='"+alltrim(cCF)+"' SequenciaTipoSiscomex='"+"1"+"' NF='"+ALLTRIM(mv_par07);           
        +"' Serie='"+ALLTRIM(SF2->F2_SERIE)+"' DataEmissao='";
        +(strzero(day(SF2->F2_EMISSAO),2)+"/"+strzero(month(SF2->F2_EMISSAO),2)+"/"+str(year(SF2->F2_EMISSAO),4))+"' ValorTotal='"+TRANSFORM(SF2->F2_VALBRUT,"@e 9999999999.99")+"' PesoLiquido='"+TRANSFORM(SF2->F2_PLIQUI,"@e 999999999.99");
        +"' Pais='"+cpaiscliente+"' >"+CHR(13)+CHR(10))
_cexcel=CHR(13)+CHR(10)

FWRITE(nHandleX, _cexcel)  
_cexcel="NF;Série;Data de Emissão;Qtd.Sacas;Valor Total;Peso Liquido;País;"+CHR(13)+CHR(10)

FWRITE(nHandleX, _cexcel)  //Excel
_cexcel=ALLTRIM(mv_par07)+";"+ALLTRIM(SF2->F2_SERIE)+";"+(strzero(day(SF2->F2_EMISSAO),2)+"/"+strzero(month(SF2->F2_EMISSAO),2)+"/"+str(year(SF2->F2_EMISSAO),4))+";";
+TRANSFORM(SF2->F2_VOLUME1	,"@e 9,999,999,999.99")+";"+TRANSFORM(SF2->F2_VALBRUT,"@e 9,999,999,999.99")+";"+TRANSFORM(SF2->F2_PLIQUI,"@e 999,999,999.99")+";"+cpaiscliente+";"+CHR(13)+CHR(10)

FWRITE(nHandleX, _cexcel)  //Excel
_cexcel=CHR(13)+CHR(10)

FWRITE(nHandleX, _cexcel)  
TMP->(dbGoTop())
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+TMP->FORNEC+TMP->LOJA ,.F.)
cESTFOR:=SA2->A2_EST

FWRITE(nHandle,"<RE RE='"+alltrim(cRE)+"' TipoSiscomex='"+"RE"+"' UFProdutor='"+TMP->UF+"' />"+CHR(13)+CHR(10))
_cexcel="RE;"+cREX+"; TipoSiscomex;"+"RE"+"; UF Produtor;"+TMP->UF+";"+CHR(13)+CHR(10)

FWRITE(nHandleX, _cexcel)  
_cexcel=CHR(13)+CHR(10)

FWRITE(nHandleX, _cexcel)  
_cexcel="FORNECEDOR"+";"+"NF"+";"+"Série"+";"+"Dt.Emissão"+";"+"NCM"+";"+"Unidade"+";"+"Qtd.Nota"+";"+"Qtd.Utilizada"+";"+"Valor"+";"+CHR(13)+CHR(10)

FWRITE(nHandleX, _cexcel)  
wTotalq:=0            
wTotalv:=0         
nQTDNF:=0
Do While !TMP->(EOF())     
   If TMP->OK<>'  '  
   
      dbSelectarea("SZU")
      dbSetOrder(2)     //  ZU_FILIAL+ ZU_NOTA+ ZU_NFR+ ZU_SRREM
      If DBSEEK( xFILIAL("SZU")+MV_PAR07+TMP->NF+TMP->SERIE )
         nQTDNF:=SZU->ZU_QTDUTZ
      Else 
           nQTDNF := 0
      ENdif

      dbSelectarea("SD1")
      dbSetOrder(1)
      DBSEEK(xFILIAL("SD1")+TMP->NF+TMP->SERIE+TMP->FORNEC+TMP->LOJA)
//      nQTDNF:=SD1->D1_QUANT

      dbSelectArea("SA2")
      dbSetOrder(1)
      dbSeek(xFilial("SA2")+TMP->FORNEC+TMP->LOJA ,.F.)
      cESTFOR:=SA2->A2_EST
      cCGC:=SA2->A2_CGC        
      cNOMFOR:=SA2->A2_NOME   

      dbSelectArea("SB1")
      dbSetorder(1)
      dbSeek(xFilial("SB1")+TMP->PRODUTO,.F.)
      cNCM:=SB1->B1_POSIPI

      dbSelectArea("TMP")
      FWRITE(nHandle,"<RelacaoNf CNPJ='"+cCGC+"' NF='"+TMP->NF+"' Serie='"+TMP->SERIE+"' DataEmissao='"+;
      (strzero(day(TMP->EMISSAO),2)+"/"+strzero(month(TMP->EMISSAO),2)+"/"+str(year(TMP->EMISSAO),4))+"'>"+CHR(13)+CHR(10))

      FWRITE(nHandle,"<ItemNfExportacao NCM='"+alltrim(cNCM)+"' Unidade='"+"Saca"+"' Quantidade='"+Transform(nQTDNF,"@e 999999999.99")+"' ValorTotalItem='"+TRANSFORM((SD1->D1_TOTAL/SD1->D1_QUANT)*nQTDNF,"@E 999999999.99")+"'/>"+CHR(13)+CHR(10))
//      FWRITE(nHandle,"<ItemNfExportacao NCM='"+alltrim(cNCM)+"' Unidade='"+"Saca"+"' Quantidade='"+Transform(SD1->D1_QUANT,"@e 999999999.99")+"' ValorTotalItem='"+TRANSFORM(TMP->VALOR,"@E 999999999.99")+"'/>"+CHR(13)+CHR(10))

      FWRITE(nHandle,"</RelacaoNf>"+CHR(13)+CHR(10))

      //Excel
      _cexcel=cNOMFOR+";"+TMP->NF+";"+TMP->SERIE+";"+dtoc(TMP->EMISSAO)+";"+ALLTRIM(cNCM)+";"+"Saca"+";"+Transform(nQTDNF,"@e 999999999.99")+";"+Transform(TMP->QTDTELA,"@e 999999999.99")+";"+TRANSFORM((SD1->D1_TOTAL/SD1->D1_QUANT)*nQTDNF,"@E 999,999,999.99")+";"+CHR(13)+CHR(10)
      FWRITE(nHandleX, _cexcel)  
      wTotalq+=nQTDNF
      wTotalv+=(SD1->D1_TOTAL/SD1->D1_QUANT)*nQTDNF
   EndIf
   TMP->(dbSkip())
EndDo   
_cexcel=";"+""+";"+""+";"+""+";"+""+";"+""+";"+";"+Transform(wTotalq,"@e 999,999,999.99")+";"+Transform((SD1->D1_TOTAL/SD1->D1_QUANT)*nQTDNF,"@e 999,999,999.99")+";"+CHR(13)+CHR(10)

FWRITE(nHandleX, _cexcel)  

FWRITE(nHandle,"</NfExportacao>"+CHR(13)+CHR(10))

FWRITE(nHandle,"</RegistroExportacao>"+CHR(13)+CHR(10))

FCLOSE(nHandle)  //fecha XML                                            
fClose(nHandleX) //fecha arquivo do Excel

Return .T.

static function v_dif()
Local lRetorno:= .t.

If nDiferen > 0  
   If !MsgYesNo("A  D I F E R E N Ç A  é maior que <<< Z E R O >>> ? "+CHR(10)+CHR(13)+"... CONFIRMA ?")
	  lRetorno := .f.
	Endif
EndIf
If nDiferen < 0  
   If !MsgYesNo("A  D I F E R E N Ç A  é Menor que <<< Z E R O >>> ? "+CHR(10)+CHR(13)+"... CONFIRMA ?")
	  lRetorno := .f.
	Endif
EndIf

Return lRetorno
