#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥ EDFR021     ≥ Autor ≥ Luis Felipe Mattos	≥ Data ≥ 15.10.15 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Relatorio Stock Report            				 		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 		 ≥ Gera Excel - Contratos			                      	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum													  ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function EDFR021()

Local 	nOrdem
Local 	cQuery		:= ""
Private   cAliasQry := GetNextAlias()
Private cString    	:= "SZ3"
Private wnrel      	:= "EDFR021"
Private aOrd       	:= {"Comprador"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Relatorio Stock Report"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Relatorio Stock Report", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR021"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR021"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR021"
Private _nlin      	:= 70
Private Cabec1     	:= " "
Private Cabec2     	:= " "
Private nCountnx    := 0
Private nCountny    := 1  
Private aPgtos		:= {}
Public  aForCtr		:= Nil

CriaSx1()

IF !Pergunte(cPerg,.T.)
	RETURN
ENDIF

If LastKey() == 27
	Return
Endif

MV_PAR07 := If(Empty(MV_PAR07),Ddatabase,MV_PAR07)

cQuery := " SELECT DISTINCT CN9_XFORNE"+CENT
cQuery += "                 , Z3_CONTRA, Z3_PERIODO, Z3_DTINIC, Z3_DTFIM, Z3_DTINEM, Z3_DTFIEM, Z3_QUANT"+CENT
cQuery += " 				, TIPO"+CENT
cQuery += " 				, B2_QTSEGUM"+CENT
cQuery += " 				, Z2_INCOTER"+CENT
cQuery += " 				, Case When Z6_VLFINAL <> 0 Then Z6_VLFINAL Else Z6_VLFINALP End Z6_VLFINAL"+CENT
cQuery += " 				, Z6_VLFINAL"+CENT
cQuery += " 				, E2_QTDTON, E2_VLFINAL"+CENT
cQuery += " 				, B2_FILIAL, B2_LOCAL"+CENT
cQuery += " 				, ZE_NOME  "+CENT
cQuery += " 				, Case When Len(Rtrim(B2_LOCAL)) = 2 THEN 1 ELSE 2 END ORDEM"+CENT
cQuery += " 				, B2_COD"+CENT
cQuery += " FROM"+CENT
cQuery += " (SELECT  CN9_XFORNE, Z3_CONTRA, Z3_PERIODO, Z3_DTINIC, Z3_DTFIM, Z3_DTINEM, Z3_DTFIEM, Z3_QUANT"+CENT
cQuery += " ,(CASE WHEN BM_DESC LIKE '%VHP%' THEN 'VHP' ELSE (CASE WHEN BM_DESC LIKE '%XTL%' THEN 'XTL' ELSE 'REF' END) END) TIPO"+CENT
cQuery += " ,B2_FILIAL, B2_LOCAL, B2_QTSEGUM, B2_COD"+CENT
cQuery += " ,(SELECT TOP 1 Z2_INCOTER FROM "+RetSqlName("SZ2")+" WHERE RTRIM(Z3_CONTRA)+'-'+RTRIM(Z3_PERIODO) = Z2_CODPRO AND D_E_L_E_T_ = '') AS Z2_INCOTER  "+CENT
cQuery += " ,(SELECT TOP 1 Z6_VLFINAL FROM "+RetSqlName("SZ6")+" WHERE Z3_CONTRA = Z6_CONTRA AND Z3_PERIODO = Z6_PERDE AND Z6_TIPOPRE = '2'"+If(!Empty(MV_PAR07)," AND Z6_DATA <= '"+DtoS(MV_PAR07)+"'","")+ " AND D_E_L_E_T_ = '') AS Z6_VLFINAL"+CENT
cQuery += " ,(SELECT TOP 1 Z6_VLFINAL FROM "+RetSqlName("SZ6")+" WHERE Z3_CONTRA = Z6_CONTRA AND Z3_PERIODO = Z6_PERDE AND Z6_TIPOPRE = '1'"+If(!Empty(MV_PAR07)," AND Z6_DATA <= '"+DtoS(MV_PAR07)+"'","")+ " AND D_E_L_E_T_ = '') AS Z6_VLFINALP"+CENT
cQuery += " ,(SELECT SUM(E2_QTDTON)   FROM "+RetSqlName("SE2")+" WHERE B1_COD = E2_XCONTRA AND E2_XLOCAL = B2_LOCAL "+If(!Empty(MV_PAR07),"AND E2_VENCREA <= '"+DtoS(MV_PAR07)+"'",+"")+ " AND D_E_L_E_T_ = '' GROUP BY E2_XCONTRA) AS E2_QTDTON"+CENT
cQuery += " ,(SELECT SUM(E2_VLFINAL)  FROM "+RetSqlName("SE2")+" WHERE B1_COD = E2_XCONTRA AND E2_XLOCAL = B2_LOCAL "+If(!Empty(MV_PAR07),"AND E2_VENCREA <= '"+DtoS(MV_PAR07)+"'",+"")+ " AND D_E_L_E_T_ = '' GROUP BY E2_XCONTRA) AS E2_VLFINAL"+CENT
cQuery += " FROM "+RetSqlName("SZ3")+" SZ3, "+RetSqlName("CN9")+" CN9, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SBM")+" SBM, "+RetSqlName("SB2")+" SB2"+CENT
cQuery += " WHERE B2_FILIAL = '"+xFilial("SB2")+"'"+CENT
cQuery += " AND Z3_CONTRA = CN9_NUMERO"+CENT
cQuery += " AND B1_GRUPO = BM_GRUPO"+CENT
cQuery += " AND RTRIM(Z3_CONTRA)+'-'+RTRIM(Z3_PERIODO) = RTRIM(B1_COD)"+CENT
cQuery += " AND B1_COD = B2_COD"+CENT
cQuery += " AND CN9_SITUAC = '05'"+CENT
cQuery += " AND B1_DESC NOT LIKE '%SACARIA%'"+CENT                                              

If !Empty(MV_PAR01)
	cQuery += "	AND CN9_XFORNE Like '%"+Alltrim(MV_PAR01)+"%'"+CENT
EndIf

If !Empty(MV_PAR02)
	cQuery += "	AND SUBSTRING(B2_LOCAL,1,2) = '"+Alltrim(MV_PAR02)+"'"+CENT
EndIf

If !Empty(MV_PAR03)
	cQuery += "	AND B2_FILIAL = '"+Alltrim(MV_PAR03)+"'"+CENT
EndIf

If !Empty(MV_PAR05)  
	cQuery += "	AND Z3_CONTRA = '"+Alltrim(MV_PAR05)+"'"+CENT
EndIf

If !Empty(MV_PAR06)  
	cQuery += "	AND Z3_PERIODO = '"+Alltrim(MV_PAR06)+"'"+CENT
EndIf

/* 27/05/16 - Luis Felipe
If !Empty(MV_PAR07)  
	cQuery += "	AND Z3_DTFIM <= '"+DtoS(LastDay(MV_PAR07))+"'"+CENT
EndIf
*/

cQuery += " AND SZ3.D_E_L_E_T_ = ''"+CENT
cQuery += " AND CN9.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SB1.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SBM.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SB2.D_E_L_E_T_ = '')"+CENT
cQuery += " AS SZ3"+CENT

cQuery += " LEFT JOIN"+CENT
cQuery += " (SELECT ZE_LOCAL, ZE_NOME FROM "+RetSqlName("SZE")+" WHERE D_E_L_E_T_ = '')"+CENT
cQuery += " AS SZE"+CENT
cQuery += " ON RTRIM(ZE_LOCAL) = SUBSTRING(B2_LOCAL,1,2)"+CENT


If !Empty(MV_PAR04)
	cQuery += "	WHERE TIPO = "+Alltrim(MV_PAR04)+CENT
EndIf

cQuery += " ORDER BY ORDEM, Z3_CONTRA, Z3_PERIODO, B2_LOCAL"+CENT

MemoWrite("C:\Tmp\EDFR021.txt",cQuery)
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
Local nLin := 15    
Local nCont:= 0 
Local nQTSEGUM 	:= 0
Local nVLRUSD  	:= 0
Local nQTSEGUMTR:= 0
Local nVLRUSDTR := 0

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

If !(cAliasQry)->(EOF())
	
	While !(cAliasQry)->(EOf())
		nLin ++
	 	(cAliasQry)->(DbSkip())
	End
	
	ProcRegua(nLin)
	
	(cAliasQry)->(DbGotop())

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
	cXml += '  <Created>2015-10-14T20:00:31Z</Created>'+CENT
	cXml += '  <LastSaved>2015-10-15T13:18:01Z</LastSaved>'+CENT
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
  	cXml += '  <Style ss:ID="s16" ss:Name="Normal 3 2">'+CENT
  	cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss"/>'+CENT
 	cXml += '   <Interior/>'+CENT
 	cXml += '   <NumberFormat/>'+CENT
 	cXml += '   <Protection/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s17" ss:Name="Normal_Estoque Man Br Alt">'+CENT
  	cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior/>'+CENT
 	cXml += '   <NumberFormat/>'+CENT
 	cXml += '   <Protection/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="m784132252096">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m784132252116">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="m784132252136">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s18" ss:Parent="s16">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="dd/mm/yy;@"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s19">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s20">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s21">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
  	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s22">'+CENT
 	cXml += '   <Alignment ss:Vertical="Center"/>'+CENT
 	cXml += '   <Borders/>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
  	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s23">'+CENT
 	cXml += '   <Borders/>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s24" ss:Parent="s16">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s25">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"/>'+CENT
	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s26">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"/>'+CENT
 	cXml += '   <Interior ss:Color="#000000" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;???_-;_-@_-"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s27" ss:Parent="s16">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="#,##0.000"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s28" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s29" ss:Parent="s16">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;???_-;_-@_-"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s30" ss:Parent="s16">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
  	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s31">'+CENT
	cXml += '   <Alignment ss:Vertical="Center"/>'+CENT
 	cXml += '   <Borders/>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s32">'+CENT
  	cXml += '   <Alignment ss:Vertical="Center"/>'+CENT
  	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;???_-;_-@_-"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s33">'+CENT
 	cXml += '   <Alignment ss:Vertical="Center"/>'+CENT
 	cXml += '   <Borders/>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s34">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s35">'+CENT
 	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s36">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="_(* #,##0.000_);_(* \(#,##0.000\);_(* &quot;-&quot;???_);_(@_)"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s37">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
  	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="_(* #,##0.000_);_(* \(#,##0.000\);_(* &quot;-&quot;???_);_(@_)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s38" ss:Parent="s16">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s39" ss:Parent="s16">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s40" ss:Parent="s16">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="dd/mm/yy;@"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s41" ss:Parent="s17">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s42" ss:Parent="s16">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;???_-;_-@_-"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s43" ss:Parent="s16">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="#,##0.000"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s44" ss:Parent="s16">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s45" ss:Parent="s16">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s46" ss:Parent="s16">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;???_-;_-@_-"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s47">'+CENT
  	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s48">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="dd/mm/yy;@"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s49">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s50">'+CENT
  	cXml += '   <Alignment ss:Vertical="Center"/>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s51">'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;???_-;_-@_-"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s52">'+CENT
  	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s58">'+CENT
 	cXml += '   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s59">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s60">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s61">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="#,##0.00_ ;\-#,##0.00\ "/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s62">'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="#,##0.00_ ;\-#,##0.00\ "/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s63">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
  	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="#,##0.00_ ;\-#,##0.00\ "/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s64">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
  	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="#,##0.00_ ;\-#,##0.00\ "/>'+CENT
	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s65">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="#,##0.00_ ;\-#,##0.00\ "/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s66">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="#,##0.000_ ;\-#,##0.000\ "/>'+CENT
  	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s67">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="#,##0.000_ ;\-#,##0.000\ "/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s68">'+CENT
 	cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="#,##0.00_ ;\-#,##0.00\ "/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s69">'+CENT
  	cXml += '   <Alignment ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="#,##0.000_ ;\-#,##0.000\ "/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s70">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="#,##0.00_ ;\-#,##0.00\ "/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s72">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>'+CENT
  	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s73">'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="dd/mm/yy;@"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s74">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>'+CENT
  	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s75">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>'+CENT
  	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s76">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s77">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>'+CENT
	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s78">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s79">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s80">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s86">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="13" ss:Color="#FFFFFF"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#808080" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += ' </Styles>'+CENT
 	cXml += ' <Worksheet ss:Name="Parametros">'+CENT
  	cXml += '  <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="6" x:FullColumns="1"'+CENT
    cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
	cXml += '   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="165.75"/>'+CENT
	cXml += '   <Row>'+CENT
 	cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">Usina</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">'+MV_PAR01+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
 	cXml += '   <Row>'+CENT
 	cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String">Porto</Data></Cell>'+CENT
	SZE->(DbSetOrder(3))
	SZE->(DbSeek(xFilial("SZE")+MV_PAR02))
  	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">'+SZE->ZE_NOME+'</Data></Cell>'+CENT
  	cXml += '   </Row>'+CENT
	cXml += '   <Row>'+CENT
	cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String">Filial</Data></Cell>'+CENT
	SM0->(DbSetOrder(1))
	SM0->(DbSeek('01'+MV_PAR03))
 	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">'+SM0->M0_CIDCOB+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
 	cXml += '   <Row>'+CENT
 	cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String">Produto</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">'+MV_PAR04+'</Data></Cell>'+CENT
  	cXml += '   </Row>'+CENT
  	cXml += '   <Row>'+CENT
	cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String">Contrato</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s77"><Data ss:Type="String">'+MV_PAR05+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:Height="15.75">'+CENT
 	cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">DP</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s74"><Data ss:Type="String">'+MV_PAR06+'</Data></Cell>'+CENT
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
	cXml += '     <ActiveRow>5</ActiveRow>'+CENT
	cXml += '     <ActiveCol>5</ActiveCol>'+CENT
 	cXml += '    </Pane>'+CENT
 	cXml += '   </Panes>'+CENT
 	cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
 	cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
 	cXml += '  </WorksheetOptions>'+CENT
  	cXml += ' </Worksheet>'+CENT
  	cXml += ' <Worksheet ss:Name="Stock Report">'+CENT
	cXml += '  <Table ss:ExpandedColumnCount="16" ss:ExpandedRowCount="'+Alltrim(Str(nLin))+'" x:FullColumns="1"'+CENT
	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="125.25"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="48.75"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="32.25"/>'+CENT
 	cXml += '   <Column ss:Index="8" ss:Width="33"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="92.25"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="75"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="79.5"/>'+CENT
	cXml += '   <Column ss:Index="14" ss:AutoFitWidth="0" ss:Width="70.5" ss:Span="2"/>'+CENT
	cXml += '   <Row ss:Height="18">'+CENT
 	cXml += '    <Cell ss:MergeAcross="13" ss:StyleID="s86"><Data ss:Type="String">Brasil Stock</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s72"><Data ss:Type="String">Date:</Data></Cell>'+CENT
 	cDATABASE	:= SubStr(DtoS(Ddatabase),1,4)+"-"+SubStr(DtoS(Ddatabase),5,2)+"-"+SubStr(DtoS(Ddatabase),7,2)+"T00:00:00.000"
 	cXml += '    <Cell ss:StyleID="s73"><Data ss:Type="DateTime">'+cDATABASE+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:Height="15.75">'+CENT
    If !Empty(MV_PAR07) 
	  	cXml += '    <Cell ss:MergeAcross="13" ss:StyleID="m784132252096"><Data ss:Type="String">STOCK AT THE TERMINALS X MAN BR CONTRACTS - CUT-OFF DATE: '+DtoC(MV_PAR07)+'</Data></Cell>'+CENT
	Else
	  	cXml += '    <Cell ss:MergeAcross="13" ss:StyleID="m784132252096"><Data ss:Type="String">STOCK AT THE TERMINALS X MAN BR CONTRACTS </Data></Cell>'+CENT
	EndIf  	
  	cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m784132252116"><Data ss:Type="String">PAYMENTS</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:Height="24.75">'+CENT
 	cXml += '    <Cell ss:StyleID="s38"><Data ss:Type="String">Mill</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s39"><Data ss:Type="String">Contract</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s39"><Data ss:Type="String">Deliv.</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s40"><Data ss:Type="String">Deliv Begin Date</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s40"><Data ss:Type="String">Deliv End Date</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s40"><Data ss:Type="String">Shipment Begin Date</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s40"><Data ss:Type="String">Shipment End Date</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s39"><Data ss:Type="String">Product</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s41"><Data ss:Type="String">Branch</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s39"><Data ss:Type="String">Terminal</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s42"><Data ss:Type="String">Stock (MT)</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s43"><Data ss:Type="String">FCA / FOB</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s44"><Data ss:Type="String">USD/MT</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s45"><Data ss:Type="String">Value USD</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s46"><Data ss:Type="String">Stock Paid</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s45"><Data ss:Type="String">Value USD</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	FWrite(nArq,cXml)

	ncount		:= 0 
	cXml		:= "" 
	lFez		:= .f.
	While !(cAliasQry)->(Eof())
		
		IncProc("Filtrando "+Str(ncount,5)+" registro(s) com saldo de "+Str(nLin-15,5)+ " contratos ativos ...." )

		If (cAliasQry)->ORDEM == 1
			nSaldo := u_SldSb2(Alltrim((cAliasQry)->Z3_CONTRA)+"-"+Alltrim((cAliasQry)->Z3_PERIODO),SubStr((cAliasQry)->B2_LOCAL,1,2),MV_PAR07)
        Else
			If Alltrim((cAliasQry)->B2_COD) = 'P26108-A00' 
				x:=0
			EndIf
			nSaldo := u_SldSb2(Alltrim((cAliasQry)->Z3_CONTRA)+"-"+Alltrim((cAliasQry)->Z3_PERIODO),(cAliasQry)->B2_LOCAL,MV_PAR07)
        EndIf
        
	 	If nSaldo < MV_PAR08
	 		DbSkip()
	 		Loop
	 	EndIf

		ncount += 1
 	
		cZ3_DTINIC 	:= If(!Empty((cAliasQry)->Z3_DTINIC),SubStr((cAliasQry)->Z3_DTINIC,1,4)+"-"+SubStr((cAliasQry)->Z3_DTINIC,5,2)+"-"+SubStr((cAliasQry)->Z3_DTINIC,7,2)+"T00:00:00.000","")
		cZ3_DTFIM	:= If(!Empty((cAliasQry)->Z3_DTFIM) ,SubStr((cAliasQry)->Z3_DTFIM,1,4)+"-"+SubStr((cAliasQry)->Z3_DTFIM,5,2)+"-"+SubStr((cAliasQry)->Z3_DTFIM,7,2)+"T00:00:00.000","")
		cZ3_DTINEM  := If(!Empty((cAliasQry)->Z3_DTINEM),SubStr((cAliasQry)->Z3_DTINEM,1,4)+"-"+SubStr((cAliasQry)->Z3_DTINEM,5,2)+"-"+SubStr((cAliasQry)->Z3_DTINEM,7,2)+"T00:00:00.000","")
		cZ3_DTFIEM  := If(!Empty((cAliasQry)->Z3_DTINEM),SubStr((cAliasQry)->Z3_DTFIEM,1,4)+"-"+SubStr((cAliasQry)->Z3_DTFIEM,5,2)+"-"+SubStr((cAliasQry)->Z3_DTFIEM,7,2)+"T00:00:00.000","")
         
        nCont   ++
        
		If (cAliasQry)->ORDEM == 1
			nSaldo := u_SldSb2(Alltrim((cAliasQry)->Z3_CONTRA)+"-"+Alltrim((cAliasQry)->Z3_PERIODO),SubStr((cAliasQry)->B2_LOCAL,1,2),MV_PAR07)
			nQTSEGUM += nSaldo
			nVLRUSD  += nSaldo * (cAliasQry)->Z6_VLFINAL

			cXml += '   <Row ss:Height="15.75">'+CENT
		 	cXml += '    <Cell ss:StyleID="s58"><Data ss:Type="String">'+(cAliasQry)->CN9_XFORNE+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s49"><Data ss:Type="String">'+(cAliasQry)->Z3_CONTRA+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s49"><Data ss:Type="String">'+(cAliasQry)->Z3_PERIODO+'</Data></Cell>'+CENT
		
			If !Empty(cZ3_DTINIC)
			 	cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf	

			If !Empty(cZ3_DTFIM)
			 	cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf	

			If !Empty(cZ3_DTINEM)
			  	cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="DateTime">'+cZ3_DTINEM+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf	

			If !Empty(cZ3_DTFIEM)
			  	cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="DateTime">'+cZ3_DTFIEM+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf	
	
			cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">'+(cAliasQry)->TIPO+'</Data></Cell>'+CENT
			SM0->(DbSetOrder(1))
			SM0->(DbSeek('01'+(cAliasQry)->B2_FILIAL))
			cXml += '    <Cell ss:StyleID="s37"><Data ss:Type="String">'+Alltrim(SM0->M0_CIDCOB)+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s36"><Data ss:Type="String">'+(cAliasQry)->ZE_NOME+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform(nSaldo,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s20"><Data ss:Type="String">'+(cAliasQry)->Z2_INCOTER+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform((cAliasQry)->Z6_VLFINAL,"@E 999,999,999.99")+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform(nSaldo * (cAliasQry)->Z6_VLFINAL,"@E 999,999,999.99")+'</Data></Cell>'+CENT
		  	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform((cAliasQry)->E2_QTDTON,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		  	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform((cAliasQry)->E2_VLFINAL,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '   </Row>'+CENT  
        Else
			If 	!lFez 
				cXml += '   <Row ss:Height="15.75">'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			  	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			  	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
				cXml += '    <Cell ss:StyleID="s23"/>'+CENT
				cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform(nQTSEGUM,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s21"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s22"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform(nVLRUSD,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
			  	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
				cXml += '   </Row>'+CENT
				cXml += '   <Row ss:Height="15.75">'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			  	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			  	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
				cXml += '    <Cell ss:StyleID="s23"/>'+CENT
				cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
			 	cXml += '    <Cell ss:Index="12" ss:StyleID="s47"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
			 	cXml += '    <Cell ss:Index="15" ss:StyleID="s47"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
			  	cXml += '   </Row>'+CENT
			  	cXml += '   <Row ss:Height="15.75">'+CENT
				cXml += '    <Cell ss:MergeAcross="13" ss:StyleID="m784132252136"><Data ss:Type="String">STOCK IN TRANSIT X MAN BR CONTRACTS</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s47"/>'+CENT
			 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
			 	cXml += '   </Row>'+CENT
			 	cXml += '   <Row ss:Height="24.75">'+CENT
			 	cXml += '    <Cell ss:StyleID="s38"><Data ss:Type="String">Mill</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s24"><Data ss:Type="String">Contract</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s24"><Data ss:Type="String">Deliv.</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">Deliv Begin Date</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">Deliv End Date</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">Shipment Begin Date</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s18"><Data ss:Type="String">Shipment End Date</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s24"><Data ss:Type="String">Product</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s25"><Data ss:Type="String">FROM </Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s25"><Data ss:Type="String">TO</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s26"><Data ss:Type="String"> VOLUME IN TRANSIT</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s27"><Data ss:Type="String">FCA / FOB</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s28"><Data ss:Type="String">USD/MT</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s28"><Data ss:Type="String">Value USD</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s29"><Data ss:Type="String">Stock Paid</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s30"><Data ss:Type="String">Value USD</Data></Cell>'+CENT
			 	cXml += '   </Row>'+CENT
				lFez := .t.
			EndIf
        EndIf

        If (cAliasQry)->ORDEM == 2

			nSaldo := u_SldSb2(Alltrim((cAliasQry)->Z3_CONTRA)+"-"+Alltrim((cAliasQry)->Z3_PERIODO),(cAliasQry)->B2_LOCAL,MV_PAR07)
		 	nQTSEGUMTR += nSaldo   
		 	nVLRUSDTR  += nSaldo * (cAliasQry)->Z6_VLFINAL

		 	cXml += '   <Row ss:Height="15.75">'+CENT
		 	cXml += '    <Cell ss:StyleID="s58"><Data ss:Type="String">'+(cAliasQry)->CN9_XFORNE+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s49"><Data ss:Type="String">'+(cAliasQry)->Z3_CONTRA+'</Data></Cell>'+CENT
		  	cXml += '    <Cell ss:StyleID="s49"><Data ss:Type="String">'+(cAliasQry)->Z3_PERIODO+'</Data></Cell>'+CENT

			If !Empty(cZ3_DTINIC)
			 	cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf	

			If !Empty(cZ3_DTFIM)
			 	cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf	

			If !Empty(cZ3_DTINEM)
			  	cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="DateTime">'+cZ3_DTINEM+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf	

			If !Empty(cZ3_DTFIEM)
			  	cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="DateTime">'+cZ3_DTFIEM+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s48"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf	

		 	cXml += '    <Cell ss:StyleID="s19"><Data ss:Type="String">'+(cAliasQry)->TIPO+'</Data></Cell>'+CENT
			SM0->(DbSetOrder(1))
			SM0->(DbSeek('01'+(cAliasQry)->B2_FILIAL))
		 	cXml += '    <Cell ss:StyleID="s37"><Data ss:Type="String">'+Alltrim(SM0->M0_CIDCOB)+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s36"><Data ss:Type="String">'+(cAliasQry)->ZE_NOME+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform(nSaldo,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		  	cXml += '    <Cell ss:StyleID="s20"><Data ss:Type="String">'+(cAliasQry)->Z2_INCOTER+'</Data></Cell>'+CENT
		  	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform((cAliasQry)->Z6_VLFINAL,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform(nSaldo * (cAliasQry)->Z6_VLFINAL,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s66" ss:Formula="=RC[-4]"><Data ss:Type="String">'+Transform((cAliasQry)->E2_QTDTON,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		 	cXml += '    <Cell ss:StyleID="s66" ss:Formula="=423.84*RC[-1]"><Data ss:Type="String">'+Transform((cAliasQry)->E2_VLFINAL,"@E 999,999,999.99")+'</Data></Cell>'+CENT
		 	cXml += '   </Row>'+CENT
		EndIf
        
   		(cAliasQry)->(DbSkip())

	End
	
 	cXml += '   <Row ss:Height="15.75">'+CENT
 	cXml += '    <Cell ss:Index="11" ss:StyleID="s66"><Data ss:Type="String">'+Transform(If(nQTSEGUMTR<>0,nQTSEGUMTR,nQTSEGUM),"@E 999,999,999.999")+'</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s21"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s22"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform(If(nVLRUSDTR<>0,nVLRUSDTR,nVLRUSD),"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s51"/>'+CENT
	cXml += '    <Cell ss:StyleID="s52"/>'+CENT
 	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:Height="15.75">'+CENT
 	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s32"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s33"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s23"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
  	cXml += '    <Cell ss:Index="15" ss:StyleID="s47"/>'+CENT
	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="34.5">'+CENT
 	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s32"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
	cXml += '    <Cell ss:StyleID="s31"/>'+CENT
	cXml += '    <Cell ss:Index="9" ss:StyleID="s34"><Data ss:Type="String">TOTAL MAN BR:</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s35"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform(nQTSEGUM+nQTSEGUMTR,"@E 999,999,999.999")+'</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s50"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+Transform(nVLRUSD+nVLRUSDTR,"@E 999,999,999.99")+'</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s47"/>'+CENT
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
 	cXml += '   <Selected/>'+CENT
  	cXml += '   <Panes>'+CENT
  	cXml += '    <Pane>'+CENT
	cXml += '     <Number>3</Number>'+CENT
	cXml += '     <ActiveRow>4</ActiveRow>'+CENT
 	cXml += '     <ActiveCol>3</ActiveCol>'+CENT
 	cXml += '    </Pane>'+CENT
 	cXml += '   </Panes>'+CENT
 	cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
 	cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
  	cXml += '  </WorksheetOptions>'+CENT
  	cXml += ' </Worksheet>'+CENT
	cXml += '</Workbook>'+CENT

	FWrite(nArq,cXml)

	shellExecute( "Open", cPath + cArq + ".xml", " /k dir", "C:\", 1 )
	
EndIf

FClose(nArq)

Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                        4                        5                        6           7     8   9   10  11    12   13           14      15      16      17   18   19      20      21      22      23   24        25   26   27   28   29        30   31   32   33   34   35   36   37   38        39   40  41  42   43
AADD(aSx1,{"EDFR021" , "01" , "Usina         	  ?" , "Usina         	   ?" , "Usina         	    ?" , "mv_ch1" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "Z6_FOR", "" , "", "", "" , ""})
AADD(aSx1,{"EDFR021" , "02" , "Terminal           ?" , "Terminal           ?" , "Terminal           ?" , "mv_ch2" , "C" , 02 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "SZE_2" , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR021" , "03" , "Filial             ?" , "Filial             ?" , "Filial             ?" , "mv_ch3" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "SM0EMP", "" , "", "", "" , ""})
AADD(aSx1,{"EDFR021" , "04" , "Produto            ?" , "Produto            ?" , "Produto            ?" , "mv_ch4" , "C" , 03 , 0 , 0 , "G" , "" , "mv_par04" , "VHP" , ""    , ""    , "" , "" , "XTL" , ""    , ""    , ""    , "" , "REF"   , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR021" , "05" , "Contrato           ?" , "Contrato           ?" , "Contrato           ?" , "mv_ch5" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "SZ3"   , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR021" , "06" , "DP                 ?" , "DP                 ?" , "DP                 ?" , "mv_ch6" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par06" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR021" , "07" , "Dt.de Corte        ?" , "Data de Corte      ?" , "Data de Corte      ?" , "mv_ch7" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par07" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR021" , "07" , "Volume de Corte    ?" , "Volume de Corte    ?" , "Volume de Corte    ?" , "mv_ch8" , "N" , 12 , 3 , 0 , "G" , "" , "mv_par08" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR021   08")
	
	DbSeek("EDFR021")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR021"
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
