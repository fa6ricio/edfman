
*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | LeXmlRem    | Autor | Adriano Migoto Pinto                 |*
*+------------+------------------------------------------------------------+*
*|Data		  | 10/02/2012		 										   |*
*+------------+------------------------------------------------------------+*
*|Descricao   |Importa XML NF_REMESSA               					   |*
*+------------+------------------------------------------------------------+*
*|Solicitante | 														   |*
*+------------+------------------------------------------------------------+*
*|Arquivos	  | 														   |*
*+------------+------------------------------------------------------------+*
*|			   ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL 		   |*
*+-------------------------------------------------------------------------+*
*| Analista 		 |	 Data	| Motivo da alteracao					   |*
*+-------------------+----------+------------------------------------------+*
*| Yttalo P Martins  |10/07/13	|Ajuste no processo de importação pré-nota |*
*+-------------------+----------+------------------------------------------+*
*| Analista 		 |	 Data	| Motivo da alteracao					   |*
*+-------------------+----------+------------------------------------------+*
*| Luis Felipe Nasc. |11/12/14	| Alguns forn. trocaram a TAG DEMI P/ DHEMI|*
*+-------------------+----------+------------------------------------------+*
*****************************************************************************

#Include "RwMake.ch"
#Include "XMLXFUN.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


#Define _LF   Chr(10)
#Define CRLF  Chr(13)+Chr(10)

*-------------------------------------*
User Function LXmlRem(cXML,cContra,cDP)
*-------------------------------------*

Local _cRet := ""
Local lRet := .t.
memowrite("\LOGRDM\"+ALLTRIM(PROCNAME())+".LOG",Dtoc(date()) + " - " + time() + " - " +alltrim(cusername))

Private oProcess
Private lExcJob := IsBlind()
Private cXML := cXML
Private cTContra := cContra
Private cTDP := cDP
 
If !lExcJob
	// COLOCAR O MSGYESNO AQUI, ou melhor colocar a pergunta
	oProcess:=MsNewProcess():New({||fLeXml(cXML)},"Processando","Processando XML...",.T.)
	oProcess:Activate()
Else
	// fLeXml()  01/08/16 - Luis Felipe Nascimento
	lRet := fLeXml(cXML)
EndIf
Return( lRet )

*---------------------------*
Static Function fLeXml(cXML)
*---------------------------*
Local   nArqXml        	:= 0
Local   cErro          	:= ""
Local   cAviso         	:= ""
Local   cArqXml        	:= ""
Local   cArqXml2        := ""
Local   cArqXml3        := ""
Local   cNewXml        	:= ""
Local   aFiles         	:= {}
Private cEmpPad        	:= If(lExcJob,"01",cEmpAnt)
Private cFilPad        	:= If(lExcJob,"01",cFilAnt)
Private lOk            	:= .T.
Private cAssunto       	:= ""
Private cBody          	:= ""
Private lAutoErrNoFile 	:= .T.
Private cXML := cXML

If lExcJob
	RpcSetType(3)
	RpcSetEnv( cEmpPad , cFilPad , , , , "LE_XML" )
EndIf

//Private  := Trim(GetMv("MV_XXXML",.F.,"\XML\")) //"\XML\teste\"  //

//Private cLocFile := "\XML\07733867000103\"
Private cLocFile   := "\XML\"//cGetFile( '*.xml' , ' Importação NF_REMESSA(xml)', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )
Private cLocSubMain:= cLocFile+"NF_REMESSA\"
Private cLocOk     := cLocSubMain+"backup\"
Private cLocCancel := cLocSubMain+"cancelamentos\"
Private cLocLog    := cLocSubMain+"log\"
Private nHandle    := ""

Private cFrom    := GetMv("MV_RELFROM")
Private cMailTo  := GetMv("MV_XXMAIL",.F.,GetMV("MV_EERRO"))

If lExcJob
	RpcClearEnv()
EndIf

aFiles := Directory(cLocSubMain+"*.xml")

If Len(aFiles) <= 0
	Aviso("Aviso","Não há arquivos '.xml' no diretório informado!",{"Ok"})
	Return
EndIF

If !lExcJob
	oProcess:SetRegua1( Len(aFiles) )
EndIf

For nArqXml := 1 To Len(aFiles)
	
	cAliasXml  := Left(aFiles[nArqXml][1],At(".",aFiles[nArqXml][1])-1)
	
	If cXML == cAliasXml
		
		lOk        := .T.
		cArqXml    := Lower(cLocSubMain+aFiles[nArqXml][1])
		cArqXml2    := Lower(cLocOk+aFiles[nArqXml][1])
		cArqXml3    := Lower(cLocCancel+aFiles[nArqXml][1])
		cArqXml4    := StrTran( Lower(cLocLog+aFiles[nArqXml][1]) ,".xml",".html")
		
		If !lExcJob
			oProcess:IncRegua1("Processando Aquivo: "+cArqXml)
		EndIf
		
		cAssunto   := "Processamento Aquivo: "+cArqXml+" em "+DToC(Date())+" - "+Time()
		cBody      := "<Htm><br>"+CRLF
		
		cErro      := ""
		
		ConOut( FunName()+" - Inicio processamento Aquivo: "+cArqXml+" em "+DToC(Date())+" - "+Time() )
		
		cBody      += "Processamento Arquivo : "+cArqXml+"<br>"+CRLF
		cBody      += "<br>"+CRLF
		
		cAliasXml  := Left(aFiles[nArqXml][1],At(".",aFiles[nArqXml][1])-1)
		
		oXML       := XMLParserFile( cArqXml , "_",@cErro,@cAviso)
		
		If !( Empty(cErro) .And. Empty(cAviso) .And. oXml <> Nil)
			/*
			cNewXml := StrTran(cArqXml,".XML",".ERR")
			cBody   += "O Arquivo : " + cArqXml + " / Alias : " + cAliasXml + " foi renomeado para " + cNewXml + "<br>"+CRLF
			cBody   += "Arquivo com Erro : " + cErro + "<br>"+CRLF
			cBody   += cAviso + "<br>"+CRLF
			cBody   += "<br>"+CRLF
			ConOut( FunName()+" - Atencao Erro: " + cErro )
			ConOut( FunName()+" - O Arquivo " + cArqXml + " foi renomeado para " + cNewXml )
			FRename(cArqXml,cNewXml)
			*/
			nHandle := fCreate(cArqXml4)
			
			If nHandle <> -1 // Testa para ver se consegue ou nao criar o arquivo
				
				cBody   += "Arquivo com Erro : " + cErro + "<br>"+CRLF
				cBody   += cAviso + "<br>"+CRLF
				cBody   += "<br>"+CRLF
				
				FWrite(nHandle, cBody)
				FClose(nHandle)
				
				ConOut( FunName()+" - Log do Arquivo " + cArqXml4)
				ConOut( FunName()+" - Atencao Erro: " + cErro )
				
			EndIf
			
		Else
			
			If Type("oxml:_proccancnfe")="U"
				
				//cNewXml := StrTran(upper(cArqXml),".XML",If(lOk,".OK",".ERR")) // SE NAO DER CERTO VAI CONTINUAR COMO XML PRA TENTAR NOVAMENTE-ADRIANO
				
				/*
				cNewXml := StrTran(upper(cArqXml),".XML",If(lOk,".OK",".XML"))
				cBody   += "O Arquivo : " + cArqXml + " / Alias : " + cAliasXml + " foi processado com sucesso <br>"+CRLF
				cBody   += "O Arquivo : " + cArqXml + " / Alias : " + cAliasXml + " foi renomeado para " + cNewXml + "<br>"+CRLF
				cBody   += "<br>"+CRLF
				ConOut( FunName()+" - O Arquivo " + cArqXml + " Foi processado com sucesso" )
				ConOut( FunName()+" - O Arquivo " + cArqXml + " foi renomeado para " + cNewXml )
				FRename(cArqXml,cNewXml)
				// move arquivo importado para uma pasta backup
				cArqDest := cLocFile+"backup"+cNewXml
				COPY FILE &cNewXml To &cArqDest
				FErase(cNewXml)
				*/
				Begin Transaction
				
				lOk := fProcXml(oXml,cAliasXml,@lOk)
				
				If lOk == .F.
					
					nHandle := fCreate(cArqXml4)
					
					If nHandle <> -1 // Testa para ver se consegue ou nao criar o arquivo
						
						cBody   += "Arquivo com Erro : " + cErro + "<br>"+CRLF
						cBody   += cAviso + "<br>"+CRLF
						cBody   += "<br>"+CRLF
						
						FWrite(nHandle, cBody)
						FClose(nHandle)
						
						ConOut( FunName()+" - Log do Arquivo " + cArqXml4)
						ConOut( FunName()+" - Atencao Erro: " + cErro )
						
					EndIf
					
					DisarmTransaction()
					Break
					
				Else
					ConOut( FunName()+" - O Arquivo " + cArqXml + " Foi processado com sucesso" )
					COPY FILE &cArqXml To &cArqXml2
					FERASE(cArqXml)
				EndIf
				
				End Transaction
				
				Exit // 13/09/16 - Luis Felipe
				
			Else
				// move arquivo importado para uma pasta cancelamentos
				/*
				cNewXml := StrTran(upper(cArqXml),".XML",If(lOk,".OK",".XML"))
				FRename(cArqXml,cNewXml)
				cArqDest := cLocFile+"cancelamentos\"+SubStr(cNewXml,21)
				COPY FILE &cNewXml To &cArqDest
				FErase(cNewXml)
				*/
				COPY FILE &cArqXml To &cArqXml3
				FErase(cArqXml)
			EndIf
		EndIf
		cBody += "</Htm>"
		
		ConOut( FunName()+" - Final processamento Aquivo: "+cArqXml+" em "+DToC(Date())+" - "+Time() )
		
		*-----------------------------------*
		* Envio do processamento do arquivo *
		*-----------------------------------*
		If !Empty(cMailTo)
			//U__EnviaMail(cFrom,cMailTo,cAssunto,,cBody)
		EndIf  
	EndIf
	
Next nArqXml

Return(lOK) // 01/08/16 - Luis Felipe Nascimento

*------------------------------------------*
Static Function fProcXML(oXml,cAliasXml,lOk)
*------------------------------------------*
Local   nRegXml,cTpMov,aMovim := {}
Local a, nw, X_X, nMovim
Private cnfmae 		:= Space(TamSx3("F1_DOC")[1])
Private cSERImae 	:= Space(TamSx3("F1_SERIE")[1])
Private xPedido  	:= Space(TamSx3("C7_NUM")[1])
Private xContra  	:= Space(TamSx3("C7_CONTRAT")[1])
Private XPeriod  	:= Space(TamSx3("C7_XPERIOD")[1])
Private cCONTRA 	:= Space(TamSx3("C7_CONTRAT")[1])
Private cPERIODO 	:= Space(TamSx3("C7_XPERIOD")[1])
Private nVOLUME 	:= ""
PRIVATE XCNPJ   	:= ""
PRIVATE XNOMFOR 	:= ""
PRIVATE XCONDPAG 	:= ""

pRivate lMae := .T.
Private cCliFor
Private cLoja

Private cTES := ""
Private nVlrMae := 0

If lExcJob
	RpcSetType(3)
	RpcSetEnv( cEmpPad , cFilPad , , , , "LE_XML" )
EndIf

cAliasTrb := GetNextAlias()

*--------------------------*
* Cria Arquivo de Trabalho *
*--------------------------*

aCampos := {{ "TP_DE_NOTA" , "C" , 01 , 0 , "TIPO_DE_NOTA"        ,"Left(@@,01)"                             },;
{ "FORM_PROP"  , "C" , 01 , 0 , "FORM_PROP"           ,"Left(@@,01)"                             },;
{ "TP_MOVIMEN" , "C" , 03 , 0 , "TIPO_MOVIMENTO"      ,"Left(@@,03)"                             },;
{ "NR_NFISCAL" , "C" , 09 , 0 , "NR_NFISCAL"          ,"PadR(Right(@@,09),09)"                   },;
{ "SERIE"      , "C" , 03 , 0 , "SERIE"               ,"PadR(Left(@@,03),03)"                    },;
{ "DT_EMISSAO" , "D" , 08 , 0 , "DATA_EMISSAO"        ,"SToD(@@)"                                },;
{ "CLI_FOR"    , "C" , 06 , 0 , "CLI_FOR"             ,"PadR(Right(@@,06),06)"                   },;
{ "LJ_CLI_FOR" , "C" , 02 , 0 , "LOJA_CLI_FOR"        ,"PadR(Right(@@,02),02)"                   },;
{ "ESTADO"     , "C" , 02 , 0 , "ESTADO"              ,"PadR(Right(@@,02),02)"                   },;
{ "TP_ITEM"    , "C" , 04 , 0 , "NUMERO ITEM"         ,"Left(@@,04)"                             },;
{ "COD_PROD"   , "C" , 30 , 0 , "COD_PRODUTO"         ,"PadR(Left(@@,30),30)"                    },;
{ "UNIDADE"    , "C" , 02 , 0 , "UNIDADE"             ,"PadR(Left(@@,02),02)"                    },;
{ "QUANTIDADE" , "N" , 11 , 3 , "QUANTIDADE"          ,"Val(@@)/10000"                           },;
{ "VLR_UNIT"   , "N" , 18 , 6 , "VLR_UNITARIO"        ,                },;
{ "VLR_TOTAL"  , "N" , 14 , 2 , "VLR_TOTAL"           ,"Val(@@)/100"                             },;
{ "TES"        , "C" , 03 , 0 , "TES"                 ,"PadR(Left(@@,03),03)"                    },;
{ "CFOP"       , "C" , 05 , 0 , "CFOP"                ,"PadR(Left(@@,03),03)"                    },;
{ "BASE_ICMS"  , "N" , 14 , 2 , "BASE_ICMS"           ,"Val(@@)/100"                             },;
{ "VLR_ICMS"   , "N" , 14 , 2 , "VLR_ICMS"            ,"Val(@@)/100"                             },;
{ "ALIQ_ICMS"  , "N" , 06 , 2 , "ALIQUOTA_ICMS"       ,"Val(@@)/100"                             },;
{ "TRANSP"     , "C" , 06 , 0 , "TRANSPORTADORA"      ,"Val(@@)/100"                             },;
{ "VL_SEGURO"  , "N" , 14 , 2 , "VALOR_SEGURO"        ,"Val(@@)/100"                             },;
{ "VL_FRETE"   , "N" , 14 , 2 , "VALOR_FRETE"         ,"Val(@@)/100"                             },;
{ "PESO_LIQUI" , "N" , 14 , 3 , "PESO_LIQUI"          ,"Val(@@)/100"                             },;
{ "PESO_BRUTO" , "N" , 14 , 3 , "PESO_BRUTO"          ,"Val(@@)/100"                             },;
{ "ESPECIE"    , "C" , 20 , 0 , "ESPECIE"             ,"PadR(Left(@@,20),20)"                    },;
{ "VOLUME"     , "N" , 14 , 3 , "VOLUME"              ,"PadR(Left(@@,20),20)"                    },;
{ "NATUREZA"   , "C" , 10 , 0 , "NATUREZA"            ,"PadR(Left(@@,10),10)"                    },;
{ "INFNEID"   , "C" , 44 , 0 , "INFNEID"      ,"PadR(Left(@@,44),44)"                    },;
{ "COND_PAG"   , "C" , 03 , 0 , "CONDICAO_PAGTO"      ,"PadR(Left(@@,03),03)"                    },;
{ "NF_CONTRA"  , "C" , 15 , 0 , "CONTRATO"      ,"PadR(Left(@@,09),09)"                    },;
{ "NF_PERIODO"  , "C" , 10 , 0 , "PERIODO"      ,"PadR(Left(@@,03),03)"                    },;
{ "NF_LMAE"  , "C" , 01 , 0 , "TEM NFMAE"      ,"Left(@@,01)"                    },;
{ "NF_SERIMAE"  , "C" , 03 , 0 , "SERIE MAE"      ,"PadR(Left(@@,03),03)"                    },;
{ "NF_MAE" , "C" , 09 , 0 , "NF_MAE"          ,"PadR(Right(@@,09),09)"                   }}


aStru := {}
aEval(aCampos,{|x| AAdd( aStru , {x[1],x[2],x[3],x[4]} ) } )

cArqTrb  := CriaTrab(aStru,.T.)
cArqInd  := CriaTrab(Nil,.F.)
cChave   := "NR_NFISCAL+SERIE+CLI_FOR+LJ_CLI_FOR"

If Select(cAliasTrb) > 0
	(cAliasTrb)->(DbCloseArea())
Endif
DbUseArea(.T.,,cArqTrb,cAliasTrb)

(cAliasTrb)->(DbCreateIndex( cArqInd, cChave, {|| &cChave}, .F. ))
(cAliasTrb)->(DbCommitAll())
(cAliasTrb)->(DbGoTop())

(cAliasTrb)->(DbClearInd())
(cAliasTrb)->(DbSetIndex( cArqInd ))
(cAliasTrb)->(DbSetOrder(1))

nRegs := 1

If !lExcJob
	oProcess:SetRegua2( nRegs*2 )
EndIf

lFor    	:= .f.     // indica se o fornecedor incluso
lProd   	:= .f.     // indica se o produto foi incluso automaticamente
lTransp 	:= .f.     // indica se a transportadora foi inclusa automaticamente
lMAECONTRA 	:= .T.  //INDICA SE NOTA MAE/CONTARTO INFORMADO EXISTEM
//   em todos os casos acima os registros ficam posicionados para uso no execauto da rotina mata103.

For nRegXml := 1 To nRegs
	
	cnfmae := Space(TamSx3("F1_DOC")[1])
	
	If !lExcJob
		oProcess:IncRegua2()
	EndIf
	
	if Type("oxml:_NFEPROC:_NFE:_INFNFE:_DET")="U"
		nRegXml += 1
		Loop
	endif
	
	If valtype(oxml:_NFEPROC:_NFE:_INFNFE:_DET) == 'A'
		n_tam_det := LEN(oxml:_NFEPROC:_NFE:_INFNFE:_DET)
	Else
		n_tam_det := 1
	Endif
	
	For X_X := 1 to n_tam_det
		
		X_futura := iif(n_tam_det>1,alltrim(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CFOP:TEXT),alltrim(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT))
		cCFOP    := X_futura
		X_futura := substr(X_futura,2,4)
		
		//	    if OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT="72739"
		//	       alert("teste")
		//	    endif
		
		/*
		If cCFOP="5501" .Or. cCFOP="6949" .Or. cCFOP="6501"    //Nota filha
		cTES:="006"
		ElseIf cCFOP="5922" .Or. cCFOP="6501" .Or. cCFOP="6922"//Nota mãe
		cTES:="002"
		EndIf
		*/
		
		/*      23/08/13 - Luis Felipe Nascimento
		If (cCFOP=="5501" .Or. cCFOP=="6949" .Or. cCFOP=="5922" .Or. cCFOP=="6501" .Or. cCFOP=="6922") == .F.
		X_X += 1
		loop
		EndIf
		*/
//		If !X_futura $ "922/501/503/494" .AND. TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT")<>"U"  // 24/03/17 - Luis Felipe
		If !X_futura $ "922/501/502/503/494" .AND. TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT")<>"U"
			
			// BUSCA TRANSPORTADOR
			SA4->( dbSetOrder(3) ) // ordem de CNPJ da transportadora
			If !SA4->( dbSeek(xFilial("SA4")+OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT ) )
				
				// cadastra novo quando o mesmo nao existe
				lTransp := .T.
				
				dbselectarea("SA4")
				dbsetorder(1)
				SA4->(dbgobottom())
				wcodtran:=strzero(VAL(SA4->A4_COD)+1,6)
				
				RecLock("SA4",.T.)
				SA4->A4_FILIAL := xFilial("SA4")
				SA4->A4_COD    := wcodtran //GetSxeNum("SA4","A4_COD")
				SA4->A4_NOME   := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_XNOME:TEXT
				SA4->A4_NREDUZ := SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_XNOME:TEXT,1,25)
				SA4->A4_END    := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_XENDER:TEXT
				SA4->A4_MUN    := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_XMUN:TEXT
				SA4->A4_EST    := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_UF:TEXT
				SA4->A4_CGC    := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT
				SA4->A4_INSEST := OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_IE:TEXT
				MsUnLock()
			Endif
		Endif
		
		XCNPJ := ""
		XNOMFOR := ""
		
		// BUSCA FORNECEDOR
		SA2->( dbSetOrder(3) ) // ordem de CNPJ do FORNECEDOR
		If !SA2->( dbSeek(xFilial("SA2")+OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT ) )
			// cadastra novo quando nao existe
			lFor := .T.
			Alert("Fornecedor não cadastrado! Não será importado o XML.")
			/*
			RecLock("SA2",.T.)
			SA2->A2_FILIAL  := xFilial("SA2")
			SA2->A2_COD     := GetSxeNum("SA2","A2_COD")
			SA2->A2_LOJA    := "01"
			SA2->A2_NOME    := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT
			SA2->A2_NREDUZ  := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_XFANT:TEXT
			SA2->A2_END     := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XLGR:TEXT
			SA2->A2_TIPO    := "J"
			SA2->A2_EST     := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT
			SA2->A2_COD_MUN := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CMUN:TEXT
			SA2->A2_MUN     := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XMUN:TEXT
			SA2->A2_BAIRRO  := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT
			SA2->A2_CEP     := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_CEP:TEXT
			SA2->A2_TEL     := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_FONE:TEXT
			SA2->A2_CGC     := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
			SA2->A2_INSCR   := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_IE:TEXT
			SA2->A2_VINCULA := "1"
			SA2->A2_ID_REPR := "2"
			SA2->A2_B2B     := "2"
			SA2->A2_PLCRRES := "N"
			SA2->A2_PLFIL   := "N"
			SA2->A2_MSBLQL  		:= "2"
			SA2->A2_RECPIS  		:= "1"
			SA2->A2_RECCOFI 		:= "1"
			SA2->A2_RECCSLL 		:= "1"
			SA2->A2_MJURIDI 		:= "2"
			//	   SA2->A2_INSCRM  := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_IM:TEXT
			//	   SA2->A2_COMPLEM := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XCPL:TEXT
			MsUnLock()
			*/
		Endif
		
		XCNPJ := SA2->A2_CGC
		XNOMFOR := SA2->A2_NREDUZ
		//incluido temporariamente - Milton       USINA SANTA ISABEL NAO EMITE NOTA MAE E FILHAS
		/*
		If SA2->A2_COD=="000184"
		cTES	:= "009"
		EndIf
		*/
		
		*'Luis Felipe Nascimento - Inicio ----------------------------------------------------------------------------------'
		* O produto será informado a patir da NF Mãe *
		/*
		// BUSCA AMARRACAO DO PRODUTO
		SA5->( dbSetOrder(8) )  // ordem de fornecedor + loja + cod de barras , assim nao e necessario criar indice novo
		If !SA5->( dbSeek(xFilial("SA5")+ SA2->(A2_COD+A2_LOJA)+iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ) )
		// SE NAO EXISTE A AMARRACAO, CRIA-SE UMA PARA USO COM INFORME DE CADASTRAMENTO NOVO.
		
		// para criar a amarracao cria-se um novo produto no SB1, usando numeracao automatica (SXE)
		lProd := .T.
		Alert("Amarração Fornecedor X Produto não cadastrada! Favor cadastrar e importar o XML novamente.")
		/*
		RecLock("SB1",.T.)
		SB1->B1_FILIAL  	:= xFilial("SB1")
		SB1->B1_COD     	:= GetSxeNum("SB1","B1_COD")
		SB1->B1_DESC    	:= iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_XPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT)
		SB1->B1_TIPO    	:= "PA"
		SB1->B1_UM      	:= "TL"
		SB1->B1_LOCPAD  	:= "01"
		SB1->B1_UCOM    	:= dDataBase
		SB1->B1_SEGUM   	:= "SC"
		SB1->B1_MCUSTD  	:= "1"
		SB1->B1_MSBLQL  	:= "2"
		SB1->B1_ORIGEM  	:= "0"
		SB1->B1_RASTRO  	:= "N"
		SB1->B1_APROPRI 	:= "D"
		SB1->B1_TIPODEC 	:= "N"
		SB1->B1_UREV    	:= date()
		SB1->B1_DATREF  	:= date()
		SB1->B1_MRP     	:= "S"
		SB1->B1_CODBAR  	:= SB1->B1_COD
		SB1->B1_LOCALIZ 	:= "N"
		SB1->B1_CONTRAT 	:= "N"
		SB1->B1_IMPORT  	:= "N"
		SB1->B1_ANUENTE 	:= "2"
		SB1->B1_TIPOCQ  	:= "M"
		SB1->B1_SOLICIT 	:= "N"
		SB1->B1_DESPIMP 	:= "N"
		SB1->B1_AGREGCU 	:= "2"
		SB1->B1_INSS    	:= "N"
		SB1->B1_FLAGSUG 	:= "1"
		SB1->B1_CLASSVE 	:= "1"
		SB1->B1_MIDIA   	:= "2"
		SB1->B1_QTDSER  	:= 1
		SB1->B1_ATIVO   	:= "S"
		SB1->B1_CPOTENC 	:= "2"
		SB1->B1_USAFEFO 	:= "1"
		SB1->B1_ESCRIPI 	:= "3"
		SB1->B1_PIS     	:= "2"
		SB1->B1_CRICMS  	:= "0"
		SB1->B1_CSLL    	:= "2"
		SB1->B1_FETHAB  	:= "2"
		SB1->B1_COFINS  	:= "2"
		SB1->B1_POSIPI  	:= iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_NCM:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)
		MsUnLock()
		
		RecLock("SB2",.T.)
		SB2->B2_FILIAL  	:= xFilial("SB2")
		SB2->B2_COD     	:= SB1->B1_COD
		SB2->B2_LOCAL   	:= "01"
		MsUnLock()
		
		RecLock("SA5",.T.)
		SA5->A5_FILIAL  	:= xFilial("SA5")
		SA5->A5_FORNECE 	:= SA2->A2_COD
		SA5->A5_NOMEFOR 	:= SA2->A2_NOME
		SA5->A5_LOJA    	:= SA2->A2_LOJA
		SA5->A5_PRODUTO 	:= SB1->B1_COD
		SA5->A5_CODPRF  	:= iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT)
		SA5->A5_DESREF  	:= iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_XPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT)
		SA5->A5_NOMPROD 	:= iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_XPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT)
		SA5->A5_CODBAR  	:= iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT)
		MsUnLock()
		Else
		SB1->( dbSetOrder(1) )
		SB1->( dbSeek(xFilial("SB1")+SA5->A5_PRODUTO ) )
		EndIf
		*/
		*'Luis Felipe Nascimento - Fim -------------------------------------------------------------------------------------'*
		
		/*
		// POSICIONA DO CADASTRO DE TES
		SF4->( dbOrderNickName("CFOP") )
		If !SF4->( dbSeek(xFilial("SF4")+"1"+SUBSTR(iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CFOP:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT),2,4)) )
		// efetua novo cadastramento do processo para posterior reimportação ou analise
		RecLock("SF4",.T.)
		SF4->F4_FILIAL  	:= xFilial("SF4")
		SF4->F4_CODIGO  	:= GetSxeNum("SF4","F4_CODIGO")
		SF4->F4_TIPO    	:= "E"
		SF4->F4_CREDICM 	:= "N"
		SF4->F4_CREDIPI 	:= "N"
		SF4->F4_DUPLIC  	:= "S"
		SF4->F4_ESTOQUE 	:= "S"
		SF4->F4_PODER3  	:= "N"
		SF4->F4_UPRC    	:= "S"
		SF4->F4_ATUTEC  	:= "N"
		SF4->F4_ATUATF  	:= "N"
		SF4->F4_CREDST  	:= "2"
		SF4->F4_MOVPRJ  	:= "3"
		SF4->F4_QTDZERO 	:= "2"
		SF4->F4_SLDNPT  	:= "2"
		SF4->F4_DEVZERO 	:= "1"
		SF4->F4_MSBLQL  	:= "2"
		SF4->F4_FINALID 	:= OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT
		SF4->F4_PISDSZF 	:= "2"
		SF4->F4_BENSATF 	:= "2"
		SF4->F4_ICM     	:= "N"
		SF4->F4_IPI     	:= "N"
		SF4->F4_CF      	:= "1"+SUBSTR(iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CFOP:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT),2,4)
		SF4->F4_TEXTO   	:= SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT,1,20)
		SF4->F4_LFICM   	:= "N"
		SF4->F4_LFIPI   	:= "N"
		SF4->F4_DESTACA 	:= "N"
		SF4->F4_INCIDE  	:= "N"
		SF4->F4_COMPL   	:= "N"
		MsUnLock()
		
		Endif
		*/
		
		//cnfmae:=""
		//cArmaz:=""
		
		cCliFor:=SA2->A2_COD
		cLoja  :=SA2->A2_LOJA
		
		IF TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT")<>"U" /* .AND. SA2->A2_COD<>"000167"*/
			
			/*If cCFOP="5501" .OR. cCFOP="6949" .Or. cCFOP="5922" .Or. cCFOP="6501"
			
			/*
			IF SA2->A2_COD="000161" .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U" //SANTA FÉ
			If substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,at("MERC. SERA ENTREGUE", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+19,31) == "CIA AUXILIAR DE ARMAZENS GERAIS"
			cArmaz	:= "04"
			Else
			cArmaz:= substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,at("MERC.SERA ENTR.NA ", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+18,6)
			EndIf
			*/
			/*
			IF SA2->A2_COD="000167" .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U" //ALVORADA
			cArmaz:= substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,at("REMESSA COM FIM ESPECIFICO PARA EXPORTACAO LOCAL DE ENTREGA", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+123,6)
			ELSE
			cArmaz:= substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,at("LOCAL DE ENTREGA: ", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+18,6)
			ENDIF
			If SubStr(cArmaz,1,1)=="J"
			cArmaz="10"
			Else
			cArmaz="01"
			EndIf
			//CAROLO Tratamento para armazem 04 da CAROLO
			If SA2->A2_COD == "000002" .And. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
			If AllTrim(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,at("Local de Entrega do Acucar:",OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+28,37)) == "COMPANHIA AUXILIAR DE ARMAZENS GERAIS"
			cArmaz	:= '04'
			Else
			cArmaz	:= '01'
			EndIf
			//SANTA RITA tratamento para armazens
			ElseIf SA2->A2_COD == "000084" .And. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
			If AllTrim(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,at("L.ENTREGA:",OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+10,21)) == "SERRA & MARQUES LTDA"
			cArmaz	:= '01'
			ElseIf AllTrim(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,at("L.DESCARGA:",OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+11,32)) == "CIA AUXILIAR DE ARMAZENS GERAIS"
			cArmaz	:= '04'
			Else
			cArmaz	:= '01'
			EndIf
			//SANTA FE
			
			ElseIf SA2->A2_COD="346   " .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U" //SANTA FÉ // 000161 17/05/13 - Luis Felipe nascimento
			If substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,at("MERC. SERA ENTREGUE", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+19,31) == "CIA AUXILIAR DE ARMAZENS GERAIS"
			cArmaz	:= "04"
			Else
			cArmaz:= substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,at("MERC.SERA ENTR.NA ", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+18,6)
			If SubStr(cArmaz,1,1)=="J"
			cArmaz="10"
			Else
			cArmaz="01"
			EndIf
			EndIf
			//UCP
			ElseIf SA2->A2_COD == "000326" .And. Type("OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infAdFisco:TEXT")<>"U"		//UCP
			If AllTrim(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infAdFisco:TEXT,at("formacao de lote de Exportacao no ",OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infAdFisco:TEXT)+34,38)) == "COMPANHIA AUXILIAR DE ARMAZENS GERAIS"
			cArmaz	:= '04'
			Else
			cArmaz	:= ''
			EndIf
			EndIf
			EndIf
			*/
			
			cArmaz	:= "01"
			
			*'Yttalo P Martins-INICIO-------------------------------------------------------------------------------------------'*
			*'Verifica se nota de remessa possui nota mãe-----------------------------------------------------------------------'*
			
			xPedido  := Space(TamSx3("C7_NUM")[1])
			xContra  := Space(TamSx3("C7_CONTRAT")[1])
			XPeriod  := Space(TamSx3("C7_XPERIOD")[1])
			xNatur   :=""
			xNavio   :=""
			XCONDPAG := ""
			XQTDMAE  := 0
			XQTDREM  := 0
			xLSC7    := .F.
			
			If "NOTA FISCAL DE VENDA" $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT
				
				cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
				at("NOTA FISCAL DE VENDA", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+20,10);
				,".","")
				cnfmae:= PADR(ALLTRIM(cnfmae),TAMSX3("F1_DOC")[1])
				
				cSERImae:= strtran(substr( OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
				at("NOTA FISCAL DE VENDA", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+31,2);
				,".","")
				cSERImae:=PADR(ALLTRIM(cSERImae),TAMSX3("F1_SERIE")[1])
				
				nTamSerie:= TamSx3("F1_SERIE")[1]
				cSERIma  := Alltrim(cSERImae)
				cSERImae := ""
				For a:=1 to nTamSerie
					If Upper(SubStr(cSERIma,a,1)) $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
						If SubStr(cSERIma,a,1) <> " "
							cSERImae := cSERImae + SubStr(cSERIma,a,1)
						Else
							a:=100
						EndIf
					EndIf
				Next
				cSERImae := cSERImae + Space(nTamSerie-Len(cSERImae))
				
				SD1->(DbSetOrder(1))
				If !SD1->(DbSeek(xFilial("SD1")+cnfmae+cSERImae+cCliFor+cLoja))
					lMAECONTRA := LEINFCPL(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,@cnfmae,@cSERImae,@cCONTRA,@cPERIODO,OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
					//				Else // 17/12/13 - Luis Felipe Nascimento
					//					nVlrMae := SD1->D1_TOTAL
				EndIf
				
				If lMAECONTRA
					dbselectarea("SF1")
					dbsetorder(1)
					If dbseek(xFILIAL("SF1")+cnfmae+cSERImae)
						Do While !SF1->(EOF()).AND. SF1->F1_DOC=cnfmae
							If SF1->F1_FORNECE=cCliFor .AND. SF1->F1_LOJA=cLoja
								xPedido:=SF1->F1_XPEDIDO
								
								dbselectarea("SD1")
								SD1->(DbSetOrder(1))
								If SD1->(DbSeek(xFilial("SD1")+cnfmae+cSERImae+cCliFor+cLoja) )
									nVlrMae := SD1->D1_TOTAL // 17/12/13 - Luis Felipe Nascimento
									XQTDMAE := SD1->D1_QUANT
								EndIf
								
							EndIf
							SF1->(dbSkip())
						EndDo
						
						DBSELECTAREA("SC7")
						DBSETORDER(1)
						If DBSEEK(xFILIAL("SC7")+xPEDIDO).And. !Empty(xPEDIDO)
							IF !SC7->(EOF())
								xLSC7    	:= .T.
								xContra		:=SC7->C7_CONTRAT
								XPeriod		:=SC7->C7_XPERIOD
								xNavio 		:=SC7->C7_NAVIO
								cCONTRA 	:= xContra
								cPERIODO	:= XPeriod
								XCONDPAG 	:= SC7->C7_COND
								// 30/09/13 - Luís Felipe Nascimento
								/*								If SD1->D1_UM <> SD1->D1_SEGUM
								RecLock("SC7",.F.)
								nFator := U_EDFFATOR(SC7->C7_PRODUTO)
								SC7->C7_QUJE += XQTDMAE * If(nFator<>0.00,nFator,1) // Multiplica pelo fator pois a quantidade da nf recebida está em SACAS. (20 SACAS=1 TONELADA) e o PC em toneladas.
								Else
								SC7->C7_QUJE += XQTDMAE
								EndIf
								*/
								Msunlock()
							ENDIF
						Else
							lMAECONTRA := .F.
							
						EndIf
					EndIf
				Else
					lMAECONTRA := .F.
				EndIF
				
			ELSE
				
				//abre a tela para que seja INFORMADO CONTRATO, PERIODO, NOTA, SERIE
				lMAECONTRA := LEINFCPL(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,@cnfmae,@cSERImae,@cCONTRA,@cPERIODO,OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
				
				IF LMAECONTRA == .T.
					
					IF !EMPTY(cnfmae)
						
						dbselectarea("SF1")
						dbsetorder(1)
						If dbseek(xFILIAL("SF1")+cnfmae)
							Do While !SF1->(EOF()).AND. SF1->F1_DOC=cnfmae
								If SF1->F1_FORNECE=cCliFor .AND. SF1->F1_LOJA=cLoja
									xPedido:=SF1->F1_XPEDIDO
									
									dbselectarea("SD1")
									SD1->(DbSetOrder(1))
									If SD1->(DbSeek(xFilial("SD1")+cnfmae+cSERImae+cCliFor+cLoja) )
										// 17/12/13 - Luis Felipe Nascimento
										nVlrMae := SD1->D1_TOTAL
										XQTDMAE := SD1->D1_QUANT
									EndIf
									
								EndIf
								SF1->(dbSkip())
							EndDo
							
							DBSELECTAREA("SC7")
							DBSETORDER(1)
							If DBSEEK(xFILIAL("SC7")+xPEDIDO) .And. !Empty(xPEDIDO)
								IF !SC7->(EOF())
									xLSC7   := .T.
									xContra := SC7->C7_CONTRAT
									XPeriod := SC7->C7_XPERIOD
									xNavio  := SC7->C7_NAVIO
									cCONTRA := xContra
									cPERIODO:= XPeriod
									XCONDPAG:= SC7->C7_COND
									// 30/09/13 - Luís Felipe Nascimento
									/*	RecLock("SC7",.F.)
									If SD1->D1_UM <> SD1->D1_SEGUM
									nFator := U_EDFFATOR(SC7->C7_PRODUTO)
									SC7->C7_QUJE += XQTDMAE * If(nFator<>0.00,nFator,1) // Multiplica pelo fator pois a quantidade da nf recebida está em SACAS. (20 SACAS=1 TONELADA) e o PC em toneladas.
									Else
									SC7->C7_QUJE += XQTDMAE
									EndIf
									Msunlock() */
								ENDIF
							Else
								lMAECONTRA := .F.
							EndIf
							
						Else
							lMAECONTRA := .F.
						EndIF
						
					ENDIF
					
				ENDIF
				
			EndIf
			
			// 30/10/13 - Luis Felipe Nascimento - Inicio
			IF EMPTY(xPEDIDO)
				lOk := .f.
				Aviso("Atenção","Toda NF Remessa deve estar amarrada a um Pedido de Compras. Sendo assim, este documento não será importado",{"Continuar"})
				Return(lOk)
			Else
				// 31/05/17 - Luis Felipe - Inicio
				// Criticar casos em que o preço da Nota Fiscal for diferente do Pedido de Compras  

				xVlUnit := Iif(n_tam_det>1,alltrim(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNCOM:TEXT),alltrim(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT))

				cValor := ''
				nValor := 0
				For nw:=1 to Len(xVlUnit)      
					If	SubStr(xVlUnit,nw,1) <> ',' 
						cValor += SubStr(xVlUnit,nw,1)
					Else
						nValor := Val(cValor)
						cValor := ''	
					EndIf
				Next
				nValor := nValor + (Val(cValor) / Val('1'+Strzero(0,Len(cValor))))
				  
				SB1->(DbSetOrder(1))
				If SB1->(dbSeek(xFilial("SB1") + SC7->C7_PRODUTO ) )
					nDifer := Round((SC7->C7_VLFINAL * SB1->B1_CONV) * SC7->C7_TAXAUSD,2) - nValor
					If nDifer > 0.01 .or. nDifer < -0.01
					    If Type("_cDifPCxNFE") <> "U"
							_cDifPCxNFE := "Atenção: Existe diferença de R$ "+Str(nDifer,11,2)+" entre o preço unitário do documento de entrada "+OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT+" e o preço do Pedido de Compras "+SC7->C7_NUM+" !" 
					    Else
							//Alert("Atenção: Existe diferença de R$ "+Str(nDifer,11,2)+" entre o preço unitário do documento de entrada "+OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT+" e o preço do Pedido de Compras "+SC7->C7_NUM+" !" )
						EndIf 
					EndIf
				EndIf
				// 31/05/17 - Luis Felipe - Fim
			EndIF
			// 30/10/13 - Luis Felipe Nascimento - Fim
			
			/*
			//ALVORADA
			If "NOTA MAE NR." $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT .AND. SA2->A2_COD="000167"
			cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
			at("NOTA MAE NR.", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+13,6),".","")
			cnfmae:=Trim(cnfmae)
			EndIf
			
			//BAZAN
			If "NOTA FISCAL DE SIMPLES FATURAMENTO" $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT .AND. SA2->A2_COD="000007"
			cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
			at("NOTA FISCAL DE SIMPLES FATURAMENTO", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+38,6),".","")
			EndIf
			//BELA VISTA
			If "NOTA FISCAL DE VENDA" $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT .AND. SA2->A2_COD="010   " //"000003" // 17/05/13 - Luis Felipe Nascimento
			cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
			at("NOTA FISCAL DE VENDA", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+24,6),".","")
			EndIf
			//CAETE
			If SA2->A2_COD="000210" .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
			cnfmae:= STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),6)
			EndIf
			//CAROLO
			If SA2->A2_COD="000002" .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
			cnfmae:= AllTrim(STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),9))
			EndIf
			If SA2->A2_COD=="000006" //.AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
			//cnfmae:= AllTrim(STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),9))
			cnfmae:= 'B '+Trim(strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
			at("FATURADO REF. CONTRATO(S) NR.", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+30,12),".",""))
			EndIf
			
			//sta isabel REFERENTE NOTA FISCAL DE VENDA P/ ENTREGA FUTURA
			//If "REFERENTE NOTA FISCAL DE VENDA P/ ENTREGA FUTURA" $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT .AND. SA2->A2_COD="000184"
			//cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
			//at("REFERENTE NOTA FISCAL DE VENDA P/ ENTREGA FUTURA", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+53,6),".","")
			//cnfmae:=Trim(cnfmae)
			//EndIf
			//Novo Tratamento para a Usina Santa Isabel - Milton
			If "CONFORME CONTRATO " $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT .AND. SA2->A2_COD="000184"
			cnfmae:= Trim(strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
			at("CONFORME CONTRATO", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+18,13),".",""))
			cnfmae:= SubStr(cnfmae,2,3)+SubStr(cnfmae,6,3)+SubStr(cnfmae,10,3)
			//Alert(cnfmae)
			EndIf
			//UCP
			If Type("OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infAdFisco:TEXT")<>"U" .And. "ref.A Nf.para entrega futura n" $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infAdFisco:TEXT .AND. SA2->A2_COD="000326"
			cnfmae:= Trim(strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infAdFisco:TEXT,;
			at("ref.A Nf.para entrega futura n", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infAdFisco:TEXT)+30,6),".",""))
			//Alert(cnfmae)
			EndIf
			//STA.RITA
			If SA2->A2_COD="000084" .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
			cnfmae:= AllTrim(STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),6))
			EndIf
			//MARINGA
			If SA2->A2_COD="000081" .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
			cnfmae:= STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),6)
			EndIf
			//Sta Fé
			If SA2->A2_COD=="346   " .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U" // 000161 - 18/05/13 - Luis Felipe Nascimento
			//Nota fiscal de simples faturamento nro
			//cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
			//     at("Nota fiscal de simples faturamento nro", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+39,6),".","")
			//cnfmae:=ALLTrim(cnfmae)
			cnfmae:= STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),6)
			cnfmae:=ALLTRIM(cnfmae)
			EndIf
			//COMPANHIA ALBERTINA MERC. E INDUSTRIAL
			If SA2->A2_COD="000168" .AND. ", NF " $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT
			//, NF
			cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
			at(", NF ", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+5,7),".","")
			cnfmae:=AllTrim(str(val(cnfmae),9))
			EndIf
			*/
			*'Yttalo P Martins-FIM-------------------------------------------------------------------------------------------------'*
		ENDIF
		
		
		*'Luis Felipe Nascimento - 31/10/13 -Inicio ---------------------------------------------------------------------------'*
		cNFISCAL := STRZERO( VAL(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9 )
		cSerie   := OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
		cSerie   := cSerie + Space(TamSx3("F1_SERIE")[1]-Len(cSerie ))
		
		/*      01/08/16 - Luis Felipe - Inicio
		dbselectarea("SD1")
		SD1->(DbSetOrder(1))
		If SD1->(DbSeek(xFilial("SD1")+cNFISCAL+cSerie+cCliFor+cLoja) )
		Aviso("Atenção","Documento de entrada já importado "+cNFISCAL+"-"+cSerie+" !",{"Continuar"})
		lOk := .f.
		Return(lOk)
		EndIf
		01/08/16 - Luis Felipe - Fim  */
		
		*'Luis Felipe Nascimento - 31/10/13 -Fim ------------------------------------------------------------------------------'*
		
		*'Yttalo P Martins-INICIO-------------------------------------------------------------------------------------------------'*
		dbselectarea("SD1")
		SD1->(DbSetOrder(1))
		If SD1->(DbSeek(xFilial("SD1")+cnfmae+cSERImae+cCliFor+cLoja) )
			If EMPTY(SD1->D1_TES)
				Alert("Nota mãe: "+cnfmae+"-"+cSERImae+" não foi classificada")
			EndIF
		EndIf
		
		*'Luis Felipe Nascimento -------------------------------------------------------------------------------------------------'*
		SB1->(DbSetOrder(1))
		If !SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
			cProduto := Alltrim(cCONTRA)+"-"+Alltrim(cPERIODO)
			cProduto := Padr(cProduto,TamSX3("B1_COD")[1])
			If !SB1->(DbSeek(xFilial("SB1")+cProduto))
				Alert("Produto não cadastrado "+cProduto+" !")
			EndIf
		EndIf
		*'Luis Felipe Nascimento -------------------------------------------------------------------------------------------------'*
		
		*'Luis Felipe Nascimento 20/09/13 -------------------------------------------------------------------------------------------------'*
		cUM      := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_UCOM:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)
//		nQtd	 := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QTRIB:TEXT))) // 04/07/17 - Luis Felipe - Unid. Trib
		nQtd	 := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QCOM:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)))
		lKg		 := .f.
		
		If SB1->B1_UM <> cUM
			If cUM == "KG" // REVATI SA e RENUKA - Produto esta com TM
				nQtd := nQtd / 1000
				lKg	 := .t.
			Else
				If cUM $ "TM/TO/TL/TON/SCS"
					If !SB1->B1_UM $ "TM/TO/TL/SC"
						Aviso("Atenção","A unidade de medida: "+cUM+" da Nota Fiscal de Remessa: "+cNFISCAL+" é diferente da Unidade de Medida do Produto: "+SD1->D1_COD+" ! A NF Remessa será importada com unidade de medida da ED&F MAN.",{"Voltar"})
					EndIf
				Else
					If SB1->B1_UM <> cUM
						Aviso("Atenção","A unidade de medida: "+cUM+" da Nota Fiscal de Remessa: "+cNFISCAL+" é diferente da Unidade de Medida do Produto: "+SD1->D1_COD+" ! A NF Remessa será importada com unidade de medida da ED&F MAN.",{"Voltar"})
					EndIf
				EndIf
			EndIf
		EndIf
		
		*'Luis Felipe Nascimento 20/09/13 -------------------------------------------------------------------------------------------------'*
		
		//if !lFor .AND. !lProd .AND. !lTransp
		if !lFor .AND. !lProd .AND. !lTransp //.AND. lMAECONTRA == .T.
			*'Yttalo P Martins-FIM----------------------------------------------------------------------------------------------------'*
			
			(cAliasTrb)->(RecLock(cAliasTrb,.T.))
			(cAliasTrb)->TP_DE_NOTA := "N"
			// os tipo de nota fiscais sao:
			//  - N = Normal
			//  - D = Devolucao
			//  - B = Beneficiamento
			//  - I = Complento de ICMS
			//  - C = Complemento de Preco
			
			(cAliasTrb)->TP_MOVIMEN := 'NFE'
			(cAliasTrb)->FORM_PROP  := '2'
			(cAliasTrb)->TP_ITEM    := STRZERO(X_X,4)
			(cAliasTrb)->NR_NFISCAL := STRZERO( VAL(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9 )    //OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_CNF:TEXT
			(cAliasTrb)->SERIE      := OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
			
			// 11/12/14 - Luis Felipe Nascimento - Inicio
			IF Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT")<>"U"
				(cAliasTrb)->DT_EMISSAO := _CONVDTSPED(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT)
			Else
				(cAliasTrb)->DT_EMISSAO := _CONVDTSPED(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT)
			EndIf
			// 11/12/14 - Luis Felipe Nascimento - Fim
			
			(cAliasTrb)->CLI_FOR    := SA2->A2_COD
			(cAliasTrb)->LJ_CLI_FOR := SA2->A2_LOJA
			(cAliasTrb)->ESTADO     := SA2->A2_EST
			(cAliasTrb)->COD_PROD   := SB1->B1_COD
			
			//(cAliasTrb)->UNIDADE    := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_UCOM:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)//SB1->B1_UM
			
			/*
			//DISA TEMPORARIO
			If SA2->A2_COD $ '000006/000008' .And. ((cAliasTrb)->UNIDADE=="S5" .or. (cAliasTrb)->UNIDADE=="s5" .Or. (cAliasTrb)->UNIDADE=="S50")
			(cAliasTrb)->UNIDADE	:= "SC"
			EndIf
			*/
			*'Yttalo P Martins-INICIO-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------'*
			/*
			If (cAliasTrb)->UNIDADE=="tn" .or. (cAliasTrb)->UNIDADE=="TN"
			//(cAliasTrb)->VLR_UNIT
			xVlun := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT))
			if (cAliasTrb)->VLR_UNIT==0
			(cAliasTrb)->VLR_UNIT   := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNCOM:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT)))/20
			else
			(cAliasTrb)->VLR_UNIT   := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT)))/20
			endif
			(cAliasTrb)->QUANTIDADE := 20 * (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QTRIB:TEXT)))
			ElseIf (cAliasTrb)->UNIDADE=="kg" .or. (cAliasTrb)->UNIDADE=="KG"
			//(cAliasTrb)->VLR_UNIT
			xVlun := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT))
			if (cAliasTrb)->VLR_UNIT==0
			(cAliasTrb)->VLR_UNIT   := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNCOM:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT)))*50
			else
			(cAliasTrb)->VLR_UNIT   := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT)))*50
			endif
			(cAliasTrb)->QUANTIDADE := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QTRIB:TEXT)))/50
			Else
			//(cAliasTrb)->VLR_UNIT
			xVlun := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT))
			if (cAliasTrb)->VLR_UNIT==0
			(cAliasTrb)->VLR_UNIT   := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNCOM:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT))
			else
			(cAliasTrb)->VLR_UNIT   := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT))
			endif
			(cAliasTrb)->QUANTIDADE := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QTRIB:TEXT))
			EndIf
			*/
			
			xVlun := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT))
			if (cAliasTrb)->VLR_UNIT==0
				(cAliasTrb)->VLR_UNIT   := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNCOM:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT)))
			else
				(cAliasTrb)->VLR_UNIT   := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT)))
			endif
			
			*'Yttalo P Martins-FIM--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'*
			
			(cAliasTrb)->VLR_TOTAL  := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VPROD:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT))
			
			//(cAliasTrb)->TES        := SF4->F4_CODIGO
//			//(cAliasTrb)->CFOP       := SF4->F4_CF   // 24/03/17 - Luis Felipe
			
			(cAliasTrb)->BASE_ICMS  := VAL(OXML:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT)
			(cAliasTrb)->VLR_ICMS   := VAL(OXML:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT)
			(cAliasTrb)->ALIQ_ICMS  := 0
//			(cAliasTrb)->TRANSP     := If( X_futura$"922/501/494","", SA4->A4_COD) // 24/03/17 - Luis Felipe
			(cAliasTrb)->TRANSP     := If( X_futura$"922/501/502/494","", SA4->A4_COD)
			(cAliasTrb)->VL_SEGURO  := 0
			(cAliasTrb)->VL_FRETE   := 0
			(cAliasTrb)->PESO_LIQUI := IIF(TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT")<>"U",val(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT),0)
			(cAliasTrb)->PESO_BRUTO := IIF(TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT")<>"U",val(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT),0)
			(cAliasTrb)->ESPECIE    := "NFE"
			(cAliasTrb)->VOLUME     := IIF(TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT")<>"U",VAL(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT),0)
			(cAliasTrb)->NATUREZA   := ''
			(cAliasTrb)->COND_PAG   := IIF(EMPTY(XCONDPAG),"001",XCONDPAG)//'001' //Adriano - Tirar condição de pagamento fixa e buscar no contrato.
			
			// (cAliasTrb)->QUANTIDADE  := (cAliasTrb)->PESO_LIQUI
			
			If lKg
				(cAliasTrb)->QUANTIDADE := nQtd
			Else
	 //			(cAliasTrb)->QUANTIDADE  := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QTRIB:TEXT)))// 04/07/17 - Luis Felipe - Unid. Trib
				(cAliasTrb)->QUANTIDADE  := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QCOM:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QCOM:TEXT)))
			EndIf
			
			(cAliasTrb)->UNIDADE     := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_UCOM:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)
			
			(cAliasTrb)->INFNEID    := Substr(OXML:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,44)
			
			(cAliasTrb)->NF_MAE     := cnfmae
			(cAliasTrb)->NF_SERIMAE := cSERImae
			(cAliasTrb)->NF_CONTRA     := cCONTRA
			(cAliasTrb)->NF_PERIODO    := cPERIODO
			(cAliasTrb)->NF_LMAE    := IIF(lMae == .T.,"S","N")
			
			(cAliasTrb)->(MsUnLock())
			
		ELSE
			lOk   := .F.
			lErro := .T.
			
			*'Yttalo P Martins-INICIO-------------------------------------------------------------------------------------------------'*
			IF lMAECONTRA == .F.
				MsgStop("Verifique nota mãe/contrato informados. Nota: "+(cAliasTrb)->NR_NFISCAL+" não importada !!!")
			ENDIF
			*'Yttalo P Martins-FIM----------------------------------------------------------------------------------------------------'*
			
			// adriano 06/6/11 - acrescentei as linhas abaixo em 06/6/11
			(cAliasTrb)->(DbCloseArea())
			FErase(cArqInd+IndexExt())
			
			RETURN(lOK)
		ENDIF
		
	Next X_X
	
	// envia e-mail com a necessidade de cadastramento / revisao de informacoes dos cadastros
	
	// incluir a rotina aqui .... usando as variaveis lFor, lProd e lTransp
	
	If AScan(aMovim,(cAliasTrb)->TP_MOVIMEN) == 0 .and. !lFor .and. !lProd .and. !lTransp
		AAdd( aMovim , (cAliasTrb)->TP_MOVIMEN )
	EndIf
	
	lFor    :=.F.
	lProd   :=.F.
	lTransp :=.F.
	
Next nRegXml
(cAliasTrb)->(DbCloseArea())
FErase(cArqInd+IndexExt())

If lExcJob
	RpcClearEnv()
EndIf

For nMovim := 1 To Len(aMovim)
	cTpMov  := Right(aMovim[nMovim],3)
	
	//	cEmpAnt := Left(aMovim[nMovim],2)
	//	cFilAnt := SubStr(aMovim[nMovim],3,2)
	cEmpAnt := SM0->M0_CODIGO
	cFilAnt := SM0->M0_CODFIL
	
	If lExcJob
		RpcSetType(3)
		RpcSetEnv( cEmpAnt, cFilAnt, , , , "LE_XMLREM" )
	EndIf
	
	If Select(cAliasTrb) > 0
		(cAliasTrb)->(DbCloseArea())
	Endif
	DbUseArea(.T.,,cArqTrb,cAliasTrb)
	
	cArqInd  := CriaTrab(Nil,.F.) // 15/05/13 - Luis Felipe Nascimento
	
	(cAliasTrb)->(DbCreateIndex( cArqInd, cChave, {|| &cChave}, .F. ))
	(cAliasTrb)->(DbCommitAll())
	(cAliasTrb)->(DbGoTop())
	
	(cAliasTrb)->(DbClearInd())
	(cAliasTrb)->(DbSetIndex( cArqInd ))
	(cAliasTrb)->(DbSetOrder(1))
	
	If cTpMov$"NFE|PRE"
		
		
		// Adriano comentar as linhas abaixo antes de colocar em produção.
		//cnfmae :="48140    " // ADRIANO - PARA TESTES EM 10/02/2012
		//cCliFor:="000007"    // ADRIANO - PARA TESTES EM 10/02/2012
		//cLoja  :="01"        // ADRIANO - PARA TESTES EM 10/02/2012
		
		*'Yttalo P Martins-INICIO-------------------------------------------------------------------------------------------'*
		/*
		dbselectarea("SF1")
		dbsetorder(1)
		dbseek(xFILIAL("SF1")+cnfmae)
		If SF1->(EOF()) //.AND. SF1->F1_FORNECE= .AND. SF1->F1_LOJA=
		
		If SA2->A2_COD = '000184'	.Or. SA2->A2_COD = '000006'//Usina Sta Isabel nao possui fatura e remessa/nf mae e filha
		fProcNFE(cFilAnt,cTpMov,cAliasTrb,@lOk)
		Else
		fProcNFx(cFilAnt,cTpMov,cAliasTrb,@lOk)     // PROCESSO APENAS PARA PRÉ-NOTAS
		EndIf
		
		Else
		lAchou:=.F.
		Do While !SF1->(EOF()).AND. ALLTRIM(SF1->F1_DOC)=ALLTRIM(cnfmae) //Adriano 13/02/12 - Precisei fazer assim, pq no xml não vem a SÉRIE da NF MÃE.
		If !SF1->(EOF()).AND. ALLTRIM(SF1->F1_DOC)=ALLTRIM(cnfmae) .AND. SF1->F1_FORNECE=cCliFor .AND. SF1->F1_LOJA=cLoja
		fProcNFE(cFilAnt,cTpMov,cAliasTrb,@lOk)    // PROCESSO PARA NOTA CLASSIFICADAS
		lAchou:=.T.
		EndIf
		SF1->(dbSkip())
		Enddo
		If !lAchou
		fProcNFx(cFilAnt,cTpMov,cAliasTrb,@lOk)     // PROCESSO APENAS PARA PRÉ-NOTAS
		EndIf
		EndIf
		*/
		fProcNFE(cFilAnt,cTpMov,cAliasTrb,@lOk)
		*'Yttalo P Martins-FIM----------------------------------------------------------------------------------------------'*
		
	ElseIf cTpMov$"NFS"
		// ESTE PROCESSO DEVE PREVER A ENTRADA DAS INFORMAÇÕES DE OUTRAS NOTAS, COMO EXEMPLO: IMPORTAÇÃO DE NOTAS DE OUTRAS FILIAS DA BAUCHE
		fProcNFS(cFilAnt,cTpMov,cAliasTrb,@lOk)
	EndIf
	
	(cAliasTrb)->(DbCloseArea())
	FErase(cArqInd+IndexExt())
	
	If lExcJob
		RpcClearEnv()
	EndIf
Next nMovim

FErase(cArqTrb+GetDbExtension())
FErase(cArqInd+IndexExt())

Return(lOk)

*----------------------------------------------------*
Static Function fProcNFE(cFilReg,cTpMov,cAliasTrb,lOk)
*----------------------------------------------------*
Local cFilSB1  := If( Empty(xFilial("SB1")) , Space(TAMSX3("B1_FILIAL")[1]) , cFilReg )
Local cFilSD1  := If( Empty(xFilial("SD1")) , Space(TAMSX3("D1_FILIAL")[1]) , cFilReg )
Local cFilSF1  := If( Empty(xFilial("SF1")) , Space(TAMSX3("F1_FILIAL")[1]) , cFilReg )
Local cFilSF4  := If( Empty(xFilial("SF4")) , Space(TAMSX3("F4_FILIAL")[1]) , cFilReg )
Local aErros   := {}
Local lPreNota := (cTpMov=="PRE")
Local nErro
Private lMsErroAuto := .f.

(cAliasTrb)->( dbGoTop() )

While !(cAliasTrb)->( Eof() )
	
	lPreNota := (cTpMov=="PRE")
	lErro    := .F.
	cItem	 := StrZero(VAL((cAliasTrb)->TP_ITEM),4)//StrZero(VAL((cAliasTrb)->TP_ITEM),Len(SD1->D1_ITEM))
	cTipoNf  := (cAliasTrb)->TP_DE_NOTA
	cFormul  := "N"
	cSerNf   := (cAliasTrb)->SERIE
	cNFiscal := (cAliasTrb)->NR_NFISCAL
	cSerie   := (cAliasTrb)->SERIE
	cDoc     := (cAliasTrb)->NR_NFISCAL
	cEspecie := (cAliasTrb)->ESPECIE
	cCliFor  := (cAliasTrb)->CLI_FOR
	cLoja	 := (cAliasTrb)->LJ_CLI_FOR
	dEmissao := (cAliasTrb)->DT_EMISSAO
	dDtDigit := Date()
	cEstado  := (cAliasTrb)->ESTADO
	cCondPag := (cAliasTrb)->COND_PAG
	cINFNEID := (cAliasTrb)->INFNEID
	cnfmae   := (cAliasTrb)->NF_MAE
	cSERImae := (cAliasTrb)->NF_SERIMAE
	cCONTRA   := (cAliasTrb)->NF_CONTRA
	cPERIODO := (cAliasTrb)->NF_PERIODO
	nVOLUME := (cAliasTrb)->VOLUME
	nBaseIcm := 0
	nValIcm  := 0
	nValMerc := 0
	nValBrut := 0
	XQTDREM  := (cAliasTrb)->QUANTIDADE
	aItem	 := {}
	
	ConOut( FunName()+" - Processando registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf )
	
	If AScan( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf ) > 0
		(cAliasTrb)->(DbSkip())
		Loop
	EndIf
	
	If cTipoNF $"DB"
		cAliasCli := "SA1"
		SA2->( dbSetOrder(1) )
	Else
		cAliasCli := "SA2"
		SA2->( dbSetOrder(1) )
	EndIf
	
	If !(cAliasCli)->(DbSeek(xFilial(cAliasCli)+cCliFor+cLoja))
		If !lErro
			AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
			cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
			cBody+="Erros :<br>"+CRLF
		EndIf
		lOk   := .F.
		lErro := .T.
		cBody+="Cliente/Fornecedor "+cCliFor+"/"+cLoja+" nao esta cadastrado!<br>"+CRLF
		cBody+="<br>"+CRLF
	EndIf
	
	If cTipoNF $"DB"
		cTipoCli  := SA1->A1_TIPO
		cEstCli   := SA1->A1_EST
	Else
		cTipoCli  := SA2->A2_TIPO
		cEstCli   := SA2->A2_EST
	EndIf
	
	SF1->(DbSetOrder(1))
	If SF1->(DbSeek(cFilSF1+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf))
		lOk   := .F.
		lErro := .T.
		cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado, pois ja existe no sistema!<br>"+CRLF
		AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
		(cAliasTrb)->(DbSkip())
		Loop
	EndIf
	
	While !(cAliasTrb)->(Eof()) .And. (cAliasTrb)->SERIE == cSerNf  ;              //Adriano - até aqui ok
		.And. (cAliasTrb)->NR_NFISCAL == cNFiscal;
		.And. (cAliasTrb)->CLI_FOR    == cCliFor ;
		.And. (cAliasTrb)->LJ_CLI_FOR == cLoja
		
		If !lExcJob
			oProcess:IncRegua2()
		EndIf
		
		lPreNota := Empty((cAliasTrb)->TES)
		
		If !SB1->(DbSeek(cFilSB1+(cAliasTrb)->COD_PROD))
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="O Produto "+(cAliasTrb)->COD_PROD+" nao esta cadastrado!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		
		SF4->( dbSetOrder(1) )
		If !SF4->(DbSeek(cFilSF4+(cAliasTrb)->TES)).And.!lPreNota
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="A TES "+(cAliasTrb)->TES+" nao esta cadastrada!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		
		If (cAliasTrb)->QUANTIDADE == 0
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="Quantidade nao informada<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		If (cAliasTrb)->VLR_UNIT == 0
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="Valor Unitario nao informado<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		If (cAliasTrb)->VLR_TOTAL == 0
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="Valor total nao informado!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		
		If !lErro
			cUM := SB1->B1_UM // 02/10/13 - Luís Felipe Nascimento // If(Empty((cAliasTrb)->UNIDADE),SB1->B1_UM,(cAliasTrb)->UNIDADE)
			
			/*
			If cUM=='tn' .or. cUM=='TN' .or. cUM='kg' .or. cUM="KG"
			cUM := "SC"
			EndIf
			*/
			
			_nValUnit	:= round(((cAliasTrb)->VLR_TOTAL / (cAliasTrb)->QUANTIDADE) ,TAMSX3("D1_VUNIT")[2])
			
			_cLocPad	:= SB1->B1_LOCPAD
			
			nQTD:=(cAliasTrb)->QUANTIDADE
			
			AAdd(aItem,{{"D1_COD"    ,(cAliasTrb)->COD_PROD                       ,Nil},;
			{"D1_ITEM"    ,cItem                                       ,Nil},;
			{"D1_UM"      ,cUm                                         ,Nil},;
			{"D1_QUANT"   ,(cAliasTrb)->QUANTIDADE                     ,Nil},;
			{"D1_VUNIT"   ,_nValUnit 				                   ,Nil},;
			{"D1_TOTAL"   ,(cAliasTrb)->VLR_TOTAL                      ,Nil},;
			{"D1_IPI"     ,0                                           ,Nil},;
			{"D1_VALIPI"  ,0                                           ,Nil},;
			{"D1_PICM"    ,(cAliasTrb)->ALIQ_ICMS                      ,Nil},;
			{"D1_VALICM"  ,0   						                   ,Nil},;
			{"D1_BASEICM" ,0   						                   ,Nil},;
			{"D1_BASEIPI" ,0   						                   ,Nil},;
			{"D1_RATEIO"  ,"2"                                         ,Nil},;
			{"D1_LOCAL"   ,cArmaz                                      ,Nil},;
			{"D1_BRICMS"  ,0                                           ,Nil},;
			{"D1_ICMSRET" ,0                                           ,Nil}})
			//{"D1_TES"   ,(cAliasTrb)->TES                            ,Nil},;
			//{"D1_CF"    ,(cAliasTrb)->CFOP                           ,Nil}})
			
			//			{"AUTDELETA" ,"N"                                         ,Nil}})
			
			cItem    := Soma1(cItem,4)//Soma1(cItem,Len(SD1->D1_ITEM))
			nBaseIcm += (cAliasTrb)->BASE_ICMS
			nValIcm  += (cAliasTrb)->VLR_ICMS
			nValMerc += (cAliasTrb)->VLR_TOTAL
			nValBrut += (cAliasTrb)->VLR_TOTAL
		EndIf
		(cAliasTrb)->(DbSkip())
	End
	
	
	If !lErro
		
		cEspecie:="SPED"
		
		aCab := {{"F1_TIPO"   , cTipoNF  ,NIL},;
		{"F1_FORMUL" 	, cFormul  		,NIL},;
		{"F1_DOC"    	, cNFiscal 		,NIL},;
		{"F1_SERIE"  	, cSerNf   		,NIL},;
		{"F1_EMISSAO"	, dEmissao 		,NIL},;
		{"F1_FORNECE"	, cCliFor  		,NIL},;
		{"F1_LOJA"   	, cLoja    		,NIL},;
		{"F1_ESPECIE"	, cEspecie 		,NIL},;
		{"F1_BASEICM"	, nBaseIcm 		,NIL},;
		{"F1_VALICM" 	, nValIcm  		,NIL},;
		{"F1_VALIPI" 	, nValIcm  		,NIL},;
		{"F1_ICMSRET"	, 0        		,NIL},;
		{"F1_VALMERC"	, nValBrut 		,NIL},;
		{"F1_VALBRUT"	, nValBrut 		,NIL},;
		{"F1_ORIGEM" 	, "LEXMLREM"  	,NIL},;
		{"F1_TIPODOC"	, cTipoNf  		,Nil},;
		{"F1_COND"   	, cCondPag 		,NIL}}
		
		//       ALERT("aqui "+cNFiscal)
		
		
		lMsErroAuto := .F.
		//If lPreNota
		ddatabase:=dDtDigit
		MSExecAuto({|x,y,z| Mata140(x,y,z) }, aCab, aItem, 3)
		//Else
		//ddatabase:=dDtDigit
		//MSExecAuto({|x,y,z| Mata103(x,y,z) }, aCab, aItem, 3)
		//EndIf
		
		If lMsErroAuto
			
			If !lExcJob
				MostraErro()	//"Falha na atualizacao do pedido"
			EndIf
			
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			aErros := GetAutoGrLog()
			For nErro := 1 To Len(aErros)
				cBody+= aErros[nErro]+"<br>"+CRLF
			Next nErro
			cBody+="<br>"+CRLF
			
		Else
			cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" foi importado com sucesso!<br>"+CRLF
			cBody+="<br>"+CRLF
			
			//Adriano - tirar as duas linhas abaixo antes de colocar em produção.
			//xcli:=cCliFor
			//xloj:=cLoja
			
			//cnfmae :="48140    " // ADRIANO - PARA TESTES EM 10/02/2012
			//cCliFor:="000007"    // ADRIANO - PARA TESTES EM 10/02/2012
			//cLoja  :="01"        // ADRIANO - PARA TESTES EM 10/02/2012
			
			/*
			xPedido  :=""
			xContra  :=""
			XPeriod  :=""
			xNatur   :=""
			xNavio   :=""
			
			dbselectarea("SF1")
			dbsetorder(1)
			dbseek(xFILIAL("SF1")+cnfmae)
			Do While !SF1->(EOF()).AND. SF1->F1_DOC=cnfmae
			If SF1->F1_FORNECE=cCliFor .AND. SF1->F1_LOJA=cLoja
			xPedido:=SF1->F1_XPEDIDO
			EndIf
			SF1->(dbSkip())
			EndDo
			
			DBSELECTAREA("SC7")
			DBSETORDER(1)
			If DBSEEK(xFILIAL("SC7")+xPEDIDO).And. !Empty(xPEDIDO)
			IF !SC7->(EOF())
			RecLock("SC7",.F.)
			SC7->C7_QUJE+=(nQtd/20) // divide por 20 pq a quantidade da nf recebida está em SACAS. (20 SACAS=1 TONELADA)
			xContra:=SC7->C7_CONTRAT
			xNavio :=SC7->C7_NAVIO
			Msunlock()
			ENDIF
			Else
			DBSELECTAREA("SC7")
			DBSETORDER(23)
			If DBSEEK(xFILIAL("SC7")+"B "+SubStr(cnfmae,1,3)+' '+SubStr(cnfmae,4,3)+' '+SubStr(cnfmae,7,3))
			RecLock("SC7",.F.)
			SC7->C7_QUJE+=(nQtd/20) // divide por 20 pq a quantidade da nf recebida está em SACAS. (20 SACAS=1 TONELADA)
			xContra:=SC7->C7_CONTRAT
			xNavio :=SC7->C7_NAVIO
			Msunlock()
			xPEDIDO := SC7->C7_NUM
			EndIf
			EndIf
			//Adriano tirar as duas linhas abaixo antes de colocar em produção.
			//cCliFor:=xcli
			//cLoja:=xloj
			*/
			
			dbselectarea("SF1")
			dbsetorder(1)
			dbseek(xFILIAL("SF1")+cNFiscal+cSerNF+cCliFor+cLoja+cTipoNf)
			If !SF1->(EOF())
				RecLock("SF1",.F.)
				SF1->F1_VALMERC := nValBrut
				SF1->F1_VALBRUT := nValBrut
				SF1->F1_CHVNFE  := cINFNEID
				SF1->F1_XNOMFOR := Posicione("SA2",1,xFilial("SA2")+cCliFor+cLoja,"A2_NOME")
				SF1->F1_NFMAE   := cnfmae
				SF1->F1_CONTRA   := xCONTRA
				SF1->F1_NAVIO    := xNAVIO
				SF1->F1_XPEDIDO  := xPEDIDO
				SF1->F1_XSERMAE  := cSERImae
				SF1->F1_XPERIOD  := cPERIODO
				
				msunlock()
				// U_SV_IncNt(SF1->F1_SERIE, SF1->F1_DOC, SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_CONTRA)  09/12/13 - Luis Felipe Nascimento
			Endif
			
			//SFT  //
			dbselectarea("SFT")
			dbsetorder(1)
			// Fim - 17/05/13 - Luis Felipe Nascimento - Retirado Loop desnecessário.
			If dbseek(xFILIAL("SFT")+'E'+cSerNF+cNFiscal+cCliFor+cLoja)
				//			Do While !SFT->(EOF())
				//				IF SFT->FT_TIPOMOV=='E'.AND.SFT->FT_SERIE==cSerNF.AND.SFT->FT_NFISCAL==cNFiscal.AND.SFT->FT_CLIEFOR==cCliFor.AND.SFT->FT_LOJA==cLoja
				//					IF EMPTY(SFT->FT_CHVNFE)
				RecLock("SFT",.F.)
				SFT->FT_CHVNFE:=cINFNEID
				msunlock()
				//					ENDIF
				//				ENDIF
				//				SFT->(DBSKIP())
				//			EndDo
			EndIf
			// Inicio - 17/05/13 - Luis Felipe Nascimento - Retirado Loop desnecessário.
			
			//SF3
			dbSelectArea("SF3")
			dbSetOrder(5)
			dbseek(xFilial("SF3")+cSerNF+cNFiscal+cCliFor+cLoja)
			Do While !SF3->(EOF())
				If SF3->F3_SERIE=cSerNF .AND. SF3->F3_NFISCAL=cNFiscal .AND. SF3->F3_CLIEFOR=cCliFor .AND. SF3->F3_LOJA=cLoja
					IF EMPTY(SF3->F3_CHVNFE)
						RecLock("SF3",.F.)
						SF3->F3_CHVNFE:=cINFNEID
						msunlock()
					ENDIF
				EndIf
				SF3->(dbSkip())
			EndDo
			
			//atualiza tabela SZD, tabela de retaguarda
			AtuSZD()
			
		EndIf
	EndIf
End

Return(lOk)

*----------------------------------------------------*
Static Function fProcNFS(cFilReg,cTpMov,cAliasTrb,lOk)
*----------------------------------------------------*
Local cFilSB1  := If( Empty(xFilial("SB1")) , Space(02) , cFilReg )
Local cFilSB2  := If( Empty(xFilial("SB2")) , Space(02) , cFilReg )
Local cFilSC5  := If( Empty(xFilial("SC5")) , Space(02) , cFilReg )
Local cFilSC6  := If( Empty(xFilial("SC6")) , Space(02) , cFilReg )
Local cFilSC9  := If( Empty(xFilial("SC9")) , Space(02) , cFilReg )
Local cFilSE4  := If( Empty(xFilial("SE4")) , Space(02) , cFilReg )
Local cFilSF2  := If( Empty(xFilial("SF2")) , Space(02) , cFilReg )
Local cFilSF4  := If( Empty(xFilial("SF4")) , Space(02) , cFilReg )
Local cFilSD1  := If( Empty(xFilial("SD1")) , Space(02) , cFilReg )
Local cFilSF1  := If( Empty(xFilial("SF1")) , Space(02) , cFilReg )
Local cchavetrb:= ""
Local aErros   := {}
Local aCab     := {}
Local aItem    := {}
Local aPvlNfs  := {}
Local cItem
Local nErro
Private lMsErroAuto := .f.
Public cNFiscal,cSerNf

(cAliasTrb)->(DbSeek(cEmpAnt+cFilReg+cTpMov))
While !(cAliasTrb)->(Eof()) .And. (cAliasTrb)->COD_EMP    == cEmpAnt ;
	.And. (cAliasTrb)->COD_FIL    == cFilReg ;
	.And. (cAliasTrb)->TP_MOVIMEN == cTpMov
	
	lErro    := .F.
	cItem    := StrZero(1,Len(SC6->C6_ITEM))
	cTipoNf  := (cAliasTrb)->TP_DE_NOTA
	cSerNf   := (cAliasTrb)->SERIE
	cNFiscal := (cAliasTrb)->NR_NFISCAL
	cEspecie := (cAliasTrb)->ESPECIE
	cCliFor  := (cAliasTrb)->CLI_FOR
	cLoja	 := (cAliasTrb)->LJ_CLI_FOR
	dEmissao := (cAliasTrb)->DT_EMISSAO
	dDtDigit := (cAliasTrb)->DT_ENTRADA
	cEstado  := (cAliasTrb)->ESTADO
	cCondPag := (cAliasTrb)->COND_PAG
	cNFOri	 := (cAliasTrb)->NF_COMPRA
	cSerOri	 := (cAliasTrb)->SERIE_COM
	cItemOri := SPACE(4) //"00" + (cAliasTrb)->ITEM_COM
	cProduto := (cAliasTrb)->COD_PROD
	
	nValMerc := 0
	nValBrut := 0
	aItem	   := {}
	ConOut( FunName()+" - Processando registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf )
	
	If AScan( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf ) > 0
		(cAliasTrb)->(DbSkip())
		Loop
	EndIf
	
	If cTipoNF $ "DB"
		cAliasCli := "SA2"
		cTipoCli  := "R"
		cEstCli   := SA2->A2_EST
	Else
		dbSelectArea( "SA1" )
		dbSetOrder( 01 )
		dbSeek( xFilial( "SA1" ) + cCLiFor + cLoja )
		
		cAliasCli := "SA1"
		cTipoCli  := SA1->A1_TIPO
		cEstCli   := SA1->A1_EST
	EndIf
	
	If !(cAliasCli)->(DbSeek(xFilial(cAliasCli)+cCliFor+cLoja))
		If !lErro
			AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
			cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
			cBody+="Erros :<br>"+CRLF
		EndIf
		lOk   := .F.
		lErro := .T.
		cBody+="Cliente/Fornecedor "+cCliFor+"/"+cLoja+" nao esta cadastrado!<br>"+CRLF
		cBody+="<br>"+CRLF
	EndIf
	
	If cTipoNF $ "D"
		SF1->(DbSetOrder(1))
		If !SF1->(DbSeek(cFilSF1+cNFOri+cSerOri+cCliFor+cLoja,.T.))
			lOk   := .F.
			lErro := .T.
			cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFORI+"/"+cSerORI+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado, pois nao existe nf de entrada !<br>"+CRLF
			AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
			(cAliasTrb)->(DbSkip())
			Loop
		EndIf
	Endif
	
	
	SF2->(DbSetOrder(1))
	If SF2->(DbSeek(cFilSF2+cNFiscal+cSerNf+cCliFor+cLoja))
		lOk   := .F.
		lErro := .T.
		cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado, pois ja existe no sistema!<br>"+CRLF
		AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
		(cAliasTrb)->(DbSkip())
		Loop
	EndIf
	
	*-----------------------------*
	* Geracao do pedido de vendas *
	*-----------------------------*
	DbSelectArea(cAliasTrb)
	cPedido := GetSx8Num("SC5","C5_NUM")
	//ConfirmSX8()
	SC5->(dbSetOrder(1))
	While SC5->(dbSeek(cFilReg+cPedido))
		rollbacksx8()
		cPedido := GetSx8Num("SC5","C5_NUM")
		//ConfirmSX8()
	End
	//        BeginTran()
	
	While !(cAliasTrb)->(Eof()) .And. (cAliasTrb)->COD_EMP    == cEmpAnt ;
		.And. (cAliasTrb)->COD_FIL    == cFilReg ;
		.And. (cAliasTrb)->TP_MOVIMEN == cTpMov ;
		.And. (cAliasTrb)->TP_DE_NOTA == cTipoNf ;
		.And. (cAliasTrb)->SERIE      == cSerNf  ;
		.And. (cAliasTrb)->NR_NFISCAL == cNFiscal;
		.And. (cAliasTrb)->ESPECIE    == cEspecie;
		.And. (cAliasTrb)->CLI_FOR    == cCliFor ;
		.And. (cAliasTrb)->LJ_CLI_FOR == cLoja
		
		If !lExcJob
			oProcess:IncRegua2()
		EndIf
		
		If !SB1->(DbSeek(cFilSB1+(cAliasTrb)->COD_PROD))
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="O Produto "+(cAliasTrb)->COD_PROD+" nao esta cadastrado!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		
		If !SF4->(DbSeek(cFilSF4+(cAliasTrb)->TES))
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="A TES "+(cAliasTrb)->TES+" nao esta cadastrada!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		
		If (cAliasTrb)->QUANTIDADE == 0
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="Quantidade nao informada!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		If (cAliasTrb)->VLR_UNIT == 0
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="Valor Unitario nao informado!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		
		If (cAliasTrb)->VLR_TOTAL == 0
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="Valor total nao informado!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
		
		If (cAliasTrb)->TP_DE_NOTA $ "D"
			CChaveTrb:= (cAliasTrb)->(NF_COMPRA + SERIE_COM + CLI_FOR + LJ_CLI_FOR + COD_PROD)
			SD1->(DbSetOrder(1))
			If !SD1->(DbSeek(cFilSD1 + CChaveTrb ,.T.))
				//    			 If !lErro
				cBody+="O Registro " + CChaveTrb + " nao foi importado, pois nao existe nf de entrada !<br>"+CRLF
				AAdd( aErros , cFilReg+cChaveTrb )
				//             endif
				lOk   := .F.
				lErro := .T.
			else
				cItemOri := SD1->D1_ITEM
			EndIf
		Endif
		
		
		If !lErro
			cUM := If(Empty((cAliasTrb)->UNIDADE),SB1->B1_UM,(cAliasTrb)->UNIDADE)
			
			_cLocPad	:= SB1->B1_LOCPAD
			
			If SB1->B1_CONV<=1
				AAdd( aItem  	, {{"C6_FILIAL" ,cFilSC6      ,Nil},;
				{"C6_ITEM"   	,cItem                        ,Nil},;     // 02
				{"C6_PRODUTO"	,(cAliasTrb)->COD_PROD        ,Nil},;    //  03
				{"C6_DESCRI" 	,SB1->B1_DESC                 ,Nil},;    // 04
				{"C6_UNSVEN" 	,(cAliasTrb)->QUANTIDADE      ,Nil},;   //  06
				{"C6_PRCVEN" 	,(cAliasTrb)->VLR_UNIT        ,Nil},;   //  07
				{"C6_UM"     	,cUM                          ,Nil},;    //  09
				{"C6_QTDVEN" 	,(cAliasTrb)->QUANTIDADE      ,Nil},;    // 10
				{"C6_TES"    	,(cAliasTrb)->TES             ,Nil},;    // 11
				{"C6_QTDLIB" 	,(cAliasTrb)->QUANTIDADE      ,Nil},;    // 12
				{"C6_LOCAL"  	,_cLocPad 			     	  ,Nil},;    // 15
				{"C6_CLI"    	,(cAliasTrb)->CLI_FOR         ,Nil},;    // 19
				{"C6_DESCONT"	,(cAliasTrb)->DESC_PERC       ,Nil},;    // 20
				{"C6_VALDESC"	,(cAliasTrb)->DESC_VALOR      ,Nil},;    // 21
				{"C6_ENTREG" 	,(cAliasTrb)->DT_EMISSAO      ,Nil},;    // 22
				{"C6_NFORI"  	,(cAliasTrb)->NF_COMPRA       ,Nil},;    // 22
				{"C6_SERIORI"	,(cAliasTrb)->SERIE_COM       ,Nil},;    // 22
				{"C6_ITEMORI"	,cItemOri 				      ,Nil},;    // 22
				{"C6_LOJA"   	,(cAliasTrb)->LJ_CLI_FOR      ,Nil},;    // 24
				{"C6_NUM"    	,cPedido                      ,Nil},;    // 28
				{"C6_PRUNIT" 	,(cAliasTrb)->VLR_UNIT		  ,Nil},;    // 35
				{"C6_OP"     	,"02"                         ,Nil},;    // 39
				{"C6_TPOP"   	,"F"                          ,Nil}} )   // 67
			Else
				AAdd( aItem  	, {{"C6_FILIAL" ,cFilSC6      ,Nil},;
				{"C6_ITEM"   	,cItem                        ,Nil},;     // 02
				{"C6_PRODUTO"	,(cAliasTrb)->COD_PROD        ,Nil},;    //  03
				{"C6_DESCRI" 	,SB1->B1_DESC                 ,Nil},;    // 04
				{"C6_SEGUM"  	,cUM									  ,Nil},;    //  05
				{"C6_UNSVEN" 	,(cAliasTrb)->QUANTIDADE      ,Nil},;   //  06
				{"C6_PRCVEN" 	,(cAliasTrb)->VLR_UNIT        ,Nil},;   //  07
				{"C6_UM"     	,cUM                          ,Nil},;    //  09
				{"C6_QTDVEN" 	,(cAliasTrb)->QUANTIDADE      ,Nil},;    // 10
				{"C6_TES"    	,(cAliasTrb)->TES             ,Nil},;    // 11
				{"C6_QTDLIB" 	,(cAliasTrb)->QUANTIDADE      ,Nil},;    // 12
				{"C6_LOCAL"  	,_cLocPad 							  ,Nil},;    // 15
				{"C6_CLI"    	,(cAliasTrb)->CLI_FOR         ,Nil},;    // 19
				{"C6_DESCONT"	,(cAliasTrb)->DESC_PERC       ,Nil},;    // 20
				{"C6_VALDESC"	,(cAliasTrb)->DESC_VALOR      ,Nil},;    // 21
				{"C6_ENTREG" 	,(cAliasTrb)->DT_EMISSAO      ,Nil},;    // 22
				{"C6_NFORI"  	,(cAliasTrb)->NF_COMPRA       ,Nil},;    // 22
				{"C6_SERIORI"	,(cAliasTrb)->SERIE_COM	      ,Nil},;    // 22
				{"C6_ITEMORI"	,cItemOri 			          ,Nil},;    // 22
				{"C6_LOJA"   	,(cAliasTrb)->LJ_CLI_FOR      ,Nil},;    // 24
				{"C6_NUM"    	,cPedido                      ,Nil},;    // 28
				{"C6_PRUNIT" 	,(cAliasTrb)->VLR_UNIT		  ,Nil},;    // 35
				{"C6_OP"     	,"02"                         ,Nil},;    // 39
				{"C6_TPOP"   	,"F"                          ,Nil}} )   // 67
			Endif
			//         {"C6_VALOR"  ,(cAliasTrb)->VLR_TOTAL       ,Nil},;
			//         {"C6_CLASFIS","A"                                                 ,Nil}} )
			//         {"C6_CF"     ,"" fCfop(cFilSF4,(cAliasTrb)->TES,cTipoCli,cEstCli) ,Nil},;
			//         {"C6_PRUNIT" ,(cAliasTrb)->VLR_UNIT                               ,Nil},;
			//		     {"C6_PRCVEN" ,(cAliasTrb)->VLR_TOTAL/(cAliasTrb)->QUANTIDADE ,Nil},;
			
			cItem := Soma1(cItem,Len(SC6->C6_ITEM))
		EndIf
		(cAliasTrb)->(DbSkip())
	End
	
	If lErro
		rollbacksx8()
		DisarmTransaction()
		//RollBackSxe()
		Loop
	EndIf
	// alterado Davi Jesus
	aCab := {{"C5_FILIAL" ,cFilSC5      ,Nil},;
	{"C5_NUM"    ,cPedido      ,Nil},;
	{"C5_TIPO"   ,cTipoNF      ,Nil},;
	{"C5_CLIENTE",cCliFor      ,Nil},;
	{"C5_LOJAENT",cLoja        ,Nil},;
	{"C5_LOJACLI",cLoja        ,Nil},;
	{"C5_CONDPAG",cCondPag     ,Nil},;     // 15
	{"C5_TIPLIB" ,"1"          ,Nil},;     // 21
	{"C5_TIPOCLI",cTipoCli     ,Nil},;     // 28
	{"C5_EMISSAO",dEmissao     ,Nil},;     // 40
	{"C5_MOEDA"  ,1            ,Nil},;     // 53
	{"C5_LIBEROK","S"          ,Nil}}      // 71
	
	RegToMemory("SC5")
	M->C5_FILIAL := cFilSC5
	
	RegToMemory("SC6")
	M->C6_FILIAL := cFilSC6
	
	lMsErroAuto := .F.
	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItem,3)
	If lMsErroAuto
		rollbacksx8()
		//			MostraErro()
		If !lErro
			AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
			cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
			cBody+="Erros :<br>"+CRLF
		EndIf
		lOk   := .F.
		lErro := .T.
		aErros := GetAutoGrLog()
		For nErro := 1 To Len(aErros)
			cBody+= aErros[nErro]+"<br>"+CRLF
		Next nErro
		cBody+="<br>"+CRLF
		DisarmTransaction()
	Else
		confirmsx8()
		cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" foi gerado o pedido "+cPedido+" com sucesso!<br>"+CRLF
		cBody+="<br>"+CRLF
	EndIf
	DbSelectArea(cAliasTrb)
	//      EndTran()
	
	If lErro
		Loop
	EndIf
	
	*------------------------------*
	* Liberacao do pedido de venda *
	*------------------------------*
	SC5->(DbSetOrder(1))
	SC6->(DbSetOrder(1))
	SE4->(DbSetOrder(1))
	SB1->(DbSetOrder(1))
	SB2->(DbSetOrder(1))
	SF4->(DbSetOrder(1))
	
	*--------------------------------------*
	* Define Variaveis usados pelo MATA440 *
	*--------------------------------------*
	lGerouPv 	:= .T.
	lLiber   	:= .T.
	lTrans   	:= .F.
	lCredito 	:= .F.
	lEstoque 	:= .F.
	lAvCred  	:= .T.
	lAvEst   	:= .T.
	lLiberOk 	:= .T.
	lItLib   	:= .T.
	aPvlNfs  	:= {}
	DDATABASE	:= dEmissao
	DbSelectArea(cAliasTrb)
	
	//        BeginTran()
	*-----------------------------*
	* Efetua a Liberacao por item *
	*-----------------------------*
	SC5->(DbSeek(cFilSC5+cPedido))
	SC6->(DbSeek(cFilSC6+cPedido))
	While !SC6->(Eof()) .And. SC6->C6_FILIAL == cFilSC6 .And. SC6->C6_NUM  == cPedido
		
		nQtdLib := SC6->C6_QTDVEN
		
		*----------------------------------------------*
		* Posiciona registros para efetuar a liberacao *
		*----------------------------------------------*
		SB1->(DbSeek(cFilSB1+SC6->C6_PRODUTO))
		
		nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdLib,@lCredito,@lEstoque,lAvCred,lAvEst,lLiber,lTrans)
		
		If nQtdLib != SC6->C6_QTDVEN
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lGerouPv := .F.
			lOk      := .F.
			lErro    := .T.
			cBody+="Nao foi possivel liberar o Produto "+Trim(SC6->C6_PRODUTO)+"!<br>"+CRLF
			cBody+="<br>"+CRLF
			DisarmTransaction()
			Exit
		EndIf
		
		SC9->( dbSetOrder(1) )
		IF SC9->(DbSeek(cFilSC9+SC6->C6_NUM+SC6->C6_ITEM))
			
			SC9->(RecLock("SC9",.F.))
			SC9->C9_BLEST  := ""
			SC9->C9_BLCRED := ""
			SC9->C9_DTENTR := DDATABASE
			
		ELSE
			
			SC9->(RecLock("SC9",.T.))
			SC9->C9_BLEST   := ""
			SC9->C9_BLCRED  := ""
			SC9->C9_DTENTR  := DDATABASE
			SC9->C9_FILIAL  := XFILIAL("SC9")
			SC9->C9_PEDIDO  := SC6->C6_NUM
			SC9->C9_ITEM    := SC6->C6_ITEM
			SC9->C9_CLIENTE := SC6->C6_CLI
			SC9->C9_LOJA    := SC6->C6_LOJA
			SC9->C9_PRODUTO := SC6->C6_PRODUTO
			SC9->C9_DATALIB := dDataBase
			SC9->C9_PRCVEN  := SC6->C6_PRCVEN
			SC9->C9_BLEST   := "10"
			SC9->C9_BLCRED  := "10"
			SC9->C9_LOCAL   := SC6->C6_LOCAL
			SC9->C9_QTDLIB  := SC6->C6_QTDVEN
			
		ENDIF
		
		SC9->(MsUnLock())
		
		SE4->(DbSeek(cFilSE4+SC5->C5_CONDPAG) )
		SB1->(DbSeek(cFilSB1+SC6->C6_PRODUTO) )
		SB2->(DbSeek(cFilSB2+SC6->C6_PRODUTO+SC6->C6_LOCAL) )
		SF4->(DbSeek(cFilSF4+SC6->C6_TES) )
		
		Aadd(aPvlnfs, { SC9->C9_PEDIDO  ,;
		SC9->C9_ITEM    ,;
		SC9->C9_SEQUEN  ,;
		SC9->C9_QTDLIB  ,;
		SC9->C9_PRCVEN  ,;
		SC9->C9_PRODUTO ,;
		SF4->F4_ISS=="S",;
		SC9->(RecNo())  ,;
		SC5->(RecNo())  ,;
		SC6->(RecNo())  ,;
		SE4->(RecNo())  ,;
		SB1->(RecNo())  ,;
		SB2->(RecNo())  ,;
		SF4->(RecNo())  ,;
		SC9->C9_LOCAL   })
		
		SC6->(DbSkip())
	End
	DbSelectArea(cAliasTrb)
	//       EndTran()
	
	*---------------------------------*
	* Geracao da nota fiscal de saida *
	*---------------------------------*
	If lGerouPv .And. Len(aPvlnfs) > 0
		Pergunte("MT461A",.f.)
		
		lMostraCtb   	:= .F.
		lAglutCtb    	:= .F.
		lCtbOnLine   	:= .F.
		lCtbCusto    	:= .F.
		lReajuste    	:= .F.
		nCalAcrs     	:= 0
		nArredPrcLis 	:= 0
		lAtuSA7      	:= .F.
		lECF         	:= .F.
		
		cNota := MaPvlNfs(aPvlNfs,"XML",lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajuste,nCalAcrs,nArredPrcLis,lAtuSA7,lECF)
		If cNota != cNFiscal .Or. !SF2->(DbSeek(cFilSF2+cNota+cSerNf+cCliFor+cLoja))
			If !lErro
				AAdd( aErros , cFilReg+cNFiscal+cSerNf+cCliFor+cLoja+cTipoNf )
				cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" nao foi importado!<br>"+CRLF
				cBody+="Erros :<br>"+CRLF
			EndIf
			lOk   := .F.
			lErro := .T.
			cBody+="Nao foi possivel gerar a nota fiscal de saida "+cSerNf+"-"+cNFiscal+" !<br>"+CRLF
			cBody+="<br>"+CRLF
		Else
			cBody+="O Registro "+cTpMov+"-"+cFilReg+"/"+cNFiscal+"/"+cSerNf+"/"+cCliFor+"/"+cLoja+"/"+cTipoNf+" foi gerado a NF "+cSerNf+"/"+cNota+" com sucesso!<br>"+CRLF
			cBody+="<br>"+CRLF
		EndIf
	EndIf
	
End

Return(lOk)

*--------------------------------------------------------------------*
Static Function fRet(oXml,cAliasXml,cItemXml,nItemXml,cVarXml,cFuncao)
*--------------------------------------------------------------------*
Local xRet, lIsArray

cAliasXml := If(cAliasXml==Nil,"",If(Left(cAliasXml,1)!="_","_","") + cAliasXml)
cItemXml  := If(cItemXml ==Nil,"",If(Left(cItemXml ,1)!="_","_","") + cItemXml)
nItemXml  := If(nItemXml ==Nil,"",AllTrim(Str(nItemXml)))
cVarXml   := If(cVarXml  ==Nil,"",If(Left(cVarXml  ,1)!="_","_","") + cVarXml)
cFuncao   := If(cFuncao  ==Nil,"",cFuncao)

xRet := "oXml:"+cAliasXml + If(!Empty(cItemXml),":"+cItemXml    ,"")

lIsArray := ValType(&xRet) == "A"

If lIsArray
	xRet += If(!Empty(nItemXml),"["+nItemXml+"]","")
EndIf

xRet += If(!Empty(cVarXml) ,":"+cVarXml ,"") + If(Empty(cFuncao) ,":TEXT" ,"")

If lIsArray
	xRet := If(!Empty(cFuncao),cFuncao+"(","") + xRet + If(!Empty(cFuncao),")","")
Else
	If !Empty(cFuncao)
		xRet := "1"
	EndIf
EndIf

Return(&xRet)

*--------------------------------------------------*
Static Function fCfop(cFilSF4,cTes,cTipoCli,cEstCli)
*--------------------------------------------------*
Local aAreaSF4 := SF4->(GetArea())
Local cRet     := ""
Local cAliasTab

SF4->(DbSetOrder(1))
If SF4->(DbSeek(cFilSF4+cTES,.F.))
	If SF4->F4_CODIGO >= "500"
		cRet := If(cTipoCli != "X",If(cEstCli == AllTrim(GetMv("MV_ESTADO")),SF4->F4_CF,"6"+;
		Subs(SF4->F4_CF,2,Len(SF4->F4_CF)-1)),"7"+Subs(SF4->F4_CF,2,Len(SF4->F4_CF)-1))
	Else
		cRet := If(cTipoCli != "X",If(cEstCli == AllTrim(GetMv("MV_ESTADO")),SF4->F4_CF,"2"+;
		Subs(SF4->F4_CF,2,Len(SF4->F4_CF)-1)),"3"+Subs(SF4->F4_CF,2,Len(SF4->F4_CF)-1))
	endif
Endif
RestArea(aAreaSF4)
Return(cRet)

/*
*--------------------------------------------------------*
User Function _EnviaMail(cFrom,cTo,cAssunto,cAttach,cBody)
*--------------------------------------------------------*
cAttach := If(cAttach==Nil,"",AllTrim(cAttach))

If !Empty(cAttach).And.!File(cAttach)
ApMsgInfo("Arquivo Anexo ("+cAttach+") nao encontrado!")
Return
EndIF

If lExcJob
RpcSetType(3)
RpcSetEnv( cEmpPad , cFilPad , , , , "LE_XML" )
EndIf

cFrom       := If(cFrom==Nil,GetMv("MV_RELFROM"),cFrom)
aTo         := {cTo}
aCC         := {}
aBcc        := {}
cSubject    := cAssunto

aAttach     := {}
AAdd( aAttach , cAttach )

cMailServer := GetMv("MV_RELSERV")
cMailConta  := GetMv("MV_RELACNT")
cMailSenha  := GetMv("MV_RELPSW")

If MailSmtpOn( cMailServer, cMailConta, cMailSenha )
If !MailAuth(cMailConta,cMailSenha)
MsgStop("erro na Autenticação !!!")
Return
Endif
If !MailSend(cFrom,aTo,aCc,aBcc,cSubject,cBody,aAttach,.T.)
Msgstop("Erro no envio do e-mail!! - " + MailGetErr())
EndIf
lDiscSmtp:=MailSmtpOff()
Else
cErrorMsg:= "Erro na Conexão!!!"  + MailGetErr()
EndIf
If lExcJob
RpcClearEnv()
EndIf

FErase(cAttach)
Return
*/
/*
*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | M460NUM  | Autor | Davi Jesus                              |*
*+------------+------------------------------------------------------------+*
*|Data        | 28.12.2006                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Ponto de entrada para manipular o numero da nota fiscal    |*
*|            | a ser gerada pela rotina MaPvlNfs()                        |*
*+------------+------------------------------------------------------------+*
*|Partida     | MATA461                                                    |*
*+-------------------------------------------------------------------------+*
*| Programador       |   Data   | Motivo da alteracao                      |*
*+-------------------+----------+------------------------------------------+*
*|                   |          |                                          |*
*+-------------------------------------------------------------------------+*
*****************************************************************************

*---------------------*
User Function M460NUM()
*---------------------*
cNumero := If(Type("cNFiscal")!="U".And.!Empty(cNFiscal),cNFiscal,cNumero)
cSerie  := If(Type("cNFiscal")!="U".And.!Empty(cNFiscal),cSerNf  ,cSerie )
Return
*/


STATIC FUNCTION _CONVDTSPED(cData)
Local dData

dData := ctod(substr(cData,9,2)+"/"+substr(cData,6,2)+"/"+substr(cData,1,4))

Return dData

***************************************************************************************************************************************************
*'Yttalo P Martins-INICIO-------------------------------------------------------------------------------------------'*

Static function LEINFCPL(xcmemo,cnfmae,cSERImae,cCONTRA,cPERIODO,cCNPJFor)

Local oDlg, oMemo, cMemo := ""
Local XCONTRAT 	:= PADR(ALLTRIM(cTContra),TAMSX3("Z3_CONTRA")[1])  
Local XCPER   	:= PADR(ALLTRIM(cTDP),TAMSX3("Z3_PERIODO")[1])   

Local XCnf   	:= SPACE(9)
Local XCseri 	:= SPACE(3)
Local nOpc 		:= 0
LOCAL LRET 		:= .T.
Local aArea		:= GetArea()

DbSelectArea("SZ3")
DbSetOrder(1)
DbSeek(xFilial("SZ3")+XCONTRAT+XCPER)

cMemo := xcmemo

DEFINE MSDIALOG oDlg TITLE "Informações complementares" From 000,000 TO 350,550 PIXEL
@ 005,005 GET oMemo  VAR cMemo MEMO SIZE 150,150 OF oDlg PIXEL
oMemo:bRClicked := {||.F.}//{||AllwaysTrue()}
@ 001,020 SAY "Contrato:"
@ 010,190 MSGET SZ3->Z3_CONTRA Picture PesqPict("SZ3","Z3_CONTRA") Size 70,10  F3 "SZ3" OF oDlg PIXEL //Valid (fValidaFor(cCNPJFor,XCONTRAT),XCnf:=SPACE(9),If(!Empty(XCPER),XCPER,Space(10)),dlgRefresh(oDlg)) OF oDlg PIXEL

@ 003,020 SAY "Período:"
@ 040,190 MSGET SZ3->Z3_PERIODO Picture PesqPict("SZ3","Z3_PERIODO") When .f. OF oDlg PIXEL

@ 005,020 SAY "Nfiscal:"
@ 065,190 MSGET XCnf Picture PesqPict("SF1","F1_DOC") OF oDlg PIXEL

@ 007,020 SAY "Serie:"
@ 095,190 MSGET XCSeri Picture PesqPict("SF1","F1_SERIE") OF oDlg PIXEL

@ 009,020 SAY "Pedido:"
@ 115,190 MSGET XPedido Picture PesqPict("SF1","F1_XPEDIDO") F3 "SC7_CZ" Valid (!Empty(XPedido)) OF oDlg PIXEL

DEFINE SBUTTON  FROM 160,010 TYPE 1 ACTION (nOpc == 1,LRET:=.T.,oDlg:End()) ENABLE OF oDlg PIXEL
DEFINE SBUTTON  FROM 160,040 TYPE 2 ACTION (nOpc == 0,LRET:=.F.,oDlg:End()) ENABLE OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTER

If nOpc == 0
	
	cnfmae   := iif(EMPTY(XCnf),"",PADR(ALLTRIM(XCnf),TAMSX3("F1_DOC")[1]) )
	cSERImae := iif(EMPTY(XCSeri),"",PADR(ALLTRIM(XCSeri),TAMSX3("F1_SERIE")[1]) )
	
	cCONTRA := iif(EMPTY(XCONTRAT),"",PADR(ALLTRIM(XCONTRAT),TAMSX3("Z3_CONTRA")[1]) )
	cPERIODO := iif(EMPTY(SZ3->Z3_PERIODO),"",PADR(ALLTRIM(SZ3->Z3_PERIODO),TAMSX3("Z3_PERIODO")[1]) )
	
	IF !EMPTY(cnfmae) .AND. !ExistChav("SZ3", xFilial("SZ3") + cCONTRA + cPERIODO)
		LRET := .F.
	ENDIF
	
	IF !EMPTY(cCONTRA) .AND.  !ExistChav("SF1", xFilial("SF1") + cnfmae + cSERImae + SA2->A2_COD + SA2->A2_LOJA)
		LRET := .F.
	ENDIF
	
	IF EMPTY(cnfmae)
		LRET := .F.
	ENDIF
	
	xContra := cCONTRA
	xPeriod := cPERIODO
	
ENDIF

RestArea(aArea)

Return(LRET)

//-----------------------------------------------------------------------------------------

STATIC function AtuSZD()

LOCAL _AAREA := GETAREA()

DBSELECTAREA("SZD")
DBSETORDER(1)

If DbSeek(xFilial("SZD")+cCONTRA+cPERIODO+cnfmae+cSERImae+cNFiscal+cSerie)
	If SZD->ZD_STATUS == "EX"
		RecLock("SZD",.f.)
		Delete
		Msunlock()
	EndIf
EndIf

RECLOCK("SZD",.T.)

SZD->ZD_FILIAL 		:= 	XFILIAL("SZD")
SZD->ZD_CONTRA 		:= 	cCONTRA
SZD->ZD_PERIODO 	:= 	cPERIODO
SZD->ZD_NFMAE 		:= 	cnfmae
SZD->ZD_SERIEM 		:= 	cSERImae
SZD->ZD_NFREMES 	:= 	cNFiscal
SZD->ZD_SERIER 		:= 	cSerie
SZD->ZD_QTDNFRE 	:= 	XQTDREM
SZD->ZD_QTDMAE 		:= 	XQTDMAE
SZD->ZD_SALDO 		:= 	XQTDREM
SZD->ZD_PEDIDOC 	:= 	xPedido
SZD->ZD_STATUS 		:= 	"AT"
SZD->ZD_PARC 		:= 	"01"
SZD->ZD_CNPJUSI 	:=	XCNPJ
SZD->ZD_NUSINA 		:=	XNOMFOR
SZD->ZD_EMISREM		:=	SF1->F1_EMISSAO
SZD->ZD_UM			:=	SB1->B1_UM
SZD->ZD_VLRNFRE		:=	SF1->F1_VALBRUT
SZD->ZD_VLRMAE		:=	nVlrMae
("SZD")->(MSUNLOCK())

RESTAREA(_AAREA)

RETURN
*'Yttalo P Martins-FIM-----------------------------------------------------------------------------------------------'*


Static Function fValidaFor(cCNPJ,cContra)

Local lRet := .t.

SA2->(DbSetOrder(3))
SA2->(DbSeek(xFilial("SA2")+cCNPJ))

*'YTTALO P MARTINS-INICIO-CHAVE NÃO EXISTENTE-SERÁ TRATADO POR QUERY---'*
/*
CNC->(DbSetOrder(1))
CNC->(DbSeek(xFilial("CNC")+cContra+SA2->(A2_COD+A2_LOJA)))

If SA2->(A2_COD+A2_LOJA) <> CNC->(CNC_CODIGO+CNC_LOJA)
Aviso("Aviso","O Contrato selecionado não foi criado para o fornecedor desta Nota Fiscal !",{"Voltar"})
lRet := .f.
EndIf
*/
IF SELECT("TMPCNC") > 0
	dbSelectArea("TMPCNC")
	("TMPCNC")->( dbCloseArea() )
Endif

cQuery3 := "SELECT * FROM "+RetSQLName("CNC")+" CNC "
cQuery3 += "WHERE CNC_FILIAL='"+xFilial("CNC")+"' "
cQuery3 += "AND CNC_NUMERO='"+cContra+"' "
cQuery3 += "AND CNC_CODIGO='"+SA2->A2_COD+"' "
cQuery3 += "AND CNC_LOJA='"+SA2->A2_LOJA+"' "
cQuery3 += "AND CNC.D_E_L_E_T_ = ' ' "
cQuery3 := ChangeQuery(cQuery3)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),"TMPCNC",.T.,.T.)

dbSelectArea("TMPCNC")
("TMPCNC")->(dbGotop())
IF ("TMPCNC")->(!EOF())
	
	If SA2->A2_COD <> ("TMPCNC")->CNC_CODIGO .OR. SA2->A2_LOJA <> ("TMPCNC")->CNC_LOJA
		Aviso("Aviso","O Contrato selecionado não foi criado para o fornecedor/loja desta Nota Fiscal !",{"Voltar"})
		lRet := .f.
	EndIf
	
ELSE
	
	Aviso("Aviso","O Contrato selecionado não foi criado para o fornecedor/loja desta Nota Fiscal !",{"Voltar"})
	lRet := .f.
	
ENDIF

IF SELECT("TMPCNC") > 0
	dbSelectArea("TMPCNC")
	("TMPCNC")->( dbCloseArea() )
Endif

*'YTTALO P MARTINS-FIM-CHAVE NÃO EXISTENTE-SERÁ TRATADO POR QUERY-----'*



Return( lRet )
