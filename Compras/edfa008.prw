
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA008     ºAutor  ³Yttalo P. Martins  º Data ³  31/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para estorno de transferências                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EDFA008(xnRecno)

Local cSaveMenuh,nOpca := 0,lDigita,lAglutina,aCusto := {}
Local GetList:={}
Local cQtdPict,cQtd2Pict,nRecOrig,nRecDest,nCusOrig,cNumSeq
Local dDataFec := If(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES")), oDlg
Local cLocCQ := GetMv('MV_CQ')
Local o01MsGet,o02MsGet,o03MsGet,o04MsGet,o05MsGet,o06MsGet,o07MsGet,o08MsGet
Local o09MsGet,o10MsGet,o11MsGet,o12MsGet,o13MsGet,o14MsGet,o15MsGet,o16MsGet,o17MsGet
Local aButton := {}
Local lButLotDst := .T.
Local lCAT83	 := .F.
Local cLoteDigiD := ""
Local cServico   := ""
Local aTela   := {}
Local aGet    := {}
Local aSay    := {}
Local lRet 	:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a variavel que identifica se o calculo do custo e' :    ³
//³               O = On-Line                                    ³
//³               M = Mensal                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCusMed := GetMv("MV_CUSMED")
PRIVATE cCadastro:= OemToAnsi("Transfer^ncias")     //"Transfer^ncias"
PRIVATE aRegSD3 := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o custo medio e' calculado On-Line               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCusMed == "O"
     PRIVATE nHdlPrv // Endereco do arquivo de contra prova dos lanctos cont.
     PRIVATE lCriaHeader := .T. // Para criar o header do arquivo Contra Prova
     PRIVATE cLoteEst      // Numero do lote para lancamentos do estoque
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Posiciona numero do Lote para Lancamentos do Faturamento     ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     dbSelectArea("SX5")
     dbSeek(xFilial()+"09EST")
     cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
     PRIVATE nTotal := 0      // Total dos lancamentos contabeis
     PRIVATE cArquivo     // Nome do arquivo contra prova
EndIf

aVetTransf := {}

dbSelectArea("SD3")

IF ALLTRIM(FUNNAME()) $ "MATA103#MATA140"
	dbGoto((cAliasSD3)->R_E_C_N_O_)
ELSE
	dbGoto(xnRecno)
ENDIF

If Empty(SD3->D3_ESTORNO)
	
	If !A260ChkCF(D3_COD, D3_LOCAL, D3_NUMSEQ, D3_CF, cLocCQ)
		Help(" ",1,"A260NAO")
		SetCursor(0)
		Return (.F.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificar data do ultimo fechamento em SX6.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If dDataFec >= dDataBase .Or. dDataFec >= D3_EMISSAO
		Help ( " ", 1, "FECHTO" )
		SetCursor(0)
		Return (.F.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ AvalMovDiv - Funcao utilizada para avaliar possiveis divergencias de     |
	//|              saldo no estorno do movimento selecionado.                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FindFunction("AvalMovDiv") .And. AvalMovDiv(SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_LOTECTL,SD3->D3_NUMLOTE,SD3->D3_NUMSEQ)
		Return(.F.)
	EndIf
	
	PRIVATE cCodOrig,cCodDest,cUmOrig,cUmDest,cLocOrig,cLocDest,cCAT83O,cCAT83D,nQuant260,;
			nQuant260D,cDocto,dEmis260,cLoteDigi,dDtValid,dDtVldDest,cLoclzOrig,cLoclzDest,;
			cNumLote,cNumSerie,nPotencia
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve ordem original do SX3                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSetOrder(1)
	
	dbSelectArea("SD3")
	SD3->(dbSetOrder(4))
	cNumSeq := SD3->D3_NUMSEQ
	SD3->(dbSeek(xFilial("SD3")+cNumSeq))
	nRecOrig   := RecNo()
	cCodOrig   := D3_COD
	cUmOrig    := D3_UM
	cLocOrig   := D3_LOCAL
	cLoclzOrig := D3_LOCALIZ
	cNumLote   := D3_NUMLOTE
	cNumSerie  := D3_NUMSERI
	cLoteDigi  := D3_LOTECTL
	dDtValid   := D3_DTVALID
	nPotencia  := D3_POTENCI
	cDocto     := D3_DOC
	dEmis260   := D3_EMISSAO
	cCAT83O    := IIF(lCAT83,SD3->D3_CODLAN,"")
	
	SD3->(dbSkip())
	If cNumSeq == D3_NUMSEQ
		nRecDest   := RecNo()
		cCodDest   := D3_COD
		cUmDest    := D3_UM
		cLocDest   := D3_LOCAL
		dDtVldDest := D3_DTVALID
		cLoclzDest := D3_LOCALIZ
		nQuant260  := D3_QUANT
		nQuant260D := D3_QTSEGUM
		cLoteDigiD := D3_LOTECTL
		cServico   := D3_SERVIC
		cCAT83D    := IIF(lCAT83,SD3->D3_CODLAN,"")
	Else
		Aviso("Movimento nao pode ser estornado","Nao Estornar",{"Ok"})	// "Movimento nao pode ser estornado" # "Nao Estornar"
		Return(.F.)
	EndIf
	dbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o produto origem ou o produto destino   ³
	//³ estao sendo inventariados.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If BlqInvent(cCodOrig,cLocOrig,,cLoclzOrig)
		Help(" ",1,"BLQINVENT",,cCodOrig+" Almox: "+cLocOrig,1,11)
		Return(.F.)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Analisa se o tipo do armazem permite a movimentacao |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FindFunction('AvalBlqLoc') .And. AvalBlqLoc(cCodOrig,cLocOrig,Nil,,cCodDest,cLocDest)
		Return(.F.)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o produto origem ou o produto destino   ³
	//³ estao sendo inventariados.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If BlqInvent(cCodDest,cLocDest,,cLoclzDest)
		Help(" ",1,"BLQINVENT",,cCodDest+" Almox: "+cLocDest,1,11)
		Return(.F.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o produto destino tem saldo p/ estornar ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MatVldEst(cCodDest,;
			cLocDest,;
			SD3->D3_LOTECTL,;
			SD3->D3_NUMLOTE,;
			If(Empty(cServico),SD3->D3_LOCALIZ,""),;
			SD3->D3_NUMSERI,;
			cNumSeq,;
			cDocto,;
			nQuant260)
		Return(.F.)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o produto destino esta com saldo bloqueado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !SldBlqSB2(cCodDest,cLocDest)
		Return(.F.)
	EndIf
	
	a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,.T.,nRecOrig,nRecDest,"MATA260",Nil,cServico,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,nPotencia,Nil,Nil,cCAT83O,cCAT83D)							
	
EndIf


Return(lRet)