#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"
#Include "TOTVS.ch"   
#include "Topconn.ch"  
#include "RESTFUL.CH"


#DEFINE PATHLOGSW  GetSrvProfString("Startpath","") + "\ws_log\"

User Function zArtiqPC()
	IF !ExistDir(PATHLOGSW)
		MakeDir(PATHLOGSW)
	EndIF
Return

WSRESTFUL zPedidoCompras DESCRIPTION 'Pedido de Compras API' SECURITY 'MATA120' FORMAT "application/json,text/html" 
	WSDATA numero As Character

    WSMETHOD GET ConsultarPedido;
	DESCRIPTION "Consultar Pedido de Compras" ;
	WSSYNTAX "/artiq/v1/PedidoCompras/ConsultarPedido/{numero}";
	PATH "/artiq/v1/PedidoCompras/ConsultarPedido";
	PRODUCES APPLICATION_JSON	

    WSMETHOD POST CriarPedido ; 
    DESCRIPTION "Criar Pedido de Compras" ;
    WSSYNTAX "/artiq/v1/PedidoCompras/CriarPedido" ;
    PATH "/artiq/v1//PedidoCompras/CriarPedido";
	PRODUCES APPLICATION_JSON

    WSMETHOD PUT AlterarPedido ; 
    DESCRIPTION "Alterar Pedido de Compras" ;
    WSSYNTAX "/artiq/v1//PedidoCompras/AlterarPedido" ;
    PATH "/artiq/v1//PedidoCompras/AlterarPedido";
	PRODUCES APPLICATION_JSON

    WSMETHOD DELETE ExcluirPedido ; 
    DESCRIPTION "Excluir Pedido de Compras" ;
    WSSYNTAX "/artiq/v1//PedidoCompras/ExcluirPedido/{numero}" ;
    PATH "/artiq/v1//PedidoCompras/ExcluirPedido";
	PRODUCES APPLICATION_JSON

ENDWSRESTFUL

/*
método GET - Consulta Pedido de Compras
exemplo: http://localhost:3000/rest/PedidoCompras/ConsultarPedido?numero=000001
*/
WSMETHOD GET ConsultarPedido QUERYPARAM numero WSREST zPedidoCompras
	Local lRet      := .T.
	Local aData     := {}
	Local oData     := NIL
	Local oAlias   := GetNextAlias()
	Local cPedido   := Self:numero

    /*
    Parametros de pesquisa
    */
	if Empty(cPedido)
		Self:SetResponse('{"noPedido":"' + cPedido + '", "infoMessage":"", "errorCode":"404", "errorMessage":"Numero do Pedido não informado"}')
		Return(.F.)
	EndIF

	BeginSQL Alias oAlias
        SELECT *
        FROM %Table:SC7% SC7
        WHERE SC7.C7_FILIAL = %xFilial:SC7%
            AND SC7.%NotDel%
            AND C7_NUM = %exp:cPedido%
		ORDER BY C7_NUM
	EndSQL

	dbSelectArea(oAlias)
	(oAlias)->(dbGoTop())
	IF (oAlias)->(!Eof())
		oData := JsonObject():New()

		//Monta o cabeçalho
		oData[ 'noPedido' ]     := Alltrim((oAlias)->C7_NUM)
		oData[ 'dataEmissao' ]  := Alltrim((oAlias)->C7_EMISSAO)
		oData[ 'noFornecedor' ]  := Alltrim((oAlias)->C7_FORNECE + (oAlias)->C7_LOJA)
		oData[ 'condicaoPago' ] := Alltrim((oAlias)->C7_COND)

		aAdd(aData,oData)

		oData["items"]   := Array(0)

		While (oAlias)->(!Eof())

			aadd(oData["items"], JsonObject():New())
			aTail(oData[ 'items' ])[ 'item' ]            := Alltrim((oAlias)->C7_ITEM )
			aTail(oData[ 'items' ])[ 'produto' ]         := Alltrim((oAlias)->C7_PRODUTO)
			aTail(oData[ 'items' ])[ 'uom' ]             := Alltrim((oAlias)->C7_UM )
			aTail(oData[ 'items' ])[ 'quantidade' ]      := (oAlias)->C7_QUANT
			aTail(oData[ 'items' ])[ 'precoUnitario' ]   := (oAlias)->C7_PRECO
			aTail(oData[ 'items' ])[ 'noSolicitacao' ]   := Alltrim((oAlias)->C7_NUMSC )
			aTail(oData[ 'items' ])[ 'itemSolicitacao' ] := Alltrim((oAlias)->C7_ITEMSC )
			aTail(oData[ 'items' ])[ 'dataEntrega' ]     := TRANSFORM((oAlias)->C7_DATPRF ,"@R 9999-99-99")

			(oAlias)->(dbSkip())
		EndDo

		FreeObj(oData)

		//Define o retorno do método
		Self:SetResponse(FwJsonSerialize(aData))

	ELSE
		Self:SetResponse('{"noPedido":"'+cPedido+'", "infoMessage":"", "errorCode":"404", "errorMessage":"Numero do Pedido não encontrado"}') 
		lRet    := .F.
	EndIF

	(oAlias)->(dbCloseArea())

Return(lRet)

/*
método POST - Criar Pedido de Compras
exemplo: http://localhost:3000/rest/PedidoCompras/CriarPedido
*/
WSMETHOD POST CriarPedido WSSERVICE zPedidoCompras
	Local lRet      := .T.
	Local oJson     := Nil
    Local oItems    := Nil
	Local cJson     := Self:GetContent()
	Local cError    := ""
    Local cPedido   := ""
    Local cFornLoja := ""
    Local cFornece  := ""
    Local cLoja     := ""
    Local nMoeda    := 1
    Local cCondPag  := ""
    Local cLocal    := ""
	Local nQtde     := 0
	Local nValor    := 0
	Local nTotal    := 0
    Local aCabec    := {}
    Local aItens    := {}
    Local aItem     := {}
    Local i         := 0
    Local cQuery    := ""
    Local cCodFornecedorSimpleFarm := ""
    Local cXSimpleFarm := ""
    Local cXConSimpleFarm := ""

	Private lMsErroAuto    := .F.
	Private lMsHelpAuto    := .T.
	Private lAutoErrNoFile := .T.

	//Se não existir o diretório de logs dentro da Protheus Data, será criado
	IF !ExistDir(PATHLOGSW)
		MakeDir(PATHLOGSW)
	EndIF

    FwLogMsg("INFO",, "CriarPedido", "WSCOM01", "", "01", "Iniciando")

	//Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
	Self:SetContentType("application/json")
	oJson   := JsonObject():New()
	cError  := oJson:FromJson(cJson)

	//Se tiver algum erro no Parse, encerra a execução
	IF !Empty(cError)
		FwLogMsg("ERROR",, "CriarPedido", "WSCOM01", "", "01", 'Parser Json Error')
        Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"Parser Json Error" }')
		lRet    := .F.
	Else
        //Lendo o cabeçalho do arquivo JSON
        cCodFornecedorSimpleFarm := Alltrim(oJson:GetJsonObject('noFornecedor'))
		
		nMoeda   := IIF(Empty(oJson:GetJsonObject('moeda')),1,oJson:GetJsonObject('moeda'))
		cCondPag := PadR(oJson:GetJsonObject('condicaoPago'),TamSX3("C7_COND")[1])
       

        cQuery := "select A2_CGC,A2_COD,A2_LOJA,A2_NOME,A2_NATUREZ "
        cQuery += "from "+RetSqlName('SA2')+" SA2 "
        cQuery += "where A2_XCODFAR = '"+cCodFornecedorSimpleFarm+"' "
        cQuery += "and SA2.D_E_L_E_T_ = ' ' "
        cQuery += "order by A2_COD, A2_LOJA "

        cQuery := ChangeQuery(cQuery)

        TCQuery cQuery New Alias "QRY_SA2"

        QRY_SA2->(DbGoTop())

        If !QRY_SA2->(Eof())
            cFornece := QRY_SA2->(A2_COD)
		    cLoja    := QRY_SA2->(A2_LOJA)

            //Verifica se o fornecedor existe			    
            If !(Existe("SA2",1,cFornece))
                FwLogMsg("ERROR",, "CriarPedido", "WSCOM01", "", "01", "Fornecedor: "+ Alltrim(cCodFornecedorSimpleFarm) +" nao existe!")
                Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"404" ,  "errorMessage":"O fornecedor '+ cCodFornecedorSimpleFarm + " - loja " + cLoja +' nao existe" }')
                FreeObj(oJson)
                Return(.F.)
            Endif

            //Verifica se a condição de pagamento existe			    
            If !(Existe("SE4",1,cCondPag))
                FwLogMsg("ERROR",, "CriarPedido", "WSCOM01", "", "01", "Condicao de Pagamento: "+ Alltrim(cCondPag) +" nao existe!")
                Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"404" ,  "errorMessage":"Condicao de Pagamento '+ Alltrim(cCondPag) +' nao existe" }')
                FreeObj(oJson)
                Return(.F.)
            Endif

            //Lendo os itens do arquivo JSON
            oItems  := oJson:GetJsonObject('items')
            IF ValType( oItems ) == "A"

                //Monta o cabeçalho do pedido de compras apenas se houver itens
                cPedido := GetSxeNum("SC7","C7_NUM")

                aAdd(aCabec,{"C7_FILIAL" , xFilial("SC7")	, NIL})
                aAdd(aCabec,{"C7_NUM"    , cPedido			, NIL})
                aAdd(aCabec,{"C7_EMISSAO", dDataBase		, NIL})
                aAdd(aCabec,{"C7_FORNECE", cFornece			, NIL})
                aAdd(aCabec,{"C7_LOJA"	 , cLoja			, NIL})
                aAdd(aCabec,{"C7_COND"	 , cCondPag			, NIL})
                aAdd(aCabec,{"C7_MOEDA"  , nMoeda	 		, NIL})
                aAdd(aCabec,{"C7_FILENT" , xFilial("SC7")	, NIL})

                For i  := 1 To Len (oItems)
                    cProduto := PadR(AllTrim(oItems[i]:GetJsonObject( 'produto' )),TamSX3("C7_PRODUTO")[1])
                    cLocal   := PadR(AllTrim(oItems[i]:GetJsonObject( 'armazem' )),TamSX3("C7_LOCAL")[1])
                    nQtde    := oItems[i]:GetJsonObject( 'quantidade' )
                    nValor   := oItems[i]:GetJsonObject( 'precoUnitario' )
                    cXSimpleFarm := PadR(AllTrim(oItems[i]:GetJsonObject('xsimple')),TamSX3("C7_XSIMPLE")[1])
                    cXConSimpleFarm := PadR(AllTrim(oItems[i]:GetJsonObject('xconsi')),TamSX3("C7_XCONSI")[1])
                    nTotal   := nQtde * nValor
                    

                    //Verifica se o produto existe			    
                    If !(Existe("SB1",1,cProduto))
                        FwLogMsg("ERROR",, "CriarPedido", "WSCOM01", "", "01", "Produto: "+ Alltrim(cProduto) +" nao existe!")
                        Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"404" ,  "errorMessage":"O produto '+ Alltrim(cProduto) +' nao existe" }')
                        FreeObj(oJson)
                        lRet := .F.
                        Exit
                    Endif

                    aItem:= {}
                    aAdd(aItem,{"C7_ITEM"	,  StrZero(i,4)	, NIL})
                    aAdd(aItem,{"C7_PRODUTO",  cProduto		, NIL})
                    aAdd(aItem,{"C7_QUANT"	,  nQtde		, NIL})
                    aAdd(aItem,{"C7_PRECO"	,  nValor		, NIL})
                    aAdd(aItem,{"C7_TOTAL"	,  nTotal		, NIL})
                    aAdd(aItem,{"C7_LOCAL"	,  cLocal		, NIL})
                    aAdd(aItem,{"C7_XSIMPLE",  cXSimpleFarm	, NIL})
                    aAdd(aItem,{"C7_XCONSI",   cXConSimpleFarm  ,NIL})
                    aAdd(aItens,aItem)

                Next

                //Executa a inclusão automática de pedido de compras
                FwLogMsg("INFO",, "CriarPedido", "WSCOM01", "", "01", "MSExecAuto")
                MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabec,aItens,3)

                //Se houve erro, gera um arquivo de log dentro do diretório da protheus data
                IF lMsErroAuto
                    RollBackSX8()
                    cArqLog  := "CriarPedido-" + cFornLoja + "-" + DTOS(dDataBase) + "-" + StrTran(Time(), ':' , '-' )+".log"
                    aLogAuto := {}
                    aLogAuto := GetAutoGrLog()
                    cError   := GravaLog(cArqLog,aLogAuto)

                    FwLogMsg("ERROR",, "CriarPedido", "WSCOM01", "", "01", cError )
                    Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"'+ Alltrim(cError) +'" }')
                    lRet    := .F.
                ELSE
                    ConfirmSX8()
                    FwLogMsg("INFO",, "CriarPedido", "WSCOM01", "", "01", "Pedido criado: " + cPedido)
                    Self:SetResponse('{"noPedido":"'+cPedido+'", "infoMessage":"PEDIDO CRIADO COM SUCESSO", "errorCode":"", "errorMessage":"" }')
                EndIF

            Else
                FwLogMsg("ERROR",, "CriarPedido", "WSCOM01", "", "01", "Item nao informado")
                Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"Item nao informado" }')
                FreeObj(oJson)
                lRet    := .F.
            Endif
        Else
                SetRestFault(400, 'Fornecedor não encontrado')
                lRet := .F.
        EndIf
    Endif
	FreeObj(oJson)
Return(lRet)

/*
método PUT - Alterar Pedido de Compras
exemplo: http://localhost:3000/rest/PedidoCompras/AlterarPedido
*/
WSMETHOD PUT AlterarPedido WSSERVICE zPedidoCompras
    Local lRet      := .T.
    Local oJson     := Nil
    Local oItems    := Nil
    Local cJson     := Self:GetContent()
    Local cError    := ""
    Local cPedido   := ""
    Local cCondPag  := ""
    Local cItem     := ""
    Local nQtde     := 0
    Local nValor    := 0
    Local nTotal    := 0
    Local aCabec    := {}
    Local aItens    := {}
    Local aItem     := {}
    Local i         := 0
    Local cQuery    := ""
    Local cCodFornecedorSimpleFarm  := ""
    Local cJsonFornece  := ""
    Local cJsonLoja     := ""
    Local cProduto      := ""
    Local cArqLog       := ""
    Local aLogAuto      := {}
    Local cXSimpleFarm := ""
    Local cXConSimpleFarm := ""
    Local cLocal    := ""

    Private lMsErroAuto     := .F.
    Private lMsHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.

    //Se não existir o diretório de logs dentro da Protheus Data, será criado
    IF !ExistDir(PATHLOGSW)
        MakeDir(PATHLOGSW)
    EndIF

    FwLogMsg("INFO",, "AlterarPedido", "WSCOM01", "", "01", "Iniciando")

    //Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
    Self:SetContentType("application/json")
    oJson   := JsonObject():New()
    cError  := oJson:FromJson(cJson)

    //Se tiver algum erro no Parse, encerra a execução
    IF !Empty(cError)
        FwLogMsg("ERROR",, "AlterarPedido", "WSCOM01", "", "01", 'Parser Json Error')
        Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"Parser Json Error" }')
        lRet    := .F.
    Else
        //Lendo os dados obrigatórios do JSON
        cPedido                 := Alltrim(oJson:GetJsonObject('noPedido'))
        cCodFornecedorSimpleFarm := Alltrim(oJson:GetJsonObject('noFornecedor'))

        // ETAPA 1: Validar se o Pedido de Compras existe
        dbSelectArea("SC7")
        SC7->(dbSetOrder(1)) // Ordem C7_FILIAL + C7_NUM
        SC7->(dbGoTop())

        If SC7->(dbSeek(xFilial("SC7") + cPedido))

            // ETAPA 2: Buscar o Fornecedor informado no JSON pelo código customizado
            cQuery := "select A2_COD, A2_LOJA "
            cQuery += "from "+RetSqlName('SA2')+" SA2 "
            cQuery += "where A2_XCODFAR = '"+cCodFornecedorSimpleFarm+"' "
            cQuery += "and SA2.D_E_L_E_T_ = ' ' "
            cQuery += "and SA2.A2_FILIAL = '" + xFilial("SA2") + "' "
            cQuery += "order by A2_COD, A2_LOJA "

            cQuery := ChangeQuery(cQuery)
            TCQuery cQuery New Alias "QRY_SA2"
            QRY_SA2->(DbGoTop())

            If !QRY_SA2->(Eof())
                cJsonFornece := QRY_SA2->(A2_COD)
                cJsonLoja    := QRY_SA2->(A2_LOJA)
                QRY_SA2->(DbCloseArea())

                // ETAPA 3: Validar se o Fornecedor do JSON é o mesmo do Pedido de Compras
                If (cJsonFornece + cJsonLoja) != (SC7->C7_FORNECE + SC7->C7_LOJA)
                    FwLogMsg("ERROR",, "AlterarPedido", "WSCOM01", "", "01", "Tentativa de alterar PC " + cPedido + " para fornecedor " + cJsonFornece + "/" + cJsonLoja)
                    Self:SetResponse('{"noPedido":"'+cPedido+'", "infoMessage":"", "errorCode":"400" ,  "errorMessage":"Não é permitido alterar o fornecedor do Pedido de Compras." }')
                    lRet := .F.
                Else

                    // ETAPA 4: Montar o Cabeçalho para MSExecAuto
                    aadd(aCabec,{"C7_NUM"      , SC7->C7_NUM})
                    aadd(aCabec,{"C7_FORNECE"  , SC7->C7_FORNECE}) // Usar o dado da SC7
                    aadd(aCabec,{"C7_LOJA"     , SC7->C7_LOJA})    // Usar o dado da SC7

                    // Campos que *podem* ser alterados (exemplo: Cond. Pagamento)
                    If oJson:HasProperty("condicaoPago")
                        cCondPag := PadR(oJson:GetJsonObject('condicaoPago'),TamSX3("C7_COND")[1])

                        // Validação opcional da nova Cond. Pagto
                        If !(Existe("SE4",1,cCondPag))
                            FwLogMsg("ERROR",, "AlterarPedido", "WSCOM01", "", "01", "Condicao de Pagamento: "+ Alltrim(cCondPag) +" nao existe!")
                            Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"404" ,  "errorMessage":"Condicao de Pagamento '+ Alltrim(cCondPag) +' nao existe" }')
                            lRet := .F.
                        Endif
                        
                        If lRet // Só adiciona se a condição for válida
                            aadd(aCabec,{"C7_COND" , cCondPag})
                        Endif
                    Else
                        aadd(aCabec,{"C7_COND" , SC7->C7_COND}) // Mantém a original
                    Endif

                    // Manter demais campos do cabeçalho original
                    aadd(aCabec,{"C7_EMISSAO"  , SC7->C7_EMISSAO})
                    aadd(aCabec,{"C7_CONTATO"  , SC7->C7_CONTATO})
                    aadd(aCabec,{"C7_FILENT"   , SC7->C7_FILENT})

                    // ETAPA 5: Lendo e montando os Itens (COM LÓGICA DE INCLUSÃO/ALTERAÇÃO)
                    oItems  := oJson:GetJsonObject('items')
                    IF ValType( oItems ) == "A"

                        SC7->(dbSetOrder(2))
                        For i   := 1 To Len (oItems)
                            
                            // cItem pode ser "0001" (alteração) ou "" (inclusão)
                            cItem    := AllTrim(oItems[i]:GetJsonObject( 'item' ))
                            cProduto := PadR(AllTrim(oItems[i]:GetJsonObject( 'produto' )),TamSX3("C7_PRODUTO")[1])
                            cLocal   := PadR(AllTrim(oItems[i]:GetJsonObject( 'armazem' )),TamSX3("C7_LOCAL")[1])
                            nQtde    := oItems[i]:GetJsonObject( 'quantidade' )
                            nValor   := oItems[i]:GetJsonObject( 'precoUnitario' )
                            cXSimpleFarm := PadR(AllTrim(oItems[i]:GetJsonObject('xsimple')),TamSX3("C7_XSIMPLE")[1])
                            cXConSimpleFarm := PadR(AllTrim(oItems[i]:GetJsonObject('xconsi')),TamSX3("C7_XCONSI")[1])
                            nTotal   := nQtde * nValor

                            //Verifica se o produto existe (válido para ambos os casos)
                            If !(Existe("SB1",1,cProduto))
                                FwLogMsg("ERROR",, "AlterarPedido", "WSCOM01", "", "01", "Produto: "+ Alltrim(cProduto) +" nao existe!")
                                Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"404" ,  "errorMessage":"O produto '+ Alltrim(cProduto) +' nao existe" }')
                                lRet := .F.
                                Exit // Sai do FOR
                            Endif

                            aItem:= {}
                            aAdd(aItem,{"C7_ITEM"   , PADL(cItem,4,"0") , NIL})
                            aAdd(aItem,{"C7_PRODUTO", cProduto          , NIL})
                            aAdd(aItem,{"C7_QUANT"  , nQtde             , NIL})
                            aAdd(aItem,{"C7_PRECO"  , nValor            , NIL})
                            aAdd(aItem,{"C7_TOTAL"  , nTotal            , NIL})
                            aAdd(aItem,{"C7_LOCAL"	, cLocal		, NIL})
                            aAdd(aItem,{"C7_XSIMPLE", cXSimpleFarm	    , NIL})
                            aAdd(aItem,{"C7_XCONSI" , cXConSimpleFarm   ,NIL})

                            IF SC7->(dbSeek(xFilial("SC7") + cPedido + cItem))
                                aAdd(aItem,{"LINPOS"    , "C7_ITEM" ,PADL(cItem,4,"0")})
                            ELSE
                                // Inclusão (Não adiciona LINPOS)
                            ENDIF

                            // Esta linha é CRUCIAL:
                            // Diz ao MSExecAuto para NÃO deletar os itens do pedido
                            // que não foram enviados neste JSON.
                            //aadd(aItem,{"AUTDELETA" , "N"               , Nil})

                            aAdd(aItens,aItem)
                        Next // Fim do For i...

                        // ETAPA 6: Executar a alteração (Somente se lRet for verdadeiro)
                        If lRet
                            FwLogMsg("INFO",, "AlterarPedido", "WSCOM01", "", "01", "MSExecAuto - Operação 4 (Alterar/Incluir)")
                            MSExecAuto({|a,b,c,d,e| MATA120(a,b,c,d,e)},1,aCabec,aItens,4,.F.)

                            //Se houve erro...
                            IF lMsErroAuto
                                RollBackSX8() // Importante adicionar o Rollback
                                cArqLog  := "AlterarPedido-" + cPedido + "-" + DTOS(dDataBase) + "-" + StrTran(Time(), ':' , '-' )+".log"
                                aLogAuto := {}
                                aLogAuto := GetAutoGrLog()
                                cError   := GravaLog(cArqLog,aLogAuto)

                                FwLogMsg("ERROR",, "AlterarPedido", "WSCOM01", "", "01", cError )
                                Self:SetResponse('{"noPedido":"'+cPedido+'", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"Erro ao alterar: '+ Alltrim(cError) +'" }')
                                lRet    := .F.
                            ELSE
                                ConfirmSX8() // Importante confirmar a transação SX8
                                FwLogMsg("INFO",, "AlterarPedido", "WSCOM01", "", "01", "Pedido alterado: " + cPedido)
                                Self:SetResponse('{"noPedido":"'+cPedido+'", "infoMessage":"PEDIDO ALTERADO COM SUCESSO", "errorCode":"", "errorMessage":"" }')
                            EndIF
                        Endif

                    Else
                        FwLogMsg("ERROR",, "AlterarPedido", "WSCOM01", "", "01", "Item nao informado")
                        Self:SetResponse('{"noPedido":"'+cPedido+'", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"Nenhum item informado para alteração" }')
                        lRet    := .F.
                    Endif
                Endif // Fim da validação de Fornecedor (Etapa 3)

            Else
                // ELSE Faltante da ETAPA 2
                QRY_SA2->(DbCloseArea())
                FwLogMsg("ERROR",, "AlterarPedido", "WSCOM01", "", "01", "Fornecedor (SimpleFarm): "+ Alltrim(cCodFornecedorSimpleFarm) +" nao existe!")
                Self:SetResponse('{"noPedido":"'+cPedido+'", "infoMessage":"", "errorCode":"404" ,  "errorMessage":"O fornecedor (JSON) '+ cCodFornecedorSimpleFarm +' nao foi encontrado" }')
                lRet := .F.
            EndIf
        Else
            // ELSE da ETAPA 1
            FwLogMsg("ERROR",, "AlterarPedido", "WSCOM01", "", "01", "Pedido: "+ Alltrim(cPedido) +" nao existe!")
            Self:SetResponse('{"noPedido":"'+cPedido+'", "infoMessage":"", "errorCode":"404" ,  "errorMessage":"O pedido de compras '+ cPedido +' nao existe" }')
            lRet := .F.
        Endif
    Endif

    FreeObj(oJson)
Return(lRet)

/*
método DELETE - Excluir Pedido de Compras
exemplo: http://localhost:3000/rest/PedidoCompras/ExcluirPedido
*/
WSMETHOD DELETE ExcluirPedido WSSERVICE zPedidoCompras
	Local lRet      := .T.
	Local oJson     := Nil
	Local cJson     := Self:GetContent()
	Local cError    := ""
    Local cPedido   := ""
    Local cFornLoja := ""
    Local cFornece  := ""
    Local cLoja     := ""
    Local aCabec    := {}
    Local aItens    := {}

	Private lMsErroAuto    := .F.
	Private lMsHelpAuto    := .T.
	Private lAutoErrNoFile := .T.

	//Se não existir o diretório de logs dentro da Protheus Data, será criado
	IF !ExistDir(PATHLOGSW)
		MakeDir(PATHLOGSW)
	EndIF

    FwLogMsg("INFO",, "ExcluirPedido", "WSCOM01", "", "01", "Iniciando")

	//Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
	Self:SetContentType("application/json")
	oJson   := JsonObject():New()
	cError  := oJson:FromJson(cJson)

	//Se tiver algum erro no Parse, encerra a execução
	IF !Empty(cError)
		FwLogMsg("ERROR",, "ExcluirPedido", "WSCOM01", "", "01", 'Parser Json Error')
        Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"Parser Json Error" }')
		lRet    := .F.
	Else
        //Lendo o cabeçalho do arquivo JSON
        cPedido  := Alltrim(oJson:GetJsonObject('noPedido'))
        cFornLoja:= Alltrim(oJson:GetJsonObject('noFornecedor'))
		cFornece := Left(cFornLoja,6)
		cLoja    := Right(cFornLoja,2)

        //Verifica se o fornecedor existe			    
        If !(Existe("SA2",1,cFornLoja))
            FwLogMsg("ERROR",, "ExcluirPedido", "WSCOM01", "", "01", "Fornecedor: "+ Alltrim(cFornLoja) +" nao existe!")
            Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"404" ,  "errorMessage":"O fornecedor '+ cFornece + " - loja " + cLoja +' nao existe" }')
            FreeObj(oJson)
            Return(.F.)
        Endif

        //Verifica se o pedido de compras existe			    
        dbSelectArea("SC7")
        SC7->(dbSetOrder(1))
        SC7->(dbGoTop())
        If SC7->(dbSeek(xFilial("SC7") + cPedido))
            //Monta o cabeçalho do pedido de compras apenas se houver itens
            aadd(aCabec,{"C7_NUM"       , cPedido})
            aadd(aCabec,{"C7_FORNECE"   , cFornece})
            aadd(aCabec,{"C7_LOJA"      , cLoja})

            //Executa a inclusão automática de pedido de compras
            FwLogMsg("INFO",, "ExcluirPedido", "WSCOM01", "", "01", "MSExecAuto")
            MSExecAuto({|a,b,c,d,e| MATA120(a,b,c,d,e)},1,aCabec,aItens,5,.F.)

            //Se houve erro, gera um arquivo de log dentro do diretório da protheus data
            IF lMsErroAuto
                cArqLog  := "ExcluirPedido-" + cFornLoja + "-" + DTOS(dDataBase) + "-" + StrTran(Time(), ':' , '-' )+".log"
                aLogAuto := {}
                aLogAuto := GetAutoGrLog()                
                cError   := GravaLog(cArqLog,aLogAuto)

                FwLogMsg("ERROR",, "ExcluirPedido", "WSCOM01", "", "01", cError )
                Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"'+ Alltrim(cError) +'" }')
                lRet    := .F.
            ELSE
                FwLogMsg("INFO",, "ExcluirPedido", "WSCOM01", "", "01", "Pedido Excluido: " + cPedido)
                Self:SetResponse('{"noPedido":"'+cPedido+'", "infoMessage":"PEDIDO EXCLUIDO COM SUCESSO", "errorCode":"", "errorMessage":"" }')
            EndIF
        Else
            FwLogMsg("ERROR",, "ExcluirPedido", "WSCOM01", "", "01", "Pedido: "+ Alltrim(cPedido) +" nao existe!")
            Self:SetResponse('{"noPedido":"", "infoMessage":"", "errorCode":"404",  "errorMessage":"O pedido de compras '+ cPedido +' nao existe" }')
            FreeObj(oJson)
            lRet := .F.
        Endif               
    Endif

	FreeObj(oJson)
Return(lRet)

//Função para consulta simples se um registro existe
//Sintaxe: Existe("SB1",1,"090100243")
//Retorno: .F. ou .T.
Static Function Existe(cTabela,nOrdem,cConteudo)
    Local lRet   := .F.

    dbSelectArea(cTabela)
    (cTabela)->(dbSetOrder(nOrdem))
    (cTabela)->(dbGoTop())
    If (cTabela)->(dbSeek(xFilial(cTabela) + cConteudo))
        lRet := .T.
    Endif
Return(lRet)

Static Function GravaLog(cArqLog,aLogAuto)
    Local i     := 0
    Local cErro := ""

    For i := 1 To Len(aLogAuto)
        cErro += EncodeUTF8(aLogAuto[i])+CRLF
    Next i

    MemoWrite(PATHLOGSW + "\" + cArqLog,cErro)
Return(cErro)
