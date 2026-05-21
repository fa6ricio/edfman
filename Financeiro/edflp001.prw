#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE c_ent Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ EDFLP001    ³ Autor ³ Assunção Junior   	³ Data ³ 26.05.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ LP´s abertura de VC realizada e não realizada			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ Todos                                                	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
************************************************
//User Function EDFLP001(_cTipo,_Seq,___cLcto)
User Function EDFLP001(_LanPad,_Seq)
************************************************
Local _aArea	:= GetArea()
Local _cQuery 	:= ""
Local _cAlias  	:= GetNextAlias()
Local _Valor	:= 0
Default _LanPad := ""
Default _Seq	:= ""

If Empty(_LanPad) .or. Empty(_Seq)
	RestArea(_aArea)
	Return( _Valor )
EndIf

*********************************************************************************
**** Alterado por José de Assunção 26/01/15 - Variação Cambial
*********************************************************************************
If !Empty(SE1->E1_TXMDCOR) .and. SE1->E1_MOEDA != 1 .and. Alltrim(SE1->E1_ORIGEM) <> "SIGAEEC"
	
	If _Seq == "013" .or. _Seq == "014"
			
		nValIni := SE5->E5_VLMOED2 * SE1->E1_XDOLAR
		nValFim := SE1->E1_VALLIQ
		_Valor  := nValFim - nValIni
		
	Endif
	
	If _Seq == "012"
		
		nValIni := SE5->E5_VLMOED2 * SE1->E1_XDOLAR
		nValFim := SE1->E1_VALLIQ
		
		IF _LanPad == "527" // Estorno
			_Valor  := (nValFim - nValIni) - SE5->E5_VLCORRE
		ELSE	
			_Valor  := (nValFim - nValIni) - SE1->E1_CORREC	// 520 - Baixa	
		ENDIF
		
	Endif
	
	RestArea(_aArea)
	
	*********************************************************************************
	**** Luiz Fernando 14/08/15 - Variação para Titulos com pagamentos paraciais
	**** Quebra de invoices
	*********************************************************************************
	
ElseIf !Empty(SE1->E1_TXMDCOR) .and. SE1->E1_MOEDA != 1 .and. !Empty(SE1->E1_BAIXA) .and. Alltrim(SE1->E1_ORIGEM) == "SIGAEEC"
	
	If _Seq == "013" .or. _Seq == "014"
		nValIni := SE1->E1_VLCRUZ
		nValFim := SE1->E1_VALLIQ
		_Valor  := nValFim - nValIni
	Endif
	
	If _Seq == "012"
		nValIni := SE1->E1_VLCRUZ
		nValFim := SE1->E1_VALLIQ
		_Valor  := (nValFim - nValIni) - SE1->E1_CORREC
	Endif
	
	RestArea(_aArea)
	
EndIf

Return( _Valor )

*********************************************************************************
//Alterado por Assunção - Totvs RJ - 26/01/2016
/*
_cQuery := " SELECT SUM(E5_VALOR) as VALOR"+c_ent
_cQuery += " FROM "+RetSqlName("SE5")+c_ent
_cQuery += " WHERE D_E_L_E_T_ = ' '"+c_ent

If _cTipo == 'R'
_cQuery += " AND E5_FILIAL  = '"+SE1->E1_FILIAL+"'"+c_ent
_cQuery += " AND E5_PREFIXO = '"+SE1->E1_PREFIXO+"'"+c_ent
_cQuery += " AND E5_NUMERO  = '"+SE1->E1_NUM+"'" +c_ent
_cQuery += " AND E5_PARCELA = '"+SE1->E1_PARCELA+"'"+c_ent
_cQuery += " AND E5_TIPO    = '"+SE1->E1_TIPO+"'"+c_ent
_cQuery += " AND E5_TIPODOC IN ('CM','VM')"+c_ent
_cQuery += " AND E5_SITUACA <> 'C' "+c_ent

ElseIf _cTipo == 'P'
_cQuery += " AND E5_FILIAL  = '"+SE2->E2_FILIAL+"'"+c_ent
_cQuery += " AND E5_PREFIXO = '"+SE2->E2_PREFIXO+"'"+c_ent
_cQuery += " AND E5_NUMERO  = '"+SE2->E2_NUM+"'" +c_ent
_cQuery += " AND E5_PARCELA = '"+SE2->E2_PARCELA+"'"+c_ent
_cQuery += " AND E5_TIPO    = '"+SE2->E2_TIPO+"'"+c_ent
_cQuery += " AND E5_TIPODOC IN('VM','CM')"+c_ent
_cQuery += " AND E5_SITUACA <> 'C' "+c_ent
EndIf

If _Seq = '1'
If _cTipo == 'R'
_cQuery += " AND E5_DATA < '"+DtoS(SE1->E1_BAIXA)+"'"+c_ent
ElseIf _cTipo == 'P'
_cQuery += " AND E5_DATA < '"+DtoS(SE2->E2_BAIXA)+"'"+c_ent
EndIf
EndIf

_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

_Valor := (_cAlias)->VALOR

DbcloseArea(_cAlias)

RestArea(_aArea)

Return( _Valor )
*/
