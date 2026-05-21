#INCLUDE 'PROTHEUS.CH'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.ch'
#Include "TOTVS.CH"
#Include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"   
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TBICODE.CH"

/*/{Protheus.doc} WSRIncluiPagar

Serviço REST responsável por incluir os dados do título a pagar / fornecedor.

@author	Jose Eustaquio Ladeira Jr
@since 	25/06/2021

/*/ 

WSRESTFUL ContasPagar DESCRIPTION "Serviço REST Post dos Títulos a Pagar"
	
WSMETHOD POST DESCRIPTION "Incluir os Títulos a Pagar"


    WSMETHOD GET ConsultarExclusao;
	DESCRIPTION "Consultar se titulo pode ser excluido" ;
	WSSYNTAX "/edf/v1/ContasPagar/ConsultarExclusao/{ID}";
	PATH "/edf/v1/ContasPagar/ConsultarPedido";
	PRODUCES APPLICATION_JSON	

    WSMETHOD POST IncluiPagar DESCRIPTION "Incluir os Títulos a Pagar" ;
    WSSYNTAX "/edf/v1/ContasPagar/IncluiPagar" ;
    PATH "/edf/v1//ContasPagar/IncluiPagar";
	PRODUCES APPLICATION_JSON

    WSMETHOD PUT AlterarTituo ; 
    DESCRIPTION "Alterar Titulo Financeiro" ;
    WSSYNTAX "/edf/v1//ContasPagar/AlterarTituo" ;
    PATH "/edf/v1//ContasPagar/AlterarTituo";
	PRODUCES APPLICATION_JSON

    WSMETHOD DELETE ExcluirTitulo ; 
    DESCRIPTION "Excluir Titulo Fiananceiro" ;
    WSSYNTAX "/edf/v1//ContasPagar/ExcluirTitulo/{ID}" ;
    PATH "/edf/v1//ContasPagar/ExcluirTitulo";
	PRODUCES APPLICATION_JSON

    

END WSRESTFUL


/*
	Metodo para retornar o token de autenticacao.
*/
WSMETHOD POST IncluiPagar WSSERVICE ContasPagar				
	Local oAuthToken	:= AuthWebService():New()		
	Local oResponse		:= Nil
	Local aRetMov		:= {}
	Local cBody			:= Self:GetContent()
	Local cUserAuth		:= ""
	Local cRetJSON		:= ""
	Local cMsg			:= ""
	Local lTokenOK		:= .F.	
	Local lRet 		 	:= .F.
		
//	ConOut("Inicio WS Rest Inclui a Pagar")
	cMsg := "Inicio WS Rest Inclui a Pagar"
	FWLogMsg("INFO",, "POST", , , , cMsg, , ,)	

	// Define o tipo de retorno do metodo.
	::SetContentType("application/json")

	// Pega o usuario passsado no header para autenticacao
	cUserAuth := ::GetHeader("userAuth")

	// Valida o Token passado no aHeaders
	lTokenOK := oAuthToken:CheckToken(cUserAuth)

	If	lTokenOK

		If	FWJsonDeserialize(cBody,@oResponse)
		
			aRetMov 	:= gravaDados(oResponse)
			lRet 		:= aRetMov[01]
			cRetJSON	:= aRetMov[02]

		Else
			cRetJSON	:= "Ocorreu um erro no processamento do JSON"
		EndIf
		
	Else
		cRetJSON := oAuthToken:getLog()
	EndIf		
		
	If	lRet
		Self:SetResponse( cRetJSON )		
//		ConOut("200 - "+cRetJSON)
		cMsg := "200 - "+cRetJSON
		FWLogMsg("INFO",, "POST", , , , cMsg, , ,)	
	Else		
		SetRestFault( 400, cRetJSON )
//		ConOut("400 - "+cRetJSON)
		cMsg := "400 - "+cRetJSON
		FWLogMsg("INFO",, "POST", , , , cMsg, , ,)	
	EndIf
	
Return(lRet)


/*
	Funcao reponsável por gravar os dados da inclusão do a pagar
*/
Static Function gravaDados(oResponse)	
	Local oValid	:= Nil	
	Local nRecord	:= 0
	Local cRetJSON	:= ""
	Local cItemJSON	:= ""
	Local cStatus	:= ""	

	Local cCodFil	:= ""
	Local cPrefix	:= ""
	Local cNumero	:= ""	\
	Local cParcel	:= ""
	Local cTipTit	:= ""
	Local cIDTit	:= ""
	Local cOper		:= ""
    Local aVetSE2   := {}
	Local cMensagem	:= ""
	Local cMsgError	:= ""
	Local lRet		:= .T.	
    
    Private lMsErroAuto := .F.

	If	Len(oResponse:INCLUI_PAGAR) > 0
		
		cRetJSON += '{'
		cRetJSON += '	"RETORNO_INCLUSAO": [

		For nRecord := 1 To Len(oResponse:INCLUI_PAGAR)

			// Pega os dados para retorno do JSON
			cCodFil	:= AvKey(IIf(AttIsMemberOf(oResponse:INCLUI_PAGAR[nRecord],"FILIAL_TITULO"),oResponse:INCLUI_PAGAR[nRecord]:FILIAL_TITULO,""),"E2_FILIAL")
			cPrefix	:= AvKey(IIf(AttIsMemberOf(oResponse:INCLUI_PAGAR[nRecord],"PREFIXO_TITULO"),oResponse:INCLUI_PAGAR[nRecord]:PREFIXO_TITULO,""),"E2_PREFIXO")
			cNumero	:= AvKey(IIf(AttIsMemberOf(oResponse:INCLUI_PAGAR[nRecord],"NUMERO_TITULO"),oResponse:INCLUI_PAGAR[nRecord]:NUMERO_TITULO,""),"E2_NUM")
			cParcel	:= AvKey(IIf(AttIsMemberOf(oResponse:INCLUI_PAGAR[nRecord],"PARCELA_TITULO"),oResponse:INCLUI_PAGAR[nRecord]:PARCELA_TITULO,""),"E2_PARCELA")
			cTipTit	:= AvKey(IIf(AttIsMemberOf(oResponse:INCLUI_PAGAR[nRecord],"TIPO_TITULO"),oResponse:INCLUI_PAGAR[nRecord]:TIPO_TITULO,""),"E2_TIPO")
			cIDTit	:= AvKey(IIf(AttIsMemberOf(oResponse:INCLUI_PAGAR[nRecord],"ID_TITULO"),oResponse:INCLUI_PAGAR[nRecord]:ID_TITULO,""),"E2_XIDSP")
			cOper	:= AvKey(IIf(AttIsMemberOf(oResponse:INCLUI_PAGAR[nRecord],"OPERACAO"),oResponse:INCLUI_PAGAR[nRecord]:OPERACAO,"I"),"E2_XOPSP")

			If	!Empty(cCodFil)

				cMsgError	:= ""
	


                    aVetSE2 := {}
                    aadd(aVetSE2, {"E2_FILIAL" , oResponse:INCLUI_PAGAR[nRecord]:FILIAL_TITULO        , Nil})
                    aadd(aVetSE2, {"E2_NUM"    , oResponse:INCLUI_PAGAR[nRecord]:NUMERO_TITULO        , Nil})
                    aadd(aVetSE2, {"E2_PREFIXO", oResponse:INCLUI_PAGAR[nRecord]:PREFIXO_TITULO       , Nil})
                    aadd(aVetSE2, {"E2_PARCELA", oResponse:INCLUI_PAGAR[nRecord]:PARCELA_TITULO       , Nil})
                    aadd(aVetSE2, {"E2_TIPO"   , oResponse:INCLUI_PAGAR[nRecord]:TIPO_TITULO          , Nil})
                    aadd(aVetSE2, {"E2_NATUREZ", cNatureza                                            , Nil})
                    aadd(aVetSE2, {"E2_FORNECE", oResponse:INCLUI_PAGAR[nRecord]:FORNECEDOR           , Nil})
                    aadd(aVetSE2, {"E2_LOJA"   , oResponse:INCLUI_PAGAR[nRecord]:LOJA_FRONECEDOR      , Nil})
                    aadd(aVetSE2, {"E2_NOMFOR" , oResponse:INCLUI_PAGAR[nRecord]:NOME_FORNECEDOR      , Nil})
                    aadd(aVetSE2, {"E2_EMISSAO", oResponse:INCLUI_PAGAR[nRecord]:DATA_EMISSAO         , Nil})
                    aadd(aVetSE2, {"E2_VENCTO" , sTod(oResponse:INCLUI_PAGAR[nRecord]:DATA_VENCIMENTO), Nil})
                    aadd(aVetSE2, {"E2_VENCREA", sTod(oResponse:INCLUI_PAGAR[nRecord]:DATA_VENCIMENTO), Nil})
                    aadd(aVetSE2, {"E2_VALOR"  , Val(oResponse:INCLUI_PAGAR[nRecord]:VALOR_TITULO)    , Nil})
                    aadd(aVetSE2, {"E2_HIST"   , oResponse:INCLUI_PAGAR[nRecord]:HISTORICO            , Nil})
                    aadd(aVetSE2, {"E2_MOEDA"  , oResponse:INCLUI_PAGAR[nRecord]:MOEDA                , Nil})
                    aadd(aVetSE2, {"E2_MOEDA"  , Val(oResponse:INCLUI_PAGAR[nRecord]:PTAX)            , Nil})
                    aadd(aVetSE2, {"E2_XIDSP"  , oResponse:INCLUI_PAGAR[nRecord]:ID_TITULO            , Nil})
                    aadd(aVetSE2, {"E2_XOPSP"  , oResponse:INCLUI_PAGAR[nRecord]:OPERACAO             , Nil})
                    aadd(aVetSE2, {"E2_XCONTS" , oResponse:INCLUI_PAGAR[nRecord]:NUMERO_CONTRATO      , Nil})
                                        
					//valor em dolar    //ptax     //	

					//problema compesar PA para cessionários   //Compensação Contas a Pagar (FINA340)
					// Caso nao possuir erro, inclui o título na tabela temporaria.
					If	Empty(cMsgError)

						Begin Transaction
							    lMsErroAuto := .F.
                                MSExecAuto({|x,y| FINA050(x,y)}, aVetSE2, 3)
                                
                                //Se houve erro, mostra o erro ao usuário e desarma a transação
                                If lMsErroAuto
                                    MostraErro()
                                    DisarmTransaction()
                                EndIf
						End Transaction
																		
						cStatus		:= "200"
						cMensagem	:= "Titulo a Pagar Incluido com Sucesso!!!"

					Else
						cStatus 	:= "400"
						cMensagem	:= SubStr(cMsgError,1,Len(cMsgError)-2)
					EndIf
														

			Else
				cStatus 	:= "400"
				cMensagem	:= "Não foi informado em qual filial será feita a inclusão do título a pagar"
			EndIf
					
			// Gera o Arquivo de Retorno JSON
			cItemJSON += '{'
			cItemJSON += '	"STATUS_CODE": "'+cStatus+'"	,'
			cItemJSON += '	"FILIAL_TITULO": "'+cCodFil+'"	,'
			cItemJSON += '	"PREFIXO_TITULO": "'+cPrefix+'"	,'
			cItemJSON += '	"NUMERO_TITULO": "'+cNumero+'"	,'
			cItemJSON += '	"PARCELA_TITULO": "'+cParcel+'"	,'
			cItemJSON += '	"TIPO_TITULO": "'+cTipTit+'"	,'
			cItemJSON += '	"ID_TITULO": "'+cIDTit+'"	,'
			cItemJSON += '	"OPERACAO": "'+cOper+'"	,'
			cItemJSON += '	"MENSAGEM": "'+cMensagem+'"	'	
			cItemJSON += '},'
			
			reiniciaObjeto(@oValid)

		Next nRecord

		cRetJSON += SubStr(cItemJSON,1,Len(cItemJSON)-1)
		cRetJSON += ' 	]'
		cRetJSON += '}' 

	Else
		lRet 		:= .F.
		cRetJSON	:= "Nao existem itens a serem processados"
	EndIf

Return({lRet,cRetJSON})


/*
	Funcao para reiniciar objetos
*/
Static Function reiniciaObjeto(oObjeto)
	
	FreeObj(oObjeto)	
	oObjeto := Nil		
	
Return()

