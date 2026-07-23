#Include "Totvs.ch"
#Include "FwMvcDef.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} Programa  - FA080TIT
Ponto de entrada de validação de baixa de títulos de contas a pagar

@author Alex da Silva
@since  18/06/2026
/*/

User Function FA080TIT()
    Local lRet      := .T.
    Local cQuery    := ""
    Local cAliasTmp := GetNextAlias()
    Local nSaldoPA  := 0
    
    If SE2->E2_ZZBLQPG == "2"
        
        MsgStop("Este titulo esta com o bloqueio de pagamento ativado pelo Contrato de Algodao." + CRLF + ;
                "Para prosseguir com a baixa, remova o bloqueio na rotina de Contratos.", "Baixa Bloqueada")
                
        Return .F.
        
    EndIf
    
    If !Empty(SE2->E2_ZZCONTR) .And. AllTrim(SE2->E2_TIPO) != "PA"
        
        cQuery := "SELECT SUM(ZX6_SLDCES) AS SALDO_PA FROM " + RetSqlName("ZX6") + " "
        cQuery += "WHERE ZX6_CODIGO = '" + SE2->E2_ZZCONTR + "' "
        cQuery += "AND ZX6_FORNEC = '" + SE2->E2_FORNECE + "' "
        cQuery += "AND ZX6_LOJA = '" + SE2->E2_LOJA + "' "
        cQuery += "AND ZX6_TIPO = '1' "
        
        cQuery += "AND D_E_L_E_T_ = ' ' "
        
        cQuery := ChangeQuery(cQuery)
        DBUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasTmp, .F., .T.)
        
        If !(cAliasTmp)->(Eof()) .And. (cAliasTmp)->SALDO_PA > 0
            nSaldoPA := (cAliasTmp)->SALDO_PA
            
            If MsgYesNo("ATENCAO: Foi identificado um saldo de Pagamento Antecipado (PA) no valor de R$" + ;
                        Transform(Alltrim(nSaldoPA), "@E 999,999,999.99") + " para este fornecedor no contrato " + AllTrim(SE2->E2_ZZCONTR) + "." + CRLF + CRLF + ;
                        "Deseja CANCELAR esta baixa normal para que voce possa realizar a Compensacao?", "Saldo de PA Disponivel")
                lRet := .F. 
            EndIf
        EndIf
        
        (cAliasTmp)->(DbCloseArea())
    EndIf
    
Return lRet
