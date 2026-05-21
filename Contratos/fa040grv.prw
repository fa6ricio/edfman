#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA040GRV  º Autor ³ Luiz Fernando      º Data ³  15/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige o numero do titulo da invoice no contas a receb    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
****************************
User Function FA040GRV()
****************************
Public cInvoSE1 := ""

IF Alltrim(FunName()) == "EECAE100"
	
	cInvoSE1 := Posicione("EXP",1,xFilial("EXP")+EEC->EEC_PREEMB,"EXP_NRINVO")
	
	lInvo := EXP->(DbSeek(xFilial("EXP")+EEC->EEC_PREEMB))

	If lInvo .and. PROCNAME(9) <> 'XFINANSE1' // 16/08/18 - Luis Felipe
		SM2->(DbSeek(DtoS(EEC->EEC_DTEMBA))) // 09/02/17 - Luis Felipe
		RecLock("SE1",.F.)
			//SE1->E1_TIPO := IIF(linvo,"INV",SE1->E1_TIPO)
			SE1->E1_NUM     := IIF(linvo,cInvoSE1,SE1->E1_NUM)
			// 09/02/17 - Luis Felipe - Inicio
//			SE1->E1_TXMOEDA := SE1->E1_XDOLAR // Luiz 05/08/2015  
//			SE1->E1_VLCRUZ  := SE1->E1_VALOR * SE1->E1_XDOLAR
			SE1->E1_XDOLAR  := SM2->M2_MOEDA2
			SE1->E1_VLCRUZ  := SE1->E1_VALOR * SM2->M2_MOEDA2
			// 09/02/17 - Luis Felipe - Fim
		SE1->(MsUnlock())
	Endif
	
Endif   

Return

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o valor na moeda escolhida na data da ultima variacao   ³
//³ ou na data de emissao (caso nao tenha sofrido ainda nenhuma     ³
//³ variacao.                                                       ³
//³ Calcula o valor na moeda escolhida para a database.             ³
//³ Subtrai um valor do outro para apurar a variacao.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Caso seja a primeira apuracao de variacao monetaria
If Empty(SE2->E2_TXMOEDA) .and. Empty(SE2->E2_DTVARIA) .and. STR(SE2->E2_SALDO,17,2) == STR(SE2->E2_VALOR,17,2)
	nValor1 := SE2->E2_VLCRUZ
Else
	If(SE2->(FieldPos("E2_TXMDCOR")>0 ) .And. !Empty(SE2->E2_TXMDCOR))
		nValor1 := xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,Iif(Empty(SE2->E2_DTVARIA),SE2->E2_EMISSAO,SE2->E2_DTVARIA),TamSX3("E2_TXMDCOR")[2],SE2->E2_TXMDCOR)
	Else
		nValor1 := xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,Iif(Empty(SE2->E2_DTVARIA),SE2->E2_EMISSAO,SE2->E2_DTVARIA),TamSX3("E2_TXMDCOR")[2],Iif(Empty(SE2->E2_DTVARIA),SE2->E2_TXMOEDA,0))
	EndIf
Endif

nValorM  :=    xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,dDataBase,TamSX3("E2_TXMDCOR")[2],nTxCompra)

If lF350CM2
	VALOR += Execblock("F350CM2",.F.,.F.)
Else
	VALOR += (nValorM - nValor1)
Endif

// O resultado disso será gravado no E1_XHVMNRP




Return