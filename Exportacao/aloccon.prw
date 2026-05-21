#INCLUDE "Protheus.ch"

User Function AlocCon
Local oEdit1                                   
Local lRet  := .f.
Local _aArea   		:= {}
Local _aAlias  		:= {}


/*Define MSDialog oDlg Title "Alocação de Containers" From 186,241 To 250,800 Pixel
@ C(012),C(088) MsGet oEdit1 Var cBook F3 "SZA" valid !empty(cBook) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlg
//@ C(012),C(088) MsGet oEdit1 Var cBook F3 "SB1" valid !empty(cBook) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF oDlg
@ C(013),C(007) Say "Informe o Número do Booking: " Size C(076),C(008) COLOR CLR_BLACK PIXEL OF oDlg
@10,200 Button oBtnOk     Prompt "&Alocar"       Size 30,15 Pixel Action (RunAloc(), oDlg:End()) Of oDlg
@10,240 Button oBtnCancel Prompt "&Cancelar" Size 30,15 Pixel Action ( oDlg:End()) Cancel Of oDlg
Activate MSDialog oDlg Centered

Return(NIL)
*/


//Static Function RunAloc
Local _aArea         := GetArea()
Local _aSvCols 	     := {} 
Local _aSvHead 	     := {} 
Local _nSvN		     := 1 
Local _aSvRotina     := {}
Local _aSvCadast     := 0
Local _nOpc          := 0
Local _lRet          := .F.
Private oDlg
Private cBook	 	:= SZA->ZA_BOOKING
Private aCols		:= {}
Private aHeader		:= {}
Private n
Private _oOk      	 := LoadBitmap( GetResources(), "LBOK" )
Private _oNo      	 := LoadBitmap( GetResources(), "LBNO" )
Private _nPosAnt     := 0
Private _cTitulo     := "Alocação de Containers"
Private _aColsFilter := {}
Private _aColsBk     := {}
Private _lVisible 	 := .T.
Private _lFiltro     := .f.
Private _cCboOrdem   := ""
Private _cObs        := ""
Private _cExpressao  := Space(50)
Private _aVetor		 := {}
Private _aVetorAc	 := {}
Private _cProdSel	 := ""
Private _nPrc 	     := 0
Private _cPrc 	     := ""
Private _nPrMin	     := 0
Private _cPrMin	     := ""
Private _nEstDisp 	 := 0
Private _nEstRese    := 0
Private _nRadTpPesq	 := 2
Private _nRadFiltro	 := 1

Private _oDlg, _oBrw, _oBrw1, _oSayExpressao, _oExpressao, _oLbxTabela, _oRadTpPesq, _oLocal
Private _oBtnLimpaFiltro, _oObs, _oLbxAces
//Private _cCboPesqPor	:= ""
//Private _aCboPesqPor := {}
Private _cLocal      := "01"
//Private _cExpressao  := Space(50)

/* Colunas da Busca da Pesquisa */
//aadd( _aCboPesqPor, "Descricao" )
//aadd( _aCboPesqPor, "Cod Produto" )

Define FONT oFnt NAME "Arial" SIZE 10,12 BOLD
                                       
Define MsDialog _oDlg From 000, 000 To 420, 775 Title OemToAnsi( _cTitulo ) Pixel

/* Colunas da Busca da Pesquisa */
//aadd( _aCboPesqPor, "Descricao" )
//aadd( _aCboPesqPor, "Cod Produto" )

//@ 015,091 Say _oSayPesqPor PROMPT "Pesquisar por..." Of _oDlg Pixel COLOR CLR_BLACK Size 060,008
//@ 022,091 MSCOMBOBOX _oCboPesqPor VAR _cCboPesqPor ITEMS _aCboPesqPor SIZE 065,008 OF _oDlg PIXEL
//_oCboPesqPor:bChange  := { || U_CPR01N() }

//@ 015,005 Say _oSayExpressao PROMPT "Expressão:" Of _oDlg Pixel COLOR CLR_BLACK Size 030,008
//@ 022,005 MsGet _oExpressao Var _cExpressao Size 080,008 of _oDlg Pixel
//_oExpressao:bChange := {|| If( _nRadTpPesq == 1, U_CPR01I( _cExpressao ), U_CPR01F( _cExpressao )), Eval( _oBrw:oBrowse:bChange )}

/* GetDados com as informacoes dos Produtos */
aHeader	:= {}
aCols   := {}
n       := 1
aHeader	:= CPR01B()
aCols   := CPR01C( aHeader, _nRadFiltro )

If Len(aCols) == 0
	Aviso( "Atenção!", "Não há dados no Cadastro!", { "Ok" } )
	Return( _lRet )
Endif

@ 060, 005 To 210, 385 LABEL " Containers " Of _oDlg Pixel COLOR CLR_BLUE

//@ 068, 010 Say _oSayProdSel PROMPT _cProdSel Of _oDlg Pixel COLOR CLR_RED Size 180,008 FONT oFnt
                                     
_oBrw := MsGetDados():New( 080, 005, 210, 385, 2, "AllwaysTrue()", "AllwaysTrue()", , .T., , , , , , , , , )
_oBrw:oBrowse:lDisablePaint := .F.

/* Executa funcao a cada mudanca de linha no Browse */
//_oBrw:oBrowse:bChange := {|| U_CPR01J() }


// Se o usuario deu dois cliques na Linha do Browse
_oBrw:oBrowse:bLDblClick := { || _nOpc := 1,U_Aloca(aCols[n, 1]), _oBrw:oBrowse:Refresh() }


DEFINE SBUTTON FROM 015,350 TYPE  1 ACTION ( _nOpc := 1, _oDlg:End() ) ENABLE OF _oDlg

//@ 015, 165 Button _oBtnLimpaFiltro PROMPT "Limpar Filtro" SIZE 35,11 Action ( _oBrw:oBrowse:Refresh() ) Of _oDlg Pixel
//_oBtnLimpaFiltro:lVisible := .t.
//_oBtnLimpaFiltro:lActive  := .F.

//Activate MsDialog _oDlg on init { Eval(_oBrw:oBrowse:bChange), _oExpressao:SetFocus() } centered
Activate MsDialog _oDlg on init { Eval(_oBrw:oBrowse:bChange) } centered

Return
Static Function CPR01B()
Local _aH := {}

AADD(_aH,{ 'Container', 'Container', "@!",25, 0,".t.",'','C','' } )
AADD(_aH,{ 'Saldo'	  , 'Saldo'		, "@!",12, 0,".t.",'','N','' } )

Return( _aH )


Static Function CPR01C( aHeader, _nOpcFiltro)
Local _aArea    		:= GetArea()
Local _aC       		:= {}
Local _aC1      		:= {}
Local _lSelecao 		:= .f.
Local _i 		 		:= 0
Local _x 		 		:= 0
Local _nSaldoAtual 	    := 0
Local _nPrecoVenda	    := 0
Local cQuery            := ""

For _i := 1 to Len( aHeader )
	
	If  aHeader[_i,8] == "C"
		aadd( _aC, Space( aHeader[_i,4] ) )
	Elseif aHeader[_i,8] == "N"
		aadd( _aC, 0 )
	Endif
	
Next _i

aadd( _aC, .f.)

/*cQuery := "SELECT B1_COD,B1_DESC,B1_UM,B1_LOCPAD "
cQuery += " FROM "+RetSqlName("SB1")+ " SB1 "
cQuery += " WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += " AND B1_MSBLQL <> '1' "


cQuery += " AND SB1.D_E_L_E_T_ <> '*'"   
cQuery += " ORDER BY B1_DESC"
cQuery := ChangeQuery(cQuery)   
DbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),'PRO', .F., .T.)         
*/

cQuery	:= " SELECT ZZ1_NRCNTR FROM "+RetSqlName("ZZ1")+" WHERE ZZ1_PREEMB = '"+cBook+"' AND D_E_L_E_T_ <> '*'"
dbUseArea(.T., "TOPCONN", TCGENQRY( , , cQuery), "TMP", .F., .T.)
DbSelectArea("TMP")
DbGotop()
While !eof()

    //If posicione("SB2",1,xFilial("SB2")+PRO->B1_COD+_cLocal,"B2_QATU") <> 0 
	
	  _aC[ 1 ] :=TMP->ZZ1_NRCNTR
	  _aC[ 2 ] := 0

	  
	  _aC[ Len(aHeader)+1 ] := .f.
	  AADD(_aC1,aclone(_aC))
	
	//EndIf
	
	DbSkip()
	
Enddo

dbSelectArea("TMP")
DBCloseArea()

//CONSULTA O SALDO JA ALOCADO EM CADA CONTAINER
For i := 1 To Len(_aC1)
	cQuery	:= " SELECT SUM(ZC_QTDALOC) SALDO FROM "+RetSqlName("SZC")+" WHERE ZC_BOOKING = '"+cBook+"' AND D_E_L_E_T_ <> '*'"
	cQuery	+= " AND ZC_CONTAIN = '"+_aC1[i,1]+"'"
	dbUseArea(.T., "TOPCONN", TCGENQRY( , , cQuery), "TMP", .F., .T.)
	DbSelectArea("TMP")
	If !Empty(TMP->SALDO)
		_aC1[i,2]		:= TMP->SALDO
	EndIf
	dbSelectArea("TMP")
	TMP->(DBCloseArea())
Next

If Empty(_aC1)
 AADD(_aC1,aclone(_aC))
EndIf

RestArea( _aArea )

Return( _aC1 )


Static Function GetPos( _cCampo )
Return( aScan(aHeader,{|x| UPPER(AllTrim(x[2]))==Upper( Alltrim(_cCampo))}) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TSTCON    ºAutor  ³Microsiga           º Data ³  02/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Aloca(cCont)
Private cContainer	:= cCont
aColsOld	:= aCols
aHeaderOld	:= aHeader
nOld		:= n
nOpcx  := 3


_nProp := 0
_nUm   := 0
_nNorm := 0
_nEspe := 0

_sAlias := Alias()
_sRec   := Recno()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos := RetCampos("SZC",.T.)
For nx := 1 to Len(aCampos)
	If AllTrim(aCampos[nx])=="ZC_FILIAL".Or. AllTrim(aCampos[nx])=="ZC_BOOKING";
		.Or. AllTrim(aCampos[nx])=="ZC_CONTAIN"
		Loop
	Endif
	If ( X3USO(GetSX3Cache(aCampos[nx],"X3_USADO")) .And. cNivel >= GetSX3Cache(aCampos[nx],"X3_NIVEL")) 
		nUsado:=nUsado+1
		cNome := AllTrim(aCampos[nx])
		AAdd(aHeader,{ Trim(GetSX3Cache(aCampos[nx],"X3_TITULO")),;
			AllTrim(aCampos[nx]),;
			GetSX3Cache(aCampos[nx],"X3_PICTURE"),;
			GetSX3Cache(aCampos[nx],"X3_TAMANHO"),;
			GetSX3Cache(aCampos[nx],"X3_DECIMAL"),;
			GetSX3Cache(aCampos[nx],"X3_VLDUSER"),;
			GetSX3Cache(aCampos[nx],"X3_USADO"),;
			GetSX3Cache(aCampos[nx],"X3_TIPO"),;
			GetSX3Cache(aCampos[nx],"X3_ARQUIVO"),;
			GetSX3Cache(aCampos[nx],"X3_CONTEXT") })
	Endif
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCols:=Array(1,nUsado+1)
aCampos := RetCampos("SZC",.T.)
nUsado:=0
For nx := 1 to Len(aCampos)
	If AllTrim(aCampos[nx])=="ZC_FILIAL".Or. AllTrim(aCampos[nx])=="ZC_BOOKING";
		.Or. AllTrim(aCampos[nx])=="ZC_CONTAIN"
		Loop
	Endif
	IF X3USO(GetSX3Cache(aCampos[nx],"X3_USADO")) .AND. cNivel >= GetSX3Cache(aCampos[nx],"X3_NIVEL")
		IF nOpcx == 3
			nUsado:=nUsado+1
			IF GetSX3Cache(aCampos[nx],"X3_TIPO") == "C"
				aCOLS[1][nUsado] := SPACE(GetSX3Cache(aCampos[nx],"TAMANHO"))
			Elseif GetSX3Cache(aCampos[nx],"X3_TIPO") == "N"
				aCOLS[1][nUsado] := 0
			Elseif GetSX3Cache(aCampos[nx],"X3_TIPO") == "D"
				aCOLS[1][nUsado] := dDataBase
			Elseif GetSX3Cache(aCampos[nx],"X3_TIPO") == "M"
				aCOLS[1][nUsado] := ""
			Else
				aCOLS[1][nUsado] := .F.
			Endif
		Endif
	Endif
Next nx

aCOLS[1][nUsado+1] := .F.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SZC")
dbSetOrder(2)
//cBooking	:= SZA->ZA_BOOKING
//dbSeek(xFilial("SZC")+cBook+cContainer)
If dbSeek(xFilial("SZC")+cBook+cContainer)
	aCols := {}
EndIf
cLocal   := Space(2)
cDescr   := Space(10)
cObs := Space(20)

dbSelectArea("SZC")
While !EOF() .And. cBook==SZC->ZC_BOOKING .And. cContainer == SZC->ZC_CONTAIN
//While !EOF() .And. Alltrim(cContainer) == AllTrim(SZC->ZC_CONTAIN)
	aAdd(aCols,{SZC->ZC_ITEM,SZC->ZC_NF,SZC->ZC_SERIE,SZC->ZC_QTDALOC,.F.})
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Cabecalho do Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cBook:=Space(20)
cLocal  :=Space(2)
cDescr  :=Space(40)
cData	:=Date()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Rodape do Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cObs:=Space(50)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="Cadastro de Especifica‡”es"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aC:={}
//AADD(aC,{"cProduto" ,{05,03} ,"C¢d. do Produto"   ,"@!"           ,"ExecBlock('Y1VALPRO',.F.,.F.)","SB1",})
AADD(aC,{"cBook" ,{15,06} ,"BOOKING"   ,"@!"           ,"!Empty(cBook)",,.F.})
AADD(aC,{"cData"   ,{15,159} ,"Data"         ,"@!"           ,,,.F.})
AADD(aC,{"cContainer" ,{30,06} ,"CONTAINER"   ,"@!"           ,,,.F.})

aR:={}
AADD(aR,{"cObs" ,{20,03},"Observa‡„o"    ,"@!",,,})

aCGD:={138,144,46,104}
cLinhaOk:="ExecBlock('QTDEALOC',.f.,.f.)"
cTudoOk:="ExecBlock('ZBTUDOK',.f.,.f.)"
n:=1
lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,,,.T.)

_nItem 	:= aScan(aHeader,{|x| x[2]=="ZC_ITEM"})
_nNF 	:= aScan(aHeader,{|x| x[2]=="ZC_NF"})
_nSerie := aScan(aHeader,{|x| x[2]=="ZC_SERIE"})
_nBook 	:= aScan(aHeader,{|x| x[2]=="ZC_BOOKING"})
_nQtde	:= aScan(aHeader,{|x| x[2]=="ZC_QTDALOC"})
_nContn	:= aScan(aHeader,{|x| x[2]=="ZC_CONTAIN"})

ntotal	:= 0

If lRetMod2 //
	For _l := 1 To Len(aCols)
		If !aCols[_l,Len(aHeader)+1]
			dbSelectArea("SZC")
			dbSetOrder(2)//ZC_FILIAL+ZC_BOOKING+ZB_CONTAIN+ZB_ITEM+ZB_NF+ZB_SERIE
			If !dbSeek(xFilial("SZC")+cBook+cContainer+aCols[_l,_nItem])//+aCols[_l,_nNF]+aCols[_l,_nSerie])
				RecLock("SZC",.T.)
			Else
				RecLock("SZC",.F.)
			Endif
			SZC->ZC_FILIAL  := xFilial("SZC")
			//SY1->ZC_CODIGO  := cProduto
			SZC->ZC_ITEM    	:= aCols[_l,_nItem]
			SZC->ZC_NF 	   		:= aCols[_l,_nNF]
			SZC->ZC_SERIE     	:= aCols[_l,_nSerie]
			SZC->ZC_BOOKING   	:= cBook
			SZC->ZC_CONTAIN		:= cContainer//aCols[_l,_nContn]
			SZC->ZC_QTDALOC		:= aCols[_l,_nQtde]
			ntotal				+= aCols[_l,_nQtde]
			MsUnLock()
		Else
			dbSelectArea("SZC")
			dbSetOrder(2)
			If dbSeek(xFilial("SZC")+cBook+cContainer+aCols[_l,_nItem]+aCols[_l,_nNF]+aCols[_l,_nSerie])
				RecLock("SZC",.F.)
				dbDelete()
				MsUnLock()
			Endif
		EndIf
	Next _l
Else
	For _l := 1 To Len(aCols)
		If !aCols[_l,Len(aHeader)+1]
			ntotal				+= aCols[_l,_nQtde]
		EndIf
	Next _l
Endif

dbSelectArea(_sAlias)
dbGoto(_sRec)
aCols:= aColsOld
aHeader:= aHeaderOld
n	:= nOld 
aCols[n,2]	:= ntotal
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALOCCON   ºAutor  ³Microsiga           º Data ³  05/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function QTDEALOC()
Local nNF		:= aScan(aHeader,{|x| x[2]=="ZC_NF"})
Local nSerie	:= aScan(aHeader,{|x| x[2]=="ZC_SERIE"})
//Local nContain	:= aScan(aHeader,{|x| x[2]=="ZC_CONTAIN"})
Local nQtdaloc	:= aScan(aHeader,{|x| x[2]=="ZC_QTDALOC"})

Local cNota		:= aCols[n,nNF]
Local cSerie	:= aCols[n,nSerie]
//Local cContainer:= cContainer//aCols[n,nContain]
//Local nApontam	:= M->ZC_QTDALOC

Local nUsado	:= 0
Local nDispon	:= 0
Local cQuery	:= ""
Local lRetorno	:= .T.

_sAlias := Alias()
_sRec   := Recno()

//VERIFICAR SE A QUANTIDADE DA NF JA FOI UTILIZADA EM OUTROS CONTAINERS
cQuery	:= " SELECT SUM(ZC_QTDALOC) TOTAL"
cQuery	+= " FROM "+RetSqlName("SZC")
cQuery	+= " WHERE ZC_NF+ZC_SERIE = '"+cNota+cSerie+"'"
cQuery	+= " AND D_E_L_E_T_ <> '*'"
dbUseArea(.T., "TOPCONN", TCGENQRY( , , cQuery), "QRY", .F., .T.)
DbSelectArea("QRY")
nUsado	:= QRY->TOTAL
QRY->(DbCloseArea())
//VERIFICA SE JA TEM ALGUMA QUANTIDADE UTILIZADA NO ACOLS
//If n > 1
	For i:=1 To Len(aCols)
		If aCols[i,nNF]+aCols[i,nSerie] == cNota+cSerie .And. !aCols[i,Len(aHeader)+1]//caso a linha esteja deletada nao a considera
			nUsado	+= aCols[i,nQtdaloc]
		EndIf
	Next i
//EndIf
//VERIFICA O TOTAL DA NF
cQuery	:= " SELECT SUM(D1_QUANT) QUANT"
cQuery	+= " FROM "+RetSqlName("SD1")
cQuery	+= " WHERE D1_DOC+D1_SERIE = '"+cNota+cSerie+"'"
cQuery	+= " AND D_E_L_E_T_ <> '*'"
dbUseArea(.T., "TOPCONN", TCGENQRY( , , cQuery), "QRY", .F., .T.)
DbSelectArea("QRY")
nDispon	:= QRY->QUANT
QRY->(DbCloseArea())

//SE O VALOR APONTADO SOMADO AO SALDO JA USADO FOREM MAIORES QUE A QUANTIDADE DA NOTA AVISA O USUARIO
//If nApontam + nUsado > nDispon	
If nUsado > nDispon	
	Alert("Quantidade apontada maior do que a Disponível para a NF! ("+AllTrim(Str(nDispon-nUsado))+")")
	lRetorno	:= .F.
EndIf

//VERIFICA SE TEM SALDO DISPONIVEL PARA O CONTAINER
//VERIFICAR SE A CAPACIDADE DO CONTAINER JA FOI ESGOTADA
/*cQuery	:= " SELECT SUM(ZC_QTDALOC) TOTAL"
cQuery	+= " FROM "+RetSqlName("SZC")
cQuery	+= " WHERE ZC_CONTAIN = '"+cContainer+"'"
cQuery	+= " AND D_E_L_E_T_ <> '*'"
dbUseArea(.T., "TOPCONN", TCGENQRY( , , cQuery), "QRY", .F., .T.)
DbSelectArea("QRY")
nUsado	:= QRY->TOTAL
QRY->(DbCloseArea())*/
//VERIFICA SE JA TEM ALGUMA QUANTIDADE UTILIZADA NO ACOLS
nUsado	:= 0
If n > 1
	//For i:=1 To n-1
	For i:=1 To Len(aCols)
		//If aCols[i,nContain] == cContainer .And. aCols[i,Len(aHeader)+1]//caso a linha esteja deletada nao a considera
		If !aCols[i,Len(aHeader)+1]//caso a linha esteja deletada nao a considera
			nUsado	+= aCols[i,nQtdaloc]
		EndIf
	Next i
EndIf
//VERIFICA A CAPACIDADE DO CONTAINER
cQuery	:= " SELECT ZZ1_QTDEMB"
cQuery	+= " FROM "+RetSqlName("ZZ1")
cQuery	+= " WHERE ZZ1_NRCNTR = '"+cContainer+"'"
cQuery	+= " AND D_E_L_E_T_ <> '*'"
dbUseArea(.T., "TOPCONN", TCGENQRY( , , cQuery), "QRY", .F., .T.)
DbSelectArea("QRY")
nDispon	:= QRY->ZZ1_QTDEMB
QRY->(DbCloseArea())

//SE O VALOR APONTADO SOMADO AO SALDO JA USADO FOREM MAIORES QUE A CAPACIDADE DO CONTAINER AVISA O USUARIO
//If nApontam + nUsado > nDispon	
If nUsado > nDispon
	Alert("Quantidade apontada maior do que a Capacidade do Container considerando a quantidade já apontada! ("+AllTrim(Str(nDispon-nUsado))+")")
	lRetorno	:= .F.
EndIf

dbSelectArea(_sAlias)
dbGoto(_sRec)

Return lRetorno


Static Function RetCampos(cArq, lVirtual)		
Local aCampos := {}
Local aCmpRet := {}
Local cUsado := ""
Local nx := 1

DEFAULT lVirtual := .F.

aCampos := FWSX3Util():GetAllFields(cArq,lVirtual)
	
For nx := 1 to Len (aCampos)
	IF !("USERLG" $ aCampos[nx]) 
		cUsado   := X3OBRIGAT(aCampos[nx])
		// Verifica se o campo é usado
		If !Empty(cUsado)
			AADD(aCmpRet,{aCampos[nx],FWSX3Util():GetDescription( aCampos[nx] )})
		EndIf
	Endif
Next nx
Return aCmpRet	
