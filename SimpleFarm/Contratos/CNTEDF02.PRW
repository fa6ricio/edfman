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
        aRetMov := u_gravaDados(oJsonReq)
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
    Função com Array Dinâmico, Prevenção Nativa de Crash e Lógica de Cessão de Crédito
*/
User Function gravaDados(oJsonReq)   
    Local nRecord    := 0
    Local oJsonRet   := JsonObject():New()
    Local aRetIncs   := {}
    Local oItemRet  
    Local oItemReq  
    Local aVetSE2    := {}
    Local cMsgError  := ""
    Local lRet       := .T.  
    Local cNatureza  := getMv('MV_ZZNTDUP')
    Local nValorOrig := 0
    Local nTaxaPtax  := 0
    Local nMoedaTit  := 1    
    Local cPref      := ""

    // --- Variáveis para a Lógica de Cessão de Crédito ---
    Local nValorPendente := 0
    Local nValorAtu      := 0
    Local cFornOrig      := ""
    Local cLojaOrig      := ""
    Local cNomOrig       := ""
    Local cForneceAtu    := ""
    Local cLojaAtu       := ""
    Local cNomForAtu     := ""
    Local nRecZX6        := 0
    // ----------------------------------------------------

    Private lAutoErrNoFile := .T. 
    Private lMsHelpAuto    := .T. 
    Private lMsErroAuto    := .F.

    If oJsonReq['INCLUI_PAGAR'] != Nil .And. ValType(oJsonReq['INCLUI_PAGAR']) == "A"
        
        For nRecord := 1 To Len(oJsonReq:GetJsonObject("INCLUI_PAGAR"))
            cMsgError := ""
            oItemRet  := JsonObject():New()
            oItemReq  := oJsonReq:GetJsonObject("INCLUI_PAGAR")[nRecord]

            If oItemReq['FILIAL_TITULO'] == Nil .Or. Empty(oItemReq['FILIAL_TITULO'])
                cMsgError := "A Filial do titulo e obrigatoria e nao foi informada."
            Else
                
                // 1. Identifica o Fornecedor Original da Nota
                cFornOrig := ""
                cLojaOrig := ""
                cNomOrig  := ""
                
                If oItemReq['FORNECEDOR'] != nil .And. oItemReq['ORIGEM'] <> "MARKBROWSE"
                    dbSelectArea("SA2")
                    dbSetOrder(12)   
                    If dbSeek(xFilial("SA2") + oItemReq['FORNECEDOR'])
                       cFornOrig := SA2->A2_COD
                       cLojaOrig := SA2->A2_LOJA
                       cNomOrig  := SA2->A2_NOME
                    EndIf
                ElseIf oItemReq['ORIGEM'] == "MARKBROWSE"
                    cFornOrig := oItemReq['FORNECEDOR']
                    cLojaOrig := oItemReq['LOJA']
                    cNomOrig  := "" // Quando vem do MarkBrowse, a view já tratou se necessário
                Endif

                // 2. Prepara Valores e Moeda Originais
                nValorOrig := 0
                nTaxaPtax  := 0
                nMoedaTit  := 1
                
                If oItemReq['VALOR_TITULO'] != Nil
                    nValorOrig := Val(cValToChar(oItemReq['VALOR_TITULO']))
                EndIf
                If oItemReq['PTAX'] != Nil
                    nTaxaPtax := Val(cValToChar(oItemReq['PTAX']))
                EndIf
                If oItemReq['MOEDA'] != Nil
                    nMoedaTit := Val(cValToChar(oItemReq['MOEDA']))
                EndIf

                If nMoedaTit != 1 .And. nTaxaPtax > 0
                    nValorOrig := nValorOrig * nTaxaPtax
                    nMoedaTit  := 1
                EndIf

                // =========================================================================
                // 3. LAÇO DE CESSÃO DE CRÉDITO (Pode gerar múltiplos títulos)
                // =========================================================================
                nValorPendente := nValorOrig

                While nValorPendente > 0
                    
                    // Reseta para o fornecedor original a cada iteração
                    cForneceAtu := cFornOrig
                    cLojaAtu    := cLojaOrig
                    cNomForAtu  := cNomOrig
                    nValorAtu   := nValorPendente
                    nRecZX6     := 0

                    // Verifica se há Cessão de Crédito com saldo disponível
                    If oItemReq['NUMERO_CONTRATO'] != Nil
                        DbSelectArea("ZX6")
                        ZX6->(DbSetOrder(1)) // Presumindo índice ZX6_FILIAL+ZX6_CODIGO+ZX6_ITEM
                        
                        If ZX6->(DbSeek(PadR(oItemReq['FILIAL_TITULO'], TamSx3("ZX6_FILIAL")[1]) + PadR(upper(oItemReq['NUMERO_CONTRATO']), TamSx3("ZX6_CODIGO")[1])))
                            While !ZX6->(Eof()) .And. ZX6->ZX6_FILIAL == PadR(oItemReq['FILIAL_TITULO'], TamSx3("ZX6_FILIAL")[1]) .And. ZX6->ZX6_CODIGO == PadR(upper(oItemReq['NUMERO_CONTRATO']), TamSx3("ZX6_CODIGO")[1])
                                
                                If ZX6->ZX6_SLDCES > 0 .And. AllTrim(Upper(ZX6->ZX6_TIPO)) == "CEDENTE"
                                    // Parceiro com saldo encontrado! O título vai para ele.
                                    cForneceAtu := ZX6->ZX6_FORNEC
                                    cLojaAtu    := ZX6->ZX6_LOJA
                                    cNomForAtu  := ZX6->ZX6_NOMFOR
                                    
                                    // Pega o menor valor: O que falta da nota OU o que resta de saldo do parceiro
                                    nValorAtu   := Min(nValorPendente, ZX6->ZX6_SLDCES)
                                    nRecZX6     := ZX6->(RecNo()) // Salva o registro para abater o saldo depois
                                    Exit // Quebra o While interno para processar este título
                                EndIf
                                
                                ZX6->(DbSkip())
                            EndDo
                        EndIf
                    EndIf

                    // 4. Monta o Array para o ExecAuto com o Fornecedor e Valor Atuais
                    aVetSE2 := {}
                    AAdd(aVetSE2, {"E2_FILIAL", oItemReq['FILIAL_TITULO'], Nil})

                    iif(oItemReq['NUMERO_TITULO']  != nil, aAdd(aVetSE2,{'E2_NUM'     ,upper(oItemReq['NUMERO_TITULO']) ,NIL}),nil)
                    iif(oItemReq['PREFIXO_TITULO'] != nil, aAdd(aVetSE2,{'E2_PREFIXO' ,upper(oItemReq['PREFIXO_TITULO']),NIL}),nil)
                    iif(oItemReq['PARCELA_TITULO'] != nil, aAdd(aVetSE2,{'E2_PARCELA' ,upper(oItemReq['PARCELA_TITULO']),NIL}),nil)
                    iif(oItemReq['TIPO_TITULO']    != nil, aAdd(aVetSE2,{'E2_TIPO'    ,upper(oItemReq['TIPO_TITULO'])   ,NIL}),nil)
                    iif(oItemReq['NATUREZA']       != nil, aAdd(aVetSE2,{'E2_NATUREZ' ,upper(oItemReq['NATUREZA'])      ,NIL}), aAdd(aVetSE2,{'E2_NATUREZ' ,cNatureza, NIL}))
                    
                    // Passa o Fornecedor da rodada (Cedente ou Original)
                    AAdd(aVetSE2,{'E2_FORNECE', cForneceAtu, NIL})
                    AAdd(aVetSE2,{'E2_LOJA'   , cLojaAtu   , NIL})

                    iif(oItemReq['DATA_EMISSAO']    != nil, aAdd(aVetSE2,{'E2_EMISSAO' ,sToD(oItemReq['DATA_EMISSAO'])   ,NIL}),nil)
                    iif(oItemReq['DATA_VENCIMENTO'] != nil, aAdd(aVetSE2,{'E2_VENCTO'  ,sToD(oItemReq['DATA_VENCIMENTO']),NIL}),nil)
                    iif(oItemReq['DATA_VENCIMENTO'] != nil, aAdd(aVetSE2,{'E2_VENCREA' ,sToD(oItemReq['DATA_VENCIMENTO']),NIL}),nil)
                    iif(oItemReq['FORMAPAGAMENTO']  != nil, aAdd(aVetSE2,{'E2_FORMPAG' ,oItemReq['FORMAPAGAMENTO']       ,NIL}),nil)

                    // Passa o Valor atual da rodada
                    If nValorAtu > 0
                        AAdd(aVetSE2, {'E2_VALOR' , nValorAtu, NIL})
                        AAdd(aVetSE2, {'E2_VLCRUZ', nValorAtu, NIL}) 
                    EndIf

                    AAdd(aVetSE2, {'E2_MOEDA', nMoedaTit, NIL})
                    If nTaxaPtax > 0
                        AAdd(aVetSE2, {'E2_TXMOEDA', nTaxaPtax, NIL})
                    EndIf

                    If oItemReq['BLOQUEIO_PAGAMENTO'] != Nil
                        AAdd(aVetSE2, {'E2_ZZBLQPG', oItemReq['BLOQUEIO_PAGAMENTO'], NIL})
                    EndIf

                    iif(oItemReq['HISTORICO']       != nil, aAdd(aVetSE2,{'E2_HIST'   ,upper(oItemReq['HISTORICO'])       ,NIL}),nil)
                    iif(oItemReq['ID_TITULO']       != nil, aAdd(aVetSE2,{'E2_ZZIDTIT',upper(oItemReq['ID_TITULO'])       ,NIL}), nil)
                    iif(oItemReq['OPERACAO']        != nil, aAdd(aVetSE2,{'E2_ZZOPERA',upper(oItemReq['OPERACAO'])        ,NIL}), nil)
                    iif(oItemReq['NUMERO_CONTRATO'] != nil, aAdd(aVetSE2,{'E2_ZZCONTR',upper(oItemReq['NUMERO_CONTRATO']) ,NIL}), nil)
                    
                    // Dados Bancários
                    iif(oItemReq['BANCO']         != nil, aAdd(aVetSE2,{'E2_FORBCO',upper(oItemReq['BANCO'])        ,NIL}),nil)
                    iif(oItemReq['AGENCIA']       != nil, aAdd(aVetSE2,{'E2_FORAGE',upper(oItemReq['AGENCIA'])      ,NIL}),nil)
                    iif(oItemReq['CONTA']         != nil, aAdd(aVetSE2,{'E2_FORCTA',upper(oItemReq['CONTA'])        ,NIL}),nil)
                    iif(oItemReq['DIGITOCONTA']   != nil, aAdd(aVetSE2,{'E2_FCTADV',upper(oItemReq['DIGITOCONTA'])  ,NIL}),nil)
                    iif(oItemReq['DIGITOAGENCIA'] != nil, aAdd(aVetSE2,{'E2_FAGEDV',upper(oItemReq['DIGITOAGENCIA']),NIL}),nil)

                    
                    // 5. Efetivação
                    If val(cValToChar(oItemReq['MOEDA'])) == 1 .or. val(cValToChar(oItemReq['PTAX'])) > 0
                        Begin Transaction
                            lMsErroAuto := .F.
                            MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aVetSE2,, 3)
                            
                            If lMsErroAuto
                                cMsgError := TrataLog(GetAutoGRLog())
                                DisarmTransaction()
                                nValorPendente := 0 // Aborta laço em caso de erro na gravação
                            Else
                                
                                // Abate o saldo de Cessão do Parceiro na ZX6
                                If nRecZX6 > 0
                                    DbSelectArea("ZX6")
                                    ZX6->(DbGoTo(nRecZX6))
                                    RecLock("ZX6", .F.)
                                    ZX6->ZX6_SLDCES -= nValorAtu
                                    ZX6->(MsUnlock())
                                EndIf

                                // Gerar ZX5 (Contrato Fixado -> Gera SE2 e ZX5)
                                If oItemReq['ORIGEM'] != "MARKBROWSE"
                                    RecLock("ZX5", .T.)
                                    ZX5->ZX5_FILIAL := PadR(oItemReq['FILIAL_TITULO'], TamSx3("ZX5_FILIAL")[1])
                                    iif(oItemReq['NUMERO_CONTRATO'] != nil, ZX5->ZX5_CODIGO := upper(oItemReq['NUMERO_CONTRATO']), nil)                                
                                    
                                    IF upper(oItemReq['TIPO_TITULO']) = '1'
                                        cPref:='NF'
                                    ElseIF upper(oItemReq['TIPO_TITULO']) = '2'
                                        cPref:='PA'
                                    Else
                                        cPref:='AT'
                                    EndIF
                                    ZX5->ZX5_PREFIX := cPref
                                    
                                    iif(oItemReq['NUMERO_TITULO']  != nil, ZX5->ZX5_NUMERO := upper(oItemReq['NUMERO_TITULO']) , nil)
                                    iif(oItemReq['PARCELA_TITULO'] != nil, ZX5->ZX5_PARCEL := upper(oItemReq['PARCELA_TITULO']), nil)
                                    iif(oItemReq['TIPO_TITULO']    != nil, ZX5->ZX5_TIPO   := upper(oItemReq['TIPO_TITULO'])   , nil)
                                    
                                    // Fornecedor determinado pela rodada da quebra
                                    ZX5->ZX5_FORNEC := cForneceAtu
                                    ZX5->ZX5_LOJA   := cLojaAtu
                                    ZX5->ZX5_NOMFOR := cNomForAtu

                                    ZX5->ZX5_FORTIT := cForneceAtu
                                    ZX5->ZX5_LJTIT  := cLojaAtu
                                    ZX5->ZX5_FORNOM := cNomForAtu

                                    iif(oItemReq['DATA_EMISSAO']    != nil, ZX5->ZX5_EMISSA := sToD(oItemReq['DATA_EMISSAO'])   , nil)
                                    iif(oItemReq['DATA_VENCIMENTO'] != nil, ZX5->ZX5_VENCTO := sToD(oItemReq['DATA_VENCIMENTO']), nil)
                                    
                                    ZX5->ZX5_VLRTIT := nValorAtu
                                    ZX5->ZX5_SALDO  := nValorAtu 
                                    
                                    iif(oItemReq['MOEDA'] != nil, ZX5->ZX5_MOEDA := upper(oItemReq['MOEDA'])            , nil)
                                    iif(oItemReq['PTAX']  != nil, ZX5->ZX5_PTAX  := val(cValToChar(oItemReq['PTAX']))   , nil)
                                    
                                    ZX5->ZX5_STATUS := "2" 
                                    ZX5->(MsUnlock())
                                Endif
                            EndIf

                        End Transaction
                    Else
                        // Apenas previsão - Grava ZX5 status 1
                        Begin Transaction
                            RecLock("ZX5", .T.)
                            ZX5->ZX5_FILIAL := PadR(oItemReq['FILIAL_TITULO'], TamSx3("ZX5_FILIAL")[1])
                            iif(oItemReq['NUMERO_CONTRATO'] != nil, ZX5->ZX5_CODIGO := upper(oItemReq['NUMERO_CONTRATO']), nil)                                
                            iif(oItemReq['PREFIXO_TITULO']  != nil, ZX5->ZX5_PREFIX := upper(oItemReq['PREFIXO_TITULO']) , nil)
                            iif(oItemReq['NUMERO_TITULO']   != nil, ZX5->ZX5_NUMERO := upper(oItemReq['NUMERO_TITULO'])  , nil)
                            iif(oItemReq['PARCELA_TITULO']  != nil, ZX5->ZX5_PARCEL := upper(oItemReq['PARCELA_TITULO']) , nil)
                            iif(oItemReq['TIPO_TITULO']     != nil, ZX5->ZX5_TIPO   := upper(oItemReq['TIPO_TITULO'])    , nil)
                            
                            // Fornecedor determinado pela rodada da quebra
                            ZX5->ZX5_FORNEC := cForneceAtu
                            ZX5->ZX5_LOJA   := cLojaAtu
                            ZX5->ZX5_NOMFOR := cNomForAtu

                            ZX5->ZX5_FORTIT := cForneceAtu
                            ZX5->ZX5_LJTIT  := cLojaAtu
                            ZX5->ZX5_FORNOM := cNomForAtu

                            iif(oItemReq['DATA_EMISSAO']    != nil, ZX5->ZX5_EMISSA := sToD(oItemReq['DATA_EMISSAO'])   , nil)
                            iif(oItemReq['DATA_VENCIMENTO'] != nil, ZX5->ZX5_VENCTO := sToD(oItemReq['DATA_VENCIMENTO']), nil)
                            
                            ZX5->ZX5_VLRTIT := nValorAtu
                            ZX5->ZX5_SALDO  := nValorAtu 
                            
                            ZX5->ZX5_STATUS := "1" 
                            ZX5->(MsUnlock())
                        End Transaction
                    EndIF

                    // Abate o valor recém-gravado do total da nota original
                    nValorPendente -= nValorAtu

                EndDo // Fim do Laço da Cessão
            EndIf
            
            If Empty(cMsgError)
                oItemRet['STATUS_CODE'] := "200"
                If val(cValToChar(oItemReq['MOEDA'])) == 1 .or. val(cValToChar(oItemReq['PTAX'])) > 0
                    oItemRet['MENSAGEM'] := "Titul e Previsao incluidos com sucesso."
                Else
                    oItemRet['MENSAGEM'] := "Previsao incluida com sucesso. Titulo Pendente."
                EndIf
            Else
                oItemRet['STATUS_CODE'] := "400"
                oItemRet['MENSAGEM']    := cMsgError
                lRet := .F.
            EndIf
            
            oItemRet['FILIAL_TITULO']  := IIf(oItemReq['FILIAL_TITULO']  != Nil, oItemReq['FILIAL_TITULO']  , "")
            oItemRet['NUMERO_TITULO']  := IIf(oItemReq['NUMERO_TITULO']  != Nil, oItemReq['NUMERO_TITULO']  , "")
            oItemRet['PREFIXO_TITULO'] := IIf(oItemReq['PREFIXO_TITULO'] != Nil, oItemReq['PREFIXO_TITULO'] , "")
            oItemRet['ID_TITULO']      := IIf(oItemReq['ID_TITULO']      != Nil, oItemReq['ID_TITULO']      , "")
            
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

        AAdd(aVetSE2, {"E2_FILIAL" , SE2->E2_FILIAL , Nil})
        AAdd(aVetSE2, {"E2_PREFIXO", SE2->E2_PREFIXO, Nil})
        AAdd(aVetSE2, {"E2_NUM"    , SE2->E2_NUM    , Nil})
        AAdd(aVetSE2, {"E2_PARCELA", SE2->E2_PARCELA, Nil})
        AAdd(aVetSE2, {"E2_TIPO"   , SE2->E2_TIPO   , Nil})
        AAdd(aVetSE2, {"E2_FORNECE", SE2->E2_FORNECE, Nil})
        AAdd(aVetSE2, {"E2_LOJA"   , SE2->E2_LOJA   , Nil})

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
                MsExecAuto({|x,y,z| FINA050(x,y,z)}, aVetSE2,, 4) 

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
