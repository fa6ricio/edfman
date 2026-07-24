
/*
    Função com Array Dinâmico, Prevenção Nativa de Crash e Lógica de Cessão de Crédito
*/
User Function CNTEDF05(cFil,cCont, cFornece, cLoja)   
Local cQuery := ""
Local nRet := 0

IF cFilial <> "" .AND. cCont <> ""

        cQuery := "SELECT SUM(ZX6_SLDCES) AS SALDO_PA FROM " + RetSqlName("ZX6") + " "
        cQuery += "WHERE ZX6_CODIGO = '" + cCont + "' "
        cQuery += "AND ZX6_FORNEC = '" + cFornece + "' "
        cQuery += "AND ZX6_LOJA = '" + cLoja + "' "
        cQuery += "AND ZX6_TIPO = '1' "
        
        cQuery += "AND D_E_L_E_T_ = ' ' "
        
        cQuery := ChangeQuery(cQuery)
        DBUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), 'XZX6', .F., .T.)
        
        If !('XZX6')->(Eof()) .And. ('XZX6')->SALDO_PA > 0
            
            cQuery := "SELECT SUM(ZX5_SALDO) AS SALDO FROM " + RetSqlName("ZX5") + " "
            cQuery += "WHERE ZX5_FILIAL = '"+cFil+"' AND ZX5_CODIGO = '"+cCont+"' AND D_E_L_E_T_ = ' ' AND ZX5_SALDO > 0 AND ZX5_TIPO = 'NF' "

            cQuery := ChangeQuery(cQuery)
            dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'XZX5',.T.,.T.)

            nRet := IIf(!XZX5->(Eof()),XZX5->SALDO,0)
            XZX5->(DbCloseArea())

        EndIf
        
        ('XZX6')->(DbCloseArea())
EndIF

Return nRet
