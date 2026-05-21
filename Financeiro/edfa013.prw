#include 'TOPCONN.CH'
#include 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA013  ºAutor  ³Yttalo P Martins    º Data ³  01/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Rotina utilizada para retornar taxa do dólar do dia no lança±±
±±º          ³ mento padrão                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA013()

Local _aArea := GetArea()
Local nTxUSD := 0
Local nRegSF1:= SF1->(Recno())
Local nRegSD1:= SD1->(Recno())

If Alltrim(FunName()) != "EFFEX400"

	DBSELECTAREA("SM2")
	DBSETORDER(1)
	/* // 21/08/18 - Luis Felipe - inicio
	IF DBSEEK(dtoS(dDatabase))
		nTxUSD := SM2->M2_MOEDA2
	ENDIF
	*/
	If Alltrim(FunName()) == "EECAE100"
		SM2->(DBSEEK(dtoS(EEC->EEC_DTEMBA)))
	ElseIf Alltrim(FunName()) == "MATA103" .and. SD1->D1_TIPO $ "C/D" // Complementar de Preco e Devolução de Venda
		If SD1->D1_TIPO == "D" 
			SD2->(DbSetOrder(3))
			If SD2->(DbSeek(xFilial("SD2")+SD1->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEMORI)))
				SM2->(DBSEEK(dtoS(SD2->D2_EMISSAO)))
			EndIf	
		Else 
			SF1->(DbSetOrder(1))
			If SF1->(DbSeek(xFilial("SF1")+SD1->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA)))
				SC7->(DbSetOrder(1))
				If SC7->(DbSeek(xFilial("SC7")+SF1->F1_XPEDIDO))
					nTxUSD := SC7->C7_TAXAUSD
				EndIf	
			EndIf	
		EndIf	
	Else 
		SM2->(DBSEEK(dtoS(dDatabase)))
	EndIf	

	If Found() .and. nTxUSD == 0.0 
		nTxUSD := SM2->M2_MOEDA2
	EndIf	
	// 21/08/18 - Luis Felipe - fim
	
Else
	
	nTxUSD := EF1->EF1_TX_MOE
	
Endif

SF1->(DBGoto(nRegSF1))
SD1->(DBGoto(nRegSD1))

RestArea(_aArea)

Return(nTxUSD)