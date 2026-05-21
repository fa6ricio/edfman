#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ EDFR020     ³ Autor ³ Luis Felipe Mattos	³ Data ³ 21.09.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio Balance RE Payment      				 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ Gera Excel - Contratos                               	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracaos³ Luis Felipe Nascimento 							31/10/16  ³±±
±±³          ³ Feito tratamento na query pois a mesma retornava falha na  ³±±
±±³          ³ divisão por zero. 									      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracaos³ Luis Felipe Nascimento 							26/12/16  ³±±
±±³          ³ Cliente deseja enxergar todos os contratos mesmo que os    ³±±
±±³          ³ mesmos não sofram movimentação. Sendo assim fora necessário³±±
±±³          ³ alterar a ordem do filtro da query.                        ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFR020()

Local 	nOrdem
Local 	cQuery		:= ""
Private   cAliasQry := GetNextAlias()
Private cString    	:= "EE9"
Private wnrel      	:= "EDFR020"
Private aOrd       	:= {"Comprador"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Relatorio Balance RE Payment"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Relatorio Balance RE Payment", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR020"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR020"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR020"
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

/*
Numero PI
Contrato
DP
Value Date
Stock Finance
Qtd. Ton.
Total USD
*/

cQuery := " SELECT ZJ_NUM, ZJ_CONTRA, ZJ_PERIODO, ZJ_VENCTO, ZJ_FORMPG, ZJ_QTDTON, ZJ_VALOR / ZJ_QTDTON PRUNIT, ZJ_VALOR "+CENT
cQuery += " FROM "+RetSqlName("SZJ")+CENT
cQuery += " WHERE D_E_L_E_T_ = ''"+CENT
If !Empty(MV_PAR04)
	If !Empty(MV_PAR05)
		cQuery += " AND RTRIM(ZJ_CONTRA)+'-'+RTRIM(ZJ_PERIODO) = '"+Alltrim(MV_PAR04)+"-"+Alltrim(MV_PAR05)+"'"+CENT
	Else
		cQuery += " AND RTRIM(ZJ_CONTRA) = '"+Alltrim(MV_PAR04)+"'"+CENT
	EndIf
EndIf

cQuery += " ORDER BY ZJ_CONTRA,ZJ_PERIODO,ZJ_NUM"+CENT

MemoWrite("C:\Tmp\EDFR020P.txt",cQuery)
cQuery := ChangeQuery(cQuery)

If Select(cAliasQry) > 0
	dbSelectArea(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

(cAliasQry)->(DbGotop())

While !(cAliasQry)->(Eof())
	Aadd(aPgtos,{If(Empty((cAliasQry)->ZJ_PERIODO), Alltrim((cAliasQry)->ZJ_CONTRA), Alltrim((cAliasQry)->ZJ_CONTRA)+"-"+Alltrim(ZJ_PERIODO)),(cAliasQry)->ZJ_NUM,(cAliasQry)->ZJ_VENCTO,(cAliasQry)->ZJ_FORMPG,(cAliasQry)->ZJ_QTDTON,(cAliasQry)->PRUNIT,(cAliasQry)->ZJ_VALOR})
	(cAliasQry)->(DbSkip())
End
(cAliasQry)->(dbCloseArea())

// Embarques

// 26/12/16 - Luis Felipe - Inicio

/*
cQuery := " SELECT * FROM "+CENT
// 31/10/16 - Luis Felipe - Inicio
//cQuery += " (SELECT DISTINCT EE9_COD_I, EE9_PEDIDO, EE9_RE, EE9_DTRE, EE9_PRCTOT / (EE9_QTDEM1 * EE9_QE) EE9_PRECO, EE9_PRCTOT, EE9_QTDEM1 * EE9_QE AS EE9_QTDEM1, EE9_PREEMB "+CENT
cQuery += " (SELECT DISTINCT EE9_COD_I, EE9_PEDIDO, EE9_RE, EE9_DTRE"+CENT
cQuery += " ,(CASE WHEN EE9_PRCTOT = 0 THEN EE9_PRECO ELSE EE9_PRCTOT END / (CASE WHEN EE9_QTDEM1 = 0 THEN 1 ELSE EE9_QTDEM1 END * CASE WHEN EE9_QE = 0 THEN 1 ELSE EE9_QE END)) EE9_PRECO "+CENT
cQuery += " ,EE9_PRCTOT, EE9_QTDEM1 * EE9_QE AS EE9_QTDEM1, EE9_PREEMB "+CENT
// 31/10/16 - Luis Felipe - Fim
cQuery += " FROM "+RetSqlName("EE9")+" EE9"+CENT
cQuery += " WHERE SUBSTRING(EE9_CF,2,3) = '501'"+CENT
cQuery += " AND EE9_PEDIDO NOT LIKE '%SAC%'"+CENT

// Filtros

If !Empty(MV_PAR04)
cQuery += "	AND EE9_COD_I Like '%"+Alltrim(MV_PAR04)+"%'"+CENT
EndIf

If !Empty(MV_PAR05)
cQuery += "	AND EE9_COD_I Like '%"+Alltrim(MV_PAR05)+"%'"+CENT
EndIf

cQuery += " AND EE9.D_E_L_E_T_ = '')"+CENT
cQuery += " AS  EE9"+CENT

cQuery += " LEFT JOIN"+CENT
cQuery += " (SELECT EEC_PEDREF, EEC_IMPODE, EEC_EMBARC, EEC_NRINVO, EEC_PREEMB, EEC_IMPORT"+CENT
cQuery += " FROM "+RetSqlName("EEC")+CENT
cQuery += " WHERE D_E_L_E_T_ = '')"+CENT
cQuery += " AS EEC"+CENT
cQuery += " ON EEC.EEC_PEDREF = EE9.EE9_PEDIDO AND EE9.EE9_PREEMB = EEC.EEC_PREEMB"+CENT

cQuery += " LEFT JOIN"+CENT
cQuery += " (SELECT Z3_SAFRA, Z3_CONTRA, Z3_PERIODO, Z3_DTINIC, Z3_DTFIM, Z3_QUANT, Z3_DTINEM, Z3_DTFIEM, Z3_CTRDP, CN9_XFORNE "+CENT
cQuery += " FROM "+RetSqlName("SZ3")+" SZ3 ,"+RetSqlName("CN9")+" CN9"+CENT
cQuery += " WHERE SubString(Z3_CTRDP,1,1) = 'S' "+CENT
cQuery += " AND 'P'+SubString(Z3_CONTRA,2,14) = CN9_NUMERO"+CENT
cQuery += " AND SZ3.D_E_L_E_T_ = ''"+CENT
cQuery += " AND CN9.D_E_L_E_T_ = '')"+CENT
cQuery += " AS SZ3"+CENT
cQuery += " ON SubString(SZ3.Z3_CTRDP,2,24) = SubString(EE9.EE9_COD_I,2,24) "+CENT

// Filtros
If !Empty(MV_PAR01)
cQuery += "	WHERE Z3_SAFRA = '"+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,2)+"'"+CENT
EndIf

If !Empty(MV_PAR02)
If Empty(MV_PAR01)
cQuery += "	WHERE EEC_IMPORT = "+MV_PAR02+CENT
Else
cQuery += "	AND EEC_IMPORT = "+MV_PAR02+CENT
EndIf
EndIf

If !Empty(MV_PAR03)
If Empty(MV_PAR01) .and. Empty(MV_PAR02)
cQuery += "	WHERE CN9_XFORNE Like '%"+Alltrim(MV_PAR03)+"%'"+CENT
Else
cQuery += "	AND CN9_XFORNE Like '%"+Alltrim(MV_PAR03)+"%'"+CENT
EndIf
EndIf

cQuery += " ORDER BY CN9_XFORNE,EE9_COD_I, EE9_PEDIDO"+CENT

MemoWrite("C:\Tmp\EDFR020E.txt",cQuery)
cQuery := ChangeQuery(cQuery)

*/

cQuery := " SELECT * FROM "+CENT

cQuery += " (SELECT Z3_SAFRA, Z3_CONTRA, Z3_PERIODO, Z3_DTINIC, Z3_DTFIM, Z3_QUANT, Z3_DTINEM, Z3_DTFIEM, Z3_CTRDP, CN9_XFORNE "+CENT
cQuery += " FROM "+RetSqlName("SZ3")+" SZ3 ,"+RetSqlName("CN9")+" CN9"+CENT
cQuery += " WHERE 'P'+SubString(Z3_CONTRA,2,14) = CN9_NUMERO"+CENT
cQuery += " AND SubString(Z3_CONTRA,1,1) = 'S' "+CENT
// Filtros
If !Empty(MV_PAR01)
	cQuery += "	AND Z3_SAFRA = '"+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,2)+"'"+CENT
EndIf
If !Empty(MV_PAR03)
	cQuery += "	AND CN9_XFORNE Like '%"+Alltrim(MV_PAR03)+"%'"+CENT
EndIf
If !Empty(MV_PAR04)
	If !Empty(MV_PAR05)
		cQuery += "	AND Z3_CONTRA Like '%"+Alltrim(MV_PAR04)+"%'"+CENT
		cQuery += "	AND Z3_PERIODO Like '%"+Alltrim(MV_PAR05)+"%'"+CENT
	Else
		cQuery += "	AND Z3_CONTRA Like '%"+Alltrim(MV_PAR04)+"%'"+CENT
	EndIf
EndIf
cQuery += " AND SZ3.D_E_L_E_T_ = ''"+CENT
cQuery += " AND CN9.D_E_L_E_T_ = '')"+CENT
cQuery += " AS SZ3"+CENT

cQuery += " LEFT JOIN"+CENT
cQuery += " (SELECT DISTINCT EE9_COD_I, EE9_PEDIDO, EE9_RE, EE9_DTRE"+CENT
cQuery += " ,(CASE WHEN EE9_PRCTOT = 0 THEN EE9_PRECO ELSE EE9_PRCTOT END / (CASE WHEN EE9_QTDEM1 = 0 THEN 1 ELSE EE9_QTDEM1 END * CASE WHEN EE9_QE = 0 THEN 1 ELSE EE9_QE END)) EE9_PRECO "+CENT
cQuery += " ,EE9_PRCTOT, EE9_QTDEM1 * EE9_QE AS EE9_QTDEM1, EE9_PREEMB "+CENT
cQuery += " FROM "+RetSqlName("EE9")+" EE9"+CENT
cQuery += " WHERE SUBSTRING(EE9_CF,2,3) = '501'"+CENT
cQuery += " AND EE9_PEDIDO NOT LIKE '%SAC%'"+CENT
cQuery += " AND EE9.D_E_L_E_T_ = '')"+CENT
cQuery += " AS  EE9"+CENT
cQuery += " ON SubString(SZ3.Z3_CTRDP,2,24) = SubString(EE9.EE9_COD_I,2,24) "+CENT

cQuery += " LEFT JOIN"+CENT
cQuery += " (SELECT EEC_PEDREF, EEC_IMPODE, EEC_EMBARC, EEC_NRINVO, EEC_PREEMB, EEC_IMPORT"+CENT
cQuery += " FROM "+RetSqlName("EEC")+CENT
If !Empty(MV_PAR02)
	cQuery += "	WHERE EEC_IMPORT = "+MV_PAR02+CENT
	cQuery += " AND D_E_L_E_T_ = '')"+CENT
Else
	cQuery += " WHERE D_E_L_E_T_ = '')"+CENT
EndIf
cQuery += " AS EEC"+CENT
cQuery += " ON EEC.EEC_PEDREF = EE9.EE9_PEDIDO AND EE9.EE9_PREEMB = EEC.EEC_PREEMB"+CENT
cQuery += " ORDER BY CN9_XFORNE,EE9_COD_I, EE9_PEDIDO"+CENT

MemoWrite("C:\Tmp\EDFR020E.txt",cQuery)
cQuery := ChangeQuery(cQuery)

// 26/12/16 - Luis Felipe - Fim

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
Local nPESLIQ := 0
Local nPRCTOT := 0
Local nPRCTOTP:= 0
Local nPRCTOTG:= 0
Local nPESLIQ2 := 0
Local nPRCTOT2 := 0
Local nPRCTOT2G:= 0
Local nCont	   := 0
Local nPRECOM  := 0

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

If !(cAliasQry)->(EOF())
	
	While !(cAliasQry)->(EOf())
		nLin ++
		(cAliasQry)->(DbSkip())
	End
	
	ProcRegua(nLin)
	
	nLin := nLin * 8
	
	(cAliasQry)->(DbGotop())
	
	
	
	
	cXml := '<?xml version="1.0"?>'+CENT
	cXml += '<?mso-application progid="Excel.Sheet"?>'+CENT
	cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
	cXml += ' xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT
	cXml += ' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT
	cXml += 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
	cXml += 'xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT
	cXml += '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT
	cXml += ' <Author>Luis Filipe Nascimento</Author>'+CENT
	cXml += ' <LastAuthor>Luis Filipe Nascimento</LastAuthor>'+CENT
	cXml += ' <Created>2015-08-31T14:41:24Z</Created>'+CENT
	cXml += ' <LastSaved>2015-09-25T14:45:37Z</LastSaved>'+CENT
	cXml += ' <Version>15.00</Version>'+CENT
	cXml += '</DocumentProperties>'+CENT
	cXml += '<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CENT
	cXml += ' <AllowPNG/>'+CENT
	cXml += '</OfficeDocumentSettings>'+CENT
	cXml += '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
	cXml += ' <WindowHeight>7755</WindowHeight>'+CENT
	cXml += ' <WindowWidth>20490</WindowWidth>'+CENT
	cXml += ' <WindowTopX>0</WindowTopX>'+CENT
	cXml += ' <WindowTopY>0</WindowTopY>'+CENT
	cXml += ' <ProtectStructure>False</ProtectStructure>'+CENT
	cXml += ' <ProtectWindows>False</ProtectWindows>'+CENT
	cXml += '</ExcelWorkbook>'+CENT
	cXml += '<Styles>'+CENT
	cXml += ' <Style ss:ID="Default" ss:Name="Normal">'+CENT
	cXml += '  <Alignment ss:Vertical="Bottom"/>'+CENT
	cXml += '  <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior/>'+CENT
	cXml += '   <NumberFormat/>'+CENT
	cXml += '   <Protection/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707829504">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#808080"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#808080"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#808080"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#000080" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707829524">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707829564">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707829584">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#808080"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#808080"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707829604">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#808080"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#808080"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#808080"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707829624">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707829644">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707818708">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707818728">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707818748">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707818768">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707818788">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m148707818808">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s62">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s64">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s66">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s67">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s68">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s94">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s102">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s113">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s120">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s121">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s122">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s123">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s124">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s125">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s126">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s127">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s128">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s129">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s136">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s137">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s138">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s139">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="d/m/yy;@"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s140">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="d/m/yy;@"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s151">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s153">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s158">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#0000FF"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFEFD5" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s162">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#0000FF"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFEFD5" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="#,##0.000"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s164">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s165">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s166">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s171">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s172">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s173">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s174">'+CENT
	cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s210">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s211">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s213">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s214">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s215">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Top" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s216">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s217">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s218">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s219">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s220">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s221">'+CENT
	cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s222">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s223">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s224">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s225">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s226">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s228">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s229">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s231">'+CENT
	cXml += '   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s232">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s233">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s234">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s235">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s236">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s237">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s238">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += ' </Styles>'+CENT
	cXml += ' <Worksheet ss:Name="Relatorio">'+CENT
	cXml += '  <Table ss:ExpandedColumnCount="20" ss:ExpandedRowCount="'+Alltrim(Str(nLin))+'" x:FullColumns="1"'+CENT
	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="82.5"/>'+CENT
	cXml += '   <Column ss:Width="43.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="90"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="47.25" ss:Span="2"/>'+CENT
	cXml += '   <Column ss:Index="7" ss:AutoFitWidth="0" ss:Width="50.25"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="155.25"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="48.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="63.75"/>'+CENT
	cXml += '   <Column ss:Index="12" ss:AutoFitWidth="0" ss:Width="64.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="54.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="67.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="50.25"/>'+CENT
	cXml += '   <Column ss:Width="59.25"/>'+CENT
	cXml += '   <Column ss:Width="121.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="57.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="48.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="71.25"/>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="18.75">'+CENT
	cXml += '    <Cell ss:StyleID="s62"/>'+CENT
	cXml += '    <Cell ss:MergeAcross="16" ss:StyleID="s64"><Data ss:Type="String">Balance RE Payment</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">Emissao:</Data></Cell>'+CENT
	cDATABASE	:= SubStr(DtoS(Ddatabase),1,4)+"-"+SubStr(DtoS(Ddatabase),5,2)+"-"+SubStr(DtoS(Ddatabase),7,2)+"T00:00:00.000"
	cXml += '    <Cell ss:StyleID="s67"><Data ss:Type="DateTime">'+cDATABASE+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutogFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Crop:</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m148707818708"><Data ss:Type="String">'+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,2)+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="13" ss:MergeDown="4" ss:StyleID="m148707818728"/>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Buyer:</Data></Cell>'+CENT
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+MV_PAR02))
	cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m148707818748"><Data ss:Type="String">'+SA1->A1_NOME+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Seller:</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m148707818768"><Data ss:Type="String">'+MV_PAR03+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Contract:</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m148707818788"><Data ss:Type="String">'+MV_PAR04+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">DP:</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m148707818808"><Data ss:Type="String">'+MV_PAR05+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	FWrite(nArq,cXml)
	
	ncount		:= 0
	ncountq 	:= 0
	cXml		:= ""
	cContra		:= (cAliasQry)->Z3_CONTRA+(cAliasQry)->Z3_PERIODO // (cAliasQry)->EE9_COD_I
	cXFORNE 	:= (cAliasQry)->CN9_XFORNE
	lFez		:= .f.
	While !(cAliasQry)->(Eof())
		
		ncount += 1
		ncountq += 1
		
		IncProc(Str(ncount,5)+" de "+Str(nLin-(nLin/9),5)+ " registros" )
		
		cZ3_DTINIC 	:= If(!Empty((cAliasQry)->Z3_DTINIC),SubStr((cAliasQry)->Z3_DTINIC,1,4)+"-"+SubStr((cAliasQry)->Z3_DTINIC,5,2)+"-"+SubStr((cAliasQry)->Z3_DTINIC,7,2)+"T00:00:00.000","")
		cZ3_DTFIM	:= If(!Empty((cAliasQry)->Z3_DTFIM) ,SubStr((cAliasQry)->Z3_DTFIM,1,4)+"-"+SubStr((cAliasQry)->Z3_DTFIM,5,2)+"-"+SubStr((cAliasQry)->Z3_DTFIM,7,2)+"T00:00:00.000","")
		cEE9_DTRE  := If(!Empty((cAliasQry)->EE9_DTRE),SubStr((cAliasQry)->EE9_DTRE,1,4)+"-"+SubStr((cAliasQry)->EE9_DTRE,5,2)+"-"+SubStr((cAliasQry)->EE9_DTRE,7,2)+"T00:00:00.000","")
		cZ3_DTFIEM  := If(!Empty((cAliasQry)->Z3_DTINEM),SubStr((cAliasQry)->Z3_DTFIEM,1,4)+"-"+SubStr((cAliasQry)->Z3_DTFIEM,5,2)+"-"+SubStr((cAliasQry)->Z3_DTFIEM,7,2)+"T00:00:00.000","")
		cZ3_DTFIEM  := Ctod("99/99/9999")
		
		nPESLIQ += (cAliasQry)->EE9_QTDEM1
		nPRECOM += (cAliasQry)->EE9_PRECO
		nPRCTOT := (cAliasQry)->EE9_PRCTOT
		nPRCTOTP+= nPRCTOT
		nPRCTOTG+= nPRCTOT
		nCont   ++
		
		If cXFORNE <> (cAliasQry)->CN9_XFORNE .or. !lFez
			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			cXml += '    <Cell ss:MergeAcross="19" ss:StyleID="m148707829504"><Data ss:Type="String">'+(cAliasQry)->CN9_XFORNE+'</Data></Cell>'+CENT
			cXml += '   </Row>'+CENT
			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			cXml += '    <Cell ss:StyleID="s94"><Data ss:Type="String">Sale</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s94"><Data ss:Type="String">Purchase</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s94"><Data ss:Type="String">Buyer</Data></Cell>'+CENT
			cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="m148707829524"><Data ss:Type="String">Delivery</Data></Cell>'+CENT
			cXml += '    <Cell ss:MergeDown="1" ss:StyleID="s102"><Data ss:Type="String">Qty.(MT)</Data></Cell>'+CENT
			cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m148707829564"><Data ss:Type="String">Balance to be</Data></Cell>'+CENT
			cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m148707829584"><Data ss:Type="String">RE</Data></Cell>'+CENT
			cXml += '    <Cell ss:MergeAcross="5" ss:StyleID="m148707829604"><Data ss:Type="String">PAYMENTS</Data></Cell>'+CENT
			cXml += '   </Row>'+CENT
			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			cXml += '    <Cell ss:StyleID="s113"><Data ss:Type="String">Ctrc</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s113"><Data ss:Type="String">Ctrc</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s113"><Data ss:Type="String">Purch.</Data></Cell>'+CENT
			cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="m148707829624"><Data ss:Type="String">Period</Data></Cell>'+CENT
			cXml += '    <Cell ss:Index="8" ss:MergeAcross="1" ss:StyleID="m148707829644"><Data'+CENT
			cXml += '      ss:Type="String">Allocated(MT)</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">Number</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">Date</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">US$</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s120"><Data ss:Type="String">Qty.</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s121"><Data ss:Type="String">Price US$</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s122"><Data ss:Type="String">Payment</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s123"><Data ss:Type="String">Value dt.</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s123"><ss:Data ss:Type="String"'+CENT
			cXml += '      xmlns="http://www.w3.org/TR/REC-html40"><B><Font html:Color="#000000">Type (</Font><I><Font'+CENT
			cXml += '         html:Color="#000000">for product payments</Font></I><Font'+CENT
			cXml += '        html:Color="#000000">)</Font></B></ss:Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s123"><Data ss:Type="String">Quantity</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s123"><Data ss:Type="String">Unit US$</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s124"><Data ss:Type="String">Total US$</Data></Cell>'+CENT
			cXml += '   </Row>'+CENT
			cXFORNE := (cAliasQry)->CN9_XFORNE
		EndIf
		
		If Alltrim(cContra) <> (cAliasQry)->Z3_CONTRA+(cAliasQry)->Z3_PERIODO .or. !lFez
			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			cXml += '    <Cell ss:StyleID="s125"><Data ss:Type="String">'+(cAliasQry)->Z3_CONTRA+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s126"><Data ss:Type="String">'+'P'+SubStr((cAliasQry)->Z3_CONTRA,2,15)+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s125"><Data ss:Type="String">'+(cAliasQry)->EEC_IMPODE+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s127"><Data ss:Type="String">'+(cAliasQry)->Z3_PERIODO+'</Data></Cell>'+CENT
			If !Empty(cZ3_DTINIC)
				cXml += '    <Cell ss:StyleID="s128"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s128"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			If !Empty(cZ3_DTFIM)
				cXml += '    <Cell ss:StyleID="s129"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s129"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			
			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">'+Transform((cAliasQry)->Z3_QUANT,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s216"><Data ss:Type="String">'+(cAliasQry)->EEC_EMBARC+'</Data></Cell>'+CENT
			
			If (cAliasQry)->EE9_QTDEM1 <> 0
				cXml += '    <Cell ss:StyleID="s217"><Data ss:Type="String">'+Transform((cAliasQry)->EE9_QTDEM1,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s217"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			
			cXml += '    <Cell ss:StyleID="s236"><Data ss:Type="String">'+(cAliasQry)->EE9_RE+'</Data></Cell>'+CENT
			
			If !Empty(cEE9_DTRE) .and. !Empty((cAliasQry)->EEC_EMBARC)
				cXml += '    <Cell ss:StyleID="s219"><Data ss:Type="DateTime">'+cEE9_DTRE+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s219"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			
			If !Empty((cAliasQry)->EEC_EMBARC)
				cXml += '    <Cell ss:StyleID="s220"><Data ss:Type="String">'+Transform((cAliasQry)->EE9_PRECO,"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s217"><Data ss:Type="String">'+Transform((cAliasQry)->EE9_QTDEM1,"@E 999,999,999.999")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s222"><Data ss:Type="String">'+Transform((cAliasQry)->EE9_PRCTOT,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s220"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s217"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s222"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			
			cChave := 'P'+Rtrim(SubStr((cAliasQry)->Z3_CONTRA,2,15))+'-'+Rtrim((cAliasQry)->Z3_PERIODO)
			
			xPos  := Ascan(aPgtos,{|x| x[1] == cChave })
			
			If xPos <> 0
				cZJ_VENCTO:= If(!Empty(aPgtos[xPos][3]),SubStr(aPgtos[xPos][3],1,4)+"-"+SubStr(aPgtos[xPos][3],5,2)+"-"+SubStr(aPgtos[xPos][3],7,2)+"T00:00:00.000","")
				nPESLIQ2 += aPgtos[xPos][5]
				nPRCTOT2 += aPgtos[xPos][7]
				nPRCTOT2G += aPgtos[xPos][7]
				cXml += '    <Cell ss:StyleID="s218"><Data ss:Type="String">'+aPgtos[xPos][2]+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s219"><Data ss:Type="DateTime">'+cZJ_VENCTO+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s221"><Data ss:Type="String">'+aPgtos[xPos][4]+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s217"><Data ss:Type="String">'+Transform(aPgtos[xPos][5],"@E 999,999,999.999")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s220"><Data ss:Type="String">'+Transform(aPgtos[xPos][6],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s222"><Data ss:Type="String">'+Transform(aPgtos[xPos][7],"@E 999,999,999.99")+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s218"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s219"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s221"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s217"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s220"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s222"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			cXml += '   </Row>'+CENT
			lFez	 := .t.
			cContra  := (cAliasQry)->Z3_CONTRA+(cAliasQry)->Z3_PERIODO
		Else
			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			cXml += '    <Cell ss:StyleID="s165"/>'+CENT
			cXml += '    <Cell ss:StyleID="s164"/>'+CENT
			cXml += '    <Cell ss:StyleID="s165"/>'+CENT
			cXml += '    <Cell ss:StyleID="s166"/>'+CENT
			cXml += '    <Cell ss:StyleID="s172"/>'+CENT
			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
			cXml += '    <Cell ss:StyleID="s214"/>'+CENT
			cXml += '    <Cell ss:StyleID="s223"><Data ss:Type="String">'+(cAliasQry)->EEC_EMBARC+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s171"><Data ss:Type="String">'+Transform((cAliasQry)->EE9_QTDEM1,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s237"><Data ss:Type="String">'+(cAliasQry)->EE9_RE+'</Data></Cell>'+CENT
			If !Empty(cEE9_DTRE)
				cXml += '    <Cell ss:StyleID="s172"><Data ss:Type="DateTime">'+cEE9_DTRE+'</Data></Cell>'+CENT
			Else
				cXml += '    <Cell ss:StyleID="s172"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			
			cXml += '    <Cell ss:StyleID="s173"><Data ss:Type="String">'+Transform((cAliasQry)->EE9_PRECO,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s171"><Data ss:Type="String">'+Transform((cAliasQry)->EE9_QTDEM1,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s224"><Data ss:Type="String">'+Transform((cAliasQry)->EE9_PRCTOT,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			
			xPos ++
			
			lLen := xPos > Len(aPgtos)
			
			If !lLen
				If Alltrim(aPgtos[xPos][1]) == Alltrim((cAliasQry)->EE9_COD_I)
					cZJ_VENCTO	:= If(!Empty(aPgtos[xPos][3]),SubStr(aPgtos[xPos][3],1,4)+"-"+SubStr(aPgtos[xPos][3],5,2)+"-"+SubStr(aPgtos[xPos][3],7,2)+"T00:00:00.000","")
					nPESLIQ2 	+= aPgtos[xPos][5]
					nPRCTOT2 	+= aPgtos[xPos][7]
					nPRCTOT2G 	+= aPgtos[xPos][7]
					cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+aPgtos[xPos][2]+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s172"><Data ss:Type="DateTime">'+cZJ_VENCTO+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s174"><Data ss:Type="String">'+aPgtos[xPos][4]+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s171"><Data ss:Type="String">'+Transform(aPgtos[xPos][5],"@E 999,999,999.999")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s173"><Data ss:Type="String">'+Transform(aPgtos[xPos][6],"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s224"><Data ss:Type="String">'+Transform(aPgtos[xPos][7],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				Else
					cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s172"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s174"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s171"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s173"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s224"><Data ss:Type="String"></Data></Cell>'+CENT
				EndIf
			Else
				cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s172"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s174"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s171"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s173"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s224"><Data ss:Type="String"></Data></Cell>'+CENT
			EndIf
			cXml += '   </Row>'+CENT
		EndIf
		
		nQuant := (cAliasQry)->Z3_QUANT
		
		(cAliasQry)->(DbSkip())
		
		xMais := xPos + 1
		
		If xMais <= Len(aPgtos) .and. Alltrim(aPgtos[xMais][1]) == cchave .and. xMais > 1
			
			xPos ++
			
			For a:=xPos to Len(aPgtos)
				
				cXml += '   <Row ss:AutoFitHeight="0">'+CENT
				cXml += '    <Cell ss:StyleID="s165"/>'+CENT
				cXml += '    <Cell ss:StyleID="s164"/>'+CENT
				cXml += '    <Cell ss:StyleID="s165"/>'+CENT
				cXml += '    <Cell ss:StyleID="s166"/>'+CENT
				cXml += '    <Cell ss:StyleID="s172"/>'+CENT
				cXml += '    <Cell ss:StyleID="s210"/>'+CENT
				cXml += '    <Cell ss:StyleID="s214"/>'+CENT
				cXml += '    <Cell ss:StyleID="s223"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s171"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s237"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s172"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s173"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s171"><Data ss:Type="String"></Data></Cell>'+CENT
				cXml += '    <Cell ss:StyleID="s224"><Data ss:Type="String"></Data></Cell>'+CENT
				
				If Alltrim(aPgtos[a][1]) == cchave
					cZJ_VENCTO	:= If(!Empty(aPgtos[a][3]),SubStr(aPgtos[a][3],1,4)+"-"+SubStr(aPgtos[a][3],5,2)+"-"+SubStr(aPgtos[a][3],7,2)+"T00:00:00.000","")
					nPESLIQ2 	+= aPgtos[a][5]
					nPRCTOT2 	+= aPgtos[a][7]
					nPRCTOT2G 	+= aPgtos[a][7]
					cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+aPgtos[a][2]+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s172"><Data ss:Type="DateTime">'+cZJ_VENCTO+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s174"><Data ss:Type="String">'+aPgtos[a][4]+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s171"><Data ss:Type="String">'+Transform(aPgtos[a][5],"@E 999,999,999.999")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s173"><Data ss:Type="String">'+Transform(aPgtos[a][6],"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s224"><Data ss:Type="String">'+Transform(aPgtos[a][7],"@E 999,999,999.99")+'</Data></Cell>'+CENT
					cXml += '   </Row>'+CENT
				Else
					cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s172"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s174"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s171"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s173"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '    <Cell ss:StyleID="s224"><Data ss:Type="String"></Data></Cell>'+CENT
					cXml += '   </Row>'+CENT
					Exit
				EndIf
				
			Next
			
		EndIf
		
		nPRECOM := nPRCTOTP / nPESLIQ
		
		cXml += '   <Row ss:AutoFitHeight="0">'+CENT
		cXml += '    <Cell ss:StyleID="s136"/>'+CENT
		cXml += '    <Cell ss:StyleID="s137"/>'+CENT
		cXml += '    <Cell ss:StyleID="s136"/>'+CENT
		cXml += '    <Cell ss:StyleID="s138"/>'+CENT
		cXml += '    <Cell ss:StyleID="s139"/>'+CENT
		cXml += '    <Cell ss:StyleID="s140"/>'+CENT
		cXml += '    <Cell ss:StyleID="s215"/>'+CENT
		cXml += '    <Cell ss:StyleID="s225"><Data ss:Type="String">TO BE ALLOC.:</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s226"><Data ss:Type="String">'+Transform(nQuant-nPESLIQ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s238"/>'+CENT
		cXml += '    <Cell ss:StyleID="s228"/>'+CENT
		If nPESLIQ <> 0
			cXml += '    <Cell ss:StyleID="s229"><Data ss:Type="String">'+Transform(nPRECOM,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s226"><Data ss:Type="String">'+Transform(nPESLIQ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s234"><Data ss:Type="String">'+Transform(nPRCTOTP,"@E 999,999,999.99")+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s229"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s226"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s234"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
		cXml += '    <Cell ss:StyleID="s235"/>'+CENT
		cXml += '    <Cell ss:StyleID="s231"/>'+CENT
		cXml += '    <Cell ss:StyleID="s232"/>'+CENT
		If nPESLIQ2 <> 0
			cXml += '    <Cell ss:StyleID="s226"><Data ss:Type="String">'+Transform(nPESLIQ2,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s226"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
		cXml += '    <Cell ss:StyleID="s233"/>'+CENT
		If nPRCTOT2 <> 0
			cXml += '    <Cell ss:StyleID="s234"><Data ss:Type="String">'+Transform(nPRCTOT2,"@E 999,999,999.99")+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s234"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
		cXml += '   </Row>'+CENT
		
		cXml += '   <Row ss:AutoFitHeight="0">'+CENT
		cXml += '    <Cell ss:MergeAcross="18" ss:StyleID="s153"><Data ss:Type="String">Balance for Delivery Period :</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s151"><Data ss:Type="String">'+Transform(nPRCTOTP-nPRCTOT2,"@E 999,999,999.99")+'</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT
		
		If cXFORNE <> (cAliasQry)->CN9_XFORNE .or. (cAliasQry)->(Eof())
			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			cXml += '    <Cell ss:MergeAcross="18" ss:StyleID="s158"><Data ss:Type="String">Total Balance for Contract  :                         </Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s162"><Data ss:Type="String">'+Transform(nPRCTOTG-nPRCTOT2G,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '   </Row>'+CENT
			nPRCTOTG:= 0
		EndIf
		
		FWrite(nArq,cXml)
		cXml := ""
		nPRCTOTP:= 0
		nPESLIQ := 0
		nPRCTOT2:= 0
		nPESLIQ2:= 0
		nPRECOM := 0
		nCont	:= 0
		
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
	cXml += '   <Panes>'+CENT
	cXml += '    <Pane>'+CENT
	cXml += '     <Number>3</Number>'+CENT
	cXml += '     <ActiveRow>10</ActiveRow>'+CENT
	cXml += '     <ActiveCol>6</ActiveCol>'+CENT
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

//         1           2      3                        4                        5                        6           7     8   9   10  11    12   13           14      15      16      17   18   19      20      21      22      23   24        25   26   27   28   29        30   31   32   33   34   35   36   37   38        39   40  41  42           43
AADD(aSx1,{"EDFR020" , "01" , "Safra         	  ?" , "Safra         	   ?" , "Safra         	    ?" , "mv_ch1" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "@R 99/99" , ""})
AADD(aSx1,{"EDFR020" , "02" , "Comprador          ?" , "Comprador          ?" , "Comprador          ?" , "mv_ch2" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "SA1NT2", "" , "", "", ""         , ""})
AADD(aSx1,{"EDFR020" , "03" , "Vendedor           ?" , "Vendedor           ?" , "Vendedor           ?" , "mv_ch3" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "Z6_FOR", "" , "", "", "" 		, ""})
AADD(aSx1,{"EDFR020" , "04" , "Contrato           ?" , "Contrato           ?" , "Contrato           ?" , "mv_ch4" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "SZ3"   , "" , "", "", "" 		, ""})
AADD(aSx1,{"EDFR020" , "05" , "DP                 ?" , "DP                 ?" , "DP                 ?" , "mv_ch5" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" 		, ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR020   05")
	
	DbSeek("EDFR020")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR020"
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
