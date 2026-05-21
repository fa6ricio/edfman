#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT102BTO  ºAutor  ³Leandro Ribeiro     º Data ³  24/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada executado no momento da abertura da tela  º±±
±±º          ³ de contabilização, para o preenchimento da tabela 		  º±±
±±º          ³ temporaria.												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CT102BTO()

Local _cCT102BTO := GetArea()
Local _cHistLote
Local _cResult
/*Local _lControl  := Iif(Type("_cControl") == "U", .T.,.F.)
Local _lEstorno  := Iif(Type("_cEstorno") == "U", .T.,.F.)
Local _lLiquida3 := Iif(Type("_lLiquida2") == "U", .F.,.T.)*/
Local _lControl  := Type("_cControl") == "U"
Local _lEstorno  := Type("_cEstorno") == "U"
Local _lLiquida3 := !Type("_lLiquida2") == "U"
Local _nCont	 := 1  

If	Type("lJafez") == "U"
	Public lJafez := .f. 
//Else           // 12/06/18 - Luis Felipe
//	Return	
EndIf

If(FUNNAME() == "EFFEX400")
	_cResult   := nTotInf
	If(_lEstorno)
		If(_lControl) .and. !_lLiquida3
			_cHistLote := "VC NAO REALIZADA "+_cNumContr
			DbSelectArea("TMP")
			If(!Eof())
				While !("TMP")->(Eof())
					Reclock("TMP",.F.)
					TMP->CT2_VALOR	:= Iif(_cResult <= 0, _cResult * -1, _cResult)
					TMP->CT2_HIST	:= _cHistLote
					MsUnlock()
					("TMP")->(DbSkip())
				Enddo
			EndIf
			
			DbSelectArea("TMP")
			DbGoTop()
		Else
			If Type("_aCalAcc") == "A" .and. !_lLiquida3
				_cHistLote := _cNumContr
				DbSelectArea("TMP")
				If(!Eof())
					While !("TMP")->(Eof())
						Reclock("TMP",.F.)
						TMP->CT2_VALOR := Iif(_aCalAcc[1][_nCont] <= 0, _aCalAcc[1][_nCont] * -1, _aCalAcc[1][_nCont])
						TMP->CT2_HIST  := SUBSTR(TMP->CT2_HIST,1,AT(":",TMP->CT2_HIST))+_cHistLote
						MsUnlock()
						_nCont := _nCont+1
						("TMP")->(DbSkip())
					Enddo
				EndIf
				DbSelectArea("TMP")
				DbGoTop()
			EndIf
		EndIf
	Else
		DbSelectArea("TMP")
		("TMP")->(DbGotop())
		If(!Eof())
			While !("TMP")->(Eof())
				Reclock("TMP",.F.)
				TMP->CT2_VALOR := Iif(_aEstAcc[1][_nCont] <= 0, _aEstAcc[1][_nCont] * -1, _aEstAcc[1][_nCont])
				MsUnlock()
				_nCont := _nCont+1
				("TMP")->(DbSkip())
			Enddo
		EndIf
		DbSelectArea("TMP")
		DbGoTop()
	EndIf
	
	// 03/07/15 - Luis Felipe - Inicio
	If(_cVincula)  // Vinculação de Invoices aos Contratos
		_nCont := 1
		DbSelectArea("TMP")
		("TMP")->(DbGotop())
		If(!Eof())
			If !lJafez 
				While !("TMP")->(Eof())
					Reclock("TMP",.F.)
					TMP->CT2_VALOR	:= 0
					TMP->CT2_VALR02	:= 0
					TMP->CT2_HIST	:= ''
					MsUnlock()
					("TMP")->(DbSkip())  
				End
				lJafez := .t.
			EndIf
			("TMP")->(DbGotop())
			For nx:=1 to Len(_aCalAcc)
				While !("TMP")->(Eof())
					Reclock("TMP",.F.)
					If _nCont == 1     // LP 101 SEQ 001 - VINCULACAO NUM. CONTRATO
						TMP->CT2_VALOR	+= _aCalAcc[nx][3] * _aCalAcc[nx][4]
						TMP->CT2_VALR02	+= _aCalAcc[nx][4]
						TMP->CT2_HIST	:= "VINCUL. NUM. CTR." + Alltrim(_cNumContr)  // + " INV." + Alltrim(_aCalAcc[1][5])
					ElseIf _nCont == 2 // LP 101 SEQ 002 - VC REALIZADA
						TMP->CT2_VALOR	+= If(_aCalAcc[nx][2]<0,_aCalAcc[nx][2] * -1,_aCalAcc[nx][2])
						TMP->CT2_HIST	:= "VC REALIZ. CTR." + Alltrim(_cNumContr)    // + " INV." + Alltrim(_aCalAcc[1][5])
					ElseIf _nCont == 3 // LP 101 SEQ 003 - ESTORNO VC NAO REALIZADA
						TMP->CT2_VALOR	+= If(_aCalAcc[nx][1]<0,_aCalAcc[nx][1] * -1,_aCalAcc[nx][1])
						TMP->CT2_HIST	:= "EST. VC N REALIZ." + Alltrim(_cNumContr)  // + " INV." + Alltrim(_aCalAcc[1][5])
					EndIf
					MsUnlock()
					_nCont := _nCont+1
					("TMP")->(DbSkip())
				End
				_nCont := 1
				("TMP")->(DbGotop())
			Next
		EndIf
		DbSelectArea("TMP")
		DbGoTop()
	EndIf
	
	If(_lLiquida3)  //Liquidação do Contrato
		_nCont := 1
		DbSelectArea("TMP")
		("TMP")->(DbGotop())
		If(!Eof())
			While !("TMP")->(Eof())
				Reclock("TMP",.F.)
				If _nCont == 1     // LP 102 SEQ 001 - LIQUIDAÇÃO NUM. CONTRATO
					TMP->CT2_VALOR	:= _aVliquida[1][4]
					TMP->CT2_VALR02	:= _aVliquida[1][3]
					TMP->CT2_HIST	:= "LIQUIDACAO NUM. CONTRATO " + _cNumContr
				ElseIf _nCont == 2 // LP 102 SEQ 003 - VC REALIZADA
					TMP->CT2_VALOR	:= If(_aVliquida[1][2]<0,_aVliquida[1][2] * -1,_aVliquida[1][2])
					TMP->CT2_HIST	:= "VC REALIZADA " + _cNumContr
				ElseIf _nCont == 3 // LP 102 SEQ 003 - ESTORNO VC NAO REALIZADA
					TMP->CT2_VALOR	:= If(_aVliquida[1][1]<0,_aVliquida[1][1] * -1,_aVliquida[1][1])
					TMP->CT2_HIST	:= "ESTORNO VC NAO REALIZADA " + _cNumContr
				EndIf
				MsUnlock()
				_nCont := _nCont+1
				("TMP")->(DbSkip())
			Enddo
		EndIf
		DbSelectArea("TMP")
		DbGoTop()
	EndIf
	// 03/07/15 - Luis Felipe - Fim
	
EndIf

RestArea(_cCT102BTO)

Return()