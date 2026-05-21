#INCLUDE "protheus.ch"

/*/ {Protheus.doc} bbalrel
Relatório para gerar os dados exportados para o BankBal
@type function
@author Leandro Nunes - Techno Logic
@since 13/09/2024
@history 20/06/2025, Fernando Nicolau, Formatação de dados, alteração nos filtros, remoção da coluna RECONCILED
@history 27/06/2025, Fernando Nicolau, Remoção da coluna Value USD, deixando apenas uma coluna para valor
@history 04/07/2025, Fernando Nicolau, Inclusão de busca das contas de Numerários em Trânsito pela contabilidade
/*/
User Function bbalrel()

    Local cSql     := "" As Character
    Local cSe5     := "" As Character
    Local cArquivo := GetTempPath() + "bbalrel_" + GetNextAlias() + ".xml" As Character
    Local oFWMSEx  := FWMsExcelEx():New() As Object       
    Local oExcel   := Nil As Object   
    Local cNmWs    := "Movements" As Character
    Local cNmTab   := "BankBal Movements" As Character
    Local cKey     := "" As Character
    Local dFrom    := CToD("") As Date
    Local dTo      := CToD("") As Date
    Local aPergs   := {} As Array
    Local cCtNum01 := SuperGetMV("MV_XBBAL01", .F., "") As Character //Contas de Numerários em Real
    Local cCtNum02 := SuperGetMV("MV_XBBAL02", .F., "") As Character //Contas de Numerários em Dólar

    //Adicionando os parametros do ParamBox
    aAdd(aPergs, {1, "Data De",  dFrom,  "", ".T.", "", ".T.", 80,  .F.})
    aAdd(aPergs, {1, "Data Até", dTo,  "", ".T.", "", ".T.", 80,  .T.})

    If !Empty(cCtNum01)
        cCtNum01 := FormatIn(cCtNum01, "|")
    EndIf

    If !Empty(cCtNum02)
        cCtNum02 := FormatIn(cCtNum02, "|")
    EndIf

    If ParamBox(aPergs, "Informe o período para busca", /*aRet*/, /*bOk*/, /*aButtons*/, /*lCentered*/, /*nPosx*/, /*nPosy*/, /*oDlgWizard*/, /*cLoad*/, .F., .F.)
        dFrom := MV_PAR01
        dTo   := MV_PAR02

        oFWMSEx:AddWorkSheet(cNmWs)
        oFWMSEx:AddTable(cNmWs, cNmTab, .F.)
        oFWMSEx:SetCelFont("Consolas")
        oFWMSEx:AddColumn(cNmWs, cNmTab, "Account",    2, 1)
        oFWMSEx:AddColumn(cNmWs, cNmTab, "Title",      1, 1)
        oFWMSEx:AddColumn(cNmWs, cNmTab, "Number",     1, 1)
        oFWMSEx:AddColumn(cNmWs, cNmTab, "Bank",       2, 1)
        oFWMSEx:AddColumn(cNmWs, cNmTab, "IsMtm",      2, 1)
        // oFWMSEx:AddColumn(cNmWs, cNmTab, "Reconciled", 2, 1)
        oFWMSEx:AddColumn(cNmWs, cNmTab, "Currency",   2, 1)
        oFWMSEx:AddColumn(cNmWs, cNmTab, "Movement Value",  3, 2)
        // oFWMSEx:AddColumn(cNmWs, cNmTab, "Value Usd",  3, 2)
        oFWMSEx:AddColumn(cNmWs, cNmTab, "Date",       2, 4)

        cSql := "SELECT " + CRLF
        cSql += "    ACCOUNT, " + CRLF
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
        //MOVIMENTOS BANCÁRIOS
        cSql += "(SELECT " + CRLF
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
        cSql += "    	 WHEN A6_XMTM = 'N' THEN 'NO' " + CRLF 
        cSql += "    	 ELSE 'NO MTM' " + CRLF 
        cSql += "	 END ISMTM, " + CRLF
        cSql += "	 CASE " + CRLF
        cSql += "		 WHEN E5_RECONC = 'x' THEN 'Y' ELSE 'N' " + CRLF
        cSql += "	 END RECONCILED, " + CRLF
        cSql += "    CASE " + CRLF 
        cSql += "    	 WHEN A6_XCURREN = '' THEN 'NO CURRENCY' " + CRLF 
        cSql += "    	 ELSE A6_XCURREN " + CRLF
        cSql += "	 END CURRENCY, " + CRLF
        cSql += "	 E5_TXMOEDA USTAX, " + CRLF
        cSql += "	 CASE " + CRLF
        cSql += "    	 WHEN A6_XCURREN <> 'BRL' AND E5_MOEDA IN ('01', 'M1') THEN CASE WHEN E5_TXMOEDA > 1 THEN E5_VALOR / E5_TXMOEDA ELSE E5_VALOR END " + CRLF
        cSql += "    	 ELSE E5_VALOR " + CRLF
        cSql += "	 END MOVVALBRL, " + CRLF
        cSql += "	 CASE WHEN E5_TXMOEDA > 1 THEN E5_VALOR / E5_TXMOEDA ELSE 0 END MOVVALUSD, " + CRLF 
        cSql += "	 E5_RECPAG RECPAG, " + CRLF
        cSql += "	 E5_DATA DT, " + CRLF
        cSql += "	 E5_FILIAL FILIAL, " + CRLF
        cSql += "	 E5_PREFIXO PREFIXO, " + CRLF
        cSql += "	 E5_NUMERO NUMERO, " + CRLF
        cSql += "	 E5_PARCELA PARCELA, " + CRLF
        cSql += "	 E5_TIPO TIPO, " + CRLF
        cSql += "    E5_DOCUMEN DOC, " + CRLF
        cSql += "    E5_HISTOR HIST " + CRLF
        cSql += "FROM " + CRLF
        cSql += "    " + RetSqlName("SE5") + " SE5 INNER JOIN " + RetSqlName("SA6") + " SA6 ON " + CRLF
        cSql += "        A6_COD + A6_AGENCIA + A6_NUMCON = E5_BANCO + E5_AGENCIA + E5_CONTA INNER JOIN " + RetSqlName("CT1") + " CT1 ON " + CRLF
        cSql += "            CT1_CONTA = A6_CONTA AND " + CRLF
        If !Empty(cCtNum01)
            cSql += "            A6_CONTA NOT IN " + cCtNum01 + " AND " + CRLF
        EndIf
        If !Empty(cCtNum02)
            cSql += "            A6_CONTA NOT IN " + cCtNum02 + " AND " + CRLF
        EndIf
        cSql += "            SE5.E5_DATA BETWEEN '" + DToS(dFrom) + "' AND '" + DToS(dTo) + "' AND " + CRLF
        cSql += "            SE5.E5_SITUACA <> 'C' AND " + CRLF
        cSql += "            SE5.E5_TIPODOC NOT IN ('CM', 'DC', 'JR', 'MT') AND " + CRLF
        cSql += "            (SE5.E5_NATUREZ <> 'HEDGE' OR (SE5.E5_NATUREZ = 'HEDGE' AND SE5.E5_PREFIXO = 'MTM') OR (SE5.E5_NATUREZ = 'HEDGE' AND SE5.E5_BANCO = 'MTM')) AND " + CRLF
        cSql += "            SE5.E5_NATUREZ <> 'NATMOVP' AND " + CRLF
        cSql += "            SA6.D_E_L_E_T_= ' ' AND " + CRLF
        cSql += "            CT1.D_E_L_E_T_= ' ' AND " + CRLF
        cSql += "            SE5.D_E_L_E_T_= ' ' " + CRLF

        If !Empty(cCtNum01)
            cSql += " UNION ALL " + CRLF
            
            cSql += "SELECT " + CRLF
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
            cSql += "    	 WHEN A6_XMTM = 'N' THEN 'NO' " + CRLF 
            cSql += "    	 ELSE 'NO MTM' " + CRLF 
            cSql += "	 END ISMTM, " + CRLF
            cSql += "	 ' ' RECONCILED, " + CRLF
            cSql += "    CASE " + CRLF 
            cSql += "    	 WHEN A6_XCURREN = '' THEN 'NO CURRENCY' " + CRLF 
            cSql += "    	 ELSE A6_XCURREN " + CRLF
            cSql += "	 END CURRENCY, " + CRLF
            cSql += "	 0 USTAX, " + CRLF
            cSql += "	 CT2_VALOR MOVVALBRL, " + CRLF
            cSql += "	 0 MOVVALUSD, " + CRLF 
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
        EndIf

        If !Empty(cCtNum02)
            cSql += " UNION ALL " + CRLF
            
            cSql += "SELECT " + CRLF
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
            cSql += "    	 WHEN A6_XMTM = 'N' THEN 'NO' " + CRLF 
            cSql += "    	 ELSE 'NO MTM' " + CRLF 
            cSql += "	 END ISMTM, " + CRLF
            cSql += "	 ' ' RECONCILED, " + CRLF
            cSql += "    CASE " + CRLF 
            cSql += "    	 WHEN A6_XCURREN = '' THEN 'NO CURRENCY' " + CRLF 
            cSql += "    	 ELSE A6_XCURREN " + CRLF
            cSql += "	 END CURRENCY, " + CRLF
            cSql += "	 0 USTAX, " + CRLF
            cSql += "	 CT2_VALOR MOVVALBRL, " + CRLF
            cSql += "	 0 MOVVALUSD, " + CRLF 
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
        EndIf
        
        cSql += "            ) TAB " + CRLF
        cSql += "ORDER BY DT, " + CRLF
        cSql += "         ACCOUNT"
        cSe5 := MPSysOpenQuery(cSql)
        DbSelectArea(cSe5)
        While !(cSe5)->(Eof())
            cKey := (cSe5)->(FILIAL + PREFIXO + NUMERO + PARCELA + TIPO)
            If Empty(cKey)
                cKey := AllTrim((cSe5)->HIST)
            EndIf

            oFWMSEx:AddRow(cNmWs, cNmTab, { ;
                (cSe5)->ACCOUNT, ;
                (cSe5)->TIT, ;
                cKey, ;
                (cSe5)->BANK, ;
                (cSe5)->ISMTM, ;
                (cSe5)->CURRENCY, ;
                (cSe5)->MOVVALBRL, ;
                StoD((cSe5)->DT)})
                // (cSe5)->MOVVALUSD, ;
                // (cSe5)->RECONCILED, ;

            (cSe5)->(DbSkip())
        EndDo
        (cSe5)->(DbCloseArea())

        //Criando o XML
        oFWMSEx:Activate()
        oFWMSEx:GetXMLFile(cArquivo)
        
        //Abrindo o excel e abrindo o arquivo xml
        oExcel := MsExcel():New()       // Abre uma nova conexão com Excel
        oExcel:WorkBooks:Open(cArquivo) // Abre uma planilha
        oExcel:SetVisible(.T.)          // Visualiza a planilha
        oExcel:Destroy()                // Encerra o processo do gerenciador de tarefas
    EndIf 

Return()
