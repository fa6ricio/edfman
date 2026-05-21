#INCLUDE "rwmake.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFC009   บ Autor ณ Fabricio Antunes บ Data ณ  12/12/26     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Notas fiscais integra็ใo Simplefarm                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function EDFC010

Private oBrowse 	:= FwMBrowse():New()

oBrowse:SetAlias('ZX1')
oBrowse:SetDescripton("Notas fiscais integra็ใo Simplefarm")
oBrowse:SetAmbiente(.F.)
oBrowse:SetWalkThru(.F.)
oBrowse:DisableDetails()
oBrowse:Activate()

Return Nil


Static Function MenuDef()

Local aMenu :=	{}

	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       		OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.EDFC010'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.EDFC010' 	OPERATION 3 ACCESS 0
	ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.EDFC010' 	OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.EDFC010' 	OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.EDFC010'	OPERATION 8 ACCESS 0
	ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.EDFC010'	OPERATION 9 ACCESS 0


Return aMenu



Static Function Modeldef()

Local oStruZX1	:=	FWFormStruct(1,'ZX1', /*bAvalCampo*/, /*lViewUsado*/ ) 
Local oModel

oModel	:=	MpFormModel():New('EDFC010A',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Commit*/,/*Cancel*/)
oModel:AddFields('ID_M_FLD_ZX1', /*cOwner*/, oStruZX1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
oModel:SetPrimaryKey({ 'ZX1_FILIAL', 'ZX1_EXPORT', 'ZX1_NOTA', 'ZX1_SERIE','ZX1_CHAVE', 'ZX1_ITEM' })
oModel:SetDescription( 'Notas fiscais integra็ใo Simplefarm' )
oModel:GetModel( 'ID_M_FLD_ZX1' ):SetDescription( 'Notas fiscais integra็ใo Simplefarm' )
	

Return oModel

//-------------------------------------------------------------------// ViewDef - Visualizador de dados do Cadastro //-------------------------------------------------------------------


Static Function ViewDef()

Local oStruZX1	:=	FWFormStruct(2,'ZX1') 	
Local oModel	:=	FwLoadModel('EDFC010')	
Local oView		:=	FwFormView():New() 

oView:SetModel(oModel)
oView:AddField( 'ID_V_FLD_ZX1', oStruZX1, 'ID_M_FLD_ZX1')

oView:CreateHorizontalBox( 'ID_HBOX_100', 100 )
oView:SetOwnerView( 'ID_V_FLD_ZX1', 'ID_HBOX_100' )

oView:EnableTitleView('ID_V_FLD_ZX1'	,'Grupo de Fornecedores')


Return oView

