#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"


WSRESTFUL zTransportadoraRetorno DESCRIPTION 'Atualização de Campos Customizados no ERP Protheus'
    //Atributos
    WSDATA id         AS STRING
 
    //Métodos
    WSMETHOD GET    ID     DESCRIPTION 'Retorna o registro pesquisado' WSSYNTAX '/zTransportadoraRetorno/get_id?{id}'                       PATH 'get_id'        PRODUCES APPLICATION_JSON
    WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro'       WSSYNTAX '/zTransportadoraRetorno/update?{id}'                            PATH 'update'        PRODUCES APPLICATION_JSON
END WSRESTFUL


WSMETHOD GET ID WSRECEIVE id WSSERVICE zTransportadoraRetorno
    Local lRet       := .T.
    Local jResponse  := JsonObject():New()
    Local cAliasWS   := 'SA4'

    //Se o id estiver vazio
    If Empty(::id)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(5))

        //Se não encontrar o registro
        If ! (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::id))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'ID002'
            jResponse['error']    := 'ID não encontrado'
            jResponse['solution'] := 'Código ID não encontrado na tabela ' + cAliasWS
        Else
            //Define o retorno
            jResponse['xdtint'] := (cAliasWS)->A4_XDTINT 
            jResponse['xsinte'] := (cAliasWS)->A4_XSINTE 
            jResponse['xobs'] := (cAliasWS)->A4_XOBS 
        EndIf
    EndIf

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT UPDATE WSRECEIVE id WSSERVICE zTransportadoraRetorno
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
		FwLogMsg("ERROR",, "zRetornoTransportadora", "Update", "", "01", 'Parser Json Error')
        Self:SetResponse('{"zRetornoTransportadora":"", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"Parser Json Error" }')
		lRet    := .F.
	Else
        cXdTinit    := sTod(Alltrim(oJson:GetJsonObject( 'xdtint' )))
        cXsinte     := Alltrim(oJson:GetJsonObject( 'xsinte' ))
        cXobs       := Alltrim(oJson:GetJsonObject( 'xobs' ))
        If Empty(::id)
            FwLogMsg("ERROR",, "zRetornoTransportadora", "Update", "", "01", "Update: Id não encontrado!")
            Self:SetResponse('{"Update":"", "infoMessage":"", "errorCode":"404" ,  "errorMessage":" nao existe" }')
            FreeObj(oJson)
            Return(.F.)
        Endif
            dbselectarea("SA4")  
            SA4->(dbsetorder(5))
            SA4->(dbGoTop())
            If SA4->(dbseek(xfilial("SA4")+::id))
                RecLock("SA4",.f.)
                    SA4->(A4_XDTINT) := cXdTinit
                    SA4->(A4_XSINTE) := cXsinte
                    SA4->(A4_XOBS) := cXobs
                SA4->(MsUnLock())   
                Self:SetResponse('Registro Alterado v1 ' + ::id)
            Else
                Self:SetResponse('Registro não encontrado v1 ' + ::id)
            EndIf       
        EndIf
   
Return lRet
