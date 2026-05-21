#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥ EDFR027     ≥ Autor ≥ Luis Felipe Mattos	≥ Data ≥ 03.01.17 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Relatorio Transfer Price          				 		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 		 ≥ Faturamento          	  		                      	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum													  ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function EDFR027()

Local 	nOrdem
Local 	cQuery		:= ""
Private cAliasQry 	:= GetNextAlias()
Private cAliasQry2 	:= GetNextAlias()
Private cString    	:= "SF3"
Private wnrel      	:= "EDFR027"
Private aOrd       	:= {"Data"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Relatorio Transfer Price"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Relatorio Transfer Price", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR027"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR027"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR027"
Private _nlin      	:= 70
Private Cabec1     	:= " "
Private Cabec2     	:= " "
Private nCountnx    := 0
Private aPos        := {}

CriaSx1()

IF !Pergunte(cPerg,.T.)
	RETURN
ENDIF

If LastKey() == 27
	Return
Endif

If Empty(MV_PAR01)
	MV_PAR01 := FirstDay(MV_PAR02)
EndIf

If Empty(MV_PAR02)
	MV_PAR02 := LastDay(dDatabase)
EndIf

cQuery += " Select F3_FILIAL, F3_ENTRADA, F3_EMISSAO, F3_NFISCAL, F3_SERIE, F3_CLIEFOR, F3_LOJA, A1_NREDUZ, D2_COD, D2_SEGUM"+CENT
cQuery += " ,IsNull(Case When D2_UM = 'TM' Then D2_QUANT Else D2_QUANT * B1_CONV End, 0) D2_QUANT"+CENT
cQuery += " ,F3_CFO, F3_VALCONT, F3_OBSERV"+CENT
cQuery += " ,Z5_TELA, Rtrim(Z5_BOLSA) As Z5_BOLSA, Z5_LOTEPER, Z5_DESUSD, Z5_CONTRA, Z5_PERDE, Z5_MBOLSA"+CENT
cQuery += " ,(Select SUM(Z6_LOTE) From "+RetSqlName("SZ6")+" Where D_e_l_e_t_ = '' And SZ5.Z5_CONTRA = Z6_CONTRA And SZ5.Z5_PERDE = Z6_PERDE And Z6_TIPOPRE = '2') as LOTES_FIXADOS"+CENT
cQuery += " ,(Select MAX(Z6_DATA) From "+RetSqlName("SZ6")+" Where D_e_l_e_t_ = '' And SZ5.Z5_CONTRA = Z6_CONTRA And SZ5.Z5_PERDE = Z6_PERDE And Z6_TIPOPRE = '2') as Z6_DATA"+CENT
cQuery += " ,(Select EE8_XPOLDP   From "+RetSqlName("EE8")+" Where D_e_l_e_t_ = '' And D2_FILIAL = EE8_FILIAL And D2_PEDIDO = EE8_PEDIDO) as EE8_XPOLDP"+CENT
//cQuery += " ,EE8_XPOLDP"+CENT
cQuery += " ,B1_CONTA , B1_UM"+CENT
cQuery += " ,(Case When BM_DESC Like '%ACUCAR%' Then 'Acucar' Else (Case When BM_DESC Like '%MILHO%' Then 'Milho' Else (Case When BM_DESC Like '%SOJA%' Then 'Soja' Else (Case When BM_DESC Like '%SOJA%' Then 'Soja' Else '???' End) End) End) End) MARKET"+CENT
//cQuery += " From "+RetSqlName("SF3")+" SF3,"+RetSqlName("SB1")+" SB1,"+RetSqlName("SD2")+" SD2,"+RetSqlName("SA1")+" SA1,"+RetSqlName("SZ5")+" SZ5,"+RetSqlName("EE8")+" EE8, "+RetSqlName("SBM")+" SBM"+CENT
cQuery += " From "+RetSqlName("SF3")+" SF3,"+RetSqlName("SB1")+" SB1,"+RetSqlName("SD2")+" SD2,"+RetSqlName("SA1")+" SA1,"+RetSqlName("SZ5")+" SZ5,"+RetSqlName("SBM")+" SBM"+CENT
cQuery += " Where F3_FILIAL = D2_FILIAL"+CENT
cQuery += " And F3_NFISCAL = D2_DOC"+CENT
cQuery += " And F3_SERIE = D2_SERIE"+CENT
cQuery += " And F3_CLIEFOR = D2_CLIENTE"+CENT
cQuery += " And F3_LOJA = D2_LOJA"+CENT
cQuery += " And D2_COD = B1_COD"+CENT
cQuery += " And F3_CLIEFOR = A1_COD"+CENT
cQuery += " And F3_LOJA = A1_LOJA"+CENT
cQuery += " And 'S'+Rtrim(SubString(D2_COD,2,15)) = Rtrim(Z5_CONTRA)+'-'+Rtrim(Z5_PERDE)"+CENT
//cQuery += " And D2_FILIAL = EE8_FILIAL"+CENT      
//cQuery += " And D2_PEDIDO = EE8_PEDIDO"+CENT      
cQuery += " And B1_GRUPO = BM_GRUPO"+CENT 
cQuery += "	And F3_EMISSAO Between '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"+CENT
cQuery += " And SubString(F3_CFO,2,3)='501'"+CENT
cQuery += " And SubString(F3_OBSERV,1,12)<>'NF CANCELADA'"+CENT
cQuery += " And SF3.D_e_l_e_t_ = ''"+CENT
cQuery += " And SB1.D_e_l_e_t_ = ''"+CENT
cQuery += " And SD2.D_e_l_e_t_ = ''"+CENT
//cQuery += " And EE8.D_e_l_e_t_ = ''"+CENT
cQuery += " And SZ5.D_e_l_e_t_ = ''"+CENT
cQuery += " And SBM.D_e_l_e_t_ = ''"+CENT
cQuery += " Order By F3_ENTRADA,F3_NFISCAL"+CENT

MemoWrite("C:\Tmp\EDFR027.txt",cQuery)
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
Local cXml 		:= ""
Local nLin 		:= 2
Local nCont		:= 0
Local nValor 	:= 0
Local nMPrecif  :=0

/*SZL->(DbSetOrder(1))
If !SZL->(DbSeek(DtoS(Ddatabase))) .and. DOW(Ddatabase) <> 2  
	u_EDFI002()
EndIf
*/
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

(cAliasQry)->(DbGoTop())
While !(cAliasQry)->(EOF())
	nLin ++
	(cAliasQry)->(DbSkip())
End
(cAliasQry)->(DbGoTop())
	
ProcRegua(nLin)

If !(cAliasQry)->(EOF())

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
  	cXml += '<Created>2016-12-20T13:16:57Z</Created>'+CENT
	cXml += '  <LastSaved>2017-01-03T21:58:08Z</LastSaved>'+CENT
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
 	cXml += '  <Style ss:ID="s20" ss:Name="Porcentagem">'+CENT
 	cXml += '   <NumberFormat ss:Format="0%"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s62" ss:Name="V&#56487;ula">'+CENT
  	cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
  	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s63">'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s64">'+CENT
 	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s66">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>'+CENT
  	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s68">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s69">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s71" ss:Parent="s62">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s72">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>'+CENT
  	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="0"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s73" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s75" ss:Parent="s20">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
  	cXml += '   <NumberFormat ss:Format="Percent"/>'+CENT
  	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s76">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders/>'+CENT
 	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s77">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders/>'+CENT
  	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
  	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s78">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders/>'+CENT
 	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s79">'+CENT
 	cXml += '   <Borders/>'+CENT
  	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s80">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s81">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders/>'+CENT
 	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s82">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s83">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s84">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders/>'+CENT
  	cXml += '   <NumberFormat ss:Format="#,##0.000"/>'+CENT
  	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s85">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders/>'+CENT
 	cXml += '   <NumberFormat ss:Format="#,##0.000"/>'+CENT
 	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s86">'+CENT
 	cXml += '   <Borders/>'+CENT
  	cXml += '   <NumberFormat ss:Format="0"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s87">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders/>'+CENT
	cXml += '   <NumberFormat ss:Format="#,##0.0000"/>'+CENT
	cXml += '  </Style>'+CENT
 	cXml += ' </Styles>'+CENT
 	cXml += ' <Worksheet ss:Name="Parametros">'+CENT
 	cXml += '  <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="2" x:FullColumns="1"'+CENT
 	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="66"/>'+CENT
  	cXml += '   <Column ss:Width="60.75"/>'+CENT

	cMV_PAR01	:= SubStr(DtoS(MV_PAR01),1,4)+"-"+SubStr(DtoS(MV_PAR01),5,2)+"-"+SubStr(DtoS(MV_PAR01),7,2)+"T00:00:00.000"
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">Data De</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="DateTime">'+cMV_PAR01+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT

	cMV_PAR02	:= SubStr(DtoS(MV_PAR02),1,4)+"-"+SubStr(DtoS(MV_PAR02),5,2)+"-"+SubStr(DtoS(MV_PAR02),7,2)+"T00:00:00.000"
 	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">Data Ate</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="DateTime">'+cMV_PAR02+'</Data></Cell>'+CENT
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
  	cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
	cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
	cXml += '  </WorksheetOptions>'+CENT
 	cXml += ' </Worksheet>'+CENT
 	cXml += ' <Worksheet ss:Name="Relatorio">'+CENT
 	cXml += '  <Table ss:ExpandedColumnCount="32" ss:ExpandedRowCount="'+Alltrim(Str(nLin+2))+'" x:FullColumns="1"'+CENT

	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="30"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="55.5" ss:Span="1"/>'+CENT
  	cXml += '   <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="50.25"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="27.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="208.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="39"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="75.75"/>'+CENT
 	cXml += '   <Column ss:Width="93.75"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="207.75"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="68.25"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="20.25"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="93.75"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="75.75"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="70.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="64.5"/>'+CENT
	cXml += '   <Column ss:Index="18" ss:Width="51"/>'+CENT
 	cXml += '   <Column ss:Width="65.25"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="54" ss:Span="2"/>'+CENT
 	cXml += '   <Column ss:Index="23" ss:Width="71.25"/>'+CENT
 	cXml += '   <Column ss:Width="96"/>'+CENT
 	cXml += '   <Column ss:Width="71.25"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="84"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="54.75"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="83.25"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="89.25"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="72"/>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="24">'+CENT
	cXml += '    <Cell ss:MergeAcross="31" ss:StyleID="s66"><Data ss:Type="String">TRANSFER PRICE - 2016</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">FILIAL</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">ENTRADA NF</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">EMISSAO NF</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s71"><Data ss:Type="String">N. NFISCAL</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">SERIE</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">CLIENTE</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">CFOP</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">CONTA CONTABIL</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">VLR TOTAL NF R$</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">INFORMACOES COMPLEMENTARES</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">CONTRATO-DP</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">U.M.</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">QUANTIDADE</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">PRC. UNITARIO R$</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">PRICING MONTH</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">MARKET</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s72"><Data ss:Type="String">LOTS</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s72"><Data ss:Type="String">LOTS FIXED</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">FIXATION DATE</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">HIGH</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">LOW</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">AVERAGE</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">PRC.  PROTHEUS</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">AVERAGE # PROTHEUS</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s73"><Data ss:Type="String">POLARIZACAO</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s73"><Data ss:Type="String">PREMIO/DESCONTO</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">US$ EMIS. NF</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s73"><Data ss:Type="String">PRC.UNIT.R$ CALC.</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">PRC. PARAMETRO R$</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">DIFERENCA</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">MARGEM %</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">CHECK</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
	
	FWrite(nArq,cXml)
	
	ncount		:= 0
	ncountq 	:= 0
	cXml		:= ""
	lFez		:= .f.
	
	While (cAliasQry)->(!Eof())
		
		ncount += 1
		ncountq += 1
		
		IncProc(Str(ncount,5)+" de "+Str(nLin-2,5)+ " registros" )
		
		cEntrada := If(!Empty((cAliasQry)->F3_ENTRADA),SubStr((cAliasQry)->F3_ENTRADA,1,4)+"-"+SubStr((cAliasQry)->F3_ENTRADA,5,2)+"-"+SubStr((cAliasQry)->F3_ENTRADA,7,2)+"T00:00:00.000",'')
		cEmissao := If(!Empty((cAliasQry)->F3_EMISSAO),SubStr((cAliasQry)->F3_EMISSAO,1,4)+"-"+SubStr((cAliasQry)->F3_EMISSAO,5,2)+"-"+SubStr((cAliasQry)->F3_EMISSAO,7,2)+"T00:00:00.000",'')
		cZ6_DATA := If(!Empty((cAliasQry)->Z6_DATA),SubStr((cAliasQry)->Z6_DATA,1,4)+"-"+SubStr((cAliasQry)->Z6_DATA,5,2)+"-"+SubStr((cAliasQry)->Z6_DATA,7,2)+"T00:00:00.000",'')
		
	 	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	 	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">'+(cAliasQry)->F3_FILIAL+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s77"><Data ss:Type="DateTime">'+cEntrada+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s77"><Data ss:Type="DateTime">'+cEmissao+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAliasQry)->F3_NFISCAL+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">'+(cAliasQry)->F3_SERIE+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String">'+(cAliasQry)->F3_CLIEFOR+'-'+(cAliasQry)->F3_LOJA+' '+(cAliasQry)->A1_NREDUZ+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">'+(cAliasQry)->F3_CFO+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAliasQry)->B1_CONTA+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+Transform((cAliasQry)->F3_VALCONT,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+(cAliasQry)->F3_OBSERV+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s82"><Data ss:Type="String">'+(cAliasQry)->D2_COD+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s83"><Data ss:Type="String">'+(cAliasQry)->D2_SEGUM+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform((cAliasQry)->D2_QUANT,"@E 99,999,999.999")+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform((cAliasQry)->F3_VALCONT/(cAliasQry)->D2_QUANT,"@E 99,999,999.99")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+(cAliasQry)->Z5_TELA+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s85"><Data ss:Type="String">'+(cAliasQry)->Z5_BOLSA+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s86"><Data ss:Type="String">'+Str((cAliasQry)->Z5_LOTEPER,4)+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s86"><Data ss:Type="String">'+Str((cAliasQry)->LOTES_FIXADOS,4)+'</Data></Cell>'+CENT
		
		If !Empty(cZ6_DATA)
			cXml += '    <Cell ss:StyleID="s77"><Data ss:Type="DateTime">'+cZ6_DATA+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s77"><Data ss:Type="String">'+cZ6_DATA+'</Data></Cell>'+CENT
		EndIf

		If (cAliasQry)->MARKET == 'Acucar' 
			SZL->(DbSeek((cAliasQry)->Z6_DATA+Padr((cAliasQry)->Z5_BOLSA,TamSx3("ZL_MERCADO")[1])))
		Else
			SZL->(DbSeek((cAliasQry)->Z6_DATA+Padr((cAliasQry)->MARKET,TamSx3("ZL_MERCADO")[1])))
		EndIf 
		SM2->(DbSeek((cAliasQry)->F3_EMISSAO))
 
		nMedia 		:= Round((SZL->ZL_ALTA+SZL->ZL_BAIXA)/2,2)
		If	(cAliasQry)->Z5_BOLSA <> 'CME' 
//			nPrcUnCal 	:= Round(( Round((nMedia * IF(Alltrim((cAliasQry)->Z5_BOLSA)=="NY" .and. Rtrim((cAliasQry)->Z5_TELA)<>'FX' ,22.0462,1)),4) + (cAliasQry)->EE8_XPOLDP + (cAliasQry)->Z5_DESUSD) * SM2->M2_MOEDA2,2) 
			nPrcUnCal 	:= Round(( Round((nMedia * IF(Alltrim((cAliasQry)->Z5_BOLSA)=="NY",22.0462,1)),4) + (cAliasQry)->EE8_XPOLDP + (cAliasQry)->Z5_DESUSD) * SM2->M2_MOEDA2,2) // 27/11/17 - Luis Felipe
		Else
			nPrcUnCal 	:= Round(( Round((nMedia / 100) * 36.7454,4) + (cAliasQry)->EE8_XPOLDP + (cAliasQry)->Z5_DESUSD) * SM2->M2_MOEDA2,2) 
		EndIf	
	
		nValCal 	:= nPrcUnCal*(cAliasQry)->D2_QUANT 
		nDifer 		:= (cAliasQry)->F3_VALCONT-nValCal
		nMargem 	:= nDifer / (cAliasQry)->F3_VALCONT
		
		SZ6->(DbSetOrder(1))
		SZ6->(DbSeek(xFilial("SZ6")+(cAliasQry)->(Z5_CONTRA+Z5_PERDE)))

 		nMPrecif := If(!Empty((cAliasQry)->Z5_MBOLSA),(cAliasQry)->Z5_MBOLSA,SZ6->Z6_MDCENTS)
		
	 	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform(SZL->ZL_ALTA,"@E 999,999.99")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform(SZL->ZL_BAIXA,"@E 999,999.99")+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform(nMedia,"@E 999,999.99")+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform(nMPrecif,"@E 999,999.99")+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform(nMedia-nMPrecif,"@E 999,999.99")+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform((cAliasQry)->EE8_XPOLDP,"@E 999.9999")+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform((cAliasQry)->Z5_DESUSD,"@E 999,999.99")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s87"><Data ss:Type="String">'+Transform(SM2->M2_MOEDA2,"@E 999.9999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform(nPrcUnCal,"@E 999,999.99")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform(nValCal,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform(nDifer,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s84"><Data ss:Type="String">'+Transform(nMargem,"@E 999.999")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s85"><Data ss:Type="String">'+If(nMargem>-3,'Ok','Ajuste')+'</Data></Cell>'+CENT
	 	cXml += '   </Row>'+CENT

		nValor += (cAliasQry)->F3_VALCONT
		
		If	ncountq == 380 .or. (cAliasQry)->(Eof())
			FWrite(nArq,cXml)
			cXml := ""
			ncountq := 0
		EndIf  
		
		(cAliasQry)->(DbSkip())
		
	End

  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  	cXml += '    <Cell ss:Index="7"><Data ss:Type="String">Vendas intercompany</Data></Cell>'+CENT
  	cXml += '    <Cell ss:Index="9" ss:StyleID="s80"><Data ss:Type="String">'+Transform(nValor,"@E 999,999,999,999.99")+'</Data></Cell>'+CENT
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
 	cXml += '   <Selected/>'+CENT
  	cXml += '   <LeftColumnVisible>16</LeftColumnVisible>'+CENT
  	cXml += '   <Panes>'+CENT
  	cXml += '    <Pane>'+CENT
  	cXml += '     <Number>3</Number>'+CENT
  	cXml += '     <RangeSelection>R1C1:R1C32</RangeSelection>'+CENT
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

//         1           2      3                        4                        5                        6           7     8   9   10  11    12   13           14           15      16      17   18   19               20      21      22      23   24        25   26   27   28   29        30   31   32   33   34   35   36   37   38        39   40  41  42   43
AADD(aSx1,{"EDFR027" , "01" , "Data De       	  ?" , "Data De       	   ?" , "Data De       	    ?" , "mv_ch1" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par01" , ""         , ""    , ""    , "" , "" , ""             , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR027" , "02" , "Data Ate      	  ?" , "Data Ate      	   ?" , "Data Ate      	    ?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , ""         , ""    , ""    , "" , "" , ""             , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR027   02")
	
	DbSeek("EDFR027")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR027"
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
