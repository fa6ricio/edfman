#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE c_ent Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ EDFFUN      ³ Autor ³ Luis Felipe Mattos	³ Data ³ 26.04.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funções de Uso Geral                    			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ Todos                                                	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function fTotReg(__cAlias,__cCondicao,__cFilDe,__cFilAte)

Local _nRegistro 	:= 0
Local _cQuery	 	:= ""
Local _cAlias    	:= GetNextAlias()
Local _aArea		:= GetArea()
Default __cCondicao	:= ""
Default __cAlias	:= alias()
Default __cFilDe	:= ""
Default __cFilAte	:= "ZZ"

_cQuery := " SELECT Count(*) REGISTROS "+c_ent
_cQuery += " FROM "+RetSqlName(__cAlias)+c_ent
_cQuery += " WHERE D_E_L_E_T_ = ' '"+c_ent
_cQuery += " AND " + If(SubStr(__cAlias,1,1)=='S',SubStr(__cAlias,1,2)+"_FILIAL ",SubStr(__cAlias,1,3)+"_FILIAL " )+" Between "+__cFilDe+"' AND '"+__cFilAte+"'"+c_ent
_cQuery += " "+__cCondicao+c_ent

_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

_nRegistro := (_cAlias)->REGISTROS

DbcloseArea(_cAlias)

RestArea(_aArea)

Return( _nRegistro )

*------------------------------------------------------------*
User Function fFiltro(__cAlias,__cCondicao,__cFilDe,__cFilAte)
*------------------------------------------------------------*

Local _nRegs 		:= 0
Local _cQuery		:= ""
Local _cAlias   	:= GetNextAlias()
Local _aArea		:= GetArea()
Default __cCondicao	:= ""
Default __cAlias	:= alias()
Default __cFilDe	:= ""
Default __cFilAte	:= "ZZ"

If Select(_cAlias) > 0
	DbcloseArea(_cAlias)
EndIf

_cQuery := " SELECT DISTINCT * "+c_ent
_cQuery += " FROM "+RetSqlName(__cAlias)+c_ent
_cQuery += " WHERE D_E_L_E_T_ = '' "+c_ent
_cQuery += " AND " + If(SubStr(__cAlias,1,1)=='S',SubStr(__cAlias,2,2)+"_FILIAL ",SubStr(__cAlias,1,3)+"_FILIAL " )+" Between '"+__cFilDe+"' AND '"+__cFilAte+"'"+c_ent
If !Empty(__cCondicao)
	_cQuery += " AND "+__cCondicao+c_ent
EndIf

_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

DbcloseArea(_cAlias)

RestArea(_aArea)

Return

*--------------------------------------------------------------------*
User Function fProx(__cTabela,__cCondicao,__cFilDe,__cFilAte,__cCampo)
*--------------------------------------------------------------------*

Local _cProx    	:= Soma1(StrZero(0,TamSx3(__cCampo)[1]))
Local _cQuery		:= ""
Local _aArea		:= GetArea()
Local _cAlias		:= GetNextAlias()
Default __cCondicao	:= ""
Default __cTabela	:= alias()
Default __cFilDe	:= ""
Default __cFilAte	:= "ZZ"
Default __cCampo    := ""

_cQuery := " SELECT Max("+__cCampo+") AS PROXIMO"+c_ent
_cQuery += " FROM "+RetSqlName(__cTabela)+c_ent
_cQuery += " WHERE D_E_L_E_T_ = ' ' "+c_ent
_cQuery += " AND " + If(SubStr(__cTabela,1,1)=='S',SubStr(__cTabela,2,2)+"_FILIAL ",SubStr(__cTabela,1,3)+"_FILIAL " )+" Between '"+__cFilDe+"' AND '"+__cFilAte+"'"+c_ent
If !Empty(__cCondicao)
	_cQuery += " AND "+__cCondicao+c_ent
EndIf

_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.f.,.f.)

If !Empty((_cAlias)->PROXIMO)
	_cProx := Soma1((_cAlias)->PROXIMO)
EndIf

DbcloseArea(_cAlias)

RestArea(_aArea)

Return( _cProx )

// +----------------------------------------------------------------------------------+ //
// 31/07/14 - Luis Felipe Nascimento                                                    //
// Avalia se o fornecedor é uma Usina para que se possa criar o sequencial dos PA´s     //
// +----------------------------------------------------------------------------------+ //
*----------------------------------*
User Function fGrp(__cGrupo,__cTipo)
*----------------------------------*

Local   lRet	:= .f.
Default __cGrupo:= ""
Default __cTipo	:= ""

If __cGrupo $ "000003/000008" .And. __cTipo == "PA "
	lRet := .t.
EndIf

Return( lRet )


// +-----------------------------------------------+ //
// 29/12/15 - Luis Felipe Nascimento                 //
// Recomposição do saldo por armazem ou produto.     //
// +-----------------------------------------------+ //

*-----------------------------------------*
User Function SldSb2(cProduto,cLocal,dData)
*-----------------------------------------*

Local _nSaldo    	:= 0
Local _nSldIni 		:= 0
Local _cQuery		:= ""
Local _aArea		:= GetArea()
Local _cAlias		:= GetNextAlias()
Local dData 		:= If(Empty(dData),DtoS(dDataBase),DtoS(dData))

If !Empty(cLocal)
	// Por armazem
	_cQuery := " SELECT B2_FILIAL,B2_COD, B2_LOCAL, B9_QISEGUM, SD1_ENTRADAS, SD3_ENTRADAS, SD2_SAIDAS, SD3_SAIDAS, B9_DATA, D1_DTDIGIT, D2_EMISSAO, D3_EMISSAO"+c_ent
	_cQuery += " FROM"+c_ent
	_cQuery += " (SELECT DISTINCT B2_FILIAL, B2_COD, B2_LOCAL"+c_ent
	_cQuery += " ,ISNULL((SELECT B1_CONV * SUM(D1_QUANT) FROM "+ RetSqlName("SD1") + " D1," + RetSqlName("SF4") + " F4 WHERE SB2.B2_FILIAL=D1.D1_FILIAL AND SB2.B2_COD = D1_COD    AND SB2.B2_LOCAL = D1_LOCAL    AND F4.F4_CODIGO = D1_TES AND F4_ESTOQUE = 'S' AND D1_DTDIGIT 	<= '"+dData+"' AND D1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' GROUP BY D1_COD, D1_LOCAL),0)  SD1_ENTRADAS"+c_ent
	_cQuery += " ,ISNULL((SELECT B1_CONV * SUM(D2_QUANT) FROM "+ RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4 WHERE SB2.B2_FILIAL=D2.D2_FILIAL AND SB2.B2_COD = D2_COD    AND SB2.B2_LOCAL = D2_LOCAL    AND F4.F4_CODIGO = D2_TES AND F4_ESTOQUE = 'S' AND D2_EMISSAO 	<= '"+dData+"' AND D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' GROUP BY D2_COD, D2_LOCAL),0)  SD2_SAIDAS"+c_ent
	_cQuery += " ,ISNULL((SELECT B1_CONV * SUM(D3_QUANT) FROM "+ RetSqlName("SD3") + " D3                              WHERE SB2.B2_FILIAL=D3.D3_FILIAL AND SB2.B2_COD = D3.D3_COD AND SB2.B2_LOCAL = D3.D3_LOCAL AND D3.D3_TM <= 500 							 AND D3.D3_EMISSAO  <= '"+dData+"' AND D3.D_E_L_E_T_ = '' 						 GROUP BY D3_COD, D3_LOCAL),0)  SD3_ENTRADAS"+c_ent
	_cQuery += " ,ISNULL((SELECT B1_CONV * SUM(D3_QUANT) FROM "+ RetSqlName("SD3") + " D3                              WHERE SB2.B2_FILIAL=D3.D3_FILIAL AND SB2.B2_COD = D3.D3_COD AND SB2.B2_LOCAL = D3.D3_LOCAL AND D3.D3_TM >= 501 							 AND D3.D3_EMISSAO  <= '"+dData+"' AND D3.D_E_L_E_T_ = '' 						 GROUP BY D3_COD, D3_LOCAL),0)  SD3_SAIDAS"+c_ent
	_cQuery += " ,ISNULL((SELECT Min(D1_DTDIGIT) FROM "+ RetSqlName("SD1") + " D1," + RetSqlName("SF4") + " F4 WHERE SB2.B2_FILIAL=D1.D1_FILIAL AND SB2.B2_COD = D1_COD    AND SB2.B2_LOCAL = D1_LOCAL    AND F4.F4_CODIGO = D1_TES AND F4_ESTOQUE = 'S' AND D1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' 								 GROUP BY D1_COD, D1_LOCAL),'') D1_DTDIGIT"+c_ent
	_cQuery += " ,ISNULL((SELECT Min(D2_EMISSAO) FROM "+ RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4 WHERE SB2.B2_FILIAL=D2.D2_FILIAL AND SB2.B2_COD = D2_COD    AND SB2.B2_LOCAL = D2_LOCAL    AND F4.F4_CODIGO = D2_TES AND F4_ESTOQUE = 'S' AND D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' 								 GROUP BY D2_COD, D2_LOCAL),'') D2_EMISSAO"+c_ent
	_cQuery += " ,ISNULL((SELECT Min(D3_EMISSAO) FROM "+ RetSqlName("SD3") + " D3                              WHERE SB2.B2_FILIAL=D3.D3_FILIAL AND SB2.B2_COD = D3_COD    AND SB2.B2_LOCAL = D3_LOCAL    												 AND D3.D_E_L_E_T_ = '' 					   									 GROUP BY D3_COD, D3_LOCAL),'') D3_EMISSAO"+c_ent
	_cQuery += " FROM "+ RetSqlName("SB1") + " SB1, "+RetSqlName("SB2") + " SB2"+c_ent
	_cQuery += " WHERE B1_COD = B2_COD"+c_ent
	_cQuery += " AND SB1.D_E_L_E_T_ = ''"+c_ent
	_cQuery += " AND SB2.D_E_L_E_T_ = ''"+c_ent
	_cQuery += " AND B2_COD   = '"+cProduto+"'"+c_ent
	_cQuery += " AND B2_LOCAL = '"+cLocal+"')"+c_ent
	_cQuery += " AS B2"+c_ent
	_cQuery += " LEFT JOIN"+c_ent
	_cQuery += " (SELECT DISTINCT B9_FILIAL, B9_COD, B9_LOCAL, B9_QISEGUM, B9_DATA"+c_ent
	_cQuery += " FROM "+ RetSqlName("SB9") + " B9 "+c_ent
	_cQuery += " WHERE B9_COD   = '"+cProduto+"'"+c_ent
	_cQuery += " AND B9_LOCAL = '"+cLocal+"'"+c_ent
	_cQuery += " AND B9.D_E_L_E_T_ = ''"+c_ent
	_cQuery += " AND B9_DATA = (SELECT Min(B9_DATA) FROM "+ RetSqlName("SB9") + " WHERE B9_FILIAL = B9.B9_FILIAL AND B9_COD = B9.B9_COD AND B9_LOCAL = B9.B9_LOCAL AND D_E_L_E_T_ = ''))"+c_ent
	_cQuery += " AS B9"+c_ent
	_cQuery += " ON B2.B2_FILIAL=B9.B9_FILIAL AND B2.B2_COD = B9.B9_COD AND B2.B2_LOCAL = B9.B9_LOCAL"+c_ent
	_cQuery += " WHERE B9_QISEGUM <> 0 OR SD1_ENTRADAS <> 0 OR SD3_ENTRADAS <> 0 OR SD2_SAIDAS <> 0 OR SD3_SAIDAS <> 0"+c_ent
Else
	// Por produto
	_cQuery := " SELECT B2_FILIAL,B2_COD,B9_QISEGUM, SD1_ENTRADAS, SD3_ENTRADAS, SD2_SAIDAS, SD3_SAIDAS, B9_DATA, D1_DTDIGIT, D2_EMISSAO, D3_EMISSAO"+c_ent
	_cQuery += " FROM"+c_ent
	_cQuery += " (SELECT DISTINCT B2_FILIAL,B2_COD"+c_ent
	_cQuery += " ,ISNULL((SELECT B1_CONV * SUM(D1_QUANT) FROM "+ RetSqlName("SD1") + " D1," + RetSqlName("SF4") + " F4 WHERE SB2.B2_FILIAL = D1.D1_FILIAL    AND SB2.B2_COD = D1_COD    AND F4.F4_CODIGO = D1_TES AND F4_ESTOQUE = 'S' AND D1_DTDIGIT 	<= '"+dData+"' AND Len(D1_LOCAL) = '2' AND D1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' GROUP BY D1_COD),0)  SD1_ENTRADAS"+c_ent
	_cQuery += " ,ISNULL((SELECT B1_CONV * SUM(D2_QUANT) FROM "+ RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4 WHERE SB2.B2_FILIAL = D2.D2_FILIAL    AND SB2.B2_COD = D2_COD    AND F4.F4_CODIGO = D2_TES AND F4_ESTOQUE = 'S' AND D2_EMISSAO 	<= '"+dData+"' AND Len(D2_LOCAL) = '2' AND D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' GROUP BY D2_COD),0)  SD2_SAIDAS"+c_ent
	_cQuery += " ,ISNULL((SELECT B1_CONV * SUM(D3_QUANT) FROM "+ RetSqlName("SD3") + " D3                              WHERE SB2.B2_FILIAL = D3.D3_FILIAL    AND SB2.B2_COD = D3.D3_COD AND D3.D3_TM <= 500 						   AND D3.D3_EMISSAO  <= '"+dData+"' AND Len(D3_LOCAL) = '2' AND D3.D_E_L_E_T_ = '' 					 GROUP BY D3_COD),0)  SD3_ENTRADAS"+c_ent
	_cQuery += " ,ISNULL((SELECT B1_CONV * SUM(D3_QUANT) FROM "+ RetSqlName("SD3") + " D3                              WHERE SB2.B2_FILIAL = D3.D3_FILIAL    AND SB2.B2_COD = D3.D3_COD AND D3.D3_TM >= 501 						   AND D3.D3_EMISSAO  <= '"+dData+"' AND Len(D3_LOCAL) = '2' AND D3.D_E_L_E_T_ = '' 					 GROUP BY D3_COD),0)  SD3_SAIDAS"+c_ent
	_cQuery += " ,ISNULL((SELECT Min(D1_DTDIGIT) 		 FROM "+ RetSqlName("SD1") + " D1," + RetSqlName("SF4") + " F4 WHERE SB2.B2_FILIAL = D1.D1_FILIAL    AND SB2.B2_COD = D1_COD    AND F4.F4_CODIGO = D1_TES AND F4_ESTOQUE = 'S' AND D1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' 								 GROUP BY D1_COD),'') D1_DTDIGIT"+c_ent
	_cQuery += " ,ISNULL((SELECT Min(D2_EMISSAO)		 FROM "+ RetSqlName("SD2") + " D2," + RetSqlName("SF4") + " F4 WHERE SB2.B2_FILIAL = D2.D2_FILIAL    AND SB2.B2_COD = D2_COD    AND F4.F4_CODIGO = D2_TES AND F4_ESTOQUE = 'S' AND D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' 								 GROUP BY D2_COD),'') D2_EMISSAO"+c_ent
	_cQuery += " ,ISNULL((SELECT Min(D3_EMISSAO) 		 FROM "+ RetSqlName("SD3") + " D3                              WHERE SB2.B2_FILIAL = D3.D3_FILIAL    AND SB2.B2_COD = D3_COD    AND D3.D_E_L_E_T_ = '' 					   									 												 GROUP BY D3_COD),'') D3_EMISSAO"+c_ent
	_cQuery += " FROM "+ RetSqlName("SB1") + " SB1, "+RetSqlName("SB2") + " SB2"+c_ent
	_cQuery += " WHERE B1_COD = B2_COD"+c_ent
	_cQuery += " AND Len(B2_LOCAL) = '2'"+c_ent
	_cQuery += " AND SB1.D_E_L_E_T_ = ''"+c_ent
	_cQuery += " AND SB2.D_E_L_E_T_ = ''"+c_ent
	_cQuery += " AND B2_COD   = '"+cProduto+"')"+c_ent
	_cQuery += " AS B2"+c_ent
	_cQuery += " LEFT JOIN"+c_ent
	_cQuery += " (SELECT DISTINCT B9_FILIAL,B9_COD, B9_DATA, SUM(B9_QISEGUM) AS B9_QISEGUM"+c_ent
	_cQuery += " FROM "+ RetSqlName("SB9") + " B9 "+c_ent
	_cQuery += " WHERE B9_COD   = '"+cProduto+"'"+c_ent
	_cQuery += " AND Len(B9_LOCAL) = '2'"+c_ent
	_cQuery += " AND B9.D_E_L_E_T_ = ''"+c_ent
	_cQuery += " AND B9_DATA = (SELECT Min(B9_DATA) FROM "+ RetSqlName("SB9") + " WHERE B9_FILIAL = B9.B9_FILIAL AND B9_COD = B9.B9_COD AND Len(B9_LOCAL) = '2' AND D_E_L_E_T_ = '') GROUP BY B9_FILIAL,B9_COD, B9_DATA)"+c_ent
	_cQuery += " AS B9"+c_ent
	_cQuery += " ON B2.B2_FILIAL=B9.B9_FILIAL AND B2.B2_COD = B9.B9_COD "+c_ent
	_cQuery += " WHERE B9_QISEGUM <> 0 OR SD1_ENTRADAS <> 0 OR SD3_ENTRADAS <> 0 OR SD2_SAIDAS <> 0 OR SD3_SAIDAS <> 0"+c_ent
EndIf

MemoWrite("C:\Tmp\SALDOSB2.txt",_cQuery)
_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.f.,.f.)

If !(_cAlias)->(Eof())
	DbSelectArea("SB9")
	SB9->(DbSetOrder(1))
	If Empty(cLocal)
		cArqTrbSB9		:= CriaTrab("",.F.)
		cIndex    		:= CriaTrab(NIL, .F.)
		cChave			:= 'B9_COD+DtoS(B9_DATA)'
		cCondicao 		:= ''
		IndRegua("SB9", cIndex, cChave, , cCondicao)
		nNewIndSB9 := RetIndex("SB9")
		DbSelectArea("SB9")
		#IFNDEF TOP
			dbSetIndex(cArqTrbSB9+OrdBagExt())
		#ENDIF
		dbSetOrder(nNewIndSB9+1)
		dbGoTop()
		SB9->(DbSeek((_cAlias)->B2_COD))
	Else
		SB9->(DbSeek(xFilial("SB9")+(_cAlias)->B2_COD+(_cAlias)->B2_LOCAL))
	EndIf
	
	dDTSB9 := SB9->B9_DATA
	While SB9->B9_COD == (_cAlias)->B2_COD .and. dDTSB9 == SB9->B9_DATA .and. !SB9->(Eof())
		If !Empty(cLocal) 
			If (_cAlias)->B2_LOCAL <> SB9->B9_LOCAL
	 			SB9->(DbSkip())
	 			Loop
	 		EndIf	
		EndIf
		If (_cAlias)->B9_QISEGUM <> 0
			_nSldIni := (_cAlias)->B9_QISEGUM
			If !Empty((_cAlias)->D1_DTDIGIT)
				If (_cAlias)->D1_DTDIGIT <= (_cAlias)->B9_DATA
					_nSldIni := 0
				EndIf
			EndIf
			If !Empty((_cAlias)->D2_EMISSAO)
				If (_cAlias)->D2_EMISSAO <= (_cAlias)->B9_DATA
					_nSldIni := 0
				EndIf
			EndIf
			If !Empty((_cAlias)->D3_EMISSAO)
				If (_cAlias)->D3_EMISSAO <= (_cAlias)->B9_DATA
					_nSldIni := 0
				EndIf
			EndIf
		EndIf
		_nSaldo += _nSldIni  
//		Alert("Saldo Inicial => "+Str(_nSldIni,12,2))
//		Alert("Saldo Consolidado => "+Str(_nSaldo,12,2))
		SB9->(DbSkip())
	End
	_nSaldo := Round( _nSaldo + (_cAlias)->SD1_ENTRADAS + (_cAlias)->SD3_ENTRADAS - (_cAlias)->SD2_SAIDAS - (_cAlias)->SD3_SAIDAS,4)

//	Alert("Saldo Final => "+Str(_nSaldo,12,2))
	
EndIf

DbcloseArea(_cAlias)

RestArea(_aArea)

Return( _nSaldo )