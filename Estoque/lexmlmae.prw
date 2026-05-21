
*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | LeXmlMae    | Autor | Davi Jesus                           |*
*+------------+------------------------------------------------------------+*                                              
*|Data		  | 08/11/2010		 										   |*
*+------------+------------------------------------------------------------+*
*|Descricao   |Importa XML NF_MAE                   					   |*
*+------------+------------------------------------------------------------+*
*|Solicitante | 														   |*
*+------------+------------------------------------------------------------+*
*|Arquivos	  | 														   |*
*+------------+------------------------------------------------------------+*
*|			   ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL 		   |*
*+-------------------------------------------------------------------------+*
*| Programador		 |	 Data	| Motivo da alteracao					   |*
*+-------------------+----------+------------------------------------------+*
*| Yttalo P Martins  |10/07/13	|Ajuste no processo de importação pré-nota |*
*+-------------------+----------+------------------------------------------+*
*****************************************************************************

#Include "RwMake.ch"
#Include "XMLXFUN.CH"
#Define _LF   Chr(10)
#Define CRLF  Chr(13)+Chr(10)

*-------------------*
User Function LeXmlMae()
*-------------------* 

Local _cRet := ""
memowrite("\LOGRDM\"+ALLTRIM(PROCNAME())+".LOG",Dtoc(date()) + " - " + time() + " - " +alltrim(cusername))


Private oProcess
Private lExcJob := IsBlind()

If !lExcJob 
 // COLOCAR O MSGYESNO AQUI, ou melhor colocar a pergunta 
	oProcess:=MsNewProcess():New({||fLeXml()},"Processando","Processando XML...",.T.)
	oProcess:Activate()
Else
	fLeXml()
EndIf
Return

*----------------------*
Static Function fLeXml()
*----------------------*
Local   nArqXml        := 0
Local   cErro          := ""
Local   cAviso         := ""
Local   cArqXml        := ""
Local   cArqXml2        := ""
Local   cArqXml3        := ""
Local   cArqXml4        := ""
Local   cNewXml        := ""
Local   aFiles         := {}
Private cEmpPad        := If(lExcJob,"01",cEmpAnt)
Private cFilPad        := If(lExcJob,"01",cFilAnt)
Private lOk            := .T.
Private cAssunto       := ""
Private cBody          := ""
Private lAutoErrNoFile := .T.

If lExcJob
	RpcSetType(3)
	RpcSetEnv( cEmpPad , cFilPad , , , , "LE_XML" )
EndIf

//Private cLocFile := Trim(GetMv("MV_XXXML",.F.,"\XML\")) //"\XML\teste\"  //
//07733867000103
Private cLocFile   := cGetFile( '*.xml' , ' Importação NF_MAE(xml)', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ),.T., .T. )
Private cLocMain   := "C:\IMPORTACAO_XML\"
Private cLocSubMain:= cLocMain+"NF_MAE\"
Private cLocOk     := cLocSubMain+"backup\"
Private cLocCancel := cLocSubMain+"cancelamentos\"
Private cLocLog    := cLocSubMain+"log\"
Private nHandle   := ""

Private cFrom    := GetMv("MV_RELFROM")
Private cMailTo  := GetMv("MV_XXMAIL",.F.,GetMV("MV_EERRO")) 

If lExcJob
	RpcClearEnv()
EndIf

MAKEDIR(cLocMain)
MAKEDIR(cLocSubMain)
MAKEDIR(cLocOk)
MAKEDIR(cLocCancel)
MAKEDIR(cLocLog)

aFiles := Directory(cLocFile+"*.xml")

If Len(aFiles) <= 0
	Aviso("Aviso","Não há arquivos '.xml' no diretório informado!",{"Ok"})
	Return
EndIF

If !lExcJob
	oProcess:SetRegua1( Len(aFiles) )
EndIf

For nArqXml := 1 To Len(aFiles)
	
	lOk        := .T.
	cArqXml    := Lower(cLocFile+aFiles[nArqXml][1])
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
				FErase(cArqXml)			
				
			EndIf
			
			End Transaction			
	      
       Else 
          // move arquivo importado para uma pasta cancelamentos                  
          /*
          cNewXml := StrTran(upper(cArqXml),".XML",If(lOk,".OK",".XML"))
          FRename(cArqXml,cNewXml)                  
	      cArqDest := cLocFile+"cancelamentos"+SubStr(cNewXml,21)
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
	
Next nArqXml



Return

*------------------------------------------*
Static Function fProcXML(oXml,cAliasXml,lOk)
*------------------------------------------*
Local   nRegXml,cTpMov,aMovim := {}
Private cnfmae

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
			{ "TP_ITEM"    , "C" , 02 , 0 , "NUMERO ITEM"         ,"Left(@@,03)"                             },;
			{ "COD_PROD"   , "C" , 30 , 0 , "COD_PRODUTO"         ,"PadR(Left(@@,30),30)"                    },;
			{ "UNIDADE"    , "C" , 02 , 0 , "UNIDADE"             ,"PadR(Left(@@,02),02)"                    },;
			{ "QUANTIDADE" , "N" , 11 , 2 , "QUANTIDADE"          ,"Val(@@)/10000"                           },;
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
			{ "NF_MAE" , "C" , 09 , 0 , "NF_MAE"          ,"PadR(Right(@@,09),09)"                   }}


aStru := {}
aEval(aCampos,{|x| AAdd( aStru , {x[1],x[2],x[3],x[4]} ) } )

If Select(cAliasTrb) > 0
	(cAliasTrb)->(DbCloseArea())
Endif

oAliasTrb:= FwTemporarytable():New(cAliasTrb,aStru)
oAliasTrb:AddIndex( "TRB001", {"NR_NFISCAL+SERIE+CLI_FOR+LJ_CLI_FOR"} )
oAliasTrb:Create()

(cAliasTrb)->(DbCommitAll())
(cAliasTrb)->(DbGoTop())

(cAliasTrb)->(DbSetOrder(1))

nRegs := 1

If !lExcJob
	oProcess:SetRegua2( nRegs*2 )
EndIf
        
lFor    := .f.     // indica se o fornecedor incluso
lProd   := .f.     // indica se o produto foi incluso automaticamente
lTransp := .f.     // indica se a transportadora foi inclusa automaticamente
//   em todos os casos acima os registros ficam posicionados para uso no execauto da rotina mata103.

For nRegXml := 1 To nRegs
   
    cnfmae:=""

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
	    X_futura := substr(X_futura,2,4)
	                                            
//	    if OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT="72739"
//	       alert("teste")
//	    endif
	    
	    
	    If !X_futura $ "922/501/503" .AND. TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT")<>"U"
			// BUSCA TRANSPORTADOR
			SA4->( dbSetOrder(3) ) // ordem de CNPJ da transportadora
			If !SA4->( dbSeek(xFilial("SA4")+OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_TRANSPORTA:_CNPJ:TEXT ) )
		
			   // cadastra novo quando o mesmo nao existe
		       //lTransp := .T.         
		                          
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
		   SA2->A2_MSBLQL  := "2"
		   SA2->A2_RECPIS  := "1"
		   SA2->A2_RECCOFI := "1"
		   SA2->A2_RECCSLL := "1"
		   SA2->A2_MJURIDI := "2"
	//	   SA2->A2_INSCRM  := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_IM:TEXT
	//	   SA2->A2_COMPLEM := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_XCPL:TEXT
		   MsUnLock()
		   */
	    Endif

		// BUSCA AMARRACAO DO PRODUTO
		SA5->( dbSetOrder(8) )  // ordem de fornecedor + loja + cod de barras , assim nao e necessario criar indice novo 
	    If !SA5->( dbSeek(xFilial("SA5")+ SA2->(A2_COD+A2_LOJA)+iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT) ) )
	       // SE NAO EXISTE A AMARRACAO, CRIA-SE UMA PARA USO COM INFORME DE CADASTRAMENTO NOVO.
	       
		   // para criar a amarracao cria-se um novo produto no SB1, usando numeracao automatica (SXE)
		   lProd := .T.
		   Alert("Amarração Fornecedor X Produto não cadastrada! Favor cadastrar e importar o XML novamente.")
		   /*
		   RecLock("SB1",.T.) 
		   SB1->B1_FILIAL  := xFilial("SB1")
		   SB1->B1_COD     := GetSxeNum("SB1","B1_COD")
		   SB1->B1_DESC    := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_XPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT)
		   SB1->B1_TIPO    := "PA"
		   SB1->B1_UM      := "TL"
		   SB1->B1_LOCPAD  := "01"
		   SB1->B1_UCOM    := dDataBase
		   SB1->B1_SEGUM   := "SC"
		   SB1->B1_MCUSTD  := "1" 
		   SB1->B1_MSBLQL  := "2" 
		   SB1->B1_ORIGEM  := "0" 
		   SB1->B1_RASTRO  := "N" 
		   SB1->B1_APROPRI := "D" 
		   SB1->B1_TIPODEC := "N" 
		   SB1->B1_UREV    := date()
		   SB1->B1_DATREF  := date()
		   SB1->B1_MRP     := "S" 
		   SB1->B1_CODBAR  := SB1->B1_COD
		   SB1->B1_LOCALIZ := "N" 
		   SB1->B1_CONTRAT := "N" 
		   SB1->B1_IMPORT  := "N" 
		   SB1->B1_ANUENTE := "2" 
		   SB1->B1_TIPOCQ  := "M" 
		   SB1->B1_SOLICIT := "N" 
		   SB1->B1_DESPIMP := "N" 
		   SB1->B1_AGREGCU := "2" 
		   SB1->B1_INSS    := "N" 
		   SB1->B1_FLAGSUG := "1" 
		   SB1->B1_CLASSVE := "1" 
		   SB1->B1_MIDIA   := "2" 
		   SB1->B1_QTDSER  := 1 
		   SB1->B1_ATIVO   := "S" 
		   SB1->B1_CPOTENC := "2" 
		   SB1->B1_USAFEFO := "1" 
		   SB1->B1_ESCRIPI := "3" 
		   SB1->B1_PIS     := "2" 
		   SB1->B1_CRICMS  := "0" 
		   SB1->B1_CSLL    := "2" 
		   SB1->B1_FETHAB  := "2" 
		   SB1->B1_COFINS  := "2" 
		   SB1->B1_POSIPI  := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_NCM:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_NCM:TEXT)
	       MsUnLock() 
	
		   RecLock("SB2",.T.) 
	       SB2->B2_FILIAL  := xFilial("SB2")
	       SB2->B2_COD     := SB1->B1_COD
	       SB2->B2_LOCAL   := "01"
	       MsUnLock()
	
		   RecLock("SA5",.T.) 
	       SA5->A5_FILIAL  := xFilial("SA5")
	       SA5->A5_FORNECE := SA2->A2_COD
	       SA5->A5_NOMEFOR := SA2->A2_NOME
	       SA5->A5_LOJA    := SA2->A2_LOJA
	       SA5->A5_PRODUTO := SB1->B1_COD
	       SA5->A5_CODPRF  := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT)
	       SA5->A5_DESREF  := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_XPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT)
	       SA5->A5_NOMPROD := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_XPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_XPROD:TEXT)
	       SA5->A5_CODBAR  := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CPROD:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CPROD:TEXT)
	       MsUnLock() 
	       */
	    Else
		   SB1->( dbSetOrder(1) )
		   SB1->( dbSeek(xFilial("SB1")+SA5->A5_PRODUTO ) )
		EndIf
		      
		
		/*
	    // POSICIONA DO CADASTRO DE TES
	    SF4->( dbOrderNickName("CFOP") )
	    If !SF4->( dbSeek(xFilial("SF4")+"1"+SUBSTR(iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CFOP:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT),2,4)) )
	       // efetua novo cadastramento do processo para posterior reimportação ou analise
		   RecLock("SF4",.T.) 
	       SF4->F4_FILIAL  := xFilial("SF4")
	       SF4->F4_CODIGO  := GetSxeNum("SF4","F4_CODIGO")
	       SF4->F4_TIPO    := "E"
	       SF4->F4_CREDICM := "N"
	       SF4->F4_CREDIPI := "N"
	       SF4->F4_DUPLIC  := "S"
	       SF4->F4_ESTOQUE := "S"
	       SF4->F4_PODER3  := "N"
	       SF4->F4_UPRC    := "S"
	       SF4->F4_ATUTEC  := "N"
	       SF4->F4_ATUATF  := "N"
	       SF4->F4_CREDST  := "2"
	       SF4->F4_MOVPRJ  := "3"
	       SF4->F4_QTDZERO := "2"
	       SF4->F4_SLDNPT  := "2"
	       SF4->F4_DEVZERO := "1"
	       SF4->F4_MSBLQL  := "2"
	       SF4->F4_FINALID := OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT
	       SF4->F4_PISDSZF := "2"
	       SF4->F4_BENSATF := "2"
	       SF4->F4_ICM     := "N"
	       SF4->F4_IPI     := "N"
	       SF4->F4_CF      := "1"+SUBSTR(iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_CFOP:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_CFOP:TEXT),2,4)
	       SF4->F4_TEXTO   := SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NATOP:TEXT,1,20)
	       SF4->F4_LFICM   := "N"
	       SF4->F4_LFIPI   := "N"
	       SF4->F4_DESTACA := "N"
	       SF4->F4_INCIDE  := "N"
	       SF4->F4_COMPL   := "N"
	       MsUnLock() 
	    
	    Endif
	    */         
	    cnfmae:=""   
	    IF /*SA2->A2_COD<>"000167" .AND.*/ TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT")<>"U"

	       //ALVORADA
           If "NOTA FISCAL DE SIMPLES FATURAMENTO" $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT .AND. SA2->A2_COD="000167"
              cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
                   at("NOTA FISCAL DE SIMPLES FATURAMENTO", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+38,6),".","")
           EndIf  

	       //BAZAN
           If "NOTA FISCAL DE SIMPLES FATURAMENTO" $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT .AND. SA2->A2_COD="000007"
              cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
                   at("NOTA FISCAL DE SIMPLES FATURAMENTO", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+38,6),".","")
           EndIf  
           //BELA VISTA
           If "NOTA FISCAL DE VENDA" $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT .AND. SA2->A2_COD="000003" 
              cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
                   at("NOTA FISCAL DE VENDA", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+24,6),".","")
           EndIf  
   	       //CAETE
	       If SA2->A2_COD="000210" .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
              cnfmae:= STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),6)
	       EndIf      
	       //sta isabel REFERENTE NOTA FISCAL DE VENDA P/ ENTREGA FUTURA
           If "REFERENTE NOTA FISCAL DE VENDA P/ ENTREGA FUTURA" $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT .AND. SA2->A2_COD="000184" 
              cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
                   at("REFERENTE NOTA FISCAL DE VENDA P/ ENTREGA FUTURA", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+53,6),".","")
              cnfmae:=Trim(cnfmae)
           EndIf  
	       //STA.RITA
  	       If SA2->A2_COD="000084" .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
              cnfmae:= STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),6)
 	       EndIf                     
	       //MARINGA
	       If SA2->A2_COD="000081" .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
              cnfmae:= STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),6)
	       EndIf                     
	       //Sta Fé
	       If SA2->A2_COD="000161" .AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
	          //Nota fiscal de simples faturamento nro
              //cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
              //     at("Nota fiscal de simples faturamento nro", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+39,6),".","")
              //cnfmae:=ALLTrim(cnfmae)
              cnfmae:= STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),6)
	       EndIf                                                                                                  
	       //DISA TEMPORARIO
	       If SA2->A2_COD=="000006" //.AND. Type("OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE")<>"U"
              //cnfmae:= AllTrim(STR(VAL(SUBSTR(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT,26,9)),9))
              cnfmae:= Trim(strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
                   at("FATURADO REF. CONTRATO(S) NR.", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+30,12),".",""))
                   Alert(cnfmae)
	       EndIf
	       //COMPANHIA ALBERTINA MERC. E INDUSTRIAL          
	       If SA2->A2_COD="000168" .AND. ", NF " $ OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT 
	          //, NF                    
              cnfmae:= strtran(substr(OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT,;
                   at(", NF ", OXML:_NFEPROC:_NFE:_INFNFE:_infAdic:_infCpl:TEXT)+5,7),".","")
              cnfmae:=AllTrim(str(val(cnfmae),9))
	       EndIf                             
	    ENDIF
	    if !lFor .AND. !lProd .AND. !lTransp
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
		   (cAliasTrb)->TP_ITEM    := STRZERO(X_X,3)
		   (cAliasTrb)->NR_NFISCAL := STRZERO( VAL(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9 )   //OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_CNF:TEXT
		   (cAliasTrb)->SERIE      := OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
		   (cAliasTrb)->DT_EMISSAO := _CONVDTSPED(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT)
		   (cAliasTrb)->CLI_FOR    := SA2->A2_COD
		   (cAliasTrb)->LJ_CLI_FOR := SA2->A2_LOJA
		   (cAliasTrb)->ESTADO     := SA2->A2_EST
		   (cAliasTrb)->COD_PROD   := SB1->B1_COD
		   (cAliasTrb)->UNIDADE    := iif(n_tam_det>1,OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_UCOM:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_UCOM:TEXT)//SB1->B1_UM
	  	   
	  	   //Tratamento para a DISA que envia UM errada
	  	   If SA2->A2_COD $ '000006/000008' .And. ((cAliasTrb)->UNIDADE=="S5" .or. (cAliasTrb)->UNIDADE=="s5" .Or. (cAliasTrb)->UNIDADE=="S50")
	  	   		(cAliasTrb)->UNIDADE	:= "SC"
	  	   EndIf
	  	   
	  	   If (cAliasTrb)->UNIDADE=="tn" .or. (cAliasTrb)->UNIDADE=="TN"
		      //(cAliasTrb)->VLR_UNIT   
		      xVlun := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT))
  		      if (cAliasTrb)->VLR_UNIT==0
  		         (cAliasTrb)->VLR_UNIT   := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNCOM:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNCOM:TEXT)))/20
		      else
		         (cAliasTrb)->VLR_UNIT   := (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VUNTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VUNTRIB:TEXT)))/20
		      endif
  	  	      
  	  	      *'Yttalo P. Martins-INICIO--------------------------------------------------------------------------------------------------'*
  	  	      //(cAliasTrb)->QUANTIDADE := 20 * (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QTRIB:TEXT)))
  	  	      (cAliasTrb)->QUANTIDADE := U_EDFFATOR((cAliasTrb)->COD_PROD) * (iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_QTRIB:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_QTRIB:TEXT)))
  	  	      *'Yttalo P. Martins-INICIO--------------------------------------------------------------------------------------------------'*
  	  	        	  	      
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
	  	   //DISA Unidade de Medida S50 = SC
	  	   /*If (cAliasTrb)->UNIDADE=="S5"
	  	   		(cAliasTrb)->UNIDADE	:= "SC"
	  	   EndIf*/
		   (cAliasTrb)->VLR_TOTAL  := iif(n_tam_det>1,VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET[X_X]:_PROD:_VPROD:TEXT),VAL(OXML:_NFEPROC:_NFE:_INFNFE:_DET:_PROD:_VPROD:TEXT))

		   //(cAliasTrb)->TES        := SF4->F4_CODIGO
		   //(cAliasTrb)->CFOP       := SF4->F4_CF
		   (cAliasTrb)->BASE_ICMS  := VAL(OXML:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:TEXT)
		   (cAliasTrb)->VLR_ICMS   := VAL(OXML:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT)
		   (cAliasTrb)->ALIQ_ICMS  := 0
		   (cAliasTrb)->TRANSP     := If( X_futura$"922/501","", SA4->A4_COD)
		   (cAliasTrb)->VL_SEGURO  := 0
		   (cAliasTrb)->VL_FRETE   := 0
		   (cAliasTrb)->PESO_LIQUI := IIF(TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT")<>"U",val(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOL:TEXT),0)
		   (cAliasTrb)->PESO_BRUTO := IIF(TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT")<>"U",val(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_PESOB:TEXT),0)
		   (cAliasTrb)->ESPECIE    := "NFE" 
		   (cAliasTrb)->VOLUME     := IIF(TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT")<>"U",VAL(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_VOL:_QVOL:TEXT),0)
		   (cAliasTrb)->NATUREZA   := ''
		   (cAliasTrb)->COND_PAG   := '001' //Adriano - Tirar condição de pagamento fixa e buscar no contrato.
		   
		   (cAliasTrb)->INFNEID    := Substr(OXML:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,44)
		   
		   (cAliasTrb)->NF_MAE     := cnfmae
	
		   (cAliasTrb)->(MsUnLock())
		ELSE
  		   lOk   := .F.
		   lErro := .T.
		   
		   // adriano 06/6/11 - acrescentei as linhas abaixo em 06/6/11
		   (cAliasTrb)->(DbCloseArea())

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
		RpcSetEnv( cEmpAnt, cFilAnt, , , , "LE_XML" )
	EndIf
	
	If Select(cAliasTrb) > 0
		(cAliasTrb)->(DbCloseArea())
	Endif
	
	oAliasTrb:= FwTemporarytable():New(cAliasTrb,aStru)
	oAliasTrb:AddIndex( "TRB001", {"NR_NFISCAL+SERIE+CLI_FOR+LJ_CLI_FOR"} )
	oAliasTrb:Create()
	
	(cAliasTrb)->(DbCommitAll())
	(cAliasTrb)->(DbGoTop())
	
	(cAliasTrb)->(DbSetOrder(1))
	
	If cTpMov$"NFE|PRE"
	   fProcNFE(cFilAnt,cTpMov,cAliasTrb,@lOk)
	ElseIf cTpMov$"NFS"
	// ESTE PROCESSO DEVE PREVER A ENTRADA DAS INFORMAÇÕES DE OUTRAS NOTAS, COMO EXEMPLO: IMPORTAÇÃO DE NOTAS DE OUTRAS FILIAS DA BAUCHE
	   fProcNFS(cFilAnt,cTpMov,cAliasTrb,@lOk)
	EndIf
	
	(cAliasTrb)->(DbCloseArea())
	
	If lExcJob
		RpcClearEnv()
	EndIf
Next nMovim

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
Private lMsErroAuto := .f.

(cAliasTrb)->( dbGoTop() )

While !(cAliasTrb)->( Eof() )
	
	lPreNota := (cTpMov=="PRE")
	lErro    := .F.
	cItem	 := StrZero(VAL((cAliasTrb)->TP_ITEM),Len(SD1->D1_ITEM))
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
	nBaseIcm := 0
	nValIcm  := 0
	nValMerc := 0
	nValBrut := 0
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
			cUM := If(Empty((cAliasTrb)->UNIDADE),SB1->B1_UM,(cAliasTrb)->UNIDADE)   
			
			If cUM=='tn' .or. cUM=='TN' .or. cUM='kg' .or. cUM="KG"
			   cUM := "SC"
			EndIf
			
			_nValUnit	:= round(((cAliasTrb)->VLR_TOTAL / (cAliasTrb)->QUANTIDADE) ,6)

			_cLocPad	:= SB1->B1_LOCPAD

			AAdd(aItem,{{"D1_COD"    ,(cAliasTrb)->COD_PROD                       ,Nil},;
			{"D1_ITEM"   ,cItem                                       ,Nil},;
			{"D1_UM"     ,cUm                                         ,Nil},;
			{"D1_QUANT"  ,(cAliasTrb)->QUANTIDADE                     ,Nil},;
			{"D1_VUNIT"  ,_nValUnit 				                  ,Nil},;
			{"D1_TOTAL"  ,(cAliasTrb)->VLR_TOTAL                      ,Nil},;
			{"D1_IPI"    ,0                                           ,Nil},;
			{"D1_VALIPI" ,0                                           ,Nil},;
			{"D1_PICM"   ,(cAliasTrb)->ALIQ_ICMS                      ,Nil},;
			{"D1_VALICM" ,0   						                  ,Nil},;
			{"D1_BASEICM" ,0   						                  ,Nil},;
			{"D1_BASEIPI" ,0   						                  ,Nil},;
			{"D1_RATEIO" ,"2"                                         ,Nil},;
			{"D1_LOCAL"  ,_cLocPad                                    ,Nil},;
			{"D1_BRICMS" ,0                                           ,Nil},;
			{"D1_ICMSRET",0                                           ,Nil}})

//			{"D1_TES"    ,(cAliasTrb)->TES                            ,Nil},;
//			{"D1_CF"     ,(cAliasTrb)->CFOP                           ,Nil},;


//			{"AUTDELETA" ,"N"                                         ,Nil}})
			
			cItem    := Soma1(cItem,Len(SD1->D1_ITEM))
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
		{"F1_FORMUL" , cFormul  ,NIL},;
		{"F1_DOC"    , cNFiscal ,NIL},;
		{"F1_SERIE"  , cSerNf   ,NIL},;
		{"F1_EMISSAO", dEmissao ,NIL},;
		{"F1_FORNECE", cCliFor  ,NIL},;
		{"F1_LOJA"   , cLoja    ,NIL},;
		{"F1_ESPECIE", cEspecie ,NIL},;
		{"F1_BASEICM", nBaseIcm ,NIL},;
		{"F1_VALICM" , nValIcm  ,NIL},;
		{"F1_VALIPI" , nValIcm  ,NIL},;
		{"F1_ICMSRET", 0        ,NIL},;                                
        {"F1_VALMERC", nValBrut ,NIL},;
		{"F1_VALBRUT", nValBrut ,NIL},;
		{"F1_ORIGEM" , "LEXML"  ,NIL},; 
		{"F1_TIPODOC", cTipoNf  ,Nil},;
		{"F1_COND"   , cCondPag ,NIL}}
		
//       ALERT("aqui "+cNFiscal)
                                          

		lMsErroAuto := .F.
		//If lPreNota
			ddatabase:=dDtDigit
			MSExecAuto({|x,y,z| Mata140(x,y,z) }, aCab, aItem, 3)
		//Else
		//	ddatabase:=dDtDigit
		//	MSExecAuto({|x,y,z| Mata103(x,y,z) }, aCab, aItem, 3)
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
			   msunlock()
			Endif

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
	cPedido := GetSxeNum("SC5","C5_NUM")
	SC5->(dbSetOrder(1))
	While SC5->(dbSeek(cFilReg+cPedido))
		ConfirmSX8()
		cPedido := GetSxeNum("SC5","C5_NUM")
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
				AAdd( aItem  , {{"C6_FILIAL" ,cFilSC6      ,Nil},;
								{"C6_ITEM"   ,cItem                        ,Nil},;     // 02
								{"C6_PRODUTO",(cAliasTrb)->COD_PROD        ,Nil},;    //  03
								{"C6_DESCRI" ,SB1->B1_DESC                 ,Nil},;    // 04
								{"C6_UNSVEN" ,(cAliasTrb)->QUANTIDADE      ,Nil},;   //  06
					         	{"C6_PRCVEN" ,(cAliasTrb)->VLR_UNIT        ,Nil},;   //  07
								{"C6_UM"     ,cUM                          ,Nil},;    //  09
								{"C6_QTDVEN" ,(cAliasTrb)->QUANTIDADE      ,Nil},;    // 10
								{"C6_TES"    ,(cAliasTrb)->TES             ,Nil},;    // 11
								{"C6_QTDLIB" ,(cAliasTrb)->QUANTIDADE      ,Nil},;    // 12
								{"C6_LOCAL"  ,_cLocPad 			     	  ,Nil},;    // 15
								{"C6_CLI"    ,(cAliasTrb)->CLI_FOR         ,Nil},;    // 19
								{"C6_DESCONT",(cAliasTrb)->DESC_PERC       ,Nil},;    // 20
								{"C6_VALDESC",(cAliasTrb)->DESC_VALOR      ,Nil},;    // 21
								{"C6_ENTREG" ,(cAliasTrb)->DT_EMISSAO      ,Nil},;    // 22
								{"C6_NFORI"  ,(cAliasTrb)->NF_COMPRA        ,Nil},;    // 22
								{"C6_SERIORI",(cAliasTrb)->SERIE_COM     ,Nil},;    // 22
								{"C6_ITEMORI",cItemOri 				     ,Nil},;    // 22
								{"C6_LOJA"   ,(cAliasTrb)->LJ_CLI_FOR      ,Nil},;    // 24
								{"C6_NUM"    ,cPedido                      ,Nil},;    // 28
								{"C6_PRUNIT" ,(cAliasTrb)->VLR_UNIT			 ,Nil},;    // 35
								{"C6_OP"     ,"02"                         ,Nil},;    // 39
								{"C6_TPOP"   ,"F"                          ,Nil}} )   // 67
         Else
				AAdd( aItem  , {{"C6_FILIAL" ,cFilSC6      ,Nil},;
								{"C6_ITEM"   ,cItem                        ,Nil},;     // 02
								{"C6_PRODUTO",(cAliasTrb)->COD_PROD        ,Nil},;    //  03
								{"C6_DESCRI" ,SB1->B1_DESC                 ,Nil},;    // 04
								{"C6_SEGUM"  ,cUM									  ,Nil},;    //  05
								{"C6_UNSVEN" ,(cAliasTrb)->QUANTIDADE      ,Nil},;   //  06
					        	{"C6_PRCVEN" ,(cAliasTrb)->VLR_UNIT        ,Nil},;   //  07
								{"C6_UM"     ,cUM                          ,Nil},;    //  09
								{"C6_QTDVEN" ,(cAliasTrb)->QUANTIDADE      ,Nil},;    // 10
								{"C6_TES"    ,(cAliasTrb)->TES             ,Nil},;    // 11
								{"C6_QTDLIB" ,(cAliasTrb)->QUANTIDADE      ,Nil},;    // 12
								{"C6_LOCAL"  ,_cLocPad 							  ,Nil},;    // 15
								{"C6_CLI"    ,(cAliasTrb)->CLI_FOR         ,Nil},;    // 19
								{"C6_DESCONT",(cAliasTrb)->DESC_PERC       ,Nil},;    // 20
								{"C6_VALDESC",(cAliasTrb)->DESC_VALOR      ,Nil},;    // 21
								{"C6_ENTREG" ,(cAliasTrb)->DT_EMISSAO      ,Nil},;    // 22
								{"C6_NFORI"  ,(cAliasTrb)->NF_COMPRA        ,Nil},;    // 22
								{"C6_SERIORI",(cAliasTrb)->SERIE_COM	    ,Nil},;    // 22
								{"C6_ITEMORI",cItemOri 			        	 ,Nil},;    // 22
								{"C6_LOJA"   ,(cAliasTrb)->LJ_CLI_FOR      ,Nil},;    // 24
								{"C6_NUM"    ,cPedido                      ,Nil},;    // 28
								{"C6_PRUNIT" ,(cAliasTrb)->VLR_UNIT			 ,Nil},;    // 35
								{"C6_OP"     ,"02"                         ,Nil},;    // 39
								{"C6_TPOP"   ,"F"                          ,Nil}} )   // 67
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
		DisarmTransaction()
		RollBackSxe()
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
	lGerouPv := .T.
	lLiber   := .T.
	lTrans   := .F.
	lCredito := .F.
	lEstoque := .F.
	lAvCred  := .T.
	lAvEst   := .T.
	lLiberOk := .T.
	lItLib   := .T.
	aPvlNfs  := {}
	DDATABASE:= dEmissao
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
		
		lMostraCtb   := .F.
		lAglutCtb    := .F.
		lCtbOnLine   := .F.
		lCtbCusto    := .F.
		lReajuste    := .F.
		nCalAcrs     := 0
		nArredPrcLis := 0
		lAtuSA7      := .F.
		lECF         := .F.
		
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

*--------------------------------------------------------*
User Function x_EnviaMail(cFrom,cTo,cAssunto,cAttach,cBody)
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

******************************************************************************************************

STATIC FUNCTION _CONVDTSPED(cData)
Local dData

dData := ctod(substr(cData,9,2)+"/"+substr(cData,6,2)+"/"+substr(cData,1,4))

Return dData
