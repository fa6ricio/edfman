#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA410   บAutor  ณLuis Felipe Nascimento ณ Data  ณ24/06/2013บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ Valida็ใo da tela toda no Pedido de Venda                  บฑฑ
ฑฑบDesc.     ณ                                               			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบPrograma  ณ MTA410     บAutor  ณLeandro Ribeiro   บ Data ณ  13/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para valida็ใo do acols, para verificar se o usuarioบฑฑ
ฑฑบ          ณ realizou alguma altera็ใo em um ou mas itens da remessa    บฑฑ
ฑฑบ          ณ para devolu็ใo.											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTA410()

Local lRet   	:= .T.
Local nPLiq		:= 0
Local nPBru		:= 0
Local nPVol     := 0
Local nVolume	:= 0 
Local cTes  	:= Space(3)

For n_x := 1 to Len(aCols)
	If acols[n_x][Len(aHeader)+1] == .F.
		nPLiq += GdFieldGet("C6_XPESO"  ,n_x)
		nPBru += GdFieldGet("C6_XPESOBR",n_x)
		nPVol += GdFieldGet("C6_XQTDEM1",n_x)
	Endif
Next

M->C5_PESOL   := nPLiq
M->C5_PBRUTO  := nPBru
M->C5_VOLUME1 := nPVol

// DESABILITADO PARA ANALISE - 18/10/13
Return( lRet )

If Empty(M->C5_XNCONTR)
	Return( lRet )
EndIf

If(M->C5_TIPO == "D" .AND. !EMPTY(M->C5_XNCONTR))
	
	If INCLUI == .F. .AND. ALTERA == .T.
	
		lRet:=  EDFA004C() 
		If(!lRet)
			Aviso("Aviso","Por medidade de seguran็a e integridade dos dados, a ED&F MAN solicitou o bloqueio das altera็๕es ap๓s a confirma็ใo dos itens selecionados !",{"OK"})
		EndIf
	    
	EndIF
	
EndIf

RETURN(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA004C    บAutor  ณLeandro Ribeiro   บ Data ณ  13/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para valida็ใo do acols, para verificar se o usuarioบฑฑ
ฑฑบ          ณ realizou alguma altera็ใo em um ou mas itens da remessa    บฑฑ
ฑฑบ          ณ para devolu็ใo.											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EDFA004C()

Local _cEDFA004C := GetArea()
Local __xRet 	 := .T.
Local _cQuery3 	 := ""
Local _cAliasAc  := GetNextAlias()
Local _cxItens	 := {}
Local _Position  := {}
Local _cTesFis	 := Alltrim(SuperGetMV("MV_XTESFIS",.t.,"501"))
Local _cTesDev	 := Alltrim(SuperGetMV("MV_XTESDEV",.t.,"507"))

Local nPosProd := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})
Local nPosUnid := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_UM"})
Local nPosQTDV := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDVEN"})
Local nPosPrcv := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})
Local nPosVal  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_VALOR"})
Local nPosQTDL := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDLIB"})
Local nPosTES  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_TES"})
Local nPosNori := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_NFORI"})
Local nPosSeOr := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_SERIORI"})
Local nPosItem := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_ITEMORI"})

Local cTes     := GdFieldGet("C6_TES",n)
Local __cTipoDev := If(cTes==_cTesFis,"1","2")

Aadd(_Position,{nPosProd,nPosUnid,nPosQTDV,nPosPrcv,nPosVal,nPosQTDL,nPosTES,nPosNori,nPosSeOr,nPosItem})

_cQuery3 := " SELECT D1_DOC,D1_COD,D1_UM,D1_VUNIT,ZD_NFREMES,ZD_SERIER,ZD_LOCAL,D1_ITEM, MIN(ZD_SALDO) AS MINIMO " + c_ent
_cQuery3 += " FROM" +RETSQLNAME("SZD")+" SZD" + c_ent
_cQuery3 += " INNER JOIN "+RETSQLNAME("SD1")+" SD1" + c_ent
_cQuery3 += " ON ZD_FILIAL = D1_FILIAL" + c_ent
_cQuery3 += " AND ZD_NFREMES = D1_DOC" + c_ent
_cQuery3 += " AND ZD_SERIER = D1_SERIE" + c_ent
_cQuery3 += " WHERE" + c_ent
_cQuery3 += " ZD_FILIAL = '"+xFilial("SZD")+"'" + c_ent
_cQuery3 += " AND ZD_QTDREC < ZD_QTDNFRE " + c_ent
_cQuery3 += " AND ZD_SALDO <> 0 " + c_ent
_cQuery3 += " AND ZD_STATUS <> 'BX' " + c_ent
_cQuery3 += " AND D1_FORNECE = (SELECT A2_COD
_cQuery3 += " FROM" +RETSQLNAME("SA2")+" SA2" + c_ent
_cQuery3 += " WHERE" + c_ent
_cQuery3 += " A2_CGC = (SELECT ZD_CNPJUSI" + c_ent
_cQuery3 += " FROM" +RETSQLNAME("SZD")+" SZD" + c_ent
_cQuery3 += " WHERE" + c_ent
_cQuery3 += " ZD_FILIAL = '"+xFilial("SZD")+"'" + c_ent
_cQuery3 += " AND ZD_CONTRA = '"+SZD->ZD_CONTRA+"'" + c_ent
_cQuery3 += " AND D_E_L_E_T_ = ''" + c_ent
_cQuery3 += " GROUP BY ZD_CNPJUSI)" + c_ent
_cQuery3 += " AND D_E_L_E_T_ = '')" + c_ent
_cQuery3 += " AND SD1.D_E_L_E_T_ = ' '" + c_ent
_cQuery3 += " AND SZD.D_E_L_E_T_ = ' '" + c_ent
_cQuery3 += " GROUP BY D1_DOC, D1_COD,D1_UM,D1_VUNIT,ZD_NFREMES,ZD_SERIER,ZD_LOCAL,D1_ITEM" + c_ent
_cQuery3 := ChangeQuery(_cQuery3)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAliasAc,.T.,.T.)

DbSelectArea(_cAliasAc)
If(!Eof())
	While (!Eof())
		Aadd(_cxItens,{(_cAliasAc)->D1_COD,(_cAliasAc)->D1_UM,(_cAliasAc)->MINIMO,(_cAliasAc)->D1_VUNIT,;
		ROUND((_cAliasAc)->D1_VUNIT * (_cAliasAc)->MINIMO,2),(_cAliasAc)->MINIMO,If(__cTipoDev=="1",_cTesFis,_cTesDev),(_cAliasAc)->ZD_NFREMES,;
		(_cAliasAc)->ZD_SERIER,(_cAliasAc)->D1_ITEM })
		DbSkip()
	Enddo
EndIf

For _cx := 1 to Len(aCols)
	For _dx := 1 to Len(_Position[1])
		If!(aCols[_cx][_Position[1][_dx]] == _cxItens[_cx][_dx])
			__xRet := .F.
		EndIf
	Next _dx
Next _cx

DbCloseArea()

RestArea(_cEDFA004C)

Return(__xRet)
