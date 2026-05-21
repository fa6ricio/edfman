#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥ EDFR009     ≥ Autor ≥ Luis Felipe Mattos	≥ Data ≥ 09.05.14 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Resultado por Navio                     			 		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 		 ≥ Gera Excel - Financeiro                              	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracao ≥                       Luis Felipe Nascimento     17/06/15   ±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracao ≥ AlteraÁ„o no filtro dos grupos de produtos atravÈs da des- ≥±±
±±≥          ≥ criÁ„o a fim de garantir a informaÁ„o.				      ≥±±
±±≥			 ≥                       Luis Felipe Nascimento     17/06/15   ±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracao ≥ Luis Felipe Nascimento				            03/08/16  ≥±±
±±≥          ≥ Usado o custo mÈdio em dolar para o calculo dos produtos   ≥±±
±±≥          ≥ sem Petax.								  			      ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function EDFR009()

Local 	cQry		:= ""
Local	cAlias		:= GetNextAlias()

Private cString    	:= "SB1"
Private wnrel      	:= "EDFR009"
Private aOrd       	:= {"Contrato"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Resultado por Navio"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Resultado por Navio", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR009"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR009"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR009"
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

cQry := "SELECT DISTINCT SD2.D2_FILIAL, SD2.D2_CLVL, SD2.CTH_DESC01, A1_NREDUZ, SD2.D2_DOC, D2_EMISSAO, CN9_XFORNE, TIPO, D2_COD, D2_LOCAL,"+CENT
cQry += "			    D2_QUANT, D2_UM, CUS_REALTM, CUS_REAL, CUS_USTM, CUS_PTAX,D2_ITEM,"+CENT
cQry += "				VLR_RTM, VLR_R, VLR_USTM, VLR_US,"+CENT
cQry += "				C_OUTXTLR  * (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END/QTDTOT) AS C_OUTXTLR,"+CENT
cQry += "				C_OUTVHPR  * (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END/QTDTOT) AS C_OUTVHPR,"+CENT
cQry += "				C_OUTXTLUS * (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END/QTDTOT) AS C_OUTXTLUS,"+CENT
cQry += "				C_OUTVHPUS * (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END/QTDTOT) AS C_OUTVHPUS,"+CENT   
cQry += "				C_ESEXTLR  * (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END/QTDTOT) AS C_ESEXTLR,"+CENT				
cQry += "				C_ESEVHPR  * (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END/QTDTOT) AS C_ESEVHPR,"+CENT	
cQry += "				C_ESEXTLUS * (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END/QTDTOT) AS C_ESEXTLUS,"+CENT
cQry += "				C_ESEVHPUS * (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END/QTDTOT) AS C_ESEVHPUS,"+CENT
cQry += "				QTDDEV_Q, VLRDEV_R, VLRDEV_US, CUSDEV_R, D1_DOC, D1_COD, D1_LOCAL,M2_MOEDA4, D1_DTDIGIT"+CENT
cQry += " FROM "+CENT
cQry += " (SELECT DISTINCT D2_FILIAL, D2_CLVL, A1_NREDUZ, D2_DOC, D2_EMISSAO, D2_COD, D2_LOCAL, D2_QUANT, D2_UM, D2_ITEM,"+CENT
cQry += " D2_CUSTO1 / (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END)	AS CUS_REALTM,"+CENT
cQry += " D2_CUSTO1 AS CUS_REAL,"+CENT
//cQry += " (D2_CUSTO1 / (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END)) / (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND Month(C7_DATPRF) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(C7_DATPRF) = '"+SubStr(MV_PAR01,3,4)+"' AND D_E_L_E_T_ = ' ') AS CUS_USTM, "+CENT  // 04/08/15- Luis Felipe
//cQry += " D2_CUSTO1 / (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND Month(C7_DATPRF) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(C7_DATPRF) = '"+SubStr(MV_PAR01,3,4)+"' AND D_E_L_E_T_ = ' ') AS CUS_PTAX,"+CENT // 04/08/15- Luis Felipe

/* 03/08/16 - Luis Felipe - Adicionado custo mÈdio calculado no final do mÍs antes da virada dos saldos.
cQry += " (D2_CUSTO1 / (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END)) / (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') AS CUS_USTM, "+CENT 
cQry += " D2_CUSTO1 / (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') AS CUS_PTAX,"+CENT
*/

// cQry += " (D2_CUSTO1 / (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END)) / (CASE WHEN (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') <> 0 THEN (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') ELSE (SELECT B2_CMFIM2 FROM "+RetSqlName("SB2")+" WHERE B2_COD = D2_COD AND B2_LOCAL = D2_LOCAL AND D_E_L_E_T_ = ' ') END) AS CUS_USTM, "+CENT // 20/02/17 - Luis Felipe 
cQry += " (D2_CUSTO1 / (CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END)) / (CASE WHEN (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') <> 0 THEN (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') ELSE (SELECT CASE WHEN B2_CMFIM2 = 0 THEN B2_CM2 ELSE B2_CMFIM2 END B2_CMFIM2 FROM "+RetSqlName("SB2")+" WHERE B2_COD = D2_COD AND B2_LOCAL = D2_LOCAL AND D_E_L_E_T_ = ' ') END) AS CUS_USTM, "+CENT 

//cQry += " D2_CUSTO1 / (CASE WHEN (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') <> 0 THEN (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') ELSE (SELECT B2_CMFIM2 FROM "+RetSqlName("SB2")+" WHERE B2_COD = D2_COD AND B2_LOCAL = D2_LOCAL AND D_E_L_E_T_ = ' ') END) AS CUS_PTAX,"+CENT
//cQry += " (CASE WHEN (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') <> 0 THEN D2_CUSTO1 / (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') ELSE D2_QUANT * (SELECT B2_CMFIM2 FROM "+RetSqlName("SB2")+" WHERE B2_COD = D2_COD AND B2_LOCAL = D2_LOCAL AND D_E_L_E_T_ = ' ') END) AS CUS_PTAX,"+CENT // 20/02/17 - Luis Felipe 
cQry += " (CASE WHEN (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') <> 0 THEN D2_CUSTO1 / (SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ = ' ') ELSE D2_QUANT * (SELECT CASE WHEN B2_CMFIM2 = 0 THEN B2_CM2 ELSE B2_CMFIM2 END B2_CMFIM2 FROM "+RetSqlName("SB2")+" WHERE B2_COD = D2_COD AND B2_LOCAL = D2_LOCAL AND D_E_L_E_T_ = ' ') END) AS CUS_PTAX,"+CENT

cQry += " (D2_TOTAL/(CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END)) AS VLR_RTM,"+CENT
cQry += " D2_TOTAL					    AS VLR_R,"+CENT
cQry += " (D2_TOTAL/M2_MOEDA4)/(CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END) AS VLR_USTM,"+CENT
cQry += " D2_TOTAL/M2_MOEDA4            AS VLR_US,"+CENT
// cQry += " (CASE WHEN B1_GRUPO = '001' THEN 'VHP' ELSE 'XTL' END) TIPO,"+CENT 29/06/16 - Luis Felipe
cQry += " (CASE WHEN BM_DESC LIKE '%VHP%' THEN 'VHP' ELSE (CASE WHEN BM_DESC LIKE '%XTL%' THEN 'XTL' ELSE (CASE WHEN BM_DESC LIKE '%REFINADO%' THEN 'REF' ELSE (CASE WHEN BM_DESC LIKE '%SACARIA%' THEN 'SAC' ELSE (CASE WHEN BM_DESC LIKE '%SOJA%' THEN 'SOJA' ELSE '???' END) END) END) END) END) TIPO,"+CENT
cQry += " CN9_XFORNE,"+CENT
cQry += " (SELECT CTH_DESC01 FROM "+RetSqlName("CTH")+" CTH WHERE SD2.D2_CLVL = CTH.CTH_CLVL AND CTH.D_E_L_E_T_ = '') AS CTH_DESC01, "+CENT
//cQry += " FROM "+RetSqlName("SD2")+" SD2,"+RetSqlName("SB2")+" SB2,"+RetSqlName("SA1")+" SA1, "+RetSqlName("SM2")+" SM2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("CN9")+" CN9, "+RetSqlName("SZ2")+" SZ2 "+CENT // 29/06/16 - Luis Felipe
// 08/08/16 - Luis Felipe - Inicio
cQry += " (SELECT D1_QUANT  FROM "+RetSqlName("SD1")+" WHERE D2_FILIAL = D1_FILIAL AND D2_COD = D1_COD AND D2_LOCAL = D1_LOCAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS QTDDEV_Q,"+CENT 
cQry += " (SELECT D1_TOTAL  FROM "+RetSqlName("SD1")+" WHERE D2_FILIAL = D1_FILIAL AND D2_COD = D1_COD AND D2_LOCAL = D1_LOCAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS VLRDEV_R,"+CENT 
cQry += " (SELECT D1_TOTAL/M2_MOEDA4 FROM "+RetSqlName("SD1")+" WHERE D2_FILIAL = D1_FILIAL AND D2_COD = D1_COD AND D2_LOCAL = D1_LOCAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS VLRDEV_US,"+CENT 
cQry += " (SELECT D1_CUSTO  FROM "+RetSqlName("SD1")+" WHERE D2_FILIAL = D1_FILIAL AND D2_COD = D1_COD AND D2_LOCAL = D1_LOCAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS CUSDEV_R,"+CENT 
cQry += " (SELECT D1_DOC    FROM "+RetSqlName("SD1")+" WHERE D2_FILIAL = D1_FILIAL AND D2_COD = D1_COD AND D2_LOCAL = D1_LOCAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS D1_DOC,"+CENT 
cQry += " (SELECT D1_COD    FROM "+RetSqlName("SD1")+" WHERE D2_FILIAL = D1_FILIAL AND D2_COD = D1_COD AND D2_LOCAL = D1_LOCAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS D1_COD,"+CENT 
cQry += " (SELECT D1_LOCAL  FROM "+RetSqlName("SD1")+" WHERE D2_FILIAL = D1_FILIAL AND D2_COD = D1_COD AND D2_LOCAL = D1_LOCAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS D1_LOCAL,"+CENT 
cQry += " (SELECT D1_DTDIGIT FROM "+RetSqlName("SD1")+" WHERE D2_FILIAL = D1_FILIAL AND D2_COD = D1_COD AND D2_LOCAL = D1_LOCAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS D1_DTDIGIT,"+CENT // 21/08/17 - Luis Felipe
cQry += " M2_MOEDA4" 
// 08/08/16 - Luis Felipe - Fim
cQry += " FROM "+RetSqlName("SD2")+" SD2,"+RetSqlName("SB2")+" SB2,"+RetSqlName("SA1")+" SA1, "+RetSqlName("SM2")+" SM2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("CN9")+" CN9, "+RetSqlName("SZ2")+" SZ2, "+RetSqlName("SBM")+" SBM "+CENT
cQry += " WHERE ((Month(D2_EMISSAO) = '"+If(SubStr(MV_PAR01,1,2)='01','12',StrZero(Val(SubStr(MV_PAR01,1,2))-1,2))+"' AND Year(D2_EMISSAO) = '"+If(SubStr(MV_PAR01,1,2)='01',Str(Val(SubStr(MV_PAR01,3,4))-1,4),SubStr(MV_PAR01,3,4)) + "')"+CENT
cQry += " OR  (Month(D2_EMISSAO) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(D2_EMISSAO) = '"+SubStr(MV_PAR01,3,4)+"'))"+CENT
cQry += " AND D2_FILIAL  = B2_FILIAL"+CENT
cQry += " AND D2_COD     = B2_COD"+CENT
cQry += " AND D2_LOCAL   = B2_LOCAL"+CENT
cQry += " AND D2_CLIENTE = A1_COD"+CENT
cQry += " AND D2_LOJA    = A1_LOJA"+CENT
cQry += " AND D2_EMISSAO = M2_DATA"+CENT
cQry += " AND D2_COD     = B1_COD"+CENT
cQry += " AND B1_GRUPO   = BM_GRUPO"+CENT // 29/06/16 - Luis Felipe
/* 03/08/15 - Luis Felipe
cQry += " AND D2_FILIAL  = C7_FILIAL"+CENT
cQry += " AND D2_COD     = C7_PRODUTO"+CENT 
cQry += " AND Month(C7_DATPRF) = '"+SubStr(MV_PAR01,1,2)+"'"+CENT // 07/07/15 - Luis Felipe - Duplicava os registros porque haviam pedidos com taxas diferentes
*/
cQry += " AND D2_CF      = '7501 '"+CENT
//cQry += " AND D2_TIPO	<> 'C'"+CENT       // 15/05/15 - Luis Felipe
cQry += " AND D2_TIPO	<> 'D'"+CENT       // 31/05/15 - Luis Felipe
cQry += " AND D2_COD     = Z2_CODPRO "+CENT
cQry += " AND Substring(Z2_CONTRA,1,1) = 'P'"+CENT
cQry += " AND Z2_CONTRA  = CN9_NUMERO "+CENT

If !Empty(MV_PAR02) 
	cQry += " AND D2_CLVL = '"+MV_PAR02+"'"+CENT
EndIf
cQry += " AND D2_CLVL <> ' '"+CENT // 03/08/15 - Luis Felipe

If MV_PAR03 = 1 
	cQry += " AND BM_DESC LIKE '%VHP%' "+CENT
ElseIf MV_PAR03 = 2 
	cQry += " AND BM_DESC LIKE '%XTL%'"+CENT
ElseIf MV_PAR03 = 3 
	cQry += " AND BM_DESC LIKE '%REFINADO%'"+CENT
ElseIf MV_PAR03 = 4 
	cQry += " AND BM_DESC LIKE '%SACARIA%'"+CENT
EndIf

If !Empty(MV_PAR04)              	
	cQry += " AND D2_COD = '"+MV_PAR04+"'"+CENT
EndIf

cQry += " AND D2_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+CENT
cQry += " AND B2_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+CENT
cQry += " AND SD2.D_E_L_E_T_ = ' '"+CENT
cQry += " AND SB2.D_E_L_E_T_ = ' '"+CENT 
cQry += " AND SA1.D_E_L_E_T_ = ' '"+CENT
cQry += " AND SB1.D_E_L_E_T_ = ' '"+CENT
cQry += " AND SM2.D_E_L_E_T_ = ' '"+CENT
// cQry += " AND SC7.D_E_L_E_T_ = ' '"+CENT // 03/08/15 - Luis Felipe
cQry += " AND CN9.D_E_L_E_T_ = ' ')"+CENT
cQry += " AS SD2"+CENT
cQry += " LEFT JOIN"+CENT
cQry += " (SELECT D1_FILIAL, D1_CLVL,"+CENT
cQry += " ISNULL((SELECT SUM(D1_CUSTO)    		  FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SM2")+" SM WHERE SD.D1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND SD.D1_FILIAL = SD1.D1_FILIAL AND SD.D1_CLVL = SD1.D1_CLVL AND SD.D1_DTDIGIT = M2_DATA AND SD.D1_XDESCRI NOT LIKE '%ESTUFAGEM%' AND SD.D1_XDESCRI NOT LIKE '%ELEVACAO%' AND Month(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,3,4)+"' AND SD.D1_CONTA  = '32102030'              AND D1_TIPO <> 'D' AND SD.D_E_L_E_T_ = '' AND SM.D_E_L_E_T_ = '' GROUP BY D1_CLVL),0) C_OUTXTLR,"+CENT
cQry += " ISNULL((SELECT SUM(D1_CUSTO)            FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SM2")+" SM WHERE SD.D1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND SD.D1_FILIAL = SD1.D1_FILIAL AND SD.D1_CLVL = SD1.D1_CLVL AND SD.D1_DTDIGIT = M2_DATA AND SD.D1_XDESCRI NOT LIKE '%ESTUFAGEM%' AND SD.D1_XDESCRI NOT LIKE '%ELEVACAO%' AND Month(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,3,4)+"' AND SD.D1_CONTA IN ('32101030','32101060') AND D1_TIPO <> 'D' AND SD.D_E_L_E_T_ = '' AND SM.D_E_L_E_T_ = '' GROUP BY D1_CLVL),0) C_OUTVHPR,"+CENT
cQry += " ISNULL((SELECT SUM(D1_CUSTO/M2_MOEDA4)  FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SM2")+" SM WHERE SD.D1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND SD.D1_FILIAL = SD1.D1_FILIAL AND SD.D1_CLVL = SD1.D1_CLVL AND SD.D1_DTDIGIT = M2_DATA AND SD.D1_XDESCRI NOT LIKE '%ESTUFAGEM%' AND SD.D1_XDESCRI NOT LIKE '%ELEVACAO%' AND Month(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,3,4)+"' AND SD.D1_CONTA  = '32102030'              AND D1_TIPO <> 'D' AND SD.D_E_L_E_T_ = '' AND SM.D_E_L_E_T_ = '' GROUP BY D1_CLVL),0) C_OUTXTLUS,"+CENT
cQry += " ISNULL((SELECT SUM(D1_CUSTO/M2_MOEDA4)  FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SM2")+" SM WHERE SD.D1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND SD.D1_FILIAL = SD1.D1_FILIAL AND SD.D1_CLVL = SD1.D1_CLVL AND SD.D1_DTDIGIT = M2_DATA AND SD.D1_XDESCRI NOT LIKE '%ESTUFAGEM%' AND SD.D1_XDESCRI NOT LIKE '%ELEVACAO%' AND Month(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,3,4)+"' AND SD.D1_CONTA IN ('32101030','32101060') AND D1_TIPO <> 'D' AND SD.D_E_L_E_T_ = '' AND SM.D_E_L_E_T_ = '' GROUP BY D1_CLVL),0) C_OUTVHPUS,"+CENT
cQry += " ISNULL((SELECT SUM(D1_CUSTO)			  FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SM2")+" SM WHERE SD.D1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND SD.D1_FILIAL = SD1.D1_FILIAL AND SD.D1_CLVL = SD1.D1_CLVL AND SD.D1_DTDIGIT = M2_DATA AND (SD.D1_XDESCRI LIKE    '%ESTUFAGEM%' OR  SD.D1_XDESCRI LIKE	'%ELEVACAO%')    AND Month(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,3,4)+"' AND SD.D1_CONTA  = '32102020'              AND D1_TIPO <> 'D' AND SD.D_E_L_E_T_ = '' AND SM.D_E_L_E_T_ = '' GROUP BY D1_CLVL),0) C_ESEXTLR,"+CENT
cQry += " ISNULL((SELECT SUM(D1_CUSTO)			  FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SM2")+" SM WHERE SD.D1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND SD.D1_FILIAL = SD1.D1_FILIAL AND SD.D1_CLVL = SD1.D1_CLVL AND SD.D1_DTDIGIT = M2_DATA AND (SD.D1_XDESCRI LIKE    '%ESTUFAGEM%' OR  SD.D1_XDESCRI LIKE	'%ELEVACAO%')    AND Month(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,3,4)+"' AND SD.D1_CONTA  = '32101020'			   AND D1_TIPO <> 'D' AND SD.D_E_L_E_T_ = '' AND SM.D_E_L_E_T_ = '' GROUP BY D1_CLVL),0) C_ESEVHPR,"+CENT
cQry += " ISNULL((SELECT SUM(D1_CUSTO/M2_MOEDA4)  FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SM2")+" SM WHERE SD.D1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND SD.D1_FILIAL = SD1.D1_FILIAL AND SD.D1_CLVL = SD1.D1_CLVL AND SD.D1_DTDIGIT = M2_DATA AND (SD.D1_XDESCRI LIKE	   '%ESTUFAGEM%' OR  SD.D1_XDESCRI LIKE	'%ELEVACAO%')    AND Month(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,3,4)+"' AND SD.D1_CONTA  = '32102020'              AND D1_TIPO <> 'D' AND SD.D_E_L_E_T_ = '' AND SM.D_E_L_E_T_ = '' GROUP BY D1_CLVL),0) C_ESEXTLUS,"+CENT
cQry += " ISNULL((SELECT SUM(D1_CUSTO/M2_MOEDA4)  FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SM2")+" SM WHERE SD.D1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND SD.D1_FILIAL = SD1.D1_FILIAL AND SD.D1_CLVL = SD1.D1_CLVL AND SD.D1_DTDIGIT = M2_DATA AND (SD.D1_XDESCRI LIKE	   '%ESTUFAGEM%' OR  SD.D1_XDESCRI LIKE	'%ELEVACAO%')    AND Month(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,1,2)+"' AND Year(SD.D1_DTDIGIT) = '"+SubStr(MV_PAR01,3,4)+"' AND SD.D1_CONTA  = '32101020'			   AND D1_TIPO <> 'D' AND SD.D_E_L_E_T_ = '' AND SM.D_E_L_E_T_ = '' GROUP BY D1_CLVL),0) C_ESEVHPUS"+CENT
cQry += " FROM "+RetSqlName("SF1")+" SF1,"+RetSqlName("SD1")+" SD1 "+CENT
cQry += " WHERE Month(F1_DTDIGIT) = '"+SubStr(MV_PAR01,1,2)+"'"+CENT
cQry += " AND Year(F1_DTDIGIT) = '"+SubStr(MV_PAR01,3,4)+"'"+CENT
cQry += " AND F1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+CENT
cQry += " AND D1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+CENT
cQry += " AND F1_FILIAL  = D1_FILIAL"+CENT
cQry += " AND F1_DOC     = D1_DOC"+CENT
cQry += " AND F1_SERIE   = D1_SERIE"+CENT
cQry += " AND F1_FORNECE = D1_FORNECE"+CENT
cQry += " AND F1_LOJA    = D1_LOJA"+CENT
cQry += " AND SF1.D_E_L_E_T_ = ' '"+CENT
cQry += " AND SD1.D_E_L_E_T_ = ' ')"+CENT
cQry += " AS SD1"+CENT
cQry += " ON SD2.D2_CLVL = SD1.D1_CLVL AND SD2.D2_FILIAL = SD1.D1_FILIAL"+CENT
cQry += " LEFT JOIN"+CENT
//cQry += " (SELECT D2_CLVL, CASE WHEN SUM(D2_QUANT)= 0 THEN 1 ELSE SUM(D2_QUANT) END QTDTOT"+CENT// 15/05/15 - Luis Felipe - Case When
cQry += " (SELECT D2_CLVL, SUM(CASE WHEN D2_QUANT = 0 THEN 1 ELSE D2_QUANT END) QTDTOT"+CENT//  26/06/15 - Luis Felipe - Case When
cQry += " FROM  "+RetSqlName("SD2")+" SD2"+CENT
cQry += " WHERE Month(D2_EMISSAO) = '"+SubStr(MV_PAR01,1,2)+"'"+CENT
cQry += " AND Year(D2_EMISSAO) = '"+SubStr(MV_PAR01,3,4)+"'"+CENT
cQry += " AND D2_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+CENT

If !Empty(MV_PAR02) 
	cQry += " AND D2_CLVL = '"+MV_PAR02+"'"+CENT
EndIf

cQry += " AND SD2.D_E_L_E_T_ = ' '"+CENT
//cQry += " GROUP BY D2_CLVL,D2_QUANT)"+CENT  // 26/06/15 - Luis Felipe
cQry += " GROUP BY D2_CLVL)"+CENT
cQry += " AS SD2T"+CENT
cQry += " ON SD2.D2_CLVL = SD2T.D2_CLVL"+CENT
cQry += " ORDER BY 6,3,9"+CENT

/*
cQry += " (SELECT D2_CLVL, D2_DOC, (CASE WHEN SUM(D2_QUANT) = 0 THEN 1 ELSE D2_QUANT END) AS QTDTOT"+CENT
cQry += " FROM  "+RetSqlName("SD2")+" SD2"+CENT
cQry += " WHERE Month(D2_EMISSAO) = '"+SubStr(MV_PAR01,1,2)+"'"+CENT
cQry += " AND Year(D2_EMISSAO) = '"+SubStr(MV_PAR01,3,4)+"'"+CENT
cQry += " AND D2_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'"+CENT

If !Empty(MV_PAR02) 
	cQry += " AND D2_CLVL = '"+MV_PAR02+"'"+CENT
EndIf

cQry += " AND SD2.D_E_L_E_T_ = ' '"+CENT
cQry += " GROUP BY D2_CLVL,D2_DOC,D2_QUANT)"+CENT
cQry += " AS SD2T"+CENT
cQry += " ON SD2.D2_CLVL = SD2T.D2_CLVL AND SD2.D2_DOC = SD2T.D2_DOC"+CENT
cQry += " ORDER BY 6,3"+CENT

*/

MemoWrite("C:\Tmp\EDFR009.txt",cQry)
  
If Select("TRB") > 0
	dbselectarea("TRB")
	TRB->(dbCloseArea())
Endif

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)
dbselectarea("TRB")
TRB->(dbGoTop())

Processa ( { ||  GeraPlan()  } )

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
Local cXml    	 	:= ""
Local nD2_QUANTM 	:= 0
Local nD2_QUANTSC	:= 0

Local nVCUS_REAL	:= 0
Local nVCUS_PTAX	:= 0
Local nVVLR_R		:= 0
Local nVVLR_US		:= 0
Local nVC_OUTRR		:= 0
Local nVC_OUTRUS	:= 0
Local nVC_ESESR		:= 0
Local nVC_ESESUS	:= 0

Local nXCUS_REAL	:= 0
Local nXCUS_PTAX	:= 0
Local nXVLR_R		:= 0
Local nXVLR_US		:= 0
Local nXC_OUTRR		:= 0
Local nXC_OUTRUS	:= 0
Local nXC_ESESR		:= 0
Local nXC_ESESUS	:= 0

Local nVTD2_QTDTM 	:= 0
Local nVTD2_QTDSC	:= 0
Local nVTCUS_REAL	:= 0
Local nVTCUS_PTAX	:= 0
Local nVTVLR_R		:= 0
Local nVTVLR_US		:= 0
Local nVTC_OUTRR	:= 0
Local nVTC_OUTRUS	:= 0
Local nVTC_ESESR	:= 0
Local nVTC_ESESUS	:= 0
Local nVTMGTOTR 	:= 0
Local nVTMGTOTU 	:= 0

Local nXTD2_QTDTM 	:= 0
Local nXTD2_QTDSC	:= 0
Local nXTCUS_REAL	:= 0
Local nXTCUS_PTAX	:= 0
Local nXTVLR_R		:= 0
Local nXTVLR_US		:= 0
Local nXTC_OUTRR	:= 0
Local nXTC_OUTRUS	:= 0
Local nXTC_ESESR	:= 0
Local nXTC_ESESUS	:= 0
Local nXTMGTOTR 	:= 0
Local nXTMGTOTU 	:= 0

Local nSldMesM1  	:= 0
Local nSld_XTL_R 	:= 0
Local nSld_VHP_R 	:= 0
Local nSld_XTL_US	:= 0
Local nSld_VHP_US	:= 0 

Local NMGTOTR       := 0
Local nMGTOTU		:= 0
Local nMARGEM		:= 0

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

If TRB->(!EOF())
	
	nLin := 150
	While !TRB->(EOf())
		nLin ++
		TRB->(DbSkip())
	End
	
	ProcRegua(nLin-150)
	
	TRB->(DbGotop())
	
	While !TRB->(EOf())
	
		IncProc()
		
		cXml := '<?xml version="1.0"?>'+CENT
		cXml += '<?mso-application progid="Excel.Sheet"?>'+CENT
		cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
		cXml += ' xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT
		cXml += ' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT
		cXml += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
		cXml += ' xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT
		cXml += ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT
		cXml += '  <Author>svogt</Author>'+CENT
		cXml += '  <LastAuthor>luis.nascimento</LastAuthor>'+CENT
		cXml += '  <LastPrinted>2014-01-10T14:21:04Z</LastPrinted>'+CENT
		cXml += '  <Created>2013-12-06T21:18:07Z</Created>'+CENT
		cXml += '  <LastSaved>2014-05-14T19:05:16Z</LastSaved>'+CENT
		cXml += '  <Company>E D &amp; F MAN BRASIL S.A.</Company>'+CENT
		cXml += '  <Version>14.00</Version>'+CENT
		cXml += ' </DocumentProperties>'+CENT
		cXml += ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CENT
		cXml += '  <AllowPNG/>'+CENT
		cXml += ' </OfficeDocumentSettings>'+CENT
		cXml += ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
		cXml += '  <WindowHeight>7215</WindowHeight>'+CENT
		cXml += '  <WindowWidth>19320</WindowWidth>'+CENT
		cXml += '  <WindowTopX>240</WindowTopX>'+CENT
		cXml += '  <WindowTopY>825</WindowTopY>'+CENT
		cXml += '  <ActiveSheet>1</ActiveSheet>'+CENT
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
		cXml += '  <Style ss:ID="s58" ss:Name="Normal 2">'+CENT
		cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s16" ss:Name="VÌrgula">'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m32595092" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m32595112" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m32595132">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m32595152">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m32595172">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m32595192">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m32595212">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m32595232" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
		cXml += '     ss:Color="#000000"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
		cXml += '     ss:Color="#000000"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m32595252" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m32595272">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="m51263400">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s75" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
		cXml += '     ss:Color="#000000"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
		cXml += '     ss:Color="#000000"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
		cXml += '     ss:Color="#000000"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s76" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
		cXml += '     ss:Color="#000000"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
		cXml += '     ss:Color="#000000"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s77" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s78" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s79" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s80" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s81" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s82" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s83" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s84" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s85" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s86">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s87">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
		cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s88" ss:Parent="s16">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s89" ss:Parent="s16">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s90">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s91">'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s92">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s93">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s94">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s95" ss:Parent="s16">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s96">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s97">'+CENT
		cXml += '   <Interior/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s98">'+CENT
		cXml += '   <Interior/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s99">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
		cXml += '   <NumberFormat ss:Format="0"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s100">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s101" ss:Parent="s16">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s102">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <Interior/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s103">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s104">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <Interior/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s105" ss:Parent="s58">'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s108">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s109">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s110">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s111" ss:Parent="s16">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s112">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <Interior/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s113">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <Interior ss:Color="#DCE6F1" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s114">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <Interior ss:Color="#FDE9D9" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s115">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <Interior ss:Color="#F2DCDB" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s116">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <Interior ss:Color="#DAEEF3" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s117" ss:Parent="s16">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s118" ss:Parent="s16">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s119" ss:Parent="s16">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s120" ss:Parent="s16">'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s121" ss:Parent="s16">'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s122" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s123" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s124" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s125" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s126" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s127" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"'+CENT
		cXml += '    ss:Italic="1"/>'+CENT
		cXml += '   <Interior ss:Color="#76933C" ss:Pattern="Solid"/>'+CENT
		cXml += '   <NumberFormat ss:Format="_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s128">'+CENT
		cXml += '   <NumberFormat ss:Format="mm/yyyy"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s129">'+CENT
		cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s130">'+CENT
		cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <NumberFormat ss:Format="@"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s131">'+CENT
		cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '    <Style ss:ID="s132">'+CENT
		cXml += '    <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
		cXml += '    <NumberFormat ss:Format="Standard"/>'+CENT
		cXml += '    </Style>'+CENT
		cXml += '  <Style ss:ID="s133" ss:Parent="s16">'+CENT
		cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s150">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
		cXml += '    ss:Bold="1"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += '  <Style ss:ID="s153">'+CENT
		cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
		cXml += '   <Borders>'+CENT
		cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
		cXml += '     ss:Color="#000000"/>'+CENT
		cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
		cXml += '     ss:Color="#000000"/>'+CENT
		cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
		cXml += '     ss:Color="#000000"/>'+CENT
		cXml += '   </Borders>'+CENT
		cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>'+CENT
		cXml += '   <Interior ss:Color="#00B050" ss:Pattern="Solid"/>'+CENT
		cXml += '  </Style>'+CENT
		cXml += ' </Styles>'+CENT
		cXml += ' <Worksheet ss:Name="Parametros">'+CENT
		cXml += '  <Table ss:ExpandedColumnCount="3" ss:ExpandedRowCount="7" x:FullColumns="1"'+CENT
		cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
		cXml += '   <Column ss:Index="3" ss:Width="67.5"/>'+CENT
		cXml += '   <Row ss:Index="2">'+CENT
		cXml += '    <Cell ss:Index="2"><Data ss:Type="String">MÍs/Ano:</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s128"><Data ss:Type="DateTime">2014-04-01T00:00:00.000</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row>'+CENT
		cXml += '    <Cell ss:Index="2"><Data ss:Type="String">Navio:</Data></Cell>'+CENT
		cXml += '    <Cell><Data ss:Type="String">FAFWEFCZFW</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row>'+CENT
		cXml += '    <Cell ss:Index="2"><Data ss:Type="String">Tipo :</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s129"><Data ss:Type="String">VHP</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row>'+CENT
		cXml += '    <Cell ss:Index="2"><Data ss:Type="String">Produto:</Data></Cell>'+CENT
		cXml += '    <Cell><Data ss:Type="String">P12232-12123</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row>'+CENT
		cXml += '    <Cell ss:Index="2"><Data ss:Type="String">Filial De:</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s130"><Data ss:Type="String">0101</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row>'+CENT
		cXml += '    <Cell ss:Index="2"><Data ss:Type="String">Filial Ate:</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s130"><Data ss:Type="String">0102</Data></Cell>'+CENT
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
		cXml += '    <HorizontalResolution>-3</HorizontalResolution>'+CENT
		cXml += '    <VerticalResolution>-3</VerticalResolution>'+CENT
		cXml += '   </Print>'+CENT
		cXml += '   <Panes>'+CENT
		cXml += '    <Pane>'+CENT
		cXml += '     <Number>3</Number>'+CENT
		cXml += '     <ActiveRow>2</ActiveRow>'+CENT
		cXml += '     <ActiveCol>2</ActiveCol>'+CENT
		cXml += '    </Pane>'+CENT
		cXml += '   </Panes>'+CENT
		cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
		cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
		cXml += '  </WorksheetOptions>'+CENT
		cXml += ' </Worksheet>'+CENT
		cXml += ' <Worksheet ss:Name="FATEX">'+CENT
		cXml += '  <Table ss:ExpandedColumnCount="24" ss:ExpandedRowCount="'+Alltrim(Str(nLin))+'" x:FullColumns="1"'+CENT
		cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
		cXml += '   <Column ss:Width="122.25"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="67.5"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="51.75" ss:Span="1"/>'+CENT
		cXml += '   <Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="79.5"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="48.75"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="71.25"/>'+CENT
		cXml += '   <Column ss:StyleID="s119" ss:Width="60.75"/>'+CENT
		cXml += '   <Column ss:StyleID="s119" ss:Width="66"/>'+CENT
		cXml += '   <Column ss:StyleID="s89" ss:AutoFitWidth="0" ss:Width="63"/>'+CENT
		cXml += '   <Column ss:StyleID="s89" ss:AutoFitWidth="0" ss:Width="75"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="58.5"/>'+CENT
		cXml += '   <Column ss:StyleID="s89" ss:AutoFitWidth="0" ss:Width="80.25"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="63"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="75"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="63"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="93"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="60.75"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="69.75"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="78"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="60"/>'+CENT
		cXml += '   <Column ss:AutoFitWidth="0" ss:Width="78.75" ss:Span="1"/>'+CENT
		cXml += '   <Column ss:Index="24" ss:AutoFitWidth="0" ss:Width="48.75"/>'+CENT
		cXml += '   <Row ss:Height="15.75">'+CENT
		cXml += '    <Cell ss:MergeAcross="23" ss:StyleID="s153"><Data ss:Type="String">RESULTADO POR NAVIO (FATEX)</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row ss:Height="39">'+CENT
		cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m32595132"><Data ss:Type="String">NAVIO</Data></Cell>'+CENT
		cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m32595152"><Data ss:Type="String">CLIENTE</Data></Cell>'+CENT
		cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m32595172"><Data ss:Type="String">NF</Data></Cell>'+CENT
		cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m32595192"><Data ss:Type="String">DATA</Data></Cell>'+CENT
		cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m32595212"><Data ss:Type="String">TIPO DE PRODUTO</Data></Cell>'+CENT
		cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m32595272"><Data ss:Type="String">USINA</Data></Cell>'+CENT
		cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m51263400"><Data ss:Type="String">CONTRATO</Data></Cell>'+CENT
		cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m32595092"><Data ss:Type="String">QTDE TM</Data></Cell>'+CENT
		cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m32595112"><Data ss:Type="String">QTDE SC</Data></Cell>'+CENT
		cXml += '    <Cell ss:MergeAcross="3" ss:StyleID="m32595232"><Data ss:Type="String">CUSTO DO ACUCAR</Data></Cell>'+CENT
		cXml += '    <Cell ss:MergeAcross="3" ss:StyleID="m32595252"><Data ss:Type="String">RECEITA</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s123"><Data ss:Type="String">OUTROS</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s124"><Data ss:Type="String">OUTROS</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s122"><Data ss:Type="String">ESTUFAGEM/ELEVA«√O</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s122"><Data ss:Type="String">ESTUFAGEM/ELEVA«√O</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s126"><Data ss:Type="String">MARGEM TOTAL</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s127"><Data ss:Type="String">MARGEM TOTAL</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s125"><Data ss:Type="String">MARGEM</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT
		cXml += '   <Row ss:Height="15.75">'+CENT
		cXml += '    <Cell ss:Index="10" ss:StyleID="s75"><Data ss:Type="String">R$/TM</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">R$</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">US$/TM</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">US$</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s77"><Data ss:Type="String">R$/TM</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">R$</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">US$/TM</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String">US$</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">R$</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">US$</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">R$</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s82"><Data ss:Type="String">US$</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s83"><Data ss:Type="String">R$</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">US$</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s85"><Data ss:Type="String">US$/TM</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT

		While !TRB->(EOf())
			                                      
			cNAVIO := TRB->D2_CLVL
			cDoc   := TRB->D2_DOC  
			cItem  := TRB->D2_ITEM
			
			IncProc()

			nSld_XTL_R := fSldMes("01","32102010",TRB->D2_COD,TRB->D2_CLVL)
			nSld_VHP_R := fSldMes("01","32101010",TRB->D2_COD,TRB->D2_CLVL)
			nSld_XTL_US:= fSldMes("02","32102010",TRB->D2_COD,TRB->D2_CLVL)
			nSld_VHP_US:= fSldMes("02","32101010",TRB->D2_COD,TRB->D2_CLVL)
			
			If SubStr(TRB->D2_EMISSAO,5,2)+Substr(TRB->D2_EMISSAO,1,4) == MV_PAR01

				nMGTOTR := TRB->VLR_R  - (TRB->CUS_REAL+If((nSld_XTL_R)>0,(nSld_XTL_R),0)+If((nSld_VHP_R)>0,(nSld_VHP_R),0)) - TRB->C_OUTXTLR - TRB->C_OUTVHPR - TRB->C_ESEXTLR - TRB->C_ESEVHPR
				nMGTOTU := TRB->VLR_US - (TRB->CUS_PTAX+If((nSld_XTL_US)>0,(nSld_XTL_US),0)+If((nSld_VHP_US)>0,(nSld_VHP_US),0)) - TRB->C_OUTXTLUS - TRB->C_OUTVHPUS - TRB->C_ESEXTLUS - TRB->C_ESEVHPUS          
				nMARGEM := nMGTOTU / TRB->D2_QUANT            
	
				cData  	:= SubStr(TRB->D2_EMISSAO,1,4)+"-"+SubStr(TRB->D2_EMISSAO,5,2)+"-"+SubStr(TRB->D2_EMISSAO,7,2)+"T00:00:00.000"
				
				cXml += '   <Row ss:Height="12" ss:StyleID="s86">'+CENT
				cXml += '    <Cell ss:StyleID="s131"><Data ss:Type="String">'+Alltrim(TRB->D2_CLVL)+' - '+Alltrim(TRB->CTH_DESC01)+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s131"><Data ss:Type="String">'+Alltrim(TRB->A1_NREDUZ)+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s99"><Data ss:Type="String">'+Alltrim(TRB->D2_DOC)+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="DateTime">'+cData+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s108"><Data ss:Type="String">'+Alltrim(TRB->TIPO)+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s131"><Data ss:Type="String">'+Alltrim(TRB->CN9_XFORNE)+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s131"><Data ss:Type="String">'+Alltrim(TRB->D2_COD)+'</Data></Cell>'+CENT
		
				If TRB->D2_UM <> 'SC' 
					cXml += '    <Cell ss:StyleID="s132"><Data ss:Type="String">'+Transform(TRB->D2_QUANT,"@E 999,999,999.999")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s132"><Data ss:Type="String">'+Str(0,15,3)+'</Data></Cell>'+CENT
					nD2_QUANTM += TRB->D2_QUANT 
				Else
					cXml += '    <Cell ss:StyleID="s132"><Data ss:Type="String">'+Str(0,15,3)+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s132"><Data ss:Type="String">'+Transform(TRB->D2_QUANT,"@E 999,999,999.999")+'</Data></Cell>'+CENT
					nD2_QUANTSC+= TRB->D2_QUANT
			    EndIf
				
				nCUS_REALTM := (TRB->CUS_REAL+If((nSld_XTL_R)>0,nSld_XTL_R,0)+If((nSld_VHP_R)>0,(nSld_VHP_R),0)) / TRB->D2_QUANT  
				nCUS_USTM   := (TRB->CUS_PTAX+If((nSld_XTL_US)>0,(nSld_XTL_US),0)+(nSld_VHP_US)) / TRB->D2_QUANT
	
				cXml += '    <Cell ss:StyleID="s133"><Data ss:Type="String">'+Transform(nCUS_REALTM,"@E 999,999,999.9999")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(If(TRB->D2_QUANT <> 0,TRB->CUS_REAL+If((nSld_XTL_R)>0,nSld_XTL_R,0)+If((nSld_VHP_R)>0,(nSld_VHP_R),0),0),"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(nCUS_USTM ,"@E 999,999,999.9999")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(If(TRB->D2_QUANT <> 0,TRB->CUS_PTAX+If((nSld_XTL_US)>0,(nSld_XTL_US),0)+If((nSld_VHP_US)>0,(nSld_VHP_US),0),0),"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(TRB->VLR_RTM   ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(TRB->VLR_R,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(TRB->VLR_USTM  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(TRB->VLR_US,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(TRB->C_OUTXTLR+TRB->C_OUTVHPR   ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(TRB->C_OUTXTLUS+TRB->C_OUTVHPUS  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(TRB->C_ESEXTLR+TRB->C_ESEVHPR  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(TRB->C_ESEXTLUS+TRB->C_ESEVHPUS  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(nMGTOTR        ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(nMGTOTU        ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(nMARGEM        ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '   </Row>'+CENT
			EndIf
			
            // 22/08/16 
            
			lDocDevol := .f.
                   
			If !Empty(TRB->D1_DOC) .and. SubStr(TRB->D1_DTDIGIT,5,2)+SubStr(TRB->D1_DTDIGIT,1,4) == MV_PAR01
				
				cData  	:= SubStr(TRB->D1_DTDIGIT,1,4)+"-"+SubStr(TRB->D1_DTDIGIT,5,2)+"-"+SubStr(TRB->D1_DTDIGIT,7,2)+"T00:00:00.000" // 21/08/17 - Luis Felipe

				cXml += '   <Row ss:Height="12" ss:StyleID="s86">'+CENT
				cXml += '    <Cell ss:StyleID="s131"><Data ss:Type="String">'+Alltrim(TRB->D2_CLVL)+' - '+Alltrim(TRB->CTH_DESC01)+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s131"><Data ss:Type="String">'+Alltrim(TRB->A1_NREDUZ)+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s99"><Data ss:Type="String">'+Alltrim(TRB->D1_DOC)+'-DV'+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="DateTime">'+cData+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s108"><Data ss:Type="String">'+Alltrim(TRB->TIPO)+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s131"><Data ss:Type="String">'+Alltrim(TRB->CN9_XFORNE)+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s131"><Data ss:Type="String">'+Alltrim(TRB->D2_COD)+'</Data></Cell>'+CENT
		
				If TRB->D2_UM <> 'SC' 
					cXml += '    <Cell ss:StyleID="s132"><Data ss:Type="String">'+Transform(-TRB->QTDDEV_Q,"@E 999,999,999.999")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s132"><Data ss:Type="String">'+Str(0,15,3)+'</Data></Cell>'+CENT
					nD2_QUANTM -= TRB->QTDDEV_Q 
				Else
					cXml += '    <Cell ss:StyleID="s132"><Data ss:Type="String">'+Str(0,15,3)+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s132"><Data ss:Type="String">'+Transform(-TRB->QTDDEV_Q,"@E 999,999,999.999")+'</Data></Cell>'+CENT
					nD2_QUANTSC -= TRB->QTDDEV_Q
			    EndIf
                
				nCUS_PTAX := 0 
				SC7->(DbSetOrder(2))
				If !SC7->(DbSeek(TRB->D2_FILIAL+TRB->D1_COD))
					SB2->(DbSetOrder(1))
					If SB2->(DbSeek(TRB->D2_FILIAL+TRB->D1_COD+TRB->D1_LOCAL))
// 						nCUS_PTAX := TRB->QTDDEV_Q * SB2->B2_CMFIM2 // 20/02/17 - Luis Felipe
						nCUS_PTAX := TRB->QTDDEV_Q * If(SB2->B2_CMFIM2<>0,SB2->B2_CMFIM2,SB2->B2_CM2)
					EndIf
				Else
					nCUS_PTAX := TRB->CUSDEV_R / SC7->C7_TAXAUSD
				EndIf 

				nCUS_REALTM := TRB->CUSDEV_R / TRB->QTDDEV_Q
				nCUS_USTM   := nCUS_PTAX / TRB->QTDDEV_Q

				//nMGTOTR := TRB->VLR_R  - TRB->CUS_REAL 
				nMGTOTR := TRB->VLRDEV_R - TRB->CUSDEV_R
				
//				nMGTOTU := TRB->VLR_US - TRB->CUS_PTAX 
				nMGTOTU := (TRB->VLRDEV_R/TRB->M2_MOEDA4) - nCUS_PTAX
  
//				nMARGEM := nMGTOTU / TRB->D2_QUANT            
				nMARGEM := nMGTOTU / TRB->QTDDEV_Q      

				nCUS_PTAX 	:= -1 * nCUS_PTAX
				nCUS_REALTM := -1 * nCUS_REALTM
				nCUS_USTM   := -1 * nCUS_USTM
				nMGTOTR 	:= -1 * nMGTOTR
				nMGTOTU 	:= -1 * nMGTOTU
				nMARGEM 	:= -1 * nMARGEM
                    
				// ((TRB->VLRDEV_R/TRB->M2_MOEDA4)/TRB->QTDDEV_Q) * TRB->QTDDEV_Q -- AQUI

				cXml += '    <Cell ss:StyleID="s133"><Data ss:Type="String">'+Transform(nCUS_REALTM,"@E 999,999,999.9999")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(-1 * TRB->CUSDEV_R,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(nCUS_USTM ,"@E 999,999,999.9999")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(nCUS_PTAX,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(-1 * (TRB->VLRDEV_R / TRB->QTDDEV_Q),"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(-1 * TRB->VLRDEV_R,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(-1 * ((TRB->VLRDEV_R/TRB->M2_MOEDA4)/TRB->QTDDEV_Q),"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(-1 * TRB->VLRDEV_US,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(0  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(0  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(0  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(0  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(nMGTOTR        ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(nMGTOTU        ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform(nMARGEM        ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '   </Row>'+CENT
                
				lDocDevol := .t.
				
            EndIf
            
			If SubStr(TRB->D2_EMISSAO,5,2)+Substr(TRB->D2_EMISSAO,1,4) == MV_PAR01 .or. lDocDevol 
				If TRB->TIPO = 'VHP'
					nVCUS_REAL	+= If(!lDocDevol,TRB->CUS_REAL+If(nSld_VHP_R>0,nSld_VHP_R,0),-TRB->CUSDEV_R)
					nVCUS_PTAX	+= If(!lDocDevol,TRB->CUS_PTAX+If((nSld_VHP_US)>0,(nSld_VHP_US),0),nCUS_PTAX)
					nVVLR_R		+= If(!lDocDevol,TRB->VLR_R,-TRB->VLRDEV_R)
					nVVLR_US	+= If(!lDocDevol,TRB->VLR_US,-TRB->VLRDEV_US)
					nVC_OUTRR	+= TRB->C_OUTVHPR
					nVC_OUTRUS	+= TRB->C_OUTVHPUS
					nVC_ESESR	+= TRB->C_ESEVHPR
					nVC_ESESUS	+= TRB->C_ESEVHPUS
				Else
					nXCUS_REAL	+= If(!lDocDevol,TRB->CUS_REAL+If(nSld_XTL_R>0,nSld_XTL_R,0),-TRB->CUSDEV_R)
					nXCUS_PTAX	+= If(!lDocDevol,TRB->CUS_PTAX+If((nSld_XTL_US)>0,(nSld_XTL_US),0),nCUS_PTAX)
					nXVLR_R		+= If(!lDocDevol,TRB->VLR_R,-TRB->VLRDEV_R)
					nXVLR_US	+= If(!lDocDevol,TRB->VLR_US,-TRB->VLRDEV_US)
					nXC_OUTRR	+= TRB->C_OUTXTLR
					nXC_OUTRUS	+= TRB->C_OUTXTLUS
					nXC_ESESR	+= TRB->C_ESEXTLR
					nXC_ESESUS	+= TRB->C_ESEXTLUS
				EndIf
			EndIf
           
            // 22/08/16

			cTipo := TRB->TIPO          
			
			TRB->(DbSkip())       
			
			// Pula quando houver Ptax diferentes para um mesmo Pedido de Compras 
			If cNAVIO == TRB->D2_CLVL .and. cDoc == TRB->D2_DOC .and. cItem = TRB->D2_ITEM
				TRB->(DbSkip())       
			EndIf	

			If cNAVIO <> TRB->D2_CLVL .and. nD2_QUANTM + nD2_QUANTSC <> 0 
				cXml += '   <Row ss:Height="15.75">'+CENT
				cXml += '    <Cell ss:Index="2" ss:StyleID="s105"/>'+CENT
				cXml += '    <Cell ss:StyleID="s105"/>'+CENT
				cXml += '    <Cell ss:Index="17" ss:StyleID="s91"/>'+CENT
				cXml += '    <Cell ss:StyleID="s97"/>'+CENT
				cXml += '    <Cell ss:StyleID="s98"/>'+CENT
				cXml += '    <Cell ss:StyleID="s97"/>'+CENT
				cXml += '    <Cell ss:StyleID="s98"/>'+CENT
				cXml += '    <Cell ss:Index="23" ss:StyleID="s91"/>'+CENT
				cXml += '   </Row>'+CENT
                
				nVMGTOTR := nVVLR_R  - nVCUS_REAL - nVC_OUTRR  - nVC_ESESR            
				nVMGTOTU := nVVLR_US - nVCUS_PTAX - nVC_OUTRUS - nVC_ESESUS            

				nXMGTOTR := nXVLR_R  - nXCUS_REAL - nXC_OUTRR  - nXC_ESESR            
				nXMGTOTU := nXVLR_US - nXCUS_PTAX - nXC_OUTRUS - nXC_ESESUS            

 				If cTipo == 'VHP'
					cXml += '   <Row ss:Height="12" ss:StyleID="s86">'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nD2_QUANTM ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nD2_QUANTSC ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVCUS_REAL  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVCUS_PTAX  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVVLR_R     ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVVLR_US    ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVC_OUTRR   ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVC_OUTRUS  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVC_ESESR   ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVC_ESESUS  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVMGTOTR  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVMGTOTU  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '   </Row>'+CENT
                Else
					cXml += '   <Row ss:Height="12" ss:StyleID="s86">'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nD2_QUANTM ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nD2_QUANTSC ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXCUS_REAL  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXCUS_PTAX  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXVLR_R     ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXVLR_US    ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXC_OUTRR   ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXC_OUTRUS  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXC_ESESR   ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXC_ESESUS  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXMGTOTR  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXMGTOTU  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '   </Row>'+CENT
                EndIf
                
				cXml += '   <Row ss:Height="15.75">'+CENT
				cXml += '    <Cell ss:Index="2" ss:StyleID="s105"/>'+CENT
				cXml += '    <Cell ss:StyleID="s105"/>'+CENT
				cXml += '    <Cell ss:Index="17" ss:StyleID="s91"/>'+CENT
				cXml += '    <Cell ss:StyleID="s97"/>'+CENT
				cXml += '    <Cell ss:StyleID="s98"/>'+CENT
				cXml += '    <Cell ss:StyleID="s97"/>'+CENT
				cXml += '    <Cell ss:StyleID="s98"/>'+CENT
				cXml += '    <Cell ss:Index="23" ss:StyleID="s91"/>'+CENT
				cXml += '   </Row>'+CENT 

				If cTipo = 'VHP'
					nVTD2_QTDTM += nD2_QUANTM
					nVTD2_QTDSC	+= nD2_QUANTSC
					nVTCUS_REAL	+= nVCUS_REAL 
					nVTCUS_PTAX	+= nVCUS_PTAX 
					nVTVLR_R	+= nVVLR_R
					nVTVLR_US	+= nVVLR_US
					nVTC_OUTRR	+= nVC_OUTRR
					nVTC_OUTRUS	+= nVC_OUTRUS
					nVTC_ESESR	+= nVC_ESESR
					nVTC_ESESUS	+= nVC_ESESUS
					nVTMGTOTR 	:= nVTVLR_R  - nVTCUS_REAL - nVTC_OUTRR  - nVTC_ESESR             
					nVTMGTOTU 	:= nVTVLR_US - nVTCUS_PTAX - nVTC_OUTRUS - nVTC_ESESUS             
				Else
					nXTD2_QTDTM += nD2_QUANTM
					nXTD2_QTDSC	+= nD2_QUANTSC
					nXTCUS_REAL	+= nXCUS_REAL 
					nXTCUS_PTAX	+= nXCUS_PTAX 
					nXTVLR_R	+= nXVLR_R
					nXTVLR_US	+= nXVLR_US
					nXTC_OUTRR	+= nXC_OUTRR
					nXTC_OUTRUS	+= nXC_OUTRUS
					nXTC_ESESR	+= nXC_ESESR
					nXTC_ESESUS	+= nXC_ESESUS
					nXTMGTOTR 	:= nXTVLR_R  - nXTCUS_REAL - nXTC_OUTRR  - nXTC_ESESR             
					nXTMGTOTU 	:= nXTVLR_US - nXTCUS_PTAX - nXTC_OUTRUS - nXTC_ESESUS            
				EndIf

				nD2_QUANTM 	:= 0 
				nD2_QUANTSC	:= 0
				nVCUS_REAL	:= 0
				nVCUS_PTAX	:= 0
				nVVLR_R		:= 0
				nVVLR_US	:= 0
				nVC_OUTRR	:= 0
				nVC_OUTRUS	:= 0
				nVC_ESESR	:= 0
				nVC_ESESUS	:= 0

				nXCUS_REAL	:= 0
				nXCUS_PTAX	:= 0
				nXVLR_R		:= 0
				nXVLR_US	:= 0
				nXC_OUTRR	:= 0
				nXC_OUTRUS	:= 0
				nXC_ESESR	:= 0
				nXC_ESESUS	:= 0

	        EndIf
		End

		If Eof() 
			cXml += '   <Row ss:Height="15.75" ss:StyleID="s103">'+CENT
			cXml += '    <Cell ss:MergeAcross="6" ss:StyleID="s150"><Data ss:Type="String">TOTAIS ACUCAR VHP</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTD2_QTDTM ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTD2_QTDSC ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s111"/>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTCUS_REAL ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s110"/>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTCUS_PTAX ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s110"/>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTVLR_R ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s110"/>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTVLR_US ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTC_OUTRR ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTC_OUTRUS ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTC_ESESR ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTC_ESESUS ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTMGTOTR ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nVTMGTOTU ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s110"/>'+CENT
			cXml += '   </Row>'+CENT
			cXml += '   <Row ss:Height="15.75">'+CENT
			cXml += '    <Cell ss:Index="2" ss:StyleID="s105"/>'+CENT
			cXml += '    <Cell ss:StyleID="s105"/>'+CENT
			cXml += '    <Cell ss:Index="17" ss:StyleID="s91"/>'+CENT
			cXml += '    <Cell ss:StyleID="s97"/>'+CENT
			cXml += '    <Cell ss:StyleID="s98"/>'+CENT
			cXml += '    <Cell ss:StyleID="s97"/>'+CENT
			cXml += '    <Cell ss:StyleID="s98"/>'+CENT
			cXml += '    <Cell ss:Index="23" ss:StyleID="s91"/>'+CENT
			cXml += '   </Row>'+CENT

			cXml += '   <Row ss:Height="15.75" ss:StyleID="s103">'+CENT
			cXml += '    <Cell ss:MergeAcross="6" ss:StyleID="s150"><Data ss:Type="String">TOTAIS ACUCAR XTL</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTD2_QTDTM ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTD2_QTDSC ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s111"/>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTCUS_REAL ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s110"/>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTCUS_PTAX ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s110"/>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTVLR_R ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s110"/>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTVLR_US ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTC_OUTRR ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTC_OUTRUS ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTC_ESESR ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTC_ESESUS ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTMGTOTR ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">'+Transform(nXTMGTOTU ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s110"/>'+CENT
			cXml += '   </Row>'+CENT
			cXml += '   <Row ss:Height="15.75">'+CENT
			cXml += '    <Cell ss:Index="2" ss:StyleID="s105"/>'+CENT
			cXml += '    <Cell ss:StyleID="s105"/>'+CENT
			cXml += '    <Cell ss:Index="17" ss:StyleID="s91"/>'+CENT
			cXml += '    <Cell ss:StyleID="s97"/>'+CENT
			cXml += '    <Cell ss:StyleID="s98"/>'+CENT
			cXml += '    <Cell ss:StyleID="s97"/>'+CENT
			cXml += '    <Cell ss:StyleID="s98"/>'+CENT
			cXml += '    <Cell ss:Index="23" ss:StyleID="s91"/>'+CENT
			cXml += '   </Row>'+CENT
		EndIf
		cXml += '  </Table>'+CENT
		cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
		cXml += '   <PageSetup>'+CENT
		cXml += '    <Layout x:Orientation="Landscape"/>'+CENT
		cXml += '    <Header x:Margin="0.31496062992125984"/>'+CENT
		cXml += '    <Footer x:Margin="0.31496062992125984"/>'+CENT
		cXml += '    <PageMargins x:Bottom="0.74803149606299213" x:Left="0.23622047244094491"'+CENT
		cXml += '     x:Right="0.23622047244094491" x:Top="0.74803149606299213"/>'+CENT
		cXml += '   </PageSetup>'+CENT
		cXml += '   <FitToPage/>'+CENT
		cXml += '   <Print>'+CENT
		cXml += '    <FitWidth>2</FitWidth>'+CENT
		cXml += '    <ValidPrinterInfo/>'+CENT
		cXml += '    <PaperSizeIndex>9</PaperSizeIndex>'+CENT
		cXml += '    <Scale>88</Scale>'+CENT
		cXml += '    <HorizontalResolution>600</HorizontalResolution>'+CENT
		cXml += '    <VerticalResolution>600</VerticalResolution>'+CENT
		cXml += '   </Print>'+CENT
		cXml += '   <Selected/>'+CENT
		cXml += '   <LeftColumnVisible>11</LeftColumnVisible>'+CENT
		cXml += '   <Panes>'+CENT
		cXml += '    <Pane>'+CENT
		cXml += '     <Number>3</Number>'+CENT
		cXml += '     <ActiveRow>5</ActiveRow>'+CENT
		cXml += '     <ActiveCol>20</ActiveCol>'+CENT
		cXml += '    </Pane>'+CENT
		cXml += '   </Panes>'+CENT
		cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
		cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
		cXml += '  </WorksheetOptions>'+CENT
		cXml += ' </Worksheet>'+CENT
		cXml += '</Workbook>'+CENT

		Exit
		
	End
	FWrite(nArq,cXml)
	FClose(nArq)
	shellExecute( "Open", cPath + cArq + ".xml", " /k dir", "C:\", 1 )
EndIf

Return

*----------------------------------------------------*
Static Function fSldMes(cMoeda,cConta,cProduto,cNavio)
*----------------------------------------------------*

Local nValor := 0 
Local cQuery := ""
Local cAlias := GetNextAlias() 
Local dDataI  := CtoD("01/"+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4))
Local dDataf  := LastDay(dDataI)

cQuery:=" SELECT XX2.CLVL, XX2.VLR"+CENT  	
cQuery+=" FROM"+CENT  	
cQuery+=" (SELECT"+CENT  	
cQuery+=" (CASE WHEN CT2_CLVLDB = '' THEN CT2_CLVLCR ELSE CT2_CLVLDB END) AS CLVL,"+CENT 
cQuery+=" Isnull((CASE WHEN CT2.CT2_CLVLDB = '"+cNavio+"' AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3') AND CT2.CT2_DEBITO = '"+cConta+"' AND CT2.CT2_MOEDLC = '"+cMoeda+"' THEN SUM(CT2_VALOR) ELSE 0 END),0) - "+CENT
cQuery+=" Isnull((CASE WHEN CT2.CT2_CLVLCR = '"+cNavio+"' AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3') AND CT2.CT2_CREDIT = '"+cConta+"' AND CT2.CT2_MOEDLC = '"+cMoeda+"' THEN SUM(CT2_VALOR) ELSE 0 END),0) AS VLR"+CENT 
cQuery+=" FROM 	" + RetSqlName("CT2") + " CT2"+CENT 
cQuery+=" WHERE CT2.D_E_L_E_T_ = ' '"+CENT 
cQuery+=" AND CT2.CT2_MOEDLC = '"+cMoeda+"'"+CENT  
cQuery+=" AND CT2.CT2_MANUAL = '1'"+CENT   
cQuery+=" AND CT2.CT2_CLVLDB = '"+cNavio+"' OR CT2.CT2_CLVLCR = '"+cNavio+"'"+CENT 
cQuery+=" AND CT2.CT2_DATA Between '" + DtoS(dDataI) + "' AND '"+ DtoS(dDataF) + "'"+CENT 
cQuery+=" AND EXISTS (SELECT CT2_HIST FROM "+ RetSqlName("CT2") + " CT WHERE CT2.CT2_LOTE = CT.CT2_LOTE"+CENT 
cQuery+=" AND (CT2.CT2_CLVLDB = CT.CT2_CLVLDB OR CT2.CT2_CLVLCR = CT.CT2_CLVLCR)"+CENT
cQuery+=" AND CT2.CT2_SBLOTE = CT.CT2_SBLOTE"+CENT 
cQuery+=" AND CT2.CT2_DOC    = CT.CT2_DOC"+CENT 
cQuery+=" AND CT2_HIST Like '%"+Alltrim(cProduto)+"%'"+CENT 
cQuery+=" AND CT.D_E_L_E_T_  = ' ')"+CENT 
cQuery+=" GROUP BY CT2_CLVLDB,CT2_CLVLCR,CT2_DC,CT2_CREDIT,CT2_DEBITO,CT2_MOEDLC)"+CENT 
cQuery+=" AS XX2"+CENT  	
cQuery+=" WHERE XX2.VLR <> 0"+CENT  	

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
Endif

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)

Dbselectarea(cAlias)

nValor := (cAlias)->VLR

(cAlias)->(DbCloseArea())

Return(nValor)

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                        4                       5                        6           7     8   9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24        25   26   27   28   29   30   31   32   33   34   35   36   37   38      39   40  41  42            43
AADD(aSx1,{"EDFR009" , "01" , "MÍs/Ano            ?" , "MÍs/Ano           ?" , "MÍs/Ano            ?" , "mv_ch1" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "@R 99/9999", ""})
AADD(aSx1,{"EDFR009" , "02" , "Navio              ?" , "Navio             ?" , "Navio              ?" , "mv_ch2" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CTH" , "" , "", "", ""          , ""})
//AADD(aSx1,{"EDFR009" , "03" , "Tipo               ?" , "Tipo              ?" , "Tipo               ?" , "mv_ch3" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par03" , "VHP" , ""    , ""    , "" , "" , "XTL" , ""    , ""    , "" , "" , "Ambos" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", ""          , ""}) // 29/06/16 - Luis Felipe
AADD(aSx1,{"EDFR009" , "03" , "Tipo               ?" , "Tipo              ?" , "Tipo               ?" , "mv_ch3" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par03" , "VHP" , ""    , ""    , "" , "" , "XTL" , ""    , ""    , "" , "" , "Refinado" , "" , "" , "" , "" , "Sacaria" , "" , "" , "" , "" , "Outros" , "" , "" , "" , ""    , "" , "", "", ""          , ""})
AADD(aSx1,{"EDFR009" , "04" , "Produto       	  ?" , "Produto    		  ?" , "Produto       	   ?" , "mv_ch4" , "C" , 25 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SB1" , "" , "", "", ""          , ""})
AADD(aSx1,{"EDFR009" , "05" , "Filial De          ?" , "Filial De         ?" , "Filial De          ?" , "mv_ch5" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "DLB" , "" , "", "", ""          , ""})
AADD(aSx1,{"EDFR009" , "06" , "Filial Ate         ?" , "Filial Ate        ?" , "Filial Ate         ?" , "mv_ch6" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par06" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "DLB" , "" , "", "", ""          , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR009   06")
	
	DbSeek("EDFR009")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR009"
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
