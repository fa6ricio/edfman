
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1140I   ºAutor  ³Milton Nishimoto    º Data ³  08/14/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ POnto de Entrada para atualizar o campo customizado        º±±
±±º          ³ F1_XNOMFOR com o nome do fornecedor.                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bauche - Facri                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF1140I

Local cCodForn	:= SF1->F1_FORNECE
Local cCodLoj	:= SF1->F1_LOJA

If Reclock("SF1",.F.)
	SF1->F1_XNOMFOR		:= Posicione("SA2",1,xFilial("SA2")+cCodForn+cCodLoj,"A2_NOME")
	MsUnlock()
EndIf

*'Yttalo P Martins-INICIO-------------------------------------------------------------------'*
//Atualiza tabela SZD(tabela retaguarda)

If !l140Auto .AND. EMPTY(SF1->F1_NFMAE)
	SD1->(DbSetOrder(1))  
	SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE))
	SB1->(DbSeeK(xFilial("SB1")+SD1->D1_COD))
	
	If Alltrim(SB1->B1_GRUPO) $ "001/002/003/004"
		lResp := Aviso("Rotina Especifica SF1140I","Essa NF faz referência a produtos comercializados pela ED&F MAN. Você gostaria de amarrar esta NF a um Contrato ?",{"Não","Sim"}) 
		If lResp == 1
			Return
		EndIf  
	Else	
		Return
	EndIf
	u_xAtuNF_SZD(.f.) // U_EDFA010()
EndIF
*'Yttalo p Martins-FIM----------------------------------------------------------------------'*

Return