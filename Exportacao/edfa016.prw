#Include "rwmake.ch"
#Include "topconn.ch"
#include "protheus.ch"

#DEFINE xDECIMAL 4

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA016   ºAutor  ³YTTALO P MARTINS    º Data ³  16/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA PARA ALTERAÇÃO DO PEDIDO DE EXPORTAÇÃO REALIZADO NA  º±±
±±º          ³INTEGRAÇÃO COM FATURAMENTO DEVIDO A DIFERENÇA ENTRE UNIDADE E±±
±±º          ³PREÇO ENTRE EXPORTAÇÃOE  FATURAMENTO                         ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EECFAT2                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA016()

Local cNrFatIt := "  "
Local cCF      := ""
Local cTES     := ""
Local cAutoDel := "N"

Local i    := 0
Local nInd := 0
Local nPos := 0
Local aStrSC6 := SC6->(dbStruct())
Local aStrEE8 := EE8->(dbStruct())

//Local nQtdVen      := 0  // Nopado por GFP - 01/02/13
Local nValorFob    := 0
Local nDesconto    := 0
Local nPorcento    := 0
Local nDecDesc     := AvSx3("D2_DESCON",xDECIMAL)
Local nDecPrc      := AvSx3("D2_PRCVEN",xDECIMAL)
Local nPosDesconto := 0
Local nTotDesc     := 0
Local nSldAtu      := 0

Local dEntrega
Local lSegUnMed := .F.   // GFP - 03/10/2012

Local cProduto := WorkIt->EE8_COD_I
Local nQuant   := WorkIt->EE8_SLDINI
Local nItemGr  := 0

Begin Sequence

IF SB1->(dbSeek(xFilial()+AvKey(cProduto,"B1_COD")))
	
	//WFS 27/05/2010
//	lSegUnMed:= If(AllTrim(WorkIt->EE8_UNIDAD) == AllTrim(SB1->B1_SEGUM), .T., .F.)
	lSegUnMed:= If(AllTrim(WorkIt->EE8_UNIDAD) <> AllTrim(SB1->B1_UM), .T., .F.) // 17/02/14 - Luis Felipe Nascimento

	
	IF ! SB2->(dbSeek(xFilial()+SB1->B1_COD+SB1->B1_LOCPAD))
		CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
	Endif
Endif

///////////////////////////////////////////////////
//Cálculo do saldo do item para grade de produtos//
///////////////////////////////////////////////////
If lGrade
	If nOpc == 3
		nSldAtu := nQuant
	Else
		EE8->(DbSetOrder(1)) //EE8_FILIAL + EE8_PEDIDO + EE8_SEQUEN + EE8_COD_I
		If EE8->(DbSeek(xFilial("EE8")+M->EE7_PEDIDO+WorkIt->EE8_SEQUEN+AvKey(cProduto,"EE8_COD_I")))
			If nQuant <> EE8->EE8_SLDINI
				If EE8->EE8_SLDINI == EE8->EE8_SLDATU
					nSldAtu := nQuant
				Else
					If nQuant > EE8->EE8_SLDINI
						nSldAtu := EE8->EE8_SLDATU + nQuant
					Else
						nSldAtu := EE8->EE8_SLDATU - nQuant
					EndIf
				EndIf
			Else
				nSldAtu := EE8->EE8_SLDATU
			EndIf
		Else
			nSldAtu := nQuant
		EndIf
	EndIf
Else
	nSldAtu := WorkIt->EE8_SLDATU
EndIf

aReg := {}

cNrFatIt := If(Empty(WorkIt->EE8_FATIT),cItem,WorkIt->EE8_FATIT)

aAdd(aReg,{"C6_NUM",aCab[1,2],nil}) // Código do Pedido de Venda
aAdd(aReg,{"C6_ITEM",cNrFatIt,nil}) // Item sequencial

nQtdVen    := WORKIT->EE8_SLDINI
cUnidade   := WorkIt->EE8_UNIDAD
nPrcUniMed := WorkIt->EE8_PRECOI
nSaldo     := WorkIt->EE8_SLDATU
//cSegum     := WorkIt->EE8_UNPRC

//WFS 27/05/2010
//Conversão da segunda unidade de medida, conforme o cadastro do produto.
//Sempre será enviada a quantidade e o valor conforme a primeira unidade de medida.
If lSegUnMed
	
	aAdd(aReg,{"C6_UNSVEN",nQtdVen,nil}) //DFS - 22/09/2011 - Inclusão de tratamento para segunda unidade de medida quando o PE for alterado	
	Fat2SegUnidade(@cUnidade, @nQtdVen, @nPrcUniMed, @nSaldo)
EndIf

nQuant:= nQtdVen
/*
RMD - 04/05/08
Quando possuir Commodity, geralmente o pedido é gerado sem possuir um preço inicial, que será definido
pela RV. Desta forma, é enviado o preço 0.01 para que o faturamento aceite o item sem preço.
*/
If (nPrcUniMed == 0) .And. EECFlags("COMMODITY")
	nPrcUniMed := 0.01
EndIf

aAdd(aReg,{"C6_PRODUTO",cProduto,nil}) // Cod.Item
aAdd(aReg,{"C6_UM",cUnidade,nil}) // Unidade
//aAdd(aReg,{"C6_SEGUM",cSegum,nil}) // cSegum // 17/02/14 - Luis Felipe Nascimento

aAdd(aReg,{"C6_QTDVEN",nQuant,nil}) // Quantidade

aAdd(aReg,{"C6_PRCVEN",nPrcUniMed,nil}) // Preco Unit.
aAdd(aReg,{"C6_PRUNIT",nPrcUniMed,nil}) // Preco Unit.

If lConvUnid
	nValorFOB := ROUND((AvTransUnid(WorkIt->EE8_UNIDAD, WorkIt->EE8_UNPRC, WorkIt->EE8_COD_I,;
	nQuant,.F.)*WorkIt->EE8_PRECOI),AvSx3("EE8_PRCINC",xDECIMAL))
	nValorInc := ROUND((AvTransUnid(WorkIt->EE8_UNIDAD, WorkIt->EE8_UNPRC, WorkIt->EE8_COD_I,;
	nQuant,.F.)*WorkIt->EE8_PRECO),AvSx3("EE8_PRCTOT",xDECIMAL))
Else
	nValorFOB     := Round(WorkIt->(nQuant*EE8_PRECOI),AvSx3("EE8_PRCINC",xDECIMAL))
	nValorInc     := Round(WorkIt->(nQuant*EE8_PRECO),AvSx3("EE8_PRCTOT",xDECIMAL))
EndIf
//Acb - 08/11/2010 - Caso o parêmetro esteja ligado não é rateado o desconto no itens e somente no total do processo.
If !GetMv("MV_AVG0085",,.F.)
	nDesconto := 0
	
	If nDescAtu <> 0 //JPM - só corrige qdo há desconto.
		
		nPorcento := Round(nValorInc/nTotItens, 8)
		nDesconto := Round((nPorcento * nDescAtu), 8)
		nDesconto := Round(nDesconto/nQtdVen,nDecPrc)
		
		nDesconto := Round(nDesconto*nQtdVen,nDecDesc)
	EndIf
	
	//FJH 07/02/06 - Adaptação desconto por item
	If GetMV("MV_AVG0119",,.F.) .and. EE8->(FieldPos("EE8_DESCON")) > 0
		aAdd(aReg,{"C6_VALDESC", WorkIt->EE8_DESCON, nil})
	Else
		aAdd(aReg,{"C6_VALDESC",nDesconto , nil}) // Percentual de desconto por item.
	Endif
Endif

nPosDesconto := aScan(aReg,{|x| x[1] = "C6_VALDESC"})
IF nPosDesconto > 0
	nTotDesc += aReg[nPosDesconto, 2]
Endif

cTES := "501"
IF Type("WorkIt->EE8_TES") == "C"
	cTES := WorkIt->EE8_TES
Endif
aAdd(aReg,{"C6_TES",cTES,nil}) // Tipo de Saida

cCF := "663"
IF Type("WorkIt->EE8_CF") == "C"
	cCF := WorkIt->EE8_CF
Endif
aAdd(aReg,{"C6_CF",cCF,nil})  // Classificacao Fiscal

aAdd(aReg,{"C6_LOCAL",SB1->B1_LOCPAD,nil})  // Almoxarifado

dEntrega := WorkIt->EE8_DTENTR

IF Empty(dEntrega)
	dEntrega := WorkIt->EE8_DTPREM
Endif

aAdd(aReg,{"C6_ENTREG",dEntrega,nil})  // Dt.Entrega

aAdd(aReg,{"C6_DESCRI",SB1->B1_DESC,nil})

If lGrade
	If nItemGr > 0
		aAdd(aReg,{"C6_GRADE"  ,"S",nil})
		aAdd(aReg,{"C6_ITEMGRD",StrZero(nItemGr,AVSX3("C6_ITEMGRD",AV_TAMANHO)),nil})
	Else
		aAdd(aReg,{"C6_GRADE"  ,"N",nil})
		aAdd(aReg,{"C6_ITEMGRD",nil,nil})
	EndIf
EndIf

/*
Verifica os Campos do EE8 que possuem a mesma terminação de nome dos campos
do SC6, caso encontre e o campo estja preenchido, adiciona esses campos no
array para serem gravados no SC6. */

For nInd := 1 TO Len(aStrSC6)
	cCampo := aStrSC6[nInd][1]
	If aScan(aReg,{|x| x[1] == cCampo }) == 0 .And. !("FILIAL"$cCampo)
		cCpoComum := SubStr(cCampo,4)
		cCpoEE8   := Left("EE8_" + cCpoComum,10)
		If ( nPos := aScan(aStrEE8,{|x| x[1] = cCpoEE8 }) ) > 0
			If aStrEE8[nPos][2] = aStrSC6[nInd][2] .And.;
				aStrEE8[nPos][3] = aStrSC6[nInd][3] .And.;
				aStrEE8[nPos][4] = aStrSC6[nInd][4]
				//DFS - 08/04/2011 - Tratamento para quando alterar o valor no Embarque, transmita ao Faturamento
				If WorkIt->(FieldPos(cCpoEE8)) > 0 .And. !Empty(WorkIt->(FieldGet(FieldPos(cCpoEE8))))
					If (nPos:= AScan(aReg, {|x| x[1] == AllTrim(cCampo)})) > 0
						aReg[nPos][2]:= WorkIt->(FieldGet(FieldPos(cCpoEE8)))
					Else
						aAdd(aReg, {cCampo, WorkIt->(FieldGet(FieldPos(cCpoEE8))), Nil})
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Next


//ER - 29/04/2008 - Posiciona no Item do Pedido de Venda não perder informações já gravadas.
If nOpc == 4
	SC6->(DbSetOrder(1))
	If SC6->(DbSeek(xFilial("SC6")+AvKey(aCab[1,2],"C6_NUM")+AvKey(aReg[2,2],"C6_ITEM")))
		//////////////////////////////////////////////////////////////////////////////////////////
		//Verifica se os campos do array aSC6NaoAlt estão preenchidos no Pedido de Venda.       //
		//Em Caso Positivo grava o seu valor no array aReg para que as informações desses campos//
		//não sejam alteradas no Pedido de Venda.                                               //
		//////////////////////////////////////////////////////////////////////////////////////////
		
		//DFS - 05/02/11 - Adicionado tratamento para filtrar os campos que não estão no array e adicioná-los para não haver perda de informações ao alterar um Ped. Export
		For i:=1 To Len(aSC6NaoAlt)
			If !Empty(SC6->&(aSC6NaoAlt[i]))
				cCampo:= aSC6NaoAlt[i]
				If AScan(aReg, {|x| x[1] == AllTrim(cCampo)}) == 0
					aAdd(aReg,{cCampo,SC6->&(aSC6NaoAlt[i]),nil})
				EndIf
			EndIf
		Next
	EndIf
EndIf

//aAdd(aReg,{"AUTDELETA","N",nil}) nopado por WFS
AAdd(aReg, {"AUTDELETA", cAutoDel, Nil})

End Sequence

RETURN() 

**************************************************************************************************************

Static Function Fat2SegUnidade(cUnidade, nQuantidade, nPreco, nSaldo)
Default cUnidade:= ""
Default nQuantidade:= 0,;
        nPreco     := 0,;
        nSaldo     := 0

Begin Sequence

   If SB1->B1_CONV == 0
      Break
   EndIf

   cUnidade  := SB1->B1_UM

   //Será realizado a operação inversa para a conversão da quantidade
   //If !(SB1->B1_TIPCONV == "M")  // GFP - 29/11/2012
   If (SB1->B1_TIPCONV == "M")
      nQuantidade:= nQuantidade / SB1->B1_CONV
      nSaldo     := nSaldo / SB1->B1_CONV
      If SB1->B1_UM <> If(Select("WorkIt")> 0, WorkIt->EE8_UNPRC, WorkIp->EE9_UNPRC)   //TRP - 12/12/2011 - Considerar a WorkIp quando fluxo alternativo.        
         nPreco     := Round(nPreco * SB1->B1_CONV, AvSx3("C6_PRCVEN", xDECIMAL))
      EndIf
   Else
      nQuantidade:= nQuantidade * SB1->B1_CONV
      nSaldo     := nSaldo * SB1->B1_CONV
      If SB1->B1_UM <> If(Select("WorkIt")> 0, WorkIt->EE8_UNPRC, WorkIp->EE9_UNPRC)      
         nPreco     := Round(nPreco / SB1->B1_CONV, AvSx3("C6_PRCVEN", xDECIMAL))
      EndIf   
   EndIf

End Sequence
Return Nil
