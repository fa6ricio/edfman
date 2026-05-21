
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFRIEX  บAutor  ณ ADRIANO MIGOTO PINTO บData ณ 02/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera planilha para conferencia do Riex.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/           

User Function ConfRiex                                
Private cPerg       := "CFR001"
ValidPerg()
If pergunte(cPerg,.T.)
   ConfR01()
Endif
Return .T.   


Static Function ConfR01         
Local aCabec:={}
Local aDados:={}
cQuery="SELECT ZU_NOTA AS NOTA_BAUCHE, ZU_NFR AS NOTA_COMPRA, ZU_SRREM AS SERIE, A2_NOME AS FORNEC, ZU_QTDUTZ AS QUANTIDADE, ZU_DATA AS dDATA,ZU_FORNECE, ZU_LOJA "
cQuery+="FROM SZU010 "
cQuery+="INNER JOIN SA2010 ON A2_COD = ZU_FORNECE AND A2_LOJA=ZU_LOJA "
cQuery+="WHERE ZU_DATA >='"+dtos(mv_par01)+"' AND ZU_DATA <='"+dtos(mv_par02)+"' AND  "+RetSqlName("SZU")+".D_E_L_E_T_<>'*' AND "+RetSqlName("SA2")+".D_E_L_E_T_<>'*' "
cQuery+="ORDER BY NOTA_BAUCHE"
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbselectarea("TRB")  
AAdd(aCabec ,"NF Bauche")
AAdd(aCabec ,"NF Remessa")                                                
AAdd(aCabec ,"S้rie")
AAdd(aCabec ,"Contrato")
AAdd(aCabec ,"Fornecedor")
AAdd(aCabec ,"Data")
AAdd(aCabec ,"Quantidade Nota")
AAdd(aCabec ,"Quantidade Utilizada")
dbselectarea("TRB")  
dbGoTop()                 
Do While !TRB->(EOF())         
   dbSelectArea("SF1")
   dbSetOrder(1)
   dbSeek(xFilial("SF1")+TRB->NOTA_COMPRA+TRB->SERIE+TRB->ZU_FORNECE+TRB->ZU_LOJA)
   cCONTRA:=0
   If !SF1->(EOF())
      cCONTRA:=SF1->F1_CONTRA
   EndIf
   dbSelectArea("SD1")
   dbSetOrder(1)
   dbSeek(xFilial("SD1")+TRB->NOTA_COMPRA+TRB->SERIE+TRB->ZU_FORNECE+TRB->ZU_LOJA)
   nQTDNF:=0
   If !SD1->(EOF())
      nQTDNF:=SD1->D1_QUANT
   EndIf
   dbSelectArea("TRB")  
   AAdd(aDados, {TRB->NOTA_BAUCHE, TRB->NOTA_COMPRA, TRB->SERIE, cCONTRA, TRB->FORNEC, STOD(TRB->dDATA), nQTDNF, TRB->QUANTIDADE})
   TRB->(dbSkip())
EndDo                    
              
//AAdd(aDados ,{" "," "," "," "," "," ",nvltotal,nvltotal/20,"","","",nvlDesfu,nvlSegur,nvlReale, "",nValor})
                
DlgToExcel( { { "ARRAY", "Rela็ใo", aCabec, aDados} })                                  

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
Return .T.