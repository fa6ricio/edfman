#Include "Protheus.ch"

/////////////////////////////////////////////////////////////////////////////////////////////////////
// Autor: Rafael Nastri                                                                            //
// Data: 25/03/11                                                                                  //
// Motivo: Ponto de Entrada para Preenchimento de Informações para Criação das TAG´S de Exportação.//
/////////////////////////////////////////////////////////////////////////////////////////////////////

User Function Sf2460i()

Local lRet := .T.

// Wilbis Paulo 12/01/2026
aArea := GetArea()

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))

If Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO, "B1_XCONTCT") == "2"
	RestArea(aArea)
	Return (lRet)
EndIf

RestArea(aArea)
// Fim Wilbis Paulo 12/01/2026

SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))

If SA1->A1_EST == 'EX'

	aArea := GetArea()
	
	RECLOCK("CDL",.T.)
	
	*'YTTALO P MARTINS-INICIO-FILIAL NÃO PODE SER CHUMBADA-----------------------'*
	//CDL->CDL_FILIAL := "01"
	CDL->CDL_FILIAL := xFilial("CDL")
	*'YTTALO P MARTINS-FIM-------------------------------------------------------'*
	
	CDL->CDL_DOC    := SF2->F2_DOC
	CDL->CDL_SERIE  := SF2->F2_SERIE
	CDL->CDL_ESPEC  := SF2->F2_ESPECIE
	CDL->CDL_CLIENT := SF2->F2_CLIENTE
	CDL->CDL_LOJA   := SF2->F2_LOJA
	CDL->CDL_INDDOC := "0"
	CDL->CDL_NATEXP := "0"
	CDL->CDL_UFEMB  := SC5->C5_XUFEMBA
	CDL->CDL_LOCEMB := SC5->C5_XLOCEMB
	CDL->(MsUnlock())
	If MsgYesNo("Nota de Exportação. Complementa-la Agora ??")
		AxCadastro("CDL")
	Else
		lRet := .f.
	EndIf

	*'29/08/17 - Luis Felipe - Inicio -----------------------'*
	SC5->(DBSetOrder(1))
	SC5->(DBSeek(xFilial("SC5")+SD2->D2_PEDIDO))

	cProcesso := Padr(SC5->C5_NAVIO,TamSX3("EE9_PREEMB")[1])

	EE9->(DBSetOrder(2))
	EE9->(DBSeek(xFilial("EE9")+cProcesso+SD2->D2_PEDIDO))

/*  Luis Felipe - 16/04/2020 - release 12.1.25  -inicio
	EE9->(RecLock("EE9",.F.))	
    EE9->EE9_NF := SD2->D2_DOC
    EE9->EE9_SERIE := SD2->D2_SERIE
    EE9->(MsunLock())
/*  Luis Felipe - 16/04/2020 - release 12.1.25  -fim */ 
                                    
	EYY->(DBSetOrder(2))
	EYY->(DBSeek(xFilial("EYY")+SD2->D2_PEDIDO))
	
	While EYY->(!Eof()) .and. EYY->EYY_FILIAL == SD2->D2_FILIAL .and. SD2->D2_PEDIDO == Rtrim(EYY->EYY_PEDIDO)
		If Empty(EYY->EYY_PREEMB)
			EYY->(Reclock("EYY",.f.))
			EYY->EYY_RE 	:= EE9->EE9_RE
			EYY->EYY_PREEMB := EE9->EE9_PREEMB
			EYY->EYY_NFSAI  := SF2->F2_DOC
			EYY->EYY_SERSAI := SF2->F2_SERIE
			EYY->EYY_SEQUEN := '01'
			EYY->EYY_FASE  	:= 'Q'
			EYY->EYY_DTMEX  := SF2->F2_EMISSAO
			EYY->EYY_NROMEX := SF2->F2_DOC
			Msunlock()
		EndIf
		EYY->(DbSkip())
	End
	*'29/08/17 - Luis Felipe - Fim --------------------------'*
	RestArea(aArea)
EndIf      

Return (lRet)

/*
cQuery := " UPDATE "+RetSqlName("EYY")
cQuery += " SET EYY_PREEMB 	= D2_PREEMB,"
cQuery += " EYY_RE 		= EE9_RE,"
cQuery += " EYY_NFSAI 	= D2_DOC,"
cQuery += " EYY_SERSAI 	= D2_SERIE,"
cQuery += " EYY_NROMEX 	= D2_DOC,"
cQuery += " EYY_DTMEX 	= D2_EMISSAO,"
cQuery += " EYY_FASE  	= 'Q',"
cQuery += " EYY_SEQUEN	= '01'"
cQuery += " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("EYY")+" EYY, "+RetSqlName("EE9")+" EE9"
cQuery += " WHERE EYY_FILIAL = D2_FILIAL"
cQuery += " AND EYY_PEDIDO = D2_PEDIDO"
cQuery += " AND EE9_FILIAL = D2_FILIAL"
cQuery += " AND EE9_PEDIDO = D2_PEDIDO"
cQuery += " AND EE9_PREEMB = D2_PREEMB"
cQuery += " AND D2_PEDIDO = '"+SD2->D2_PEDIDO+"'"
cQuery += " AND EYY_PREEMB = ''"
cQuery += " AND SD2.D_E_L_E_T_ = ''"
cQuery += " AND EYY.D_E_L_E_T_ = ''"
cQuery += " AND EE9.D_E_L_E_T_ = ''"
If TCSQLExec( cQuery ) <> 0
UserException("Falha na atualização da tabela EYY - Amarração NF Remessa x NFS Expotação - " + TCSQLError() )
	EndIf
