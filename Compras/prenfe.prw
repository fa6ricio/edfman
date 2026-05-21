///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | ADRIANO      | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_MarkBrw()                                            |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                   | DESCRICAO                              |//
//+-----------------------------------------------------------------------------+//
//| Alteracao| Luis Felipe Nascimento  |                      DATA    07/05/14  |//
//|          | -----------------------------------------------------------------|//
//|          | RDM - 004 - Payments by DP - Sele็ใo do armazem.                 |//
//+-----------------------------------------------------------------------------+//
//| Alteracao| Luis Felipe Nascimento  |                      DATA    07/01/15  |//
//|          | -----------------------------------------------------------------|//
//|          | RDM - Desfeita altera็ใo, tornando a ser como antes.             |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

/*
+----------------------------------------------------------------------------
| Parโmetros do MarkBrow()
+----------------------------------------------------------------------------
| MarkBrow( cAlias, cCampo, cCpo, aCampos, lInverte, cMarca, cCtrlM, uPar,
|            cExpIni, cExpFim, cAval )
+----------------------------------------------------------------------------
| cAlias...: Alias do arquivo a ser exibido no browse
| cCampo...: Campo do arquivo onde serแ feito o controle (grava็ใo) da marca
| cCpo.....: Campo onde serแ feita a valida็ใo para marca็ใo e exibi็ใo do bitmap de status
| aCampos..: Colunas a serem exibidas
| lInverte.: Inverte a marca็ใo
| cMarca...: String a ser gravada no campo especificado para marca็ใo
| cCtrlM...: Fun็ใo a ser executada caso deseje marcar todos elementos
| uPar.....: Parโmetro reservado
| cExpIni..: Fun็ใo que retorna o conte๚do inicial do filtro baseada na chave de ํndice selecionada
| cExpFim..: Fun็ใo que retorna o conte๚do final do filtro baseada na chave de ํndice selecionada
| cAval....: Fun็ใo a ser executada no duplo clique em um elemento no browse
+----------------------------------------------------------------------------
*/

#Include "TOTVS.CH"
    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRENFE      บAutor  ณAlexandre Santos  บ Data ณ  07/17/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Alterado para tratar fator de conversใo atraves da fun็ใo  บฑฑ
ฑฑบ          ณ  U_EDFFATOR(Par01)                                         บฑฑ
ฑฑบ          ณ  Par01 - C๓digo do produto                                 บฑฑ 
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบAltera็ใo ณ Alexandre Santos - 24/07/2013 - De Para da TES             บฑฑ
ฑฑบ          ณ De 005 Para 018                                            บฑฑ
ฑฑบ          ณ De 006 Para 006                                            บฑฑ
ฑฑบ          ณ De 008 Para 002                                            บฑฑ
ฑฑบ          ณ De 009 Para 017                                            บฑฑ  
ฑฑบ          ณ De 501 Para 504                                            บฑฑ
ฑฑบ          ณ De 506 Para 501                                            บฑฑ
ฑฑบ          ณ De 598 Para 507                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CLSPRENF()
//+----------------------------------------------------------------------------
//| Atribuicao de variaveis
//+----------------------------------------------------------------------------
Local aArea   := {}
Local nI 	  := 0
Local cFiltro := ""
Local cKey    := ""
Local cArq    := ""
Local nIndex  := 0
Local aSay    := {}
Local aButton := {}
Local nOpcao  := 0
Local cDesc1  := " Este programa tem como objetivo classificar pr้-notas."
Local cDesc2  := " "
Local cDesc3  := " "
Local aCpos   := {}
Local aCampos := {}

Private aRotina     := {}
Private cMarca      := ""
Private cCadastro   := OemToAnsi("Transfer๊ncias de Almoxarifado")
Private cPerg       := "MARK01"
Private nTotal      := 0
Private cArquivo    := ""

//+----------------------------------------------------------------------------
//| Monta tela de interacao com usuario
//+----------------------------------------------------------------------------
aAdd(aSay,cDesc1)
aAdd(aSay,cDesc2)
aAdd(aSay,cDesc3)

aAdd(aButton, { 1,.T.,{|| nOpcao := 1, FechaBatch() }})
aAdd(aButton, { 2,.T.,{|| FechaBatch()              }})

//FormBatch(<cTitulo>,<aMensagem>,<aBotoes>,<bValid>,nAltura,nLargura)
FormBatch(cCadastro,aSay,aButton)

//+----------------------------------------------------------------------------
//| Se cancelar sair
//+----------------------------------------------------------------------------
If nOpcao <> 1
	Return Nil
Endif

//+--------------------------------------------------------+
//| Parametros utilizado no programa                       |
//+--------------------------------------------------------+
//| mv_par01 - Data Emissao de    ? 99/99/99               |
//| mv_par02 - Data Emissao ate   ? 99/99/99               |
//| mv_par03 - Forncedor de       ? 999999                 |
//| mv_par04 - Fornecedor ate     ? 999999                 |
//| mv_par05 - Filtrar            ? Todos/Manuten็ใo       |
//+--------------------------------------------------------+
//+----------------------------------------------------------------------------
//| Cria as perguntas em SX1
//+----------------------------------------------------------------------------
//CriaSX1()

//+----------------------------------------------------------------------------
//| Monta tela de paramentos para usuario, se cancelar sair
//+----------------------------------------------------------------------------
//If !Pergunte(cPerg,.T.)
//   Return Nil
//Endif

//+----------------------------------------------------------------------------
//| Atribui as variaveis de funcionalidades
//+----------------------------------------------------------------------------
aAdd( aRotina ,{"Pesquisar"   ,"AxPesqui()"    ,0,1})
aADD (aRotina, {"Logํstica"   ,"u_logistic()"  ,0,4})
aAdd( aRotina ,{"Classificar" ,"u_ClassNFE()"  ,0,3})
aAdd( aRotina ,{"Legenda"     ,"u_Legenda()"   ,0,4})
aadd( aRotina ,{"Limpa Dados" ,"u_limpaclass()",0,3})
//aadd( aRotina ,{"Altera็ใo"   ,"u_limpa_nf()" ,0,4})

//+----------------------------------------------------------------------------
//| Atribui as variaveis os campos que aparecerao no mBrowse()
//+----------------------------------------------------------------------------
	aCpos := {"F1_OK","F1_DOC","F1_SERIE","F1_XNOMFOR","F1_EMISSAO","F1_DTCHEGA","F1_NFMAE","F1_VALBRUT"}

	//dbSelectArea("SX3")
	//dbSetOrder(2)
	For nI := 1 To Len(aCpos)
		cTitulo := FWX3Titulo(aCpos[nI])
		cCampo  := FWSX3Util():GetDescription( aCpos[nI] )
		aAdd(aCampos,{cCampo,"",Iif(nI==1,"",Trim(cTitulo)),""})
	Next
//+----------------------------------------------------------------------------
//| Monta o filtro especifico para MarkBrow()
//+----------------------------------------------------------------------------
dbSelectArea("SF1")
aArea := GetArea()
cKey  := IndexKey()


	cFiltro="F1_FILIAL = '"+xFilial("SF1")+"' .AND. F1_STATUS=' ' " //.AND. F1_DOC = '000113430'"

	cArq := CriaTrab( Nil, .F. )
	IndRegua("SF1",cArq,cKey,,cFiltro)
	nIndex := RetIndex("SF1")
	nIndex := nIndex + 1
	dbSelectArea("SF1")

	dbSetOrder(9) 	// 8 p/ 9 	// 10/05/13 - Luis Felipe Nascimento
dbGoTop()

//+----------------------------------------------------------------------------
//| Apresenta o MarkBrowse para o usuario
//+----------------------------------------------------------------------------
//cMarca := GetMark()
//MarkBrow("SF1","F1_OK","F1_REMITO",aCampos,,cMarca,,,,,"u_MarcaBox()")

//+----------------------------------------------------------------------------
//| Desfaz o indice e filtro temporario
//+----------------------------------------------------------------------------
dbSelectArea("SF1")
RetIndex("SF1")
Set Filter To
cArq += OrdBagExt()
oMark := FWMarkBrowse():New()
	oMark:SetAlias('SF1')
	cMarca := oMark:Mark()
	//Setando semแforo, descri็ใo e campo de mark
	oMark:SetSemaphore(.T.)
	oMark:SetDescription(cCadastro)
	oMark:SetFieldMark( 'F1_OK' )
	oMark:SetFilterDefault(cFiltro)
	oMark:AddLegend( "empty(F1_XPEDIDO)", "BR_VERDE", "NF Nใo Transferida" )
	oMark:AddLegend( "!empty(F1_XPEDIDO)", "BR_VERMELHO", "NF Transferida" )

	oMark:Activate()
FErase( cArq )
RestArea( aArea )
Return Nil

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+	//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Adriano      | DATA | 18/01/2011 |	//
//+-----------------------------------------------------------------------------+	//
//| DESCRICAO | Funcao - u_Legenda()                                            |	//
//+-----------------------------------------------------------------------------+	//
///////////////////////////////////////////////////////////////////////////////////
User Function Legenda()
Local aCor := {}

aAdd(aCor,{"BR_VERDE"   ,"NF Nใo Transferida"})
aAdd(aCor,{"BR_VERMELHO","NF Transferida"    })

BrwLegenda(cCadastro,OemToAnsi("Registros"),aCor)

Return


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+	//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Adriano      | DATA | 18/01/2011 |	//
//+-----------------------------------------------------------------------------+	//
//| DESCRICAO | Funcao - CriaSX1()                                              |	//
//+-----------------------------------------------------------------------------+	//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1()
Local nY := 0
Local j  := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Emissao de ?        ","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"02","Emissao ate ?       ","mv_ch2","D", 8,0,0,"G","(mv_par02>=mv_par01)","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"03","Codigo de ?         ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"04","Codigo ate ?        ","mv_ch4","C", 6,0,0,"G","(mv_par04>=mv_par03)","mv_par04","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"05","Mostrar Todos ?     ","mv_ch5","N", 1,0,0,"C","","mv_par05","Sim","","","Nao","","","","","","","","","","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)
For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny
RestArea(aAreaSX1)
RestArea(aAreaAnt)
Return Nil




User Function ClassNFE()
Local oVar1, oVar2, oVar3, oVar4, oVar5, oVar6, oBtnOk, oBtnCancel
Local cTrb 	:= getnextalias()
Private oDlg, cCondic, cNatur, cNavio, cTes, cNFMAE, cContra, cContrato, nPedido, dDTvencto, nTXUSD, nqtdton, xNUMTIT, nVLFINAL, cARMAZEM
cMarca := oMark:Mark()
xNUMTIT  := "         "

cCondicao:= "   "
cCondic  := "   "

cNatureza:= "101005"
cNatur   := "101005"

cNavio   := "               "
cReferen := ""
cContrato:= ""
cTes     := "002" // Alexandre Santos - 24/07/2013 - De Para da TES 008 p/ 002
cNFMAE   := SPACE( TAMSX3("F1_DOC")[1] )//SF1->F1_DOC // 06/08/13 - Luํs Felipe Nascimento
cContra  := Space(TamSx3("F1_CONTRA")[1]) 

cPedido  := Space(TamSx3("F1_XPEDIDO")[1]) 

dDTvencto:= CtoD(Space(08))

nTxusd   := 0
nqtdton  := 0

cARMAZEM := Space(02) // "01"

	BEGINSQL ALIAS cTrb
		SELECT SUM(D1_QUANT) AS QTD
		  FROM %TABLE:SF1% A, %TABLE:SD1% B
		 WHERE A.F1_FILIAL = %EXP:FWXFILIAL("SF1")%
		   AND B.D1_FILIAL = %EXP:FWXFILIAL("SD1")%
		   AND A.%NOTDEL%
		   AND B.%NOTDEL%
		   AND A.F1_DOC = B.D1_DOC
		   AND A.F1_SERIE = B.D1_SERIE
		   AND A.F1_FORNECE = B.D1_FORNECE
		   AND A.F1_LOJA = B.D1_LOJA
		   AND A.F1_OK = %EXP:cMarca%
		   AND A.F1_STATUS = ''
	ENDSQL
	DBSELECTAREA(cTrb)
	IF (cTrb)->(!EOF())
		nqtdton := (cTrb)->QTD
	ENDIF
	(cTrb)->(DBCLOSEAREA())

Define MSDialog oDlg Title OemToAnsi("Dados adicionais:") From 0,0 To 420,540 Pixel

@015,20 Say "Pedido: " Pixel Of oDlg
@015,90 MSGet oVar6  Var cPEDIDO  size 036,10 Picture "@!" Size 38,10 F3 "SC7" VALID U_VER_PEDIDO(cPEDIDO) Pixel  Of oDlg

@030,20 Say "Contrato:" Pixel Of oDlg
@030,90 MSGet oVar1  Var cContra Picture "@!" size 100,10  F3 "CN9" VALID NAOVAZIO() OF oDlg PIXEL

@045,20 Say "Condi็ใo de Pagto:"  Pixel Of oDlg
@045,90 MSGet oVar2  Var cCondic size 050,10 Picture "@!" Size 052,10 F3 "SE4" OF oDlg PIXEL

@060,20 Say "Natureza Financeira:"  Pixel Of oDlg
@060,90 MSGet oVar4  Var cNatur size 065,10 Picture "@!" Size 075,10 F3 "SED" VALID NAOVAZIO() OF oDlg PIXEL

@075,20 Say "Nota Fiscal Mใe:"  Pixel Of oDlg
@075,90 MSGet oVar5  Var cNFMAE  size 008,10 Picture "@!" Size 010,10 Pixel  Of oDlg

@090,20 Say "TES:"  Pixel Of oDlg
@090,90 MSGet oVar3  Var cTES  size 050,10 Picture "@!" Size 052,10 F3 "SF4" VALID NAOVAZIO() OF oDlg PIXEL

@105,20 Say "Navio:"  Pixel Of oDlg
@105,90 MSGet oVar6  Var cNAVIO     size 036,10 Picture "@!" Size 38,10 Pixel  Of oDlg

@135,20 Say "Quantidade de sacas: "+transform(nqtdton,"@E 999,999,999.99") Pixel Of oDlg

@150,20 SAY "Armaz้m:" SIZE 60,8 OF oDlg PIXEL
@150,90 MSGET oGet VAR cArmazem  PICTURE "@!" SIZE 80,9 VALID NAOVAZIO() OF oDlg PIXEL

@180,20 Button oBtnOk     Prompt "&Grava"         Size 30,15 Pixel Action (U_TRANSFERE(), oDlg:End()) Of oDlg
@180,90 Button oBtnCancel Prompt "C&ancela"       Size 30,15 Pixel Action ( oDlg:End(),lContinua := .F.) Cancel Of oDlg

Activate MSDialog oDlg Centered 

Return .T.

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+	//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | ADRIANO      | DATA | 18/01/2011 |	//
//+-----------------------------------------------------------------------------+	//
//| DESCRICAO | Funcao - u_Transfere()                                          |	//
//+-----------------------------------------------------------------------------+	//
///////////////////////////////////////////////////////////////////////////////////
User Function Transfere()
//Local cMsg   := "Nota fiscal marcada:"+Chr(10)+Chr(13)+"Pre/N๚mero"+Chr(10)+Chr(13)
Local aNotas := {}
Local cTrb 	:= getnextalias()
Private aNF  := {}

IF ! EMPTY(cPEDIDO) // PESQUISAR NA SC7, VER SE ESTA EM ABERTO E SE EXISTE REALMENTE
	DBSELECTAREA("SC7")
	DBSETORDER(1)
	DBSEEK(xFILIAL("SC7")+cPEDIDO)
	//IF SC7->(EOF())
	//   MSGALERT("PEDIDO NรO EXISTE")
	//   RETURN NIL
	//ENDIF
	IF !SC7->(EOF()) .AND. SC7->C7_ENCER=="S"
		MSGALERT("PEDIDO ENCERRADO, NรO DEVE RECEBER MAIS N.F.")
		RETURN NIL
	ENDIF
ENDIF

nVLFINAL:= SC7->C7_VLFINAL
cNAVIO  := SC7->C7_NAVIO
//cArmazem:= SC7->C7_LOCAL

//+----------------------------------------------------------------------------
//| Guarda os dados chave de todas as nota fiscais marcadas
//+----------------------------------------------------------------------------

	BEGINSQL ALIAS cTrb
		SELECT  F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA 
		  FROM %TABLE:SF1% A
		 WHERE A.F1_FILIAL = %EXP:FWXFILIAL("SF1")%
		   AND A.%NOTDEL%
		   AND A.F1_OK = %EXP:cMarca%
		   AND A.F1_STATUS = ''
	ENDSQL
	DBSELECTAREA(cTrb)
	while (cTrb)->(!EOF())
		aAdd( aNotas, (cTrb)->F1_SERIE+"/"+(cTrb)->F1_DOC )
		aAdd( aNF, (cTrb)->F1_DOC+(cTrb)->F1_SERIE+(cTrb)->F1_FORNECE+(cTrb)->F1_LOJA)
		(cTrb)->(dbskip())
	END
	(cTrb)->(DBCLOSEAREA())

//+----------------------------------------------------------------------------
//| Solicita a confirmacao das notas fiscais
//+----------------------------------------------------------------------------
If Len(aNotas)>0
	//If MsgYesNo(cMsg,"Confirma็ใo")
	Ok_Transfere( aNF )
	//Endif
Endif
Return


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+	//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Adriano      | DATA | 18/01/2011 |	//
//+-----------------------------------------------------------------------------+	//
//| DESCRICAO | Funcao - Ok_Transfere()                                         |	//
//+-----------------------------------------------------------------------------+	//
///////////////////////////////////////////////////////////////////////////////////
Static Function Ok_Transfere( aNF )
Local aNFs     := {}
Local nI      := 0
Local cFilSD1 := xFilial("SD1")
Local nQtdton := 0
Local xQtd    := 0      
Local nFator := 1 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirar o valor pre-fixado 

aNFs := aClone( aNF )

// Busca item a item para o devido tratamento de transferencia
//dbSelectArea("SD1")
//dbSetOrder(1)        
BEGIN TRANSACTION

For nI := 1 To Len( aNFs )
	aItem	:= {}
	xQtd	:= 0

	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(cFilSD1+aNFs[nI])

	While !Eof() .And. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == cFilSD1+aNFs[nI]
		aCab   := {}
		cNatureza:=cNatur
		cCondicao:=cCondic
		
		Dbselectarea("SF1")
		DBSETORDER(1)   
		IF !DBSEEK(cFilSD1+aNFs[nI])
			ALERT("NรO ENCONTROU N.F.")
		ELSE
			RecLock("SF1",.F.)
			SF1->F1_NFMAE    := cNFMAE   // 19/03/15 - Luis Felipe Nascimento - Esta sendo preenchido na importa็ใo da NF Mae 
			SF1->F1_CONTRA   := cCONTRA
			SF1->F1_NAVIO    := cNAVIO
			SF1->F1_XPEDIDO  := cPEDIDO
			msunlock()
		ENDIF
		
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek( xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA ) )

		SB1->( dbSetOrder(1) )
		SB1->( dbSeek( xFilial("SB1")+SD1->D1_COD ) )

		SF4->( dbSetOrder(1) )
		SF4->( dbSeek( xFilial("SF4")+cTes ) )
		
		xNF      := SF1->F1_DOC
		xSR      := SF1->F1_SERIE
		xFORNECE := SF1->F1_FORNECE
		xLOJA    := SF1->F1_LOJA
		xTIPO    := SF1->F1_TIPO
		aCab := {{"F1_TIPO"   , 'N'   ,NIL},;
		{"F1_FORMUL" , 'N'              ,NIL},;
		{"F1_DOC"    , SF1->F1_DOC      ,NIL},;
		{"F1_SERIE"  , SF1->F1_SERIE    ,NIL},;
		{"F1_EMISSAO", SF1->F1_EMISSAO  ,NIL},;
		{"F1_FORNECE", SF1->F1_FORNECE  ,NIL},;
		{"F1_LOJA"   , SF1->F1_LOJA     ,NIL},;
		{"F1_ESPECIE", 'NFE'            ,NIL},;
		{"F1_BASEICM", 0                ,NIL},;
		{"F1_VALICM" , 0                ,NIL},;
		{"F1_VALIPI" , 0                ,NIL},;
		{"F1_ICMSRET", 0                ,NIL},;
		{"F1_VALBRUT", 0                ,NIL},;
		{"F1_ORIGEM" , "LEXML"          ,NIL},;
		{"F1_CONTRA" , cContra          ,NIL},;
		{"F1_NAVIO"  , cNavio           ,NIL},;
		{"F1_NFMAE"  , cNFMAE           ,NIL},;
		{"F1_COND"   , cCondicao        ,NIL},;
		{"E2_NATUREZ",PadR(cNatureza,TamSx3("ED_CODIGO")[1])   ,Nil}}

		DBSELECTAREA("SD1")
		xQtd+=SD1->D1_QUANT
		xDTCHEGA := SD1->D1_DTCHEGA
		xFALTAS  := SD1->D1_FALTAS
		xAVARIAS := SD1->D1_AVARIAS
		xSOBRAS  := SD1->D1_SOBRAS
		
		AAdd(aItem,{{"D1_ITEM"   ,SD1->D1_ITEM            ,Nil},;
		{"D1_COD"    ,SD1->D1_COD ,Nil},;
		{"D1_UM"     ,SD1->D1_UM              ,Nil},;
		{"D1_QUANT"  ,SD1->D1_QUANT           ,Nil},;
		{"D1_VUNIT"  ,SD1->D1_VUNIT 			,Nil},;
		{"D1_TOTAL"  ,SD1->D1_TOTAL           ,Nil},;
		{"D1_LOCAL"  ,cARMAZEM                ,Nil},;
		{"D1_TES"    ,cTes                    ,Nil},;
		{"D1_CLVL", SUBSTR(TRIM(cNavio),1,9)  ,Nil},;
		{"D1_IPI"    ,0                       ,Nil},;
		{"D1_VALIPI" ,0                       ,Nil},;
		{"D1_PICM"   ,0                       ,Nil},;
		{"D1_VALICM" ,0   					,Nil},;
		{"D1_BASEICM" ,0   					,Nil},;
		{"D1_BASEIPI" ,0   					,Nil},;
		{"D1_RATEIO" ,"2"                     ,Nil},;
		{"D1_BRICMS" ,0                       ,Nil},;
		{"D1_ICMSRET",0                       ,Nil}})
		
		// retirado o comentario e colocar abaixo do fonte
		DBSELECTAREA("SD1")
		dbSkip()
	End
	
	//iniciando classifica็ใo
	lMSErroAuto := .F.
	DBSELECTAREA("SF1")
	dbSetOrder(1)
	
	MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,aItem,4)
	
	If lMSErroAuto
		lRet     := .F.
		MostraErro()	//"Falha na atualizacao do pedido"
	Else
		
		// Se nใo tiver erro atualiza os pedidos de compras, verificando se ้ nota mใe ou filha.
		
//		IF !EMPTY(cNFMAE) //.AND. cNFMAE<>SF1->F1_DOC // 18/03/15 - Luํs Felipe Nascimento 
		IF !EMPTY(cNFMAE) // verifica se ja gravou o n๚mero da n.f. mใe.
			// No caso abaixo ้ nota filha, portanto ้ preciso atualizar o pedido de compras com a qtd entregue.
			DBSELECTAREA("SC7")
			DBSETORDER(1)
			DBSEEK(xFILIAL("SC7")+cPEDIDO)
			IF !SC7->(EOF())              
			    
			   nFator := U_EDFFATOR(SC7->C7_PRODUTO) 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirnar o valor pre-fixado 
			
				RecLock("SC7",.F.) 
				   
				// Alexandre Santos - 17/07/2013 - Alteracao para retirnar o valor pre-fixado 				
				SC7->C7_QUJE+=(xQtd/nFator)
				//SC7->C7_QUJE+=(xQtd/20) // divide por 20 pq a quantidade da nf recebida estแ em SACAS. (20 SACAS=1 TONELADA)  
				// --------------------------------------------------------------------------
				
				nQtdton+=xQtd
				Msunlock()
			ENDIF
		ELSE
			// CLASSIFICAวรO DE NOTA MรE E ATUALIZAวรO DO PEDIDO DE COMPRA COM O NฺMERO DA NOTA FISCAL MรE.
			// cai nessa parte se for nota fiscal mใe, porque quando classifica n.f. mใe nใo preenche na tela a variแvel cNFMAE.
			IF EMPTY(cNFMAE) .OR. cNFMAE==SF1->F1_DOC 	// verifica se ja gravou o n๚mero da n.f. mใe.
			RecLock("SC7",.F.)
			SC7->C7_NFMAE   := xNF
			Msunlock()
			ENDIF
		ENDIF

	EndIf
Next nI 
END TRANSACTION
DBSELECTAREA("SF1")
Return

User Function VER_PEDIDO(cPEDIDO)
dbselectarea("SC7")
dbsetorder(1)
If dbseek(xFILIAL("SC7")+cPEDIDO)
	cCONTRA  :=SC7->C7_CONTRAT
	cARMAZEM :=SC7->C7_LOCAL
	cNAVIO   :=SC7->C7_NAVIO
	cNFMAE   :=IIF(!EMPTY(SC7->C7_NFMAE),SC7->C7_NFMAE,SPACE(09))
		if empty(cNFMAE)
			cTES:="002"  	// Alexandre Santos - 24/07/2013 - De Para da TES
			// cTES:="008"
		else
			cTES:="006"
		endif
		@030,20 Say "Contrato:"+cCONTRA  Pixel Of oDlg
ENDIF
Return cCONTRA

USER FUNCTION LOGISTIC()
//MSGALERT(SF1->F1_DOC)
Local oVar1, oVar2, oVar3, oVar4, oVar6, oBtnOk, oBtnCancel

Private oDlg, cCondic, cNatur, cNavio, cTes, cNFMAE, cContra, cContrato, nPedido, dDTvencto, nTXUSD, nqtdton, xNUMTIT, nVLFINAL, cARMAZEM,cDOCUM,xCODPRO

Private xSEEK, citem

xNUMTIT  := "         "

cCondicao:= "   "
cCondic  := "   "

cNatureza:= "101001"
cNatur   := "101001"

cNavio   := "               "
cReferen := ""
cContrato:= ""
cTes     := "018"    // Alexandre Santos - 24/07/2013 - De Para da TES 
// cTes     := "005"
cNFMAE   := SPACE(9)
cContra  := "               "

cPedido  := "      "

dDTvencto:= ctod(space(08))

nTxusd   := 0
nqtdton  := 0

xSEEK    := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA

xCODPRO  := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_COD")

dbselectarea("SB1")
DBSETORDER(1)
DBSEEK(xFILIAL("SB1")+xCODPRO)
IF SB1->(EOF())
	MSGALERT("PRODUTO NรO CADASTRADO!")
	RETURN NIL
ENDIF


xNOMPRO  := Posicione("SB1",1,xFilial("SB1")+xCODPRO,"B1_DESC")

xQTD     := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_QUANT")
xVLUNIT  := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_VUNIT")
xVLTOT   := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_TOTAL")

xFALTAS  := 0
xAVARIAS := 0
xSOBRAS  := 0
xDTCHEGA := CTOD(SPACE(08))

xDTCHEGA := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_DTCHEGA")
xFALTAS  := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_FALTAS")
xAVARIAS := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_AVARIAS")
xSOBRAS  := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_SOBRAS")
cnavio   := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_CLVL")


cArmazem := "  "
citem    := 0
dbselectarea("SD1")
dbsetorder(1)
dbseek(xFilial("SD1")+xSEEK)
IF ! SD1->(EOF())
	cArmazem := SD1->D1_LOCAL
	citem    := val(SD1->D1_ITEM)
ENDIF

if empty(xDTCHEGA)
	xDTCHEGA :=SF1->F1_EMISSAO
endif

cDOCUM := SF1->F1_DOC

Define MSDialog oDlg Title OemToAnsi("Logํstica:") From 0,0 To 550,540 Pixel

@015,20 Say "Nota Fiscal: "+SF1->F1_DOC           Pixel Of oDlg

@030,20 Say "Fornecedor : "+SF1->F1_XNOMFOR       Pixel Of oDlg

@045,20 Say "Dt.Emissใo N.F.: "+DTOC(SF1->F1_EMISSAO) Pixel Of oDlg

@060,20 Say "Produto    : "+xNOMPRO               Pixel Of oDlg

@075,20 Say "Quant.N.F. : "+Transform(xQTD,"@E 999,999,999.99") Pixel Of oDlg

@090,20 Say "Vl Unit. N.F. : "+Transform(xVLUNIT,"@E 999,999,999.99") Pixel Of oDlg

@105,20 Say "Vl Total N.F. : "+Transform(xVLTOT,"@E 999,999,999.99") Pixel Of oDlg

@120,20 Say "Item :" SIZE 60, 8 OF oDlg PIXEL
@120,90 MSGet oVar6  Var citem  size 036,10 Picture "99" Size 38,10 VALID U_VER_SD1() Pixel  Of oDlg

@135,20 SAY "Navio:" SIZE 60, 8 OF oDlg PIXEL
@135,90 MSGET oGet VAR cNavio  PICTURE "@!" SIZE 80,9 F3 "CTH" VALID cNavio<>'' OF oDlg PIXEL

@150,20 SAY "Armaz้m:" SIZE 60,8 OF oDlg PIXEL
@150,90 MSGET oGet VAR cArmazem  PICTURE "@!" SIZE 80,9 VALID NAOVAZIO() OF oDlg PIXEL

@165,20 Say "Data de Chegada: "  Pixel Of oDlg
@165,90 MSGet oVar1  Var xDTCHEGA size 008,10 Picture "@D"                Size 010,10 Pixel  Of oDlg

@180,20 Say "Faltas: "           Pixel Of oDlg
@180,90 MSGet oVar2  Var xFALTAS  Size 080,10 Picture "@E 999,999,999.99" Size 080,10 Pixel  Of oDlg

@195,20 Say "Avarias: "           Pixel Of oDlg
//    @150,90 MSGet xAVARIAS Picture "@E 999,999,999.99" Size 080,10 Pixel  Of oDlg
@195,90 MSGet oVar3  Var xAVARIAS Size 080,10 Picture "@E 999,999,999.99" Size 080,10 Pixel  Of oDlg

@210,20 Say "Sobras: "           Pixel Of oDlg
@210,90 MSGet oVar4  Var xSOBRAS Size 080,10 Picture "@E 999,999,999.99" Size 080,10 Pixel  Of oDlg

@225,20 Button oBtnOk     Prompt "&Grava"         Size 30,15 Pixel Action (U_Grava_log(), oDlg:End()) Of oDlg
@225,90 Button oBtnCancel Prompt "C&ancela"       Size 30,15 Pixel Action ( oDlg:End(),lContinua := .F.) Cancel Of oDlg

Activate MSDialog oDlg Centered

RETURN NIL

User Function Grava_log
// Adriano - Gravar Data de chegada na tabela SF1
dbselectarea("SF1")
dbsetorder(1)
dbseek(xFilial("SF1")+xSEEK)
IF ! SF1->(EOF())
	RecLock("SF1",.F.)
	SF1->F1_DTCHEGA := xDTCHEGA
	//SF1->F1_NAVIO   := cNAVIO
	Msunlock()
ENDIF

// Adriano - Gravar data de chegade, faltas e avarias na tabela SD1
dbselectarea("SD1")
dbsetorder(1)
dbseek(xFilial("SD1")+xSEEK+xCODPRO+strzero(citem,4))
IF ! SD1->(EOF())
	RecLock("SD1",.F.)
	SD1->D1_DTCHEGA := xDTCHEGA
	SD1->D1_FALTAS  := xFALTAS
	SD1->D1_AVARIAS := xAVARIAS
	SD1->D1_SOBRAS  := xSOBRAS
	SD1->D1_CLVL    := cNAVIO
	SD1->D1_LOCAL   := cARMAZEM
	Msunlock()
ENDIF

dbselectarea("SF1")
//dbsetorder(8)
//dbgotop()
Return Nil


USER FUNCTION LIMPA_NF
//MSGALERT(SF1->F1_DOC)
Local oVar1, oVar2, oVar3, oVar4, oBtnOk, oBtnCancel

Private oDlg, cCondic, cNatur, cNavio, cTes, cNFMAE, cContra, cContrato, nPedido, dDTvencto, nTXUSD, nqtdton, xNUMTIT, nVLFINAL

Private xSEEK

xNUMTIT  := "         "

cCondicao:= "   "
cCondic  := "   "

cNatureza:= "101001"
cNatur   := "101001"

cNavio   := "               "
cReferen := ""
cContrato:= ""
cTes     := "018"      // Alexandre Santos - 24/07/2013 - De Para da TES
// cTes     := "005"
cNFMAE   := SPACE(9)
cContra  := "               "

cPedido  := "      "

dDTvencto:= ctod(space(08))

nTxusd   := 0
nqtdton  := 0

xSEEK    := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
xCODPRO  := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_COD")

dbselectarea("SB1")
DBSETORDER(1)
DBSEEK(xFILIAL("SB1")+xCODPRO)
IF SB1->(EOF())
	MSGALERT("PRODUTO NรO CADASTRADO!")
	RETURN NIL
ENDIF


xNOMPRO  := Posicione("SB1",1,xFilial("SB1")+xCODPRO,"B1_DESC")

xQTD     := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_QUANT")
xVLUNIT  := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_VUNIT")
xVLTOT   := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_TOTAL")

xFALTAS  := 0
xAVARIAS := 0
xSOBRAS  := 0
xDTCHEGA := CTOD(SPACE(08))

xDTCHEGA := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_DTCHEGA")
xFALTAS  := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_FALTAS")
xAVARIAS := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_AVARIAS")
xSOBRAS  := Posicione("SD1",1,xFilial("SD1")+xSEEK,  "D1_SOBRAS")


if empty(xDTCHEGA)
	DBSELECTAREA("SF1")
	xDTCHEGA :=SF1->F1_EMISSAO
endif

Define MSDialog oDlg Title OemToAnsi("Logํstica:") From 0,0 To 420,540 Pixel

@015,20 Say "Nota Fiscal: "+SF1->F1_DOC           Pixel Of oDlg

@030,20 Say "Fornecedor : "+SF1->F1_XNOMFOR       Pixel Of oDlg

@045,20 Say "Dt.Emissใo N.F.: "+DTOC(SF1->F1_EMISSAO) Pixel Of oDlg

@060,20 Say "Produto    : "+xNOMPRO               Pixel Of oDlg

@075,20 Say "Quant.N.F. : "+Transform(xQTD,"@E 999,999,999.99") Pixel Of oDlg

@090,20 Say "Vl Unit. N.F. : "+Transform(xVLUNIT,"@E 999,999,999.99") Pixel Of oDlg

@105,20 Say "Vl Total N.F. : "+Transform(xVLTOT,"@E 999,999,999.99") Pixel Of oDlg

@120,20 Say "Data de Chegada: "  Pixel Of oDlg
@120,90 MSGet oVar1  Var xDTCHEGA size 008,10 Picture "@D"                Size 010,10 Pixel  Of oDlg

@135,20 Say "Faltas: "           Pixel Of oDlg
@135,90 MSGet oVar2  Var xFALTAS  Size 080,10 Picture "@E 999,999,999.99" Size 080,10 Pixel  Of oDlg

@150,20 Say "Avarias: "           Pixel Of oDlg
//    @150,90 MSGet xAVARIAS Picture "@E 999,999,999.99" Size 080,10 Pixel  Of oDlg
@150,90 MSGet oVar3  Var xAVARIAS Size 080,10 Picture "@E 999,999,999.99" Size 080,10 Pixel  Of oDlg

@165,20 Say "Sobras: "           Pixel Of oDlg
@165,90 MSGet oVar4  Var xSOBRAS Size 080,10 Picture "@E 999,999,999.99" Size 080,10 Pixel  Of oDlg

@180,20 Button oBtnOk     Prompt "&Grava"         Size 30,15 Pixel Action (U_Grava_limp(), oDlg:End()) Of oDlg
@180,90 Button oBtnCancel Prompt "C&ancela"       Size 30,15 Pixel Action ( oDlg:End(),lContinua := .F.) Cancel Of oDlg

Activate MSDialog oDlg Centered

RETURN NIL

User Function Grava_limp
// Adriano - Gravar Data de chegada na tabela SF1
dbselectarea("SF1")
dbsetorder(1)
dbseek(xFilial("SF1")+xSEEK)
IF ! SF1->(EOF())
	RecLock("SF1",.F.)
	SF1->F1_DTCHEGA := xDTCHEGA
	Msunlock()
ENDIF

// Adriano - Gravar data de chegade, faltas e avarias na tabela SD1
dbselectarea("SD1")
dbsetorder(1)
dbseek(xFilial("SD1")+xSEEK)
IF ! SD1->(EOF())
	RecLock("SD1",.F.)
	SD1->D1_DTCHEGA := xDTCHEGA
	SD1->D1_FALTAS  := xFALTAS
	SD1->D1_AVARIAS := xAVARIAS
	SD1->D1_SOBRAS  := xSOBRAS
	Msunlock()
ENDIF

dbselectarea("SF1")
Return Nil

User Function limpaclass()
Local aNFs     := {}
Local nI      := 0
Local cFilSD1 := xFilial("SD1")
Local nQtdton := 0
Local xQtd    := 0
Local cPEDIDO := ""
Local aNotas := {}
Private aNF  := {}

dbSelectArea("SF1")
dbGoTop()
While !Eof()
	If SF1->F1_OK <> cMarca
		dbSkip()
		Loop
	Endif
	aAdd( aNotas, SF1->F1_SERIE+"/"+SF1->F1_DOC )
	aAdd( aNF, SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	dbSkip()
End

aNFs := aClone( aNF )

// Busca item a item para o devido tratamento de transferencia
dbSelectArea("SD1")
dbSetOrder(1)
For nI := 1 To Len( aNFs )
	xQtd=0
	dbSeek(cFilSD1+aNFs[nI])
	While !Eof() .And. SD1->D1_FILIAL + ;
		SD1->D1_DOC + ;
		SD1->D1_SERIE + ;
		SD1->D1_FORNECE + ;
		SD1->D1_LOJA == cFilSD1+aNFs[nI]
		aItem	 := {}
		aCab   := {}
		cNatureza:=""
		cCondicao:=""
		cPEDIDO  :=""
		cNFMAE   :=""
		xQtd+=SD1->D1_QUANT
		Dbselectarea("SF1")
		DBSETORDER(1)
		DBSEEK(cFilSD1+aNFs[nI])
		IF SF1->(EOF())
			ALERT("NรO ENCONTROU N.F.")
		ELSE
			cPEDIDO  :=SF1->F1_XPEDIDO
			cNFMAE   :=SF1->F1_NFMAE
			RecLock("SF1",.F.)
			SF1->F1_NFMAE    := "" //cNFMAE
			SF1->F1_CONTRA   := "" //cCONTRA
			SF1->F1_NAVIO    := "" //cNAVIO
			SF1->F1_XPEDIDO  := "" //cPEDIDO
			msunlock()
		ENDIF

		IF !EMPTY(cNFMAE) //.AND. cNFMAE<>SF1->F1_DOC // verifica se ja gravou o n๚mero da n.f. mใe.
			// No caso abaixo ้ nota filha, portanto ้ preciso atualizar o pedido de compras com a qtd entregue.
			DBSELECTAREA("SC7")
			DBSETORDER(1)
			DBSEEK(xFILIAL("SC7")+cPEDIDO)
			IF !SC7->(EOF())          
			
			    nFator := U_EDFFATOR(SC7->C7_PRODUTO) 	  // Alexandre Santos - 17/07/2013 - Alteracao para retirnar o valor pre-fixado 
			
				RecLock("SC7",.F.) 
				// Alexandre Santos - 17/07/2013 - Alteracao para retirnar o valor pre-fixado 				
				SC7->C7_QUJE+=(xQtd/nFator)   				
				// --------------------------------------------------------------------------
				nQtdton+=xQtd
				Msunlock()

			ENDIF
		ENDIF
		
		DBSELECTAREA("SD1")
		dbSkip()
	End
	
Next nI
Return





USER FUNCTION VER_SD1

dbselectarea("SD1")
dbsetorder(1)
dbseek(xFilial("SD1")+xSEEK+xCODPRO+STRZERO(citem,4))
IF ! SD1->(EOF())
	cArmazem := SD1->D1_LOCAL
ENDIF

xNOMPRO  := Posicione("SB1",1,xFilial("SB1")+xCODPRO,"B1_DESC")

xQTD     := Posicione("SD1",1,xFilial("SD1")+xSEEK+xCODPRO+STRZERO(citem,4),  "D1_QUANT")
xVLUNIT  := Posicione("SD1",1,xFilial("SD1")+xSEEK+xCODPRO+STRZERO(citem,4),  "D1_VUNIT")
xVLTOT   := Posicione("SD1",1,xFilial("SD1")+xSEEK+xCODPRO+STRZERO(citem,4),  "D1_TOTAL")

xFALTAS  := 0
xAVARIAS := 0
xSOBRAS  := 0
//xDTCHEGA := CTOD(SPACE(08))

//xDTCHEGA := Posicione("SD1",1,xFilial("SD1")+xSEEK+STRZERO(citem,3),  "D1_DTCHEGA")
xFALTAS  := Posicione("SD1",1,xFilial("SD1")+xSEEK+xCODPRO+STRZERO(citem,4),  "D1_FALTAS")
xAVARIAS := Posicione("SD1",1,xFilial("SD1")+xSEEK+xCODPRO+STRZERO(citem,4),  "D1_AVARIAS")
xSOBRAS  := Posicione("SD1",1,xFilial("SD1")+xSEEK+xCODPRO+STRZERO(citem,4),  "D1_SOBRAS")

cnavio   := Posicione("SD1",1,xFilial("SD1")+xSEEK+xCODPRO+STRZERO(citem,4),  "D1_CLVL")


RETURN
