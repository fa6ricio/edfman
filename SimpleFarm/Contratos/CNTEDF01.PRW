#Include "Totvs.ch"
#Include "FwMvcDef.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*
______________________________________________________________________________
|_____________________________________________________________________________|
|Programa  - CNTEDF01    Autor  Fabricio Antunes      Data   30/04/2026   	  |
|_____________________________________________________________________________|
|Descricao|Funcao para controle de contratos de algodao                       |
|         |                                                                   |
|_________|___________________________________________________________________|
|Uso      | ED & F                                                            | 
|_________|___________________________________________________________________|
|_____________________________________________________________________________|
*/

User Function CNTEDF01()
Private oBrowse 	:= FwMBrowse():New()

oBrowse:SetAlias('ZX3')
oBrowse:SetDescripton("Contratos Algodao")
//oBrowse:AddLegend( "ZX3->ZX3_TIPCLE == '1'", "GREEN", "Aberto" )
//oBrowse:AddLegend( "ZX3->ZX3_TIPCLE == '2'", "RED",   "Gerado" )
oBrowse:SetAmbiente(.F.)
oBrowse:SetWalkThru(.F.)
oBrowse:DisableDetails()
oBrowse:Activate()

Return
/*
______________________________________________________________________________
|_____________________________________________________________________________|
|Programa  - MenuDef    Autor  Fabricio Antunes      Data   04/11/2020   	  |
|_____________________________________________________________________________|
|Descricao|Funcao padrão MVC para geracao do menu da rotina			          |
|         |                                                                   |
|_________|___________________________________________________________________|
|Uso      | ED & F                                                         | 
|_________|___________________________________________________________________|
|_____________________________________________________________________________|
*/
Static Function MenuDef()

Local aMenu :=	{}

	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       		OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.CNTEDF01'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.CNTEDF01' 	OPERATION 3 ACCESS 0
	ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.CNTEDF01' 	OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.CNTEDF01' 	OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.CNTEDF01'	OPERATION 8 ACCESS 0
	ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.CNTEDF01'	OPERATION 9 ACCESS 0

Return(aMenu)

/*
______________________________________________________________________________
|_____________________________________________________________________________|
|Programa  - ModelDef    Autor  Fabricio Antunes      Data   04/11/2020   	  |
|_____________________________________________________________________________|
|Descricao|Funcao de Modelo de Dados do MVC onde é definido a estrutura de    |
|         |dados e Regras de Negocio                                          |
|_________|___________________________________________________________________|
|Uso      | ED & F                                                         | 
|_________|___________________________________________________________________|
|_____________________________________________________________________________|
*/

Static Function ModelDef()
	Local oStruZX3	:=	FWFormStruct(1,'ZX3', /*bAvalCampo*/, /*lViewUsado*/ ) 
	Local oStruZX4	:=	FWFormStruct(1,'ZX4', /*bAvalCampo*/, /*lViewUsado*/ ) 
	Local oStruZX5	:=	FWFormStruct(1,'ZX5', /*bAvalCampo*/, /*lViewUsado*/ ) 
	Local oStruZX6	:=	FWFormStruct(1,'ZX6', /*bAvalCampo*/, /*lViewUsado*/ ) 

	Local oModel


    oStruZX5:AddField( ;
	AllTrim('') , ;               // [01] C Titulo do campo
	AllTrim('') , ;               // [02] C ToolTip do campo
	'ZX5_LEGEND' , ;              // [03] C identificador (ID) do Field
	'C' , ;                       // [04] C Tipo do campo
	50 , ;                        // [05] N Tamanho do campo
	0 , ;                         // [06] N Decimal do campo
	NIL , ;                       // [07] B Code-block de validação do campo
	NIL , ;                       // [08] B Code-block de validação When do campo
	NIL , ;                       // [09] A Lista de valores permitido do campo
	NIL , ;                       // [10] L Indica se o campo tem preenchimento obrigatório
	{ || Iif(ZX5->ZX5_TIPO  = 'PA', "BR_BRANCO","BR_PRETO") } , ;           // [11] B Code-block de inicializacao do campo
	NIL , ;                       // [12] L Indica se trata de um campo chave
	NIL , ;                       // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                         // [14] L Indica se o campo é virtual 


	oModel	:=	MpFormModel():New('zCNE01',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Commit*/,/*Cancel*/)
	oModel:AddFields('ID_M_FLD_ZX3', /*cOwner*/, oStruZX3, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'ID_M_GRD_ZX4', 'ID_M_FLD_ZX3', oStruZX4, /*bLinePre*/, /*{|oModelZX4| ValLinha(oModelZX4)}*/, /*bPreVal*/,/*{|oModel| ValLinha(oModel)}*/, /*BLoad*/ )
	oModel:AddGrid( 'ID_M_GRD_ZX5', 'ID_M_FLD_ZX3', oStruZX5, /*bLinePre*/, /*{|oModelZX4| ValLinha(oModelZX4)}*/, /*bPreVal*/,/*{|oModel| ValLinha(oModel)}*/, /*BLoad*/ )
	oModel:AddGrid( 'ID_M_GRD_ZX6', 'ID_M_FLD_ZX3', oStruZX6, /*bLinePre*/, /*{|oModelZX4| ValLinha(oModelZX4)}*/, /*bPreVal*/,/*{|oModel| ValLinha(oModel)}*/, /*BLoad*/ )


	oModel:SetRelation( 'ID_M_GRD_ZX4', {{'ZX4_FILIAL','xFilial("ZX4")'},{'ZX4_CODIGO','ZX3_CODIGO'}}, ZX4->(IndexKey(1)))
	oModel:SetRelation( 'ID_M_GRD_ZX5', {{'ZX5_FILIAL','xFilial("ZX4")'},{'ZX5_CODIGO','ZX3_CODIGO'}}, ZX5->(IndexKey(1)))
	//oModel:SetRelation( 'ID_M_GRD_ZX5', {{'ZX5_FILIAL','xFilial("ZX5")'},{'ZX5_CODIGO','ZX4_CODIGO'},{'ZX5_NF','ZX4_NF'},;
	//									 {'ZX5_SERIE','ZX4_SERIE'}}, ZX5->(IndexKey(1)))
	oModel:SetRelation( 'ID_M_GRD_ZX6', {{'ZX6_FILIAL','xFilial("ZX6")'},{'ZX6_CODIGO','ZX3_CODIGO'}}, ZX6->(IndexKey(1)))



	oModel:GetModel( 'ID_M_GRD_ZX4' ):SetUniqueLine( { 'ZX4_FILIAL','ZX4_CODIGO','ZX4_ITEM'} )
	oModel:GetModel( 'ID_M_GRD_ZX5' ):SetUniqueLine( { 'ZX5_FILIAL','ZX5_CODIGO','ZX5_ITEM'} )
	oModel:GetModel( 'ID_M_GRD_ZX6' ):SetUniqueLine( { 'ZX6_FILIAL','ZX6_CODIGO','ZX6_ITEM'} )

	oModel:SetPrimaryKey({ 'ZX3_FILIAL', 'ZX3_CODIGO' })

	oModel:GetModel("ID_M_GRD_ZX4"):SetOptional(.T.)
	oModel:GetModel("ID_M_GRD_ZX5"):SetOptional(.T.)
	oModel:GetModel("ID_M_GRD_ZX6"):SetOptional(.T.)

	oModel:SetDescription( 'Contratos Algodao' )
	oModel:GetModel( 'ID_M_FLD_ZX3' ):SetDescription( 'Contratos Algodao' )
    oModel:GetModel( 'ID_M_GRD_ZX4' ):SetDescription( 'Notas Fiscais de Compras' )
	oModel:GetModel( 'ID_M_GRD_ZX5' ):SetDescription( 'Titulos Financeiros' )
	oModel:GetModel( 'ID_M_GRD_ZX6' ):SetDescription( 'Parceiros Negocio' )
	
Return(oModel)


/*
______________________________________________________________________________
|_____________________________________________________________________________|
|Programa  - ViewDef    Autor  Fabricio Antunes      Data   04/11/2020   	  |
|_____________________________________________________________________________|
|Descricao|Funcao de Visualização de Dados do MVC onde é definido a           |
|         |visualizacao da Regra de Negocio.                                  |
|_________|___________________________________________________________________|
|Uso      | ED & F                                                            | 
|_________|___________________________________________________________________|
|_____________________________________________________________________________|
*/

Static Function ViewDef()
	Local oStruZX3	:=	FWFormStruct(2,'ZX3') 	
	Local oStruZX4	:=	FWFormStruct(2,'ZX4') 
	Local oStruZX5	:=	FWFormStruct(2,'ZX5') 
	Local oStruZX6	:=	FWFormStruct(2,'ZX6') 
	Local oModel	:=	FwLoadModel('CNTEDF01')	
	Local oView		:=	FwFormView():New() 

	oStruZX5:AddField( ;            	    // Ord. Tipo Desc.
	'ZX5_LEGEND'                    , ;     // [01] C   Nome do Campo
	"00"                            , ;     // [02] C   Ordem
	AllTrim( ''    )        		, ;     // [03] C   Titulo do campo
	AllTrim( '' )       			, ;     // [04] C   Descricao do campo
	{ 'Legenda' }           		, ;     // [05] A   Array com Help
	'C'                             , ;     // [06] C   Tipo do campo
	'@BMP'               			, ;     // [07] C   Picture
	NIL                             , ;     // [08] B   Bloco de Picture Var
	''                              , ;     // [09] C   Consulta F3
	.T.                             , ;     // [10] L   Indica se o campo é alteravel
	NIL                             , ;     // [11] C   Pasta do campo
	NIL                             , ;     // [12] C   Agrupamento do campo
	NIL                             , ;     // [13] A   Lista de valores permitido do campo (Combo)
	NIL                             , ;     // [14] N   Tamanho maximo da maior opção do combo
	NIL                             , ;     // [15] C   Inicializador de Browse
	.T.                             , ;     // [16] L   Indica se o campo é virtual
	NIL                             , ;     // [17] C   Picture Variavel
	NIL                             )       // [18] L   Indica pulo de linha após o campo 


 	oView:SetModel(oModel)
	oView:AddField( 'ID_V_FLD_ZX3', oStruZX3, 'ID_M_FLD_ZX3')
	oView:AddGrid(  'ID_V_GRD_ZX4', oStruZX4, 'ID_M_GRD_ZX4')
	oView:AddGrid(  'ID_V_GRD_ZX5', oStruZX5, 'ID_M_GRD_ZX5')
	oView:AddGrid(  'ID_V_GRD_ZX6', oStruZX6, 'ID_M_GRD_ZX6')


	//oView:AddUserButton( 'Gerar Produtos', 'CLIPS', {|oView| MCOM01A()} )
	//oView:AddUserButton( 'Gerar Solicitacao', 'CLIPS', {|oView| GERASOLIC()} )
	

	oView:CreateHorizontalBox( 'ID_HBOX_40', 40 )
	oView:CreateHorizontalBox( 'ID_HBOX_60', 60)//,,, 'PASTAS', 'ABA01' )


	oView:CreateFolder('GRIDS','ID_HBOX_60')

	//Notas e Pagamentos
	oView:AddSheet('GRIDS', 'GRID_1', "Notas e Pag")
    oView:CreateHorizontalBox("GRID_NFPG", 100,,,'GRIDS','GRID_1')
    oView:CreateVerticalBox('ESQUERDA', 50 , 'GRID_NFPG',,'GRIDS','GRID_1')
	oView:CreateVerticalBox("DIREITA",  50 , 'GRID_NFPG',,'GRIDS','GRID_1')


    //Cedentes
    oView:AddSheet('GRIDS', 'GRID_2', "Parceiros Negocio")
    oView:CreateHorizontalBox("GRID_CD", 100,,,'GRIDS','GRID_2')


	oView:SetOwnerView( 'ID_V_FLD_ZX3', 'ID_HBOX_40' )
	oView:SetOwnerView( 'ID_V_GRD_ZX4', 'ESQUERDA' )
	oView:SetOwnerView( 'ID_V_GRD_ZX5', 'DIREITA' )
	oView:SetOwnerView( 'ID_V_GRD_ZX6', 'GRID_CD' )

	oView:SetViewProperty("ID_V_GRD_ZX4", "GRIDSEEK", {.T.})
	oView:SetViewProperty("ID_V_GRD_ZX4", "GRIDFILTER", {.T.})


	oView:SetViewProperty("ID_V_GRD_ZX5", "GRIDSEEK", {.T.})
	oView:SetViewProperty("ID_V_GRD_ZX5", "GRIDFILTER", {.T.})
	oView:SetViewProperty("ID_V_GRD_ZX5", "GRIDDOUBLECLICK", {{|oFormulario,cFieldName,nLineGrid,nLineModel| Iif(Alltrim(cFieldName) == "ZX5_LEGEND",TT002(),TT002())}})


	oView:EnableTitleView('ID_V_FLD_ZX3'	, 'Contratos Algodao' )
    oView:EnableTitleView('ID_V_GRD_ZX4'	, 'Notas Fiscais de Compras' )
	oView:EnableTitleView('ID_V_GRD_ZX5'	, 'Titulos Financeiros' )
	oView:EnableTitleView('ID_V_GRD_ZX6'	, 'Parceiros Negocio' )


	oView:AddIncrementField( 'ID_V_GRD_ZX4', 'ZX4_ITEM' )
	oView:AddIncrementField( 'ID_V_GRD_ZX5', 'ZX5_ITEM' )
	oView:AddIncrementField( 'ID_V_GRD_ZX6', 'ZX6_ITEM' )


Return(oView)


Static Function TT002()

// Cria a legenda que identifica a estrutura
oLegend := FWLegend():New()

// Adiciona descrição para cada legenda
oLegend:Add( { || }, 'BR_BRANCO'   , 'Pagamento Antecipado' ) 
oLegend:Add( { || }, 'BR_PRETO'    , 'Pagamento de Nota' ) 
oLegend:Add( { || }, 'BR_AMARELO'  , 'Cessao de Credito' )


// Ativa a Legenda
oLegend:Activate()

// Exibe a Tela de Legendas
oLegend:View()

Return Nil


//Rotina para visuaalizar o titulo 
Static Function TT003()

	Local oModel     	:= FWModelActive()
	Local oModelSE1 	:= oModel:GetModel( 'SE1DETAIL' )

	DbSelectArea("SE1")
	SE1->(DbSetOrder(1))
	If SE1->(DbSeek(xFilial("SE1")+oModelSE1:GetValue("E1_PREFIXO")+oModelSE1:GetValue("E1_NUM")+oModelSE1:GetValue("E1_PARCELA")))
		FA280Visua( "SE1",SE1->(Recno()),2 )
	Else
		Alert("Não Localizou")
	EndIf

Return()
