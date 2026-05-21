#include "protheus.ch"

/*/
+-----------------------------------------------------------------------------
| Função	| EDFA010     | Autor | YTTALO P MARTINS        |Data |26/08/2013|
+-----------------------------------------------------------------------------
| Descrição	| ROTINA PARA PREENCHIMENTO DE DADOS COMPLEMENTARES DA PRE NOTA	|
+-----------------------------------------------------------------------------
| Uso 	| PE SF1140I									|
+-----------------------------------------------------------------------------
/*/

User Function EDFA010()

Local nI
Local oDlg
Local oGetDB
Local nUsado   := 0
Local aStruct  := {}
Local aAlter   := {}
Local aButtons := {}
Local lRet     := .T.
Local _aArea   := GetArea()
Local xSEEK    := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
Local xFornece := SF1->F1_FORNECE
Local xLoja    := SF1->F1_LOJA
Local xcRecno  := SF1->(Recno())  
Local lResp	   := 0	
Local cCriaTrab := GetNextAlias()
Local nx

Private lRefresh := .T.
Private aHeader := {}
Private aCols := {}

Private nPosContra 	:= 0
Private nPosPeriod 	:= 0
Private nPosNfMae 	:= 0
Private nPosSerMae 	:= 0
Private nPosPedido 	:= 0

aCampos := RetCampos("SZD",.T.)
For nx := 1 to Len(aCampos)
	If X3USO(GetSX3Cache(aCampos[nx],"X3_USADO")) .And. ALLTRIM(aCampos[nx]) $ "ZD_CONTRA#ZD_PERIODO#ZD_NFMAE#ZD_SERIEM#ZD_PEDIDOC"
		nUsado++
		AAdd(aHeader,{ Trim(GetSX3Cache(aCampos[nx],"X3_TITULO")),;
			AllTrim(aCampos[nx]),;
			GetSX3Cache(aCampos[nx],"X3_PICTURE"),;
			GetSX3Cache(aCampos[nx],"X3_TAMANHO"),;
			GetSX3Cache(aCampos[nx],"X3_DECIMAL"),;
			GetSX3Cache(aCampos[nx],"X3_VALID"),;
			"",;
			GetSX3Cache(aCampos[nx],"X3_TIPO"),;
			"",;
			"" })
		AADD(aStruct,{AllTrim(aCampos[nx]),;
			GetSX3Cache(aCampos[nx],"X3_TIPO"),;
			GetSX3Cache(aCampos[nx],"X3_TAMANHO"),;
			GetSX3Cache(aCampos[nx],"X3_DECIMAL")})
		AADD(aAlter,AllTrim(aCampos[nx]))
	Endif
Next nx

AADD(aStruct,{"FLAG","L",1,0})

oCriaTrab:= FwTemporarytable():New(cCriaTrab,aStruct)
oCriaTrab:Create()

//oDlg 	:= MSDIALOG():New(000,000,400,500, "Complemento Informações XML-Template",,,,,,,,,.T.)

DEFINE MSDIALOG oDlg TITLE "Teste EnchoiceBar" FROM 000,000 TO 400,500 PIXEL STYLE DS_MODALFRAME


oGetDB := MsGetDB():New(05,05,175,245,3,"U_EDFA10LOK", "U_EDFA10TOK", "", ;
.T.,aAlter,,.F.,,cCriaTrab,"U_EDFA10FDOK",,.T.,oDlg, .T., ,"U_EDFA10DOK",;
"U_EDFA10SDEL")

ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,{||lRet:=.T.,oDlg:End()},{||oDlg:End()},,@aButtons))

If lRet == .T.

	DbSelectArea(cCriaTrab)
	
	DBSELECTAREA("SZD")
	DBSETORDER(1)
	
	RECLOCK("SZD",.T.)
	
	SZD->ZD_FILIAL  := xFILIAL("SZD")
	SZD->ZD_CONTRA  := (cCriaTrab)->ZD_CONTRA
	SZD->ZD_PERIODO := (cCriaTrab)->ZD_PERIODO
	SZD->ZD_NFMAE   := (cCriaTrab)->ZD_NFMAE
	SZD->ZD_SERIEM  := (cCriaTrab)->ZD_SERIEM
	SZD->ZD_NFREMES := SF1->F1_DOC
	SZD->ZD_SERIER  := SF1->F1_SERIE
	SZD->ZD_QTDNFRE := Posicione("SD1",1,xFilial("SD1")+xSEEK,"D1_QUANT")
	SZD->ZD_SALDO   := SZD->ZD_QTDNFRE
	SZD->ZD_PEDIDOC := (cCriaTrab)->ZD_PEDIDOC
	SZD->ZD_STATUS  := "AT"
	SZD->ZD_PARC    := "01"	
	
	dbselectarea("SF1")
	dbsetorder(1)
	dbseek(xFILIAL("SF1")+(cCriaTrab)->ZD_NFMAE+(cCriaTrab)->ZD_SERIEM+xFornece+xLoja)//PONTEIRA NA NF MÃE

	SZD->ZD_QTDMAE  := SD1->D1_QUANT
	
	dbselectarea("SA2")
	dbsetorder(1)
	dbSeek(xFilial("SA2")+ xFornece+xLoja )
			
	SZD->ZD_CNPJUSI := SA2->A2_CGC
	SZD->ZD_NUSINA  := SA2->A2_NREDUZ
	
	("SZD")->(MSUNLOCK())
	
    
	//volta a ponteirar na pré-nota que acabou de ser incluída
	dbSelectArea("SF1")
	SF1->(DbGoto(xcRecno))
	
	RECLOCK("SF1",.F.)
		SF1->F1_XNOMFOR := SA2->A2_NOME
		SF1->F1_NFMAE   := SZD->ZD_NFMAE 
		SF1->F1_CONTRA   := SZD->ZD_CONTRA
		SF1->F1_XPEDIDO  := SZD->ZD_PEDIDOC
		SF1->F1_XSERMAE  := SZD->ZD_SERIEM
		SF1->F1_XPERIOD  := SZD->ZD_PERIODO			
	("SF1")->(MSUNLOCK())	
	
	ApMsgStop("Tabela XML-Template atualizada sucesso!")
	
EndIf


DbSelectArea(cCriaTrab)	
(cCriaTrab)->(dbCloseArea())


RestArea(_aArea)
Return(lRet)

*******************************************************************************************************************************
User Function EDFA10LOK()
//ApMsgStop("LINHAOK")
Return .F.


User Function EDFA10TOK()

Local lOk           := .T.

DbSelectArea(cCriaTrab)

dbselectarea("SF1")
dbsetorder(1)
If !dbseek(xFILIAL("SF1")+(cCriaTrab)->ZD_NFMAE+(cCriaTrab)->ZD_SERIEM+xFornece+xLoja)
	
	ApMsgStop("Nota mãe informada não existe!")
	lOk := .F.
	
EndIf

dbSelectArea("SZ3")
dbSetOrder(1)
If !dbSeek(xFilial("SZ3")+(cCriaTrab)->ZD_CONTRA+(cCriaTrab)->ZD_PERIODO)
	
	ApMsgStop("Contrato + DP inexistente no conograma!")
	lOk := .F.
	
EndIf

DBSELECTAREA("SC7")
DBSETORDER(1)
If !DBSEEK(xFILIAL("SC7")+(cCriaTrab)->ZD_PEDIDOC)
	
	ApMsgStop("Pedido de compra inexistente!")
	lOk := .F.
	
EndIF

DBSELECTAREA("SC7")
DBSETORDER(23)
If !DBSEEK(xFILIAL("SC7")+(cCriaTrab)->ZD_CONTRA)
	
	ApMsgStop("Contrato não amarrado ao Pedido de Compra!")
	lOk := .F.
Else
	If 	(cCriaTrab)->ZD_PERIODO <> SC7->C7_XPERIOD
		ApMsgStop("Contrato/DP não amarrado ao Pedido de Compra!")
		lOk := .F.
	EndIf
	
EndIF

Return(lOk)

User Function EDFA10DOK()
//ApMsgStop("DELOK")
Return .T.

User Function EDFA10SDEL()
//ApMsgStop("SUPERDEL")
Return .T.

User Function EDFA10FDOK()
//ApMsgStop("FIELDOK")
Return .T.



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
