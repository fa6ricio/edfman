#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} edfr005
Atualização do relatório Payments By DP
@type function
@version 12.1.2310
@author Fernando Nicolau
@since 30/05/2025
/*/
User Function edfr005()

	Local cPerg      := "EDFR005"
	Private aComp    := {} As Array
	Private cCompt   := "" As Character
	Private dDataDe  := CtoD("  /  /  ") As Date
	Private dDataAte := CtoD("  /  /  ") As Date

	If Pergunte(cPerg, .T.)
		Processa({|| fProcessa()}, "Por favor aguarde!")
	EndIf

Return

/*/{Protheus.doc} fProcessa
Processa os dados da competência e gera o relatório
@type function
@version 12.1.2310
@author Fernando Nicolau
@since 07/04/2025
/*/
Static Function fProcessa()

	Local cQry       := "" As Character
	Local cArqXlsx   := "" As Character
	Local cPayTer  	 := ""
	Local cPPayter1	 := ""
	Local cPPayter2	 := ""
	Local cZ3_DTINIC := ""
	Local cZ3_DTFIM	 := ""
	Local cZ3_DTINEM := ""
	Local cZ3_DTFIEM := ""
	Local aExp := {} As Array
	Local cUsina 	 := ""
	Local cContra 	 := ""
	Local cContraDP  := ""
	Local nQTDTONPA	 := 0
	Local nPAGOPA	 := 0
	Local nQTDREM	 := 0
	Local nQTDREC	 := 0
	Local nQTDEM1X	 := 0
	Local lOculta1	 := .F.
	Local lOculta2	 := .F.
	Local lOculta3	 := .F.
	Local cDiaSemana := ""
	Local cCN9_XDTPG := ""
	Local nPos		 := 0
	Local nX         := 0
	Local lLocal	 := .F.

	Private cAlias     := GetNextAlias() As Character
	Private cAlias2    := GetNextAlias() As Character
	Private cAlias3    := GetNextAlias() As Character
	Private cAlias4    := GetNextAlias() As Character
	Private oPrintXlsx := Nil As Object
	Private oCellHoriz := FwXlsxCellAlignment():Horizontal() As Object
	Private oCellVerti := FwXlsxCellAlignment():Vertical() As Object
	Private nLinExcel  := 0 As Numeric

	//
	// Colunas necessárias para a montagem do relatório.
	// 
	// DOCUMENTOS IMPORTADOS E GRAVADOS SOBRE TABELA DE RETAGUARDA 
	cQry := " SELECT DISTINCT 'SZD' AS ORIGEM, Z3_CONTRA,Z3_PERIODO,Z3_DTINIC,Z3_DTFIM,Z3_DTINEM,Z3_DTFIEM,Z3_DTINIC,Z3_QUANT,Z3_SAFRA,Z3_CONDPG,Z3_QTDLOT,SZ3.A2_NREDUZ,SZD.ZD_LOCAL,SZ3.A2_CGC,SZ3.A2_XGRFOR,Z3_PAYTERM,Z3_FIXADO,Z3_NFIXADO, " + CRLF
	cQry += " 		 ISNULL(SZD.ZD_QTDREC,0) AS ZD_QTDREC,  " + CRLF
	cQry += " 		 ISNULL(SD2.D2_QTDDEV,0) AS D2_QTDDEV,  " + CRLF
	cQry += " 		 ISNULL(SZD.ZD_QTDMAET,0)  	AS ZD_QTDMAET, " + CRLF
	cQry += " 		 ISNULL(SZD.ZD_QTDNFRE,0)  	AS ZD_QTDNFRE, " + CRLF
	cQry += " 		 ISNULL(SZD.ZD_VLRNFRE,0)  	AS ZD_VLRNFRE, " + CRLF
	cQry += " 		 ISNULL(SZD.ZD_VLRMAE,0)   	AS ZD_VLRMAE,  " + CRLF
	cQry += "        ISNULL(SE2X.E2_QTDTONPA,0) AS E2_QTDTONPA," + CRLF
	cQry += "        ISNULL(SE2X.E2_PAGOPA,0) AS E2_PAGOPA,  " + CRLF
	cQry += "        ISNULL(SE2X.E2_PERCPG,0) AS E2_PERCPG,  " + CRLF
	cQry += "        ISNULL(SE2X.E2_REGSPG,0) AS E2_REGSPG,  " + CRLF
	cQry += "        SZ3.CN9_XDTPG	 AS CN9_XDTPG, " + CRLF
	cQry += "        SZ3.CN9_XDIASE	 AS CN9_XDIASE, " + CRLF
	cQry += "        SZ2.Z2_INCOTER  AS Z2_INCOTER," + CRLF
	cQry += "        SZ6.Z6_TOTFIX   AS Z6_TOTFIX, " + CRLF
	cQry += "  		 CASE WHEN Z3_QTDLOT = SZ6.Z6_TOTFIX THEN SZ3.Z6_VLFINAL ELSE 0 END AS Z6_VLFINAL, " + CRLF
	cQry += " 		 Z5_POLDP,SZ3.B1_GRUPO " + CRLF

	cQry += " FROM  " + CRLF
	//
	// Contratos e Períodos filtrados a partir dos parâmetros selecionados
	//
	cQry += " (SELECT DISTINCT Z3_CONTRA,Z3_PERIODO,Z3_DTINIC,Z3_DTINEM,Z3_DTFIEM,Z3_DTFIM,Z3_QUANT,Z3_SAFRA,Z3_CONDPG,Z3_QTDLOT,Z3_PAYTERM,A2_NREDUZ,A2_CGC,A2_XGRFOR,CN9_XDTPG,CN9_XDIASE,Z3_FIXADO,Z3_NFIXADO,B1_GRUPO, " + CRLF
	cQry += " (SELECT Z5_POLDP FROM "+RetSqlName("SZ5")+" WHERE Z3_CONTRA = Z5_CONTRA AND Z3_PERIODO  = Z5_PERDE AND D_E_L_E_T_ <> '*') AS Z5_POLDP, " + CRLF
	cQry += " (SELECT TOP 1 Z6_VLFINAL FROM "+RetSqlName("SZ6")+" WHERE Z3_CONTRA = Z6_CONTRA AND Z3_PERIODO  = Z6_PERDE AND Z6_TIPOPRE = '2' AND D_E_L_E_T_ <> '*') AS Z6_VLFINAL " + CRLF
	cQry += " FROM "+RetSqlName("SZ3")+" SZ3, "+RetSqlName("SA2")+" SA2, "+RetSqlName("CN9")+" CN9, "+RetSqlName("CNC")+" CNC, "+RetSqlName("SB1")+" SB1 " + CRLF
	cQry += " WHERE CNC_NUMERO  = Z3_CONTRA " + CRLF
	cQry += " AND CNC_CODIGO  = A2_COD " + CRLF	
	cQry += " AND CNC_LOJA    = A2_LOJA " + CRLF
	cQry += " AND Z3_CONTRA   = CN9_NUMERO " + CRLF
	cQry += " AND RTRIM(Z3_CONTRA)+'-'+RTRIM(Z3_PERIODO) = B1_COD " + CRLF
	//
	// Filtros do relatório
	//
	If !Empty(MV_PAR01)
		cQry += " AND A2_XGRFOR = '"+MV_PAR01+"'" + CRLF
	EndIf

	If !Empty(MV_PAR02)
		cQry += " AND A2_CGC = '"+MV_PAR02+"'" + CRLF
	EndIf

	If !Empty(MV_PAR03)
		cQry += " AND Z3_SAFRA       = '"+MV_PAR03+"'" + CRLF
	EndIf

	If !Empty(MV_PAR05)
		cQry += " AND Z3_CONTRA     = '"+MV_PAR05+"'" + CRLF
	EndIf

	If !Empty(MV_PAR06)
		cQry += " AND Z3_PERIODO    = '"+MV_PAR06+"'" + CRLF
	EndIf

	If !Empty(MV_PAR07)
		cQry += " AND Z3_PAYTERM     = '"+MV_PAR07+"'" + CRLF
	EndIf

	cQry += " AND SB1.D_E_L_E_T_ <> '*' " + CRLF
	cQry += " AND CN9.D_E_L_E_T_ <> '*' " + CRLF
	cQry += " AND SZ3.D_E_L_E_T_ <> '*' " + CRLF
	cQry += " AND SA2.D_E_L_E_T_ <> '*' " + CRLF
	cQry += " AND CNC.D_E_L_E_T_ <>  '*'
	// 10/11/15 - Luis Felipe - Inicio
	cQry += " AND EXISTS (SELECT ZD_CONTRA,ZD_PERIODO,A2_CGC FROM "+RetSqlName("SZD")+" WHERE ZD_CONTRA = Z3_CONTRA AND ZD_PERIODO = Z3_PERIODO AND SA2.A2_CGC = ZD_CNPJUSI AND D_E_L_E_T_ = '') ) " + CRLF
	// 10/11/15 - Luis Felipe - Fim

	cQry += " AS SZ3 " + CRLF
	//
	// Quantidade recebida sobre NF´s Remessa (Entregue) - Tabela de Retaguarda (SZD)
	// ZD_STATUS => Desconsiderados EX - Excluido
	//								AT - Aguardando Template
	//								PL - Pedido Liberado
	//              Considerados	BP - Baixa Parcial
	//								BX - Baixa Total
	//								QT - Quantidade Acima da esperada
	//
							

	cQry += " LEFT JOIN " + CRLF
	cQry += " (SELECT ZD_CONTRA,ZD_PERIODO,ZD_CNPJUSI,ZD_LOCAL, " + CRLF

	// 14/07/15 - Luis Felipe - Transferido tratamento de filtro de datas da query principal para esta - Inicio
	If !Empty(MV_PAR04)
		cQry += " (SELECT SUM(ISNULL(CASE WHEN ZD_UM IN ('TM','TO') THEN ZD_QTDREC  ELSE ZD_QTDREC * B1_CONV END, 0))  FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_CNPJUSI = SZD.ZD_CNPJUSI AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD_DTETERM <= '"+DtoS(MV_PAR04)+"' AND ZD_DTTERMI <= '"+DtoS(MV_PAR04)+"' AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND B1.D_E_L_E_T_ = '' ) AS ZD_QTDREC, " + CRLF
		cQry += " (SELECT SUM(ISNULL(CASE WHEN ZD_UM IN ('TM','TO') THEN ZD_QTDMAE  ELSE ZD_QTDMAE * B1_CONV END, 0))  FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_CNPJUSI = SZD.ZD_CNPJUSI AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD_DTETERM <= '"+DtoS(MV_PAR04)+"' AND ZD_DTTERMI <= '"+DtoS(MV_PAR04)+"' AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND B1.D_E_L_E_T_ = '' AND ZD.R_E_C_N_O_ = (SELECT Max(R_E_C_N_O_) FROM "+RetSqlName("SZD")+" WHERE ZD_NFMAE   = ZD.ZD_NFMAE   AND ZD_CNPJUSI = ZD.ZD_CNPJUSI AND D_E_L_E_T_ = '')) AS ZD_QTDMAET, " + CRLF
		cQry += " (SELECT SUM(ZD_VLRMAE)                                                                       FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_CNPJUSI = SZD.ZD_CNPJUSI AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD_DTETERM <= '"+DtoS(MV_PAR04)+"' AND ZD_DTTERMI <= '"+DtoS(MV_PAR04)+"' AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND B1.D_E_L_E_T_ = '' AND ZD.R_E_C_N_O_ = (SELECT Max(R_E_C_N_O_) FROM "+RetSqlName("SZD")+" WHERE ZD_NFMAE   = ZD.ZD_NFMAE   AND ZD_CNPJUSI = ZD.ZD_CNPJUSI AND D_E_L_E_T_ = '')) AS ZD_VLRMAE, " + CRLF
		cQry += " (SELECT SUM(ISNULL(CASE WHEN ZD_UM IN ('TM','TO') THEN ZD_QTDNFRE ELSE ZD_QTDNFRE * B1_CONV END, 0)) FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_CNPJUSI = SZD.ZD_CNPJUSI AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD_DTETERM <= '"+DtoS(MV_PAR04)+"' AND ZD_DTTERMI <= '"+DtoS(MV_PAR04)+"' AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND B1.D_E_L_E_T_ = '' AND ZD.R_E_C_N_O_ = (SELECT Max(R_E_C_N_O_) FROM "+RetSqlName("SZD")+" WHERE ZD_NFREMES = ZD.ZD_NFREMES AND ZD_CNPJUSI = ZD.ZD_CNPJUSI AND D_E_L_E_T_ = '')) AS ZD_QTDNFRE, " + CRLF
		cQry += " (SELECT SUM(ZD_VLRNFRE)                                                                      FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_CNPJUSI = SZD.ZD_CNPJUSI AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD_DTETERM <= '"+DtoS(MV_PAR04)+"' AND ZD_DTTERMI <= '"+DtoS(MV_PAR04)+"' AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND B1.D_E_L_E_T_ = '' AND ZD.R_E_C_N_O_ = (SELECT Max(R_E_C_N_O_) FROM "+RetSqlName("SZD")+" WHERE ZD_NFREMES = ZD.ZD_NFREMES AND ZD_CNPJUSI = ZD.ZD_CNPJUSI AND D_E_L_E_T_ = '')) AS ZD_VLRNFRE " + CRLF
	// 14/07/15 - Luis Felipe - Transferido tratamento de filtro de datas da query principal para esta - Fim
	Else
		cQry += " (SELECT SUM(ISNULL(CASE WHEN ZD_UM IN ('TM','TO') THEN ZD_QTDREC  ELSE ZD_QTDREC * B1_CONV END, 0))  FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_CNPJUSI = SZD.ZD_CNPJUSI AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND B1.D_E_L_E_T_ = '' ) AS ZD_QTDREC, " + CRLF
		cQry += " (SELECT SUM(ISNULL(CASE WHEN ZD_UM IN ('TM','TO') THEN ZD_QTDMAE  ELSE ZD_QTDMAE * B1_CONV END, 0))  FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_CNPJUSI = SZD.ZD_CNPJUSI AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND B1.D_E_L_E_T_ = '' AND ZD.R_E_C_N_O_ = (SELECT Max(R_E_C_N_O_) FROM "+RetSqlName("SZD")+" WHERE ZD_NFMAE   = ZD.ZD_NFMAE   AND ZD_CNPJUSI = ZD.ZD_CNPJUSI AND D_E_L_E_T_ = '')) AS ZD_QTDMAET, " + CRLF
		cQry += " (SELECT SUM(ZD_VLRMAE)                                                                       FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_CNPJUSI = SZD.ZD_CNPJUSI AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND B1.D_E_L_E_T_ = '' AND ZD.R_E_C_N_O_ = (SELECT Max(R_E_C_N_O_) FROM "+RetSqlName("SZD")+" WHERE ZD_NFMAE   = ZD.ZD_NFMAE   AND ZD_CNPJUSI = ZD.ZD_CNPJUSI AND D_E_L_E_T_ = '')) AS ZD_VLRMAE, " + CRLF
		cQry += " (SELECT SUM(ISNULL(CASE WHEN ZD_UM IN ('TM','TO') THEN ZD_QTDNFRE ELSE ZD_QTDNFRE * B1_CONV END, 0)) FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_CNPJUSI = SZD.ZD_CNPJUSI AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND B1.D_E_L_E_T_ = '' AND ZD.R_E_C_N_O_ = (SELECT Max(R_E_C_N_O_) FROM "+RetSqlName("SZD")+" WHERE ZD_NFREMES = ZD.ZD_NFREMES AND ZD_CNPJUSI = ZD.ZD_CNPJUSI AND D_E_L_E_T_ = '')) AS ZD_QTDNFRE, " + CRLF
		cQry += " (SELECT SUM(ZD_VLRNFRE)                                                                      FROM "+RetSqlName("SZD")+" ZD, "+RetSqlName("SB1")+" B1 WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = Rtrim(B1_COD) AND ZD.ZD_CONTRA = SZD.ZD_CONTRA AND ZD.ZD_PERIODO = SZD.ZD_PERIODO AND ZD.ZD_CNPJUSI = SZD.ZD_CNPJUSI AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND ZD.ZD_STATUS IN ('BP','BX','QT','') AND ZD.D_E_L_E_T_ = '' AND ZD.ZD_LOCAL = SZD.ZD_LOCAL AND B1.D_E_L_E_T_ = '' AND ZD.R_E_C_N_O_ = (SELECT Max(R_E_C_N_O_) FROM "+RetSqlName("SZD")+" WHERE ZD_NFREMES = ZD.ZD_NFREMES AND ZD_CNPJUSI = ZD.ZD_CNPJUSI AND D_E_L_E_T_ = '')) AS ZD_VLRNFRE " + CRLF
	EndIf
	cQry += " FROM "+RetSqlName("SZD")+" SZD " + CRLF
	cQry += " WHERE SZD.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND ZD_NOMETER  <> '' " + CRLF
	cQry += " GROUP BY ZD_CONTRA,ZD_PERIODO,ZD_CNPJUSI,ZD_LOCAL) " + CRLF
	cQry += " AS SZD " + CRLF
	cQry += " ON Z3_CONTRA+Z3_PERIODO+SZ3.A2_CGC = ZD_CONTRA+ZD_PERIODO+ZD_CNPJUSI " + CRLF
	//
	// Termos de Entrega - Condições Comerciais (SZ2)
	//
	cQry += " LEFT JOIN " + CRLF
	cQry += " (SELECT DISTINCT Z2_CONTRA ,Z2_CODPRO, Z2_INCOTER " + CRLF
	cQry += " FROM "+RetSqlName("SZ2")+" SZ2 " + CRLF
	cQry += " WHERE SZ2.D_E_L_E_T_ <>  '*' )" + CRLF
	cQry += " AS SZ2 " + CRLF
	cQry += " ON RTRIM(SZ3.Z3_CONTRA)+'-'+RTRIM(SZ3.Z3_PERIODO) = Z2_CODPRO AND SZ3.Z3_CONTRA = Z2_CONTRA " + CRLF
	//
	// Total de lotes Precificados - Itens da Precificação (SZ6)
	//
	cQry += " LEFT JOIN " + CRLF
	cQry += " (SELECT Z6_CONTRA ,Z6_PERDE, SUM(ISNULL(CASE WHEN Z6_TIPOPRE = '2' THEN Z6_LOTE ELSE 0 END, 0)) Z6_TOTFIX " + CRLF
	cQry += " FROM "+RetSqlName("SZ6")+" SZ6 " + CRLF
	cQry += " WHERE SZ6.D_E_L_E_T_ <>  '*' " + CRLF
	If !Empty(MV_PAR04)  
		cQry += "  AND Z6_DATA <= '"+DtoS(MV_PAR04)+"'" + CRLF	
	EndIf
	cQry += " GROUP BY Z6_CONTRA,Z6_PERDE) " + CRLF
	cQry += " AS SZ6 " + CRLF
	cQry += " ON Z3_CONTRA+Z3_PERIODO = Z6_CONTRA+Z6_PERDE " + CRLF
	//
	// Adiantamentos de Pagtos as Usinas - Titulos a Pagar (SE2) - E2_XCONTRA
	//                                               1
	cQry += " LEFT JOIN " + CRLF
	cQry += " (SELECT A2_CGC, E2_XCONTRA, E2_XLOCAL, SUM(E2_XPERPGT) AS E2_PERCPG, COUNT(E2_XCONTRA) E2_REGSPG, SUM(E2_VLFINAL) AS E2_PAGOPA, " + CRLF
	cQry += " SUM((CASE WHEN E2_XSUBTIP NOT IN ('6','7') THEN E2_QTDTON ELSE 0 END)) AS E2_QTDTONPA " + CRLF
	cQry += " FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2 " + CRLF
	cQry += " WHERE SE2.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND SA2.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND A2_COD = E2_FORNECE " + CRLF
	cQry += " AND A2_LOJA = E2_LOJA " + CRLF
	If !Empty(MV_PAR02)
		cQry += " AND A2_CGC = '"+MV_PAR02+"'" + CRLF
	EndIf
	If !Empty(MV_PAR04)  
		cQry += "  AND E2_VENCREA <= '"+DtoS(MV_PAR04)+"'" + CRLF	
	EndIf
	cQry += " GROUP BY E2_XCONTRA,E2_XLOCAL,A2_CGC) " + CRLF
	cQry += " AS SE2X " + CRLF
	cQry += " ON RTRIM(SZD.ZD_CONTRA)+'-'+RTRIM(SZD.ZD_PERIODO) = RTRIM(SE2X.E2_XCONTRA) AND SZD.ZD_LOCAL = SE2X.E2_XLOCAL AND SZ3.A2_CGC = SE2X.A2_CGC " + CRLF
	//
	// Devoluções
	//
	cQry += " LEFT JOIN " + CRLF
	cQry += " (SELECT D2_COD,D2_LOCAL,A2_CGC, " + CRLF
	cQry += " SUM(ISNULL(CASE WHEN B1_UM IN ('TM','TON') THEN D2_QUANT ELSE D2_QUANT * B1_CONV END, 0)) AS D2_QTDDEV " + CRLF
	cQry += " FROM "+RetSqlName("SD2")+" SD2,"+RetSqlName("SB1")+" SB1, "+RetSqlName("SA2")+" SA2 " + CRLF
	cQry += " WHERE SD2.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND SB1.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND SA2.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND D2_COD = B1_COD " + CRLF
	cQry += " AND D2_TIPO = 'D' " + CRLF
	cQry += " AND D2_TES NOT IN ('506','508') " + CRLF  // 16/06/15 - Luis Felipe Nascimento 
	cQry += " AND D2_CLIENTE = A2_COD " + CRLF
	cQry += " AND D2_LOJA = A2_LOJA " + CRLF
	If !Empty(MV_PAR04)  
		cQry += "  AND D2_EMISSAO <= '"+DtoS(MV_PAR04)+"'" + CRLF	
	EndIf
	cQry += " GROUP BY D2_COD,D2_LOCAL,A2_CGC) " + CRLF
	cQry += " AS SD2 " + CRLF
	cQry += " ON RTRIM(SZ3.Z3_CONTRA)+'-'+RTRIM(SZ3.Z3_PERIODO) = SD2.D2_COD AND SZD.ZD_LOCAL = SD2.D2_LOCAL AND SZ3.A2_CGC = SD2.A2_CGC" + CRLF

	// 23/10/14 - Luís Felipe Nascimento - Inicio

	cQry += " UNION ALL " + CRLF

	// Contratos pagos sobre terminais diferentes dos de origem da enrada do açucar
	cQry += " SELECT DISTINCT 'SE2' AS ORIGEM, SZ3.Z3_CONTRA, SZ3.Z3_PERIODO, SZ3.Z3_DTINIC, SZ3.Z3_DTFIM, SZ3.Z3_DTINEM, SZ3.Z3_DTFIEM, SZ3.Z3_DTINIC, SZ3.Z3_QUANT, SZ3.Z3_SAFRA, SZ3.Z3_CONDPG, SZ3.Z3_QTDLOT, SZ3.A2_NREDUZ" + CRLF
	cQry += " ,SZE.ZE_LOCAL AS ZD_LOCAL, SZ3.A2_CGC, SZ3.A2_XGRFOR, SZ3.Z3_PAYTERM, SZ3.Z3_FIXADO, SZ3.Z3_NFIXADO" + CRLF
	cQry += " ,0 AS ZD_QTDREC" + CRLF 
	cQry += " ,0 AS D2_QTDDEV" + CRLF 
	cQry += " ,0 AS ZD_QTDMAET" + CRLF 
	cQry += " ,0 AS ZD_QTDNFRE" + CRLF 
	cQry += " ,0 AS ZD_VLRNFRE" + CRLF 
	cQry += " ,0 AS ZD_VLRMAE" + CRLF 
	cQry += " ,E2_QTDTONPA" + CRLF 
	cQry += " ,E2_PAGOPA" + CRLF 
	cQry += " ,E2_PERCPG" + CRLF 
	cQry += " ,E2_REGSPG" + CRLF
	cQry += " ,SZ3.CN9_XDTPG  AS CN9_XDTPG" + CRLF
	cQry += " ,SZ3.CN9_XDIASE AS CN9_XDIASE" + CRLF
	cQry += " ,' ' AS Z2_INCOTER" + CRLF
	cQry += " ,0  AS Z6_TOTFIX" + CRLF
	cQry += " ,SZ3.Z6_VLFINAL" + CRLF
	cQry += " ,SZ3.Z5_POLDP" + CRLF
	cQry += " ,SE2.B1_GRUPO" + CRLF
	cQry += " FROM " + CRLF
	cQry += " (SELECT E2_XCONTRA, E2_XLOCAL,SUM(E2_XPERPGT) AS E2_PERCPG, COUNT(E2_XCONTRA) E2_REGSPG, SUM(E2_VLFINAL) AS E2_PAGOPA,SUM((CASE WHEN E2_XSUBTIP NOT IN ('6','7') THEN E2_QTDTON ELSE 0 END)) AS E2_QTDTONPA,A2_CGC,B1_GRUPO" + CRLF
	cQry += " FROM "+RetSqlName("SE2")+" SE2 ,"+RetSqlName("SA2")+" SA2, "+RetSqlName("SB1")+" SB1 " + CRLF
	cQry += " WHERE A2_COD = E2_FORNECE" + CRLF
	cQry += " AND A2_LOJA = E2_LOJA" + CRLF
	//cQry += " AND E2_CONTRA = ''" + CRLF // 18/04/17 - Luis Felipe
	cQry += " AND E2_XCONTRA <> ''" + CRLF
	cQry += " AND E2_XCONTRA = B1_COD" + CRLF

	If !Empty(MV_PAR04)  
		cQry += "  AND E2_VENCREA <= '"+DtoS(MV_PAR04)+"'" + CRLF	
	EndIf

	If !Empty(MV_PAR05) .and. !Empty(MV_PAR06)
		cQry += " AND E2_XCONTRA = '"+Alltrim(MV_PAR05)+"-"+Alltrim(MV_PAR06)+"'" + CRLF
	EndIf

	cQry += " AND SB1.D_E_L_E_T_ <> '*' " + CRLF
	cQry += " AND SE2.D_E_L_E_T_ <> '*'" + CRLF
	cQry += " AND SA2.D_E_L_E_T_ <> '*'" + CRLF
	cQry += " AND NOT EXISTS (SELECT ZD_CONTRA,ZD_PERIODO,ZD_LOCAL,A2_CGC FROM "+RetSqlName("SZD")+" WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = RTRIM(SE2.E2_XCONTRA) AND ZD_LOCAL = SE2.E2_XLOCAL AND SA2.A2_CGC = ZD_CNPJUSI AND D_E_L_E_T_ = '')" + CRLF
	cQry += " AND NOT EXISTS (SELECT D1_COD FROM "+RetSqlName("SD1")+" WHERE RTRIM(D1_COD) = RTRIM(SE2.E2_XCONTRA) AND D1_LOCAL = SE2.E2_XLOCAL AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND D_E_L_E_T_ = '')" + CRLF // 16/12/16 - Luis Felipe
	cQry += " GROUP BY E2_XCONTRA,E2_XLOCAL,A2_CGC,B1_GRUPO)" + CRLF
	cQry += " AS SE2" + CRLF
	cQry += " LEFT JOIN" + CRLF
	cQry += " (SELECT DISTINCT Z3_CONTRA,Z3_PERIODO,Z3_DTINIC,Z3_DTINEM,Z3_DTFIEM,Z3_DTFIM,Z3_QUANT,Z3_SAFRA,Z3_CONDPG,Z3_QTDLOT,Z3_PAYTERM,A2_NREDUZ,A2_CGC,A2_XGRFOR,CN9_XDTPG,CN9_XDIASE,Z3_FIXADO,Z3_NFIXADO," + CRLF
	cQry += "  (SELECT Z5_POLDP FROM "+RetSqlName("SZ5")+" WHERE Z3_CONTRA = Z5_CONTRA AND Z3_PERIODO  = Z5_PERDE AND D_E_L_E_T_ <> '*') AS Z5_POLDP," + CRLF
	cQry += "  (SELECT TOP 1 Z6_VLFINAL FROM "+RetSqlName("SZ6")+" WHERE Z3_CONTRA = Z6_CONTRA AND Z3_PERIODO  = Z6_PERDE AND Z6_TIPOPRE = '2' AND D_E_L_E_T_ <> '*') AS Z6_VLFINAL" + CRLF
	cQry += " FROM "+RetSqlName("SZ3")+" SZ3 ,"+RetSqlName("SA2")+" SA2, "+RetSqlName("CN9")+" CN9, "+RetSqlName("CNC")+" CNC " + CRLF
	cQry += "  WHERE CNC_NUMERO  = Z3_CONTRA " + CRLF
	cQry += "  AND CNC_CODIGO  = A2_COD " + CRLF
	cQry += "  AND CNC_LOJA    = A2_LOJA " + CRLF
	cQry += "  AND Z3_CONTRA   = CN9_NUMERO " + CRLF
	cQry += "  AND Z3_CONTRA   <> '' " + CRLF
	//
	// Filtros do relatório
	//
	If !Empty(MV_PAR01)
		cQry += " AND A2_XGRFOR = '"+MV_PAR01+"'" + CRLF
	EndIf

	If !Empty(MV_PAR02)
		cQry += " AND A2_CGC = '"+MV_PAR02+"'" + CRLF
	EndIf

	If !Empty(MV_PAR03)
		cQry += " AND Z3_SAFRA = '"+MV_PAR03+"'" + CRLF
	EndIf

	If !Empty(MV_PAR05)
		cQry += " AND Z3_CONTRA = '"+MV_PAR05+"'" + CRLF
	EndIf

	If !Empty(MV_PAR06)
		cQry += " AND Z3_PERIODO = '"+MV_PAR06+"'" + CRLF
	EndIf

	If !Empty(MV_PAR09)
		cQry += " AND Z3_PAYTERM = '"+MV_PAR09+"'" + CRLF
	EndIf

	cQry += "  AND CN9.D_E_L_E_T_ <> '*' " + CRLF
	cQry += "  AND SZ3.D_E_L_E_T_ <> '*' " + CRLF
	cQry += "  AND SA2.D_E_L_E_T_ <> '*' " + CRLF
	cQry += "  AND CNC.D_E_L_E_T_ <>  '*' ) " + CRLF
	cQry += "  AS SZ3 " + CRLF
	cQry += "  ON  RTRIM(Z3_CONTRA)+'-'+RTRIM(Z3_PERIODO) = SE2.E2_XCONTRA AND SZ3.A2_CGC = SE2.A2_CGC" + CRLF
	cQry += " LEFT JOIN" + CRLF
	cQry += " (SELECT ZE_LOCAL,ZE_NOME " + CRLF
	cQry += " FROM "+RetSqlName("SZE") + CRLF
	cQry += " WHERE D_E_L_E_T_ = '')" + CRLF
	cQry += " AS SZE" + CRLF
	cQry += " ON ZE_LOCAL = SE2.E2_XLOCAL" + CRLF

	// 23/10/14 - Luís Felipe Nascimento - FIM
	cQry += " WHERE Z3_CONTRA <> ''" + CRLF

	// 10/11/15 - Luis Felipe - Inicio
	cQry += " UNION ALL " + CRLF

	// -- CONTRATOS SEM MOVIMENTAÇÃO

	cQry += " SELECT DISTINCT 'SZ3' AS ORIGEM, Z3_CONTRA,Z3_PERIODO,Z3_DTINIC,Z3_DTFIM,Z3_DTINEM,Z3_DTFIEM,Z3_DTINIC,Z3_QUANT,Z3_SAFRA,Z3_CONDPG,Z3_QTDLOT,SZ3.A2_NREDUZ,'' AS ZD_LOCAL,SZ3.A2_CGC,SZ3.A2_XGRFOR,Z3_PAYTERM,Z3_FIXADO,Z3_NFIXADO, " + CRLF
	cQry += " 		 0 AS ZD_QTDREC," + CRLF
	cQry += " 		 0 AS D2_QTDDEV," + CRLF
	cQry += " 		 0 AS ZD_QTDMAET," + CRLF
	cQry += " 		 0 AS ZD_QTDNFRE," + CRLF
	cQry += " 		 0 AS ZD_VLRNFRE," + CRLF
	cQry += " 		 0 AS ZD_VLRMAE," + CRLF
	cQry += "        0 AS E2_QTDTONPA," + CRLF
	cQry += "        0 AS E2_PAGOPA," + CRLF 
	cQry += "        0 AS E2_PERCPG," + CRLF  
	cQry += "        0 AS E2_REGSPG," + CRLF
	cQry += "        SZ3.CN9_XDTPG	 AS CN9_XDTPG," + CRLF
	cQry += "        SZ3.CN9_XDIASE	 AS CN9_XDIASE," + CRLF
	cQry += "        SZ2.Z2_INCOTER  AS Z2_INCOTER," + CRLF
	cQry += "        SZ6.Z6_TOTFIX   AS Z6_TOTFIX, " + CRLF
	cQry += "  		 CASE WHEN Z3_QTDLOT = SZ6.Z6_TOTFIX THEN SZ3.Z6_VLFINAL ELSE 0 END AS Z6_VLFINAL, " + CRLF
	cQry += " 		 Z5_POLDP,SZ3.B1_GRUPO " + CRLF

	cQry += " FROM  " + CRLF
	//
	// Contratos e Períodos filtrados a partir dos parâmetros selecionados
	//
	cQry += " (SELECT DISTINCT Z3_CONTRA,Z3_PERIODO,Z3_DTINIC,Z3_DTINEM,Z3_DTFIEM,Z3_DTFIM,Z3_QUANT,Z3_SAFRA,Z3_CONDPG,Z3_QTDLOT,Z3_PAYTERM,A2_NREDUZ,A2_CGC,A2_XGRFOR,CN9_XDTPG,CN9_XDIASE,Z3_FIXADO,Z3_NFIXADO, B1_GRUPO," + CRLF
	cQry += " (SELECT Z5_POLDP FROM "+RetSqlName("SZ5")+" WHERE Z3_CONTRA = Z5_CONTRA AND Z3_PERIODO  = Z5_PERDE AND D_E_L_E_T_ <> '*') AS Z5_POLDP, " + CRLF
	cQry += " (SELECT TOP 1 Z6_VLFINAL FROM "+RetSqlName("SZ6")+" WHERE Z3_CONTRA = Z6_CONTRA AND Z3_PERIODO  = Z6_PERDE AND Z6_TIPOPRE = '2' AND D_E_L_E_T_ <> '*') AS Z6_VLFINAL " + CRLF
	cQry += " FROM "+RetSqlName("SZ3")+" SZ3, "+RetSqlName("SA2")+" SA2, "+RetSqlName("CN9")+" CN9, "+RetSqlName("CNC")+" CNC, "+RetSqlName("SB1")+" SB1 " + CRLF
	cQry += " WHERE CNC_NUMERO  = Z3_CONTRA " + CRLF
	cQry += " AND CNC_CODIGO  = A2_COD " + CRLF	
	cQry += " AND CNC_LOJA    = A2_LOJA " + CRLF
	cQry += " AND Z3_CONTRA   = CN9_NUMERO " + CRLF
	cQry += " AND B1_COD      = RTRIM(Z3_CONTRA)+'-'+RTRIM(Z3_PERIODO)" + CRLF
	//
	// Filtros do relatório
	//
	If !Empty(MV_PAR01)
		cQry += " AND A2_XGRFOR = '"+MV_PAR01+"'" + CRLF
	EndIf

	If !Empty(MV_PAR02)
		cQry += " AND A2_CGC = '"+MV_PAR02+"'" + CRLF
	EndIf

	If !Empty(MV_PAR03)
		cQry += " AND Z3_SAFRA       = '"+MV_PAR03+"'" + CRLF
	EndIf

	If !Empty(MV_PAR05)
		cQry += " AND Z3_CONTRA     = '"+MV_PAR05+"'" + CRLF
	EndIf

	If !Empty(MV_PAR06)
		cQry += " AND Z3_PERIODO    = '"+MV_PAR06+"'" + CRLF
	EndIf

	If !Empty(MV_PAR07)
		cQry += " AND Z3_PAYTERM     = '"+MV_PAR07+"'" + CRLF
	EndIf

	cQry += " AND SB1.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND CN9.D_E_L_E_T_ <> '*' " + CRLF
	cQry += " AND SZ3.D_E_L_E_T_ <> '*' " + CRLF
	cQry += " AND SA2.D_E_L_E_T_ <> '*' " + CRLF
	cQry += " AND CNC.D_E_L_E_T_ <>  '*'
	cQry += " AND NOT EXISTS (SELECT D1_COD FROM "+RetSqlName("SD1")+" WHERE RTRIM(D1_COD) = RTRIM(SZ3.Z3_CONTRA)+'-'+RTRIM(Z3_PERIODO) AND D_E_L_E_T_ = '')) " + CRLF
	cQry += " AS SZ3 " + CRLF
	//
	// Termos de Entrega - Condições Comerciais (SZ2)
	//
	cQry += " LEFT JOIN " + CRLF
	cQry += " (SELECT DISTINCT Z2_CONTRA ,Z2_CODPRO, Z2_INCOTER " + CRLF
	cQry += " FROM "+RetSqlName("SZ2")+" SZ2 " + CRLF
	cQry += " WHERE SZ2.D_E_L_E_T_ <>  '*' )" + CRLF
	cQry += " AS SZ2 " + CRLF
	cQry += " ON RTRIM(SZ3.Z3_CONTRA)+'-'+RTRIM(SZ3.Z3_PERIODO) = Z2_CODPRO AND SZ3.Z3_CONTRA = Z2_CONTRA " + CRLF
	//
	// Total de lotes Precificados - Itens da Precificação (SZ6)
	//
	cQry += " LEFT JOIN " + CRLF
	cQry += " (SELECT Z6_CONTRA ,Z6_PERDE, SUM(ISNULL(CASE WHEN Z6_TIPOPRE = '2' THEN Z6_LOTE ELSE 0 END, 0)) Z6_TOTFIX " + CRLF
	cQry += " FROM "+RetSqlName("SZ6")+" SZ6 " + CRLF
	cQry += " WHERE SZ6.D_E_L_E_T_ <>  '*' " + CRLF
	If !Empty(MV_PAR04)  
		cQry += "  AND Z6_DATA <= '"+DtoS(MV_PAR04)+"'" + CRLF	
	EndIf
	cQry += " GROUP BY Z6_CONTRA,Z6_PERDE) " + CRLF
	cQry += " AS SZ6 " + CRLF
	cQry += " ON Z3_CONTRA+Z3_PERIODO = Z6_CONTRA+Z6_PERDE " + CRLF

	cQry += " UNION ALL " + CRLF

	// ENTRADA MANUAL DE SACARIAS

	cQry += " SELECT DISTINCT 'SD1' AS ORIGEM, SZ3.Z3_CONTRA, SZ3.Z3_PERIODO, SZ3.Z3_DTINIC, SZ3.Z3_DTFIM, SZ3.Z3_DTINEM, SZ3.Z3_DTFIEM, SZ3.Z3_DTINIC, SZ3.Z3_QUANT, SZ3.Z3_SAFRA, SZ3.Z3_CONDPG, SZ3.Z3_QTDLOT, SZ3.A2_NREDUZ" + CRLF
	cQry += " ,SZE.ZE_LOCAL AS ZD_LOCAL, SZ3.A2_CGC, SZ3.A2_XGRFOR, SZ3.Z3_PAYTERM, SZ3.Z3_FIXADO, SZ3.Z3_NFIXADO" + CRLF
	cQry += " ,SD1.ZD_QTDREC AS ZD_QTDREC" + CRLF
	cQry += " ,0 AS D2_QTDDEV" + CRLF
	cQry += " ,0 AS ZD_QTDMAET" + CRLF
	cQry += " ,SD1.ZD_QTDREC AS ZD_QTDNFRE" + CRLF
	cQry += " ,0 AS ZD_VLRNFRE" + CRLF
	cQry += " ,0 AS ZD_VLRMAE" + CRLF
	cQry += " ,E2_QTDTONPA" + CRLF
	cQry += " ,E2_PAGOPA" + CRLF
	cQry += " ,E2_PERCPG" + CRLF
	cQry += " ,E2_REGSPG" + CRLF
	cQry += " ,SZ3.CN9_XDTPG  AS CN9_XDTPG" + CRLF
	cQry += " ,SZ3.CN9_XDIASE AS CN9_XDIASE" + CRLF
	cQry += " ,' ' AS Z2_INCOTER" + CRLF
	cQry += " ,0  AS Z6_TOTFIX" + CRLF
	cQry += " ,SZ3.Z6_VLFINAL" + CRLF
	cQry += " ,SZ3.Z5_POLDP" + CRLF
	cQry += " ,SD1.B1_GRUPO" + CRLF
	cQry += " FROM " + CRLF

	cQry += " (SELECT A2_CGC, D1_COD, D1_LOCAL, Z3_CTRDP, A2_XGRFOR, B1_GRUPO" + CRLF
	cQry += " ,(SELECT SUM(ISNULL(CASE WHEN D1_UM IN ('TM','TON') THEN D1_QUANT ELSE D1_QUANT * B1_CONV END, 0)) FROM "+RetSqlName("SD1")+" D1,"+RetSqlName("SB1")+" B1, "+RetSqlName("SA2")+" A2 WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND RTRIM(D1_COD) = Rtrim(B1_COD) AND SA2.A2_CGC = A2.A2_CGC AND SD1.D1_COD = D1.D1_COD AND SD1.D1_LOCAL = D1.D1_LOCAL AND A2.D_E_L_E_T_ = '' AND D1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' ) AS ZD_QTDREC" + CRLF
	cQry += " FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SA2")+" SA2, "+RetSqlName("SZ3")+" SZ3, "+RetSqlName("SB1")+" SB1 ,"+RetSqlName("SF4")+" SF4 " + CRLF
	cQry += " WHERE D1_FORNECE = A2_COD" + CRLF
	cQry += " AND D1_LOJA = A2_LOJA" + CRLF
	cQry += " AND D1_COD = Z3_CTRDP" + CRLF
	cQry += " AND D1_COD = B1_COD" + CRLF
	cQry += " AND D1_TES = F4_CODIGO" + CRLF
	cQry += " AND F4_ESTOQUE = 'S'" + CRLF

	If !Empty(MV_PAR01)
		cQry += " AND A2_XGRFOR = '"+MV_PAR01+"'" + CRLF
	EndIf

	If !Empty(MV_PAR02)
		cQry += " AND A2_CGC = '"+MV_PAR02+"'" + CRLF
	EndIf

	If !Empty(MV_PAR03)
		cQry += " AND Z3_SAFRA = '"+MV_PAR03+"'" + CRLF
	EndIf

	If !Empty(MV_PAR05)
		cQry += " AND Z3_CONTRA = '"+MV_PAR05+"'" + CRLF
	EndIf

	If !Empty(MV_PAR06)
		cQry += " AND Z3_PERIODO = '"+MV_PAR06+"'" + CRLF
	EndIf

	If !Empty(MV_PAR07)
		cQry += " AND Z3_PAYTERM = '"+MV_PAR07+"'" + CRLF
	EndIf

	cQry += " AND SB1.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND SA2.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND SD1.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND SZ3.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND SF4.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND NOT EXISTS (SELECT ZD_CONTRA,ZD_PERIODO,ZD_LOCAL,A2_CGC FROM "+RetSqlName("SZD")+" WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = RTRIM(SD1.D1_COD) AND ZD_LOCAL = SD1.D1_LOCAL AND SA2.A2_CGC = ZD_CNPJUSI AND D_E_L_E_T_ = '')
	cQry += " GROUP BY A2_CGC, Z3_CTRDP, D1_LOCAL, D1_COD, A2_XGRFOR, B1_GRUPO)" + CRLF
	cQry += " AS SD1" + CRLF

	cQry += " LEFT JOIN" + CRLF
	cQry += " (SELECT DISTINCT Z3_CONTRA,Z3_PERIODO,Z3_DTINIC,Z3_DTINEM,Z3_DTFIEM,Z3_DTFIM,Z3_QUANT,Z3_SAFRA,Z3_CONDPG,Z3_QTDLOT,Z3_PAYTERM,A2_NREDUZ,A2_CGC,A2_XGRFOR,CN9_XDTPG,CN9_XDIASE,Z3_FIXADO,Z3_NFIXADO," + CRLF
	cQry += " (SELECT Z5_POLDP FROM "+RetSqlName("SZ5")+" WHERE Z3_CONTRA = Z5_CONTRA AND Z3_PERIODO  = Z5_PERDE AND D_E_L_E_T_ <> '*') AS Z5_POLDP," + CRLF
	cQry += " (SELECT TOP 1 Z6_VLFINAL FROM "+RetSqlName("SZ6")+" WHERE Z3_CONTRA = Z6_CONTRA AND Z3_PERIODO  = Z6_PERDE AND Z6_TIPOPRE = '2' AND D_E_L_E_T_ <> '*') AS Z6_VLFINAL" + CRLF
	cQry += " FROM "+RetSqlName("SZ3")+" SZ3 ,"+RetSqlName("SA2")+" SA2, "+RetSqlName("CN9")+" CN9,"+RetSqlName("CNC")+" CNC " + CRLF
	cQry += " WHERE CNC_NUMERO  = Z3_CONTRA" + CRLF
	cQry += " AND CNC_CODIGO = A2_COD" + CRLF
	cQry += " AND CNC_LOJA = A2_LOJA" + CRLF
	cQry += " AND Z3_CONTRA = CN9_NUMERO" + CRLF
	cQry += " AND CN9.D_E_L_E_T_ <> '*'" + CRLF
	cQry += " AND SZ3.D_E_L_E_T_ <> '*'" + CRLF
	cQry += " AND SA2.D_E_L_E_T_ <> '*'" + CRLF
	cQry += " AND CNC.D_E_L_E_T_ <>  '*' )" + CRLF
	cQry += " AS SZ3" + CRLF
	cQry += " ON  RTRIM(Z3_CONTRA)+'-'+RTRIM(Z3_PERIODO) = RTRIM(SD1.D1_COD) AND SZ3.A2_CGC = SD1.A2_CGC" + CRLF
	
	cQry += " LEFT JOIN" + CRLF
	cQry += " (SELECT E2_XCONTRA, E2_XLOCAL,SUM(E2_XPERPGT) AS E2_PERCPG, COUNT(E2_XCONTRA) E2_REGSPG, SUM(E2_VLFINAL) AS E2_PAGOPA,SUM((CASE WHEN E2_XSUBTIP NOT IN ('6','7') THEN E2_QTDTON ELSE 0 END)) AS E2_QTDTONPA,A2_CGC" + CRLF
	cQry += " FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2" + CRLF 
	cQry += " WHERE A2_COD = E2_FORNECE" + CRLF
	cQry += " AND A2_LOJA = E2_LOJA" + CRLF
	//cQry += " AND E2_CONTRA = ''" + CRLF // 18/04/17 - Luis Felipe
	cQry += " AND E2_XCONTRA <> ''" + CRLF
	cQry += " AND SE2.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND SA2.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND NOT EXISTS (SELECT ZD_CONTRA,ZD_PERIODO,ZD_LOCAL,A2_CGC FROM "+RetSqlName("SZD")+" WHERE RTRIM(ZD_CONTRA)+'-'+RTRIM(ZD_PERIODO) = RTRIM(SE2.E2_XCONTRA) AND ZD_LOCAL = SE2.E2_XLOCAL AND SA2.A2_CGC = ZD_CNPJUSI AND D_E_L_E_T_ = '')" + CRLF
	cQry += " GROUP BY E2_XCONTRA,E2_XLOCAL,A2_CGC)" + CRLF
	cQry += " AS SE2" + CRLF
	cQry += " ON RTRIM(SD1.Z3_CTRDP)+SD1.A2_CGC = RTRIM(E2_XCONTRA)+SE2.A2_CGC AND SE2.E2_XLOCAL = SD1.D1_LOCAL" + CRLF 
	
	cQry += " LEFT JOIN" + CRLF
	cQry += " (SELECT ZE_LOCAL,ZE_NOME" + CRLF
	cQry += " FROM "+RetSqlName("SZE") + CRLF
	cQry += " WHERE D_E_L_E_T_ = '')" + CRLF
	cQry += " AS SZE" + CRLF
	cQry += " ON ZE_LOCAL = SD1.D1_LOCAL" + CRLF
	cQry += " WHERE Z3_CONTRA <> ''" + CRLF

	// 10/11/15 - Luis Felipe - Fim

	cQry += " ORDER BY A2_XGRFOR,A2_CGC,Z3_CONTRA,Z3_PERIODO,ZD_LOCAL " + CRLF

	//Executando consulta
	PlsQuery(cQry, cAlias)

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	SZE->(DbSetOrder(3))
	While !(cAlias)->(Eof())
		If !Empty((cAlias)->ZD_LOCAL)
			SZE->(DbSeek(xFilial("SZE") + (cAlias)->ZD_LOCAL))
			nPos := aScan(aExp, {|x| x[1] + x[6] == Alltrim((cAlias)->Z3_CONTRA) + "-" + Alltrim((cAlias)->Z3_PERIODO) + Alltrim((cAlias)->A2_CGC) + (cAlias)->ZD_LOCAL})
			If nPos == 0 
				AAdd(aExp, {Alltrim((cAlias)->Z3_CONTRA) + "-" + Alltrim((cAlias)->Z3_PERIODO) + Alltrim((cAlias)->A2_CGC), 0, SZE->ZE_NOME, (cAlias)->B1_GRUPO, 0, (cAlias)->ZD_LOCAL})
			EndIf
		EndIf
		(cAlias)->(DbSkip())
	End

	(cAlias)->(dbGoTop())

	// 24/04/15 - Luis Felipe
	//
	// Quantidade embarcada = > EE9 - Item do Embarque e EEC - Cabeçalho do Embarque
	//
	//cQry := " SELECT EE8_COD_I " + CRLF
	cQry := " SELECT EE8_COD_I,A2_CGC,B1_GRUPO " + CRLF
	//cQry += " ,SUM(ISNULL(CASE WHEN B1_UM = 'TM' THEN EE9_QTDEM1 ELSE EE9_QTDEM1 * B1_CONV END,0)) EE9_QTDEM1 " + CRLF   // 23/06/15 - Luis Felipe
	// 10/11/15 - Luis Felipe - Inicio
	// cQry += " ,SUM(EE9_PSLQTO / 1000) EE9_PSLQTO   " + CRLF
	cQry += ",CASE WHEN B1_GRUPO IN ('021','022') THEN SUM(EE9_QE * EE9_QTDEM1) ELSE SUM(EE9_PSLQTO / 1000) END  EE9_PSLQTO" + CRLF
	// 10/11/15 - Luis Felipe - Fim

	//cQry += " ,EEC_END2IM" + CRLF
	cQry += " ,ZE_LOCAL" + CRLF
	//cQry += " FROM "+RetSqlName("EEC")+" EEC ,"+RetSqlName("EE9")+" EE9, "+RetSqlName("EE8")+" EE8,"+RetSqlName("SB1")+" SB1 " + CRLF
	cQry += " FROM " + RetSqlName("EEC") + " EEC ," + RetSqlName("EE9") + " EE9, " + RetSqlName("EE8") + " EE8," + RetSqlName("SA2") + " SA2 ," + RetSqlName("SZE") + " SZE, " + RetSqlName("SB1") + " SB1" + CRLF
	cQry += " WHERE EEC.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND SZE.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND EE8.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND EE9.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND SA2.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND SB1.D_E_L_E_T_ <>  '*' " + CRLF
	cQry += " AND EEC_PREEMB = EE9_PREEMB " + CRLF
	cQry += " AND EE8_LOCAL  = ZE_LOCAL " + CRLF
	cQry += " AND EE8_PEDIDO = EE9_PEDIDO " + CRLF
	cQry += " AND EE8_COD_I  = EE9_COD_I " + CRLF
	cQry += " AND EE9_FABR   = A2_COD " + CRLF
	cQry += " AND EE9_FALOJA = A2_LOJA" + CRLF 
	cQry += " AND EE9_COD_I = B1_COD" + CRLF
	/* 12/06/15 - Luis Felipe Nascimento - Solicitado por Tatiana Cerqueira nesta data
	cQry += " AND EEC_STATUS = '6' " + CRLF
	*/

	If !Empty(MV_PAR04)
		cQry += " AND EEC_DTEMBA <= '" + DtoS(MV_PAR04) + "' " + CRLF
	EndIf

	If !Empty(MV_PAR05)
		If Empty(MV_PAR06)
			cQry += " AND (SubString(EE8_COD_I,1,6) IN ('" + Alltrim(MV_PAR05) + "')" + CRLF
			cQry += " OR SubString(EE8_COD_I,1,7) IN ('" + Alltrim(MV_PAR05) + "'))" + CRLF
		Else
			cQry += " AND EE8_COD_I = '" + Alltrim(MV_PAR05) + "-" + Alltrim(MV_PAR06) + "'" + CRLF
		EndIf
	EndIf
	//cQry += " GROUP BY EE8_COD_I,EEC_END2IM " + CRLF
	//cQry += " ORDER BY EE8_COD_I,EEC_END2IM " + CRLF
	cQry += " GROUP BY EE8_COD_I,A2_CGC,ZE_LOCAL,B1_GRUPO " + CRLF
	cQry += " ORDER BY EE8_COD_I,A2_CGC,ZE_LOCAL " + CRLF

	//Executando consulta
	PlsQuery(cQry, cAlias2)

	DbSelectArea(cAlias2)
	(cAlias2)->(DbGoTop())

	SZE->(DbSetOrder(3))
	While !(cAlias2)->(Eof())
		If !Empty((cAlias2)->ZE_LOCAL)
			SZE->(DbSeek(xFilial("SZE") + (cAlias2)->ZE_LOCAL))
			nPos := aScan(aExp, {|x| x[1] + x[6] == Alltrim((cAlias2)->EE8_COD_I) + Alltrim((cAlias2)->A2_CGC) + (cAlias2)->ZE_LOCAL})
			If nPos == 0 
				AAdd(aExp, {Alltrim((cAlias2)->EE8_COD_I) + Alltrim((cAlias2)->A2_CGC), (cAlias2)->EE9_PSLQTO, SZE->ZE_NOME, (cAlias2)->B1_GRUPO, 0, (cAlias2)->ZE_LOCAL})
			Else
				aExp[nPos][2] := (cAlias2)->EE9_PSLQTO 
			EndIf	
		EndIf	
		(cAlias2)->(DbSkip())
	End

	// 14/09/18 - Luis Felipe

	// Reposição por Armazem = TES 155

	cQry := " SELECT DISTINCT D1_COD, A2_CGC, D1_LOCAL " + CRLF
	cQry += ",(SELECT SUM(ISNULL(CASE WHEN D1_UM IN ('TM','TON') THEN D1_QUANT ELSE D1_QUANT * B1_CONV END, 0)) FROM " + RetSqlName("SD1") + " D1, " + RetSqlName("SB1") + " B1, " + RetSqlName("SA2") + " A2 WHERE D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND RTRIM(D1_COD) = Rtrim(B1_COD) AND SA2.A2_CGC = A2.A2_CGC AND SD1.D1_COD = D1.D1_COD AND SD1.D1_LOCAL = D1.D1_LOCAL AND D1.D1_TES = '155' AND A2.D_E_L_E_T_ = '' AND D1.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' ) AS D1_QUANT" + CRLF
	cQry += " FROM " + RetSqlName("SD1") + " SD1 ," + RetSqlName("SA2") + " SA2, " + RetSqlName("SZ3") + " SZ3," + RetSqlName("SB1") + " SB1 ," + RetSqlName("SF4") + " SF4 " + CRLF
	cQry += " WHERE D1_FORNECE = A2_COD " + CRLF
	cQry += " AND D1_LOJA = A2_LOJA " + CRLF
	cQry += " AND D1_COD = Z3_CTRDP " + CRLF
	cQry += " AND D1_COD = B1_COD " + CRLF
	cQry += " AND D1_TES = F4_CODIGO " + CRLF
	cQry += " AND D1_TES = '155' " + CRLF

	If !Empty(MV_PAR03)
		cQry += " AND Z3_SAFRA       = '"+MV_PAR03+"'" + CRLF
	EndIf

	If !Empty(MV_PAR05)
		cQry += " AND Z3_CONTRA     = '"+MV_PAR05+"'" + CRLF
	EndIf

	If !Empty(MV_PAR06)
		cQry += " AND Z3_PERIODO    = '"+MV_PAR06+"'" + CRLF
	EndIf

	If !Empty(MV_PAR04)
		cQry += " AND D1_DTDIGIT <= '"+DtoS(MV_PAR04)+"' " + CRLF
	EndIf

	cQry += " AND SB1.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND SA2.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND SD1.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND SZ3.D_E_L_E_T_ <>  '*'" + CRLF
	cQry += " AND SF4.D_E_L_E_T_ <>  '*'" + CRLF

	//Executando consulta
	PlsQuery(cQry, cAlias3)

	DbSelectArea(cAlias3)
	(cAlias3)->(DbGoTop())

	While !(cAlias3)->(Eof())
		nPos := aScan(aExp,{|x| x[1] + x[6] == Alltrim((cAlias3)->D1_COD) + Alltrim((cAlias3)->A2_CGC) + (cAlias3)->D1_LOCAL})
		If nPos <> 0 
			aExp[nPos][5] += (cAlias3)->D1_QUANT 
		EndIf
		(cAlias3)->(DbSkip())
	End
	// 14/09/18 - Luis Felipe - Fim

	If !(cAlias)->(Eof())

		ProcRegua(0)

		// cArqXlsx := Alltrim(GetTempPath()) + "Payments By DP_" + SubStr(DtoS(dDataBase), 1, 6) + "_" + StrTran(Time(),":","") + ".rel"
		cArqXlsx := "C:\Temp\" + "Payments By DP_" + SubStr(DtoS(dDataBase), 1, 6) + "_" + StrTran(Time(),":","") + ".rel"
		oPrintXlsx := FwPrinterXlsx():New()
		
		If !oPrintXlsx:Activate(cArqXlsx)
			MsgAlert("Não foi possível criar o Arquivo " + cArqXlsx + ".", "Atenção!")
			Return
		EndIf

		//Adiciona a worksheet
		oPrintXlsx:AddSheet("Relatório")

		//Define largura das colunas
		oPrintXlsx:SetColumnsWidth(1 /* nColFrom */, 1 /* nColTo */, 15 /* nWidth */)
		oPrintXlsx:SetColumnsWidth(2 /* nColFrom */, 2 /* nColTo */, 15 /* nWidth */)
		oPrintXlsx:SetColumnsWidth(3 /* nColFrom */, 3 /* nColTo */, 6  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(4 /* nColFrom */, 4 /* nColTo */, 5  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(5 /* nColFrom */, 5 /* nColTo */, 8  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(6 /* nColFrom */, 6 /* nColTo */, 8  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(7 /* nColFrom */, 7 /* nColTo */, 8  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(8 /* nColFrom */, 8 /* nColTo */, 8  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(9 /* nColFrom */, 9 /* nColTo */, 7  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(10/* nColFrom */, 10/* nColTo */, 7  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(11/* nColFrom */, 11/* nColTo */, 7  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(12/* nColFrom */, 12/* nColTo */, 7  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(13/* nColFrom */, 13/* nColTo */, 10 /* nWidth */)
		oPrintXlsx:SetColumnsWidth(14/* nColFrom */, 14/* nColTo */, 4  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(15/* nColFrom */, 15/* nColTo */, 4  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(16/* nColFrom */, 16/* nColTo */, 10 /* nWidth */)
		oPrintXlsx:SetColumnsWidth(17/* nColFrom */, 17/* nColTo */, 12 /* nWidth */)
		oPrintXlsx:SetColumnsWidth(18/* nColFrom */, 18/* nColTo */, 10 /* nWidth */)
		oPrintXlsx:SetColumnsWidth(19/* nColFrom */, 19/* nColTo */, 10 /* nWidth */)
		oPrintXlsx:SetColumnsWidth(20/* nColFrom */, 20/* nColTo */, 10 /* nWidth */)
		oPrintXlsx:SetColumnsWidth(21/* nColFrom */, 21/* nColTo */, 10 /* nWidth */)
		oPrintXlsx:SetColumnsWidth(22/* nColFrom */, 22/* nColTo */, 10 /* nWidth */)
		oPrintXlsx:SetColumnsWidth(23/* nColFrom */, 23/* nColTo */, 7  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(24/* nColFrom */, 24/* nColTo */, 7  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(25/* nColFrom */, 25/* nColTo */, 7  /* nWidth */)
		oPrintXlsx:SetColumnsWidth(26/* nColFrom */, 26/* nColTo */, 13 /* nWidth */)

		//Aplica estilo 
		oPrintXlsx:SetFont(FwPrinterFont():Calibri(), 11/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
		oPrintXlsx:ResetCellsFormat()
		oPrintXlsx:SetCellsFormat(oCellHoriz:Left(), oCellVerti:Center(), .F., 0, "000000" /* cTextColor */, "FFFFFF" /* cBgColor */, "")
		
		//Imprime os títulos dos parâmetros
		oPrintXlsx:SetText(1 /* nLinha */, 1 /* nColuna */, "Group of Suppliers:" /* cTexto */)
		oPrintXlsx:SetText(2 /* nLinha */, 1 /* nColuna */, "Crop:" /* cTexto */)
		oPrintXlsx:SetText(3 /* nLinha */, 1 /* nColuna */, "Seller:" /* cTexto */)
		oPrintXlsx:SetText(4 /* nLinha */, 1 /* nColuna */, "Contract:" /* cTexto */)
		oPrintXlsx:SetText(5 /* nLinha */, 1 /* nColuna */, "DP:" /* cTexto */)
		oPrintXlsx:SetText(6 /* nLinha */, 1 /* nColuna */, "Up to date:" /* cTexto */)
		oPrintXlsx:SetText(7 /* nLinha */, 1 /* nColuna */, "Payment Terms:" /* cTexto */)

		//Aplica estilo 
		oPrintXlsx:SetFont(FwPrinterFont():Calibri(), 11/* nTamFonte */, .F./* lItalico */, .T./* lNegrito */, .F./* lSublinhado */)
		oPrintXlsx:ResetCellsFormat()
		oPrintXlsx:SetCellsFormat(oCellHoriz:Left(), oCellVerti:Center(), .F., 0, "FF6600" /* cTextColor */, "FFFFFF" /* cBgColor */, "")
		
		SX5->(DbSetOrder(1))
		SX5->(DbSeek(xFilial("SX5") + "Z6" + MV_PAR01))
		aSX5 := FWGetSX5("Z6", MV_PAR01)

		//Imprime os valores dos parâmetros
		oPrintXlsx:SetText(1 /* nLinha */, 2 /* nColuna */, Iif(!Empty(MV_PAR01), Alltrim(aSX5[1,4]), '') /* cTexto */)
		oPrintXlsx:SetText(2 /* nLinha */, 2 /* nColuna */, MV_PAR03 /* cTexto */)
		oPrintXlsx:SetText(3 /* nLinha */, 2 /* nColuna */, MV_PAR02 /* cTexto */)
		oPrintXlsx:SetText(4 /* nLinha */, 2 /* nColuna */, MV_PAR05 /* cTexto */)
		oPrintXlsx:SetText(5 /* nLinha */, 2 /* nColuna */, MV_PAR06 /* cTexto */)
		oPrintXlsx:SetText(6 /* nLinha */, 2 /* nColuna */, DtoC(MV_PAR04) /* cTexto */)
		oPrintXlsx:SetText(7 /* nLinha */, 2 /* nColuna */, MV_PAR07 /* cTexto */)

		//Aplica estilo ao título 
		oPrintXlsx:SetFont(FwPrinterFont():Calibri(), 13/* nTamFonte */, .F./* lItalico */, .T./* lNegrito */, .F./* lSublinhado */)
		oPrintXlsx:ResetCellsFormat()
		oPrintXlsx:SetCellsFormat(oCellHoriz:Left(), oCellVerti:Center(), .F., 0, "000000" /* cTextColor */, "FFFFFF" /* cBgColor */, "")

		//Imprime o título
		oPrintXlsx:SetText(8 /* nLinha */, 11 /* nColuna */, "Payments by DP - "+ DtoC(dDataBase) /* cTexto */)

		//Mescla células do cabeçalho
		oPrintXlsx:MergeCells(9 /* nRowFrom */, 1 /* nColFrom */, 11 /* nRowTo */, 1 /* nColTo */)
		oPrintXlsx:MergeCells(9 /* nRowFrom */, 2 /* nColFrom */, 11 /* nRowTo */, 2 /* nColTo */)
		oPrintXlsx:MergeCells(9 /* nRowFrom */, 16 /* nColFrom */, 9 /* nRowTo */, 17 /* nColTo */)
		oPrintXlsx:MergeCells(9 /* nRowFrom */, 18 /* nColFrom */, 9 /* nRowTo */, 22 /* nColTo */)
		oPrintXlsx:MergeCells(9 /* nRowFrom */, 23 /* nColFrom */, 9 /* nRowTo */, 24 /* nColTo */)
		oPrintXlsx:MergeCells(9 /* nRowFrom */, 25 /* nColFrom */, 9 /* nRowTo */, 26 /* nColTo */)
		
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 16 /* nColFrom */, 11 /* nRowTo */, 16 /* nColTo */)
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 17 /* nColFrom */, 11 /* nRowTo */, 17 /* nColTo */)
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 18 /* nColFrom */, 11 /* nRowTo */, 18 /* nColTo */)
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 19 /* nColFrom */, 11 /* nRowTo */, 19 /* nColTo */)
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 20 /* nColFrom */, 11 /* nRowTo */, 20 /* nColTo */)
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 21 /* nColFrom */, 11 /* nRowTo */, 21 /* nColTo */)
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 22 /* nColFrom */, 11 /* nRowTo */, 22 /* nColTo */)
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 23 /* nColFrom */, 11 /* nRowTo */, 23 /* nColTo */)
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 24 /* nColFrom */, 11 /* nRowTo */, 24 /* nColTo */)
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 25 /* nColFrom */, 11 /* nRowTo */, 25 /* nColTo */)
		oPrintXlsx:MergeCells(10 /* nRowFrom */, 26 /* nColFrom */, 11 /* nRowTo */, 26 /* nColTo */)

		//Aplica estilo ao cabeçalho
		oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .T./* lNegrito */, .F./* lSublinhado */)
		oPrintXlsx:ResetCellsFormat()
		oPrintXlsx:SetCellsFormat(oCellHoriz:Center(), oCellVerti:Center(), .T., 0, "000000" /* cTextColor */, "D3D3D3" /* cBgColor */, "")

		//Imprime o cabeçalho
		oPrintXlsx:SetText(9 /* nLinha */, 1 /* nColuna */, "Group of Suppliers" /* cTexto */)
		oPrintXlsx:SetText(9 /* nLinha */, 2 /* nColuna */, "Beneficiary" /* cTexto */)
		
		oPrintXlsx:SetText(9  /* nLinha */, 3 /* nColuna */, "Ctrt" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 3 /* nColuna */, "Nbr" /* cTexto */)
		oPrintXlsx:ApplyFormat(11 /* nLinha */, 3 /* nColuna */)
		
		oPrintXlsx:SetText(9  /* nLinha */, 4 /* nColuna */, "Deliv." /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 4 /* nColuna */, "key" /* cTexto */)
		oPrintXlsx:ApplyFormat(11 /* nLinha */, 4 /* nColuna */)
		
		oPrintXlsx:SetText(9  /* nLinha */, 5 /* nColuna */, "Deliv." /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 5 /* nColuna */, "Begin" /* cTexto */)
		oPrintXlsx:SetText(11 /* nLinha */, 5 /* nColuna */, "Date" /* cTexto */)
		
		oPrintXlsx:SetText(9  /* nLinha */, 6 /* nColuna */, "Deliv." /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 6 /* nColuna */, "End" /* cTexto */)
		oPrintXlsx:SetText(11 /* nLinha */, 6 /* nColuna */, "Date" /* cTexto */)

		oPrintXlsx:SetText(9  /* nLinha */, 7 /* nColuna */, "Shipment" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 7 /* nColuna */, "Begin" /* cTexto */)
		oPrintXlsx:SetText(11 /* nLinha */, 7 /* nColuna */, "Date" /* cTexto */)
		
		oPrintXlsx:SetText(9  /* nLinha */, 8 /* nColuna */, "Shipment" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 8 /* nColuna */, "End" /* cTexto */)
		oPrintXlsx:SetText(11 /* nLinha */, 8 /* nColuna */, "Date" /* cTexto */)

		oPrintXlsx:SetText(9  /* nLinha */, 9 /* nColuna */, "Delivery" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 9 /* nColuna */, "Terms" /* cTexto */)
		oPrintXlsx:ApplyFormat(11 /* nLinha */, 9 /* nColuna */)
		
		oPrintXlsx:SetText(9  /* nLinha */, 10 /* nColuna */, "Payment" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 10 /* nColuna */, "Terms" /* cTexto */)
		oPrintXlsx:ApplyFormat(11 /* nLinha */, 10 /* nColuna */)
		
		oPrintXlsx:SetText(9  /* nLinha */, 11 /* nColuna */, "% if" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 11 /* nColuna */, "Priced" /* cTexto */)
		oPrintXlsx:ApplyFormat(11 /* nLinha */, 11 /* nColuna */)

		oPrintXlsx:SetText(9  /* nLinha */, 12 /* nColuna */, "% if" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 12 /* nColuna */, "Unpriced" /* cTexto */)
		oPrintXlsx:ApplyFormat(11 /* nLinha */, 12 /* nColuna */)

		oPrintXlsx:SetText(9  /* nLinha */, 13 /* nColuna */, "Contrated" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 13 /* nColuna */, "Qty" /* cTexto */)
		oPrintXlsx:ApplyFormat(11 /* nLinha */, 13 /* nColuna */)

		oPrintXlsx:SetText(9  /* nLinha */, 14 /* nColuna */, "Total" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 14 /* nColuna */, "Lots" /* cTexto */)
		oPrintXlsx:ApplyFormat(11 /* nLinha */, 14 /* nColuna */)

		oPrintXlsx:SetText(9  /* nLinha */, 15 /* nColuna */, "Total" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 15 /* nColuna */, "Fixed" /* cTexto */)
		oPrintXlsx:ApplyFormat(11 /* nLinha */, 15 /* nColuna */)

		oPrintXlsx:SetText(9  /* nLinha */, 16 /* nColuna */, "PAID" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 16 /* nColuna */, "Qty Liquid" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 17 /* nColuna */, "Amount US$" /* cTexto */)
		
		oPrintXlsx:SetText(9  /* nLinha */, 18 /* nColuna */, "STOCK" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 18 /* nColuna */, "Departure Qty" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 19 /* nColuna */, "Gross Qty" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 20 /* nColuna */, "Arrived Liquid Qty" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 21 /* nColuna */, "Qty Retention" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 22 /* nColuna */, "Location" /* cTexto */)

		oPrintXlsx:SetText(9  /* nLinha */, 23 /* nColuna */, "SHIPMENT" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 23 /* nColuna */, "Shipped Qty" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 24 /* nColuna */, "Location" /* cTexto */)

		oPrintXlsx:SetText(9  /* nLinha */, 25 /* nColuna */, "BALANCE" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 25 /* nColuna */, "Price mt" /* cTexto */)
		oPrintXlsx:SetText(10 /* nLinha */, 26 /* nColuna */, "Arrived" /* cTexto */)

		nLinExcel := 12

		cUsina 		:= (cAlias)->A2_NREDUZ  
		cContra 	:= (cAlias)->Z3_CONTRA
		cPeriodo 	:= (cAlias)->Z3_PERIODO
		lOculta1	:= .F.
		lOculta2	:= .F.
		nQTDTONPA	:= 0
		nPAGOPA		:= 0
		nQTDREM		:= 0
		nQTDREC		:= 0
		nQtdRet		:= 0
		cXGRFOR		:= (cAlias)->A2_XGRFOR
		cContraDP	:= Alltrim((cAlias)->Z3_CONTRA) + "-" + Alltrim((cAlias)->Z3_PERIODO)

		While !(cAlias)->(EOf())
		
			IncProc("Imprimindo Relatório...")

			cPayTer  := ""
			cPPayter1:= ""
			cPPayter2:= ""
			If (cAlias)->Z3_PAYTERM == '1'
				cPayTer := "CAD ManBR"
				cPayTer := "CAD Bco"
				cPPayter1:= Str((cAlias)->Z3_FIXADO,3)
				cPPayter2:= Str((cAlias)->Z3_NFIXADO,3)
			ElseIf (cAlias)->Z3_PAYTERM == '2'
				cPayTer := "LC(C.Cred.)"
				cPPayter1:= Str((cAlias)->Z3_FIXADO,3)
				cPPayter2:= Str((cAlias)->Z3_NFIXADO,3)
			ElseIf (cAlias)->Z3_PAYTERM == '3'
				cPayTer := "CAFD(c/copia docs)"
				cPPayter1:= Str((cAlias)->Z3_FIXADO,3)
				cPPayter2:= Str((cAlias)->Z3_NFIXADO,3)
			ElseIf (cAlias)->Z3_PAYTERM == '4'
				cPayTer := "Stock Finance"
				cPPayter1:= Str((cAlias)->Z3_FIXADO,3)
				cPPayter2:= Str((cAlias)->Z3_NFIXADO,3)
			ElseIf (cAlias)->Z3_PAYTERM == '5'
				cPayTer := "Standby L/C"
				cPPayter1:= Str((cAlias)->Z3_FIXADO,3)
				cPPayter2:= Str((cAlias)->Z3_NFIXADO,3)
			ElseIf (cAlias)->Z3_PAYTERM == '6'
				cPayTer := "Part.Payment"
				cPPayter1:= Str((cAlias)->Z3_FIXADO,3)
				cPPayter2:= Str((cAlias)->Z3_NFIXADO,3)
			ElseIf (cAlias)->Z3_PAYTERM == '7'
				cPayTer := "CAD Without Prod"
				cPPayter1:= Str((cAlias)->Z3_FIXADO,3)
				cPPayter2:= Str((cAlias)->Z3_NFIXADO,3)
			ElseIf (cAlias)->Z3_PAYTERM == '8'
				cPayTer := "CAD"
				cPPayter1:= Str((cAlias)->Z3_FIXADO,3)
				cPPayter2:= Str((cAlias)->Z3_NFIXADO,3)
			ElseIf (cAlias)->Z3_PAYTERM == '9'
				cPayTer := "Prepayment"
				cPPayter1:= Str((cAlias)->Z3_FIXADO,3)
				cPPayter2:= Str((cAlias)->Z3_NFIXADO,3)
			EndIf
			
			cDiaSemana  := ""
			If (cAlias)->CN9_XDIASE == '1'
				cDiaSemana := "Monday"
			ElseIf (cAlias)->CN9_XDIASE == '2'
				cDiaSemana := "Tuesday"
			ElseIf (cAlias)->CN9_XDIASE == '3'
				cDiaSemana := "Wednesday"
			ElseIf (cAlias)->CN9_XDIASE == '4'
				cDiaSemana := "Thursday"
			ElseIf (cAlias)->CN9_XDIASE == '5'
				cDiaSemana := "Friday"
			ElseIf (cAlias)->CN9_XDIASE == '6'
				cDiaSemana := "Saturday"
			ElseIf (cAlias)->CN9_XDIASE == '7'
				cDiaSemana := "Sunday"
			EndIf
			
			// cZ3_DTINIC 	:= SubStr((cAlias)->Z3_DTINIC,1,4)+"-"+SubStr((cAlias)->Z3_DTINIC,5,2)+"-"+SubStr((cAlias)->Z3_DTINIC,7,2)+"T00:00:00.000"
			// cZ3_DTFIM	:= SubStr((cAlias)->Z3_DTFIM,1,4)+"-"+SubStr((cAlias)->Z3_DTFIM,5,2)+"-"+SubStr((cAlias)->Z3_DTFIM,7,2)+"T00:00:00.000"
			// cZ3_DTINEM	:= SubStr((cAlias)->Z3_DTINEM,1,4)+"-"+SubStr((cAlias)->Z3_DTINEM,5,2)+"-"+SubStr((cAlias)->Z3_DTINEM,7,2)+"T00:00:00.000"
			// cZ3_DTFIEM	:= SubStr((cAlias)->Z3_DTFIEM,1,4)+"-"+SubStr((cAlias)->Z3_DTFIEM,5,2)+"-"+SubStr((cAlias)->Z3_DTFIEM,7,2)+"T00:00:00.000"
			// cCN9_XDTPG	:= ""
			
			If !Empty((cAlias)->CN9_XDTPG)
				// cCN9_XDTPG	:= SubStr((cAlias)->CN9_XDTPG,1,4)+"-"+SubStr((cAlias)->CN9_XDTPG,5,2)+"-"+SubStr((cAlias)->CN9_XDTPG,7,2)+"T00:00:00.000"
			EndIf
			
			SX5->(DbSetOrder(1))
			SX5->(DbSeek(xFilial("SX5") + "Z6" + (cAlias)->A2_XGRFOR))
			aSX5 := FWGetSX5("Z6", (cAlias)->A2_XGRFOR)

			oPrintXlsx:SetRowsHeight(nLinExcel /* nRowFrom */, nLinExcel /* nRowTo */, 28.2  /* nHeight */)
			
			oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .T./* lNegrito */, .F./* lSublinhado */)
			oPrintXlsx:ResetCellsFormat()
			oPrintXlsx:SetCellsFormat(oCellHoriz:Left(), oCellVerti:Center(), .T., 0, "0000FF" /* cTextColor */, "FFFFFF" /* cBgColor */, "")
	
			If !lOculta1
				oPrintXlsx:SetText(nLinExcel /* nLinha */,  1 /* nColuna */, Iif(!Empty((cAlias)->A2_XGRFOR), Alltrim(aSX5[1,4]), '') /* cTexto */)
			Else
				oPrintXlsx:ApplyFormat(nLinExcel, 1)
			EndIf
			
			If !lOculta2 .or. !lOculta1
				oPrintXlsx:SetText(nLinExcel /* nLinha */,  2 /* nColuna */, SubStr((cAlias)->A2_NREDUZ, 1, 17) /* cTexto */)
			Else
				oPrintXlsx:ApplyFormat(nLinExcel, 2)
			EndIf

			If !lOculta3
				oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
				//Reseta a formatação
				oPrintXlsx:ResetCellsFormat()
				//Em seguida, define a formatação da coluna, sendo que o texto será preto
				oPrintXlsx:SetCellsFormat(oCellHoriz:Left(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000" /* cTextColor */, "FFFFFF" /* cBgColor */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */,  3 /* nColuna */, Alltrim((cAlias)->Z3_CONTRA) /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */,  4 /* nColuna */, Alltrim((cAlias)->Z3_PERIODO) /* cTexto */)

				
				//Reseta a formatação
				oPrintXlsx:ResetCellsFormat()
				//Em seguida, define a formatação da coluna, sendo que o texto será preto
				oPrintXlsx:SetCellsFormat(oCellHoriz:Center(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFFF", "dd/mm/yyyy")
				//Adiciona a informação na linha do excel na coluna do campo
				oPrintXlsx:SetDate(nLinExcel, 5, (cAlias)->Z3_DTINIC)
				oPrintXlsx:SetDate(nLinExcel, 6, (cAlias)->Z3_DTFIM)
				oPrintXlsx:SetDate(nLinExcel, 7, (cAlias)->Z3_DTINEM)
				oPrintXlsx:SetDate(nLinExcel, 8, (cAlias)->Z3_DTFIEM)

				//Reseta a formatação
				oPrintXlsx:ResetCellsFormat()
				//Em seguida, define a formatação da coluna, sendo que o texto será preto
				oPrintXlsx:SetCellsFormat(oCellHoriz:Center(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFFF",)
				oPrintXlsx:SetText(nLinExcel /* nLinha */,  9 /* nColuna */, (cAlias)->Z2_INCOTER /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 10 /* nColuna */, cPayTer /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 11 /* nColuna */, cPPayter1 /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 12 /* nColuna */, cPPayter2 /* cTexto */)

				oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFFF", "#,##0.000")
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 13 /* nColuna */, (cAlias)->Z3_QUANT)

				oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFFF", "#,##0")
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 14 /* nColuna */, (cAlias)->Z3_QTDLOT)
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 15 /* nColuna */, (cAlias)->Z6_TOTFIX)
			Else
				oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
				//Reseta a formatação
				oPrintXlsx:ResetCellsFormat()
				//Em seguida, define a formatação da coluna, sendo que o texto será preto
				oPrintXlsx:SetCellsFormat(oCellHoriz:Left(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000" /* cTextColor */, "FFFFFF" /* cBgColor */)
				oPrintXlsx:ApplyFormat(nLinExcel, 3)
				oPrintXlsx:ApplyFormat(nLinExcel, 4)

				
				//Reseta a formatação
				oPrintXlsx:ResetCellsFormat()
				//Em seguida, define a formatação da coluna, sendo que o texto será preto
				oPrintXlsx:SetCellsFormat(oCellHoriz:Center(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFFF", "dd/mm/yyyy")
				//Adiciona a informação na linha do excel na coluna do campo
				oPrintXlsx:ApplyFormat(nLinExcel, 5)
				oPrintXlsx:ApplyFormat(nLinExcel, 6)
				oPrintXlsx:ApplyFormat(nLinExcel, 7)
				oPrintXlsx:ApplyFormat(nLinExcel, 8)

				//Reseta a formatação
				oPrintXlsx:ResetCellsFormat()
				//Em seguida, define a formatação da coluna, sendo que o texto será preto
				oPrintXlsx:SetCellsFormat(oCellHoriz:Center(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFFF",)
				oPrintXlsx:ApplyFormat(nLinExcel, 9)
				oPrintXlsx:ApplyFormat(nLinExcel, 10)
				oPrintXlsx:ApplyFormat(nLinExcel, 11)
				oPrintXlsx:ApplyFormat(nLinExcel, 12)
				
				oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFFF", "#,##0.000")
				oPrintXlsx:ApplyFormat(nLinExcel, 13)

				oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFFF", "#,##0")
				oPrintXlsx:ApplyFormat(nLinExcel, 14)
				oPrintXlsx:ApplyFormat(nLinExcel, 15)
			EndIf
			
			SZE->(DbSetOrder(3))
			SZE->(DbSeek(xFilial("SZE") + (cAlias)->ZD_LOCAL))

			If !lLocal    
				nPos := Ascan(aExp, {|x| Alltrim(x[1]) == Alltrim((cAlias)->Z3_CONTRA) + "-" + Alltrim((cAlias)->Z3_PERIODO) + (cAlias)->A2_CGC}) 
			Else
				nPos +=	1 
			EndIf 

			If nPos > Len(aExp) .Or. nPos == 0 
				nPos := 0
				cCompara:= ""                                                
			Else
				cCompara := Alltrim(aExp[nPos][1])
			EndIf

			oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFE4C4", "#,##0.000")
			oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 16 /* nColuna */, (cAlias)->E2_QTDTONPA)
			
			oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFE4C4", "#,##0.00")
			oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 17 /* nColuna */, (cAlias)->E2_PAGOPA)
			
			oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFE0", "#,##0.000")
			oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 18 /* nColuna */, (cAlias)->ZD_QTDNFRE - (cAlias)->D2_QTDDEV)
			oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 19 /* nColuna */, (cAlias)->ZD_QTDREC - (cAlias)->D2_QTDDEV)
			oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 20 /* nColuna */, ((cAlias)->ZD_QTDREC - (cAlias)->D2_QTDDEV) * 0.9975)
			oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 21 /* nColuna */, If(nPos <> 0, aExp[nPos][5], 0))
			
			oPrintXlsx:SetFont(FwPrinterFont():Arial(), 5/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
			oPrintXlsx:ResetCellsFormat()
			oPrintXlsx:SetCellsFormat(oCellHoriz:Center(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFE0")
			oPrintXlsx:SetText(nLinExcel /* nLinha */, 22 /* nColuna */, Alltrim(SZE->ZE_NOME) /* cTexto */)
						
			If 	Alltrim((cAlias)->Z3_CONTRA) + "-" + Alltrim((cAlias)->Z3_PERIODO) + (cAlias)->A2_CGC == cCompara
				oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
				oPrintXlsx:ResetCellsFormat()
				oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFE0", "#,##0.000")
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 23 /* nColuna */, aExp[nPos][2])
			
				oPrintXlsx:SetFont(FwPrinterFont():Arial(), 5/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
				oPrintXlsx:ResetCellsFormat()
				oPrintXlsx:SetCellsFormat(oCellHoriz:Center(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFE0")
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 24 /* nColuna */, Alltrim(aExp[nPos][3]) /* cTexto */)
							
				If !Alltrim(aExp[nPos][4]) $ "021/022" // - Não soma sacaria   
					nQTDEM1X  += aExp[nPos][2] 
				EndIf	
			Else
				oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
				oPrintXlsx:ResetCellsFormat()
				oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFE0", "#,##0.000")
				oPrintXlsx:ApplyFormat(nLinExcel, 23)
			
				oPrintXlsx:SetFont(FwPrinterFont():Arial(), 5/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
				oPrintXlsx:ResetCellsFormat()
				oPrintXlsx:SetCellsFormat(oCellHoriz:Center(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFE0")
				oPrintXlsx:ApplyFormat(nLinExcel, 24)
				
			EndIf

			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1") + Alltrim((cAlias)->Z3_CONTRA) + "-" + Alltrim((cAlias)->Z3_PERIODO)))
			
			lVhp := 'VHP' $ SB1->B1_DESC
			lPol := .F.
			If (cAlias)->Z3_QTDLOT == (cAlias)->Z6_TOTFIX
				If lVhp .And. (cAlias)->Z5_POLDP <> 0
					lPol := .T.
				ElseIf !lVhp	
					lPol := .T.
				EndIf
			EndIf

			oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
			oPrintXlsx:ResetCellsFormat()
			oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "E6E6FA", "#,##0.00")
			oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 25 /* nColuna */, (cAlias)->Z6_VLFINAL)
			
			oPrintXlsx:ResetCellsFormat()
			oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "E6E6FA", "#,##0.000")
			oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 26 /* nColuna */, ((((cAlias)->ZD_QTDREC-(cAlias)->D2_QTDDEV)*0.9975) + if(nPos<>0,aExp[nPos][5],0)) - (cAlias)->E2_QTDTONPA)
						
			If !Alltrim((cAlias)->B1_GRUPO) $ "021/022" .and. (cAlias)->ORIGEM <> "SD1"  // 10/11/15 - Luis Felipe
				nQTDTONPA 	:= nQTDTONPA + (cAlias)->E2_QTDTONPA
				nQTDREM   	:= nQTDREM   + (cAlias)->ZD_QTDNFRE-(cAlias)->D2_QTDDEV   
				nQTDREC   	:= nQTDREC   + (cAlias)->ZD_QTDREC-(cAlias)->D2_QTDDEV 
				// // 14/09/18 - Luis Felipe - Inicio
				nQtdRet		:= nQtdRet   + if(nPos<>0,aExp[nPos][5],0) 
				// // 14/09/18 - Luis Felipe - Fim
			EndIf
			nPAGOPA	:= nPAGOPA   + (cAlias)->E2_PAGOPA
			cContra := (cAlias)->Z3_CONTRA
			cPeriodo:= (cAlias)->Z3_PERIODO
			cCGC	:= (cAlias)->A2_CGC

			(cAlias)->(DbSkip())
			nLinExcel++

			If	cContra + cPeriodo + cCGC <> (cAlias)->Z3_CONTRA + (cAlias)->Z3_PERIODO + (cAlias)->A2_CGC 
				lLocal := .F.
				For nx := 1 to 10
					nPos += 1
					If nPos <= Len(aExp) 
						If	Alltrim(cContra) + "-" + Alltrim(cPeriodo) + cCGC == Alltrim(aExp[nPos][1]) 
							nLin ++
							oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .T./* lNegrito */, .F./* lSublinhado */)
				
							oPrintXlsx:ResetCellsFormat()
							oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFE4C4", "#,##0.000")
							oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 16 /* nColuna */, (cAlias)->E2_QTDTONPA)
							
							oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFE4C4", "#,##0.00")
							oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 17 /* nColuna */, (cAlias)->E2_PAGOPA)

							oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFE0", "#,##0.000")
							oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 18 /* nColuna */, (cAlias)->ZD_QTDNFRE - (cAlias)->D2_QTDDEV)
							oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 19 /* nColuna */, (cAlias)->ZD_QTDREC - (cAlias)->D2_QTDDEV)
							oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 20 /* nColuna */, ((cAlias)->ZD_QTDREC - (cAlias)->D2_QTDDEV) * 0.9975)
							oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 21 /* nColuna */, If(nPos <> 0, aExp[nPos][5], 0))

							oPrintXlsx:SetFont(FwPrinterFont():Arial(), 5/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
							oPrintXlsx:ResetCellsFormat()
							oPrintXlsx:SetCellsFormat(oCellHoriz:Center(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFE0")
							oPrintXlsx:SetText(nLinExcel /* nLinha */, 22 /* nColuna */, Alltrim(SZE->ZE_NOME) /* cTexto */)
										
							oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .T./* lNegrito */, .F./* lSublinhado */)
				
							oPrintXlsx:ResetCellsFormat()
							oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFE0", "#,##0.000")
							oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 23 /* nColuna */, aExp[nPos][2])
							
							oPrintXlsx:SetFont(FwPrinterFont():Arial(), 5/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
							oPrintXlsx:ResetCellsFormat()
							oPrintXlsx:SetCellsFormat(oCellHoriz:Center(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFE0")
							oPrintXlsx:SetText(nLinExcel /* nLinha */, 24 /* nColuna */, Alltrim(aExp[nPos][3]) /* cTexto */)

							oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
							oPrintXlsx:ResetCellsFormat()
							oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "E6E6FA", "#,##0.00")
							oPrintXlsx:ApplyFormat(nLinExcel /* nLinha */, 25 /* nColuna */)
							
							oPrintXlsx:ResetCellsFormat()
							oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "000000", "E6E6FA", "#,##0.000")
							oPrintXlsx:ApplyFormat(nLinExcel /* nLinha */, 26 /* nColuna */)

							nLinExcel++
							
							If !Alltrim(aExp[nPos][4]) $ "021/022" // - Não soma sacaria  
								nQTDEM1X  += aExp[nPos][2]
							EndIf
						EndIf
					EndIf
				Next   	
			Else  
				lLocal := .T.
			EndIf 

			If cXGRFOR <> (cAlias)->A2_XGRFOR
				lOculta1 := .F.
			Else	
				lOculta1 := .T.
			EndIf
			
			If	!lOculta1 // cUsina	<> (cAlias)->A2_NREDUZ  // 23/06/15 - Luis Felipe
				
				oPrintXlsx:SetFont(FwPrinterFont():Arial(), 8/* nTamFonte */, .F./* lItalico */, .T./* lNegrito */, .F./* lSublinhado */)
				
				oPrintXlsx:ResetCellsFormat()
				oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "0000FF", "FFFFFF", "#,##0.000")
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 16 /* nColuna */, nQTDTONPA)
				
				oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "0000FF", "FFFFFF", "#,##0.00")
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 17 /* nColuna */, nPAGOPA)

				oPrintXlsx:SetCellsFormat(oCellHoriz:Right(), oCellVerti:Center(), .T. /* lQuebrLin */, 0 /* nRotation */, "0000FF", "FFFFFF", "#,##0.000")
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 18 /* nColuna */, nQTDREM)
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 19 /* nColuna */, nQTDREC)
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 20 /* nColuna */, nQTDREC * 0.9975)
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 21 /* nColuna */, nQtdRet)

				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 23 /* nColuna */, nQTDEM1X)

				nLinExcel++
				
				nQTDTONPA	:= 0
				nPAGOPA		:= 0
				nQTDREM		:= 0
				nQTDREC		:= 0
				nQTDEM1X  	:= 0    
				nQtdRet		:= 0
				cXGRFOR  	:= (cAlias)->A2_XGRFOR  
			EndIf

			If cUsina <> (cAlias)->A2_NREDUZ
				lOculta2 := .F.
				cUsina	 := (cAlias)->A2_NREDUZ
			Else
				lOculta2 := .T.
			EndIf

			If cContra + cPeriodo <> (cAlias)->Z3_CONTRA + (cAlias)->Z3_PERIODO
				cContra  := (cAlias)->Z3_CONTRA
				cPeriodo := (cAlias)->Z3_PERIODO
				cContraDP:= Alltrim((cAlias)->Z3_CONTRA) + "-" + Alltrim((cAlias)->Z3_PERIODO)
				lOculta3 := .F. 
			Else	
				lOculta3 := .T.
			EndIf 

		End

		cQry := " SELECT E2_PREFIXO,E2_NUM,E2_TIPO,E2_EMISSAO,E2_CONTRA,E2_XPERIOD,E2_XLOCAL,ZE_NOME,E2_FORNECE,E2_LOJA,A2_CGC,E2_VLFINAL"  + CRLF
		cQry += " FROM "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2, "+RetSqlName("SZE")+" SZE " + CRLF
		cQry += " WHERE E2_FORNECE = A2_COD " + CRLF
		cQry += " AND E2_LOJA = A2_LOJA " + CRLF
		cQry += " AND E2_TIPO = 'PA' " + CRLF
		cQry += " AND E2_PREFIXO = 'USI' " + CRLF
		cQry += " AND E2_XLOCAL = ZE_LOCAL " + CRLF
		If !Empty(MV_PAR05)
		cQry += " AND E2_CONTRA = '" + MV_PAR05 + "'" + CRLF
		EndIf

		If !Empty(MV_PAR06)
		cQry += " AND E2_XPERIOD = '" + MV_PAR06 + "'" + CRLF
		EndIf
		cQry += " AND SE2.D_E_L_E_T_ = '' "
		cQry += " AND SA2.D_E_L_E_T_ = '' "
		cQry += " AND SZE.D_E_L_E_T_ = '' "
		/* // 11/04/16 - Luis Felipe
		cQry += " AND NOT EXISTS (SELECT ZD_CONTRA, ZD_PERIODO, ZD_LOCAL FROM "+RetSqlName("SZD")+" SZD WHERE SZD.ZD_CONTRA = SE2.E2_CONTRA " + CRLF
		cQry += "                                                                        AND SZD.ZD_PERIODO = SE2.E2_XPERIOD " + CRLF
		cQry += " 																	   AND SZD.ZD_CNPJUSI = SA2.A2_CGC " + CRLF
		cQry += " 																	   AND SZD.ZD_LOCAL = SE2.E2_XLOCAL " + CRLF
		cQry += " 																	   AND SZD.D_E_L_E_T_ <> '*') " + CRLF
		cQry += "  ORDER BY E2_CONTRA,E2_XPERIOD,E2_XLOCAL,E2_NUM" + CRLF
		*/
		cQry += " AND NOT EXISTS (SELECT Z3_CONTRA, Z3_PERIODO FROM "+RetSqlName("SZ3")+" SZ3 WHERE (SZ3.Z3_CONTRA = SE2.E2_CONTRA AND SZ3.Z3_CTRDP = SE2.E2_XPERIOD)" + CRLF 
		cQry += " 																	   		OR SE2.E2_XCONTRA =  SZ3.Z3_CTRDP" + CRLF
		cQry += "																		   		AND SZ3.D_E_L_E_T_ <> '*')" + CRLF 
		cQry += " ORDER BY E2_EMISSAO,E2_CONTRA,E2_XPERIOD,E2_XLOCAL,E2_NUM" + CRLF

		//Executando consulta
		PlsQuery(cQry, cAlias4)

		DbSelectArea(cAlias4)
		(cAlias4)->(DbGoTop())

		If !(cAlias4)->(Eof())

			//Adiciona a worksheet Inconsistências
			oPrintXlsx:AddSheet("Inconsistências")

			//Aplica estilo 
			oPrintXlsx:SetFont(FwPrinterFont():Calibri(), 11/* nTamFonte */, .F./* lItalico */, .T./* lNegrito */, .F./* lSublinhado */)
			oPrintXlsx:ResetCellsFormat()
			oPrintXlsx:SetCellsFormat(oCellHoriz:Left(), oCellVerti:Center(), .F., 0, "000000" /* cTextColor */, "FFFFFF" /* cBgColor */, "")

			//Imprime os cabeçalhos
			oPrintXlsx:SetText(1 /* nLinha */, 1 /* nColuna */, "E2_NUM" /* cTexto */)
			oPrintXlsx:SetText(1 /* nLinha */, 2 /* nColuna */, "E2_TIPO" /* cTexto */)
			oPrintXlsx:SetText(1 /* nLinha */, 3 /* nColuna */, "E2_EMISSAO" /* cTexto */)
			oPrintXlsx:SetText(1 /* nLinha */, 4 /* nColuna */, "E2_CONTRA" /* cTexto */)
			oPrintXlsx:SetText(1 /* nLinha */, 5 /* nColuna */, "E2_XPERIOD" /* cTexto */)
			oPrintXlsx:SetText(1 /* nLinha */, 6 /* nColuna */, "E2_XLOCAL" /* cTexto */)
			oPrintXlsx:SetText(1 /* nLinha */, 7 /* nColuna */, "ZE_NOME" /* cTexto */)
			oPrintXlsx:SetText(1 /* nLinha */, 8 /* nColuna */, "E2_FORNECE" /* cTexto */)
			oPrintXlsx:SetText(1 /* nLinha */, 9 /* nColuna */, "E2_LOJA" /* cTexto */)
			oPrintXlsx:SetText(1 /* nLinha */, 10/* nColuna */, "A2_CGC" /* cTexto */)
			oPrintXlsx:SetText(1 /* nLinha */, 11/* nColuna */, "E2_VLFINAL" /* cTexto */)

			//Aplica estilo
			oPrintXlsx:SetFont(FwPrinterFont():Calibri(), 9/* nTamFonte */, .F./* lItalico */, .F./* lNegrito */, .F./* lSublinhado */)
			oPrintXlsx:ResetCellsFormat()
			oPrintXlsx:SetCellsFormat(oCellHoriz:Left(), oCellVerti:Center(), .F., 0, "000000" /* cTextColor */, "FFFFFF" /* cBgColor */, "")

			nCont := 0
			nLinExcel := 2
			While !(cAlias4)->(Eof())
				nCont += 1
				IncProc("Inconsistências encontradas: " + cValToChar(nCont))
				
				oPrintXlsx:SetCellsFormat(oCellHoriz:Left(), oCellVerti:Center(), .F., 0, "000000" /* cTextColor */, "FFFFFF" /* cBgColor */, "")
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 1 /* nColuna */, (cAlias4)->E2_NUM /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 2 /* nColuna */, (cAlias4)->E2_TIPO /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 4 /* nColuna */, (cAlias4)->E2_CONTRA /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 5 /* nColuna */, (cAlias4)->E2_XPERIOD /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 6 /* nColuna */, (cAlias4)->E2_XLOCAL /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 7 /* nColuna */, (cAlias4)->ZE_NOME /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 8 /* nColuna */, (cAlias4)->E2_FORNECE /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 9 /* nColuna */, (cAlias4)->E2_LOJA /* cTexto */)
				oPrintXlsx:SetText(nLinExcel /* nLinha */, 10/* nColuna */, (cAlias4)->A2_CGC /* cTexto */)
				oPrintXlsx:SetNumber(nLinExcel /* nLinha */, 11/* nColuna */, (cAlias4)->E2_VLFINAL /* nNumero */)
				
				oPrintXlsx:SetCellsFormat(oCellHoriz:Left(), oCellVerti:Center(), .F. /* lQuebrLin */, 0 /* nRotation */, "000000", "FFFFFF", "dd/mm/yyyy")
				oPrintXlsx:SetDate(nLinExcel /* nLinha */, 3 /* nColuna */, (cAlias4)->E2_EMISSAO /* dData */)
				
				(cAlias4)->(DbSkip())
				nLinExcel++
			End
		EndIf

		(cAlias4)->(DbCloseArea())

		//Finaliza o arquivo
		oPrintXlsx:ToXlsx()
		ferase(cArqXlsx)
		oPrintXlsx:DeActivate()
		oPrintXlsx:Destroy()

		//Abre o Arquivo
		cArqXlsx := ChgFileExt(cArqXlsx, ".xlsx")
		If File(cArqXlsx)
			cFileName := cArqXlsx
			cDrive := ""
			cDir := ""
			SplitPath(cFileName, @cDrive, @cDir)		
			cDir := Alltrim(cDrive) + Alltrim(cDir)
			ShellExecute("open", cFileName, "", cDir, 1)
		EndIf

	EndIf

Return
