#Include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100AG   ºAutor  ³YTTALO P. MARTINS   º Data ³  18/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada utilizado para realizar um procedimento de  ±±
±±º           execução complementar após a confirmação de "Inclusão,       ±± 
±±º           Classificação ou exclusão" de um Documento de Entrada.       ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ESTORNA MOVIMENTAÇÕES INTERNAS E TRANSFERÊNCIAS APÓS ESTORNOº±±
±±º          ³DA CLASSIFICAÇÃO E EXCLUSÃO DA NF DE ENTRADA                 ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100AG()

//Local lRet := .T.

Private cAliasSD3 := ""
Private cAliasSD1 := ""
Private cAliasSZD := ""
Private cQuery    := ""
Private cQuery2   := ""
Private cQuery3   := ""
Private cQuery4   := ""
Private aVetMov   := {}
Private aVetTransf:= {}
Private aAreaAtu  := GetArea()
Private aAreaSF1  := SF1->(GetArea())
Private aAreaSA2  := SA2->(GetArea())
Private aAreaSC7  := SC7->(GetArea())
Private aAreaSB2  := SB2->(GetArea())
Private aAreaSF4  := SF4->(GetArea())
Private _aArea
Private _aArea2
Public nCusto5      := 0
Public __cContra	:= SF1->F1_CONTRA
Public __cPeriodo 	:= SF1->F1_XPERIOD
Public __cPedido  	:= SF1->F1_XPEDIDO
Public __nValor 	:= GdFieldGet("D1_TOTAL",n)
Public __cTES 		:= GdFieldGet("D1_TES",n)
Public __nTaxaUSD	:= GetAdvFVal( "SC7", "C7_TAXAUSD", xFilial("SC7")+SF1->F1_XPEDIDO, 1, " " )

Private lMsErroAuto := .F.
//alert("entrou no MT100AG")
IF (INCLUI == .F. .AND. ALTERA == .F.)
	//alert("entrou na exclusão - MT100AG")
	cAliasSD1 := GetNextAlias()
	cQuery := "SELECT * FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += "WHERE SD1.D1_FILIAL='"+xFilial("SD1")+"' "
	cQuery += "AND SD1.D1_DOC='"+SF1->F1_DOC+"' "
	cQuery += "AND SD1.D1_SERIE='"+SF1->F1_SERIE+"' "
	cQuery += "AND SD1.D1_FORNECE='"+SF1->F1_FORNECE+"' "
	cQuery += "AND SD1.D1_LOJA='"+SF1->F1_LOJA+"' "
	cQuery += "ORDER BY D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA "
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
	
	dbSelectArea(cAliasSD1)
	(cAliasSD1)->(dbGotop())
	If (cAliasSD1)->(!EOF())
		
		_aArea2 := GetArea()
		
		//------------------------------------------------------------------
		//Atualiza Qtd Atendida do Pedido de Compras associado--------------
		//------------------------------------------------------------------
		dbSelectArea("SC7")
		SC7->(DbSetOrder(4)) 
        If SC7->(DbSeek(xFilial("SC7")+(cAliasSD1)->D1_COD+SF1->F1_XPEDIDO)) 
			RecLock("SC7",.F.) 
			SC7->C7_QUJE -= (cAliasSD1)->D1_QUANT
			SC7->C7_QTDACLA -= (cAliasSD1)->D1_QUANT
			("SC7")->(Msunlock())
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			If SF4->(DbSeek(xFilial("SF4")+SC7->C7_TES))			
			    
				If SF4->F4_ESTOQUE=="S"
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o Saldo em Pedido do SB2                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SB2")
					dbSetOrder(1)
					If SB2->(DbSeek(xFilial("SC7")+SC7->C7_PRODUTO+SC7->C7_LOCAL))
		            
						SB2->B2_SALPEDI += SC7->C7_QUANT
						SB2->B2_SALPED2 += ConvUm(SC7->C7_PRODUTO,SC7->C7_QUANT,0,2)		
		
					EndIf
				
				EndIf
			
			EndIf
			
        EndIf
		
		lMsErroAuto := .F.
		//-------------------------------------------------------------------
		//estorna movimentações internas-------------------------------------
		//-------------------------------------------------------------------
		xEstMovInt()
		
		If lMsErroAuto == .F.
			//-------------------------------------------------------------------
			//estorna transferências---------------------------------------------
			//-------------------------------------------------------------------
			xEstTransf()
			
		EndIf
		
		If lMsErroAuto == .F.
			//-------------------------------------------------------------------
			//Atualiza SZD-------------------------------------------------------
			//-------------------------------------------------------------------
			xAtuSZD()
			
		EndIf
		
		RestArea(_aArea2)
		
	EndIf
	
	//lRet := IIF(lMsErroAuto == .T.,lRet := .F., lRet := .T.)
	
	dbSelectArea(cAliasSD1)
	(cAliasSD1)->(dbCloseArea())
	
ELSEIF INCLUI == .T. .AND. ALTERA == .F.
	
	//-------------------------------------------
	//mantida lógica encontrada no fonte antigo--
	//-------------------------------------------
	dbSelectArea("SA2")
	SA2->( dbSetOrder( 1 ) )
	If SA2->( DbSeek( xFilial( "SA2" ) + cA100For + cLoja  ) )
		
		RecLock("SF1",.F.)
		SF1->F1_XNOMFOR := SA2->A2_NOME
		("SF1")->(Msunlock())
		
	EndIf
	
ENDIF

RestArea(aAreaAtu)
RestArea(aAreaSF1)
RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aAreaSB2)
RestArea(aAreaSF4)


RETURN()

*********************************************************************************************************************************************

Static Function xEstMovInt()

cAliasSD3 := GetNextAlias()
cQuery2 := "SELECT * FROM "+RetSqlName("SD3")+" SD3 "
cQuery2 += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' "
cQuery2 += "AND SD3.D3_XD1NSEQ = '" + (cAliasSD1)->D1_NUMSEQ + "' "
cQuery2 += "AND SD3.D3_ESTORNO = ' ' "
cQuery2 += "AND ( SUBSTRING(SD3.D3_CF,1,2) <> 'PR' AND SUBSTRING(SD3.D3_CF,3,1) NOT IN ('2','4','5','7') ) "
cQuery2 += "AND SD3.D_E_L_E_T_ = ' ' "
cQuery2 += "ORDER BY D3_NUMSEQ DESC "

cQuery2 := ChangeQuery(cQuery2)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAliasSD3,.T.,.T.)

dbSelectArea(cAliasSD3)
(cAliasSD3)->(dbGotop())

Begin Transaction

While (cAliasSD3)->(!EOF())
	
	_aArea := GetArea()
	
	
	aVetMov := {}
	
	aAdd(aVetMov, {"D3_NUMSEQ" , (cAliasSD3)->D3_NUMSEQ   , Nil})
	aAdd(aVetMov, {"INDEX"     , 4        , Nil})
	
	dbSelectArea("SD3")
	MSExecAuto({|x,y| MATA240(x,y)}, aVetMov, 5) //5-Estorno
	
	If lMsErroAuto
		MostraErro()
		
		MsgAlert("Erro: Movimentação(XML-Template) não estornada!")
		
		DisarmTransaction()
		
		Break
	EndIf
	
	
	RestArea(_aArea)
	
	(cAliasSD3)->(dbSkip())
EndDo

End Transaction

dbSelectArea(cAliasSD3)
(cAliasSD3)->(dbCloseArea())

Return()

*********************************************************************************************************************************************

Static Function xEstTransf()

cAliasSD3 := GetNextAlias()
cQuery3 := "SELECT * FROM "+RetSqlName("SD3")+" SD3 "
cQuery3 += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' "
cQuery3 += "AND SD3.D3_XD1NSEQ = '" + (cAliasSD1)->D1_NUMSEQ + "' "
cQuery3 += "AND SD3.D3_ESTORNO = ' ' "
cQuery3 += "AND ( SD3.D3_CF = 'DE4' OR SD3.D3_CF = 'RE4' ) "
cQuery3 += "AND SD3.D_E_L_E_T_ = ' ' "
cQuery3 += "ORDER BY D3_NUMSEQ DESC "

cQuery3 := ChangeQuery(cQuery3)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),cAliasSD3,.T.,.T.)

dbSelectArea(cAliasSD3)
(cAliasSD3)->(dbGotop())

Begin Transaction

While (cAliasSD3)->(!EOF())
	
	_aArea := GetArea()
	
	
	aVetTransf := {}
	
	dbSelectArea("SD3")
	dbGoto((cAliasSD3)->R_E_C_N_O_)
	
	If Empty(SD3->D3_ESTORNO)
		
		MSExecAuto({|x,y| mata261(x,y)},aVetTransf,6)//estorno
		
		If lMsErroAuto
			MostraErro()
			
			MsgAlert("Erro: Transferência(XML-Template) não estornada!")
			
			DisarmTransaction()
			
			Break
		EndIf
		
	EndIf
	
	
	RestArea(_aArea)
	
	(cAliasSD3)->(dbSkip())
EndDo

End Transaction

dbSelectArea(cAliasSD3)
(cAliasSD3)->(dbCloseArea())

Return()

*********************************************************************************************************************************************
Static Function xAtuSZD()

Local cStatus := IIF( SF1->(Deleted()),"EX","AT" )//se nota excluída ou apenas estorno da classificação

dbSelectArea("SA2")
SA2->( dbSetOrder( 1 ) )
If SA2->( DbSeek( xFilial( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA  ) )
	
	Begin Transaction
	
	//DELETA LINHAS REFERENTES AS DEMAIS ENTRADAS PARCIAIS
	cQuery4 := "UPDATE "+RetSQLName("SZD")+" SET "
	cQuery4 += "D_E_L_E_T_ = '*' "
	cQuery4 += "WHERE ZD_FILIAL='"+xFilial("SZD")+"' "
	cQuery4 += "AND ZD_NFREMES = '" + SF1->F1_DOC + "' "
	cQuery4 += "AND ZD_SERIER = '" + SF1->F1_SERIE + "' "
	cQuery4 += "AND ZD_CNPJUSI = '" + SA2->A2_CGC + "' "
	cQuery4 += "AND ZD_PARC <> '01' "
	cQuery4 += "AND D_E_L_E_T_ = ' '; "
	
	TcSqlExec(cQuery4)
	
	If TCSQLExec( cQuery4 ) <> 0
		UserException("Falha na Atualização da tabela XML-Template - " + TCSQLError() )
		
		DisarmTransaction()
		
		Break
	EndIf
	
	cQuery4 := ""
	
	//ATUALIZA REGISTRO REFERENTES A PARCELA '01'
	cQuery4 := "UPDATE "+RetSQLName("SZD")+" SET "
	cQuery4 += "ZD_QTDREC = 0, ZD_SALDO = ( "
	cQuery4 += "    SELECT TOP 1 ZD_QTDNFRE FROM "+RetSqlName("SZD")+" "
	cQuery4 += "    WHERE ZD_FILIAL='"+xFilial("SZD")+"' "
	cQuery4 += "    AND ZD_NFREMES = '" + SF1->F1_DOC + "' "
	cQuery4 += "    AND ZD_SERIER = '" + SF1->F1_SERIE + "' "
	cQuery4 += "    AND ZD_CNPJUSI = '" + SA2->A2_CGC + "' "
	cQuery4 += "    AND ZD_PARC = '01' "
	cQuery4 += "    AND D_E_L_E_T_ = ' ' "
	cQuery4 += "    ) "
	cQuery4 += ", ZD_STATUS = '"+cStatus+"' "
	cQuery4 += "WHERE ZD_FILIAL='"+xFilial("SZD")+"' "
	cQuery4 += "AND ZD_NFREMES = '" + SF1->F1_DOC + "' "
	cQuery4 += "AND ZD_SERIER = '" + SF1->F1_SERIE + "' "
	cQuery4 += "AND ZD_CNPJUSI = '" + SA2->A2_CGC + "' "
	cQuery4 += "AND ZD_PARC = '01' "
	cQuery4 += "AND D_E_L_E_T_ = ' '; "
	
	TcSqlExec(cQuery4)
	
	If TCSQLExec( cQuery4 ) <> 0
		UserException("Falha na Atualização da tabela XML-Template - " + TCSQLError() )
		
		DisarmTransaction()
		
		Break
	EndIf
	
	End Transaction
	
EndIf


Return()

