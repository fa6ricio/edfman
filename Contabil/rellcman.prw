#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ RelLcMan      ºAutor³ Luiz Pereira       		   º Data ³ 23/06/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Gera Excel Relatorio Relação de Lançamentos Manuais                    º±±
±±º         ³ Tabela CT2                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam    ³                                                          		         º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ ED&FMan                                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                 ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  Programador  ³  Data   ³ Motivo da Alteracao                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º               ³         ³                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

****************************
User Function RelLcMan()
****************************
Local   aPergs 	  := {}
Local   nTpRel    := 2
Local   cTable    := ""

Private oFwMsEx   := NIL
Private cWorkSheet:= ""
Private bFileFat  :={|| cDir:=ChoseMapDir(),If(Empty(cDir),cDir:=Space(200),Nil)}
Private oDlg      := Nil
Private cArq      := "RelLcMan_"+DtoS(dDataBase), cRel:="Relação de Lançamentos Manuais efetuados pelo Departamento Contábil e Fiscal"
Private cDir      := Space(250)
Private cPerg     := ""
Private aArea     := GetArea()
Private lRetor    := .T.
Private lSair     := .F.
Private lTudOk    := .T.
Private aStru     := {}
private cArqTrb2  := CriaTrab(NIL,.F.)
Private cCamposCSV:= ""
Private cDadosCSV := ""
Private cMsg      := ""
Private cArqTxt   := ""
Private nSomaMoeda:= 0
Private nSomaVreal:= 0
Private cCadastro := "Analise Mov. Contábil Manual"
Private nQtdDoc   := 0
Private cNrdoc    := ""
Private aRadio    := {}
Private oRadio    := NIL
Private nRadio    := 0
Private nOk       := 1

lEnd := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cPerg := Avkey("RELCTM","X1_GRUPO")

ValidPerg(nTpRel)

If !Pergunte(cPerg)
	Return (.T.)
EndIf

//+-----------------------------------------------------------------------------------//
//| Definição da janela e seus conteúdos
//+-----------------------------------------------------------------------------------//

DEFINE MSDIALOG oDlg TITLE cRel FROM 0,0 TO 175,368 OF oDlg PIXEL

@ 06,06 TO 65,180 LABEL "Dados do arquivo" OF oDlg PIXEL

@ 15, 10 SAY   "Nome do Arquivo"  SIZE 45,7 PIXEL OF oDlg
@ 25, 10 MSGET cArq               SIZE 60,08 PIXEL OF oDlg

@ 40, 10 SAY "Diretorio de gravação"  SIZE  65, 7 PIXEL OF oDlg
@ 50, 10 MSGET cDir PICTURE "@!"      SIZE 150, 8 WHEN .F. PIXEL OF oDlg
@ 50,162 BUTTON "..."                 SIZE  13,10 PIXEL OF oDlg ACTION Eval(bFileFat)

DEFINE SBUTTON FROM 70,10 TYPE 1  OF oDlg ACTION (ValiRel("ok")) ENABLE
DEFINE SBUTTON FROM 70,50 TYPE 2  OF oDlg ACTION (ValiRel("cancel")) ENABLE

ACTIVATE MSDIALOG oDlg CENTER

If lSair
	Return .T.
EndIf

Processa({||GerExcel()},"Prepara Arquivo Temporário....")

If lTudOk
	
	cMsg := "Relatório de Lcto Manuais gerado com sucesso!"
	
	MsgInfo(cMsg,"Atenção")
	lAbre := MsgYesNo("Deseja Abrir o arquivo em Excel?","Atenção")
	
	If lAbre
		
		If ! ApOleClient( 'MsExcel' )
			MsgStop(" MsExcel nao instalado ")
			Return
		EndIf
		
		If nRadio == 1
			
			cArqTxt := Alltrim(cArq) + ".xls"
			
			LjMsgRun("Gerando o arquivo relatorio lancamentos Manuais em EXCEL.", cCadastro, {|| oFwMsEx:GetXMLFile( cArqTxt ) } )
			
			If __CopyFile( cArqTxt, cDir + cArqTxt )
				If ApOleClient('MsExcel')
					oExcelApp := MsExcel():New()
					oExcelApp:WorkBooks:Open( cDir + cArqTxt )
					oExcelApp:SetVisible(.T.)
				else
					MsgInfo( "Microsoft Excel não instalado, arquivo " + cArqTxt + " foi salvo na pasta " + cDir )
				endif
			Else
				MsgInfo( "Arquivo não copiado para o diretório dos arquivos temporários do usuário." )
			Endif
			
			
		Else
			
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open(cArqTxt)
			
			oExcelApp:SetVisible(.T.)
			
		Endif
		
		
	EndIf
	
EndIf

Return .T.


***************************
Static Function GerEXCEL()
***************************
// monta arquivo analitico

aAdd(aStru,{"DTLANC"  	,"D",08,0})  // Data Lancamento	- CT2_DATA
aAdd(aStru,{"LOTE" 	    ,"C",06,0})  // Numero Lote    	- CT2_LOTE
aAdd(aStru,{"SUBLOTE"  	,"C",03,0})  // Sub-Lote       	- CT2_SBLOTE
aAdd(aStru,{"NRDOC"     ,"C",06,0})  // Nr. Documento	- CT2_DOC
aAdd(aStru,{"NRLINHA"   ,"C",03,0})  // Nr. Linha		- CT2_LINHA
aAdd(aStru,{"MOEDA"     ,"C",03,0})  // Moeda			- CT2_MOEDLC
aAdd(aStru,{"TPDOCLC"   ,"C",15,0})  // Tipo Lcto		- CT2_DC = 1-Debito / 2-Credito / 3-Partida Dobrada
aAdd(aStru,{"CTDEB" 	,"C",20,0})  // Conta Debito	- CT2_DEBITO
aAdd(aStru,{"CTCRE" 	,"C",20,0})  // Conta Credito	- CT2_CREDIT
aAdd(aStru,{"VALOR"     ,"N",13,2})  // Valor Lcto		- CT2_VALOR
aAdd(aStru,{"HIST"   	,"C",40,0})  // Historico 		- CT2_HIST
aAdd(aStru,{"CCDEB"     ,"C",09,0})  // C. Custo Deb.	- CT2_CCD
aAdd(aStru,{"CCCRE"     ,"C",09,0})  // C. Custo Cred.	- CT2_CCC
aAdd(aStru,{"ICDEB"     ,"C",09,0})  // Item Cta Deb.	- CT2_ITEMD
aAdd(aStru,{"ICCRE"     ,"C",09,0})  // Item Cta Cred.	- CT2_ITEMC
aAdd(aStru,{"CVDEB"     ,"C",20,0})  // Cla Vlr. Deb.	- CT2_CLVLDB
aAdd(aStru,{"CVCRE"     ,"C",20,0})  // Cla Vlr. Cred.	- CT2_CLVLCR
aAdd(aStru,{"FILIAL"  	,"C",04,0})  // Filial     		- CT2_FILIAL
aAdd(aStru,{"ORIGEM"    ,"C",99,0})  // Origem Lcto     - CT2_ORIGEM

cArqTrb2 := "TRB2"
oArqTrb2:= FwTemporarytable():New(cArqTrb2,aStru)
oArqTrb2:Create()
index on LOTE+DtoS(DTLANC)+NRDOC to &(cArqTrb2+"1")

set index to &(cArqTrb2+"1")

Processa({|lEnd|GerarArq()})

TRB2->(dbclosearea())

Return .T.

**********************************
Static Function GerarArq()
********************************

**************************************
***** Seleciona Movimentos Contabeis
**************************************
dbSelectArea("CT2")
cIndex := CriaTrab("",.F.)
cKey := 'CT2_FILIAL+CT2_LOTE+DtoS(CT2_DATA)+CT2_DOC'

cCondicao := 'CT2_FILIAL>="'    		+mv_par01      +'".And.CT2_FILIAL<="'    +mv_par02+'"'
cCondicao += '.And.CT2_LOTE>="' 		+mv_par03      +'".And.CT2_LOTE<="'      +mv_par04+'"'
cCondicao += '.And.DtoS(CT2_DATA)>="' 	+DtoS(mv_par05)+'".And.DtoS(CT2_DATA)<="'+DtoS(mv_par06)+'"'
cCondicao += '.And.(CT2_MANUAL="1" .or. SubStr(CT2_LOTE,1,2) $ "'+mv_par07+'")'

IndRegua("CT2",cIndex,cKey,,cCondicao)
dbSelectArea("CT2")

#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF

dbGoTop()
ProcRegua(LastRec())
************************************************************************

cNrdoc := Alltrim(CT2->CT2_LOTE)+DtoS(CT2->CT2_DATA)+alltrim(CT2->CT2_DOC)         

While !Eof()
	

	IncProc("Fil: "+CT2->CT2_FILIAL+" Lote: "+Alltrim(CT2->CT2_LOTE)+" C.Deb: "+AllTrim(CT2->CT2_CCD)+" C.Cre: "+AllTrim(CT2->CT2_CCC))
	
	If Substr(CT2->CT2_LOTE,1,2) != "GP"
		DbSelectArea("TRB2")
		RecLock("TRB2",.T.)
		TRB2->DTLANC    := CT2->CT2_DATA
		TRB2->LOTE 	    := CT2->CT2_LOTE
		TRB2->SUBLOTE	:= CT2->CT2_SBLOTE
		TRB2->NRDOC		:= CT2->CT2_DOC
		TRB2->NRLINHA	:= CT2->CT2_LINHA
		TRB2->MOEDA		:= CT2->CT2_MOEDLC
		TRB2->TPDOCLC	:= IIF(AllTrim(CT2->CT2_DC) == "1","Debito",IIF(AllTrim(CT2->CT2_DC) == "2","Credito","Partida Dobrada"))
		TRB2->CTDEB		:= CT2->CT2_DEBITO
		TRB2->CTCRE		:= CT2->CT2_CREDIT
		TRB2->VALOR		:= CT2->CT2_VALOR
		TRB2->HIST		:= CT2->CT2_HIST
		TRB2->CCDEB		:= CT2->CT2_CCD
		TRB2->CCCRE		:= CT2->CT2_CCC
		TRB2->ICDEB		:= CT2->CT2_ITEMD
		TRB2->ICCRE		:= CT2->CT2_ITEMC
		TRB2->CVDEB		:= CT2->CT2_CLVLDB
		TRB2->CVCRE		:= CT2->CT2_CLVLCR
		TRB2->FILIAL	:= xFilial("CT2")
		TRB2->ORIGEM	:= CT2->CT2_ORIGEM
		TRB2->(MsUnlock())
	Endif
	
	dbSelectArea("CT2")
	dbSkip()
	
	If Eof()
		Exit
	Endif
	
Enddo

*********************************
*** Seleciona Formato Relatório
*********************************
MenEscol()
*********************************


If nOk = 1
	
	Do Case
		Case nRadio == 1 // Mapa Excel
			MsAguarde({||GerRelEXCEL()},"Aguarde","Gerando Relatório Excel !"+CHR(13)+CHR(10)+"Lanc. Contábeis Manual..."      ,.F.)
		Case nRadio == 2 // Rel. CSV com Totais
			MsAguarde({||MANCSV()     },"Aguarde","Gerando Relatório CSV com Totais !"+CHR(13)+CHR(10)+"Lanc. Contábeis Manual...",.F.)
	EndCase

Endif

Return .T.

**********************************
Static Function GerRelEXCEL()
**********************************

cWorkSheet := "Contabilidade"
cTable     := "Relação de Lançamentos Manuais efetuados pelo Departamento Contábil e Fiscal de "+DtoC(MV_PAR05) + " Até "+DtoC(MV_PAR06)
oFwMsEx    := FWMsExcel():New()

oFwMsEx:AddWorkSheet( cWorkSheet )
oFwMsEx:AddTable( cWorkSheet, cTable )

oFwMsEx:AddColumn( cWorkSheet, cTable , "Dta Lcto"    		, 1,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Lote"    			, 1,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Sub"  	    		, 1,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Num Doc"   		, 1,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Num Linha"   		, 3,3)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Moeda" 	      	, 3,3)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Tipo Lcto"   		, 1,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Cta Debito"   		, 3,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Cta Credito"		, 3,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Valor"	    		, 3,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Hist Lanc."   		, 1,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "C Custo Deb"  		, 3,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "C Custo Cred"		, 3,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Item Conta D"     	, 3,2)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Item Conta C" 		, 3,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Cod Cl Val D" 		, 3,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Cod Cl Val C" 		, 3,1)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Filial Orig " 		, 3,3)
oFwMsEx:AddColumn( cWorkSheet, cTable , "Origem / Usuário"	, 1,1)

dbSelectArea("TRB2")
DBGOTOP()

ProcRegua(LastRec())

While !TRB2->(Eof())
	
	IncProc("Fil: "+TRB2->FILIAL+" Lote: "+Alltrim(TRB2->LOTE))
	
	aParam := {}
	aadd(aParam, TRB2->DTLANC	)
	aadd(aParam, TRB2->LOTE		)
	aadd(aParam, TRB2->SUBLOTE	)
	aadd(aParam, TRB2->NRDOC	)
	aadd(aParam, TRB2->NRLINHA	)
	aadd(aParam, TRB2->MOEDA	)
	aadd(aParam, TRB2->TPDOCLC	)
	aadd(aParam, TRB2->CTDEB	)
	aadd(aParam, TRB2->CTCRE	)
	aadd(aParam, Transform(TRB2->VALOR,"@E 999,999,999.99"))
	aadd(aParam, TRB2->HIST		)
	aadd(aParam, TRB2->CCDEB	)
	aadd(aParam, TRB2->CCCRE	)
	aadd(aParam, TRB2->ICDEB	)
	aadd(aParam, TRB2->ICCRE	)
	aadd(aParam, TRB2->CVDEB	)
	aadd(aParam, TRB2->CVCRE	)
	aadd(aParam, TRB2->FILIAL	)
	aadd(aParam, TRB2->ORIGEM	)
	
	oFwMsEx:AddRow(cWorkSheet,cTable, aParam)
	
	TRB2->(DBSKIP())
	
End

oFwMsEx:Activate()

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: ValidPerg()
//|Descricao.: Valida a existencia das perguntas, criando caso não exista
//|Observação:
//+-----------------------------------------------------------------------------------//

********************************
Static Function ValidPerg(xTp)
********************************

Local sAlias := Alias()
Local aRegs := {}
Local i,j

aAdd(aRegs,{cPerg,"01","Filial De"         ,"","","mv_ch1" ,"C",04,0,0,"G","U_Cont1('01')","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate"        ,"","","mv_ch2" ,"C",04,0,0,"G","U_Cont1('02')","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
aAdd(aRegs,{cPerg,"03","Nr Lote De"        ,"","","mv_ch3" ,"C",06,0,0,"G","U_Cont1('03')","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CT2X","","","","",""})
aAdd(aRegs,{cPerg,"04","Nr Lote Ate"       ,"","","mv_ch4" ,"C",06,0,0,"G","U_Cont1('04')","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CT2X","","","","",""})
aAdd(aRegs,{cPerg,"05","Dta Lct De"  	   ,"","","mv_ch5" ,"D",08,0,0,"G","U_Cont1('05')","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@D","" })
aAdd(aRegs,{cPerg,"06","Dta Lct Ate" 	   ,"","","mv_ch6" ,"D",08,0,0,"G","U_Cont1('06')","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@D","" })
aAdd(aRegs,{cPerg,"07","Lotes Iniciados MA/AT/??" ,"","","mv_ch7" ,"C",30,0,0,"G","U_Cont1('07')","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@","" })

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
//|Funcao....: U_Cont1 ()
//|Descricao.: Valida datas informadas nas perguntas
//|Observação:
//+-----------------------------------------------------------------------------------//

******************************
User Function Cont1(cMV)
******************************

Local cRet     := .T.
Local cTitulo  := "Inconsistencia de Dados"

Do Case
	
	Case cMV == '01'
		
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
		
		If !Empty(MV_PAR03) .AND. MV_PAR03 > MV_PAR04
			Aviso( cTitulo, "Cliente Final não pode ser maior que o Final", {"Ok"} )
			cRet := .F.
		EndIf
		
	Case cMV == '04'
		
		If Empty(MV_PAR04)
			Aviso( cTitulo, "Cliente Final deve ser informado", {"Ok"} )
			cRet := .F.
		EndIf
		
	End Case
	
Return(cRet)

	
	
//+-----------------------------------------------------------------------------------//
//|Funcao....: ValiRel()
//|Descricao.: Valida informações de gravação
//|Observação:
//+-----------------------------------------------------------------------------------//

**********************************
Static Function ValiRel(cValida)
**********************************

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
//|Funcao....: ChoseMapDir()
//|Descricao.: Localiza diretório de gravação
//|Observação:
//+-----------------------------------------------------------------------------------//

********************************
Static Function ChoseMapDir()
********************************

Local cTitle:= "Geração de arquivo"
Local cMask := "Formato *|*.*"
Local cFile := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY

cFile:= cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,.F., nOptions)

Return(cFile)
	
//+-----------------------------------------------------------------------------------//
//|Funcao....: MANCSV()
//|Descricao.: Gera Arquivo CSV
//|Observação:
//+-----------------------------------------------------------------------------------//

*-----------------------------------------*
Static Function MANCSV()
*-----------------------------------------*
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
*-----------------------------------------*
Static Function RunCont()
*-----------------------------------------*

Local nTamLin, cLin, cCpo
Local nFlag := 0, nTotReais:=0
Local nTotUSD:=0, nTotYEN:=0, nTotEUR:=0
Local nTXUSD :=0, nTxYEN :=0, nTxEUR :=0

cCamposCSV :="Dta Lcto;Lote;Sub;Num Doc;Num Linha;Moeda;Tipo Lcto;Cta Debito;"
cCamposCSV +="Cta Credito;Valor;Lote;Hist Lanc.;C Custo Deb;C Custo Cred;Item Conta D;Item Conta C;"
cCamposCSV +="Cod Cl Val D;Cod Cl Val C;Filial Orig;Origem / Usuário;"

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

cTitRel:=";;;;;"+cRel+";"+"Filial De "+";"+MV_PAR01+";"+"Até "+";"+ MV_PAR02 +";"+ "Nota De "+";"+MV_PAR03+";"+"Até "+";"+ MV_PAR04+cEOL
fWrite(nHdl,cTitRel,Len(cTitRel))
fWrite(nHdl,cLin,Len(cLin))


cLin := Stuff(cLin,01,02,cCamposCSV)
fWrite(nHdl,cLin,Len(cLin))

TRB2->(DBGOTOP())

cNrdoc  := Alltrim(TRB2->LOTE)+DtoS(TRB2->DTLANC)+Alltrim(TRB2->NRDOC) //Alltrim(TRB2->LOTE)+"/"+Alltrim(TRB2->NRDOC)
nQtdDoc := 0
cLote   := LOTE
cNrLote := Alltrim(TRB2->LOTE)  //+"/"+Alltrim(TRB2->NRDOC) 

While ! TRB2->(EOF())
	
	IncProc("Gerando arquivo CSV")
	
	nTamLin := 2
	cLin    := Space(nTamLin)+cEOL
	cDadosCSV := ""
	
	For nInd := 1 To TRB2->(fCount())
		cCpoDest := TRB2->(FieldName(nInd))
		If TRB2->(FieldPos(cCpoDest)) > 0
			cValor:=TRB2->(FieldGet(FieldPos(cCpoDest)))
			If cCpoDest $ "DTLANC"
				cValor:= DtoC(TRB2->(&cCpoDest))
			Endif
			If ValType(TRB2->(&cCpoDest)) == "N"
				Do Case
					Case cCpoDest $ "VALOR"
						cPict:= "@E 99,999,999,999.99"
				EndCase
				cDadosCSV += TRANSFORM(cValor,cPict)+Iif(nInd = TRB2->(fCount()),"",";")
			Else
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

	   If Alltrim(TRB2->LOTE)+DtoS(TRB2->DTLANC)+Alltrim(TRB2->NRDOC) != cNrdoc
		   nQtdDoc += 1                                                        
		   cNrdoc  := Alltrim(TRB2->LOTE)+DtoS(TRB2->DTLANC)+Alltrim(TRB2->NRDOC)
       Endif
       If TRB2->LOTE != cLote
	    cTitRel:=";;"+"Total Fichas: "+";"+cNrLote+";"+TRANSFORM(nQtdDoc,"@E 99999")+";;" +cEOL //+TRANSFORM(nSomaVreal,"@E 99,999,999,999.99")+";;"+cEOL
	    fWrite(nHdl,cTitRel,Len(cTitRel))
		cNrdoc  := Alltrim(TRB2->LOTE)+DtoS(TRB2->DTLANC)+Alltrim(TRB2->NRDOC)
		nQtdDoc := 0
		cLote   := TRB2->LOTE
		cNrLote := Alltrim(TRB2->LOTE)  //+"/"+Alltrim(TRB2->NRDOC) 
	   Endif	
	
EndDo

Return
	
*----------------------------*
Static Function MenEscol()
*----------------------------*
Private oDlgINI  := Nil

aAdd(aRadio,"01-Rel. Formato Excel")
aAdd(aRadio,"02-Rel. Formato CSV com Totais")

While .T.
	
	nOk := 0
	
	DEFINE MSDIALOG oDlgINI TITLE "Selecione o Formato do Relatório" FROM 0,0 TO 105,340 OF oDlgINI PIXEL
	
	@ 04, 15 RADIO oRadio VAR nRadio ITEMS aRadio[1],aRadio[2] SIZE 90,128 PIXEL OF oDlgINI
	
	DEFINE SBUTTON FROM 08,140 TYPE 19 OF oDlgINI ACTION (nOk := 1 ,oDlgINI:End()) ENABLE
	DEFINE SBUTTON FROM 26,140 TYPE 2  OF oDlgINI ACTION (nOk := 0 ,oDlgINI:End()) ENABLE
	
	ACTIVATE MSDIALOG oDlgINI CENTER
	
	If nOk = 1
		Exit
	Else
		
		If MsgYesNo("Deseja realmente sair?","Saida")
			Exit
			Return
		Else
			Loop
		EndIf
		
	EndIf
	
EndDo

Return .T.
