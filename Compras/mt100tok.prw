#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT100TOK ºAutor  ³ Luis Felipe Nasc.  º Data ³  24/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esse Ponto de Entrada é chamado 2 vezes dentro da rotina    ±±
±±º          ³ A103Tudok(). Para o controle do número de vezes em que ele é±±
±±º          ³ chamado foi criada a variável lógica lMT100TOK, que quando  ±±
±±º          ³ for definida como (.F.) o ponto de entrada será chamado     ±±
±±º          ³ somente uma vez.											   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³ Validar a obrigatoriedade do preenchimento das Informações º±±
±±º          ³ de Controle Intercompany. 				                   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³ Luis Felipe Nascimento                  º Data ³ 29/05/17  º±±
±±º          ³ Tratamento para a TES 149.				                   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100TOK()

	Local lRet  := .t.
	Local aArea := GetArea()
	Local cProd := TamSx3("B1_COD")[1]

	// Evaldo: 21/11/2014
	Local nBaseDup	:= Mafisret( , "NF_BASEDUP")
	Local nValIrrf	:= Mafisret( , "NF_VALIRR")
	Local cNaturez  := ALLTRIM(Mafisret( , "NF_NATUREZA"))
	//
	if Len(aCols) > 0 .and. !empty(GdFieldGet("D1_COD",1))
		For nx:=1 to Len(aCols)
			cTES  	:= GdFieldGet("D1_TES",nx)
			cPedido	:= GdFieldGet("D1_PEDIDO",nx)
			cProd 	:= GdFieldGet("D1_COD",nx)
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+cProd))
			If SB1->B1_XDESP == 'S'
				If !Empty(GdFieldGet("D1_CLVL",nx))
					If Empty(GdFieldGet("D1_XCONTRI",nx))
						If Alltrim(GdFieldGet("D1_CLVL",nx)) == "INTERCO"
							cTexto := "Favor preencher os campos 'Contrato' , 'Navio' e ' Observ.' para o(s) iten(s) quando a classe de valor informada for INTERCO. Do contrário, não será possível confirmar a inclusão desta NF."
						Else
							cTexto := "Favor preencher os campos 'Contrato' e ' Observ.' para o(s) iten(s) quando a classe de valor não for INTERCO. Do contrário, não será possível confirmar a inclusão desta NF."
						EndIf
						lRet := .f.
						Exit
					EndIf
					If lRet .and. Alltrim(GdFieldGet("D1_CLVL",nx)) == "INTERCO" .and. Empty(GdFieldGet("D1_XNAVIOI",nx)) .or. Empty(GdFieldGet("D1_XOBS",nx))
						cTexto := "Favor preencher os campos 'Navio' e 'Observ.' para o(s) iten(s) quando a classe de valor informada for INTERCO. Do contrário, não será possível confirmar a inclusão desta NF."
						lRet := .f.
						Exit
					EndIf
					If lRet .and. Alltrim(GdFieldGet("D1_CLVL",nx)) <> "INTERCO" .and. Empty(GdFieldGet("D1_XOBS",nx))
						cTexto := "Favor preencher o campo 'Observ.' para o(s) iten(s) quando a classe de valor não for INTERCO. Do contrário, não será possível confirmar a inclusão desta NF."
						lRet := .f.
						Exit
					EndIf
				Else
					cTexto := "Favor preencher os campos 'Cod Cl Val' , 'Contrato' , 'Navio' e ' Observ.' para o(s) iten(s) quando a classe de valor informada for INTERCO e 'Cod Cl Val' , 'Contrato' e ' Observ.' quando não for. Do contrário, não será possível confirmar a inclusão desta NF."
					lRet := .f.
					Exit
				EndIf
			EndIf
			If cTES == '149' .and. lRet
				SF1->(Reclock("SF1",.F.))
				SF1->F1_XPEDIDO := cPedido
				Msunlock()
			EndIf
		Next

		If !lRet
			Aviso("Validação Intercompany (MT100TOK)",cTexto,{"Voltar"})
		EndIf

		// Evaldo: 21/11/2014
		If lRet
			// Validar o preenchimento da Natureza e do código de retenção do IR quando houver imposto
			If ! AllTrim( FunName() ) $ "MATA910|MATA920|EDFA001"	// Não validar quando se for inclusão NF Entrada ou Saida MANUAL pelo Livro Fiscal

				If nBaseDup <> 0       // Se NF não gera financeiro, não faz crítica
					if empty(cNaturez)
						Aviso("Natureza","Natureza Não informada, favor informar",{"OK"})
						lRet := .F.
					endif

					If lRet .and. nValIrrf > 0 .and. cDirf == "2"
						Aviso("Dirf","Duplicata com Valor de IRRF, preencher o campo Gerar Dirf",{"OK"})
						lRet := .F.
					EndIf

					If lRet .and. nValIrrf > 0 .and. Empty(cCodRet)
						Aviso("Cod. de Retenção","Duplicata com Valor de IRRF, preencher campo Cod. de Retenção",{"OK"})
						lRet := .F.
					EndIf
				EndIf
			Endif
		Endif
	endif
	lMT100TOK := .f.

	RestArea(aArea)

Return( lRet )
