#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE   c_ent      CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA004   บAutor  ณLeandro Ribeiro     บ Data ณ  11/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar para o usuario quais remessas deverแ  บฑฑ
ฑฑบ          ณ ser devolvida e preenchedo automaticamente o acols,        บฑฑ
ฑฑบ          ณ obedecendo o contrato e a Nota Mใe selecionada.			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function EDFA004()

Local _cEDFA004   := GetArea()
Local _cRet       := .F.
Local _cTela	  := .T.
Local _cTDev      := ""
Local cFornece    := Space(TAMSX3("A2_NOME")[1])//Space(40)
Local cContrato   := Space(TAMSX3("CN9_NUMERO")[1])//Space(15)
Local cNfMae	  := Space(TAMSX3("ZD_NFMAE")[1])//Space(9)
Local cSerie	  := Space(TAMSX3("ZD_SERIEM")[1])//Space(3)
Local cTNFMae     := Space(TAMSX3("ZD_QTDMAE")[1])//Space(11)
Local cTNFRem     := Space(TAMSX3("ZD_QTDMAE")[1])//Space(11)
Local cTReceb     := Space(TAMSX3("ZD_QTDREC")[1])//Space(11)
Local cTDevol     := Space(TAMSX3("ZD_QTDREC")[1])//Space(11)
Local cSldDev	  := Space(TAMSX3("ZD_QTDREC")[1])//Space(11)
Local cSldDevMae  := Space(TAMSX3("ZD_QTDREC")[1])//Space(11)
Local cBuscaRem	  := Space(TAMSX3("F1_DOC")[1])//Space(9)
Local _aTReceb	  := {}
Local _cRetVal	  := {}
Local _cQuery	  := ""
Local _cAliasZD   := GetNextAlias()
Local cFornece	  := SA2->A2_NOME
// 09/10/13 - Luํs Felipe Nascimento - INICIO - Alterado a consulta SF3 de SZD p/ SF1MAE
// Local cContrato	 := SZD->ZD_CONTRA
// Local cNfMae      := SZD->ZD_NFMAE
// Local cSerie      := SZD->ZD_SERIEM
Local cContrato	  := SF1->F1_CONTRA 
Local cNfMae      := SF1->F1_DOC    
Local cSerie      := SF1->F1_SERIE  
// 09/10/13 - Luํs Felipe Nascimento - FIM
Local _cRetVal
Local nOpca
Local oGetd
Local cTNFRem 	  := 0 
Local cTDevol	  := 0

Local _aArea      := {}
Local _aAlias     := {}
Local _aArea2     := {}

Public __cTipoDev := "2" // Onde 1 = Fiscal e 2 - Fisica

Private oList, nList:= 1
Private aItens:={}

Private oOk := LoadBitmap( GetResources(), "CHECKED" )
Private oNo := LoadBitmap( GetResources(), "UNCHECKED" )
Private lChk:= .F.
Private oChk
Private lChk2:= .F.
Private oChk2

CtrlArea(1,@_aArea,@_aAlias,{"SC5"}) // GetArea

_cQuery := " SELECT MAX(ZD_PARC) AS TOTPARC, ZD_NFMAE, ZD_SERIEM,ZD_NFREMES,ZD_SERIER,ZD_CONTRA,ZD_PERIODO,ZD_TOTDEV " + c_ent
_cQuery += " FROM "+ RETSQLNAME("SZD") + " SZD " + c_ent
_cQuery += " WHERE ZD_FILIAL = '"+xFilial("SZD")+"' " + c_ent
_cQuery += " AND ZD_CONTRA = '"+cContrato+"' " + c_ent
_cQuery += " AND ZD_NFMAE = '"+cNfMae+"' " + c_ent
_cQuery += " AND ZD_SERIEM = '"+cSerie+"'" + c_ent
_cQuery += " AND ZD_STATUS <> 'EX' " + c_ent
_cQuery += " AND ZD_CNPJUSI  = '"+SA2->A2_CGC+"'"+c_ent	
_cQuery += " AND D_E_L_E_T_ = ' ' " + c_ent
_cQuery += " GROUP BY ZD_NFMAE, ZD_SERIEM,ZD_NFREMES,ZD_SERIER,ZD_CONTRA,ZD_PERIODO,ZD_TOTDEV "+ c_ent

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasZD,.T.,.T.)

DbSelectArea(_cAliasZD)
(_cAliasZD)->(dbGoTop())
If(!Eof())
	While (!Eof())
		
		_aArea2     := GetArea()
		
		DbSelectArea("SZD")
		SZD->(DbSetOrder(1))
		If SZD->(DbSeek(xFilial("SZD")+(_cAliasZD)->ZD_CONTRA+(_cAliasZD)->ZD_PERIODO+(_cAliasZD)->ZD_NFMAE+(_cAliasZD)->ZD_SERIEM+(_cAliasZD)->ZD_NFREMES+(_cAliasZD)->ZD_SERIER+(_cAliasZD)->TOTPARC))
			
			Aadd(aItens,{.F.,SZD->ZD_NFREMES,SZD->ZD_SERIER,SZD->ZD_QTDNFRE,SZD->ZD_QTDNFRE-SZD->ZD_SALDO,SZD->ZD_SALDO,SZD->ZD_QTDDEV,SZD->ZD_TOTDEV,0 })
			
			cTNFRem += SZD->ZD_QTDNFRE
			cTDevol += SZD->ZD_TOTDEV
			
		EndIf
		
		RestArea(_aArea2)
		
		DbSkip()
	Enddo
Else
	
	_cTela := .F.
	Aviso("Aviso","Nใo Existem Remessas a Devolver",{"OK"})
	
	DbSelectArea(_cAliasZD)
	(_cAliasZD)->(DbCloseArea())
	
	CtrlArea(2,_aArea,_aAlias)
	
	Return()
	
EndIf

If(_cTela)
	
	Define MSDialog oDlg Title "Remessas para Devolu็ใo" From 0,0 To 500,900 Pixel STYLE DS_MODALFRAME    //400,600     355,540 //825
	
	@010,010 Say "Fornecedor"        Pixel Of oDlg
	@017,010 Get cFornece WHEN .F.   Pixel Of oDlg
	
	@030,010 Say "Contrato"          Pixel Of oDlg
	@037,010 Get cContrato WHEN .F.  Pixel Of oDlg
	
	@030,110 Say "NF Mใe"          Pixel Of oDlg
	@037,110 Get cNfMae WHEN .F.   Pixel Of oDlg
	
	@030,175 Say "Serie"          Pixel Of oDlg
	@037,175 Get cSerie WHEN .F.  Pixel Of oDlg
	
	@040,210 Say "Nf Remessa? "          Pixel Of oDlg
	@037,250 Get cBuscaRem   Pixel Of oDlg
	@037,310 BUTTON "Pesquisar"		SIZE 36,12 PIXEL ACTION (xPesqNF(cBuscaRem)) Of oDlg Pixel
	
	@050,010 Say "Remessas"       Pixel Of oDlg
	
	Define Font oFont Name 'Courier New' Size 0, -12
	
	oList := TCBrowse():New(057,010,430,120,,{"",;
	RetTitle("ZD_NFREMES"),;
	RetTitle("ZD_SERIER"),;
	RetTitle("ZD_QTDNFRE"),;
	RetTitle("ZD_QTDREC"),;
	RetTitle("ZD_SALDO"),;
	RetTitle("ZD_QTDDEV"),;
	RetTitle("ZD_TOTDEV"),;
	"Qtd a Devolver"},;
	{20,50,50,50,50,50,50,50,50},oDlg,,,,,{||},,oFont,,,,,.F.,,.T.,,.F.,,, )
	// Seta o vetor a ser utilizado
	oList:SetArray(aItens)
	// Monta a linha a ser exibina no Browse
	
	oList:bLine := {||{ If(aItens[oList:nAt,01],oOK,oNO),;
	aItens[oList:nAt,02],;
	aItens[oList:nAt,03],;
	Alltrim(Transform(aItens[oList:nAT,04],'@E 99,999,999,999.999')),;
	Alltrim(Transform(aItens[oList:nAT,05],'@E 99,999,999,999.999')),;
	Alltrim(Transform(aItens[oList:nAT,06],'@E 99,999,999,999.999')),;
	Alltrim(Transform(aItens[oList:nAt,07],'@E 99,999,999,999.999')),;
	Alltrim(Transform(aItens[oList:nAt,08],'@E 99,999,999,999.999')),;
	Alltrim(Transform(aItens[oList:nAt,09],'@E 99,999,999,999.999')) }}
	
	oList:bLDblClick := {||IIF( lChk==.T.,Alert("Apenas nfs com devolu็ใo fiscal estใo marcadas!") ,(aItens[oList:nAt][1] :=!aItens[oList:nAt][1],;
	oList:DrawSelect(),;
	lEditCell(@aItens,oList,PesqPict("SZD","ZD_QTDREC",TamSx3("ZD_QTDREC")[1],oList:nAt),9),;
	xVldTcBrow()) ) }
	
	@200,010 Say "Total NF Mใe"          Pixel Of oDlg
	@207,010 Get Transform(cTNFMae,"@E 999,999,999.999")	 WHEN .F.   Pixel Of oDlg
	
	@200,110 Say "Total das Remessas"    Pixel Of oDlg
	@207,110 Get Transform(cTNFRem,"@E 999,999,999.999")	 WHEN .F.   Pixel Of oDlg
	
	@200,210 Say "Total Template"       Pixel Of oDlg
	@207,210 Get Transform(cTReceb,"@E 999,999,999.999")	 WHEN .F.   Pixel Of oDlg
	
	@200,310 Say "Total Devolvido"       Pixel Of oDlg
	@207,310 Get Transform(cTDevol,"@E 999,999,999.999")	 WHEN .F.   Pixel Of oDlg
	
	@220,010 Say "Saldo a Devolver s/ Mใe"      Pixel Of oDlg
	@227,010 Get Transform(cSldDevMae,"@E 999,999,999.999") 	 WHEN .F.   Pixel Of oDlg
	
	@220,110 Say "Sld Fiscal a Dev. s/ Remessas"      Pixel Of oDlg
	@227,110 Get Transform(cSldDev,"@E 999,999,999.999") 	 WHEN .F.   Pixel Of oDlg
	
	@180,010 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca Devolu็ใo Fiscal" SIZE 120,007 PIXEL OF oDlg ;
	ON CLICK(xMarkDevol(),oList:Refresh())
	
	@235,320 BUTTON "&Ok"		SIZE 36,12 PIXEL ACTION (oDlg:End(),EDFA004A(cContrato,cSldDev)) Of oDlg Pixel
	@235,360 BUTTON "&Cancelar"	SIZE 36,12 PIXEL ACTION (oDlg:End()) Of oDlg Pixel
	
	_aTReceb :=  EDFA004C(cContrato,cNfMae,cSerie)
	_cRetVal :=  EDFA004B(cContrato,cNfMae,cSerie)
	
	If Len(_cRetVal) > 0 .AND. Len(_aTReceb) > 0
		cTNFMae	:= _cRetVal[1][1]
		cTReceb	:= _aTReceb[1][1]
		cSldDev := cTNFRem - cTReceb
		cSldDevMae := cTNFMae-(cTNFRem-cTDevol)
	EndIf
	
	ACTIVATE MSDIALOG oDlg CENTER
	
EndIf

DbSelectArea(_cAliasZD)
(_cAliasZD)->(DbCloseArea())

CtrlArea(2,_aArea,_aAlias) // RestArea

Return(GetdRefresh())

***********************************************************************************************************************************************
Static Function xVldTcBrow()

If aItens[oList:nAt][9] > 0
	
	If aItens[oList:nAt][9] >  aItens[oList:nAt][5]
		Alert("Qtd a devolver ้ maior que "+RetTitle("ZD_QTDREC")+" da NF Remessa!")
		aItens[oList:nAt][9] := 0
		
	EndIf
	
	oList:bLine := {||{ If(aItens[oList:nAt,01],oOK,oNO),;
	aItens[oList:nAt,02],;
	aItens[oList:nAt,03],;
	Alltrim(Transform(aItens[oList:nAT,04],'@E 99,999,999,999.99')),;
	Alltrim(Transform(aItens[oList:nAT,05],'@E 99,999,999,999.99')),;
	Alltrim(Transform(aItens[oList:nAT,06],'@E 99,999,999,999.99')),;
	Alltrim(Transform(aItens[oList:nAt,07],'@E 99,999,999,999.99')),;
	Alltrim(Transform(aItens[oList:nAt,08],'@E 99,999,999,999.99')),;
	Alltrim(Transform(aItens[oList:nAt,09],'@E 99,999,999,999.99')) }}
	
EndIf

Return

***********************************************************************************************************************************************
Static Function xMarkDevol()

Local ni    := 1
Local xlRet := .T.
Local xlMarc:= .F.

For ni := 1 To Len(aItens)
	If aItens[ni][6] > 0
		If aItens[ni][9] > 0
			xlRet := .F.
		EndIf
	EndIf
Next ni

If xlRet == .F. .AND. lChk == .T.
	Aviso("Aviso","A ED&F MAN realiza devolu็๕es aos seus fornecedores de duas formas: Devolu็ใo Fiscal, ajuste das quantidades nใo recebidas sobre NF Remessa x Template, o que estแ previsto para acontecer ao final do processo, quando a Usina informa que nใo existem mais NFดs de Remessa para entragar sobre a NF Mใe e a Devolu็ใo Fํsica, quando o produto recebido sofre alguma avaria. Como as transa็๕es sใo classificadas por TES diferentes, nใo ้ permitido juntar as mesmas.",{"OK"})
	lChk := .F.
	oChk:Refresh()
	Return
EndIf

For ni := 1 To Len(aItens)
	If aItens[ni][6] > 0
		aItens[ni][1] :=IIF(lChk == .T.,.T.,.F.)
		xlMarc:= .T.
	EndIf
Next ni

If xlMarc == .F.
	Aviso("Aviso"," A ED&F MAN realiza devolu็๕es aos seus fornecedores de duas formas: Devolu็ใo Fiscal, ajuste das quantidades nใo recebidas sobre NF Remessa x Template, o que estแ previsto para acontecer ao final do processo, quando a Usina informa que nใo existem mais NFดs de Remessa para entragar sobre a NF Mใe e a Devolu็ใo Fํsica, quando o produto recebido sofre alguma avaria. Como as transa็๕es sใo classificadas por TES diferentes, nใo ้ permitido juntar as mesmas.",{"OK"})
	lChk := .F.
	oChk:Refresh()
EndIf

oList:bLine := {||{ If(aItens[oList:nAt,01],oOK,oNO),;
aItens[oList:nAt,02],;
aItens[oList:nAt,03],;
Alltrim(Transform(aItens[oList:nAT,04],'@E 99,999,999,999.99')),;
Alltrim(Transform(aItens[oList:nAT,05],'@E 99,999,999,999.99')),;
Alltrim(Transform(aItens[oList:nAT,06],'@E 99,999,999,999.99')),;
Alltrim(Transform(aItens[oList:nAt,07],'@E 99,999,999,999.99')),;
Alltrim(Transform(aItens[oList:nAt,08],'@E 99,999,999,999.99')),;
Alltrim(Transform(aItens[oList:nAt,09],'@E 99,999,999,999.99')) }}

If xlMarc
	__cTipoDev := "1"
EndIf

Return
***********************************************************************************************************************************************
Static Function xPesqNF(cBuscaRem)

Local ni := 1

For ni := 1 To Len(aItens)
	
	If aItens[ni][2] == cBuscaRem
		oList:nAT := ni
		
		oList:bLine := {||{ If(aItens[oList:nAt,01],oOK,oNO),;
		aItens[oList:nAt,02],;
		aItens[oList:nAt,03],;
		Alltrim(Transform(aItens[oList:nAT,04],'@E 99,999,999,999.99')),;
		Alltrim(Transform(aItens[oList:nAT,05],'@E 99,999,999,999.99')),;
		Alltrim(Transform(aItens[oList:nAT,06],'@E 99,999,999,999.99')),;
		Alltrim(Transform(aItens[oList:nAt,07],'@E 99,999,999,999.99')),;
		Alltrim(Transform(aItens[oList:nAt,08],'@E 99,999,999,999.99')),;
		Alltrim(Transform(aItens[oList:nAt,09],'@E 99,999,999,999.99')) }}
		
		Exit
	EndIf
	
Next ni

Return()
***********************************************************************************************************************************************
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA004A  บAutor  ณLeandro Ribeiro     บ Data ณ  07/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para o preenchimento do acols.	                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EDFA004A(_Contra,nSaldo)

Local _cEDFA004A := GetArea()
Local __cCont	 := 1
Local ni         := 1
Local cProxItem  := aCols[Len(aCols),aScan(aHeader,{|x| AllTrim(x[2]) = "C6_ITEM"})]

Local nPosIt    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_ITEM"})
Local nPosProd  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})
Local nPosUnid  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_UM"})
Local nPosQTDV  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDVEN"})
Local nPosPrcv  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})
Local nPosPrcu  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRUNIT"})
Local nPosVal   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_VALOR"})
Local nPosQTDL  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDLIB"})
Local nPosLocal := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_LOCAL"})
Local nPosTES   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_TES"})
Local nPosNori  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_NFORI"})
Local nPosSeOr  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_SERIORI"})
Local nPosItem  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_ITEMORI"})
Local nPosClas  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_CLASFIS"})
Local nPosDesc  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_DESCRI"})
Local cXTESFIS  := GetMV("MV_XTESFIS")
Local cXTESDEV  := GetMV("MV_XTESDEV")

If nSaldo == 0 .and. lChk
	Aviso("Aviso","Nใo existe mais saldo a devolver sobre as Notas Fiscais dessa NF Mใe pois, jแ foi realizado ajuste Fiscal da mesma !",{"Voltar"})
	Return()
EndIf

For ni := 1 To Len(aItens)
	
	If aItens[ni,1] == .t.
		
		dbselectarea("SD1")
		SD1->(DbSetOrder(1))
		If SD1->(DbSeek(xFilial("SD1")+aItens[ni,2]+aItens[ni,3]+M->C5_CLIENTE+M->C5_LOJACLI) )
			
			dbselectarea("SF4")
			SF4->(DbSetOrder(1))
			If SF4->(DbSeek(xFilial("SF4")+ IIF(lchk == .T.,cXTESFIS,cXTESDEV )))
				
				dbselectarea("SB1")
				SB1->(DbSetOrder(1))
				If SB1->(DbSeek(xFilial("SB1")+ SD1->D1_COD))
					
					If (Len(aCols) > 1 .AND. !EMPTY(aCols[Len(aCols)][nPosProd])) .OR. (Len(aCols) == 1 .AND. !EMPTY(aCols[1][nPosProd]))
						
						cProxItem := aCols[Len(aCols)][nPosIt]
						cProxItem := Soma1(cProxItem)
						
						aadd(aCols,Array(Len(aHeader)+1))
						
						For nX := 1 To Len(aHeader)
							If aHeader[nX][2] == "C6_ALI_WT"
								aCols[Len(aCols)][nX] := ""
								
							ElseIf aHeader[nX][2] == "C6_REC_WT"
								aCols[Len(aCols)][nX] := 0
								
							Else
								aCols[Len(aCols)][nX] := CriaVar(aHeader[nX][2])
							EndIf
						Next nX
						
						aCols[Len(aCols)][Len(aHeader)+1] := .F.
						
						aCols[Len(aCols)][nPosIt]                                   := cProxItem
						aCols[Len(aCols)][nPosProd]                                 := SD1->D1_COD
						aCols[Len(aCols)][nPosTES ]                                 := IIF(lchk == .T.,cXTESFIS,cXTESDEV )
						//aCols[Len(aCols)][nPosClas]                                 := Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
						aCols[Len(aCols)][nPosDesc]                                 := SB1->B1_DESC
						aCols[Len(aCols)][nPosQTDV]                                 := IIF(aItens[ni,9]>0,aItens[ni,9],aItens[ni,6] )
						aCols[Len(aCols)][nPosPrcv]                                  := SD1->D1_VUNIT
						aCols[Len(aCols)][nPosPrcu]                                  := SD1->D1_VUNIT
						aCols[Len(aCols)][nPosQTDL]                                 := aCols[Len(aCols)][nPosQTDV]
						aCols[Len(aCols)][nPosVal]                                  := ROUND( (aCols[Len(aCols)][nPosPrcv] * aCols[Len(aCols)][nPosQTDV]) ,2)
						aCols[Len(aCols)][nPosUnid]                                 := SB1->B1_UM
						aCols[Len(aCols)][nPosLocal]                                := SD1->D1_LOCAL
						aCols[Len(aCols)][nPosNori]                                 := SD1->D1_DOC
						aCols[Len(aCols)][nPosSeOr]                                 := SD1->D1_SERIE
						aCols[Len(aCols)][nPosItem]                                 := SD1->D1_ITEM
						
					Else
						
						aCols[Len(aCols)][nPosIt]                                   := cProxItem
						aCols[Len(aCols)][nPosProd]                                 := SD1->D1_COD
						aCols[Len(aCols)][nPosTES ]                                 := IIF(lchk == .T.,cXTESFIS,cXTESDEV )
						//aCols[Len(aCols)][nPosClas]                                 := Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB
						aCols[Len(aCols)][nPosDesc]                                 := SB1->B1_DESC
						aCols[Len(aCols)][nPosQTDV]                                 := IIF(aItens[ni,9]>0,aItens[ni,9],aItens[ni,6] )
						aCols[Len(aCols)][nPosPrcv]                                  := SD1->D1_VUNIT
						aCols[Len(aCols)][nPosPrcu]                                  := SD1->D1_VUNIT
						aCols[Len(aCols)][nPosQTDL]                                 := aCols[Len(aCols)][nPosQTDV]
						aCols[Len(aCols)][nPosVal]                                  := ROUND( (aCols[Len(aCols)][nPosPrcv] * aCols[Len(aCols)][nPosQTDV]) ,2)
						aCols[Len(aCols)][nPosUnid]                                 := SB1->B1_UM
						aCols[Len(aCols)][nPosLocal]                                := SD1->D1_LOCAL
						aCols[Len(aCols)][nPosNori]                                 := SD1->D1_DOC
						aCols[Len(aCols)][nPosSeOr]                                 := SD1->D1_SERIE
						aCols[Len(aCols)][nPosItem]                                 := SD1->D1_ITEM
						
					EndIf
					
					//ALERT("ITEM: "+cProxItem)
					A410ReCalc(.T.)
					//				GetDRefresh()//atualiza acols // 12/08/13 - Luis Felipe - Tirei pois estava travando
					
				EndIf
				
			EndIf
			
		EndIf
	EndIf
	
Next ni

RestArea(_cEDFA004A)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA004B  บAutor  Leandro Ribeiro      บ Data ณ  07/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar os valores para o preenchimento da    บฑฑ
ฑฑบ          ณ tela informativa.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EDFA004B(__Contra,__NumNF,__Serie)

Local _cEDFA004B := GetArea()
Local _cAliasD   := GetNextAlias()
Local _cQuery1 	 := ""
Local _cValor	 := {}

_cQuery1 := " SELECT MAX(ZD_PARC),ZD_NFMAE,ZD_SERIEM,ZD_QTDMAE, SUM(ZD_SALDO) AS SALDO" + c_ent
_cQuery1 += " FROM "+ RETSQLNAME("SZD") + " SZD " + c_ent
_cQuery1 += " WHERE ZD_FILIAL = '"+xFilial("SZD")+"' " + c_ent
_cQuery1 += " AND ZD_CONTRA = '"+__Contra+"' " + c_ent
_cQuery1 += " AND ZD_NFMAE = '"+__NumNF+"' " + c_ent
_cQuery1 += " AND ZD_SERIEM = '"+__Serie+"'" + c_ent
_cQuery1 += " AND ZD_STATUS <> 'EX' " + c_ent
_cQuery1 += " AND ZD_CNPJUSI  = '"+SA2->A2_CGC+"'"+c_ent
_cQuery1 += " AND D_E_L_E_T_ = ' ' " + c_ent
_cQuery1 += " GROUP BY ZD_NFMAE,ZD_SERIEM,ZD_QTDMAE"

_cQuery1 := ChangeQuery(_cQuery1)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAliasD,.T.,.T.)

DbSelectArea(_cAliasD)
If(!Eof())
	While (!Eof())
		Aadd(_cValor,{(_cAliasD)->ZD_QTDMAE,(_cAliasD)->SALDO})
		DbSkip()
	Enddo
EndIf

DbCloseArea()

RestArea(_cEDFA004B)

Return(_cValor)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CtrlArea บ Autor ณRicardo Mansano     บ Data ณ 18/05/2005  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ mansano@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Static Function auxiliar no GetArea e ResArea retornando   บฑฑ
ฑฑบ          ณ o ponteiro nos Aliases descritos na chamada da Funcao.     บฑฑ
ฑฑบ          ณ Exemplo:                                                   บฑฑ
ฑฑบ          ณ Local _aArea  := {} // Array que contera o GetArea         บฑฑ
ฑฑบ          ณ Local _aAlias := {} // Array que contera o                 บฑฑ
ฑฑบ          ณ                     // Alias(), IndexOrd(), Recno()        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ // Chama a Funcao como GetArea                             บฑฑ
ฑฑบ          ณ P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"})         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ // Chama a Funcao como RestArea                            บฑฑ
ฑฑบ          ณ P_CtrlArea(2,_aArea,_aAlias)                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ nTipo   = 1=GetArea / 2=RestArea                           บฑฑ
ฑฑบ          ณ _aArea  = Array passado por referencia que contera GetArea บฑฑ
ฑฑบ          ณ _aAlias = Array passado por referencia que contera         บฑฑ
ฑฑบ          ณ           {Alias(), IndexOrd(), Recno()}                   บฑฑ
ฑฑบ          ณ _aArqs  = Array com Aliases que se deseja Salvar o GetArea บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Generica.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)
Local _nN
// Tipo 1 = GetArea()
If _nTipo == 1
	_aArea   := GetArea()
	For _nN  := 1 To Len(_aArqs)
		DbSelectArea(_aArqs[_nN])
		AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})
	Next
	// Tipo 2 = RestArea()
Else
	For _nN := 1 To Len(_aAlias)
		DbSelectArea(_aAlias[_nN,1])
		DbSetOrder(_aAlias[_nN,2])
		DbGoto(_aAlias[_nN,3])
	Next
	RestArea(_aArea)
Endif
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA004B  บAutor  Luis Felipe Nascim.  บ Data ณ  08/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar os valores para o preenchimento da    บฑฑ
ฑฑบ          ณ tela informativa.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-----------------------------------------------------------------------------------------------*
* Busca o total recebido pelas NFs Remessa de um mesmo Contrato + Perํodo + Mae                 *
*-----------------------------------------------------------------------------------------------*

Static Function EDFA004C(cContra,cNfMae,cSerie)

Local cQuery := ""
Local cAlias := GetNextAlias()
Local aValor := {}

cQuery := " SELECT ZD_NFMAE,ZD_SERIEM,Sum(ZD_QTDREC) As ZD_QTDREC"+c_ent
cQuery += " FROM " + RetSqlName("SZD")+" SZD "+c_ent
cQuery += " WHERE ZD_FILIAL = '"+xFilial("SZD")+"'"+c_ent
cQuery += " AND ZD_CONTRA   = '"+cContra+"'"+c_ent
cQuery += " AND ZD_NFMAE    = '"+cNfMae+"'"+c_ent
cQuery += " AND ZD_SERIEM   = '"+cSerie+"'"+c_ent
cQuery += " AND ZD_STATUS <> 'EX' " + c_ent
cQuery += " AND ZD_CNPJUSI  = '"+SA2->A2_CGC+"'"+c_ent	
cQuery += " AND D_E_L_E_T_  = ' '"+c_ent
cQuery += " GROUP BY ZD_NFMAE,ZD_SERIEM "

If Select(cAlias) > 0
	DbselectArea(cAlias)
	(cAlias)->(DbCloseArea())
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)

Aadd(aValor,{(cAlias)->ZD_QTDREC})

(cAlias)->(DbCloseArea())

Return( aValor )
