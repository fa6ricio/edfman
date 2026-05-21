#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "Tbiconn.ch"
#Define _CRLF  Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFR004  ºAutor  ³Luis Felipe Nascimento ³Data ³  09/12/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consultas para análise das informações contábeis, Ativo    º±±
±±º          ³ Fixo ........                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contabilidade / Ativos Fixo                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                         	  º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CONSULTAS()

Local cTexto := "Consultas"
Local oDlg:= ""   
Private nRadio
	
DEFINE DIALOG oDlg TITLE "Consultas" FROM 180,350 TO 380,750 PIXEL

@ 08,010 SAY cTexto  SIZE 55,07 OF oDlg PIXEL
@ 05,050 RADIO oRadio VAR nRadio 3D SIZE 150,10  PROMPT 'Duplicidade de Lançamentos Contábeis',;
                                                        'Saldo Débito e Crédito por Lote',;
                                                        'Balancete Contábil',;
                                                        'Atualização dos Grupos de Bens',; 
                                                        'Atualização Grupos de Bens All',;
                                                        'Lançamentos Contabeis sem Moeda 02',; 
                                                        'Lançamentos Contabeis Entrada Estoque',;
                                                        'Alteracao dos Grupos filial 0106' OF oDlg 


DEFINE SBUTTON FROM 080, 100 TYPE 1 ACTION (nopc:= 1, Executa(nRadio)) ENABLE OF oDlg
DEFINE SBUTTON FROM 080, 141 TYPE 2 ACTION (nopc:= 2, oDlg:End()) ENABLE OF oDlg

ACTIVATE DIALOG oDlg CENTERED

Return     

*--------------------------------*
Static Function Executa(nRadio)
*--------------------------------*

Private cQuery 		:= ""
Private cAlias 		:= GetNextAlias()
Private aArea	 	:= GetArea()
Private aCabec 		:= {}
Private aDados 		:= {}
Private cPerg     	:= Space(10)
Private nConsulta 	:= nRadio

If Select(cAlias) > 0
	DbselectArea(cAlias)
	(cAlias)->(DbCloseArea())
EndIf

// Parâmetros

If nConsulta == 1 .OR. nConsulta == 2 .OR. nConsulta == 6
	cPerg := "CONSUL_001"
ElseIf nConsulta == 3
	cPerg := "CONSUL_003"
ElseIf nConsulta == 4
	cPerg := "CONSUL_004"
ElseIf nConsulta == 7
	cPerg := "CONSUL_007"
EndIf

CriaSx1()

Pergunte(cPerg,.T.)

If LastKey() == 27
	Return
Endif

If nConsulta == 1
	Processa({|| PROCESSA_1() },"Filtrando Duplicidade(s) de Lançamento(s) Contábeis ... ")
ElseIf nConsulta == 2
	Processa({|| PROCESSA_2() },"Calculando Saldos Contábeis Débito e Crédito por Lote ... ")
ElseIf nConsulta == 3    
	Processa({|| PROCESSA_3() },"Calculando Saldos Contábeis por Conta ... ")
ElseIf nConsulta == 4         
	Processa({|| PROCESSA_4() },"Atualizando ... ")
ElseIf nConsulta == 5   
	Processa({|| PROCESSA_5() },"Atualizando ... ") 
ElseIf nConsulta == 6
	Processa({|| PROCESSA_6() },"Processando registros ... ") 
ElseIf nConsulta == 7
	Processa({|| PROCESSA_7() },"Processando registros ... ") 
ElseIf nConsulta == 8
	Processa({|| PROCESSA_8() },"Processando registros ... ") 
EndIf

If !Str(nConsulta,1) $ "3/4/5/6/7"
	DlgToExcel( { { "ARRAY", "", aCabec, aDados} })
EndIf

RestArea(aArea)

Return

*--------------------------*
Static Function PROCESSA_1()  
*--------------------------*
	
cQuery := " SELECT CT2_LINHA, CT2_CREDIT, CT2_DEBITO, CT2_FILIAL, CT2_VALOR, CT2_HIST, CT2_KEY, COUNT(*) CONTADOR FROM "+RetSqlName("CT2")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND CT2_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"
cQuery += " GROUP BY CT2_LINHA, CT2_CREDIT, CT2_DEBITO, CT2_FILIAL, CT2_VALOR, CT2_HIST, CT2_KEY "
cQuery += " HAVING COUNT(*) >1 "

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)

AAdd(aDados,{"CT2_LINHA","CT2_CREDIT","CT2_DEBITO","CT2_FILIAL","CT2_VALOR","CT2_HIST","CT2_KEY","CONTADOR"})

ProcRegua(RecCount())
    
nCont := 0
While !Eof()
	nCont += 1
	IncProc("Registros : "+Str(nCont,4))
	AAdd(aDados ,{(cAlias)->CT2_LINHA,"'"+(cAlias)->CT2_CREDIT,"'"+(cAlias)->CT2_DEBITO,"'"+(cAlias)->CT2_FILIAL,(cAlias)->CT2_VALOR,"'"+(cAlias)->CT2_HIST,"'"+(cAlias)->CT2_KEY,(cAlias)->CONTADOR})
	DbSkip()
End

(cAlias)->(DbCloseArea())

Return 
	
*--------------------------*
Static Function PROCESSA_2()  
*--------------------------*

cQuery := "SELECT DISTINCT"
cQuery += " MAE.CT2_FILIAL,"
cQuery += " MAE.CT2_LOTE"   
cQuery += " ,"
cQuery += " (SELECT SUM(DEBITO.CT2_VALOR) FROM "+RetSqlName('CT2')+" AS DEBITO"
cQuery += " WHERE DEBITO.D_E_L_E_T_ = ''"
cQuery += " AND DEBITO.CT2_DC IN('1','3')"
cQuery += " AND DEBITO.CT2_FILIAL = MAE.CT2_FILIAL"
cQuery += " AND DEBITO.CT2_LOTE = MAE.CT2_LOTE"
cQuery += " GROUP BY DEBITO.CT2_FILIAL, DEBITO.CT2_LOTE) AS VAL_DEB"
cQuery += " ,"
cQuery += " (SELECT SUM(CREDITO.CT2_VALOR)FROM "+RetSqlName('CT2')+" AS CREDITO"
cQuery += " WHERE CREDITO.D_E_L_E_T_ = ''"
cQuery += " AND CREDITO.CT2_DC IN('2','3')"
cQuery += " AND CREDITO.CT2_FILIAL = MAE.CT2_FILIAL"
cQuery += " AND CREDITO.CT2_LOTE = MAE.CT2_LOTE"
cQuery += " GROUP BY CREDITO.CT2_FILIAL, CREDITO.CT2_LOTE) AS VAL_CRED"
cQuery += " FROM "+RetSqlName("CT2")+" MAE"
cQuery += " WHERE MAE.D_E_L_E_T_ = ''"
cQuery += " AND  MAE.CT2_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"
cQuery += " ORDER BY MAE.CT2_FILIAL, MAE.CT2_LOTE"

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)

AAdd(aDados,{"CT2_FILIAL","CT2_LOTE","VAL_DEB","VAL_CRED"})

ProcRegua(RecCount())

 While !Eof()
	IncProc("Lote : "+(cAlias)->CT2_LOTE)
	AAdd(aDados ,{"'"+(cAlias)->CT2_FILIAL,"'"+(cAlias)->CT2_LOTE,(cAlias)->VAL_DEB,(cAlias)->VAL_CRED})
	DbSkip()
End  

(cAlias)->(DbCloseArea())

Return                     

*---------------------------*
Static Function PROCESSA_3()  
*---------------------------*
	
Local cPeriodo  := SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4)
Local aCabec 	:= {"Cod. Conta","Descrição","Mês "+cPeriodo+" BRL","Mês "+cPeriodo+" USD","FX","Sld. "+cPeriodo+" BRL","Sld. "+cPeriodo+" USD","FX"}
Local aDados    := {}
Local cEmpresa  := SM0->M0_CODIGO
Local nRecnoSM0 := SM0->(Recno())
Local aFiliais  := {}
Local aSldCtaMes:= {}

Private dDataI  := CtoD("01/"+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4))
Private dDataf  := LastDay(CtoD("01/"+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4)))

DbSelectArea("SM0")
DbGotop()

While !Eof()
	If SM0->M0_CODIGO == cEmpresa
		Aadd(aFiliais,Alltrim(SM0->M0_CODFIL))
	EndIf
	DbSkip()
End

DbSelectArea("CT1")
DbSetOrder(1)
DbGotop()

ProcRegua(RecCount())

While !Eof()
	
	IncProc("Da Conta : "+CT1->CT1_CONTA)
	
	If CT1->CT1_CLASSE <> "2" .or. CT1->CT1_CONTA < MV_PAR03 .or. CT1->CT1_CONTA > MV_PAR04
		DbSkip()
		Loop
	EndIf
	
	Store 0 to nSaldoM1,nSaldoM2
	Store 0 to nSldMesM1,nSldMesM2
	
	For a:=1 to Len(aFiliais)
		nSaldoM1 := nSaldoM1 + SaldoConta(CT1->CT1_CONTA,dDataf,"01","1",1,0,MV_PAR02,aFiliais[a])
		nSaldoM2 := nSaldoM2 + SaldoConta(CT1->CT1_CONTA,dDataf,"02","1",1,0,MV_PAR02,aFiliais[a])
	Next
	nSldMesM1 := fSldMes("01",CT1->CT1_CONTA)
	nSldMesM2 := fSldMes("02",CT1->CT1_CONTA)
   
	If MV_PAR05 == 1 .and. nSldMesM1 == 0 .and. nSldMesM2 == 0 .and. nSaldoM1 == 0 .and. nSaldoM2 == 0
		DbSelectArea("CT1")
		DbSkip()
		Loop
	EndIf
	
	Aadd(aDados,{CT1->CT1_CONTA,CT1->CT1_DESC01,nSldMesM1,nSldMesM2,nSldMesM1/nSldMesM2,-1*nSaldoM1,-1*nSaldoM2,nSaldoM1/nSaldoM2})
	
	DbSelectArea("CT1")
	DbSkip()
	
End

DbSelectArea("SM0")
DbGoto(nRecnoSM0)

DlgToExcel({ {"ARRAY", "", aCabec, aDados} })

Return

*------------------------------------*
Static Function fSldMes(cMoeda,cConta)
*------------------------------------*

Local nValor := 0

cQuery:=" SELECT" 																									+_CRLF  	
cQuery+=" (CASE WHEN ( ISNULL(D.CT1_CONTA,' ') = ' ' ) THEN C.CT1_CONTA ELSE D.CT1_CONTA END ) AS CT1_CONTA,"		+_CRLF 
cQuery+=" (CASE WHEN ( ISNULL(D.CT1_DESC01,' ') = ' ' ) THEN C.CT1_DESC01 ELSE D.CT1_DESC01 END ) AS CT1_DESC01,"	+_CRLF 
cQuery+=" ("																										+_CRLF 
cQuery+=" (CASE WHEN ( ISNULL(D.CT2_VALOR,0) = 0  ) THEN 0 ELSE D.CT2_VALOR END )-"									+_CRLF 
cQuery+=" (CASE WHEN ( ISNULL( C.CT2_VALOR , 0 ) = 0  ) THEN 0 ELSE C.CT2_VALOR END )" 								+_CRLF 
cQuery+=" ) AS CT2_VALOR"                                                             								+_CRLF 
cQuery+=" FROM(SELECT CT1.CT1_CONTA,CT1.CT1_DESC01,"	   															+_CRLF 
cQuery+=" SUM(CT2.CT2_VALOR) AS CT2_VALOR,'D' AS CT2_DC"															+_CRLF 
cQuery+=" FROM 	" + RetSqlName("CT1") + " CT1, 	" + RetSqlName("CT2") + " CT2" 										+_CRLF 
cQuery+=" WHERE CT1.D_E_L_E_T_ = ' '"  																				+_CRLF 
cQuery+=" AND CT2.D_E_L_E_T_ = ' '"																					+_CRLF 
cQuery+=" AND CT2.CT2_DEBITO = '"+cConta+"'"		 																+_CRLF 
cQuery+=" AND (CT2_MOEDLC = '"+cMoeda+"'"																			+_CRLF 
cQuery+=" AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3'))" 																+_CRLF 
cQuery+=" AND CT2.CT2_DATA Between '" + DtoS(dDataI) + "' AND '"+ DtoS(dDataF) + "'" 								+_CRLF 
cQuery+=" GROUP BY CT1.CT1_CONTA, CT1.CT1_DESC01 ) AS D" 															+_CRLF 
cQuery+=" FULL OUTER JOIN ( SELECT CT1.CT1_CONTA, CT1.CT1_DESC01,"	   												+_CRLF 
cQuery+=" SUM(CT2.CT2_VALOR) AS CT2_VALOR, 'C' AS CT2_DC"  															+_CRLF 
cQuery+=" FROM 	" + RetSqlName("CT1") + " CT1, 	" + RetSqlName("CT2") + " CT2"										+_CRLF 
cQuery+=" WHERE CT1.D_E_L_E_T_ = ' '"																				+_CRLF 
cQuery+=" AND CT2.D_E_L_E_T_ = ' '"																					+_CRLF 
cQuery+=" AND CT2.CT2_CREDIT = '"+cConta+"'"		 																+_CRLF 
cQuery+=" AND (CT2_MOEDLC = '"+cMoeda+"'" 																			+_CRLF 
cQuery+=" AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3'))"	   															+_CRLF 
cQuery+=" AND CT2.CT2_DATA Between '" + DtoS(dDataI) + "' AND '"+ DtoS(dDataF) + "'"								+_CRLF 
cQuery+=" GROUP BY CT1.CT1_CONTA, CT1.CT1_DESC01 ) AS C" 															+_CRLF 
cQuery+=" ON	D.CT1_CONTA = C.CT1_CONTA"																			+_CRLF 
cQuery+=" ORDER BY CT1_CONTA, CT1_DESC01"																			+_CRLF 

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
Endif

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)

Dbselectarea(cAlias)

nValor := (cAlias)->CT2_VALOR

(cAlias)->(DbCloseArea())

Return(nValor)

*--------------------------*
Static Function PROCESSA_4()  
*--------------------------*

cQuery := " UPDATE "+RetSqlName("SN1")								 
cQuery += " SET N1_GRUPO = "													 
cQuery += " CASE	"
If !Empty(MV_PAR01)																
	cQuery += " WHEN	N3_CCONTAB = '"+MV_PAR01+"' THEN  '"+MV_PAR02+"'"	
EndIf
If !Empty(MV_PAR03)
	cQuery += " WHEN	N3_CCONTAB = '"+MV_PAR03+"' THEN  '"+MV_PAR04+"'"
EndIf
cQuery += " END"
cQuery += " FROM "+RetSqlName("SN1")+" SN1 LEFT OUTER JOIN"
cQuery += "      "+RetSqlName("SN3")+" SN3 ON SN1.N1_FILIAL = SN3.N3_FILIAL"
cQuery += " 				    AND  SN1.N1_CBASE  = SN3.N3_CBASE"
cQuery += " 					AND  SN1.N1_ITEM   = SN3.N3_ITEM"
cQuery += " WHERE   SN1.D_E_L_E_T_ = ''"
cQuery += " AND     SN3.D_E_L_E_T_ = ''"
cQuery += " AND     SN3.N3_CCONTAB <> ''"

TCSQLExec(cQuery)

Aviso("Aviso","Grupo de Bens atualizado !",{"Sair"})  

Return

*--------------------------*
Static Function PROCESSA_5()  
*--------------------------*
	
cQuery := " UPDATE "+RetSqlName("SN1")
cQuery += " SET N1_GRUPO = "
cQuery += " CASE	WHEN	N3_CCONTAB = '12301010' THEN  '0001'"
cQuery += " 		WHEN	N3_CCONTAB = '12301020' THEN  '0002'"
cQuery += " 		WHEN	N3_CCONTAB = '12301030'	THEN  '0003'"
cQuery += " 		WHEN	N3_CCONTAB = '12301040'	THEN  '0004'"
cQuery += " 		WHEN	N3_CCONTAB = '12301050'	THEN  '0005'"
cQuery += " 		WHEN	N3_CCONTAB = '12301060'	THEN  '0006'"
cQuery += " 		WHEN	N3_CCONTAB = '12301070'	THEN  '0007'"
cQuery += " 		WHEN	N3_CCONTAB = '12301080'	THEN  '0008'"
cQuery += " 		WHEN	N3_CCONTAB = '12301090'	THEN  '0009'"
cQuery += " 		WHEN	N3_CCONTAB = '12401010' THEN  '0010'"
cQuery += " END"
cQuery += " FROM "+RetSqlName("SN1")+" SN1 LEFT OUTER JOIN"
cQuery += "      "+RetSqlName("SN3")+" SN3 ON SN1.N1_FILIAL = SN3.N3_FILIAL"
cQuery += " 				    AND  SN1.N1_CBASE  = SN3.N3_CBASE"
cQuery += " 					AND  SN1.N1_ITEM   = SN3.N3_ITEM"
cQuery += " WHERE   SN1.D_E_L_E_T_ = ''"
cQuery += " AND     SN3.D_E_L_E_T_ = ''"
cQuery += " AND     SN3.N3_CCONTAB <> ''"

TCSQLExec(cQuery)

Aviso("Aviso","Grupo de Bens atualizado !",{"Sair"})

Return  

*--------------------------*
Static Function PROCESSA_6()  
*--------------------------*

Local aCabec 	:= {"FILIAL","DATA","LINHA","LOTE","SUB-LOTE","DOC","REAL"}
Local aDados    := {}

cQuery := " SELECT	M1.CT2_FILIAL AS M1CT2_FILIAL, " +_CRLF
cQuery += " 		M1.CT2_DATA AS M1CT2_DATA," +_CRLF
cQuery += " 		M1.CT2_LINHA AS M1CT2_LINHA," +_CRLF
cQuery += " 		M1.CT2_LOTE AS M1CT2_LOTE," +_CRLF
cQuery += " 		M1.CT2_SBLOTE AS M1CT2_SBLOTE," +_CRLF
cQuery += " 		M1.CT2_DOC AS M1CT2_DOC," +_CRLF
cQuery += " 		M1.CT2_MOEDLC AS M1CT2_MOEDLC," +_CRLF
cQuery += " 		M1.CT2_VALOR AS M1CT2_VALOR," +_CRLF
cQuery += " 		M2.CT2_FILIAL AS M2CT2_FILIAL," +_CRLF
cQuery += " 		M2.CT2_DATA AS M2CT2_DATA," +_CRLF
cQuery += " 		M2.CT2_LOTE AS M2CT2_LOTE," +_CRLF
cQuery += " 		M2.CT2_SBLOTE AS M2CT2_SBLOTE," +_CRLF
cQuery += " 		M2.CT2_DOC AS M2CT2_DOC," +_CRLF
cQuery += " 		M2.CT2_MOEDLC AS M2CT2_MOEDLC," +_CRLF
cQuery += " 		M2.CT2_VALOR AS M2CT2_VALOR" +_CRLF
cQuery += " FROM" +_CRLF
cQuery += " ( SELECT * FROM "+RetSqlName("CT2")+" WHERE D_E_L_E_T_ = '' AND CT2_MOEDLC = 01 AND CT2_DC <> '4') AS M1 LEFT OUTER JOIN " +_CRLF
cQuery += " ( SELECT * FROM "+RetSqlName("CT2")+" WHERE D_E_L_E_T_ = '' AND CT2_MOEDLC = 02 AND CT2_DC <> '4') AS M2 " +_CRLF
cQuery += " ON" +_CRLF
cQuery += " M1.CT2_KEY = M2.CT2_KEY AND" +_CRLF
cQuery += " M1.CT2_LINHA = M2.CT2_LINHA" +_CRLF
cQuery += " WHERE M1.CT2_VALOR > 0" +_CRLF
cQuery += " AND M2.CT2_VALOR IS NULL" +_CRLF
cQuery += " AND M1.CT2_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"
cQuery += " ORDER BY 5 " +_CRLF

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)

ProcRegua(RecCount())
    
nCont := 0
While !Eof()
	nCont += 1
	IncProc("Registros : "+Str(nCont,4))
	AAdd(aDados ,{"'"+(cAlias)->M1CT2_FILIAL,StoD((cAlias)->M1CT2_DATA),(cAlias)->M1CT2_LINHA,"'"+(cAlias)->M1CT2_LOTE,"'"+(cAlias)->M1CT2_SBLOTE,"'"+(cAlias)->M1CT2_DOC,(cAlias)->M1CT2_VALOR})
	DbSkip()
End

(cAlias)->(DbCloseArea())   

DlgToExcel({ {"ARRAY", "", aCabec, aDados} })

Return   

*--------------------------*
Static Function PROCESSA_7()  
*--------------------------*

// a) Filtrar os lançamentos contábeis a debito na conta de estoque e relacionar com as Notas de Entrada
//    642,650,660,655,665 

Local aCabec 	:= {"F4_CODIGO","F4_ESTOQUE","F4_DUPLIC","F4_TEXTO","F4_AGREG","D1_DOC","D1_COD","D1_CUSTO","F1_SERIE","B1_CONTA","F1_FILIAL","F1_FORNECE","F1_LOJA","F1_VALBRUT","CT2_DEBITO","CT2_CREDIT","CT2_VALOR","CT2_KEY","CT2_ORIGEM","CT2_HIST","CT2_LP","CT2_RECNO","Deletado"}
Local aDados    := {}
Local cLps		:= "('"

nCont := 0
For a:=1 to Len(MV_PAR03)
	If SubStr(MV_PAR03,a,1) $ "0123456789"
		nCont ++
		cLps +=	SubStr(MV_PAR03,a,1) 
	EndIf
	If nCont = 3
		cLps += "','"
		nCont := 0
	EndIf 
Next  
cLps += "')"

cQuery := " SELECT F4_CODIGO, F4_ESTOQUE, F4_DUPLIC, F4_TEXTO, F4_AGREG, D1DELETE, D1_DOC, D1_COD, D1_CUSTO, B1_CONTA, Q3.* " +_CRLF
cQuery += " FROM " +_CRLF
cQuery += " ( " +_CRLF
cQuery += " SELECT F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_VALBRUT, CT2_DEBITO, CT2_CREDIT, CT2_VALOR, CT2_KEY, CT2_ORIGEM, CT2_HIST, CT2_LP, Q1.R_E_C_N_O_  AS CT2_RECNO " +_CRLF
cQuery += " FROM " +_CRLF
cQuery += " ( " +_CRLF
cQuery += " SELECT * " +_CRLF  
cQuery += " FROM " + RetSqlName("CT2") + " WHERE D_E_L_E_T_ = ' ' AND CT2_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' " +_CRLF
cQuery += " AND CT2_MOEDLC = '01' AND ( CT2_DEBITO IN ('"+MV_PAR04+"'"
If !Empty(MV_PAR05)
	cQuery += ",'"+MV_PAR05+"'"
EndIf                          
If !Empty(MV_PAR06)    
	cQuery += ",'"+MV_PAR06+"'"
EndIf
If !Empty(MV_PAR07)    
	cQuery += ",'"+MV_PAR07+"'"
EndIf
cQuery += ") or  CT2_CREDIT IN ('"+MV_PAR04+"'"  
If !Empty(MV_PAR05)
	cQuery += ",'"+MV_PAR05+"'"
EndIf                          
If !Empty(MV_PAR06)    
	cQuery += ",'"+MV_PAR06+"'"
EndIf
If !Empty(MV_PAR07)    
	cQuery += ",'"+MV_PAR07+"'"
EndIf
cQuery += ") ) " +_CRLF
cQuery += " AND CT2_LP IN "+ cLps + _CRLF 
cQuery += " ) Q1 " +_CRLF
cQuery += " FULL JOIN " +_CRLF
cQuery += " ( " +_CRLF
cQuery += " SELECT * " +_CRLF
cQuery += " FROM "+ RetSqlName("SF1") + " SF1 WHERE F1_DTDIGIT  BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' " +_CRLF
cQuery += " ) Q2 " +_CRLF
cQuery += " ON SUBSTRING(CT2_KEY,1,24)  = F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA " +_CRLF
cQuery += " )  Q3 " +_CRLF
cQuery += " INNER JOIN " +_CRLF
cQuery += " ( " +_CRLF
cQuery += " SELECT D1.D_E_L_E_T_ AS D1DELETE, D1.*, F4_CODIGO, F4_TEXTO, F4_AGREG, F4_ESTOQUE, F4_DUPLIC, B1_CONTA " +_CRLF
cQuery += " FROM "+ RetSqlName("SD1") + " D1, " + RetSqlName("SF4") + " F4, " + RetSqlName("SB1") + " B1 " +_CRLF
cQuery += " WHERE F4.D_E_L_E_T_ = ' ' AND B1.D_E_L_E_T_ = ' ' " +_CRLF
cQuery += " AND D1_DTDIGIT  BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' " +_CRLF
cQuery += " AND D1_TES = F4_CODIGO " +_CRLF
cQuery += " AND D1_COD = B1_COD " +_CRLF   
cQuery += " ) Q4 " +_CRLF
cQuery += " ON SUBSTRING(CT2_KEY,1,24)  = D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA " +_CRLF 
If MV_PAR08 == 2  
	cQuery += "WHERE D1_CUSTO <> CT2_VALOR " +_CRLF   
EndIf
cQuery += " ORDER BY D1_DOC, CT2_RECNO " +_CRLF

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)

ProcRegua(RecCount())
    
nCont := 0
While !Eof()
	nCont += 1
	IncProc("Registros : "+Str(nCont,4))
	AAdd(aDados ,{(cAlias)->F4_CODIGO,;
	(cAlias)->F4_ESTOQUE,;
	(cAlias)->F4_DUPLIC,;
	(cAlias)->F4_TEXTO,;
	(cAlias)->F4_AGREG,;
	"'"+(cAlias)->D1_DOC,;
	(cAlias)->D1_COD,;
	(cAlias)->D1_CUSTO,;
	(cAlias)->F1_SERIE,;
	"'"+(cAlias)->B1_CONTA,;
	"'"+(cAlias)->F1_FILIAL,;
	"'"+(cAlias)->F1_FORNECE,;
	"'"+(cAlias)->F1_LOJA,;
	(cAlias)->F1_VALBRUT,;
	(cAlias)->CT2_DEBITO,;
	(cAlias)->CT2_CREDIT,;
	(cAlias)->CT2_VALOR,;
	"'"+(cAlias)->CT2_KEY,;
	(cAlias)->CT2_ORIGEM,;
	(cAlias)->CT2_HIST,;
	"'"+(cAlias)->CT2_LP,;
	Str((cAlias)->CT2_RECNO,10),;
	If((cAlias)->D1DELETE=='*','S','')})
	DbSkip()
End

(cAlias)->(DbCloseArea())   

DlgToExcel({ {"ARRAY", "", aCabec, aDados} })

Return   

*--------------------------*
Static Function PROCESSA_8()  
*--------------------------*
	
cQuery := " UPDATE "+RetSqlName("SN3")
cQuery += " SET N3_TXDEPR1 = 
cQuery += " CASE	WHEN	N1_GRUPO IN ('0004','0005','0006','0009') Then 20"
cQuery += " 		WHEN    N1_GRUPO = '0007' 							Then 10"
cQuery += " 		ELSE	N3_TXDEPR1"
cQuery += " END"
cQuery += " FROM "+RetSqlName("SN1")+" SN1 INNER JOIN"
cQuery += "      "+RetSqlName("SN3")+" SN3 ON SN1.N1_FILIAL = SN3.N3_FILIAL AND SN1.N1_CBASE  = SN3.N3_CBASE"
cQuery += " WHERE SN1.N1_FILIAL = '0106'"
cQuery += "	AND   SN3.N3_CCUSTO = '807'"
cQuery += " AND   SN1.D_E_L_E_T_ = ''"
cQuery += " AND   SN3.D_E_L_E_T_ = ''"

If TCSQLExec( cQuery ) <> 0
	UserException("Falha na Atualização da tabela XML-Template - " + TCSQLError() )
EndIf

Aviso("Aviso","Taxas dos Grupos atualizados !",{"Sair"})

Return  

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1       2      3                           4                           5                           6          7     8    9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38      39   40  41  42  43
If nConsulta == 1 .or. nConsulta == 2 .or. nConsulta == 6
	AADD(aSx1,{cPerg , "01" , "Data De               ?" , "Data De               ?" , "Data De               ?" , "mv_ch1" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "02" , "Data Ate              ?" , "Data Ate              ?" , "Data Ate              ?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
ElseIf nConsulta = 3
	AADD(aSx1,{cPerg , "01" , "Mês/Ano               ?" , "Mês/Ano               ?" , "Mês/Ano               ?" , "mv_ch1" , "C" , 07 , 0 , 0 , "G" , "" , "mv_par01" , ""    , "" , "" , "" , "" , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "@R 99/9999", ""})
	AADD(aSx1,{cPerg , "02" , "Dt.Lucros Perdas      ?" , "Dt.Lucros Perdas      ?" , "Dt.Lucros Perdas      ?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , ""    , "" , "" , "" , "" , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", ""          , ""})
	AADD(aSx1,{cPerg , "03" , "Conta De              ?" , "Conta De              ?" , "Conta De              ?" , "mv_ch3" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par03" , ""    , "" , "" , "" , "" , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1" , "" , "", "", ""          , ""})
	AADD(aSx1,{cPerg , "04" , "Conta Ate             ?" , "Conta Ate             ?" , "Conta Ate             ?" , "mv_ch4" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par04" , ""    , "" , "" , "" , "" , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1" , "" , "", "", ""          , ""})
	AADD(aSx1,{cPerg , "05" , "Contas Zeradas        ?" , "Conta Zeradas         ?" , "Conta Zeradas         ?" , "mv_ch5" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par05" , "Não" , "" , "" , "" , "" , "Sim" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", ""          , ""})
ElseIf nConsulta = 4
	AADD(aSx1,{cPerg , "01" , "Conta Conatbil 1      ?" , "Conta Conatbil 1      ?" , "Conta Conatbil 1      ?" , "mv_ch1" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1" , "" , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "02" , "Grupo do Ativo 1      ?" , "Grupo do Ativo 1      ?" , "Grupo do Ativo 1      ?" , "mv_ch2" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "03" , "Conta Conatbil 2      ?" , "Conta Conatbil 2      ?" , "Conta Conatbil 2      ?" , "mv_ch3" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1" , "" , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "04" , "Grupo do Ativo 2      ?" , "Grupo do Ativo 2      ?" , "Grupo do Ativo 2      ?" , "mv_ch4" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "" , "", "", "", ""})
ElseIf nConsulta == 7
	AADD(aSx1,{cPerg , "01" , "Data De               	?" , "Data De               	?" , "Data De                  	?" , "mv_ch1" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "02" , "Data Ate              	?" , "Data Ate              	?" , "Data Ate                 	?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "03" , "Lp´s 642,650,660,655,665 ?" , "Lp´s 642,650,660,655,665  ?" , "Lp´s 642,650,660,655,665 	?" , "mv_ch3" , "C" , 30 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "04" , "Conta Conatbil 1      	?" , "Conta Conatbil 1      	?" , "Conta Conatbil 1      	?" , "mv_ch4" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1" , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "05" , "Conta Conatbil 2      	?" , "Conta Conatbil 2      	?" , "Conta Conatbil 2      	?" , "mv_ch5" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1" , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "06" , "Conta Conatbil 3      	?" , "Conta Conatbil 3      	?" , "Conta Conatbil 3      	?" , "mv_ch6" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par06" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1" , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "07" , "Conta Conatbil 4      	?" , "Conta Conatbil 4      	?" , "Conta Conatbil 4      	?" , "mv_ch7" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par07" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1" , "" , "", "", "", ""})
	AADD(aSx1,{cPerg , "08" , "Somente Diferenças    	?" , "Somente Diferenças	 	?" , "Somente Diferenças		?" , "mv_ch8" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par08" , "Nao" , ""    , ""    , "" , "" , "Sim"    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "", "", "", ""})
EndIf

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek(cPerg)
	
	DbSeek(cPerg)
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == cPerg
		Reclock("SX1",.F.,.F.)
		DbDelete()
		MsunLock()
		DbSkip()
	End
	
	For X1:=1 to Len(aSX1)
		RecLock("SX1",.T.)
		For Z:=1 To FCount()
			FieldPut(Z,aSx1[X1,Z])
		Next
		MsunLock()
	Next
	
Endif*/

Return
