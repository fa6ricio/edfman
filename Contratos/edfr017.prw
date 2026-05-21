#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥ EDFR017     ≥ Autor ≥ Luis Felipe Mattos	≥ Data ≥ 01.09.15 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Relatorio de Controle de Embarques				 		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 		 ≥ Gera Excel - Contratos                               	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum													  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracoes≥        				  Luis Felipe Mattos 		23/05/16  ≥±±
±±≥          ≥ Criadas as colunas DATA DA SD, DATA DA DE e DATA AVERBACAO ≥±±
±±≥          ≥ AlteraÁıes de filtro e consulta SXB 					      ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracoes≥        				  Luis Felipe Mattos 		24/10/16  ≥±±
±±≥          ≥ CorreÁ„o no filtro da data da BL EEC_DTEMBA.               ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function EDFR017()

Local 	nOrdem
Local 	cQuery		:= ""
Private   cAliasQry   := GetNextAlias()

Private cString    	:= "SZD"
Private wnrel      	:= "EDFR017"
Private aOrd       	:= {"Contrato"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Relatorio de Controle de Embarques"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Relatorio de Controle de Embarques", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR017"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR017"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR017"
Private _nlin      	:= 70
Private Cabec1     	:= " "
Private Cabec2     	:= " "
Private nCountnx   := 0
Private nCountny   := 1

CriaSx1()

IF !Pergunte(cPerg,.T.)
	RETURN
ENDIF

If LastKey() == 27
	Return
Endif

cQuery := " SELECT DISTINCT Z3_CONTRA, CNC_NOME, Z3_PERIODO, Z3_DTINIC, Z3_DTFIM, Z3_SAFRA"+CENT
cQuery += " ,F1_XPEDIDO"+CENT
cQuery += " ,EYY_NFENT, EYY_SERENT"+CENT

//cQuery += " ,CASE  WHEN D2_UM = 'SC' THEN EYY_QUANT ELSE 0 END  AS SACAS"+CENT  // 24/06/16 - Luis Felipe
cQuery += " ,((CASE  WHEN D2_UM = 'SC' THEN EYY_QUANT ELSE 0 END)                    - (CASE WHEN (SELECT TOP 1 D1_QUANT FROM "+RetSqlName("SD1")+" WHERE D2_COD = D1_COD AND EYY_NFSAI = D1_NFORI AND EYY_SERSAI = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') <> 0 THEN (SELECT TOP 1 D1_QUANT FROM "+RetSqlName("SD1")+" WHERE  D2_COD = D1_COD AND EYY_NFSAI = D1_NFORI AND EYY_SERSAI = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') ELSE 0 END)) AS SACAS"+CENT

//cQuery += " ,CASE  WHEN D2_UM = 'SC' THEN EYY_QUANT * B1_CONV ELSE EYY_QUANT END  AS TONELADAS"+CENT // 24/06/16 - Luis Felipe
cQuery += " ,((CASE  WHEN D2_UM = 'SC' THEN EYY_QUANT * B1_CONV ELSE EYY_QUANT END)  - (CASE WHEN (SELECT TOP 1 D1_QTSEGUM FROM "+RetSqlName("SD1")+" WHERE  D2_COD = D1_COD AND EYY_NFSAI = D1_NFORI AND EYY_SERSAI = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') <> 0 THEN (SELECT TOP 1 D1_QTSEGUM FROM "+RetSqlName("SD1")+" WHERE  D2_COD = D1_COD AND EYY_NFSAI = D1_NFORI AND EYY_SERSAI = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') ELSE 0 END)) AS TONELADAS "+CENT

//cQuery += " ,EYY_QUANT AS TONELADAS"+CENT // D2_QTSEGUM
cQuery += " ,D2_PEDIDO"+CENT
cQuery += " ,D2_ITEM"+CENT
cQuery += " ,A1_NREDUZ"+CENT
cQuery += " ,EE9_PREEMB"+CENT
cQuery += " ,CASE WHEN (SELECT TOP 1 CTH_VESSEL FROM "+RetSqlName("CTH")+" CTH WHERE CTH_CLVL = EYY_PREEMB AND D_E_L_E_T_ = '') <> '' THEN (SELECT TOP 1 CTH_VESSEL FROM "+RetSqlName("CTH")+" CTH WHERE CTH_CLVL = EYY_PREEMB AND D_E_L_E_T_ = '') ELSE (SELECT TOP 1 CTH_VESSEL FROM "+RetSqlName("CTH")+" CTH WHERE SUBSTRING(EYY_PREEMB,1,LEN(RTRIM(EYY_PREEMB))-1) = RTRIM(CTH_CLVL) AND D_E_L_E_T_ = '') END AS CTH_VESSEL"+CENT
cQuery += " ,CASE WHEN (SELECT TOP 1 CTH_BOOKIN FROM "+RetSqlName("CTH")+" CTH WHERE CTH_CLVL = EYY_PREEMB AND D_E_L_E_T_ = '') <> '' THEN (SELECT TOP 1 CTH_BOOKIN FROM "+RetSqlName("CTH")+" CTH WHERE CTH_CLVL = EYY_PREEMB AND D_E_L_E_T_ = '') ELSE (SELECT TOP 1 CTH_BOOKIN FROM "+RetSqlName("CTH")+" CTH WHERE SUBSTRING(EYY_PREEMB,1,LEN(RTRIM(EYY_PREEMB))-1) = RTRIM(CTH_CLVL) AND D_E_L_E_T_ = '') END AS CTH_BOOKIN"+CENT
cQuery += " ,(SELECT TOP 1 CASE WHEN EEC_ETA = '' THEN '' ELSE EEC_ETA END EEC_ETA FROM "+RetSqlName("EEC")+" WHERE EEC_PREEMB = D2_PREEMB AND D_E_L_E_T_ = '') AS EEC_ETA"+CENT
cQuery += " ,EYY_RE"+CENT
cQuery += " ,EE9_NRSD"+CENT
cQuery += " ,(SELECT TOP 1 EEC_NRCONH FROM "+RetSqlName("EEC")+" WHERE EEC_PREEMB = D2_PREEMB  AND D_E_L_E_T_ = '') AS EEC_NRCONH"+CENT
cQuery += " ,(SELECT TOP 1 CASE WHEN EEC_DTEMBA = '' THEN '' ELSE EEC_DTEMBA END EEC_DTEMBA FROM "+RetSqlName("EEC")+" WHERE EEC_PREEMB = D2_PREEMB AND D_E_L_E_T_ = '') AS EEC_DTEMBA"+CENT
cQuery += " ,(SELECT TOP 1 Z6_VLFINAL FROM "+RetSqlName("SZ6")+" WHERE Z3_CONTRA = Z6_CONTRA AND Z3_PERIODO = Z6_PERDE AND Z6_TIPOPRE = '2' AND D_E_L_E_T_ = '') AS Z6_VLFINAL"+CENT
cQuery += " ,(SELECT TOP 1 C7_TAXAUSD FROM "+RetSqlName("SC7")+" WHERE F1_XPEDIDO = C7_NUM AND D_E_L_E_T_ = '') AS C7_TAXAUSD"+CENT
cQuery += " ,(EYY_QUANT * EE9_PRECOI) D2_TOTAL"+CENT
cQuery += " ,EYY_NFSAI, EYY_SERSAI"+CENT
cQuery += " ,EE8_LOCAL, ZE_NOME"+CENT
cQuery += " ,Z3_PORTO, Y9_DESCR"+CENT
cQuery += " ,(CASE WHEN BM_DESC LIKE '%VHP%' THEN 'VHP' ELSE (CASE WHEN BM_DESC LIKE '%XTL%' THEN 'XTL' ELSE 'REF' END) END) TIPO "+CENT
cQuery += " ,'AGENTE' AS AGENTE"+CENT
cQuery += " ,'SUPERV' AS SUPERV"+CENT
cQuery += " ,EE8_XPOLDP"+CENT
cQuery += " ,EYY_FORN, EYY_FOLOJA"+CENT 
cQuery += " ,(SELECT TOP 1 EEC_NRINVO FROM "+RetSqlName("EEC")+" WHERE EEC_PREEMB = D2_PREEMB AND D_E_L_E_T_ = '') AS EEC_NRINVO"+CENT
// 23/05/16 - Luis Felipe - Inicio
cQuery += " ,EE9_DTRE"+CENT
cQuery += " ,EE9_DTDDE"+CENT
cQuery += " ,EE9_DTAVRB"+CENT
cQuery += " ,(SELECT TOP 1 D1_DOC FROM "+RetSqlName("SD1")+" WHERE  D2_COD = D1_COD AND EYY_NFSAI = D1_NFORI AND EYY_SERSAI = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS NFDEV"+CENT // 24/06/16 - Luis Felipe
cQuery += " ,(SELECT TOP 1 D1_QUANT * EE9_PRECOI FROM "+RetSqlName("SD1")+" WHERE  D2_COD = D1_COD AND EYY_NFSAI = D1_NFORI AND EYY_SERSAI = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS NFDEVVL"+CENT // 24/06/16 - Luis Felipe
// 23/05/16 - Luis Felipe - Fim
// 25/07/16 - Luis Felipe - Inicio
// 24/10/16 - Luis Felipe - Inicio
//cQuery += " ,(SELECT EEC_XINVCP FROM "+RetSqlName("EEC")+" WHERE EEC_XINVCP <> '' AND EEC_PREEMB = EE9_PREEMB AND EEC_PEDREF = EE9_PEDIDO AND EE9_NF = D2_DOC AND D_E_L_E_T_ = '') AS EEC_XINVCP"+CENT
//cQuery += " ,(SELECT EEC_XVLNF  FROM "+RetSqlName("EEC")+" WHERE EEC_XINVCP <> '' AND EEC_PREEMB = EE9_PREEMB AND EEC_PEDREF = EE9_PEDIDO AND EE9_NF = D2_DOC AND D_E_L_E_T_ = '') AS EEC_XVLNF"+CENT
//cQuery += " ,(SELECT EEC_PEDEMB FROM "+RetSqlName("EEC")+" WHERE EEC_XINVCP <> '' AND EEC_PREEMB = EE9_PREEMB AND EEC_PEDREF = EE9_PEDIDO AND EE9_NF = D2_DOC AND D_E_L_E_T_ = '') AS EEC_PEDEMB"+CENT

cQuery += " ,EEC_XINVCP,EEC_XVLNF,EEC_PEDEMB"+CENT
// 24/10/16 - Luis Felipe - Fim
// 25/07/16 - Luis Felipe - Fim
cQuery += " FROM "+RetSqlName("EYY")+" EYY, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF1")+" SF1, "+RetSqlName("SZ3")+" SZ3, "+RetSqlName("CN9")+" CN9 ,"+RetSqlName("SB1")+" SB1, "+RetSqlName("SBM")+" SBM, "+RetSqlName("SY9")+" SY9, "+RetSqlName("SZE")+" SZE, "+RetSqlName("SA1")+" SA1, "+RetSqlName("EE9")+" EE9, "+RetSqlName("EE8")+" EE8, "+RetSqlName("CNC")+" CNC ,"+RetSqlName("EEC")+" EEC"+CENT
cQuery += " WHERE EYY_NFSAI = D2_DOC"+CENT
cQuery += " AND EYY_PEDIDO = D2_PEDIDO"+CENT
cQuery += " AND EYY_NFENT = F1_DOC"+CENT
cQuery += " AND EYY_SERENT = F1_SERIE"+CENT
cQuery += " AND EYY_FORN = F1_FORNECE"+CENT
cQuery += " AND EYY_FOLOJA = F1_LOJA"+CENT
cQuery += " AND D2_COD = Z3_CTRDP"+CENT
cQuery += " AND CN9_NUMERO = Z3_CONTRA"+CENT
cQuery += " AND D2_COD = B1_COD"+CENT
cQuery += " AND B1_GRUPO = BM_GRUPO"+CENT
cQuery += " AND Z3_PORTO = Y9_COD"+CENT
cQuery += " AND EE8_LOCAL = ZE_LOCAL"+CENT
cQuery += " AND D2_CLIENTE = A1_COD"+CENT
cQuery += " AND D2_LOJA = A1_LOJA"+CENT
cQuery += " AND EYY_PREEMB = EE9_PREEMB"+CENT
cQuery += " AND EE9_PEDIDO = D2_PEDIDO"+CENT
cQuery += " AND EE9_COD_I = EE8_COD_I"+CENT
cQuery += " AND EE8_PEDIDO = D2_PEDIDO"+CENT
cQuery += " AND CN9_NUMERO = CNC_NUMERO"+CENT 
cQuery += " AND EYY_FORN = CNC_CODIGO"+CENT
cQuery += " AND EYY_FOLOJA = CNC_LOJA"+CENT
// 24/10/16 - Luis Felipe - Inicio
cQuery += " AND EEC_PREEMB = D2_PREEMB"+CENT
cQuery += " AND EEC_PEDREF = D2_PEDIDO"+CENT
// 24/10/16 - Luis Felipe - Fim
cQuery += " AND SUBSTRING(Z3_CONTRA,1,1) = 'P'"+CENT

// Filtros
If !Empty(MV_PAR01)
	cQuery += "	AND Rtrim(EE8_LOCAL) = '"+SubStr(MV_PAR01,1,2)+"'"+CENT
EndIf

If !Empty(MV_PAR02)
	cQuery += "	AND Y9_COD = '"+MV_PAR02+"'"+CENT
EndIf

If MV_PAR03 = 1
	cQuery += " AND BM_DESC LIKE '%VHP%' "+CENT
ElseIf MV_PAR03 = 2
	cQuery += " AND BM_DESC LIKE '%XTL%' "+CENT
ElseIf MV_PAR03 = 3
	cQuery += " AND BM_DESC LIKE '%REF%' "+CENT
EndIf

If !Empty(MV_PAR04)
	cQuery += "	AND Z3_SAFRA = '"+SubStr(MV_PAR04,1,2)+"/"+SubStr(MV_PAR04,3,2)+"'"+CENT
EndIf

If !Empty(MV_PAR05)
	cQuery += "	AND RTRIM(CNC_NOME) = '"+Alltrim(MV_PAR05)+"'"+CENT
EndIf

If !Empty(MV_PAR06)
	cQuery += "	AND D2_PEDIDO = '"+MV_PAR06+"'"+CENT
EndIf

If !Empty(MV_PAR08)
	If !Empty(MV_PAR09)
		cQuery += "	AND Z3_CTRDP = '"+Alltrim(MV_PAR08)+"-"+Alltrim(MV_PAR09)+"'"+CENT
	Else
		cQuery += "	AND Z3_CONTRA = '"+MV_PAR08+"'"+CENT
	EndIf
EndIf

dMV_PAR11 := If(Empty(MV_PAR11),Ddatabase,MV_PAR11)
If	!Empty(MV_PAR10) 
	If	!Empty(MV_PAR11)  
		cQuery += " AND EEC_DTEMBA BETWEEN '"+DtoS(MV_PAR10)+"' AND '"+DtoS(dMV_PAR11)+"'"+CENT
	Else
		cQuery += " AND EEC_DTEMBA >= '"+DtoS(MV_PAR10)+"'"+CENT
	EndIf
Else
	If	!Empty(MV_PAR11)  
		cQuery += " AND EEC_DTEMBA <= '"+DtoS(MV_PAR11)+"'"+CENT
	EndIf
EndIf

cQuery += " AND EYY.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SD2.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SF1.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SZ3.D_E_L_E_T_ = ''"+CENT
cQuery += " AND CN9.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SB1.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SBM.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SY9.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SZE.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SA1.D_E_L_E_T_ = ''"+CENT
cQuery += " AND EE9.D_E_L_E_T_ = ''"+CENT
cQuery += " AND EE8.D_E_L_E_T_ = ''"+CENT
cQuery += " AND CNC.D_E_L_E_T_ = ''"+CENT
cQuery += " AND EEC.D_E_L_E_T_ = ''"+CENT

cQuery += "UNION ALL"+CENT

// Notas de Saida sem registro de embarque

cQuery += " SELECT DISTINCT Z3_CONTRA, CNC_NOME, Z3_PERIODO, Z3_DTINIC, Z3_DTFIM, Z3_SAFRA"+CENT
cQuery += " ,'' AS F1_XPEDIDO"+CENT
cQuery += " ,'' AS EYY_NFENT"+CENT
cQuery += " ,'' AS EYY_SERENT"+CENT
//cQuery += " ,CASE  WHEN D2_UM = 'SC' THEN D2_QUANT ELSE 0 END  AS SACAS"+CENT // 24/06/16 - Luis Felipe
//cQuery += " ,CASE  WHEN D2_UM = 'SC' THEN D2_QUANT * B1_CONV ELSE D2_QUANT END  AS TONELADAS"+CENT // 24/06/16 - Luis Felipe
cQuery += " ,((CASE  WHEN D2_UM = 'SC' THEN D2_QUANT ELSE 0 END)                   - (CASE WHEN (SELECT TOP 1 D1_QUANT   FROM "+RetSqlName("SD1")+" WHERE  D2_COD = D1_COD AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') <> 0 THEN (SELECT TOP 1 D1_QUANT   FROM "+RetSqlName("SD1")+" WHERE D2_COD = D1_COD AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') ELSE 0 END)) AS SACAS"+CENT
cQuery += " ,((CASE  WHEN D2_UM = 'SC' THEN D2_QUANT * B1_CONV ELSE D2_QUANT END)  - (CASE WHEN (SELECT TOP 1 D1_QTSEGUM FROM "+RetSqlName("SD1")+" WHERE  D2_COD = D1_COD AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') <> 0 THEN (SELECT TOP 1 D1_QTSEGUM FROM "+RetSqlName("SD1")+" WHERE D2_COD = D1_COD AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') ELSE 0 END)) AS TONELADAS "+CENT
//cQuery += " ,D2_QTSEGUM AS TONELADAS"+CENT
cQuery += " ,D2_PEDIDO"+CENT
cQuery += " ,D2_ITEM"+CENT
cQuery += " ,A1_NREDUZ"+CENT
cQuery += " ,EE9_PREEMB"+CENT
cQuery += " ,CASE WHEN (SELECT TOP 1 CTH_VESSEL FROM "+RetSqlName("CTH")+" CTH WHERE CTH_CLVL = D2_PREEMB AND D_E_L_E_T_ = '') <> '' THEN (SELECT TOP 1 CTH_VESSEL FROM "+RetSqlName("CTH")+" CTH WHERE CTH_CLVL = D2_PREEMB AND D_E_L_E_T_ = '') ELSE (SELECT TOP 1 CTH_VESSEL FROM "+RetSqlName("CTH")+" CTH WHERE SUBSTRING(D2_PREEMB,1,LEN(RTRIM(D2_PREEMB))-1) = RTRIM(CTH_CLVL) AND D_E_L_E_T_ = '') END AS CTH_VESSEL"+CENT
cQuery += " ,CASE WHEN (SELECT TOP 1 CTH_BOOKIN FROM "+RetSqlName("CTH")+" CTH WHERE CTH_CLVL = D2_PREEMB AND D_E_L_E_T_ = '') <> '' THEN (SELECT TOP 1 CTH_BOOKIN FROM "+RetSqlName("CTH")+" CTH WHERE CTH_CLVL = D2_PREEMB AND D_E_L_E_T_ = '') ELSE (SELECT TOP 1 CTH_BOOKIN FROM "+RetSqlName("CTH")+" CTH WHERE SUBSTRING(D2_PREEMB,1,LEN(RTRIM(D2_PREEMB))-1) = RTRIM(CTH_CLVL) AND D_E_L_E_T_ = '') END AS CTH_BOOKIN"+CENT
cQuery += " ,'' AS EEC_ETA"+CENT
cQuery += " ,EE9_RE AS EYY_RE"+CENT
cQuery += " ,EE9_NRSD"+CENT
cQuery += " ,'' AS EEC_NRCONH"+CENT
cQuery += " ,'' AS EEC_DTEMBA"+CENT
cQuery += " ,(SELECT TOP 1 Z6_VLFINAL FROM "+RetSqlName("SZ6")+" SZ6 WHERE Z3_CONTRA = Z6_CONTRA AND Z3_PERIODO = Z6_PERDE AND Z6_TIPOPRE = '2' AND D_E_L_E_T_ = '') AS Z6_VLFINAL"+CENT
cQuery += " ,'' AS C7_TAXAUSD"+CENT
cQuery += " ,(D2_QUANT * EE9_PRECOI) D2_TOTAL"+CENT
cQuery += " ,D2_DOC AS EYY_NFSAI"+CENT
cQuery += " ,D2_SERIE AS EYY_SERSAI"+CENT
cQuery += " ,EE8_LOCAL, ZE_NOME"+CENT
cQuery += " ,Z3_PORTO, Y9_DESCR"+CENT
cQuery += " ,(CASE WHEN BM_DESC LIKE '%VHP%' THEN 'VHP' ELSE (CASE WHEN BM_DESC LIKE '%XTL%' THEN 'XTL' ELSE 'REF' END) END) TIPO"+CENT
cQuery += " ,'*' AS AGENTE"+CENT
cQuery += " ,'*' AS SUPERV"+CENT
cQuery += " ,EE8_XPOLDP"+CENT
cQuery += " ,'' AS EYY_FORN"+CENT
cQuery += " ,'' AS EYY_FOLOJA"+CENT
cQuery += " ,EEC_NRINVO"+CENT
// 23/05/16 - Luis Felipe - Inicio
cQuery += " ,EE9_DTRE"+CENT
cQuery += " ,EE9_DTDDE"+CENT
cQuery += " ,EE9_DTAVRB"+CENT
//cQuery += " ,'' AS NFDEV"+CENT // 24/06/16 - Luis Felipe
//cQuery += " ,'' AS NFDEVVL"+CENT  // 24/06/16 - Luis Felipe
cQuery += " ,(SELECT TOP 1 D1_DOC FROM "+RetSqlName("SD1")+" WHERE  D2_COD = D1_COD AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS NFDEV"+CENT // 24/06/16 - Luis Felipe
cQuery += " ,(SELECT TOP 1 D1_QUANT * EE9_PRECOI FROM "+RetSqlName("SD1")+" WHERE  D2_COD = D1_COD AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D1_TIPO = 'D'  AND  D_E_L_E_T_ = '') AS NFDEVVL"+CENT // 24/06/16 - Luis Felipe
// 23/05/16 - Luis Felipe - Fim
// 25/07/16 - Luis Felipe - Inicio
cQuery += " , '' EEC_XINVCP"+CENT
cQuery += " , '' EEC_XVLNF"+CENT
cQuery += " , '' EEC_PEDEMB"+CENT
// 25/07/16 - Luis Felipe - Fim
cQuery += " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SZ3")+" SZ3, "+RetSqlName("CN9")+" CN9 ,"+RetSqlName("SB1")+" SB1, "+RetSqlName("SBM")+" SBM, "+RetSqlName("SY9")+" SY9, "+RetSqlName("SZE")+" SZE, "+RetSqlName("SA1")+" SA1, "+RetSqlName("EE9")+" EE9, "+RetSqlName("EE8")+" EE8, "+RetSqlName("EEC")+" EEC, "+RetSqlName("CNC")+" CNC "+CENT
cQuery += " WHERE D2_COD = Z3_CTRDP"+CENT
cQuery += " AND CN9_NUMERO = Z3_CONTRA"+CENT
cQuery += " AND D2_COD = B1_COD"+CENT
cQuery += " AND B1_GRUPO = BM_GRUPO"+CENT
cQuery += " AND Z3_PORTO = Y9_COD"+CENT
cQuery += " AND EE8_LOCAL = ZE_LOCAL"+CENT
cQuery += " AND D2_CLIENTE = A1_COD"+CENT
cQuery += " AND D2_LOJA = A1_LOJA"+CENT
cQuery += " AND D2_PREEMB = EE9_PREEMB"+CENT
cQuery += " AND EE9_PEDIDO = D2_PEDIDO"+CENT
cQuery += " AND EE9_COD_I = EE8_COD_I"+CENT
cQuery += " AND EE8_PEDIDO = D2_PEDIDO"+CENT
cQuery += " AND EEC_PREEMB = D2_PREEMB"+CENT
cQuery += " AND EEC_PEDREF = D2_PEDIDO"+CENT
cQuery += " AND CN9_NUMERO = CNC_NUMERO"+CENT 
cQuery += " AND EE8_FABR = CNC_CODIGO"+CENT
cQuery += " AND EE8_FALOJA = CNC_LOJA"+CENT
cQuery += " AND SUBSTRING(D2_CF,2,3) = '501'"+CENT
cQuery += " AND SUBSTRING(Z3_CONTRA,1,1) = 'P'"+CENT

// Filtros
If !Empty(MV_PAR01)
	cQuery += "	AND Rtrim(EE8_LOCAL) = '"+SubStr(MV_PAR01,1,2)+"'"+CENT
EndIf

If !Empty(MV_PAR02)
	cQuery += "	AND Y9_COD = '"+MV_PAR02+"'"+CENT
EndIf

If MV_PAR03 = 1
	cQuery += " AND BM_DESC LIKE '%VHP%' "+CENT
ElseIf MV_PAR03 = 2
	cQuery += " AND BM_DESC LIKE '%XTL%' "+CENT
ElseIf MV_PAR03 = 3
	cQuery += " AND BM_DESC LIKE '%REF%' "+CENT
EndIf

If !Empty(MV_PAR04)
	cQuery += "	AND Z3_SAFRA = '"+SubStr(MV_PAR04,1,2)+"/"+SubStr(MV_PAR04,3,2)+"'"+CENT
EndIf

If !Empty(MV_PAR05)
	cQuery += "	AND RTRIM(CNC_NOME) = '"+Alltrim(MV_PAR05)+"'"+CENT
EndIf

If !Empty(MV_PAR06)
	cQuery += "	AND D2_PEDIDO = '"+MV_PAR06+"'"+CENT
EndIf

If !Empty(MV_PAR08)
	If !Empty(MV_PAR09)
		cQuery += "	AND Z3_CTRDP = '"+Alltrim(MV_PAR08)+"-"+Alltrim(MV_PAR09)+"'"+CENT
	Else
		cQuery += "	AND Z3_CONTRA = '"+MV_PAR08+"'"+CENT
	EndIf
EndIf

cQuery += " AND SD2.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SZ3.D_E_L_E_T_ = ''"+CENT
cQuery += " AND CN9.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SB1.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SBM.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SY9.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SZE.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SA1.D_E_L_E_T_ = ''"+CENT
cQuery += " AND EE9.D_E_L_E_T_ = ''"+CENT
cQuery += " AND EE8.D_E_L_E_T_ = ''"+CENT
cQuery += " AND EEC.D_E_L_E_T_ = ''"+CENT
cQuery += " AND CNC.D_E_L_E_T_ = ''"+CENT
cQuery += " AND NOT EXISTS (SELECT EYY_PEDIDO FROM "+RetSqlName("EYY")+" EYY WHERE EYY_PEDIDO = D2_PEDIDO AND D_E_L_E_T_ = '')"+CENT
cQuery += " ORDER BY EYY_NFSAI, D2_PEDIDO, D2_ITEM"+CENT

MemoWrite("C:\Tmp\EDFR017.txt",cQuery)
cQuery := ChangeQuery(cQuery)

If Select(cAliasQry) > 0
	dbSelectArea(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

Processa ( { ||  GeraPlan()  } )

If Select(cAliasQry) > 0
	dbselectarea(cAliasQry)
	(cAliasQry)->(dbCloseArea())
Endif

Return

**************************
Static Function GeraPlan()
**************************

Local oExcel
Local cArq
Local nArq
Local cPath
Local cXml := ""
Local nSACAS := 0
Local nZD_QTDNFRE := 0
Local nPESOLIQ := 0
Local nFALTA := 0
Local nAVARIA := 0
Local nSOBRA := 0

Local cCONTRA:='' 
Local cNOME:=''
Local cPeriodo:='' 
Local cNFSAI:='' 
Local cNREDUZ:='' 
Local cXINVCP:='' 
Local nXVLNF:=0 
Local cPedido:='' 
Local cNRINVO:=''

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

If (cAliasQry)->(!EOF())
	
	CTH->(DbSetOrder(1))
	CTH->(DbSeek(xFilial("CTH")+MV_PAR07))
	
	nLin := 150
	While !(cAliasQry)->(EOf())
		If !Empty(MV_PAR07) .and. (cAliasQry)->CTH_VESSEL <> CTH->CTH_VESSEL
			(cAliasQry)->(DbSkip())
			Loop
		EndIf
		nLin ++
		(cAliasQry)->(DbSkip())
	End
	
	ProcRegua(nLin-150)
	
	(cAliasQry)->(DbGotop())
	
  	FWrite(nArq,'<?xml version="1.0"?>'+CENT)
  	FWrite(nArq,'<?mso-application progid="Excel.Sheet"?>'+CENT)
  	FWrite(nArq,'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT)
  	FWrite(nArq,' xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT)
  	FWrite(nArq,' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT)
  	FWrite(nArq,' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT)
  	FWrite(nArq,' xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT)
  	FWrite(nArq,' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT)
  	FWrite(nArq,'  <Author>luis.nascimento</Author>'+CENT)
  	FWrite(nArq,'  <LastAuthor>Luis Filipe Nascimento</LastAuthor>'+CENT)
  	FWrite(nArq,'  <Created>2014-08-06T19:56:04Z</Created>'+CENT)
  	FWrite(nArq,'  <LastSaved>2016-03-16T20:33:14Z</LastSaved>'+CENT)
  	FWrite(nArq,'  <Company>Microsoft</Company>'+CENT)
  	FWrite(nArq,'  <Version>15.00</Version>'+CENT)
  	FWrite(nArq,' </DocumentProperties>'+CENT)
  	FWrite(nArq,' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CENT)
  	FWrite(nArq,'  <AllowPNG/>'+CENT)
  	FWrite(nArq,' </OfficeDocumentSettings>'+CENT)
  	FWrite(nArq,' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CENT)
  	FWrite(nArq,'  <WindowHeight>7155</WindowHeight>'+CENT)
  	FWrite(nArq,'  <WindowWidth>20490</WindowWidth>'+CENT)
  	FWrite(nArq,'  <WindowTopX>0</WindowTopX>'+CENT)
  	FWrite(nArq,'  <WindowTopY>0</WindowTopY>'+CENT)
  	FWrite(nArq,'  <ActiveSheet>1</ActiveSheet>'+CENT)
  	FWrite(nArq,'  <ProtectStructure>False</ProtectStructure>'+CENT)
  	FWrite(nArq,'  <ProtectWindows>False</ProtectWindows>'+CENT)
  	FWrite(nArq,' </ExcelWorkbook>'+CENT)
  	FWrite(nArq,' <Styles>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="Default" ss:Name="Normal">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders/>'+CENT)
  	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT)
  	FWrite(nArq,'   <Interior/>'+CENT)
  	FWrite(nArq,'   <NumberFormat/>'+CENT)
  	FWrite(nArq,'   <Protection/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s62" ss:Name="V&#56487;ula">'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="m829279992400">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="18" ss:Color="#000000"'+CENT)
  	FWrite(nArq,'    ss:Bold="1"/>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#D8E4BC" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="m829279992420">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#D8E4BC" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="Short Date"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s63">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Bold="1"/>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#EBF1DE" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s64">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#EBF1DE" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s73">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s89">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT)
  	FWrite(nArq,'   <Borders/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s90">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#EBF1DE" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s91">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s92">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="@"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s93">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="Short Date"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s97">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="Short Date"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s99">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="#,##0.0000"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s100">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s102">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders/>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s106">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s107">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s108">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s109">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s110">'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s111">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="Short Date"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s112">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s113">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="Short Date"/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s114">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="#,##0_ ;[Red]\-#,##0\ "/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s115" ss:Parent="s62">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="#,##0.000_ ;\-#,##0.000\ "/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,'  <Style ss:ID="s117" ss:Parent="s62">'+CENT)
  	FWrite(nArq,'   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'   <Borders>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   </Borders>'+CENT)
  	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT)
  	FWrite(nArq,'   <NumberFormat ss:Format="#,##0.00_ ;\-#,##0.00\ "/>'+CENT)
  	FWrite(nArq,'  </Style>'+CENT)
  	FWrite(nArq,' </Styles>'+CENT)
  	FWrite(nArq,' <Worksheet ss:Name="Parametros">'+CENT)
  	FWrite(nArq,'  <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="12" x:FullColumns="1"'+CENT)
  	FWrite(nArq,'   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT)
  	FWrite(nArq,'   <Column ss:AutoFitWidth="0" ss:Width="187.5"/>'+CENT)
  	FWrite(nArq,'   <Column ss:AutoFitWidth="0" ss:Width="179.25"/>'+CENT)
  	FWrite(nArq,'   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s63"><Data ss:Type="String">FILTROS PARA ACESSO</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s64"/>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

	SZE->(DbSetOrder(1))
	SZE->(DbSeek(xFilial("SZE")+SubStr(MV_PAR01,1,2)))
  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s106"><Data ss:Type="String">Terminal</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s107"><Data ss:Type="String">'+Alltrim(SZE->ZE_NOME)+'</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

	SY9->(DbSetOrder(1))
	SY9->(DbSeek(xFilial("SY9")+MV_PAR02))
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s108"><Data ss:Type="String">Pais de Destino</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s109"><Data ss:Type="String">'+Alltrim(SY9->Y9_DESCR)+'</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

	If MV_PAR03 == 1
		cTipo := "VHP"
	ElseIf MV_PAR03 == 2
		cTipo := "XTL"
	ElseIf MV_PAR03 = 3
		cTipo := "REFINADO"
	Else
		cTipo := "Todos"
	EndIf

  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s110"><Data ss:Type="String">Tipo Produto (Granel ou ensacado)</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s109"><Data ss:Type="String">'+cTipo+'</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s108"><Data ss:Type="String">Safra 15/16</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s109"><Data ss:Type="String">'+SubStr(MV_PAR04,1,2)+"/"+SubStr(MV_PAR04,3,2)+'</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s108"><Data ss:Type="String">Fornecedor</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s109"><Data ss:Type="String">'+MV_PAR05+'</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s108"><Data ss:Type="String">Pedido de Venda</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s109"><Data ss:Type="String">'+MV_PAR06+'</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s108"><Data ss:Type="String">Navio</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s109"><Data ss:Type="String">'+MV_PAR07+'</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s108"><Data ss:Type="String">Contrato</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s109"><Data ss:Type="String">'+MV_PAR08+'</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s108"><Data ss:Type="String">DP</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s109"><Data ss:Type="String">'+MV_PAR09+'</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

	cMVPAR10 	:= If(!Empty(MV_PAR10),SubStr(DtoS(MV_PAR10),1,4)+"-"+SubStr(DtoS(MV_PAR10),5,2)+"-"+SubStr(DtoS(MV_PAR10),7,2)+"T00:00:00.000","")

  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s108"><Data ss:Type="String">Embarcado De</Data></Cell>'+CENT)
	If !Empty(MV_PAR10)
 	 	FWrite(nArq,'    <Cell ss:StyleID="s111"><Data ss:Type="DateTime">'+cMVPAR10+'</Data></Cell>'+CENT)
	Else
 	 	FWrite(nArq,'    <Cell ss:StyleID="s111"><Data ss:Type="String"></Data></Cell>'+CENT)
	EndIf
  	FWrite(nArq,'   </Row>'+CENT)

	cMVPAR11	:= If(!Empty(MV_PAR11),SubStr(DtoS(MV_PAR11),1,4)+"-"+SubStr(DtoS(MV_PAR11),5,2)+"-"+SubStr(DtoS(MV_PAR11),7,2)+"T00:00:00.000","")

  	FWrite(nArq,'   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s112"><Data ss:Type="String">Embarcado Ate</Data></Cell>'+CENT)
	If !Empty(MV_PAR11)
	  	FWrite(nArq,'    <Cell ss:StyleID="s113"><Data ss:Type="DateTime">'+cMVPAR11+'</Data></Cell>'+CENT)
	Else
	  	FWrite(nArq,'    <Cell ss:StyleID="s113"><Data ss:Type="String"></Data></Cell>'+CENT)
	EndIf
  	FWrite(nArq,'   </Row>'+CENT)


  	FWrite(nArq,'  </Table>'+CENT)
  	FWrite(nArq,'  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT)
  	FWrite(nArq,'   <PageSetup>'+CENT)
  	FWrite(nArq,'    <Header x:Margin="0.31496062000000002"/>'+CENT)
  	FWrite(nArq,'    <Footer x:Margin="0.31496062000000002"/>'+CENT)
  	FWrite(nArq,'    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT)
  	FWrite(nArq,'     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT)
  	FWrite(nArq,'   </PageSetup>'+CENT)
  	FWrite(nArq,'   <Unsynced/>'+CENT)
  	FWrite(nArq,'   <Panes>'+CENT)
  	FWrite(nArq,'    <Pane>'+CENT)
  	FWrite(nArq,'     <Number>3</Number>'+CENT)
  	FWrite(nArq,'     <ActiveRow>6</ActiveRow>'+CENT)
  	FWrite(nArq,'     <ActiveCol>1</ActiveCol>'+CENT)
  	FWrite(nArq,'    </Pane>'+CENT)
  	FWrite(nArq,'   </Panes>'+CENT)
  	FWrite(nArq,'   <ProtectObjects>False</ProtectObjects>'+CENT)
  	FWrite(nArq,'   <ProtectScenarios>False</ProtectScenarios>'+CENT)
  	FWrite(nArq,'  </WorksheetOptions>'+CENT)
  	FWrite(nArq,' </Worksheet>'+CENT)
  	FWrite(nArq,' <Worksheet ss:Name="Relatorio">'+CENT)
  	FWrite(nArq,'  <Table ss:ExpandedColumnCount="30" ss:ExpandedRowCount="'+Alltrim(Str(nLin))+'" x:FullColumns="1"'+CENT)
  	FWrite(nArq,'   x:FullRows="1" ss:StyleID="s73" ss:DefaultRowHeight="15">'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="79.5"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="151.5"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="52.5"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="63" ss:Span="1"/>'+CENT)
  	FWrite(nArq,'   <Column ss:Index="6" ss:StyleID="s73" ss:Width="54.75"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="81"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="66.75"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="82.5"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="51.75"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="125.25"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="93.75"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="150.75"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="110.25"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="97.5"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="65.25"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="88.5"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="66"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="117.75"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="64.5"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="63.75"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="75"/>'+CENT)
  	FWrite(nArq,'   <Column ss:Index="24" ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="81.75"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="74.25"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="83.25"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="170.25"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="131.25"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:Width="27"/>'+CENT)
  	FWrite(nArq,'   <Column ss:StyleID="s73" ss:AutoFitWidth="0" ss:Width="60.75"/>'+CENT)
  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:MergeAcross="28" ss:MergeDown="2" ss:StyleID="m829279992400"><Data'+CENT)
  	FWrite(nArq,'      ss:Type="String">Relatorio de Controle de Embarques - PV</Data></Cell>'+CENT)
	cDATABASE	:= SubStr(DtoS(Ddatabase),1,4)+"-"+SubStr(DtoS(Ddatabase),5,2)+"-"+SubStr(DtoS(Ddatabase),7,2)+"T00:00:00.000"
  	FWrite(nArq,'    <Cell ss:MergeDown="2" ss:StyleID="m829279992420"><Data ss:Type="DateTime">'+cDATABASE+'</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)

  	FWrite(nArq,'   <Row ss:AutoFitHeight="0" ss:Height="16.5"/>'+CENT)
  	FWrite(nArq,'   <Row ss:AutoFitHeight="0" ss:Height="0.75"/>'+CENT)
  	FWrite(nArq,'   <Row ss:AutoFitHeight="0" ss:Height="30" ss:StyleID="s89">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Contrato </Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Fornecedor</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">DP</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Dt.Inicio</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Dt.Fim</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Pedido de Compra</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">NF Mae do Ped. de Compra </Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Sacas</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Tons  (3 casas decimais)</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Pedido de Venda</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Importador</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Referencia</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Navio</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Booking</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">R.E.</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Data do R.E.</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">SD</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Data da SD</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">BL number</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Data do BL</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Data da Averbacao</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Vl.Final</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Taxa USD</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Valor Total</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">NF Exportacao</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Invoice</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Terminal</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Porto</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Tipo</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">Qualidade Final</Data></Cell>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)
	
	nSACAS 		:= 0
	nTONELADAS  := 0
	ncount		:= 0
	ncountq 	:= 0
	cXml		:= ""
	aPVES		:= {}
	aPVS		:= {}
	While !(cAliasQry)->(Eof())
		
		ncount += 1
		ncountq += 1
		
		IncProc(Str(ncount,5)+" de "+Str(nLin-150,5)+ " registros" )
		
		If !Empty(MV_PAR07) .and. (cAliasQry)->CTH_VESSEL <> CTH->CTH_VESSEL
			(cAliasQry)->(DbSkip())
			Loop
		EndIf
		
		cZ3_DTINIC 	:= SubStr((cAliasQry)->Z3_DTINIC,1,4)+"-"+SubStr((cAliasQry)->Z3_DTINIC,5,2)+"-"+SubStr((cAliasQry)->Z3_DTINIC,7,2)+"T00:00:00.000"
		cZ3_DTFIM	:= SubStr((cAliasQry)->Z3_DTFIM,1,4)+"-"+SubStr((cAliasQry)->Z3_DTFIM,5,2)+"-"+SubStr((cAliasQry)->Z3_DTFIM,7,2)+"T00:00:00.000"
		
		If !Empty((cAliasQry)->EEC_DTEMBA)
			cDTBL := SubStr((cAliasQry)->EEC_DTEMBA,1,4)+"-"+SubStr((cAliasQry)->EEC_DTEMBA,5,2)+"-"+SubStr((cAliasQry)->EEC_DTEMBA,7,2)+"T00:00:00.000"
		Else
			cDTBL := ""
		EndIf
		
		xPos  := Ascan(aPVES,{|x| x[1] == (cAliasQry)->EYY_NFSAI+(cAliasQry)->D2_PEDIDO+(cAliasQry)->D2_ITEM+(cAliasQry)->EYY_NFENT})
		
		If xPos == 0
			xPos  := Ascan(aPVS,{|x| x[1] == (cAliasQry)->EYY_NFSAI+(cAliasQry)->D2_PEDIDO+(cAliasQry)->D2_ITEM})
			If xPos == 0
				Aadd(aPVES,{(cAliasQry)->EYY_NFSAI+(cAliasQry)->D2_PEDIDO+(cAliasQry)->D2_ITEM+(cAliasQry)->EYY_NFENT})
				Aadd(aPVS,{(cAliasQry)->EYY_NFSAI+(cAliasQry)->D2_PEDIDO+(cAliasQry)->D2_ITEM})
				nSACAS 		+= (cAliasQry)->SACAS
				nTONELADAS  += (cAliasQry)->TONELADAS
			EndIf

			// 23/05/16 - Luis Felipe - Inicio

			If !Empty((cAliasQry)->EE9_DTRE)
				cEE9_DTRE := SubStr((cAliasQry)->EE9_DTRE,1,4)+"-"+SubStr((cAliasQry)->EE9_DTRE,5,2)+"-"+SubStr((cAliasQry)->EE9_DTRE,7,2)+"T00:00:00.000"
			Else
				cEE9_DTRE := ""
			EndIf
	
			If !Empty((cAliasQry)->EE9_DTDDE)
				cEE9_DTDDE	:= SubStr((cAliasQry)->EE9_DTDDE,1,4)+"-"+SubStr((cAliasQry)->EE9_DTDDE,5,2)+"-"+SubStr((cAliasQry)->EE9_DTDDE,7,2)+"T00:00:00.000"
			Else
				cEE9_DTDDE := ""
			EndIf

			If !Empty((cAliasQry)->EE9_DTAVRB)
				cEE9_DTAVRB	:= SubStr((cAliasQry)->EE9_DTDDE,1,4)+"-"+SubStr((cAliasQry)->EE9_DTDDE,5,2)+"-"+SubStr((cAliasQry)->EE9_DTDDE,7,2)+"T00:00:00.000"
			Else
				cEE9_DTAVRB := ""
			EndIf
			// 23/05/16 - Luis Felipe - Fim


		  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+Alltrim((cAliasQry)->Z3_CONTRA)+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+Alltrim((cAliasQry)->CNC_NOME)+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s92"><Data ss:Type="String">'+Alltrim((cAliasQry)->Z3_PERIODO)+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s93"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s93"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s92"><Data ss:Type="String">'+(cAliasQry)->F1_XPEDIDO+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s92"><Data ss:Type="String">'+(cAliasQry)->EYY_NFENT+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s114"><Data ss:Type="String">'+Transform((cAliasQry)->SACAS,"@E 999,999,999")+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s115"><Data ss:Type="String">'+Transform((cAliasQry)->TONELADAS,"@E 999,999,999.999")+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s92"><Data ss:Type="String">'+(cAliasQry)->D2_PEDIDO+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->A1_NREDUZ+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->EE9_PREEMB+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->CTH_VESSEL+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->CTH_BOOKIN+'</Data></Cell>'+CENT)


		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->EYY_RE+'</Data></Cell>'+CENT)
			If !Empty(cEE9_DTRE)
			  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="DateTime">'+cEE9_DTRE+'</Data></Cell>'+CENT)
			Else
			  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="String"></Data></Cell>'+CENT)
            EndIf
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->EE9_NRSD+'</Data></Cell>'+CENT)
			If !Empty(cEE9_DTDDE)
			  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="DateTime">'+cEE9_DTDDE+'</Data></Cell>'+CENT)
			Else
			  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="String"></Data></Cell>'+CENT)
            EndIf
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->EEC_NRCONH+'</Data></Cell>'+CENT)
			If !Empty(cDTBL)
			  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="DateTime">'+cDTBL+'</Data></Cell>'+CENT)
			Else
			  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="String"></Data></Cell>'+CENT)
            EndIf
            
			If !Empty(cEE9_DTAVRB)
			  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="DateTime">'+cEE9_DTAVRB+'</Data></Cell>'+CENT)
			Else
			  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="String"></Data></Cell>'+CENT)
			EndIf	
		  	FWrite(nArq,'    <Cell ss:StyleID="s117"><Data ss:Type="String">'+Transform((cAliasQry)->Z6_VLFINAL,"@E 999,999,999.99")+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s99"><Data ss:Type="String">'+Transform((cAliasQry)->C7_TAXAUSD,"@E 99,999.9999")+'</Data></Cell>'+CENT)
  			FWrite(nArq,'    <Cell ss:StyleID="s117"><Data ss:Type="String">'+Transform((cAliasQry)->D2_TOTAL-(cAliasQry)->NFDEVVL,"@E 999,999,999.99")+'</Data></Cell>'+CENT)
  			FWrite(nArq,'    <Cell ss:StyleID="s92"><Data ss:Type="String">'+(cAliasQry)->EYY_NFSAI+' '+(cAliasQry)->NFDEV+'</Data></Cell>'+CENT)

			If	Substr((cAliasQry)->EEC_NRINVO,1,2)=="MV" // A invoice ainda n„o foi gerada 
			  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String"></Data></Cell>'+CENT)
            Else
			  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->EEC_NRINVO+'</Data></Cell>'+CENT)
            EndIf
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->ZE_NOME+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->Y9_DESCR+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+(cAliasQry)->TIPO+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s99"><Data ss:Type="String">'+Transform((cAliasQry)->EE8_XPOLDP,"@E 99,999.9999")+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'   </Row>'+CENT)
		EndIf
		
		If !Empty((cAliasQry)->EEC_XINVCP)
		   	cCONTRA := Alltrim((cAliasQry)->Z3_CONTRA)
		   	cNOME	:= Alltrim((cAliasQry)->CNC_NOME) 
		   	cPeriodo:= Alltrim((cAliasQry)->Z3_PERIODO)
			cNFSAI 	:= Alltrim((cAliasQry)->EYY_NFSAI)     
			cNREDUZ	:= (cAliasQry)->A1_NREDUZ
			cXINVCP := (cAliasQry)->EEC_XINVCP
			nXVLNF 	:= (cAliasQry)->EEC_XVLNF 
			cPedido := (cAliasQry)->EEC_PEDEMB 
			cNRINVO	:= (cAliasQry)->EEC_NRINVO
		EndIf 
		
		(cAliasQry)->(DbSkip()) 
		
		If	cNFSAI <> (cAliasQry)->EYY_NFSAI .and. !Empty(cNFSAI)
		  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+cCONTRA+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+cNOME+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s92"><Data ss:Type="String">'+cPERIODO+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s93"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s93"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s92"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s92"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s114"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s115"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s92"><Data ss:Type="String">'+cPedido+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+cNREDUZ+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s97"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s117"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s99"><Data ss:Type="String"></Data></Cell>'+CENT)
  			FWrite(nArq,'    <Cell ss:StyleID="s117"><Data ss:Type="String">'+Transform(nXVLNF,"@E 999,999,999.99")+'</Data></Cell>'+CENT)
  			FWrite(nArq,'    <Cell ss:StyleID="s92"><Data ss:Type="String">'+cNFSAI+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+cNRINVO+'</Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'    <Cell ss:StyleID="s99"><Data ss:Type="String"></Data></Cell>'+CENT)
		  	FWrite(nArq,'   </Row>'+CENT) 
		   	cCONTRA := ''
		   	cNOME	:= ''
		   	cPeriodo:= ''
			cNFSAI 	:= ''
			cNREDUZ	:= ''
			cXINVCP := ''
			nXVLNF 	:= ''
			cPedido := ''
			cNRINVO	:= ''
		EndIf
		
		If	ncountq == 380 .or. (cAliasQry)->(Eof())
			FWrite(nArq,cXml)
			cXml := ""
			ncountq := 0
		EndIf
		
	End
  	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s100"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s100"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s100"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s100"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s100"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s100"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s100"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s114"><Data ss:Type="String">'+Transform(nSACAS,"@E 999,999,999")+'</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s115"><Data ss:Type="String">'+Transform(nTONELADAS,"@E 999,999,999.999")+'</Data></Cell>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'    <Cell ss:StyleID="s102"/>'+CENT)
  	FWrite(nArq,'   </Row>'+CENT)
  	FWrite(nArq,'  </Table>'+CENT)
  	FWrite(nArq,'  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT)
  	FWrite(nArq,'   <PageSetup>'+CENT)
  	FWrite(nArq,'    <Header x:Margin="0.31496062000000002"/>'+CENT)
  	FWrite(nArq,'    <Footer x:Margin="0.31496062000000002"/>'+CENT)
  	FWrite(nArq,'    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT)
  	FWrite(nArq,'     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT)
  	FWrite(nArq,'   </PageSetup>'+CENT)
  	FWrite(nArq,'   <Unsynced/>'+CENT)
  	FWrite(nArq,'   <Print>'+CENT)
  	FWrite(nArq,'    <ValidPrinterInfo/>'+CENT)
  	FWrite(nArq,'    <PaperSizeIndex>9</PaperSizeIndex>'+CENT)
  	FWrite(nArq,'    <HorizontalResolution>-3</HorizontalResolution>'+CENT)
  	FWrite(nArq,'    <VerticalResolution>-3</VerticalResolution>'+CENT)
  	FWrite(nArq,'   </Print>'+CENT)
  	FWrite(nArq,'   <Selected/>'+CENT)
  	FWrite(nArq,'   <Panes>'+CENT)
  	FWrite(nArq,'    <Pane>'+CENT)
  	FWrite(nArq,'     <Number>3</Number>'+CENT)
  	FWrite(nArq,'     <ActiveRow>3</ActiveRow>'+CENT)
  	FWrite(nArq,'    </Pane>'+CENT)
  	FWrite(nArq,'   </Panes>'+CENT)
  	FWrite(nArq,'   <ProtectObjects>False</ProtectObjects>'+CENT)
  	FWrite(nArq,'   <ProtectScenarios>False</ProtectScenarios>'+CENT)
  	FWrite(nArq,'  </WorksheetOptions>'+CENT)
  	FWrite(nArq,' </Worksheet>'+CENT)
  	FWrite(nArq,'</Workbook>'+CENT)

	FClose(nArq)
	shellExecute( "Open", cPath + cArq + ".xml", " /k dir", "C:\", 1 )
	
EndIf

Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                          4                           5                          6           7    8   9   10  11    12   13           14      15      16      17   18   19      20      21      22      23   24        25   26   27   28   29        30   31   32   33   34   35   36   37   38       39   40  41  42             43
AADD(aSx1,{"EDFR017" , "01" , "Terminal           ?"   , "Terminal           ?"   , "Terminal           ?"   , "mv_ch1" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "SZE_2", "" , "", "", ""           , ""})
AADD(aSx1,{"EDFR017" , "02" , "PaÌs de Destino    ?"   , "PaÌs de Destino    ?"   , "PaÌs de Destino    ?"   , "mv_ch2" , "C" , 05 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "SY9"  , "" , "", "", ""           , ""})
AADD(aSx1,{"EDFR017" , "03" , "Tipo de Produto    ?"   , "Tipo de Produto    ?"   , "Tipo de Produto    ?"   , "mv_ch3" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par03" , "VHP" , ""    , ""    , "" , "" , "XTL" , ""    , ""    , ""    , "" , "REF"   , "" , "" , "" , "" , "Todos" , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "" , "", "", ""          , ""})
AADD(aSx1,{"EDFR017" , "04" , "Safra 15/16   	  ?"   , "Safra 15/16   	   ?" , "Safra 15/16   	    ?"   , "mv_ch4" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "" , "", "", "@R 99/99" , ""})
AADD(aSx1,{"EDFR017" , "05" , "Fornecedor Ex: BAZAN  ?" , "Fornecedor Ex: BAZAN  ?" , "Fornecedor Ex: BAZAN  ?" , "mv_ch5" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 	  , "" , "" , "" , "" , "" , "" , "" , "" , "SA2NRZ"  , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR017" , "06" , "Pedido de Venda    ?"   , "Pedido de Venda    ?"   , "Pedido de Venda    ?"   , "mv_ch6" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par06" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 	  , "" , "" , "" , "" , "" , "" , "" , "" , "SC6"  , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR017" , "07" , "Navio              ?"   , "Navio              ?"   , "Navio              ?"   , "mv_ch7" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par07" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 	  , "" , "" , "" , "" , "" , "" , "" , "" , "CTH"  , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR017" , "08" , "Contrato           ?"   , "Contrato           ?"   , "Contrato           ?"   , "mv_ch8" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par08" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 	  , "" , "" , "" , "" , "" , "" , "" , "" , "SZ3"  , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR017" , "09" , "DP                 ?"   , "DP                 ?"   , "DP                 ?"   , "mv_ch9" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par09" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 	  , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR017" , "10" , "Embarcado De       ?"   , "Embarcado De       ?"   , "Embarcado De       ?"   , "mv_cha" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par10" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 	  , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR017" , "11" , "Embarcado Ate      ?"   , "Embarcado Ate      ?"   , "Embarcado Ate      ?"   , "mv_chb" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par11" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 	  , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "" , "", "", "" 			 , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR017   11")
	
	DbSeek("EDFR017")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR017"
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
