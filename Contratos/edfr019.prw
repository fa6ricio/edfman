#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥ EDFR019     ≥ Autor ≥ Luis Felipe Mattos	≥ Data ≥ 07.08.15 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Pricing Start                           			 		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 		 ≥ Gera Excel - Contratos                               	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum													  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracao ≥                       Luis Felipe Mattos          24/03/17 ≥±±
±±≥          ≥ AdequaÁ„o para aceitaÁ„o de produtos do grupo de Gr„os     ≥±±
±±≥          ≥ Soja e Milho.                                              ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function EDFR019()

Local 	nOrdem
Local 	cQuery		:= ""
Private   cAliasQry   := GetNextAlias()

Private cString    	:= "SZD"
Private wnrel      	:= "EDFR019"
Private aOrd       	:= {"Nota Fiscal"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Sum·rio do Navio"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Sum·rio do Navio", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR019"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR019"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR019"
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

cQuery := " SELECT DISTINCT Z3_CONTRA"+CENT
cQuery += " ,Z3_PERIODO"+CENT
cQuery += " ,Z3_SAFRA"+CENT
cQuery += " ,CN9_DTASSI"+CENT
cQuery += " ,Z2_INCOTER"+CENT
cQuery += " ,CN9_XFORNE"+CENT
cQuery += " ,TIPO"+CENT
cQuery += " ,Z3_PAYTERM"+CENT
cQuery += " ,CN9_XFIXO"+CENT
cQuery += " ,Z3_BOLSA"+CENT
cQuery += " ,Z3_TELA"+CENT
cQuery += " ,CN9_XSTYLE"+CENT
cQuery += " ,Z3_QTDLOT"+CENT
cQuery += " ,Z6_FIXO"+CENT
cQuery += " ,Z6_NFIXO"+CENT
cQuery += " ,CN9_VIGE"+CENT
cQuery += " ,PrcFob"+CENT
cQuery += " ,NPrcFob"+CENT
cQuery += " ,FOB_DISCOUNT"+CENT
cQuery += " ,Z6_VLFINAL"+CENT
cQuery += " ,Z6_NVLFINAL"+CENT
cQuery += " ,'DEFINITIVO' AS Type"+CENT
cQuery += " ,Z3_DTINIC"+CENT
cQuery += " ,Z3_DTFIM"+CENT
cQuery += " ,Z3_DTINEM"+CENT
cQuery += " ,Z3_DTFIEM"+CENT
cQuery += " ,Z3_QUANT"+CENT
cQuery += " ,ZD_QTDREC"+CENT
cQuery += " ,D2_QTDDEV "+CENT
cQuery += " ,EE9_PSLQTO"+CENT
cQuery += " ,B2_SALDO "+CENT
cQuery += " ,CN9_XTRADE"+CENT  

cQuery += " FROM"+CENT
cQuery += " (SELECT Z3_CONTRA"+CENT
cQuery += " ,Z3_PERIODO"+CENT
cQuery += " ,Z3_SAFRA"+CENT
cQuery += " ,CN9_DTASSI"+CENT
cQuery += " ,(SELECT TOP 1 Z2_INCOTER FROM "+RetSqlName("SZ2")+" WHERE SZ3.Z3_CTRDP = Z2_CODPRO AND SUBSTRING(Z2_CONTRA,1,1) = 'P' AND D_E_L_E_T_ <> '*') AS Z2_INCOTER"+CENT  
cQuery += " ,CN9_XFORNE"+CENT
//cQuery += " ,(CASE WHEN B1_GRUPO = '001' THEN 'VHP' ELSE (CASE WHEN B1_GRUPO IN ('001','002','003') THEN 'XTL' ELSE 'REF' END) END) TIPO"+CENT
cQuery += " ,(CASE WHEN BM_DESC LIKE '%VHP%' THEN 'VHP' ELSE (CASE WHEN BM_DESC LIKE '%XTL%' THEN 'XTL' ELSE (CASE WHEN BM_DESC LIKE '%SOJA%' THEN 'SOJ' ELSE (CASE WHEN BM_DESC LIKE '%MILHO%' THEN 'MIL' ELSE (CASE WHEN BM_DESC LIKE '%REFINADO%' THEN 'REF' ELSE '   ' END) END) END) END) END) AS TIPO "+CENT
cQuery += " ,Z3_PAYTERM"+CENT
cQuery += " ,CN9_XFIXO"+CENT
cQuery += " ,Z3_BOLSA"+CENT
cQuery += " ,Z3_TELA"+CENT
cQuery += " ,CN9_XSTYLE"+CENT
cQuery += " ,Z3_QTDLOT"+CENT
cQuery += " ,Z3_DTINIC"+CENT
cQuery += " ,Z3_DTFIM"+CENT
cQuery += " ,Z3_DTINEM"+CENT
cQuery += " ,Z3_DTFIEM"+CENT
cQuery += " ,Z3_QUANT"+CENT  
cQuery += " ,CN9_VIGE"+CENT  
cQuery += " ,CN9_XTRADE"+CENT  
cQuery += " FROM "+RetSqlName("SZ3")+" SZ3, "+RetSqlName("CN9")+" CN9, "+RetSqlName("SB1")+" SB1,"+RetSqlName("CNC")+" CNC, "+RetSqlName("SBM")+" SBM"+CENT
cQuery += " WHERE Z3_CONTRA = CN9_NUMERO"+CENT
cQuery += " AND Z3_CONTRA = CNC_NUMERO"+CENT
cQuery += " AND Z3_CTRDP = B1_COD"+CENT
cQuery += " AND B1_GRUPO = BM_GRUPO"+CENT
cQuery += " AND SUBSTRING(Z3_CONTRA,1,1) = 'P'"+CENT
// Filtros
cQuery += "	AND Z3_SAFRA BETWEEN '"+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,2)+"' AND '"+SubStr(MV_PAR02,1,2)+"/"+SubStr(MV_PAR02,3,2)+"'"+CENT
If !Empty(MV_PAR03)
	cQuery += "	AND CNC_CODIGO = '"+MV_PAR03+"'"+CENT
EndIf 
cQuery += " AND SZ3.D_E_L_E_T_ = '' "+CENT
cQuery += " AND CN9.D_E_L_E_T_ = ''"+CENT
cQuery += " AND CNC.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SB1.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SBM.D_E_L_E_T_ = '')"+CENT
cQuery += " AS SZ3"+CENT

cQuery += " LEFT JOIN"+CENT
cQuery += " (SELECT DISTINCT Z6_CONTRA,Z6_PERDE"+CENT
//cQuery += " ,MONTH((SELECT MAX(Z6_DATA) FROM "+RetSqlName("SZ6")+" WHERE SZ6.Z6_CONTRA = Z6_CONTRA AND SZ6.Z6_PERDE = Z6_PERDE AND Z6_TIPOPRE = '2' AND D_E_L_E_T_ <> '*')) AS Z6_MES"+CENT
cQuery += " ,(SELECT SUM(Z6_LOTE)       FROM "+RetSqlName("SZ6")+" WHERE SZ6.Z6_CONTRA = Z6_CONTRA AND SZ6.Z6_PERDE = Z6_PERDE AND Z6_TIPOPRE = '2' AND D_E_L_E_T_ <> '*') AS Z6_FIXO "+CENT
//cQuery += " ,(Z6_MDCENTS+Z5_PREMIO6+Z5_PREMIO7)*(CASE WHEN Z5_BOLSA='NY' THEN 22.0462 ELSE 1 END)+Z5_PREMIO1+Z5_PREMIO3+Z5_POLDP AS PrcFob"+CENT // 21/08/17 - Luis Felipe
cQuery += " ,(Z6_MDCENTS+Z5_PREMIO6+Z5_PREMIO7)*(CASE WHEN Z5_BOLSA='NY' AND Z5_TELA <> 'FX' THEN 22.0462 ELSE 1 END)+Z5_PREMIO1+Z5_PREMIO3+Z5_POLDP AS PrcFob"+CENT
cQuery += " ,Z5_ELEVAC+(Z5_PREMIO4) AS FOB_DISCOUNT"+CENT
cQuery += " ,(SELECT TOP 1 Z6_VLFINAL   FROM "+RetSqlName("SZ6")+" WHERE SZ6.Z6_CONTRA = Z6_CONTRA AND SZ6.Z6_PERDE = Z6_PERDE AND Z6_TIPOPRE = '2' AND D_E_L_E_T_ <> '*') AS Z6_VLFINAL "+CENT
cQuery += " FROM  "+RetSqlName("SZ5")+" SZ5, "+RetSqlName("SZ6")+" SZ6 WHERE Z5_CONTRA = Z6_CONTRA AND Z5_PERDE = Z6_PERDE AND Z6_TIPOPRE = '2' AND SZ5.D_E_L_E_T_ = '' AND SZ6.D_E_L_E_T_ = '')"+CENT  
cQuery += " AS SZ6"+CENT
cQuery += " ON  SZ3.Z3_CONTRA = SZ6.Z6_CONTRA AND SZ3.Z3_PERIODO = SZ6.Z6_PERDE"+CENT

cQuery += " LEFT JOIN"+CENT
cQuery += " (SELECT DISTINCT Z6_CONTRA,Z6_PERDE"+CENT
//cQuery += " ,MONTH((SELECT MAX(Z6_DATA) FROM "+RetSqlName("SZ6")+" WHERE SZ6.Z6_CONTRA = Z6_CONTRA AND SZ6.Z6_PERDE = Z6_PERDE AND Z6_TIPOPRE = '1' AND D_E_L_E_T_ <> '*'))  AS Z6_NMES"+CENT
cQuery += " ,(SELECT SUM(Z6_LOTE)       FROM "+RetSqlName("SZ6")+" WHERE SZ6.Z6_CONTRA = Z6_CONTRA AND SZ6.Z6_PERDE = Z6_PERDE AND Z6_TIPOPRE = '1' AND D_E_L_E_T_ <> '*') AS Z6_NFIXO "+CENT
//cQuery += " ,(Z6_MDCENTS+Z5_PREMIO6+Z5_PREMIO7)*(CASE WHEN Z5_BOLSA='NY' THEN 22.0462 ELSE 1 END)+Z5_PREMIO1+Z5_PREMIO3+Z5_POLDP AS nPrcFob"+CENT // 21/08/17 - Luis Felipe
cQuery += " ,(Z6_MDCENTS+Z5_PREMIO6+Z5_PREMIO7)*(CASE WHEN Z5_BOLSA='NY' AND Z5_TELA <> 'FX' THEN 22.0462 ELSE 1 END)+Z5_PREMIO1+Z5_PREMIO3+Z5_POLDP AS nPrcFob"+CENT
cQuery += " ,(SELECT TOP 1 Z6_VLFINAL   FROM "+RetSqlName("SZ6")+" WHERE SZ6.Z6_CONTRA = Z6_CONTRA AND SZ6.Z6_PERDE = Z6_PERDE AND Z6_TIPOPRE = '1' AND D_E_L_E_T_ <> '*') AS Z6_NVLFINAL "+CENT
cQuery += " FROM "+RetSqlName("SZ5")+" SZ5, "+RetSqlName("SZ6")+ " SZ6 WHERE Z5_CONTRA = Z6_CONTRA AND Z5_PERDE = Z6_PERDE AND Z6_TIPOPRE = '1' AND SZ5.D_E_L_E_T_ = '' AND SZ6.D_E_L_E_T_ = '')  "+CENT
cQuery += " AS SZ6N"+CENT
cQuery += " ON  SZ3.Z3_CONTRA = SZ6N.Z6_CONTRA AND SZ3.Z3_PERIODO = SZ6N.Z6_PERDE"+CENT

cQuery += " LEFT JOIN "+CENT
cQuery += " (SELECT ZD_CONTRA,ZD_PERIODO "+CENT
cQuery += " ,(SELECT SUM(ISNULL(CASE WHEN ZD_UM = 'TM' THEN ZD_QTDREC  ELSE ZD_QTDREC * B1_CONV END, 0))  FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '') AS ZD_QTDREC "+CENT
cQuery += " ,(SELECT SUM(ISNULL(CASE WHEN ZD_UM = 'TM' THEN ZD_QTDNFRE ELSE ZD_QTDNFRE * B1_CONV END, 0)) FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD.D_E_L_E_T_ = ''  AND B1.D_E_L_E_T_ = '' AND ZD.R_E_C_N_O_ = (SELECT Max(R_E_C_N_O_) FROM "+RetSqlName("SZD")+" WHERE ZD_NFREMES = ZD.ZD_NFREMES AND D_E_L_E_T_ = '')) AS ZD_QTDNFRE "+CENT
cQuery += " FROM "+RetSqlName("SZD")+" SZD"+CENT
cQuery += " WHERE SZD.D_E_L_E_T_ <>  '*'"+CENT
cQuery += " AND ZD_NOMETER  <> ''"+CENT
cQuery += " GROUP BY ZD_CONTRA,ZD_PERIODO)"+CENT
cQuery += " AS SZD "+CENT
cQuery += " ON SZ3.Z3_CONTRA = SZD.ZD_CONTRA AND  SZ3.Z3_PERIODO = SZD.ZD_PERIODO"+CENT 

cQuery += " LEFT JOIN "+CENT
cQuery += " (SELECT D2_COD, SUM(ISNULL(CASE WHEN B1_UM = 'TM' THEN D2_QUANT ELSE D2_QUANT * B1_CONV END, 0)) AS D2_QTDDEV "+CENT
cQuery += " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1"+CENT
cQuery += " WHERE SD2.D_E_L_E_T_ <>  '*'"+CENT
cQuery += " AND SB1.D_E_L_E_T_ <>  '*'"+CENT 
cQuery += " AND D2_COD = B1_COD"+CENT 
cQuery += " AND D2_TIPO = 'D'"+CENT 
cQuery += " AND D2_TES NOT IN ('506','508')"+CENT 
cQuery += " GROUP BY D2_COD)"+CENT
cQuery += " AS SD2"+CENT
cQuery += " ON RTRIM(SZ3.Z3_CONTRA)+'-'+RTRIM(SZ3.Z3_PERIODO) = SD2.D2_COD"+CENT 

cQuery += " LEFT JOIN"+CENT
cQuery += " (SELECT EE9_COD_I, SUM(EE9_PSLQTO / 1000) AS EE9_PSLQTO"+CENT
cQuery += " FROM "+RetSqlName("EE9")+" EE9, "+RetSqlName("EEC")+" EEC,"+RetSqlName("EE8")+" EE8,"+RetSqlName("SB1")+" SB1"+CENT
cQuery += " WHERE EE9.EE9_FILIAL = EEC.EEC_FILIAL"+CENT
cQuery += " AND EE9.EE9_PREEMB = EEC.EEC_PREEMB"+CENT
cQuery += " AND EE9.EE9_FILIAL = EE8.EE8_FILIAL"+CENT
cQuery += " AND EE9.EE9_PEDIDO = EE8.EE8_PEDIDO"+CENT 
cQuery += " AND EE9.EE9_COD_I  = EE8.EE8_COD_I"+CENT
cQuery += " AND EE9.EE9_COD_I  = B1_COD"+CENT 
cQuery += " AND EE8.D_E_L_E_T_ = ''"+CENT 
cQuery += " AND EE9.D_E_L_E_T_ = ''"+CENT 
cQuery += " AND EEC.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SB1.D_E_L_E_T_ = ''"+CENT
cQuery += " GROUP BY EE9_COD_I)"+CENT 
cQuery += " AS EE9"+CENT
cQuery += " ON RTRIM(EE9.EE9_COD_I) = RTRIM(SZ3.Z3_CONTRA)+'-'+RTRIM(SZ3.Z3_PERIODO)"+CENT

cQuery += " LEFT JOIN"+CENT
cQuery += " (SELECT B2_COD, SUM(ISNULL(CASE WHEN B1_UM = 'TM' THEN B2_QTSEGUM ELSE B2_QATU END, 0)) AS B2_SALDO"+CENT 
cQuery += " FROM "+RetSqlName("SB2")+" SB2, "+RetSqlName("SB1")+" SB1"+CENT  
cQuery += " WHERE B2_COD = B1_COD"+CENT
cQuery += " AND SB2.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SB1.D_E_L_E_T_ = ''"+CENT 
cQuery += " GROUP BY B2_COD)"+CENT 
cQuery += " AS SB2"+CENT 
cQuery += " ON RTRIM(SB2.B2_COD) = RTRIM(SZ3.Z3_CONTRA)+'-'+RTRIM(SZ3.Z3_PERIODO)"+CENT
cQuery += " ORDER BY 3,1,2"+CENT

MemoWrite("C:\Tmp\EDFR019.txt",cQuery)
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
	
	nLin := 150
	While !(cAliasQry)->(EOf())
		nLin ++
		(cAliasQry)->(DbSkip())
	End
	
	ProcRegua(nLin-150)
	
	(cAliasQry)->(DbGotop())

	cXml := '<?xml version="1.0"?>'+CENT
	cXml += '<?mso-application progid="Excel.Sheet"?>'+CENT
	cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
	cXml += ' xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT
	cXml += ' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT
	cXml += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
	cXml += ' xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT
	cXml += ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT
	cXml += '  <Author>Luis Filipe Nascimento</Author>'+CENT
	cXml += '  <LastAuthor>Luis Filipe Nascimento</LastAuthor>'+CENT
	cXml += '  <LastPrinted>2015-08-06T20:27:59Z</LastPrinted>'+CENT
	cXml += '  <Created>2015-08-04T16:40:01Z</Created>'+CENT
	cXml += '  <LastSaved>2015-08-07T14:11:10Z</LastSaved>'+CENT
	cXml += '  <Version>15.00</Version>'+CENT
	cXml += ' </DocumentProperties>'+CENT
	cXml += ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CENT
	cXml += '  <AllowPNG/>'+CENT
	cXml += ' </OfficeDocumentSettings>'+CENT
	cXml += ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
	cXml += '  <WindowHeight>7755</WindowHeight>'+CENT
	cXml += '  <WindowWidth>20490</WindowWidth>'+CENT
	cXml += '  <WindowTopX>0</WindowTopX>'+CENT
	cXml += '  <WindowTopY>0</WindowTopY>'+CENT
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
	cXml += '  <Style ss:ID="m458472266776">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="16" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s16">'+CENT
	cXml += '   <Alignment ss:Vertical="Top" ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s17">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s18">'+CENT
	cXml += '   <Alignment ss:Vertical="Top" ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s19">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0;\(#,##0\)"/>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s20">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s21">'+CENT
	cXml += '   <Alignment ss:Vertical="Top" ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]0.000000;\(0.000000\)"/>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s22">'+CENT
	cXml += '   <Alignment ss:Vertical="Top" ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s23">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.000;\(#,##0.000\)"/>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s26">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Top" ss:ReadingOrder="LeftToRight"'+CENT
	cXml += '    ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>'+CENT
	cXml += '   <NumberFormat ss:Format="mmm/yy"/>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s27">'+CENT
	cXml += '   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s30">'+CENT
	cXml += '   <Alignment ss:Vertical="Top" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s31">'+CENT
	cXml += '   <Alignment ss:Vertical="Top" ss:ReadingOrder="LeftToRight" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '   <Protection ss:Protected="0"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s32">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s33">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s98">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s99">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#F2F2F2" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += ' </Styles>'+CENT
	cXml += ' <Worksheet ss:Name="Parametros">'+CENT
	cXml += '  <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="2" x:FullColumns="1"'+CENT
	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
	cXml += '   <Column ss:Width="66.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="192"/>'+CENT
	cXml += '   <Row>'+CENT
	cXml += '    <Cell ss:StyleID="s98"><Data ss:Type="String">Counterparty</Data></Cell>'+CENT
	SA2->(DBSetOrder(1))
	SA2->(DBSeeK(xFilial("SA2")+MV_PAR03))
	cXml += '    <Cell ss:StyleID="s99"><Data ss:Type="String">'+SA2->A2_NOME+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row>'+CENT
	cXml += '    <Cell ss:StyleID="s98"><Data ss:Type="String">Crop</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s99"><Data ss:Type="String">De '+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4)+' Ate '+SubStr(MV_PAR02,1,2)+"/"+SubStr(MV_PAR02,3,4)+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
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
	cXml += '     <ActiveRow>7</ActiveRow>'+CENT
	cXml += '     <ActiveCol>1</ActiveCol>'+CENT
	cXml += '    </Pane>'+CENT
	cXml += '   </Panes>'+CENT
	cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
	cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
	cXml += '  </WorksheetOptions>'+CENT
	cXml += ' </Worksheet>'+CENT
	cXml += ' <Worksheet ss:Name="Relatorio">'+CENT
	cXml += '  <Table ss:ExpandedColumnCount="30" ss:ExpandedRowCount="'+Alltrim(Str(nLin))+'" x:FullColumns="1"'+CENT
	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
	cXml += '   <Column ss:Index="2" ss:Hidden="1" ss:AutoFitWidth="0"/>'+CENT
	cXml += '   <Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="53.25"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="96"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="211.5"/>'+CENT
	cXml += '   <Column ss:Width="59.25"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="90.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="88.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="85.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="69"/>'+CENT
	cXml += '   <Column ss:Index="17" ss:AutoFitWidth="0" ss:Width="79.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="97.5" ss:Span="1"/>'+CENT
	cXml += '   <Column ss:Index="20" ss:AutoFitWidth="0" ss:Width="81.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="69"/>'+CENT
	cXml += '   <Column ss:Width="70.5"/>'+CENT
	cXml += '   <Column ss:Width="65.25"/>'+CENT
	cXml += '   <Column ss:Width="53.25" ss:Span="1"/>'+CENT
	cXml += '   <Column ss:Index="26" ss:AutoFitWidth="0" ss:Width="80.25"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="89.25"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="93.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="81.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="137.25"/>'+CENT
	cXml += '   <Row ss:Height="21.75">'+CENT
	cXml += '    <Cell ss:MergeAcross="28" ss:StyleID="m458472266776"><Data ss:Type="String">Pricing Start</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s27"><Data ss:Type="String">Date: '+DtoC(Ddatabase)+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:Height="25.5">'+CENT
	cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="s31"><Data ss:Type="String">Contract</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s30"><Data ss:Type="String">DP</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Crop</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Contract Date</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Terms</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Counterparty</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Commodity</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Pay Terms</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Pricing</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Mkt</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Prompt</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Style</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Lots</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Lots Fixed</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Lots Unfixed</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s32"><Data ss:Type="String">Pricing Months</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s33"><Data ss:Type="String">Fob Price</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s33"><Data ss:Type="String">Fob Discount</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s33"><Data ss:Type="String">Final Price</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Type</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Delivery Start</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Delivery End</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Ship Start</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Ship End</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Contract  Qty</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Nominated Qty</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Shipped Qty</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s31"><Data ss:Type="String">Free Qty</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s16"><Data ss:Type="String">Trader</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT

	FWrite(nArq,cXml)
	cXml := ''	

	ncount		:= 0 
	ncountq 	:= 0 
	
	While !(cAliasQry)->(Eof())
		
		ncount += 1
		ncountq += 1 
		
		IncProc(Str(ncount,5)+" de "+Str(nLin-150,5)+ " registros" )

		cPayTer  := ""
		If (cAliasQry)->Z3_PAYTERM == '1'
			cPayTer := "CAD ManBR"
		ElseIf (cAliasQry)->Z3_PAYTERM == '2'
			cPayTer := "LC(C.Cred.)"
		ElseIf (cAliasQry)->Z3_PAYTERM == '3'
			cPayTer := "CAFD(c/copia docs)"
		ElseIf (cAliasQry)->Z3_PAYTERM == '4'
			cPayTer := "Stock Finance"
		ElseIf (cAliasQry)->Z3_PAYTERM == '5'
			cPayTer := "Standby L/C"
		ElseIf (cAliasQry)->Z3_PAYTERM == '6'
			cPayTer := "Part.Payment"
		ElseIf (cAliasQry)->Z3_PAYTERM == '7'
			cPayTer := "CAD Without Prod"
		ElseIf (cAliasQry)->Z3_PAYTERM == '8'
			cPayTer := "CAD"
		ElseIf (cAliasQry)->Z3_PAYTERM == '9'
			cPayTer := "Prepayment"
		EndIf
		
		Stor Space(1) to cZ3_DTFIM,cZ3_DTINEM,cZ3_DTFIEM,cCN9_DTASSI
		 	
		If !Empty((cAliasQry)->Z3_DTINIC)
			cZ3_DTINIC 	:= SubStr((cAliasQry)->Z3_DTINIC,1,4)+"-"+SubStr((cAliasQry)->Z3_DTINIC,5,2)+"-"+SubStr((cAliasQry)->Z3_DTINIC,7,2)+"T00:00:00.000"
		EndIf
		
		If !Empty((cAliasQry)->Z3_DTFIM)
			cZ3_DTFIM	:= SubStr((cAliasQry)->Z3_DTFIM,1,4)+"-"+SubStr((cAliasQry)->Z3_DTFIM,5,2)+"-"+SubStr((cAliasQry)->Z3_DTFIM,7,2)+"T00:00:00.000"
		EndIf

		If !Empty((cAliasQry)->Z3_DTINEM)
			cZ3_DTINEM 	:= SubStr((cAliasQry)->Z3_DTINEM,1,4)+"-"+SubStr((cAliasQry)->Z3_DTINEM,5,2)+"-"+SubStr((cAliasQry)->Z3_DTINEM,7,2)+"T00:00:00.000"
		EndIf

		If !Empty((cAliasQry)->Z3_DTFIEM)
			cZ3_DTFIEM	:= SubStr((cAliasQry)->Z3_DTFIEM,1,4)+"-"+SubStr((cAliasQry)->Z3_DTFIEM,5,2)+"-"+SubStr((cAliasQry)->Z3_DTFIEM,7,2)+"T00:00:00.000"
		EndIf

		If !Empty((cAliasQry)->CN9_DTASSI)
			cCN9_DTASSI	:= SubStr((cAliasQry)->CN9_DTASSI,1,4)+"-"+SubStr((cAliasQry)->CN9_DTASSI,5,2)+"-"+SubStr((cAliasQry)->CN9_DTASSI,7,2)+"T00:00:00.000"
        EndIf

		cXml += '   <Row>'+CENT
		cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="s18"><Data ss:Type="String">'+(cAliasQry)->Z3_CONTRA+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s17"><Data ss:Type="String">'+(cAliasQry)->Z3_PERIODO+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s26"><Data ss:Type="String">'+(cAliasQry)->Z3_SAFRA+'</Data></Cell>'+CENT
	    If !Empty(cCN9_DTASSI)
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="DateTime">'+cCN9_DTASSI+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+(cAliasQry)->Z2_INCOTER+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+(cAliasQry)->CN9_XFORNE+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+(cAliasQry)->TIPO+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+cPayTer+'</Data></Cell>'+CENT

		If (cAliasQry)->CN9_XFIXO $  ' 1'
 			cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">TO BE FIXED</Data></Cell>'+CENT
		Else
 			cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">FIXED</Data></Cell>'+CENT
		EndIf

		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+(cAliasQry)->Z3_BOLSA+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+(cAliasQry)->Z3_TELA+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+(cAliasQry)->CN9_XSTYLE+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">'+Transform((cAliasQry)->Z3_QTDLOT, "@E 999,999,999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">'+Transform((cAliasQry)->Z6_FIXO, "@E 999,999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">'+Transform((cAliasQry)->Z6_NFIXO, "@E 999,999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">'+Str((cAliasQry)->CN9_VIGE)+'</Data></Cell>'+CENT
        If (cAliasQry)->Z6_FIXO <> 0 
			cXml += '    <Cell ss:StyleID="s20"><Data ss:Type="String">'+Transform((cAliasQry)->PrcFob, "@E 999,999,999.99")+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s20"><Data ss:Type="String">'+Transform((cAliasQry)->NPrcFob, "@E 999,999,999.99")+'</Data></Cell>'+CENT
        EndIf
		cXml += '    <Cell ss:StyleID="s20"><Data ss:Type="String">'+Transform((cAliasQry)->FOB_DISCOUNT, "@E 999,999,999.99")+'</Data></Cell>'+CENT
        If (cAliasQry)->Z6_FIXO <> 0 
			cXml += '    <Cell ss:StyleID="s20"><Data ss:Type="String">'+Transform((cAliasQry)->Z6_VLFINAL, "@E 99,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s21"><Data ss:Type="String">Definifivo</Data></Cell>'+CENT
        Else
			cXml += '    <Cell ss:StyleID="s20"><Data ss:Type="String">'+Transform((cAliasQry)->Z6_NVLFINAL, "@E 99,999.99")+'</Data></Cell>'+CENT   
			If (cAliasQry)->Z6_NFIXO <> 0 
				cXml += '    <Cell ss:StyleID="s21"><Data ss:Type="String">Provisorio</Data></Cell>'+CENT  
			Else	
				cXml += '    <Cell ss:StyleID="s21"><Data ss:Type="String"></Data></Cell>'+CENT  
			EndIf
        EndIf
        
	    If !Empty(cZ3_DTINIC)
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
	
	    If !Empty(cZ3_DTFIM)
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
	
	    If !Empty(cZ3_DTINEM)
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="DateTime">'+cZ3_DTINEM+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
	
	    If !Empty(cZ3_DTFIEM)
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="DateTime">'+cZ3_DTFIEM+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
	
		cXml += '    <Cell ss:StyleID="s23"><Data ss:Type="String">'+Transform((cAliasQry)->Z3_QUANT, "@E 999,999,999.999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s23"><Data ss:Type="String">'+Transform((cAliasQry)->ZD_QTDREC - (cAliasQry)->D2_QTDDEV, "@E 999,999,999.999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s23"><Data ss:Type="String">'+Transform((cAliasQry)->EE9_PSLQTO, "@E 999,999,999.999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s23"><Data ss:Type="String">'+Transform((cAliasQry)->B2_SALDO, "@E 999,999,999.999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">'+(cAliasQry)->CN9_XTRADE+'</Data></Cell>'+CENT  // Trade
		cXml += '   </Row>'+CENT
        
        /* Descartar dupliciadades geradas pelos contratos com mais de um preÁo final. Falha gerada pela troca de funcion·rios da empresa. */
  		cContra := (cAliasQry)->Z3_CONTRA
  		cDP	    := (cAliasQry)->Z3_PERIODO
		(cAliasQry)->(DbSkip())
	  	While !Eof() .and. cContra == (cAliasQry)->Z3_CONTRA .and. cDP == (cAliasQry)->Z3_PERIODO
		   (cAliasQry)->(DbSkip())
		End
		
		If	ncountq == 380 .or. Eof() 
			FWrite(nArq,cXml)
			cXml := ""
			ncountq := 0 
		EndIf

    End
	cXml += '  </Table>'+CENT
	cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
	cXml += '   <PageSetup>'+CENT
	cXml += '    <Layout x:Orientation="Landscape"/>'+CENT
	cXml += '    <Header x:Margin="0.31496062000000002"/>'+CENT
	cXml += '    <Footer x:Margin="0.31496062000000002"/>'+CENT
	cXml += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT
	cXml += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT
	cXml += '   </PageSetup>'+CENT
	cXml += '   <FitToPage/>'+CENT
	cXml += '   <Print>'+CENT
	cXml += '    <ValidPrinterInfo/>'+CENT
	cXml += '    <PaperSizeIndex>9</PaperSizeIndex>'+CENT
	cXml += '    <Scale>31</Scale>'+CENT
	cXml += '    <HorizontalResolution>-3</HorizontalResolution>'+CENT
	cXml += '    <VerticalResolution>-3</VerticalResolution>'+CENT
	cXml += '   </Print>'+CENT
	cXml += '   <Selected/>'+CENT
	cXml += '   <Panes>'+CENT
	cXml += '    <Pane>'+CENT
	cXml += '     <Number>3</Number>'+CENT
	cXml += '     <ActiveRow>2</ActiveRow>'+CENT
	cXml += '     <RangeSelection>R3C1:R3C2</RangeSelection>'+CENT
	cXml += '    </Pane>'+CENT
	cXml += '   </Panes>'+CENT
	cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
	cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
	cXml += '  </WorksheetOptions>'+CENT
	cXml += ' </Worksheet>'+CENT
	cXml += '</Workbook>'+CENT	
	
	FWrite(nArq,cXml)	
	FClose(nArq)
	shellExecute( "Open", cPath + cArq + ".xml", " /k dir", "C:\", 1 )

EndIf

Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                        4                        5                        6           7     8   9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24        25   26   27   28   29   30   31   32   33   34   35   36   37   38       39   40  41  42             43
AADD(aSx1,{"EDFR019" , "01" , "Safra De      	  ?" , "Safra De      	   ?" , "Safra De      	    ?" , "mv_ch1" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "" , "", "", "@R 99/99" , ""})
AADD(aSx1,{"EDFR019" , "02" , "Safra Ate     	  ?" , "Safra Ate     	   ?" , "Safra Ate     	    ?" , "mv_ch2" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "" , "", "", "@R 99/99" , ""})
AADD(aSx1,{"EDFR019" , "03" , "Counterparty       ?" , "Counterparty       ?" , "Counterparty       ?" , "mv_ch3" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SA2"  , "" , "", "", "" 			 , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR019   03")
	
	DbSeek("EDFR019")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR019"
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
