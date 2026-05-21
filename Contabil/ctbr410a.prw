#Include "PROTHEUS.Ch"
#INCLUDE "CTBR410.CH"

#DEFINE TAM_VALOR	19
#DEFINE TAM_CONTA  17
#DEFINE TAM_TX		8
#DEFINE TAM_DATA	12
#DEFINE TAM_DOC	18
#DEFINE __cCRLF CHR(13)+CHR(10)


// 17/08/2009 -- Filial com mais de 2 caracteres

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBR410  ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 11.07.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o do Raz„o em Duas Moedas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBR410()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBR410a()

If TRepInUse() 
	CTBR410R4()
Else
	CTBR410R3()
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBR410R4³ Autor ³ Gustavo Henrique      ³ Data ³ 13/09/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o do Raz„o em Duas Moedas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBR410R4()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTBR410R4()

Local aSetOfBook	:= {}

Local lRet			:= .T.
Local cPerg			:= "CTR410"

Private nomeprog	:= "CTBR410"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                            ³
//³ mv_par01            // da conta                                 ³
//³ mv_par02            // ate a conta                              ³
//³ mv_par03            // da data                                  ³
//³ mv_par04            // Ate a data                               ³
//³ mv_par05            // Moeda corrente 	                        ³   
//³ mv_par06            // Moeda   			                     	³   
//³ mv_par07            // Saldos		                          	³  	 
//³ mv_par08            // Set Of Books                          	³
//³ mv_par09            // Analitico ou Resumido dia (resumo)    	³
//³ mv_par10            // Imprime conta sem movimento?          	³
//³ mv_par11            // Junta Contas com mesmo C.Custo?       	³
//³ mv_par12            // Imprime Conta (Normal / Reduzida)     	³
//³ mv_par13            // Imprime ?                             	³
//³ mv_par14            // Imprime Codigo (Normal / Reduzido)    	³
//³ mv_par15            // Do Centro de Custo                    	³
//³ mv_par16            // At‚ o Centro de Custo                 	³
//³ mv_par17            // Do Item                                  ³
//³ mv_par18            // Ate Item                                 ³
//³ mv_par19            // Da Classe de Valor                       ³
//³ mv_par20            // Ate a Classe de Valor                 	³
//³ mv_par21            // Salto de pagina                       	³
//³ mv_par22            // Pagina Inicial                        	³
//³ mv_par23            // Pagina Final                          	³
//³ mv_par24            // Numero da Pag p/ Reiniciar            	³
//³ mv_par25            // Imprime Total Geral (Sim/Nao)         	³
//³ mv_par26            // So Livro/Livro e Termos/So Termos     	³
//³ mv_par27            // Com Saldo Moeda/Com Saldo Corrente/Todos ³ 
//³ mv_par28            // Imprime Valor 0.00						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Pergunte(cPerg, .T. )
	Return
EndIf

If !Ct040Valid(mv_par08)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par08)
EndIf

If lRet
	aCtbMoeda := CtbMoeda(mv_par06)
   	If Empty(aCtbMoeda[1])
      	Help(" ",1,"NOMOEDA")
      	lRet := .F.
   	Endif
Endif

If lRet       
	oReport:= ReportDef( cPerg, aCtbMoeda, aSetOfBook )
	oReport:PrintDialog()
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Gustavo Henrique      ³ Data ³12/09/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo usuario.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³EXPC1 - Nome do grupo de perguntas                          ³±±
±±³          ³EXPA2 - Array de moedas                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef( cPerg, aCtbMoeda, aSetOfBook )

Local oContaSint	
Local oConta
Local oLancto
Local oCompl
Local cDesc1		:= OemToAnsi(STR0001)	// "Este programa ir  imprimir o Raz„o Contabil,"
Local cDesc2		:= OemToAnsi(STR0002)	// "os parametros solicitados pelo usuario. O Relatorio sera"
Local cDesc3		:= OemToAnsi(STR0003)	// "impresso em Real e outra Moeda escolhida pelo Usuario."
Local lSalto		:= (mv_par21 == 1)
Local lAnalitico	:= (mv_par09 == 1)
Local lCusto 		:= (mv_par13 == 1)
Local lItem			:= (mv_par13 == 2)
Local lCLVL			:= (mv_par13 == 3)
Local lPrintZero	:= (mv_par28 == 1)                                                  
Local cSayCusto	:= CtbSayApro("CTT")
Local cSayItem		:= CtbSayApro("CTD")
Local cSayClVl		:= CtbSayApro("CTH")
Local cPicture		:= aSetOfBook[4]
Local aTamConta	:= TamSX3("CT1_CONTA")
Local nTamCusto	:= Len(CriaVar("CT3_CUSTO"))
Local nTamItem 	:= Len(CriaVar("CTD->CTD_DESC"+mv_par05))
Local nTamCLVL		:= Len(CriaVar("CTH_CLVL"))
Local nAlignTot 	:= 0
Local nDecimais 	:= DecimalCTB(aSetOfBook,mv_par06)
Local aCtbMd01		:= CtbMoeda(mv_par05)     

oReport :=	TReport():New( "CTBR410", OemToAnsi(STR0006), cPerg,;	//"Emissao do Razao Contabil"
			{ |oReport|	Pergunte( cPerg, .F. ), ReportPrint(oReport,aSetOfBook,aCtbMoeda,cPerg) },cDesc1+cDesc2+cDesc3)

oReport:ParamReadOnly()

If lAnalitico
	oReport:SetLandScape(.T.)
Else
	oReport:SetPortrait(.T.)
EndIf

// Conta Sintetica                
oContaSint := TRSection():New( oReport, STR0034, {"cArqTmp","CT2"},, .F., .F. ) 	// "Conta Sintética"
oContaSint:SetHeaderSection(.F.)        

If lSalto
	oContaSint:SetPageBreak(.T.)
EndIf

TRCell():New( oContaSint, "CONTSINT", "", STR0035,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)		//"Conta"
TRCell():New( oContaSint, "DESCSINT", "", STR0040,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)		//"Descrição"	
                  
// Conta 
oConta := TRSection():New( oReport, STR0035, {"cArqTmp"},, .F., .F. )		// "Conta"
oConta:SetHeaderSection(.F.)        

If lSalto
	oConta:SetPageBreak(.T.)
EndIf
        

TRCell():New( oConta, "CONTA"		 , "cArqTmp", STR0035,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)				//"Conta"
TRCell():New( oConta, "DESCONTA"	 , ""       , STR0040,/*Picture*/,If(lAnalitico,161,93),/*lPixel*/,/*CodeBlock*/)	//"Descrição"
TRCell():New( oConta, "SLDMOEDA2", ""       , STR0030+Space(1)+aCtbMoeda[3],/*Picture*/,TAM_VALOR,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")		//"SALDO ATUAL US$"
TRCell():New( oConta, "SLDMOEDA1", ""       , STR0030+Space(1)+aCtbMd01[3] ,/*Picture*/,TAM_VALOR,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")		//"SALDO ATUAL R$"

// Lancamentos
oLancto := TRSection():New( oReport, STR0036,{"cArqTmp"},, .F., .F. )	// "Lançamento"
oLancto:SetTotalInLine(.F.)
oLancto:SetHeaderPage(.T.)

TRCell():New(oLancto, "DATAL"			,"cArqTmp", STR0019 ,/*Picture*/, 10,/*lPixel*/,/*CodeBlock*/)// Data do Lancamento
TRCell():New(oLancto, "DOCUMENTO"	,""       , STR0031 ,/*Picture*/,25,/*lPixel*/,{|| cArqTmp->(LOTE+SUBLOTE+DOC+LINHA) })// "LOTE/SUB/DOC/LINHA"
If lAnalitico
	TRCell():New(oLancto, "HISTORICO"	,"cArqTmp", STR0032 ,/*Picture*/,40	,/*lPixel*/,{|| SubStr(cArqTmp->HISTORICO,1,40) },,.F.)// Historico
	TRCell():New(oLancto, "XPARTIDA"		,"cArqTmp", STR0033 ,/*Picture*/,aTamConta[1],/*lPixel*/,/*CodeBlock*/)// "XPARTIDA"	
	oLancto:Cell("HISTORICO"):lHeaderSize 	:= .F.
	oLancto:Cell("XPARTIDA"):lHeaderSize	:= .F.
EndIf
If lCusto .And. lAnalitico
	TRCell():New(oLancto, "CUSTO"	  		,"cArqTmp", STR0041 ,/*Picture*/,15,/*lPixel*/,/*CodeBlock*/)		//"C.CUSTO"
ElseIf lClVl .And. lAnalitico
	TRCell():New(oLancto, "CLVL"			,"cArqTmp", STR0042 ,/*Picture*/,15,/*lPixel*/,/*CodeBlock*/)		//"CL.VALOR"
ElseIf lItem .And. lAnalitico
	TRCell():New(oLancto, "ITEM"			,"cArqTmp", STR0043 ,/*Picture*/,15,/*lPixel*/,/*CodeBlock*/)		//"ITEM CONTAB"
EndIf
TRCell():New(oLancto, "LANCDEB"		,"cArqTmp", STR0028,/*Picture*/,TAM_VALOR,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCDEB  ,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },/*"RIGHT"*/,,"RIGHT")// Debito
TRCell():New(oLancto, "LANCDEBTX"	,"cArqTmp", Space(1)+aCtbMoeda[3],/*Picture*/,TAM_TX,/*lPixel*/,{|| Trans(cArqTmp->TXDEBITO, "@Z 9.9999") },/*"RIGHT"*/,,"RIGHT")// DebitoTX
TRCell():New(oLancto, "LANCDEB_1"	,"cArqTmp", STR0028+Space(1)+aCtbMd01[3] ,/*Picture*/,TAM_VALOR	,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCDEB_1,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },/*"RIGHT"*/,,"RIGHT")// Debito moeda 1
TRCell():New(oLancto, "LANCCRD"		,"cArqTmp", STR0029,/*Picture*/,TAM_VALOR,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCCRD  ,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)},/*"RIGHT"*/,,"RIGHT")// Credito
TRCell():New(oLancto, "LANCCRDTX"	,"cArqTmp", Space(1)+aCtbMoeda[3],/*Picture*/,TAM_TX,/*lPixel*/,{|| Trans(cArqTmp->TXCREDITO, "@Z 9.9999") },/*"RIGHT"*/,,"RIGHT")// CreditoTX
TRCell():New(oLancto, "LANCCRD_1"	,"cArqTmp", STR0029+Space(1)+aCtbMd01[3] ,/*Picture*/,TAM_VALOR	,/*lPixel*/,{|| ValorCTB(cArqTmp->LANCCRD_1,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) },/*"RIGHT"*/,,"RIGHT")// Credito moeda 1
TRCell():New(oLancto, "SLDATU"		,"cArqTmp", STR0030+Space(1)+aCtbMoeda[3],/*Picture*/,TAM_VALOR	,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"RIGHT")// Sinal do Saldo Atual => Consulta Razao
TRCell():New(oLancto, "SLDATU_1"	,"cArqTmp", STR0030+Space(1)+aCtbMd01[3] ,/*Picture*/,TAM_VALOR	,/*lPixel*/,/*CodeBlock*/,/*"RIGHT"*/,,"RIGHT",,,,,,)// Sinal do Saldo Atual => Consulta Razao
        
          		
oConta:Cell("CONTA"):lHeaderSize        := .F.
oConta:Cell("DESCONTA"):lHeaderSize     := .F.
oConta:Cell("SLDMOEDA2"):lHeaderSize    := .F.
oConta:Cell("SLDMOEDA1"):lHeaderSize    := .F.
oLancto:Cell("LANCDEB"):lHeaderSize 	:= .F.
oLancto:Cell("LANCDEBTX"):lHeaderSize	:= .F.
oLancto:Cell("LANCDEB_1"):lHeaderSize	:= .F.
oLancto:Cell("LANCCRD"):lHeaderSize 	:= .F.
oLancto:Cell("LANCCRDTX"):lHeaderSize 	:= .F.
oLancto:Cell("LANCCRD_1"):lHeaderSize	:= .F.
oLancto:Cell("SLDATU"):lHeaderSize 		:= .F.
oLancto:Cell("SLDATU_1"):lHeaderSize 	:= .F.    

If !lAnalitico
	oLancto:Cell("DOCUMENTO"):Hide()
	oLancto:Cell("DOCUMENTO"):HideHeader() 
EndIf

If lAnalitico
	// Complemento
	oCompl := TRSection():New( oReport,STR0038,,, .F., .F. )	//"Complemento"
	TRCell():New(oCompl,"COMP","",STR0038,/*Picture*/,Iif(lAnalitico,60,28)+aTamConta[1]+nTamCusto+nTamItem+nTamCLVL,/*lPixel*/,/*{|| code-block de impressao }*/)
	oCompl:Cell("COMP"):HideHeader()
	oCompl:SetHeaderSection(.F.)
	oCompl:SetLinesBefore(0)
EndIf

oLancto:SetEdit(.F.)
oConta:SetEdit(.F.)
oContaSint:SetEdit(.F.)
If lAnalitico
	oCompl:SetEdit(.F.)
EndIf

Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Gustavo Henrique      ³ Data ³12/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport, aSetOfBook, aCtbMoeda, cPerg )
        
Local oContaSint  := oReport:Section(1)
Local oConta		:= oReport:Section(2)
Local oLancto		:= oReport:Section(3)
Local oCompl		:= oReport:Section(4)
Local aSaldo		:= {}
Local aSaldAnt		:= {}
Local aCtbMd01   	:= {}
Local aTamConta	:= TamSX3("CT1_CONTA")
Local lImpLivro	:= .T.     
Local lCusto 		:= .F.
Local lItem			:= .F.
Local lCLVL			:= .F.
Local lAnalitico	:= .F.
Local lSalto		:= .F.
Local lTotalGeral	:= .F.
Local lNormal		:= .F.
Local lReduz		:= .F.
Local lNoMov		:= .F.
Local lJunta		:= .F.
Local lPrintZero	:= .F.
Local cCodRes		:= ""
Local cDescMoeda	:= ""
Local cDescSint	:= ""
Local cDescConta	:= ""
Local cMascara1	:= ""
Local cMascara2	:= ""
Local cMascara3	:= ""
Local cMascara4	:= ""
Local cPicture		:= ""
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cSepara3		:= ""
Local cSepara4		:= ""
Local cArqTmp		:= ""
Local cContaAnt	:= ""
Local cTitulo		:= ""
Local cSaldo		:= ""
Local cContaIni	:= ""
Local cContaFIm	:= ""
Local cCustoIni	:= ""
Local cCustoFim	:= ""
Local cItemIni		:= ""
Local cItemFim		:= ""
Local cCLVLIni		:= ""
Local cCLVLFim		:= ""
Local cMoeda		:= ""
Local cArqAbert	:= ""
Local cArqEncer	:= ""
Local dDataAnt		:= CtoD("  /  /  ")
Local dDataIni		:= CtoD("  /  /  ")
Local dDataFim		:= CtoD("  /  /  ")
Local nDecimais	:= 0
Local nSldATran1	:= 0
Local nSldATran2	:= 0
Local nSldDTran1	:= 0
Local nSldDTran2	:= 0
Local nSal01Atu	:= 0
Local nSaldoAtu	:= 0
Local nVlrDeb		:= 0
Local nV01Deb		:= 0
Local nVlrCrd		:= 0
Local nV01Crd		:= 0
Local nTotDeb		:= 0
Local nT01Deb		:= 0
Local nTotCrd		:= 0
Local nT01Crd		:= 0
Local nTotGerDeb	:= 0
Local nT01GerDeb	:= 0
Local nTotGerCrd	:= 0
Local nT01GerCrd	:= 0
Local nInutLin		:= 0
Local nLinAst		:= 0
Local nCont			:= 0
Local cFilterUser 	:= oContaSint:GetAdvplExp()    
Local lTemDados		:= .T.
Local lResetPag		:= .T.
Local m_pag			:= 1 // controle de numeração de pagina
Local l1StQb		:= .T.  
Local nPagIni		:= mv_par22
Local nPagFim		:= mv_par23
Local nReinicia		:= mv_par24
Local nBloco		:= 0
Local nBlCount		:= 1   
Local lRetrato		:= (oReport:GetOrientation()==1)          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Garante alteracoes nas perguntas realizadas no dialogo de configuracao do TReport³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte( cPerg, .F. )

lCusto 		:= (mv_par13 == 1)
lItem			:= (mv_par13 == 2)
lCLVL			:= (mv_par13 == 3)
lAnalitico	:= (mv_par09 == 1)
lSalto		:= (mv_par21 == 1)
lTotalGeral		:= (mv_par25 == 1)                          

lNormal		:= (mv_par14 == 1)
lReduz		:= (mv_par12 == 1)
lNoMov		:= (mv_par10 == 1)
lJunta		:= (mv_par11 == 1)                           
lPrintZero	:= (mv_par28 == 1)

dDataIni		:= mv_par03
dDataFim		:= mv_par04

cSaldo		:= mv_par07
cContaIni	:= mv_par01
cContaFIm	:= mv_par02
cCustoIni	:= mv_par15
cCustoFim	:= mv_par16
cItemIni		:= mv_par17
cItemFim		:= mv_par18
cCLVLIni		:= mv_par19
cCLVLFim		:= mv_par20
cMoeda		:= mv_par06

aCtbMd01	:= CtbMoeda(mv_par05)

//********************************
// Totalizadores do Relatorio    *
//********************************

// Totais da Conta
oTotConta := TRBreak():New(oContaSint, { || cArqTmp->CONTA }, OemToAnsi(STR0019),) //"Totais da Conta"

oTotCDeb  := TRFunction():New(oLancto:Cell("LANCDEB")	,,"ONPRINT",oTotConta,,, { || ValorCTB(nTotDeb,0,0,TAM_VALOR-2,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. )}, .T. , .F. )
oTotCDeb1 := TRFunction():New(oLancto:Cell("LANCDEB_1")	,,"ONPRINT",oTotConta,,, { || ValorCTB(nT01Deb,0,0,TAM_VALOR-2,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. )}, .T. , .F. )
oTotCCrd  := TRFunction():New(oLancto:Cell("LANCCRD")	,,"ONPRINT",oTotConta,,, { || ValorCTB(nTotCrd,0,0,TAM_VALOR-2,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. )}, .T. , .F. )
oTotCCrd1 := TRFunction():New(oLancto:Cell("LANCCRD_1")	,,"ONPRINT",oTotConta,,, { || ValorCTB(nT01Crd,0,0,TAM_VALOR-2,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. )}, .T. , .F. )
oTotCSld  := TRFunction():New(oLancto:Cell("SLDATU")	,,"ONPRINT",oTotConta,,, { || ValorCTB(nSaldoAtu,0,0,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.)}, .T. , .F. )
oTotCSld1 := TRFunction():New(oLancto:Cell("SLDATU_1")	,,"ONPRINT",oTotConta,,, { || ValorCTB(nSal01Atu,0,0,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.)}, .T. , .F. )

// Total Geral
If lImpLivro .And. lTotalGeral	//Imprime total Geral

	oTotGeral := TRBreak():New(oContaSint, { || cArqTmp->(Eof())}, OemToAnsi(STR0039),) //"Total Geral"
	
	oTotGDeb  := TRFunction():New(oLancto:Cell("LANCDEB")	,,"ONPRINT",oTotGeral,,, { || ValorCTB(nTotGerDeb,0,0,TAM_VALOR-2,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. )}, .F. , .F. )
	oTotGDeb1 := TRFunction():New(oLancto:Cell("LANCDEB_1")	,,"ONPRINT",oTotGeral,,, { || ValorCTB(nT01GerDeb,0,0,TAM_VALOR-2,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. )}, .F. , .F. )
	oTotGCrd  := TRFunction():New(oLancto:Cell("LANCCRD")	,,"ONPRINT",oTotGeral,,, { || ValorCTB(nTotGerCrd,0,0,TAM_VALOR-2,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. )}, .F. , .F. )
	oTotGCrd1 := TRFunction():New(oLancto:Cell("LANCCRD_1")	,,"ONPRINT",oTotGeral,,, { || ValorCTB(nT01GerCrd,0,0,TAM_VALOR-2,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. )}, .F. , .F. )	

EndIf

//****************************************
// Fim dos Totalizadores do Relatorio    *
//****************************************

If lRetrato .and. lAnalitico

	oLancto:Cell("HISTORICO"  ):SetSize(0)
	oLancto:Cell("HISTORICO"  ):Disable()
	oLancto:Cell("XPARTIDA"	  ):SetSize(0)
	oLancto:Cell("XPARTIDA"	  ):Disable()
	
	If lCusto
		oLancto:Cell("CUSTO"	  ):SetSize(0)
		oLancto:Cell("CUSTO"	  ):Disable()
	EndIf
	If lCLVL
		oLancto:Cell("CLVL"		  ):SetSize(0)
		oLancto:Cell("CLVL"		  ):Disable()
	EndIf
	If lItem
		oLancto:Cell("ITEM"		  ):SetSize(0)
		oLancto:Cell("ITEM"		  ):Disable()
	EndIf

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("NewHead")== "U"
	IF lAnalitico
		cTitulo	:=	OemToAnsi(STR0007)	//"RAZAO ANALITICO EM MOEDA CORRENTE E "
	Else
		cTitulo	:=	OemToAnsi(STR0008)	//"RAZAO SINTETICO EM MOEDA CORRENTE E "
	EndIf
	cTitulo += 	Alltrim(aCtbMoeda[2]) + OemToAnsi(STR0009) + DTOC(dDataIni) +;	// "DE"
				OemToAnsi(STR0010) + DTOC(dDataFim) + CtbTitSaldo(mv_par07)	// "ATE"
Else
	cTitulo := NewHead
EndIf

oReport:SetTitle(cTitulo)

oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,cTitulo,,,,,oReport,.T.,@lResetPag,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb) } )

If lAnalitico		// Relatorio Analitico

	oLancto:Cell("LANCDEB"  ):SetTitle(STR0028 + Space(1) + AllTrim(aCtbMoeda[3]))	// DEBITO
	oLancto:Cell("LANCDEBTX"  ):SetTitle( " TX " + aCtbMoeda[3])					// DEBITOTX
	oLancto:Cell("LANCDEB_1"):SetTitle(	STR0028 + Space(1) + aCtbMd01[3])			// DEBITO
	
	oLancto:Cell("LANCCRD"  ):SetTitle(	STR0029 + Space(1) + AllTrim(aCtbMoeda[3]))// CREDITO
	oLancto:Cell("LANCCRDTX"  ):SetTitle(" TX " + aCtbMoeda[3])					// CREDITOTX
	oLancto:Cell("LANCCRD_1"):SetTitle(	STR0029 + Space(1) + aCtbMd01[3])			// CREDITO
	       	
	oLancto:Cell("SLDATU"  	):SetTitle(STR0030 + Space(1) + aCtbMoeda[3])			// SALDO ATUAL
	oLancto:Cell("SLDATU_1"	):SetTitle(STR0030 + Space(1) + aCtbMd01[3])			// SALDO ATUAL
                                            
	oLancto:Cell("LANCDEB"):SetSize(TAM_VALOR)
	oLancto:Cell("LANCDEBTX"):SetSize(TAM_TX)
	oLancto:Cell("LANCCRD"):SetSize(TAM_VALOR)
	oLancto:Cell("LANCCRDTX"):SetSize(TAM_TX)

	oLancto:Cell("LANCDEB"):SetBlock({ || ValorCTB(cArqTmp->LANCDEB  ,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")// Debito
	oLancto:Cell("LANCDEBTX"):SetBlock({ || Transform(cArqTmp->TXDEBITO, "@Z 9.9999")},"RIGHT",,"RIGHT")// DebitoTX

	oLancto:Cell("LANCCRD"):SetBlock({ || ValorCTB(cArqTmp->LANCCRD  ,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")// Credito
	oLancto:Cell("LANCCRDTX"):SetBlock({ || Transform(cArqTmp->TXCREDITO, "@Z 9.9999") },"RIGHT",,"RIGHT")// CreditoTX

Else                // Relatorio Resumido
	
	lCusto 	:= .F.
	lItem  	:= .F.
	lCLVL  	:= .F.

	oLancto:Cell("LANCDEB"  ):SetTitle(STR0028 + Space(1) + aCtbMoeda[3])
	oLancto:Cell("LANCDEB_1"):SetTitle(STR0028 + Space(1) + aCtbMd01[3])
	
	oLancto:Cell("LANCCRD"  ):SetTitle(STR0029 + Space(1) + aCtbMoeda[3])
	oLancto:Cell("LANCCRD_1"):SetTitle(STR0029 + Space(1) + aCtbMd01[3])
	
	oLancto:Cell("SLDATU"  	):SetTitle(STR0030 + Space(1) + aCtbMoeda[3])
	oLancto:Cell("SLDATU_1"	):SetTitle(STR0030 + Space(1) + aCtbMd01[3])

	oLancto:Cell("LANCDEB"):SetSize(TAM_VALOR)
	oLancto:Cell("LANCCRD"):SetSize(TAM_VALOR)

	oLancto:Cell("LANCDEB"):SetBlock(;
		{ || ValorCTB(nVlrDeb  ,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")
	oLancto:Cell("LANCDEB_1"):SetBlock(;
		{ || ValorCTB(nV01Deb  ,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")

	oLancto:Cell("LANCCRD"):SetBlock(;
		{ || ValorCTB(nVlrCrd  ,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")
	oLancto:Cell("LANCCRD_1"):SetBlock(;
		{ || ValorCTB(nV01Crd  ,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.)},"RIGHT",,"RIGHT")

EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par26==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par26==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par26==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase		

If ! lCusto
	If lItem
		lClVl := .F.
	Endif
Else
	lItem := .F.
	lClVl := .F.
Endif

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,cMoeda)

// Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1	:= RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf               

If lCusto .Or. lItem .Or. lCLVL
	// Mascara do Centro de Custo
	If Empty(aSetOfBook[6])
		cMascara2 := GetMv("MV_MASCCUS")
	Else
		cMascara2	:= RetMasCtb(aSetOfBook[6],@cSepara2)
	EndIf                                                
	// Mascara do Item Contabil
	If Empty(aSetOfBook[7])
		cMascara3 := ""
	Else
		cMascara3 := RetMasCtb(aSetOfBook[7],@cSepara3)
	EndIf
	// Mascara da Classe de Valor
	If Empty(aSetOfBook[8])
		cMascara4 := ""
	Else
		cMascara4 := RetMasCtb(aSetOfBook[8],@cSepara4)
	EndIf
EndIf	

cPicture := aSetOfBook[4]

If lImpLivro
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Arquivo Temporario para Impressao   					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTBGerRaz(oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				aSetOfBook,lNoMov,cSaldo,lJunta,"1",lAnalitico,mv_par05,mv_par27,cFilterUser)},;
				OemToAnsi(OemToAnsi(STR0018)),;		// "Criando Arquivo Tempor rio..."
				OemToAnsi(STR0006))						// "Emissao do Razao"

	oReport:NoUserFilter()

	dbSelectArea("cArqTmp")
	dbGoTop()
	lTemDados := (RecCount() > 0)
	oReport:SetMeter(RecCount())
Endif

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If lImpLivro .And. ! (lTemDados .And. !Empty(aSetOfBook[5]))

	// Seta ordem das tabelas
	CT1->(dbSetOrder(1) )

	If ! lNormal 
		CTT->(dbSetOrder(1))
		CTD->(dbSetOrder(1))
		CTH->(dbSetOrder(1))
	EndIf	

	oConta:Cell("CONTA"):SetSize(Len(cArqTmp->CONTA))

	// "T o t a i s  d a  C o n t a  ==> " ### "Tot.Conta"
	oTotConta:SetTitle( Iif(lAnalitico,OemToAnsi(STR0020),OemToAnsi(STR0026)))
         
	If lTotalGeral                                                     
		// "T O T A L  G E R A L ==> " ### "TOT.GERAL"
		oTotGeral:SetTitle( Iif(lAnalitico,OemToAnsi(STR0025),OemToAnsi(STR0027)) )
	EndIf	
        
	oContaSint:Init()
	oConta:Init()

	Do While cArqTmp->( ! EoF() .And. !oReport:Cancel() )

	    If oReport:Cancel()
	    	Exit
	    EndIf        

		// Saldo na moeda 02
		If lCusto
			aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
			aSaldo	  := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)
		ElseIf lItem
			aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
			aSaldo	  := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)			
		ElseIf lClVl
			aSaldoAnt := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
			aSaldo	  := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)
		Else	
			aSaldoAnt	:= SaldoCT7(cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,"CTBR400")
			aSaldo 		:= SaldoCT7(cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)
		EndIf

		If Ctbr410Fil(lNoMov,aSaldo[6],dDataIni)
			oReport:IncMeter()
			cArqTmp->(dbSkip())
			Loop
		EndIf
	
		cContaSint	:= Ctr400Sint(cArqTmp->CONTA,@cDescSint,cMoeda,@cDescConta,@cCodRes)
		cNormal 	:= CT1->CT1_NORMAL
	    
	    oContaSint:Cell("CONTSINT"):SetSize(Len(cContaSint))
   	    oContaSint:Cell("DESCSINT"):SetSize(Len(cDescSint))
   	    
	  	oContaSint:Cell("CONTSINT"):SetBlock( { || 	EntidadeCTB(cContaSint,0,0,Len(cContaSint),.F.,cMascara1,cSepara1,,,,,.F.)})
	  	oContaSint:Cell("DESCSINT"):SetBlock( { || " - " + cDescSint } )

		oContaSint:PrintLine()
	   
		nT01Deb		:= 0
		nTotDeb		:= 0
		nT01Crd		:= 0
		nTotCrd		:= 0
		nSaldoAtu	:= 0
		nSal01Atu	:= 0
	   
		oReport:SkipLine()
	                                                           
		If mv_par12 == 1							// Imprime Cod Normal
		  	oConta:Cell("CONTA"):SetBlock( { || OemToAnsi(STR0016)+EntidadeCTB(cArqTmp->CONTA,0,0,,.F.,cMascara1,cSepara1,,,,,.F.) } )	//"CONTA - "
        Else
		  	oConta:Cell("CONTA"):SetBlock( { || OemToAnsi(STR0016)+EntidadeCTB(cCodRes,0,0,20,.F.,cMascara1,cSepara1,,,,,.F.) } )	//"CONTA - "
		EndIf

	  	oConta:Cell("DESCONTA"):SetBlock( { || "- " + cDescConta } )

		nSaldoAtu := aSaldoAnt[6]
			  	                                         
		// Impressao do Saldo Anterior - moeda 02
	  	oConta:Cell("SLDMOEDA2"):SetBlock( { || ValorCTB(nSaldoAtu,0,0,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.) } )
	  	
		// Saldo na moeda 01
		If lCusto
			aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,mv_par05,cSaldo)
			aSaldo	  := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,mv_par05,cSaldo)		
		ElseIf lItem
			aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,mv_par05,cSaldo)
			aSaldo	  := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,mv_par05,cSaldo)			
		ElseIf lClVl
			aSaldoAnt := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,mv_par05,cSaldo)
			aSaldo	  := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,mv_par05,cSaldo)
		Else		
			aSaldoAnt:= SaldoCT7(cArqTmp->CONTA,dDataIni,mv_par05,cSaldo,"CTBR400")
			aSaldo 	 := SaldoCT7(cArqTmp->CONTA,cArqTmp->DATAL,mv_par05,cSaldo)
		EndIf
                                                
		nSal01Atu := aSaldoAnt[6]

	  	oConta:Cell("SLDMOEDA1"):SetBlock( { || ValorCTB(nSal01Atu,0,0,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F.)})

		oConta:PrintLine()
		
		cContaAnt	:= cArqTmp->CONTA
		dDataAnt	:= CTOD("  /  /  ")

		// A TRANSPORTAR :		
		oReport:SetPageFooter( 5, {|| Iif(oLancto:Printing() /*.Or. oTotConta:Printing()*/,;
			(oReport:PrintText(OemToAnsi(STR0022)),; 
			oReport:PrintText(ValorCTB(nSldATran2,,,TAM_VALOR-2,nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) ),;
			oReport:PrintText(ValorCTB(nSldATran1,,,TAM_VALOR-2,nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.) )),nil)})

		//"DE TRANSPORTE : "
		oReport:OnPageBreak( {|| Iif(oLancto:Printing() /*.Or. oTotConta:Printing()*/,;
				( oReport:PrintText(OemToAnsi(STR0023)),;
				oReport:PrintText(ValorCTB(nSldDTran2,,,TAM_VALOR-2,nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.)),;
			 	oReport:PrintText(ValorCTB(nSldDTran1,,,TAM_VALOR-2,nDecimais,.T.,cPicture,,,,,,,lPrintZero,.F.)),;
			 	oReport:Skipline()),nil)})
		        
		oLancto:Init()
		   
		Do While cArqTmp->( !Eof() .And. CONTA == cContaAnt .And. !oReport:Cancel() )
		                                                                             
			If oReport:Cancel()
				Exit
			EndIf	

			oReport:IncMeter()
		
			// Imprime os lancamentos para a conta
			If dDataAnt != cArqTmp->DATAL
				oLancto:Cell("DATAL"):SetBlock( { || cArqTmp->DATAL } )
				dDataAnt := cArqTmp->DATAL
			Else
				oLancto:Cell("DATAL"):SetBlock( { || dDataAnt } )
			EndIf
						
			If lAnalitico		//Se for relatorio analitico

				nSaldoAtu 	:= nSaldoAtu - cArqTmp->LANCDEB + cArqTmp->LANCCRD      
	
				// Valor da Moeda 01
				nSal01Atu 	:= nSal01Atu - cArqTmp->LANCDEB_1 + cArqTmp->LANCCRD_1

				nTotDeb		+= cArqTmp->LANCDEB
				nT01Deb		+= cArqTmp->LANCDEB_1
				nTotCrd		+= cArqTmp->LANCCRD
				nT01Crd		+= cArqTmp->LANCCRD_1
	
				nTotGerDeb	+= cArqTmp->LANCDEB
				nT01GerDeb	+= cArqTmp->LANCDEB_1
				nTotGerCrd	+= cArqTmp->LANCCRD
				nT01GerCrd	+= cArqTmp->LANCCRD_1
				
				CT1->(dbSetOrder(1))
				CT1->(MsSeek(xFilial()+cArqTmp->XPARTIDA))

				cCodRes := CT1->CT1_RES
	                                                                      
				If lReduz // Impr Cod (Normal/Reduzida/Cod.Impress)
					oLancto:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(cArqTmp->XPARTIDA,0,0,aTamConta[1],.F.,cMascara1,cSepara1,,,,,.F.) } )
				Else
					oLancto:Cell("XPARTIDA"):SetBlock( { || EntidadeCTB(cCodRes,0,0,TAM_CONTA,.F.,cMascara1,cSepara1,,,,,.F.) } )
				Endif                              
	
				If lCusto
					If lNormal //Imprime Cod. Centro de Custo Normal 
						oLancto:Cell("CUSTO"):SetBlock( { || EntidadeCTB(cArqTmp->CCUSTO,0,0,TAM_CONTA,.F.,cMascara2,cSepara2,,,,,.F.) } )
					Else 
						CTT->(MsSeek(xFilial()+cArqTmp->CCUSTO))
						oLancto:Cell("CUSTO"):SetBlock( { || EntidadeCTB(CTT->CTT_RES,0,0,TAM_CONTA,.F.,cMascara2,cSepara2,,,,,.F.) } )
					Endif                                                       
				Endif
	
				If lItem 	// Se imprime item 
					If lNormal // Imprime Cod. Normal Classe de Valor
						oLancto:Cell("ITEM"):SetBlock( { || EntidadeCTB(cArqTmp->ITEM,0,0,TAM_CONTA,.F.,cMascara3,cSepara3,,,,,.F.) } )
					Else
						CTD->(MsSeek(xFilial("CTD")+cArqTmp->ITEM))
						oLancto:Cell("ITEM"):SetBlock( { || EntidadeCTB(CTD->CTD_RES,0,0,TAM_CONTA,.F.,cMascara3,cSepara3,,,,,.F.) } )
					EndIf
				Endif
					
				If lCLVL	// Se imprime classe de valor
					If lNormal // Imprime Cod. Normal Classe de Valor
						oLancto:Cell("CLVL"):SetBlock( { || EntidadeCTB(cArqTmp->CLVL,0,0,TAM_CONTA,.F.,cMascara4,cSepara4,,,,,.F.) } )
					Else
						CTH->(MsSeek(xFilial("CTH")+cArqTmp->CLVL))
						oLancto:Cell("CLVL"):SetBlock( { || EntidadeCTB(CTH->CTH_RES,0,0,TAM_CONTA,.F.,cMascara4,cSepara4,,,,,.F.) } )
					Endif			
				Endif
				
				// Saldo na moeda 02   
				
	 			oLancto:Cell("SLDATU"):SetBlock( { || ValorCTB(nSaldoAtu,0,0,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )

				// Saldo na Moeda 01
				oLancto:Cell("SLDATU_1"):SetBlock( { || ValorCTB(nSal01Atu,0,0,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )

				oLancto:PrintLine()

				nSldATran2 := nSaldoAtu // Valor a Transportar - Moeda 2
				nSldATran1 := nSal01Atu // Valor a Transportar - Moeda 1
					
				nSldDTran2 := nSaldoAtu // Valor de Transporte - 2
				nSldDTran1 := nSal01Atu // Valor de Transporte - 1
	                             
				If lAnalitico
					// Procura pelo complemento de historico e imprime se encontrar
					ImpCompl(oReport)
        		EndIf
        		
				cArqTmp->(dbSkip())
				
			Else		// Se for resumido.                               			

				Do While cArqTmp->( !EoF() .And. dDataAnt == DATAL .And. cContaAnt == CONTA .And. !oReport:Cancel() )
					
					If oReport:Cancel()
						Exit
					EndIf	

					oReport:IncMeter()			        	
					nVlrDeb	+= cArqTmp->LANCDEB
					nV01Deb	+= cArqTmp->LANCDEB_1
					nVlrCrd	+= cArqTmp->LANCCRD
					nV01Crd	+= cArqTmp->LANCCRD_1
	
					nTotGerDeb	+= cArqTmp->LANCDEB
					nTotGerCrd	+= cArqTmp->LANCCRD
					nT01GerDeb	+= cArqTmp->LANCDEB_1
					nT01GerCrd	+= cArqTmp->LANCCRD_1
					cArqTmp->(dbSkip())
				EndDo			                                                                    
				
				If !oReport:Cancel()
	
					nSaldoAtu := nSaldoAtu - nVlrDeb + nVlrCrd
					nSal01Atu := nSal01Atu - nV01Deb + nV01Crd

					oLancto:Cell("DATAL"):SetBlock( { || dDataAnt } )
		
					// Saldo na moeda 02 
					oLancto:Cell("SLDATU"):SetBlock( { || ValorCTB(nSaldoAtu,0,0,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
	
					// Saldo na Moeda 01
					oLancto:Cell("SLDATU_1"):SetBlock( { || ValorCTB(nSal01Atu,0,0,TAM_VALOR-2,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
	                    
					oLancto:PrintLine()
	
					nTotDeb		+= nVlrDeb
					nTotCrd		+= nVlrCrd         
					nT01Deb		+= nV01Deb
					nT01Crd		+= nV01Crd         
					nVlrDeb		:= nV01Deb := 0
					nVlrCrd		:= nV01Crd := 0
				EndIf	
				
			EndIf

		EndDo  
		
		oLancto:Finish()
/*
		If !oReport:Cancel() 
		    oLancto:Finish()     
	    
		    oTotConta:Init()
		    
			oTotConta:Cell("TOT_DEB"  ):SetBlock( { || ValorCTB(nTotDeb,0,0,TAM_VALOR,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
			oTotConta:Cell("TOT_DEB_1"):SetBlock( { || ValorCTB(nT01Deb,0,0,TAM_VALOR,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
				
			oTotConta:Cell("TOT_CRD"  ):SetBlock( { || ValorCTB(nTotCrd,0,0,TAM_VALOR,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
			oTotConta:Cell("TOT_CRD_1"):SetBlock( { || ValorCTB(nT01Crd,0,0,TAM_VALOR,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
			
			oTotConta:Cell("TOT_SLD"  ):SetBlock( { || ValorCTB(nSaldoAtu,0,0,TAM_VALOR,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
			oTotConta:Cell("TOT_SLD_1"):SetBlock( { || ValorCTB(nSal01Atu,0,0,TAM_VALOR,nDecimais,.T.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
		            
			oTotConta:PrintLine()    
			
			oTotConta:Finish()   
			
			oReport:SkipLine()
			
			If lSalto .And. cArqTmp->(!EoF())
				oReport:EndPage()
			EndIf
				
		EndIf	
*/

		nSldATran2 := 0 // Valor a Transportar - Moeda 2
		nSldATran1 := 0 // Valor a Transportar - Moeda 1
			
		nSldDTran2 := 0 // Valor de Transporte - 2
		nSldDTran1 := 0 // Valor de Transporte - 1

	EndDo

	oConta:Finish()
	oContaSint:Finish()
/*		
	If !oReport:Cancel() .And. lTemDados

		If lImpLivro .And. lTotalGeral	//Imprime total Geral

			oTotGeral:Init()
	
			oTotGeral:Cell("TOT_DEB"  ):SetBlock( { || ValorCTB(nTotGerDeb,0,0,TAM_VALOR,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
			oTotGeral:Cell("TOT_DEB_1"):SetBlock( { || ValorCTB(nT01GerDeb,0,0,TAM_VALOR,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
	
			oTotGeral:Cell("TOT_CRD"  ):SetBlock( { || ValorCTB(nTotGerCrd,0,0,TAM_VALOR,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
			oTotGeral:Cell("TOT_CRD_1"):SetBlock( { || ValorCTB(nT01GerCrd,0,0,TAM_VALOR,nDecimais,.F.,cPicture,cNormal,,,,,,lPrintZero,.F. ) } )
		                      
			oReport:ThinLine()
			
		 	oTotGeral:PrintLine()
			oTotGeral:Finish()	
		
		Endif
	
	EndIf
*/
	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	
Endif

nLinAst := GetNewPar("MV_INUTLIN",0)
If !oReport:Cancel() .And. lTemDados .And. nLinAst # 0
	For nInutLin := 1 to nLinAst
		oReport:SkipLine()
		oReport:PrintText(Replicate("*",oReport:PageWidth()))
	Next
EndIf

If !oReport:Cancel() .And. lImpTermos 							// Impressao dos Termos

	cArqAbert:=GetNewPar("MV_LRAZABE","")
	cArqEncer:=GetNewPar("MV_LRAZENC","")
	
    If Empty(cArqAbert)
		ApMsgAlert(	"Devem ser criados os parametros MV_LRAZABE e MV_LRAZENC. " +;
					"Utilize como base MV_LDIARAB.")
	Endif
Endif

If !oReport:Cancel() .And. lImpTermos .And. !Empty(cArqAbert)	// Impressao dos Termos

	dbSelectArea("SM0")
	aVariaveis:={}

	For nCont:=1 to FCount()	
		If FieldName(nCont)=="M0_CGC"
			AADD(aVariaveis,{FieldName(nCont),Transform(FieldGet(nCont),"@R 99.999.999/9999-99")})
		Else
            If FieldName(nCont)=="M0_NOME"
                Loop
            EndIf
			AADD(aVariaveis,{FieldName(nCont),FieldGet(nCont)})
		Endif
	Next

	oFwSX1Util := FwSX1Util():New()
	oFwSX1Util:AddGroup("CTR410")
	oFwSX1Util:SearchGroup()
	aPergunte := oFwSX1Util:GetGroup("CTR410")
	If Len(aPergunte) >= 2
		For nx := 1 to Len (aPergunte[2])
			AADD(aVariaveis,{Rtrim(Upper(aPergunte[2,nx]:CX1_VAR01)),&(aPergunte[2,nx]:CX1_VAR01)})
		Next nx
	Endif

	If !File(cArqAbert)
		aSavSet:=__SetSets()
		cArqAbert:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If !File(cArqEncer)
		aSavSet:=__SetSets()
		cArqEncer:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If cArqAbert#NIL
		oReport:EndPage()
		ImpTerm2(cArqAbert,aVariaveis,,,, oReport)
	Endif

	If cArqEncer#NIL     
		oReport:EndPage()	
		ImpTerm2(cArqEncer,aVariaveis,,,, oReport)
	Endif

Endif

If Select("cArqTmp") == 0

	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIf	

dbselectArea("CT2")

Return
                
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpCompl  ºAutor  ³Gustavo Henrique    º Data ³  12/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Retorna a descricao, da conta contabil, item, centro de     º±±
±±º          ³custo ou classe valor                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³EXPO1 - Objeto do relatorio TReport.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR390                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpCompl(oReport)
	
Local oCompl := oReport:Section(4)

oCompl:SetHeaderSection(.F.)
oCompl:SetLinesBefore(0)

oCompl:Cell("COMP"):SetBlock({|| Space(LEN(DTOS(CT2->CT2_DATA))+4+LEN(CT2->CT2_LOTE)+LEN(CT2->CT2_SBLOTE)+LEN(CT2->CT2_DOC))+CT2->CT2_LINHA+Space(1)+Subs(CT2->CT2_HIST,1,40) } )
oCompl:Init()
// Procura pelo complemento de historico
dbSelectArea("CT2")
dbSetOrder(10)
If MsSeek(xFilial("CT2")+cArqTMP->(DTOS(DATAL)+LOTE+SUBLOTE+DOC+SEQLAN+EMPORI+FILORI),.F.)
	dbSkip()
	If CT2->CT2_DC == "4"			//// TRATAMENTO PARA IMPRESSAO DAS CONTINUACOES DE HISTORICO
		Do While !	CT2->(Eof()) .And.;
					CT2->CT2_FILIAL == xFilial("CT2") 		.And.;
					CT2->CT2_LOTE   == cArqTMP->LOTE		.And.;
					CT2->CT2_SBLOTE == cArqTMP->SUBLOTE		.And.;
					CT2->CT2_DOC    == cArqTmp->DOC 		.And.;
					CT2->CT2_SEQLAN == cArqTmp->SEQLAN	 	.And.;
					CT2->CT2_EMPORI == cArqTmp->EMPORI		.And.;
					CT2->CT2_FILORI == cArqTmp->FILORI 		.And.;
					CT2->CT2_DC     == "4" 					.And.;
				 	DTOS(CT2->CT2_DATA) == DTOS(cArqTmp->DATAL)
			oCompl:Printline()
			CT2->(dbSkip())
		EndDo
	EndIf
EndIf

oCompl:Finish()

dbSelectArea("cArqTmp")
    
Return
                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Ctbr410Fil ºAutor  ³ Gustavo Henrique   º Data ³  14/09/06 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Filtra contas sem movimento                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR440                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ctbr410Fil(lNoMov,nSaldo,dDataIni)

Local lOk := .F.

If !lNoMov //Se imprime conta sem movimento
	lOk := (nSaldo == 0 .And. cArqTmp->LANCDEB + cArqTmp->LANCDEB_1 ==0 .And.;
			cArqTmp->LANCCRD + cArqTmp->LANCCRD_1 == 0)
Endif             

If lNomov .And. (nSaldo == 0 .And.	cArqTmp->LANCDEB + cArqTmp->LANCDEB_1 ==0 .And.;
							cArqTmp->LANCCRD + cArqTmp->LANCCRD_1 == 0) 
	If CtbExDtFim("CT1") .And. CT1->(MsSeek(xFilial()+cArqTmp->CONTA))
		lOk := !CtbVlDtFim("CT1",dDataIni) 		
	EndIf
EndIf

Return lOk



                  
/*
------------------------------------------------------------ RELEASE 3 ---------------------------------------------------------
*/




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CTBR410R3³ Autor ³ Wagner Mobile Costa   ³ Data ³ 11.07.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o do Raz„o em Duas Moedas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CTBR410R3()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTBR410R3()

Local aCtbMoeda		:= {}
Local WnRel			:= "CTBR410A"

Local cDesc1		:= OemToAnsi(STR0001)	// "Este programa ir  imprimir o Raz„o Contabil,"
Local cDesc2		:= OemToAnsi(STR0002)	// "os parametros solicitados pelo usuario. O Relatorio sera"
Local cDesc3		:= OemToAnsi(STR0003)	// "impresso em Real e outra Moeda escolhida pelo Usuario."
Local cString		:= "CT2"

Local titulo		:= OemToAnsi(STR0006)	//"Emissao do Razao Contabil"
Local lCusto		:= .F.
Local lItem			:= .F.
Local lCLVL			:= .F.                         
Local lAnalitico 	:= .T.
Local lRet			:= .T.

Local nTamLinha		:= 220

Private aReturn		:= { OemToAnsi(STR0004), 1,OemToAnsi(STR0005), 2, 2, 1, "", 1 }  //"Zebrado"###"Administracao"
Private nomeprog	:= "CTBR410A"
Private aLinha		:= {}
Private nLastKey	:= 0
Private cPerg		:= "CTR410"
Private Tamanho 	:= "G"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

If !Pergunte("CTR410", .T. )
	Return
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         	  ³
//³ mv_par01            // da conta                              	  ³
//³ mv_par02            // ate a conta                           	  ³
//³ mv_par03            // da data                               	  ³
//³ mv_par04            // Ate a data                            	  ³
//³ mv_par05            // Moeda corrente 	                          ³   
//³ mv_par06            // Moeda   			                     	  ³   
//³ mv_par07            // Saldos		                          	  ³  	 
//³ mv_par08            // Set Of Books                          	  ³
//³ mv_par09            // Analitico ou Resumido dia (resumo)    	  ³
//³ mv_par10            // Imprime conta sem movimento?          	  ³
//³ mv_par11            // Junta Contas com mesmo C.Custo?       	  ³
//³ mv_par12            // Imprime Conta (Normal / Reduzida)     	  ³
//³ mv_par13            // Imprime ?                             	  ³
//³ mv_par14            // Imprime Codigo (Normal / Reduzido)    	  ³
//³ mv_par15            // Do Centro de Custo                    	  ³
//³ mv_par16            // At‚ o Centro de Custo                 	  ³
//³ mv_par17            // Do Item                                    ³
//³ mv_par18            // Ate Item                                   ³
//³ mv_par19            // Da Classe de Valor                         ³
//³ mv_par20            // Ate a Classe de Valor                 	  ³
//³ mv_par21            // Salto de pagina                       	  ³
//³ mv_par22            // Pagina Inicial                        	  ³
//³ mv_par23            // Pagina Final                          	  ³
//³ mv_par24            // Numero da Pag p/ Reiniciar            	  ³
//³ mv_par25            // Imprime Total Geral (Sim/Nao)         	  ³
//³ mv_par26            // So Livro/Livro e Termos/So Termos     	  ³
//³ mv_par27            // Com Saldo Moeda/Com Saldo Corrente/Todos   ³ 
//³ mv_par28            // Imprime Valor 0.00						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

lCusto 		:= Iif(mv_par13 == 1,.T.,.F.)
lItem		:= Iif(mv_par13 == 2,.T.,.F.)
lCLVL		:= Iif(mv_par13 == 3,.T.,.F.)
lAnalitico	:= Iif(mv_par09 == 1,.T.,.F.)

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"")

lCusto 		:= Iif(mv_par13 = 1,.T.,.F.)
lItem		:= Iif(mv_par13 = 2,.T.,.F.)
lCLVL		:= Iif(mv_par13 = 3,.T.,.F.)
lAnalitico	:= Iif(mv_par09 == 1,.T.,.F.)

If nLastKey = 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books -> Conf. da Mascara / Valores   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Ct040Valid(mv_par08)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par08)
EndIf

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par06)
   	If Empty(aCtbMoeda[1])
      	Help(" ",1,"NOMOEDA")
      	lRet := .F.
   	Endif
Endif

If !lRet	
	Set Filter To
	Return
EndIf

If ! lAnalitico
	nTamLinha := 132
	Tamanho	  := "M"	
Endif

SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,aReturn[1]))

If nLastKey = 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| 	CTR410Imp(@lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,;
					lAnalitico,Titulo,nTamlinha,aCtbMoeda)})
Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CTR410Imp ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Impressao do Razao                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³Ctr410Imp(lEnd,wnRel,cString,aSetOfBook,lCusto,lItem,;      ³±±
±±³           ³          lCLVL,Titulo,nTamLinha,aCtbMoeda)                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ lEnd       - A‡ao do Codeblock                             ³±±
±±³           ³ wnRel      - Nome do Relatorio                             ³±±
±±³           ³ cString    - Mensagem                                      ³±±
±±³           ³ aSetOfBook - Array de configuracao set of book             ³±±
±±³           ³ lCusto     - Imprime Centro de Custo?                      ³±±
±±³           ³ lItem      - Imprime Item Contabil?                        ³±±
±±³           ³ lCLVL      - Imprime Classe de Valor?                      ³±± 
±±³           ³ Titulo     - Titulo do Relatorio                           ³±±
±±³           ³ nTamLinha  - Tamanho da linha a ser impressa               ³±± 
±±³           ³ aCtbMoeda  - Moeda                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR410Imp(lEnd,WnRel,cString,aSetOfBook,lCusto,lItem,lCLVL,lAnalitico,Titulo,nTamlinha,;
						aCtbMoeda)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt
Local cbcont
Local Cabec1		:= ""
Local Cabec2		:= ""

Local aSaldo		:= {}
Local aSaldAnt		:= {}
Local aColunas
Local aCtbMd01   	:= CtbMoeda(mv_par05)

Local cDescMoeda
Local cMascara1
Local cMascara2
Local cMascara3
Local cMascara4
Local cPicture
Local cSepara1		:= ""
Local cSepara2		:= ""
Local cSepara3		:= ""
Local cSepara4		:= ""
Local cSaldo		:= mv_par07
Local cContaIni	:= mv_par01
Local cContaFIm	:= mv_par02
Local cCustoIni	:= mv_par15
Local cCustoFim	:= mv_par16
Local cItemIni		:= mv_par17
Local cItemFim		:= mv_par18
Local cCLVLIni		:= mv_par19
Local cCLVLFim		:= mv_par20
Local cContaAnt	:= ""
Local cDescConta	:= ""
Local cCodRes		:= ""
Local cResCC		:= ""
Local cResItem		:= ""
Local cResCLVL		:= ""     
Local cDescSint	:= ""
Local cMoeda		:= mv_par06
Local cContaSint	:= ""
Local cArqTmp
Local cNormal

Local dDataAnt		:= CTOD("  /  /  ")
Local dDataIni		:= mv_par03
Local dDataFim		:= mv_par04

Local lNoMov		:= Iif(mv_par10==1,.T.,.F.)
Local lJunta		:= Iif(mv_par11==1,.T.,.F.)
Local lSalto		:= Iif(mv_par21==1,.T.,.F.)
Local lImpLivro	:= .T.
Local lImpTermos	:= .F.
Local lPrintZero	:= Iif(mv_par28 == 1,.T.,.F.)								

Local nDecimais
Local nSaldoAtu     :=0
Local nSal01Atu     :=0
Local nTotDeb		:= nT01Deb := 0
Local nTotCrd		:= nT01Crd := 0
Local nTotGerDeb	:= nT01GerDeb := 0
Local nTotGerCrd	:= nT01GerCrd := 0
Local nReinicia 	:= mv_par24
Local nPagFim		:= mv_par23
Local l1StQb		:= .T.    
Local nVlrDeb		:= nV01Deb := 0
Local nVlrCrd		:= nV01Crd := 0
Local nCont			:= 0

Local l132 			:= .F.
Local lQbPg			:= .F.
Local nPagIni		:= mv_par22
Local nBloco		:= 0
Local nBlCount		:= 0
Local LIMITE		:= If(TAMANHO=="G",220,If(TAMANHO=="M",132,80))
Local nInutLin		:= 1

m_pag    := 1
CtbQbPg(.T.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb )		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par26==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par26==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par26==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase		

If ! lCusto
	If lItem
		lClVl := .F.
	Endif
Else
	lItem := .F.
	lClVl := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,cMoeda)

// Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1	:= RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf               

If lCusto .Or. lItem .Or. lCLVL
	// Mascara do Centro de Custo
	If Empty(aSetOfBook[6])
		cMascara2 := GetMv("MV_MASCCUS")
	Else
		cMascara2	:= RetMasCtb(aSetOfBook[6],@cSepara2)
	EndIf                                                
	// Mascara do Item Contabil
	If Empty(aSetOfBook[7])
		cMascara3 := ""
	Else
		cMascara3 := RetMasCtb(aSetOfBook[7],@cSepara3)
	EndIf
	// Mascara da Classe de Valor
	If Empty(aSetOfBook[8])
		cMascara4 := ""
	Else
		cMascara4 := RetMasCtb(aSetOfBook[8],@cSepara4)
	EndIf
EndIf	

cPicture 	:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo do Relatorio                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("NewHead")== "U"
	IF lAnalitico
		Titulo	:=	OemToAnsi(STR0007)	//"RAZAO ANALITICO EM MOEDA CORRENTE E "
	Else
		Titulo	:=	OemToAnsi(STR0008)	//"RAZAO SINTETICO EM MOEDA CORRENTE E "
	EndIf
	Titulo += 	cDescMoeda + OemToAnsi(STR0009) + DTOC(dDataIni) +;	// "DE"
				OemToAnsi(STR0010) + DTOC(dDataFim) + CtbTitSaldo(mv_par07)	// "ATE"
Else
	Titulo := NewHead
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Resumido                                  						         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// DATA        DEBITO MOEDAXXXXX  DEBITO REAISXXXXX CREDITO MOEDAXXXXX CREDITO REAISXXXXX SALDO ATUAL REAISXXXXX SALDO ATUAL REAISXXXXX
//            123456789012345678 123456789012345678 123456789012345678 123456789012345678 12345678901234567890   12345678901234567890
// 99/99/9999 999,999,999,999.99 999,999,999,999.99 999,999,999,999.99 999,999,999,999.99 9,999,999,999,999.99 D 9,999,999,999,999.99 X
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//           1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16         17        18        19        20       21        22
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabe‡alho Conta                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// DATA                                                                                                                 
// LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA            CENTRO CUSTO         DEBITO MOEDAXXX TX US$  DEBITO REAISXXX CREDITO MOEDAXX  TX U$  CREDITO REAISXX SALDO ATUAL REAISXX SALDO ATUAL REAISXX
// XX/XX/XXXX                                                                                            123456789012345         123456789012345 123456789012345         123456789012345 12345678901234567 X 12345678901234567 X
// XXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 999999999999.99 00,0000 999999999999.99 999999999999.99 00,0000 999999999999.99 999999999999999.99D 999999999999999.99D
// 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


#DEFINE 	COL_NUMERO 			1
#DEFINE 	COL_HISTORICO		2
#DEFINE 	COL_CONTRA_PARTIDA	3
#DEFINE 	COL_CENTRO_CUSTO 	4
#DEFINE 	COL_ITEM_CONTABIL 	5
#DEFINE 	COL_CLASSE_VALOR  	6 
#DEFINE 	COL_VLR_DEBITO_2	7
#DEFINE 	COL_VLR_DEBITO_TX	8
#DEFINE 	COL_VLR_DEBITO_1	9
#DEFINE 	COL_VLR_CREDITO_2	10
#DEFINE 	COL_VLR_CREDITO_TX	11
#DEFINE 	COL_VLR_CREDITO_1	12
#DEFINE 	COL_VLR_SALDO_2		13
#DEFINE 	COL_VLR_SALDO_1		14
#DEFINE 	TAMANHO_TM       	15
#DEFINE 	COL_VLR_TRANSPORTE  16

If lAnalitico											// Relatorio Analitico
	aColunas := { 	000, 019, 060, 081, 081, 081, 102, 118, 125, 141, 157, 164,;
					181, 201, 015, 102  }
	Cabec1 := OemToAnsi(STR0019)	// "DATA"
	Cabec2 := OemToAnsi(STR0014) 	// "LOTE/SUB/DOC/LINHA H I S T O R I C O                        C/PARTIDA            CENTRO CUSTO         "

	If lCusto
		Cabec2 := Stuff(Cabec2, 082, 20, Left(Upper(CtbSayApro("CTT")) + Space(20),20))
	Endif
	If lItem
		Cabec2 := Stuff(Cabec2, 082, 20, Left(Upper(CtbSayApro("CTD")) + Space(20),20))
	Endif
	If lClVl
		Cabec2 := Stuff(Cabec2, 082, 20, Left(Upper(CtbSayApro("CTH")) + Space(20),20))
	Endif
	
	Cabec2 	+= Padl(Trim(Left(STR0028 + Space(1) + aCtbMoeda[3] + Space(15), 15)), 15)
	Cabec2 	+= Space(1) + "TX " + Left(aCtbMoeda[3] + Space(3), 3) + Space(1)
	Cabec2 	+= Padl(Trim(Left(STR0028 + Space(1) + aCtbMd01[3] + Space(15), 15)), 15)
	
	Cabec2 	+= Space(1) + Padl(Trim(Left(STR0029 + Space(1) + aCtbMoeda[3] + Space(15), 15)), 15)
	Cabec2 	+= Space(1) + "TX " + Left(aCtbMoeda[3] + Space(3), 3) + Space(1)
	Cabec2 	+= Padl(Trim(Left(STR0029 + Space(1) + aCtbMd01[3] + Space(15), 15)), 15)
	       	
	Cabec2 	+= Space(2) + Padl(Trim(Left(STR0030 + Space(1) + aCtbMoeda[3] + Space(19), 19)), 19)
	Cabec2 	+= Space(1) + Padl(Trim(Left(STR0030 + Space(1) + aCtbMd01[3] + Space(19), 19)), 19)
Else                
	l132 	 := .T.
	aColunas := { 	000,    ,    ,    ,    ,    , 011,, 030, 049,, 068, 087, 110,;
					018, 075 }
	lCusto 	:= .F.
	lItem  	:= .F.
	lCLVL  	:= .F.
	Cabec1	:= OemToAnsi(STR0024)	// "DATA       "
	Cabec1 	+= Padl(Trim(Left(STR0028 + Space(1) + aCtbMoeda[3] + Space(18), 18)), 18)
	Cabec1 	+= Space(1) + Padl(Trim(Left(STR0028 + Space(1) + aCtbMd01[3] + Space(18), 18)), 18)
	
	Cabec1 	+= Space(1) + Padl(Trim(Left(STR0029 + Space(1) + aCtbMoeda[3] + Space(18), 18)), 18)
	Cabec1 	+= Space(1) + Padl(Trim(Left(STR0029 + Space(1) + aCtbMd01[3] + Space(18), 18)), 18)
	
	Cabec1	+= Space(1) + Padl(Trim(Left(STR0030 + Space(1) + aCtbMoeda[3] + Space(22), 22)), 22)
	Cabec1 	+= Space(1) + Padl(Trim(Left(STR0030 + Space(1) + aCtbMd01[3] + Space(22), 22)), 22)
EndIf	

m_pag := mv_par22

If lImpLivro  

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Arquivo Temporario para Impressao   					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTBGerRaz(oMeter,oText,oDlg,lEnd,@cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				aSetOfBook,lNoMov,cSaldo,lJunta,"1",lAnalitico,mv_par05,mv_par27)},;
				OemToAnsi(OemToAnsi(STR0018)),;		// "Criando Arquivo Tempor rio..."
				OemToAnsi(STR0006))						// "Emissao do Razao"

	dbSelectArea("cArqTmp")
	SetRegua(RecCount())
	dbGoTop()
Endif

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial 
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. !Empty(aSetOfBook[5])                                       
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())	
	Return
Endif
 

While lImpLivro .And. !Eof()

	IF lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0015)  //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	If lCusto
		aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
		aSaldo	  := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)		
	ElseIf lItem
		aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
		aSaldo	  := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)			
	ElseIf lClVl
		aSaldoAnt := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,cMoeda,cSaldo)
		aSaldo	  := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)
	Else	
 	// 08/08/18 - Luis Felipe - INICIO
	//	aSaldoAnt	:= SaldoCT7(cArqTmp->CONTA,dDataIni,cMoeda,cSaldo,"CTBR400")
	If	Empty(MV_PAR29) 
		_cQryFil := '0101'
	Else
		_cQryFil := MV_PAR29
	EndIf
	nSaldoAtu := 0   
	While _cQryFil <= MV_PAR30 
//	 	lLanc := FLanCt2(_cQryFil,cArqTmp->CONTA)
//        If lLanc
			aSaldoAnt := SaldoCQ("CT1",cArqTmp->CONTA,"","","","",dDataIni,"02",cSaldo,"",.f.,,_cQryFil)
			nSaldoAtu += aSaldoAnt[1]
//		EndIf	
		_cQryFil  := Soma1(_cQryFil)
	End
    // 08/08/18 - Luis Felipe - FIM   
		aSaldo 		:= SaldoCT7(cArqTmp->CONTA,cArqTmp->DATAL,cMoeda,cSaldo)
	EndIf
	
	If !lNoMov //Se imprime conta sem movimento
		If aSaldo[6] == 0 .And.	cArqTmp->LANCDEB + cArqTmp->LANCDEB_1 ==0 .And.;
								cArqTmp->LANCCRD + cArqTmp->LANCCRD_1 == 0 
			dbSelectArea("cArqTmp")
			dbSkip()
			Loop
		Endif	
	Endif             
	
	If lNomov .And. (aSaldo[6] == 0 .And.	cArqTmp->LANCDEB + cArqTmp->LANCDEB_1 ==0 .And.;
								cArqTmp->LANCCRD + cArqTmp->LANCCRD_1 == 0) 
		If CtbExDtFim("CT1") 			
			dbSelectArea("CT1") 
			dbSetOrder(1) 
			If MsSeek(xFilial()+cArqTmp->CONTA)
				If !CtbVlDtFim("CT1",dDataIni) 		
					dbSelectArea("cArqTmp")
					dbSkip()
					Loop								
	            EndIf
		    EndIf
		    dbSelectArea("cArqTmp")
		EndIf
	EndIf
	

	If li > 56 .Or. lSalto              
		CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
		CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
	EndiF
//	nSaldoAtu	:= 0
	nSal01Atu	:= 0
	nT01Deb		:= 0
	nTotDeb		:= 0
	nT01Crd		:= 0
	nTotCrd		:= 0
                              
	// IMPRIME A CONTA
	
	// Conta Sintetica	
	cContaSint := Ctr400Sint(cArqTmp->CONTA,@cDescSint,cMoeda,@cDescConta,@cCodRes)
	cNormal := CT1->CT1_NORMAL
	EntidadeCTB(cContaSint,li,001,Len(cContaSint),.F.,cMascara1,cSepara1) 
	@li,5+Len(cContaSint) PSAY " - " + cDescSint
	li+=2
	
	// Conta Analitica


	@li,011 PSAY OemToAnsi(STR0016) 	//"CONTA - "

	If mv_par12 == 1							// Imprime Cod Normal
		EntidadeCTB(cArqTmp->CONTA,li,20,Len(cArqTmp->CONTA),.F.,cMascara1,cSepara1)
	Else
		EntidadeCTB(cCodRes,li,20,20,.F.,cMascara1,cSepara1)
	EndIf
	@ li,20+Len(cArqTmp->CONTA) PSAY "- " + cDescConta
	
	// Impressao do Saldo Anterior do Centro de Custo
    /* 08/08/18 - Luis Felipe - INICIO
	ValorCTB(aSaldoAnt[6],li,aColunas[COL_VLR_SALDO_2],aColunas[TAMANHO_TM]+2,nDecimais,.T.,cPicture,cNormal)
	nSaldoAtu := aSaldoAnt[6]
    */
	ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO_2],aColunas[TAMANHO_TM]+2,nDecimais,.T.,cPicture,cNormal)
//	nSal01Atu := nSaldoAtu  // aqui
	// nSaldoAtu := aSaldoAnt[1]
    // 08/08/18 - Luis Felipe - FIM

	// Valor da Moeda 01
	If lCusto
		aSaldoAnt := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,mv_par05,cSaldo)
		aSaldo	  := SaldTotCT3(cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,mv_par05,cSaldo)		
	ElseIf lItem
		aSaldoAnt := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,mv_par05,cSaldo)
		aSaldo	  := SaldTotCT4(cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,mv_par05,cSaldo)			
	ElseIf lClVl
		aSaldoAnt := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,dDataIni,mv_par05,cSaldo)
		aSaldo	  := SaldTotCTI(cClVlIni,cClVlFim,cItemIni,cItemFim,cCustoIni,cCustoFim,cArqTmp->CONTA,cArqTmp->CONTA,cArqTmp->DATAL,mv_par05,cSaldo)
	Else		
    // 08/08/18 - Luis Felipe - INICIO
	//	aSaldoAnt2  := SaldoCQ("CT1",cArqTmp->CONTA,cCCusto,cItem,cClasse,cIdent,dDataIni,cMoeda,cSaldo,cRotina,lImpAntLP,dDataLP,cFilEsp,lUltDtVl)
		If	Empty(MV_PAR29) 
			_cQryFil := '0101'
		Else
			_cQryFil := MV_PAR29
		EndIf   
		While _cQryFil <= MV_PAR30
//		 	lLanc := FLanCt2(_cQryFil,cArqTmp->CONTA)
//			If lLanc
				aSaldoAnt := SaldoCQ("CT1",cArqTmp->CONTA,"","","","",dDataIni,"01",cSaldo,"",.f.,,_cQryFil)
				nSal01Atu += aSaldoAnt[1] // nSaldoAtu
//			EndIf	
			_cQryFil  := Soma1(_cQryFil)
		End
    //	aSaldoAnt:= SaldoCT7(cArqTmp->CONTA,dDataIni,mv_par05,cSaldo,"CTBR400")
    // 08/08/18 - Luis Felipe - FIM
		aSaldo 	 := SaldoCT7(cArqTmp->CONTA,cArqTmp->DATAL,mv_par05,cSaldo)              
	EndIf
    /* 08/08/18 - Luis Felipe - INICIO
    ValorCTB(aSaldoAnt[6],li,aColunas[COL_VLR_SALDO_1],aColunas[TAMANHO_TM]+2,nDecimais,.T.,cPicture,cNormal)
	nSal01Atu := aSaldoAnt[6]
    */

	ValorCTB(nSal01Atu,li,aColunas[COL_VLR_SALDO_1],aColunas[TAMANHO_TM]+2,nDecimais,.T.,cPicture,cNormal)  // nSaldoAtu
//	nSal01Atu := nSaldoAtu // aSaldoAnt[1]
    // 08/08/18 - Luis Felipe - FIM
    
	li += 2         
	dbSelectArea("cArqTmp")
	cContaAnt	:= cArqTmp->CONTA
	dDataAnt	:= CTOD("  /  /  ")
	While !Eof() .And. cArqTmp->CONTA == cContaAnt
	
		If li > 56
			li++
			
			@li,aColunas[COL_VLR_TRANSPORTE] - Len(OemToAnsi(STR0022)) - 1;
						 PSAY OemToAnsi(STR0022)	//"A TRANSPORTAR : "
			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO_2],;
								   aColunas[TAMANHO_TM]+2,nDecimais, .T.,cPicture,cNormal)

// Valor da Moeda 1

			ValorCTB(nSal01Atu,li,aColunas[COL_VLR_SALDO_1],;
								   aColunas[TAMANHO_TM]+2,nDecimais, .T.,cPicture,cNormal)
			
			CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
			CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
			lQbPg := .T.
			
			@li,aColunas[COL_VLR_TRANSPORTE] - Len(OemToAnsi(STR0023)) - 1;
						 PSAY OemToAnsi(STR0023)	//"A TRANSPORTAR : "
			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO_2],;
								   aColunas[TAMANHO_TM]+2,nDecimais, .T.,cPicture,cNormal)

// Valor da Moeda 1

			ValorCTB(nSal01Atu,li,aColunas[COL_VLR_SALDO_1],;
								   aColunas[TAMANHO_TM]+2,nDecimais, .T.,cPicture,cNormal)
			li++
		EndIf
	
		// Imprime os lancamentos para a conta                          
		If dDataAnt != cArqTmp->DATAL
//			If (cArqTmp->LANCDEB <> 0 .Or. cArqTmp->LANCCRD <> 0) 
				If lAnalitico
					@li,000 PSAY cArqTmp->DATAL
					li++                       
				Else
					@li,000 PSAY cArqTmp->DATAL
				Endif		
//			Endif	
			dDataAnt := cArqTmp->DATAL	
		ElseIf lQbPg
			@li,000 PSAY dDataAnt
			li++
			lQbPg := .F.
		EndIf	
		
		If lAnalitico		//Se for relatorio analitico
			nSaldoAtu 	:= nSaldoAtu - cArqTmp->LANCDEB + cArqTmp->LANCCRD      

// Valor da Moeda 01
			
			nSal01Atu 	:= nSal01Atu - cArqTmp->LANCDEB_1 + cArqTmp->LANCCRD_1
			nTotDeb		+= cArqTmp->LANCDEB
			nT01Deb		+= cArqTmp->LANCDEB_1
			nTotCrd		+= cArqTmp->LANCCRD
			nT01Crd		+= cArqTmp->LANCCRD_1

			nTotGerDeb	+= cArqTmp->LANCDEB
			nT01GerDeb	+= cArqTmp->LANCDEB_1
			nTotGerCrd	+= cArqTmp->LANCCRD
			nT01GerCrd	+= cArqTmp->LANCCRD_1
			
			dbSelectArea("CT1")
			dbSetOrder(1)
			dbSeek(xFilial()+cArqTmp->XPARTIDA)
			cCodRes := CT1->CT1_RES
			dbSelectArea("cArqTmp")

			@li,aColunas[COL_NUMERO] PSAY cArqTmp->LOTE+cArqTmp->SUBLOTE+;
										   cArqTmp->DOC+cArqTmp->LINHA
			@li,aColunas[COL_HISTORICO] PSAY Subs(cArqTmp->HISTORICO,1,40)                        
			dbSelectArea("CT1")
			dbSetOrder(1)
			dbSeek(xFilial()+cArqTmp->XPARTIDA)
			cCodRes := CT1->CT1_RES
			dbSelectArea("cArqTmp")

			If mv_par12 == 1
				EntidadeCTB(cArqTmp->XPARTIDA,li,aColunas[COL_CONTRA_PARTIDA],;
							20,.F.,cMascara1,cSepara1)
			Else
				EntidadeCTB(cCodRes,li,aColunas[COL_CONTRA_PARTIDA],20,.F.,;
							cMascara1,cSepara1)				
			Endif                              

			If lCusto
				If mv_par14 == 1 //Imprime Cod. Centro de Custo Normal 
					EntidadeCTB(cArqTmp->CCUSTO,li,aColunas[COL_CENTRO_CUSTO],20,.F.,cMascara2,cSepara2)
				Else 
					dbSelectArea("CTT")
					dbSetOrder(1)
					dbSeek(xFilial()+cArqTmp->CCUSTO)				
					cResCC := CTT->CTT_RES
					EntidadeCTB(cResCC,li,aColunas[COL_CENTRO_CUSTO],20,.F.,cMascara2,cSepara2)
					dbSelectArea("cArqTmp")
				Endif                                                       
			Endif

			If lItem 						//Se imprime item 
				If mv_par14 == 1 //Imprime Codigo Normal Item Contabl
					EntidadeCTB(cArqTmp->ITEM,li,aColunas[COL_ITEM_CONTABIL],20,.F.,cMascara3,cSepara3)
				Else
					dbSelectArea("CTD")
					dbSetOrder(1)
					dbSeek(xFilial()+cArqTmp->ITEM)				
					cResItem := CTD->CTD_RES
					EntidadeCTB(cResItem,li,aColunas[COL_ITEM_CONTABIL],20,.F.,cMascara3,cSepara3)						
					dbSelectArea("cArqTmp")					
				Endif
			Endif
				
			If lCLVL						//Se imprime classe de valor
				If mv_par14 == 1 //Imprime Cod. Normal Classe de Valor
					EntidadeCTB(cArqTmp->CLVL,li,aColunas[COL_CLASSE_VALOR],20,.F.,cMascara4,cSepara4)
				Else
					dbSelectArea("CTH")
					dbSetOrder(1)
					dbSeek(xFilial()+cArqTmp->CLVL)				
					cResClVl := CTH->CTH_RES						
					EntidadeCTB(cResClVl,li,aColunas[COL_CLASSE_VALOR],20,.F.,cMascara4,cSepara4)
					dbSelectArea("cArqTmp")					
				Endif			
			Endif
			
			ValorCTB(cArqTmp->LANCDEB,li,aColunas[COL_VLR_DEBITO_2],;
										  aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,cNormal, , , , , ,lPrintZero)
			@li,aColunas[COL_VLR_DEBITO_TX] PSAY Trans(cArqTmp->TXDEBITO, "@Z 9.9999")

// Valor da Moeda 01
			ValorCTB(cArqTmp->LANCDEB_1,li,aColunas[COL_VLR_DEBITO_1],;
										  	aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,cNormal, , , , , ,lPrintZero)
										  
			ValorCTB(cArqTmp->LANCCRD,li,aColunas[COL_VLR_CREDITO_2],;
										  aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,cNormal, , , , , ,lPrintZero)
			@li,aColunas[COL_VLR_CREDITO_TX] PSAY Trans(cArqTmp->TXCREDITO, "@Z 9.9999")

// Valor da Moeda 01
			ValorCTB(cArqTmp->LANCCRD_1,li,aColunas[COL_VLR_CREDITO_1],;
										  	aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,cNormal, , , , , ,lPrintZero)

			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO_2],;
								   aColunas[TAMANHO_TM]+2,nDecimais,.T.,cPicture,cNormal)
// Valor da Moeda 01
			ValorCTB(nSal01Atu,li,aColunas[COL_VLR_SALDO_1],;
								   aColunas[TAMANHO_TM]+2,nDecimais,.T.,cPicture,cNormal)

			// Procura pelo complemento de historico
			dbSelectArea("CT2")
			dbSetOrder(10)
			If dbSeek(xFilial("CT2")+cArqTMP->(DTOS(DATAL)+LOTE+SUBLOTE+DOC+SEQLAN+EMPORI+FILORI),.F.)
				dbSkip()
				If CT2->CT2_DC == "4"
					While !Eof() .And. CT2->CT2_FILIAL == xFilial() 			.And.;
										CT2->CT2_LOTE == cArqTMP->LOTE 		.And.;
										CT2->CT2_SBLOTE == cArqTMP->SUBLOTE 	.And.;
										CT2->CT2_DOC == cArqTmp->DOC 			.And.;
										CT2->CT2_SEQLAN == cArqTmp->SEQLAN 	.And.;
										CT2->CT2_EMPORI == cArqTmp->EMPORI	.And.;
										CT2->CT2_FILORI == cArqTmp->FILORI	.And.;
										CT2->CT2_DC == "4" 					.And.;
								   DTOS(CT2->CT2_DATA) == DTOS(cArqTmp->DATAL)                        
						li++
						If li > 56
							CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
							CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
							li++
							@li,000 PSAY dDataAnt
							li++
						EndIf						
						@li,aColunas[COL_NUMERO] 	PSAY CT2->(CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA)
						@li,aColunas[COL_HISTORICO] PSAY Subs(CT2->CT2_HIST,1,40)
						dbSkip()
					EndDo	
				EndIf	
			EndIf	
			dbSelectArea("cArqTmp")
			dbSkip()			
		Else		// Se for resumido.                               			
			While dDataAnt == cArqTmp->DATAL .And. cContaAnt == cArqTmp->CONTA
				nVlrDeb	+= cArqTmp->LANCDEB
				nV01Deb	+= cArqTmp->LANCDEB_1
				nVlrCrd	+= cArqTmp->LANCCRD
				nV01Crd	+= cArqTmp->LANCCRD_1

				nTotGerDeb	+= cArqTmp->LANCDEB
				nTotGerCrd	+= cArqTmp->LANCCRD
				nT01GerDeb	+= cArqTmp->LANCDEB_1
				nT01GerCrd	+= cArqTmp->LANCCRD_1
				dbSkip()                                                                    				
			End			                                                                    
			nSaldoAtu := nSaldoAtu - nVlrDeb + nVlrCrd
			nSal01Atu := nSal01Atu - nV01Deb + nV01Crd

			ValorCTB(nVlrDeb,li,aColunas[COL_VLR_DEBITO_2],aColunas[TAMANHO_TM],;
					 nDecimais,.F.,cPicture,cNormal, , , , , ,lPrintZero)
			ValorCTB(nV01Deb,li,aColunas[COL_VLR_DEBITO_1],aColunas[TAMANHO_TM],;
					 nDecimais,.F.,cPicture,cNormal, , , , , ,lPrintZero)

			ValorCTB(nVlrCrd,li,aColunas[COL_VLR_CREDITO_2],aColunas[TAMANHO_TM],;
					 nDecimais,.F.,cPicture,cNormal, , , , , ,lPrintZero)
			ValorCTB(nV01Crd,li,aColunas[COL_VLR_CREDITO_1],aColunas[TAMANHO_TM],;
					 nDecimais,.F.,cPicture,cNormal, , , , , ,lPrintZero)

			ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO_2],aColunas[TAMANHO_TM]+2,;
					 nDecimais,.T.,cPicture,cNormal)
			ValorCTB(nSal01Atu,li,aColunas[COL_VLR_SALDO_1],aColunas[TAMANHO_TM]+2,;
					 nDecimais,.T.,cPicture,cNormal)
			nTotDeb		+= nVlrDeb
			nTotCrd		+= nVlrCrd         
			nT01Deb		+= nV01Deb
			nT01Crd		+= nV01Crd         
			nVlrDeb		:= 0
			nVlrCrd		:= 0
			nV01Deb		:= 0
			nV01Crd		:= 0
		Endif
		dbSelectArea("cArqTmp")
		//dbSkip()  
		li++
	EndDo

    li+=2
	If li > 56
		li++
		@li,aColunas[COL_VLR_TRANSPORTE] - Len(OemToAnsi(STR0022)) - 1;
					 PSAY OemToAnsi(STR0022)	//"A TRANSPORTAR : "
		ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO_2],;
							   aColunas[TAMANHO_TM]+2,nDecimais, .T.,cPicture,cNormal)
		ValorCTB(nSal01Atu,li,aColunas[COL_VLR_SALDO_1],;
							   aColunas[TAMANHO_TM]+2,nDecimais, .T.,cPicture,cNormal)
		           
		CtbQbPg(.F.,@nPagIni,@nPagFim,@nReinicia,@m_pag,@nBloco,@nBlCount,@l1StQb)		/// FUNCAO PARA TRATAMENTO DA QUEBRA //.T. INICIALIZA VARIAVEIS
		CtCGCCabec(lItem,lCusto,lCLVL,Cabec1,Cabec2,dDataFim,Titulo,lAnalitico,"1",Tamanho)
		
		@li,aColunas[COL_VLR_TRANSPORTE] - Len(OemToAnsi(STR0023)) - 1;
					 PSAY OemToAnsi(STR0023)	//"A TRANSPORTAR : "
		ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO_2],;
							   aColunas[TAMANHO_TM]+2,nDecimais, .T.,cPicture,cNormal)
		ValorCTB(nSal01Atu,li,aColunas[COL_VLR_SALDO_1],;
							   aColunas[TAMANHO_TM]+2,nDecimais, .T.,cPicture,cNormal)
		li++
    EndIf
    
	If l132
  		@li,000 PSAY OemToAnsi(STR0026)  //"Tot.Conta"
	Else
		@li,aColunas[COL_HISTORICO] PSAY OemToAnsi(STR0020)  //"T o t a i s  d a  C o n t a  ==> "
	Endif			

	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO_2],aColunas[TAMANHO_TM],nDecimais,;
			 .F.,cPicture,cNormal, , , , , ,lPrintZero)
// Valor da Moeda 01
	ValorCTB(nT01Deb,li,aColunas[COL_VLR_DEBITO_1],aColunas[TAMANHO_TM],nDecimais,;
			 .F.,cPicture,cNormal, , , , , ,lPrintZero)

	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO_2],aColunas[TAMANHO_TM],nDecimais,;
			 .F.,cPicture,cNormal, , , , , ,lPrintZero)
// Valor da Moeda 01
	ValorCTB(nT01Crd,li,aColunas[COL_VLR_CREDITO_1],aColunas[TAMANHO_TM],nDecimais,;
			 .F.,cPicture,cNormal, , , , , ,lPrintZero)

	ValorCTB(nSaldoAtu,li,aColunas[COL_VLR_SALDO_2],aColunas[TAMANHO_TM]+2,nDecimais,;
			 .T.,cPicture,cNormal, , , , , ,lPrintZero)
// Valor da Moeda 01
	ValorCTB(nSal01Atu,li,aColunas[COL_VLR_SALDO_1],aColunas[TAMANHO_TM]+2,nDecimais,;
			 .T.,cPicture,cNormal, , , , , ,lPrintZero)
    
	li++
	@li, 00 PSAY Replicate("-",nTamLinha)
	li++

EndDo	 
          
If li != 80 .And. lImpLivro .And. mv_par25 == 1	//Imprime total Geral
	If l132
	    @li, 00 PSAY OemToAnsi(STR0027)  //"TOT.GERAL"
	Else
	    @li, 30 PSAY OemToAnsi(STR0025)  //"T O T A L  G E R A L  ==> "
	Endif

	ValorCTB(nTotGerDeb,li,aColunas[COL_VLR_DEBITO_2],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
// Valor da Moeda 01
	ValorCTB(nT01GerDeb,li,aColunas[COL_VLR_DEBITO_1],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)

	ValorCTB(nTotGerCrd,li,aColunas[COL_VLR_CREDITO_2],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
// Valor da Moeda 01
	ValorCTB(nT01GerCrd,li,aColunas[COL_VLR_CREDITO_1],aColunas[TAMANHO_TM],nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)

	li++
	@li, 00 PSAY Replicate("-",nTamLinha)
	li+=2		
Endif

nLinAst := GetNewPar("MV_INUTLIN",0)
If li < 56 .and. nLinAst <> 0 .and. !lEnd
	For nInutLin := 1 to nLinAst
		li++
		@li,00 PSAY REPLICATE("*",LIMITE)	
		If li == 56
			Exit
		EndIf
	Next
EndIf

If li <= 56 .and. !lEnd .and. !lImpTermos
	Roda(cbCont,cbTxt,Tamanho)
EndIf

If lImpTermos 							// Impressao dos Termos

	cArqAbert:=GetNewPar("MV_LRAZABE","")
	cArqEncer:=GetNewPar("MV_LRAZENC","")
	
    If Empty(cArqAbert)
		ApMsgAlert(	"Devem ser criados os parametros MV_LRAZABE e MV_LRAZENC. " +;
					"Utilize como base MV_LDIARAB.")
	Endif
Endif

If lImpTermos .And. ! Empty(cArqAbert)	// Impressao dos Termos

	dbSelectArea("SM0")
	aVariaveis:={}

	For nCont:=1 to FCount()	
		If FieldName(nCont)=="M0_CGC"
			AADD(aVariaveis,{FieldName(nCont),Transform(FieldGet(nCont),"@R 99.999.999/9999-99")})
		Else
            If FieldName(nCont)=="M0_NOME"
                Loop
            EndIf
			AADD(aVariaveis,{FieldName(nCont),FieldGet(nCont)})
		Endif
	Next
	
	oFwSX1Util := FwSX1Util():New()
	oFwSX1Util:AddGroup("CTR410")
	oFwSX1Util:SearchGroup()
	aPergunte := oFwSX1Util:GetGroup("CTR410")
	If Len(aPergunte) >= 2
		For nx := 1 to Len (aPergunte[2])
			AADD(aVariaveis,{Rtrim(Upper(aPergunte[2,nx]:CX1_VAR01)),&(aPergunte[2,nx]:CX1_VAR01)})
		Next nx
	Endif

	If !File(cArqAbert)
		aSavSet:=__SetSets()
		cArqAbert:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If !File(cArqEncer)
		aSavSet:=__SetSets()
		cArqEncer:=CFGX024(,"Razão") // Editor de Termos de Livros
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	Endif

	If cArqAbert#NIL
		ImpTerm(cArqAbert,aVariaveis,AvalImp(132))
	Endif

	If cArqEncer#NIL
		ImpTerm(cArqEncer,aVariaveis,AvalImp(132))
	Endif	 
Endif

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
End

If lImpLivro

	dbSelectArea("cArqTmp")
	Set Filter To
	dbCloseArea()
	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())
	EndIf	

EndIf
dbselectArea("CT2")

MS_FLUSH()

// 03/11/15 Luis Felipe  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGerRaz ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Cria Arquivo Temporario para imprimir o Razao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe   ³CtbGerRaz(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim³±±
±±³			  ³cCustoIni,cCustoFim,cItemIni,cItemFim,cCLVLIni,cCLVLFim,    ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo,lAnalit)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nome do arquivo temporario                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC1 = Arquivo temporario                                 ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ ExpL4 = Indica se imprime analitico ou sintetico           ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGerRaz(oMeter,oText,oDlg,lEnd,cArqTmp,cContaIni,cContaFim,cCustoIni,cCustoFim,;
						cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
						aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,lAnalit,c2Moeda,;
						nTipo,cUFilter,lSldAnt,aSelFil,lExterno)

Local aTamConta	:= TAMSX3("CT1_CONTA")
Local aTamCusto	:= TAMSX3("CT3_CUSTO") 
Local aTamVal	:= TAMSX3("CT2_VALOR")
Local aCtbMoeda	:= {}
Local aSaveArea := GetArea()                       
Local aCampos
Local cChave
Local nTamHist	:= Len(CriaVar("CT2_HIST"))
Local nTamItem	:= Len(CriaVar("CTD_ITEM"))
Local nTamCLVL	:= Len(CriaVar("CTH_CLVL"))
Local nDecimais	:= 0    
Local cMensagem		:= STR0030// O plano gerencial nao esta disponivel nesse relatorio. 
Local lCriaInd := .F.
//Local nTamFilial 	:= IIf( lFWCodFil, FWGETTAMFILIAL, TamSx3( "CT2_FILIAL" )[1] )
Local nTamFilial 	:= TamSx3( "CT2_FILIAL" )[1] // 03/11/15 - Luis Felipe

DEFAULT c2Moeda := ""
DEFAULT nTipo	:= 1
DEFAULT cUFilter:= ""
DEFAULT lSldAnt	:= .F.
DEFAULT aSelFil := {}   
DEFAULT lExterno := .F.

#IFDEF TOP
If TcSrvType() != "AS/400" .And. cTipo == "1" .And. FunName() == 'CTBR400' .And. TCGetDb() $ "MSSQL7/MSSQL"		
	DEFAULT cUFilter	:= ".T."		
Else
#ENDIF

DEFAULT cUFilter	:= ""

#IFDEF TOP
Endif
#ENDIF

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]
                
aCampos :={	{ "CONTA"		, "C", aTamConta[1], 0 },;  		// Codigo da Conta
			{ "XPARTIDA"   	, "C", aTamConta[1] , 0 },;		// Contra Partida
			{ "TIPO"       	, "C", 01			, 0 },;			// Tipo do Registro (Debito/Credito/Continuacao)
			{ "LANCDEB"		, "N", aTamVal[1]+2, nDecimais },; // Debito
			{ "LANCCRD"		, "N", aTamVal[1]+2	, nDecimais },; // Credito
			{ "SALDOSCR"	, "N", aTamVal[1]+2, nDecimais },; 			// Saldo
			{ "TPSLDANT"	, "C", 01, 0 },; 					// Sinal do Saldo Anterior => Consulta Razao
			{ "TPSLDATU"	, "C", 01, 0 },; 					// Sinal do Saldo Atual => Consulta Razao			
			{ "HISTORICO"	, "C", nTamHist   	, 0 },;			// Historico
			{ "CCUSTO"		, "C", aTamCusto[1], 0 },;			// Centro de Custo
			{ "ITEM"		, "C", nTamItem		, 0 },;			// Item Contabil
			{ "CLVL"		, "C", nTamCLVL		, 0 },;			// Classe de Valor
			{ "DATAL"		, "D", 10			, 0 },;			// Data do Lancamento
			{ "LOTE" 		, "C", 06			, 0 },;			// Lote
			{ "SUBLOTE" 	, "C", 03			, 0 },;			// Sub-Lote
			{ "DOC" 		, "C", 06			, 0 },;			// Documento
			{ "LINHA"		, "C", 03			, 0 },;			// Linha
			{ "SEQLAN"		, "C", 03			, 0 },;			// Sequencia do Lancamento
			{ "SEQHIST"		, "C", 03			, 0 },;			// Seq do Historico
			{ "EMPORI"		, "C", 02			, 0 },;			// Empresa Original
			{ "FILORI"		, "C", nTamFilial	, 0 },;			// Filial Original
			{ "NOMOV"		, "L", 01			, 0 },;			// Conta Sem Movimento
			{ "FILIAL"		, "C", nTamFilial	, 0 }} // Filial do sistema

If cPaisLoc $ "CHI|ARG"
	Aadd(aCampos,{"SEGOFI","C",TamSx3("CT2_SEGOFI")[1],0})
EndIf
If ! Empty(c2Moeda)
	Aadd(aCampos, { "LANCDEB_1"	, "N", aTamVal[1]+2, nDecimais }) // Debito
	Aadd(aCampos, { "LANCCRD_1"	, "N", aTamVal[1]+2, nDecimais }) // Credito
	Aadd(aCampos, { "TXDEBITO"	, "N", aTamVal[1]+2, 6 }) // Taxa Debito
	Aadd(aCampos, { "TXCREDITO"	, "N", aTamVal[1]+2, 6 }) // Taxa Credito
Endif
																	
// Se o arquivo temporario de trabalho esta aberto
If ( Select ( "cArqTmp" ) > 0 )
	cArqTmp->(dbCloseArea())
EndIf

oAliasTrb:= FwTemporarytable():New("cArqTmp",aCampos)
oAliasTrb:Create()
lCriaInd := .T.

DbSelectArea("cArqTmp")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "1"			// Razao por Conta
    If FunName() <> "CTBC400"
		cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Else
		cChave   := "CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
	EndIf
ElseIf cTipo == "2"		// Razao por Centro de Custo                   
	If lAnalit 				// Se o relatorio for analitico
		If FunName() <> "CTBC440"
			If FunName() <> "CTBR440"
				cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
			Else
				cChave 	:= "FILIAL+CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
			EndIf
		Else
			cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"		
		EndIf
	Else    
		If FunName() <> "CTBR440"
	   		cChave 	:= "CCUSTO+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
        Else                                                      
			cChave 	:= "FILIAL+CCUSTO+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		EndIf
	Endif
ElseIf cTipo == "3" 		//Razao por Item Contabil      
	If lAnalit 				// Se o relatorio for analitico               
		If FunName() <> "CTBC480"
			cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave 	:= "ITEM+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"		
		Endif
	Else                                                                  
		cChave 	:= "ITEM+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif
ElseIf cTipo == "4"		//Razao por Classe de Valor	
	If lAnalit 				// Se o relatorio for analitico               
		If FunName() <> "CTBC490"	
			cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
		Else
			cChave 	:= "CLVL+CONTA+DTOS(DATAL)+LOTE+SUBLOTE+DOC+EMPORI+FILORI+LINHA"
		EndIf
	Else                                                                  
		cChave 	:= "CLVL+DTOS(DATAL)+LOTE+SUBLOTE+DOC+LINHA+EMPORI+FILORI"
	Endif	
EndIf

dbSelectArea("cArqTmp")

If lCriaInd
	IndRegua("cArqTmp",cArqTmp,cChave,,,STR0017)  //"Selecionando Registros..."
	dbSelectArea("cArqTmp")
	dbSetIndex(cArqTmp+OrdBagExt())
Endif	
dbSetOrder(1)
                                                                                        
If !Empty(aSetOfBook[5])
	MsgAlert(cMensagem)	
	Return
EndIf                   

//CT2->(dbGotop())
#IFDEF TOP
	If TcSrvType() != "AS/400" .And. cTipo == "1" .And. FunName() == 'CTBR400' .And. TCGetDb() $ "MSSQL7/MSSQL"		
		CtbQryRaz(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
				cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
				aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,cUFilter,lSldAnt,aSelFil,lExterno)	
	Else
#ENDIF
	// Monta Arquivo para gerar o Razao
	CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
			cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
			aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt,aSelFil,lExterno)
#IFDEF TOP
	EndIf
#ENDIF	

RestArea(aSaveArea)

Return cArqTmp

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbRazao  ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Realiza a "filtragem" dos registros do Razao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,		   ³±±
±±³			  ³cCustoIni,cCustoFim, cItemIni,cItemFim,cCLVLIni,cCLVLFim,   ³±±
±±³			  ³cMoeda,dDataIni,dDataFim,aSetOfBook,lNoMov,cSaldo,lJunta,   ³±±
±±³			  ³cTipo)                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpO1 = Objeto oMeter                                      ³±±
±±³           ³ ExpO2 = Objeto oText                                       ³±±
±±³           ³ ExpO3 = Objeto oDlg                                        ³±±
±±³           ³ ExpL1 = Acao do Codeblock                                  ³±±
±±³           ³ ExpC2 = Conta Inicial                                      ³±±
±±³           ³ ExpC3 = Conta Final                                        ³±±
±±³           ³ ExpC4 = C.Custo Inicial                                    ³±±
±±³           ³ ExpC5 = C.Custo Final                                      ³±±
±±³           ³ ExpC6 = Item Inicial                                       ³±±
±±³           ³ ExpC7 = Cl.Valor Inicial                                   ³±±
±±³           ³ ExpC8 = Cl.Valor Final                                     ³±±
±±³           ³ ExpC9 = Moeda                                              ³±±
±±³           ³ ExpD1 = Data Inicial                                       ³±±
±±³           ³ ExpD2 = Data Final                                         ³±±
±±³           ³ ExpA1 = Matriz aSetOfBook                                  ³±±
±±³           ³ ExpL2 = Indica se imprime movimento zerado ou nao.         ³±±
±±³           ³ ExpC10= Tipo de Saldo                                      ³±±
±±³           ³ ExpL3 = Indica se junta CC ou nao.                         ³±±
±±³           ³ ExpC11= Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cUFilter= Conteudo Txt com o Filtro de Usuario (CT2)       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbRazao(oMeter,oText,oDlg,lEnd,cContaIni,cContaFim,cCustoIni,cCustoFim,;
					  	cItemIni,cItemFim,cCLVLIni,cCLVLFim,cMoeda,dDataIni,dDataFim,;
					  	aSetOfBook,lNoMov,cSaldo,lJunta,cTipo,c2Moeda,nTipo,cUFilter,lSldAnt,aSelFil,lExterno)

Local cCpoChave	:= ""
Local cTmpChave	:= ""
Local cContaI	:= ""
Local cContaF	:= ""
Local cCustoI	:= ""
Local cCustoF	:= ""
Local cItemI	:= ""
Local cItemF	:= ""
Local cClVlI	:= ""
Local cClVlF	:= ""
Local cVldEnt	:= ""
Local cAlias	:= ""
Local lUFilter	:= !Empty(cUFilter)			//// SE O FILTRO DE USUÁRIO NÃO ESTIVER VAZIO - TEM FILTRO DE USUÁRIO
Local cFilMoeda	:= "" 							
Local cAliasCT2	:= "CT2"	
Local bCond		:= {||.T.}
Local cQryFil	:= '' // variavel de condicional da query
Local cTmpCT2Fil

#IFDEF TOP
	Local cQuery	:= ""
	Local cOrderBy	:= ""
	Local nI	:= 0
	Local aStru	:= {}
#ENDIF

DEFAULT cUFilter := ".T."
DEFAULT lSldAnt	 := .F.
DEFAULT aSelFil  := {}      
DEFAULT lExterno := .F.

// cQryFil := " CT2_FILIAL " + GetRngFil( aSelFil ,"CT2", .T., @cTmpCT2Fil) // Filtro do Usuário - 03/11/2015 - Luis Felipe   
cQryFil	:= "CT2_FILORI >= '"+MV_PAR29+"' AND CT2_FILORI <= '"+MV_PAR30+"'" 

cCustoI	:= CCUSTOINI
cCustoF := CCUSTOFIM
cContaI	:= CCONTAINI
cContaF := CCONTAFIM
cItemI	:= CITEMINI      
cItemF 	:= CITEMFIM
cClvlI	:= CCLVLINI
cClVlF 	:= CCLVLFIM

#IFDEF TOP
	If TcSrvType() != "AS/400"
		If !Empty(c2Moeda) 			
			cFilMoeda	:= " (CT2_MOEDLC = '" + cMoeda + "' OR "		
			cFilMoeda	+= " CT2_MOEDLC = '" + c2Moeda + "') " 			
		Else
			cFilMoeda	:= " CT2_MOEDLC = '" + cMoeda + "' "				
		EndIf
	Else
#ENDIF 
	If !Empty(c2Moeda) 			
		cFilMoeda	:= " (CT2_MOEDLC = '" + cMoeda + "' .Or. "		
		cFilMoeda	+= " CT2_MOEDLC = '" + c2Moeda + "') " 			
	Else
		cFilMoeda	:= " CT2_MOEDLC = '" + cMoeda + "' "				
	EndIf
#IFDEF TOP
	EndIf
#ENDIF 

If !lExterno
	oMeter:nTotal := CT1->(RecCount())
Endif

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m os d‚bitos ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cTipo <> "1"
	If cTipo = "2" .And. Empty(cCustoIni)
		CTT->(DbSeek(xFilial("CTT")))
		cCustoIni := CTT->CTT_CUSTO
	Endif
	If cTipo = "3" .And. Empty(cItemIni)
		CTD->(DbSeek(xFilial("CTD")))
		cItemIni := CTD->CTD_ITEM
	Endif
	If cTipo = "4" .And. Empty(cClVlIni)
		CTH->(DbSeek(xFilial("CTH")))
		cClVlIni := CTH->CTH_CLVL
	Endif
Endif

#IFDEF TOP
	If TcSrvType() != "AS/400"

		If cTipo == "1"
			dbSelectArea("CT2")
			dbSetOrder(2)
			cValid	:= 	"CT2_DEBITO>='" + cContaIni + "' AND " +;
						"CT2_DEBITO<='" + cContaFim + "'"
			cVldEnt := 	"CT2_CCD>='" + cCustoIni + "' AND " +;
						"CT2_CCD<='" + cCustoFim + "' AND " +;
						"CT2_ITEMD>='" + cItemIni + "' AND " +;
						"CT2_ITEMD<='" + cItemFim + "' AND " +;
						"CT2_CLVLDB>='" + cClVlIni + "' AND " +;
						"CT2_CLVLDB<='" + cClVlFim + "'"						
			cOrderBy:= " CT2_FILIAL, CT2_DEBITO, CT2_DATA "
		ElseIf cTipo == "2"
			dbSelectArea("CT2")
			dbSetOrder(4)
			cValid	:= 	"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCD <= '" + cCustoFim + "'"
			cVldEnt := 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
						"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
						"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMD <= '" + cItemFim + "'  AND  " +;
						"CT2_CLVLDB >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLDB <= '" + cClVlFim + "'" 
			cOrderBy:= " CT2_FILIAL, CT2_CCD, CT2_DATA "						
		ElseIf cTipo == "3"
			dbSelectArea("CT2")
			dbSetOrder(6)
			cValid 	:= 	"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMD <= '" + cItemFim + "'"
			cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
						"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
						"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCD <= '" + cCustoFim + "'  AND  " +;
						"CT2_CLVLDB >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLDB <= '" + cClVlFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_ITEMD, CT2_DATA "												
		ElseIf cTipo == "4"
			dbSelectArea("CT2")
			dbSetOrder(8)
			cValid 	:= 	"CT2_CLVLDB >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLDB <= '" + cClVlFim + "'"
			cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  AND  " +;
						"CT2_DEBITO <= '" + cContaFim + "'  AND  " +;
						"CT2_CCD >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCD <= '" + cCustoFim + "'  AND  " +;
						"CT2_ITEMD >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMD <= '" + cItemFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_CLVLDB, CT2_DATA "												
		EndIf                                           

		cAliasCT2	:= "cAliasCT2"
		
		cQuery	:= " SELECT * "
		cQuery	+= " FROM " + RetSqlName("CT2")  
		cQuery	+= " WHERE " + cQryFil + " AND "
		cQuery	+= cValid + " AND "
		cQuery	+= " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
		cQuery	+= " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
		cQuery	+= cVldEnt+ " AND " 
		cQuery	+= cFilMoeda + " AND " 
		cQuery	+= " CT2_TPSALD = '"+ cSaldo + "'"
		cQuery	+= " AND (CT2_DC = '1' OR CT2_DC = '3')"
		cQuery   += " AND CT2_VALOR <> 0 "
		cQuery	+= " AND D_E_L_E_T_ = ' ' " 
		cQuery	+= " ORDER BY "+ cOrderBy
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
		aStru := CT2->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField(cAliasCT2, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next ni		

		If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
			If !Empty(cVldEnt)
				cVldEnt  += " AND "			/// SE JÁ TIVER CONTEUDO, ADICIONA "AND"				
				cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
			EndIf		
		EndIf	
		                                     
		If (!lUFilter) .or. Empty(cUFilter)
			cUFilter := ".T."
		EndIf			
		
		dbSelectArea(cAliasCT2)				
		While !Eof()
			If &cUFilter
				CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo)
				dbSelectArea(cAliasCT2)
			EndIf
			dbSkip()
		EndDo			
		If ( Select ( "cAliasCT2" ) <> 0 )
			dbSelectArea ( "cAliasCT2" )
			dbCloseArea ()
		Endif
		
    Else    
#ENDIF    
	If cTipo == "1"
		dbSelectArea("CT2")                              
		dbSetOrder(2)
		cValid	:= 	"CT2_DEBITO>='" + cContaIni + "' .And. " +;
					"CT2_DEBITO<='" + cContaFim + "'"
		cVldEnt := 	"CT2_CCD>='" + cCustoIni + "' .And. " +;
					"CT2_CCD<='" + cCustoFim + "' .And. " +;
					"CT2_ITEMD>='" + cItemIni + "' .And. " +;
					"CT2_ITEMD<='" + cItemFim + "' .And. " +;
					"CT2_CLVLDB>='" + cClVlIni + "' .And. " +;
					"CT2_CLVLDB<='" + cClVlFim + "'"
		bCond 	:= { ||CT2->CT2_DEBITO >= cContaIni .And. CT2->CT2_DEBITO <= cContaFim}
	ElseIf cTipo == "2"
		dbSelectArea("CT2")
		dbSetOrder(4)
		cValid	:= 	"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'"
		cVldEnt := 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'  .And.  " +;
					"CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
					"CT2_CLVLDB <= '" + cClVlFim + "'"
	ElseIf cTipo == "3"
		dbSelectArea("CT2")
		dbSetOrder(6)
		cValid 	:= 	"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'"
		cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
					"CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
					"CT2_CLVLDB <= '" + cClVlFim + "'"
	ElseIf cTipo == "4"
		dbSelectArea("CT2")
		dbSetOrder(8)
		cValid 	:= 	"CT2_CLVLDB >= '" + cClVlIni + "'  .And.  " +;
					"CT2_CLVLDB <= '" + cClVlFim + "'"
		cVldEnt	:= 	"CT2_DEBITO >= '" + cContaIni + "'  .And.  " +;
					"CT2_DEBITO <= '" + cContaFim + "'  .And.  " +;
					"CT2_CCD >= '" + cCustoIni + "'  .And.  " +;
					"CT2_CCD <= '" + cCustoFim + "'  .And.  " +;
					"CT2_ITEMD >= '" + cItemIni + "'  .And.  " +;
					"CT2_ITEMD <= '" + cItemFim + "'"
	EndIf
		
	If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
		If !Empty(cVldEnt)
			cVldEnt  += " .and. "			/// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."		
		EndIf
	Endif
	
	cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
		
	If cTipo == "1"						/// TRATAMENTO CONTAS A CREDITO

		dbSelectArea("CT2")
		dbSetOrder(2)
		
		dbSelectArea("CT1")
		dbSetOrder(3)
		cFilCT1 := xFilial("CT1")
		cFilCT2	:= xFilial("CT2")
		cContaIni := If(Empty(cContaIni),"",cContaIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilCT1+"2"+cContaIni,.T.)					/// Procura inicial analitica
		
		While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
			dbSelectArea("CT2")
			MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
			While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_DEBITO == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim
		        
				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
		
				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo
			CT1->(dbSkip())
		EndDo
	Else
		dbSelectArea("CT2")

		cTabCad := "CTT"
		cEntIni	:= cCustoIni
		bCond 	:= { || CT2->CT2_CCD == CTT->CTT_CUSTO}
		bCondCad:= { || .T.}
		dbSetOrder(4)

		If cTipo == "3"
			cTabCad := "CTD"
			cEntIni := cItemIni
			bCond 	:= { || CT2->CT2_ITEMD == CTD->CTD_ITEM}			
			dbSetOrder(6)
		ElseIf cTipo == "4"
			cTabCad := "CTH"
			cEntIni := cCLVLIni
			bCond 	:= { || CT2->CT2_CLVLDB == CTH->CTH_CLVL}					
			dbSetOrder(8)
		EndIf
		
		dbSelectArea(cTabCad)
		dbSetOrder(2)
		cFilEnt := xFilial(cTabCad)
		cFilCT2	:= xFilial("CT2")
		cEntIni := If(Empty(cEntIni),"",cEntIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilEnt+"2"+cEntIni,.T.)					/// Procura inicial analitica
		
		If cTipo == "2"
			bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
		ElseIf cTipo == "3"
   			bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
  		ElseIf cTipo == "4"
			bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CTH->CTH_CLVL <= cCLVLFim }  		
  		EndIf
		
		While (cTabCad)->(!Eof()) .and. Eval(bCondCad)			/// WHILE DO CADASTRO DE ENTIDADES
	
			dbSelectArea("CT2")    			
			If cTipo == "2"
				MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
			ElseIf cTipo == "3"
				MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)			
			Else
				MsSeek(cFilCT2+CTH->CTH_CLVL+DTOS(dDataIni),.T.)						
			EndIf

			dbSelectArea("CT2")									/// WHILE CT2 - DEBITOS
			While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim
		
				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf

				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "1" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"1",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo	
			(cTabCad)->(dbSkip())
		EndDo
	Endif
		
#IFDEF TOP
	EndIf
#ENDIF


// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Obt‚m os creditos³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "1"
	dbSelectArea("CT2")
	dbSetOrder(3)
ElseIf cTipo == "2"
	dbSelectArea("CT2")
	dbSetOrder(5)
ElseIf cTipo == "3"
	dbSelectArea("CT2")
	dbSetOrder(7)
ElseIf cTipo == "4"		
	dbSelectArea("CT2")
	dbSetOrder(9)
EndIf

#IFDEF TOP
	If TcSrvType() != "AS/400"                          
		If cTipo == "1"
			cValid	:= 	"CT2_CREDIT>='" + cContaIni + "' AND " +;
						"CT2_CREDIT<='" + cContaFim + "'"
			cVldEnt :=	"CT2_CCC>='" + cCustoIni + "' AND " +;
						"CT2_CCC<='" + cCustoFim + "' AND " +;
						"CT2_ITEMC>='" + cItemIni + "' AND " +;
						"CT2_ITEMC<='" + cItemFim + "' AND " +;
						"CT2_CLVLCR>='" + cClVlIni + "' AND " +;
						"CT2_CLVLCR<='" + cClVlFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_CREDIT, CT2_DATA "																	
		ElseIf cTipo == "2"
			cValid 	:= 	"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCC <= '" + cCustoFim + "'"
			cVldEnt	:= 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
						"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
						"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMC <= '" + cItemFim + "'  AND  " +;
						"CT2_CLVLCR >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLCR <= '" + cClVlFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_CCC, CT2_DATA "																	
		ElseIf cTipo == "3"
			cValid 	:= 	"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMC <= '" + cItemFim + "'"
			cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
						"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
						"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCC <= '" + cCustoFim + "'  AND  " +;
						"CT2_CLVLCR >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLCR <= '" + cClVlFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_ITEMC, CT2_DATA "																	
		ElseIf cTipo == "4"		
			cValid 	:= 	"CT2_CLVLCR >= '" + cClVlIni + "'  AND  " +;
						"CT2_CLVLCR <= '" + cClVlFim + "'"
			cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "'  AND  " +;
						"CT2_CREDIT <= '" + cContaFim + "'  AND  " +;
						"CT2_CCC >= '" + cCustoIni + "'  AND  " +;
						"CT2_CCC <= '" + cCustoFim + "'  AND  " +;
						"CT2_ITEMC >= '" + cItemIni + "'  AND  " +;
						"CT2_ITEMC <= '" + cItemFim + "'"
			cOrderBy:= " CT2_FILIAL, CT2_CLVLCR, CT2_DATA "																						
		EndIf	                    
		
		cAliasCT2	:= "cAliasCT2"		
		
		cQuery	:= " SELECT * "
		cQuery	+= " FROM " + RetSqlName("CT2")  
		cQuery	+= " WHERE " + cQryFil + " AND "
		cQuery	+= cValid + " AND "
		cQuery	+= " CT2_DATA >= '" + DTOS(dDataIni) + "' AND "
		cQuery	+= " CT2_DATA <= '" + DTOS(dDataFim) + "' AND "
		cQuery	+= cVldEnt+ " AND " 
		cQuery	+= cFilMoeda + " AND " 
		cQuery	+= " CT2_TPSALD = '"+ cSaldo + "' AND "  
		cQuery	+= " (CT2_DC = '2' OR CT2_DC = '3') AND "
		cQuery	+= " CT2_VALOR <> 0 AND "
		cQuery	+= " D_E_L_E_T_ = ' ' " 
		cQuery	+= " ORDER BY "+ cOrderBy
		cQuery := ChangeQuery(cQuery)
			
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCT2,.T.,.F.)
		
		aStru := CT2->(dbStruct())
		
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField(cAliasCT2, aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next ni		
		

		If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
			If !Empty(cVldEnt)
				cVldEnt  += " AND "			/// SE JÁ TIVER CONTEUDO, ADICIONA "AND"				
				cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
			EndIf		
		EndIf	
		
		If (!lUFilter) .or. Empty(cUFilter)
			cUFilter := ".T."
		EndIf			
		
		dbSelectArea(cAliasCT2)				
		While !Eof()
			If &cUFilter
				CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo)
				dbSelectArea(cAliasCT2)
		    EndIf
			dbSkip()
		EndDo
		
		If ( Select ( "cAliasCT2" ) <> 0 )
			dbSelectArea ( "cAliasCT2" )
			dbCloseArea ()
		Endif

	Else
#ENDIF
	bCond	:= {||.T.}

	If cTipo == "1"
		cValid	:= 	"CT2_CREDIT>='" + cContaIni + "'.And." +;
					"CT2_CREDIT<='" + cContaFim + "'"
		cVldEnt :=	"CT2_CCC>='" + cCustoIni + "'.And." +;
					"CT2_CCC<='" + cCustoFim + "'.And." +;
					"CT2_ITEMC>='" + cItemIni + "'.And." +;
					"CT2_ITEMC<='" + cItemFim + "'.And." +;
					"CT2_CLVLCR>='" + cClVlIni + "'.And." +;
					"CT2_CLVLCR<='" + cClVlFim + "'"
		bCond 	:= { ||CT2->CT2_CREDIT >= cContaIni .And. CT2->CT2_CREDIT <= cContaFim}
	ElseIf cTipo == "2"
		cValid 	:= 	"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "'"
		cVldEnt	:= 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "' .And. " +;
					"CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
					"CT2_CLVLCR <= '" + cClVlFim + "'"
	ElseIf cTipo == "3"
		cValid 	:= 	"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "'"
		cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "' .And. " +;
					"CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
					"CT2_CLVLCR <= '" + cClVlFim + "'"
	ElseIf cTipo == "4"		
		cValid 	:= 	"CT2_CLVLCR >= '" + cClVlIni + "' .And. " +;
					"CT2_CLVLCR <= '" + cClVlFim + "'"
		cVldEnt := 	"CT2_CREDIT >= '" + cContaIni + "' .And. " +;
					"CT2_CREDIT <= '" + cContaFim + "' .And. " +;
					"CT2_CCC >= '" + cCustoIni + "' .And. " +;
					"CT2_CCC <= '" + cCustoFim + "' .And. " +;
					"CT2_ITEMC >= '" + cItemIni + "' .And. " +;
					"CT2_ITEMC <= '" + cItemFim + "'"
	EndIf	
	
	If lUFilter					//// ADICIONA O FILTRO DEFINIDO PELO USUÁRIO SE NÃO ESTIVER EM BRANCO
		If !Empty(cVldEnt)
			cVldEnt  += " .and. "			/// SE JÁ TIVER CONTEUDO, ADICIONA ".AND."		
		EndIf
	Endif
	
	cVldEnt  += cUFilter				/// ADICIONA O FILTRO DE USUÁRIO		
	
	If cTipo == "1"						/// TRATAMENTO CONTAS A CREDITO
		dbSelectArea("CT2")
		dbSetOrder(3)
		
		dbSelectArea("CT1")
		dbSetOrder(3)
		cFilCT1 := xFilial("CT1")
		cFilCT2	:= xFilial("CT2")
		cContaIni := If(Empty(cContaIni),"",cContaIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilCT1+"2"+cContaIni,.T.)					/// Procura inicial analitica
		
		While CT1->(!Eof()) .and. CT1->CT1_FILIAL == cFilCT1 .And. CT1->CT1_CONTA <= cContaFim
			dbSelectArea("CT2")
			MsSeek(cFilCT2+CT1->CT1_CONTA+DTOS(dDataIni),.T.)
			While !Eof() .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_CREDIT == CT1->CT1_CONTA .and. CT2->CT2_DATA <= dDataFim

				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
	
				If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cValid) .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					If Empty(c2Moeda)			
						If CT2->CT2_MOEDLC <> cMoeda
							dbSkip()
							Loop
						EndIF
					Else
						If !(&(cFilMoeda))
							dbSkip()
							Loop
						EndIf			
					EndIf			
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo			
			CT1->(dbSkip())
		EndDo
	Else
		dbSelectArea("CT2")

		cTabCad := "CTT"
		cEntIni	:= cCustoIni
		bCond 	:= { || CT2->CT2_CCC == CTT->CTT_CUSTO}
		bCondCad:= { || .T.}
		dbSetOrder(5)

		If cTipo == "3"
			cTabCad := "CTD"
			cEntIni := cItemIni
			bCond 	:= { || CT2->CT2_ITEMC == CTD->CTD_ITEM}			
			dbSetOrder(7)
		ElseIf cTipo == "4"
			cTabCad := "CTH"
			cEntIni := cCLVLIni
			bCond 	:= { || CT2->CT2_CLVLCR == CTH->CTH_CLVL}					
			dbSetOrder(9)
		EndIf
		
		dbSelectArea(cTabCad)
		dbSetOrder(2)
		cFilEnt := xFilial(cTabCad)
		cFilCT2	:= xFilial("CT2")
		cEntIni := If(Empty(cEntIni),"",cEntIni)		/// Se tiver espacos em branco usa "" p/ seek
		dbSeek(cFilEnt+"2"+cEntIni,.T.)					/// Procura inicial analitica
		
		If cTipo == "2"
			bCondCad := {|| CTT->CTT_FILIAL == cFilEnt .and. CTT->CTT_CUSTO <= cCustoFim }
		ElseIf cTipo == "3"
   			bCondCad := {|| CTD->CTD_FILIAL == cFilEnt .and. CTD->CTD_ITEM <= cItemFim }
  		ElseIf cTipo == "4"
			bCondCad := {|| CTH->CTH_FILIAL == cFilEnt .and. CTH->CTH_CLVL <= cCLVLFim }  		
  		EndIf
		
		While (cTabCad)->(!Eof()) .and. Eval(bCondCad)			/// WHILE DO CADASTRO DE ENTIDADES
	
			dbSelectArea("CT2")    	
			If cTipo == "2"
				MsSeek(cFilCT2+CTT->CTT_CUSTO+DTOS(dDataIni),.T.)
			ElseIf cTipo == "3"
				MsSeek(cFilCT2+CTD->CTD_ITEM+DTOS(dDataIni),.T.)			
			Else
				MsSeek(cFilCT2+CTH->CTH_CLVL+DTOS(dDataIni),.T.)						
			EndIf

			dbSelectArea("CT2")									/// WHILE CT2 - CREDITO
			While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .and. Eval(bCond) .and. CT2->CT2_DATA <= dDataFim

				If CT2->CT2_VALOR = 0
					dbSkip()
					Loop				
				EndIf
		
				If Empty(c2Moeda)			
					If CT2->CT2_MOEDLC <> cMoeda
						dbSkip()
						Loop
					EndIF
				Else
					If !(&(cFilMoeda))
						dbSkip()
						Loop
					EndIf			
				EndIf
				
				If (CT2->CT2_DC == "2" .Or. CT2->CT2_DC == "3") .And. &(cVldEnt) .And. CT2->CT2_TPSALD == cSaldo
					CT2->(CtbGrvRAZ(lJunta,cMoeda,cSaldo,"2",c2Moeda,cAliasCT2,nTipo))
				Endif
				dbSelectArea("CT2")
				dbSkip()
			EndDo	
			(cTabCad)->(dbSkip())
		EndDo
	EndIf

#IFDEF TOP
	EndIf
#ENDIF

If lNoMov .or. lSldAnt
	If cTipo == "1"
		dbSelectArea("CT1")
		dbSetOrder(3)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CT1_FILIAL == '" + xFilial("CT1") + "' .And. CT1_CONTA >= '"+cContaI+ "' .And. CT1_CONTA <= '" +;
						cContaF + "' .And. CT1_CLASSE = '2'",STR0017)
		cCpoChave := "CT1_CONTA"
		cTmpChave := "CONTA"
	ElseIf cTipo == "2"
		dbSelectArea("CTT")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTT_FILIAL == '" + xFilial("CTT") + "' .And. CTT_CUSTO >= '"+cCustoI+"' .And. CTT_CUSTO <= '" +;
						cCUSTOF + "' .And. CTT_CLASSE == '2'",STR0017)
		cCpoChave := "CTT_CUSTO"
		cTmpChave := "CCUSTO"
	ElseIf ctipo == "3"
		dbSelectArea("CTD")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTD_FILIAL == '" + xFilial("CTD") + "' .And. CTD_ITEM >= '"+cItemI+"' .And. CTD_ITEM <= '" +;
						cITEMF + "' .And. CTD_CLASSE == '2'",STR0017)
		cCpoChave := "CTD_ITEM"
		cTmpChave := "ITEM"
	ElseIf ctipo == "4"
		dbSelectArea("CTH")
		dbSetOrder(2)
		IndRegua(	Alias(),CriaTrab(nil,.f.),IndexKey(),,;
						"CTH_FILIAL == '" + xFilial("CTH") + "' .And. CTH_CLVL >= '"+cClVlI+"' .And. CTH_CLVL <= '" +;
						cCLVLF + "' .And. CTH_CLASSE == '2'",STR0017)
		cCpoChave := "CTH_CLVL"
		cTmpChave := "CLVL"
	EndIf

	cAlias := Alias()

	While ! Eof()
		dbSelectArea("cArqTmp")
		cKey2Seek	:= &(cAlias + "->" + cCpoChave)
		If !DbSeek(cKey2Seek)
			If lNoMov		
				CtbGrvNoMov(cKey2Seek,dDataIni,cTmpChave)
			ElseIf cTipo == "1"		/// SOMENTE PARA O RAZAO POR CONTA
				/// TRATA OS DADOS PARA A PERGUNTA "IMPRIME CONTA SEM MOVIMENTO" = "NAO C/ SLD.ANT."
				If SaldoCT7Fil(cKey2Seek,dDataIni,cMoeda,cSaldo,'CTBR400',,,aSelFil)[6] <> 0 .and. cArqTMP->CONTA <> cKey2Seek
					/// SE TIVER SALDO ANTERIOR E NÃO TIVER MOVIMENTO GRAVADO
					CtbGrvNoMov(cKey2Seek,dDataIni,cTmpChave)
				Endif
			EndIf
		Endif
		DbSelectArea(cAlias)
		DbSkip()
	EndDo

	DbSelectArea(cAlias)
	DbClearFil()
	RetIndex(cAlias)
Endif

CtbTmpErase(cTmpCT2Fil)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³CtbGrvRaz ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 05/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³Grava registros no arq temporario - Razao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³CtbGrvRaz(lJunta,cMoeda,cSaldo,cTipo)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso       ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpL1 = Se Junta CC ou nao                                 ³±±
±±³           ³ ExpC1 = Moeda                                              ³±±
±±³           ³ ExpC2 = Tipo de saldo                                      ³±±
±±            ³ ExpC3 = Tipo do lancamento                                 ³±±
±±³           ³ c2Moeda = Indica moeda 2 a ser incluida no relatorio       ³±±
±±³           ³ cAliasQry = Alias com o conteudo selecionado do CT2        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CtbGrvRAZ(lJunta,cMoeda,cSaldo,cTipo,c2Moeda,cAliasCT2,nTipo)

Local cConta
Local cContra
Local cCusto
Local cItem
Local cCLVL
Local cChave   	:= ""
Local lFind   	:= .F.
Local lImpCPartida := GetNewPar("MV_IMPCPAR",.T.) // Se .T.,     IMPRIME Contra-Partida para TODOS os tipos de lançamento (Débito, Credito e Partida-Dobrada),
                                                  // se .F., NÃO IMPRIME Contra-Partida para NENHUM   tipo  de lançamento.
DEFAULT cAliasCT2	:= "CT2"

If !Empty(c2Moeda)
	If cTipo == "1"
		cChave	:=	(cAliasCT2)->(CT2_DEBITO+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
	Else
    	cChave	:=	(cAliasCT2)->(CT2_CREDIT+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_EMPORI+CT2_FILORI)
 	EndIf
EndIf

If cTipo == "1"
	cConta 	:= (cAliasCT2)->CT2_DEBITO
	cContra	:= (cAliasCT2)->CT2_CREDIT
	cCusto	:= (cAliasCT2)->CT2_CCD
	cItem	:= (cAliasCT2)->CT2_ITEMD
	cCLVL	:= (cAliasCT2)->CT2_CLVLDB
EndIf	
If cTipo == "2"
	cConta 	:= (cAliasCT2)->CT2_CREDIT
	cContra := (cAliasCT2)->CT2_DEBITO
	cCusto	:= (cAliasCT2)->CT2_CCC
	cItem	:= (cAliasCT2)->CT2_ITEMC
	cCLVL	:= (cAliasCT2)->CT2_CLVLCR
EndIf		           

dbSelectArea("cArqTmp")
dbSetOrder(1)	
If !Empty(c2Moeda) 
	If MsSeek(cChave,.F.) 
   		While !Eof() .and.!lFind
			lFind := cCusto==cArqTmp->CCUSTO.and.cItem==cArqTmp->ITEM.and.cCLVL==cArqTmp->CLVL  
			if !lFind
				dbSkip()
			EndIf			
		EndDo
		Reclock("cArqTmp",!lFind)
	Else
		RecLock("cArqTmp",.T.)		
	EndIf
Else
	RecLock("cArqTmp",.T.)
EndIf


Replace FILIAL		With (cAliasCT2)->CT2_FILIAL
Replace DATAL		With (cAliasCT2)->CT2_DATA
Replace TIPO		With cTipo
Replace LOTE		With (cAliasCT2)->CT2_LOTE
Replace SUBLOTE		With (cAliasCT2)->CT2_SBLOTE
Replace DOC			With (cAliasCT2)->CT2_DOC
Replace LINHA		With (cAliasCT2)->CT2_LINHA
Replace CONTA		With cConta

If lImpCPartida
	Replace XPARTIDA	With cContra
EndIf

Replace CCUSTO		With cCusto
Replace ITEM		With cItem
Replace CLVL		With cCLVL
Replace HISTORICO	With (cAliasCT2)->CT2_HIST
Replace EMPORI		With (cAliasCT2)->CT2_EMPORI
Replace FILORI		With (cAliasCT2)->CT2_FILORI
Replace SEQHIST		With (cAliasCT2)->CT2_SEQHIST
Replace SEQLAN		With (cAliasCT2)->CT2_SEQLAN
Replace NOMOV		With .F.							// Conta com movimento

If cPaisLoc $ "CHI|ARG"
	Replace SEGOFI With (cAliasCT2)->CT2_SEGOFI// Correlativo para Chile
EndIf

If Empty(c2Moeda)	//Se nao for Razao em 2 Moedas
	If cTipo == "1"
		Replace LANCDEB	With LANCDEB + (cAliasCT2)->CT2_VALOR
	EndIf	
	If cTipo == "2"
		Replace LANCCRD	With LANCCRD + (cAliasCT2)->CT2_VALOR
	EndIf	    
	If (cAliasCT2)->CT2_DC == "3"
		Replace TIPO	With cTipo
	Else
		Replace TIPO 	With (cAliasCT2)->CT2_DC
	EndIf		
Else	//Se for Razao em 2 Moedas
	If (nTipo = 1 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = cMoeda //Se Imprime Valor na Moeda ou ambos
		If cTipo == "1"
			Replace LANCDEB With (cAliasCT2)->CT2_VALOR	
		Else			
			Replace LANCCRD With (cAliasCT2)->CT2_VALOR	
		EndIf
	EndIf
    If (nTipo = 2 .Or. nTipo = 3) .And. (cAliasCT2)->CT2_MOEDLC = c2Moeda	//Se Imprime Moeda Corrente ou Ambas
		If cTipo == "1"
			Replace LANCDEB_1	With (cAliasCT2)->CT2_VALOR
		Else
			Replace LANCCRD_1	With (cAliasCT2)->CT2_VALOR
		Endif
	EndIf
	If LANCDEB_1 <> 0 .And. LANCDEB <> 0 
		Replace TXDEBITO  	With LANCDEB_1 / LANCDEB		
	Endif                                               
	If LANCCRD_1 <> 0 .And. LANCCRD <> 0
		Replace TXCREDITO 	With LANCCRD_1 / LANCCRD
	EndIf	
	If (cAliasCT2)->CT2_DC == "3"
		Replace TIPO	With cTipo
	Else
		Replace TIPO 	With (cAliasCT2)->CT2_DC
	EndIf			
EndIf

If nTipo = 1 .And. (LANCDEB + LANCCRD) = 0
	DbDelete()
ElseIf nTipo = 2 .And. (LANCDEB_1 + LANCCRD_1) = 0
	DbDelete()
Endif
If ! Empty(c2Moeda) .And. LANCDEB + LANCDEB_1 + LANCCRD + LANCCRD_1 = 0
	DbDelete()
Endif
MsUnlock()

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SaldoCT7  ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 15.12.99 			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Saldo do Plano de Contas                                   			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³SaldoCT7(cConta,dData,cMoeda,cTpSald,cRotina,lImpAntLP,dDataLP,cFilEsp³±±
±±³			 |,cArqCt7)																³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³{nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Conta Contabil                                    		    ³±±
±±³          ³ ExpD1 = Data                                              		    ³±±
±±³          ³ ExpC2 = Moeda                                             		    ³±±
±±³          ³ ExpC3 = Tipo de Saldo                                     		    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SaldoCT7(cConta,dData,cMoeda,cTpSald,cRotina,lImpAntLP,dDataLP,cFilEsp,cArqCt7)

Local aSaveArea	:= CT7->(GetArea())
Local aSaveAnt	:= GetArea()
Local lNaoAchei	:= .F.
Local nDebito	:= 0				// Valor Debito na Data
Local nCredito 	:= 0				// Valor Credito na Data
Local nAtuDeb  	:= 0				// Saldo Atual Devedor
Local nAtuCrd	:= 0				// Saldo Atual Credor
Local nAntDeb	:= 0				// Saldo Anterior Devedor
Local nAntCrd	:= 0				// Saldo Anterior Credor
Local nSaldoAnt	:= 0				// Saldo Anterior (com sinal)
Local nSaldoAtu	:= 0				// Saldo Atual (com sinal)
Local bCondicao	:= {||.F.}
Local bCondLP	:= {||.F.}
Local cChaveLP	:= ""
Local aSldLP	:= {0,0}
Local lSeek		:=	.T.
Local cQryFil	:= ""

Default cArqCt7 := Nil
DEFAULT cFilEsp	:= xFilial("CT7")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratativa para o filtro de filiais           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Não pode haver filial nula ou diferente de caracter
If cFilEsp == nil .Or. Empty( cFilEsp ) .Or. ValType(cFilEsp) <> "C"
	cFilEsp	:= xFilial( "CT7" )
Else
	cFilEsp := Alltrim( cFilEsp )
Endif

// cQryFil := " CT7_FILIAL = '" + cFilEsp + "' "  // 20/05/16 - Luis Felipe

If	Empty(MV_PAR29) 
	_cQryFil := '0101'
Else
	_cQryFil := MV_PAR29
EndIf                   

#IFDEF TOP
	lSeek	:= ( TcSrvType() == "AS/400" )
#ENDIF 

cTpSald		:= Iif( Empty( cTpSald),"1",cTpSald)                   
dDataLp		:= Iif( dDataLP ==Nil,CTOD("  /  /  "),dDataLP)              
cRotina		:= Iif( cRotina ==Nil,"",cRotina)
lImpAntLP	:= Iif( lImpAntLP == Nil,.F.,lImpAntLP)
cConta		:= Left(AllTrim(cConta) + Space(Len(CT7->CT7_CONTA)), Len(CT7->CT7_CONTA))

dbSelectArea("CT7")
Dbsetorder(2)

If lSeek
	MsSeek( cFilEsp + cConta + cMoeda + cTpSald + Dtos(dData) ,.T.)
Endif

bCondicao	:= { || (CT7->CT7_FILIAL >= MV_PAR29 .And. CT7->CT7_FILIAL <= MV_PAR30 .And. CT7->CT7_CONTA == cConta .And. CT7->CT7_MOEDA == cMoeda .And. CT7->CT7_TPSALD == cTpSald .And. CT7->CT7_DATA  <= dData) }
cChaveLP	:= ( cFilEsp + "Z" + cConta + cMoeda + cTpSald )
bCondLP  	:= { || (CT7->CT7_FILIAL >= MV_PAR29 .And. CT7->CT7_FILIAL <= MV_PAR30 .And. CT7->CT7_CONTA == cConta .And. CT7->CT7_MOEDA == cMoeda .And. CT7->CT7_TPSALD == cTpSald .And.  CT7->CT7_LP == "Z" .And.	dDataLP <= dData) }	

#IFDEF TOP
If TcSrvType() <> "AS/400"

	If cArqCt7 == Nil
		cArqCt7 := RetSqlName( "CT7" )
	Endif

	While _cQryFil <= MV_PAR30  // 20/05/16 - Luis Felipe   

		cData := DTOS(dData)
		lAcheiSld := .F.
		nExecW := 0				///Vai rodar 2vezes caso não ache na data informada.
		cQryFil := "CT7_FILIAL = '"+_cQryFil+"'"

		While !lAcheiSld
	
			nExecW++ // contador de seleção da data a ser filtrada, Data referenciada ou a ultima data com lançamento
	
			cQrySld := "SELECT CT7.CT7_DATA";
			              + ", CT7.CT7_LP";
			              + ", CT7.CT7_ANTDEB";
			              + ", CT7.CT7_ANTCRD";
			              + ", CT7.CT7_DEBITO";
			              + ", CT7.CT7_CREDIT";
			              + ", CT7.CT7_ATUDEB";
			              + ", CT7.CT7_ATUCRD ";
				      + " FROM " + cArqCt7 + " CT7";
					 + " WHERE " + cQryFil ;
				       + " AND CT7.CT7_CONTA = '" + cConta + "' "
	
			If nExecW == 1
				cQrySld += " AND CT7_DATA = '"+cData+"' "
			Else
				cQrySld += " AND CT7_DATA = '"+cMaxDTAnt+"' "	
			EndIf
	
			cQrySld += " AND CT7_MOEDA = '" + cMoeda + "' "
			cQrySld += " AND CT7_TPSALD = '" + cTpSald + "' "
			cQrySld += " AND D_E_L_E_T_ = '' "
			
			cQrySld := ChangeQuery(cQrySld)
			
			If Select("SLDCT7") > 0
				dbSelectArea("SLDCT7")
				SLDCT7->(dbCloseArea())
			Endif
	
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQrySld),"SLDCT7",.T.,.F.)
	
			TcSetField("SLDCT7","CT7_ANTDEB"  ,"N",TamSx3("CT7_ANTDEB")[1],TamSx3("CT7_ANTDEB")[2])	
			TcSetField("SLDCT7","CT7_ANTCRD"  ,"N",TamSx3("CT7_ANTCRD")[1],TamSx3("CT7_ANTCRD")[2])			
			TcSetField("SLDCT7","CT7_DEBITO"  ,"N",TamSx3("CT7_DEBITO")[1],TamSx3("CT7_DEBITO")[2])			
			TcSetField("SLDCT7","CT7_CREDIT"  ,"N",TamSx3("CT7_CREDIT")[1],TamSx3("CT7_CREDIT")[2])			
			TcSetField("SLDCT7","CT7_ATUDEB"  ,"N",TamSx3("CT7_ATUDEB")[1],TamSx3("CT7_ATUDEB")[2])					
			TcSetField("SLDCT7","CT7_ATUCRD"  ,"N",TamSx3("CT7_ATUCRD")[1],TamSx3("CT7_ATUCRD")[2])					
	
			dbSelectArea("SLDCT7")
		
			If SLDCT7->(EOF()) .AND. SLDCT7->(BOF()) ///SE NÃO ACHOU O REGISTRO DE SALDO NA DATA
	
				If nExecW >= 2
					lAcheiSld := .F.			/// SE NA 2ª EXECUCAO (D-1) NAO ACHOU REGISTRO DE SALDO, SAI DO WHILE (SALDO 0)
					Exit
				EndIf
		
				/// APENAS SE NÃO EXISTIR O REGISTRO DE SALDO NO DIA.
				cQryMaxDT := "SELECT MAX(CT7_DATA) CT7_DATA ";
							+ " FROM " + cArqCt7;
						   + " WHERE " + cQryFil ;
							 + " AND CT7_CONTA = '" + cConta + "' ";
							 + " AND CT7_DATA < '" + cData + "' ";
							 + " AND CT7_MOEDA = '" + cMoeda+ "' ";
							 + " AND CT7_TPSALD = '" + cTpSald + "' ";
							 + " AND D_E_L_E_T_ = '' "
	
				cQryMaxDT := ChangeQuery(cQryMaxDT)
				
				If Select("SL7MDT") > 0   // 01/06/16 - Luis Felipe
					dbselectarea("SL7MDT")
					SL7MDT->( dbCloseArea() )
				Endif

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryMaxDT),"SL7MDT",.T.,.F.)
				
				dbSelectArea("SL7MDT")
	
				cMaxDtAnt := SL7MDT->CT7_DATA
				
				If Empty(cMaxDTAnt)		///Se nao localizou data anterior
					lAcheiSld := .F.	// Não tem saldo (nem executa query pela 2ª vez)
					Exit
				EndIf
				
				dbSelectArea( "SL7MDT" )
				SL7MDT->( dbCloseArea() )
			Else	
				lAcheiSld := .T.				
			EndIf
		EndDo
	
		dbSelectArea("SLDCT7")
	
		If lAcheiSld							//Se achou algum registro de saldo (na data, ou na data anterior)
			SLDCT7->(dbGoTop())
			lAchouNoD := nExecW <= 1			//Se achou na 1ª indica que achou na data solicitada
			IF lAchouNoD						//Se achou saldo na data solicitada
				nAntDeb		:= SLDCT7->CT7_ANTDEB	//Sld ANT é igual a Sld ANT do dia (1ª registro da data, considerando N,S,Z)
				nAntCrd		:= SLDCT7->CT7_ANTCRD	//Sld ANT é igual a Sld ANT do dia (1ª registro da data, considerando N,S,Z)
			EndIf
	
			While SLDCT7->(!Eof())
				If lAchouNoD					//Se achou saldo na data solicitada (não esta na data imediatamente anterior)
					nDebito 	+= SLDCT7->CT7_DEBITO	///ACUMULA MOVIMENTO DO DIA (CONSIDERANDO Q PODEM EXISTIR N,S e Z da MESMA DATA).
					nCredito	+= SLDCT7->CT7_CREDIT   ///ACUMULA MOVIMENTO DO DIA (CONSIDERANDO Q PODEM EXISTIR N,S e Z da MESMA DATA).
				EndIf
			
				nAtuDeb		:= SLDCT7->CT7_ATUDEB	/// Se houver CTx_LP o ATUDEB deverá ser o último (ref ao Z se houver)
				nAtuCrd		:= SLDCT7->CT7_ATUCRD	/// Se houver CTx_LP o ATUCRD deverá ser o último (ref ao Z se houver)
	
				SLDCT7->(dbSkip())
			EndDo		
	
			If !lAchouNoD				//Se achou saldo apenas no dia anterior 
				nAntDeb		:= nAtuDeb 	// Saldo ANT é igual ao ATU do dia anterior (último registro considerando N,S,Z)
				nAntCrd		:= nAtuCrd  // Saldo ANT é igual ao ATU do dia anterior (último registro considerando N,S,Z)
			EndIf
				
			nSaldoAnt += nAntCRD - nAntDEB // 01/06/16 - Felipe - De := p/ +=
			nSaldoAtu += nAtuCRD - nAtuDEB		
			
		EndIF
		    
        _cQryFil := Soma1(_cQryFil)  
    
    End

	If Select("SLDCT7") > 0
		dbSelectArea("SLDCT7")
		SLDCT7->(dbCloseArea())
	Endif
	If Select("SL7MDT7") > 0
		dbSelectArea("SL7MDT7")
		SL7MDT7->(dbCloseArea())
	Endif

Else
#ENDIF
	dbSetOrder(2)	
	If ! Eval(bCondicao)
		dbSkip(-1)
		lNaoAchei := .T.
	Else	//Verificar se existe algum registro de zeramento na mesma data 
		If cRotina $ "CTBR400/CTBXFUN"				//// NO RAZAO O SALDO ANTERIOR NAO DEVE CONSIDERAR OS LANCAMENTOS DE APURACAO
			nAntCrd := CT7->CT7_ANTCRD
			nAntDeb := CT7->CT7_ANTDEB
		Endif
		dbSkip()
		If !Eval(bCondicao) //Se nao existir registro na mesma data, volto para o registro anterior. 
			dbSkip(-1)
		EndIf
	EndIf
	
	If Eval(bCondicao)
		// Movimentacoes na data
		If CT7->CT7_DATA == dData
			nDebito		:= CT7->CT7_DEBITO
			nCredito	:= CT7->CT7_CREDITO
		Endif	
		nAtuDeb	 	:= CT7->CT7_ATUDEB
		nAtuCrd  	:= CT7->CT7_ATUCRD
		If lNaoAchei
			// Neste caso, como a data nao foi encontrada, considera-se como saldo anterior
			// o saldo atual do registro anterior! -> dbskip(-1)
			nAntDeb  := CT7->CT7_ATUDEB
			nAntCrd  := CT7->CT7_ATUCRD
		Else		
			If !cRotina$"CTBR400/CTBXFUN"			/// NO RAZAO O SALDO ANTERIOR NAO DEVE CONSIDERAR OS LANCAMENTOS DE APURACAO
				nAntDeb  := CT7->CT7_ANTDEB
				nAntCrd  := CT7->CT7_ANTCRD
			Endif
		Endif
	
		If cRotina = "CTBA210"
			//Se foi chamado pela rotina de apuracao de lucros/perdas,existe um registro
			//na data solcitada e o saldo nao eh o do proprio zeramento, considero como 
			//saldo anterior, o saldo atual antes do zeramento. 
			If CT7->CT7_LP	<> 'Z'
				nAntDeb  := CT7->CT7_ATUDEB                  		
				nAntCrd  := CT7->CT7_ATUCRD		
			Endif
		Endif
	
		nSaldoAtu+= nAtuCrd - nAtuDeb  // 01/06/16 - Felipe - De := p/ +=
		nSaldoAnt+= nAntCrd - nAntDeb
	EndIf
	
#IFDEF TOP
EndIf
#ENDIF

//Se considera saldo anterior a apurcao de lucros/perdas
If lImpAntLP
	dbSelectArea("CT7")
	dbSetOrder(5)
	If MsSeek(cChaveLP)				
		aSldLP	:= CtbSldLP("CT7",dDataLP,bCondLP,dData)		
		nAtuDeb	-= aSldLP[1]
		nAtuCrd	-= aSldLP[2]		
		nSaldoAtu := nAtuCrd - nAtuDeb

//		If lNaoAchei
			nAntDeb	-= aSldLP[1]
			nAntCrd -= aSldLP[2]    
			nSaldoAnt	+= nAntCrd - nAntDeb // 01/06/16 - Felipe - De := p/ += 
//		EndIf

	EndIf
EndIf

If Select( "SLDCT7" ) > 0
	dbSelectArea( "SLDCT7" )
	SLDCT7->( dbCloseArea() )
Endif
If Select( "SL7MDT" ) > 0
	dbSelectArea( "SL7MDT" )
	SL7MDT->( dbCloseArea() )
Endif

CT7->(RestArea(aSaveArea))

RestArea(aSaveAnt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return {nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}




//-------------------------------------------------------------------
/*{Protheus.doc} SaldoCQ
Retorna o saldo da entidade

@author Alvaro Camillo Neto

@param cArqBase 	Arquivo Base para o saldo ( CT1 - Conta , CTT - Centro de Custo, CTD - Item Contábil , CTH - Classe de Valor, CTU - Saldo por entidade )
@param cConta 	Conta Contábil
@param cCCusto 	Centro de Custo
@param cItem 		Item contábil
@param cClasse 	Classe Contábil
@param cIdent 	Identificador da Tabela
@param dData 		Data do Saldo
@param cMoeda		Moeda                                            
@param cTpSald 	Tipo de Saldo                       
@param cRotina 	Reservado		           
@param lImpAntLP 	Flag para indicar se imprime antes do Lucro/Perdas
@param dDataLP 	Data de Lucro/Perdas                      
@param cFilEsp   Filial de busca
@param lUltDtVl Busca a ultima data de saldo válida
   
@version P12
@since   20/02/2014
@return  Nil
@obs	 
*/
//-------------------------------------------------------------------
Static Function SaldoCQ(cArqBase,cConta,cCCusto,cItem,cClasse,cIdent,dData,cMoeda,cTpSald,cRotina,lImpAntLP,dDataLP,cFilEsp,lUltDtVl)

Local nSaldoAtu	:= 0
Local nDebito		:= 0
Local nCredito	:= 0
Local nAtuDeb		:= 0
Local nAtuCrd		:= 0
Local nSaldoAnt	:= 0
Local nAntDeb		:= 0
Local nAntCrd		:= 0
Local cQuery		:= ""
Local cTabMes		:= ""
Local cTabDia		:= ""
Local cFilMes		:= ""
Local cFilDia		:= ""
Local cCodigo		:= ""
Local cCpoTot		:= ""
Local cCpoDia		:= ""
Local cCpoMes		:= ""
Local cGrpDia		:= ""
Local cGrpMes		:= ""
Local aTamVlr		:= TamSX3("CT2_VALOR")
Local aArea		:= GetArea()
Local nDebLP		:= 0
Local nCrdLP		:= 0
Local cTRB			:= GetNextAlias()
Local dDataNew    := CTOD("")

DEFAULT cFilEsp	:= xFilial("CT2")

DEFAULT cConta 		:= Nil
DEFAULT cCCusto		:= Nil
DEFAULT cItem			:= Nil
DEFAULT cClasse		:= Nil
DEFAULT cIdent		:= ""
DEFAULT dData			:= STOD("")
DEFAULT lImpAntLP    := .F.
DEFAULT dDataLP		:= STOD("")
DEFAULT cTpSald		:= "1"
DEFAULT cRotina		:= ""
DEFAULT lUltDtVl		:= .t.


If cArqBase $ "CT1/CT7/CQ0/CQ1"
	cArqBase := "CT1"
	dbSelectArea("CQ0")
	dbSelectArea("CQ1")
	cTabMes := "CQ0"
	cTabDia := "CQ1"
ElseIf cArqBase $ "CTT/CT3/CQ2/CQ3"
	cArqBase := "CTT"
	dbSelectArea("CQ2")
	dbSelectArea("CQ3")
	cTabMes := "CQ2"
	cTabDia := "CQ3"
ElseIf cArqBase $ "CTD/CT4/CQ4/CQ5"
	cArqBase := "CTD"
	dbSelectArea("CQ4")
	dbSelectArea("CQ5")
	cTabMes := "CQ4"
	cTabDia := "CQ5"
ElseIf cArqBase $ "CTH/CTI/CQ6/CQ7"
	cArqBase := "CTH"
	dbSelectArea("CQ6")
	dbSelectArea("CQ7")
	cTabMes := "CQ6"
	cTabDia := "CQ7"
	
ElseIf cArqBase  $ "CTU/CQ8/CQ9"
	dbSelectArea("CQ7")
	dbSelectArea("CQ8")
	cTabMes := "CQ8"
	cTabDia := "CQ9"
	cArqBase := "CTU"
	If cIdent $ "CTT/CT3"
		cIdent := "CTT"
		cCodigo := cCCusto
	ElseIf cIdent $ "CTD/CT4"
		cIdent := "CTD"
		cCodigo := cItem
	ElseIf cIdent $ "CTH/CTI"
		cIdent := "CTH"
		cCodigo := cClasse
	EndIf
EndIf

//Tratativa para o filtro de filiais
If cFilEsp == nil .Or. Empty( cFilEsp ) .Or. ValType(cFilEsp) <> "C"
	cFilEsp	:= xFilial( cTabMes )
Else
	cFilEsp := Alltrim( cFilEsp )
Endif

cFilMes := " "+cTabMes+"_FILIAL = '" + cFilEsp + "' "
cFilDia := " "+cTabDia+"_FILIAL = '" + cFilEsp + "' "

If lUltDtVl
	dDataNew := GetDtMaxCQ(cArqBase,cConta,cCCusto,cItem,cClasse,cIdent,dData,cMoeda,cTpSald,cFilEsp)
Else
	dDataNew := dData
EndIf

If !Empty(dDataNew)
	If cArqBase != "CTU"
		If cConta != Nil
			cCpoTot  +=   ",CONTA " +CRLF
			cCpoDia  +=   ","+cTabDia+"_CONTA CONTA" +CRLF
			cCpoMes  +=   ","+cTabMes+"_CONTA CONTA" +CRLF
			cGrpDia  +=   ","+cTabDia+"_CONTA " +CRLF
			cGrpMes  +=   ","+cTabMes+"_CONTA " +CRLF
		EndIf
		If  cArqBase $ 'CTT/CTD/CTH' .And. cCCusto != Nil
			cCpoTot +=   ",CCUSTO " +CRLF
			cCpoDia +=   ","+cTabDia+"_CCUSTO CCUSTO " +CRLF
			cCpoMes +=   ","+cTabMes+"_CCUSTO CCUSTO " +CRLF
			cGrpDia +=   ","+cTabDia+"_CCUSTO  " +CRLF
			cGrpMes +=   ","+cTabMes+"_CCUSTO  " +CRLF
		EndIf
		If  cArqBase $ 'CTD/CTH' .And. cItem != Nil
			cCpoTot +=   ",ITEM " +CRLF
			cCpoDia +=   ","+cTabDia+"_ITEM ITEM " +CRLF
			cCpoMes +=   ","+cTabMes+"_ITEM ITEM " +CRLF
			cGrpDia +=   ","+cTabDia+"_ITEM  " +CRLF
			cGrpMes +=   ","+cTabMes+"_ITEM  " +CRLF
		EndIf
		If  cArqBase $ 'CTH' .And. cItem != Nil
			cCpoTot +=   ",CLVL " +CRLF
			cCpoDia +=   ","+cTabDia+"_CLVL CLVL" +CRLF
			cCpoMes +=   ","+cTabMes+"_CLVL CLVL" +CRLF
			cGrpDia +=   ","+cTabDia+"_CLVL " +CRLF
			cGrpMes +=   ","+cTabMes+"_CLVL " +CRLF
		EndIf
	Else
		cCpoTot +=   ",IDENT " +CRLF
		cCpoTot +=   ",CODIGO " +CRLF
		cCpoDia +=   ","+cTabDia+"_IDENT IDENT " +CRLF
		cCpoDia +=   ", "+cTabDia+"_CODIGO CODIGO " +CRLF
		cCpoMes +=   ","+cTabMes+"_IDENT IDENT " +CRLF
		cCpoMes +=   ", "+cTabMes+"_CODIGO CODIGO " +CRLF
		cGrpDia +=   ","+cTabDia+"_IDENT  " +CRLF
		cGrpDia +=   ", "+cTabDia+"_CODIGO  " +CRLF
		cGrpMes +=   ","+cTabMes+"_IDENT  " +CRLF
		cGrpMes +=   ", "+cTabMes+"_CODIGO  " +CRLF
	EndIf
	
	
	cQuery +=     " SELECT " +CRLF
	
	cQuery +=     " SUM(SLDANTDEB) SLDANTDEB " +CRLF
	cQuery +=     " ,SUM(SLDANTCRD) SLDANTCRD " +CRLF
	cQuery +=     " ,SUM(SALDODEB) SALDODEB " +CRLF
	cQuery +=     " ,SUM(SALDOCRD) SALDOCRD " +CRLF
	cQuery +=     " ,SUM(SALDODEBLP) SALDODEBLP " +CRLF
	cQuery +=     " ,SUM(SALDOCRDLP) SALDOCRDLP " +CRLF
	cQuery +=     " ,SUM(SALDODEBATU) SALDODEBATU " +CRLF
	cQuery +=     " ,SUM(SALDOCRDATU) SALDOCRDATU " +CRLF
	cQuery +=     " "+cCpoTot+"  " +CRLF
	
	cQuery +=     " FROM    " +CRLF
	cQuery +=     " ( " +CRLF
	//		---------------------------- Saldo atual -----------------------------------------------
	
	//		--Diário
	cQuery +=       " SELECT " +CRLF
	
	cQuery +=          " SUM("+cTabDia+"_DEBITO) SALDODEB " +CRLF
	cQuery +=          " ,SUM("+cTabDia+"_CREDIT) SALDOCRD " +CRLF
	cQuery +=          " ,0 SLDANTDEB " +CRLF
	cQuery +=          " ,0 SLDANTCRD  " +CRLF
	cQuery +=          " ,0 SALDODEBLP " +CRLF
	cQuery +=          " ,0 SALDOCRDLP " +CRLF
	cQuery +=          " ,0 SALDODEBATU " +CRLF
	cQuery +=          " ,0 SALDOCRDATU " +CRLF
	cQuery +=          " "+cCpoDia+"  " +CRLF
	
	cQuery +=      " FROM "+RetSqlName(cTabDia) +CRLF
	cQuery +=      " WHERE " +CRLF
	cQuery +=          " D_E_L_E_T_ = '' " +CRLF
	cQuery +=          " AND "+cFilDia+" "+CRLF
	
	If cArqBase != "CTU"
		If cConta != Nil
			cQuery +=   " AND "+cTabDia+"_CONTA = '"+cConta+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTT/CTD/CTH' .And.  cCCusto != Nil
			cQuery +=   " AND "+cTabDia+"_CCUSTO = '"+cCCusto+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTD/CTH'  .And.  cItem != Nil
			cQuery +=   " AND "+cTabDia+"_ITEM = '"+cItem+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTH'  .And.  cClasse != Nil
			cQuery +=   " AND "+cTabDia+"_CLVL = '"+cClasse+"'" +CRLF
		EndIf
	Else
		cQuery +=   " AND "+cTabDia+"_IDENT = '"+cIdent+"' " +CRLF
		cQuery +=   " AND "+cTabDia+"_CODIGO = '"+cCodigo+"' " +CRLF
	EndIf
	
	cQuery +=          " AND "+cTabDia+"_MOEDA = '"+cMoeda+"' " +CRLF
	cQuery +=          " AND "+cTabDia+"_TPSALD = '"+cTpSald+"' " +CRLF
	cQuery +=          " AND "+cTabDia+"_DATA = '"+DTOS(dDataNew)+"' " +CRLF
	
	cQuery +=          " GROUP BY " +CRLF
	cQuery +=" "+Right(cGrpDia,Len(cGrpDia)-1)+"  " +CRLF
	
	
	//------------------------------------------ Saldo anterior ------------------------------------
	//------------------------------Mensal----------------------------------
	cQuery +=       " UNION ALL	 " +CRLF
	
	cQuery +=       " SELECT  " +CRLF
	
	cQuery +=          " 0 SALDODEB " +CRLF
	cQuery +=          " ,0 SALDOCRD " +CRLF
	cQuery +=          " ,SUM("+cTabMes+"_DEBITO) SLDANTDEB " +CRLF
	cQuery +=          " ,SUM("+cTabMes+"_CREDIT) SLDANTCRD " +CRLF
	cQuery +=          " ,0 SALDODEBLP " +CRLF
	cQuery +=          " ,0 SALDOCRDLP " +CRLF
	cQuery +=          " ,0 SALDODEBATU " +CRLF
	cQuery +=          " ,0 SALDOCRDATU " +CRLF
	cQuery +=          " "+cCpoMes+"  " +CRLF
	
	cQuery +=       " FROM " + RetSqlName(cTabMes) +CRLF
	cQuery +=       " WHERE " +CRLF
	cQuery +=          " D_E_L_E_T_ = '' " +CRLF
	cQuery +=          " AND "+ cFilMes +CRLF
	
	If cArqBase != "CTU"
		If cConta != Nil
			cQuery +=   " AND "+cTabMes+"_CONTA = '"+cConta+"' " +CRLF
		EndIf
		
		If  cArqBase $ 'CTT/CTD/CTH' .And. cCCusto != Nil
			cQuery +=   " AND "+cTabMes+"_CCUSTO = '"+cCCusto+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTD/CTH' .And. cItem != Nil
			cQuery +=   " AND "+cTabMes+"_ITEM = '"+cItem+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTH' .And. cClasse != Nil
			cQuery +=   " AND "+cTabMes+"_CLVL = '"+cClasse+"'" +CRLF
		EndIf
	Else
		cQuery +=   " AND "+cTabMes+"_IDENT = '"+cIdent+"' " +CRLF
		cQuery +=   " AND "+cTabMes+"_CODIGO = '"+cCodigo+"' " +CRLF
	EndIf
	cQuery +=          " AND "+cTabMes+"_MOEDA = '"+cMoeda+"' " +CRLF
	cQuery +=          " AND "+cTabMes+"_TPSALD = '"+cTpSald+"' " +CRLF
	cQuery +=          " AND "+cTabMes+"_DATA <= '"+DTOS(FirstDay(dDataNew)-1)+"' " +CRLF
	
	cQuery +=          " GROUP BY " +CRLF
	
	cQuery +=" "+Right(cGrpMes,Len(cGrpMes)-1)+"  " +CRLF
	
	//-------------------------Diario --------------------------------------
	cQuery +=   " UNION ALL " +CRLF
	
	cQuery +=       " SELECT " +CRLF
	
	cQuery +=          " 0 SALDODEB " +CRLF
	cQuery +=          " ,0 SALDOCRD " +CRLF
	cQuery +=          " ,SUM("+cTabDia+"_DEBITO) SLDANTDEB " +CRLF
	cQuery +=          " ,SUM("+cTabDia+"_CREDIT) SLDANTCRD  " +CRLF
	cQuery +=          " ,0 SALDODEBLP " +CRLF
	cQuery +=          " ,0 SALDOCRDLP " +CRLF
	cQuery +=          " ,0 SALDODEBATU " +CRLF
	cQuery +=          " ,0 SALDOCRDATU " +CRLF
	cQuery +=          " "+cCpoDia+"  " +CRLF
	
	cQuery +=      " FROM "+RetSqlName(cTabDia) +CRLF
	cQuery +=      " WHERE " +CRLF
	
	cQuery +=          " D_E_L_E_T_ = '' " +CRLF
	cQuery +=          " AND "+cFilDia+" "+CRLF
	
	If cArqBase != "CTU"
		If cConta != Nil
			cQuery +=   " AND "+cTabDia+"_CONTA = '"+cConta+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTT/CTD/CTH' .And. cCCusto != Nil
			cQuery +=   " AND "+cTabDia+"_CCUSTO = '"+cCCusto+"' " +CRLF
			
		EndIf
		If  cArqBase $ 'CTD/CTH' .And. cItem != Nil
			cQuery +=   " AND "+cTabDia+"_ITEM = '"+cItem+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTH' .And. cClasse != Nil
			cQuery +=   " AND "+cTabDia+"_CLVL = '"+cClasse+"'" +CRLF
		EndIf
	Else
		cQuery +=   " AND "+cTabDia+"_IDENT = '"+cIdent+"' " +CRLF
		cQuery +=   " AND "+cTabDia+"_CODIGO = '"+cCodigo+"' " +CRLF
	EndIf
	
	cQuery +=          " AND "+cTabDia+"_MOEDA = '"+cMoeda+"' " +CRLF
	cQuery +=          " AND "+cTabDia+"_TPSALD = '"+cTpSald+"' " +CRLF
	
	cQuery +=          " AND "+cTabDia+"_DATA >= '"+DTOS(FirstDay(dDataNew))+"' " +CRLF
	cQuery +=          " AND "+cTabDia+"_DATA < '"+DTOS(dDataNew)+"' " +CRLF
	
	cQuery +=          " GROUP BY " +CRLF
	
	cQuery +=" "+Right(cGrpDia,Len(cGrpDia)-1)+"  " +CRLF
	//---------------------Saldo Antes Lucros e Perdas ---------------------------------------
	If lImpAntLP
		
		cQuery +=          " UNION ALL  " +CRLF
		
		cQuery +=          " SELECT  " +CRLF
		cQuery +=          "  0 SALDODEB " +CRLF
		cQuery +=          " ,0 SALDOCRD " +CRLF
		cQuery +=          " ,0 SLDANTDEB " +CRLF
		cQuery +=          " ,0 SLDANTCRD " +CRLF
		cQuery +=          " ,SUM("+cTabMes+"_DEBITO) SALDODEBLP " +CRLF
		cQuery +=          " ,SUM("+cTabMes+"_CREDIT) SALDOCRDLP " +CRLF
		cQuery +=          " ,0 SALDODEBATU " +CRLF
		cQuery +=          " ,0 SALDOCRDATU " +CRLF
		cQuery +=          " "+cCpoMes+"  " +CRLF
		
		cQuery +=          " FROM  " +RetSqlName(cTabMes) +CRLF
		cQuery +=          " WHERE  " +CRLF
		cQuery +=          " D_E_L_E_T_ = ''  " +CRLF
		cQuery +=           " AND "+cFilMes+" "+CRLF
		If cArqBase != "CTU"
			If cConta != Nil
				cQuery +=   " AND "+cTabMes+"_CONTA = '"+cConta+"' " +CRLF
			EndIf
			If  cArqBase $ 'CTT/CTD/CTH' .And. cCCusto != Nil
				cQuery +=   " AND "+cTabMes+"_CCUSTO = '"+cCCusto+"' " +CRLF
				
			EndIf
			If  cArqBase $ 'CTD/CTH' .And. cItem != Nil
				cQuery +=   " AND "+cTabMes+"_ITEM = '"+cItem+"' " +CRLF
			EndIf
			If  cArqBase $ 'CTH' .And. cClasse != Nil
				cQuery +=   " AND "+cTabMes+"_CLVL = '"+cClasse+"'" +CRLF
			EndIf
		Else
			cQuery +=   " AND "+cTabMes+"_IDENT = '"+cIdent+"' " +CRLF
			cQuery +=   " AND "+cTabMes+"_CODIGO = '"+cCodigo+"' " +CRLF
		EndIf
		cQuery +=          " AND "+cTabMes+"_MOEDA = '"+cMoeda+"' " +CRLF
		cQuery +=          " AND "+cTabMes+"_TPSALD = '"+cTpSald+"' " +CRLF
		
		cQuery +=          " AND "+cTabMes+"_DATA <= '"+DTOS(FirstDay(dDataNew)-1)+"'  " +CRLF
		cQuery +=          " AND "+cTabMes+"_LP    = 'Z'   " +CRLF
		cQuery +=          " AND "+cTabMes+"_DTLP  = '"+DTOS(dDataLP)+"' " +CRLF
		
		cQuery +=          " GROUP BY  " +CRLF
		
		cQuery +=" "+Right(cGrpMes,Len(cGrpMes)-1)+"  " +CRLF
		
		cQuery +=          " UNION ALL  " +CRLF
		cQuery +=          " SELECT  " +CRLF
		
		cQuery +=          " 0 SALDODEB  " +CRLF
		cQuery +=          " ,0 SALDOCRD  " +CRLF
		cQuery +=          " ,0 SLDANTDEB  " +CRLF
		cQuery +=          " ,0 SLDANTCRD  " +CRLF
		cQuery +=          " ,SUM("+cTabDia+"_DEBITO) SALDODEBLP  " +CRLF
		cQuery +=          " ,SUM("+cTabDia+"_CREDIT) SALDOCRDLP  " +CRLF
		cQuery +=          " ,0 SALDODEBATU " +CRLF
		cQuery +=          " ,0 SALDOCRDATU " +CRLF
		cQuery +=          " "+cCpoDia+"  " +CRLF
		
		cQuery +=          " FROM "+RetSqlName(cTabDia) +CRLF
		cQuery +=          " WHERE  " +CRLF
		cQuery +=          " D_E_L_E_T_ = ''  " +CRLF
		cQuery +=           " AND "+cFilDia+" "+CRLF
		If cArqBase != "CTU"
			If cConta != Nil
				cQuery +=   " AND "+cTabDia+"_CONTA = '"+cConta+"' " +CRLF
			EndIf
			If  cArqBase $ 'CTT/CTD/CTH' .And. cCCusto != Nil
				cQuery +=   " AND "+cTabDia+"_CCUSTO = '"+cCCusto+"' " +CRLF
				
			EndIf
			If  cArqBase $ 'CTD/CTH' .And. cItem != Nil
				cQuery +=   " AND "+cTabDia+"_ITEM = '"+cItem+"' " +CRLF
			EndIf
			If  cArqBase $ 'CTH' .And. cClasse != Nil
				cQuery +=   " AND "+cTabDia+"_CLVL = '"+cClasse+"'" +CRLF
			EndIf
		Else
			cQuery +=   " AND "+cTabDia+"_IDENT = '"+cIdent+"' " +CRLF
			cQuery +=   " AND "+cTabDia+"_CODIGO = '"+cCodigo+"' " +CRLF
		EndIf
		cQuery +=          " AND "+cTabDia+"_MOEDA = '"+cMoeda+"' " +CRLF
		cQuery +=          " AND "+cTabDia+"_TPSALD = '"+cTpSald+"' " +CRLF
		
		cQuery +=          " AND "+cTabDia+"_DATA >= '"+DTOS(FirstDay(dDataNew))+"'  " +CRLF
		cQuery +=          " AND "+cTabDia+"_DATA <= '"+DTOS(dDataNew)+"' " +CRLF
		cQuery +=          " AND "+cTabDia+"_LP    = 'Z'   " +CRLF
		cQuery +=          " AND "+cTabDia+"_DTLP  = '"+DTOS(dDataLP)+"'  " +CRLF
		
		cQuery +=          " GROUP BY  " +CRLF
		cQuery +=" "+Right(cGrpDia,Len(cGrpDia)-1)+"  " +CRLF
	EndIf

	//------------------------------------------ Saldo Atual ------------------------------------
	//------------------------------Mensal----------------------------------
	cQuery +=       " UNION ALL	 " +CRLF
	
	cQuery +=       " SELECT  " +CRLF
	
	cQuery +=          " 0 SALDODEB " +CRLF
	cQuery +=          " ,0 SALDOCRD " +CRLF
	cQuery +=          " ,0 SLDANTDEB " +CRLF
	cQuery +=          " ,0 SLDANTCRD " +CRLF
	cQuery +=          " ,0 SALDODEBLP " +CRLF
	cQuery +=          " ,0 SALDOCRDLP " +CRLF
	cQuery +=          " ,SUM("+cTabMes+"_DEBITO) SALDODEBATU " +CRLF
	cQuery +=          " ,SUM("+cTabMes+"_CREDIT) SALDOCRDATU " +CRLF
	cQuery +=          " "+cCpoMes+"  " +CRLF
	
	cQuery +=       " FROM " + RetSqlName(cTabMes) +CRLF
	cQuery +=       " WHERE " +CRLF
	cQuery +=          " D_E_L_E_T_ = '' " +CRLF
	cQuery +=          " AND "+ cFilMes +CRLF
	
	If cArqBase != "CTU"
		If cConta != Nil
			cQuery +=   " AND "+cTabMes+"_CONTA = '"+cConta+"' " +CRLF
		EndIf
		
		If  cArqBase $ 'CTT/CTD/CTH' .And. cCCusto != Nil
			cQuery +=   " AND "+cTabMes+"_CCUSTO = '"+cCCusto+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTD/CTH' .And. cItem != Nil
			cQuery +=   " AND "+cTabMes+"_ITEM = '"+cItem+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTH' .And. cClasse != Nil
			cQuery +=   " AND "+cTabMes+"_CLVL = '"+cClasse+"'" +CRLF
		EndIf
	Else
		cQuery +=   " AND "+cTabMes+"_IDENT = '"+cIdent+"' " +CRLF
		cQuery +=   " AND "+cTabMes+"_CODIGO = '"+cCodigo+"' " +CRLF
	EndIf
	cQuery +=          " AND "+cTabMes+"_MOEDA = '"+cMoeda+"' " +CRLF
	cQuery +=          " AND "+cTabMes+"_TPSALD = '"+cTpSald+"' " +CRLF
	cQuery +=          " AND "+cTabMes+"_DATA <= '"+DTOS(FirstDay(dDataNew)-1)+"' " +CRLF
	
	cQuery +=          " GROUP BY " +CRLF
	
	cQuery +=" "+Right(cGrpMes,Len(cGrpMes)-1)+"  " +CRLF
	
	//-------------------------Diario --------------------------------------
	cQuery +=   " UNION ALL " +CRLF
	
	cQuery +=       " SELECT " +CRLF
	
	cQuery +=          " 0 SALDODEB " +CRLF
	cQuery +=          " ,0 SALDOCRD " +CRLF
	cQuery +=          " ,0 SLDANTDEB " +CRLF
	cQuery +=          " ,0 SLDANTCRD " +CRLF
	cQuery +=          " ,0 SALDODEBLP " +CRLF
	cQuery +=          " ,0 SALDOCRDLP " +CRLF
	cQuery +=          " ,SUM("+cTabDia+"_DEBITO) SALDODEBATU " +CRLF
	cQuery +=          " ,SUM("+cTabDia+"_CREDIT) SALDOCRDATU " +CRLF
	cQuery +=          " "+cCpoDia+"  " +CRLF
	
	cQuery +=      " FROM "+RetSqlName(cTabDia) +CRLF
	cQuery +=      " WHERE " +CRLF
	
	cQuery +=          " D_E_L_E_T_ = '' " +CRLF
	cQuery +=          " AND "+cFilDia+" "+CRLF
	
	If cArqBase != "CTU"
		If cConta != Nil
			cQuery +=   " AND "+cTabDia+"_CONTA = '"+cConta+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTT/CTD/CTH' .And. cCCusto != Nil
			cQuery +=   " AND "+cTabDia+"_CCUSTO = '"+cCCusto+"' " +CRLF
			
		EndIf
		If  cArqBase $ 'CTD/CTH' .And. cItem != Nil
			cQuery +=   " AND "+cTabDia+"_ITEM = '"+cItem+"' " +CRLF
		EndIf
		If  cArqBase $ 'CTH' .And. cClasse != Nil
			cQuery +=   " AND "+cTabDia+"_CLVL = '"+cClasse+"'" +CRLF
		EndIf
	Else
		cQuery +=   " AND "+cTabDia+"_IDENT = '"+cIdent+"' " +CRLF
		cQuery +=   " AND "+cTabDia+"_CODIGO = '"+cCodigo+"' " +CRLF
	EndIf
	
	cQuery +=          " AND "+cTabDia+"_MOEDA = '"+cMoeda+"' " +CRLF
	cQuery +=          " AND "+cTabDia+"_TPSALD = '"+cTpSald+"' " +CRLF
	
	cQuery +=          " AND "+cTabDia+"_DATA >= '"+DTOS(FirstDay(dDataNew))+"' " +CRLF
	cQuery +=          " AND "+cTabDia+"_DATA <= '"+DTOS(dDataNew)+"' " +CRLF
	
	cQuery +=          " GROUP BY " +CRLF
	
	cQuery +=" "+Right(cGrpDia,Len(cGrpDia)-1)+"  " +CRLF

	
	
	cQuery +="		) SALDO " +CRLF
	cQuery +="	  GROUP BY " +CRLF
	
	cQuery +=" "+Right(cCpoTot,Len(cCpoTot)-1)+"  " +CRLF
	
	cQuery +=" ORDER BY " +CRLF
	
	cQuery +=" "+Right(cCpoTot,Len(cCpoTot)-1)+"  " +CRLF
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cTRB) > 0
		dbSelectArea(cTRB)
		(cTRB)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTRB,.T.,.F.)
	
	TcSetField(cTRB,"SLDANTDEB"  ,"N",aTamVlr[1],aTamVlr[2])
	TcSetField(cTRB,"SLDANTCRD"  ,"N",aTamVlr[1],aTamVlr[2])
	TcSetField(cTRB,"SALDODEB"  ,"N",aTamVlr[1],aTamVlr[2])
	TcSetField(cTRB,"SALDOCRD"  ,"N",aTamVlr[1],aTamVlr[2])
	TcSetField(cTRB,"SALDODEBLP"  ,"N",aTamVlr[1],aTamVlr[2])
	TcSetField(cTRB,"SALDOCRDLP"  ,"N",aTamVlr[1],aTamVlr[2])
	TcSetField(cTRB,"SALDODEBATU"  ,"N",aTamVlr[1],aTamVlr[2])
	TcSetField(cTRB,"SALDOCRDATU"  ,"N",aTamVlr[1],aTamVlr[2])
	
	If (cTRB)->(!EOF())
		
		lAchouNoDia := dDataNew == dData
		
		nAtuDeb		:= (cTRB)->SALDODEBATU
		nAtuCrd		:= (cTRB)->SALDOCRDATU
		nDebLP			:= (cTRB)->SALDODEBLP
		nCrdLP			:= (cTRB)->SALDOCRDLP
		
		IF lAchouNoDia						//Se achou saldo na data solicitada
			nAntDeb		:= (cTRB)->SLDANTDEB
			nAntCrd		:= (cTRB)->SLDANTCRD
			nDebito		:= (cTRB)->SALDODEB
			nCredito		:= (cTRB)->SALDOCRD
		Else
			nAntDeb		:= nAtuDeb 	
			nAntCrd		:= nAtuCrd  
		EndIf
				
		If lImpAntLP
			nAntDeb -= nDebLP
			nAntCrd -= nCrdLP
			nAtuDeb -= nDebLP
			nAtuCrd -= nCrdLP
		EndIf

		nSaldoAnt		:= nAntCrd - nAntDeb 
		nSaldoAtu		:= nAtuCrd - nAtuDeb
	EndIf
	
EndIf

If Select(cTRB) > 0
	dbSelectArea(cTRB)
	(cTRB)->(dbCloseArea())
Endif

RestArea(aArea)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno:                                             ³
//³ [1] Saldo Atual (com sinal)                          ³
//³ [2] Debito na Data                                   ³
//³ [3] Credito na Data                                  ³
//³ [4] Saldo Atual Devedor                              ³
//³ [5] Saldo Atual Credor                               ³
//³ [6] Saldo Anterior (com sinal)                       ³
//³ [7] Saldo Anterior Devedor                           ³
//³ [8] Saldo Anterior Credor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//      [1]       [2]     [3]      [4]     [5]     [6]       [7]     [8]
Return {nSaldoAtu,nDebito,nCredito,nAtuDeb,nAtuCrd,nSaldoAnt,nAntDeb,nAntCrd}

// 08/08/18 - Luis Felipe - INICIO

*--------------------------------------*
Static Function FLanCt2(_xFilial,cConta)
*--------------------------------------*

Local lLanc  := .f.
Local cAlias := GetNextAlias()
Local cQuery := ""

cQuery += " SELECT COUNT(*) NREGS"
cQuery += " FROM "+RetSqlName("CT2")
cQuery += " WHERE D_E_L_E_T_ = ''"
cQuery += " AND CT2_FILIAL = '"+_xFilial+"'"
cQuery += " AND YEAR(CT2_DATA) = '"+Str(Year(MV_PAR03),4)+"'"
cQuery += " AND MONTH(CT2_DATA) = '"+Strzero(Month(MV_PAR03),2)+"'"
cQuery += " AND (CT2_DEBITO = '"+cConta+"' OR CT2_CREDIT = '"+cConta+"')"

cQuery := ChangeQuery(cQuery)

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
Endif

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

Dbselectarea(cAlias)

lLanc := If((cAlias)->NREGS<> 0,.t.,.f.)

(cAlias)->(DbCloseArea())

Return(lLanc) 

// 08/08/18 - Luis Felipe - FIM
