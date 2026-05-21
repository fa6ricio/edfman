#INCLUDE "rwmake.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFC009   บ Autor ณ Fabricio Antunes บ Data ณ  03/12/25     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro de grupos de Fornecedores                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function EDFC009

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZH"

dbSelectArea("SZH")
dbSetOrder(1)

AxCadastro(cString,"Grupo de Fornecedores",cVldExc,cVldAlt)

Return


User Function EDFC09MVC
Private oBrowse 	:= FwMBrowse():New()

oBrowse:SetAlias('SZH')
oBrowse:SetDescripton("Grupo de Fornecedores")
oBrowse:SetAmbiente(.F.)
oBrowse:SetWalkThru(.F.)
oBrowse:DisableDetails()
oBrowse:Activate()

Return Nil

//-------------------------------------------------------------------// Menu Funcional//-------------------------------------------------------------------

Static Function MenuDef()

Local aMenu :=	{}

	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       		OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.EDFC009'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.EDFC009' 	OPERATION 3 ACCESS 0
	ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.EDFC009' 	OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.EDFC009' 	OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.EDFC009'	OPERATION 8 ACCESS 0
	ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.EDFC009'	OPERATION 9 ACCESS 0


Return aMenu

//-------------------------------------------------------------------// ModelDef - Modelo de dados do Cadastro de Clientes//-------------------------------------------------------------------


Static Function Modeldef()

Local oStruSZH	:=	FWFormStruct(1,'SZH', /*bAvalCampo*/, /*lViewUsado*/ ) 
Local oModel

oModel	:=	MpFormModel():New('MDEDFC009',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Commit*/,/*Cancel*/)
oModel:AddFields('ID_M_FLD_SZH', /*cOwner*/, oStruSZH, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
oModel:SetPrimaryKey({ 'ZH_FILIAL', 'ZH_CODIGO' })
oModel:SetDescription( 'Grupo de Fornecedores' )
oModel:GetModel( 'ID_M_FLD_SZH' ):SetDescription( 'Grupo de Fornecedores' )
	

Return(oModel)

//-------------------------------------------------------------------// ViewDef - Visualizador de dados do Cadastro //-------------------------------------------------------------------


Static Function ViewDef()

Local oStruSZH	:=	FWFormStruct(2,'SZH') 	
Local oModel	:=	FwLoadModel('EDFC009')	
Local oView		:=	FwFormView():New() 

oView:SetModel(oModel)
oView:AddField( 'ID_V_FLD_SZH', oStruSZH, 'ID_M_FLD_SZH')

oView:CreateHorizontalBox( 'ID_HBOX_100', 100 )
oView:SetOwnerView( 'ID_V_FLD_SZH', 'ID_HBOX_100' )

oView:EnableTitleView('ID_V_FLD_SZH'	,'Grupo de Fornecedores')


Return oView

