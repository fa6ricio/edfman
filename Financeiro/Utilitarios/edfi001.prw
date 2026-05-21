#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPA001   ºAutor  ³Flávio Bezerra      º Data ³  07/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importação de Cliente/Produto/Fornecedor                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFI001

// BEGIN TRANSACTION

Processa ( { ||  Importa()  } )

// END TRANSACTION

Return

Static Function Importa

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cBuffer		:= ""
Private cArquiv     := ""

Private cNumPV      := ""
Private aCabPv      := {}
Private aItemPv     := {}
Private cDtInEn     := ""
Private cPerg       := "EDFI001"
Private cLog        := ""
Private aLog        := {}
Private cEnt        := Chr(13) + Chr(10)
//Private lMsErroAuto := .F.
private cAlias      := GetNextAlias()
Private cCaminho    := "C:\LOG"
Private cNomeArq    := Dtos(dDataBase) + Time()
Private aErroLog    := {}

Private nCount       := 0
Private cLogFile    := ""//nome do arquivo de log a ser gravadoLocal
Private aLog 	    := {}
Private aVetor      := {}
Private nHandle
Private lRet        := .F.        // variável de controle interno da rotina automatica que informa se houve erro durante o processamento
PRIVATE lMsErroAuto := .F.        // variável que define que o help deve ser gravado no arquivo de log e que as informações estão vindo à partir da rotina automática.
Private lMsHelpAuto	:= .T.       // força a gravação das informações de erro em array para manipulação da gravação ao invés de gravar direto no arquivo temporário
Private lAutoErrNoFile := .T.


//Putsx1(cPerg,"01","Tipo de arquivo:"      , "", "", "MV_CH1" , "N",1,0,0,"C","",""   ,"","","MV_PAR01","1-Cliente","","","","2-Fornecedor","","","3-Produto","","")
Putsx1(cPerg,"01","Tipo de arquivo:"      , "", "", "MV_CH1" , "N",1,0,0,"C","",""   ,"","","MV_PAR01","1-Fornecedor","","","","","","","","","")

pergunte(cPerg,.T.)

cTipo     := 2 // MV_PAR01
cTPImport := IIf(MV_PAR01 == 1,"Cliente",IIf(MV_PAR01 == 2," Fornecedor","Produto"))

Private cArquiv 	:= cGetFile("Todos os Arquivos|*.*",OemToAnsi("Importação de " + cTPImport + "..."),0, ,.T.)

//Caso não exista nenhum arquivo para abertura retorna.
If Empty(cArquiv)
	Return
EndIf

*---------------------*
* Abre o Arquivo Texto   *
*---------------------*
FT_FUSE(cArquiv)

*-------------------------------------------------------------------------------*
* Vai para o Inicio do Arquivo e Define o numero de Linhas para a Barra de Processamento. *
*-------------------------------------------------------------------------------*
FT_FGOTOP()
ProcRegua(FT_FLASTREC())

*--------------------------*
* Leitura da linha do arquivo *
*--------------------------*
cBuffer := FT_FREADLN()

FT_FSKIP() //pula primeira linha do arquivo.

//Abre a tabela que será gravada..
ctabela := IIf(cTipo == 1,"SA1",IIf(cTipo == 2,"SA2","SB1"))
DbSelectarea(ctabela)

*------------------------------------*
* Percorre todo os itens do arquivo CSV. *
*------------------------------------*
While !FT_FEOF() //Percorre todo os itens do arquivo CSV.
	
	IncProc("Importando..")
	
	aTmpDados := {}
	aDados    := {}
	nCount+=1
	
	*---------------------------------------------------------*
	* Faz a Leitura da Linha do Arquivo e atribui a Variavel cBuffer *
	*---------------------------------------------------------*
	cBuffer := FT_FREADLN()
	
	*-------------------------------------------------------------*
	* Se ja passou por todos os registros da planilha "CSV" sai do While. *
	*-------------------------------------------------------------*
	If Empty(cBuffer)
		Exit
	Endif
	
	*----------------------------------------*
	* Retorna posicao em que foi encontrado o ";" *
	*----------------------------------------*
	xPos := AT(";",cBuffer)
	
	*----------------------------------------------------------------------------------*
	* somente grava o item se houver o "x" na planilha,ou seja, o ";" não estiver na posição 1.  *
	*----------------------------------------------------------------------------------*
	//	if !Empty(SubStr(cBuffer , 1, xPos-1 ))
	*----------------------------------------------------------------------------------------*
	* Adiciona as informacoes no vetor ate o ";" e retira o conteudo inserido no vetor da linha cBuffer *
	*----------------------------------------------------------------------------------------*
	While xPos <> 0
		aInfo  := Alltrim(SubStr(cBuffer , 1, xPos-1 ))
		aAdd( aTmpDados , aInfo )
		cBuffer:= SubStr(cBuffer , xPos+1, Len(cBuffer)-xPos)
		xPos := AT(";",cBuffer)
	Enddo
	*--------------------------------------------------------------------------------------------------*
	* Se ainda tiver informacao no cBuffer, adiciona a ultima parte do arquivo depois do ";" no vetor  *
	*--------------------------------------------------------------------------------------------------*
	If Len(cBuffer) > 0
		aInfo  := Alltrim(SubStr(cBuffer , 1, Len(cBuffer) ))
		aAdd( aTmpDados , aInfo )
	Else
		aInfo  := ""
		aAdd( aTmpDados , aInfo )
	EndIf
	
	aAdd( aDados , aTmpDados )
	//endif
	
	Do Case
		Case cTipo == 1   //Cliente
			
			nOpc := 3 //Inclusão
			
			cCgc := ""
			
			For x := 1 to len(aTmpDados[13])
				If !Substr(aTmpDados[13],x,1) $ ".|/|-"
					cCgc += Substr(aTmpDados[13],x,1)
				EndIf
			Next
			
			//Verifica se o cliente já existe cadastrado na base, se já existir altera o cliente..
			cQuery := " SELECT A1_COD, A1_LOJA, A1_CGC"
			cQuery += " FROM " + RetSqlName("SA1")"
			cQuery += " WHERE A1_CGC  = '"+cCgc+"'"
			cQuery += " AND D_E_L_E_T_ = ' '"
			
			If Select(cAlias) > 0
				DbselectArea(cAlias)
				(cAlias)->(DbCloseArea())
			EndIf
			
			DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
			
			If !(cAlias)->(Eof())
				nOpc := 4 //Alteração
				cCodCli := (cAlias)->A1_COD
				cCodLoj := (cAlias)->A1_LOJA
			Else
				cCodCli := STRZERO(VAL(aTmpDados[2]),6)//GetSX8Num( "SA1","A1_COD" )
				cCodLoj := STRZERO(VAL(aTmpDados[3]),2)//"01"
			EndIf
			cCep := ""
			
			For x := 1 to len(aTmpDados[9])
				If !Substr(aTmpDados[9],x,1) $ "-"
					cCep += Substr(aTmpDados[9],x,1)
				EndIf
			Next
			
			aVetor :={}
			
			Aadd(aVetor,{"A1_FILIAL" ,  xfilial("SA1")          ,Nil})	        //C	2		Filial	Filial do Sistema
			Aadd(aVetor,{"A1_COD"    , 	cCodCli	                ,Nil}) 		//C	6		Codigo	Codigo do Cliente
			Aadd(aVetor,{"A1_LOJA"   , 	cCodLoj                 ,Nil}) 		//C	2		Loja	Loja do Cliente
			Aadd(aVetor,{"A1_PESSOA" , 	Substr(aTmpDados[4],1,1),Nil}) 		//C	1		Fisica/Jurid	Pessoa Fisica/Juridica
			Aadd(aVetor,{"A1_NOME"   , 	aTmpDados[5]			,Nil}) 		//C	40		Nome	Nome do cliente
			Aadd(aVetor,{"A1_NREDUZ" , 	aTmpDados[6]			,Nil}) 		//C	20		N Fantasia	Nome Reduzido do cliente
			Aadd(aVetor,{"A1_END"    , 	aTmpDados[7]			,Nil}) 		//C	40		Endereco	Endereco do cliente
			Aadd(aVetor,{"A1_TIPO"   , 	aTmpDados[8]			,Nil})	        //C	1		Tipo	Tipo do Cliente
			Aadd(aVetor,{"A1_EST"    , 	aTmpDados[10]			,Nil}) 		//C	2		Estado	Estado do cliente
			Aadd(aVetor,{"A1_COD_MUN", 	aTmpDados[11]			,Nil}) 		//C	5		Cd.Municipio	C¾digo do Municipio
			Aadd(aVetor,{"A1_CEP"    , 	cCep        			,Nil}) 	    // Cep
			Aadd(aVetor,{"A1_PAIS"   , 	aTmpDados[12]			,Nil}) 		//C	3		Pais	Codigo do Paİs
			Aadd(aVetor,{"A1_CGC"    , 	cCgc	         		,Nil}) 		//C	14		CNPJ/CPF	CNPJ/CPF do cliente
			If Substr(Alltrim(aTmpDados[4]),1,1) <> "F"
				Aadd(aVetor,{"A1_INSCR"  , 	aTmpDados[14]			        ,Nil}) 		//C	18		Ins. Estad.	Inscricao Estadual
				Aadd(aVetor,{"A1_INSCRM" , 	aTmpDados[15]			        ,Nil}) 		//C	18		Ins. Municip	Inscricao Municipal
			EndIf
			Aadd(aVetor,{"A1_EMAIL"  , 	aTmpDados[16]			,Nil}) 	    //C	20		Email
			Aadd(aVetor,{"A1_TPESSOA", 	aTmpDados[17]			,Nil})			//C	2		Tipo Pessoa	Tipo de Pessoa
						
			lRet := .F.
			
			MSExecAuto({|x,y| Mata030(x,y)},aVetor,nOpc) //Inclusao
			
			If lMsErroAuto
				
				//AutoGrLog("Teste de geração do arquivo de log "+Alltrim(Time()))
				//AutoGrLog("")
				
				cLogFile := "C:\LOG\LOG"+Alltrim(Str(nCount))+".LOG"		//função que retorna as informações de erro ocorridos durante o processo da rotina automática
				aLog := GetAutoGRLog()	                                 				//efetua o tratamento para validar se o arquivo de log já existe
				If !File(cLogFile)
					If (nHandle := MSFCreate(cLogFile,0)) <> -1
						lRet := .T.
					EndIf
				Else
					If (nHandle := FOpen(cLogFile,2)) <> -1
						FSeek(nHandle,0,2)
						lRet := .T.
					EndIf
				EndIf
				If lRet //grava as informações de log no arquivo especificado
					cTexto := ""
					
					For nX := 1 To Len(aLog)
						FWrite(nHandle,aLog[nX]+CHR(13)+CHR(10))
						cTexto += aLog[nX]+CHR(13)+CHR(10)
					Next nX
					aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],aTmpDados[5],aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],aTmpDados[11],aTmpDados[12],aTmpDados[13],aTmpDados[14],aTmpDados[15],aTmpDados[16],aTmpDados[17],cTexto})
					
					FClose(nHandle)
				EndIf
				
				RollBackSX8()
				lMsErroAuto := .F.
			//Else
			  //	If nOpc == 3
				  //	ConfirmSX8()
				//endif
			EndIf
			
		Case cTipo == 2 //Fornecedor
			
			nOpc := 3 //Inclusão
			
			cCgc := ""
			
			For x := 1 to len(aTmpDados[11])
				If !Substr(aTmpDados[11],x,1) $ ".|/|-"
					cCgc += Substr(aTmpDados[11],x,1)
				EndIf
			Next
			
			//Verifica se o Fornecedor já existe cadastrado na base, se já existir altera o Fornecedor..
			cQuery := " SELECT A2_COD, A2_LOJA, A2_CGC"
			cQuery += " FROM " + RetSqlName("SA2")"
			cQuery += " WHERE A2_CGC  = '"+cCgc+"'"
			cQuery += " AND D_E_L_E_T_ = ' '"
			
			If Select(cAlias) > 0
				DbselectArea(cAlias)
				(cAlias)->(DbCloseArea())
			EndIf
			
			DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
			
			If !(cAlias)->(Eof()) .And. aTmpDados[7] <> "EX"
				nOpc := 4 //Alteração
				cCodFor := (cAlias)->A2_COD
				cLojFor := (cAlias)->A2_LOJA
			Else
				cCodFor := STRZERO(VAL(aTmpDados[2]),6)//GetSx8Num("SA2","A2_COD")
				cLojFor := STRZERO(VAL(aTmpDados[3]),2)//"01"
			Endif
			
			aVetor := {}
			
			Aadd(aVetor,{"A2_FILIAL"  ,  xFilial("SA2")	,Nil}) 		//C	2		Filial	Filial do Sistema
			Aadd(aVetor,{"A2_COD"     ,  cCodFor	        ,Nil})			//C	6		Codigo	Codigo do Fornecedor
			Aadd(aVetor,{"A2_LOJA"    ,  cLojFor	                ,Nil})			//C	2		Loja	Loja do Fornecedor
			Aadd(aVetor,{"A2_NOME"    ,  aTmpDados[4]	        ,Nil})			//C	40		Razao Social	Nome ou Razao Social
			Aadd(aVetor,{"A2_NREDUZ"  ,  aTmpDados[5]	        ,Nil})			//C	20		N Fantasia	Nome de Fantasia
			Aadd(aVetor,{"A2_END"     ,  aTmpDados[6]	        ,Nil})			//C	40		Endereco	Endereco do Fornecedor
			Aadd(aVetor,{"A2_EST"     ,  aTmpDados[7]           ,Nil})			//C	2		Estado	Sigla da Federacao
			Aadd(aVetor,{"A2_CEP"     ,  aTmpDados[8]           ,Nil})			//C	2		Estado	Sigla da Federacao
			Aadd(aVetor,{"A2_COD_MUN" ,  STRZERO(VAL(aTmpDados[9]),5)	        ,Nil})			//C	5		Cod. Municip	Codigo do Municipio
			Aadd(aVetor,{"A2_TIPO"    ,  aTmpDados[10]	        ,Nil})			//C	1		Tipo	Tipo do Fornecedor
			Aadd(aVetor,{"A2_CGC"     ,  cCgc	                ,Nil})			//C	14		CNPJ/CPF	CNPJ/CPF do cliente
			Aadd(aVetor,{"A2_INSCR"   ,  aTmpDados[12]	        ,Nil})			//C	18		Ins. Estad.	Inscricao Estadual
			Aadd(aVetor,{"A2_INSCRM"  ,  aTmpDados[13]	        ,Nil})			//C	18		Ins. Municip	Inscricao Municipal
			Aadd(aVetor,{"A2_PAIS"    ,  aTmpDados[14]	        ,Nil})			//C	3		Pais	Pais do Fornecedor
			Aadd(aVetor,{"A2_TPESSOA" ,  aTmpDados[15]	        ,Nil})			//C	2		Tipo Pessoa	Tipo de Pessoa
			Aadd(aVetor,{"A2_MUN"     ,	 aTmpDados[16]	        ,Nil})
			Aadd(aVetor,{"A2_BAIRRO"  ,  aTmpDados[17]	        ,Nil})
			Aadd(aVetor,{"A2_DDI"     ,  aTmpDados[18]	        ,Nil})
			Aadd(aVetor,{"A2_DDD"     ,  aTmpDados[19]	        ,Nil})
			Aadd(aVetor,{"A2_TEL"     ,  aTmpDados[20]	        ,Nil})
			Aadd(aVetor,{"A2_EMAIL"   ,  aTmpDados[21]	        ,Nil})
			Aadd(aVetor,{"A2_CODPAIS" ,  STRZERO(VAL(aTmpDados[22]),5)	        ,Nil})
			Aadd(aVetor,{"A2_BANCO"   ,  STRZERO(VAL(aTmpDados[23]),3)	        ,Nil})
			Aadd(aVetor,{"A2_AGENCIA" ,  aTmpDados[24]	        ,Nil})
			Aadd(aVetor,{"A2_NUMCON"  ,  aTmpDados[25]	        ,Nil})
			Aadd(aVetor,{"A2_RECISS"  ,  aTmpDados[26]	        ,Nil})
			Aadd(aVetor,{"A2_RECINSS" ,  aTmpDados[27]	        ,Nil})
			Aadd(aVetor,{"A2_RECPIS"  ,  aTmpDados[28]	        ,Nil})
			Aadd(aVetor,{"A2_RECCSLL" ,  aTmpDados[29]	        ,Nil})
			Aadd(aVetor,{"A2_RECCOFI" ,  aTmpDados[30]	        ,Nil})
			Aadd(aVetor,{"A2_CALCIRF" ,  aTmpDados[31]	        ,Nil})
			Aadd(aVetor,{"A2_COMPLEM" ,  aTmpDados[32]	        ,Nil})

			lMsErroAuto := .F.
			lRet := .F.
			
			If cCodFor == "000096"
			x:=0
            EndIf

			MSExecAuto({|x,y| Mata020(x,y)},aVetor,nOpc) //Inclusao
			
			If lMsErroAuto
				
				//AutoGrLog("Teste de geração do arquivo de log "+Alltrim(Time()))
				//AutoGrLog("")
				
				cLogFile := "C:\LOG\LOG"+Alltrim(Str(nCount))+".LOG"		//função que retorna as informações de erro ocorridos durante o processo da rotina automática
				aLog := GetAutoGRLog()	                                 				//efetua o tratamento para validar se o arquivo de log já existe
				If !File(cLogFile)
					If (nHandle := MSFCreate(cLogFile,0)) <> -1
						lRet := .T.
					EndIf
				Else
					If (nHandle := FOpen(cLogFile,2)) <> -1
						FSeek(nHandle,0,2)
						lRet := .T.
					EndIf
				EndIf
				If lRet //grava as informações de log no arquivo especificado
					cTexto := ""
					
					For nX := 1 To Len(aLog)
						FWrite(nHandle,aLog[nX]+CHR(13)+CHR(10))
						cTexto += aLog[nX]+CHR(13)+CHR(10)
					Next nX
					aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],aTmpDados[5],aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],aTmpDados[11],aTmpDados[12],aTmpDados[13],aTmpDados[14],aTmpDados[15],cTexto})
					
					FClose(nHandle)
				EndIf
				
				RollBackSX8()
				lMsErroAuto := .F.
			//Else
				//If nOpc == 3
				//	ConfirmSX8()
				//endif
			EndIf
			
		Case cTipo == 3 //Produto
			
			
			//Verifica se o Produto já existe cadastrado na base, se já existir altera o Produto..
			cQuery := " SELECT B1_COD"
			cQuery += " FROM " + RetSqlName("SB1")"
			cQuery += " WHERE B1_COD   = '"+STRZERO(VAL(aTmpDados[2]),6)+"'"
			cQuery += " AND D_E_L_E_T_ = ' '"
			
			If Select(cAlias) > 0
				DbselectArea(cAlias)
				(cAlias)->(DbCloseArea())
			EndIf
			
			DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
			
			If !(cAlias)->(Eof())
				nOpc := 4 //Alteração
				cCodProd := (cAlias)->B1_COD
			Else
				nOpc := 3 //Inclusão
				cCodProd := STRZERO(VAL(aTmpDados[2]),6) //GetSX8Num("SB1","B1_COD")
			EndIf
			
			aVetor := {}
			Aadd(aVetor,{"B1_FILIAL"  , xfilial("SB1")    ,Nil}) 	//C	2		Filial	Filial do Sistema
			Aadd(aVetor,{"B1_COD"     , cCodProd      			,Nil}) 	//C	30		Codigo	Codigo do Produto
			Aadd(aVetor,{"B1_DESC"    , UPPER(Alltrim(aTmpDados[3])),Nil}) 	//C	30		Descricao	Descricao do Produto
			Aadd(aVetor,{"B1_TIPO" 	  , aTmpDados[4]      			,Nil}) 	//C	2		Tipo	Tipo de Produto (MP,PA,.)
			Aadd(aVetor,{"B1_UM"      , aTmpDados[5]      			,Nil}) 	//C	2		Unidade	Unidade de Medida
			Aadd(aVetor,{"B1_LOCPAD"  , STRZERO(Val(aTmpDados[6]),2)      			,Nil}) 	//C	2		Armazem Pad.	Armazem Padrao p/Requis.
			Aadd(aVetor,{"B1_GRUPO"   , STRZERO(Val(aTmpDados[7]),4)      			,Nil}) 	//C	4		Grupo	Grupo de Estoque
			Aadd(aVetor,{"B1_POSIPI"  , aTmpDados[8]      			,Nil}) 	//C	10		Pos.IPI/NCM	Nomenclatura Ext.Mercosul
			Aadd(aVetor,{"B1_TS"      , aTmpDados[9]      			,Nil}) 	//C	3		TS Padrao	Codigo de Saida padrao
			Aadd(aVetor,{"B1_PICMRET" , VAl(aTmpDados[10])            	,Nil}) 	//N	5	2	Solid. Saida	% Lucro Calc. Solid.Saida
			Aadd(aVetor,{"B1_ORIGEM"  , aTmpDados[11]	  			,Nil})  	//C	1		Origem	Origem do produto
			
			lMsErroAuto := .F.
			lRet := .F.
			
			MSExecAuto({|x,y| Mata010(x,y)},aVetor,3) //Inclusao
			
			If lMsErroAuto
				
				//AutoGrLog("Teste de geração do arquivo de log "+Alltrim(Time()))
				//AutoGrLog("")
				
				cLogFile := "C:\LOG\LOG"+Alltrim(Str(nCount))+".LOG"		//função que retorna as informações de erro ocorridos durante o processo da rotina automática
				aLog := GetAutoGRLog()	                                 				//efetua o tratamento para validar se o arquivo de log já existe
				If !File(cLogFile)
					If (nHandle := MSFCreate(cLogFile,0)) <> -1
						lRet := .T.
					EndIf
				Else
					If (nHandle := FOpen(cLogFile,2)) <> -1
						FSeek(nHandle,0,2)
						lRet := .T.
					EndIf
				EndIf
				If lRet //grava as informações de log no arquivo especificado
					cTexto := ""
					
					For nX := 1 To Len(aLog)
						FWrite(nHandle,aLog[nX]+CHR(13)+CHR(10))
						cTexto += aLog[nX]+CHR(13)+CHR(10)
					Next nX
					aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],aTmpDados[5],aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],aTmpDados[11],cTexto})
					FClose(nHandle)
				EndIf
				
				RollBackSX8()
				lMsErroAuto := .F.
			//Else
			 //	If nOpc == 3
			//		ConfirmSX8()
			//	endif
			EndIf
	EndCase
	
	IncProc("Importando....")
	
	*------------------------*
	* Incrementa linha       *
	*------------------------*
	FT_FSKIP()
Enddo

//Fecha a tabela que está aberta..
DbSelectarea(ctabela)
DbCloseArea()

//Grava arquivo de log.
If Len(aErroLog) > 0
	If msgYesNo("Deseja Gerar Log com as inconsistências encontradas em Excel.")
		aCab := {}
		Do case
			Case cTipo == 1
				aCab := {"A1_FILIAL","A1_COD","A1_LOJA","A1_PESSOA","A1_NOME","A1_NREDUZ","A1_END","A1_TIPO","A1_CEP","A1_EST","A1_COD_MUN","A1_PAIS","A1_CGC","A1_INSCR","A1_INSCRM","A1_EMAIL","A1_TPESSOA"}
			Case cTipo == 2
				aCab := {"A2_FILIAL","A2_COD","A2_LOJA","A2_NOME","A2_NREDUZ","A2_END","A2_EST","A2_CEP","A2_COD_MUN","A2_TIPO","A2_CGC","A2_INSCR","A2_INSCRM","A2_PAIS","A2_TPESSOA"}
			Case cTipo == 3
				aCab := {"B1_FILIAL","B1_COD","B1_DESC","B1_TIPO","B1_UM","B1_LOCPAD","B1_GRUPO","B1_POSIPI","B1_TS","B1_PICMRET","B1_ORIGEM"}
		EndCase
		
		DlgToExcel({{"ARRAY","",aCab,aErroLog}})
		
		//Especifica onde o arquivo de log será gravado.
		//cCamlog := cGetFile("Todos os Arquivos|*.*",OemToAnsi("Log importação" + cTPImport + "..."),0, ,.F.)
		
		//MemoWrite(cCamlog + ".txt ",cLog)
		
	EndIf
Else
	MsgInfo("Importação realizada sem inconsistências.")
EndIf

Return