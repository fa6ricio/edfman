#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA070CHK ³ Autor ³ Luis Felipe Nascimento³ Data ³ 27.11.13   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ O ponto de entrada FA070CHK sera executado na entrada da     ³±±
±±³          ³ funcao antes de carregar a tela de baixa do contas a receber.³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Financeiro                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteracao³ Luis Felipe Nascimento                      Data:  27/11/13  ³±±
±±³          ³ Forçar a baixa através da taxa da moeda do dia. Com isso,    ³±±
±±³          ³ o sistema gera a variação cambial, visto que no ato da inclu-³±±
±±³          ³ são do título a taxa era diferente da atual.				    ³±±
±±³          ³ Ver fonte: SACI008                              			    ³±±
±±³          ³                                              			    ³±±
±±³          ³ Obs.: Criado campo E1_TXMOED2 para voltar a taxa em caso de  ³±±
±±³          ³ cancelamento na tela de confirmação.         			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      

User Function FA070CHK()

If SE1->E1_MOEDA == 2
	If SE1->E1_TXMOED2 <> 0
		RecLock("SE1",.F.)
		SE1->E1_TXMOEDA := SE1->E1_TXMOED2
		MsunLock()
	EndIf
	RecLock("SE1",.F.)
	SE1->E1_TXMOED2 := SE1->E1_TXMOEDA
	SE1->E1_TXMOEDA := RecMoeda(dDatabase,SE1->E1_MOEDA)
	MsunLock()
EndIf

Return( .t. )