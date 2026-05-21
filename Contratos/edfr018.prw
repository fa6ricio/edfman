#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ EDFR018     ³ Autor ³ Luis Felipe Mattos	³ Data ³ 04.08.15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Sumário do Navio                        			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ Gera Excel - Contratos                               	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFR018()

Local 	nOrdem
Local 	cQuery		:= ""
Private   cAliasQry   := GetNextAlias()

Private cString    	:= "SZD"
Private wnrel      	:= "EDFR018"
Private aOrd       	:= {"Nota Fiscal"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Sumário do Navio"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Sumário do Navio", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR018"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR018"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR018"
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

If !Empty(MV_PAR05) .and. !Empty(MV_PAR11) 
	Aviso("Sumario Navio","Não permitido escolher o Porto e a Invoice ao mesmo tempo. Escolha uma das opções por vez.",{"Voltar"})
	Return
EndIf

SY9->(DbSetOrder(1))
SY9->(DbSeek(xFilial("SY9")+MV_PAR05))

cQuery := " SELECT * FROM"+CENT
cQuery += " ("+CENT
If !Empty(MV_PAR06) .or. !Empty(MV_PAR07) .or. Empty(MV_PAR06) .and. Empty(MV_PAR07) .and. Empty(MV_PAR08) .and. Empty(MV_PAR09)
	cQuery += " SELECT EES_FILIAL"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_SAFRA FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_SAFRA"+CENT
	cQuery += " , EEC_EMBARC"+CENT
	cQuery += " ,(SELECT TOP 1 Y9_CIDADE FROM "+RetSqlName("SY9")+" WHERE EEC_ORIGEM = Y9_SIGLA  AND D_E_L_E_T_ = ' ') AS EEC_ORIGEM"+CENT
	cQuery += " ,(SELECT TOP 1 Y9_CIDADE FROM "+RetSqlName("SY9")+" WHERE EEC_DEST = Y9_SIGLA  AND D_E_L_E_T_ = ' ') AS EEC_DEST"+CENT
	cQuery += " ,(SELECT TOP 1 ZE_NOME FROM "+RetSqlName("SZE")+" WHERE EE8_LOCAL = ZE_LOCAL AND D_E_L_E_T_ = ' ') AS ZE_NOME"+CENT
	cQuery += " ,EES_PREEMB"+CENT
	cQuery += " ,(SELECT TOP 1 CTH_DESC01 FROM CTH010 WHERE EES_PREEMB = CTH_CLVL AND D_E_L_E_T_ = ' ') AS CTH_BOOKIN"+CENT
	cQuery += " ,EES_PEDIDO"+CENT
	cQuery += " ,A2_NREDUZ"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_CONTRA FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_CONTRA"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_PERIODO FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_PERIODO"+CENT
	cQuery += " ,(CASE WHEN B1_GRUPO = '001' THEN 'VHP' ELSE (CASE WHEN B1_GRUPO IN ('002','003','004','023') THEN 'XTL' ELSE 'REF' END) END) TIPO"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_DTINIC FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_DTINIC"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_DTFIM  FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_DTFIM"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_DTINEM FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_DTINEM"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_DTFIEM FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_DTFIEM"+CENT
	cQuery += " ,(SELECT TOP 1 EXR_NRINVO FROM "+RetSqlName("EXR")+" WHERE EES.EES_PREEMB = EXR_PREEMB AND D_E_L_E_T_ <> '*') AS EXR_NRINVO"+CENT
	cQuery += " ,EEC_INCOTE"+CENT
	cQuery += " ,D2_SEGUM"+CENT
	cQuery += " ,D2_QTSEGUM"+CENT          	
	cQuery += " ,D2_UM"+CENT
	cQuery += " ,CASE WHEN D2_UM = 'SC' THEN D2_QUANT ELSE 0 END AS D2_QUANT"+CENT
	cQuery += " ,EE8_XPOLDP"+CENT
	cQuery += " ,EEC_VLFOB"+CENT
	cQuery += " ,(SELECT TOP 1 Z6_VLFINAL FROM "+RetSqlName("SZ3")+" Z3, "+RetSqlName("SZ6")+" Z6 WHERE EES.EES_COD_I = Z3.Z3_CTRDP AND Z3.Z3_CONTRA = Z6.Z6_CONTRA AND Z3.Z3_PERIODO = Z6.Z6_PERDE AND Z6.Z6_TIPOPRE = '2' AND Z3.D_E_L_E_T_ <> '*' AND Z6.D_E_L_E_T_ <> '*') AS Z6_VLFINAL "+CENT
	cQuery += " ,(SELECT SUM(Z6_LOTE)     FROM "+RetSqlName("SZ3")+" Z3, "+RetSqlName("SZ6")+" Z6 WHERE EES.EES_COD_I = Z3.Z3_CTRDP AND Z3.Z3_CONTRA = Z6.Z6_CONTRA AND Z3.Z3_PERIODO = Z6.Z6_PERDE AND Z6.Z6_TIPOPRE = '2' AND Z3.D_E_L_E_T_ <> '*' AND Z6.D_E_L_E_T_ <> '*') AS Z6_LOTE  "+CENT
	cQuery += " ,(SELECT TOP 1 Z3_QTDLOT  FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_QTDLOT"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_PAYTERM FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_PAYTERM"+CENT
	cQuery += " ,EES_NRNF"+CENT
	cQuery += " ,EES_DTNF"+CENT
	cQuery += " ,EEC_NRINVO"+CENT
	cQuery += " ,EEC_NRCONH"+CENT 
	cQuery += " ,EEC_DTEMBA"+CENT
	cQuery += " ,EEC_STATUS"+CENT
	cQuery += " ,EE8_LOCAL"+CENT
	cQuery += " ,EE9_RE"+CENT
	cQuery += " ,EE9_NRSD"+CENT
	cQuery += " ,EEC_ORIGEM AS SIGLA"+CENT
	cQuery += " FROM "+RetSqlName("EES")+" EES, "+RetSqlName("SD2")+" SD2, "+RetSqlName("EEC")+" EEC, "+RetSqlName("EE8")+" EE8, "+RetSqlName("SA2")+" SA2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("EE9")+" EE9"+CENT
	cQuery += " WHERE EES_FILIAL = D2_FILIAL"+CENT
	cQuery += " AND EES_PEDIDO = D2_PEDIDO"+CENT
	cQuery += " AND EES_COD_I  = D2_COD"+CENT
	cQuery += " AND EES_FILIAL = EEC_FILIAL"+CENT
	cQuery += " AND EES_PREEMB = EEC_PREEMB"+CENT
	cQuery += " AND EES_FILIAL = EE8_FILIAL"+CENT
	cQuery += " AND EES_COD_I  = EE8_COD_I"+CENT
	cQuery += " AND EES_PEDIDO = EE8_PEDIDO"+CENT
	cQuery += " AND EES_FILIAL = EE9_FILIAL"+CENT
	cQuery += " AND EES_PREEMB = EE9_PREEMB"+CENT
	cQuery += " AND EES_COD_I  = EE9_COD_I"+CENT
	cQuery += " AND EES_PEDIDO = EE9_PEDIDO"+CENT
	cQuery += " AND EEC_FORN   = A2_COD"+CENT
	cQuery += " AND EEC_FOLOJA = A2_LOJA"+CENT
	cQuery += " AND EES_COD_I  = B1_COD"+CENT
	
	// Filtros
	If !Empty(MV_PAR01)
		cQuery += "	AND EES_PREEMB LIKE '%"+Alltrim(MV_PAR01)+"%'"+CENT
	EndIf
	If !Empty(MV_PAR02) 
		cQuery += " AND EE8_LOCAL = '"+MV_PAR02+"'"+CENT
	EndIf
	If !Empty(MV_PAR03)
		If !Empty(MV_PAR04)
			cQuery += "	AND EES_COD_I = '"+Alltrim(MV_PAR03)+"-"+Alltrim(MV_PAR04)+"'"+CENT
		Else
			cQuery += "	AND EES_COD_I LIKE '%"+Alltrim(MV_PAR03)+"%'"+CENT
		EndIf	
	EndIf
	
	dMV_PAR07 := If(Empty(MV_PAR07),Ddatabase,MV_PAR07)
	cQuery += " AND EES_DTNF BETWEEN '"+DtoS(MV_PAR06)+"' AND '"+DtoS(dMV_PAR07)+"'"+CENT 
	
	If !Empty(MV_PAR10) 
		cQuery += " AND EE9_RE = '"+MV_PAR10+"'"+CENT
	EndIf
	
	cQuery += " AND EES.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND SD2.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND EEC.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND EE8.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND SA2.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND SB1.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND EE9.D_E_L_E_T_ = ' '"+CENT
EndIf

If !Empty(MV_PAR08) .or. !Empty(MV_PAR09) .or. Empty(MV_PAR06) .and. Empty(MV_PAR07) .and. Empty(MV_PAR08) .and. Empty(MV_PAR09)
	If  !Empty(MV_PAR07) .or. Empty(MV_PAR06) .and. Empty(MV_PAR07) .and. Empty(MV_PAR08) .and. Empty(MV_PAR09)
		cQuery += " UNION"+CENT
	EndIf	
	cQuery += " SELECT EES_FILIAL"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_SAFRA FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_SAFRA"+CENT
	cQuery += " , EEC_EMBARC"+CENT
	cQuery += " ,(SELECT TOP 1 Y9_CIDADE FROM "+RetSqlName("SY9")+" WHERE EEC_ORIGEM = Y9_SIGLA  AND D_E_L_E_T_ = ' ') AS EEC_ORIGEM"+CENT
	cQuery += " ,(SELECT TOP 1 Y9_CIDADE FROM "+RetSqlName("SY9")+" WHERE EEC_DEST = Y9_SIGLA  AND D_E_L_E_T_ = ' ') AS EEC_DEST"+CENT
	cQuery += " ,(SELECT TOP 1 ZE_NOME FROM "+RetSqlName("SZE")+" WHERE EE8_LOCAL = ZE_LOCAL AND D_E_L_E_T_ = ' ') AS ZE_NOME"+CENT
	cQuery += " ,EES_PREEMB"+CENT
	cQuery += " ,(SELECT TOP 1 CTH_DESC01 FROM CTH010 WHERE EES_PREEMB = CTH_CLVL AND D_E_L_E_T_ = ' ') AS CTH_BOOKIN"+CENT
	cQuery += " ,EES_PEDIDO"+CENT
	cQuery += " ,A2_NREDUZ"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_CONTRA FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_CONTRA"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_PERIODO FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_PERIODO"+CENT
	cQuery += " ,(CASE WHEN B1_GRUPO = '001' THEN 'VHP' ELSE (CASE WHEN B1_GRUPO IN ('001','002','003') THEN 'XTL' ELSE 'REF' END) END) TIPO"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_DTINIC FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_DTINIC"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_DTFIM  FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_DTFIM"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_DTINEM FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_DTINEM"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_DTFIEM FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_DTFIEM"+CENT
	cQuery += " ,(SELECT TOP 1 EXR_NRINVO FROM "+RetSqlName("EXR")+" WHERE EES.EES_PREEMB = EXR_PREEMB AND D_E_L_E_T_ <> '*') AS EXR_NRINVO"+CENT
	cQuery += " ,EEC_INCOTE"+CENT
	cQuery += " ,D2_SEGUM"+CENT
	cQuery += " ,D2_QTSEGUM"+CENT          	
	cQuery += " ,D2_UM"+CENT
	cQuery += " ,CASE WHEN D2_UM = 'SC' THEN D2_QUANT ELSE 0 END AS D2_QUANT"+CENT
	cQuery += " ,EE8_XPOLDP"+CENT
	cQuery += " ,EEC_VLFOB"+CENT
	cQuery += " ,(SELECT TOP 1 Z6_VLFINAL FROM "+RetSqlName("SZ3")+" Z3, "+RetSqlName("SZ6")+" Z6 WHERE EES.EES_COD_I = Z3.Z3_CTRDP AND Z3.Z3_CONTRA = Z6.Z6_CONTRA AND Z3.Z3_PERIODO = Z6.Z6_PERDE AND Z6.Z6_TIPOPRE = '2' AND Z3.D_E_L_E_T_ <> '*' AND Z6.D_E_L_E_T_ <> '*') AS Z6_VLFINAL "+CENT
	cQuery += " ,(SELECT SUM(Z6_LOTE)     FROM "+RetSqlName("SZ3")+" Z3, "+RetSqlName("SZ6")+" Z6 WHERE EES.EES_COD_I = Z3.Z3_CTRDP AND Z3.Z3_CONTRA = Z6.Z6_CONTRA AND Z3.Z3_PERIODO = Z6.Z6_PERDE AND Z6.Z6_TIPOPRE = '2' AND Z3.D_E_L_E_T_ <> '*' AND Z6.D_E_L_E_T_ <> '*') AS Z6_LOTE  "+CENT
	cQuery += " ,(SELECT TOP 1 Z3_QTDLOT  FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_QTDLOT"+CENT
	cQuery += " ,(SELECT TOP 1 Z3_PAYTERM FROM "+RetSqlName("SZ3")+" WHERE EES.EES_COD_I = Z3_CTRDP AND D_E_L_E_T_ <> '*') AS Z3_PAYTERM"+CENT
	cQuery += " ,EES_NRNF"+CENT
	cQuery += " ,EES_DTNF"+CENT
	cQuery += " ,EEC_NRINVO"+CENT
	cQuery += " ,EEC_NRCONH"+CENT 
	cQuery += " ,EEC_DTEMBA"+CENT
	cQuery += " ,EEC_STATUS"+CENT
	cQuery += " ,EE8_LOCAL"+CENT
	cQuery += " ,EE9_RE"+CENT
	cQuery += " ,EE9_NRSD"+CENT
	cQuery += " ,EEC_ORIGEM AS SIGLA"+CENT
	cQuery += " FROM "+RetSqlName("EES")+" EES, "+RetSqlName("SD2")+" SD2, "+RetSqlName("EEC")+" EEC, "+RetSqlName("EE8")+" EE8, "+RetSqlName("SA2")+" SA2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("EE9")+" EE9"+CENT
	cQuery += " WHERE EES_FILIAL = D2_FILIAL"+CENT
	cQuery += " AND EES_PEDIDO = D2_PEDIDO"+CENT
	cQuery += " AND EES_COD_I  = D2_COD"+CENT
	cQuery += " AND EES_FILIAL = EEC_FILIAL"+CENT
	cQuery += " AND EES_PREEMB = EEC_PREEMB"+CENT
	cQuery += " AND EES_FILIAL = EE8_FILIAL"+CENT
	cQuery += " AND EES_COD_I  = EE8_COD_I"+CENT
	cQuery += " AND EES_PEDIDO = EE8_PEDIDO"+CENT
	cQuery += " AND EES_FILIAL = EE9_FILIAL"+CENT
	cQuery += " AND EES_PREEMB = EE9_PREEMB"+CENT
	cQuery += " AND EES_COD_I  = EE9_COD_I"+CENT
	cQuery += " AND EES_PEDIDO = EE9_PEDIDO"+CENT
	cQuery += " AND EEC_FORN   = A2_COD"+CENT
	cQuery += " AND EEC_FOLOJA = A2_LOJA"+CENT
	cQuery += " AND EES_COD_I  = B1_COD"+CENT
	
	// Filtros
	If !Empty(MV_PAR01)
		cQuery += "	AND EES_PREEMB = '"+MV_PAR01+"'"+CENT
	EndIf
	If !Empty(MV_PAR02) 
		cQuery += " AND EE8_LOCAL = '"+MV_PAR02+"'"+CENT
	EndIf
	If !Empty(MV_PAR03)
		cQuery += "	AND EES_COD_I LIKE '%"+Alltrim(MV_PAR03)+"-"+Alltrim(MV_PAR04)+"%'"+CENT
	EndIf
    
	dMV_PAR09 := If(Empty(MV_PAR09),Ddatabase,MV_PAR09)
	cQuery += " AND EEC_DTEMBA BETWEEN '"+DtoS(MV_PAR08)+"' AND '"+DtoS(dMV_PAR09)+"'"+CENT 

	If !Empty(MV_PAR10) 
		cQuery += " AND EE9_RE = '"+MV_PAR10+"'"+CENT
	EndIf
	
	cQuery += " AND EES.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND SD2.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND EEC.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND EE8.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND SA2.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND SB1.D_E_L_E_T_ = ' '"+CENT
	cQuery += " AND EE9.D_E_L_E_T_ = ' '"+CENT
EndIf
cQuery += " )"+CENT
cQuery += " AS EES"+CENT

If !Empty(MV_PAR05) 
	cQuery += " WHERE SIGLA  = '"+SY9->Y9_SIGLA+"'"+CENT
EndIf

If !Empty(MV_PAR11) 
	cQuery += " WHERE EXR_NRINVO = '"+MV_PAR11+"'"+CENT
EndIf	    

cQuery += " ORDER BY EES_FILIAL,Z3_CONTRA,Z3_PERIODO,EES_NRNF"+CENT

MemoWrite("C:\Tmp\EDFR018.txt",cQuery)
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

	cXml := '<?xml version="1.0"?>'+CENT
	cXml += '<?mso-application progid="Excel.Sheet"?>'+CENT
	cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
 	cXml += 'xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT
 	cXml += 'xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT
 	cXml += 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
 	cXml += 'xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT
 	cXml += '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT
  	cXml += ' <Author>Santos, Leonardo (SUG, BRRIO)</Author>'+CENT
  	cXml += ' <LastAuthor>Luis Filipe Nascimento</LastAuthor>'+CENT
  	cXml += ' <Created>2015-06-24T14:14:40Z</Created>'+CENT
 	cXml += ' <LastSaved>2015-08-17T14:11:59Z</LastSaved>'+CENT
 	cXml += ' <Company>Hewlett-Packard Company</Company>'+CENT
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
  	cXml += ' <ActiveSheet>1</ActiveSheet>'+CENT
  	cXml += ' <ProtectStructure>False</ProtectStructure>'+CENT
  	cXml += ' <ProtectWindows>False</ProtectWindows>'+CENT
 	cXml += '</ExcelWorkbook>'+CENT
 	cXml += '<Styles>'+CENT
  	cXml += ' <Style ss:ID="Default" ss:Name="Normal">'+CENT
  	cXml += '  <Alignment ss:Vertical="Bottom"/>'+CENT
  	cXml += '  <Borders/>'+CENT
  	cXml += '  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
  	cXml += '  <Interior/>'+CENT
   	cXml += '  <NumberFormat/>'+CENT
   	cXml += '  <Protection/>'+CENT
   	cXml += ' </Style>'+CENT
  	cXml += ' <Style ss:ID="s62">'+CENT
  	cXml += '  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
   	cXml += '   ss:Bold="1"/>'+CENT
   	cXml += ' </Style>'+CENT
   	cXml += ' <Style ss:ID="s63">'+CENT
  	cXml += '  <Borders>'+CENT
  	cXml += '   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
   	cXml += '   <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
   	cXml += '   <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
   	cXml += '   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '  </Borders>'+CENT
  	cXml += '  <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
   	cXml += ' </Style>'+CENT
   	cXml += ' <Style ss:ID="s64">'+CENT
   	cXml += '  <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Interior ss:Color="#F2F2F2" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s65">'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Interior ss:Color="#F2F2F2" ss:Pattern="Solid"/>'+CENT
 	cXml += '   <NumberFormat ss:Format="mmm/yy"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s66">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
  	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s67">'+CENT
 	cXml += '   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s75">'+CENT
  	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
 	cXml += '  <Borders>'+CENT
 	cXml += '   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '  </Borders>'+CENT
  	cXml += '  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
   	cXml += '   ss:Bold="1"/>'+CENT
   	cXml += '  <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
   	cXml += ' </Style>'+CENT
  	cXml += ' <Style ss:ID="s76">'+CENT
  	cXml += '  <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
   	cXml += '  <Borders>'+CENT
   	cXml += '   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
   	cXml += '   <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
   	cXml += '  </Borders>'+CENT
   	cXml += '  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
   	cXml += '   ss:Bold="1"/>'+CENT
  	cXml += '  <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += ' </Style>'+CENT
   	cXml += ' <Style ss:ID="s77">'+CENT
   	cXml += '  <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
   	cXml += '  <Borders>'+CENT
 	cXml += '   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '  </Borders>'+CENT
  	cXml += '  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000"'+CENT
  	cXml += '   ss:Bold="1"/>'+CENT
   	cXml += '  <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
   	cXml += ' </Style>'+CENT
   	cXml += ' <Style ss:ID="s78">'+CENT
  	cXml += '  <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
  	cXml += ' </Style>'+CENT
   	cXml += ' <Style ss:ID="s79">'+CENT
   	cXml += '  <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
   	cXml += '  <NumberFormat ss:Format="Short Date"/>'+CENT
  	cXml += ' </Style>'+CENT
  	cXml += ' <Style ss:ID="s80">'+CENT
   	cXml += '  <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
   	cXml += ' </Style>'+CENT
   	cXml += ' <Style ss:ID="s81">'+CENT
  	cXml += '  <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
  	cXml += '  <NumberFormat ss:Format="Standard"/>'+CENT
   	cXml += ' </Style>'+CENT
   	cXml += ' <Style ss:ID="s82">'+CENT
   	cXml += '  <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s88">'+CENT
 	cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s89">'+CENT
  	cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders>'+CENT
 	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>'+CENT
 	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s90">'+CENT
  	cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
  	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"'+CENT
 	cXml += '    ss:Bold="1"/>'+CENT
 	cXml += '   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
  	cXml += '  <Style ss:ID="s92">'+CENT
  	cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
 	cXml += '   <Borders/>'+CENT
 	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>'+CENT
  	cXml += '  </Style>'+CENT
 	cXml += '  <Style ss:ID="s93">'+CENT
 	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
  	cXml += '   <Borders>'+CENT
  	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
 	cXml += '   </Borders>'+CENT
  	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  	cXml += '    ss:Bold="1"/>'+CENT
  	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
 	cXml += ' </Style>'+CENT
 	cXml += ' <Style ss:ID="s94">'+CENT
  	cXml += '  <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
  	cXml += '  <Borders>'+CENT
  	cXml += '   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
   	cXml += '  </Borders>'+CENT
   	cXml += '  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
   	cXml += '   ss:Bold="1"/>'+CENT
  	cXml += '  <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
  	cXml += ' </Style>'+CENT
   	cXml += ' <Style ss:ID="s95">'+CENT
   	cXml += '  <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>'+CENT
   	cXml += '  <Borders>'+CENT
  	cXml += '   <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
  	cXml += '   <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
   	cXml += '   <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
   	cXml += '   <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
   	cXml += '  </Borders>'+CENT
  	cXml += '  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
  	cXml += '   ss:Bold="1"/>'+CENT
   	cXml += '  <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
   	cXml += ' </Style>'+CENT
   	cXml += '</Styles>'+CENT
	cXml += ' <Worksheet ss:Name="Parametros">'+CENT
	cXml += '  <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="13" x:FullColumns="1"'+CENT
 	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
 	cXml += '   <Column ss:Width="111"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="152.25"/>'+CENT
 	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 	cXml += '    <Cell ss:StyleID="s62"><Data ss:Type="String">FILTROS:</Data></Cell>'+CENT
  	cXml += '   </Row>'+CENT
	CTH->(DBSetOrder(1))
	CTH->(DBSeeK(xFilial("CTH")+MV_PAR01))
  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">NAVIO</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">'+CTH->CTH_DESC01+'</Data></Cell>'+CENT
 	cXml += '   </Row>
	SZE->(DbSetOrder(3))
	SZE->(DbSeek(xFilial("SZE")+SubStr(MV_PAR02,1,2)))
  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">TERMINAL</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">'+SZE->ZE_NOME+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">CONTRATO</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">'+Alltrim(MV_PAR03)+if(!Empty(MV_PAR04),"-"+Alltrim(MV_PAR04),"")+'</Data></Cell>'+CENT
  	cXml += '   </Row>'+CENT
	SY9->(DbSetOrder(1))
	SY9->(DbSeek(xFilial("SY9")+MV_PAR05))
 	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">PORTO</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s64"><Data ss:Type="String">'+SY9->Y9_DESCR+'</Data></Cell>'+CENT
  	cXml += '   </Row>'+CENT
  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">DT. NF EXPORT. DE</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+DtoC(MV_PAR06)+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
 	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">DT. NF EXPORT. ATE</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+DtoC(MV_PAR07)+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">DT. EMBARQUE DE</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+DtoC(MV_PAR08)+'</Data></Cell>'+CENT
 	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">DT. EMBARQUE ATE</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+DtoC(MV_PAR09)+'</Data></Cell>'+CENT
  	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">RE</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+MV_PAR10+'</Data></Cell>'+CENT
  	cXml += '   </Row>'+CENT
 	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
  	cXml += '    <Cell ss:StyleID="s63"><Data ss:Type="String">INVOICE</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s65"><Data ss:Type="String">'+MV_PAR11+'</Data></Cell>'+CENT
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
 	cXml += '     <ActiveRow>5</ActiveRow>'+CENT
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
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="36.75"/>'+CENT
  	cXml += '   <Column ss:Width="184.5"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="143.25"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="130.5"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="174"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="94.5"/>'+CENT
  	cXml += '   <Column ss:Width="91.5"/>'+CENT
 	cXml += '   <Column ss:Width="40.5"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="165.75"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="60"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="44.25"/>'+CENT
  	cXml += '   <Column ss:Width="53.25"/>'+CENT
	cXml += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="63"/>'+CENT
	cXml += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="60.75"/>'+CENT
 	cXml += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="72"/>'+CENT
 	cXml += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="63.75"/>'+CENT
 	cXml += '   <Column ss:Width="55.5"/>'+CENT
 	cXml += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="78.75"/>'+CENT
 	cXml += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="75"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="58.5"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="78.75"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="77.25"/>'+CENT
 	cXml += '   <Column ss:StyleID="s67" ss:Width="90.75"/>'+CENT
 	cXml += '   <Column ss:StyleID="s67" ss:AutoFitWidth="0" ss:Width="70.5"/>'+CENT
  	cXml += '   <Column ss:StyleID="s67" ss:AutoFitWidth="0" ss:Width="88.5"/>'+CENT
  	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="74.25"/>'+CENT
  	cXml += '   <Column ss:Width="150"/>'+CENT
 	cXml += '   <Column ss:Width="66"/>'+CENT
 	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="86.25"/>'+CENT
  	cXml += '   <Column ss:Width="95.25"/>'+CENT
  	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="21">'+CENT
  	cXml += '    <Cell ss:StyleID="s88"><Data ss:Type="String">RESUMO DO NAVIO - 10/07/2015</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
 	cXml += '    <Cell ss:StyleID="s89"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s92"/>'+CENT
  	cXml += '    <Cell ss:StyleID="s90"/>'+CENT
  	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="27">'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">SAFRA</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">NAVIO</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">PORTO DE EMBARQUE</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">DESTINO</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">TERMINAL</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">REF</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">BOOKING</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">PV</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">FORNECEDOR</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">CONTRATO</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">DP</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">ACUCAR</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">ENTREGA INICIO</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">ENTREGA FINAL</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">EMBARQUE INICIO</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">EMBARQUE FINAL</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">INCOTERM</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">VOLUME EMBARCADO</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">VOLUME EM SACAS</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">POL</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">FOB DISCOUNT</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">FINAL PRICE - CTR. COMPRA</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">PAYMENT TYPE</Data></Cell>'+CENT
  	cXml += '    <Cell ss:StyleID="s76"><Data ss:Type="String">NF DE EXPORTACAO</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s77"><Data ss:Type="String">NF DE EXPORTACAO - DATA</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">INVOICE</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s75"><Data ss:Type="String">B/L </Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s93"><Data ss:Type="String">DATA DO B/L</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s95"><Data ss:Type="String">RE</Data></Cell>'+CENT
 	cXml += '    <Cell ss:StyleID="s94"><Data ss:Type="String">SD</Data></Cell>'+CENT
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
		
		Stor Space(1) to cZ3_DTFIM,cZ3_DTINEM,cZ3_DTFIEM,cEES_DTNF,cEEC_DTEMBA,cZ3_DTINIC
		 	
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

		If !Empty((cAliasQry)->EES_DTNF)
			cEES_DTNF	:= SubStr((cAliasQry)->EES_DTNF,1,4)+"-"+SubStr((cAliasQry)->EES_DTNF,5,2)+"-"+SubStr((cAliasQry)->EES_DTNF,7,2)+"T00:00:00.000"
		EndIf

		If !Empty((cAliasQry)->EEC_DTEMBA)
			cEEC_DTEMBA	:= SubStr((cAliasQry)->EEC_DTEMBA,1,4)+"-"+SubStr((cAliasQry)->EEC_DTEMBA,5,2)+"-"+SubStr((cAliasQry)->EEC_DTEMBA,7,2)+"T00:00:00.000"
        EndIf
        
	  	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	  	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->Z3_SAFRA+'</Data></Cell>'+CENT
	  	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->EEC_EMBARC+'</Data></Cell>'+CENT
	 	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->EEC_ORIGEM+'</Data></Cell>'+CENT
	 	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->EEC_DEST+'</Data></Cell>'+CENT
	  	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->ZE_NOME+'</Data></Cell>'+CENT
	  	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->EES_PREEMB+'</Data></Cell>'+CENT
	  	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->CTH_BOOKIN+'</Data></Cell>'+CENT
	 	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->EES_PEDIDO+'</Data></Cell>'+CENT
	 	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->A2_NREDUZ+'</Data></Cell>'+CENT
	  	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->Z3_CONTRA+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s78"><Data ss:Type="String">'+(cAliasQry)->Z3_PERIODO+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s66"><Data ss:Type="String">'+(cAliasQry)->TIPO+'</Data></Cell>'+CENT
	
	    If !Empty(cZ3_DTINIC)
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cZ3_DTINIC+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
	
	    If !Empty(cZ3_DTFIM)
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cZ3_DTFIM+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
	
	    If !Empty(cZ3_DTINEM)
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cZ3_DTINEM+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
	
	    If !Empty(cZ3_DTFIEM)
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cZ3_DTFIEM+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
	
	  	cXml += '    <Cell ss:StyleID="s80"><Data ss:Type="String">'+(cAliasQry)->EEC_INCOTE+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+Transform((cAliasQry)->D2_QTSEGUM,"@E 999,999,999.999")+'</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+Transform((cAliasQry)->D2_QUANT,"@E 999,999,999.999")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+Transform((cAliasQry)->EE8_XPOLDP,"@E 99,999.99")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+Transform((cAliasQry)->EEC_VLFOB,"@E 9,999,999.99")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s81"><Data ss:Type="String">'+Transform((cAliasQry)->Z6_VLFINAL,"@E 99,999.99")+'</Data></Cell>'+CENT
	 	cXml += '    <Cell ss:StyleID="s82"><Data ss:Type="String">'+cPayTer+'</Data></Cell>'+CENT
	 	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->EES_NRNF+'</Data></Cell>'+CENT
	  	cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cEES_DTNF+'</Data></Cell>'+CENT
	  	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->EXR_NRINVO+'</Data></Cell>'+CENT
	  	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->EEC_NRCONH+'</Data></Cell>'+CENT
	    If !Empty(cEEC_DTEMBA)
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="DateTime">'+cEEC_DTEMBA+'</Data></Cell>'+CENT
		Else
			cXml += '    <Cell ss:StyleID="s79"><Data ss:Type="String"></Data></Cell>'+CENT
		EndIf
	 	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->EE9_RE+'</Data></Cell>'+CENT
	  	cXml += '    <Cell><Data ss:Type="String">'+(cAliasQry)->EE9_NRSD+'</Data></Cell>'+CENT
	  	cXml += '   </Row>'+CENT

		(cAliasQry)->(DbSkip())

		If	ncountq == 380 .or. Eof() 
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
 	cXml += '    <HorizontalResolution>600</HorizontalResolution>'+CENT
 	cXml += '    <VerticalResolution>600</VerticalResolution>'+CENT
 	cXml += '   </Print>'+CENT
 	cXml += '   <Zoom>90</Zoom>'+CENT
 	cXml += '   <Selected/>'+CENT
  	cXml += '   <DoNotDisplayGridlines/>'+CENT
  	cXml += '   <Panes>'+CENT
  	cXml += '    <Pane>'+CENT
 	cXml += '     <Number>3</Number>'+CENT
 	cXml += '     <ActiveRow>2</ActiveRow>'+CENT
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
AADD(aSx1,{"EDFR018" , "01" , "Navio Ex.: MV2015299  ?" , "Navio MV2015299    ?" , "Navio MV2015299    ?" , "mv_ch1" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CTH"   , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR018" , "02" , "Terminal Ex.: 04      ?" , "Terminal 04        ?" , "Terminal 04        ?" , "mv_ch2" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZE_2" , "" , "", "", ""           , ""})
AADD(aSx1,{"EDFR018" , "03" , "Contrato Ex.: P12345  ?" , "Contrato P12345    ?" , "Contrato P12345    ?" , "mv_ch3" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZ3"   , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR018" , "04" , "DP (opcional)         ?" , "DP (opcinal)       ?" , "DP (opcional)      ?" , "mv_ch4" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" 			 , ""})
AADD(aSx1,{"EDFR018" , "05" , "Porto Ex.: 41173      ?" , "Porto              ?" , "Porto              ?" , "mv_ch5" , "C" , 05 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SY9"   , "" , "", "", ""           , ""})
AADD(aSx1,{"EDFR018" , "06" , "Dt. NF Export. De     ?" , "Dt. NF Export. De  ?" , "Dt. NF Export. De  ?" , "mv_ch6" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par06" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR018" , "07" , "Dt. NF Export. Ate    ?" , "Dt. NF Export. Ate ?" , "Dt. NF Export. Ate ?" , "mv_ch7" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par07" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR018" , "08" , "Dt. Embarque De       ?" , "Dt. Embarque De    ?" , "Dt. Embarque De    ?" , "mv_ch8" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par08" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR018" , "09" , "Dt. Embarque Ate      ?" , "Dt. Embarque Ate   ?" , "Dt. Embarque Ate   ?" , "mv_ch9" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par09" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR018" , "10" , "RE  Ex.: 151041966001 ?" , "RE  151041966001   ?" , "RE  151041966001   ?" , "mv_cha" , "C" , 12 , 0 , 0 , "G" , "" , "mv_par10" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "EE9_RE", "" , "", "", "" , ""})
AADD(aSx1,{"EDFR018" , "11" , "Invoice Ex.: 104/2013 ?" , "Invoice 104/2013   ?" , "Invoice 104/2013   ?" , "mv_chb" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par11" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "INVOIC", "" , "", "", "" , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR018   11")
	
	DbSeek("EDFR018")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR018"
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
