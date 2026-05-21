#INCLUDE "PROTHEUS.CH"

#DEFINE c_ent Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA080CMC ³ Autor ³ Luis Felipe Nascimento³ Data ³ 04.11.13   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ O ponto de entrada FA080CMC sera utilizado na entrada da     ³±±
±±³          ³ funcao, antes de carregar a tela de baixa do contas a pagar. ³±±
±±³          ³ Ponto de entrada criado para indicar se é utilizado leitor   ³±±
±±³          ³ de código de barras.		  								    ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro - Veja FA080POS                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteracao³ Luis Felipe Nascimento                      Data:  26/11/13  ³±±
±±³          ³ Forçar a baixa através da taxa da moeda do dia. Com isso,    ³±±
±±³          ³ o sistema gera a variação cambial, visto que no ato da inclu-³±±
±±³          ³ são do título a taxa era diferente da atual.				    ³±±
±±³          ³ Ver fonte: FA080PE                           			    ³±±
±±³          ³                                              			    ³±±
±±³          ³ Obs.: Criado campo E2_TXMOED2 para voltar a taxa em caso de  ³±±
±±³          ³ cancelamento na tela de confirmação.         			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteracao³ Luis Felipe Nascimento                      Data:  22/05/17  ³±±
±±³          ³ Criada regra para transferir o rateio do titulo principal    ³±±
±±³          ³ para os títulos de imposto.                                  ³±±
±±³          ³ Ver fonte: F080MNAT.prw                       			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA080CMC()

Local _aArea := GetArea()

If Alltrim(SE2->E2_ORIGEM) == "SIGAEFF"
	RecLock("SE2",.F.)
	SE2->E2_ORIGEM := "FINA050"
	MsunLock()
EndIf

If SE2->E2_MOEDA == 2
	If SE2->E2_TXMOED2 <> 0
		RecLock("SE2",.F.)
		SE2->E2_TXMOEDA := SE2->E2_TXMOED2
		MsunLock()
	EndIf
	RecLock("SE2",.F.)
	SE2->E2_TXMOED2 := SE2->E2_TXMOEDA
	SE2->E2_TXMOEDA := RecMoeda(dDatabase,SE2->E2_MOEDA)
	MsunLock()
EndIf

u_fRateio()

RestArea(_aArea)

Return( .f. )

*---------------------*
User Function fRateio()
*---------------------*

Local __aArea := GetArea()
Local cAlias := GetNextAlias()
Local cQry := ""
Local aSEZ := {}
Local lRateio := .f.
Local cTipo := ''
Local cNat := Alltrim(SE2->E2_NATUREZ)

// Replicar Rateio para os impostos
/* 16/06/17 - Luis Felipe
If SE2->E2_FORNECE == '000235' .and.  Alltrim(SE2->E2_NATUREZ) == 'ISS'
	cTipo := 'ISS'
ElseIf SE2->E2_FORNECE == 'UNIAO ' .and.  Alltrim(SE2->E2_NATUREZ) == 'IRF'
	cTipo := 'IRF'
ElseIf SE2->E2_FORNECE == 'UNIAO ' .and.  Alltrim(SE2->E2_NATUREZ) == 'PCC'
	cTipo := 'PCC'
ElseIf SE2->E2_FORNECE == 'INPS  ' .and.  Alltrim(SE2->E2_NATUREZ) == 'INSS'
	cTipo := 'INSS'
EndIf
*/

If cNat == 'ISS'
	cTipo := 'ISS'
ElseIf cNat == 'IRF'
	cTipo := 'IRF'
ElseIf cNat == 'PCC'
	cTipo := 'PCC'
ElseIf cNat == 'INSS'
	cTipo := 'INSS'
EndIf

If !Empty(cTipo)
	cQry := " Select SEZ.R_E_C_N_O_ AS REGISTRO"+c_ent
	cQry += " From SE2010 SE2, SEZ010 SEZ"+c_ent
	cQry += " Where E2_NUM = EZ_NUM"+c_ent
	cQry += " And E2_FORNECE = EZ_CLIFOR"+c_ent
	cQry += " And E2_LOJA = EZ_LOJA"+c_ent
	cQry += " And E2_TIPO = EZ_TIPO"+c_ent
	cQry += " And E2_NATUREZ = EZ_NATUREZ"+c_ent
	cQry += " And E2_MULTNAT = '1'"+c_ent
	cQry += " And E2_NUM = '"+SE2->E2_NUM+"'"+c_ent
	If cTipo == 'ISS'
		cQry += " And E2_ISS = '"+Str(SE2->E2_VALOR,16,2)+"'"+c_ent
	ElseIf cTipo == 'IRF'
		cQry += " And E2_IRRF = '"+Str(SE2->E2_VALOR,16,2)+"'"+c_ent
	ElseIf cTipo == 'PCC'
		cQry += " And E2_COFINS+E2_PIS+E2_CSLL = '"+Str(SE2->E2_VALOR,16,2)+"'"+c_ent
	ElseIf cTipo == 'INSS'
		cQry += " And E2_INSS = '"+Str(SE2->E2_VALOR,16,2)+"'"+c_ent
	EndIf
	cQry += " And EZ_RECPAG = 'P'"+c_ent
	cQry += " And EZ_IDENT = '1'"+c_ent
	cQry += " And SE2.D_e_l_e_t_ =  ''"+c_ent
	cQry += " And SEZ.D_e_l_e_t_ =  ''"+c_ent
	
	MemoWrite("C:\Tmp\F080MNAT.txt",cQry)
	cQry := ChangeQuery(cQry)
	
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),cAlias,.F.,.T.)
	Dbselectarea(cAlias)
	(cAlias)->(DbGoTop())
	
	If !(cAlias)->(Eof())
		
		DbSelectArea("SEZ")
		DbSetOrder(1)
		
		While !(cAlias)->(Eof())
			
			SEZ->(DbGoto((cAlias)->REGISTRO))
			
			If !SEZ->(DbSeek(xFilial("SEZ")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA+E2_NATUREZ)+SEZ->EZ_CCUSTO))
				
				SEZ->(DbGoto((cAlias)->REGISTRO))
				
				For nX:= 1 To FCount()
					Aadd(aSEZ, {fieldname(nX), fieldget(nX)})
				Next
				
				DbSelectArea("SEZ")
				RecLock("SEZ",.T.)
				For i:=1 to Len(aSEZ)
					&(aSEZ[i][1]) :=  aSEZ[i][2]
				Next i
				SEZ->EZ_PREFIXO:= SE2->E2_PREFIXO
				SEZ->EZ_PARCELA:= SE2->E2_PARCELA
				SEZ->EZ_TIPO   := SE2->E2_TIPO
				SEZ->EZ_CLIFOR := SE2->E2_FORNECE
				SEZ->EZ_LOJA   := SE2->E2_LOJA
				SEZ->EZ_NATUREZ:= SE2->E2_NATUREZ
				SEZ->EZ_VALOR  := SE2->E2_VALOR * SEZ->EZ_PERC
				MsunLock()
			EndIf
			
			(cAlias)->(DbSkip())
			
			lRateio := .t.
			
		End
		
		If lRateio
			DbSelectArea("SEV")
			SEV->(DbSetOrder(1))
			If !SEV->(DbSeek(xFilial("SEV")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA+E2_NATUREZ)))
				SEV->(RecLock("SEV",.t.))
				SEV->EV_FILIAL := xFilial("SEV")
				SEV->EV_TIPO   := SE2->E2_TIPO
				SEV->EV_NUM    := SE2->E2_NUM
				SEV->EV_PARCELA:= SE2->E2_PARCELA
				SEV->EV_PREFIXO:= SE2->E2_PREFIXO
				SEV->EV_CLIFOR := SE2->E2_FORNECE
				SEV->EV_LOJA   := SE2->E2_LOJA
				SEV->EV_PERC   := 1
				SEV->EV_VALOR  := SE2->E2_VALOR
				SEV->EV_RECPAG := 'P'
				SEV->EV_RATEICC:= '1'
				SEV->EV_NATUREZ:= SE2->E2_NATUREZ
				SEV->EV_IDENT  := '1'
				SEV->EV_LA	   := 'S'
			EndIf
			SE2->(RecLock("SE2",.f.))
			SE2->E2_RATEIO  := 'N'
			SE2->E2_OCORREN := '01'
			SE2->E2_DESDOBR := 'N'
			SE2->E2_MULTNAT := '1'
			MsunLock()
		EndIf    
		
	EndIf
	
	(cAlias)->(DbClosearea())
	
EndIf

RestArea(__aArea)

Return