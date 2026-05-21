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

WSRESTFUL ContratoAlgodao DESCRIPTION "Serviço REST Contratos Algodao"
	

    WSMETHOD POST IncluiPagar DESCRIPTION "Incluir Contrato Algodao" ;
    WSSYNTAX "/edf/v1/ContratoAlgodao/IncluirContrato" ;
    PATH "/edf/v1//ContratoAlgodao/IncluirContrato";
	PRODUCES APPLICATION_JSON

    WSMETHOD PUT AlterarTituo ; 
    DESCRIPTION "Alterar Contrato Algodao" ;
    WSSYNTAX "/edf/v1//ContratoAlgodao/AlterarContrato/{ID}" ;
    PATH "/edf/v1//ContratoAlgodao/AlterarContrato";
	PRODUCES APPLICATION_JSON

    WSMETHOD DELETE ExcluirContrato ; 
    DESCRIPTION "Excluir Contrato Algodao" ;
    WSSYNTAX "/edf/v1//ContratoAlgodao/ExcluirContrato/{ID}" ;
    PATH "/edf/v1//ContratoAlgodao/ExcluirContrato";
	PRODUCES APPLICATION_JSON

    

END WSRESTFUL


/*
	Metodo para retornar o token de autenticacao.
*/
WSMETHOD POST IncluirContrato WSSERVICE ContratoAlgodao				
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
	Local cNumero	:= ""
	Local cParcel	:= ""
	Local cTipTit	:= ""
	Local cIDTit	:= ""
	Local cOper		:= ""
    Local aVetSE2   := {}
	Local cMensagem	:= ""
	Local cMsgError	:= ""
	Local lRet		:= .T.	
    
    Private lMsErroAuto := .F.

	If	Len(oResponse:DADOS) > 0
		
		cRetJSON += '{'
		cRetJSON += '	"RETORNO_INCLUSAO": [

		For nRecord := 1 To Len(oResponse:DADOS)

			// Pega os dados para retorno do JSON
			cCodFil	:= AvKey(IIf(AttIsMemberOf(oResponse:DADOS[nRecord],"FILIAL_TITULO"),oResponse:DADOS[nRecord]:FILIAL_TITULO,""),"E2_FILIAL")
			cPrefix	:= AvKey(IIf(AttIsMemberOf(oResponse:DADOS[nRecord],"PREFIXO_TITULO"),oResponse:DADOS[nRecord]:PREFIXO_TITULO,""),"E2_PREFIXO")
			cNumero	:= AvKey(IIf(AttIsMemberOf(oResponse:DADOS[nRecord],"NUMERO_TITULO"),oResponse:DADOS[nRecord]:NUMERO_TITULO,""),"E2_NUM")
			cParcel	:= AvKey(IIf(AttIsMemberOf(oResponse:DADOS[nRecord],"PARCELA_TITULO"),oResponse:DADOS[nRecord]:PARCELA_TITULO,""),"E2_PARCELA")
			cTipTit	:= AvKey(IIf(AttIsMemberOf(oResponse:DADOS[nRecord],"TIPO_TITULO"),oResponse:DADOS[nRecord]:TIPO_TITULO,""),"E2_TIPO")
			cIDTit	:= AvKey(IIf(AttIsMemberOf(oResponse:DADOS[nRecord],"ID_TITULO"),oResponse:DADOS[nRecord]:ID_TITULO,""),"E2_XIDSP")
			cOper	:= AvKey(IIf(AttIsMemberOf(oResponse:DADOS[nRecord],"OPERACAO"),oResponse:DADOS[nRecord]:OPERACAO,"I"),"E2_XOPSP")

			If	!Empty(cCodFil)

				cMsgError	:= ""
	
					
						ZX3_FILIAL      := oResponse:DADOS[nRecord]:FILIAL_TITULO
						ZX3_CODIGO      := oResponse:DADOS[nRecord]:CODIGO
						ZX3_FORNEC      := oResponse:DADOS[nRecord]:FORNECEDOR
						ZX3_LOJA        := oResponse:DADOS[nRecord]:LOJA
						ZX3_DATA        := oResponse:DADOS[nRecord]:DATAINICIO
						ZX3_VIGENC      := oResponse:DADOS[nRecord]:DATAFIM
						ZX3_CONDPG      := oResponse:DADOS[nRecord]:CONDPAGAMENTO
						ZX3_MOEDA       := oResponse:DADOS[nRecord]:MOEDA
						ZX3_MOEPG       := oResponse:DADOS[nRecord]:MOEDAPAGAMENTO
						ZX3_PROUTO      := oResponse:DADOS[nRecord]:PRODUTO
						ZX3_QUANTI      := oResponse:DADOS[nRecord]:QUANTIDADE
						ZX3_UM          := oResponse:DADOS[nRecord]:UM
						ZX3_VALOR       := oResponse:DADOS[nRecord]:VALORUNITARIO
						ZX3_VLRTOT      := oResponse:DADOS[nRecord]:VALORTOTAL
						ZX3_COTAFI      := oResponse:DADOS[nRecord]:COTACAOFIXA
						ZX3_TIPOCO      := oResponse:DADOS[nRecord]:'1'
					
										
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

