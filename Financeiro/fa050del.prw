#Include "Totvs.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} ContratosAlg
Exclusão de titulo deve também refletir em ZX5, ZX6 e ZX3.

@author Alex da Silva
@since  14/07/2026
/*/

*************************
User Function FA050Del()
*************************

    Local lRet       := .T.
    Local cAliasZX5  := GetNextAlias()
    Local cAliasZX3  := GetNextAlias()
    Local cAliasZX6  := GetNextAlias()
    Local cQuery     := ""
    Local nValAbater := 0
    Local nCalcPerc  := 0

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Declaracao de Variaveis e Validacao Inicial                         ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    If SM0->M0_CODFIL != SE2->E2_FILORIG
        ApMsgStop("Titulo Pertence a Filial: "+SE2->E2_FILORIG+" Favor entrar na filial original do titulo para exclusão! A exclusão não será finalizada. Obrigado!")    
        lRet := .F.
    Endif

    If lRet
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ 1. DEVOLUÇÃO DO SALDO PARA O CONTRATO (ZX3) E CEDENTE (ZX6)         ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !Empty(SE2->E2_ZZCONTR)
            
            // Define o valor a devolver (Converte para Dólar se o título tiver taxa)
            nValAbater := SE2->E2_VALOR
            If SE2->E2_TXMOEDA > 0
                nValAbater := Round(SE2->E2_VALOR / SE2->E2_TXMOEDA, 2)
            EndIf
            
            // 1.1 Devolve saldo para o Parceiro (ZX6), se for o caso
            cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX6 FROM " + RetSqlName("ZX6") + " "
            cQuery += "WHERE ZX6_CODIGO = '" + AllTrim(SE2->E2_ZZCONTR) + "' "
            cQuery += "AND ZX6_FORNEC = '" + SE2->E2_FORNECE + "' AND ZX6_LOJA = '" + SE2->E2_LOJA + "' "
            cQuery += "AND D_E_L_E_T_ = ' '"
            cQuery := ChangeQuery(cQuery)
            DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZX6, .F., .T. )
            
            If !(cAliasZX6)->(Eof())
                DbSelectArea("ZX6")
                ZX6->(DbGoTo((cAliasZX6)->RECNO_ZX6))
                RecLock("ZX6", .F.)
                ZX6->ZX6_SLDCES += nValAbater
                ZX6->(MsUnlock())
            EndIf
            (cAliasZX6)->(DbCloseArea())

            // 1.2 Devolve saldo para o Titular do Contrato (ZX3)
            cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX3, ZX3_VLRTOT FROM " + RetSqlName("ZX3") + " "
            cQuery += "WHERE ZX3_CODIGO = '" + AllTrim(SE2->E2_ZZCONTR) + "' AND D_E_L_E_T_ = ' '"
            cQuery := ChangeQuery(cQuery)
            DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZX3, .F., .T. )

            If !(cAliasZX3)->(Eof())
                DbSelectArea("ZX3")
                ZX3->(DbGoTo((cAliasZX3)->RECNO_ZX3))
                RecLock("ZX3", .F.)
                ZX3->ZX3_SALDO += nValAbater
                
                // Recalcula a porcentagem matemática exata
                If ZX3->ZX3_VLRTOT > 0 
                    nCalcPerc := Round((ZX3->ZX3_SALDO / ZX3->ZX3_VLRTOT) * 100, 2)
                    ZX3->ZX3_SLDPER := nCalcPerc
                Else
                    ZX3->ZX3_SLDPER := 0
                EndIf
                ZX3->(MsUnlock())
            EndIf
            (cAliasZX3)->(DbCloseArea())
        EndIf

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ 2. TRATAMENTO DA PREVISÃO DO TÍTULO (ZX5) VIA ID DE INTEGRAÇÃO      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If !Empty(SE2->E2_ZZIDTIT)
            cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX5 FROM " + RetSqlName("ZX5") + " "
            cQuery += "WHERE ZX5_IDTIT = '" + AllTrim(SE2->E2_ZZIDTIT) + "' "
            cQuery += "AND D_E_L_E_T_ = ' '"
            
            cQuery := ChangeQuery(cQuery)
            DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZX5, .F., .T. )

            If !(cAliasZX5)->(Eof())
                
                // Pergunta ao usuário se ele quer excluir a previsão
                If MsgYesNo("Existe uma previsão de título atrelada a este documento na rotina de Contratos de Algodão." + CRLF + CRLF + "Deseja eliminar permanentemente essa previsão da base de dados?", "Atenção - Previsão de Contrato")
                    
                    // Usuário clicou em SIM: Exclusão Física
                    While !(cAliasZX5)->(Eof())
                        DbSelectArea("ZX5")
                        ZX5->(DbGoTo((cAliasZX5)->RECNO_ZX5))

                        RecLock("ZX5", .F.)
                        ZX5->(DbDelete())
                        ZX5->(MsUnlock())

                        (cAliasZX5)->(DbSkip())
                    EndDo
                Else
                    
                    // Usuário clicou em NÃO: Volta o status para Pendente
                    While !(cAliasZX5)->(Eof())
                        DbSelectArea("ZX5")
                        ZX5->(DbGoTo((cAliasZX5)->RECNO_ZX5))

                        RecLock("ZX5", .F.)
                        ZX5->ZX5_STATUS := "1" // Volta a ficar disponível para geração
                        ZX5->(MsUnlock())

                        (cAliasZX5)->(DbSkip())
                    EndDo
                EndIf
            EndIf
            
            (cAliasZX5)->(DbCloseArea())
        EndIf
    EndIf

Return(lRet)
