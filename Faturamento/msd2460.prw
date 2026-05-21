/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2460   ºAutor  ³Renato Bandeira     º Data ³  26/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada que ira gravar as informacoes do campo     º±±
±±º          ³C6_XCLCL no campo D2_CLVL - Classe de Valor (Navio)         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Faturamento - Especifico para Bauche.                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracoes³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function U_MSD2460()

// Wilbis Paulo 13/01/2026
aArea := GetArea()

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

If Posicione("SB1",1, xFilial("SB1")+SC6->C6_PRODUTO, "B1_XCONTCT") == "2"
	RestArea(aArea)
	Return
EndIf

RestArea(aArea)
// Fim Wilbis Paulo 13/01/2026

// 02/02/16 - Luis Felipe - Forçar posicionamento pois, estão ocorrendo falhas de gravação do nvaio.
If SC6->(C6_NUM+C6_ITEM) <> SD2->(D2_PEDIDO+D2_ITEMPV)
   SC6->(IndexOrd(1))
   SC6->(DbSeek(xFilial("SC6")+SD2->(D2_PEDIDO+D2_ITEMPV)))
EndIf
 
RecLock("SD2",.F.)
//Replace D2_CCUSTO  With SC6->C6_CC
//Replace D2_ITEMCC  With SC6->C6_ITEMC
// Grava a Classe de Valor (Navio)
Replace SD2->D2_CLVL	With SC6->C6_XCLVL
SD2->( MsUnLock())

Return
