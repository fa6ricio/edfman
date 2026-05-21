#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ EDFLP002    ³ Autor ³ Luis Felipe Nascim	³ Data ³ 16.09.16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retornar a conta contabil a partir do LP e Sequencia  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ LP´s                                                 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------------*
User Function EDFLP002(_LanPad,_Seq)
*----------------------------------*

Local _aArea	:= GetArea()
Local _cConta	:= ''
Default _LanPad := ''
Default _Seq	:= ''

// PAGAMENTO ANTECIPADO INCL. E ESTORNO
If	_LanPad $ '513/514' .and. _Seq == '001' 
	SA2->(DbSetOrder(1))     
	SA2->(DbSeek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA)))
	If SA2->A2_XDESCGR $ "000003"
		_cConta := "11402011" // ADIANTAMENTO A FORNECEDORES REAL - USINAS         
	ElseIf SA2->A2_XDESCGR $ "000008" 
		_cConta := "11402013" // ADIANTAMENTO A FORNECEDORES REAL - MCM // Substituida a conta "11402012" // 24/05/17 - Luis Felipe            
	Else     
		SED->(DbSetOrder(1))     
		SED->(DbSeek(xFilial("SED")+SE2->E2_NATUREZ))
		_cConta := SED->ED_CONTA
	EndIf
EndIf

RestArea(_aArea)
 
Return( _cConta )