#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE   c_ent      CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFGATIL ºAutor  ³ Luis Felipe Nasc.  º Data ³  27/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Conjunto de gatilhos executadas a partir do campo de vali- º±±
±±º          ³ dações do usuário no dicionário de dados.                  º±±
±±º          ³                                                			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFG001()

M->E2_VLFINAL := M->E2_QTDTON * M->E2_PREPAGO
M->E2_PREPGR  := M->E2_TXUSD  * M->E2_PREPAGO
M->E2_VLORIG  := M->E2_QTDTON * M->E2_PREPGR
M->E2_VALOR	  := (M->E2_QTDTON * M->E2_PREPGR) + (M->E2_XVLAC1+M->E2_XVLAC2+M->E2_XVLAC3) - (M->E2_XVLDC1+M->E2_XVLDC2+M->E2_XVLDC3)
M->E2_VLCRUZ  := M->E2_VALOR

Return(GetdRefresh())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFG002 ºAutor  ³Luis Felipe Nascimento ³Data ³  15/04/15 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EDFG002                                                    º±±
±±º          ³ Certifica se foram embarcadas todas as quantidades do      º±±
±±º          ³ Contrato DP, para fins de calculo da Polarização.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*---------------------*
User Function EDFG002()
*---------------------*

Local aArea		:= GetArea()
Local nEmbarq	:= 0
Local nSomaPol  := 0
Local nMedia    := 0
Local lRetorno  := .T.
Local _nX       := 0
Local nSomaVal  := 0

oModelx := FWModelActive() 						//-> Carregando Model Ativo
oModelxDet := oModelx:GetModel('SZ3DETAIL') 	//-> Carregando grid de dados a partir o ID que foi instanciado no fonte.
nPosQuant := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_QUANT"})
nPosPolDp := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_POLDP"})
cPosCtrDp := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_CTRDP"})
nLinPos := oModelxDet:NLINE
nPolDP := oModelxDet:ADATAMODEL[nLinPos][1][1][nPosPolDp]
cContraDP := oModelxDet:ADATAMODEL[nLinPos][1][1][cPosCtrDp]

nSomaVal := 0
For _nX	:= 1 To Len(oModelxDet:ADATAMODEL)
	nSomaVal += If(_nX<>nLinPos,oModelxDet:ADATAMODEL[_Nx][1][1][nPosQuant],M->Z3_QUANT)
Next

If nSomaVal > M->CN9_QTDTOT
	MsgAlert("Não é possível incluir e ou alterar a quantidade contratada do cronograma, pois o somatório de todos os Contratos DP "+ Alltrim(Str(nSomaVal)) +" é maior do que o total do Contrato:"+ Alltrim(Str(M->CN9_QTDTOT))+". Para tornar isso possível é preciso alterar o saldo total contratado." )
	Return( .f. )
EndIf

If Select("TMPEE9")>0
	dbSelectArea("TMPEE9")
	("TMPEE9")->(dbCloseArea())
EndIf

cQuery := "SELECT EE9_FILIAL, EE9_PREEMB, EE9_PEDIDO, EE9_COD_I, (EE9_PSLQTO / 1000) EE9_PSLQTO, EE8_XPOLDP "
cQuery += "FROM "+RetSqlName("EE9") + " EE9, "+RetSqlName("EEC") + " EEC, "+RetSqlName("EE8") + " EE8 "
cQuery += "WHERE "
cQuery += "EE9.EE9_FILIAL = EEC.EEC_FILIAL AND "
cQuery += "EE9.EE9_PREEMB = EEC.EEC_PREEMB AND "
cQuery += "EE9.EE9_FILIAL = EE8.EE8_FILIAL AND "
cQuery += "EE9.EE9_PEDIDO = EE8.EE8_PEDIDO AND "
cQuery += "EE9.EE9_COD_I  = EE8.EE8_COD_I AND "
cQuery += "EE9.EE9_COD_I  = '"+cContraDP+"' AND "
cQuery += "EE8.D_E_L_E_T_ = '' AND "
cQuery += "EE9.D_E_L_E_T_ = '' AND "
cQuery += "EEC.D_E_L_E_T_ = '' "

MemoWrite("C:\Tmp\EDFG002.txt",cQuery)

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPEE9",.F.,.T.)

DBSELECTAREA("TMPEE9")
("TMPEE9")->(DbGoTop())

If ("TMPEE9")->(!EOF())
	nEmbarq	 := 0
	nSomaPol := 0
	lPol	 := .t.
	While ("TMPEE9")->(!Eof())
		If !Empty(("TMPEE9")->EE8_XPOLDP)
			nSomaPol += (("TMPEE9")->EE8_XPOLDP/100) * (("TMPEE9")->EE9_PSLQTO / M->Z3_QUANT)
			nEmbarq  += ("TMPEE9")->EE9_PSLQTO
		Else
			lPol	:= .f.
		EndIf
		("TMPEE9")->(DbSkip())
	End
	If nEmbarq >= M->Z3_QUANT .and. lRetorno .and. lPol
		nMedia := nSomaPol * 100
		If	nMedia > 0 .and. nMedia <> nPolDP
//			GdFieldPut("Z3_POLDP",nMedia,n)
			u_EDFV002("CRONOGRAMA") // Falta corrigir essa rotina
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return( nMedia )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFG003 ºAutor  ³ Luis Felipe Nasc.  º Data ³  13/01/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca próximo sequencial da Invoic.                        º±±
±±º          ³ Tratamento especial para o ano de 2017 pois já havia inici-º±±
±±º          ³ ado                                             			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*---------------------*
User Function EDFG003()
*---------------------*

Local aArea		:= GetArea()
Local cAlias	:= GetNextAlias()
Local nProx		:= '00001'
Local cQuery	:= ''

If Select(cAlias)>0
	dbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
EndIf

cQuery := " Select Max(EXP_XINCIN) EXP_XINCIN"
cQuery += " From "+RetSqlName("EXP")
cQuery += " Where D_e_l_e_t_ = ''"
cQuery += " And Year(EXP_DTINVO) = '"+Str(Year(dDatabase),4)+"'"
If Year(Ddatabase) == 2017
	cQuery += "	And SubString(EXP_XINCIN,1,4) Not In ('INVC')"
	cQuery += "	And EXP_XINCIN Not In ('00029','00987','00988','00989','00990','00991','00992','00993','00994','00995','00996','00997','00998','00999','01000','01001','01002','01003','01004','01005')"
EndIf

MemoWrite("C:\Tmp\EDFG003.txt",cQuery)

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)

nProx := Soma1((cAlias)->EXP_XINCIN)
If Year(Ddatabase) == 2017 .and. nProx == '00987'
	nProx := '01006'
EndIf

(cAlias)->(DbCloseArea())

RestArea(aArea)

Return( nProx )