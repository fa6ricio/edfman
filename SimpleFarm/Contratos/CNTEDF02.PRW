#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} ContasPagar
Serviço REST para Gestão de Títulos a Pagar.

@author Alex da Silva
@since  21/05/2026
/*/

WSRESTFUL ContasPagar DESCRIPTION "Serviço REST dos Títulos a Pagar"
    
    WSDATA id AS STRING 

    WSMETHOD POST IncluiPagar ;
        DESCRIPTION "Incluir os Títulos a Pagar" ;
        WSSYNTAX "/edf/v1/ContasPagar/IncluiPagar" ;
        PATH "/edf/v1/ContasPagar/IncluiPagar" ;
        PRODUCES APPLICATION_JSON

    WSMETHOD PUT AlterarTitulo ; 
        DESCRIPTION "Alterar Titulo Financeiro" ;
        WSSYNTAX "/edf/v1/ContasPagar/AlterarTitulo" ;
        PATH "/edf/v1/ContasPagar/AlterarTitulo" ;
        PRODUCES APPLICATION_JSON

    WSMETHOD DELETE ExcluirTitulo ; 
        DESCRIPTION "Excluir Titulo Financeiro" ;
        WSSYNTAX "/edf/v1/ContasPagar/ExcluirTitulo" ;
        PATH "/edf/v1/ContasPagar/ExcluirTitulo" ;
        PRODUCES APPLICATION_JSON

    WSMETHOD GET ConsultarExclusao ;
        DESCRIPTION "Consultar se titulo pode ser excluido" ;
        WSSYNTAX "/edf/v1/ContasPagar/ConsultarExclusao/{id}" ;
        PATH "/edf/v1/ContasPagar/ConsultarExclusao" ;
        PRODUCES APPLICATION_JSON

END WSRESTFUL

// =========================================================================
// INCLUSÃO (POST)
// =========================================================================
WSMETHOD POST IncluiPagar WSSERVICE ContasPagar             
    Local lRet       := .T.
    Local cJson      := Self:GetContent()
    Local cError     := ""
    Local oJsonReq   := JsonObject():New()
    Local oJsonRet   := JsonObject():New()
    Local aRetMov    := {}
        
    FWLogMsg("INFO",, "ContasPagar", "IncluiPagar", "", "01", "Inicio da Inclusao")  
    Self:SetContentType('application/json')

    cError := oJsonReq:FromJson(cJson)
    
    If !Empty(cError)
        Self:setStatus(400)
        Self:SetResponse('{"errorCode":"400" , "errorMessage":"Parser Json Error. Verifique a estrutura."}')
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
    Função com Array Dinâmico e Prevenção Nativa de Crash
*/
Static Function gravaDados(oJsonReq)   
    Local nRecord   := 0
    Local oJsonRet  := JsonObject():New()
    Local aRetIncs  := {}
    Local oItemRet  
    Local oItemReq  
    Local aVetSE2   := {}
    Local cMsgError := ""
    Local lRet      := .T.  
    Local cNatureza := getMv('MV_ZZNTDUP')

    // Variáveis Privadas obrigatórias para o ExecAuto funcionar perfeitamente em background
    Private lAutoErrNoFile := .T. 
    Private lMsHelpAuto    := .T. 
    Private lMsErroAuto    := .F.

    // Verifica se a tag principal existe e é um array
    If oJsonReq['INCLUI_PAGAR'] != Nil .And. ValType(oJsonReq['INCLUI_PAGAR']) == "A"
        
        For nRecord := 1 To Len(oJsonReq:GetJsonObject("INCLUI_PAGAR"))
            cMsgError := ""
            oItemRet  := JsonObject():New()
            aVetSE2   := {}
            
            // Isola o item atual do array
            oItemReq  := oJsonReq:GetJsonObject("INCLUI_PAGAR")[nRecord]
            
            // Validação de chave obrigatória primária
            If oItemReq['FILIAL_TITULO'] == Nil .Or. Empty(oItemReq['FILIAL_TITULO'])
                cMsgError := "A Filial do titulo e obrigatoria e nao foi informada."
            Else
                AAdd(aVetSE2, {"E2_FILIAL", oItemReq['FILIAL_TITULO'], Nil})
                // Dados principais do Titulo
                iif(oItemReq['NUMERO_TITULO']           != nil  ,aAdd(aVetSE2,{'E2_NUM'     ,upper(oItemReq:numero_titulo)     ,NIL}),nil)
                iif(oItemReq['PREFIXO_TITULO']          != nil  ,aAdd(aVetSE2,{'E2_PREFIXO' ,upper(oItemReq:prefixo_titulo)    ,NIL}),nil)
                iif(oItemReq['PARCELA_TITULO']          != nil  ,aAdd(aVetSE2,{'E2_PARCELA' ,upper(oItemReq:parcela_titulo)    ,NIL}),nil)
                iif(oItemReq['TIPO_TITULO']             != nil  ,aAdd(aVetSE2,{'E2_TIPO'    ,upper(oItemReq:tipo_titulo)       ,NIL}),nil)
                iif(oItemReq['NATUREZA']                != nil  ,aAdd(aVetSE2,{'E2_NATUREZ' ,upper(oItemReq:natureza)          ,NIL}), aAdd(aVetSE2,{'E2_NATUREZ' ,cNatureza, NIL}))
                
                If oItemReq['FORNECEDOR'] != nil
                    dbSelectarea("SA2")
                    dbSetOrder(12)   
                    If dbseek(xFilial("SA2")+oItemReq['FORNECEDOR'])
                       aAdd(aVetSE2,{'E2_FORNECE' ,SA2->A2_COD ,NIL})
                       aAdd(aVetSE2,{'E2_LOJA' ,SA2->A2_LOJA,NIL})
                    EndIf
                Endif

                iif(oItemReq['DATA_EMISSAO']            != nil  ,aAdd(aVetSE2,{'E2_EMISSAO' ,sToD(oItemReq:data_emissao)     ,NIL}),nil)
                iif(oItemReq['DATA_VENCIMENTO']         != nil  ,aAdd(aVetSE2,{'E2_VENCTO'  ,sToD(oItemReq:data_vencimento)  ,NIL}),nil)
                iif(oItemReq['DATA_VENCIMENTO']         != nil  ,aAdd(aVetSE2,{'E2_VENCREA' ,sToD(oItemReq:data_vencimento)  ,NIL}),nil)
                iif(oItemReq['FORMAPAGAMENTO']          != nil  ,aAdd(aVetSE2,{'E2_FORMPAG' ,oItemReq:formaPagamento    ,NIL}),nil)
                iif(oItemReq['VALOR_TITULO']            != nil  ,aAdd(aVetSE2,{'E2_VALOR'   ,val(cValToChar(oItemReq:valor_titulo)),NIL}),nil)
                iif(oItemReq['VALOR_TITULO']            != nil  ,aAdd(aVetSE2,{'E2_VLCRUZ'  ,val(cValToChar(oItemReq:valor_titulo)),NIL}),nil) 
                iif(oItemReq['MOEDA']                   != nil  ,aAdd(aVetSE2,{'E2_MOEDA'   ,val(cValToChar(oItemReq:moeda)),NIL}),nil)
                iif(oItemReq['PTAX']                    != nil  ,aAdd(aVetSE2,{'E2_TXMOEDA'   ,val(cValToChar(oItemReq:ptax)),NIL}),nil)
                iif(oItemReq['HISTORICO']               != nil  ,aAdd(aVetSE2,{'E2_HIST'    ,upper(oItemReq:historico)  ,NIL}),nil)
                iif(oItemReq['ID_TITULO']               != nil, aAdd(aVetSE2,{'E2_ZZIDTIT'   ,upper(oItemReq['ID_TITULO'])       ,NIL}), nil)
                iif(oItemReq['OPERACAO']                != nil, aAdd(aVetSE2,{'E2_ZZOPERA'   ,upper(oItemReq['OPERACAO'])        ,NIL}), nil)
                iif(oItemReq['NUMERO_CONTRATO']         != nil, aAdd(aVetSE2,{'E2_ZZCONTR'  ,upper(oItemReq['NUMERO_CONTRATO']) ,NIL}), nil)
                // Dados Bancários
                iif(oItemReq['BANCO']                   != nil  ,aAdd(aVetSE2,{'E2_FORBCO'  ,upper(oItemReq:banco)      ,NIL}),nil)
                iif(oItemReq['AGENCIA']                 != nil  ,aAdd(aVetSE2,{'E2_FORAGE'  ,upper(oItemReq:agencia)    ,NIL}),nil)
                iif(oItemReq['CONTA']                   != nil  ,aAdd(aVetSE2,{'E2_FORCTA'  ,upper(oItemReq:conta)      ,NIL}),nil)
                iif(oItemReq['DIGITOCONTA']             != nil  ,aAdd(aVetSE2,{'E2_FCTADV'  ,upper(oItemReq:digitoConta),NIL}),nil)
                iif(oItemReq['DIGITOAGENCIA']           != nil  ,aAdd(aVetSE2,{'E2_FAGEDV'  ,upper(oItemReq:digitoAgencia),NIL}),nil)

                                    
                Begin Transaction
                        lMsErroAuto := .F.
                        MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aVetSE2,, 3)
                        
                        If lMsErroAuto
                            cMsgError := TrataLog(GetAutoGRLog())
                            DisarmTransaction()
                        EndIf
                End Transaction
            EndIf
            
            // Monta o retorno isolado do item
            If Empty(cMsgError)
                oItemRet['STATUS_CODE'] := "200"
                oItemRet['MENSAGEM']    := "Titulo incluido com sucesso."
            Else
                oItemRet['STATUS_CODE'] := "400"
                oItemRet['MENSAGEM']    := cMsgError
                lRet := .F.
            EndIf
            
            // Feedback dos dados base que foram tentados 
            oItemRet['FILIAL_TITULO']       := IIf(oItemReq['FILIAL_TITULO']    != Nil, oItemReq['FILIAL_TITULO']   , "")
            oItemRet['NUMERO_TITULO']       := IIf(oItemReq['NUMERO_TITULO']    != Nil, oItemReq['NUMERO_TITULO']   , "")
            oItemRet['PREFIXO_TITULO']      := IIf(oItemReq['PREFIXO_TITULO']   != Nil, oItemReq['PREFIXO_TITULO']  , "")
            oItemRet['ID_TITULO']           := IIf(oItemReq['ID_TITULO']        != Nil, oItemReq['ID_TITULO']       , "")
            
            AAdd(aRetIncs, oItemRet)
        Next nRecord

        oJsonRet['RETORNO_INCLUSAO'] := aRetIncs
    Else
        lRet := .F.
        Self:setStatus(400)
        oJsonRet:Set("errorMessage", "A tag principal [INCLUI_PAGAR] nao foi encontrada ou nao e um Array.")
    EndIf

Return {lRet, oJsonRet:ToJson()}

/*
    Função Helper para tratar o Array de Erros do ExecAuto e formatar para o JSON
*/
Static Function TrataLog(aLog)
    Local nX     := 0
    Local cErros := ""

    If ValType(aLog) == "A"
        For nX := 1 To Len(aLog)
            cErros += StrTran(aLog[nX], CRLF, " ") + " | "
        Next nX
        
        If Right(cErros, 3) == " | "
            cErros := SubStr(cErros, 1, Len(cErros) - 3)
        EndIf
    Else
        cErros := "Falha desconhecida no ExecAuto. Log indisponível."
    EndIf
    
Return cErros

// =========================================================================
// ALTERAÇÃO (PUT) POR ID_TITULO 
// =========================================================================
WSMETHOD PUT AlterarTitulo WSRECEIVE id WSSERVICE ContasPagar
    Local lRet       := .T.
    Local cJson      := Self:GetContent()
    Local oJsonReq   := JsonObject():New()
    Local oJsonRet   := JsonObject():New()
    Local aVetSE2    := {}
    Local cMsgError  := ""
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()

    // Variáveis Privadas obrigatórias
    Private lAutoErrNoFile := .T.
    Private lMsHelpAuto    := .T.
    Private lMsErroAuto    := .F.

    FWLogMsg("INFO",, "ContasPagar", "AlterarTitulo", "", "01", "Inicio da Alteracao ID_TITULO: " + cValToChar(::id))
    Self:SetContentType('application/json')

    If Empty(::id)
        Self:setStatus(400)
        Self:SetResponse('{"STATUS_CODE":"400", "MENSAGEM":"ID_TITULO nao informado na URL."}')
        Return .F.
    EndIf

    If !Empty(cJson) .And. !Empty(oJsonReq:FromJson(cJson))
        Self:setStatus(400)
        Self:SetResponse('{"STATUS_CODE":"400", "MENSAGEM":"Parser Json Error. Estrutura invalida."}')
        Return .F.
    EndIf

    // Busca o RECNO do título utilizando a chave externa (E2_XIDSP)
    cQuery := "SELECT R_E_C_N_O_ AS RECNO_SE2 "
    cQuery += "FROM " + RetSqlName("SE2") + " SE2 "
    cQuery += "WHERE E2_ZZIDTIT = '" + ::id  + "' "
    cQuery += "AND D_E_L_E_T_ = ' ' "
    
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias (cAlias)
    (cAlias)->(DbGoTop())

    If !(cAlias)->(Eof())
        DbSelectArea("SE2")
        // Posiciona a SE2 fisicamente, ignorando índices
        SE2->(DbGoTo((cAlias)->RECNO_SE2))

        // Chaves obrigatórias para o ExecAuto encontrar o registro posicionado
        AAdd(aVetSE2, {"E2_FILIAL" , SE2->E2_FILIAL , Nil})
        AAdd(aVetSE2, {"E2_PREFIXO", SE2->E2_PREFIXO, Nil})
        AAdd(aVetSE2, {"E2_NUM"    , SE2->E2_NUM    , Nil})
        AAdd(aVetSE2, {"E2_PARCELA", SE2->E2_PARCELA, Nil})
        AAdd(aVetSE2, {"E2_TIPO"   , SE2->E2_TIPO   , Nil})
        AAdd(aVetSE2, {"E2_FORNECE", SE2->E2_FORNECE, Nil})
        AAdd(aVetSE2, {"E2_LOJA"   , SE2->E2_LOJA   , Nil})

        // ARRAY DINÂMICO: Atualiza apenas o que vier no JSON de PUT
        If !Empty(cJson)
            iif(oJsonReq['NATUREZA']   != nil, aAdd(aVetSE2, {'E2_NATUREZ', upper(oJsonReq['NATUREZA'])  , NIL}), nil)
            iif(oJsonReq['DATA_VENCIMENTO'] != nil, aAdd(aVetSE2, {'E2_VENCTO' , sToD(oJsonReq['DATA_VENCIMENTO']) , NIL}), nil)
            iif(oJsonReq['DATA_VENCIMENTO'] != nil, aAdd(aVetSE2, {'E2_VENCREA', sToD(oJsonReq['DATA_VENCIMENTO']) , NIL}), nil)
            iif(oJsonReq['VALOR_TITULO']      != nil, aAdd(aVetSE2, {'E2_VALOR'  , val(cValToChar(oJsonReq['VALOR_TITULO'])), NIL}), nil)
            iif(oJsonReq['HISTORICO']  != nil, aAdd(aVetSE2, {'E2_HIST'   , upper(oJsonReq['HISTORICO']) , NIL}), nil)
            iif(oJsonReq['BANCO']      != nil, aAdd(aVetSE2, {'E2_FORBCO' , upper(oJsonReq['BANCO'])     , NIL}), nil)
            iif(oJsonReq['AGENCIA']    != nil, aAdd(aVetSE2, {'E2_FORAGE' , upper(oJsonReq['AGENCIA'])   , NIL}), nil)
            iif(oJsonReq['CONTA']      != nil, aAdd(aVetSE2, {'E2_FORCTA' , upper(oJsonReq['CONTA'])     , NIL}), nil)
        EndIf

        If Len(aVetSE2) > 7 
            Begin Transaction
                lMsErroAuto := .F.
                MsExecAuto({|x,y,z| FINA050(x,y,z)}, aVetSE2,, 4) // 4 = Alteração

                If lMsErroAuto
                    cMsgError := TrataLog(GetAutoGRLog())
                    DisarmTransaction()
                EndIf
            End Transaction

            If Empty(cMsgError)
                oJsonRet['STATUS_CODE'] := "200"
                oJsonRet['MENSAGEM']    := "Titulo alterado com sucesso."
            Else
                Self:setStatus(400)
                oJsonRet['STATUS_CODE'] := "400"
                oJsonRet['MENSAGEM']    := cMsgError
                lRet := .F.
            EndIf
        Else
            Self:setStatus(400)
            oJsonRet['STATUS_CODE'] := "400"
            oJsonRet['MENSAGEM']    := "Nenhum campo valido para alteracao foi enviado."
            lRet := .F.
        EndIf
    Else
        Self:setStatus(404)
        oJsonRet['STATUS_CODE'] := "404"
        oJsonRet['MENSAGEM']    := "Titulo nao encontrado para alteracao com o ID_TITULO informado."
        lRet := .F.
    EndIf

    (cAlias)->(DbCloseArea())
    Self:SetResponse(EncodeUTF8(oJsonRet:ToJson()))
    FreeObj(oJsonReq)
    FreeObj(oJsonRet)
Return lRet

// =========================================================================
// EXCLUSÃO (DELETE) POR ID_TITULO
// =========================================================================
WSMETHOD DELETE ExcluirTitulo WSRECEIVE id WSSERVICE ContasPagar
    Local lRet       := .T.
    Local oJsonRet   := JsonObject():New()
    Local aVetSE2    := {}
    Local cMsgError  := ""
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()

    Private lAutoErrNoFile := .T.
    Private lMsHelpAuto    := .T.
    Private lMsErroAuto    := .F.

    FWLogMsg("INFO",, "ContasPagar", "ExcluirTitulo", "", "01", "Inicio da Exclusao ID_TITULO: " + cValToChar(::id))
    Self:SetContentType('application/json')

    If Empty(::id)
        Self:setStatus(400)
        Self:SetResponse('{"STATUS_CODE":"400", "MENSAGEM":"ID_TITULO nao informado na URL."}')
        Return .F.
    EndIf

    cQuery := "SELECT R_E_C_N_O_ AS RECNO_SE2 "
    cQuery += "FROM " + RetSqlName("SE2") + " SE2 "
    cQuery += "WHERE E2_ZZIDTIT = '" + ::id  + "' "
    cQuery += "AND D_E_L_E_T_ = ' ' "
    
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias (cAlias)
    (cAlias)->(DbGoTop())

    If !(cAlias)->(Eof())
        DbSelectArea("SE2")
        SE2->(DbGoTo((cAlias)->RECNO_SE2))

        If SE2->E2_SALDO < SE2->E2_VALOR .Or. !Empty(SE2->E2_BAIXA)
            Self:setStatus(400)
            oJsonRet['STATUS_CODE'] := "400"
            oJsonRet['MENSAGEM']    := "Titulo nao pode ser excluido pois possui baixas/pagamentos."
            lRet := .F.
        Else
            AAdd(aVetSE2, {"E2_FILIAL" , SE2->E2_FILIAL , Nil})
            AAdd(aVetSE2, {"E2_PREFIXO", SE2->E2_PREFIXO, Nil})
            AAdd(aVetSE2, {"E2_NUM"    , SE2->E2_NUM    , Nil})
            AAdd(aVetSE2, {"E2_PARCELA", SE2->E2_PARCELA, Nil})
            AAdd(aVetSE2, {"E2_TIPO"   , SE2->E2_TIPO   , Nil})
            AAdd(aVetSE2, {"E2_FORNECE", SE2->E2_FORNECE, Nil})
            AAdd(aVetSE2, {"E2_LOJA"   , SE2->E2_LOJA   , Nil})

            Begin Transaction
                lMsErroAuto := .F.
                MsExecAuto({|x,y,z| FINA050(x,y,z)}, aVetSE2,, 5) // 5 = Exclusão

                If lMsErroAuto
                    cMsgError := TrataLog(GetAutoGRLog())
                    DisarmTransaction()
                EndIf
            End Transaction

            If Empty(cMsgError)
                oJsonRet['STATUS_CODE'] := "200"
                oJsonRet['MENSAGEM']    := "Titulo excluido com sucesso."
            Else
                Self:setStatus(400)
                oJsonRet['STATUS_CODE'] := "400"
                oJsonRet['MENSAGEM']    := cMsgError
                lRet := .F.
            EndIf
        EndIf
    Else
        Self:setStatus(404)
        oJsonRet['STATUS_CODE'] := "404"
        oJsonRet['MENSAGEM']    := "Titulo nao encontrado para exclusao com o ID_TITULO informado."
        lRet := .F.
    EndIf

    (cAlias)->(DbCloseArea())
    Self:SetResponse(EncodeUTF8(oJsonRet:ToJson()))
    FreeObj(oJsonRet)
Return lRet

// =========================================================================
// CONSULTA (GET) POR ID_TITULO
// =========================================================================
WSMETHOD GET ConsultarExclusao WSRECEIVE id WSSERVICE ContasPagar
    Local lRet       := .T.
    Local oJsonRet   := JsonObject():New()
    Local cQuery     := ""
    Local cAlias     := GetNextAlias()

    FWLogMsg("INFO",, "ContasPagar", "ConsultarExclusao", "", "01", "Consulta ID_TITULO: " + cValToChar(::id))
    Self:SetContentType('application/json')

    If Empty(::id)
        Self:setStatus(400)
        Self:SetResponse('{"STATUS_CODE":"400", "MENSAGEM":"ID_TITULO nao informado na URL."}')
        Return .F.
    EndIf

    cQuery := "SELECT E2_SALDO, E2_VALOR, E2_BAIXA "
    cQuery += "FROM " + RetSqlName("SE2") + " SE2 "
    cQuery += "WHERE E2_ZZIDTIT = '" + ::id + "' "
    cQuery += "AND D_E_L_E_T_ = ' ' "
    
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias (cAlias)
    (cAlias)->(DbGoTop())

    If !(cAlias)->(Eof())
        If (cAlias)->E2_SALDO < (cAlias)->E2_VALOR .Or. !Empty((cAlias)->E2_BAIXA)
            oJsonRet['STATUS_CODE']  := "400"
            oJsonRet['PODE_EXCLUIR'] := .F.
            oJsonRet['MENSAGEM']     := "Titulo possui baixas e nao pode ser excluido."
        Else
            oJsonRet['STATUS_CODE']  := "200"
            oJsonRet['PODE_EXCLUIR'] := .T.
            oJsonRet['MENSAGEM']     := "Titulo disponivel para exclusao."
        EndIf
    Else
        Self:setStatus(404)
        oJsonRet['STATUS_CODE']  := "404"
        oJsonRet['PODE_EXCLUIR'] := .F.
        oJsonRet['MENSAGEM']     := "Titulo nao encontrado com o ID_TITULO informado."
        lRet := .F.
    EndIf

    (cAlias)->(DbCloseArea())
    Self:SetResponse(EncodeUTF8(oJsonRet:ToJson()))
    FreeObj(oJsonRet)
Return lRet
