#INCLUDE "rwmake.ch"
#include "protheus.ch"
#INCLUDE 'TOPConn.ch'

#DEFINE c_ent Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF1100I   º Autor ³ Luis Felipe Nascim.º Data ³  11/03/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Ponto    ³ Ponto de entrada utilizado apos a gravação da SF1       	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo: ³  Informar a PTAX da Nota Fiscal Complementar antes da con- º±±
±±º          ³  tabilização.            	                              º±±
±±º          ³  Fontes: MT103FIM, MT100AG e SF1100I					      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³  Luis Felipe Mattos Nascimento                  03/10/2016 º±±
±±º          ³  Registro da quantidade devolvida ao Embarque.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³  Luis Felipe Mattos Nascimento                  17/04/2017 º±±
±±º          ³  Rateio por Centro de Custo.                               º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF1100I

Local __aArea := GetArea()
Local cQry	  := ""
Local cAlias  := GetNextAlias()
Local cChave  := ''
Local lDifPc  := .T.
 
Public __cRateio := SD1->D1_RATEIO // Rateio pelos itens ? // 08/05/17 - Luis Felipe

SF1->(DbSetOrder(1))
SF1->(dbSeek(xFilial("SF1") + cNFiscal + cSerie + cA100For + cLoja ) )

IF alltrim(FUNNAME()) <> "CLSPRENF"
	SA2->( dbSetOrder( 1 ) )
	SA2->( DbSeek( xFilial( "SA2" ) + cA100For + cLoja  ) )
	xnomfor:=SA2->A2_NOME
	
	SF1->(RecLock("SF1",.F.))
	SF1->F1_XNOMFOR := Posicione("SA2",1,xFilial("SA2")+cA100For + cLoja,"A2_NOME")
	Msunlock()
	
	// 11/03/14 - Luis Felipe Nascimento
	If __cTES $ "003/004/023" .and. (Inclui .or. Altera) // 13/06/18 - Luis Felipe
		SF1->F1_CONTRA  := __cContra
		SF1->F1_XPERIOD := __cPeriodo
		SF1->F1_XPEDIDO := __cPedido
		SF1->F1_NFMAE	:= ""
/*	ElseIf __cTES == "031" .and. Inclui
		SD1->(DbSetOrder(1))
		SD1->(dbSeek(xFilial("SD1") + cNFiscal + cSerie + cA100For + cLoja ) )
		nD1_QTSEGUM := SD1->D1_QTSEGUM
		_nReg := fEmbarque()
		EE9->(DbGoto(_nReg))
		EE9->(Reclock("EE9",.F.))
		EE9->EE9_XQTDEV += nD1_QTSEGUM
		EE9->EE9_XVRDEV += nD1_QTSEGUM * EE9->EE9_PRECO
		EE9->(MsUnlock("EE9"))
*/
	EndIf
	
	// 17/04/17 - Luis Felipe - Inicio
	// Replicação do rateio de Compras x Financeiro
	SDE->(DbSetOrder(1))
	If SDE->(dbSeek(xFilial("SDE") + cNFiscal + cSerie + cA100For + cLoja ) )
		
		nReg := SDE->(Recno())
		
		cQry := " Select E2_NUM, E2_PREFIXO, E2_PARCELA, E2_TIPO, E2_NATUREZ"+c_ent
		cQry += " From "+RetSqlName("SE2") + " SE2, "+ RetSqlName("SF1")+ " SF1"+c_ent
		cQry += " Where F1_DOC = E2_NUM"+c_ent
		cQry += " And F1_SERIE = E2_PREFIXO"+c_ent
		cQry += " And F1_FORNECE = E2_FORNECE"+c_ent
		cQry += " And F1_LOJA = E2_LOJA"+c_ent
		cQry += " And F1_DOC = '"+cNFiscal+"'"+c_ent
		cQry += " And F1_FORNECE = '"+cA100For+"'"+c_ent
		cQry += " And F1_LOJA = '"+cLoja+"'"+c_ent
		cQry += " And F1_SERIE = '"+cSerie+"'"+c_ent
		cQry += " And SE2.D_E_L_E_T_ = ''"+c_ent
		cQry += " And SF1.D_E_L_E_T_ = ''"+c_ent
		
		MemoWrite("C:\Tmp\SF1100I.txt",cQry)
		cQry := ChangeQuery(cQry)
		
		DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),cAlias,.F.,.T.)
		dbselectarea(cAlias)
		(cAlias)->(DbGoTop())
		
		// Valor total do titulo a ser rateado
		
		If (cAlias)->(!Eof())
			SEV->(RecLock("SEV",.t.))
			SEV->EV_FILIAL := SDE->DE_FILIAL
			SEV->EV_TIPO   := SE2->E2_TIPO
			SEV->EV_NUM    := SDE->DE_DOC
			SEV->EV_PARCELA:= SE2->E2_PARCELA
			SEV->EV_PREFIXO:= SDE->DE_SERIE
			SEV->EV_CLIFOR := SDE->DE_FORNECE
			SEV->EV_LOJA   := SDE->DE_LOJA
			SEV->EV_PERC   := 1
			SEV->EV_VALOR  := SF1->F1_VALBRUT
			SEV->EV_RECPAG := 'P'
			SEV->EV_RATEICC:= '1'
			SEV->EV_NATUREZ:= SE2->E2_NATUREZ
			SEV->EV_IDENT  := '1'
			SEV->EV_LA	   := 'S'
		EndIf
		
		// Rateio por parcela
		
		While (cAlias)->(!Eof())
			DbSelectarea("SDE")
			Go nReg
			cChave := cNFiscal+cSerie+cA100For+cLoja
			
			SE2->(DbSetOrder(1))
			If SE2->(dbSeek(xFilial("SE2") + cSerie + cNFiscal + (cAlias)->E2_PARCELA + (cAlias)->E2_TIPO + cA100For + cLoja ))
				SE2->(RecLock("SE2",.f.))
				SE2->E2_RATEIO  := 'N'
				SE2->E2_OCORREN := '01'
				SE2->E2_DESDOBR := 'N'
				SE2->E2_MULTNAT := '1'
				MsUnlock()
				While !SDE->(Eof()) .and. SDE->(DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA) ==  cChave
					SEZ->(RecLock("SEZ",.t.))
					SEZ->EZ_FILIAL := SDE->DE_FILIAL
					SEZ->EZ_TIPO   := SE2->E2_TIPO
					SEZ->EZ_NUM    := SDE->DE_DOC
					SEZ->EZ_PARCELA:= SE2->E2_PARCELA
					SEZ->EZ_PREFIXO:= SDE->DE_SERIE
					SEZ->EZ_CLIFOR := SDE->DE_FORNECE
					SEZ->EZ_LOJA   := SDE->DE_LOJA
					SEZ->EZ_PERC   := SDE->DE_CUSTO1 / SF1->F1_VALBRUT //     SDE->DE_PERC / 100
					SEZ->EZ_CCUSTO := SDE->DE_CC
					SEZ->EZ_ITEMCTA:= SDE->DE_ITEMCTA
					SEZ->EZ_CLVL   := SDE->DE_CLVL
					SEZ->EZ_VALOR  := SDE->DE_CUSTO1 
					SEZ->EZ_RECPAG := 'P'
					SEZ->EZ_CONTA  := SDE->DE_CONTA
					SEZ->EZ_XCONTA := SDE->DE_XCONTA
					SEZ->EZ_XCC    := SDE->DE_XCC
					SEZ->EZ_NATUREZ:= SE2->E2_NATUREZ
					SEZ->EZ_IDENT  := '1'
					SEZ->EZ_LA	   := 'S'
					MsUnlock()
					SDE->(DBSkip())
				End
			EndIf
			(cAlias)->(DbSkip())
		End
		(cAlias)->(DbCloseArea())
	EndIf
	// 17/04/17 - Luis Felipe - Inicio
	
Endif 

// 02/06/17 - Luis Felipe - Inicio
// Criticar casos em que o preço da Nota Fiscal for diferente do Pedido de Compras
lDifPc := Type("_cDifPCxNFE") <> "U"

If Alltrim(SF1->F1_ESPECIE) == 'SPED' 
	SD1->(DbSetOrder(1))
	If SD1->(dbSeek(xFilial("SD1") + cNFiscal + cSerie + cA100For + cLoja ) )
		While cNFiscal + cSerie + cA100For + cLoja == SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) .and. !SD1->(Eof())
			SC7->(DbSetOrder(1))
			If SC7->(DbSeek(xFilial("SC7") + SF1->F1_XPEDIDO ) )
				SB1->(DbSetOrder(1))
				If SB1->(dbSeek(xFilial("SB1") + SD1->D1_COD ) )
					nDifer := Round((SC7->C7_VLFINAL * SB1->B1_CONV) * SC7->C7_TAXAUSD,2) - SD1->D1_VUNIT
					If nDifer > 0.01 .or. nDifer < -0.01
						If lDifPc
							_cDifPCxNFE := "Atenção: Existe diferença de R$ "+Str(nDifer,11,2)+" entre o preço unitário do documento de entrada "+SF1->F1_DOC+" e o preço do Pedido de Compras "+SC7->C7_NUM+" !"
						Else
							Alert("Atenção: Existe diferença de R$ "+Str(nDifer,11,2)+" entre o preço unitário do documento de entrada "+SF1->F1_DOC+" e o preço do Pedido de Compras "+SC7->C7_NUM+" !")							
						EndIf
					EndIf
				EndIf
			EndIf
			SD1->(DbSkip())
		End
	EndIf
EndIf
// 02/06/17 - Luis Felipe - Fim

RestArea(__aArea)

Return

*-------------------------*
Static Function fEmbarque()
*-------------------------*

Local _cQuery := ""
Local _cAlias := GetNextAlias()
Local _nReg   := 0

_cQuery := " SELECT DISTINCT EE9.R_E_C_N_O_ As REGISTRO "+c_ent
_cQuery += " FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SD2")+" SD2, "+RetSqlName("EE9")+" EE9 "+c_ent
_cQuery += " WHERE D2_DOC 	= '"+SD1->D1_NFORI+"'"+c_ent
_cQuery += " AND D2_SERIE 	= '"+SD1->D1_SERIORI+"'"+c_ent
_cQuery += " AND D2_CLIENTE = '"+SD1->D1_FORNECE+"'"+c_ent
_cQuery += " AND D2_LOJA 	= '"+SD1->D1_LOJA+"'"+c_ent
_cQuery += " AND D2_COD  	= '"+SD1->D1_COD+"'"+c_ent
_cQuery += " AND D2_PEDIDO	= EE9_PEDIDO"+c_ent
_cQuery += " AND D2_DOC 	= EE9_NF"+c_ent
_cQuery += " AND D2_SERIE 	= EE9_SERIE"+c_ent
_cQuery += " AND D2_COD 	= EE9_COD_I"+c_ent
_cQuery += " AND D2_CLVL 	= EE9_PREEMB"+c_ent
_cQuery	+= " AND SD1.D_E_L_E_T_ = ' '"+c_ent
_cQuery	+= " AND SD2.D_E_L_E_T_ = ' '"+c_ent
_cQuery	+= " AND EE9.D_E_L_E_T_ = ' '"+c_ent

MemoWrite("C:\Tmp\SF1100I.txt",_cQuery)

_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

_nReg := (_cAlias)->REGISTRO

DbcloseArea(_cAlias)

Return( _nReg )
