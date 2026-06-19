#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} ContratosAlg
Serviço REST para Gestão de Contratos do Algodão (Tabela ZX3).

@author Alex da Silva
@since  22/05/2026
/*/

WSRESTFUL ContratosAlg DESCRIPTION "Serviço REST dos Contratos do Algodao"
    
    WSDATA id AS STRING 

    WSMETHOD POST IncluirContrato ;
        DESCRIPTION "Incluir Contrato do Algodao" ;
        WSSYNTAX "/edf/v1/ContratosAlg/IncluirContrato" ;
        PATH "/edf/v1/ContratosAlg/IncluirContrato" ;
        PRODUCES APPLICATION_JSON

    WSMETHOD PUT AlterarContrato ; 
        DESCRIPTION "Alterar Contrato do Algodao" ;
        WSSYNTAX "/edf/v1/ContratosAlg/AlterarContrato" ;
        PATH "/edf/v1/ContratosAlg/AlterarContrato" ;
        PRODUCES APPLICATION_JSON

    WSMETHOD DELETE ExcluirContrato ; 
        DESCRIPTION "Excluir Contrato do Algodao" ;
        WSSYNTAX "/edf/v1/ContratosAlg/ExcluirContrato" ;
        PATH "/edf/v1/ContratosAlg/ExcluirContrato" ;
        PRODUCES APPLICATION_JSON

END WSRESTFUL

// =========================================================================
// INCLUSÃO (POST)
// =========================================================================
WSMETHOD POST IncluirContrato WSSERVICE ContratosAlg            
    Local lRet       := .T.
    Local cJson      := Self:GetContent()
    Local cError     := ""
    Local oJsonReq   := JsonObject():New()
    Local oJsonRet   := JsonObject():New()
    Local aRetMov    := {}
        
    FWLogMsg("INFO",, "ContratosAlg", "IncluirContrato", "", "01", "Inicio da Inclusao")  
    Self:SetContentType('application/json')

    cError := oJsonReq:FromJson(cJson)
    
    If !Empty(cError)
        Self:setStatus(400)
        Self:SetResponse('{"STATUS_CODE":"400" , "MENSAGEM":"Parser Json Error. Verifique a estrutura."}')
        lRet := .F.
    Else
        aRetMov := gravaDados(oJsonReq)
        lRet    := aRetMov[1]
        
        If lRet
            Self:SetResponse(EncodeUTF8(aRetMov[2]))
        Else
            Self:setStatus(400)
            Self:SetResponse(EncodeUTF8(aRetMov[2]))
        EndIf
    EndIf
    
    FreeObj(oJsonReq)
    FreeObj(oJsonRet)
Return lRet

/*
    Função de Gravação na ZX3/ZX6 utilizando RecLock e Validação Relacional
*/
Static Function gravaDados(oJsonReq)   
    Local nRecord   := 0
    Local nParc     := 0
    Local oJsonRet  := JsonObject():New()
    Local aRetIncs  := {}
    Local oItemRet  
    Local oItemReq
    Local oParceiro  
    Local cMsgError := ""
    Local cFilTit   := ""
    Local lRet      := .T.  


    If oJsonReq['CONTRATOS'] != Nil .And. ValType(oJsonReq['CONTRATOS']) == "A"
        
        DbSelectArea("ZX3")
        ZX3->(DbSetOrder(1))

        For nRecord := 1 To Len(oJsonReq:GetJsonObject("CONTRATOS"))
            cMsgError := ""
            oItemRet  := JsonObject():New()
            oItemReq  := oJsonReq:GetJsonObject("CONTRATOS")[nRecord]

            If oItemReq['FILIAL_TITULO'] == Nil .Or. Empty(oItemReq['FILIAL_TITULO']) .Or. ;
               oItemReq['CODIGO'] == Nil .Or. Empty(oItemReq['CODIGO'])
                cMsgError := "As chaves FILIAL_TITULO e CODIGO sao obrigatorias."
            Else

                IF Alltrim(oItemReq['FILIAL_TITULO']) = '01'
                        cFilTit:= '0101'
                ElseIF Alltrim(oItemReq['FILIAL_TITULO'])  = '10'
                        cFilTit:= '0110'
                ElseIF Alltrim(oItemReq['FILIAL_TITULO'])  = '09'
                        cFilTit:= '0109'
                ElseIF Alltrim(oItemReq['FILIAL_TITULO'])  = '13'
                        cFilTit:= '0113'
                ElseIF Alltrim(oItemReq['FILIAL_TITULO'])  = '11'
                        cFilTit:= '0111'    
                Else
                    cMsgError := "FILIAL_TITULO invalida."
                    lRet := .F.
                EndIf

                IF lRet
                    // Verifica se o contrato já existe para não duplicar
                    If ZX3->(DbSeek(cFilTit + PadR(oItemReq['CODIGO'], TamSx3("ZX3_CODIGO")[1])))
                        cMsgError := "Contrato ja cadastrado na base de dados."
                        lRet := .F.
                    Else
                        Begin Transaction
                        

                            RecLock("ZX3", .T.) 
                            
                            ZX3->ZX3_FILIAL := cFilTit
                            ZX3->ZX3_CODIGO := PadR(upper(oItemReq['CODIGO'])       , TamSx3("ZX3_CODIGO")[1])
                            
                            If oItemReq['FORNECEDOR'] != nil
                                DbSelectArea("SA2")
                                SA2->(DbSetOrder(12))   
                                If SA2->(DbSeek(xFilial("SA2") + oItemReq['FORNECEDOR']))
                                    ZX3->ZX3_FORNEC := SA2->A2_COD
                                    ZX3->ZX3_LOJA   := SA2->A2_LOJA
                                    ZX3->ZX3_NOMFOR	:= SA2->A2_NOME
                                EndIf
                            EndIf

                            iif(oItemReq['DATAINICIO']     != nil, ZX3->ZX3_DATA   := sToD(oItemReq['DATAINICIO'])            , nil)
                            iif(oItemReq['DATAFIM']        != nil, ZX3->ZX3_VIGENC := sToD(oItemReq['DATAFIM'])               , nil)
                            iif(oItemReq['CONDPAGAMENTO']  != nil, ZX3->ZX3_CONDPG := upper(oItemReq['CONDPAGAMENTO'])        , nil)
                            iif(oItemReq['MOEDA']          != nil, ZX3->ZX3_MOEDA  := upper(oItemReq['MOEDA'])                , nil)
                            iif(oItemReq['MOEDAPAGAMENTO'] != nil, ZX3->ZX3_MOEPG  := upper(oItemReq['MOEDAPAGAMENTO'])       , nil)

                            If oItemReq['PRODUTO'] != nil
                                DbSelectArea("SB1")
                                SB1->(DbSetOrder(1))   
                                If SB1->(DbSeek(xFilial("SB1") + Alltrim(oItemReq['PRODUTO'])))
                                    ZX3->ZX3_PROUTO 	:= SB1->B1_COD
                                    ZX3->ZX3_PRODES   	:= SB1->B1_DESC
                                EndIf
                            EndIf

                            iif(oItemReq['UM']             != nil, ZX3->ZX3_UM     := upper(oItemReq['UM'])                   , nil)
                            iif(oItemReq['TIPOCONTRATO']   != nil, ZX3->ZX3_TIPOCO := upper(oItemReq['TIPOCONTRATO'])         , nil)
                            iif(oItemReq['QUANTIDADE']     != nil, ZX3->ZX3_QUANTI := val(cValToChar(oItemReq['QUANTIDADE'])) , nil)
                            iif(oItemReq['VALORUNITARIO']  != nil, ZX3->ZX3_VALOR  := val(cValToChar(oItemReq['VALORUNITARIO'])), nil)
                            iif(oItemReq['VALORTOTAL']     != nil, ZX3->ZX3_VLRTOT := val(cValToChar(oItemReq['VALORTOTAL'])) , nil)
                            iif(oItemReq['VALORTOTAL']     != nil, ZX3->ZX3_SALDO  := val(cValToChar(oItemReq['VALORTOTAL'])) , nil)
                            ZX3->ZX3_SLDPER := 100
                            ZX3->ZX3_BLQPAG := 1
                            iif(oItemReq['COTACAOFIXA']    != nil, ZX3->ZX3_COTAFI := val(cValToChar(oItemReq['COTACAOFIXA'])), nil)

                            ZX3->(MsUnlock())
                            
                            If oItemReq['PARCEIROS'] != Nil .And. ValType(oItemReq['PARCEIROS']) == "A"
                                For nParc := 1 To Len(oItemReq:GetJsonObject("PARCEIROS"))
                                    oParceiro := oItemReq:GetJsonObject("PARCEIROS")[nParc]
                                    
                                    If oParceiro['CODPAR'] != Nil
                                        RecLock("ZX6", .T.)
                                        
                                        ZX6->ZX6_FILIAL := cFilTit  
                                        ZX6->ZX6_CODIGO := PadR(upper(oItemReq['CODIGO'])       , TamSx3("ZX6_CODIGO")[1])
                                        ZX6->ZX6_ITEM   := StrZero(nParc, TamSx3("ZX6_ITEM")[1])
                                        
                                        DbSelectArea("SA2")
                                        SA2->(DbSetOrder(12)) 
                                        If SA2->(DbSeek(xFilial("SA2") + oParceiro['CODPAR']))
                                            ZX6->ZX6_FORNEC := SA2->A2_COD
                                            ZX6->ZX6_LOJA   := SA2->A2_LOJA
                                            ZX6->ZX6_NOMFOR := SA2->A2_NOME
                                        Else
                                            ZX6->ZX6_FORNEC := PadR(oParceiro['CODPAR'], TamSx3("ZX6_FORNEC")[1])
                                        EndIf
                                        
                                        ZX6->(MsUnlock())
                                    EndIf
                                Next nParc
                            EndIf

                        End Transaction
                    EndIF
                EndIf
            EndIf
            
            If Empty(cMsgError)
                oItemRet['STATUS_CODE'] := "200"
                oItemRet['MENSAGEM']    := "Contrato e Parceiros incluidos com sucesso."
            Else
                oItemRet['STATUS_CODE'] := "400"
                oItemRet['MENSAGEM']    := cMsgError
                lRet := .F.
            EndIf
            
            oItemRet['FILIAL_TITULO'] := IIf(oItemReq['FILIAL_TITULO'] != Nil, oItemReq['FILIAL_TITULO'] , "")
            oItemRet['CODIGO']        := IIf(oItemReq['CODIGO']        != Nil, oItemReq['CODIGO']        , "")
            
            AAdd(aRetIncs, oItemRet)
        Next nRecord

        oJsonRet['RETORNO_INCLUSAO'] := aRetIncs
    Else
        lRet := .F.
        Self:setStatus(400)
        oJsonRet:Set("MENSAGEM", "A tag principal [CONTRATOS] nao foi encontrada ou nao e um Array.")
    EndIf

Return {lRet, oJsonRet:ToJson()}


// =========================================================================
// ALTERAÇÃO (PUT) POR CODIGO DO CONTRATO
// =========================================================================
WSMETHOD PUT AlterarContrato WSRECEIVE id WSSERVICE ContratosAlg
    Local lRet       := .T.
    Local cJson      := Self:GetContent()
    Local oJsonReq   := JsonObject():New()
    Local oJsonRet   := JsonObject():New()
    Local oItemReq
    Local oParceiro
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()
    Local cQueryZX6  := ""
    Local cAliasZX6  := GetNextAlias()
    Local nParc      := 0

    FWLogMsg("INFO",, "ContratosAlg", "AlterarContrato", "", "01", "Inicio da Alteracao CODIGO: " + cValToChar(::id))
    Self:SetContentType('application/json')

    If Empty(::id)
        Self:setStatus(400)
        Self:SetResponse('{"STATUS_CODE":"400", "MENSAGEM":"CODIGO do contrato nao informado na URL."}')
        Return .F.
    EndIf

    If !Empty(cJson) .And. !Empty(oJsonReq:FromJson(cJson))
        Self:setStatus(400)
        Self:SetResponse('{"STATUS_CODE":"400", "MENSAGEM":"Parser Json Error. Estrutura invalida."}')
        Return .F.
    EndIf

    If oJsonReq['CONTRATOS'] != Nil .And. ValType(oJsonReq['CONTRATOS']) == "A" .And. Len(oJsonReq:GetJsonObject("CONTRATOS")) > 0
        oItemReq := oJsonReq:GetJsonObject("CONTRATOS")[1]
    Else
        oItemReq := oJsonReq 
    EndIf

    cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX3, ZX3_FILIAL, ZX3_CODIGO "
    cQuery += "FROM " + RetSqlName("ZX3") + " ZX3 "
    cQuery += "WHERE ZX3_CODIGO = '" + ::id + "' "
    cQuery += "AND D_E_L_E_T_ = ' ' "
    
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias (cAlias)
    (cAlias)->(DbGoTop())

    If !(cAlias)->(Eof())
        DbSelectArea("ZX3")
        ZX3->(DbGoTo((cAlias)->RECNO_ZX3))

        Begin Transaction
            
            RecLock("ZX3", .F.) 
            
            If oItemReq['FORNECEDOR'] != nil
                DbSelectArea("SA2")
                SA2->(DbSetOrder(12))   
                If SA2->(DbSeek(xFilial("SA2") + oItemReq['FORNECEDOR']))
                    ZX3->ZX3_FORNEC := SA2->A2_COD
                    ZX3->ZX3_LOJA   := SA2->A2_LOJA
                    ZX3->ZX3_NOMFOR := SA2->A2_NOME
                EndIf
            EndIf

            If oItemReq['PRODUTO'] != nil
                DbSelectArea("SB1")
                SB1->(DbSetOrder(1))   
                If SB1->(DbSeek(xFilial("SB1") + oItemReq['PRODUTO']))
                    ZX3->ZX3_PROUTO     := SB1->B1_COD
                    ZX3->ZX3_PRODES     := SB1->B1_DESC
                EndIf
            EndIf


            iif(oItemReq['DATAINICIO']     != nil, ZX3->ZX3_DATA   := sToD(oItemReq['DATAINICIO'])            , nil)
            iif(oItemReq['DATAFIM']        != nil, ZX3->ZX3_VIGENC := sToD(oItemReq['DATAFIM'])               , nil)
            iif(oItemReq['CONDPAGAMENTO']  != nil, ZX3->ZX3_CONDPG := upper(oItemReq['CONDPAGAMENTO'])        , nil)
            iif(oItemReq['MOEDA']          != nil, ZX3->ZX3_MOEDA  := upper(oItemReq['MOEDA'])                , nil)
            iif(oItemReq['MOEDAPAGAMENTO'] != nil, ZX3->ZX3_MOEPG  := upper(oItemReq['MOEDAPAGAMENTO'])       , nil)
            iif(oItemReq['UM']             != nil, ZX3->ZX3_UM     := upper(oItemReq['UM'])                   , nil)
            iif(oItemReq['TIPOCONTRATO']   != nil, ZX3->ZX3_TIPOCO := upper(oItemReq['TIPOCONTRATO'])         , nil)
            iif(oItemReq['QUANTIDADE']     != nil, ZX3->ZX3_QUANTI := val(cValToChar(oItemReq['QUANTIDADE'])) , nil)
            iif(oItemReq['VALORUNITARIO']  != nil, ZX3->ZX3_VALOR  := val(cValToChar(oItemReq['VALORUNITARIO'])), nil)
            iif(oItemReq['VALORTOTAL']     != nil, ZX3->ZX3_VLRTOT := val(cValToChar(oItemReq['VALORTOTAL'])) , nil)
            iif(oItemReq['COTACAOFIXA']    != nil, ZX3->ZX3_COTAFI := val(cValToChar(oItemReq['COTACAOFIXA'])), nil)

            ZX3->(MsUnlock())


            If oItemReq['PARCEIROS'] != Nil .And. ValType(oItemReq['PARCEIROS']) == "A"
                

                cQueryZX6 := "SELECT R_E_C_N_O_ AS RECNO_ZX6 FROM " + RetSqlName("ZX6") + " "
                cQueryZX6 += "WHERE ZX6_CODIGO = '" + ZX3->ZX3_CODIGO + "' AND ZX6_FILIAL = '" + ZX3->ZX3_FILIAL + "' AND D_E_L_E_T_ = ' ' "
                cQueryZX6 := ChangeQuery(cQueryZX6)
                TCQuery cQueryZX6 New Alias (cAliasZX6)
                
                DbSelectArea("ZX6")
                While !(cAliasZX6)->(Eof())
                    ZX6->(DbGoTo((cAliasZX6)->RECNO_ZX6))
                    RecLock("ZX6", .F.)
                    ZX6->(DbDelete())
                    ZX6->(MsUnlock())
                    (cAliasZX6)->(DbSkip())
                EndDo
                (cAliasZX6)->(DbCloseArea())

                For nParc := 1 To Len(oItemReq:GetJsonObject("PARCEIROS"))
                    oParceiro := oItemReq:GetJsonObject("PARCEIROS")[nParc]
                    
                    If oParceiro['CODPAR'] != Nil
                        RecLock("ZX6", .T.)
                        
                        ZX6->ZX6_FILIAL := ZX3->ZX3_FILIAL
                        ZX6->ZX6_CODIGO := ZX3->ZX3_CODIGO
                        ZX6->ZX6_ITEM   := StrZero(nParc, TamSx3("ZX6_ITEM")[1])
                        
                        DbSelectArea("SA2")
                        SA2->(DbSetOrder(12)) 
                        If SA2->(DbSeek(xFilial("SA2") + oParceiro['CODPAR']))
                            ZX6->ZX6_FORNEC := SA2->A2_COD
                            ZX6->ZX6_LOJA   := SA2->A2_LOJA
                            ZX6->ZX6_NOMFOR := SA2->A2_NOME
                        Else
                            ZX6->ZX6_FORNEC := PadR(oParceiro['CODPAR'], TamSx3("ZX6_FORNEC")[1])
                        EndIf
                        
                        ZX6->(MsUnlock())
                    EndIf
                Next nParc
            EndIf

        End Transaction

        oJsonRet['STATUS_CODE'] := "200"
        oJsonRet['MENSAGEM']    := "Contrato alterado com sucesso."

    Else
        Self:setStatus(404)
        oJsonRet['STATUS_CODE'] := "404"
        oJsonRet['MENSAGEM']    := "Contrato nao encontrado para alteracao com o CODIGO informado."
        lRet := .F.
    EndIf

    (cAlias)->(DbCloseArea())
    Self:SetResponse(EncodeUTF8(oJsonRet:ToJson()))
    FreeObj(oJsonReq)
    FreeObj(oJsonRet)
Return lRet


// =========================================================================
// EXCLUSÃO (DELETE) POR CODIGO DO CONTRATO
// =========================================================================
WSMETHOD DELETE ExcluirContrato WSRECEIVE id WSSERVICE ContratosAlg
    Local lRet       := .T.
    Local oJsonRet   := JsonObject():New()
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()
    Local cQueryZX6  := ""
    Local cAliasZX6  := GetNextAlias()

    FWLogMsg("INFO",, "ContratosAlg", "ExcluirContrato", "", "01", "Inicio da Exclusao CODIGO: " + cValToChar(::id))
    Self:SetContentType('application/json')

    If Empty(::id)
        Self:setStatus(400)
        Self:SetResponse('{"STATUS_CODE":"400", "MENSAGEM":"CODIGO do contrato nao informado na URL."}')
        Return .F.
    EndIf

    cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX3, ZX3_FILIAL, ZX3_CODIGO "
    cQuery += "FROM " + RetSqlName("ZX3") + " ZX3 "
    cQuery += "WHERE ZX3_CODIGO = '" + ::id + "' "
    cQuery += "AND D_E_L_E_T_ = ' ' "
    
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias (cAlias)
    (cAlias)->(DbGoTop())

    If !(cAlias)->(Eof())
        
        Begin Transaction

            DbSelectArea("ZX3")
            ZX3->(DbGoTo((cAlias)->RECNO_ZX3))
            
            RecLock("ZX3", .F.)
            ZX3->(DbDelete())
            ZX3->(MsUnlock())


            cQueryZX6 := "SELECT R_E_C_N_O_ AS RECNO_ZX6 FROM " + RetSqlName("ZX6") + " "
            cQueryZX6 += "WHERE ZX6_CODIGO = '" + ZX3->ZX3_CODIGO + "' AND ZX6_FILIAL = '" + ZX3->ZX3_FILIAL + "' AND D_E_L_E_T_ = ' ' "
            cQueryZX6 := ChangeQuery(cQueryZX6)
            TCQuery cQueryZX6 New Alias (cAliasZX6)
            
            DbSelectArea("ZX6")
            While !(cAliasZX6)->(Eof())
                ZX6->(DbGoTo((cAliasZX6)->RECNO_ZX6))
                RecLock("ZX6", .F.)
                ZX6->(DbDelete())
                ZX6->(MsUnlock())
                (cAliasZX6)->(DbSkip())
            EndDo
            (cAliasZX6)->(DbCloseArea())

        End Transaction

        oJsonRet['STATUS_CODE'] := "200"
        oJsonRet['MENSAGEM']    := "Contrato e parceiros vinculados excluidos com sucesso."
    Else
        Self:setStatus(404)
        oJsonRet['STATUS_CODE'] := "404"
        oJsonRet['MENSAGEM']    := "Contrato nao encontrado para exclusao."
        lRet := .F.
    EndIf

    (cAlias)->(DbCloseArea())
    Self:SetResponse(EncodeUTF8(oJsonRet:ToJson()))
    FreeObj(oJsonRet)
Return lRet
