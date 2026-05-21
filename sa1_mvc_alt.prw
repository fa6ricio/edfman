#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

USER Function SA1_MVC(xRotAuto,nOpcAuto)

Local oMBrowse

/*
If xRotAuto == Nil
	
	DEFINE FWMBROWSE oMBrowse ALIAS "SA1" DESCRIPTION "Cadastro de Clientes"
	
	ACTIVATE FWMBROWSE oMBrowse
	
Else
*/	
	aRotina := MenuDef()
	
	FWMVCRotAuto(ModelDef(),"SA1",nOpcAuto,{{"MATA030_SA1",xRotAuto}})
	
//Endif

Return

//-------------------------------------------------------------------// Menu Funcional//-------------------------------------------------------------------

Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.SA1_MVC" OPERATION MODEL_OPERATION_VIEW 	ACCESS 0
ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.SA1_MVC" OPERATION MODEL_OPERATION_INSERT ACCESS 0
ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.SA1_MVC" OPERATION MODEL_OPERATION_UPDATE ACCESS 143
ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.SA1_MVC" OPERATION MODEL_OPERATION_DELETE ACCESS 144

Return aRotina

//-------------------------------------------------------------------// ModelDef - Modelo de dados do Cadastro de Clientes//-------------------------------------------------------------------

Static Function Modeldef()

Local oModel    := Nil
Local oStruCN9	:= FWFormStruct(1,'CN9')
Local oStruCNC	:= FWFormStruct(1,'CNC')    
Local bPreVldCN9:= {|oModel,cAction,cField,xValue| CN300CN9Pre(oModel,cAction,cField,xValue)}

//-----------------------------------------//Monta o modelo do formulário//-----------------------------------------

oModel:= MPFormModel():New("MATA030",/*Pre-Validacao*/, /*Pos-Validacao*/, /*Commit*/,/*Cancel*/)
oModel:AddFields('CN9MASTER',/*cOwner*/,oStruCN9,'bPreVldCN9',/*bPosValid*/,/*Carga*/)
oModel:AddGrid('CNCDETAIL','CN9MASTER',oStruCNC,{|oModel,nLine,cAction,cField,xValue,xOldValue| CN300VldFor(cAction,cField,xValue,xOldValue)})

Return(oModel)

//-------------------------------------------------------------------// ViewDef - Visualizador de dados do Cadastro de Clientes//-------------------------------------------------------------------

Static Function ViewDef()

Local oViewLocal

oModel := FWLoadModel("SA1_MVC")
oView := FWFormView():New()
oView:SetModel(oModel)

//View do contrato
oView:AddField( "CN9MASTER" , FWFormStruct(2,"CN9"))
oView:AddGrid('CNCDETAIL',oStruCNC,'CNCDETAIL')

//oView:CreateHorizontalBox("ALL",100)

//-- Cria as 2 divisoes da interface
oView:CreateHorizontalBox('SUPERIOR',30)
oView:CreateHorizontalBox('INFERIOR',70)

//-- Cria a pasta e planilhas da Manutencao de Contratos
oView:CreateFolder('FLDCNT','INFERIOR')
oView:AddSheet('FLDCNT','GRDFORN','Fornecedores') //"Fornecedores"

oView:CreateHorizontalBox('FORN' ,100,/*owner*/,/*lUsePixel*/,'FLDCNT','GRDFORN')

oView:SetOwnerView("XXX_SA1","ALL")

Return oView

//-------------------------------------------------------------------// MYTESTSA1 - Teste para rotina automatica usando MSEXECAUTO//-------------------------------------------------------------------

User Function MYTESTSA1()

Local oModel := Nil
Local nX := 0

RpcSetEnv("01","01")

dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial())

FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Inicio: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

oModel := FWLoadModel("SA1_MVC")

For nX := 50 To 51
	
	oModel:SetOperation(MODEL_OPERATION_INSERT)
	oModel:Activate()
	oModel:SetValue("XXX_SA1","A1_COD",StrZero(nX,6))
	oModel:SetValue("XXX_SA1","A1_LOJA","01")
	oModel:SetValue("XXX_SA1","A1_TIPO","R")
	oModel:SetValue("XXX_SA1","A1_NOME","TOTVS S/A")
	oModel:SetValue("XXX_SA1","A1_NREDUZ","TOTVS")
	oModel:SetValue("XXX_SA1","A1_END","AV. BRAZ LEME, 1631")
	oModel:SetValue("XXX_SA1","A1_BAIRRO","SANTANA")
	oModel:SetValue("XXX_SA1","A1_MUN","SAO PAULO")
	oModel:SetValue("XXX_SA1","A1_EST","SP")
	oModel:SetValue("XXX_SA1","A1_COD_MUN","50308")
	oModel:SetValue("XXX_SA1","A1_CEP","02511000")
	oModel:SetValue("XXX_SA1","A1_PESSOA","F")
	
	If oModel:VldData()
		oModel:CommitData()
	Else
		VarInfo("",oModel:GetErrorMessage())
	EndIf
	
	oModel:DeActivate()
	
Next nX

FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Fim Inclusão: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Inicio Alteração: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

SA1->(MsSeek(xFilial("SA1")+"000050",.T.)) // pesquisa o cliente 000050 para alterá-lo

FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Time Ini: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

oModel:SetOperation(MODEL_OPERATION_UPDATE)
oModel:Activate()
oModel:SetValue("XXX_SA1","A1_NOME","TESTE")

If oModel:VldData()
	FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Time Commit: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
	oModel:CommitData()
Else
	VarInfo("",oModel:GetErrorMessage())
EndIf

oModel:DeActivate()

FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Fim Alteração: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Inicio Exclusão: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

SA1->(MsSeek(xFilial("SA1")+"000051",.T.)) // pesquisa o cliente 000051 para excluí-lo

FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Time Ini: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

oModel:SetOperation(MODEL_OPERATION_DELETE)

oModel:Activate()
FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Time Commit: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
oModel:CommitData()
oModel:DeActivate()

FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Fim Exclusão: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Inicio: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/) // inclui 2 registros pela rotina do padrão

MyMata030()

FWLogMsg("INFO", /*cTransactionId*/, /* */, /*cCategory*/, /*cStep*/, /*cMsgId*/, " >>>> Fim: " + Time() + " <<<<", /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

RpcClearEnv()

Return

Static Function MyMata030()

Local aCabec    := {}
Local cCodCli   := ""
Local nXPRIVATE
Local nx

lMsErroAuto := .F.

cCodCli := Soma1("000051")

For nX := 1 To 2
	
	aCabec := {}
	
	aadd(aCabec,{"A1_COD"   ,cCodCli,})
	aadd(aCabec,{"A1_LOJA","01",})
	aadd(aCabec,{"A1_TIPO","R",})
	aadd(aCabec,{"A1_NOME","TOTVS S/A",})
	aadd(aCabec,{"A1_NREDUZ","TOTVS",})
	aadd(aCabec,{"A1_END","AV. BRAZ LEME, 1631",})
	aadd(aCabec,{"A1_BAIRRO","SANTANA",})
	aadd(aCabec,{"A1_MUN","SAO PAULO",})
	aadd(aCabec,{"A1_EST","SP",})
	aadd(aCabec,{"A1_COD_MUN","50308",})
	aadd(aCabec,{"A1_CEP","02511000",})
	aadd(aCabec,{"A1_PESSOA","F",})
	
	MATA030(aCabec,3)
	
	cCodCli := Soma1(cCodCli)
Next

nXReturn(.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} CN300CN9Pre
Rotina para tratamento no pre valid do Modelo CN9

@param nLine	Linha atual
@param cAction	Acao do usuario
@param cCampo	Campo em memoria
@param xValue	Valor em memoria

@author Flavio Lopes Rasta
@since 17/08/2015
@version 12
/*/
//-------------------------------------------------------------------
/*
Static Function CN300CN9Pre(oModel,cAction,cCampo,xValue)
Local lRet		:= .T.
Local oModelCN9 := Nil

Default oModel 	:= FwModelActive()

oModelCN9 := oModel:GetModel("CN9MASTER")

If cAction == 'UNDELETE' .Or. cAction == 'SETVALUE'
	If cCampo == "CN9_FLGREJ"
		CN300VRCt("CN9",xValue)
	EndIf
Endif

Return lRet
*/

//-------------------------------------------------------------------
/*{Protheus.doc} CN300VldFor
Rotina para validacao dos fornecedores do Contrato

@author Leandro.Moura
@since 23/09/2013
@version P11.90
*/
//-------------------------------------------------------------------
Static Function CN300VldFor(cAction,cField,xValue,xOldValue)
Local cCodigo	:= ""
Local cLoja		:= ""
Local lRet	   	:= .T.
Local nPlan		:= 0
Local oModel	:= FWModelActive()
Local oModelCN9	:= oModel:GetModel("CN9MASTER")
Local oModelCNA := oModel:GetModel("CNADETAIL")
Local oModelCNC	:= oModel:GetModel("CNCDETAIL")
Local oModelCN8	:= oModel:GetModel("CN8DETAIL")
Local aSaveLines:= FWSaveRows()
Local cCpoCodi	:= If(oModelCN9:GetValue("CN9_ESPCTR")=="1","CNA_FORNEC","CNA_CLIENT")
Local cCpoLoja	:= If(oModelCN9:GetValue("CN9_ESPCTR")=="1","CNA_LJFORN","CNA_LOJACL")
Local cCpoCodCNC:= If(oModelCN9:GetValue("CN9_ESPCTR")=="1","CNC_CODIGO","CNC_CLIENT")
Local cCpoLojCNC:= If(oModelCN9:GetValue("CN9_ESPCTR")=="1","CNC_LOJA","CNC_LOJACL")
Local cCpoCodCN8:= If(oModelCN9:GetValue("CN9_ESPCTR")=="1","CN8_FORNEC","CN8_CLIENT")
Local cCpoLojCN8:= If(oModelCN9:GetValue("CN9_ESPCTR")=="1","CN8_LOJA","CN8_LOJACL")
Local cCodValue	:= IIF(cField == cCpoCodCNC,xOldValue,oModelCNC:GetValue(cCpoCodCNC))
Local cLojValue	:= IIF(cField == cCpoLojCNC,xOldValue,oModelCNC:GetValue(cCpoLojCNC))

If cAction == "DELETE"
	cCodigo := oModelCNC:GetValue(If(oModelCN9:GetValue("CN9_ESPCTR") == "1","CNC_CODIGO","CNC_CLIENT"))
	cLoja := oModelCNC:GetValue(If(oModelCN9:GetValue("CN9_ESPCTR") == "1","CNC_LOJA","CNC_LOJACL"))

	//-- Verifica se pode deletar o fornecedor
	If !Empty(cCodigo) .And. ! Empty(cLoja)
		For nPlan := 1 to oModelCNA:Length()
			oModelCNA:GoLine(nPlan)
			If MTFindMVC(oModelCNA,{{cCpoCodi,cCodigo},{cCpoLoja,cLoja}}) > 0 .And.; //-- Usado em planilha
			 			MTFindMVC(oModelCNC,{{cCpoCodCNC,cCodigo},{cCpoLojCNC,cLoja}}) == oModelCNC:GetLine()
	   			Help(" ",1,If(oModelCN9:GetValue("CN9_ESPCTR")=="1","CNTA300FRN","CNTA300CLI")) //-- O # nao pode ser deletado pois pertence a uma planilha.
		   		lRet := .F.
		   		Exit
			EndIf
		Next nPlan
		For nPlan := 1 to oModelCN8:Length()
			oModelCN8:GoLine(nPlan)
			If MTFindMVC(oModelCN8,{{cCpoCodCN8,cCodigo},{cCpoLojCN8,cLoja}}) > 0 // Usado na caução
		   		Help(" ",1,"CNTA300CAU") //-- "O Fornecedor/Cliente não pode ser alterado, pois, existe uma caução relacionada. Realize as correções no Cadastro de Cauções"
		   		lRet := .F.
		   		Exit
			EndIf
		Next nPlan
	EndIf
EndIf

//Verifica se existe caução para o fornecedor e não permite a troca
If cAction == 'SETVALUE' .And. !Empty(xOldValue) .And. cField == cCpoCodCNC .Or. cField == cCpoLojCNC
	If MTFindMVC(oModelCN8,{{cCpoCodCN8,cCodValue},{cCpoLojCN8,cLojValue}}) > 0
		Help(" ",1,"CNTA300CAU") //-- "O Fornecedor/Cliente não pode ser alterado, pois, existe uma caução relacionada. Realize as correções no Cadastro de Cauções"
	   	lRet := .F.
	EndIf
EndIf

If cAction == 'CANSETVALUE' .And. !Empty(xOldValue) .And. (cField == cCpoCodCNC .Or. cField == cCpoLojCNC)
	If cField == cCpoCodCNC
		cCodigo := xOldValue
		cLoja := oModelCNC:GetValue(If(oModelCN9:GetValue("CN9_ESPCTR") == "1","CNC_LOJA","CNC_LOJACL"))
	Else
		cCodigo := oModelCNC:GetValue(If(oModelCN9:GetValue("CN9_ESPCTR") == "1","CNC_CODIGO","CNC_CLIENT"))
		cLoja	:= xOldValue
	EndIf

	//-- Verifica se pode alterar o fornecedor/cliente
	For nPlan := 1 to oModelCNA:Length()
		oModelCNA:GoLine(nPlan)
		If 	MTFindMVC(oModelCNA,{{cCpoCodi,cCodigo},{cCpoLoja,cLoja}}) > 0 .And.;
			MTFindMVC(oModelCNC,{{cCpoCodCNC,cCodigo},{cCpoLojCNC,cLoja}}) == oModelCNC:GetLine()
			If oModelCN9:GetValue("CN9_ESPCTR") == "1"
				Alert(OemtoAnsi('STR0137')+OemtoAnsi('STR0139'))  // AQUI
			Else
				Alert(OemtoAnsi('STR0138')+OemtoAnsi('STR0139'))
			EndIf
		   	lRet := .F.
		   	Exit
		EndIf
	Next nPlan
EndIf


FWRestRows(aSaveLines)
Return lRet
