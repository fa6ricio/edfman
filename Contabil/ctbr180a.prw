#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "CTBR180.CH"
                                                                                                                 
static TAM_VALOR := 25

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                                    
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR180  ³ Autor ³ Cicero J. Silva   	³ Data ³ 04.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±                    
±±³Descri‡…o ³ Balancete Centro de Custo/Conta         			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr180()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ SIGACTB      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                            
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CTBR180A()

Local aArea := GetArea()
Local oReport

Local lOk 			:= .T.
Local aCtbMoeda		:= {}
Local nDivide		:= 1

PRIVATE cTipoAnt	:= ""
PRIVATE cPerg	 	:= "CTR180"
PRIVATE nomeProg  := "CTBR180"
PRIVATE titulo
PRIVATE aSelFil	:= {}     
PRIVATE lImpR4  := TRepInUse()

If lImpR4
	
	Pergunte(cPerg,.T.) // Precisa ativar as perguntas antes das definicoes.
	
	If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
		lOk := .F.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
	//³ Gerencial -> montagem especifica para impressao)			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    if ! Empty( mv_par08 )
    	lOK := VdSetOfBook( mv_par08 , .F. ) // codigo do livro , visao gerencial
	endif
	
	If lOk
		If mv_par24 == 2			// Divide por cem
			nDivide := 100
		
		ElseIf mv_par24 == 3		// Divide por mil
			nDivide := 1000
		
		ElseIf mv_par24 == 4		// Divide por milhao
			nDivide := 1000000
		
		EndIf
		
		aCtbMoeda := CtbMoeda( mv_par10 , nDivide ) // Moeda?

		If Empty( aCtbMoeda[1] )
			Help(" ",1,"NOMOEDA")
			lOk := .F.
		Endif 
	Endif
	
	If lOk .And. mv_par37 == 1 .And. Len( aSelFil ) <= 0
		aSelFil := AdmGetFil()
		If Len( aSelFil ) <= 0
			lOk := .F.
		EndIf 
	EndIf     
	
	If lOk
		If (mv_par34 == 1) .and. ( Empty(mv_par35) .or. Empty(mv_par36) )
			cMensagem	:= "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou "
			cMensagem	+= "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
			MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des") //"Ignora Sl Ant.Rec/Des"
			lOk	:= .F.
		EndIf
	EndIf

	If lOk
		oReport := ReportDef( aCtbMoeda, nDivide )

		If Valtype( oReport ) == 'O'
			oReport:PrintDialog()
		Endif

		oReport := nil
	EndIf
Else
	CTBR180R3() // Executa versão anterior do fonte
Endif

//Limpa os arquivos temporários 
CTBGerClean()

RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Cicero J. Silva    º Data ³  01/08/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ aCtbMoeda  - Matriz ref. a moeda                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGACTB                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef( aCtbMoeda, nDivide )

Local oReport
Local oSection1
Local oSection2
Local oTotais

Local cSayCC		:= CtbSayApro("CTT")

Local cDesc1 		:= OemToAnsi("Este programa ira imprimir o Balancete de ")+ Upper(cSayCC)+ " / " + Upper(OemToAnsi("Conta"))	//"Este programa ira imprimir o Balancete de  / Conta "
Local cDesc2 		:= OemToansi("de acordo com os parametros solicitados pelo Usuario")  

Local aTamCC    	:= TAMSX3( "CTT_CUSTO" )
Local aTamCCRes 	:= TAMSX3( "CTT_RES"   )
Local aTamConta		:= TAMSX3( "CT1_CONTA" )
Local aTamCtaRes	:= TAMSX3( "CT1_RES"   )
Local nTamCC  		:= Len( CriaVar( "CTT->CTT_DESC"+mv_par10))
Local nTamCta 		:= Len( CriaVar( "CT1->CT1_DESC"+mv_par10))
Local nTamGrupo		:= Len( CriaVar( "CT1->CT1_GRUPO"))

Local lPula			:= .T.

Local lPrintZero	:= Iif(mv_par22==1,.T.,.F.)
Local lPulaSint		:= Iif(mv_par21==1,.T.,.F.)
Local lPulaPag		:= Iif(mv_par20==1,.T.,.F.)
Local lCCNormal		:= Iif(mv_par23==1,.T.,.F.)
Local lCNormal		:= Iif(mv_par25==1,.T.,.F.)

Local cSegAte   	:= mv_par14 // Imprimir ate o Segmento?

Local nDigitAte		:= 0
Local lMov		:= IIF( mv_par19 == 1 , .T. ,.F.) // Imprime movimento ?
Local cCCNormal

Local cSepara1		:= ""
Local cSepara2		:= ""
Local aSetOfBook := CTBSetOf(mv_par08)

Local cMascara1		:= IIF (Empty(aSetOfBook[2]),GetMv("MV_MASCARA"),RetMasCtb(aSetOfBook[2],@cSepara1))//Mascara da Conta
Local cMascara2		:= IIF (Empty(aSetOfBook[6]),GetMv("MV_MASCCUS"),RetMasCtb(aSetOfBook[6],@cSepara2))//Mascara do Centro de Custo

Local cPicture 		:= aSetOfBook[4]
Local nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)
Local cDescMoeda 	:= aCtbMoeda[2]

Local bCdCUSTO	:= {|| EntidadeCTB(cArqTmp->CUSTO,0,0,20,.F.,cMascara2,cSepara2,,,,,.F.) }
Local bCdCCRES	:= {|| EntidadeCTB(cArqTmp->CCRES,0,0,20,.F.,cMascara2,cSepara2,,,,,.F.) }

Local bCdCONTA	:= {|| EntidadeCTB(cArqTmp->CONTA,0,0,25 ,.F.,cMascara1,cSepara1,,,,,.F.)}
Local bCdCTRES	:= {|| EntidadeCTB(cArqTmp->CTARES,0,0,20,.F.,cMascara1,cSepara1,,,,,.F.)}

titulo	:= OemToAnsi("Balancete de Verificacao")+ Upper(cSayCC)+ " / " +  Upper(OemToAnsi("Conta"))	//"Balancete de Verificacao  / Conta"


oReport := TReport():New(nomeProg,titulo,cPerg,{|oReport| ReportPrint(oReport,aSetOfBook,cDescMoeda,cSayCC,nDivide,cMascara1,cMascara2,cSepara1,cSepara2,cPicture,nDecimais)},cDesc1+cDesc2)
oReport:SetLandScape(.T.)
oReport:DisableOrientation()

// Sessao 1
oSection1 := TRSection():New(oReport,cSayCC ,{"cArqTmp","CTT"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) //"Conta"

oReport:SetTotalInLine(.F.)
oReport:EndPage(.T.)

//Somente sera impresso centro de custo analitico
TRCell():New(oSection1,	"CUSTO"	,"cArqTmp","C.Custo",/*Picture*/,aTamCC[1]*2-1		,/*lPixel*/,bCdCUSTO, /*"LEFT"*/,,/*"LEFT"*/,,,.F.)
TRCell():New(oSection1,	"CCRES"	,"cArqTmp","Cód. Reduzido"	,/*Picture*/,aTamCCRes[1]	,/*lPixel*/,bCdCCRES, /*"LEFT"*/,,/*"LEFT"*/,,,.F.) //"Cód. Reduzido"
TRCell():New(oSection1,	"DESCCC","cArqTmp","Descricao"	,/*Picture*/,nTamCC			,/*lPixel*/,/*{|| }*/, /*"LEFT"*/,,/*"LEFT"*/,,,.F.) //"Descricao"


If lCCNormal
	oSection1:Cell("CCRES"	):Disable()
Else
	oSection1:Cell("CUSTO"	):Disable()
EndIf

If lPulaPag
	oSection1:SetPageBreak(.T.)
EndIf

// Sessao 2
oSection2 := TRSection():New(oReport,"Conta",{"cArqTmp","CT1"},/*aOrder*/,/*lLoadCells*/,/*lLoadOrder*/) //"Conta"
oSection2:SetTotalInLine(.F.)
oSection2:SetHeaderPage()

TRCell():New(oSection2,"CUSTO"		,"cArqTmp","C.Custo",/*Picture*/,aTamCC[1]*2-1		,/*lPixel*/,bCdCUSTO, /*"LEFT"*/,,/*"LEFT"*/,,,.F.)
TRCell():New(oSection2,"CONTA"		,"cArqTmp","Conta",/*Picture*/,aTamConta[1]		,/*lPixel*/, bCdCONTA )// Codigo da Conta //"Código"
TRCell():New(oSection2,"CTARES"		,"cArqTmp","Cód. Reduzido",/*Picture*/,aTamCtaRes[1]	,/*lPixel*/, bCdCTRES )// Codigo Reduzido da Conta //"Cód. Reduzido"
TRCell():New(oSection2,"DESCCTA"	,"cArqTmp","Descricao",/*Picture*/,nTamCta			,/*lPixel*/,/*{|| }*/ )// Descricao da Conta //"Descricao"
TRCell():New(oSection2,"SALDOANT"	,"cArqTmp","Saldo anterior",/*Picture*/,TAM_VALOR+2		,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDOANT ,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)}, /*"RIGHT"*/,,"RIGHT",,,.F.)// Saldo Anterior //"Saldo anterior"
TRCell():New(oSection2,"SALDODEB"	,"cArqTmp","Débito",/*Picture*/,TAM_VALOR+2		,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDODEB ,,,TAM_VALOR  ,nDecimais,.F.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)}, /*"RIGHT"*/,,"RIGHT",,,.F.)// Debito //"Débito"
TRCell():New(oSection2,"SALDOCRD"	,"cArqTmp","Crédito",/*Picture*/,TAM_VALOR+2		,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDOCRD ,,,TAM_VALOR  ,nDecimais,.F.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)}, /*"RIGHT"*/,,"RIGHT",,,.F.)// Credito //"Crédito"

If lMov //Imprime Coluna Movimento!!
	TRCell():New(oSection2,"MOVIMENTO","cArqTmp","Movimento do periodo",/*Picture*/,TAM_VALOR+2	,/*lPixel*/,{|| ValorCTB(cArqTmp->MOVIMENTO,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)}, /*"RIGHT"*/,,"RIGHT",,,.F.)// Movimento do Periodo //"Movimento do periodo"
EndIf

TRCell():New(oSection2,"SALDOATU"	,"cArqTmp","Saldo atual",/*Picture*/,TAM_VALOR+2		,/*lPixel*/,{|| ValorCTB(cArqTmp->SALDOATU ,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.)}, /*"RIGHT"*/,,"RIGHT",,,.F.)// Saldo Atual //"Saldo atual"

TRPosition():New( oSection2, "CT1", 1, {|| xFilial("CT1") + cArqTMP->CONTA })

If lCNormal
	oSection2:Cell("CTARES"):Disable()
Else
	oSection2:Cell("CONTA"	):Disable()
EndIf

oSection2:Cell("SALDOANT"):SetAlign("RIGHT")
oSection2:Cell("SALDODEB"):SetAlign("RIGHT")
oSection2:Cell("SALDOCRD"):SetAlign("RIGHT")
oSection2:Cell("SALDOATU"):SetAlign("RIGHT")

oSection2:Cell("SALDOANT"):lHeaderSize	:= .F.
oSection2:Cell("SALDODEB"):lHeaderSize	:= .F.
oSection2:Cell("SALDOCRD"):lHeaderSize	:= .F.
oSection2:Cell("SALDOATU"):lHeaderSize	:= .F.  

If lMov //Imprime Coluna Movimento!!
//	oSection2:Cell("MOVIMENTO"):SetHeaderAlign("RIGHT")
	oSection2:Cell("MOVIMENTO"):SetAlign("RIGHT")
	oSection2:Cell("MOVIMENTO"):lHeaderSize	:= .F.
Endif

oSection2:OnPrintLine( {|| ( IIf( lPulaSint .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2")), oReport:SkipLine(),NIL),;
									cTipoAnt := cArqTmp->TIPOCONTA;
									)  })

// Totais das sessoes
oTotais := TRSection():New( oReport,"Total",,, .F., .F. ) 

TRCell():New( oTotais,"TOT"			,,""		,/*Picture*/,aTamConta[1] + nTamCta - 2 /*Size*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oTotais,"TOT_SPACE"	,,""		,/*Picture*/,1/*Size*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New( oTotais,"TOT_ANT"		,,"A N T E R I O R"	,/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| code-block de impressao }*/) //"A N T E R I O R"
TRCell():New( oTotais,"TOT_DEBITO"	,,"D E B I T O    "	,/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| code-block de impressao }*/) //"D E B I T O    "
TRCell():New( oTotais,"TOT_CREDITO"	,,"C R E D I T O  "	,/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| code-block de impressao }*/) //"C R E D I T O  "

If lMov
	TRCell():New( oTotais, "TOT_MOV"	,,"M O V I M E N T O",/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| code-block de impressao }*/) //"M O V I M E N T O"
	oTotais:Cell("TOT_MOV"):HideHeader()
	oTotais:Cell("TOT_MOV"):SetAlign("RIGHT")
	oTotais:Cell("TOT_MOV"):lHeaderSize := .F.
EndIf

TRCell():New( oTotais,"TOT_ATU"		,,"A T U A L",/*Picture*/,TAM_VALOR+2,/*lPixel*/,/*{|| code-block de impressao }*/) //"A T U A L"

If lCNormal
	oTotais:Cell("TOT"):SetSize(aTamConta[1] + nTamCta - 1 )
Else
   	oTotais:Cell("TOT"):SetSize(aTamCtaRes[1] + nTamCta - 1 )
Endif

oTotais:Cell("TOT_ANT"    ):HideHeader()
oTotais:Cell("TOT_DEBITO" ):HideHeader()
oTotais:Cell("TOT_CREDITO"):HideHeader()
oTotais:Cell("TOT_ATU"    ):HideHeader()

oTotais:Cell("TOT_ANT"    ):SetAlign("RIGHT")
oTotais:Cell("TOT_DEBITO" ):SetAlign("RIGHT")
oTotais:Cell("TOT_CREDITO"):SetAlign("RIGHT")
oTotais:Cell("TOT_ATU"    ):SetAlign("RIGHT")

oTotais:Cell("TOT_ANT"    ):lHeaderSize	:= .F.  
oTotais:Cell("TOT_DEBITO" ):lHeaderSize	:= .F.  
oTotais:Cell("TOT_CREDITO"):lHeaderSize	:= .F.  
oTotais:Cell("TOT_ATU"    ):lHeaderSize	:= .F.  

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrintº Autor ³ Cicero J. Silva    º Data ³  14/07/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportPrint(oReport,aSetOfBook,cDescMoeda,cSayCC,nDivide,cMascara1,cMascara2,cSepara1,cSepara2,cPicture,nDecimais)

Local oSection1 	:= oReport:Section(1)
Local oSection2		:= oReport:Section(2)
Local oTotais		:= oReport:Section(3)

Local cArqTmp		:= ""
Local cFiltro		:= oSection2:GetAdvplExp('CT1')
Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+mv_par10))

Local dDataLP		:= mv_par27
Local dDataFim		:= mv_par02
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)
Local lMov			:= IIF(mv_par19 == 1,.T.,.F.) // Imprime movimento ?
Local lPrintZero	:= Iif(mv_par22==1,.T.,.F.)
Local lImpAntLP		:= Iif(mv_par26==1,.T.,.F.)
Local lRecDesp0		:= Iif(mv_par34==1,.T.,.F.)
Local lCttSint 		:= Iif(mv_par33 == 1 .or. mv_par33 == 3,.T.,.F.)
Local cRecDesp		:= mv_par35
Local dDtZeraRD		:= mv_par36
Local cSegAte   	:= mv_par14

Local aTotCCSup		:= {0,0,0,0,0}	//{Saldo Ant,Debito,Credito,Movimento,Saldo Atual}
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nCCTMov 		:= 0
Local nTotCCDeb		:= 0
Local nTotCCCrd		:= 0
Local nCCSldAnt		:= 0
Local nCCSldAtu		:= 0
Local nTotSldAnt	:= 0
Local nTotSldAtu	:= 0
Local nDigitAte		:= 0
Local nDigCCAte		:= 0
Local nRegTmp		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0
Local cFiltCTT		:=oSection1:Getadvplexp('CTT')	
Local cmask1,cmask2
Local nCont    := 0
Local lCNormal		:= Iif(mv_par25==1,.T.,.F.)
Local aTamConta		:= TAMSX3( "CT1_CONTA" )
Local aTamCtaRes	:= TAMSX3( "CT1_RES"   )  
Local aSaldos		:= {}
Local nPos 			:= 0

SaveInter()

If oReport:GetOrientation() == 1 //retrato
	TAM_VALOR := 22     
	
	oSection2:Cell( "DESCCTA" ):SetSize(18, .F.)
	oSection2:Cell( "DESCCTA" ):SetLineBreak()
	oTotais:Cell("TOT"):SetSize( oTotais:Cell("TOT"):GetSize() - ( Len( CriaVar( "CT1->CT1_DESC"+mv_par10)) - 18 ) )
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par07 == 1		/// Se imprime somente contas sinteticas
	Titulo:=	OemToAnsi("BALANCETE SINTETICO DE  ") + Upper(cSayCC) + "/" + Upper(OemToAnsi("Conta"))//"BALANCETE SINTETICO DE  "
ElseIf mv_par07 == 2		/// Se imprime somente contas analiticas
	Titulo:=	OemToAnsi("BALANCETE ANALITICO DE  ") + Upper(cSayCC) + "/" + Upper(OemToAnsi("Conta"))//"BALANCETE ANALITICO DE  "
ElseIf mv_par07 == 3
	Titulo:=	OemToAnsi("BALANCETE DE  ") + Upper(cSayCC)	+  "/" + Upper(OemToAnsi("Conta"))//"BALANCETE DE  "
EndIf

Titulo += 	OemToAnsi(STR0009) + DTOC(mv_par01) + OemToAnsi(STR0010) + Dtoc(mv_par02) + ;
OemToAnsi(STR0011) + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
EndIf

If nDivide > 1
	Titulo += " (" + OemToAnsi(STR0022) + Alltrim(Str(nDivide)) + ")"
EndIf

oReport:SetPageNumber(mv_par11) //mv_par14	-	Pagina Inicial
oReport:SetCustomText( {|| CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao					     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
			CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
						mv_par01,mv_par02,"CT3","",mv_par03,mv_par04,mv_par05,mv_par06,,,,,mv_par10,;
						mv_par12,aSetOfBook,mv_par15,mv_par16,mv_par17,mv_par18,;
						!lMov,.T.,,"CTT",lImpAntLP,dDataLP, nDivide,lVlrZerado,,,;
						mv_par29,mv_par30,mv_par31,mv_par32,,,,,,,,,cFiltro,lRecDesp0,;
						cRecDesp,dDtZeraRD,,,,,,,,,aSelFil,,,,,,,,lCttSint)},;
				OemToAnsi(OemToAnsi(STR0014)),;  //"Criando Arquivo Tempor rio..."
				OemToAnsi(STR0003)+Upper(cSayCC)+ " / "+Upper(OemToAnsi(STR0021)))     //"Balancete Verificacao "
		
dbSelectArea("cArqTmp")
dbGoTop()    

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. ! Empty(aSetOfBook[5])
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
	
	oReport:Cancel()

	Return .F.
Endif

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	nDigitAte := CtbRelDig(cSegAte,cMascara1) 	
EndIf

// Verifica Se existe filtragem Ate o Segmento de C.Custo
If !Empty(mv_par28)
	nDigCCAte := CtbRelDig(mv_par28,cMascara2) 	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a impressao do relatorio                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dbSelectArea("cArqTmp")
//dbGotop()

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial
//nao esta disponivel e sai da rotina.

aSaldos := SldCCusto(oReport)

CTT->(DbSetOrder(1))

If ! ( RecCount() == 0 ) .And. Empty( aSetOfBook[5] )
	
	cGrupo := cArqTmp->GRUPO
	
	While mv_par33 == 1 .And. cArqTmp->TIPOCC == "2"
		dbSkip()
		cCusto := cArqTmp->CUSTO
	EndDo 
	
	
	
	While ! Eof()   
	
		If f180Fil( cSegAte, nDigitAte, nDigCCAte, cMascara1 , cMascara2 ) // regra de skip do relatorio
			dbSelectArea("cArqTmp")
			dbSkip()
			Loop
		EndIf

		//Imprime Section(1) Cabecalho                     
		If CTT->( ! DbSeek( xFilial( "CTT" ) + cArqTMP->CUSTO ))
			dbSelectArea("cArqTmp")
			dbSkip()
			Loop
		Else
			If !Empty(cFiltCTT) .And. !CTT->(&(cFiltCTT))
				dbSelectArea("cArqTmp")		
				dbSkip()
				Loop
			Endif		
	
			cCCAnt := cArqTmp->CUSTO 
			
			nPos := aScan( aSaldos, { |x| x[1] == cCCAnt}) 
	
			nCCSldAnt := aSaldos[nPos][2]
			nTotCCDeb := aSaldos[nPos][3]
			nTotCCCrd := aSaldos[nPos][4]
			nCCSldAtu := aSaldos[nPos][5]  
		
			nTotDeb 	:= aSaldos[nPos][3]
			nTotCrd 	:= aSaldos[nPos][4]
			nTotSldAnt	:= aSaldos[nPos][2]
			nTotSldAtu	:= aSaldos[nPos][5]
			nGrpDeb 	:= aSaldos[nPos][3]
			nGrpCrd 	:= aSaldos[nPos][4]
	
			oSection1:Init()
			oSection1:PrintLine()
			oReport:ThinLine()
	
			oSection1:Finish()
			oSection2:Init()
			
			While ! Eof() .And. (cCCAnt == cArqTmp->CUSTO) 
				
				If mv_par13 == 1 .And. cGrupo != cArqTmp->Grupo
					Exit				
				Endif
				
				If f180Fil( cSegAte, nDigitAte, nDigCCAte, cMascara1 , cMascara2 ) // regra de skip do relatorio
					dbSelectArea("cArqTmp")
					dbSkip()
					Loop
				EndIf
				
				IF ( MV_PAR07 == 3 .Or. ( ( MV_PAR07 == 1 .And. cArqTmp->TIPOCONTA == '1' ) .Or. ( MV_PAR07 == 2 .And. cArqTmp->TIPOCONTA == '2' ) ) )
			 		oSection2:PrintLine()
				Endif
				
				dbSkip()
			EndDo
	
			oSection2:Finish()
	
			//
			If mv_par13 == 1 // Grupo Diferente - Totaliza e Quebra
				If cGrupo != cArqTmp->GRUPO
					oTotais:Init()
	
					oTotais:Cell("TOT"):SetTitle(OemToAnsi(STR0019) + cGrupo + " )")
					oTotais:Cell( "TOT_DEBITO"	):SetBlock( { || ValorCTB(nGrpDeb,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
					oTotais:Cell( "TOT_CREDITO"):SetBlock( { || ValorCTB(nGrpCrd,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
					
					oTotais:PrintLine()
					oTotais:Finish()
					oReport:EndPage()
					
					cGrupo	:= cArqTmp->GRUPO
				EndIf
			Else
				If (cCCAnt <> cArqTmp->CUSTO) // Imprime Totalizador do Centro de Custo
					
					oTotais:Cell("TOT"):SetTitle(OemToAnsi(STR0020)+ RTrim( Upper(cSayCC) ) + " : " )
					dbSelectArea("CTT")
					dbSetOrder(1)
					If MsSeek(xFilial("CTT")+cArqTmp->CUSTO)
						cCCSup	:= CTT->CTT_CCSUP	//Centro de Custo Superior
					Else
						cCCSup	:= ""
					EndIf
					If MsSeek(xFilial("CTT")+cCCAnt)
						cAntCCSup := CTT->CTT_CCSUP	//Centro de Custo Superior do Centro de custo anterior.
						cCCRes	  := CTT->CTT_RES
					Else
						cAntCCSup := ""
					EndIf
					dbSelectArea("cArqTmp")
					If mv_par23 == 2 //Se Impr. Cod. Red. C.C
						If CTT->CTT_CUSTO == cCCAnt .And. CTT->CTT_CLASSE == '2' //Se for analitico
							oTotais:Cell( "TOT"):SetBlock( { || EntidadeCTB(cCCRes,0 ,0 ,nTamCC,.F.,cMascara2,cSepara2,"CTT",,,,.F.) } )
						Else
							oTotais:Cell( "TOT"):SetBlock( { || EntidadeCTB(cCCAnt,0 ,0 ,nTamCC,.F.,cMascara2,cSepara2,"CTT",,,,.F.) } )
						EndIf
					Else//Se Imprime Cod. normal do C.Custo
						oTotais:Cell( "TOT"):SetBlock( { || EntidadeCTB(cCCAnt,0 ,0 ,nTamCC,.F.,cMascara2,cSepara2,"CTT",,,,.F.) } )
					Endif

					cCCNormal := Posicione("CTT" , 1 , xFilial("CTT") + cCCAnt , "CTT_NORMAL")

					oTotais:Cell( "TOT_SPACE"   ):SetBlock( { || "" } )
					oTotais:Cell( "TOT_ANT"		):SetBlock( { || ValorCTB(nCCSldAnt,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cCCNormal,,,,,,lPrintZero,.F.) } )
					oTotais:Cell( "TOT_DEBITO"	):SetBlock( { || ValorCTB(nTotCCDeb,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
					oTotais:Cell( "TOT_CREDITO"	):SetBlock( { || ValorCTB(nTotCCCrd,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )

					If lMov
						// Totaliza Centro de Custo
						nTotMov := (nTotCCCrd - nTotCCDeb)
						oTotais:Cell("TOT_MOV"):Enable()				
						oTotais:Cell("TOT_MOV"):SetBlock( { || ValorCTB(nTotMov,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cCCNormal,,,,,,lPrintZero,.F.) } )
					EndIf
					oTotais:Cell( "TOT_ATU"		):SetBlock( { || ValorCTB(nCCSldAtu,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cCCNormal,,,,,,lPrintZero,.F.) } )
					
					// Imprime totalizado
				 	oTotais:Init()
					oTotais:PrintLine()
					oTotais:Finish()
				EndIf
			EndIF
		EndIf
		dbSelectArea("cArqTmp")
	EndDo
	         
	
	 nPos := aScan( aSaldos, { |x| x[1] == "TOTGERAL"}) 

	nCCSldAnt 	:= aSaldos[nPos][2]
	nTotCCDeb 	:= aSaldos[nPos][3]
	nTotCCCrd 	:= aSaldos[nPos][4]
	nCCSldAtu	:= aSaldos[nPos][5]  
	
	nTotDeb 	:= aSaldos[nPos][3]
	nTotCrd 	:= aSaldos[nPos][4]
	nTotSldAnt	:= aSaldos[nPos][2]
	nTotSldAtu	:= aSaldos[nPos][5]
	nGrpDeb 	:= aSaldos[nPos][3]
	nGrpCrd 	:= aSaldos[nPos][4]

	
	oTotais:Cell("TOT"):SetTitle(OemToAnsi(STR0018))
	oTotais:Cell("TOT"):SetBlock({|| ""})
	oTotais:Cell("TOT_ANT"):SetBlock( { || ValorCTB(nTotSldAnt,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) } )
	oTotais:Cell("TOT_DEBITO"):SetBlock( { || ValorCTB(nTotDeb,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oTotais:Cell("TOT_CREDITO"):SetBlock( { || ValorCTB(nTotCrd,,,TAM_VALOR-2,nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )

	If lMov
		nTotMov := (nTotCrd - nTotDeb)
		oTotais:Cell("TOT_MOV"):Enable()
		If Round(NoRound(nTotMov,3),2) < 0
			oTotais:Cell("TOT_MOV"):SetBlock( { || ValorCTB(nTotMov,,,TAM_VALOR-2,nDecimais,.T.,cPicture,"1",,,,,,lPrintZero,.F.) } )
		ElseIf Round(NoRound(nTotMov,3),2) >= 0
			oTotais:Cell("TOT_MOV"):SetBlock( { || ValorCTB(nTotMov,,,TAM_VALOR-2,nDecimais,.T.,cPicture,"2",,,,,,lPrintZero,.F.) } )
		EndIf
	EndIf

	oTotais:Cell("TOT_ATU"):SetBlock( { || ValorCTB(nTotSldAtu,,,TAM_VALOR-2,nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,,lPrintZero,.F.) } )
	
	// Imprime totalizado
	oTotais:Init()
	oTotais:PrintLine()
	oTotais:Finish()
	
EndIf

dbSelectArea("cArqTmp")

Set Filter To
dbCloseArea()

If Select("cArqTmp") == 0
	//	Ferase(cArqTmp+GetDBExtension())
	//	FErase("cArqInd"+OrdBagExt())
EndIf

dbselectArea("CT2")
RestInter()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³f180Fil   ºAutor  ³Cicero J. Silva     º Data ³  24/07/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBR180                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function f180Fil(cSegAte,nDigitAte,nDigCCAte,cMascara1,cMascara2)
Local lDeixa	:= .F.

If mv_par33 == 1					// So imprime Sinteticas
	If cArqTmp->TIPOCC == "2"
		lDeixa := .T.
	EndIf
ElseIf mv_par33 == 2				// So imprime Analiticas
	If cArqTmp->TIPOCC == "1"
		lDeixa := .T.
	EndIf
EndIf

If mv_par07 == 1					// So imprime Sinteticas
	If cArqTmp->TIPOCONTA == "2"
		lDeixa := .T.
	EndIf
ElseIf mv_par07 == 2				// So imprime Analiticas
	If cArqTmp->TIPOCONTA == "1"
		lDeixa := .T.
	EndIf
EndIf

//Filtragem ate o Segmento da Conta( antigo nivel do SIGACON)
If !Empty(mv_par14)
	If Len(Alltrim(cArqTmp->CONTA)) > nDigitAte
		lDeixa := .T.
	Endif
EndIf

//Filtragem ate o Segmento do CC( antigo nivel do SIGACON)
If !Empty(mv_par28)
	If Len(Alltrim(cArqTmp->CUSTO)) > nDigCCAte
		lDeixa := .T.
	Endif
EndIf


dbSelectArea("cArqTmp")

Return (lDeixa)

/*

------------------------------------------------------- RELESE 4 ---------------------------------------------------------------

*/

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA  			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_SALDO_ANT    	6
#DEFINE 	COL_SEPARA4			7
#DEFINE 	COL_VLR_DEBITO   	8
#DEFINE 	COL_SEPARA5			9
#DEFINE 	COL_VLR_CREDITO  	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_MOVIMENTO 		12
#DEFINE 	COL_SEPARA7			13
#DEFINE 	COL_SALDO_ATU 		14
#DEFINE 	COL_SEPARA8			15

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR180R3³ Autor ³ Gustavo Henrique  	³ Data ³ 24.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Centro de Custo/Conta         			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr180R3()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTBR180R3()

Local aSetOfBook
Local aCtbMoeda		:= {}

Local cSayCC		:= CtbSayApro("CTT")
Local cDesc1 		:= OemToAnsi(STR0001)+ Upper(cSayCC)+ " / " + Upper(OemToAnsi(STR0021))	//"Este programa ira imprimir o Balancete de  / Conta "
Local cDesc2 		:= OemToansi(STR0002)  //"de acordo com os parametros solicitados pelo Usuario"
Local cString		:= "CTT"

Local lRet			:= .T.

Local nDivide		:= 1

Local wnrel
Local titulo 		:= OemToAnsi(STR0003)+ Upper(cSayCC)+ " / " +  Upper(OemToAnsi(STR0021))	//"Balancete de Verificacao  / Conta"


PRIVATE aReturn 	:= { OemToAnsi(STR0015), 1,OemToAnsi(STR0016), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE cPerg	 	:= "CTR180"
PRIVATE nLastKey 	:= 0
PRIVATE nomeProg  	:= "CTBR180"
PRIVATE Tamanho		:="M"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li 		:= 80
m_pag	:= 1

Pergunte("CTR180",.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  	   	³
//³ mv_par01				// Data Inicial              	       	³
//³ mv_par02				// Data Final                          	³
//³ mv_par03				// Conta Inicial                       	³
//³ mv_par04				// Conta Final  					   	³
//³ mv_par05				// Do Centro de Custo                  	³
//³ mv_par06				// Ate Centro de Custo                 	³
//³ mv_par07				// Imprime Contas: Sintet/Analit/Ambas 	³
//³ mv_par08				// Set Of Books				    	   	³
//³ mv_par09				// Saldos Zerados?			     	  	³
//³ mv_par10				// Moeda?          			     	   	³
//³ mv_par11				// Pagina Inicial  		     		   	³
//³ mv_par12				// Saldos? Reais / Orcados	/Gerenciais	³
//³ mv_par13				// Quebra por Grupo Contabil?		   	³
//³ mv_par14				// Imprimir ate o Segmento?			   	³
//³ mv_par15				// Filtra Segmento?					   	³
//³ mv_par16				// Conteudo Inicial Segmento?		   	³
//³ mv_par17				// Conteudo Final Segmento?		       	³
//³ mv_par18				// Conteudo Contido em?				   	³
//³ mv_par19				// Imprime Coluna Mov ?				   	³
//³ mv_par20				// Pula Pagina                         	³
//³ mv_par21				// Salta linha sintetica ?			    ³
//³ mv_par22				// Imprime valor 0.00    ?			    ³
//³ mv_par23				// Imprimir CC?Normal / Reduzido       	³
//³ mv_par24				// Divide por ?                   		³
//³ mv_par25				// Imprime Cod. Conta ? Normal/Reduzido ³
//³ mv_par26				// Posicao Ant. L/P? Sim / Nao         	³
//³ mv_par27 				// Data Lucros/Perdas?                	³
//³ mv_par28				// C.Custo ate o Segmento?			   	³
//³ mv_par29				// Filtra Segmento?					   	³
//³ mv_par30				// Conteudo Inicial Segmento?		   	³
//³ mv_par31				// Conteudo Final Segmento?		       	³
//³ mv_par32				// Conteudo Contido em?				   	³
//³ mv_par33				// Imprime C.C: Sintet/Analit/Ambas 	³
//³ mv_par34				// Rec./Desp. Anterior Zeradas?			³
//³ mv_par35				// Grupo Receitas/Despesas?      		³
//³ mv_par36				// Data de Zeramento Receita/Despesas?	³
//³ mv_par37				// Selecao de Filiais					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. mv_par37 == 1 .And. Len( aSelFil ) <= 0
	aSelFil := AdmGetFil()
	If Len( aSelFil ) <= 0
		lRet := .F.
	EndIf 
EndIf    

wnrel	:= "CTBR180"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct040Valid(mv_par08)
	lRet := .F.
Else
	aSetOfBook := CTBSetOf(mv_par08)
Endif

If mv_par24 == 2			// Divide por cem
	nDivide := 100
ElseIf mv_par24 == 3		// Divide por mil
	nDivide := 1000
ElseIf mv_par24 == 4		// Divide por milhao
	nDivide := 1000000
EndIf

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par10,nDivide)
	If Empty(aCtbMoeda[1])
		Help(" ",1,"NOMOEDA")
		lRet := .F.
	Endif
Endif

If lRet
	If (mv_par34 == 1) .and. ( Empty(mv_par35) .or. Empty(mv_par36) )
		cMensagem	:= STR0023	// "Favor preencher os parametros Grupos Receitas/Despesas e Data Sld Ant. Receitas/Despesas ou "
		cMensagem	+= STR0024	// "deixar o parametro Ignora Sl Ant.Rec/Des = Nao "
		MsgAlert(cMensagem,STR0025) //"Ignora Sl Ant.Rec/Des"
		lRet    	:= .F.
	EndIf
EndIf

If !lRet
	Set Filter To
	Return
EndIf

If mv_par19 == 1			// Se imprime coluna movimento -> relatorio 220 colunas
	tamanho := "G"
EndIf

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR180Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,nDivide)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR180IMP ³ Autor ³ Simone Mie / Gustavo  ³ Data ³ 25.08.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Balancete Conta/Centro de Custo.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR180Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayCC)   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1   - A‡ao do Codeblock                                ³±±
±±³          ³ ExpC1   - T¡tulo do relat¢rio                              ³±±
±±³          ³ ExpC2   - Mensagem                                         ³±±
±±³          ³ ExpA1   - Matriz ref. Config. Relatorio                    ³±±
±±³          ³ ExpA2   - Matriz ref. a moeda                              ³±±
±±³          ³ ExpC3   - Descricao do C.custo utilizada pelo usuario.     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR180Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,cSayCC,nDivide)

LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL tamanho		:= "M"
LOCAL limite		:= 132
Local cabec1  		:= ""
Local cabec2		:= ""
Local aColunas
Local cSepara1  	:= ""
Local cSepara2      := ""
Local cPicture
Local cDescMoeda
Local cMascara1
Local cMascara2
Local cGrupo		:= ""
Local cGrupoAnt		:= ""
Local cCCAnt 		:= ""
Local cCCRes		:= ""
Local cSegAte   	:= mv_par14
Local cArqTmp		:= ""
Local cCCSup		:= ""//Centro de Custo Superior do centro de custo atual
Local cAntCCSup		:= ""//Centro de Custo Superior do centro de custo anterior

Local dDataLP		:= mv_par27
Local dDataFim		:= mv_par02

Local lImpAntLP		:= Iif(mv_par26 == 1,.T.,.F.)
Local lFirstPage	:= .T.
Local lPula			:= .F.
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(mv_par22==1,.T.,.F.)
Local lPulaSint		:= Iif(mv_par21==1,.T.,.F.)  
Local lCttSint 		:= Iif(mv_par33 == 1 .or. mv_par33 == 3,.T.,.F.)
Local l132			:= .T.
Local lImpCCSint	:= .T.
Local lVlrZerado	:= Iif(mv_par09==1,.T.,.F.)
Local lImpDscCC	:= .F.

Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nCCTMov 		:= 0
Local nTamCC		:= 20
Local nTotCCDeb		:= 0
Local nTotCCCrd		:= 0
Local nCCSldAnt		:= 0
Local nCCSldAtu		:= 0
Local nTotSldAnt	:= 0
Local nTotSldAtu	:= 0
Local nDigitAte		:= 0
Local nDigCCAte		:= 0
Local nRegTmp		:= 0
Local n
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0
Local lRecDesp0		:= Iif(mv_par34==1,.T.,.F.)
Local cRecDesp		:= mv_par35
Local dDtZeraRD		:= mv_par36
Local cmask1,cmask2     
Local aSaldos		:= {}
Local nPos 			:= 0 
Local cFilt         := ""

cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par10)

//Mascara da Conta
If Empty(aSetOfBook[2])
	cMascara1 := GetMv("MV_MASCARA")
Else
	cMascara1 	:= RetMasCtb(aSetOfBook[2],@cSepara1)
EndIf

// Mascara do Centro de Custo
If Empty(aSetOfBook[6])
	cMascara2 := GetMv("MV_MASCCUS")
Else
	cMascara2 := RetMasCtb(aSetOfBook[6],@cSepara2)
EndIf

cPicture 		:= aSetOfBook[4]

If mv_par19 == 1 // Se imprime saldo movimento do periodo
	cabec1 := OemToAnsi(STR0004)  //"|  CODIGO              |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |    DEBITO     |    CREDITO   | MOVIMENTO DO PERIODO |   SALDO ATUAL    |"
	tamanho := "G"
	limite	:= 220
	l132	:= .F.
Else
	cabec1 := OemToAnsi(STR0005)  //"|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |"
Endif
SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF mv_par07 == 1		/// Se imprime somente contas sinteticas
	Titulo:=	OemToAnsi(STR0007) + Upper(cSayCC) + "/" + Upper(OemToAnsi(STR0021))//"BALANCETE SINTETICO DE  "
ElseIf mv_par07 == 2		/// Se imprime somente contas analiticas
	Titulo:=	OemToAnsi(STR0006) + Upper(cSayCC) + "/" + Upper(OemToAnsi(STR0021))//"BALANCETE ANALITICO DE  "
ElseIf mv_par07 == 3
	Titulo:=	OemToAnsi(STR0008) + Upper(cSayCC)	+  "/" + Upper(OemToAnsi(STR0021))//"BALANCETE DE  "
EndIf

Titulo += 	OemToAnsi(STR0009) + DTOC(mv_par01) + OemToAnsi(STR0010) + Dtoc(mv_par02) + ;
OemToAnsi(STR0011) + cDescMoeda

If mv_par12 > "1"
	Titulo += " (" + Tabela("SL", mv_par12, .F.) + ")"
EndIf

If nDivide > 1
	Titulo += " (" + OemToAnsi(STR0022) + Alltrim(Str(nDivide)) + ")"
EndIf

If l132
	aColunas := { 000, 001, 024, 025, 057, 058, 077, 078, 094, 095, 111,    ,    , 112, 131 }
Else
	aColunas := { 000, 001, 030, 032, 080, 082, 112, 114, 131, 133, 151, 153, 183, 185, 219 }
Endif

m_pag := mv_par11
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao					     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
			CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
						mv_par01,mv_par02,"CT3","",mv_par03,mv_par04,mv_par05,mv_par06,,,,,mv_par10,;
						mv_par12,aSetOfBook,mv_par15,mv_par16,mv_par17,mv_par18,;
						l132,.T.,,"CTT",lImpAntLP,dDataLP, nDivide,lVlrZerado,,,;
						mv_par29,mv_par30,mv_par31,mv_par32,,,,,,,,,cFilt,lRecDesp0,;
						cRecDesp,dDtZeraRD,,,,,,,,,aSelFil,,,,,,,,lCttSint)},;
				OemToAnsi(OemToAnsi(STR0014)),;  //"Criando Arquivo Tempor rio..."
				OemToAnsi(STR0003)+Upper(cSayCC)+ " / "+Upper(OemToAnsi(STR0021)))     //"Balancete Verificacao "    
				
cFilt := aReturn[7]					


// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	nDigitAte := CtbRelDig(cSegAte,cMascara1) 	
EndIf

// Verifica Se existe filtragem Ate o Segmento de C.Custo
If !Empty(mv_par28)
	nDigCCAte := CtbRelDig(mv_par28,cMascara2) 	
EndIf

dbSelectArea("cArqTmp")
dbGoTop()

//Se tiver parametrizado com Plano Gerencial, exibe a mensagem que o Plano Gerencial
//nao esta disponivel e sai da rotina.
If RecCount() == 0 .And. ! Empty(aSetOfBook[5])
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase("cArqInd"+OrdBagExt())
	Return
Endif

SetRegua(RecCount())

cCCAnt := cArqTmp->CUSTO   

dbSelectArea("cArqTmp")
dbGoTop()
cGrupo := GRUPO   

aSaldos := SldCCusto(,cFilt)

While mv_par33 == 1 .And. cArqTmp->TIPOCC == "2"
	dbSkip()
	cCCAnt := cArqTmp->CUSTO
EndDo 

While !Eof()   

	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0017)   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF
	
	IncRegua()
	
	******************** "FILTRAGEM" PARA IMPRESSAO *************************
	
	
	If CTT->( ! DbSeek( xFilial( "CTT" ) + cArqTMP->CUSTO ))
			dbSelectArea("cArqTmp")
			dbSkip()
			Loop
		Else
			If !Empty(cFilt) .And. !CTT->(&(cFilt))
				dbSelectArea("cArqTmp")		
				dbSkip()
				Loop
			Endif
	Endif
	 
	If mv_par33 == 1					// So imprime Sinteticas
		If TIPOCC == "2"
			dbSkip()
			Loop 
		EndIf
	ElseIf mv_par33 == 2				// So imprime Analiticas
		If TIPOCC == "1"
			dbSkip() 
			Loop
		EndIf
	EndIf
	
	If mv_par07 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()  
			Loop
		EndIf
	ElseIf mv_par07 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	//Filtragem ate o Segmento da Conta( antigo nivel do SIGACON)
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf
	
	//Filtragem ate o Segmento do CC( antigo nivel do SIGACON)
	If !Empty(mv_par28)
		If Len(Alltrim(CUSTO)) > nDigCCAte
			dbSkip()
			Loop
		Endif
	EndIf
	
	************************* ROTINA DE IMPRESSAO *************************
         
 	nPos := aScan( aSaldos, { |x| x[1] == cCCAnt}) 

	nCCSldAnt 	:= aSaldos[nPos][2]
	nTotCCDeb 	:= aSaldos[nPos][3]
	nTotCCCrd 	:= aSaldos[nPos][4]
	nCCSldAtu 	:= aSaldos[nPos][5]  
	
	nTotDeb 	:= aSaldos[nPos][3]
	nTotCrd 	:= aSaldos[nPos][4]
	nTotSldAnt	:= aSaldos[nPos][2]
	nTotSldAtu	:= aSaldos[nPos][5]
	nGrpDeb 	:= aSaldos[nPos][3]
	nGrpCrd 	:= aSaldos[nPos][4]  
	
	
	If mv_par13 == 1							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,01 PSAY STR0019 + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			@li,aColunas[COL_SEPARA8] PSAY "|"
			li++
			li			:= 60
			cGrupo		:= GRUPO
		EndIf
	Else
		If (cCCAnt <> cArqTmp->CUSTO) .And. !lFirstPage 
		
			@li,00 PSAY	Replicate("-",limite)
			li++
			@li,0 PSAY "|"
			// Imprime Totalizador do Centro de Custo
			@li, 1 PSAY OemToAnsi(STR0020)+ PadR(Upper(cSayCC),13) + " : "
			dbSelectArea("CTT")
			dbSetOrder(1)
			If MsSeek(xFilial("CTT")+cArqTmp->CUSTO)
				cCCSup	:= CTT->CTT_CCSUP	//Centro de Custo Superior
			Else
				cCCSup	:= ""
			EndIf
			If MsSeek(xFilial("CTT")+cCCAnt)
				cAntCCSup := CTT->CTT_CCSUP	//Centro de Custo Superior do Centro de custo anterior.
				cCCRes	  := CTT->CTT_RES
			Else
				cAntCCSup := ""
			EndIf
			dbSelectArea("cArqTmp")
			If mv_par23 == 2 //Se Impr. Cod. Red. C.C
				If CTT->CTT_CUSTO == cCCAnt .And. CTT->CTT_CLASSE == '2' //Se for analitico
					EntidadeCTB(cCCRes,li,27,nTamCC,.F.,cMascara2,cSepara2,"CTT")
				Else
					EntidadeCTB(cCCAnt,li,27,nTamCC,.F.,cMascara2,cSepara2,"CTT")
				EndIf
			Else//Se Imprime Cod. normal do C.Custo
				EntidadeCTB(cCCAnt,li,27,nTamCC,.F.,cMascara2,cSepara2,"CTT")
			Endif

			// Busca Natureza do Centro de Custo para utilizar nos totais por centro de custo
			cCCNormal := Posicione("CTT" , 1 , xFilial("CTT") + cCCAnt , "CTT_NORMAL")
			
			@ li,aColunas[COL_SEPARA3] PSAY "|"
			ValorCTB(nCCSldAnt,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,cCCNormal, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nTotCCDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nTotCCCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			
			If !l132
				nTotMov := (nTotCCCrd - nTotCCDeb)
				ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,cCCNormal, , , , , ,lPrintZero)
				@ li,aColunas[COL_SEPARA7] PSAY "|"
			Endif

			ValorCTB(nCCSldAtu,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,cCCNormal, , , , , ,lPrintZero)
			@ li,aColunas[COL_SEPARA8] PSAY "|"  
			li++
			@li,00 PSAY REPLICATE("-",limite)
			li++			
		EndIf
	EndIf
	
	If mv_par13 == 1				// Grupo Diferente
		If cGrupo != GRUPO
			lPula := .T.
			li		:= 60
			cGrupo:= GRUPO
		EndIf		
	Else          
		If mv_par20 == 1 
			If cCCAnt <> cArqTmp->CUSTO //Se o item atual for diferente do item anterior
				lPula := .T.
				li 	:= 60
			EndIf
		Endif
	EndIf          

	If li > 58 
		If !lFirstPage
			@ Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf

		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		li++            

		If mv_par20 == 1 .or. lFirstPage
			@ li,000 PSAY REPLICATE("-",limite)
 			li++
			@ li,000 PSAY "|"                                
			@ li,001 PSAY PadR(Upper(cSayCC),13) + " : "

			If mv_par23 == 2 .And. cArqTmp->TIPOCC == '2' //Se Imprime Cod. Red. CC e se for analitico			
				EntidadeCTB(CCRES,li,17,nTamCC,.F.,cMascara2,cSepara2,"CTT")
			Else                                                          
				EntidadeCTB(CUSTO,li,17,nTamCC,.F.,cMascara2,cSepara2,"CTT")			
			Endif         

			lImpDscCC	:= .T.
			@ li,aColunas[COL_CONTA]+ Len(CriaVar("CTT_DESC01")) PSAY " - " +cArqTMP->DESCCC
			@ li,aColunas[COL_SEPARA8] PSAY "|"		                                        
			li++
			@ li,000 PSAY REPLICATE("-",limite)		
			li+=1		
			lImpDscCC	:= .T.
		Endif		

		lFirstPage := .F.		
	Endif
	
	If  !lImpDscCC .And. ((mv_par20 == 2 .And. cCCAnt <> cArqTmp->CUSTO	) .Or. li > 58 .Or. ( mv_par20 == 1 .And. cCCant <> cArqTmp->CUSTO) .Or. ;
		(mv_par13 == 1 .And. cGrupoAnt <> cArqTmp->GRUPO))
		@ li,000 PSAY REPLICATE("-",limite)
		li++
		@ li,000 PSAY "|"
		@ li,001 PSAY PadR(Upper(cSayCC),13) + " : "
		If mv_par23 == 2 .And. cArqTmp->TIPOCC == '2' //Se Imprime Cod. Red.CC e se for analitico
			EntidadeCTB(CCRES,li,17,nTamCC,.F.,cMascara2,cSepara2,"CTT")
		Else
			EntidadeCTB(CUSTO,li,17,nTamCC,.F.,cMascara2,cSepara2,"CTT")
		Endif
		@ li,aColunas[COL_CONTA]+ Len(CriaVar("CTT_DESC01")) PSAY " - " +cArqTMP->DESCCC
		@ li,131 PSAY "|"
		li++
		@ li,000 PSAY REPLICATE("-",limite)
		li+=1
	Endif
	
	lImpDscCC	:= .F.
	
	@ li,aColunas[COL_SEPARA1] PSAY "|"
	If mv_par25 == 2 .And. cArqTmp->TIPOCONTA == '2' //Se imprime Cod. Red. conta e se for analitico
		EntidadeCTB(CTARES,li,aColunas[COL_CONTA],If(l132,22,25),.F.,cMascara1,cSepara1)
	Else
		EntidadeCTB(CONTA,li,aColunas[COL_CONTA],If(l132,22,25),.F.,cMascara1,cSepara1)
	EndIf
	dbSelectArea("cArqTmp")
	@ li,aColunas[COL_SEPARA2] PSAY "|"

	If l132
		@ li,aColunas[COL_DESCRICAO] PSAY Substr(DESCCTA,1,29)
	Else
		@ li,aColunas[COL_DESCRICAO] PSAY DESCCTA
	Endif
	@ li,aColunas[COL_SEPARA3] PSAY "|"
	ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6] PSAY "|"
	If !l132
		ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"
	Endif
	ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	
	lJaPulou := .F.
	If lPulaSint .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		@ li,aColunas[COL_SEPARA3] PSAY "|"
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		EndIf
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf
	
	************************* FIM   DA  IMPRESSAO *************************

	cCCAnt := cArqTmp->CUSTO
	cGrupoAnt	:= cArqTmp->GRUPO   
	
 	nPos := aScan( aSaldos, { |x| x[1] == cCCAnt}) 

	nCCSldAnt 	:= aSaldos[nPos][2]
	nTotCCDeb 	:= aSaldos[nPos][3]
	nTotCCCrd 	:= aSaldos[nPos][4]
	nCCSldAtu	:= aSaldos[nPos][5]  
	
	nTotDeb 	:= aSaldos[nPos][3]
	nTotCrd 	:= aSaldos[nPos][4]
	nTotSldAnt	:= aSaldos[nPos][2]
	nTotSldAtu	:= aSaldos[nPos][5]
	nGrpDeb 	:= aSaldos[nPos][3]
	nGrpCrd 	:= aSaldos[nPos][4]

	dbSkip()
	If lPulaSint .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			EndIf
			li++
		EndIf
	EndIf
EndDO

If mv_par13 == 1							// Grupo Diferente - Totaliza e Quebra
	@li,00 PSAY REPLICATE("-",limite)
	li+=2
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	@li,01 PSAY STR0019 + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
	@li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA6] PSAY "|"
	@li,aColunas[COL_SEPARA8] PSAY "|"
	li++

	cGrupo		:= GRUPO
Else
	//Imprime o total do ultimo item a ser impresso.
	@li,00 PSAY	Replicate("-",limite)
	li++
	@li,0 PSAY "|"
	// T O T A I S  D O
	@li, 1 PSAY OemToAnsi(STR0020)+ PadR(Upper(cSayCC),13) + " : "
	
	dbSelectArea("CTT")
	dbSetOrder(1)
	If MsSeek(xFilial("CTT")+cArqTmp->CUSTO)
		cCCSup	:= CTT->CTT_CCSUP	//Centro de Custo Superior
	Else
		cCCSup	:= ""
	EndIf
	
	If MsSeek(xFilial("CTT")+cCCAnt)
		cAntCCSup := CTT->CTT_CCSUP	//Centro de Custo Superior do Centro de custo anterior.
		cCCRes	  := CTT->CTT_RES
	Else
		cAntCCSup := ""
	EndIf
	
	dbSelectArea("cArqTmp")
	
	If mv_par23 == 2 //Se Imprime Cod. Red. C.custo
		If  CTT->CTT_CUSTO == cCCAnt .And. CTT->CTT_CLASSE == '2'//Se for analitico, imprime cod. reduzido.
			EntidadeCTB(cCCRes,li,27,nTamCC,.F.,cMascara2,cSepara2,"CTT")
		Else
			EntidadeCTB(cCCAnt,li,27,nTamCC,.F.,cMascara2,cSepara2,"CTT")
		Endif
	Else
		EntidadeCTB(cCCAnt,li,27,nTamCC,.F.,cMascara2,cSepara2,"CTT")
	Endif

	// Busca Natureza do Centro de Custo para utilizar nos totais por centro de custo
	cCCNormal := Posicione("CTT" , 1 , xFilial("CTT") + cCCAnt , "CTT_NORMAL")

	@ li,aColunas[COL_SEPARA3] PSAY "|"
	ValorCTB(nCCSldAnt,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,cCCNormal, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(nTotCCDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCCCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6] PSAY "|"

	If !l132
		nCCtMov := (nTotCCCrd - nTotCCDeb)
		ValorCTB(nCCtMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,cCCNormal, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"
	Endif
	ValorCTB(nCCSldAtu,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,cCCNormal, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	
EndIf   

IF li != 80 .And. !lEnd 

 	nPos := aScan( aSaldos, { |x| x[1] == "TOTGERAL"}) 

	nCCSldAnt 	:= aSaldos[nPos][2]
	nTotCCDeb 	:= aSaldos[nPos][3]
	nTotCCCrd 	:= aSaldos[nPos][4]
	nCCSldAtu	:= aSaldos[nPos][5]  
	
	nTotDeb 	:= aSaldos[nPos][3]
	nTotCrd 	:= aSaldos[nPos][4]
	nTotSldAnt	:= aSaldos[nPos][2]
	nTotSldAtu	:= aSaldos[nPos][5]
	nGrpDeb 	:= aSaldos[nPos][3]
	nGrpCrd 	:= aSaldos[nPos][4]

	IF li > 58
		@Prow()+1,00 PSAY	Replicate("-",limite)
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		li++
	End
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY "|"
	@li,1 PSAY OemToAnsi(STR0018)  		//"T O T A I S  D O  P E R I O D O : "
	@ li,aColunas[COL_SEPARA3] PSAY "|"
	ValorCTB(nTotSldAnt,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA6] PSAY "|"
	If !l132
		nTotMov := (nTotCrd - nTotDeb)
		ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"
	Endif
	ValorCTB(nTotSldAtu,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "
	If !lExterno .and. li < 59
		roda(cbcont,cbtxt,"M")
		Set Filter To
	EndIf
EndIF

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
FErase(cArqTmp+GetDBExtension())
FErase("cArqInd"+OrdBagExt())
dbselectArea("CT2")

MS_FLUSH()               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SldCCusto ºAutor  ³TOTVS               º Data ³  25/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SldCCusto(oReport,cFilt)
Local aSaldos := {}
Local aCcusto := {}
Local cCusto  := ""
Local nSldDeb := 0  
Local nSldCrd := 0
Local nSldAnt := 0   
Local nSldAtu := 0
Local nTotAnt := 0
Local nTotDeb := 0
Local nTotCrd := 0
Local nTotAtu := 0   
Local oSection1 := ""
Local cFiltCTT	:= ""

If lImpR4
	oSection1 := oReport:Section(1) 
	cFiltCTT  :=oSection1:Getadvplexp('CTT')	
Else
    CfiltCTT := cFilt
Endif

While mv_par33 == 1 .And. cArqTmp->TIPOCC == "2"
	dbSkip()
EndDo  

cCusto := cArqTmp->CUSTO

While !Eof()

   If !Empty(cFiltCTT)
       dbSelectArea("cArqTmp")		
   Endif             

	If cArqTmp->TIPOCONTA == "2"   

		If cCusto == cArqTmp->CUSTO         
			nSldAnt	+= cArqTmp->SALDOANT  
			nSldDeb += cArqTmp->SALDODEB	     
			nSldCrd += cArqTmp->SALDOCRD	     
		    nSldAtu += cArqTmp->SALDOATU  
		    
			If cArqTmp->TIPOCC == "2"
				nTotAnt	+= cArqTmp->SALDOANT  
				nTotDeb += cArqTmp->SALDODEB	     
				nTotCrd += cArqTmp->SALDOCRD	     
		    	nTotAtu += cArqTmp->SALDOATU  
		    Endif
		Else 
			AADD(aCCusto, cCusto)
	    	AADD(aCCusto, nSldAnt) 
		    AADD(aCCusto, nSldDeb) 
			AADD(aCCusto, nSldCrd) 	    
			AADD(aCCusto, nSldAtu) 	    
	    
	        AADD(aSaldos,aCCusto) 
    	    aCCusto := {} 
        
	        cCusto  := cArqTmp->CUSTO
    	    nSldAnt := cArqTmp->SALDOANT
        	nSldDeb := cArqTmp->SALDODEB
	        nSldCrd := cArqTmp->SALDOCRD
    	    nSldAtu := cArqTmp->SALDOATU  
    	    
    	    If cArqTmp->TIPOCC == "2"
	    	    nTotAnt	+= cArqTmp->SALDOANT  
				nTotDeb += cArqTmp->SALDODEB	     
				nTotCrd += cArqTmp->SALDOCRD	     
		    	nTotAtu += cArqTmp->SALDOATU  
            Endif 
		Endif
	
	Endif

	dbSkip()
EndDo  

If !Empty(cFiltCTT)
	AADD(aCCusto, cCusto)
	AADD(aCCusto, nSldAnt) 
	AADD(aCCusto, nSldDeb) 
	AADD(aCCusto, nSldCrd) 	    
	AADD(aCCusto, nSldAtu) 	    
	AADD(aSaldos, aCCusto)
	aCCusto := {}
	
	AADD(aCCusto, "TOTGERAL")
	AADD(aCCusto, nSldAnt) 
	AADD(aCCusto, nSldDeb) 
	AADD(aCCusto, nSldCrd) 	    
	AADD(aCCusto, nSldAtu)    
	AADD(aSaldos,aCCusto) 
Else
	AADD(aCCusto, cCusto)
	AADD(aCCusto, nSldAnt) 
	AADD(aCCusto, nSldDeb) 
	AADD(aCCusto, nSldCrd) 	    
	AADD(aCCusto, nSldAtu) 	    
	AADD(aSaldos, aCCusto)
	aCCusto := {}  
	
	AADD(aCCusto, "TOTGERAL")
	AADD(aCCusto, nTotAnt) 
	AADD(aCCusto, nTotDeb) 
	AADD(aCCusto, nTotCrd) 	    
	AADD(aCCusto, nTotAtu) 	    
	AADD(aSaldos,aCCusto) 
Endif	

dbGoTop()

Return aSaldos
