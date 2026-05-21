#Include "Totvs.ch"

/*/{Protheus.doc} bbalrel
Descrição: Função principal que gera arquivo Excel com movimentos bancários.
Inclui contas de numerários (Real e Dólar) conforme parametrização.
Geração do arquivo na pasta c:\totvs\ e abertura automática do Excel após a geração.

Parâmetros:
	MV_XBBAL01 - Contas de Numerários em Real (separadas por |)
	MV_XBBAL02 - Contas de Numerários em Dólar (separadas por |)

Retorno: Nil

Exemplo:
	bbalrel()

@author Marques Tec
@since 26/12/2025
/*/
User Function bbalrel()
	Local aArea := FWGetArea()
	Local aPergs   := {}

	Private dFrom := sToD("")
	Private dTo := sToD("")
	Private cCtNum01 := SuperGetMV("MV_XBBAL01", .F., "") As Character //Contas de Numerários em Real
	Private cCtNum02 := SuperGetMV("MV_XBBAL02", .F., "") As Character //Contas de Numerários em Dólar


	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Data de", dFrom,  "", ".T.", "", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Data Ate", dTo,  "", ".T.", "", ".T.", 80,  .F.})


	If !Empty(cCtNum01)
		cCtNum01 := FormatIn(cCtNum01, "|")
	EndIf


	If !Empty(cCtNum02)
		cCtNum02 := FormatIn(cCtNum02, "|")
	EndIf

	//Se a pergunta for confirmada, chama o preenchimento dos dados do .dot
	If ParamBox(aPergs, 'Informe os parâmetros', /*aRet*/, /*bOk*/, /*aButtons*/, /*lCentered*/, /*nPosx*/, /*nPosy*/, /*oDlgWizard*/, /*cLoad*/, .F., .F.)
		dFrom := MV_PAR01
		dTo   := MV_PAR02
		Processa({|| fGeraExcel()})
	EndIf

	FWRestArea(aArea)
Return

Static Function fGeraExcel()
	Local aArea       := FWGetArea()
	Local oPrintXlsx
	Local dData       := Date()
	Local cHora       := Time()
	Local cLocal      := "C:\totvs\"
	Local cArquivo    := cLocal + 'bbalrel' + dToS(dData) + '_' + StrTran(cHora, ':', '-') + '.rel'
	// Local cArquivo    := GetTempPath() + 'bbalrel' + dToS(dData) + '_' + StrTran(cHora, ':', '-') + '.rel'
	Local cSql     := ''
	Local cSqlSaldo    := ''
	Local nAtual      := 0
	Local nTotal      := 0
	Local aColunas    := {}
	Local oExcel
	Local cFonte      := FwPrinterFont():Arial()
	Local nTamFonte   := 12
	Local lItalico    := .F.
	Local lNegrito    := .T.
	Local lSublinhado := .F.
	Local nCpoAtual   := 0
	Local oCellHoriz  := FwXlsxCellAlignment():Horizontal()
	Local oCellVerti  := FwXlsxCellAlignment():Vertical()
	Local cHorAlinha  := ''
	Local cVerAlinha  := ''
	Local lQuebrLin   := .F.
	Local nRotation   := 0
	Local cCustForma  := ''
	Local cCampoAtu   := ''
	Local cTipo       := ''
	Local cCorFundo   := ''
	Local cCorPreto   := '000000'
	Local cCorBranco  := 'FFFFFF'
	Local cCorTxtCab  := '5D9CD5'
	Local cCorFunPad  := 'DDEBF7'

	//Montando consulta de dados
		cSql := "SELECT " + CRLF
		cSql += "    ID, " + CRLF
		cSql += "   ACCOUNT, " + CRLF
		cSql += "    TIT, " + CRLF
		cSql += "    BANK, " + CRLF
		cSql += "    ISMTM, " + CRLF
		cSql += "    RECONCILED, " + CRLF
		cSql += "    CURRENCY, " + CRLF
		cSql += "    CASE WHEN RECPAG = 'R' THEN MOVVALBRL ELSE MOVVALBRL * -1 END MOVVALBRL, " + CRLF
		cSql += "    CASE WHEN RECPAG = 'R' THEN MOVVALUSD ELSE MOVVALUSD * -1 END MOVVALUSD, " + CRLF
		cSql += "    USTAX, " + CRLF
		cSql += "    RECPAG, " + CRLF
		cSql += "    DT, " + CRLF
		cSql += "    FILIAL, " + CRLF
		cSql += "    PREFIXO, " + CRLF
		cSql += "    NUMERO, " + CRLF
		cSql += "    PARCELA, " + CRLF
		cSql += "    TIPO, " + CRLF
		cSql += "    DOC, " + CRLF
		cSql += "    HIST " + CRLF
		cSql += "FROM " + CRLF
		cSql += " (SELECT   " + CRLF
		cSql += "     E5_MSUIDT ID,   " + CRLF
		cSql += "     A6_CONTA ACCOUNT,   " + CRLF
		cSql += " 	 TRIM(CT1_DESC01) TIT,   " + CRLF
		cSql += "     CASE   " + CRLF
		cSql += " 	     WHEN A6_XTPBNK = 'C' THEN 'CURRENT ACCOUNT'   " + CRLF
		cSql += "     	 WHEN A6_XTPBNK = 'T' THEN 'CASH IN TRANSIT'   " + CRLF
		cSql += "     	 WHEN A6_XTPBNK = 'L' THEN 'LOAN ACCOUNT'   " + CRLF
		cSql += "     	 WHEN A6_XTPBNK = 'P' THEN 'PETTY CASH'   " + CRLF
		cSql += "     	 ELSE 'NO BANK'   " + CRLF
		cSql += " 	 END BANK,   " + CRLF
		cSql += "     CASE   " + CRLF
		cSql += "     	 WHEN A6_XMTM = 'S' THEN 'YES'   " + CRLF
		cSql += "     	 ELSE 'NO'   " + CRLF
		cSql += " 	 END ISMTM,   " + CRLF
		cSql += " 	 CASE   " + CRLF
		cSql += " 		 WHEN E5_RECONC = 'x' THEN 'Y' ELSE 'N'   " + CRLF
		cSql += " 	 END RECONCILED,   " + CRLF
		cSql += "     CASE   " + CRLF
		cSql += "     	 WHEN A6_XCURREN = '' THEN 'BRL'   " + CRLF
		cSql += "     	 ELSE A6_XCURREN   " + CRLF
		cSql += " 	 END CURRENCY,   " + CRLF
		cSql += " 	CASE   " + CRLF
		cSql += "     	WHEN (A6_XCURREN = 'BRL' OR A6_XCURREN = '') AND E5_MOEDA IN ('01', 'M1','TB')  " + CRLF
		cSql += " 			THEN E5_VALOR  " + CRLF
		cSql += " 		ELSE 0 " + CRLF
		cSql += " 	END MOVVALBRL,   " + CRLF
		cSql += " 	CASE   " + CRLF
		cSql += "     	WHEN A6_XCURREN <> 'BRL' AND A6_XCURREN <> '' " + CRLF
		cSql += " 			THEN  " + CRLF
		cSql += " 				CASE  " + CRLF
		cSql += " 					WHEN E5_TXMOEDA > 1  " + CRLF
		cSql += " 						THEN E5_VALOR / E5_TXMOEDA  " + CRLF
		cSql += " 					ELSE E5_VALOR  " + CRLF
		cSql += " 				END   " + CRLF
		cSql += " 		ELSE 0  " + CRLF
		cSql += " 	END MOVVALUSD,   " + CRLF
		cSql += "    E5_TXMOEDA USTAX, " + CRLF
		cSql += " 	 E5_RECPAG RECPAG,   " + CRLF
		cSql += " 	 E5_DATA DT,   " + CRLF
		cSql += " 	 E5_FILIAL FILIAL,   " + CRLF
		cSql += " 	 E5_PREFIXO PREFIXO,   " + CRLF
		cSql += " 	 E5_NUMERO NUMERO,   " + CRLF
		cSql += " 	 E5_PARCELA PARCELA,   " + CRLF
		cSql += " 	 E5_TIPO TIPO,   " + CRLF
		cSql += "     E5_DOCUMEN DOC,   " + CRLF
		cSql += "     E5_HISTOR HIST   " + CRLF
		cSql += " FROM   " + CRLF
		cSql += "      " + RetSqlName("SE5") + "  SE5  " + CRLF
		cSql += " 	 INNER JOIN  " + RetSqlName("SA6") + "  SA6  " + CRLF
		cSql += " 		ON A6_COD + A6_AGENCIA + A6_NUMCON = E5_BANCO + E5_AGENCIA + E5_CONTA  " + CRLF
		cSql += " 	 INNER JOIN  " + RetSqlName("CT1") + "  CT1  " + CRLF
		cSql += " 	 ON CT1_CONTA = A6_CONTA AND   " + CRLF
		If !Empty(cCtNum01)
			cSql += "            A6_CONTA NOT IN " + cCtNum01 + " AND " + CRLF
		EndIf
		If !Empty(cCtNum02)
			cSql += "            A6_CONTA NOT IN " + cCtNum02 + " AND " + CRLF
		EndIf
		cSql += "         SE5.E5_DATA BETWEEN '" + DToS(dFrom) + "' AND '" + DToS(dTo) + "' AND " + CRLF
		cSql += "         SE5.E5_SITUACA <> 'C' AND   " + CRLF
		cSql += "         SE5.E5_TIPODOC NOT IN ('CM', 'DC', 'JR', 'MT') AND   " + CRLF
		cSql += "         (SE5.E5_NATUREZ <> 'HEDGE' OR (SE5.E5_NATUREZ = 'HEDGE' AND SE5.E5_PREFIXO = 'MTM') OR (SE5.E5_NATUREZ = 'HEDGE' AND SE5.E5_BANCO = 'MTM')) AND   " + CRLF
		cSql += "         SE5.E5_NATUREZ <> 'NATMOVP' AND   " + CRLF
		cSql += "         SA6.D_E_L_E_T_= ' ' AND   " + CRLF
		cSql += "         CT1.D_E_L_E_T_= ' ' AND   " + CRLF
		cSql += "         SE5.D_E_L_E_T_= ' '   " + CRLF

		If !Empty(cCtNum01)
			cSql += " UNION ALL " + CRLF

			cSql += "SELECT " + CRLF
			cSql += "    max(CT2_MSUIDT) AS ID, " + CRLF
			cSql += "    A6_CONTA ACCOUNT, " + CRLF
			cSql += "	 TRIM(CT1_DESC01) TIT, " + CRLF
			cSql += "    CASE " + CRLF
			cSql += "	     WHEN A6_XTPBNK = 'C' THEN 'CURRENT ACCOUNT' " + CRLF
			cSql += "    	 WHEN A6_XTPBNK = 'T' THEN 'CASH IN TRANSIT' " + CRLF
			cSql += "    	 WHEN A6_XTPBNK = 'L' THEN 'LOAN ACCOUNT' " + CRLF
			cSql += "    	 WHEN A6_XTPBNK = 'P' THEN 'PETTY CASH' " + CRLF
			cSql += "    	 ELSE 'NO BANK' " + CRLF
			cSql += "	 END BANK, " + CRLF
			cSql += "    CASE " + CRLF
			cSql += "    	 WHEN A6_XMTM = 'S' THEN 'YES' " + CRLF
			cSql += "    	 ELSE 'NO' " + CRLF
			cSql += "	 END ISMTM, " + CRLF
			cSql += "	 'N' RECONCILED, " + CRLF
			cSql += "    CASE " + CRLF
			cSql += "    	 WHEN A6_XCURREN = '' THEN 'BRL' " + CRLF
			cSql += "    	 ELSE A6_XCURREN " + CRLF
			cSql += "	 END CURRENCY, " + CRLF
			cSql += "	 max(CT2_VALOR) MOVVALBRL, " + CRLF
			cSql += "	 0 MOVVALUSD, " + CRLF
			cSql += "	 0 USTAX, " + CRLF
			cSql += "	 CASE WHEN A6_CONTA = CT2_CREDIT THEN 'P' ELSE 'R' END RECPAG, " + CRLF
			cSql += "	 CT2_DATA DT, " + CRLF
			cSql += "	 '' FILIAL, " + CRLF
			cSql += "	 '' PREFIXO, " + CRLF
			cSql += "	 '' NUMERO, " + CRLF
			cSql += "	 '' PARCELA, " + CRLF
			cSql += "	 '' TIPO, " + CRLF
			cSql += "    '' DOC, " + CRLF
			cSql += "    CT2_HIST HIST " + CRLF
			cSql += "FROM " + CRLF
			cSql += "    " + RetSqlName("CT2") + " CT2 INNER JOIN " + RetSqlName("SA6") + " SA6 ON " + CRLF
			cSql += "        A6_CONTA = CT2_DEBITO OR A6_CONTA = CT2_CREDIT INNER JOIN " + RetSqlName("CT1") + " CT1 ON " + CRLF
			cSql += "            CT1_CONTA = A6_CONTA AND " + CRLF
			cSql += "            A6_CONTA IN " + cCtNum01 + " AND " + CRLF
			cSql += "            CT2.CT2_DATA BETWEEN '" + DToS(dFrom) + "' AND '" + DToS(dTo) + "' AND " + CRLF
			cSql += "            CT2.CT2_MOEDLC = '01' AND " + CRLF
			cSql += "            CT2.CT2_DC IN ('1', '2', '3') AND " + CRLF
			cSql += "            SA6.D_E_L_E_T_= ' ' AND " + CRLF
			cSql += "            CT1.D_E_L_E_T_= ' ' AND " + CRLF
			cSql += "            CT2.D_E_L_E_T_= ' ' " + CRLF
			cSql += " GROUP BY  A6_XCURREN, A6_XTPBNK , A6_XMTM , A6_CONTA , CT1_DESC01, CT2_CREDIT, CT2_DATA , CT2_HIST "+ CRLF
		EndIf

		If !Empty(cCtNum02)
			cSql += " UNION ALL " + CRLF

			cSql += "SELECT " + CRLF
			cSql += "    max(CT2_MSUIDT) AS ID, " + CRLF
			cSql += "    A6_CONTA ACCOUNT, " + CRLF
			cSql += "	 TRIM(CT1_DESC01) TIT, " + CRLF
			cSql += "    CASE " + CRLF
			cSql += "	     WHEN A6_XTPBNK = 'C' THEN 'CURRENT ACCOUNT' " + CRLF
			cSql += "    	 WHEN A6_XTPBNK = 'T' THEN 'CASH IN TRANSIT' " + CRLF
			cSql += "    	 WHEN A6_XTPBNK = 'L' THEN 'LOAN ACCOUNT' " + CRLF
			cSql += "    	 WHEN A6_XTPBNK = 'P' THEN 'PETTY CASH' " + CRLF
			cSql += "    	 ELSE 'NO BANK' " + CRLF
			cSql += "	 END BANK, " + CRLF
			cSql += "    CASE " + CRLF
			cSql += "    	 WHEN A6_XMTM = 'S' THEN 'YES' " + CRLF
			cSql += "    	 ELSE 'NO' " + CRLF
			cSql += "	 END ISMTM, " + CRLF
			cSql += "	 'N' RECONCILED, " + CRLF
			cSql += "    CASE " + CRLF
			cSql += "    	 WHEN A6_XCURREN = '' THEN 'USD' " + CRLF
			cSql += "    	 ELSE A6_XCURREN " + CRLF
			cSql += "	 END CURRENCY, " + CRLF
			cSql += "	 0 MOVVALBRL, " + CRLF
			cSql += "	 max(CT2_VALOR) MOVVALUSD, " + CRLF
			cSql += "	 0 USTAX, " + CRLF
			cSql += "	 CASE WHEN A6_CONTA = CT2_CREDIT THEN 'P' ELSE 'R' END RECPAG, " + CRLF
			cSql += "	 CT2_DATA DT, " + CRLF
			cSql += "	 '' FILIAL, " + CRLF
			cSql += "	 '' PREFIXO, " + CRLF
			cSql += "	 '' NUMERO, " + CRLF
			cSql += "	 '' PARCELA, " + CRLF
			cSql += "	 '' TIPO, " + CRLF
			cSql += "    '' DOC, " + CRLF
			cSql += "    CT2_HIST HIST " + CRLF
			cSql += "FROM " + CRLF
			cSql += "    " + RetSqlName("CT2") + " CT2 INNER JOIN " + RetSqlName("SA6") + " SA6 ON " + CRLF
			cSql += "        A6_CONTA = CT2_DEBITO OR A6_CONTA = CT2_CREDIT INNER JOIN " + RetSqlName("CT1") + " CT1 ON " + CRLF
			cSql += "            CT1_CONTA = A6_CONTA AND " + CRLF
			cSql += "            A6_CONTA IN " + cCtNum02 + " AND " + CRLF
			cSql += "            CT2.CT2_DATA BETWEEN '" + DToS(dFrom) + "' AND '" + DToS(dTo) + "' AND " + CRLF
			cSql += "            CT2.CT2_MOEDLC = '02' AND " + CRLF
			cSql += "            CT2.CT2_DC IN ('1', '2', '3') AND " + CRLF
			cSql += "            SA6.D_E_L_E_T_= ' ' AND " + CRLF
			cSql += "            CT1.D_E_L_E_T_= ' ' AND " + CRLF
			cSql += "            CT2.D_E_L_E_T_= ' ' " + CRLF
			cSql += " GROUP BY  A6_XCURREN, A6_XTPBNK , A6_XMTM , A6_CONTA , CT1_DESC01, CT2_CREDIT, CT2_DATA , CT2_HIST "+ CRLF
		EndIf

		cSql += "            ) TAB " + CRLF
		cSql += "ORDER BY DT,ACCOUNT"

	// Montando consulta (versão unificada por ACCOUNT)
		cSqlSaldo := " SELECT   " + CRLF
		cSqlSaldo += "     MAX(ID) ID, " + CRLF
		cSqlSaldo += "     Account, " + CRLF
		cSqlSaldo += "     DESCR, " + CRLF
		cSqlSaldo += "     SUM(DEBITO)  AS TOTAL_DEBITO, " + CRLF
		cSqlSaldo += "     SUM(CREDITO) AS TOTAL_CREDITO, " + CRLF
		cSqlSaldo += "     SUM( " + CRLF
		cSqlSaldo += "         CASE  " + CRLF
		cSqlSaldo += "             WHEN MOEDA = '01' THEN (DEBITO - CREDITO) " + CRLF
		cSqlSaldo += "             ELSE 0 " + CRLF
		cSqlSaldo += "         END " + CRLF
		cSqlSaldo += "     ) AS MOVVALBRL, " + CRLF
		cSqlSaldo += "     SUM( " + CRLF
		cSqlSaldo += "         CASE  " + CRLF
		cSqlSaldo += "             WHEN MOEDA = '02' THEN (DEBITO - CREDITO) " + CRLF
		cSqlSaldo += "             ELSE 0 " + CRLF
		cSqlSaldo += "         END " + CRLF
		cSqlSaldo += "     ) AS MOVVALUSD " + CRLF

		cSqlSaldo += " FROM ( " + CRLF
		cSqlSaldo += "     SELECT DISTINCT " + CRLF
		cSqlSaldo += "         CQ1.CQ1_FILIAL AS FIL, " + CRLF
		cSqlSaldo += "         CQ1.CQ1_DATA   AS DT, " + CRLF
		cSqlSaldo += "         CQ1.CQ1_CONTA  AS Account, " + CRLF
		cSqlSaldo += "         CQ1.CQ1_MOEDA  AS MOEDA, " + CRLF
		cSqlSaldo += "         TRIM(CT1_DESC01) AS DESCR, " + CRLF
		cSqlSaldo += "         CQ1.CQ1_DEBITO AS DEBITO, " + CRLF
		cSqlSaldo += "         CQ1.CQ1_CREDIT AS CREDITO, " + CRLF
		cSqlSaldo += "         E5_MSUIDT ID " + CRLF

		cSqlSaldo += "     FROM " + RetSqlName("SE5") + "   SE5 " + CRLF
		cSqlSaldo += "     INNER JOIN  " + RetSqlName("SA6") + "   SA6 " + CRLF
		cSqlSaldo += "         ON A6_COD + A6_AGENCIA + A6_NUMCON = E5_BANCO + E5_AGENCIA + E5_CONTA " + CRLF
		cSqlSaldo += "     INNER JOIN  " + RetSqlName("CT1") + "   CT1 " + CRLF
		cSqlSaldo += "         ON CT1_CONTA = A6_CONTA " + CRLF
		cSqlSaldo += "         AND SE5.E5_DATA BETWEEN '" + DToS(dFrom) + "' AND '" + DToS(dTo) + "' " + CRLF
		cSqlSaldo += "         AND SE5.E5_SITUACA <> 'C' " + CRLF
		cSqlSaldo += "         AND SE5.E5_TIPODOC NOT IN ('CM','DC','JR','MT') " + CRLF
		cSqlSaldo += "         AND (SE5.E5_NATUREZ <> 'HEDGE' " + CRLF
		cSqlSaldo += "              OR (SE5.E5_NATUREZ = 'HEDGE' AND SE5.E5_PREFIXO = 'MTM') " + CRLF
		cSqlSaldo += "              OR (SE5.E5_NATUREZ = 'HEDGE' AND SE5.E5_BANCO = 'MTM')) " + CRLF
		cSqlSaldo += "         AND SE5.E5_NATUREZ <> 'NATMOVP' " + CRLF
		cSqlSaldo += "         AND SA6.D_E_L_E_T_ = ' ' " + CRLF
		cSqlSaldo += "         AND CT1.D_E_L_E_T_ = ' ' " + CRLF
		cSqlSaldo += "         AND SE5.D_E_L_E_T_ = ' ' " + CRLF
		cSqlSaldo += "     LEFT JOIN  " + RetSqlName("CQ1") + "   CQ1 " + CRLF
		cSqlSaldo += "         ON CQ1.CQ1_CONTA = SA6.A6_CONTA " + CRLF
		cSqlSaldo += "         AND CQ1.CQ1_MOEDA IN ('01','02') " + CRLF
		cSqlSaldo += "         AND CQ1.CQ1_DATA < '" + DToS(dFrom) + "' " + CRLF
		cSqlSaldo += "         AND CQ1.D_E_L_E_T_ = ' ' " + CRLF
		cSqlSaldo += "         AND CQ1.CQ1_LP = ( " + CRLF
		cSqlSaldo += "                 SELECT MAX(CQ1_LP) " + CRLF
		cSqlSaldo += "                 FROM " + RetSqlName("CQ1") + "   CQ13 " + CRLF
		cSqlSaldo += "                 WHERE CQ13.CQ1_FILIAL = CQ1.CQ1_FILIAL " + CRLF
		cSqlSaldo += "                   AND CQ13.CQ1_MOEDA  = CQ1.CQ1_MOEDA " + CRLF
		cSqlSaldo += "                   AND CQ13.CQ1_TPSALD = CQ1.CQ1_TPSALD " + CRLF
		cSqlSaldo += "                   AND CQ13.CQ1_CONTA  = CQ1.CQ1_CONTA " + CRLF
		cSqlSaldo += "                   AND CQ13.CQ1_DATA   < '" + DToS(dFrom) + "' " + CRLF
		cSqlSaldo += "                   AND CQ13.D_E_L_E_T_ = ' ' " + CRLF
		cSqlSaldo += "         ) " + CRLF
		cSqlSaldo += " ) TAB " + CRLF

		cSqlSaldo += " GROUP BY " + CRLF
		cSqlSaldo += "     Account, " + CRLF
		cSqlSaldo += "     DESCR " + CRLF

		cSqlSaldo += " ORDER BY Account " + CRLF

	//Executando consulta e setando o total da regua
	If '--' $ cSql .Or. 'WITH' $ Upper(cSql) .Or. 'NOLOCK' $ Upper(cSql)
		FWAlertInfo('Alguns comandos (como --, WITH e NOLOCK), não são executados pela PLSQuery devido ao ChangeQuery. Tente migrar da PLSQuery para TCQuery.', 'Atenção')
	EndIf
	MemoWrite('C:\Temp\clientes\cSql.txt',cSql)
	PlsQuery(cSql, "cSe5")
	DbSelectArea("cSe5")

	MemoWrite('C:\Temp\clientes\cSqlSaldo.txt',cSqlSaldo)
	PlsQuery(cSqlSaldo, "cSaldo")
	DbSelectArea("cSaldo")

	//Somente se houver dados
	If ! cSaldo->(EoF())
		If ! cSe5->(EoF())

			//Definindo o tamanho da regua
			Count To nTotal
			ProcRegua(nTotal)
			cSaldo->(DbGoTop())

			//Vamos agora adicionar as colunas no Excel, sendo as posições:
			//  [1] Nome do Campo
			//  [2] Tipo do Campo
			//  [3] Título a ser exibido
			//  [4] Largura em pixels, sendo que o ideal é o tamanho do campo * 1.5 (se o campo for muito pequeno, considere o tamanho minimo como 10 * 1.5)
			//  [5] Alinhamento (0 = esquerda, 1 = direita, 2 = centralizado)
			//  [6] Máscara aplicada em campos numéricos

			aAdd(aColunas, { 'ID'  , 'C'  , 'ID'  , Len(cSe5->ID) * 1.5  , 0  , ''  })
			aAdd(aColunas, { 'ACCOUNT'  , 'C'  , 'Account'  , Len(cSe5->ACCOUNT) * 1.5  , 0  , ''  })
			aAdd(aColunas, { 'TIT'  , 'C'  , 'Title'  , Len(cSe5->TIT) * 1.5  , 0  , ''  })
			aAdd(aColunas, { 'cKey'  , 'C'  , 'Number'  , 40 * 1.5  , 0  , ''  })
			aAdd(aColunas, { 'BANK'  , 'C'  , 'Bank'  , Len(cSe5->BANK) * 1.5  , 0  , ''  })
			aAdd(aColunas, { 'ISMTM'  , 'C'  , 'IsMtm'  , Len(cSe5->ISMTM) * 1.5  , 0  , ''  })
			aAdd(aColunas, { 'RECONCILED'  , 'C'  , 'Reconciled'  , Len(cSe5->RECONCILED) * 1.5  , 0  , ''  })
			aAdd(aColunas, { 'CURRENCY'  , 'C'  , 'Currency'  , Len(cSe5->CURRENCY) * 1.5  , 0  , ''  })
			aAdd(aColunas, { 'MOVVALBRL'  , 'N'  , 'Value BRL'  , 18  , 0  , '@E 999,999,999,999.99'  })
			aAdd(aColunas, { 'MOVVALUSD'  , 'N'  , 'Value USD'  , 18  , 0  , '@E 999,999,999,999.99'  })
			aAdd(aColunas, { 'DT'  , 'D'  , 'Movement Date'  , 15  , 0  , ''  })


			//Instancia a classe, e tenta criar o arquivo .rel
			oPrintXlsx := FwPrinterXlsx():New()
			If oPrintXlsx:Activate(cArquivo)

				//Adiciona uma worksheet
				oPrintXlsx:AddSheet('BankBal_Movements')

				//Depois de imprimir os textos do cabeçalho, vamos colocar a fonte como normal
				nTamFonte := 10
				lNegrito  := .F.
				oPrintXlsx:SetFont(cFonte, nTamFonte, lItalico, lNegrito, lSublinhado)

				//Na primeira linha do cabeçalho, vamos definir como tudo centralizado, a cor do texto verde e de fundo branca
				cHorAlinha  := oCellHoriz:Center()
				cVerAlinha  := oCellVerti:Center()
				oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, cCorTxtCab, cCorBranco, cCustForma)

				//Percorre agora as colunas e vem setando o tamanho delas e colocando o nome
				nLinExcel := 1
				For nAtual := 1 To Len(aColunas)
					oPrintXlsx:SetColumnsWidth(nAtual, nAtual, aColunas[nAtual][4])
					oPrintXlsx:SetText(nLinExcel, nAtual, aColunas[nAtual][3])
				Next

				//Define que as colunas terão opção de filtrar (da coluna 1 até a quantidade de campos)
				oPrintXlsx:ApplyAutoFilter(nLinExcel, 1, nLinExcel, Len(aColunas))

				//Percorrendo os dados da query
				nAtual := 0

				//percorre os registros (saldos)
				While !(cSaldo->(EoF()))

					//Incrementando a regua
					nAtual++

					//Se for ímpar, o fundo vai ser verde claro, senão vai ser branco
					If nAtual % 2 != 0
						cCorFundo := cCorFunPad
					Else
						cCorFundo := cCorBranco
					EndIf

					//Incrementa a linha no Excel
					nLinExcel++
					//Percorre as colunas
					For nCpoAtual := 1 To Len(aColunas)
						cCampoAtu := aColunas[nCpoAtual][1]
						cTipo     := aColunas[nCpoAtual][2]
						// Obtendo o conteúdo do campo
						IF cCampoAtu == 'ID'
							xConteud  := Alltrim(&('cSaldo->' + "ID"))
						EndIf
						IF cCampoAtu == 'ACCOUNT'
							xConteud  := Alltrim(&('cSaldo->' + "Account"))
						EndIf
						IF cCampoAtu == 'TIT'
							xConteud  := Alltrim(&('cSaldo->' + "DESCR"))
						EndIf
						IF cCampoAtu == 'cKey'
							xConteud  := "PREVIOUS BALANCE"
						EndIf
						IF cCampoAtu == 'ISMTM'
							xConteud  := " "
						EndIf
						IF cCampoAtu == 'BANK'
							xConteud  := " "
						EndIf
						IF cCampoAtu == 'RECONCILED'
							xConteud  := " "
						EndIf
						IF cCampoAtu == 'CURRENCY'
							if Alltrim(&('cSaldo->' + "Account")) $ cCtNum01
								xConteud  := "BRL"//cValToChar(&('cSaldo->' + "CURRENCY"))
							elseif Alltrim(&('cSaldo->' + "Account")) $ cCtNum02
								xConteud  := "USD"
							ELSE
								xConteud  := " "
							endif
						EndIf
						IF cCampoAtu == 'MOVVALBRL'
							if Alltrim(&('cSaldo->' + "Account")) $ cCtNum01
								xConteud := Alltrim(Transform(&('cSaldo->' + "MOVVALBRL"),'@E 999,999,999,999.99'))
							else
								xConteud := Alltrim(Transform(000,'@E 999,999,999,999.99'))
							endif
						EndIf
						IF cCampoAtu == 'MOVVALUSD'
							if Alltrim(&('cSaldo->' + "Account")) $ cCtNum02
								xConteud := Alltrim(Transform(&('cSaldo->' + "MOVVALUSD"),'@E 999,999,999,999.99'))
							else
								xConteud := Alltrim(Transform(000,'@E 999,999,999,999.99'))
							endif
						EndIf
						IF cCampoAtu == 'DT'
							xConteud  := dtos(dFrom)
						EndIf

						//Se o alinhamento for a direita
						If aColunas[nCpoAtual][5] == 1
							cHorAlinha := oCellHoriz:Right()

							//Se for centralizado
						ElseIf aColunas[nCpoAtual][5] == 2
							cHorAlinha := oCellHoriz:Center()

							//Senão, será a esquerda
						Else
							cHorAlinha := oCellHoriz:Left()
						EndIf

						//Reseta a formatação
						oPrintXlsx:ResetCellsFormat()

						//Em seguida, define a formatação da coluna, sendo que o texto será preto
						oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, cCorPreto, cCorFundo, cCustForma)

						//Adiciona a informação na linha do excel na coluna do campo
						oPrintXlsx:SetText(nLinExcel, nCpoAtual, xConteud)
					Next

					cSaldo->(DbSkip())
				EndDo

				nAtual := 0

				//percorrendo os dados da query (movimentos)
				While !(cSe5->(EoF()))

					//Incrementando a regua
					nAtual++
					IncProc('Adicionando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

					//Se for ímpar, o fundo vai ser verde claro, senão vai ser branco
					If nAtual % 2 != 0
						cCorFundo := cCorFunPad
					Else
						cCorFundo := cCorBranco
					EndIf

					//Incrementa a linha no Excel
					nLinExcel++

					//Percorre as colunas
					For nCpoAtual := 1 To Len(aColunas)
						cCampoAtu := aColunas[nCpoAtual][1]
						cTipo     := aColunas[nCpoAtual][2]
						// Obtendo o conteúdo do campo
						IF cCampoAtu == 'cKey' .AND. !EMPTY(&('cSe5->' + "(FILIAL + PREFIXO + NUMERO + PARCELA + TIPO)"))
							xConteud  := &('cSe5->' + "(FILIAL + PREFIXO + NUMERO + PARCELA + TIPO)")
						ELSEIF cCampoAtu == 'cKey' .AND. EMPTY(&('cSe5->' + "(FILIAL + PREFIXO + NUMERO + PARCELA + TIPO)"))
							xConteud  := &('cSe5->' + "HIST")
						ELSE
							xConteud  := &('cSe5->' + cCampoAtu)
						EndIf

						//Se for data, vai ser centralizado
						If cTipo == 'D'
							// xConteud := dToC(xConteud)
							xConteud := xConteud

							//Se for numérico, vai ser a direita
						ElseIf cTipo == 'N'
							//Se tem máscara, aplica num transform
							If ! Empty(aColunas[nCpoAtual][6])
								xConteud := Alltrim(Transform(xConteud, aColunas[nCpoAtual][6]))

								//Senão converte de numérico para texto
							Else
								xConteud := cValToChar(xConteud)
							EndIf

							//Senão, apenas tira espaços do campo
						Else
							xConteud := Alltrim(xConteud)
						EndIf

						//Se o alinhamento for a direita
						If aColunas[nCpoAtual][5] == 1
							cHorAlinha := oCellHoriz:Right()

							//Se for centralizado
						ElseIf aColunas[nCpoAtual][5] == 2
							cHorAlinha := oCellHoriz:Center()

							//Senão, será a esquerda
						Else
							cHorAlinha := oCellHoriz:Left()
						EndIf

						//Reseta a formatação
						oPrintXlsx:ResetCellsFormat()

						//Em seguida, define a formatação da coluna, sendo que o texto será preto
						oPrintXlsx:SetCellsFormat(cHorAlinha, cVerAlinha, lQuebrLin, nRotation, cCorPreto, cCorFundo, cCustForma)

						//Adiciona a informação na linha do excel na coluna do campo
						oPrintXlsx:SetText(nLinExcel, nCpoAtual, xConteud)
					Next

					cSe5->(DbSkip())
				EndDo

				//Vamos finalizar o arquivo
				oPrintXlsx:ToXlsx()
				oPrintXlsx:DeActivate()

				// Remove o arquivo .rel temporário
				If File(cArquivo)
					FErase(cArquivo)
				EndIf

				//E agora vamos abrir ele
				cArquivo := ChgFileExt(cArquivo, '.xlsx')
				If File(cArquivo)
					oExcel := MsExcel():New()
					oExcel:WorkBooks:Open(cArquivo)
					oExcel:SetVisible(.T.)
					oExcel:Destroy()
				EndIf
			EndIf

		Else
			FWAlertError('Não foi encontrado registros com os filtros informados!', 'Falha')
		EndIf
		cSe5->(DbCloseArea())
	Else
		FWAlertError('Não foi encontrado registros com os filtros informados!', 'Falha')
	EndIf
	cSaldo->(DbCloseArea())

	FWRestArea(aArea)
Return
