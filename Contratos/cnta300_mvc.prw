#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "Protheus.ch"

// -- Declaração de Variáveis Estáticas
Static cTipRevisa	:= ''
Static cAprTipRev	:= ''

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CNTA300_MVCºAutor  ³Luis Felipe Nascimento ³Data ³ 03/10/17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutenção de Contratos - ED&F MAN                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³                                                   /  /      º±±
±±º          ³                                                             º±±
±±º          ³                                                             º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CNTA300MVC(xRotAuto,nOpcAuto)

Local oBrowse
Local nX := 1    
Private aCoresLeg := {}

aRotina := MenuDef()

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("CN9")
oBrowse:SetDescription('Contratos')  

cRevAlc := " .Or. (Alltrim(CN9->CN9_SITUAC) == '09' .And. !Empty(CN9->CN9_APROV)) "

//-- Define legendas
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == '01'",                             "RED",    	'Cancelado'})
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == '02'",                             "YELLOW", 	'Em Elaboracao'})	
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == '03'",                             "BLUE",   	'Emitido'})
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == '04'",                             "ORANGE", 	'Em Aprovacao'})
aadd(aCoresLeg,{"AllTrim(CN9->CN9_SITUAC) == '11'",								"BR_CANCEL",'Rejeitado'}) 
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == '05'",                             "GREEN",  	'Vigente'})	
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == '06'",                             "GRAY",   	'Paralisado'})
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == '07'",                             "BROWN",  	'Sol. Finalizacao'})
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == '08'",                             "BLACK",  	'Finalizado'})
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == '09' .And. Empty(CN9->CN9_APROV)", "PINK",   	'Revisao'})
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == 'A' "+cRevAlc,						"VIOLET",	'Revisão - Aprovação por Alçadas'})
aadd(aCoresLeg,{"Alltrim(CN9->CN9_SITUAC) == '10'",                             "WHITE", 	'Revisado'})

For nX := 1 to Len(aCoresLeg) STEP 1
	If(Len(aCoresLeg[nX]) >= 3)
		oBrowse:addLegend(aCoresLeg[nX][1],aCoresLeg[nX][2],aCoresLeg[nX][3])
	EndIf
Next nX

oBrowse:Activate()

Return Nil

//-------------------------------------------------------------------// Menu Funcional//-------------------------------------------------------------------

*-----------------------*
Static Function MenuDef()
*-----------------------*

Local aRotina := {}

aAdd( aRotina, { 'Visualizar'					, 'VIEWDEF.CNTA300_MVC'	, 0, 2, 0, NIL } )
aAdd( aRotina, { 'Incluir'   					, 'VIEWDEF.CNTA300_MVC'	, 0, 3, 0, NIL } )
aAdd( aRotina, { 'Alterar'   					, 'VIEWDEF.CNTA300_MVC'	, 0, 4, 0, NIL } )
aAdd( aRotina, { 'Excluir'   					, 'VIEWDEF.CNTA300_MVC'	, 0, 5, 0, NIL } )
aAdd( aRotina, { 'Imprimir'  					, 'VIEWDEF.CNTA300_MVC'	, 0, 8, 0, NIL } )
aAdd( aRotina, { OemToAnsi('Aut.Alt.Situação')  , "u_fGRVCNN" 			, 0, 4, 0, nil } )  
aAdd( aRotina, { OemToAnsi("Situação")			, "CN100Situac"			, 0, 4, 0, nil } )  
aAdd( aRotina, { 'Copia'        				, "u_EDFA003"			, 0, 7, 0, nil } )  
aAdd( aRotina, { 'Gera P.C.' 					, "u_GerCom"			, 0, 7, 0, nil } )  
aAdd( aRotina, { 'Gera P.V.' 					, "u_GerVenPE"			, 0, 7, 0, nil } )  

Return aRotina

//-------------------------------------------------------------------// ModelDef - Modelo de dados do Cadastro de Clientes//-------------------------------------------------------------------

*------------------------*
Static Function Modeldef()
*------------------------*

Local oModel   := Nil
Local oStruCN9 := FWFormStruct( 1, 'CN9' )
Local oStruCNC := FWFormStruct( 1, 'CNC' )
Local oStruSZ3 := FWFormStruct( 1, 'SZ3' )
Local oStruSZ2 := FWFormStruct( 1, 'SZ2' )

//-----------------------------------------//Monta o modelo do formulário//-----------------------------------------

oModel:= MPFormModel():New("CNTA300_MVC",/*Pre-Validacao*/, /*Pos-Validacao*/, /*AQUI*/,/*Cancel*/)
oModel:AddFields("CN9MASTER", Nil , oStruCN9,/*Pre-Validacao*/,/*Pos-Validacao*/,/*Carga*/)

//-- Adiciona Grids
oModel:AddGrid( 'CNCDETAIL', 'CN9MASTER', oStruCNC ) 
oModel:AddGrid( 'SZ3DETAIL', 'CN9MASTER', oStruSZ3 ) 
oModel:AddGrid( 'SZ2DETAIL', 'CN9MASTER', oStruSZ2 ) 

//-- Seta UniqueLine
oModel:GetModel('CNCDETAIL'):SetUniqueLine({"CNC_CODIGO","CNC_LOJA","CNC_CLIENT","CNC_LOJACL"})
oModel:GetModel('SZ3DETAIL'):SetUniqueLine({"Z3_CONTRA","Z3_PERIODO"})
oModel:GetModel('SZ2DETAIL'):SetUniqueLine({"Z2_CONTRA","Z2_CODPRO"})

//-- Seta relacao entre os grids
oModel:SetRelation('CNCDETAIL',{{'CNC_FILIAL','xFilial("CNC")'},{'CNC_NUMERO','CN9_NUMERO'},{'CNC_REVISA','CN9_REVISA'}},CNC->(IndexKey(1)))
oModel:SetRelation('SZ3DETAIL',{{'Z3_FILIAL','xFilial("SZ3")'},{'Z3_CONTRA','CN9_NUMERO'}},SZ3->(IndexKey(1)))
oModel:SetRelation('SZ2DETAIL',{{'Z2_FILIAL','xFilial("SZ2")'},{'Z2_CONTRA','CN9_NUMERO'}},SZ2->(IndexKey(1)))

//-- Modelos de preenchimento opcional
oModel:GetModel('CNCDETAIL'):SetOptional(.T.)
oModel:GetModel('SZ3DETAIL'):SetOptional(.T.)
oModel:GetModel('SZ2DETAIL'):SetOptional(.T.)

oModel:SetActivate({|oModel| CN300Activ(oModel)})

oModel:SetDescription( 'CNTA300_MVC - Manutenção de Contratos')

Return(oModel)

//-------------------------------------------------------------------// ViewDef - Visualizador de dados do Cadastro //-------------------------------------------------------------------

*-----------------------*
Static Function ViewDef()
*-----------------------*

Local oView
Local oModel   	:= FWLoadModel("CNTA300_MVC") // Nome do Fonte
Local oView 	:= FWFormView():New()     	
Local cCampoCN9	:= "CN9_VLREAJ|CN9_NUMTIT|CN9_VLMEAC|CN9_TXADM |CN9_FORMA |CN9_DTENTR|CN9_LOCENT|CN9_CODENT|CN9_DESLOC|CN9_DESFIN|CN9_CONTFI|CN9_DTINPR|CN9_PERPRO|CN9_UNIPRO|CN9_VLRPRO|CN9_DTINCP|CN9_FILCTR|CN9_PRORAT|CN9_PERI|CN9_UNPERI|CN9_MODORJ"
Local cCampoCNC	:= "CNC_CODED |CNC_NUMPR |CNC_REVISA|CNC_CLIENT"
Local oStruCN9 	:= FWFormStruct(2,'CN9', {|cCampo| !AllTrim(cCampo) $ cCampoCN9})
Local oStruCNC 	:= FWFormStruct(2,'CNC', {|cCampo| !AllTrim(cCampo) $ cCampoCNC})
Local oStruSZ3 	:= FWFormStruct(2,'SZ3' )
Local oStruSZ2 	:= FWFormStruct(2,'SZ2' )
Local cOper		:= ''

//-- Monta o modelo da interface do formulario
oView:SetModel(oModel)
cOper := oModel:GetOperation()

//View do contrato
oView:AddField("VIEW_CN9", oStruCN9, "CN9MASTER")
oView:AddGrid('VIEW_CNC', oStruCNC, 'CNCDETAIL' )
oView:AddGrid('VIEW_SZ3', oStruSZ3, 'SZ3DETAIL' )
oView:AddGrid('VIEW_SZ2', oStruSZ2, 'SZ2DETAIL' )

oView:CreateHorizontalBox( 'SUPERIOR', 70 )
oView:CreateHorizontalBox( 'INFERIOR', 30 ) 

//-- Cria a pasta e planilhas da Manutencao de Contratos
oView:CreateFolder('FLDCNT','INFERIOR')
oView:AddSheet('FLDCNT','GRDFORN','Fornecedores')	  
oView:AddSheet('FLDCNT','GRDCRON','Cronograma')
oView:AddSheet('FLDCNT','GRDVEND','Condições Comerciais')

// Bloco com CreateFolder, AddSheet e CreateHorizontalBox
oView:CreateHorizontalBox('FORN' ,100,/*owner*/,/*lUsePixel*/,'FLDCNT','GRDFORN')		
oView:CreateHorizontalBox('CRON' ,100,/*owner*/,/*lUsePixel*/,'FLDCNT','GRDCRON')		
oView:CreateHorizontalBox('VEND' ,100,/*owner*/,/*lUsePixel*/,'FLDCNT','GRDVEND')		

oView:SetOwnerView( 'VIEW_CN9', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_CNC', 'FORN' )
oView:SetOwnerView( 'VIEW_SZ3', 'CRON' )
oView:SetOwnerView( 'VIEW_SZ2', 'VEND' ) 

If cOper == 7
	u_fGRVCNN()
EndIf

Return oView

*-----------------------*
User Function fGRVCNN()
*-----------------------*

Local cCod 		:= RetCodUsr()                              
Local aGrp		:= UsrRetGrp(UsrRetName(cCod))
Local aArea  	:= GetArea()

DbSelectArea("CNN")
CNN->(dbSetOrder(1))

//Verifica se o contrato tem controle total
If !CNN->(DbSeek(xFilial("CNN")+RetCodUsr()+CN9->CN9_NUMERO+"001"))
	//-- Gera permissão de controle sobre o contrato
	CNN->(RecLock("CNN",.T.))
	CNN->CNN_FILIAL := xFilial("CNN")	
	CNN->CNN_USRCOD := RetCodUsr()
	CNN->CNN_TRACOD := '001'
	CNN->CNN_CONTRA := CN9->CN9_NUMERO
	MsUnlock()
	CNN->(DBReindex())
	MsgAlert("Gera permissão de controle sobre o contrato !","CNTA300_MVC")
Else	
	MsgAlert("Usuário já tem permissão de controle sobre o contrato !","CNTA300_MVC")
EndIf

RestArea(aArea)
	
Return( .t. ) 

*--------------------------------*
Static Function CN300Activ(oModel)
*--------------------------------*

Static aGCTCRM		:= {}

Local oModelSZ2		:= oModel:GetModel('SZ2DETAIL')
Local oModelSZ3		:= oModel:GetModel('SZ3DETAIL')
Local aSaveLines	:= FWSaveRows()
Local nX			:= 1
Local nY			:= 1

If oModel:GetOperation() == MODEL_OPERATION_INSERT
	If Empty(oModel:GetValue("CN9MASTER","CN9_ESPCTR"))
   		cTipo := u_FDialCtr()
   		If	cTipo == '001' 
			oModel:GetModel("CN9MASTER"):SetValue("CN9_ESPCTR",'1')
			If Empty(oModel:GetValue("CN9MASTER","CN9_TPCTO"))
				oModel:GetModel("CN9MASTER"):SetValue("CN9_TPCTO",'001')
		    EndIf	
		Else
			oModel:GetModel("CN9MASTER"):SetValue("CN9_ESPCTR",'2')
			If Empty(oModel:GetValue("CN9MASTER","CN9_TPCTO"))
				oModel:GetModel("CN9MASTER"):SetValue("CN9_TPCTO",'002')
			EndIf	                                                    
		EndIf	                                                    
		If Empty(oModel:GetValue("CN9MASTER","CN9_NUMERO"))
			oModel:GetModel("CN9MASTER"):SetValue("CN9_NUMERO",cContra)
		EndIf	
	EndIf
	If Empty(oModel:GetValue('SZ2DETAIL','Z2_CONTRA'))
		For nX:=1 To oModelSZ2:Length()
			oModelSZ2:GoLine(nX)
			oModelSZ2:SetValue('Z2_CONTRA',cContra)
		Next nX
	Endif
	If Empty(oModel:GetValue('SZ3DETAIL','Z3_CONTRA'))
		For nY:=1 To oModelSZ2:Length()
			oModelSZ3:GoLine(nY)
			oModelSZ3:SetValue('Z3_CONTRA',cContra)
		Next nY
	Endif
Endif

cContra := Nil

FWRestRows(aSaveLines)

Return

*-----------------------*
User Function FDialCtr()
*-----------------------*

Local oDlg2
Local oGet012
Local cTitulo2 := "Tipo de Contrato"
Local cTitulo3 := "Número Contrato"
Local nOpcTp   := 1

Private cEspCtr    := Space(TamSX3("CN1_ESPCTR")[1])
Private cCodigo    := Space(TamSX3("CN1_CODIGO")[1])
Public  cContra    := Space(TamSX3("CN9_NUMERO")[1])

DEFINE MSDIALOG oDlg2 TITLE OemtoAnsi(cTitulo2) FROM  165,115 TO 245,430 PIXEL
@ 05,10 SAY OemToAnsi(cTitulo2) SIZE 60, 8 OF oDlg2 PIXEL
@ 05,70  MSGET oGet012 VAR cCodigo PICTURE "999" F3 "CN1" SIZE 25,9 VALID ExistCpo("CN1", cCodigo )  OF oDlg2 PIXEL

@ 20,10 SAY OemToAnsi(cTitulo3) SIZE 60, 8 OF oDlg2 PIXEL
@ 20,70  MSGET oGet012 VAR cContra PICTURE "@!" SIZE 50,9 VALID ExistChav("CN9",cContra) .AND. NAOVAZIO() OF oDlg2 PIXEL
DEFINE SBUTTON FROM 10, 123 TYPE 1 ACTION (if(!empty(cCodigo),oDlg2:End(),)) ENABLE OF oDlg2
DEFINE SBUTTON FROM 25, 123 TYPE 2 ACTION (cCodigo:="",oDlg2:End(),nOpcTp := 2) ENABLE OF oDlg2

ACTIVATE MSDIALOG oDlg2

CN1->( dbSetOrder(1) )
CN1->( dbSeek(xFilial("CN1")+cCodigo) )

cEspCtr := If(!Empty(CN1->CN1_ESPCTR),CN1->CN1_ESPCTR,"1")

Return( cCodigo )