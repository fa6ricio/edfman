#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥ EDFR024     ≥ Autor ≥ Luis Felipe Mattos	≥ Data ≥ 08.07.16 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Relatorio de Compras                    			 		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 		 ≥ Compras                                              	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracao ≥                                                             ±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥          ≥        												      ≥±±
±±≥          ≥        												      ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function EDFR024()

Local 	cQry		:= ""

Private cString    	:= "SB1"
Private wnrel      	:= "EDFR024"
Private aOrd       	:= {"Filial"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Relatorio de Compras"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Relatorio de Compras", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR024"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR024"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR024"
Private _nlin      	:= 70
Private Cabec1     	:= " "
Private Cabec2     	:= " "
Private cAlias 		:= GetNextAlias()

CriaSx1()

IF !Pergunte(cPerg,.T.)
	RETURN
ENDIF

If LastKey() == 27
	Return
Endif

cQry := " SELECT F1_DOC, F1_ESPECIE, D1_COD, D1_CONTA, D1_XDESCRI, F1_FORNECE, F1_LOJA, A2_NOME, D1_TES, F1_DTDIGIT, F1_EMISSAO, E2_VENCREA
cQry += " ,CASE WHEN D1_VALIRR <> 0 THEN D1_VALIRR ELSE VALIRRF END VALIRRF"+CENT
cQry += " ,CASE WHEN D1_VALISS <> 0 THEN D1_VALISS ELSE VALISS END VALISS"+CENT
cQry += " ,CASE WHEN D1_VALINS <> 0 THEN D1_VALINS ELSE VALINSS END VALINSS"+CENT
cQry += " ,CASE WHEN D1_VALPIS <> 0 THEN D1_VALPIS ELSE VALPIS END VALPIS"+CENT
cQry += " ,CASE WHEN D1_VALCOF <> 0 THEN D1_VALCOF ELSE VALCOF END VALCOF"+CENT
cQry += " ,CASE WHEN D1_VALCSL <> 0 THEN D1_VALCSL ELSE VALCSLL END VALCSLL"+CENT
cQry += " ,CASE WHEN D1_VALCSL = 0 AND VALPCC <> 0 THEN VALPCC ELSE 0 END VALPCC"+CENT
cQry += " ,D1_TOTAL, D1_CC, D1_CLVL, D1_ITEMCTA, F1_FILIAL, D1_ITEM, F1_SERIE, E2_NATUREZ AS ED_CODIGO, ED_DESCRIC, A2_CGC, E2_BAIXA"+CENT
cQry += " ,CASE WHEN D1_VALCSL <> 0 THEN D1_TOTAL-(D1_VALIRR+D1_VALISS+D1_VALINS+D1_VALPIS+D1_VALCOF+D1_VALCSL) ELSE D1_TOTAL-(VALIRRF+VALISS+VALINSS+VALPIS+VALCOF+VALCSLL) END VALLIQ"+CENT
cQry += " FROM"+CENT
cQry += " (SELECT F1_FILIAL, F1_DOC, D1_COD, D1_CONTA, D1_XDESCRI, F1_FORNECE, F1_LOJA, A2_NOME, D1_TES, F1_DTDIGIT, F1_EMISSAO, D1_CC, D1_CLVL, D1_ITEMCTA, F1_SERIE, D1_TOTAL, F1_ESPECIE, D1_ITEM, A2_CGC"+CENT
cQry += " ,D1_VALPIS, D1_VALCOF, D1_VALCSL, D1_VALISS, D1_VALINS, D1_VALIRR"+CENT
cQry += " FROM "+RetSqlName("SF1")+" SF1, "+RetSqlName("SD1")+" SD1, "+RetSqlName("SA2")+" SA2 "+CENT
cQry += " WHERE F1_DOC = D1_DOC"+CENT
cQry += " AND F1_SERIE = D1_SERIE"+CENT
cQry += " AND F1_FORNECE = D1_FORNECE"+CENT
cQry += " AND F1_LOJA = D1_LOJA "+CENT
cQry += " AND F1_FORNECE = A2_COD"+CENT
cQry += " AND F1_LOJA = A2_LOJA"+CENT
cQry += " AND F1_DTDIGIT BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"+CENT
cQry += " AND A2_XDESCGR NOT IN ('000001','000003')"
If	!Empty(MV_PAR03)
	cQry += " AND F1_FORNECE = '"+MV_PAR03+"'"+CENT
EndIf
If	!Empty(MV_PAR04)
	cQry += " AND F1_LOJA = '"+MV_PAR04+"'"+CENT
EndIf
If	!Empty(MV_PAR05)
	cQry += " AND D1_CONTA = '"+MV_PAR05+"'"+CENT
EndIf
If	!Empty(MV_PAR06)
	If	!Empty(MV_PAR07)
		cQry += " AND F1_FILIAL BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'"+CENT
	Else
		cQry += " AND F1_FILIAL = '"+MV_PAR06+"'"+CENT
	EndIf
EndIf
If	!Empty(MV_PAR08)
	cQry += " AND D1_CC = '"+MV_PAR08+"'"+CENT
EndIf
If	!Empty(MV_PAR09)
	cQry += " AND D1_CLVL = '"+MV_PAR09+"'"+CENT
EndIf
If	!Empty(MV_PAR10)
	cQry += " AND D1_ITEMCTA = '"+MV_PAR10+"'"+CENT
EndIf
cQry += " AND SF1.D_E_L_E_T_ = ''"+CENT
cQry += " AND SD1.D_E_L_E_T_ = ''"+CENT
cQry += " AND SA2.D_E_L_E_T_ = '')"+CENT
cQry += " AS TIT"+CENT
cQry += " LEFT JOIN"+CENT
cQry += " (SELECT E2_FILORIG AS FILIAL"+CENT
cQry += " ,E2_FORNECE AS FORNECE"+CENT
cQry += " ,E2_LOJA AS LOJA"+CENT
cQry += " ,E2_NOMFOR AS NREDUZ"+CENT
cQry += " ,E2_VALOR AS VALOR"+CENT
cQry += " ,E2_TITPAI, E2_PREFIXO AS PRF, E2_TIPO AS TIPO, E2_PARCELA AS PARC, E2_NUM AS NUM, E2_EMISSAO, E2_VENCREA, E2_BAIXA, E2_NATUREZ"+CENT
cQry += " ,(E2_VALOR+E2_IRRF+E2_INSS+E2_ISS+E2_SEST) VALBASE"+CENT
cQry += " ,E2_VALLIQ AS VALLIQ"+CENT
cQry += " ,ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'INSS'   AND D_E_L_E_T_ <> '*'),0) VALINSS"+CENT
cQry += " ,ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'IRF'    AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) VALIRRF"+CENT
cQry += " ,ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'ISS'    AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) VALISS"+CENT
cQry += " ,CASE WHEN E2_PIS    <> 0 THEN E2_PIS    ELSE ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'PIS'    AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) END VALPIS"+CENT
cQry += " ,CASE WHEN E2_COFINS <> 0 THEN E2_COFINS ELSE ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'COFINS' AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) END VALCOF"+CENT
cQry += " ,CASE WHEN E2_CSLL   <> 0 THEN E2_CSLL   ELSE ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'CSLL'   AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) END VALCSLL"+CENT
cQry += " ,CASE WHEN E2_CSLL   = 0  THEN ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'PCC'    AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) ELSE 0 END VALPCC"+CENT
cQry += " ,(SELECT ED_DESCRIC FROM "+RetSqlName("SED")+" WHERE E2_NATUREZ=ED_CODIGO AND D_E_L_E_T_ = '') AS ED_DESCRIC"+CENT
cQry += " FROM "+RetSqlName("SE2")+" TITULO "+CENT
cQry += " WHERE D_E_L_E_T_ <> '*'"+CENT
cQry += " AND E2_FILORIG  BETWEEN '  ' AND 'ZZ')"+CENT
cQry += " AS SE2"+CENT
cQry += " ON TIT.F1_FILIAL = SE2.FILIAL AND TIT.F1_DOC = SE2.NUM AND TIT.F1_SERIE = SE2.PRF AND TIT.F1_FORNECE = SE2.FORNECE AND TIT.F1_LOJA = SE2.LOJA "+CENT

cQry += " UNION "+CENT

cQry += " SELECT NUM AS F1_DOC, PRF AS F1_ESPECIE, '' AS D1_COD, ED_CONTA AS D1_CONTA, '' AS D1_XDESCRI, E2_FORNECE AS F1_FORNECE, E2_LOJA AS F1_LOJA, E2_NOMFOR AS A2_NOME, '' AS D1_TES, E2_EMISSAO AS F1_DTDIGIT, E2_EMISSAO AS F1_EMISSAO, E2_VENCREA, 0  AS VALIRRF, 0 AS VALISS, 0 AS VALINSS, 0 AS VALPIS, 0 AS VALCOF, 0 AS VALCSLL, 0 AS VALPCC, VALOR AS D1_TOTAL, E2_CCUSTO AS D1_CC, E2_CLVL AS D1_CLVL, E2_ITEMCTA AS D1_ITEMCTA, FILIAL AS F1_FILIAL, '' AS D1_ITEM, E2_PREFIXO AS F1_SERIE, E2_NATUREZ AS ED_CODIGO, ED_DESCRIC, A2_CGC, E2_BAIXA, VALLIQ"+CENT
cQry += " FROM"+CENT
cQry += " (SELECT E2_FILORIG AS FILIAL"+CENT
cQry += " ,E2_FORNECE AS FORNECE"+CENT
cQry += " ,E2_LOJA AS LOJA"+CENT
cQry += " ,E2_NOMFOR AS NREDUZ"+CENT
cQry += " ,E2_VALOR AS VALOR"+CENT
cQry += " ,E2_TITPAI, E2_PREFIXO AS PRF, E2_TIPO AS TIPO, E2_PARCELA AS PARC, E2_NUM AS NUM, E2_EMISSAO, E2_VENCREA, E2_BAIXA"+CENT
cQry += " ,(E2_VALOR+E2_IRRF+E2_INSS+E2_ISS+E2_SEST) VALBASE"+CENT
cQry += " ,E2_VALLIQ  AS VALLIQ"+CENT
cQry += " ,(SELECT ED_DESCRIC FROM "+RetSqlName("SED")+" WHERE E2_NATUREZ=ED_CODIGO AND D_E_L_E_T_ = '') AS ED_DESCRIC"+CENT
cQry += " ,(SELECT ED_CONTA FROM "+RetSqlName("SED")+" WHERE E2_NATUREZ=ED_CODIGO AND D_E_L_E_T_ = '') AS ED_CONTA"+CENT
cQry += " ,E2_PREFIXO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_CCUSTO,E2_CLVL,E2_ITEMCTA,E2_FILORIG,A2_CGC,E2_NATUREZ"+CENT
cQry += " FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2"+CENT
cQry += " WHERE SE2.D_E_L_E_T_ <> '*'"+CENT
cQry += " AND SA2.D_E_L_E_T_ <> '*'"+CENT
cQry += " AND E2_FORNECE = A2_COD"+CENT
cQry += " AND E2_LOJA = A2_LOJA"+CENT
cQry += " AND E2_FILORIG BETWEEN '  ' AND 'ZZ'"+CENT
// cQry += " AND E2_TITPAI = ''"+CENT
cQry += " AND E2_TIPO <> 'FT '
cQry += " AND E2_PREFIXO NOT IN ('USI','EFF')
cQry += " AND A2_XDESCGR NOT IN ('000001','000003')"
cQry += " AND E2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"+CENT
If	!Empty(MV_PAR03)
	cQry += " AND E2_FORNECE = '"+MV_PAR03+"'"+CENT
EndIf
If	!Empty(MV_PAR04)
	cQry += " AND E2_LOJA = '"+MV_PAR04+"'"+CENT
EndIf
If	!Empty(MV_PAR06)
	If	!Empty(MV_PAR07)
		cQry += " AND E2_FILORIG BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"'"+CENT
	Else
		cQry += " AND E2_FILORIG = '"+MV_PAR06+"'"+CENT
	EndIf
EndIf
If	!Empty(MV_PAR08)
	cQry += " AND E2_CCUSTO = '"+MV_PAR08+"'"+CENT
EndIf
If	!Empty(MV_PAR09)
	cQry += " AND E2_CLVL = '"+MV_PAR09+"'"+CENT
EndIf
If	!Empty(MV_PAR10)
	cQry += " AND E2_ITEMCTA = '"+MV_PAR10+"'"+CENT
EndIf
If	!Empty(MV_PAR05)
	cQry += " AND (SELECT ED_CONTA FROM "+RetSqlName("SED")+" WHERE E2_NATUREZ=ED_CODIGO AND D_E_L_E_T_ = '') = "+MV_PAR05+"'" +CENT
EndIf
cQry += " AND NOT EXISTS (SELECT F1_DOC FROM "+RetSqlName("SF1")+" WHERE E2_NUM = F1_DOC AND E2_PREFIXO = F1_SERIE AND E2_FORNECE = F1_FORNECE AND E2_LOJA = F1_LOJA AND D_E_L_E_T_ <> '*'))"+CENT
cQry += " AS TIT_MAN"+CENT
cQry += " ORDER BY F1_FILIAL,F1_FORNECE,F1_LOJA"+CENT

If Select(cAlias) > 0
	dbselectarea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

MemoWrite("C:\Tmp\EDFR024.txt",cQry)
cQry := ChangeQuery(cQry)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),cAlias,.F.,.T.)
dbselectarea(cAlias)
(cAlias)->(DbGoTop())

Processa ( { ||  GeraPlan()  } )

If Select(cAlias) > 0
	dbselectarea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

Return

**************************
Static Function GeraPlan()
**************************

Local oExcel
Local cArq
Local nArq
Local cPath
Local cXml 	:= ""
Local ncount := 0
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

nLin := 500
While !(cAlias)->(EOf())
	nLin ++
	(cAlias)->(DbSkip())
End

ProcRegua(nLin-500)

(cAlias)->(DbGotop())

If !(cAlias)->(EOf())
	cXml := '<?xml version="1.0"?>'+CENT
	cXml += '<?mso-application progid="Excel.Sheet"?>'+CENT
	cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
	cXml += 'xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT
	cXml += 'xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT
	cXml += 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
	cXml += 'xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT
	cXml += '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT
	cXml += '<Author>Luis Filipe Nascimento</Author>'+CENT
	cXml += '<LastAuthor>Luis Filipe Nascimento</LastAuthor>'+CENT
	cXml += '<Created>2016-05-19T14:01:06Z</Created>'+CENT
	cXml += '<LastSaved>2018-06-20T13:46:21Z</LastSaved>'+CENT
	cXml += '<Version>15.00</Version>'+CENT
	cXml += '</DocumentProperties>'+CENT
	cXml += '<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CENT
	cXml += '<AllowPNG/>'+CENT
	cXml += '</OfficeDocumentSettings>'+CENT
	cXml += '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
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
	cXml += '  <Style ss:ID="s62">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s63">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s64">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s65">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s66">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s67">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s69">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s73">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s74">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s75">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s76">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s77">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s78">'+CENT
	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s79">'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s80">'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s81">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += ' </Styles>'+CENT
	cXml += ' <Worksheet ss:Name="Parametros">'+CENT
	cXml += '  <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="10" x:FullColumns="1"'+CENT
	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
	cXml += '   <Column ss:Width="83.25"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="132"/>'+CENT
	
	cMVPAR01 	:= If(!Empty(MV_PAR01),SubStr(DtoS(MV_PAR01),1,4)+"-"+SubStr(DtoS(MV_PAR01),5,2)+"-"+SubStr(DtoS(MV_PAR01),7,2)+"T00:00:00.000","")
	cMVPAR02 	:= If(!Empty(MV_PAR02),SubStr(DtoS(MV_PAR02),1,4)+"-"+SubStr(DtoS(MV_PAR02),5,2)+"-"+SubStr(DtoS(MV_PAR02),7,2)+"T00:00:00.000","")
	
	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
	cXml += '    <Cell ss:StyleID="s62"><Data ss:Type="String">Dt. Digitacao De</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="DateTime">'+cMVPAR01+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Dt. Digitacao Ate</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="DateTime">'+cMVPAR02+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Fornecedor De</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+MV_PAR03+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Loja</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+MV_PAR04+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Cta. Contabil</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+MV_PAR05+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Filial De</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+MV_PAR06+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Filial Ate</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+MV_PAR07+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">C.Custo</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+MV_PAR08+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Classe Valor</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+MV_PAR09+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">Item Contabil</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s67"><Data ss:Type="String">'+MV_PAR10+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '  </Table>'+CENT
	cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
	cXml += '   <PageSetup>'+CENT
	cXml += '    <Header x:Margin="0.31496062000000002"/>'+CENT
	cXml += '    <Footer x:Margin="0.31496062000000002"/>'+CENT
	cXml += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT
	cXml += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT
	cXml += '   </PageSetup>'+CENT
	cXml += '   <Unsynced/>'+CENT
	cXml += '   <Panes>'+CENT
	cXml += '    <Pane>'+CENT
	cXml += '     <Number>3</Number>'+CENT
	cXml += '     <ActiveRow>4</ActiveRow>'+CENT
	cXml += '     <ActiveCol>2</ActiveCol>'+CENT
	cXml += '    </Pane>'+CENT
	cXml += '   </Panes>'+CENT
	cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
	cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
	cXml += '  </WorksheetOptions>'+CENT
	cXml += ' </Worksheet>'+CENT
	cXml += ' <Worksheet ss:Name="Relatorio">'+CENT
	cXml += '  <Table ss:ExpandedColumnCount="27" ss:ExpandedRowCount="'+Alltrim(Str(nLin))+'" x:FullColumns="1"'+CENT
	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
	cXml += '   <Column ss:Width="32.25"/>'+CENT
	cXml += '   <Column ss:Width="66.75"/>'+CENT
	cXml += '   <Column ss:Width="42"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="207.75"/>'+CENT
	cXml += '   <Column ss:Width="108.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="101.25"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="229.5"/>'+CENT
	cXml += '   <Column ss:Width="69"/>'+CENT
	cXml += '   <Column ss:Width="27.75"/>'+CENT
	cXml += '   <Column ss:Width="214.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="118.5"/>'+CENT
	cXml += '   <Column ss:Width="21"/>'+CENT
	cXml += '   <Column ss:Width="57"/>'+CENT
	cXml += '   <Column ss:Width="56.25" ss:Span="1"/>'+CENT
	cXml += '   <Column ss:Index="16" ss:AutoFitWidth="0" ss:Width="81"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="75.75" ss:Span="5"/>'+CENT
	cXml += '   <Column ss:Index="23" ss:AutoFitWidth="0" ss:Width="54.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="72.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="102"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="85.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="102.75"/>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
	cXml += '    <Cell ss:MergeAcross="25" ss:StyleID="s69"><Data ss:Type="String">RELATORIO DE COMPRAS</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Emissao: '+DtoC(dDatabase)+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="30.75">'+CENT
	cXml += '    <Cell ss:StyleID="s74"><Data ss:Type="String">FILIAL</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">DOCUMENTO</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">ESPECIE</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">NATUREZA</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">PRODUTO</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">CONTA CONTABIL</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">DESCRICAO DO PRODUTO</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">CODIGO FORNECEDOR</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">LOJA</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">RAZAO SOCIAL</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">CNPJ</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">TES</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">DIGITACAO</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">EMISSAO</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">VENCTO</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">TOTAL ITEM</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">IR</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">ISS</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">INSS</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">PIS</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">COF</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">CSLL</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">DT. BAIXA </Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">VLR. LIQUIDO DE BAIXA</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">CENTRO DE CUSTO</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">CLASSE. VALOR</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s77"><Data ss:Type="String">ITEM CONTABIL</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	While !(cAlias)->(EOf())
		
		ncount ++
		ncountq ++
		
		IncProc("Imprimindo RelatÛrio - "+Alltrim(STR(ncount))+" / "+Alltrim(STR(nLin-150))+" Registros...")
		
		cDTDIGIT  	:= SubStr((cAlias)->F1_DTDIGIT,1,4)+"-"+SubStr((cAlias)->F1_DTDIGIT,5,2)+"-"+SubStr((cAlias)->F1_DTDIGIT,7,2)+"T00:00:00.000"
		cEMISSAO  	:= SubStr((cAlias)->F1_EMISSAO,1,4)+"-"+SubStr((cAlias)->F1_EMISSAO,5,2)+"-"+SubStr((cAlias)->F1_EMISSAO,7,2)+"T00:00:00.000"
		cVENCREA  	:= If(!Empty((cAlias)->E2_VENCREA),SubStr((cAlias)->E2_VENCREA,1,4)+"-"+SubStr((cAlias)->E2_VENCREA,5,2)+"-"+SubStr((cAlias)->E2_VENCREA,7,2)+"T00:00:00.000",'')
		cBAIXA    	:= If(!Empty((cAlias)->E2_BAIXA),SubStr((cAlias)->E2_BAIXA,1,4)+"-"+SubStr((cAlias)->E2_BAIXA,5,2)+"-"+SubStr((cAlias)->E2_BAIXA,7,2)+"T00:00:00.000",'')
		
		// Rateio
		SDE->(DbSetOrder(1))
		If !SDE->(DbSeek((cAlias)->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+D1_ITEM)))
			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->F1_FILIAL+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->F1_DOC+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->F1_ESPECIE+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->ED_CODIGO+' - '+(cAlias)->ED_DESCRIC+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->D1_COD+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->D1_CONTA+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->D1_XDESCRI+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->F1_FORNECE+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->F1_LOJA+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->A2_NOME+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->A2_CGC+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->D1_TES+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cDTDIGIT+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cEMISSAO+'</Data></Cell>'+CENT 
			If !Empty(cVENCREA)
				cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cVENCREA+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->D1_TOTAL ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALIRRF ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALISS ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALINSS ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
			If	(cAlias)->VALPCC == 0
				cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALPIS ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALCOF ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALCSLL ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform(0 ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform(0 ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALPCC ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
			EndIf
			If !Empty(cBAIXA)
				cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cBAIXA+'</Data></Cell>'+CENT 
			Else
				cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALLIQ ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->D1_CC+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->D1_CLVL+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->D1_ITEMCTA+'</Data></Cell>'+CENT
			cXml += '   </Row>'+CENT
		EndIf
	   
		While (cAlias)->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+D1_ITEM) == SDE->(DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF) .and. SDE->(!Eof())
			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->F1_FILIAL+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->F1_DOC+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->F1_ESPECIE+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->ED_CODIGO+' - '+(cAlias)->ED_DESCRIC+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->D1_COD+'</Data></Cell>'+CENT
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+(cAlias)->D1_COD))
			If	!Empty(SDE->DE_CONTA)
				cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+SDE->DE_CONTA+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+SB1->B1_CONTA+'</Data></Cell>'+CENT
			EndIf
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->D1_XDESCRI+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->F1_FORNECE+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->F1_LOJA+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->A2_NOME+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->A2_CGC+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAlias)->D1_TES+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cDTDIGIT+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cEMISSAO+'</Data></Cell>'+CENT
			If !Empty(cVENCREA)
				cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cVENCREA+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform(SDE->DE_CUSTO1 ,"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALIRRF * (SDE->DE_PERC/100),"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALISS * (SDE->DE_PERC/100),"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALINSS * (SDE->DE_PERC/100),"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALPIS * (SDE->DE_PERC/100),"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALCOF * (SDE->DE_PERC/100),"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALCSLL * (SDE->DE_PERC/100),"@E 99,999,999.99")+'</Data></Cell>'+CENT

			If !Empty(cBAIXA)
				cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cBAIXA+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAlias)->VALLIQ * (SDE->DE_PERC/100),"@E 99,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+SDE->DE_CC+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+SDE->DE_CLVL+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+SDE->DE_ITEMCTA+'</Data></Cell>'+CENT
			cXml += '   </Row>'+CENT

			SDE->(DbSkip())
		End

		(cAlias)->(DbSkip())
		
		If	ncountq >= 150 .or. (cAlias)->(Eof())
			FWrite(nArq,cXml)
			cXml := ""
			ncountq := 0
		EndIf
		
	End
	
	cXml += '  </Table>'+CENT
	cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
	cXml += '   <PageSetup>'+CENT
	cXml += '    <Header x:Margin="0.31496062000000002"/>'+CENT
	cXml += '    <Footer x:Margin="0.31496062000000002"/>'+CENT
	cXml += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT
	cXml += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT
	cXml += '   </PageSetup>'+CENT
	cXml += '   <Unsynced/>'+CENT
	cXml += '   <Print>'+CENT
	cXml += '    <ValidPrinterInfo/>'+CENT
	cXml += '    <PaperSizeIndex>9</PaperSizeIndex>'+CENT
	cXml += '    <HorizontalResolution>-3</HorizontalResolution>'+CENT
	cXml += '    <VerticalResolution>-3</VerticalResolution>'+CENT
	cXml += '   </Print>'+CENT
	cXml += '   <Selected/>'+CENT
	cXml += '   <FreezePanes/>'+CENT
	cXml += '   <FrozenNoSplit/>'+CENT
	cXml += '   <SplitHorizontal>2</SplitHorizontal>'+CENT
	cXml += '   <TopRowBottomPane>2</TopRowBottomPane>'+CENT
	cXml += '   <SplitVertical>3</SplitVertical>'+CENT
	cXml += '   <LeftColumnRightPane>17</LeftColumnRightPane>'+CENT
	cXml += '   <ActivePane>0</ActivePane>'+CENT
	cXml += '   <Panes>'+CENT
	cXml += '    <Pane>'+CENT
	cXml += '     <Number>3</Number>'+CENT
	cXml += '    </Pane>'+CENT
	cXml += '    <Pane>'+CENT
	cXml += '     <Number>1</Number>'+CENT
	cXml += '     <ActiveCol>3</ActiveCol>'+CENT
	cXml += '    </Pane>'+CENT
	cXml += '    <Pane>'+CENT
	cXml += '     <Number>2</Number>'+CENT
	cXml += '    </Pane>'+CENT
	cXml += '    <Pane>'+CENT
	cXml += '     <Number>0</Number>'+CENT
	cXml += '     <ActiveRow>0</ActiveRow>'+CENT
	cXml += '     <ActiveCol>26</ActiveCol>'+CENT
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

//         1           2      3                        4                       5                        6           7     8   9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38  39  40  41  42  43
AADD(aSx1,{"EDFR024" , "01" , "Dt.DigitaÁ„o De    ?" , "Dt.DigitaÁ„o De   ?" , "Dt.DigitaÁ„o De    ?" , "mv_ch1" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "" , "", "", "", ""})
AADD(aSx1,{"EDFR024" , "02" , "Dt.DigitaÁ„o Ate   ?" , "Dt.DigitaÁ„o Ate  ?" , "Dt.DigitaÁ„o Ate   ?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "" , "", "", "", ""})
AADD(aSx1,{"EDFR024" , "03" , "Fornecedor         ?" , "Fornecedor        ?" , "Fornecedor         ?" , "mv_ch3" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SAA2" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR024" , "04" , "Loja               ?" , "Loja              ?" , "Loja               ?" , "mv_ch4" , "C" , 02 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "" , "", "", "", ""})
AADD(aSx1,{"EDFR024" , "05" , "Conta Cont·bil	  ?" , "Conta Cont·bil    ?" , "Conta Cont·bil	   ?" , "mv_ch5" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1"  , "" , "", "", "", ""})
AADD(aSx1,{"EDFR024" , "06" , "Filial De     	  ?" , "Filial De  		  ?" , "Filial De     	   ?" , "mv_ch6" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par06" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "XM0"  , "" , "", "", "", ""})
AADD(aSx1,{"EDFR024" , "07" , "Filial Ate    	  ?" , "Filial Ate 		  ?" , "Filial Ate    	   ?" , "mv_ch7" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par07" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "XM0"  , "" , "", "", "", ""})
AADD(aSx1,{"EDFR024" , "08" , "Centro Custo  	  ?" , "Centro Custo      ?" , "Centro Custo  	   ?" , "mv_ch8" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par08" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CTT"  , "" , "", "", "", ""})
AADD(aSx1,{"EDFR024" , "09" , "Classe Valor  	  ?" , "Classe Valor      ?" , "Classe Valor  	   ?" , "mv_ch9" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par09" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CTH"  , "" , "", "", "", ""})
AADD(aSx1,{"EDFR024" , "10" , "Item Contabil 	  ?" , "Item Contabil     ?" , "Item Contabil 	   ?" , "mv_cha" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par10" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CTD"  , "" , "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR024   10")
	
	DbSeek("EDFR024")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR024"
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
