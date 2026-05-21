
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRcustosMV บAutor  ณAdriano Migoto Pintoบ Data ณ  14/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime custos de um MV.                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                       
              
User Function RcustosMV   

Private cPerg       := "RCMV01"
ValidPerg()
If pergunte(cPerg,.T.)
   RCtmv1()
Endif
Return .T.                                                                               


Static Function RCtmv1
Private aCabec:={}
Private aDados:={}                                             
Private aporcent:={}

aCabec:={" ", " ", " "}
         
If Select("TRB")<>0
   TRB->(dbcloseArea())
EndIf

/*
cQuery:="SELECT DISTINCT(C5_NAVIO+C5_CONTRAT), C5_NAVIO, C5_CONTRAT, C5_QTDTON FROM SC5010"                     
//cQuery+=" WHERE C5_CONTRAT='"+mv_par01+"'"                                            
//Alterado por Milton para desconsiderar a emissao para buscar todos os pedidos do Navio(MV) em questao
//cQuery+=" WHERE C5_EMISSAO>='"+dtos(mv_par01)+"' AND C5_EMISSAO<='"+dtos(mv_par02+30)+"'"
cQuery+=" WHERE C5_EMISSAO<='"+dtos(mv_par02+30)+"'"
cQuery+=" AND SC5010.D_E_L_E_T_=' ' AND C5_NAVIO<>'' AND C5_TIPO='N' AND C5_NOTA<>''"
cQuery+=" ORDER BY C5_NAVIO, C5_CONTRAT"
*/
cQuery	:= " SELECT C5.C5_NAVIO, C5.C5_CONTRAT, SUM(C5.C5_QTDTON) C5_QTDTON,"
cQuery	+= " (SELECT SUM(C6.C5_QTDTON) FROM SC5010 C6 WHERE C6.C5_NAVIO = C5.C5_NAVIO AND C6.D_E_L_E_T_ <> '*') C5_TOTTON"
cQuery	+= " FROM SC5010 C5"
cQuery	+= " WHERE C5.C5_EMISSAO<='"+dtos(mv_par02+30)+"'"
cQuery	+= " AND C5.D_E_L_E_T_=' ' AND C5.C5_NAVIO<>'' AND C5.C5_TIPO='N' AND C5.C5_NOTA<>''"
If !Empty(mv_par04)
	cQuery	+= " AND C5_CONTRAT BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
EndIf
cQuery	+= " GROUP BY C5.C5_NAVIO, C5.C5_CONTRAT"
cQuery	+= " ORDER BY C5.C5_NAVIO, C5.C5_CONTRAT"

cQuery := ChangeQuery(cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

If TRB->(EOF())                                                     
   TRB->(dbcloseArea())                                            
   Return .T.
EndIf

//dbselectarea("TRB")  

If Select("TRB1")<>0
   TRB1->(dbcloseArea())                                            
EndIf
cMV:=TRB->C5_NAVIO
cCONTRAT:=TRB->C5_CONTRAT
nQtdCont:=0 
nQTDNav	:=0
//totaliza os contratos por navio(mv)
//Do While !TRB->(EOF())         
   /* //Retirado por Milton(somando o campo C5_QTDTON direto na primeira query ja totaliza o navio
   cQry:="SELECT SUM(C5_QTDTON) AS TOTQTD FROM SC5010 WHERE C5_NAVIO IN ('"+ALLTRIM(TRB->C5_NAVIO)+"') AND C5_TIPO='N' "
   cQry+="AND SC5010.D_E_L_E_T_=' ' AND C5_EMISSAO>='"+dtos(mv_par01)+"' AND C5_EMISSAO<='"+dtos(mv_par02)+"' AND C5_NOTA<>'' "
   cQry := ChangeQuery(cQry)
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TRBX",.F.,.T.)
   If TRBX->(EOF())                                                     
      TRBX->(dbcloseArea())                                            
      TRB->(dbSkip())
      cMV:=TRB->C5_NAVIO                                                         
      cCONTRAT:=TRB->C5_CONTRAT
   ELSE  
   
   
      nQTD:=0                    
      cCONTRAT:=TRB->C5_CONTRAT
      Do While TRB->C5_NAVIO=cMV .AND. !TRB->(EOF())
         nQTD+=TRB->C5_QTDTON               
         TRB->(dbSkip())     
         //If cCONTRAT<>TRB->C5_CONTRAT .OR. TRB->(EOF())    
         If TRB->C5_NAVIO<>cMV .OR. TRB->(EOF()) .OR. cCONTRAT<>TRB->C5_CONTRAT    
            //aadd(aDados, {cMV, cCONTRAT, TRBX->TOTQTD, nQTD, Round((nQTD/TRBX->TOTQTD) * 100,2), "%"})        
            aadd(aporcent, {cCONTRAT, cMV, Round((nQTD/TRBX->TOTQTD) * 100,2)})
            nQTD:=0       
            cCONTRAT:=TRB->C5_CONTRAT           
            //cMV:=TRB->C5_NAVIO  
         EndIf
      //EndDo
      //aadd(aDados, {" ", " ", " "})
      cMV:=TRB->C5_NAVIO                                                         
      cCONTRAT:=TRB->C5_CONTRAT
      TRBX->(dbcloseArea())                                            
   EndIf
EndDo                     
*/                        
//laco que adiciona todos os contratos e seus percentuais em relacao ao Navio
Do While !TRB->(EOF())
	nQtdCont	+= TRB->C5_QTDTON
	nQTDNav		:= TRB->C5_TOTTON
	TRB->(dbSkip())
	//If cCONTRAT<>TRB->C5_CONTRAT .OR. TRB->(EOF())
	If TRB->(EOF()) .Or. TRB->C5_NAVIO<>cMV .OR. cCONTRAT<>TRB->C5_CONTRAT
		//aadd(aDados, {cMV, cCONTRAT, TRBX->TOTQTD, nQTD, Round((nQTD/TRBX->TOTQTD) * 100,2), "%"})
		aadd(aporcent, {cCONTRAT, cMV, Round((nQtdCont/nQTDNav) * 100,2),nQtdCont})
		
		nQtdCont:=0
		cCONTRAT:=TRB->C5_CONTRAT
		//cMV:=TRB->C5_NAVIO
	EndIf
	cMV:=TRB->C5_NAVIO
	cCONTRAT:=TRB->C5_CONTRAT
	//TRBX->(dbcloseArea())
	
EndDo
ASort( aporcent,,, { |x,y| y[2] > x[2] } )
            
            
aadd(aDados, {" ", " ", " "})
aadd(aDados, {"MV", "Contrato", /*"NF Venda",*/ "NF Compra", /*"Pedido",*/ "Emissใo", "Fornecedor", "Vl Unit.", "QTD","Valor", "Valor Rerefente", "%" ,"Qtde","Produto"} )

TRB->(dbGoTop())

Do While !TRB->(EOF())
   cQuery:="SELECT   F1_NAVIO AS NAVIOS, F1_NFMAE AS NF_Venda, F1_DOC AS NF, F1_CONTRA AS CONTRATO, F1_XPEDIDO AS PEDIDO,  F1_EMISSAO AS EMISSAO,"
   cQuery+=" F1_DTCHEGA AS CHEGADA,D1_QUANT AS QTD, D1_LOCAL AS ARMAZEM, D1_TES AS TES,  F1_XNOMFOR AS FORNECEDOR, D1_LOCAL, D1_VUNIT AS VL_UNIT," 
   cQuery+="         F1_VALMERC AS VL_TOTAL, D1_FALTAS, D1_AVARIAS, D1_SOBRAS, D1_CLVL AS NAVIO, F1_FORNECE, A2_COD, A2_NOME AS NOME, B1_DESC, D1_TOTAL"
   cQuery+=" FROM SF1010 INNER JOIN SD1010 ON D1_DOC        = F1_DOC AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA"
   cQuery+=" INNER JOIN SA2010 ON A2_COD        = F1_FORNECE AND A2_LOJA=F1_LOJA"                                                           	
   cQuery+=" INNER JOIN SB1010 ON B1_COD        = D1_COD AND B1_COD<>'000001' AND B1_COD<>'000002' AND B1_COD<>'000003' AND B1_COD<>'000091'"
   //cQuery+=" WHERE D1_CLVL IN ('"+ALLTRIM(TRB->C5_NAVIO)+"') AND  SF1010.D_E_L_E_T_ = ' ' AND F1_NFMAE='' AND SD1010.D_E_L_E_T_ = ' '"

   cQuery+=" WHERE D1_CLVL IN ('"+ALLTRIM(TRB->C5_NAVIO)+"') AND F1_EMISSAO>='"+dtos(mv_par01)+"' AND F1_EMISSAO<='"+dtos(mv_par02)+"' AND  SF1010.D_E_L_E_T_ = ' ' AND F1_NFMAE='' AND SD1010.D_E_L_E_T_ = ' '"
   If !Empty(mv_par04)
   		cQuery+=" AND F1_CONTRA BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
   EndIf

   cQuery+=" AND SF1010.F1_CONTRA=''"
   cQuery+=" ORDER BY EMISSAO, NAVIO, NOME, NF "            

   cQuery := ChangeQuery(cQuery)

   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB1",.F.,.T.)

   dbselectarea("TRB1")   
   TRB1->(dbGotop())

   Do While !TRB1->(EOF())
      //AADD(aDados,{TRB->C5_CONTRAT, TRB->C5_NAVIO, TRB1->NF, STOD(TRB1->EMISSAO), TRB1->NOME,  TRB1->VL_UNIT, TRB1->QTD,TRB1->D1_TOTAL, TRB1->B1_DESC})
      
      nposicao:= aScan(aporcent,{|x| Trim(x[1]) == Trim(TRB->C5_CONTRAT) .AND. Trim(x[2]) == Trim(TRB->C5_NAVIO) })
      
      ntotal:=Round((TRB1->D1_TOTAL/100)*aporcent[nposicao,3],2)
      
      AADD(aDados,{ TRB->C5_NAVIO, TRB->C5_CONTRAT, TRB1->NF, STOD(TRB1->EMISSAO), TRB1->NOME,  TRB1->VL_UNIT, TRB1->QTD,  TRB1->D1_TOTAL, ntotal, aporcent[nposicao,3],aporcent[nposicao,4],TRB1->B1_DESC})
      TRB1->(dbSkip())
   EndDo   
   
   If Select("TRB1")<>0
      TRB1->(dbcloseArea())
   EndIf                                               
   TRB->(dbSkip())

EndDo
TRB->(dbcloseArea())             
   
cQuery:=" SELECT E2_NAVIO, E2_VENCREA, E2_NUM+'-'+E2_PARCELA E2_NUM, E2_VALOR, E2_QTDTON, E2_HIST, E2_NOMFOR, "

cQuery+=" ISNULL((SELECT TOP 1 C5_CONTRAT FROM SC5010 C5 WHERE C5_NAVIO=E2_NAVIO AND C5.D_E_L_E_T_ <> '*'),'') AS C5_CONTRAT"
cQuery+=" FROM SE2010"     
//cQuery+=" INNER JOIN SC5010 ON C5_NAVIO=E2_NAVIO"
cQuery+=" WHERE E2_NAVIO<>'' AND E2_VENCREA>='"+dtos(mv_par01)+"' AND E2_VENCREA<='"+dtos(mv_par02)+"' AND  SE2010.D_E_L_E_T_ = ' '"
cQuery+=" AND E2_TIPO NOT IN ('PA')"

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB1",.F.,.T.)

dbselectarea("TRB1")   
TRB1->(dbGotop())

Do While !TRB1->(EOF())

   nposicao:= aScan(aporcent,{|x| Trim(x[1]) == Trim(TRB1->C5_CONTRAT) .AND. Trim(x[2]) == Trim(TRB1->E2_NAVIO) })
                                    
      
   if nposicao=0
      ntotal:=TRB1->E2_VALOR
      npercent:=100
      nqtde	:= 0
   else
      ntotal:=Round((TRB1->E2_VALOR/100)*aporcent[nposicao,3],2)       
      npercent:=aporcent[nposicao,3]
      nqtde	:= aporcent[nposicao,4]
   endif   
   
   
	If Empty(mv_par04) .Or. (TRB1->C5_CONTRAT >= mv_par03 .And. TRB1->C5_CONTRAT <= mv_par04)
   		AADD(aDados,{TRB1->E2_NAVIO, TRB1->C5_CONTRAT, TRB1->E2_NUM, STOD(TRB1->E2_VENCREA), TRB1->E2_NOMFOR,  TRB1->E2_VALOR, TRB1->E2_QTDTON, TRB1->E2_VALOR,ntotal, npercent,nqtde, TRB1->E2_HIST})
 	EndIf
   TRB1->(dbSkip())
EndDo   
   
If Select("TRB1")<>0
   TRB1->(dbcloseArea())
EndIf                                               
   
//juncao dos lancamentos manuais do financeiro - Alteracao Milton
cQuery 	:= " SELECT CV4_CLVLDB as E2_NAVIO,E2_VENCREA, E2_NUM+'-'+E2_PARCELA E2_NUM, E2_VALOR, CV4_VALOR, CV4_PERCEN,E2_QTDTON, E2_HIST, E2_NOMFOR, "
cQuery 	+= " ISNULL((SELECT TOP 1 C5_CONTRAT FROM SC5010 C5 WHERE C5_NAVIO=CV4_CLVLDB AND C5.D_E_L_E_T_ <> '*'),'') AS C5_CONTRAT"
cQuery 	+= " FROM SE2010 SE2"
cQuery 	+= " JOIN CV4010 CV4 ON CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN = E2_ARQRAT"
cQuery	+= " 
cQuery 	+= " WHERE SE2.D_E_L_E_T_ <> '*' AND E2_RATEIO = 'S' AND E2_ARQRAT <> ' '"
cQuery 	+= " AND CV4.D_E_L_E_T_ <> '*'"
cQuery 	+= " AND E2_VENCREA>='"+dtos(mv_par01)+"' AND E2_VENCREA<='"+dtos(mv_par02)+"'"
cQuery 	+= " AND LEFT(E2_ORIGEM,7) <> 'MATA100'"
cQuery 	+= " AND E2_TIPO NOT IN ('PA')"
cQuery 	+= " ORDER BY E2_VENCREA, E2_NAVIO"
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB1",.F.,.T.)

dbselectarea("TRB1")   
TRB1->(dbGotop())

Do While !TRB1->(EOF())
	//nposicao:= aScan(aporcent,{|x| Trim(x[1]) == Trim(TRB1->C5_CONTRAT) .AND. Trim(x[2]) == Trim(TRB1->E2_NAVIO) })
	nposicao:= aScan(aporcent,{|x| Trim(x[2]) == Trim(TRB1->E2_NAVIO) })
	//inclui no relatorio enquanto for o mesmo MV(Navio) soh mudando os contratos
	While nposicao <> 0 .And. nposicao <= Len(aporcent) .And. AllTrim(TRB1->E2_NAVIO) == AllTrim(aporcent[nposicao,2])
	   //se nao achar no array de contratos deixa o percentual como 100%
	   if nposicao=0
	      npercent:=1
	      cContrato		:= TRB1->C5_CONTRAT
	      nqtde		:= 0
	   else//senao adiciona o percentual entre os contratos
	      npercent:=aporcent[nposicao,3]/100
	      cContrato	:= aporcent[nposicao,1]//busca o codigo do contrato no array aporcent que armazena todas as vendas para esse navio e todos os contratos relacionados ao navio
	      nqtde		:= aporcent[nposicao,4]
	   endif
	   If Empty(mv_par04) .Or. (cContrato >= mv_par03 .And. cContrato <= mv_par04)
			AADD(aDados,{TRB1->E2_NAVIO, cContrato, TRB1->E2_NUM, STOD(TRB1->E2_VENCREA), TRB1->E2_NOMFOR,  TRB1->E2_VALOR, TRB1->E2_QTDTON, TRB1->E2_VALOR,TRB1->CV4_VALOR*npercent,TRB1->CV4_PERCEN*npercent,nqtde, TRB1->E2_HIST})
			
		EndIf
		nposicao++
	EndDo
   TRB1->(dbSkip())
EndDo   
   
If Select("TRB1")<>0
   TRB1->(dbcloseArea())
EndIf                                               
   

DlgToExcel( { { "ARRAY", "Exporta็ใo para o Excel", aCabec, aDados} })                                  

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
//PutSx1(cPerg,"01","Contrato      ?","","","mv_ch1","C",15,00,00,"G","","CN9","","","mv_par01","","","","","","","","","","","","","","","","",{"Digite o Numero do Contrato"},{},{},"")

PutSx1(cPerg,"01","De            ?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{"Digite a data inicial"},{},{},"")
PutSx1(cPerg,"02","At้           ?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{"Digite a data final"},{},{},"")
PutSx1(cPerg,"03","Contrato De   ?","","","mv_ch3","C",15,0,0,"G","","CN9","","","mv_par03","","","","","","","","","","","","","","","","",{"Contrato Inicial     "},{},{},"")
PutSx1(cPerg,"04","Contrato Ate  ?","","","mv_ch4","C",15,0,0,"G","","CN9","","","mv_par04","","","","","","","","","","","","","","","","",{"Contrato Final     "},{},{},"")

Return .T.
