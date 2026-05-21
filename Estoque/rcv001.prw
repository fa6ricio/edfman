#include "protheus.ch"             

//KARDEX
//ADRIANO
//FACRI
//14-09-2011 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCV001    บAutor  ณAlexandre Santos  บ Data ณ  17/07/2013   บฑฑ
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


User Function RCV001   
Local   nFator := 1 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirnar o valor pre-fixado 
Private cPerg       := "RCV001"
ValidPerg()
If pergunte(cPerg,.T.)
   Relrc001()
Endif
Return .T.   

Static Function Relrc001  
Private aCabec:={}                 
Private aItens:={}

cQuery:="SELECT F1_CONTRA AS CONTRATO, F1_DOC AS DOC,F1_SERIE AS SERIE,F1_EMISSAO AS EMISSAO,F1_FORNECE AS FORCLI,F1_LOJA AS LOJA,D1_TES AS TES,D1_LOCAL AS ARMAZEM,D1_COD AS COD,D1_UM AS UM,D1_QUANT AS QUANT,D1_VUNIT AS VALOR,D1_TOTAL AS TOTAL "
cQuery+=" FROM "+RetSqlname("SD1")
cQuery+=" INNER JOIN "+RetSqlname("SF1")+" ON F1_DOC = D1_DOC AND F1_FORNECE=D1_FORNECE AND F1_LOJA=D1_LOJA"
cQuery+=" WHERE"                 
cQuery+=" D1_TES IN ("+mv_par07+") AND"  // Alexandre Santos - 24/07/2013   De Para TES 
//cQuery+=" D1_TES IN ('006', '009') AND" 
cQuery+=" F1_EMISSAO>='"+dtos(mv_par01)+"' AND F1_EMISSAO<='"+dtos(mv_par02)+"' AND  "+RetSqlName("SF1")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SD1")+".D_E_L_E_T_<>'*' "
cQuery+=" AND D1_LOCAL>='"+mv_par03+"' AND D1_LOCAL<='"+mv_par04+"' "
//cQuery+=" AND F1_CONTRA>='"+mv_par05+"' AND F1_CONTRA<='"+mv_par06+"'" 
IF !EMPTY(mv_par05)
   cQuery+=" AND F1_CONTRA='"+alltrim(mv_par05)+"' "
ENDIF   
/*
cQuery+=" ORDER BY F1_EMISSAO "
cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbselectarea("TRB")       
                  
aCabec:={"Documento","Serie","Emissใo","Fornece","Loja","TES","Armaz้m","Produto","Unidade","Quantide","Valor","Total"}

Do While !TRB->(EOF())
   AADD(aItens,{F1_DOC,F1_SERIE,F1_EMISSAO,F1_FORNECE,F1_LOJA,D1_TES,D1_LOCAL,D1_COD,D1_UM,D1_QUANT,D1_VUNIT,D1_TOTAL})
   TRB->(dbSkip())                                                                                              
EndDo
*/

cQuery+=" UNION "

cQuery+=" SELECT C5_CONTRAT,F2_DOC,F2_SERIE,F2_EMISSAO,F2_CLIENTE,F2_LOJA,D2_TES,D2_LOCAL,D2_COD,D2_UM,D2_QUANT,D2_PRCVEN,D2_TOTAL "
cQuery+=" FROM ( "
cQuery+=" SELECT C5_CONTRAT,F2_DOC,F2_SERIE,"
cQuery+=" CASE WHEN (SELECT TOP 1 EEC_DTEMBA FROM "+RetSqlName("EEC")+" AS EEC WHERE EEC.D_E_L_E_T_ = ' ' AND EEC_PREEMB = D2_PREEMB) IS NULL OR (SELECT TOP 1 EEC_DTEMBA FROM "+RetSqlName("EEC")+" AS EEC WHERE EEC.D_E_L_E_T_ = ' ' AND EEC_PREEMB = D2_PREEMB) = ' ' THEN D2_EMISSAO ELSE (SELECT TOP 1 EEC_DTEMBA FROM "+RetSqlName("EEC")+" AS EEC WHERE EEC.D_E_L_E_T_ = ' ' AND EEC_PREEMB = D2_PREEMB) END AS F2_EMISSAO, "
cQuery+=" F2_CLIENTE,F2_LOJA,D2_TES,D2_LOCAL,D2_COD,D2_UM,D2_QUANT,D2_PRCVEN,D2_TOTAL "
cQuery+=" FROM "+RetSqlname("SD2")
cQuery+=" INNER JOIN "+RetSqlname("SF2")+" ON F2_DOC = D2_DOC AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA"    
cQuery+=" INNER JOIN "+RetSqlName("SC5")+" ON C5_NOTA= D2_DOC "
cQuery+=" WHERE"                 
cQuery+=" D2_TES IN ("+mv_par08+") AND"     // Alexandre Santos - 24/07/2013   De Para TES 
// cQuery+=" D2_TES IN ('501', '506', '598') AND"
cQuery+=" F2_EMISSAO>='"+dtos(mv_par01)+"' AND F2_EMISSAO<='"+dtos(mv_par02)+"' AND  "+RetSqlName("SF2")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SD2")+".D_E_L_E_T_<>'*' "
cQuery+=" AND D2_LOCAL>='"+mv_par03+"' AND D2_LOCAL<='"+mv_par04+"' AND "+RetSqlName("SC5")+".D_E_L_E_T_<>'*'
//cQuery+=" AND C5_CONTRAT>='"+mv_par05+"' AND C5_CONTRAT<='"+mv_par06+"' AND "+RetSqlName("SC5")+".D_E_L_E_T_<>'*'
IF !EMPTY(mv_par06)
   cQuery+=" AND C5_CONTRAT='"+alltrim(mv_par06)+"'" 
ENDIF             
cQuery += ") AS QRY1 "

cQuery+=" ORDER BY EMISSAO, TES "
cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(DbCloseArea())
Endif

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbselectarea("TRB")       
nSaldo:=0                  
wqtd:=0                                                                                                         
wtqtd:=0
Do While !TRB->(EOF())   

   nFator := U_EDFFATOR(TRB->COD) 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirnar o valor pre-fixado 
                         
   wNome:=""
   IF TRB->TES<"500"
	  dbSelectArea( "SA2" )
	  dbSetOrder( 01 )
	  dbSeek( xFilial( "SA2" ) + TRB->FORCLI + TRB->LOJA )
	  wNome:=SA2->A2_NOME
	  
	  // Alexandre Santos - 17/07/2013 - Inํcio Alteracao para retirnar o valor pre-fixado 
	  nSaldo+=TRB->QUANT/nFator
	  wqtd:=TRB->QUANT/nFator
	  wtqtd+=(TRB->QUANT/nFator)           
	  //nSaldo+=TRB->QUANT/20
	  //wqtd:=TRB->QUANT/20
	  //wtqtd+=(TRB->QUANT/20)           
	  // Alexandre Santos - 17/07/2013 - Fim


   ELSE
	  dbSelectArea( "SA1" )
	  dbSetOrder( 01 )
	  dbSeek( xFilial( "SA1" ) + TRB->FORCLI + TRB->LOJA )
	  wNome:=SA1->A1_NOME       
	  
	  // Alexandre Santos - 17/07/2013 - Inํcio Alteracao para retirnar o valor pre-fixado 	  
	  nSaldo-=TRB->QUANT/nFator
	  wqtd:=(TRB->QUANT/nFator)*-1
	  wtqtd-=(TRB->QUANT/nFator)
	  //nSaldo-=TRB->QUANT/20
	  //wqtd:=(TRB->QUANT/20)*-1
	  //wtqtd-=(TRB->QUANT/20)  
	  // Alexandre Santos - 17/07/2013 - Fim
	  
   ENDIF                    
   dbSelectArea("TRB")                                                               
  
   AADD(aItens,{TRB->CONTRATO, TRB->DOC,TRB->SERIE,Stod(TRB->EMISSAO),wNome,TRB->TES,TRB->ARMAZEM,TRB->COD,TRB->UM,wqtd,TRB->VALOR,TRB->TOTAL,nSaldo})
   
   IF TRB->TES<'500'
      dbSelectArea("SD2")
      dbSetOrder(10)
      dbSeek(xFilial("SD2")+TRB->DOC+TRB->SERIE)     
      If !SD2->(EOF()) .AND. SD2->D2_TES="598" .AND. SD2->D2_CLIENTE=TRB->FORCLI .AND. SD2->D2_LOJA=TRB->LOJA   

	     // Alexandre Santos - 17/07/2013 - Inํcio - Alteracao para retirnar o valor pre-fixado 	        

         nFator := U_EDFFATOR(SD2->D2_COD) 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirnar o valor pre-fixado 

         nSaldo-=(SD2->D2_QUANT/nFator)
   	     wtqtd-=(SD2->D2_QUANT/nFator)
         //nSaldo-=(SD2->D2_QUANT/20)
   	     //wtqtd-=(SD2->D2_QUANT/20)
	     // Alexandre Santos - 17/07/2013 - Fim 	        
      
         AADD(aItens,{TRB->CONTRATO, SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_EMISSAO,wNome,SD2->D2_TES,SD2->D2_LOCAL,SD2->D2_COD,SD2->D2_UM,(SD2->D2_QUANT/20)*-1,SD2->D2_PRCVEN,SD2->D2_TOTAL,nSaldo})
      ENDIF                   
   ELSE
      If Select("TRX") > 0
	     TRX->(dbCloseArea())
      Endif        
      cQuery:="SELECT *"
      cQuery+=" FROM "+RetSqlname("SD1")
      cQuery+=" INNER JOIN "+RetSqlname("SF1")+" ON F1_DOC = D1_DOC"
      cQuery+=" WHERE D1_NFORI='"+TRB->DOC+"' AND D1_TES IN ("+mv_par09+") AND "+RetSqlname("SF1")+".D_E_L_E_T_='' AND "+RetSqlname("SD1")+".D_E_L_E_T_=''"   // Alexandre Santos - 24/07/2013   De Para TES 
      //cQuery+=" WHERE D1_NFORI='"+TRB->DOC+"' AND D1_TES='010' AND "+RetSqlname("SF1")+".D_E_L_E_T_='' AND "+RetSqlname("SD1")+".D_E_L_E_T_=''"
      cQuery+=" ORDER BY F1_EMISSAO"
      cQuery := ChangeQuery(cQuery)
      DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRX",.F.,.T.)
      dbselectarea("TRX")  
      TRX->(dbGoTop())
      If ! TRX->(EOF())        
               
         // Alexandre Santos - 17/07/2013 - Inํcio - Alteracao para retirnar o valor pre-fixado 	        

         nFator := U_EDFFATOR(TRX->D1_COD) 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirnar o valor pre-fixado 

         nSaldo+=(TRX->D1_QUANT/nFator)
   	     wtqtd+=(TRX->D1_QUANT/nFator)
         //nSaldo+=(TRX->D1_QUANT/20)
   	     //wtqtd+=(TRX->D1_QUANT/20)
	     // Alexandre Santos - 17/07/2013 - Fim 	        

         AADD(aItens,{TRB->CONTRATO, TRX->D1_DOC,TRX->D1_SERIE,TRX->D1_EMISSAO,wNome,TRX->D1_TES,TRX->D1_LOCAL,TRX->D1_COD,TRX->D1_UM,(TRX->D1_QUANT/20),TRX->D1_VUNIT,TRX->D1_TOTAL,nSaldo})
      EndIf                  
      TRX->(dbCloseArea())
   ENDIF
   dbSelectArea("TRB")                                                               
   TRB->(dbSkip())                                                                                              
EndDo
AADD(aItens,{"", "","","","","","","","",wtqtd,"","",""})

aCabec:={"Contrato", "Documento","Serie","Emissใo","Entidade","TES","Armaz้m","Produto","Unidade","Quantide","Valor","Total","SD"}

                
DlgToExcel( { { "ARRAY", "Rela็ใo", aCabec, aItens} })                                  

TRB->(dbcloseArea())

Return .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณValidPerg ณ Autor ณAdriano Migoto Pinto   ณ Data ณ 14/09/11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Ajuste de Perguntas (SX1)                 			      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ ValidPerg()                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MP8                                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ValidPerg()
PutSx1(cPerg,"01","De            ?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
PutSx1(cPerg,"02","At้           ?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")
PutSx1(cPerg,"03","Do Armaz้m    ?","","","mv_ch3","C",2,0,0,"G","","","","","mv_par03")
PutSx1(cPerg,"04","At้ o Armaz้m ?","","","mv_ch4","C",2,0,0,"G","","","","","mv_par04")  
PutSx1(cPerg,"05","Contrato Compra?","","","mv_ch5","C",15,0,0,"G","","","","","mv_par05")  
PutSx1(cPerg,"06","Contrato Venda?","","","mv_ch6","C",15,0,0,"G","","","","","mv_par06")    
PutSx1(cPerg,"07","TES 001,002...099 ?","","","mv_ch7","C",40,0,0,"G","","","","","mv_par07")  
PutSx1(cPerg,"08","TES 001,002...099 ?","","","mv_ch8","C",40,0,0,"G","","","","","mv_par08")   
PutSx1(cPerg,"09","TES 001,002...099 ?","","","mv_ch9","C",40,0,0,"G","","","","","mv_par09")  
Return .T.