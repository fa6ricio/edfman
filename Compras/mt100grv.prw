#Include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"
#INCLUDE "TOPCONN.CH"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GRV  ºAutor  ³YTTALO P. MARTINS   º Data ³  24/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Está localizado na função a103Grava responsável pela gravação±±
±±º           da Nota Fiscal.  Executado antes de iniciar o processo de    ±±
±±º           gravação / exclusão de Nota de Entrada.                      ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ESTORNA MOVIMENTAÇÕES INTERNAS E TRANSFERÊNCIAS APÓS ESTORNOº±±
±±º          ³DA CLASSIFICAÇÃO E EXCLUSÃO DA NF DE ENTRADA                 ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100GRV()

Local lRet 	 := .T.
Local lExp01 := PARAMIXB[1]//SE ESTÁ DELETANDO NOTA
Local nQtdRec:= 0

Private aAreaAtu  := GetArea()

Public __cRateio := SD1->D1_RATEIO // Rateio pelos itens ?
	
IF (INCLUI == .F. .AND. ALTERA == .F.) .AND. lExp01 == .T.
	
	Private cAliasSD3 := ""
	Private cAliasSD1 := ""
	Private cAliasSZD := ""
	Private cQuery    := ""
	Private cQuery2   := ""
	Private cQuery3   := ""
	Private cQuery4   := ""
	Private aVetMov   := {}
	Private aVetTransf:= {}
	Private aAreaSF1  := SF1->(GetArea())
	Private aAreaSA2  := SA2->(GetArea())
	Private aAreaSC7  := SC7->(GetArea())
	Private aAreaSB2  := SB2->(GetArea())
	Private aAreaSF4  := SF4->(GetArea())
	Private _aArea
	Private _aArea2
	
	Public xlEDFSZD   := .F.//variável para verificar se SZD foi atualizada para ser utilizada no PE QIEIMPRL
	
	Public __cRateio := SD1->D1_RATEIO // Rateio pelos itens ?
	
	Private lMsErroAuto := .F.
	
	//-------------------------------------------------------------------
	//Exclui título criado na classificação da NFE-----------------------
	//-------------------------------------------------------------------	
	U_EDFA012()
	
	// 01/10/2013 - Luís Felipe Nascimento
	nQtdRec := fQtdRec()
	
	//-------------------------------------------------------------------
	//Atualiza SZD-------------------------------------------------------
	//-------------------------------------------------------------------
	lRet := xAtuSZD()
	
	If lRet == .T.
		
		xlEDFSZD   := .T.
		
		//------------------------------------------------------------------
		//Atualiza Qtd Atendida do Pedido de Compras associado--------------
		//------------------------------------------------------------------
		dbSelectArea("SC7")
		SC7->(DbSetOrder(1))
		If SC7->(DbSeek(xFilial("SC7")+SF1->F1_XPEDIDO))
			
			dbSelectArea("SD1")
			dbSetOrder(1)
			If dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
				nFator := U_EDFFATOR(SD1->D1_COD) // 16/09/13 - Luis Felipe Nascimento
				RecLock("SC7",.F.)
				SC7->C7_QUJE    -= nQtdRec * If(nFator<>0.00,nFator,1)
				SC7->C7_QTDACLA -= nQtdRec * If(nFator<>0.00,nFator,1)
				("SC7")->(Msunlock())
				/*
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
				*/
			EndIf
			
		EndIf
		
	EndIF
	
	RestArea(aAreaSF1)
	RestArea(aAreaSA2)
	RestArea(aAreaSC7)
	RestArea(aAreaSB2)
	RestArea(aAreaSF4)
	
ENDIF

RestArea(aAreaAtu)


RETURN(lRet)

*********************************************************************************************************************************************
Static Function xAtuSZD()

Local lOk := .T.

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
	
	If TCSQLExec( cQuery4 ) <> 0
		UserException("Falha na Atualização da tabela XML-Template - " + TCSQLError() )
		
		lOk := .F.
		DisarmTransaction()
		
		Break
	EndIf
	
	cQuery4 := ""
	
	//ATUALIZA REGISTRO REFERENTES A PARCELA '01'
	cQuery4 := "UPDATE "+RetSQLName("SZD")+" SET "
	cQuery4 += "    ZD_QTDREC  = 0 , ZD_STATUS  = 'AT',"
	cQuery4 += "	ZD_DTETERM = '', ZD_SEQTEMP = ''  ,"
	cQuery4 += "	ZD_CNPJTER = '', ZD_CNPJTEI = ''  ,"
	cQuery4 += "	ZD_DTTERMI = '', ZD_QTDTERI = ''  ,"
	cQuery4 += "	ZD_NOMETER = '', ZD_NOMETEI = ''  ,"
	cQuery4 += "	ZD_PLACA   = '',"
	cQuery4 += "	ZD_DTTEMPL = '', ZD_SALDO = ( "
	cQuery4 += "    SELECT TOP 1 ZD_QTDNFRE FROM "+RetSqlName("SZD")+" "
	cQuery4 += "    WHERE ZD_FILIAL = '" +xFilial("SZD")+"' "
	cQuery4 += "    AND ZD_NFREMES  = '" + SF1->F1_DOC + "' "
	cQuery4 += "    AND ZD_SERIER   = '" + SF1->F1_SERIE + "' "
	cQuery4 += "    AND ZD_CNPJUSI  = '" + SA2->A2_CGC + "' "
	cQuery4 += "    AND ZD_PARC     = '01' "
	cQuery4 += "    AND ZD_STATUS <> 'EX' "    // 12/09/13 - Luís Felipe Nascimento
	cQuery4 += "    AND D_E_L_E_T_  = ' ' "
	cQuery4 += "    ) "
	cQuery4 += "WHERE ZD_FILIAL='"+xFilial("SZD")+"' "
	cQuery4 += "AND ZD_NFREMES = '" + SF1->F1_DOC + "' "
	cQuery4 += "AND ZD_SERIER = '" + SF1->F1_SERIE + "' "
	cQuery4 += "AND ZD_CNPJUSI = '" + SA2->A2_CGC + "' "
	cQuery4 += "AND ZD_PARC = '01' "
	cQuery4 += "AND ZD_STATUS <> 'EX' " // 12/09/13 - Luís Felipe Nascimento
	cQuery4 += "AND D_E_L_E_T_ = ' '; "
	
	If TCSQLExec( cQuery4 ) <> 0
		UserException("Falha na Atualização da tabela XML-Template - " + TCSQLError() )
		
		lOk := .F.
		DisarmTransaction()
		
		Break
	EndIf
	
	End Transaction
	
EndIf

Return(lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA004B  ºAutor  Luis Felipe Nascim.  º Data ³  08/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para retornar os valores para o preenchimento da    º±±
±±º          ³ tela informativa.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-----------------------------------------------------------------------------------------------*
* Busca o total recebido pelas NFs Remessa de um mesmo Contrato + Período + Mae                 *
*-----------------------------------------------------------------------------------------------*

Static Function fQtdRec()

Local cQuery := ""
Local cAlias := GetNextAlias()
Local nValor := {}

cQuery := " SELECT ZD_NFREMES,Sum(ZD_QTDREC) As ZD_QTDREC"+c_ent
cQuery += " FROM " + RetSqlName("SZD")+" SZD "+c_ent
cQuery += " WHERE ZD_FILIAL = '"+xFilial("SZD")+"'"+c_ent
cQuery += " AND ZD_CONTRA   = '"+SF1->F1_CONTRA+"'"+c_ent
cQuery += " AND ZD_PERIODO  = '"+SF1->F1_XPERIOD+"'"+c_ent
cQuery += " AND ZD_NFMAE    = '"+SF1->F1_NFMAE+"'"+c_ent
cQuery += " AND ZD_SERIEM   = '"+SF1->F1_XSERMAE+"'"+c_ent
cQuery += " AND ZD_NFREMES  = '"+SF1->F1_DOC + "' "
cQuery += " AND ZD_SERIER   = '"+SF1->F1_SERIE + "' "
cQuery += " AND ZD_STATUS   <> 'EX'" + c_ent
cQuery += " AND D_E_L_E_T_  = ' '"+c_ent
cQuery += " GROUP BY ZD_NFREMES "

If Select(cAlias) > 0
	DbselectArea(cAlias)
	(cAlias)->(DbCloseArea())
EndIf

DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)

nValor := (cAlias)->ZD_QTDREC

(cAlias)->(DbCloseArea())

Return( nValor )
