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
oBrowse:SetDescripton("Contratos de Compra deAlgodao")
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

	ADD OPTION aMenu TITLE 'Pesquisar'  		ACTION 'PesqBrw'       		            OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' 		ACTION 'VIEWDEF.CNTEDF01'	            OPERATION 2 ACCESS 0
	//ADD OPTION aMenu TITLE 'Incluir'    		ACTION 'VIEWDEF.CNTEDF01' 	            OPERATION 3 ACCESS 0
	//ADD OPTION aMenu TITLE 'Alterar'    		ACTION 'VIEWDEF.CNTEDF01' 	            OPERATION 4 ACCESS 0
	//ADD OPTION aMenu TITLE 'Excluir'    		ACTION 'VIEWDEF.CNTEDF01' 	            OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   		ACTION 'VIEWDEF.CNTEDF01'	            OPERATION 8 ACCESS 0
	//ADD OPTION aMenu TITLE 'Copiar'     		ACTION 'VIEWDEF.CNTEDF01'	            OPERATION 9 ACCESS 0
	ADD OPTION aMenu TITLE 'Gerar Titulos'     ACTION 'U_GeraMkZX5("","","")'           OPERATION 10 ACCESS 0

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
	AllTrim('Legenda de Tipo') , ;               // [02] C ToolTip do campo
	'ZX5_LEGEND' , ;              // [03] C identificador (ID) do Field
	'C' , ;                       // [04] C Tipo do campo
	50 , ;                        // [05] N Tamanho do campo
	0 , ;                         // [06] N Decimal do campo
	NIL , ;                       // [07] B Code-block de validação do campo
	NIL , ;                       // [08] B Code-block de validação When do campo
	NIL , ;                       // [09] A Lista de valores permitido do campo
	NIL , ;                       // [10] L Indica se o campo tem preenchimento obrigatório
	{ || Iif(ZX5->ZX5_TIPO  = 'PA' .AND. ZX5->ZX5_PREFIX = 'PA' ,;
            "BR_BRANCO",;
         IIF (ZX5->ZX5_TIPO  = 'PA' .AND. ZX5->ZX5_PREFIX = 'AT',;
            "BR_AMARELO", ;
        "BR_CINZA")) } , ;           // [11] B Code-block de inicializacao do campo
	NIL , ;                       // [12] L Indica se trata de um campo chave
	NIL , ;                       // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                         // [14] L Indica se o campo é virtual 

    oStruZX5:AddField( ;
	AllTrim('') , ;               // [01] C Titulo do campo
	AllTrim('Legenda de Moedas') , ;               // [02] C ToolTip do campo
	'ZX5_TPMOD' , ;              // [03] C identificador (ID) do Field
	'C' , ;                       // [04] C Tipo do campo
	50 , ;                        // [05] N Tamanho do campo
	0 , ;                         // [06] N Decimal do campo
	NIL , ;                       // [07] B Code-block de validação do campo
	NIL , ;                       // [08] B Code-block de validação When do campo
	NIL , ;                       // [09] A Lista de valores permitido do campo
	NIL , ;                       // [10] L Indica se o campo tem preenchimento obrigatório
	{ || Iif(ZX5->ZX5_MOEDA  = '1', "BR_AZUL","BR_VERDE") } , ;           // [11] B Code-block de inicializacao do campo
	NIL , ;                       // [12] L Indica se trata de um campo chave
	NIL , ;                       // [13] L Indica se o campo pode receber valor em uma operação de update.
	.T. )                         // [14] L Indica se o campo é virtual 


    oStruZX5:AddField( ;
    'Acao' , ;                      // [01] C Titulo do campo
    'Duplo clique para Gerar' , ;   // [02] C ToolTip do campo
    'ZX5_GERAR' , ;                 // [03] C identificador (ID) do Field
    'C' , ;                         // [04] C Tipo do campo
    10 , ;                          // [05] N Tamanho do campo (O NUMERO QUE O PROTHEUS ESPERAVA)
    0 , ;                           // [06] N Decimal do campo
    NIL , ;                         // [07] B Code-block de validação do campo
    NIL , ;                         // [08] B Code-block de validação When do campo
    NIL , ;                         // [09] A Lista de valores permitido do campo
    NIL , ;                         // [10] L Indica se o campo tem preenchimento obrigatório
    { || Iif(ZX5->ZX5_STATUS == "1" .AND. ZX5->ZX5_MOEDA  == '2', "BUDGET", "CADEADO") } ,;               // [11] B Code-block de inicializacao do campo (Icone)
    NIL , ;                         // [12] L Indica se trata de um campo chave
    NIL , ;                         // [13] L Indica se o campo pode receber valor
    .T. )                           // [14] L Indica se o campo é virtual


	oModel := MpFormModel():New('zCNE01', /*Pre-Validacao*/, /*Pos-Validacao*/, {|oModel| U_CNE01Cmt(oModel)}, /*Cancel*/)
	oModel:AddFields('ID_M_FLD_ZX3', /*cOwner*/, oStruZX3, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'ID_M_GRD_ZX4', 'ID_M_FLD_ZX3', oStruZX4, /*bLinePre*/, /*{|oModelZX4| ValLinha(oModelZX4)}*/, /*bPreVal*/,/*{|oModel| ValLinha(oModel)}*/, /*BLoad*/ )
	oModel:AddGrid( 'ID_M_GRD_ZX5', 'ID_M_FLD_ZX3', oStruZX5, /*bLinePre*/, /*{|oModelZX4| ValLinha(oModelZX4)}*/, /*bPreVal*/,/*{|oModel| ValLinha(oModel)}*/, /*BLoad*/ )
	oModel:AddGrid( 'ID_M_GRD_ZX6', 'ID_M_FLD_ZX3', oStruZX6, /*bLinePre*/, /*{|oModelZX4| ValLinha(oModelZX4)}*/, /*bPreVal*/,/*{|oModel| ValLinha(oModel)}*/, /*BLoad*/ )


	oModel:SetRelation( 'ID_M_GRD_ZX4', {{'ZX4_FILIAL','xFilial("ZX4")'},{'ZX4_CODIGO','ZX3_CODIGO'}}, ZX4->(IndexKey(1)))
	oModel:SetRelation( 'ID_M_GRD_ZX5', {{'ZX5_FILIAL','xFilial("ZX4")'},{'ZX5_CODIGO','ZX3_CODIGO'}}, ZX5->(IndexKey(1)))
	oModel:SetRelation( 'ID_M_GRD_ZX6', {{'ZX6_FILIAL','xFilial("ZX6")'},{'ZX6_CODIGO','ZX3_CODIGO'}}, ZX6->(IndexKey(1)))



	oModel:GetModel( 'ID_M_GRD_ZX4' ):SetUniqueLine( { 'ZX4_FILIAL','ZX4_CODIGO','ZX4_ITEM'} )
	oModel:GetModel( 'ID_M_GRD_ZX5' ):SetUniqueLine( { 'ZX5_FILIAL','ZX5_CODIGO','ZX5_ITEM'} )
	oModel:GetModel( 'ID_M_GRD_ZX6' ):SetUniqueLine( { 'ZX6_FILIAL','ZX6_CODIGO','ZX6_ITEM'} )

	oModel:SetPrimaryKey({ 'ZX3_FILIAL', 'ZX3_CODIGO' })

	oModel:GetModel("ID_M_GRD_ZX4"):SetOptional(.T.)
	oModel:GetModel("ID_M_GRD_ZX5"):SetOptional(.T.)
	oModel:GetModel("ID_M_GRD_ZX6"):SetOptional(.T.)

	oModel:SetDescription( 'Contratos Algodao' )
	oModel:GetModel( 'ID_M_FLD_ZX3' ):SetDescription( 'Contratos de Compra deAlgodao' )
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
	AllTrim( 'Tipo'    )        		, ;     // [03] C   Titulo do campo
	AllTrim( 'Tipo de titulo' )       			, ;     // [04] C   Descricao do campo
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

    oStruZX5:AddField( ;            	    // Ord. Tipo Desc.
	'ZX5_TPMOD'                    , ;     // [01] C   Nome do Campo
	"01"                            , ;     // [02] C   Ordem
	AllTrim( 'Moeda'    )        		, ;     // [03] C   Titulo do campo
	AllTrim( 'Legenda Moeda' )       			, ;     // [04] C   Descricao do campo
	{ 'Moeda' }           		, ;     // [05] A   Array com Help
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


    oStruZX5:AddField( ;
    'ZX5_GERAR' , ;                 // [01] C   Nome do Campo
    "02" , ;                        // [02] C   Ordem
    'Gerar' , ;                     // [03] C   Titulo do campo
    'Gerar Titulo' , ;              // [04] C   Descricao do campo
    {'Duplo clique para gerar'} , ; // [05] A   Array com Help (O ARRAY QUE DEU CONFLITO)
    'C' , ;                         // [06] C   Tipo do campo
    '@BMP' , ;                      // [07] C   Picture
    NIL , ;                         // [08] B   Bloco de Picture Var
    '' , ;                          // [09] C   Consulta F3
    .F. , ;                         // [10] L   Indica se o campo é alteravel
    NIL , ;                         // [11] C   Pasta do campo
    NIL , ;                         // [12] C   Agrupamento do campo
    NIL , ;                         // [13] A   Lista de valores permitido do campo (Combo)
    NIL , ;                         // [14] N   Tamanho maximo da maior opção do combo
    NIL , ;                         // [15] C   Inicializador de Browse
    .T. , ;                         // [16] L   Indica se o campo é virtual
    NIL , ;                         // [17] C   Picture Variavel
    NIL )                           // [18] L   Indica pulo de linha após o campo

    


 	oView:SetModel(oModel)
	oView:AddField( 'ID_V_FLD_ZX3', oStruZX3, 'ID_M_FLD_ZX3')
	oView:AddGrid(  'ID_V_GRD_ZX4', oStruZX4, 'ID_M_GRD_ZX4')
	oView:AddGrid(  'ID_V_GRD_ZX5', oStruZX5, 'ID_M_GRD_ZX5')
	oView:AddGrid(  'ID_V_GRD_ZX6', oStruZX6, 'ID_M_GRD_ZX6')


	oView:AddUserButton( 'Gerar Titulos', 'CLIPS', {|oView| U_GeraMkZX5()} )
	

	oView:CreateHorizontalBox( 'ID_HBOX_40', 40 )
	oView:CreateHorizontalBox( 'ID_HBOX_60', 60)//,,, 'PASTAS', 'ABA01' )


	oView:CreateFolder('GRIDS','ID_HBOX_60')

	//Notas e Pagamentos
	oView:AddSheet('GRIDS', 'GRID_1', "Notas e Pagamentos")
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
    oView:SetViewProperty("ID_V_GRD_ZX5", "GRIDDOUBLECLICK", {{|oFormulario, cFieldName, nLineGrid, nLineModel| ;
        Iif(Alltrim(cFieldName) == "ZX5_LEGEND", TT002(),;
        Iif(Alltrim(cFieldName) == "ZX5_TPMOD", TT003(), ;
        Iif(Alltrim(cFieldName) == "ZX5_GERAR", ;
            U_GeraMkZX5( oFormulario:GetModel('ID_M_GRD_ZX5'):GetValue('ZX5_NUMERO'), ;
                         oFormulario:GetModel('ID_M_GRD_ZX5'):GetValue('ZX5_PARCEL'), ;
                         oFormulario:GetModel('ID_M_GRD_ZX5'):GetValue('ZX5_STATUS') ), Nil))) }})


	oView:EnableTitleView('ID_V_FLD_ZX3'	, 'Contratos de Compra deAlgodao' )
    oView:EnableTitleView('ID_V_GRD_ZX4'	, 'Notas Fiscais de Compras' )
	oView:EnableTitleView('ID_V_GRD_ZX5'	, 'Titulos Financeiros' )
	oView:EnableTitleView('ID_V_GRD_ZX6'	, 'Parceiros Negocio' )


	oView:AddIncrementField( 'ID_V_GRD_ZX4', 'ZX4_ITEM' )
	oView:AddIncrementField( 'ID_V_GRD_ZX5', 'ZX5_ITEM' )
	oView:AddIncrementField( 'ID_V_GRD_ZX6', 'ZX6_ITEM' )


Return(oView)


Static Function TT002()

oLegend := FWLegend():New()

oLegend:Add( { || }, 'BR_BRANCO'   , 'Pagamento Antecipado' ) 
oLegend:Add( { || }, 'BR_CINZA'    , 'Pagamento de Nota' ) 
oLegend:Add( { || }, 'BR_AMARELO'  , 'Cessao de Credito' )


oLegend:Activate()

oLegend:View()

Return Nil


Static Function TT003()

oLegend := FWLegend():New()

oLegend:Add( { || }, 'BR_AZUL'   , 'Real' ) 
oLegend:Add( { || }, 'BR_VERDE'    , 'Dolar' ) 



oLegend:Activate()

oLegend:View()


Return()

/*
______________________________________________________________________________
| Função    | U_GeraMkZX5                                                     |
| Descrição | Tela de MarkBrowse para selecionar títulos pós-fixados (ZX5)    |
|           | pendentes de geração na SE2.                                    |
|___________|_________________________________________________________________|
*/
User Function GeraMkZX5(cTitNum, cTitParc, cTitStatus)
    Local oMark
    Local oDlg
    Local cAliasTRB  := GetNextAlias()
    Local cAliasQry  := GetNextAlias()
    Local aCampos    := {}
    Local cQuery     := ""
    Local oTempTable
    Local lConfirm   := .F.
    Local cMarca     := GetMark() 
    Local lIsAltera  := .F. 
    Local lDireto    := .F.
    
    Local aParam     := {}
    Local cFilde     := Space(Tamsx3("ZX5_FILIAL")[1])
    Local cFilAte    := Replicate("Z",Tamsx3("ZX5_FILIAL")[1])

    Local cFornDe    := Space(TamSx3("ZX5_FORNEC")[1])
    Local cLojde     := Space(Tamsx3("ZX5_LOJA")[1])
    Local cFornAte   := Replicate("Z", TamSx3("ZX5_FORNEC")[1])
    Local cLojAte    := Replicate("Z",Tamsx3("ZX5_LOJA")[1])
    Local cContrDe   := Space(TamSx3("ZX5_CODIGO")[1])
    Local cContrAte  := Replicate("Z", TamSx3("ZX5_CODIGO")[1])
    Local dVenctoDe  := CTOD("")
    Local dVenctoAte := LastDate(Date())

    Default cTitNum    := ""
    Default cTitParc   := ""
    Default cTitStatus := ""

    If !Empty(cTitNum) 
        If cTitStatus == "2"
            MsgInfo("Este título já foi gerado no Contas a Pagar.", "Aviso")
            Return .F.
        EndIf
        lDireto := .T. 
    EndIf

    If Type("ALTERA") == "L" 
        lIsAltera := ALTERA
    EndIf

    If lIsAltera
        If Empty(ZX3->ZX3_CODIGO)
            MsgAlert("Posicione em um contrato válido para gerar os títulos.", "Atenção")
            Return
        EndIf
    Else
        aAdd(aParam, {1, "Filial De"       , cFilde        , "", "", "SM0", "", 80, .F.})
        aAdd(aParam, {1, "Filial Até"      , cFilAte       , "", "", "SM0", "", 80, .F.})
        aAdd(aParam, {1, "Fornecedor De"   , cFornDe       , "", "", "SA2", "", 80, .F.})
        aAdd(aParam, {1, "Loja De"         , cLojde        , "", "", "SA2", "", 80, .F.})        
        aAdd(aParam, {1, "Fornecedor Até"  , cFornAte      , "", "", "SA2", "", 80, .F.})
        aAdd(aParam, {1, "Loja Até"        , cLojAte       , "", "", "SA2", "", 80, .F.})        
        aAdd(aParam, {1, "Contrato De"     , cContrDe      , "", "", "ZX3", "", 80, .F.})
        aAdd(aParam, {1, "Contrato Até"    , cContrAte     , "", "", "ZX3", "", 80, .F.})

        aAdd(aParam, {1, "Vencto De"        , dVenctoDe     ,  "", ".T.", "", ".T.", 80,  .F.})
        aAdd(aParam, {1, "Vencto Até"       , dVenctoAte    ,  "", ".T.", "", ".T.", 80,  .F.})

        If ParamBox(aParam, "Filtros para Geracao de Titulos",)
            cFilde      := MV_PAR01
            cFilAte     := MV_PAR02
            cFornDe     := MV_PAR03
            cLojde      := MV_PAR04
            cFornAte    := MV_PAR05
            cLojAte     := MV_PAR06
            cContrDe    := MV_PAR07
            cContrAte   := MV_PAR08
            dVenctoDe   := MV_PAR09
            dVenctoAte  := MV_PAR10
        Else
            Return
        EndIf
    EndIf

    oTempTable := FWTemporaryTable():New(cAliasTRB)

    AAdd(aCampos, {"OK"         , "C", 2                        , 0})
    AAdd(aCampos, {"REC_ZX5"    , "N", 15                       , 0})
    AAdd(aCampos, {"ZX5_PARCEL" , "C", TamSx3("ZX5_PARCEL")[1]  , 0})
    AAdd(aCampos, {"ZX5_NUMERO" , "C", TamSx3("ZX5_NUMERO")[1]  , 0})
    AAdd(aCampos, {"ZX5_CODIGO" , "C", TamSx3("ZX5_CODIGO")[1]  , 0})
    AAdd(aCampos, {"ZX5_FORNEC" , "C", TamSx3("ZX5_FORNEC")[1]  , 0})
    AAdd(aCampos, {"ZX5_LOJA"   , "C", TamSx3("ZX5_LOJA")[1]    , 0})
    AAdd(aCampos, {"ZX5_VLRTIT" , "N", TamSx3("ZX5_VLRTIT")[1]  , TamSx3("ZX5_VLRTIT")[2]})
    AAdd(aCampos, {"ZX5_VENCTO" , "D", TamSx3("ZX5_VENCTO")[1]  ,0})

    oTempTable:SetFields(aCampos)
    oTempTable:Create()

    cQuery := "SELECT R_E_C_N_O_ AS RECNO_ZX5, ZX5_PARCEL, ZX5_NUMERO, ZX5_FORNEC, ZX5_LOJA, ZX5_VLRTIT, ZX5_VENCTO, ZX5_CODIGO "
    cQuery += " FROM " + RetSqlName("ZX5")
 
    If lIsAltera
        cQuery += " WHERE ZX5_FILIAL = '" + xFilial("ZX5") + "' " 
        cQuery += " AND ZX5_CODIGO = '" + ZX3->ZX3_CODIGO + "' "
        cQuery += " AND ZX5_MOEDA = '2' "
    Else
        cQuery += " WHERE ZX5_FILIAL >= '" + cFilde   + "' AND ZX5_FILIAL <= '" + cFilAte  + "' "
        cQuery += " AND ZX5_FORNEC >= '" + cFornDe  + "' AND ZX5_FORNEC <= '" + cFornAte  + "' "
        cQuery += " AND ZX5_LOJA   >= '" + cLojde   + "' AND ZX5_LOJA   <= '" + cLojAte  + "' "
        cQuery += " AND ZX5_CODIGO >= '" + cContrDe + "' AND ZX5_CODIGO <= '" + cContrAte + "' "
        cQuery += " AND ZX5_MOEDA = '2' "

        cQuery += " AND ZX5_VENCTO >= '" + DtoS(dVenctoDe) + "' AND ZX5_VENCTO <= '" + DtoS(dVenctoAte) + "' "     
                         
    EndIf

    If !Empty(cTitNum)
        cQuery += " AND ZX5_NUMERO = '" + cTitNum + "' "
        cQuery += " AND ZX5_PARCEL = '" + cTitParc + "' "
    EndIf
    
    cQuery += " AND ZX5_STATUS = '1' " 
    cQuery += " AND D_E_L_E_T_ = ' ' "

    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias (cAliasQry)

    While !(cAliasQry)->(Eof())
        RecLock(cAliasTRB, .T.)
        
        (cAliasTRB)->OK         := Iif(lDireto, cMarca, "") 
        
        (cAliasTRB)->REC_ZX5    := (cAliasQry)->RECNO_ZX5
        (cAliasTRB)->ZX5_FORNEC := (cAliasQry)->ZX5_FORNEC
        (cAliasTRB)->ZX5_LOJA   := (cAliasQry)->ZX5_LOJA
        (cAliasTRB)->ZX5_CODIGO := (cAliasQry)->ZX5_CODIGO        
        (cAliasTRB)->ZX5_NUMERO := (cAliasQry)->ZX5_NUMERO
        (cAliasTRB)->ZX5_PARCEL := (cAliasQry)->ZX5_PARCEL        
        (cAliasTRB)->ZX5_VLRTIT := (cAliasQry)->ZX5_VLRTIT
        (cAliasTRB)->ZX5_VENCTO := Stod((cAliasQry)->ZX5_VENCTO)
        (cAliasTRB)->(MsUnlock())
        
        (cAliasQry)->(DbSkip())
    EndDo
    (cAliasQry)->(DbCloseArea())

    (cAliasTRB)->(DbGoTop())
    If (cAliasTRB)->(Eof())
        MsgInfo("Não há títulos pendentes de geração para este(s) contrato(s).", "Aviso")
        oTempTable:Delete()
        Return
    EndIf

    
    If lDireto

        If MsgNoYes("Confirma a geração do título " + AllTrim(cTitNum) + " (Parcela " + AllTrim(cTitParc) + ") no Contas a Pagar?", "Atenção")
            ExecMarca(cAliasTRB, cMarca)
        Else
            MsgInfo("Geração de títulos cancelada pelo usuário.", "Cancelado")
        Endif
    Else

        DEFINE MSDIALOG oDlg TITLE "Geracao de Titulos a Pagar (Pos-Fixados)" FROM 000, 000 TO 400, 800 PIXEL

        oMark := FWMarkBrowse():New()
        oMark:SetOwner(oDlg) 
        oMark:SetAlias(cAliasTRB)
        oMark:SetDescription("Titulos Encontrados")
        oMark:SetFieldMark("OK")
        oMark:Mark(cMarca)
        oMark:SetMenuDef("U_MnuVazio")
        oMark:DisableReport()
        oMark:DisableConfig()

        oMark:oBrowse:AddColumn( {"Fornecedor"  , {|| (cAliasTRB)->ZX5_FORNEC}, "C", "", 0, TamSx3("ZX5_FORNEC")[1], 0                        , .F.} )
        oMark:oBrowse:AddColumn( {"Loja"        , {|| (cAliasTRB)->ZX5_LOJA}  , "C", "", 0, TamSx3("ZX5_LOJA")[1]  , 0                        , .F.} )
        oMark:oBrowse:AddColumn( {"Contrato"    , {|| (cAliasTRB)->ZX5_CODIGO}, "C", "", 0, TamSx3("ZX5_CODIGO")[1], 0                        , .F.} )
        oMark:oBrowse:AddColumn( {"Numero"      , {|| (cAliasTRB)->ZX5_NUMERO}, "C", "", 0, TamSx3("ZX5_NUMERO")[1], 0                        , .F.} )        
        oMark:oBrowse:AddColumn( {"Parcela"     , {|| (cAliasTRB)->ZX5_PARCEL}, "C", "", 0, TamSx3("ZX5_PARCEL")[1], 0                        , .F.} )
        oMark:oBrowse:AddColumn( {"Valor"       , {|| (cAliasTRB)->ZX5_VLRTIT}, "N", "", 0, TamSx3("ZX5_VLRTIT")[1], TamSx3("ZX5_VLRTIT")[2]  , .F.} )
        oMark:oBrowse:AddColumn( {"Vencimento"  , {|| (cAliasTRB)->ZX5_VENCTO}, "D", "", 0, TamSx3("ZX5_VENCTO")[1], 0                        , .F.} )

        oMark:Activate()

        oDlg:lMaximized := .T.

        ACTIVATE MSDIALOG oDlg CENTERED ;
            ON INIT EnchoiceBar(oDlg, {|| lConfirm := .T., oDlg:End() }, {|| lConfirm := .F., oDlg:End() })

        If lConfirm
            ExecMarca(cAliasTRB, cMarca)
        EndIf
    EndIf
    
    // Limpeza
    oTempTable:Delete()

Return

/*
______________________________________________________________________________
| Função    | ExecMarca                                                       |
| Descrição | Processa as marcações do MarkBrowse, monta o JSON e invoca a    |
|           | rotina original gravaDados()                                    |
|___________|_________________________________________________________________|
*/
Static Function ExecMarca(cAliasTRB, cMarca)
    Local oJsonReq  := JsonObject():New()
    Local aInclui   := {}
    Local oItem
    Local nGerados  := 0
    Local aRet

    Local aParam    := {}
    Local nTaxaPtax := 0

    Local dDataD1   := dDataBase - 1 
    Local nTxDolar  := 0

    (cAliasTRB)->(DbGoTop())
    While !(cAliasTRB)->(Eof())
        If (cAliasTRB)->OK <> " " 
            nGerados++
        EndIf
        (cAliasTRB)->(DbSkip())
    EndDo

    If nGerados == 0
        MsgAlert("Nenhum título foi selecionado. A geração não será realizada.", "Atenção")
        Return .F.
    EndIf
    
    DbSelectArea("SM2")
    SM2->(DbSetOrder(1)) 
    SM2->(DbSeek(DtoS(dDataD1), .T.))
    
    If SM2->(Eof()) .Or. SM2->M2_DATA > dDataD1
        SM2->(DbSkip(-1))
    EndIf
    
    If !SM2->(Bof()) .And. !Empty(SM2->M2_DATA)
        nTxDolar := SM2->M2_MOEDA2
    EndIf

    aAdd(aParam, {1, "Taxa de conversão do Dolar:", nTxDolar, "@E 999.9999", "Positivo()"    , "", ".T.", 50,  .F.})
    
    If ParamBox(aParam, "Conversão de Títulos (Pós-Fixado)",)
        
        nTaxaPtax := MV_PAR01
        
        If nTaxaPtax <= 0
            MsgStop("A taxa do dólar informada deve ser maior que zero!", "Erro")
            Return .F.
        EndIf
    Else
        MsgInfo("Geração de títulos cancelada pelo usuário.", "Cancelado")
        Return .F.
    EndIf

    nGerados := 0 

    (cAliasTRB)->(DbGoTop())
    While !(cAliasTRB)->(Eof())
        If (cAliasTRB)->OK <> " " 
            
            DbSelectArea("ZX5")
            ZX5->(DbGoTo((cAliasTRB)->REC_ZX5))

            oItem := JsonObject():New()

            DbSelectArea("ZX3")
            ZX3->(DbSetOrder(1))
            If ZX3->(DbSeek(ZX5->ZX5_FILIAL + ZX5->ZX5_CODIGO))
                oItem['BLOQUEIO_PAGAMENTO'] := ZX3->ZX3_BLQPAG // ERRO AQUI! oItem ainda não existe.
            Else
                oItem['BLOQUEIO_PAGAMENTO'] := "2" 
            EndIf
            
            Iif(!Empty(ZX5->ZX5_FILIAL),     oItem['FILIAL_TITULO']   := ZX5->ZX5_FILIAL,            Nil)
            Iif(!Empty(ZX5->ZX5_PREFIX),     oItem['PREFIXO_TITULO']  := Upper(ZX5->ZX5_PREFIX),     Nil)
            Iif(!Empty(ZX5->ZX5_NUMERO),     oItem['NUMERO_TITULO']   := Upper(ZX5->ZX5_NUMERO),     Nil)
            Iif(!Empty(ZX5->ZX5_PARCEL),     oItem['PARCELA_TITULO']  := Upper(ZX5->ZX5_PARCEL),     Nil)
            Iif(!Empty(ZX5->ZX5_TIPO),       oItem['TIPO_TITULO']     := Upper(ZX5->ZX5_TIPO),       Nil)
            Iif(!Empty(ZX5->ZX5_FORNEC),     oItem['FORNECEDOR']      := ZX5->ZX5_FORNEC,            Nil)
            Iif(!Empty(ZX5->ZX5_LOJA),       oItem['LOJA']            := ZX5->ZX5_LOJA,              Nil)
            Iif(!Empty(ZX5->ZX5_CODIGO),     oItem['NUMERO_CONTRATO'] := ZX5->ZX5_CODIGO,            Nil)

            Iif(!Empty(ZX5->ZX5_EMISSA),     oItem['DATA_EMISSAO']    := DtoS(ZX5->ZX5_EMISSA),      Nil)
            Iif(!Empty(ZX5->ZX5_VENCTO),     oItem['DATA_VENCIMENTO'] := DtoS(ZX5->ZX5_VENCTO),      Nil)
            Iif(ZX5->ZX5_VLRTIT > 0,         oItem['VALOR_TITULO']    := cValToChar(ZX5->ZX5_VLRTIT), Nil)
            
            oItem['HISTORICO']              := "TITULO GERADO MANUALMENTE"
            oItem['BANCO']                  := ""
            oItem['AGENCIA']                := ""
            
            oItem['MOEDA']           := 2 
            oItem['PTAX']            := cValToChar(nTaxaPtax) 
            oItem['ORIGEM']          := "MARKBROWSE"

            AAdd(aInclui, oItem)
            nGerados++
        EndIf
        (cAliasTRB)->(DbSkip())
    EndDo

    If nGerados > 0
        oJsonReq['INCLUI_PAGAR'] := aInclui

        aRet := U_gravaDados(oJsonReq)

        If ValType(aRet) == "A" .And. aRet[1] == .T.
            MsgInfo("Títulos gerados e convertidos no Contas a Pagar com sucesso!", "Sucesso")

            (cAliasTRB)->(DbGoTop())
            While !(cAliasTRB)->(Eof())
                If (cAliasTRB)->OK <> " "
                    DbSelectArea("ZX5")
                    ZX5->(DbGoTo((cAliasTRB)->REC_ZX5))
                    
                    RecLock("ZX5", .F.)
                        ZX5->ZX5_STATUS := "2" 
                        ZX5_PTAX:=nTaxaPtax
                    ZX5->(MsUnlock())
                EndIf
                (cAliasTRB)->(DbSkip())
            EndDo
        Else
            MsgStop("Houve um erro na geração dos títulos: " + aRet[2], "Erro")
        EndIf
    EndIf

    FreeObj(oJsonReq)
Return .T.
/*
______________________________________________________________________________
| Função    | U_MnuVazio                                                      |
| Descrição | Menu vazio para limpar os botoes superiores do FWMarkBrowse     |
|___________|_________________________________________________________________|
*/
User Function MnuVazio()
Return {}

/*
______________________________________________________________________________
| Função    | U_CNE01Cmt                                                      |
| Descrição | Intercepta o Commit padrão do MVC. Grava o modelo e, em caso    |
|           | de sucesso, aciona a atualização da flag de bloqueio na SE2.    |
|___________|_________________________________________________________________|
*/
User Function CNE01Cmt(oModel)
    // 1. Executa a gravação padrão do MVC (ZX3, ZX4, ZX5, ZX6)
    Local lRet := FWFormCommit(oModel)
    
    // 2. Se o contrato gravou com sucesso, atualiza o financeiro
    If lRet
        U_AtuSE2Blq(oModel)
    EndIf
    
Return lRet

/*
______________________________________________________________________________
| Função    | U_AtuSE2Blq                                                     |
| Descrição | Varre a SE2 buscando os títulos em aberto atrelados ao contrato |
|           | e replica o campo ZX3_BLOQPAG para o E2_ZZBLQPG.                |
|___________|_________________________________________________________________|
*/
User Function AtuSE2Blq(oModel)
    Local oModelZX3 := oModel:GetModel('ID_M_FLD_ZX3')
    Local cContrato := oModelZX3:GetValue('ZX3_CODIGO')
    Local cBloqPag  := oModelZX3:GetValue('ZX3_BLQPAG')
    Local cAliasSE2 := GetNextAlias()
    Local cQuery    := ""

    // Tratamento de segurança caso o campo venha vazio
    If Empty(cBloqPag)
        cBloqPag := "2" // Assume o padrão "Não"
    EndIf

    // Busca diretamente na SE2 os títulos atrelados ao contrato que já foram gerados e estão em aberto
    cQuery := "SELECT R_E_C_N_O_ AS RECNO_SE2 FROM " + RetSqlName("SE2")
    cQuery += " WHERE E2_ZZCONTR = '" + cContrato + "'"
    cQuery += " AND E2_SALDO > 0"
    cQuery += " AND D_E_L_E_T_ = ' '"
    
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias (cAliasSE2)

    DbSelectArea("SE2")
    While !(cAliasSE2)->(Eof())
        SE2->(DbGoTo((cAliasSE2)->RECNO_SE2))

        // Atualiza a tabela apenas se a flag estiver diferente (evita RecLock desnecessário)
        If SE2->E2_ZZBLQPG != cBloqPag
            RecLock("SE2", .F.)
            SE2->E2_ZZBLQPG := cBloqPag
            SE2->(MsUnlock())
        EndIf

        (cAliasSE2)->(DbSkip())
    EndDo

    (cAliasSE2)->(DbCloseArea())

Return .T.
