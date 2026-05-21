#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ EDFR016     ³ Autor ³ Luis Felipe Mattos	³ Data ³ 25.11.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relação de Movimentações x Template     			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ Gera Excel - Contratos                               	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFR016()

Local 	nOrdem
Local 	cQuery		:= ""
Private   cAliasQry   := GetNextAlias()

Private cString    	:= "SZD"
Private wnrel      	:= "EDFR016"
Private aOrd       	:= {"Contrato"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Relação de Movimentações x Template"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Relação de Movimentações x Template", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR016"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR016"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR016"
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

cQuery := " SELECT"+CENT
cQuery += " Z3_CONTRA"+CENT
cQuery += " ,A2_NREDUZ"+CENT
cQuery += " ,BM_DESC"+CENT
cQuery += " ,Z3_PERIODO"+CENT
cQuery += " ,Z3_DTINIC"+CENT
cQuery += " ,Z3_DTFIM"+CENT
cQuery += " ,ZD_PEDIDOC"+CENT
cQuery += " ,ZD_NFMAE"+CENT
cQuery += " ,ZD_NFREMES"+CENT
cQuery += " ,SACAS"+CENT
cQuery += " ,ZD_QTDNFRE"+CENT
cQuery += " ,ZD_QTDREC AS PESOLIQ"+CENT
cQuery += " ,TRANSPORTE "+CENT
cQuery += " ,ZD_PLACA"+CENT
cQuery += " ,ZD_NOMETER"+CENT
cQuery += " ,Y9_DESCR"+CENT
cQuery += " ,ZD_EMISREM"+CENT
cQuery += " ,ZD_DTETERM"+CENT
cQuery += " ,EMBAL"+CENT
cQuery += " ,CASE WHEN ZD_QTDNFRE - ZD_QTDREC > 0 THEN ZD_QTDNFRE - ZD_QTDREC ELSE 0 END FALTA"+CENT
cQuery += " ,D2_QTDDEV AS AVARIA"+CENT
cQuery += " ,CASE WHEN ZD_QTDNFRE - ZD_QTDREC < 0 THEN (ZD_QTDNFRE - ZD_QTDREC) * -1 ELSE 0 END SOBRA"+CENT
cQuery += " FROM"+CENT
cQuery += " (SELECT DISTINCT Z3_CONTRA,A2_NREDUZ,B1_DESC,Z3_PERIODO,Z3_DTINIC,Z3_DTFIM,ZD_PEDIDOC,ZD_NFMAE,ZD_NFREMES"+CENT
cQuery += " ,CASE WHEN B1_UM = 'SC' THEN ZD_QTDNFRE ELSE 0 END SACAS"+CENT
cQuery += " ,CASE WHEN B1_UM = 'TM' THEN ZD_QTDNFRE ELSE B1_CONV * ZD_QTDNFRE END ZD_QTDNFRE"+CENT
cQuery += " ,0 AS PESOLIQ"+CENT
cQuery += " ,CASE WHEN LEN(RTRIM(ZD_PLACA)) > 8 THEN 'Vagao' ELSE 'Caminhao' END TRANSPORTE"+CENT
cQuery += " ,ZD_NOMETER,Y9_DESCR,ZD_EMISREM"+CENT
cQuery += " ,CASE WHEN B1_CONV = 1 THEN 'Big Bags' ELSE 'Sacos '+Ltrim(Str(B1_CONV*1000))+' kg' END AS EMBAL"+CENT
cQuery += " ,Z3_CTRDP,ZD_LOCAL,ZD_PLACA,ZD_DTETERM"+CENT
cQuery += " ,(SELECT SUM(ISNULL(CASE WHEN ZD_UM = 'TM' THEN ZD_QTDREC  ELSE ZD_QTDREC * B1_CONV END, 0))  FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_NFREMES = SZD.ZD_NFREMES AND B1.D_E_L_E_T_ = '') AS ZD_QTDREC"+CENT
cQuery += " ,BM_DESC"+CENT
cQuery += " FROM "+RetSqlName("SZ3")+" SZ3, "+RetSqlName("SY9")+" SY9, "+RetSqlName("CN9")+" CN9, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SZD")+" SZD ,"+RetSqlName("SA2")+" SA2 ,"+RetSqlName("SBM")+" SBM "+CENT
cQuery += " WHERE Z3_PORTO = Y9_COD"+CENT
cQuery += " AND CN9_NUMERO = Z3_CONTRA"+CENT
cQuery += " AND ZD_CNPJUSI = A2_CGC"+CENT
cQuery += " AND Z3_CTRDP = B1_COD"+CENT
cQuery += " AND ZD_CONTRA = Z3_CONTRA"+CENT
cQuery += " AND ZD_PERIODO = Z3_PERIODO "+CENT
cQuery += " AND ZD_STATUS <> 'EX'"+CENT
cQuery += " AND ZD_PARC = '01'"+CENT
cQuery += " AND B1_GRUPO = BM_GRUPO"+CENT

If !Empty(MV_PAR01)
	cQuery += "	AND Rtrim(ZD_LOCAL) = '"+SubStr(MV_PAR01,1,2)+"'"+CENT
EndIf

If !Empty(MV_PAR02)
	cQuery += "	AND Y9_COD = '"+MV_PAR02+"'"+CENT
EndIf

If MV_PAR03 = 1 
	cQuery += " AND BM_DESC LIKE '%VHP%'"+CENT
ElseIf MV_PAR03 = 2 
	cQuery += " AND BM_DESC LIKE '%XTL%'"+CENT
ElseIf MV_PAR03 = 3 
	cQuery += " AND BM_DESC LIKE '%REF%'"+CENT    
EndIf

If !Empty(MV_PAR04)
	cQuery += "	AND Z3_SAFRA = '"+SubStr(MV_PAR04,1,2)+"/"+SubStr(MV_PAR04,3,2)+"'"+CENT
EndIf

If !Empty(MV_PAR05)
	cQuery += "	AND A2_COD = '"+MV_PAR05+"'"+CENT
EndIf

If !Empty(MV_PAR06)
	cQuery += "	AND ZD_PEDIDOC = '"+MV_PAR06+"'"+CENT
EndIf

If !Empty(MV_PAR07)
	cQuery += "	AND ZD_NFMAE = '"+MV_PAR07+"'"+CENT
EndIf

If !Empty(MV_PAR08)
	If !Empty(MV_PAR09)
		cQuery += "	AND Z3_CTRDP = '"+Alltrim(MV_PAR08)+"-"+Alltrim(MV_PAR09)+"'"+CENT
	Else
		cQuery += "	AND Z3_CONTRA = '"+MV_PAR08+"'"+CENT
	EndIf
EndIf

If !Empty(MV_PAR11)
	If !Empty(MV_PAR10)
		cQuery += "	AND (ZD_DTETERM BETWEEN '"+DtoS(MV_PAR10)+"' AND '"+DtoS(MV_PAR11)+"' OR  ZD_DTETERM = '') "+CENT
    Else
		cQuery += "	AND ZD_DTETERM BETWEEN '"+DtoS(MV_PAR10)+"' AND '"+DtoS(MV_PAR11)+"'"+CENT
	EndIf
Else
	cQuery += "	AND (ZD_DTETERM >= '"+DtoS(MV_PAR10)+"' OR ZD_DTETERM = '')"+CENT
EndIf

If	Empty(MV_PAR10) .and. Empty(MV_PAR11)
	Aviso("Aviso","Como não houve o preenchimento dos parâmetros de data da descarga no porto, serão apresentadas todas as descargas !",{"Continuar"})
EndIf

cQuery += " AND SA2.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SZ3.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SY9.D_E_L_E_T_ = ''"+CENT
cQuery += " AND CN9.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SB1.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SZD.D_E_L_E_T_ = ''"+CENT
cQuery += " AND SBM.D_E_L_E_T_ = '')"+CENT
cQuery += " AS SZD"+CENT
cQuery += " LEFT JOIN"+CENT
cQuery += " (SELECT D2_COD,D2_LOCAL,D2_NFORI,"+CENT
cQuery += " SUM(ISNULL(CASE WHEN B1_UM = 'TM' THEN D2_QUANT ELSE D2_QUANT * B1_CONV END, 0)) AS D2_QTDDEV"+CENT
cQuery += " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1 "+CENT
cQuery += " WHERE SD2.D_E_L_E_T_ <>  '*'"+CENT
cQuery += " AND SB1.D_E_L_E_T_ <>  '*'"+CENT
cQuery += " AND D2_COD = B1_COD"+CENT
cQuery += " AND D2_TIPO = 'D'"+CENT
cQuery += " AND D2_TES NOT IN ('506','508')"+CENT
cQuery += " GROUP BY D2_COD,D2_LOCAL,D2_NFORI)"+CENT
cQuery += " AS SD2"+CENT
cQuery += " ON SZD.Z3_CTRDP = SD2.D2_COD AND SZD.ZD_LOCAL = SD2.D2_LOCAL AND SD2.D2_NFORI = SZD.ZD_NFREMES "+CENT
cQuery += " ORDER BY Z3_CONTRA, Z3_PERIODO, ZD_NFMAE, ZD_NFREMES "+CENT

MemoWrite("C:\Tmp\EDFR016.txt",cQuery)
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

If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel não instalado!")
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
	
	FWrite(nArq,'<?xml version="1.0"?>'+CENT)
	FWrite(nArq,'<?mso-application progid="Excel.Sheet"?>'+CENT)
	FWrite(nArq,'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT)
	FWrite(nArq,' xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT)
	FWrite(nArq,' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT)
 	FWrite(nArq,'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT)
 	FWrite(nArq,'xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT)
 	FWrite(nArq,'<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT)
 	FWrite(nArq,' <Author>luis.nascimento</Author>'+CENT)
 	FWrite(nArq,' <LastAuthor>Luis Filipe Nascimento</LastAuthor>'+CENT)
 	FWrite(nArq,' <Created>2014-08-06T19:25:14Z</Created>'+CENT)
 	FWrite(nArq,' <LastSaved>2015-06-17T21:57:33Z</LastSaved>'+CENT)
 	FWrite(nArq,' <Company>Microsoft</Company>'+CENT)
 	FWrite(nArq,' <Version>15.00</Version>'+CENT)
 	FWrite(nArq,'</DocumentProperties>'+CENT)
 	FWrite(nArq,'<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CENT)
 	FWrite(nArq,' <AllowPNG/>'+CENT)
 	FWrite(nArq,'</OfficeDocumentSettings>'+CENT)
 	FWrite(nArq,'<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CENT)
 	FWrite(nArq,' <WindowHeight>7755</WindowHeight>'+CENT)
 	FWrite(nArq,' <WindowWidth>20490</WindowWidth>'+CENT)
 	FWrite(nArq,' <WindowTopX>0</WindowTopX>'+CENT)
 	FWrite(nArq,' <WindowTopY>0</WindowTopY>'+CENT)
 	FWrite(nArq,' <ActiveSheet>1</ActiveSheet>'+CENT)
 	FWrite(nArq,' <ProtectStructure>False</ProtectStructure>'+CENT)
 	FWrite(nArq,' <ProtectWindows>False</ProtectWindows>'+CENT)
 	FWrite(nArq,'</ExcelWorkbook>'+CENT)
 	FWrite(nArq,'<Styles>'+CENT)
 	FWrite(nArq,' <Style ss:ID="Default" ss:Name="Normal">'+CENT)
 	FWrite(nArq,'  <Alignment ss:Vertical="Bottom"/>'+CENT)
 	FWrite(nArq,'  <Borders/>'+CENT)
 	FWrite(nArq,'  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT)
 	FWrite(nArq,'  <Interior/>'+CENT)
 	FWrite(nArq,'  <NumberFormat/>'+CENT)
 	FWrite(nArq,'  <Protection/>'+CENT)
	FWrite(nArq,'  </Style>'+CENT)
	FWrite(nArq,'  <Style ss:ID="s62" ss:Name="Virgula">'+CENT)
	FWrite(nArq,'   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT)
	FWrite(nArq,'  </Style>'+CENT)
	FWrite(nArq,'  <Style ss:ID="s63">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
 	FWrite(nArq,'   <Borders/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s64">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
 	FWrite(nArq,'   <Borders/>'+CENT)
 	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s65">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
 	FWrite(nArq,'   <Borders/>'+CENT)
 	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FF0000"'+CENT)
 	FWrite(nArq,'    ss:Bold="1"/>'+CENT)
 	FWrite(nArq,'   <Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s66">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
 	FWrite(nArq,'   <Borders/>'+CENT)
 	FWrite(nArq,'   <Interior/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s67">'+CENT)
 	FWrite(nArq,'   <Interior/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s68">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
 	FWrite(nArq,'   <Borders/>'+CENT)
 	FWrite(nArq,'   <NumberFormat ss:Format="Short Date"/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s70">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT)
	FWrite(nArq,'   <Borders>'+CENT)
	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
	FWrite(nArq,'   </Borders>'+CENT)
	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="18" ss:Color="#000000"'+CENT)
	FWrite(nArq,'    ss:Bold="1"/>'+CENT)
 	FWrite(nArq,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s72">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>'+CENT)
 	FWrite(nArq,'   <Borders/>'+CENT)
 	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="18" ss:Color="#000000"'+CENT)
 	FWrite(nArq,'    ss:Bold="1"/>'+CENT)
 	FWrite(nArq,'   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s73">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT)
 	FWrite(nArq,'   <Borders/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s74">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT)
 	FWrite(nArq,'   <Borders>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'   </Borders>'+CENT)
 	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT)
 	FWrite(nArq,'    ss:Bold="1"/>'+CENT)
 	FWrite(nArq,'   <Interior ss:Color="#EBF1DE" ss:Pattern="Solid"/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s75">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT)
 	FWrite(nArq,'   <Borders>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
	FWrite(nArq,'   </Borders>'+CENT)
	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Bold="1"/>'+CENT)
	FWrite(nArq,'   <Interior ss:Color="#EBF1DE" ss:Pattern="Solid"/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s76">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT)
 	FWrite(nArq,'   <Borders>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'   </Borders>'+CENT)
 	FWrite(nArq,'   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT)
 	FWrite(nArq,'    ss:Bold="1"/>'+CENT)
 	FWrite(nArq,'   <Interior ss:Color="#EBF1DE" ss:Pattern="Solid"/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s77">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
 	FWrite(nArq,'   <Borders>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'   </Borders>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s78">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
 	FWrite(nArq,'   <Borders>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'   </Borders>'+CENT)
 	FWrite(nArq,'   <NumberFormat ss:Format="Short Date"/>'+CENT)
	FWrite(nArq,'  </Style>'+CENT)
	FWrite(nArq,'  <Style ss:ID="s79">'+CENT)
	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
	FWrite(nArq,'   <Borders>'+CENT)
	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'   </Borders>'+CENT)
 	FWrite(nArq,'   <NumberFormat ss:Format="@"/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s80">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT)
 	FWrite(nArq,'   <Borders>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'   </Borders>'+CENT)
 	FWrite(nArq,'   <NumberFormat ss:Format="@"/>'+CENT)
 	FWrite(nArq,'  </Style>'+CENT)
 	FWrite(nArq,'  <Style ss:ID="s83" ss:Parent="s62">'+CENT)
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
 	FWrite(nArq,'  <Style ss:ID="s84" ss:Parent="s62">'+CENT)
 	FWrite(nArq,'   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
 	FWrite(nArq,'   <Borders>'+CENT)
 	FWrite(nArq,'   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'   <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'   <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'  </Borders>'+CENT)
  	FWrite(nArq,'  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT)
  	FWrite(nArq,'  <Interior/>'+CENT)
  	FWrite(nArq,'  <NumberFormat ss:Format="_-* #,##0.000_-;\-* #,##0.000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT)
  	FWrite(nArq,' </Style>'+CENT)
  	FWrite(nArq,' <Style ss:ID="s85">'+CENT)
  	FWrite(nArq,'  <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'  <Borders>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'  </Borders>'+CENT)
  	FWrite(nArq,'  <Interior/>'+CENT)
  	FWrite(nArq,' </Style>'+CENT)
  	FWrite(nArq,' <Style ss:ID="s86">'+CENT)
  	FWrite(nArq,'  <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'  <Borders>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'  </Borders>'+CENT)
  	FWrite(nArq,'  <Interior/>'+CENT)
  	FWrite(nArq,'  <NumberFormat ss:Format="Short Date"/>'+CENT)
  	FWrite(nArq,' </Style>'+CENT)
  	FWrite(nArq,' <Style ss:ID="s87">'+CENT)
  	FWrite(nArq,'  <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'  <Borders>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
 	FWrite(nArq,'  </Borders>'+CENT)
 	FWrite(nArq,' </Style>'+CENT)
 	FWrite(nArq,' <Style ss:ID="s88" ss:Parent="s62">'+CENT)
 	FWrite(nArq,'  <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'  <Borders>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT)
  	FWrite(nArq,'  </Borders>'+CENT)
  	FWrite(nArq,'  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT)
  	FWrite(nArq,'  <Interior/>'+CENT)
  	FWrite(nArq,'  <NumberFormat ss:Format="#,##0.000"/>'+CENT)
  	FWrite(nArq,' </Style>'+CENT)
  	FWrite(nArq,' <Style ss:ID="s90" ss:Parent="s62">'+CENT)
  	FWrite(nArq,'  <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'  <Borders/>'+CENT)
  	FWrite(nArq,'  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT)
  	FWrite(nArq,'  <NumberFormat ss:Format="#,##0.000_ ;\-#,##0.000\ "/>'+CENT)
  	FWrite(nArq,' </Style>'+CENT)
  	FWrite(nArq,' <Style ss:ID="s91" ss:Parent="s62">'+CENT)
  	FWrite(nArq,'  <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'  <Borders/>'+CENT)
  	FWrite(nArq,'  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT)
  	FWrite(nArq,'  <Interior/>'+CENT)
  	FWrite(nArq,'  <NumberFormat ss:Format="#,##0.000"/>'+CENT)
  	FWrite(nArq,' </Style>'+CENT)
  	FWrite(nArq,' <Style ss:ID="s92" ss:Parent="s62">'+CENT)
  	FWrite(nArq,'  <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT)
  	FWrite(nArq,'  <Borders/>'+CENT)
  	FWrite(nArq,'  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT)
  	FWrite(nArq,'  <NumberFormat ss:Format="#,##0.000"/>'+CENT)
  	FWrite(nArq,' </Style>'+CENT)
  	FWrite(nArq,'</Styles>'+CENT)
	FWrite(nArq,' <Worksheet ss:Name="Parametros">'+CENT)
	FWrite(nArq,'  <Table ss:ExpandedColumnCount="21" ss:ExpandedRowCount="12" x:FullColumns="1"'+CENT)
	FWrite(nArq,'   x:FullRows="1" ss:StyleID="s63" ss:DefaultRowHeight="15">'+CENT)
	FWrite(nArq,'   <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="285"/>'+CENT)
	FWrite(nArq,'   <Column ss:StyleID="s63" ss:Width="142.5"/>'+CENT)
 	FWrite(nArq,'   <Column ss:StyleID="s63" ss:Width="42.75"/>'+CENT)
 	FWrite(nArq,'   <Column ss:StyleID="s63" ss:Width="57" ss:Span="1"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Index="6" ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="64.5"/>'+CENT)
 	FWrite(nArq,'   <Column ss:StyleID="s63" ss:Width="60.75"/>'+CENT)
 	FWrite(nArq,'   <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="57"/>'+CENT)
 	FWrite(nArq,'   <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="71.25"/>'+CENT)
 	FWrite(nArq,'   <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="87"/>'+CENT)
 	FWrite(nArq,'   <Column ss:StyleID="s64" ss:Width="67.5"/>'+CENT)
 	FWrite(nArq,'   <Column ss:StyleID="s63" ss:Width="63.75"/>'+CENT)
 	FWrite(nArq,'   <Column ss:StyleID="s63" ss:Width="75.75"/>'+CENT)
 	FWrite(nArq,'   <Column ss:StyleID="s63" ss:Width="66.75" ss:Span="1"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Index="16" ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="62.25"'+CENT)
 	FWrite(nArq,'    ss:Span="1"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Index="18" ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="64.5"'+CENT)
 	FWrite(nArq,'    ss:Span="3"/>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s65"><Data ss:Type="String">FILTROS PARA ACESSO</Data></Cell>'+CENT)
 	FWrite(nArq,'   </Row>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s66"><Data ss:Type="String">Terminal</Data></Cell>'+CENT)
	SZE->(DbSetOrder(1))
	SZE->(DbSeek(xFilial("SZE")+SubStr(MV_PAR01,1,2)))
 	FWrite(nArq,'    <Cell><Data ss:Type="String">'+SZE->ZE_NOME+'</Data></Cell>'+CENT)
 	FWrite(nArq,'   </Row>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s66"><Data ss:Type="String">Porto</Data></Cell>'+CENT)
	SY9->(DbSetOrder(1))
	SY9->(DbSeek(xFilial("SY9")+MV_PAR02))
 	FWrite(nArq,'    <Cell><Data ss:Type="String">'+SY9->Y9_DESCR+'</Data></Cell>'+CENT)
 	FWrite(nArq,'   </Row>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s67"><Data ss:Type="String">Tipo Produto (Granel ou ensacado)</Data></Cell>'+CENT)

	If MV_PAR03 == 1
		cTipo := "VHP"
	ElseIf MV_PAR03 == 2
		cTipo := "XTL"
	ElseIf MV_PAR03 == 3
		cTipo := "REFINADO"
	Else
		cTipo := "Todos"
	EndIf

 	FWrite(nArq,'    <Cell><Data ss:Type="String">'+cTipo+'</Data></Cell>'+CENT)
 	FWrite(nArq,'   </Row>'+CENT)
	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
	FWrite(nArq,'    <Cell ss:StyleID="s66"><Data ss:Type="String">Safra</Data></Cell>'+CENT)
	FWrite(nArq,'    <Cell><Data ss:Type="String">'+SubStr(MV_PAR04,1,2)+"/"+SubStr(MV_PAR04,3,2)+'</Data></Cell>'+CENT)
	FWrite(nArq,'   </Row>'+CENT)
	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+MV_PAR05))
	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s66"><Data ss:Type="String">Fornecedor</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell><Data ss:Type="String">'+MV_PAR05+" - "+SA2->A2_NREDUZ+'</Data></Cell>'+CENT)
 	FWrite(nArq,'   </Row>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s66"><Data ss:Type="String">Pedido de Compra</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell><Data ss:Type="String">'+MV_PAR06+'</Data></Cell>'+CENT)
 	FWrite(nArq,'   </Row>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s66"><Data ss:Type="String">Nota Fiscal Mae</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell><Data ss:Type="String">'+MV_PAR07+'</Data></Cell>'+CENT)
 	FWrite(nArq,'   </Row>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s66"><Data ss:Type="String">Contrato</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell><Data ss:Type="String">'+MV_PAR08+'</Data></Cell>'+CENT)
 	FWrite(nArq,'   </Row>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s66"><Data ss:Type="String">DP</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell><Data ss:Type="String">'+MV_PAR09+'</Data></Cell>'+CENT)
 	FWrite(nArq,'   </Row>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s66"><Data ss:Type="String">Descarga De</Data></Cell>'+CENT)

	cMVPAR10 	:= SubStr(DtoS(MV_PAR10),1,4)+"-"+SubStr(DtoS(MV_PAR10),5,2)+"-"+SubStr(DtoS(MV_PAR10),7,2)+"T00:00:00.000"

	If !Empty(MV_PAR10)
	 	FWrite(nArq,'    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cMVPAR10+'</Data></Cell>'+CENT)
	Else
	 	FWrite(nArq,'    <Cell ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>'+CENT)
    EndIf
 	FWrite(nArq,'   </Row>'+CENT)

 	FWrite(nArq,'   <Row ss:AutoFitHeight="0">'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s66"><Data ss:Type="String">Descarga Ate</Data></Cell>'+CENT)

	cMVPAR11 	:= SubStr(DtoS(MV_PAR11),1,4)+"-"+SubStr(DtoS(MV_PAR11),5,2)+"-"+SubStr(DtoS(MV_PAR11),7,2)+"T00:00:00.000"

	If !Empty(MV_PAR11)
	 	FWrite(nArq,'    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cMVPAR11+'</Data></Cell>'+CENT)
	Else
	 	FWrite(nArq,'    <Cell ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>'+CENT)
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
 	FWrite(nArq,'     <ActiveRow>11</ActiveRow>'+CENT)
 	FWrite(nArq,'     <ActiveCol>1</ActiveCol>'+CENT)
 	FWrite(nArq,'    </Pane>'+CENT)
 	FWrite(nArq,'   </Panes>'+CENT)
 	FWrite(nArq,'   <ProtectObjects>False</ProtectObjects>'+CENT)
 	FWrite(nArq,'   <ProtectScenarios>False</ProtectScenarios>'+CENT)
 	FWrite(nArq,'  </WorksheetOptions>'+CENT)
 	FWrite(nArq,' </Worksheet>'+CENT)
 	FWrite(nArq,' <Worksheet ss:Name="Detalhes">'+CENT)
 	FWrite(nArq,'  <Table ss:ExpandedColumnCount="22" ss:ExpandedRowCount="'+Alltrim(Str(nLin))+'" x:FullColumns="1"'+CENT)
 	FWrite(nArq,'   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT)
 	FWrite(nArq,'   <Column ss:Width="102.75"/>'+CENT)
 	FWrite(nArq,'   <Column ss:AutoFitWidth="0" ss:Width="171.75"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Width="50.25"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Width="36.75"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Width="56.25" ss:Span="1"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Index="7" ss:Width="52.5" ss:Span="2"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Index="10" ss:Width="67.5"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Width="77.25" ss:Span="1"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Index="13" ss:Width="59.25"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Width="75"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Width="180.75"/>'+CENT)
 	FWrite(nArq,'   <Column ss:AutoFitWidth="0" ss:Width="157.5"/>'+CENT)
 	FWrite(nArq,'   <Column ss:Width="56.25"/>'+CENT)
 	FWrite(nArq,'   <Column ss:AutoFitWidth="0" ss:Width="59.25"/>'+CENT)
 	FWrite(nArq,'   <Column ss:AutoFitWidth="0" ss:Width="63"/>'+CENT)
 	FWrite(nArq,'   <Column ss:AutoFitWidth="0" ss:Width="54.75" ss:Span="2"/>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0" ss:Height="57" ss:StyleID="s63">'+CENT)
 	FWrite(nArq,'    <Cell ss:MergeAcross="18" ss:StyleID="s70"><Data ss:Type="String">Relatorio de Mov x template - '+DtoC(Ddatabase)+'</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s72"/>'+CENT)
 	FWrite(nArq,'  </Row>'+CENT)
 	FWrite(nArq,'  <Row ss:AutoFitHeight="0" ss:Height="45" ss:StyleID="s73">'+CENT)
 	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Fornecedor</Data></Cell>'+CENT)
 	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Descricao do Produto</Data></Cell>'+CENT)
 	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Contratos</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">DP</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Dt.Inicio</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Dt.Fim</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">NF Vendas (NF Mae)</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">NF Remessas</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Pedido de Compra</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Sacas</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Peso Nota Fiscal (tons, 3 casas decimais)</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s75"><Data ss:Type="String">Peso Liquido (tons)</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s75"><Data ss:Type="String">Caminhao ou Vagao</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s75"><Data ss:Type="String">Placa Veiculo</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Terminal</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Porto</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Dt.Emissao</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Dt.Chegada</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s74"><Data ss:Type="String">Embalagem</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s76"><Data ss:Type="String">Faltas</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s76"><Data ss:Type="String">Avarias</Data></Cell>'+CENT)
  	FWrite(nArq,'   <Cell ss:StyleID="s76"><Data ss:Type="String">Sobras</Data></Cell>'+CENT)
  	FWrite(nArq,'  </Row>'+CENT)  
  	
	nSACAS 		:= 0
	nZD_QTDNFRE := 0
	nPESOLIQ 	:= 0
	nFALTA 		:= 0
	nAVARIA 	:= 0
	nSOBRA 		:= 0
	ncount		:= 0 
	ncountq 	:= 0 
	
	While !(cAliasQry)->(Eof())
		
		ncount += 1
		ncountq += 1 
		
		IncProc(Str(ncount,5)+" de "+Str(nLin,5)+ " registros" )
		
		cZ3_DTINIC 	:= SubStr((cAliasQry)->Z3_DTINIC,1,4)+"-"+SubStr((cAliasQry)->Z3_DTINIC,5,2)+"-"+SubStr((cAliasQry)->Z3_DTINIC,7,2)+"T00:00:00.000"
		cZ3_DTFIM	:= SubStr((cAliasQry)->Z3_DTFIM,1,4)+"-"+SubStr((cAliasQry)->Z3_DTFIM,5,2)+"-"+SubStr((cAliasQry)->Z3_DTFIM,7,2)+"T00:00:00.000"
		cZD_EMISREM := SubStr((cAliasQry)->ZD_EMISREM,1,4)+"-"+SubStr((cAliasQry)->ZD_EMISREM,5,2)+"-"+SubStr((cAliasQry)->ZD_EMISREM,7,2)+"T00:00:00.000"
		cZD_DTETERM	:= SubStr((cAliasQry)->ZD_DTETERM,1,4)+"-"+SubStr((cAliasQry)->ZD_DTETERM,5,2)+"-"+SubStr((cAliasQry)->ZD_DTETERM,7,2)+"T00:00:00.000"
  	
	  	cXml += '  <Row ss:AutoFitHeight="0" ss:StyleID="s63">'+CENT
	  	cXml += '   <Cell ss:StyleID="s77"><Data ss:Type="String">'+Alltrim((cAliasQry)->A2_NREDUZ)+'</Data></Cell>'+CENT
	  	cXml += '   <Cell ss:StyleID="s77"><Data ss:Type="String">'+(cAliasQry)->BM_DESC+'</Data></Cell>'+CENT
	  	cXml += '   <Cell ss:StyleID="s77"><Data ss:Type="String">'+Alltrim((cAliasQry)->Z3_CONTRA)+'</Data></Cell>'+CENT
	  	cXml += '   <Cell ss:StyleID="s77"><Data ss:Type="String">'+Alltrim((cAliasQry)->Z3_PERIODO)+'</Data></Cell>'+CENT
	  	cXml += '   <Cell ss:StyleID="s78"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT
	  	cXml += '   <Cell ss:StyleID="s78"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT
	  	cXml += '   <Cell ss:StyleID="s79"><Data ss:Type="String">'+(cAliasQry)->ZD_NFMAE+'</Data></Cell>'+CENT
	  	cXml += '   <Cell ss:StyleID="s79"><Data ss:Type="String">'+(cAliasQry)->ZD_NFREMES+'</Data></Cell>'+CENT
	  	cXml += '   <Cell ss:StyleID="s80"><Data ss:Type="String">'+(cAliasQry)->ZD_PEDIDOC+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s92"><Data ss:Type="String">'+Transform((cAliasQry)->SACAS,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s83"><Data ss:Type="String">'+Transform((cAliasQry)->ZD_QTDNFRE,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s83"><Data ss:Type="String">'+Transform((cAliasQry)->PESOLIQ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+(cAliasQry)->TRANSPORTE+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Alltrim((cAliasQry)->ZD_PLACA)+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s77"><Data ss:Type="String">'+Alltrim((cAliasQry)->ZD_NOMETER)+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s85"><Data ss:Type="String">'+Alltrim((cAliasQry)->Y9_DESCR)+'</Data></Cell>'+CENT
		If  !Empty((cAliasQry)->ZD_EMISREM)
		 	cXml += '    <Cell ss:StyleID="s86"><Data ss:Type="DateTime">'+cZD_EMISREM+'</Data></Cell>'+CENT
		Else
		 	cXml += '    <Cell ss:StyleID="s86"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
			
		If  !Empty((cAliasQry)->ZD_DTETERM)
		 	cXml += '    <Cell ss:StyleID="s86"><Data ss:Type="DateTime">'+cZD_DTETERM+'</Data></Cell>'+CENT
		Else
		 	cXml += '    <Cell ss:StyleID="s86"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf

	 	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Alltrim((cAliasQry)->EMBAL)+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform((cAliasQry)->FALTA,"@E 999,999.999")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform((cAliasQry)->AVARIA,"@E 999,999.999")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">'+Transform((cAliasQry)->SOBRA,"@E 999,999.999") +'</Data></Cell>'+CENT
	 	cXml += '   </Row>'+CENT
 
		nSACAS 		+= (cAliasQry)->SACAS
		nZD_QTDNFRE += (cAliasQry)->ZD_QTDNFRE
		nPESOLIQ 	+= (cAliasQry)->PESOLIQ
		nFALTA 		+= (cAliasQry)->FALTA
		nAVARIA 	+= (cAliasQry)->AVARIA
		nSOBRA 		+= (cAliasQry)->SOBRA
		
		(cAliasQry)->(DbSkip())

		If	ncountq == 480 .or. Eof() 
			FWrite(nArq,cXml)
			cXml := ""
			ncountq := 0 
		EndIf

	End

 	FWrite(nArq,'   <Row ss:AutoFitHeight="0" ss:StyleID="s63">'+CENT)
 	FWrite(nArq,'    <Cell ss:Index="10" ss:StyleID="s92"><Data ss:Type="String">'+Transform(nSACAS,"@E 999,999,999.999")+'</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(nZD_QTDNFRE,"@E 999,999,999.999")+'</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s90"><Data ss:Type="String">'+Transform(nPESOLIQ,"@E 999,999,999.999")+'</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s64"/>'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s64"/>'+CENT)
 	FWrite(nArq,'    <Cell ss:Index="20" ss:StyleID="s91"><Data ss:Type="String">'+Transform(nFALTA,"@E 999,999.999")+'</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+Transform(nAVARIA,"@E 999,999.999")+'</Data></Cell>'+CENT)
 	FWrite(nArq,'    <Cell ss:StyleID="s91"><Data ss:Type="String">'+Transform(nSOBRA,"@E 999,999.999") +'</Data></Cell>'+CENT)
 	FWrite(nArq,'   </Row>'+CENT)
 	FWrite(nArq,'   <Row ss:AutoFitHeight="0" ss:StyleID="s63">'+CENT)
 	FWrite(nArq,'    <Cell ss:Index="12" ss:StyleID="s64"/>'+CENT)
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

//         1           2      3                        4                        5                        6           7     8   9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24          25   26   27   28   29   	  30   31   32   33   34   35   36   37   38       39   40  41  42             43
AADD(aSx1,{"EDFR016" , "01" , "Terminal Ex.: 05       ?" , "Terminal           ?" , "Terminal           ?" , "mv_ch1" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""        , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "SZE_2" , "" , "", "", ""           , ""})
AADD(aSx1,{"EDFR016" , "02" , "Porto Ex.: 41173       ?" , "Porto              ?" , "Porto              ?" , "mv_ch2" , "C" , 05 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""        , "" , "" , "" , "" , ""       , "" , "" , "" , "" , "" , "" , "" , "" , "SY9"   , "" , "", "", ""           , ""})
AADD(aSx1,{"EDFR016" , "03" , "Tipo de Produto        ?" , "Tipo de Produto    ?" , "Tipo de Produto    ?" , "mv_ch3" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par03" , "VHP" , ""    , ""    , "" , "" , "XTL" , ""    , ""    , "" , "" , "Refinado", "" , "" , "" , "" , "Ambos"  , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", ""          , ""})
AADD(aSx1,{"EDFR016" , "04" , "Safra Ex.: 14/15       ?" , "Safra         	   ?" , "Safra         	    ?" , "mv_ch4" , "C" , 05 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""        , "" , "" , "" , "" , ""       , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "@R 99/99" , ""})
AADD(aSx1,{"EDFR016" , "05" , "Fornecedor Ex.: 123456 ?" , "Fornecedor         ?" , "Fornecedor         ?" , "mv_ch5" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""        , "" , "" , "" , "" , ""       , "" , "" , "" , "" , "" , "" , "" , "" , "SA2"   , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR016" , "06" , "Ped.Compra Ex.: 123456 ?" , "Pedido de Compra   ?" , "Pedido de Compra   ?" , "mv_ch6" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par06" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""        , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "SC7"   , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR016" , "07" , "N.Fiscal Mãe           ?" , "N.Fiscal Mãe       ?" , "N.Fiscal Mãe       ?" , "mv_ch7" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par07" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""        , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "NFMAER", "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR016" , "08" , "Contrato               ?" , "Contrato           ?" , "Contrato           ?" , "mv_ch8" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par08" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""        , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "SZ3"   , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR016" , "09" , "DP                     ?" , "DP                 ?" , "DP                 ?" , "mv_ch9" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par09" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""        , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""  	  , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR016" , "10" , "Descarga De            ?" , "Descarga De        ?" , "Descarga De        ?" , "mv_cha" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par10" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""        , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR016" , "11" , "Descarga Ate           ?" , "Descarga Ate       ?" , "Descarga Ate       ?" , "mv_chb" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par11" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""        , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" 			 , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR016   11")
	
	DbSeek("EDFR016")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR016"
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
