#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥ EDFR022     ≥ Autor ≥ Luis Felipe Mattos	≥ Data ≥ 26.10.15 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Relatorio de Fornecedores Usinas  				 		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 		 ≥ Gera Excel - Contabil 			                      	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum													  ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function EDFR022()

Local 	nOrdem
Local 	cQuery		:= ""
Private   cAliasQry := GetNextAlias()
Private cString    	:= "SZ3"
Private wnrel      	:= "EDFR022"
Private aOrd       	:= {"Fornecedore"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Relatorio de Fornecedores Usinas"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Relatorio de Fornecedores Usinas", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR022"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR022"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR022"
Private _nlin      	:= 70
Private Cabec1     	:= " "
Private Cabec2     	:= " "
Private nCountnx    := 0
Private nCountny    := 1  
Private aPgtos		:= {}
Private	cFORNECE 	:= TamSx3("A2_COD")[1]
Private	cNFORNEC 	:= TamSx3("A2_NREDUZ")[1]
Private	cDOC     	:= TamSx3("F1_DOC")[1]
Private	cCONTRA  	:= TamSx3("Z3_CTRDP")[1]
Private	cDOCCOMP 	:= TamSx3("F1_DOC")[1]
Private	cUSUARIO 	:= Space(20)
Private aDados		:= {}
Public  aForCtr		:= Nil

CriaSx1()

IF !Pergunte(cPerg,.T.)
	RETURN
ENDIF

If LastKey() == 27
	Return
Endif

MV_PAR03 := If(Empty(MV_PAR03),Ddatabase,MV_PAR03)

cQuery := " SELECT 'D' AS TIPO,SUBSTRING(CT2_ORIGEM,3,3) AS CT2_SQLP,SUBSTRING(CT2_ORIGEM,7,3) AS CT2_SQLAN,R_E_C_N_O_ AS REG,*"+CENT
cQuery += " FROM  "+RetSqlName("CT2")+" CT2"+CENT 
cQuery += " WHERE 	CT2_FILORI BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'"+CENT
cQuery += " AND   	CT2_DATA   BETWEEN '"+DtoS(MV_PAR02)+"' AND '"+DtoS(MV_PAR03)+"'"+CENT 
cQuery += " AND   	CT2_DEBITO = '"+MV_PAR01+"'"+CENT 
cQuery += " AND   	(CT2_MOEDLC = '02' OR  CT2_MOEDLC = '01')"+CENT  
cQuery += " AND   	CT2_TPSALD = '"+MV_PAR07+"'"+CENT
cQuery += " AND 	(CT2_DC = '1' OR CT2_DC = '3')"+CENT 
cQuery += " AND 	CT2_VALOR <> '0' "+CENT 
cQuery += " AND 	D_E_L_E_T_ = ' '"+CENT  
 
cQuery += " UNION "+CENT

cQuery += " SELECT 'C' AS TIPO,SUBSTRING(CT2_ORIGEM,3,3) AS CT2_SQLP,SUBSTRING(CT2_ORIGEM,7,3) AS CT2_SQLAN,R_E_C_N_O_ AS REG,*"+CENT
cQuery += " FROM  "+RetSqlName("CT2")+" CT2"+CENT 
cQuery += " WHERE 	CT2_FILORI BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'"+CENT
cQuery += " AND   	CT2_DATA   BETWEEN '"+DtoS(MV_PAR02)+"' AND '"+DtoS(MV_PAR03)+"'"+CENT 
cQuery += " AND   	CT2_CREDIT = '"+MV_PAR01+"'"+CENT 
cQuery += " AND   	(CT2_MOEDLC = '02' OR  CT2_MOEDLC = '01')"+CENT  
cQuery += " AND   	CT2_TPSALD = '"+MV_PAR07+"'"+CENT
cQuery += " AND 	(CT2_DC = '2' OR CT2_DC = '3')"+CENT 
cQuery += " AND 	CT2_VALOR <> '0' "+CENT 
cQuery += " AND 	D_E_L_E_T_ = ' '"+CENT  
cQuery += " ORDER BY CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_SEQLAN"+CENT

MemoWrite("C:\Tmp\EDFR022.txt",cQuery)
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

		If  (cAliasQry)->CT2_VALOR == 0
			DbSkip()
			Loop
		EndIf
		
		nPos := aScan(aDados,{|x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]+x[8]+X[14]+X[19]+X[20]+X[21] == (cAliasQry)->CT2_FILIAL+(cAliasQry)->CT2_LOTE+(cAliasQry)->CT2_SBLOTE+(cAliasQry)->CT2_DOC+(cAliasQry)->CT2_SEQLAN+(cAliasQry)->CT2_EMPORI+(cAliasQry)->CT2_FILORI+(cAliasQry)->CT2_DATA+(cAliasQry)->TIPO+(cAliasQry)->CT2_LINHA+(cAliasQry)->CT2_KEY+(cAliasQry)->CT2_SEQHIS})

		If	nPos == 0
			If (cAliasQry)->CT2_MOEDLC == "01" // Real
				Aadd(aDados,{(cAliasQry)->CT2_FILIAL,(cAliasQry)->CT2_LOTE,(cAliasQry)->CT2_SBLOTE,(cAliasQry)->CT2_DOC,(cAliasQry)->CT2_SEQLAN,(cAliasQry)->CT2_EMPORI,(cAliasQry)->CT2_FILORI,(cAliasQry)->CT2_DATA,(cAliasQry)->CT2_HIST,(cAliasQry)->CT2_SQLP,(cAliasQry)->CT2_SQLAN,(cAliasQry)->CT2_ORIGEM,(cAliasQry)->CT2_USRCNF,(cAliasQry)->TIPO,(cAliasQry)->REG,(cAliasQry)->CT2_MOEDLC,(cAliasQry)->CT2_VALOR,0,(cAliasQry)->CT2_LINHA,(cAliasQry)->CT2_KEY,(cAliasQry)->CT2_SEQHIS})      
			ElseIf (cAliasQry)->CT2_MOEDLC == "02"
				Aadd(aDados,{(cAliasQry)->CT2_FILIAL,(cAliasQry)->CT2_LOTE,(cAliasQry)->CT2_SBLOTE,(cAliasQry)->CT2_DOC,(cAliasQry)->CT2_SEQLAN,(cAliasQry)->CT2_EMPORI,(cAliasQry)->CT2_FILORI,(cAliasQry)->CT2_DATA,(cAliasQry)->CT2_HIST,(cAliasQry)->CT2_SQLP,(cAliasQry)->CT2_SQLAN,(cAliasQry)->CT2_ORIGEM,(cAliasQry)->CT2_USRCNF,(cAliasQry)->TIPO,(cAliasQry)->REG,(cAliasQry)->CT2_MOEDLC,0,(cAliasQry)->CT2_VALOR,(cAliasQry)->CT2_LINHA,(cAliasQry)->CT2_KEY,(cAliasQry)->CT2_SEQHIS})      
			EndIf	
			nLin ++                
		Else
			If (cAliasQry)->CT2_MOEDLC == "01" // Real
				aDados[nPos][17] := (cAliasQry)->CT2_VALOR
			Else                                          
				aDados[nPos][18] := (cAliasQry)->CT2_VALOR
			EndIf	
		EndIf
	 	(cAliasQry)->(DbSkip())
	End
	
	ProcRegua(nLin-15)
	
 	cXml := '<?xml version="1.0"?>'+CENT
 	cXml += '<?mso-application progid="Excel.Sheet"?>'+CENT
 	cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
  	cXml += 'xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT
  	cXml += 'xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT
  	cXml += 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
 	cXml += ' xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT
 	cXml += ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT
 	cXml += '  <Author>Luis Filipe Nascimento</Author>'+CENT
  	cXml += '  <LastAuthor>Luis Filipe Nascimento</LastAuthor>'+CENT
  	cXml += '  <Created>2015-10-26T16:20:45Z</Created>'+CENT
  	cXml += '  <LastSaved>2015-10-26T16:48:11Z</LastSaved>'+CENT
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
  	cXml += '  <Style ss:ID="m571601116928">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571604155952">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571604155972">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571604155992">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571604156012">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571604156032">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571604156052">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571562709312">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="m571562709352">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="m571562709372">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += ' 	 <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571562709392">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571562709412">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571562709432">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571562709452">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="m571562709472">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s62">'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s63">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s64">'+CENT
 	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s65">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s66">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s67">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s68">'+CENT
 	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s69">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s70">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s71">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
  	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s72">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s73">'+CENT
  	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s74">'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s79">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s80">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s81">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s82">'+CENT
 	cXml += '   <Alignment ss:Vertical="Center"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s83">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s84">'+CENT
  	cXml += '   <Alignment ss:Vertical="Center"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="#,##0.0000"/>'+CENT
  	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s85">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s87">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="#,##0.0000"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s100">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s117">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s118">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s119">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += ' </Styles>'+CENT
 	cXml += ' <Worksheet ss:Name="Parametros">'+CENT
 	cXml += '  <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="9" x:FullColumns="1"'+CENT
 	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="96"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="154.5"/>'+CENT
  	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
 	cXml += '    <Cell ss:StyleID="s62"><Data ss:Type="String">Relatorio </Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">Fornecedores Usinas</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
 	cDATABASE	:= SubStr(DtoS(Ddatabase),1,4)+"-"+SubStr(DtoS(Ddatabase),5,2)+"-"+SubStr(DtoS(Ddatabase),7,2)+"T00:00:00.000"
  	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
  	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Emissao </Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="DateTime">'+cDATABASE+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
 	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">Parametros</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s67"/>'+CENT
  	cXml += '   </Row>'+CENT
  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Conta</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">'+MV_PAR01+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT

 	cMV_PAR02	:= If(!Empty(MV_PAR02),SubStr(DtoS(MV_PAR02),1,4)+"-"+SubStr(DtoS(MV_PAR02),5,2)+"-"+SubStr(DtoS(MV_PAR02),7,2)+"T00:00:00.000","")
	cXml += '   <Row>'+CENT
  	cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">Data De</Data></Cell>'+CENT
	If !Empty(cMV_PAR02)
	  	cXml += '    <Cell ss:StyleID="s71"><Data ss:Type="DateTime">'+cMV_PAR02+'</Data></Cell>'+CENT
    Else
		cXml += '    <Cell ss:StyleID="s71"><Data ss:Type="String"></Data></Cell>'+CENT
    EndIf
	cXml += '   </Row>'+CENT

 	cMV_PAR03	:= If(!Empty(MV_PAR03),SubStr(DtoS(MV_PAR03),1,4)+"-"+SubStr(DtoS(MV_PAR03),5,2)+"-"+SubStr(DtoS(MV_PAR03),7,2)+"T00:00:00.000","")
	cXml += '   <Row>'+CENT
 	cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">Data Ate</Data></Cell>'+CENT
	If !Empty(cMV_PAR03)
	  	cXml += '    <Cell ss:StyleID="s71"><Data ss:Type="DateTime">'+cMV_PAR03+'</Data></Cell>'+CENT
    Else
		cXml += '    <Cell ss:StyleID="s71"><Data ss:Type="String"></Data></Cell>'+CENT
    EndIf
	cXml += '   </Row>'+CENT

  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 	cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">Filial De</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s72"><Data ss:Type="String">'+MV_PAR04+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  	cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">Filial Ate</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s72"><Data ss:Type="String">'+MV_PAR05+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
 	cXml += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Fornecedor</Data></Cell>'+CENT
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
 	cXml += '   <Unsynced/>'+CENT
 	cXml += '   <Print>'+CENT
  	cXml += '    <ValidPrinterInfo/>'+CENT
  	cXml += '    <PaperSizeIndex>9</PaperSizeIndex>'+CENT
  	cXml += '    <HorizontalResolution>-3</HorizontalResolution>'+CENT
 	cXml += '    <VerticalResolution>-3</VerticalResolution>'+CENT
 	cXml += '   </Print>'+CENT
 	cXml += '   <Panes>'+CENT
  	cXml += '    <Pane>'+CENT
  	cXml += '     <Number>3</Number>'+CENT
  	cXml += '     <ActiveCol>2</ActiveCol>'+CENT
 	cXml += '    </Pane>'+CENT
 	cXml += '   </Panes>'+CENT
 	cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
  	cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
  	cXml += '  </WorksheetOptions>'+CENT
  	cXml += ' </Worksheet>'+CENT
 	cXml += ' <Worksheet ss:Name="Relatorio">'+CENT
 	cXml += '  <Table ss:ExpandedColumnCount="18" ss:ExpandedRowCount="'+Alltrim(Str(nLin))+'" x:FullColumns="1"'+CENT
 	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="75.75"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="78"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="57.75"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="62.25"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="132"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="60.75"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="65.25"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="72"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="95.25" ss:Span="3"/>'+CENT
 	cXml += '   <Column ss:Index="13" ss:AutoFitWidth="0" ss:Width="54"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="111"/>'+CENT
 	cXml += '   <Column ss:Width="41.25"/>'+CENT
  	cXml += '   <Column ss:Width="36.75" ss:Span="1"/>'+CENT
  	cXml += '   <Column ss:Index="18" ss:AutoFitWidth="0" ss:Width="656.25"/>'+CENT
  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571601116928"><Data ss:Type="String">Conta</Data></Cell>'+CENT
 	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571562709352"><Data ss:Type="String">Data da Contabilizacao</Data></Cell>'+CENT
 	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571562709372"><Data ss:Type="String">N Fornecedor</Data></Cell>'+CENT
  	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571562709392"><Data ss:Type="String">Filial do Fornecedor</Data></Cell>'+CENT
  	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571562709412"><Data ss:Type="String">Nome Fornecedor</Data></Cell>'+CENT
  	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571562709432"><Data ss:Type="String">Documento</Data></Cell>'+CENT
 	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571562709452"><Data ss:Type="String">Compensado</Data></Cell>'+CENT
 	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571562709472"><Data ss:Type="String">N do Contrato</Data></Cell>'+CENT
 	cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m571562709312"><Data ss:Type="String">Debito</Data></Cell>'+CENT
  	cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="s100"><Data ss:Type="String">Credito</Data></Cell>'+CENT
  	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571604155952"><Data ss:Type="String">Ptax</Data></Cell>'+CENT
  	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571604155972"><Data ss:Type="String">Usuario</Data></Cell>'+CENT
 	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571604155992"><Data ss:Type="String">LP</Data></Cell>'+CENT
 	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571604156012"><Data ss:Type="String">Lote</Data></Cell>'+CENT
 	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571604156032"><Data ss:Type="String">Doc</Data></Cell>'+CENT
  	cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m571604156052"><Data ss:Type="String">Historico</Data></Cell>'+CENT
  	cXml += '   </Row>'+CENT
  	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="22.5">'+CENT
 	cXml += '    <Cell ss:Index="9" ss:StyleID="s117"><Data ss:Type="String"> US$</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s118"><Data ss:Type="String">R$</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s118"><Data ss:Type="String"> US$</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s119"><Data ss:Type="String">R$</Data></Cell>'+CENT
  	cXml += '   </Row>'+CENT

	FWrite(nArq,cXml)

	ncount		:= 0 
	ncountq 	:= 0 
	cXml		:= "" 
	lFez		:= .f.
	For nx := 1 to Len(aDados)
		
		ncount += 1
		ncountq += 1 
		
		IncProc(Str(ncount,5)+" de "+Str(nLin-15,5)+ " registros" )

		cDATA 	:= If(!Empty(aDados[nx][8]),SubStr(aDados[nx][8],1,4)+"-"+SubStr(aDados[nx][8],5,2)+"-"+SubStr(aDados[nx][8],7,2)+"T00:00:00.000","")
         
        nCont   ++

		// Procura pelo complemento do historico
		CT2->(DbSetOrder(10))
		If CT2->(DbSeek(aDados[nx][1]+aDados[nx][8]+aDados[nx][2]+aDados[nx][3]+aDados[nx][4]+aDados[nx][5]+aDados[nx][6]+aDados[nx][7]))
			cHist := Rtrim(aDados[nx][9])
			CT2->(DbSkip())
			If CT2->CT2_DC == "4" 
				While !	CT2->(Eof()) 							.And.;
						CT2->CT2_FILIAL == aDados[nx][1]        .And.;
						CT2->CT2_LOTE   == aDados[nx][2]		.And.;
						CT2->CT2_SBLOTE == aDados[nx][3]		.And.;
						CT2->CT2_DOC    == aDados[nx][4] 		.And.;
						CT2->CT2_SEQLAN == aDados[nx][5]	 	.And.;
						CT2->CT2_EMPORI == aDados[nx][6]		.And.;
						CT2->CT2_FILORI == aDados[nx][7] 		.And.;
						DtoS(CT2->CT2_DATA) == aDados[nx][8]	.And.;
						CT2->CT2_DC     == "4" 				    
						cHist += Rtrim(CT2->CT2_HIST)
					CT2->(dbSkip())
				EndDo
			EndIf
		EndIf
 
 		// Checa Layout do LP
		lLayOut := .t.
		lFornec := .t.
		SZI->(DbSetOrder(1))         
		If SZI->(DbSeek(xFilial("SZI")+MV_PAR01+aDados[nx][10]+aDados[nx][11]))
			
			cDOC     := SubStr(cHist,Val(SubStr(SZI->ZI_DOC    ,1,2)),Val(SubStr(SZI->ZI_DOC    ,3,4)))

			// Particularidades 597/001 e 597/002
			If aDados[nx][10]+aDados[nx][11] == '597001'
				RecLock("SZI",.f.)
				If 	Substr(cHist,1,8) == "COMPENS."   
					SZI->ZI_DOC     := '1309'
					SZI->ZI_NOMEFOR := '4010'
					SZI->ZI_CONTRA  := '6612'
					SZI->ZI_DOCCOMP := '3009'
				ElseIf Substr(cHist,1,10) == "COMP. TIT "
					SZI->ZI_DOC     := '1409'
					SZI->ZI_NOMEFOR := '4010'
					SZI->ZI_CONTRA  := '8212'
					SZI->ZI_DOCCOMP := '3109'
				ElseIf Substr(cHist,1,12) == "COMP. TITULO"
					SZI->ZI_DOC     := '1709'
					SZI->ZI_NOMEFOR := '4410'
					SZI->ZI_CONTRA  := '7512'
					SZI->ZI_DOCCOMP := '3409'
				Endif
				MsunLock()
			EndIf

			// Checa variaÁıes no tamanho do documento
			
			nTamDoc := TamSx3("F1_DOC")[1]
			xDoc := ""
			For a:=1 to nTamDoc
				If SubStr(cDOC,a,1) $ " 0123456789"  
					xDoc += SubStr(cDOC,a,1)
				Else
					Exit	
				EndIf 
			Next
			cDoc := xDoc+Space(TamSx3("F1_DOC")[1]-Len(xDoc))

			nLenDoc  := -1 * (Len(xDoc) - nTamDoc) // Reposiciona

			cFORNECE := If(!Empty(SZI->ZI_FORNEC),SubStr(cHist,Val(SubStr(SZI->ZI_FORNEC ,1,2))-nLenDoc,Val(SubStr(SZI->ZI_FORNEC ,3,4))),lFornec:=.f.)
			cNFORNEC := SubStr(cHist,Val(SubStr(SZI->ZI_NOMEFOR,1,2))-nLenDoc,Val(SubStr(SZI->ZI_NOMEFOR,3,4)))

			// Checa variaÁıes no tamanho do Nome do Fornecedor

			nTamNRed := TamSx3("A2_NREDUZ")[1]
			If !lFornec 
				aFor := fFor(cNFORNEC)
				If Len(aFor) > 0 
					cFORNECE := aFor[1]
					cNFORNEC := aFor[2] 
				EndIf
			EndIf

			cDOCCOMP := If(!Empty(SZI->ZI_DOCCOMP),SubStr(cHist,Val(SubStr(SZI->ZI_DOCCOMP,1,2))-nLenDoc,Val(SubStr(SZI->ZI_DOCCOMP,3,4))),"") 

            nLenNFor := -1 * (Len(Alltrim(aFor[2])) - nTamNRed)   // Reposiciona

			// Particularidades 660/116 e 660/118
			If aDados[nx][10]+aDados[nx][11] $ '660116/660118'     
				RecLock("SZI",.f.)
				If 	Substr(cHist,57-(nLenDoc+nLenNFor),1) == "-"
					SZI->ZI_CONTRA  := '6313'
				Else
					SZI->ZI_CONTRA  := '6913'
				Endif
				MsunLock()
			EndIf

			cCONTRA  := SubStr(cHist,Val(SubStr(SZI->ZI_CONTRA ,1,2))-(nLenDoc+nLenNFor),Val(SubStr(SZI->ZI_CONTRA ,3,4)))
            
			SZ3->(DbSetOrder(3))
			If !SZ3->(DbSeek(xFilial("SZ3")+Alltrim(cCONTRA))) 
				For ny=1 to Len(cCONTRA)
				   	If SZ3->(DbSeek(xFilial("SZ3")+SubStr(cCONTRA,1,Len(cCONTRA)-ny))) 
				   		cCONTRA := SubStr(cCONTRA,1,Len(cCONTRA)-ny) 
				   		Exit
				   	EndIf	      
				Next
            EndIf

			If SZ3->(Eof()) 
				cCONTRA := fContra(cFORNECE,cDOC)			
            Endif        

			cUSUARIO := If(!Empty(SZI->ZI_USER)   ,SubStr(aDados[nx][12],Val(SubStr(SZI->ZI_USER,1,2)),Val(SubStr(SZI->ZI_USER,3,4))),"")  
			cNFORNEC := If(!SubStr(cNFORNEC,1,1) $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ",SubStr(cNFORNEC,2,08),cNFORNEC)

		Else
			cUSUARIO :=aDados[nx][13]
			lLayOut  := .f.
		EndIf

		nTXUSD := aDados[nx][17] / aDados[nx][18]

		lImprime := .t.
		If !Empty(MV_PAR06) 
			If !Alltrim(MV_PAR06) $ cFORNECE  
				lImprime := .f.
			EndIf
		EndIf
		
		If 	lImprime
			If lLayOut
			  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			 	cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String">'+MV_PAR01+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="DateTime">'+cDATA+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+cFORNECE+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+aDados[nx][1]+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s82"><Data ss:Type="String">'+cNFORNEC+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s83"><Data ss:Type="String">'+cDOC+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s83"><Data ss:Type="String">'+cDOCCOMP+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s83"><Data ss:Type="String">'+cCONTRA+'</Data></Cell>'+CENT
				If  aDados[nx][14] == 'D'  // Alltrim((cAliasQry)->CT2_DEBITO) == Alltrim(MV_PAR01)
				 	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(aDados[nx][18],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(aDados[nx][17],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String"></Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String"></Data></Cell>'+CENT
				Else
				 	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String"></Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String"></Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(aDados[nx][18],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(aDados[nx][17],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				Endif
			 	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(nTXUSD,"@E 999,999,999.9999")+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+cUSUARIO+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s82"><Data ss:Type="String">'+aDados[nx][10]+'/'+aDados[nx][11]+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+aDados[nx][02]+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+aDados[nx][04]+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s85"><Data ss:Type="String">'+cHist+Str(aDados[nx][15])+'</Data></Cell>'+CENT
			 	cXml += '   </Row>'+CENT
			Else
			  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			 	cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String">'+MV_PAR01+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="DateTime">'+cDATA+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String"></Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+aDados[nx][01]+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s82"><Data ss:Type="String"></Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s83"><Data ss:Type="String"></Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s83"><Data ss:Type="String"></Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s83"><Data ss:Type="String"></Data></Cell>'+CENT
				If 	aDados[nx][14] == 'D'
				 	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(aDados[nx][18],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(aDados[nx][17],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String"></Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String"></Data></Cell>'+CENT
				Else
				 	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String"></Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String"></Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(aDados[nx][18],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(aDados[nx][17],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				Endif
			 	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(nTXUSD,"@E 999,999,999.9999")+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+cUSUARIO+'</Data></Cell>'+CENT
			 	cXml += '    <Cell ss:StyleID="s82"><Data ss:Type="String">'+aDados[nx][10]+'/'+aDados[nx][11]+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+aDados[nx][02]+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+aDados[nx][04]+'</Data></Cell>'+CENT
			  	cXml += '    <Cell ss:StyleID="s85"><Data ss:Type="String">'+cHist+Str(aDados[nx][15])+'</Data></Cell>'+CENT
			 	cXml += '   </Row>'+CENT
			EndIf
	        
			If	ncountq == 380 .or. nx == Len(aDados) 
				FWrite(nArq,cXml)
				cXml := ""
				ncountq := 0 
			EndIf
	
   		EndIf
   		
		cNFORNEC := "" 
		cCONTRA  := "" 
		cDOCCOMP := "" 
		cFORNECE := ""
		cDoc 	 := ""
        
	Next
 	cXml += '  </Table>'+CENT
 	cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
  	cXml += '   <PageSetup>'+CENT
  	cXml += '    <Header x:Margin="0.31496062000000002"/>'+CENT
  	cXml += '    <Footer x:Margin="0.31496062000000002"/>'+CENT
 	cXml += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT
 	cXml += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT
 	cXml += '   </PageSetup>'+CENT
  	cXml += '   <Unsynced/>'+CENT
  	cXml += '   <Selected/>'+CENT
  	cXml += '   <Panes>'+CENT
 	cXml += '    <Pane>'+CENT
 	cXml += '     <Number>3</Number>'+CENT
 	cXml += '     <ActiveRow>2</ActiveRow>'+CENT
  	cXml += '     <ActiveCol>4</ActiveCol>'+CENT
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

******************************
Static Function fFor(cNFORNEC)
******************************
Local 	cQuery := ""
Private aFor   := {}
Private cAlias := "TRAB"  

cQuery := " SELECT A2_COD, A2_NREDUZ FROM "+RetSqlName("SA2")+" WHERE A2_NREDUZ LIKE '%"+Alltrim(cNFORNEC)+"%' AND D_E_L_E_T_ = ''"

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)   

If Select(cAlias) > 0
	aFor := {(cAlias)->A2_COD,(cAlias)->A2_NREDUZ}
EndIf

(cAlias)->(dbCloseArea())

Return(aFor)

**************************************
Static Function fContra(cFORNECE,cDOC)
**************************************
Local 	cQuery := ""
Local 	cDoc2  := Substr(cDOC,1,9)
Private cAlias := "TRAB"  

cQuery := " SELECT RTRIM(F1_CONTRA)+'-'+RTRIM(F1_XPERIOD) AS CONTRA FROM "+RetSqlName("SF1")+" WHERE F1_FORNECE = '"+cFORNECE+"' AND F1_DOC = '"+cDoc2+"' AND D_E_L_E_T_ = ''"

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)   

If Select(cAlias) > 0
	cCONTRA := (cAlias)->CONTRA
EndIf

(cAlias)->(dbCloseArea())

Return(cCONTRA)


*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                        4                        5                        6           7     8   9   10  11    12   13           14      15      16      17   18   19      20      21      22      23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38        39   40  41  42   43
AADD(aSx1,{"EDFR022" , "01" , "Conta         	  ?" , "Conta         	   ?" , "Conta         	    ?" , "mv_ch1" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1"   , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR022" , "02" , "Data De            ?" , "Data De            ?" , "Data De            ?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR022" , "03" , "Data Ate           ?" , "Data Ate           ?" , "Data Ate           ?" , "mv_ch3" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""		, "" , "", "", "" , ""})
AADD(aSx1,{"EDFR022" , "04" , "Filial De          ?" , "Filial De          ?" , "Filial De          ?" , "mv_ch4" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR022" , "05" , "Filial Ate         ?" , "Filial Ate         ?" , "Filial Ate         ?" , "mv_ch5" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""   	, "" , "", "", "" , ""})
AADD(aSx1,{"EDFR022" , "06" , "Fornecedor         ?" , "Fornecedor         ?" , "Fornecedor         ?" , "mv_ch6" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par06" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "Z6_FOR", "" , "", "", "" , ""})
AADD(aSx1,{"EDFR022" , "07" , "Tipo de Saldo      ?" , "Tipo de Saldo      ?" , "Tipo de Saldo      ?" , "mv_ch7" , "C" , 01 , 0 , 0 , "G" , "" , "mv_par07" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SLW", "" , "", "", "" , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR022   07")
	
	DbSeek("EDFR022")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR022"
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

/*		 	If (cAliasQry)->TIPO <> ' '  
				SM2->(DbSeek((cAliasQry)->CT2_DATA))
				If	(cAliasQry)->CT2_VLRUS == 0 
					nCT2_VLRUS := Round((cAliasQry)->CT2_VALOR * SM2->M2_MOEDA2,2)
					nCT2_VALOR := (cAliasQry)->CT2_VALOR 
				EndIf
				If	(cAliasQry)->CT2_VALOR == 0 
					nCT2_VALOR := Round((cAliasQry)->CT2_VLRUS / SM2->M2_MOEDA2,2)
					nCT2_VLRUS := (cAliasQry)->CT2_VLRUS
				EndIf 
	            nTXUSD == SM2->M2_MOEDA2
			Else

				nCT2_VLRUS := (cAliasQry)->CT2_VLRUS
				nCT2_VALOR := (cAliasQry)->CT2_VALOR 
            EndIf
*/
