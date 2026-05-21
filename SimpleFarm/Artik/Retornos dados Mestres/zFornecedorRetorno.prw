#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"


WSRESTFUL zFornecedorRetorno DESCRIPTION 'Atualização de Campos Customizados no ERP Protheus'
    //Atributos
    WSDATA id         AS STRING
 
    //Métodos
    WSMETHOD GET    ID     DESCRIPTION 'Retorna o registro pesquisado' WSSYNTAX '/zFornecedorRetorno/get_id?{id}'                       PATH 'get_id'        PRODUCES APPLICATION_JSON
    WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro'       WSSYNTAX '/zFornecedorRetorno/update?{id}'                            PATH 'update'        PRODUCES APPLICATION_JSON
END WSRESTFUL


WSMETHOD GET ID WSRECEIVE id WSSERVICE zFornecedorRetorno
    Local lRet       := .T.
    Local jResponse  := JsonObject():New()
    Local cAliasWS   := 'SA2'

    //Se o id estiver vazio
    If Empty(::id)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(12))

        //Se não encontrar o registro
        If ! (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::id))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'ID002'
            jResponse['error']    := 'ID não encontrado'
            jResponse['solution'] := 'Código ID não encontrado na tabela ' + cAliasWS
        Else
            //Define o retorno
            jResponse['xdtint'] := (cAliasWS)->A2_XDTINT 
            jResponse['xsinte'] := (cAliasWS)->A2_XSINTE 
            jResponse['xobs'] := (cAliasWS)->A2_XOBS 
        EndIf
    EndIf

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT UPDATE WSRECEIVE id WSSERVICE zFornecedorRetorno
    Local lRet              := .T.
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local cDirLog           := '\x_logs\'
    Local cXdTinit          := ''
    Local cXsinte           := ''
    Local cXobs             := ''  
    Local oJson             := Nil 

    Private lMsErroAuto     := .F.
    Private lMsHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.

   //Se não existir a pasta de logs, cria
    IF ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

    //Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
    Self:SetContentType('application/json')
    oJson  := JsonObject():New()
    cError := oJson:FromJson(cJson)
    If !Empty(cError)
		FwLogMsg("ERROR",, "zRetornoFornecedor", "Update", "", "01", 'Parser Json Error')
        Self:SetResponse('{"zRetornoFornecedor":"", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"Parser Json Error" }')
		lRet    := .F.
	Else
        cXdTinit    := sTod(Alltrim(oJson:GetJsonObject( 'xdtint' )))
        cXsinte     := Alltrim(oJson:GetJsonObject( 'xsinte' ))
        cXobs       := Alltrim(oJson:GetJsonObject( 'xobs' ))
        If Empty(::id)
            FwLogMsg("ERROR",, "zRetornoFornecedor", "Update", "", "01", "Update: Id não encontrado!")
            Self:SetResponse('{"Update":"", "infoMessage":"", "errorCode":"404" ,  "errorMessage":" nao existe" }')
            FreeObj(oJson)
            Return(.F.)
        Endif
            dbselectarea("SA2")  
            SA2->(dbsetorder(12))
            SA2->(dbGoTop())
            If SA2->(dbseek(xfilial("SA2")+::id))
                RecLock("SA2",.f.)
                    SA2->(A2_XDTINT) := cXdTinit
                    SA2->(A2_XSINTE) := cXsinte
                    SA2->(A2_XOBS) := cXobs
                SA2->(MsUnLock())   
                Self:SetResponse('Registro Alterado ' + ::id)
            Else
                Self:SetResponse('Registro não encontrado ' + ::id)
            EndIf       
        EndIf
   
Return lRet
