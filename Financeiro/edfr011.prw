#include "colors.ch"
#include "Protheus.ch"
#include "TopConn.ch"
#include "TbiConn.ch"
#include "rwmake.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ EDFR011  ∫Autor  ≥ Luis Felipe Mattos ∫ Data ≥  28/07/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Balance to be Paid                                         ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Financeiro                                                 ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫AlteraÁ„o ≥	Luis Felipe								  Data: 02/10/15  ∫±±
±±∫          ≥	Ajuste no preÁo em real o qual passou a ser calculado a   ∫±±
±±∫          ≥	partir da multiplicaÁ„o do Valor em dolar x a TaxaUSD.    ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

***********************
User Function EDFR011()
***********************

Local __aArea 	:= GetArea()
Private nLastKey:= 0
Private cPerg   := "EDFR011"

Criasx1()

IF !Pergunte(cPerg,.T.)
	RETURN
ENDIF

If LastKey() == 27
	Return
Endif

Processa({|| Impressao() },"Aguarde Impress„o...")

RestArea(__aArea)

Return

***************************
Static Function Impressao()
***************************

Local oExcel
Local cArq
Local cPath
Local cXml    	:= ""

Local cQry1		:= ""   
Local cQry2		:= ""   
Local nQTDMAE 	:= 0
Local nQTDTON 	:= 0    
Local nVLFINAL	:= 0
Local nVALOR	:= 0
Local nVRLMAE   := 0
Local cNFMae	:= "" 
Local nQTDALOC  := 0
Local nPOL      := 0
Local nPREPAGO  := 0
Local nVLFINALP := 0
Local nLin		:= 100 
Local cPA		:= "" 
Local lFez		:= .f.
Local aNavio	:= {}	
Local nVLACRR   := 0
Local nVLACRUS  := 0
Local lFez 		:= .f.
Local nVLDESC   := 0
Local nVLDESUS  := 0 
Local nCountnx	:= 0  
Local nE2_VALOR := 0
Local _cContrato:= ""
Local _nMoeda	:= 0
Local _cMoeda	:= ""



Private cAlias1	:= GetNextAlias()
Private cAlias2	:= GetNextAlias()
Private nMaxCol := 3100 
Private nMaxLin := 2300
Private aAcrs	:= {}
Private aDesc   := {}

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

// Embarques

cQry1 := "SELECT DISTINCT EE9_FILIAL, EE9_PREEMB, CTH_DESC01, EEC_DTEMBA, EE9_COD_I, EE9_PSLQTO, EE8_XPOLDP, EE9_PSLQTO * Z6_VLFINAL AS VLRUS, Z6_VLFINAL, Z3_DTINIC, Z3_DTFIM " +CENT
cQry1 += "FROM "+CENT
cQry1 += "(SELECT DISTINCT EE9_FILIAL, EE9_PREEMB, CTH_DESC01, EEC_DTEMBA, EE9_PEDIDO, EE9_COD_I, CASE WHEN SUBSTRING(EE9_PEDIDO,1,7)<>'SACARIA' THEN (EE9_PSLQTO / 1000) ELSE EE9_PSLQTO END EE9_PSLQTO, EE8_XPOLDP, Z3_DTINIC, Z3_DTFIM "+CENT // 12/12/16- Luis Felipe - Tratamento sacaria.
cQry1 += "FROM "+RetSqlName("EE9")+" EE9,"+RetSqlName("EEC")+" EEC,"+RetSqlName("EE8")+" EE8, "+RetSqlName("CTH")+" CTH, "+RetSqlName("SZ3")+" SZ3 "+CENT
cQry1 += "WHERE EE9.EE9_FILIAL = EEC.EEC_FILIAL "+CENT
cQry1 += "AND EE9.EE9_PREEMB = EEC.EEC_PREEMB "+CENT
cQry1 += "AND EE9.EE9_FILIAL = EE8.EE8_FILIAL "+CENT
cQry1 += "AND EE9.EE9_PEDIDO = EE8.EE8_PEDIDO "+CENT
cQry1 += "AND EE9.EE9_COD_I  = EE8.EE8_COD_I "+CENT
cQry1 += "AND EE9.EE9_COD_I  = SZ3.Z3_CTRDP "+CENT
cQry1 += "AND SubString(EE9_PREEMB,1,9) = CTH_CLVL "+CENT 
cQry1 += "AND EE9.EE9_COD_I  = '"+Alltrim(mv_par01)+"-"+Alltrim(mv_par02)+"' "+CENT
//cQry1 += "AND EEC.EEC_STATUS = '6' "+CENT // 04/05/15 - Luis Felipe
cQry1 += "AND EE8.D_E_L_E_T_ = '' "+CENT
cQry1 += "AND EE9.D_E_L_E_T_ = '' "+CENT
cQry1 += "AND EEC.D_E_L_E_T_ = '' "+CENT
cQry1 += "AND SZ3.D_E_L_E_T_ = '' "+CENT
cQry1 += "AND CTH.D_E_L_E_T_ = '') "+CENT
cQry1 += "AS EE9 "+CENT
cQry1 += "LEFT JOIN "+CENT
cQry1 += "(SELECT DISTINCT Z6_CONTRA, Z6_PERDE, Z6_VLFINAL "+CENT
cQry1 += "FROM "+RetSqlName("SZ6")+" SZ6 "+CENT
cQry1 += "WHERE Z6_TIPOPRE = '2' "+CENT
cQry1 += "AND SZ6.D_E_L_E_T_= '') "+CENT
cQry1 += "AS SZ6 "+CENT
cQry1 += "ON RTRIM(EE9.EE9_COD_I) = RTRIM(SZ6.Z6_CONTRA)+'-'+RTRIM(SZ6.Z6_PERDE)"+CENT

MemoWrite("C:\Tmp\EDFR011_E.txt",cQry1)
cQry1 := ChangeQuery(cQry1)

If Select(cAlias1) > 0
	dbselectarea(cAlias1)
	(cAlias1)->(dbCloseArea())
Endif
 
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry1),cAlias1,.F.,.T.)
dbselectarea(cAlias1)
(cAlias1)->(dbGoTop())

// Adiantamentos

cQry2 := "  SELECT * "+CENT
cQry2 += "  FROM"+CENT
cQry2 += " (SELECT DISTINCT E2_FILIAL,E2_NOMFOR"+CENT
cQry2 += " ,E2_CONTRA "+CENT
cQry2 += " ,E2_XPERIOD"+CENT
cQry2 += " ,Z3_DTINIC"+CENT
cQry2 += " ,Z3_DTFIM "+CENT
cQry2 += " ,Z3_QUANT "+CENT
cQry2 += " ,E2_NUM "+CENT
cQry2 += " ,E2_VENCREA"+CENT
cQry2 += " ,E2_QTDTON"+CENT
cQry2 += " ,E2_XSUBTIP"+CENT
cQry2 += " ,E2_PREFIXO"+CENT
cQry2 += " ,E2_FORNECE"+CENT
cQry2 += " ,E2_LOJA"+CENT
cQry2 += " ,E2_NAVIO"+CENT
cQry2 += " ,E2_XLOCAL"+CENT
cQry2 += " ,E2_PREPAGO"+CENT
cQry2 += " ,E2_VLFINAL"+CENT
cQry2 += " ,ISNULL((SELECT X5_DESCENG FROM "+RetSqlName("SX5")+" SX5 WHERE SX5.X5_FILIAL = SE2.E2_FILORIG AND SX5.X5_TABELA = 'Z1' AND RTRIM(SX5.X5_CHAVE) = SE2.E2_XTPDES1 AND SX5.D_E_L_E_T_ = ''),'') AS TPDC01 "+CENT
cQry2 += " ,E2_XVLDC1 "+CENT
cQry2 += " ,ISNULL((SELECT X5_DESCENG FROM "+RetSqlName("SX5")+" SX5 WHERE SX5.X5_FILIAL = SE2.E2_FILORIG AND SX5.X5_TABELA = 'Z1' AND RTRIM(SX5.X5_CHAVE) = SE2.E2_XTPDES2 AND SX5.D_E_L_E_T_ = ''),'') AS TPDC02 "+CENT
cQry2 += " ,E2_XVLDC2 "+CENT
cQry2 += " ,ISNULL((SELECT X5_DESCENG FROM "+RetSqlName("SX5")+" SX5 WHERE SX5.X5_FILIAL = SE2.E2_FILORIG AND SX5.X5_TABELA = 'Z1' AND RTRIM(SX5.X5_CHAVE) = SE2.E2_XTPDES3 AND SX5.D_E_L_E_T_ = ''),'') AS TPDC03 "+CENT
cQry2 += " ,E2_XVLDC3 "+CENT
cQry2 += " ,ISNULL((SELECT X5_DESCENG FROM "+RetSqlName("SX5")+" SX5 WHERE SX5.X5_FILIAL = SE2.E2_FILORIG AND SX5.X5_TABELA = 'Z2' AND RTRIM(SX5.X5_CHAVE) = SE2.E2_XTPAC1 AND SX5.D_E_L_E_T_ = ''),'') AS TPAC01 "+CENT
cQry2 += " ,E2_XVLAC1 "+CENT
cQry2 += " ,ISNULL((SELECT X5_DESCENG FROM "+RetSqlName("SX5")+" SX5 WHERE SX5.X5_FILIAL = SE2.E2_FILORIG AND SX5.X5_TABELA = 'Z2' AND RTRIM(SX5.X5_CHAVE) = SE2.E2_XTPAC2 AND SX5.D_E_L_E_T_ = ''),'') AS TPAC02 "+CENT
cQry2 += " ,E2_XVLAC2 "+CENT
cQry2 += " ,ISNULL((SELECT X5_DESCENG FROM "+RetSqlName("SX5")+" SX5 WHERE SX5.X5_FILIAL = SE2.E2_FILORIG AND SX5.X5_TABELA = 'Z2' AND RTRIM(SX5.X5_CHAVE) = SE2.E2_XTPAC3 AND SX5.D_E_L_E_T_ = ''),'') AS TPAC03 "+CENT
cQry2 += " ,E2_XVLAC3 "+CENT 
cQry2 += " ,E2_TXUSD"+CENT 
cQry2 += " ,E2_VALOR"+CENT 
cQry2 += " ,Z3_CONTRA"+CENT 
cQry2 += " FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SZ3")+" SZ3 "+CENT
cQry2 += " WHERE SE2.D_E_L_E_T_= ''"+CENT
cQry2 += " AND SZ3.D_E_L_E_T_= ''"+CENT
cQry2 += " AND (SE2.E2_CONTRA = SZ3.Z3_CONTRA AND SE2.E2_XPERIOD = SZ3.Z3_PERIODO OR  E2_XCONTRA = RTRIM(SZ3.Z3_CONTRA)+'-'+RTRIM(SZ3.Z3_PERIODO))"+CENT
cQry2 += " AND (E2_CONTRA     = '"+MV_PAR01+"' AND E2_XPERIOD = '"+MV_PAR02+"' OR E2_XCONTRA = '"+Alltrim(MV_PAR01)+"-"+Alltrim(MV_PAR02)+"')"+CENT
cQry2 += " AND (SE2.E2_CONTRA = SZ3.Z3_CONTRA AND SE2.E2_XPERIOD = SZ3.Z3_PERIODO OR  E2_XCONTRA = RTRIM(SZ3.Z3_CONTRA)+'-'+RTRIM(SZ3.Z3_PERIODO))"+CENT
cQry2 += " AND SE2.E2_TIPO	  = 'PA '"+CENT
If	!Empty(MV_PAR05)
	cQry2 += " AND E2_VENCREA <= '"+DtoS(MV_PAR05)+"')"+CENT
Else
	cQry2 += " AND E2_VENCREA <= '"+DtoS(Ddatabase)+"')"+CENT
EndIf
cQry2 += " AS SE2"+CENT
cQry2 += " LEFT JOIN"+CENT
cQry2 += " (SELECT ZE_LOCAL, ZE_NOME"+CENT
cQry2 += " FROM "+RetSqlName("SZE")+CENT
cQry2 += " WHERE D_E_L_E_T_= '')"+CENT
cQry2 += " AS SZE"+CENT
cQry2 += " ON SE2.E2_XLOCAL = SZE.ZE_LOCAL"+CENT
cQry2 += " LEFT JOIN"+CENT
cQry2 += " (SELECT CTH_CLVL, CTH_VESSEL"+CENT
cQry2 += " FROM "+RetSqlName("CTH")+CENT
cQry2 += " WHERE D_E_L_E_T_= '')"+CENT
cQry2 += " AS CTH "+CENT
cQry2 += " ON SE2.E2_NAVIO = CTH.CTH_CLVL"+CENT
cQry2 += " ORDER BY E2_VENCREA "+CENT

MemoWrite("C:\Tmp\EDFR011_A.txt",cQry2)
cQry2 := ChangeQuery(cQry2)

If Select(cAlias2) > 0
	dbselectarea(cAlias2)
	(cAlias2)->(dbCloseArea())
Endif
 
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry2),cAlias2,.F.,.T.)
dbselectarea(cAlias2)
(cAlias2)->(dbGoTop())

If Eof()
	Aviso("AtenÁ„o","N„o existem adiantamentos realizados sobre o Contrato / Dp selecionado !",{"Voltar"})
	(cAlias2)->(DbCloseArea())	
	(cAlias1)->(DbCloseArea())	
	Return
EndIf

(cAlias2)->(dbGoTop())

nZ3_Quant := (cAlias2)->Z3_QUANT
cPA 	  := (cAlias2)->E2_NUM

// Adiantamentos

If !(cAlias2)->(Eof())

	While (cAlias2)->(!EOF())
		nLin ++
		nCountnx ++
		(cAlias2)->(DbSkip())
	End
	
	ProcRegua(nCountnx)
	
	(cAlias2)->(DbGotop())

	cXml := '<?xml version="1.0"?>'+CENT
	cXml += '<?mso-application progid="Excel.Sheet"?>'+CENT
	cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
	cXml += 'xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT
	cXml += ' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT
	cXml += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
	cXml += ' xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT
	cXml += ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT
	cXml += '  <Author>Cerqueira, Tatiana (SUG, BRRIO)</Author>'+CENT
	cXml += '  <LastAuthor>Luis Filipe Nascimento</LastAuthor>'+CENT
	cXml += '  <Created>2015-04-23T13:08:30Z</Created>'+CENT
	cXml += '  <LastSaved>2015-08-19T13:35:56Z</LastSaved>'+CENT
	cXml += '  <Company>Microsoft</Company>'+CENT
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
	cXml += '  <Style ss:ID="m250691461536">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250691461556">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250691461576">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250691461596">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592761060">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592761140">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592761160">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592761180">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592761200">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592761220">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592748580">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#000000" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592748620">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592748660">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#000000" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592748680">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592754068">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.000;\(#,##0.000\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592756048">'+CENT
	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592756088">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592756128">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.000;\(#,##0.000\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592751572">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592751284">'+CENT
	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#000000"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592751304">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#000000"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#000000"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#000000" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592751324">'+CENT
	cXml += '   <Alignment ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#000000"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1" ss:Italic="1"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m250592751364">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s62">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s63">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s65">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s67">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s68">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s69">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FF0000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s70">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s71">'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s72">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s73">'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FF0000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s102">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s103">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s104">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s111">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="6" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s113">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s178">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s195">'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s200">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s206">'+CENT
	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s220">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s252">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s253">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s254">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s258">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s259">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s260">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s261">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s262">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s263">'+CENT
	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s264">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Standard"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s267">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.000;\(#,##0.000\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s268">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.000;\(#,##0.000\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s269">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.000;\(#,##0.000\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s270">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.0000;\(#,##0.0000\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s271">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.00;\(#,##0.00\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s274">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.00;\(#,##0.00\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s275">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.00;\(#,##0.00\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s276">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.000;\(#,##0.000\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s277">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.00;\(#,##0.00\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s280">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.0000;\(#,##0.0000\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s287">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.00;\(#,##0.00\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s288">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s324">'+CENT
	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s328">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s329">'+CENT
	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s330">'+CENT
	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s332">'+CENT
	cXml += '   <Alignment ss:Vertical="Center"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s334">'+CENT
	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s339">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D3D3D3" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s340">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="@"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s342">'+CENT
	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s344">'+CENT
	cXml += '   <Alignment ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s345">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s346">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="[$-10409]#,##0.00;\(#,##0.00\)"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s350">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"'+CENT
	cXml += '     ss:Color="#FFFFFF"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += ' </Styles>'+CENT
	cXml += ' <Worksheet ss:Name="Relatorio">'+CENT
	cXml += '  <Table ss:ExpandedColumnCount="14" ss:ExpandedRowCount="'+Alltrim(Str(nLin))+'" x:FullColumns="1"'+CENT
	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
	cXml += '   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="97.5"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="61.5"/>'+CENT
	cXml += '   <Column ss:Index="7" ss:AutoFitWidth="0" ss:Width="105"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="90"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="96.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="113.25"/>'+CENT
	cXml += '   <Column ss:Width="54.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="89.25" ss:Span="2"/>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s62"/>'+CENT
	cXml += '    <Cell ss:StyleID="s63"/>'+CENT
	cXml += '    <Cell ss:StyleID="s63"/>'+CENT
	cXml += '    <Cell ss:StyleID="s63"/>'+CENT
	cXml += '    <Cell ss:StyleID="s63"/>'+CENT
	cXml += '    <Cell ss:StyleID="s63"/>'+CENT
	cXml += '    <Cell ss:MergeAcross="1" ss:MergeDown="1" ss:StyleID="s65"><Data'+CENT
	cXml += '      ss:Type="String">Balance To Be Paid</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s63"/>
	cXml += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Report Date:</Data></Cell>'+CENT

	cDatabase := Alltrim(Str(Year(Ddatabase))+"-"+Strzero(Month(Ddatabase),2)+"-"+Strzero(Day(Ddatabase),2))+"T00:00:00.000"

	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cDatabase+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s68"/>'+CENT
	cXml += '    <Cell ss:StyleID="s68"/>'+CENT
	cXml += '    <Cell ss:StyleID="s69"/>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s70"/>'+CENT
	cXml += '    <Cell ss:StyleID="s71"/>'+CENT
	cXml += '    <Cell ss:StyleID="s71"/>'+CENT
	cXml += '    <Cell ss:StyleID="s71"/>'+CENT
	cXml += '    <Cell ss:StyleID="s71"/>'+CENT
	cXml += '    <Cell ss:StyleID="s71"/>'+CENT
	cXml += '    <Cell ss:Index="9" ss:StyleID="s71"/>'+CENT
	cXml += '    <Cell ss:StyleID="s72"><Data ss:Type="String">Cut-off date:</Data></Cell>'+CENT

	If !Empty(MV_PAR05)
		cCorte   := Alltrim(Str(Year(MV_PAR05))+"-"+Strzero(Month(MV_PAR05),2)+"-"+Strzero(Day(MV_PAR05),2))+"T00:00:00.000"
	Else
		cCorte   := Alltrim(Str(Year(Ddatabase))+"-"+Strzero(Month(Ddatabase),2)+"-"+Strzero(Day(Ddatabase),2))+"T00:00:00.000"
    EndIf
	
	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cCorte+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s68"/>'+CENT
	cXml += '    <Cell ss:StyleID="s68"/>'+CENT
	cXml += '    <Cell ss:StyleID="s73"/>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:MergeAcross="13" ss:StyleID="m250592751284"><Data ss:Type="String">'+Alltrim((cAlias2)->E2_NOMFOR)+' - Contract Nbr:&#160;'+MV_PAR01+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:MergeAcross="13" ss:StyleID="m250592751304"><Data ss:Type="String">PRODUCT PAYMENTS</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:MergeAcross="13" ss:StyleID="m250592751324"><Data ss:Type="String">Payments</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="s252"><Data ss:Type="String">Supplier</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s220"><Data ss:Type="String">Payment ID</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m250592751364"><Data ss:Type="String">Deliv. Period</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Date</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Payment Type</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s103"><Data ss:Type="String">TM</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Shipment</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Condition</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s104"><Data ss:Type="String">Price</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s200"><Data ss:Type="String">Amount(US$)</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s200"><Data ss:Type="String">Tx Hedge</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s253"><Data ss:Type="String">Amount(RS$)</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT

	While !(cAlias2)->(Eof())
	
		cTipo := ""
		If (cAlias2)->E2_XSUBTIP == "1"
			cTipo := "CAD BCO"
		ElseIf (cAlias2)->E2_XSUBTIP == "2"
			cTipo := "LC(C.CRED)"
		ElseIf (cAlias2)->E2_XSUBTIP == "3"
			cTipo := "CAFD(COP.DOCS)"
		ElseIf (cAlias2)->E2_XSUBTIP == "4"
			cTipo := "STOCK FINANCE"
		ElseIf (cAlias2)->E2_XSUBTIP == "5"
			cTipo := "STANDBY L/C"
		ElseIf (cAlias2)->E2_XSUBTIP == "6"
			cTipo := "PART.PAYMENT"
		ElseIf (cAlias2)->E2_XSUBTIP == "7"
			cTipo := "CAD WITHOUT PROD"
		ElseIf (cAlias2)->E2_XSUBTIP == "8"
			cTipo := "CAD"
		ElseIf SE2->E2_XSUBTIP == "9"
			cTipo := "Prepayment"
		EndIf

		cTipo := Alltrim(cTipo)    
	
		If (!Empty((cAlias2)->TPDC01),Aadd(aDesc,{(cAlias2)->E2_NUM,(cAlias2)->Z3_DTINIC,(cAlias2)->Z3_DTFIM,(cAlias2)->E2_VENCREA,(cAlias2)->TPDC01,(cAlias2)->E2_XVLDC1/(cAlias2)->E2_TXUSD,(cAlias2)->E2_XVLDC1}),)
		If (!Empty((cAlias2)->TPDC02),Aadd(aDesc,{(cAlias2)->E2_NUM,(cAlias2)->Z3_DTINIC,(cAlias2)->Z3_DTFIM,(cAlias2)->E2_VENCREA,(cAlias2)->TPDC02,(cAlias2)->E2_XVLDC2/(cAlias2)->E2_TXUSD,(cAlias2)->E2_XVLDC2}),)
		If (!Empty((cAlias2)->TPDC03),Aadd(aDesc,{(cAlias2)->E2_NUM,(cAlias2)->Z3_DTINIC,(cAlias2)->Z3_DTFIM,(cAlias2)->E2_VENCREA,(cAlias2)->TPDC03,(cAlias2)->E2_XVLDC3/(cAlias2)->E2_TXUSD,(cAlias2)->E2_XVLDC3}),)
		If (!Empty((cAlias2)->TPAC01),Aadd(aAcrs,{(cAlias2)->E2_NUM,(cAlias2)->Z3_DTINIC,(cAlias2)->Z3_DTFIM,(cAlias2)->E2_VENCREA,(cAlias2)->TPAC01,(cAlias2)->E2_XVLAC1/(cAlias2)->E2_TXUSD,(cAlias2)->E2_XVLAC1}),)
		If (!Empty((cAlias2)->TPAC02),Aadd(aAcrs,{(cAlias2)->E2_NUM,(cAlias2)->Z3_DTINIC,(cAlias2)->Z3_DTFIM,(cAlias2)->E2_VENCREA,(cAlias2)->TPAC02,(cAlias2)->E2_XVLAC2/(cAlias2)->E2_TXUSD,(cAlias2)->E2_XVLAC2}),)
		If (!Empty((cAlias2)->TPAC03),Aadd(aAcrs,{(cAlias2)->E2_NUM,(cAlias2)->Z3_DTINIC,(cAlias2)->Z3_DTFIM,(cAlias2)->E2_VENCREA,(cAlias2)->TPAC03,(cAlias2)->E2_XVLAC3/(cAlias2)->E2_TXUSD,(cAlias2)->E2_XVLAC3}),)
         
		cZ3_DTINIC 	:= SubStr((cAlias2)->Z3_DTINIC,1,4)+"-"+SubStr((cAlias2)->Z3_DTINIC,5,2)+"-"+SubStr((cAlias2)->Z3_DTINIC,7,2)+"T00:00:00.000"
		cZ3_DTFIM	:= SubStr((cAlias2)->Z3_DTFIM,1,4)+"-"+SubStr((cAlias2)->Z3_DTFIM,5,2)+"-"+SubStr((cAlias2)->Z3_DTFIM,7,2)+"T00:00:00.000"
		cE2_EMISS	:= SubStr((cAlias2)->E2_VENCREA,1,4)+"-"+SubStr((cAlias2)->E2_VENCREA,5,2)+"-"+SubStr((cAlias2)->E2_VENCREA,7,2)+"T00:00:00.000"

		cXml += '   <Row ss:AutoFitHeight="0" ss:Height="19.5">'+CENT
		cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="s254"><Data ss:Type="String">'+(cAlias2)->E2_NOMFOR+'</Data></Cell>'+CENT //  aqui
		cXml += '    <Cell ss:StyleID="s288"><Data ss:Type="String">'+(cAlias2)->E2_NUM+'</Data></Cell>'+CENT
		If	!Empty((cAlias2)->Z3_DTINIC)
			cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf	
		If	!Empty((cAlias2)->Z3_DTINIC)
		 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT
		Else
		 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf 	
	 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cE2_EMISS+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s111"><Data ss:Type="String">'+cTipo+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s269"><Data ss:Type="String">'+TRANSFORM((cAlias2)->E2_QTDTON,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s111"><Data ss:Type="String">'+Alltrim((cAlias2)->CTH_VESSEL)+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s111"><Data ss:Type="String">'+Alltrim(SubStr((cAlias2)->ZE_NOME,1,24))+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s271"><Data ss:Type="String">'+TRANSFORM((cAlias2)->E2_PREPAGO,"@E 999,999,999.99")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s274"><Data ss:Type="String">'+TRANSFORM((cAlias2)->E2_VLFINAL,"@E 999,999,999.99")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s274"><Data ss:Type="String">'+TRANSFORM((cAlias2)->E2_TXUSD,"@E 999.9999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s267"><Data ss:Type="String">'+TRANSFORM(Round((cAlias2)->E2_VLFINAL*(cAlias2)->E2_TXUSD,2),"@E 999,999,999.99")+'</Data></Cell>'+CENT 
		cXml += '   </Row>'+CENT

		If !lFez
			If !(cAlias2)->E2_XSUBTIP $ "6/7"
				nQTDTON += (cAlias2)->E2_QTDTON  
				nQTDALOC+= (cAlias2)->E2_QTDTON  
			EndIf	
			nVLFINAL  += (cAlias2)->E2_VLFINAL
//			nE2_VALOR += (cAlias2)->E2_VALOR // 02/10/15 - Luis Felipe
			nE2_VALOR += Round((cAlias2)->E2_VLFINAL*(cAlias2)->E2_TXUSD,2) 
   		EndIf
    
		(cAlias2)->(DbSkip()) 

		If cPA <> (cAlias2)->E2_NUM
			cPA  := (cAlias2)->E2_NUM
			lFez := .f.
		Else
			lFez := .t.
		EndIf
		
		If (cAlias2)->(Eof()) 
			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			cXml += '    <Cell ss:MergeAcross="6" ss:StyleID="m250592751572"><ss:Data ss:Type="String"'+CENT
			cXml += '      xmlns="http://www.w3.org/TR/REC-html40"><Font html:Color="#000000">&#160;</Font><B><Font'+CENT
			cXml += '        html:Color="#000000">Total Paid Delivery Period - '+MV_PAR02+'</Font></B></ss:Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s276"><Data ss:Type="String">'+TRANSFORM(nQTDALOC ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s113"><ss:Data ss:Type="String"'+CENT
			cXml += '      xmlns="http://www.w3.org/TR/REC-html40"><Font html:Color="#000000">of </Font><B><Font'+CENT
			cXml += '        html:Color="#000000">'+TRANSFORM(nZ3_Quant,"@E 999,999,999.99")+'</Font></B></ss:Data></Cell>'+CENT
			cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m250592756048"/>'+CENT
			cXml += '    <Cell ss:StyleID="s275"><Data ss:Type="String">'+TRANSFORM(nVLFINAL,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '    <Cell ss:StyleID="s275"><Data ss:Type="String"></Data></Cell>'+CENT 
			cXml += '    <Cell ss:StyleID="s268"><Data ss:Type="String">'+TRANSFORM(nE2_VALOR,"@E 999,999,999.99")+'</Data></Cell>'+CENT 
			cXml += '   </Row>'+CENT
			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
			cXml += '    <Cell ss:StyleID="s258"/>'+CENT
			cXml += '    <Cell ss:StyleID="s259"/>'+CENT
			cXml += '    <Cell ss:StyleID="s259"/>'+CENT
			cXml += '    <Cell ss:StyleID="s259"/>'+CENT
			cXml += '    <Cell ss:StyleID="s259"/>'+CENT
			cXml += '    <Cell ss:StyleID="s259"/>'+CENT
			cXml += '    <Cell ss:StyleID="s260"/>'+CENT
			cXml += '    <Cell ss:StyleID="s261"/>'+CENT
			cXml += '    <Cell ss:StyleID="s262"/>'+CENT
			cXml += '    <Cell ss:StyleID="s263"/>'+CENT
			cXml += '    <Cell ss:StyleID="s263"/>'+CENT
			cXml += '    <Cell ss:StyleID="s263"/>'+CENT
			cXml += '    <Cell ss:StyleID="s263"/>'+CENT
			cXml += '    <Cell ss:StyleID="s264"/>'+CENT
			cXml += '   </Row>'+CENT
		EndIf
	End
EndIf
†
// Embarques

nQTDALOC:= 0

DbSelectArea(cAlias1)
			                                    
_cContrato 	:= Substr((cAlias1)->EE9_COD_I,1,(at("-",(cAlias1)->EE9_COD_I)-1)) 
_nMoeda 	:= POSICIONE("CN9",1,XFILIAL("CN9") + _cContrato,"CN9_MOEDA")
_cMoeda		:= Iif(_nMoeda==1,"BRL","USD")
			
cXml += '   <Row ss:AutoFitHeight="0">'+CENT
cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="s324"><Data ss:Type="String">Vessel - Match</Data></Cell>'+CENT
cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m250592756088"><Data ss:Type="String">Alloc.Qtty</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s328"><Data ss:Type="String">BL</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s328"><Data ss:Type="String">POL Premium</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s329"><Data ss:Type="String">Final Price '+_cMoeda+'</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s330"><Data ss:Type="String">Amount  '+_cMoeda+'</Data></Cell>'+CENT
cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m250592761140"/>'+CENT
cXml += '   </Row>'+CENT

While !(cAlias1)->(Eof())

	cEEC_DTEMBA	:= SubStr((cAlias1)->EEC_DTEMBA,1,4)+"-"+SubStr((cAlias1)->EEC_DTEMBA,5,2)+"-"+SubStr((cAlias1)->EEC_DTEMBA,7,2)+"T00:00:00.000"
        
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="s332"><Data ss:Type="String">'+Alltrim((cAlias1)->CTH_DESC01)+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m250592756128"><Data ss:Type="String">'+TRANSFORM((cAlias1)->EE9_PSLQTO ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
	If !Empty((cAlias1)->EEC_DTEMBA)
	 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cEEC_DTEMBA+'</Data></Cell>'+CENT
	Else 
	 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>'+CENT
	EndIf  
	cXml += '    <Cell ss:StyleID="s270"><Data ss:Type="String">'+TRANSFORM((cAlias1)->EE8_XPOLDP ,"@E 99,999.9999")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s271"><Data ss:Type="String">'+TRANSFORM((cAlias1)->Z6_VLFINAL ,"@E 99,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s274"><Data ss:Type="String">'+TRANSFORM((cAlias1)->VLRUS	  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m250592761160"/>'+CENT
	cXml += '   </Row>'+CENT
	
	nVLFINALP := (cAlias1)->Z6_VLFINAL
	nQTDALOC  += (cAlias1)->EE9_PSLQTO 
	nPOL      := (cAlias1)->EE8_XPOLDP 
	nPREPAGO  += (cAlias1)->VLRUS 

	(cAlias1)->(DbSkip())
End

SZ3->(DbSetOrder(1))
SZ3->(DbSeek(xFilial("SZ3")+mv_par01+mv_par02))
	
cXml += '   <Row ss:AutoFitHeight="0">'+CENT
cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="s334"><Data ss:Type="String">Total Alloc. Qtty.</Data></Cell>'+CENT
cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m250592754068"><Data ss:Type="String">'+TRANSFORM(nQTDALOC     ,"@E 999,999,999.999")+'</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s195"/>'+CENT
cXml += '    <Cell ss:StyleID="s280"><Data ss:Type="String">'+TRANSFORM(SZ3->Z3_POLDP,"@E 99,999.9999")+'</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s277"><Data ss:Type="String">'+TRANSFORM(nVLFINALP    ,"@E 999,999.99")+'</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s275"><Data ss:Type="String">'+TRANSFORM(nPREPAGO	 ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m250592761180"/>'+CENT
cXml += '   </Row>'+CENT

// 08/05/2015 - Luis Felipe
// Increases
//

lFez := .f.
	
cXml += '   <Row ss:AutoFitHeight="0">'+CENT
cXml += '    <Cell ss:MergeAcross="13" ss:StyleID="m250691461556"/>'+CENT
cXml += '   </Row>'+CENT
cXml += '   <Row ss:AutoFitHeight="0">'+CENT
cXml += '    <Cell ss:MergeAcross="13" ss:StyleID="m250592748580"><Data ss:Type="String">Increases</Data></Cell>'+CENT
cXml += '   </Row>'+CENT
cXml += '   <Row ss:AutoFitHeight="0" ss:StyleID="s195">'+CENT
cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="s339"><Data ss:Type="String">Payment ID</Data></Cell>'+CENT
cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m250592748620"><Data ss:Type="String">Deliv. Period</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Date</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Increase Type</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s103"><Data ss:Type="String">Amount(US$)</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s200"><Data ss:Type="String">Amount(RS$)</Data></Cell>'+CENT
cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m250592761200"/>'+CENT
cXml += '   </Row>'+CENT

For nx:=1 to Len(aAcrs) 
	    
	cZ3_DTINIC := aAcrs[nx][2]
	cZ3_DTINIC := SubStr(cZ3_DTINIC,1,4)+"-"+SubStr(cZ3_DTINIC,5,2)+"-"+SubStr(cZ3_DTINIC,7,2)+"T00:00:00.000"
	cZ3_DTFIM  := aAcrs[nx][3]
	cZ3_DTFIM  := SubStr(cZ3_DTFIM,1,4)+"-"+SubStr(cZ3_DTFIM,5,2)+"-"+SubStr(cZ3_DTFIM,7,2)+"T00:00:00.000"
	cE2_EMISS  := aAcrs[nx][4]
	cE2_EMISS  := SubStr(cE2_EMISS,1,4)+"-"+SubStr(cE2_EMISS,5,2)+"-"+SubStr(cE2_EMISS,7,2)+"T00:00:00.000"

	cXml += '   <Row ss:AutoFitHeight="0" ss:StyleID="s195">'+CENT
	cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="s340"><Data ss:Type="String">'+aAcrs[nx][1]+'</Data></Cell>'+CENT

    If	!Empty(aAcrs[nx][2]) 
	 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT
    Else 
   	 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>'+CENT
    EndIf

    If	!Empty(aAcrs[nx][3]) 
		cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT
	Else
   	 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>'+CENT
	EndIf

	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cE2_EMISS+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s111"><Data ss:Type="String">'+Alltrim(aAcrs[nx][5])+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s271"><Data ss:Type="String">'+TRANSFORM(aAcrs[nx][6] ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s271"><Data ss:Type="String">'+TRANSFORM(aAcrs[nx][7] ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m250691461576"/>'+CENT
	cXml += '   </Row>'+CENT
	
 	nVLACRR  += aAcrs[nx][6]
	nVLACRUS += aAcrs[nx][7]

Next

cXml += '   <Row ss:AutoFitHeight="0" ss:StyleID="s195">'+CENT
cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="s334"><Data ss:Type="String">Total</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s206"/>'+CENT
cXml += '    <Cell ss:StyleID="s206"/>'+CENT
cXml += '    <Cell ss:StyleID="s206"/>'+CENT
cXml += '    <Cell ss:StyleID="s178"/>'+CENT
cXml += '    <Cell ss:StyleID="s277"><Data ss:Type="String">'+TRANSFORM(nVLACRR ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s287"><Data ss:Type="String">'+TRANSFORM(nVLACRUS ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m250592761220"/>'+CENT
cXml += '   </Row>'+CENT

// 
// Discount  
//

cXml += '   <Row ss:AutoFitHeight="0">'+CENT
cXml += '    <Cell ss:MergeAcross="13" ss:StyleID="m250592748660"><Data ss:Type="String">Discounts</Data></Cell>'+CENT
cXml += '   </Row>'+CENT
cXml += '   <Row ss:AutoFitHeight="0" ss:StyleID="s195">'+CENT
cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="s339"><Data ss:Type="String">Payment ID</Data></Cell>'+CENT
cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m250592761060"><Data ss:Type="String">Deliv. Period</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Date</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Discount Type</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s103"><Data ss:Type="String">Amount(US$)</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s200"><Data ss:Type="String">Amount(RS$)</Data></Cell>'+CENT
cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m250592748680"/>'+CENT
cXml += '   </Row>'+CENT

For ny:=1 to Len(aDesc) 
	
	cZ3_DTINIC := aDesc[ny][2]
	cZ3_DTINIC := SubStr(cZ3_DTINIC,1,4)+"-"+SubStr(cZ3_DTINIC,5,2)+"-"+SubStr(cZ3_DTINIC,7,2)+"T00:00:00.000"
	cZ3_DTFIM  := aDesc[ny][3]
	cZ3_DTFIM  := SubStr(cZ3_DTFIM,1,4)+"-"+SubStr(cZ3_DTFIM,5,2)+"-"+SubStr(cZ3_DTFIM,7,2)+"T00:00:00.000"
	cE2_EMISS  := aDesc[ny][4]
	cE2_EMISS  := SubStr(cE2_EMISS,1,4)+"-"+SubStr(cE2_EMISS,5,2)+"-"+SubStr(cE2_EMISS,7,2)+"T00:00:00.000"

	cXml += '   <Row ss:AutoFitHeight="0" ss:StyleID="s195">'+CENT
	cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="s350"><Data ss:Type="String">'+aDesc[ny][1]+'</Data></Cell>'+CENT
	
 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="DateTime">'+cE2_EMISS+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s111"><Data ss:Type="String">'+Alltrim(aDesc[ny][5])+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s271"><Data ss:Type="String">'+TRANSFORM(aDesc[ny][6] ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s271"><Data ss:Type="String">'+TRANSFORM(aDesc[ny][7] ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m250691461596"/>'+CENT
	cXml += '   </Row>'+CENT
	
	nVLDESC  += aDesc[ny][6]
	nVLDESUS += aDesc[ny][7]
    
Next

cXml += '   <Row ss:AutoFitHeight="0" ss:StyleID="s195">'+CENT
cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="s342"><Data ss:Type="String">Total</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s344"/>'+CENT
cXml += '    <Cell ss:StyleID="s344"/>'+CENT
cXml += '    <Cell ss:StyleID="s344"/>'+CENT
cXml += '    <Cell ss:StyleID="s345"/>'+CENT
cXml += '    <Cell ss:StyleID="s346"><Data ss:Type="String">'+TRANSFORM(nVLDESC  ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
cXml += '    <Cell ss:StyleID="s346"><Data ss:Type="String">'+TRANSFORM(nVLDESUS ,"@E 999,999,999.99")+'</Data></Cell>'+CENT
cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m250691461536"/>'+CENT
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
cXml += '    <HorizontalResolution>600</HorizontalResolution>'+CENT
cXml += '    <VerticalResolution>-3</VerticalResolution>'+CENT
cXml += '   </Print>'+CENT
cXml += '     <Zoom>91</Zoom>'+CENT
 cXml += '   <Selected/>'+CENT
cXml += '   <Panes>'+CENT
cXml += '    <Pane>'+CENT
cXml += '     <Number>3</Number>'+CENT
cXml += '     <ActiveRow>10</ActiveRow>'+CENT
cXml += '     <ActiveCol>3</ActiveCol>'+CENT
cXml += '     <RangeSelection>R11C4:R11C5</RangeSelection>'+CENT
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

(cAlias1)->(DbCloseArea())	
(cAlias2)->(DbCloseArea())	
	           
Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                           4                           5                           6          7     8    9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38         39   40  41  42  43
AADD(aSx1,{"EDFR011" , "01" , "Contrato              ?" , "Contrato              ?" , "Contrato              ?" , "mv_ch1" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZ3"    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR011" , "02" , "DP                    ?" , "DP                    ?" , "DP                    ?" , "mv_ch2" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""       , "" , "", "", "", ""})
AADD(aSx1,{"EDFR011" , "03" , "Dt.Inicio Periodo     ?" , "Dt.Inicio Periodo     ?" , "Dt.Inicio Periodo     ?" , "mv_ch3" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""       , "" , "", "", "", ""})
AADD(aSx1,{"EDFR011" , "04" , "Dt.Fim Periodo        ?" , "Dt.Fim Periodo        ?" , "Dt.Fim Periodo        ?" , "mv_ch4" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""       , "" , "", "", "", ""})
AADD(aSx1,{"EDFR011" , "05" , "Data de Corte         ?" , "Data de Corte         ?" , "Data de Corte         ?" , "mv_ch5" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""       , "" , "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR011   05")
	
	DbSeek("EDFR011")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR011"
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
