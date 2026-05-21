#INCLUDE "PROTHEUS.CH"
#INCLUDE "RESTFUL.CH"

/*
    API: SalesOrderAPI
    Descrição: Interface REST para Pedidos de Venda
    Camada: Controller (Responsável apenas pelo HTTP)
*/
WSRESTFUL PedidoVendas DESCRIPTION 'Gestao de Pedidos de Venda' FORMAT "application/json"

    WSDATA numero As Character

    // Definição das rotas
    WSMETHOD GET ConsultarPedido DESCRIPTION "Busca um pedido" PATH "/artiq/v1/orders/{numero}" PRODUCES APPLICATION_JSON
    WSMETHOD POST CriarPedido    DESCRIPTION "Cria um pedido"  PATH "/artiq/v1/orders"         PRODUCES APPLICATION_JSON
    WSMETHOD PUT AlterarPedido   DESCRIPTION "Altera um pedido" PATH "/artiq/v1/orders/{numero}" PRODUCES APPLICATION_JSON
    WSMETHOD DELETE ExcluirPedido DESCRIPTION "Exclui um pedido" PATH "/artiq/v1/orders/{numero}" PRODUCES APPLICATION_JSON

ENDWSRESTFUL

// --------------------------------------------------------------------------
// GET: Consultar
// --------------------------------------------------------------------------
WSMETHOD GET ConsultarPedido WSREST PedidoVendas
    Local oService  := SalesOrderService():New()
    Local oResponse := Nil
    Local cPedido   := Self:numero

    If Empty(cPedido)
        // Passamos 'Self' como parâmetro para a função estática
        Return SetRestFault(Self, 400, "Numero do pedido obrigatorio")
    EndIf

    oResponse := oService:GetOrder(cPedido)

    If oResponse == Nil
        Return SetRestFault(Self, 404, "Pedido nao encontrado")
    EndIf

    Self:SetResponse(oResponse:ToJson())
Return .T.

// --------------------------------------------------------------------------
// POST: Criar
// --------------------------------------------------------------------------
WSMETHOD POST CriarPedido WSREST PedidoVendas
    Local oService := SalesOrderService():New()
    Local oBody    := JsonObject():New()
    
    // DICA: O FromJson retorna NIL em versões padrão, valida-se o parsing capturando erro ou verificando conteúdo
    Local cJsonContent := Self:GetContent()
    
    If Empty(cJsonContent) .Or. ValType(oBody:FromJson(cJsonContent)) == "C" // Tratamento de erro de parse simples
        Return SetRestFault(Self, 400, "JSON invalido ou vazio")
    EndIf

    If oService:Create(oBody)
        Self:SetResponse('{"message": "Pedido criado com sucesso", "numero": "' + oService:GetLastOrder() + '"}')
        Return .T.
    Else
        Return SetRestFault(Self, 500, oService:GetError())
    EndIf
Return .T.

// --------------------------------------------------------------------------
// PUT: Alterar
// --------------------------------------------------------------------------
WSMETHOD PUT AlterarPedido WSREST PedidoVendas
    Local oService := SalesOrderService():New()
    Local oBody    := JsonObject():New()
    Local cPedido  := Self:numero // Pega da URL
    Local cJsonContent := Self:GetContent()

    If Empty(cJsonContent) .Or. ValType(oBody:FromJson(cJsonContent)) == "C"
        Return SetRestFault(Self, 400, "JSON invalido")
    EndIf
    
    // Garante que o número do pedido venha da URL ou do JSON
    oBody['numero'] := cPedido

    If oService:Update(oBody)
        Self:SetResponse('{"message": "Pedido alterado com sucesso"}')
        Return .T.
    Else
        Return SetRestFault(Self, 500, oService:GetError())
    EndIf
Return .T.

// --------------------------------------------------------------------------
// DELETE: Excluir
// --------------------------------------------------------------------------
WSMETHOD DELETE ExcluirPedido WSREST PedidoVendas
    Local oService := SalesOrderService():New()
    Local cPedido  := Self:numero

    If Empty(cPedido)
        Return SetRestFault(Self, 400, "Numero do pedido obrigatorio")
    EndIf

    If oService:Delete(cPedido)
        Self:SetResponse('{"message": "Pedido excluido com sucesso"}')
        Return .T.
    Else
        Return SetRestFault(Self, 500, oService:GetError())
    EndIf
Return .T.

// --------------------------------------------------------------------------
// Helper para Resposta de Erro Padronizada (Convertido para Static Function)
// --------------------------------------------------------------------------
Static Function SetRestFault(oSelf, nCode, cMessage)
    Local oErr := JsonObject():New()
    
    oSelf:SetContentType("application/json")
    oSelf:SetStatus(nCode)
    
    oErr['errorCode']    := cValToChar(nCode)
    oErr['errorMessage'] := cMessage
    
    oSelf:SetResponse(oErr:ToJson())
    FreeObj(oErr)
Return .F.
