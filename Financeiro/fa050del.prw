#Include "Totvs.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} ContratosAlg
Exclusão de titulo deve também refletir em ZX5 e ZX6.

@author Alex da Silva
@since  14/07/2026
/*/

*************************
User Function FA050Del()
*************************

    Local lRet       := .T.
    Local cAliasZX5  := GetNextAlias()
    Local cAliasZX6  := GetNextAlias()
    Local cQuery     := ""
    Local nValAbater := 0
    Local lIsBlind   := IsBlind() 
    Local lDelFisico := .F.

    If SM0->M0_CODFIL != SE2->E2_FILORIG
        If !lIsBlind
            ApMsgStop("Titulo Pertence a Filial: "+SE2->E2_FILORIG+" Favor ent na filial original do titulo para exclusao! A exclusao nao sera finalizada.")    
        EndIf
        Return .F.
    Endif

    If lRet
        
        nValAbater := SE2->E2_VALOR
        If SE2->E2_TXMOEDA > 0
            nValAbater := Round(SE2->E2_VALOR / SE2->E2_TXMOEDA, 2)
        EndIf

        If !Empty(SE2->E2_ZZCONTR)
            
            cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX6, ZX6_TIPO FROM " + RetSqlName("ZX6") + " "
            cQuery += "WHERE ZX6_CODIGO = '" + AllTrim(SE2->E2_ZZCONTR) + "' "
            cQuery += "AND ZX6_FORNEC = '" + SE2->E2_FORNECE + "' AND ZX6_LOJA = '" + SE2->E2_LOJA + "' "
            cQuery += "AND D_E_L_E_T_ = ' '"
            cQuery := ChangeQuery(cQuery)
            DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZX6, .F., .T. )
            
            If !(cAliasZX6)->(Eof())
                DbSelectArea("ZX6")
                ZX6->(DbGoTo((cAliasZX6)->RECNO_ZX6))
                
                RecLock("ZX6", .F.)
                
                If Upper(AllTrim(SE2->E2_TIPO)) == "PA"

                    ZX6->ZX6_SLDCES := Max(0, ZX6->ZX6_SLDCES - nValAbater)
                    
                    If lIsBlind
                        ZX6->ZX6_VLRCES := Max(0, ZX6->ZX6_VLRCES - nValAbater)
                    EndIf
                
                ElseIf AllTrim((cAliasZX6)->ZX6_TIPO) == "2"
                
                    ZX6->ZX6_SLDCES += nValAbater
                EndIf
                
                ZX6->(MsUnlock())
            EndIf
            (cAliasZX6)->(DbCloseArea())
        EndIf

        If !Empty(SE2->E2_ZZIDTIT)
            cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX5 FROM " + RetSqlName("ZX5") + " "
            cQuery += "WHERE ZX5_IDTIT = '" + AllTrim(SE2->E2_ZZIDTIT) + "' "
            cQuery += "AND D_E_L_E_T_ = ' '"
            
            cQuery := ChangeQuery(cQuery)
            DBUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasZX5, .F., .T. )

            If !(cAliasZX5)->(Eof())

                If lIsBlind
                    lDelFisico := .T. 
                Else
                    lDelFisico := MsgYesNo("Existe uma previsao atrelada a este documento." + CRLF + CRLF + "Deseja eliminar permanentemente essa previsao?", "Atencao")
                EndIf
                
                While !(cAliasZX5)->(Eof())
                    DbSelectArea("ZX5")
                    ZX5->(DbGoTo((cAliasZX5)->RECNO_ZX5))

                    RecLock("ZX5", .F.)
                    If lDelFisico
                        ZX5->(DbDelete())
                    Else
                        ZX5->ZX5_STATUS := "1" 
                    EndIf
                    ZX5->(MsUnlock())

                    (cAliasZX5)->(DbSkip())
                EndDo
            EndIf
            (cAliasZX5)->(DbCloseArea())
        EndIf
    EndIf

Return(lRet)
