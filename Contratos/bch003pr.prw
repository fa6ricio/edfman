#include "rwmake.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBCH003PR  บAutor  ณMilton Nishimoto    บ Data ณ  23/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Browse para definir o preco Definitivo nas notas de remessaบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Bauche - Facri                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BCH003PR(cContr,cPeriodo,nValorD)
Local _n	:= 0
Private _cFiltro
Private cCadastro
Private _cMarca
Private _cContr		:= cContr
Private _cPeriodo	:= cPeriodo               
Private nValDef		:= nValorD
Private aTitulos	:={}
Private oQtTotal, cQtTotal

cCadastro := "Pre็o Definitivo"
//alert(nValorD)
For i:=1 To Len(aCols)
	If aCols[i,8] == '2' //.And. aCols[i,15] == 0
		_n	:= i
	EndIf
Next i
If _n == 0
	Alert('Nใo ้ possํvel definir o pre็o!  Grave um pre็o definitivo antes de executar essa etapa.')
	Return
EndIf

If AllTrim(SZ5->Z5_BOLSA) == "NY"
	nValDef		:= aCols[_n,7]
Else
	nValDef			:= aCols[_n,6]
EndIf

aac:={"Abandona","Confirma"}

//aRotina := {{"Imp. Boleto"  ,'execblock("FINRL001",.F.,.F.)',0,4}}


MsgRun("Selecionando registros para grava็ใo do Pre็o Definitivo, Aguarde...","",{|| CursorWait(), montarq(70,80) ,CursorArrow()})

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณMicrosiga           บ Data ณ  03/15/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function montarq()
Local oOk		:= LoadBitMap(GetResources(), "LBOK")
Local oNo		:= LoadBitMap(GetResources(), "LBNO")

Local lContinua := .T.
Local nOpc		:= 0
Local nF4For
Local oBmp1, oBmp2, oBmp3, oBmp4,oBmp5, oBmp6, oBmp7, oBmp8,oBmp9,oBmp10
Local lCampos 	:= .F.
Local lContinua := .F.
Local cQueryC7	:= ""
Local cQueryF1	:= ""
Local cNFs		:= ""

Local _AreaAtu	:= GetArea()
Private cTotmarc	:= 'Space(10)'
Private oDlg,oListBox,cListBox
cQueryC7	:= " SELECT C7_NFMAE"
cQueryC7	+= " FROM "+RetSqlName("SC7")+" C7"
cQueryC7	+= " WHERE C7_CONTRAT = '"+_cContr+"'"
cQueryC7	+= " AND C7.D_E_L_E_T_ <> '*'"
//Open Query cQueryC7 Alias "TMP"
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQueryC7),"TMP", .F., .T.)
DbSelectArea("TMP") 
While TMP->(!EOF())
	cNFs	+= "'"+TMP->C7_NFMAE+"',"
	TMP->(DbSkip())
EndDo
cNFs	:= SubStr(cNFs,1,Len(cNFs)-1)
cQueryF1	:= " SELECT D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_EMISSAO, D1_QUANT, D1_VUNIT,D1_TOTAL, F1_NFMAE, F1_CONTRA,D1_XVDEFIN, D1_COD, D1_ITEM"
cQueryF1	+= " FROM "+RetSqlName("SD1")+" D1"
cQueryF1	+= " INNER JOIN SF1010 F1 ON D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA = F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA AND F1.D_E_L_E_T_ <> '*'"
cQueryF1	+= " WHERE F1_NFMAE IN ("+cNFs+")"
cQueryF1	+= " AND D1.D_E_L_E_T_ <> '*'"
cQueryF1	+= " ORDER BY D1_EMISSAO,D1_DOC"
//Alert(cQueryF1)
//Open Query cQueryF1 Alias "TMP2"
//DbSelectArea("TMP2")

/*While !TMP2->(EOF())
	cNFs	+= TMP2->D1_DOC+"/"
	TMP2->(DbSkip())
EndDo*/

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQueryF1),"TRB2", .F., .T.)

TcSetField('TRB2','D1_EMISSAO','D')
//TcSetField('TRB2','E1_VENCREA','D')
//TcSetField('TRB2','E1_VENCTO','D')

Count To nRec

If nRec == 0
	MsgStop("Nใo existem dados para este relat๓rio!","Aten็ใo")
	TRB2->(dbcloseArea())
	Return
EndIf

ProcRegua(nRec)
aTitulos := {}
DbSelectArea("TRB2")
dbGoTop()
While !Eof()
	IncProc("Montando os itens a serem selecionados")
	ProcessMessages()
	//01- COR, 02- SELECAO, 03-NUMERO, 04-SERIE, 05- PARCELA, 06- COD CLIENTE, 07- NOME CLIENTE, 08-IMPRIMIU, 09- EMISSAO, 10- VENCIMENTO
	aAdd(aTitulos,{fColor(),.F.,TRB2->D1_DOC, TRB2->D1_SERIE, TRB2->D1_FORNECE, TRB2->D1_LOJA, TRB2->D1_EMISSAO, TRB2->D1_QUANT, TRB2->D1_VUNIT, TRB2->D1_TOTAL, TRB2->F1_NFMAE, TRB2->F1_CONTRA,TRB2->D1_ITEM,TRB2->D1_COD })
	
	dbSelectArea("TRB2")
	dbSkip()
End

CursorArrow()
TMP->(DbCloseArea())
//TRB2->(DbCloseArea())
RestArea(_AreaAtu)


//MONTA O CABECALHO
cFields := " "
nCampo 	:= 0

//01- COR, 02- SELECAO, 03-NUMERO, 04-SERIE, 05- PARCELA, 06- COD CLIENTE, 07- NOME CLIENTE, 08-IMPRIMIU, 09- EMISSAO, 10- VENCIMENTO, 11- valor

aTitCampos := {" "," ",OemToAnsi("N๚mero"),OemToAnsi("S้rie"),OemToAnsi("Fornecedor"),OemToAnsi("Loja"),OemToAnsi("Emissใo"),OemToAnsi("Quantidade"),;
OemToAnsi("Vlr. Unitแrio"), OemToAnsi("Vlr. Total"), OemToAnsi("NF. Mใe"), OemToAnsi("Contrato"), OemToAnsi("Item NF"), OemToAnsi("Cod. Produto")}

cLine := "{aTitulos[oListBox:nAT][1],If(aTitulos[oListBox:nAt,2],oOk,oNo),aTitulos[oListBox:nAT][3],aTitulos[oListBox:nAT][4],aTitulos[oListBox:nAT][5],"
cLine += " aTitulos[oListBox:nAT][6],aTitulos[oListBox:nAT][7],aTitulos[oListBox:nAT][8],aTitulos[oListBox:nAT][9],aTitulos[oListBox:nAT][10],aTitulos[oListBox:nAT][11],aTitulos[oListBox:nAT][12],"
cLine += " aTitulos[oListBox:nAT][13],aTitulos[oListBox:nAT][14],}"
bLine := &( "{ || " + cLine + " }" )



@ 100,005 TO 550,950 DIALOG oDlgPedidos TITLE "Notas de Remessa"

oListBox := TWBrowse():New( 17,4,400,160,,aTitCampos,,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox:SetArray(aTitulos)
oListBox:bLDblClick := { || aTitulos[oListBox:nAt,2] := MarcaTodos(oListBox, .T., .T.,1,oListBox:nAt), AtualizaQtde(oListBox) }
oListBox:bLine := bLine

@ 183,010 BUTTON "Marca Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .T.,0),AtualizaQtde(oListBox)) PIXEL OF oDlgPedidos
@ 183,060 BUTTON "Desm. Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .F.,0),AtualizaQtde(oListBox)) PIXEL OF oDlgPedidos
@ 183,110 BUTTON "Ok"	      		  SIZE 40,15 ACTION {nOpc :=1,oDlgPedidos:End()} PIXEL OF oDlgPedidos
@ 183,160 BUTTON "Sair"       		  SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos

@ 183,210 SAY 'Qtde. Total: ' OF oDlgPedidos Color CLR_BLUE,CLR_BLACK  PIXEL 
@ 183,240 MSGET oQtTotal VAR cQtTotal SIZE 020, 010 OF oDlgPedidos COLORS 0, 16777215 READONLY PIXEL
//Impresso - "BR_VERMELHO"
//LIBERADO - "BR_VERDE"


@ 213,005 BITMAP oBmp1 ResName "BR_VERMELHO" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
@ 213,015 SAY "Definitivo" OF oDlgPedidos Color CLR_BLUE,CLR_BLACK PIXEL


@ 213,165 BITMAP oBmp5 ResName "BR_VERDE" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
@ 213,175 SAY "Provisorio" OF oDlgPedidos Color CLR_GREEN,CLR_WHITE PIXEL


ACTIVATE DIALOG oDlgPedidos CENTERED

TRB2->(dbCloseArea())

If nOpc == 0
	Return
EndIf
//Alert(AllTrim(STR(n)))
If MsgYesNo("Confirma atualiza็ใo do Pre็o definitivo para todas as notas selecionadas com o valor de R$ "+AllTrim(STR(nValDef))+"?",'Confirma')
	For y:= 1 To Len(aTitulos)
		If aTitulos[y][2]
			DbSelectArea("SD1")
			DbSetOrder(1)
			If DbSeek(xFilial("SD1")+aTitulos[y][3]+aTitulos[y][4]+aTitulos[y][5]+aTitulos[y][6]+aTitulos[y][14]+aTitulos[y][13])
				RecLock("SD1",.F.)
				SD1->D1_XVDEFIN		:= nValDef
				SD1->(MsUnlock())
			Else
				Alert("Erro na atualiza็ใo do Pre็o Definitivo! - BCH003PR.PRW")
			EndIf
		EndIf
	Next
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCOLOR    บAutor  ณMicrosiga           บ Data ณ  09/22/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RETORNA O STATUS DO PEDIDO                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//Impresso - "BR_VERMELHO"
//LIBERADO - "BR_VERDE"

Static Function fColor()
Local cEntregue

//LIBERADO
If Empty(TRB2->D1_XVDEFIN)
	Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
Endif

//IMPRESSO
If !Empty(TRB2->D1_XVDEFIN)
	Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMarcaTodosบAutor  ณPaulo Carnelossi    บ Data ณ  04/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMarca todos as opcoes do list box - totalizadores           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaTodos(oListBox, lInverte, lMarca,nItem,nPos)
Local nX
  
oListBox:Refresh()
oDlgPedidos:Refresh()
If nItem = 0
	For nX := 1 TO Len(oListbox:aArray)
		InverteSel(oListBox,nX, lInverte, lMarca,0)
	Next
Else
	lRet := InverteSel(oListBox,nPos, lInverte, lMarca,1)
	Return(lRet)
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInverteSelบAutor  ณPaulo Carnelossi    บ Data ณ  04/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInverte Selecao do list box - totalizadores                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InverteSel(oListBox,nLin, lInverte, lMarca,nItem)


If lInverte
	oListbox:aArray[nLin,2] := ! oListbox:aArray[nLin,2]
Else
	If lMarca
		oListbox:aArray[nLin,2] := .T.
	Else
		oListbox:aArray[nLin,2] := .F.
	EndIf
EndIf


If nItem == 1
	If oListbox:aArray[nLin,2] == .F.
		Return(.F.)
	ElsE
		Return(.T.)
	EndIf
Else
	aTitulos[nLin,2] := oListbox:aArray[nLin,2]
EndIf
Return

Static Function AtualizaQtde(oListBox)

	Local nQtdeTotal := 0
	Local nX 
	            
	cQtTotal := 0
	
	For nX := 1 TO Len(oListbox:aArray)
		If oListbox:aArray[nX,2] == .T.
			nQtdeTotal += oListbox:aArray[nX,8]
		EndIf
	Next		

	cQtTotal += nQtdeTotal
   
   oQtTotal:Refresh()

Return 