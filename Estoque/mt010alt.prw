#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT010ALT ºAutor  ³Luis Felipe Mattos  º Data ³  24/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada disparado na confirmação de alteração do  º±±
±±º          ³ cadastro de produto.  									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Visto que existem unidades de medidas diferentes para as   º±±
±±º          ³ sacas e que o cadastro só pode ter um tipo de conversão    E±±
±±º          ³ por unidade De/Para estaremos armazenando o produto na      ±±
±±º          ³ tabela de Unidades x Fator de Conversão - SJ5               ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EXPORTACAO - EMBARQUE - EE8                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT010ALT()

Local aArea  := GetArea()
                                                 
//If Alltrim(SB1->B1_GRUPO) $ "001/002/003/004/023" // 04/07/16 - Luis Felipe
If !Empty(SB1->B1_SEGUM)
	SJ5->(DbSetOrder(1))
	If !SJ5->(DbSeek(xFilial("SJ5")+SB1->B1_UM+" "+SB1->B1_SEGUM+" "+SB1->B1_COD))
		RecLock("SJ5",.t.)
		SJ5->J5_FILIAL := xFilial("SJ5")
		SJ5->J5_DE     := SB1->B1_UM
		SJ5->J5_PARA   := SB1->B1_SEGUM 
		SJ5->J5_COD_I  := SB1->B1_COD
	Else
		RecLock("SJ5",.f.)
	EndIf
	SJ5->J5_COEF := SB1->B1_CONV
	MsUnlock()
EndIf

RestArea(aArea)

Return