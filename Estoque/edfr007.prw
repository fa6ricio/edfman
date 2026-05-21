#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥ EDFR007     ≥ Autor ≥ Luis Felipe Mattos	≥ Data ≥ 27.03.14 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ PosiÁ„o de Estoque                      			 		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 		 ≥ Gera Excel                                           	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum													  ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function EDFR007()

Local 	cQry		:= ""
Local	cAlias		:= GetNextAlias()

Private cString    	:= "SB1"
Private wnrel      	:= "EDFR007"
Private aOrd       	:= {"Contrato"}
Private CbTxt     	:= ""
Private cDesc1     	:= "PosiÁ„o de Estoque"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"PosiÁ„o de Estoque", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR007"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR007"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR007"
Private _nlin      	:= 70
Private Cabec1     	:= " "
Private Cabec2     	:= " "

CriaSx1()

IF !Pergunte(cPerg,.T.)
	RETURN
ENDIF

If LastKey() == 27
	Return
Endif

cData	 := CtoD('01/'+SubStr(MV_PAR01,1,2)+'/'+SubStr(MV_PAR01,3,4))
cDataIni := DtoS(cData)
cDataFim := DtoS(LastDay(cData))
cDataSB9 := DtoS(LastDay(CtoD('01/'+If(SubStr(MV_PAR01,1,2)='01','12',StrZero(Val(SubStr(MV_PAR01,1,2))-1,2))+'/'+If(SubStr(MV_PAR01,1,2)='01',Str(Val(SubStr(MV_PAR01,3,4))-1,4),SubStr(MV_PAR01,3,4))))) 

cQry := "SELECT DISTINCT B2_FILIAL, B2_COD, B2_LOCAL, B1_TIPO, B1_GRUPO, B1_DESC, B1_UM, B1_SEGUM, B1_CONTA, B1_CONV, B1_TIPCONV, BM_DESC, "+CENT

cQry += "ISNULL(SB9.B9_QINI,0)    				   				AS B9_QINI, "+CENT
cQry += "ISNULL(SB9.B9_VINI1,0)	  								AS B9_VINI1, "+CENT

cQry += "ISNULL(SD1.D1_QUANT,0) + ISNULL(SD3.D3_QTDE1,0)		AS QENTRADA, "+CENT
cQry += "ISNULL(SD1.D1_CUSTO,0) + ISNULL(SD3.D3_CUSTE1,0)		AS VENTRADA, "+CENT

cQry += "ISNULL(SD2.D2_QUANT,0) + ISNULL(SD3.D3_QTDS1,0)		AS QSAIDA, "+CENT
cQry += "ISNULL(SD2.D2_CUSTO1,0)+ ISNULL(SD3.D3_CUSTS1,0)		AS VSAIDA, "+CENT

cQry += "(ISNULL(SB9.B9_QINI,0)  + ISNULL(SD1.D1_QUANT,0)  + ISNULL(SD3.D3_QTDE1,0)  - (ISNULL(SD2.D2_QUANT,0)  + ISNULL(SD3.D3_QTDS1 ,0))) - (ISNULL(D3_QTDTE1,0)  - ISNULL(D3_QTDTS1,0))  AS QSLD1, "+CENT
//cQry += "(ISNULL(SB9.B9_VINI1,0) + ISNULL(SD1.D1_CUSTO,0)  + ISNULL(SD3.D3_CUSTE1,0) - (ISNULL(SD2.D2_CUSTO1,0) + ISNULL(SD3.D3_CUSTS1,0))) - (ISNULL(D3_CUSTTE1,0) - ISNULL(D3_CUSTTS1,0)) AS VSLD1, "+CENT 07/08/17 - Luis Felipe
cQry += "(ISNULL(SB9.B9_VINI1,0) + ISNULL(SD1.D1_CUSTO,0)  + ISNULL(SD3.D3_CUSTE1,0) - ((ISNULL(SD2.D2_CUSTO1,0) + ISNULL(SD3.D3_CUSTS1,0)))) AS VSLD1, "+CENT

cQry += "ISNULL(B9_QINITRA,0)   + ISNULL(D3_QTDTE1,0)	 - ISNULL(D3_QTDTS1,0)  AS QTRANSITO, "+CENT 
cQry += "ISNULL(B9_VINITRA,0)   + ISNULL(D3_CUSTTE1,0)	 - ISNULL(D3_CUSTTS1,0) AS VTRANSITO, "+CENT 

cQry += "ISNULL(SB9.B9_VINI5,0) + ISNULL(SD1.D1_CUSTO5,0) + ISNULL(SD3.D3_CUSTE5,0) - (ISNULL(SD2.D2_CUSTO5,0) + ISNULL(SD3.D3_CUSTS5,0)) - (ISNULL(D3_CUSTTE5,0) - ISNULL(D3_CUSTTS5,0)) AS VSLD5, "+CENT

cQry += "SZE.ZE_NOME, B2_CM5"+CENT
cQry += "FROM "+CENT
cQry += "(SELECT DISTINCT B2_COD, B2_FILIAL,B2_LOCAL,B1_TIPO, B1_GRUPO, B1_DESC, B1_UM, B1_SEGUM, B1_CONTA, B1_CONV, B1_TIPCONV, BM_DESC, B2_CM5 "+CENT
cQry += "FROM "+RetSqlName("SB1")+" SB1, "+RetSqlName("SB2")+" SB2, "+RetSqlName("SBM")+" SBM "+CENT
cQry += "WHERE B1_COD = B2_COD "+CENT              
cQry += "AND Len(Rtrim(B2_LOCAL)) = 2 "+CENT   
cQry += "AND B1_GRUPO = BM_GRUPO "+CENT   
//
// Filtros do relatÛrio
//
If !Empty(MV_PAR02)
	cQry += " AND B1_TIPO = '"+MV_PAR02+"'"+CENT
EndIf

If !Empty(MV_PAR03)
	cQry += " AND B1_GRUPO  = '"+MV_PAR03+"'"+CENT
EndIf

If !Empty(MV_PAR04)
	cQry += " AND B1_COD    = '"+MV_PAR04+"'"+CENT
EndIf

If !Empty(MV_PAR05)
	cQry += " AND B2_LOCAL  = '"+MV_PAR05+"'"+CENT
EndIf
cQry += "AND SB1.D_E_L_E_T_ = '' "+CENT
cQry += "AND SB2.D_E_L_E_T_ = '' "+CENT
cQry += ") AS SB2 "+CENT
cQry += "LEFT JOIN "+CENT
cQry += "(SELECT DISTINCT D1_FILIAL,D1_COD,D1_LOCAL,SUM(D1_QUANT) AS D1_QUANT,SUM(D1_CUSTO) AS D1_CUSTO, SUM(D1_CUSTO5) AS D1_CUSTO5 "+CENT
cQry += "FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF4")+" SF4" +CENT
cQry += "WHERE D1_TES = F4_CODIGO "+CENT
cQry += "AND D1_DTDIGIT BETWEEN '"+cDataIni+"' AND '"+cDataFim+"'"+CENT
cQry += "AND SF4.F4_ESTOQUE = 'S' "+CENT
cQry += "AND SD1.D_E_L_E_T_ = '' "+CENT
cQry += "AND SF4.D_E_L_E_T_ = '' "+CENT
cQry += "GROUP BY D1_FILIAL,D1_COD,D1_LOCAL "+CENT
cQry += ") AS SD1 "+CENT
cQry += "ON SB2.B2_FILIAL+SB2.B2_COD+SB2.B2_LOCAL = SD1.D1_FILIAL+SD1.D1_COD+SD1.D1_LOCAL "+CENT
cQry += "LEFT JOIN "+CENT
cQry += "(SELECT D2_FILIAL,D2_COD,D2_LOCAL,SUM(D2_QUANT) AS D2_QUANT,SUM(D2_CUSTO1) AS D2_CUSTO1, SUM(D2_CUSTO5) AS D2_CUSTO5 "+CENT
cQry += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF4")+" SF4" +CENT
cQry += "WHERE D2_TES = F4_CODIGO "+CENT
cQry += "AND SD2.D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"'"+CENT
cQry += "AND SF4.F4_ESTOQUE = 'S' "+CENT
cQry += "AND SD2.D_E_L_E_T_ = '' "+CENT
cQry += "AND SF4.D_E_L_E_T_ = '' "+CENT
cQry += "GROUP BY D2_FILIAL,D2_COD,D2_LOCAL "+CENT
cQry += ") AS SD2 "+CENT
cQry += "ON SB2.B2_FILIAL+SB2.B2_COD+SB2.B2_LOCAL = SD2.D2_FILIAL+SD2.D2_COD+SD2.D2_LOCAL "+CENT
cQry += "LEFT JOIN "+CENT
cQry += "(SELECT D3_FILIAL,D3_COD,D3_LOCAL, "+CENT
cQry += "(SELECT SUM(D3_QUANT)  FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND (D3_TM <= 500 AND D3_XD1NSEQ = '' OR D3_TM = 002 AND D3_XD1NSEQ <> '') AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_QTDE1, "+CENT
cQry += "(SELECT SUM(D3_QUANT)  FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND  D3_TM >  500 AND D3_XD1NSEQ = '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_QTDS1, "+CENT
//cQry += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND (D3_TM <= 500 AND D3_XD1NSEQ = '' OR D3_TM = 002 AND D3_XD1NSEQ <> '') AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTE1, "+CENT // 07/08/17 - Luis Felipe
cQry += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND (D3_TM <= 500 OR D3_TM = 002 AND D3_XD1NSEQ <> '') AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTE1, "+CENT
cQry += "(SELECT SUM(D3_CUSTO5) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND (D3_TM <= 500 AND D3_XD1NSEQ = '' OR D3_TM = 002 AND D3_XD1NSEQ <> '') AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTE5, "+CENT
//cQry += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND  D3_TM >  500 AND D3_XD1NSEQ = '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTS1, "+CENT // 07/08/17 - Luis Felipe
cQry += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND  D3_TM >  500 AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTS1, "+CENT
cQry += "(SELECT SUM(D3_CUSTO5) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND  D3_TM >  500 AND D3_XD1NSEQ = '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTS5, "+CENT

// 10/09/14 - Luis Felipe Nascimento
//cQry += "(SELECT SUM(D3_QUANT)  FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND D3_TM <= 500 AND D3_TM <> '499' AND D3_XD1NSEQ <> '' AND  D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_QTDE1, "+CENT
//cQry += "(SELECT SUM(D3_QUANT)  FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND D3_TM >  500 AND D3_TM <> '999' AND D3_XD2NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_QTDS1, "+CENT
//cQry += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND D3_TM <= 500 AND D3_TM <> '499' AND D3_XD1NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTE1, "+CENT
//cQry += "(SELECT SUM(D3_CUSTO5) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND D3_TM <= 500 AND D3_TM <> '499' AND D3_XD1NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTE5, "+CENT
//cQry += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND D3_TM >  500 AND D3_TM <> '999' AND D3_XD2NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTS1, "+CENT
//cQry += "(SELECT SUM(D3_CUSTO5) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND D3_TM >  500 AND D3_TM <> '999' AND D3_XD2NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTS5, "+CENT

// EM TRANSITO
cQry += "(SELECT SUM(D3_QUANT)  FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM <= 500 AND D3_XD1NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_QTDTE1, "+CENT
cQry += "(SELECT SUM(D3_QUANT)  FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM >  500 AND D3_XD1NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_QTDTS1, "+CENT
cQry += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM <= 500 AND D3_XD1NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTTE1, "+CENT
cQry += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM >  500 AND D3_XD1NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTTS1,"+CENT
cQry += "(SELECT SUM(D3_CUSTO5) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM <= 500 AND D3_XD1NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTTE5, "+CENT
cQry += "(SELECT SUM(D3_CUSTO5) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM >  500 AND D3_XD1NSEQ <> '' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTTS5 "+CENT

cQry += "FROM "+RetSqlName("SD3")+" SD3 "+CENT
cQry += "WHERE D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "+CENT
cQry += "AND D3_ESTORNO <> 'S'"+CENT
cQry += "AND D_E_L_E_T_ = ''"+CENT
cQry += "GROUP BY SD3.D3_FILIAL,SD3.D3_COD,SD3.D3_LOCAL "+CENT
cQry += ") AS SD3 "+CENT
cQry += "ON SB2.B2_FILIAL+SB2.B2_COD+SB2.B2_LOCAL = SD3.D3_FILIAL+SD3.D3_COD+SD3.D3_LOCAL "+CENT
cQry += "LEFT JOIN "+CENT
cQry += "(SELECT B9_FILIAL,B9_COD,B9_LOCAL,B9_QINI,B9_VINI1,B9_VINI5, "+CENT      
cQry += "(SELECT B9_QINI  FROM "+RetSqlName("SB9")+" WHERE SB9.B9_FILIAL = B9_FILIAL AND SB9.B9_COD = B9_COD AND B9_DATA = '"+cDataSB9+"' AND B9_LOCAL = SubString(SB9.B9_LOCAL,1,2)+'01' AND D_E_L_E_T_ = '') AS B9_QINITRA, "+CENT      
cQry += "(SELECT B9_VINI1 FROM "+RetSqlName("SB9")+" WHERE SB9.B9_FILIAL = B9_FILIAL AND SB9.B9_COD = B9_COD AND B9_DATA = '"+cDataSB9+"' AND B9_LOCAL = SubString(SB9.B9_LOCAL,1,2)+'01' AND D_E_L_E_T_ = '') AS B9_VINITRA, "+CENT      
cQry += "(SELECT B9_VINI5 FROM "+RetSqlName("SB9")+" WHERE SB9.B9_FILIAL = B9_FILIAL AND SB9.B9_COD = B9_COD AND B9_DATA = '"+cDataSB9+"' AND B9_LOCAL = SubString(SB9.B9_LOCAL,1,2)+'01' AND D_E_L_E_T_ = '') AS B9_VINITRA5 "+CENT      
cQry += "FROM "+RetSqlName("SB9")+" SB9 "+CENT
cQry += "WHERE B9_DATA = '"+cDataSB9+"' "+CENT
cQry += "AND SB9.D_E_L_E_T_ = '' "+CENT
cQry += ") AS SB9 "+CENT
cQry += "ON SB2.B2_FILIAL+SB2.B2_COD+SB2.B2_LOCAL = SB9.B9_FILIAL+SB9.B9_COD+SB9.B9_LOCAL "+CENT
cQry += "LEFT JOIN "+CENT
cQry += "(SELECT ZE_LOCAL,ZE_NOME  "+CENT
cQry += "FROM "+RetSqlName("SZE")+" SZE "+CENT
cQry += "WHERE D_E_L_E_T_ = '' "+CENT
cQry += ") AS SZE "+CENT
cQry += "ON SB2.B2_LOCAL = SZE.ZE_LOCAL "+CENT
cQry += "ORDER BY 2,1,3 "+CENT

MemoWrite("C:\Tmp\EDFR007.txt",cQry)
cQry := ChangeQuery(cQry)

If Select("TRB") > 0
	dbselectarea("TRB")
	TRB->(dbCloseArea())
Endif

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)
dbselectarea("TRB")
TRB->(dbGoTop())

RptStatus({|| GeraPlan()})

If Select("TRB") > 0
	dbselectarea("TRB")
	TRB->(dbCloseArea())
Endif

Return

**************************
Static Function GeraPlan()
**************************

Local oExcel
Local cArq
Local nArq
Local cPath
Local cXml    	:= ""
Local ncountq := 0

If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel n„o instalado!")
	Return
EndIf

cArq := CriaTrab(Nil, .F.)
cPath := "C:\TEMP\"
Makedir(cPath)

nArq := FCreate(cPath + cArq + ".xml")

If nArq == -1
	MsgAlert("Erro ao criar o arquivo: "+cPath + cArq + ".xml")
	Return
EndIf

ProcRegua(RecCount("TRB"))

If TRB->(!EOF())
	
	nLin := 7
	While !TRB->(EOf())
		nLin ++
		TRB->(DbSkip())
	End
	
	TRB->(DbGotop())
	
	While !TRB->(EOf())
		
		cPeriodo := SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4)
		
		cXml := '<?xml version="1.0"?>'+CENT
		cXml += '<?mso-application progid="Excel.Sheet"?>'+CENT
		cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
		cXml += 'xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT
		cXml += ' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT
		cXml += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
		cXml += ' xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT
		cXml += ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT
		cXml += '  <Author>luis.nascimento</Author>'+CENT
		cXml += '  <LastAuthor>luis.nascimento</LastAuthor>'+CENT
		cXml += '  <Created>2014-03-27T19:47:13Z</Created>'+CENT
		cXml += '  <LastSaved>2014-03-28T20:43:19Z</LastSaved>'+CENT
		cXml += '  <Company>Microsoft</Company>'+CENT
		cXml += '  <Version>14.00</Version>'+CENT
		cXml += ' </DocumentProperties>'+CENT
		cXml += ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CENT
		cXml += '  <AllowPNG/>'+CENT
		cXml += ' </OfficeDocumentSettings>'+CENT
		cXml += ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
		cXml += '  <WindowHeight>8505</WindowHeight>'+CENT
		cXml += '  <WindowWidth>18195</WindowWidth>'+CENT
		cXml += '  <WindowTopX>480</WindowTopX>'+CENT
		cXml += '  <WindowTopY>60</WindowTopY>'+CENT
		cXml += '  <ProtectStructure>False</ProtectStructure>'+CENT
		cXml += '  <ProtectWindows>False</ProtectWindows>'+CENT
		cXml += ' </ExcelWorkbook>'+CENT
		cXml += ' <Styles>'+CENT
		cXml += '  <Style ss:ID="Default" ss:Name="Normal">'+CENT
		cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders/>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
		cXml += '   <Interior/>'+CENT
		cXml += '   <NumberFormat/>'+CENT
		cXml += '   <Protection/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s17">'+CENT
		cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s18">'+CENT
		cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <NumberFormat ss:Format="@"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s19">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Interior ss:Color="#F2F2F2" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s20">'+CENT
		cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders/>'+CENT
		cXml += '   <Interior/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s21">'+CENT
		cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s22">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s23">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <NumberFormat ss:Format="@"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s24">'+CENT
		cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <NumberFormat ss:Format="@"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s25">'+CENT
		cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <NumberFormat ss:Format="#,##0.000"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s26">'+CENT
		cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += ' </Styles>'+CENT
		cXml += ' <Worksheet ss:Name="Parametros">'+CENT
		cXml += '  <Table ss:ExpandedColumnCount="21" ss:ExpandedRowCount="13" x:FullColumns="1"'+CENT
		cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
		cXml += '   <Column ss:Width="81"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="128.25"/>'+CENT
		cXml += '   <Column ss:Width="25.5"/>'+CENT
		cXml += '   <Column ss:Width="33.75"/>'+CENT
		cXml += '   <Column ss:Width="60.75"/>'+CENT
		cXml += '   <Column ss:Width="49.5"/>'+CENT
		cXml += '   <Column ss:Width="81"/>'+CENT
		cXml += '   <Column ss:Width="28.5"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="1"/>'+CENT
		cXml += '   <Column ss:Index="11" ss:AutoFitWidth="0" ss:Width="76.5" ss:Span="1"/>'+CENT
		cXml += '   <Column ss:Index="13" ss:AutoFitWidth="0" ss:Width="78" ss:Span="1"/>'+CENT
		cXml += '   <Column ss:Index="15" ss:AutoFitWidth="0" ss:Width="73.5" ss:Span="1"/>'+CENT
		cXml += '   <Column ss:Index="17" ss:AutoFitWidth="0" ss:Width="83.25"/>'+CENT
		cXml += '   <Column ss:Width="28.5"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="82.5"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="74.25" ss:Span="1"/>'+CENT
		cXml += '   <Row>'+CENT
		cXml += '    <Cell><Data ss:Type="String">Mes / Ano:</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+cPeriodo+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s16"/>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row>'+CENT
		cXml += '    <Cell><Data ss:Type="String">Tipo Produto:</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s17"><Data ss:Type="String">'+Alltrim(MV_PAR02)+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s17"/>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row>'+CENT
		cXml += '    <Cell><Data ss:Type="String">Grupo Produto:</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+Alltrim(MV_PAR03)+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"/>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row>'+CENT
		cXml += '    <Cell><Data ss:Type="String">Produto:</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s17"><Data ss:Type="String">'+Alltrim(MV_PAR04)+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s17"/>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row>'+CENT
		cXml += '    <Cell><Data ss:Type="String">Filial/Armazem:</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+Alltrim(MV_PAR05)+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"/>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row ss:Index="7">'+CENT
		cXml += '    <Cell ss:StyleID="s20"/>'+CENT
		cXml += '    <Cell ss:StyleID="s21"/>'+CENT
		cXml += '    <Cell ss:StyleID="s22"/>'+CENT
		cXml += '    <Cell ss:StyleID="s23"/>'+CENT
		cXml += '    <Cell ss:StyleID="s24"/>'+CENT
		cXml += '    <Cell ss:StyleID="s23"/>'+CENT
		cXml += '    <Cell ss:StyleID="s24"/>'+CENT
		cXml += '    <Cell ss:StyleID="s23"/>'+CENT
		cXml += '    <Cell ss:StyleID="s25"/>'+CENT
		cXml += '    <Cell ss:StyleID="s26"/>'+CENT
		cXml += '    <Cell ss:StyleID="s25"/>'+CENT
		cXml += '    <Cell ss:StyleID="s26"/>'+CENT
		cXml += '    <Cell ss:StyleID="s25"/>'+CENT
		cXml += '    <Cell ss:StyleID="s26"/>'+CENT
		cXml += '    <Cell ss:StyleID="s25"/>'+CENT
		cXml += '    <Cell ss:StyleID="s26"/>'+CENT
		cXml += '    <Cell ss:StyleID="s25"/>'+CENT
		cXml += '    <Cell ss:StyleID="s23"/>'+CENT
		cXml += '    <Cell ss:StyleID="s18"/>'+CENT
		cXml += '    <Cell ss:StyleID="s26"/>'+CENT
		cXml += '    <Cell ss:StyleID="s18"/>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '  </Table>'+CENT
		cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
		cXml += '   <PageSetup>'+CENT
		cXml += '    <Header x:Margin="0.31496062000000002"/>'+CENT
		cXml += '    <Footer x:Margin="0.31496062000000002"/>'+CENT
		cXml += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT
		cXml += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT
		cXml += '   </PageSetup>'+CENT
		cXml += '   <Print>'+CENT
		cXml += '    <ValidPrinterInfo/>'+CENT
		cXml += '    <PaperSizeIndex>9</PaperSizeIndex>'+CENT
		cXml += '    <HorizontalResolution>600</HorizontalResolution>'+CENT
		cXml += '    <VerticalResolution>600</VerticalResolution>'+CENT
		cXml += '   </Print>'+CENT
		cXml += '   <Selected/>'+CENT
		cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
		cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
		cXml += '  </WorksheetOptions>'+CENT
		cXml += ' </Worksheet>'+CENT
		cXml += ' <Worksheet ss:Name="Plan2">'+CENT
		cXml += '  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="1" x:FullColumns="1"'+CENT
		cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
		cXml += '  </Table>'+CENT
		cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
		cXml += '   <PageSetup>'+CENT
		cXml += '    <Header x:Margin="0.31496062000000002"/>'+CENT
		cXml += '    <Footer x:Margin="0.31496062000000002"/>'+CENT
		cXml += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT
		cXml += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT
		cXml += '   </PageSetup>'+CENT
		cXml += '   <Visible>SheetHidden</Visible>'+CENT
		cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
		cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
		cXml += '  </WorksheetOptions>'+CENT
		cXml += ' </Worksheet>'+CENT
		cXml += ' <Worksheet ss:Name="Kardex Resumido">'+CENT
		cXml += '  <Table ss:ExpandedColumnCount="21" ss:ExpandedRowCount="'+Alltrim(Str(nLin))+'" x:FullColumns="1"'+CENT
		cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
		cXml += '   <Column ss:Width="67.5"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="170.25"/>'+CENT
		cXml += '   <Column ss:Width="25.5"/>'+CENT
		cXml += '   <Column ss:Width="33.75"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="114.75"/>'+CENT
		cXml += '   <Column ss:Width="49.5"/>'+CENT
		cXml += '   <Column ss:Width="81"/>'+CENT
		cXml += '   <Column ss:Width="28.5"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="84" ss:Span="8"/>'+CENT
		cXml += '   <Column ss:Index="18" ss:Width="28.5"/>'+CENT
		cXml += '   <Column ss:Width="73.5"/>'+CENT
		cXml += '   <Column ss:Width="72.75"/>'+CENT
		cXml += '   <Column ss:Width="74.25"/>'+CENT
		cXml += '   <Row ss:Height="15.75">'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Produto</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Descricao</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Tipo</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Grupo</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Desc. Grupo</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Filial/Armazem</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Descr. Armazem</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">1 UM</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Sld. Inicial</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Sld.Inic.Vlr</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Entradas</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Entradas Vlr</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Saidas</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Saidas Vlr</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Sld. Final</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Sld.Final.Vlr</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Sld. Transito</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">2 UM</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Sld. Final 2 UM</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Posicao USD</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Conta Contabil</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT
		
		While !TRB->(EOf())
			
			ncountq++ 
			
			IncProc() 
			
			If	MV_PAR06 == 1 .and. TRB->B9_VINI1 == 0 .and. TRB->VENTRADA == 0 .and. TRB->VSAIDA == 0 .or. !Empty(MV_PAR07) .and. MV_PAR07 <> TRB->B2_FILIAL
				DbSkip()
				Loop 
			EndIf
			
			If TRB->B1_TIPCONV = 'D'
				nSldSegum := TRB->QSLD1 / TRB->B1_CONV
			Else
				nSldSegum := TRB->QSLD1 * TRB->B1_CONV
			EndIf

			cXml += '   <Row>'+CENT
			cXml += '    <Cell ss:StyleID="s20"><Data ss:Type="String">'+TRB->B2_COD+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s21"><Data ss:Type="String">'+Alltrim(TRB->B1_DESC)+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="String">'+Alltrim(TRB->B1_TIPO)+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s23"><Data ss:Type="String">'+Alltrim(TRB->B1_GRUPO)+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s24"><Data ss:Type="String">'+Alltrim(TRB->BM_DESC)+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s23"><Data ss:Type="String">'+TRB->B2_FILIAL+'/'+Alltrim(TRB->B2_LOCAL)+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s24"><Data ss:Type="String">'+Alltrim(TRB->ZE_NOME)+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s23"><Data ss:Type="String">'+Alltrim(TRB->B1_UM)+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s25"><Data ss:Type="String">'+Rtrim(Transform(TRB->B9_QINI  ,"@E 99,999,999,999.999"))+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s26"><Data ss:Type="String">'+Rtrim(Transform(TRB->B9_VINI1 ,"@E 99,999,999,999.99"))+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s25"><Data ss:Type="String">'+Rtrim(Transform(TRB->QENTRADA ,"@E 99,999,999,999.999"))+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s26"><Data ss:Type="String">'+Rtrim(Transform(TRB->VENTRADA ,"@E 99,999,999,999.99"))+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s25"><Data ss:Type="String">'+Rtrim(Transform(TRB->QSAIDA   ,"@E 99,999,999,999.999"))+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s26"><Data ss:Type="String">'+Rtrim(Transform(TRB->VSAIDA   ,"@E 999,999,999,999.99"))+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s25"><Data ss:Type="String">'+Rtrim(Transform(TRB->QSLD1    ,"@E 99,999,999,999.999"))+'</Data></Cell>'+CENT  
			cXml += '    <Cell ss:StyleID="s26"><Data ss:Type="String">'+Rtrim(Transform(TRB->VSLD1    ,"@E 99,999,999,999.99"))+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s25"><Data ss:Type="String">'+Rtrim(Transform(TRB->QTRANSITO,"@E 99,999,999,999.999"))+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s23"><Data ss:Type="String">'+Alltrim(TRB->B1_SEGUM)+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+Rtrim(Transform(nSldSegum		,"@E 99,999,999,999.999"))+'</Data></Cell>'+CENT
//			cXml += '    <Cell ss:StyleID="s26"><Data ss:Type="String">'+Rtrim(Transform(TRB->VSLD5	   	,"@E 999,999,999.99"))+'</Data></Cell>'+CENT // 09/03/17 - Luis Felipe
//			cXml += '    <Cell ss:StyleID="s26"><Data ss:Type="String">'+Rtrim(Transform(TRB->B2_CM5 * TRB->QSLD1	,"@E 999,999,999,999.99"))+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s26"><Data ss:Type="String">'+Rtrim(Transform(TRB->VSLD5	   	,"@E 999,999,999.99"))+'</Data></Cell>'+CENT // 07/08/17 - Luis Felipe

			cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+Alltrim(TRB->B1_CONTA)+'</Data></Cell>'+CENT
			cXml += '   </Row>'+CENT
			
			If	ncountq == 380 .or. TRB->(Eof())
				FWrite(nArq,cXml)
				cXml := ""
				ncountq := 0
			EndIf  

			TRB->(DbSkip())
		End
		cXml += '  </Table>'+CENT
		cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
		cXml += '   <PageSetup>'+CENT
		cXml += '    <Header x:Margin="0.31496062000000002"/>'+CENT
		cXml += '    <Footer x:Margin="0.31496062000000002"/>'+CENT
		cXml += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT
		cXml += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT
		cXml += '   </PageSetup>'+CENT
		cXml += '   <Panes>'+CENT
		cXml += '    <Pane>'+CENT
		cXml += '     <Number>3</Number>'+CENT
		cXml += '     <ActiveRow>1</ActiveRow>'+CENT
		cXml += '     <ActiveCol>1</ActiveCol>'+CENT
		cXml += '    </Pane>'+CENT
		cXml += '   </Panes>'+CENT
		cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
		cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
		cXml += '  </WorksheetOptions>'+CENT
		cXml += ' </Worksheet>'+CENT
		cXml += '</Workbook>'+CENT
	End
	FWrite(nArq,cXml)
	FClose(nArq)
	shellExecute( "Open", cPath + cArq + ".xml", " /k dir", "C:\", 1 )
EndIf

Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                        4                       5                        6           7     8   9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24   25   26   27   28   29   30   31   32   33   34   35   36      37   38  39  40  41  42  43
AADD(aSx1,{"EDFR007" , "01" , "MÍs/Ano ReferÍncia ?" , "MÍs/Ano ReferÍncia?" , "MÍs/Ano ReferÍncia ?" , "mv_ch1" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "@R 99/9999", ""})
AADD(aSx1,{"EDFR007" , "02" , "Tipo Produto       ?" , "Tipo Produto      ?" , "Tipo Produto       ?" , "mv_ch2" , "C" , 02 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "02"  , "" , "", "", "", ""})
AADD(aSx1,{"EDFR007" , "03" , "Grupo Produto      ?" , "Grupo Produto     ?" , "Tipo Produto       ?" , "mv_ch3" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SBM" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR007" , "04" , "Produto       	  ?" , "Produto    		  ?" , "Produto       	   ?" , "mv_ch4" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SB1" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR007" , "05" , "ArmazÈm       	  ?" , "ArmazÈm    		  ?" , "ArmazÈm       	   ?" , "mv_ch5" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR007" , "06" , "Prods Sld. Zerado  ?" , "Prods Sld. Zerado ?" , "Prods Sld. Zerado  ?" , "mv_ch6" , "C" , 01 , 0 , 0 , "C" , "" , "mv_par06" , "N„o" , ""    , ""    , "" , "" , "Sim" , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR007" , "07" , "Filial             ?" , "Filial            ?" , "Filial             ?" , "mv_ch7" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par07" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "DLB" , "" , "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR007   07")
	
	DbSeek("EDFR007")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR007"
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
