#Include "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RelSalMem  ³Autor   ³ Luiz Pereira³ Data    ³  20.05.15     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio Imprime os saldos dos memorandos em EXCEL         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Para controle do departamento fiscal da ED&FMAN             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gera Planilha Excel                  		               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
User Function RelSalMem()
	Local   nTpRel    := 2
	Private bFileFat  :={|| cDir:=ChoseMapDir(),If(Empty(cDir),cDir:=Space(200),Nil)}
	Private oDlg      := Nil
	Private cArq      := Space(10), cRel:="Relatorio de Saldos de Memorando"
	Private cDir      := Space(250)
	Private cPerg     := ""
	Private lRetor    := .T.
	Private lSair     := .F.
	Private lTudOk    := .T.
	Private aStru     := {}
	Private oArqTrb2  := {}
	Private cCamposCSV:= ""
	Private cDadosCSV := ""
	Private cMsg      := ""
	Private cArqTxt   := ""
	Private lAbortPrint:=.F.

	lEnd := .F.

	// Verifica as perguntas selecionadas
	cPerg := Avkey("RESALME","X1_GRUPO")

	ValidPerg(nTpRel)

	If !Pergunte(cPerg)
		Return (.T.)
	EndIf

	If Empty(MV_PAR07) .Or. Empty(MV_PAR08) 
		FWAlertHelp("Data da emissão da nota de saída está vazia","Preencha o range de data de emissão da nota de saída!")
		Return .F.
	ElseIf Empty(MV_PAR09) .Or. Empty(MV_PAR10)
		FWAlertHelp("Data da averbação está vazia","Preencha o range de data de averbação!")
		Return .F.
	EndIf

	// Definição da janela e seus conteúdos
	DEFINE MSDIALOG oDlg TITLE cRel FROM 0,0 TO 175,368 OF oDlg PIXEL

	@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlg PIXEL

	@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlg
	@ 25, 10 MSGET cArq               SIZE 50,8 PIXEL OF oDlg

	@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlg
	@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlg
	@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlg ACTION Eval(bFileFat)

	DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlg ACTION (ValiRel("ok")) ENABLE
	DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlg ACTION (ValiRel("cancel")) ENABLE

	ACTIVATE MSDIALOG oDlg CENTER

	If lSair
		Return .T.
	EndIf

	Processa({||GerExcel()},"Gerando Relatorio de Saldos de Memorando")

	If lTudOk
		MsgInfo(cMsg,"Atenção")
		lAbre := MsgYesNo("Deseja Abrir o arquivo em Excel?","Atenção")

		If lAbre
			If ! ApOleClient( 'MsExcel' )
				MsgStop(" MsExcel nao instalado ")
				Return
			EndIf

			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(cArqTxt)

			oExcelApp:SetVisible(.T.)
		EndIf
	EndIf

Return .T.


// Variaveis utilizadas para parametros                         
// mv_par01             // De  Filial                           
// mv_par02             // Ate Filial                           
// mv_par03             // Data Processo de:                    
// mv_par04             // Data Processo Ate:                   
Static Function GerEXCEL()
	// monta arquivo analitico

	aAdd(aStru,{"DESCPAIS"  ,"C",30,0})  // Descrição do Pais+Cidade de Destino    EEC
	aAdd(aStru,{"NRPROCES"  ,"C",20,0})  // Embarque - Nr Processo Embarque EEC (EYY_PREEMB)
	aAdd(aStru,{"CODCONTR"  ,"C",25,0})  // Numero do Contrato / Cod Produto	(EE9_COD_I)
	aAdd(aStru,{"NOMFORN"  	,"C",20,0})  // Nome Fornecedor / Usina				(EYY_FORN+EYY_FOLOJA)->A2_NREDUZ
	aAdd(aStru,{"NRCNPJ"    ,"C",18,2})  // CNPJ - Usina                   		(EYY_FORN+EYY_FOLOJA)->A2_CGC
	aAdd(aStru,{"NFEXP"     ,"C",10,0})  // "."+Nota Saida Exportação			(EYY_NFSAI)
	aAdd(aStru,{"SERSAI"    ,"C",03,0})  // "."+Serie Nota Saida  				(EYY_SERSAI)
	aAdd(aStru,{"NRMEM"  	,"C",20,0})  // "."+Numero Memorando				(EYY_NROMEX)
	aAdd(aStru,{"DTMEM" 	,"D",08,0})  // Data Memorando						(EYY_DTMEX)
	aAdd(aStru,{"NR_RE"     ,"C",16,0})  // Embarque - Nr RE				    (EYY_RE)
	aAdd(aStru,{"DTAVERB" 	,"D",08,0})  // Data Averbação

	// 21/09/18 - Luis Felipe - Inicio
	aAdd(aStru,{"DTDSE" 	,"D",08,0})  // Data da DSE							(EXL_DTDSE)  // 21/09/18 - Luis Felipe
	aAdd(aStru,{"NRODUE" 	,"C",14,0})  // Nro. DUE      						(EEC_NRODUE) // 21/09/18 - Luis Felipe
	aAdd(aStru,{"NRORUC" 	,"C",35,0})  // Nro. RUC      						(EEC_NRORUC) // 21/09/18 - Luis Felipe
	aAdd(aStru,{"CHVNFE"    ,"C",50,0})  // Chave da NFE    					 F1_CHVNFE // 21/09/18 - Luis Felipe
	// 21/09/18 - Luis Felipe - Fim

	aAdd(aStru,{"NFENT"     ,"C",10,0})  // "."+Nota Entrada Usina				(EYY_NFENT)
	aAdd(aStru,{"SERENT"    ,"C",03,0})  // "."+Serie 							(EYY_SERENT)

	aAdd(aStru,{"DTENT" 	,"D",08,0})  // Data Nota Entrada Usina				(EYY_NFENT+EYY_SERENT)->SF1->F1_EMISSAO
	aAdd(aStru,{"QTDNFENT"  ,"N",13,4})  // Qtd NF Entrada						 nQtNf=(FIL+EYY_NFENT+EYY_SERENT+EYY_FORN+EYY_FOLOJA+EE9_COD_I)->SD1->D1_QUANT
	aAdd(aStru,{"QTDMEM"    ,"N",13,4})  // Qtd Memorando						(EYY_QUANT)
	aAdd(aStru,{"SALNFENT"  ,"N",13,4})  // Qtd Saldo Nota                      (EYY_QUANT - nQtNf)
	aAdd(aStru,{"NOMFIL"    ,"C",20,0})  // Nome da Filial                      ("FILIAL SANTOS")
	aAdd(aStru,{"SITUACAO"  ,"C",30,0})  // Status Memorando                    Space(30)
	aAdd(aStru,{"FILIAL"  	,"C",05,0})  // Filial                              xFilial("EYY")
	aAdd(aStru,{"FIM" 	    ,"C",01,0})  // Fim

	oArqTrb2:= FwTemporarytable():New("TRB2",aStru)
	oArqTrb2:AddIndex( "TRB001", {"NFENT","NRPROCES","NFEXP"} )
	oArqTrb2:Create()

	DbSelectArea("TRB2")
	DbSetorder(1)

	Processa({|lEnd|GeraRel()})

	TRB2->(Dbclosearea())
	oArqTrb2:Delete()

Return .T.

//-------------------------------------------------------------------
/*{Protheus.doc} relsalmem
Seleciona Arquivo Itens da Nota de Entrada e gera o relatorio
@author  author
@since   date
@version version
*/
//-------------------------------------------------------------------
Static Function GeraRel()
	cAliasSD1:="SD1"
	dbSelectArea("SD1")
	cIndex := CriaTrab("",.F.)
	cKey := 'D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD'

	IndRegua("SD1",cIndex,cKey,,)
	dbSelectArea("SD1")

	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF

	dbGoTop()
	ProcRegua(LastRec())

	//Seleciona Arquivo Principal
	cAliasEYY:="EYY"
	dbSelectArea("EYY")
	cIndex := CriaTrab("",.F.)
	cKey := 'EYY_FILIAL+EYY_NFENT+EYY_PREEMB'

	cCondicao := 'EYY_FILIAL>="'	 +MV_PAR01+'".And.EYY_FILIAL<="'+MV_PAR02+'"'
	cCondicao += '.And.EYY_NFENT>="' +MV_PAR03+'".And.EYY_NFENT<="' +MV_PAR04+'"'
	cCondicao += '.And.EYY_NROMEX>="'+MV_PAR05+'".And.EYY_NROMEX<="'+MV_PAR06+'"'

	IndRegua("EYY",cIndex,cKey,,cCondicao)
	dbSelectArea("EYY")

	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF

	dbGoTop()
	ProcRegua(LastRec())

	cCodNf := ""
	nSomaSalNf := 0

	While EYY->(!Eof()) .And. !lAbortPrint
		
		DbSelectArea("EYY")
		dDtAverbDSE	:= Posicione("EXL",1,FWxFilial("EXL", EYY->EYY_FILIAL)+EYY->EYY_PREEMB,"EXL_AVRBDS")
		dDtNFe 		:= Posicione("SF1",1,FWxFilial("SF1", EYY->EYY_FILIAL)+EYY->EYY_NFENT+EYY->EYY_SERENT,"F1_EMISSAO")

		cChvNfe		:= "."+Posicione("SF1",1,FWxFilial("SF1", EYY->EYY_FILIAL)+EYY->EYY_NFENT+EYY->EYY_SERENT+EYY->EYY_FORN+EYY->EYY_FOLOJA,"F1_CHVNFE") // Chave da NFE

		cCodDest  	:= Posicione("EEC",1,FWxFilial("EEC", EYY->EYY_FILIAL)+EYY->EYY_PREEMB,"EEC_DEST")
		cDescDest 	:= Posicione("SY9",1,FWxFilial("SY9", EYY->EYY_FILIAL)+cCodDest,"Y9_DESCR")

		cNRODUE  	:= Posicione("EEC",1,FWxFilial("EEC", EYY->EYY_FILIAL)+EYY->EYY_PREEMB,"EEC_NRODUE") // Nro. DUE
		cNRORUC  	:= Posicione("EEC",1,FWxFilial("EEC", EYY->EYY_FILIAL)+EYY->EYY_PREEMB,"EEC_NRORUC") // Nro. RUC

		cPais     	:= Posicione("SY9",1,FWxFilial("SY9", EYY->EYY_FILIAL)+cCodDest,"Y9_PAIS")
		cDescPais 	:= Posicione("SYA",1,FWxFilial("SYA", EYY->EYY_FILIAL)+cPais,"YA_DESCR")

		IncProc("Fil: "+EYY->EYY_FILIAL+" Proc: "+Alltrim(EYY->EYY_PREEMB)+" Mem: "+AllTrim(EYY->EYY_NROMEX))

		IF DtoS(dDtAverbDSE) >= DtoS(MV_PAR09) .and. DtoS(dDtAverbDSE) <= DtoS(MV_PAR10)

			IF DtoS(dDtNFE) >= DtoS(MV_PAR07) .and. DtoS(dDtNFE) <= DtoS(MV_PAR08)

				If RecLock("TRB2",.T.)
					TRB2->FILIAL	:= "."+EYY->EYY_FILIAL
					TRB2->DESCPAIS	:= Alltrim(Substr(cDescPais,1,13))+ " / "+Alltrim(Substr(cDescDest,1,13)) // Embarque - Descrição do Porto de Destino
					TRB2->NRPROCES	:= EYY->EYY_PREEMB 			// Embarque - Nr Processo Embarque
					cProCodItem 	:= Posicione("EE9",2,EYY->EYY_FILIAL+EYY->EYY_PREEMB+EYY->EYY_PEDIDO+EYY->EYY_SEQUEN,"EE9_COD_I")

					If cProCodItem+EYY->EYY_NFENT <> cCodNf
						cCodNf := cProCodItem+EYY->EYY_NFENT
						nSomaSalNf := 0
					Endif

					TRB2->CODCONTR	:= cProCodItem     			// Numero do Contrato / Cod Produto	(EE9_COD_I)
					TRB2->NOMFORN   := Posicione("SA2",1,xFilial("SA2")+EYY->EYY_FORN+EYY->EYY_FOLOJA,"A2_NREDUZ")
					cAntCNPJ := Posicione("SA2",1,xFilial("SA2")+EYY->EYY_FORN+EYY->EYY_FOLOJA,"A2_CGC")
					cCNPJ 	 := Transform(cAntCNPJ,"@R 99.999.999/9999-99")
					TRB2->NRCNPJ   	:= cCNPJ 					// CNPJ - Usina
					TRB2->NFEXP		:= "."+EYY->EYY_NFSAI  		// "."+Nota Saida Export
					TRB2->SERSAI 	:= "."+EYY->EYY_SERSAI  	// "."+Serie Nota Saida
					TRB2->NRMEM		:= "."+EYY->EYY_NROMEX  	// "."+Numero Memorando
					TRB2->DTMEM   	:= EYY->EYY_DTMEX  			// Data Memorando
					cRE := Transform(EYY->EYY_RE,"@R 99/999999999-999") // Embarque - Nr RE
					TRB2->NR_RE		:= cRE
					TRB2->DTAVERB   := dDtAverbDSE
					TRB2->NFENT  	:= "."+EYY->EYY_NFENT		// "."+Nota Entrada Usina
					TRB2->SERENT   	:= "."+EYY->EYY_SERENT		// "."+Serie
					TRB2->DTENT	   	:= Posicione("SF1",1,EYY->EYY_FILIAL+EYY->EYY_NFENT+EYY->EYY_SERENT,"F1_EMISSAO") // Data Nota Entrada Usina
					nQtNf := Posicione("SD1",1,EYY->EYY_FILIAL+EYY->EYY_NFENT+EYY->EYY_SERENT+EYY->EYY_FORN+EYY->EYY_FOLOJA+cProCodItem,"D1_QUANT")
					TRB2->QTDNFENT 	:= nQtNF 					// Qtd NF Entrada
					TRB2->QTDMEM 	:= EYY->EYY_QUANT  			// Qtd Memorando
					If nSomaSalNf == 0
						nSomaSalNf 	:= nQtNf - EYY->EYY_QUANT
					Else
						nSomaSalNf 	:= (nSomaSalNF - EYY->EYY_QUANT)
					Endif
					TRB2->SALNFENT 	:= nSomaSalNf 				// Qtd Saldo
					TRB2->NOMFIL 	:= SM0->M0_FILIAL 			//"FILIAL SANTOS" 			// Nome da Filial
					TRB2->SITUACAO 	:= Space(30)				// Status Memorando

					// 21/09/18 - Luis Felipe - inicio
					TRB2->DTDSE    	:= 	Posicione("EXL",1,EYY->EYY_FILIAL+EYY->EYY_PREEMB,"EXL_DTDSE") // Data da DSE
					TRB2->NRODUE   	:= 	cNRODUE // Nro. DUE
					TRB2->NRORUC   	:= 	cNRORUC // Nro. RUC
					TRB2->CHVNFE   	:= 	cCHVNFE // Chave da NFE
					// 21/09/18 - Luis Felipe - fim

					TRB2->(MsUnlock())
				EndIf

			Endif
		Endif

		EYY->(dbSkip())

	Enddo

	DbSelectArea("TRB2")

	RelMemExcel()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RelMemExcel ºAutor  ³Fernando          º Data ³  05/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera Arquivo em Excel e abre                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function RelMemExcel()

	MsAguarde({||RelMemCSV()},"Aguarde","Gerando Planilha Relatorio de Saldos de Memorando ",.F.)

return .T.

//+-----------------------------------------------------------------------------------//
//|Funcao....: ValidPerg()
//|Descricao.: Valida a existencia das perguntas, criando caso não exista
//|Observação:
//+-----------------------------------------------------------------------------------//
Static Function ValidPerg(xTp)

	Local sAlias := Alias()
	Local aRegs := {}
	Local i,j

	aAdd(aRegs,{cPerg,"01","Filial   De"       ,"","","mv_ch1","C",04,0,0,"G","U_ValPgMem ('01')","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	aAdd(aRegs,{cPerg,"02","Filial   Ate"      ,"","","mv_ch2","C",04,0,0,"G","U_ValPgMem ('02')","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	aAdd(aRegs,{cPerg,"03","NF Entr. De"  	   ,"","","mv_ch3","C",09,0,0,"G","U_ValPgMem ('03')","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SF1","","","","@E",""})
	aAdd(aRegs,{cPerg,"04","NF Entr. Ate" 	   ,"","","mv_ch4","C",09,0,0,"G","U_ValPgMem ('04')","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SF1","","","","@E",""})
	aAdd(aRegs,{cPerg,"05","Memor.   De"       ,"","","mv_ch5","C",20,0,0,"G","U_ValPgMem ('05')","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","EYY2","","","","@E",""})
	aAdd(aRegs,{cPerg,"06","Memor.   Ate"      ,"","","mv_ch6","C",20,0,0,"G","U_ValPgMem ('06')","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","EYY2","","","","@E",""})
	aAdd(aRegs,{cPerg,"07","Dta  NFE De"  	   ,"","","mv_ch7","D",08,0,0,"G","U_ValPgMem ('07')","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@D",""})
	aAdd(aRegs,{cPerg,"08","Data NFE Ate" 	   ,"","","mv_ch8","D",08,0,0,"G","U_ValPgMem ('08')","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@D",""})
	aAdd(aRegs,{cPerg,"09","Dt Aberb De"  	   ,"","","mv_ch9","D",08,0,0,"G","U_ValPgMem ('09')","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@D",""})
	aAdd(aRegs,{cPerg,"10","Dt Aberb Ate" 	   ,"","","mv_cha","D",08,0,0,"G","U_ValPgMem ('10')","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@D",""})

	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))

	For i:=1 to Len(aRegs)
		If !SX1->(dbSeek(cPerg+aRegs[i,2]))
			SX1->(RecLock("SX1",.T.))
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			SX1->(MsUnlock())
		Endif
	Next

	dbSelectArea(sAlias)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: U_ValPgMem ()
//|Descricao.: Valida datas informadas nas perguntas
//|Observação:
//+-----------------------------------------------------------------------------------//
User Function ValPgMem(cMV)

	Local cRet     := .T.
	Local cTitulo  := "Inconsistencia de Dados"

	Do Case

	Case cMV == '01'

		If Empty(MV_PAR01)
			Aviso( cTitulo, "Filial inicial deve ser informada", {"Ok"} )
			cRet:=.F.
		Endif

		If !Empty(MV_PAR02) .AND. MV_PAR01 > MV_PAR02
			Aviso( cTitulo, "Filial inicial não pode ser maior que o Final", {"Ok"} )
			cRet := .F.
		EndIf

	Case cMV == '02'

		If Empty(MV_PAR02)
			Aviso( cTitulo, "Filial final deve ser informada", {"Ok"} )
			cRet:=.F.
		Endif

		If !Empty(MV_PAR01) .AND. MV_PAR01 > MV_PAR02
			Aviso( cTitulo, "Filial final não pode ser menor que o Inicial", {"Ok"} )
			cRet := .F.
		EndIf

	Case cMV == '03'

		If !Empty(MV_PAR04) .AND. MV_PAR03 > MV_PAR03
			Aviso( cTitulo, "Nota final não pode ser menor que o Inicial", {"Ok"} )
			cRet := .F.
		EndIf

	Case cMV == '04'

		If Empty(MV_PAR04)
			Aviso( cTitulo, "Nota Final Nao pode Ficar em Branco", {"Ok"} )
			cRet:=.F.
		Endif

		If !Empty(MV_PAR04) .AND. MV_PAR03 > MV_PAR03
			Aviso( cTitulo, "Nota final não pode ser menor que o Inicial", {"Ok"} )
			cRet := .F.
		EndIf

	Case cMV == '05'

		If !Empty(MV_PAR06) .AND. MV_PAR05 > MV_PAR06
			Aviso( cTitulo, "Memorado final não pode ser menor que o Inicial", {"Ok"} )
			cRet := .F.
		EndIf

	Case cMV == '06'

		If Empty(MV_PAR06)
			Aviso( cTitulo, "Memorando Final Nao pode Ficar em Branco", {"Ok"} )
			cRet:=.F.
		Endif

		If !Empty(MV_PAR06) .AND. MV_PAR05 > MV_PAR06
			Aviso( cTitulo, "Memorando final não pode ser menor que o Inicial", {"Ok"} )
			cRet := .F.
		EndIf

	End Case

Return(cRet)

	//+-----------------------------------------------------------------------------------//
	//|Funcao....: ChoseMapDir()
	//|Descricao.: Localiza diretório de gravação
	//|Observação:
	//+-----------------------------------------------------------------------------------//
Static Function ChoseMapDir()

	Local cTitle:= "Geração de arquivo"
	Local cMask := "Formato *|*.*"
	Local cFile := ""
	Local nDefaultMask := 0
	Local cDefaultDir  := "C:\"
	Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

	cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)

	//+-----------------------------------------------------------------------------------//
	//|Funcao....: ValiRel()
	//|Descricao.: Valida informações de gravação
	//|Observação:
	//+-----------------------------------------------------------------------------------//

Static Function ValiRel(cValida)

	Local lCancela

	If cValida = "ok"
		If Empty(Alltrim(cArq))
			MsgInfo("O nome do arquivo deve ser informado","Atenção")
			lRetor := .F.
		ElseIf Empty(Alltrim(cDir))
			MsgInfo("O diretório deve ser informado","Atenção")
			lRetor := .F.
		ElseIf Len(Alltrim(cDir)) <= 3
			MsgInfo("Não se pode gravar o arquivo no diretório raiz, por favor, escolha um subdiretório.","Atenção")
			lRetor := .F.
		Else
			oDlg:End()
			lRetor := .T.
		EndIf
	Else
		lCancela := MsgYesNo("Deseja cancelar a geração da View de Importação?","Atenção")
		If lCancela
			oDlg:End()
			lRetor := .T.
			lSair  := .T.
		Else
			lRetor := .F.
		EndIf
	EndIf

Return(lRetor)

	//+-----------------------------------------------------------------------------------//
	//|Funcao....: RelMemCSV()
	//|Descricao.: Gera Arquivo CSV
	//|Observação:
	//+-----------------------------------------------------------------------------------//
Static Function RelMemCSV()

	cArqTxt := Alltrim(cDir)+Alltrim(cArq)+".csv"
	nHdl    := fCreate(cArqTxt)

	cEOL    := "CHR(13)+CHR(10)"
	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif

	Processa({|| RunCont() },"Processando...")

	fClose(nHdl)

Return

	//+-----------------------------------------------------------------------------------//
	//|Funcao....: RunCont()
	//|Descricao.: Chama função para gerar CSV
	//|Observação:
	//+-----------------------------------------------------------------------------------//
Static Function RunCont()

	Local nTamLin, cLin, cCpo, nInd
	Local nFlag := 0, nTotReais:=0
	Local nTotUSD:=0, nTotYEN:=0, nTotEUR:=0
	Local nTXUSD :=0, nTxYEN :=0, nTxEUR :=0

	cCamposCSV :="País / Porto Destino;Proc EEC;Contract NBR;Nome Usina;CNPJ Usina;"
	cCamposCSV +="NF Export;Ser NF Export;Nr Memo;Dta Memo;"
	cCamposCSV +="Export Register (RE);Dt Averb ;Data da DSE;Nro. DUE;Nro. RUC;Chave da NFE;Nr NF Usina;Serie NF Usina;Dta NF Ent;"
	cCamposCSV +="QTD NF Ent (BAG/TON);QTD Memorando;Saldo NF Usina;"
	cCamposCSV +="Nome Filial;Status;Filia Protheus"

	cMsg := "Relatorio gerado com sucesso!"+CHR(13)+CHR(10)
	cMsg += "O arquivo "+Alltrim(cArq)+".csv"+" se encontra no diretório "+Alltrim(cDir)

	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL

	DbSelectArea("TRB2")
	ProcRegua(RecCount("TRB2"))

	TRB2->(dbgotop())


	cTitRel:=";;;;;;;;;;;;;DATE;"+DTOC(dDataBase)+cEOL
	fWrite(nHdl,cTitRel,Len(cTitRel))
	fWrite(nHdl,cLin,Len(cLin))
	fWrite(nHdl,cLin,Len(cLin))

	cTitRel:=";;;;;"+cRel+" - Filial De: "+MV_PAR01+" Até "+ MV_PAR02 + " - NF Ent De: "+MV_PAR03+" Até "+ MV_PAR04+cEOL
	fWrite(nHdl,cTitRel,Len(cTitRel))
	fWrite(nHdl,cLin,Len(cLin))
	fWrite(nHdl,cLin,Len(cLin))

	cLin := Stuff(cLin,01,02,cCamposCSV)
	fWrite(nHdl,cLin,Len(cLin))

	TRB2->(DBGOTOP())
	While ! TRB2->(EOF())

		IncProc("Gerando arquivo CSV")

		nTamLin := 2
		cLin    := Space(nTamLin)+cEOL
		cDadosCSV := ""

		For nInd := 1 To TRB2->(fCount())
			cCpoDest := TRB2->(FieldName(nInd))
			If TRB2->(FieldPos(cCpoDest)) > 0

				cValor:=TRB2->(FieldGet(FieldPos(cCpoDest)))
				If cCpoDest $ "DTMEM,DTENT,DTAVERB,DTDSE"
					cValor:= DtoC(TRB2->(&cCpoDest))
				Endif

				If ValType(TRB2->(&cCpoDest)) == "N"
					If cCpoDest $ "QTDNFENT,QTDMEM,SALNFENT"
						cPict:= "@E 99,999,999.999"
					EndIf
					cDadosCSV += TRANSFORM(cValor,cPict)+Iif(nInd = TRB2->(fCount()),"",";")
				Else
					If cCpoDest $ "NRDI"
						cPict:= AvSx3("W6_DI_NUM",6)
						cValor:=TRANS(cValor,cPict)
					Endif
					cDadosCSV+= cValor+Iif(nInd = TRB2->(fCount()),"",";")
				EndIf

			EndIf

		Next

		cLin := Stuff(cLin,01,02,cDadosCSV)
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo nos Itens. Continua?","Atencao!")
				lTudOk := .F.
				Exit
			Endif
		Endif

		TRB2->(dbSkip())

	EndDo

Return
