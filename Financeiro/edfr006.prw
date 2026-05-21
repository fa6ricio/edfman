#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥ EDFR006     ≥ Autor ≥ Luis Felipe Mattos	≥ Data ≥ 21.02.14 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Price Fixation                          			 		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 		 ≥ Gera Excel                                           	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracao ≥ Luis Felipe Nascimento                     Data: 13/03/15  ≥±±
±±≥          ≥ Quando existiam 2 tipos de preÁo fixado e n„o fixado       ≥±±
±±≥          ≥ a rotina n„o tratava a filtro do preÁo FOB.                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracao ≥ Luis Felipe Nascimento                     Data: 16/03/15  ≥±±
±±≥          ≥ O relatÛrio estava recalculando o preco medio erroneamente ≥±±
±±≥          ≥ Foi puxado o preÁo calculado pela rotina de PrecificaÁ„o.  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracao ≥ Luis Felipe Nascimento                     Data: 24/03/15  ≥±±
±±≥          ≥ Ajuste na demonstraÁ„o do desconto em BRL/TP.              ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracao ≥ Luis Felipe Nascimento                     Data: 13/07/15  ≥±±
±±≥          ≥ Retirados os parenteses da conta do preÁo FOB    		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Alteracao ≥ Luis Felipe Nascimento                     Data: 10/08/15  ≥±±
±±≥          ≥ Alterada a forma de calculo do preco Fob         		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±∫AlteraÁ„o ≥ LuÌs Felipe Nascimento                           05/11/15  ∫±±
±±∫          ≥ RDM_054 - Contratos em Real                                ∫±±
±±∫          ≥ Adicionadas as linhas Contract Fx Rate e Amount USD / BRL  ∫±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±∫AlteraÁ„o ≥ LuÌs Felipe Nascimento                           20/06/16  ∫±±
±±∫          ≥ Realizadas alteraÁıes no tratamento de campos onde se usa  ∫±±
±±∫          ≥ Cents LB, USD p/ MT e BRL p/ MV, conforme campo preenchido.∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
±±≥Parametros≥ Nenhum													  ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
Retirados os parenteses pois, o calculo ficava errado para alguns contrato 

*/

User Function EDFR006()

Local 	cQry		:= ""
Local	cAlias		:= GetNextAlias()

Private lCtb       	:= CtbInUse()
Private cString    	:= "SZ3"
Private wnrel      	:= "EDFR006"
Private aOrd       	:= {"Contrato"}
Private CbTxt     	:= ""
Private cDesc1     	:= "RelaÁ„o de Contratos DP com PreÁo Fixado"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"RelaÁ„o de Contratos DP com PreÁo Fixado", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR006"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR006"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR006"
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

cQry := "SELECT	DISTINCT Z5_USINA,Z5_CONTRA,Z5_PERDE,Z5_TELA,Z5_PRODUTO,Z5_QTDEPER,Z5_LOTEPER, Z5_BOLSA, "+CENT
cQry += "Z5_PREMIO1,Z5_PREMIO2,Z5_PREMIO3,Z5_PREMIO4,Z5_PREMIO5,Z5_PREMIO6,Z5_PREMIO7,Z5_POLDP,Z5_PREMIO8,Z5_PREMIO9,Z5_ELEVAC, Z5_FIX100, "+CENT
//cQry += "Z6_TIPOPRE,Z6_DATA,Z6_LOTE,Z6_PRICING,Z6_VLFINAL,  "+CENT // 16/03/15 - LuÌs Felipe Nascimento
cQry += "Z6_TIPOPRE,Z6_DATA,Z6_LOTE,Z6_PRICING,Z6_VLFINAL,Z6_MDCENTS,Z6_MEDIAG,  "+CENT
//cQry += "Z6_PRECO+Z5_POLDP+Z5_PREMIO3+Z5_PREMIO1+(Z5_PREMIO6+Z5_PREMIO7) * CASE WHEN Z5_BOLSA='NY' THEN 22.0462 ELSE 1 END AS PrcFob,  "+CENT // 10/08/15 - Luis Felipe
//cQry += "(Z6_MDCENTS+Z5_PREMIO6+Z5_PREMIO7)*(CASE WHEN Z5_BOLSA='NY' AND CN9_MOEDA = 2 THEN 22.0462 ELSE 1 END)+Z5_PREMIO1+Z5_PREMIO3+Z5_POLDP AS PrcFob,"+CENT // 21/08/17 - Luis Felipe
cQry += "(Z6_MDCENTS+Z5_PREMIO6+Z5_PREMIO7)*(CASE WHEN Z5_BOLSA='NY' AND CN9_MOEDA = 2 AND Z5_TELA <> 'FX' THEN 22.0462 ELSE 1 END)+Z5_PREMIO1+Z5_PREMIO3+Z5_POLDP AS PrcFob,"+CENT
cQry += "Z3_POLDP,Z3_PAYTERM,Z3_DTINIC,Z3_DTFIM,Z3_DTINEM,Z3_DTFIEM,Z3_SAFRA,Z3_FIXADO,Z3_NFIXADO,Z3_DIVERSO, "+CENT
cQry += "CN9_QTDTOT, CN9_XJUROS, CN9_XFIXO, "+CENT
cQry += "(SELECT SUM(Z6_LOTE)                        FROM "+RetSqlName("SZ6")+" WHERE D_E_L_E_T_ = '' AND SZ5.Z5_CONTRA = Z6_CONTRA AND SZ5.Z5_PERDE = Z6_PERDE AND Z6_TIPOPRE = '2') AS LOTES_FIXADOS, "+CENT
//cQry += "ISNULL((SELECT SUM(Z6_PRICING) / COUNT(R_E_C_N_O_) FROM "+RetSqlName("SZ6")+" WHERE D_E_L_E_T_ = '' AND SZ5.Z5_CONTRA = Z6_CONTRA AND SZ5.Z5_PERDE = Z6_PERDE AND Z6_TIPOPRE = '2'),0) AS PRICE_MEDIO,  "+CENT // 16/03/15 - LuÌs Felipe Nascimento
cQry += "ISNULL((SELECT SUM(ZF_VALOR)                       FROM "+RetSqlName("SZF")+" WHERE D_E_L_E_T_ = '' AND SZ5.Z5_CONTRA = ZF_CONTRA AND SZ5.Z5_PERDE = ZF_DP AND ZF_CAMPO = 'Z3_PREMIO6' AND ZF_DESPESA LIKE '%SWITCH%' ),0) AS SWITCH,  "+CENT
cQry += "ISNULL((SELECT SUM(ZF_VALOR)                       FROM "+RetSqlName("SZF")+" WHERE D_E_L_E_T_ = '' AND SZ5.Z5_CONTRA = ZF_CONTRA AND SZ5.Z5_PERDE = ZF_DP AND ZF_CAMPO = 'Z3_PREMIO6' AND ZF_DESPESA LIKE '%EXPENSES%' ),0) AS EXPENSES,  "+CENT
cQry += "(SELECT  A1_NOME                                   FROM "+RetSqlName("SA1")+" WHERE D_E_L_E_T_ = '' AND CN9.CN9_CLIENT = A1_COD AND CN9_LOJACL = A1_LOJA) AS A1_NOME, "+CENT
cQry += "(SELECT  DISTINCT YJ_DESCR                         FROM "+RetSqlName("SZ2")+" SZ2, "+RetSqlName("SYJ")+" SYJ WHERE SZ2.D_E_L_E_T_ = '' AND SYJ.D_E_L_E_T_ = '' AND RTRIM(Z5_CONTRA)+'-'+RTRIM(Z5_PERDE) = Z2_CODPRO AND Z2_INCOTER = YJ_COD AND Substring(Z2_CONTRA,1,1)='P') AS YJ_DESCR, "+CENT 
cQry += "Y9_DESCR "+CENT
cQry += "FROM "+RetSqlName("SZ3")+" SZ3,"+RetSqlName("SZ5")+" SZ5,"+RetSqlName("SZ6")+" SZ6, "+RetSqlName("CN9")+" CN9, "+RetSqlName("SY9")+" SY9 "+CENT
cQry += "WHERE Z5_CONTRA = Z6_CONTRA "+CENT
cQry += "AND Z5_PERDE	 = Z6_PERDE "+CENT
cQry += "AND Z5_CONTRA	 = Z3_CONTRA "+CENT
cQry += "AND Z5_PERDE	 = Z3_PERIODO "+CENT
cQry += "AND Z5_CONTRA   = CN9_NUMERO "+CENT
cQry += "AND Z3_PORTO    = Y9_COD "+CENT 
cQry += "AND SubString(Z5_CONTRA,1,1) = 'P' "+CENT
cQry += "AND Z6_XINVCP                = ' ' "+CENT // 08/11/16 - Luis Felipe
//
// Filtros do relatÛrio
//
If !Empty(MV_PAR01) 
	cQry += " AND Z5_CONTRA = '"+MV_PAR01+"'"+CENT
EndIf

If !Empty(MV_PAR02)
	cQry += " AND Z5_PERDE  = '"+MV_PAR02+"'"+CENT
EndIf

cQry += "AND CN9.D_E_L_E_T_ = ''  "+CENT
cQry += "AND SY9.D_E_L_E_T_ = ''  "+CENT
cQry += "AND SZ3.D_E_L_E_T_ = ''  "+CENT
cQry += "AND SZ5.D_E_L_E_T_ = ''  "+CENT
cQry += "AND SZ6.D_E_L_E_T_ = ''  "+CENT
cQry += "ORDER BY 3 "+CENT

If Select("TRB") > 0
	dbselectarea("TRB")
	TRB->(dbCloseArea())
Endif

MemoWrite("C:\Tmp\EDFR006.txt",cQry)
cQuery := ChangeQuery(cQry)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TRB",.F.,.T.)
dbselectarea("TRB")
TRB->(dbGoTop())

If !Eof()
	RptStatus({|| GeraPlan()})
Else 
	Aviso("Aviso","Contrato "+Alltrim(MV_PAR01)+"-"+Alltrim(MV_PAR02)+" inexistente! Favor selecionar outro contrato.",{"Voltar"})
EndIf	

If Select("TRB") > 0
	dbselectarea("TRB")
	TRB->(dbCloseArea())
Endif

Return

**************************
Static Function GeraPlan()
**************************

Local cPayTer  	:= ""
Local cPPayter1	:= ""
Local cPPayter2	:= ""
Local aArray  	:= {}
Local oExcel
Local cArq
Local nArq
Local cPath
Local cXml    	:= ""            

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

// CabeÁalho
Aadd(aArray,{"Usina",;	//  1 -
"Contrato",;           	//  2 -
"Periodo",;            	//  3 -
"Tela",;               	//  4 -
"Produto",;   			//  5 -
"Quantidade",;         	//  6 -
"Lotes Periodo",;      	//  7 -
"Basis U$/TM ",;       	//  8 -
"Pre-Pagto ",;         	//  9 -
"Outros U$/TM",;       	// 10 -
"Elev. BRL/TM",;       	// 11 -
"Divers U$/TM",;       	// 12 -
"Outro Cts/Lb",;       	// 13 -
"Basis Cts/Lb",;       	// 14 -
"Switch",;              // 15 -
"Expenses",;            // 16 - 
"Pol",;                	// 17 -
"ElevaÁ„o",;     		// 18 -
"1-Prov./2-Defin.",;   	// 19 -
"Data Fixada",;        	// 20 -
"Lotes",;              	// 21 -
"Preco",;              	// 22 -
"Vl.Final",;           	// 23 -
"% PolarizaÁ„o",;      	// 24 -
"Payments Terms",;     	// 25 -
"Inic.Entrega",;       	// 26 -
"Fim Entrega ",;       	// 27 -
"Inic Embarq.",;       	// 28 -
"Fim Embarque",;       	// 29 -
"Safra",;              	// 30 -
"Preco FOB",;          	// 31 -
"Lotes Fixados",;     	// 32 -
"Preco Medio"})        	// 33 -

ProcRegua(RecCount("TRB"))

If TRB->(!EOF())
	
	While !TRB->(EOf())
		
		IncProc()

		cPayTer  := Space(20)
		If TRB->Z3_PAYTERM == '1'
			cPayTer := "CAD Bco"
		ElseIf TRB->Z3_PAYTERM == '2'
			cPayTer := "LC(C.Cred)"
		ElseIf TRB->Z3_PAYTERM == '3'
			cPayTer := "CAFD(cop.docs)"
		ElseIf TRB->Z3_PAYTERM == '4'
			cPayTer := "Stock Finance"
		ElseIf TRB->Z3_PAYTERM == '5'
			cPayTer := "Standby L/C"
		ElseIf TRB->Z3_PAYTERM == '6'
			cPayTer := "Standby L/C"
		ElseIf TRB->Z3_PAYTERM == '7'
			cPayTer := "CAD Without Prod"
		ElseIf TRB->Z3_PAYTERM == '8'
			cPayTer := "CAD"
		ElseIf TRB->Z3_PAYTERM == '9'
			cPayTer := "Prepayment"
		EndIf
		
		If !Empty(MV_PAR01) .and. !Empty(MV_PAR02)

 			cXml := '<?xml version="1.0"?>'+CENT
 			cXml += '<?mso-application progid="Excel.Sheet"?>'+CENT
 			cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
  			cXml += 'xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT
  			cXml += 'xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT
  			cXml += 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
  			cXml += 'xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT
  			cXml += '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT
 			cXml += '  <Author>luis.nascimento</Author>'+CENT
 			cXml += '  <LastAuthor>Luis Filipe Nascimento</LastAuthor>'+CENT
 			cXml += '  <LastPrinted>2014-02-24T19:36:46Z</LastPrinted>'+CENT
 			cXml += '  <Created>2014-02-24T18:04:18Z</Created>'+CENT
  			cXml += '  <LastSaved>2015-12-01T17:30:17Z</LastSaved>'+CENT
  			cXml += '  <Company>Microsoft</Company>'+CENT
  			cXml += '  <Version>15.00</Version>'+CENT
  			cXml += ' </DocumentProperties>'+CENT
  			cXml += ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CENT
 			cXml += '  <AllowPNG/>'+CENT
 			cXml += ' </OfficeDocumentSettings>'+CENT
 			cXml += ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
 			cXml += '  <WindowHeight>9045</WindowHeight>'+CENT
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
 			cXml += '  <Style ss:ID="s62" ss:Name="V&#56487;ula">'+CENT
 			cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="m924165623792">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="m924165623852">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="m924165623892">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
  			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="18" ss:Color="#000000"/>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="m924165624872">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="m924165624892">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="m924165624912">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="m924165624932">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
  			cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="m924165624020">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="m924165624100">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
 			cXml += '   <NumberFormat ss:Format="Fixed"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s68">'+CENT
 			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s69">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s70">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s71">'+CENT
  			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s72">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s77">'+CENT
 			cXml += '   <Borders/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s78">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s89">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s90">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s91">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s92">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s93">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s95" ss:Parent="s62">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '   <NumberFormat ss:Format="_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
 			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s96">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s97">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <NumberFormat ss:Format="#,##0.0000"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s98">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s99">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s105">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s107">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s113">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <NumberFormat ss:Format="Fixed"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s115">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <NumberFormat ss:Format="Fixed"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s128">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s140">'+CENT
  			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s147">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s148">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
 			cXml += '   <NumberFormat ss:Format="0.0000"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s149">'+CENT
 			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s157">'+CENT
 			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s158">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s159">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 			cXml += '   <NumberFormat ss:Format="0.0000"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s160">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s161">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s162">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>'+CENT
  			cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  			cXml += '   <NumberFormat ss:Format="0.0000"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s173">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s174">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders/>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s175">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s176">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s177">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s178">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s179">'+CENT
  			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s180">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s181">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s182">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s183">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s184">'+CENT
  			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s185">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s186">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s187">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s188">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s189">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s190">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s191">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s192">'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s193">'+CENT
  			cXml += '   <Borders/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s205">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s206">'+CENT
 			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s207">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
 			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s208">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s209">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s210">'+CENT
 			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s211">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders/>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s212">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s213">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '   <NumberFormat ss:Format="0.0000"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s214">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Borders/>'+CENT
 			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
 			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s215">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
 			cXml += '   </Borders>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s216">'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s217">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s218">'+CENT
 			cXml += '   <Borders>'+CENT
  			cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>'+CENT
  			cXml += '   </Borders>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s259">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
 			cXml += '  </Style>'+CENT
 			cXml += '  <Style ss:ID="s266">'+CENT
  			cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"'+CENT
  			cXml += '    ss:Bold="1"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s276">'+CENT
 			cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
 			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
 			cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
 			cXml += '  </Style>'+CENT
  			cXml += '  <Style ss:ID="s280">'+CENT
  			cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  			cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
  			cXml += '  </Style>'+CENT
  			cXml += ' </Styles>'+CENT
 			cXml += ' <Worksheet ss:Name="Plan1">'+CENT
 			cXml += '  <Table ss:ExpandedColumnCount="9" ss:ExpandedRowCount="100" x:FullColumns="1"'+CENT
 			cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
  			cXml += '   <Column ss:AutoFitWidth="0" ss:Width="75.75"/>'+CENT
  			cXml += '   <Column ss:AutoFitWidth="0" ss:Width="89.25"/>'+CENT
  			cXml += '   <Column ss:AutoFitWidth="0" ss:Width="97.5"/>'+CENT
  			cXml += '   <Column ss:AutoFitWidth="0" ss:Width="143.25"/>'+CENT
  			cXml += '   <Column ss:AutoFitWidth="0" ss:Width="74.25"/>'+CENT
 			cXml += '   <Column ss:AutoFitWidth="0" ss:Width="92.25"/>'+CENT
 			cXml += '   <Column ss:AutoFitWidth="0" ss:Width="74.25"/>'+CENT
 			cXml += '   <Column ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="61.5"/>'+CENT
 			cXml += '   <Column ss:AutoFitWidth="0" ss:Width="1.5"/>'+CENT

	 	 	cData 	:= DtoS(Ddatabase)
	 	 	cData  	:= SubStr(cData,1,4)+"-"+SubStr(cData,5,2)+"-"+SubStr(cData,7,2)+"T00:00:00.000"

  			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="24.75">'+CENT
  			cXml += '    <Cell ss:StyleID="s266"><Data ss:Type="String">ED&amp;F</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:MergeAcross="2" ss:MergeDown="1" ss:StyleID="m924165623892"><Data'+CENT
  			cXml += '      ss:Type="String">Price Fixation</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s280"><Data ss:Type="String">Date:</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s276"><Data ss:Type="DateTime">'+cData+'</Data></Cell>'+CENT
 			cXml += '   </Row>'+CENT
 			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="23.25">'+CENT
  			cXml += '    <Cell ss:StyleID="s266"><Data ss:Type="String">MAN</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:Index="6" ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '   </Row>'+CENT
 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Contract</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">Mill</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">Delivery Period:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Shipment Period</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">Crop</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Sugar Type</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">Pricing Type</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s71"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s72"/>'+CENT
 			cXml += '   </Row>'+CENT


 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  			cXml += '    <Cell ss:StyleID="s177"><Data ss:Type="String">'+TRB->Z5_CONTRA+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s180"><Data ss:Type="String">'+SubStr(TRB->Z5_USINA,1,14)+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s180"><Data ss:Type="String">'+TRB->Z5_PERDE+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s177"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s187"><Data ss:Type="String">'+TRB->Z3_SAFRA+'</Data></Cell>'+CENT
 
			If 'VHP' $ TRB->Z5_PRODUTO 
	 			cXml += '    <Cell ss:StyleID="s185"><Data ss:Type="String">VHP</Data></Cell>'+CENT
	 		Else
	 			cXml += '    <Cell ss:StyleID="s185"><Data ss:Type="String">XTL</Data></Cell>'+CENT
	 		EndIf	
 
			If TRB->CN9_XFIXO $  ' 1'
	 			cXml += '    <Cell ss:StyleID="s180"><Data ss:Type="String">TO BE FIXED</Data></Cell>'+CENT
			Else
 				cXml += '    <Cell ss:StyleID="s180"><Data ss:Type="String">FIXED</Data></Cell>'+CENT
			EndIf
 			cXml += '    <Cell ss:StyleID="s77"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s78"/>'+CENT
  			cXml += '   </Row>'+CENT

	 	 	cZ3_DTINIC 	:= SubStr(TRB->Z3_DTINIC,1,4)+"-"+SubStr(TRB->Z3_DTINIC,5,2)+"-"+SubStr(TRB->Z3_DTINIC,7,2)+"T00:00:00.000"
		    cZ3_DTFIM	:= SubStr(TRB->Z3_DTFIM,1,4)+"-"+SubStr(TRB->Z3_DTFIM,5,2)+"-"+SubStr(TRB->Z3_DTFIM,7,2)+"T00:00:00.000"
    		cZ3_DTINEM	:= SubStr(TRB->Z3_DTINEM,1,4)+"-"+SubStr(TRB->Z3_DTINEM,5,2)+"-"+SubStr(TRB->Z3_DTINEM,7,2)+"T00:00:00.000"
    		cZ3_DTFIEM	:= SubStr(TRB->Z3_DTFIEM,1,4)+"-"+SubStr(TRB->Z3_DTFIEM,5,2)+"-"+SubStr(TRB->Z3_DTFIEM,7,2)+"T00:00:00.000"

  			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  			cXml += '    <Cell ss:StyleID="s178"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s180"><Data ss:Type="String">'+SubStr(TRB->Z5_USINA,15,14)+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s181"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s184"><Data ss:Type="DateTime">'+cZ3_DTINEM+'</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s188"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s178"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s178"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s78"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s78"/>'+CENT
  			cXml += '   </Row>'+CENT

  			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  			cXml += '    <Cell ss:StyleID="s178"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s180"><Data ss:Type="String">'+SubStr(TRB->Z5_USINA,30,14)+'</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s182"><Data ss:Type="String">to</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s185"><Data ss:Type="String">to</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s188"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s178"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s190"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s77"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s78"/>'+CENT
  			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
 			cXml += '    <Cell ss:StyleID="s179"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s180"><Data ss:Type="String">'+SubStr(TRB->Z5_USINA,45,14)+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s183"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s186"><Data ss:Type="DateTime">'+cZ3_DTFIEM+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s189"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s179"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s191"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s77"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s78"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">
  			cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">Quantity</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Contracted</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Quantity for Period</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Operation</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">Loading  Port</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">Delivery Terms</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s69"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s77"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s78"/>'+CENT
  			cXml += '   </Row>'+CENT
  			
  			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  			cXml += '    <Cell ss:StyleID="s89"><Data ss:Type="String">Contracted</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s90"><Data ss:Type="String">Lots</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s90"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s91"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s92"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s92"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s93"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s77"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s78"/>'+CENT
  			cXml += '   </Row>'+CENT

  			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="27">'+CENT
  			cXml += '    <Cell ss:StyleID="s95"><Data ss:Type="String">'+Alltrim(Transform(TRB->CN9_QTDTOT,"@E 999,999,999.999"))+'</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s96"><Data ss:Type="String">'+Alltrim(Transform(TRB->Z5_LOTEPER,"@E 99999"))+'</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s97"><Data ss:Type="String">'+Alltrim(Transform(TRB->Z5_QTDEPER,"@E 999,999,999.999"))+'</Data></Cell>'+CENT
			If SubStr(TRB->Z5_CONTRA,1,1) = 'P'
	 			cXml += '    <Cell ss:StyleID="s98"><Data ss:Type="String">MAN BRASIL PURCHASE</Data></Cell>'+CENT
			Else
	 			cXml += '    <Cell ss:StyleID="s98"><Data ss:Type="String">MAN BRASIL EXPORT</Data></Cell>'+CENT
			EndIf
  			cXml += '    <Cell ss:StyleID="s99"><Data ss:Type="String">'+Alltrim(TRB->Y9_DESCR)+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m924165624020"><Data ss:Type="String">'+Alltrim(TRB->YJ_DESCR)+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s77"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s78"/>'+CENT
  			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">Payment Type</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s105"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">% to be paid if</Data></Cell>'+CENT
  			cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="s107"><Data ss:Type="String">% to be paid if not fixed</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">% Interest Rate A.A:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s105"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s105"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s69"/>'+CENT
 			cXml += '   </Row>'+CENT
 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s70"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s105"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s68"><Data ss:Type="String">fixed</Data></Cell>'+CENT
  			cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="s107"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s70"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s105"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s71"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s72"/>'+CENT
 			cXml += '   </Row>'+CENT
 			
 			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="21">'+CENT
 			cXml += '    <Cell ss:StyleID="s175"><Data ss:Type="String">'+cPayTer+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s176"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s113"><Data ss:Type="String">'+Transform(TRB->Z3_FIXADO,"@E 999.99")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="s115"><Data ss:Type="String">'+Transform(TRB->Z3_NFIXADO,"@E 999.99")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:MergeAcross="3" ss:StyleID="m924165624100"><Data ss:Type="String">'+Alltrim(Transform(TRB->CN9_XJUROS,"@E 999,999,999.99"))+'</Data></Cell>'+CENT
  			cXml += '   </Row>'+CENT
 
			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="14.25">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT
 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s70"><Data ss:Type="String">Market</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s105"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s105"><Data ss:Type="String">Contract Rule</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s105"><Data ss:Type="String">Pricing Month</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s69"><Data ss:Type="String">Lots</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
			If  Alltrim(TRB->Z5_BOLSA) == 'NY'
	 			cXml += '    <Cell ss:StyleID="s173"><Data ss:Type="String">                                    </Data></Cell>'+CENT
            Else
	 			cXml += '    <Cell ss:StyleID="s173"><Data ss:Type="String">N407 WHITE SUGAR FUTURES                         </Data></Cell>'+CENT
            EndIf
  			cXml += '    <Cell ss:StyleID="s174"/>'+CENT
  			cXml += '    <Cell ss:MergeDown="1" ss:StyleID="s128"><Data ss:Type="String">'+TRB->Z5_BOLSA+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:MergeDown="1" ss:StyleID="s128"><Data ss:Type="String">'+TRB->Z5_TELA+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:MergeDown="1" ss:StyleID="m924165624872"><Data ss:Type="String">'+Alltrim(Transform(TRB->Z5_LOTEPER,"@E 999,999,999,999"))+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
			If  Alltrim(TRB->Z5_BOLSA) == 'NY'
	 			cXml += '    <Cell ss:StyleID="s175"><Data ss:Type="String">ICE FUTURES U.S. SUGAR N.11         </Data></Cell>'+CENT
	  		Else	
	 			cXml += '    <Cell ss:StyleID="s175"><Data ss:Type="String">CONTRACT				            </Data></Cell>'+CENT
	  		EndIf
  			cXml += '    <Cell ss:StyleID="s176"/>'+CENT
  			cXml += '    <Cell ss:Index="7" ss:StyleID="s192"/>'+CENT
  			cXml += '   </Row>'+CENT

  			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '    <Cell ss:MergeAcross="4" ss:StyleID="m924165624892"><Data ss:Type="String">PRICING</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT
  			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m924165624912"><Data ss:Type="String">Date</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s140"><Data ss:Type="String">Lots</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s140"><Data ss:Type="String">Pricing</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s140"><Data ss:Type="String">Notes</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

            CN9->(DbSetOrder(1))
            CN9->(DbSeek(xFilial("CN9")+TRB->Z5_CONTRA))
            
            SC7->(DbSetOrder(2))
            SC7->(DbSeek(xFilial("SC7")+Alltrim(TRB->Z5_CONTRA)+'-'+Alltrim(TRB->Z5_PERDE)))

		 	While TRB->(!Eof())                   
 		 	 	cData:= SubStr(TRB->Z6_DATA,1,4)+"-"+SubStr(TRB->Z6_DATA,5,2)+"-"+SubStr(TRB->Z6_DATA,7,2)+"T00:00:00.000"
 		 	 	cFix := If(TRB->Z6_TIPOPRE == "2","Definitivo","Provisorio")
 		 	 	nVlf := If(TRB->Z6_TIPOPRE == "2",TRB->Z6_VLFINAL,0)
	 			nFob := If(TRB->Z6_TIPOPRE == "2",TRB->PrcFob,0) // 13/03/15 - Luis Felipe Nascimento 
	 			nMCT := If(TRB->Z6_TIPOPRE == "2",TRB->Z6_MDCENTS,0)
	 			nMED := If(TRB->Z6_TIPOPRE == "2",TRB->Z6_MEDIAG,0)
	 			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
	  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
	  			cXml += '    <Cell ss:MergeAcross="1" ss:StyleID="m924165624932"><Data ss:Type="DateTime">'+cData+'</Data></Cell>'+CENT
	  			cXml += '    <Cell ss:StyleID="s147"><Data ss:Type="String">'+Transform(TRB->Z6_LOTE,"@E 999,999,999,999")+'</Data></Cell>'+CENT
	  			cXml += '    <Cell ss:StyleID="s148"><Data ss:Type="String">'+Transform(TRB->Z6_PRICING,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
	  			cXml += '    <Cell ss:StyleID="s149"><Data ss:Type="String">'+cFix+'</Data></Cell>'+CENT
	 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
	 			cXml += '   </Row>'+CENT
 				TRB->(DbSkip())
            End 
            
            TRB->(DbGotop())

 			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:MergeAcross="2" ss:StyleID="m924165623792"><Data ss:Type="String">tt: '+Transform(LOTES_FIXADOS,"@E 999,999,999,999")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s157"><Data ss:Type="String">Avg: '+Transform(nMCT,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s157"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s158"><Data ss:Type="String">Contract Fx Rate</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s159"><Data ss:Type="String">'+Transform(SC7->C7_TAXAUSD,"@E 999,999,999.9999")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s160"/>'+CENT
 			If CN9->CN9_MOEDA == 1 // 05/11/15 - Luis Felipe
	  			cXml += '    <Cell ss:StyleID="s161"><Data ss:Type="String">Amount USD</Data></Cell>'+CENT
	  			cXml += '    <Cell ss:StyleID="s162"><Data ss:Type="String">'+Transform(nMED/SC7->C7_TAXAUSD,"@E 999,999,999.9999")+'</Data></Cell>'+CENT
			Else
	 			cXml += '    <Cell ss:StyleID="s161"><Data ss:Type="String">Amount BRL</Data></Cell>'+CENT
	  			cXml += '    <Cell ss:StyleID="s162"><Data ss:Type="String">'+Transform(nMED*SC7->C7_TAXAUSD,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			Endif
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s205"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s206"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s207"><Data ss:Type="String">Total Priced:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s208"><Data ss:Type="String">'+Transform(LOTES_FIXADOS,"@E 999,999,999,999")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s209"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">Balance to Price:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">'+Transform(TRB->Z5_LOTEPER-LOTES_FIXADOS,"@E 999,999,999,999")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s212"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">Average Price:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(nMCT,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
			If  Alltrim(TRB->Z5_BOLSA) == 'NY'
				cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">Cents p/ LB</Data></Cell>'+CENT
    		Else
				If  CN9->CN9_MOEDA == 2 
		 			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">USD p/ MT</Data></Cell>'+CENT
	            Else
		 			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">BRL p/ MT</Data></Cell>'+CENT
	            EndIf
            EndIf
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">Contractual Discount:</Data></Cell>'+CENT
			If TRB->Z5_PREMIO7 < 0 .or. TRB->Z5_PREMIO1 < 0
				If TRB->Z5_PREMIO7 < 0
		  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->Z5_PREMIO7,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
		  			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">Cents p/ LB</Data></Cell>'+CENT
		 		Else
		 			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->Z5_PREMIO1,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
		  			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">USD p /MT</Data></Cell>'+CENT
		 		EndIf	
	 		Else
	 			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">          0,0000</Data></Cell>'+CENT
	  			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String"></Data></Cell>'+CENT
	 		EndIf	
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
 			cXml += '   </Row>'+CENT

//          22/08/17 - Luis Felipe - Inicio

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">Other Discounts U$/TM:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->Z5_PREMIO3,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s212"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">Other Discounts UScts/Lb:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->Z5_PREMIO6,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s212"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

//          22/08/17 - Luis Felipe - Fim

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">Switch:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->SWITCH,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s212"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">Expenses:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->EXPENSES,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s212"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">Contractual Premium:</Data></Cell>'+CENT
			If TRB->Z5_PREMIO7 > 0 .or. TRB->Z5_PREMIO1 > 0
				If TRB->Z5_PREMIO7 > 0 
		  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->Z5_PREMIO7,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
	  			Else
	  				cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->Z5_PREMIO1,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
	  			EndIf	
			Else
	  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">          0,0000</Data></Cell>'+CENT
			EndIf
  			cXml += '    <Cell ss:StyleID="s212"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">Polarization Premium:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->Z5_POLDP,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">USD p /MT</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s214"><Data ss:Type="String">Fob Price:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s214"><Data ss:Type="String">'+Transform(nFob,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
			If  Alltrim(TRB->Z5_BOLSA) == 'NY'
	 			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">USD p /MT</Data></Cell>'+CENT
            Else
				If CN9->CN9_MOEDA == 1
		 			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">BRL p/ MT</Data></Cell>'+CENT
				Else
		 			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">USD p /MT</Data></Cell>'+CENT
				EndIf
			EndIf
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">Miscellaneous:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->Z3_DIVERSO,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s212"/>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s210"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s193"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s211"><Data ss:Type="String">FOB Discount:</Data></Cell>'+CENT
			If !Empty(TRB->Z5_PREMIO4)
				cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->Z5_PREMIO4,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
			Else
	  			cXml += '    <Cell ss:StyleID="s213"><Data ss:Type="String">'+Transform(TRB->Z5_ELEVAC,"@E 999,999,999.999999")+'</Data></Cell>'+CENT
			EndIf
			If !Empty(TRB->Z5_PREMIO4) .or. !Empty(TRB->Z5_ELEVAC)
				If !Empty(TRB->Z5_PREMIO4)
		 			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">BRL p/ MT</Data></Cell>'+CENT
				Else
		 			cXml += '    <Cell ss:StyleID="s212"><Data ss:Type="String">USD p /MT</Data></Cell>'+CENT
				EndIf
			EndIf
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '   <Row ss:AutoFitHeight="0" ss:Height="15.75">'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s215"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s216"/>'+CENT
  			cXml += '    <Cell ss:StyleID="s217"><Data ss:Type="String">Final Price:</Data></Cell>'+CENT
  			cXml += '    <Cell ss:StyleID="s217"><Data ss:Type="String">'+Transform(nVlf+TRB->Z3_DIVERSO,"@E 999,999,999.999999")+'</Data></Cell>'+CENT // 26/12/16 - Luis Felipe

			If  Alltrim(TRB->Z5_BOLSA) == 'NY'
	 			cXml += '    <Cell ss:StyleID="s218"><Data ss:Type="String">USD p /MT</Data></Cell>'+CENT
            Else
				If CN9->CN9_MOEDA == 1
		 			cXml += '    <Cell ss:StyleID="s218"><Data ss:Type="String">BRL p/ MT</Data></Cell>'+CENT
				Else
		 			cXml += '    <Cell ss:StyleID="s218"><Data ss:Type="String">USD p /MT</Data></Cell>'+CENT
				EndIf
			EndIf
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT

  			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:MergeAcross="4" ss:MergeDown="1" ss:StyleID="m924165623852"><ss:Data'+CENT
  			cXml += '      ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40"><B><Font'+CENT
  			cXml += '        html:Color="#000000">Observacoes complementares: </Font></B><Font'+CENT
 			cXml += '       html:Color="#000000">'+TRB->Z5_FIX100+'</Font></ss:Data></Cell>'+CENT
 			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
 			cXml += '   </Row>'+CENT
 			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  			cXml += '    <Cell ss:StyleID="s192"/>'+CENT
  			cXml += '    <Cell ss:Index="7" ss:StyleID="s192"/>'+CENT
  			cXml += '   </Row>'+CENT
  			cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  			cXml += '    <Cell ss:MergeAcross="6" ss:StyleID="s259"/>'+CENT
 			cXml += '   </Row>'+CENT

 			cXml += '  </Table>'+CENT
 			cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
 			cXml += '   <PageSetup>'+CENT
  			cXml += '    <Header x:Margin="0.3"/>'+CENT
  			cXml += '    <Footer x:Margin="0.3"/>'+CENT
  			cXml += '    <PageMargins x:Bottom="0.75" x:Left="0.25" x:Right="0.25" x:Top="0.75"/>'+CENT
  			cXml += '   </PageSetup>'+CENT
  			cXml += '   <Unsynced/>'+CENT
 			cXml += '   <FitToPage/>'+CENT
 			cXml += '   <Print>'+CENT
 			cXml += '    <FitHeight>0</FitHeight>'+CENT
 			cXml += '    <ValidPrinterInfo/>'+CENT
  			cXml += '    <PaperSizeIndex>9</PaperSizeIndex>'+CENT
  			cXml += '    <Scale>81</Scale>'+CENT
  			cXml += '    <HorizontalResolution>600</HorizontalResolution>'+CENT
  			cXml += '    <VerticalResolution>600</VerticalResolution>'+CENT
  			cXml += '   </Print>'+CENT
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
		Else
			// Itens
			Aadd(aArray,{TRB->Z5_USINA,;           					//  1
			TRB->Z5_CONTRA,;                                       	//  2
			TRB->Z5_PERDE,;                                        	//  3
			TRB->Z5_TELA,;                                         	//  4
			TRB->Z5_PRODUTO,;                                      	//  5
			TRB->Z5_QTDEPER,;									    //  6
			TRB->Z5_LOTEPER,;      									//  7
			TRB->Z5_PREMIO1,;       								//  8
			TRB->Z5_PREMIO2,;       								//  9
			TRB->Z5_PREMIO3,;       								// 10
			TRB->Z5_PREMIO4,;       								// 11
			TRB->Z5_PREMIO5,;       								// 12
			TRB->Z5_PREMIO6,;       								// 13
			TRB->Z5_PREMIO7,;       								// 14
			TRB->Z5_PREMIO8,;       								// 15
			TRB->Z5_PREMIO9,;       								// 16
			TRB->Z5_POLDP  ,;       								// 17
			TRB->Z5_ELEVAC ,;       								// 18
			TRB->Z6_TIPOPRE,;                                      	// 19
			StoD(TRB->Z6_DATA),;                                   	// 20
			TRB->Z6_LOTE,;      									// 21
			TRB->Z6_PRICING,;       								// 22
			TRB->Z6_VLFINAL,;       								// 23
			TRB->Z3_POLDP,;      									// 24
			cPayTer,;                                              	// 25
			StoD(TRB->Z3_DTINIC),;                                 	// 26
			StoD(TRB->Z3_DTFIM),;                                  	// 27
			StoD(TRB->Z3_DTINEM),;                                 	// 28
			StoD(TRB->Z3_DTFIEM),;                                 	// 29
			TRB->Z3_SAFRA,;                                        	// 30
			TRB->PrcFob,;       									// 31
			TRB->LOTES_FIXADOS,;   									// 32
			TRB->PRICE_MEDIO})      								// 33
		EndIf
		If Empty(MV_PAR02)
			DbSkip()
		Else
			Exit	
		EndIf	
	End
	
	If !Empty(MV_PAR01) .and. !Empty(MV_PAR02)
		FWrite(nArq,cXml)
		FClose(nArq)
		shellExecute( "Open", cPath + cArq + ".xml", " /k dir", "C:\", 1 )
	Else
		DlgToExcel( { { "ARRAY", "", "", aArray} })
	EndIf
EndIf

Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                           4                           5                           6          7     8    9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38         39   40  41  42  43
AADD(aSx1,{"EDFR006" , "01" , "Contrato              ?" , "Contrato              ?" , "Contrato              ?" , "mv_ch1" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZ3"    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR006" , "02" , "DP                    ?" , "DP                    ?" , "DP                    ?" , "mv_ch2" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""       , "" , "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR006   02")
	
	DbSeek("EDFR006")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR006"
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
