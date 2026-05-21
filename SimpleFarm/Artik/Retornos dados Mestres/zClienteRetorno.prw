#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"


WSRESTFUL zRetornoCli DESCRIPTION 'Atualização de Campos Customizados no ERP Protheus'
    //Atributos
    WSDATA id         AS STRING
 
    //Métodos
    WSMETHOD GET    ID     DESCRIPTION 'Retorna o registro pesquisado V1' WSSYNTAX '/zRetornoCli/get_id?{id}'                       PATH 'get_id'        PRODUCES APPLICATION_JSON
    WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro V1'       WSSYNTAX '/zRetornoCli/update?{id}'                            PATH 'update'        PRODUCES APPLICATION_JSON
END WSRESTFUL


WSMETHOD GET ID WSRECEIVE id WSSERVICE zRetornoCli
    Local lRet       := .T.
    Local jResponse  := JsonObject():New()
    Local cAliasWS   := 'SA1'

    //Se o id estiver vazio
    If Empty(::id)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(14))

        //Se não encontrar o registro
        If ! (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::id))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'ID002'
            jResponse['error']    := 'ID não encontrado'
            jResponse['solution'] := 'Código ID não encontrado na tabela ' + cAliasWS
        Else
            //Define o retorno
            jResponse['xdtint'] := (cAliasWS)->A1_XDTINT 
            jResponse['xsinte'] := (cAliasWS)->A1_XSINTE 
            jResponse['xobs'] := (cAliasWS)->A1_XOBS 
        EndIf
    EndIf

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT UPDATE WSRECEIVE id WSSERVICE zRetornoCli
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
		FwLogMsg("ERROR",, "zRetornoCli", "Update", "", "01", 'Parser Json Error')
        Self:SetResponse('{"zRetornoCli":"", "infoMessage":"", "errorCode":"500" ,  "errorMessage":"Parser Json Error" }')
		lRet    := .F.
	Else
        cXdTinit    := sTod(Alltrim(oJson:GetJsonObject( 'xdtint' )))
        cXsinte     := Alltrim(oJson:GetJsonObject( 'xsinte' ))
        cXobs       := Alltrim(oJson:GetJsonObject( 'xobs' ))
        If Empty(::id)
            FwLogMsg("ERROR",, "zRetornoCli", "Update", "", "01", "Update: Id não encontrado!")
            Self:SetResponse('{"Update":"", "infoMessage":"", "errorCode":"404" ,  "errorMessage":" nao existe" }')
            FreeObj(oJson)
            Return(.F.)
        Endif
            dbselectarea("SA1")  
            SA1->(dbsetorder(14))
            SA1->(dbGoTop())
            If SA1->(dbseek(xfilial("SA1")+::id))
                RecLock("SA1",.f.)
                    SA1->(A1_XDTINT) := cXdTinit
                    SA1->(A1_XSINTE) := cXsinte
                    SA1->(A1_XOBS) := cXobs
                SA1->(MsUnLock())   
                Self:SetResponse('Registro Alterado ' + ::id)
            Else
                Self:SetResponse('Registro não encontrado ' + ::id)
            EndIf       
        EndIf
   
Return lRet
