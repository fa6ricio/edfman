#INCLUDE "PROTHEUS.CH"

/*
    Classe: SalesOrderService
    Descrição: Responsável pela regra de negócio de Pedidos (MATA410)
*/
Class SalesOrderService
    Data cLastError
    Data cLastOrder

    Method New()
    Method GetOrder(cPedido)
    Method Create(oJson)
    Method Update(oJson)
    Method Delete(cPedido)
    Method GetError()
    Method GetLastOrder()
    
    // Métodos Privados (Helpers Internos)
    Method ExecuteRoutine(aCabec, aItens, nOp)
    Method BuildHeader(oJson)
    Method BuildItems(aItemsJson, nOp)
EndClass

Method New() Class SalesOrderService
    Self:cLastError := ""
    Self:cLastOrder := ""
Return Self

Method GetError() Class SalesOrderService
Return Self:cLastError

Method GetLastOrder() Class SalesOrderService
Return Self:cLastOrder

// --------------------------------------------------------------------------
// Método de Leitura (Query Otimizada)
// --------------------------------------------------------------------------
Method GetOrder(cPedido) Class SalesOrderService
    Local oJson  := Nil
    Local cAlias := GetNextAlias()
    
    cPedido := PadR(cPedido, TamSx3("C5_NUM")[1])

    BeginSQL Alias cAlias
        SELECT SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_EMISSAO, SC5.C5_CONDPAG,
               SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_VALOR, SC6.C6_TES
        FROM %Table:SC5% SC5
        INNER JOIN %Table:SC6% SC6 ON SC6.%NotDel% AND SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM
        WHERE SC5.C5_FILIAL = %xFilial:SC5% AND SC5.C5_NUM = %exp:cPedido% AND SC5.%NotDel%
    EndSQL

    If (cAlias)->(Eof())
        (cAlias)->(dbCloseArea())
        Return Nil
    EndIf

    oJson := JsonObject():New()
    oJson['numero']  := AllTrim((cAlias)->C5_NUM)
    oJson['cliente'] := AllTrim((cAlias)->C5_CLIENTE)
    oJson['loja']    := AllTrim((cAlias)->C5_LOJACLI)
    oJson['emissao'] := StoD((cAlias)->C5_EMISSAO)
    oJson['condPag'] := AllTrim((cAlias)->C5_CONDPAG)
    oJson['itens']   := {}

    While (cAlias)->(!Eof())
        oItem := JsonObject():New()
        oItem['item']       := AllTrim((cAlias)->C6_ITEM)
        oItem['produto']    := AllTrim((cAlias)->C6_PRODUTO)
        oItem['quantidade'] := (cAlias)->C6_QTDVEN
        oItem['valorUnit']  := (cAlias)->C6_PRCVEN
        oItem['total']      := (cAlias)->C6_VALOR
        oItem['tes']        := AllTrim((cAlias)->C6_TES)
        AAdd(oJson['itens'], oItem)
        (cAlias)->(dbSkip())
    EndDo

    (cAlias)->(dbCloseArea())
Return oJson

// --------------------------------------------------------------------------
// Método Criar (Facade para Inclusão)
// --------------------------------------------------------------------------
Method Create(oJson) Class SalesOrderService
    Local aCabec := {}
    Local aItens := {}

    // Validação básica de negócio antes de tentar montar arrays
    If !ExistCpo("SA1", oJson['cliente'] + oJson['loja'])
        Self:cLastError := "Cliente invalido: " + oJson['cliente']
        Return .F.
    EndIf

    Self:cLastOrder := GetSxeNum("SC5", "C5_NUM")
    
    // Montagem dos Arrays para ExecAuto
    aCabec := Self:BuildHeader(oJson)
    aItens := Self:BuildItems(oJson['itens'], 3,oJson)

    // Execução
    If !Self:ExecuteRoutine(aCabec, aItens, 3)
        Return .F.
    EndIf
    
    // Atualiza numero gerado se sucesso (ExecAuto pode ter consumido outro numero)
    // Aqui simplificamos assumindo o getSxeNum, mas o ideal seria ler o retorno do ExecAuto se possível
Return .T.

// --------------------------------------------------------------------------
// Método Alterar (Facade para Alteração)
// --------------------------------------------------------------------------
Method Update(oJson) Class SalesOrderService
    Local aCabec  := {}
    Local aItens  := {}
    Local cPedido := PadR(oJson['numero'], TamSx3("C5_NUM")[1])

    If !ExistCpo("SC5", cPedido)
        Self:cLastError := "Pedido nao encontrado: " + cPedido
        Return .F.
    EndIf

    // Na alteração, o cabeçalho deve conter o numero para posicionar
    AAdd(aCabec, {"C5_NUM", cPedido, Nil})
    
    // Adiciona campos que podem ser alterados no cabeçalho
    If oJson:HasProperty("condPag"); AAdd(aCabec, {"C5_CONDPAG", oJson['condPag'], Nil}); EndIf

    aItens := Self:BuildItems(oJson['itens'], 4)

    Return Self:ExecuteRoutine(aCabec, aItens, 4)

// --------------------------------------------------------------------------
// Método Excluir
// --------------------------------------------------------------------------
Method Delete(cPedido) Class SalesOrderService
    Local aCabec := {}
    cPedido := PadR(cPedido, TamSx3("C5_NUM")[1])

    If !ExistCpo("SC5", cPedido)
        Self:cLastError := "Pedido nao encontrado"
        Return .F.
    EndIf

    AAdd(aCabec, {"C5_NUM", cPedido, Nil})
    
    Return Self:ExecuteRoutine(aCabec, {}, 5)

// --------------------------------------------------------------------------
// Executa a Rotina Automática (Encapsulamento do MsExecAuto)
// --------------------------------------------------------------------------
Method ExecuteRoutine(aCabec, aItens, nOp) Class SalesOrderService
    Local lRet := .T.
    
    // Variáveis privadas obrigatórias para ExecAuto
    Private lMsErroAuto    := .F.
    Private lMsHelpAuto    := .T.
    Private lAutoErrNoFile := .T. 

    MSExecAuto({|x,y,z| Mata410(x,y,z)}, aCabec, aItens, nOp)

    If lMsErroAuto
    // GetAutoGRLog retorna uma string com a lista de erros validados pelo ExecAuto
        Self:cLastError := GetAutoGRLog() 
        lRet := .F.
    EndIf
Return lRet

// --------------------------------------------------------------------------
// Helpers de Construção de Dados (Mappers)
// --------------------------------------------------------------------------
Method BuildHeader(oJson) Class SalesOrderService
    Local aHead := {}
    
    // Mapeamento JSON -> ADVPL
    AAdd(aHead, {"C5_NUM"    , Self:cLastOrder , Nil})
    AAdd(aHead, {"C5_TIPO"   , "N"             , Nil})
    AAdd(aHead, {"C5_CLIENTE", oJson['cliente'], Nil})
    AAdd(aHead, {"C5_LOJACLI", oJson['loja']   , Nil})
    AAdd(aHead, {"C5_CONDPAG", oJson['condPag'], Nil})
    AAdd(aHead, {"C5_EMISSAO", dDataBase       , Nil})
    
Return aHead

Method BuildItems(aItemsJson, nOp,oJson) Class SalesOrderService
    Local aRet   := {}
    Local aLinha := {}
    Local i      := 0
    Local cEstD
    Local cEstO
    Local cCFOP
    
    If ValType(aItemsJson) != "A"; Return {}; EndIf
    
    dbSelectArea('SM0')
    SM0->(dbSetOrder(1))
    SM0->(dbSeek(cEmpAnt+cFilAnt))
    cEstO:= SM0->M0_ESTENT

    dbSelectArea('SA1')
    SA1->(dbSetOrder(1))
    SA1->(dbSeek(xFilial('SA1')+PadR(Alltrim(oJson['cliente']),6,' ')+Alltrim(oJson['loja'])))
    cEstD:= SA1->A1_EST 


    For i := 1 To Len(aItemsJson)
        aLinha := {}
        

        dbSelectArea('SF4')
        SF4->(dbSetOrder(1))
        IF SF4->(dbSeek(xFilial('SF4')+aItemsJson[i]['tes']))
            IF cEstD <> cEstO
                cCFOP:='6'+SubStr(2,3,SF4->F4_CF)
            Else 
                cCFOP:=SF4->F4_CF
            EndIF
        EndIF
        // Campos Obrigatórios
        AAdd(aLinha, {"C6_PRODUTO", aItemsJson[i]['produto'], Nil})
        AAdd(aLinha, {"C6_QTDVEN" , aItemsJson[i]['quantidade'], Nil})
        AAdd(aLinha, {"C6_PRCVEN" , aItemsJson[i]['valorUnit'], Nil})
        AAdd(aLinha, {"C6_VALOR"  , aItemsJson[i]['quantidade'] * aItemsJson[i]['valorUnit'], Nil})
        AAdd(aLinha, {"C6_TES"    , aItemsJson[i]['tes'], Nil})
        AAdd(aLinha, {"C6_CF"     , cCFOP, Nil})

        // Tratamento Específico para Alteração
        If nOp == 4
            // Se tiver numero do item, é alteração de linha existente
            If aItemsJson[i]:HasProperty("item")
                AAdd(aLinha, {"LINPOS", "C6_ITEM", aItemsJson[i]['item']})
                AAdd(aLinha, {"AUTDELETA", "N", Nil})
            Else
                // Se não tiver, o sistema entende como inclusão de novo item no pedido existente
            EndIf
        EndIf

        AAdd(aRet, aLinha)
    Next
Return aRet
