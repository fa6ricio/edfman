#INCLUDE "protheus.ch"
#include "TopConn.ch"
#include "TbiConn.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFVALIDºAutor  ³Luis Felipe Nascimento ³Data ³  12/07/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validações executadas a partir do X3_VLDUSR                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EDFV001                                                    º±±
±±º          ³ Executado a partir do campo X3_PERDE                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFV001 ºAutor  ³Luis Felipe Nascimento ³Data ³  14/07/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preenche os campos de formação do preço.                   º±±
±±º          ³ (Precificação)                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EDFV001                                                    º±±
±±º          ³ Executado a partir do campo Z5_PERDE                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------------*
User Function EDFV001(_cContra,_cDP)
*----------------------------------*

Local aArea := GetArea()

SZ3->(DbSetOrder(1))
SZ3->(DbSeek(xFilial("SZ3")+_cContra+_cDP))

M->Z5_PREMIO1 := SZ3->Z3_PREMIO1
M->Z5_PREMIO2 := SZ3->Z3_PREMIO2
M->Z5_PREMIO3 := SZ3->Z3_PREMIO3
M->Z5_PREMIO4 := SZ3->Z3_PREMIO4 // Elevação em R$
M->Z5_PREMIO5 := SZ3->Z3_PREMIO5
M->Z5_PREMIO6 := SZ3->Z3_PREMIO6
M->Z5_PREMIO7 := SZ3->Z3_PREMIO7
M->Z5_ELEVAC  := SZ3->Z3_ELEVAC  // US$
M->Z5_LOTEPER := SZ3->Z3_QTDLOT
M->Z5_SALOT	  := SZ3->Z3_QTDLOT
M->Z5_SALDO	  := SZ3->Z3_QUANT
M->Z5_QTDEPER := SZ3->Z3_QUANT

RestArea(aArea)

Return( .t. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFV002 ºAutor  ³Luis Felipe Nascimento ³Data ³  14/07/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do Preço                                           º±±
±±º          ³ (Precificação)                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ EDFV001                                                    º±±
±±º          ³ Executado a partir do campo Z6_PRICING                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                         08/01/2015  º±±
±±º          ³ A RDM_043 gerou a alteração da rotina que antes era exe-   º±±
±±º          ³ cutada a partir da confirmação de dos pontos distintos,    º±±
±±º          ³ alterações no cronograma do contrato e alterações na pre-  º±±
±±º          ³ cificação dos contratos, para dois novos pontos. Na confir-º±±
±±º          ³ mação das alterações do contrao e da rotina de copia dos   º±±
±±º          ³ contratos de compra p/ compra ou para vendas. Com isso,    º±±
±±º          ³ tornou-se necessário criar dois novos parâmetros os quais  º±±
±±º          ³ permitirão o recalculo dos contratos de compra e vendas    º±±
±±º          ³ a partir do informe do Contrato e DP.                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                         13/03/2015  º±±
±±º          ³ O recalculo da media dos preços e do valor final ocorria   º±±
±±º          ³ apenas ao se confirmar o Pricing. Como o número de lotes   º±±
±±º          ³ faz parte do calculo foi necessário recalcular os precos   º±±
±±º          ³ também a partir desse.                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                         08/04/2015  º±±
±±º          ³ Recalculo do preço final a partir da confirmação da        º±±
±±º          ³ polarização nos embarques.                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                         25/06/2015  º±±
±±º          ³ Adequação da rotina a fim de recalcular os Contratos de    º±±
±±º          ³ Vendas a partir da confirmação das polarizações digitadas  º±±
±±º          ³ nos cronogramas do contrato. (ORIGEM CRONOGRAMA)           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                         04/12/2015  º±±
±±º          ³ Adequação da rotina para fins de calculo dos Contratos     º±±
±±º          ³ em Real. Posicionamento CN9 e exclusão da Mult. 22.0462    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                         23/12/2016  º±±
±±º          ³ Contratos de vendas não estão sendo convertidos pelo fator º±±
±±º          ³ 22.0462                                                    º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºAlteracao ³ Luis Felipe Nascimento                         12/01/2017  º±±
±±º          ³ O desconto de elevação estva sendo calculado apenas para osº±±
±±º          ³ preços de contratos em Dolar. Z5_PREMIO4 Real e Z5_ELEVAC  º±±
±±º          ³ US$.                                                       º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºAlteracao ³ Luis Felipe Nascimento                         21/08/2017  º±±
±±º          ³ Respons.: Guilherme Figueredo                              º±±
±±º          ³ Adicionar mais uma crítica aos calculos da Precificação dosº±±
±±º          ³ contratos de bolsa NY para permitir ou não a multiplicação º±±
±±º          ³ por 22.0462. Tela FX = Não calcula                         º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------------------------------*
User Function EDFV002(cOrigem,cCampo,cContra,cDp,nPol)
*----------------------------------------------------*

Local aArea 	:= GetArea()
Local nPosPric  := 0
Local nPosMdCts := 0
Local nPosPreco := 0
Local nPosVlFin := 0
Local nPosLote  := 0
Local nPosQtde  := 0
Local nPosStat  := 0
Local nPosCtrl	:= 0
Local nPosTipo	:= 0
Local nPosMedia := 0
Local nPosPerde := 0
Local nPosContra:= 0
Local nTamHeader:= 0

Local nMediaCts := 0
Local nPrcFob 	:= 0
Local nLotes 	:= 0
Local nQtde   	:= 0
Local nLidas 	:= 0
Local cControl	:= ""
Local nPreco	:= 0
Local cZ6_MEDIA := 0
Local cQuery 	:= ""
Local cAlias	:= GetNextAlias()
Local lContinua	:= .T.
Local nVlFinal	:= 0

Default cOrigem := "CRONOGRAMA"
Default cCampo	:= ""
Default nPol 	:= 0

If cOrigem == "PRECIFICACAO"
	*-------------------------------------------------------------------------------*
	* 20/08/13 - Luís Felipe Nascimento                                             *
	* Criado campo Z7_CONTROL para ajustar a rotina de recalculo das Precificações, *
	* quando ainda não houver Pedido de Compras gerado.                             *
	*-------------------------------------------------------------------------------*
	
	nPosPric  	:= GdFieldPos("Z6_PRICING")
	nPosMdCts 	:= GdFieldPos("Z6_MDCENTS")
	nPosPreco 	:= GdFieldPos("Z6_PRECO")
	nPosVlFin 	:= GdFieldPos("Z6_VLFINAL")
	nPosLote  	:= GdFieldPos("Z6_LOTE")
	nPosQtde  	:= GdFieldPos("Z6_QTDE")
	nPosStat  	:= GdFieldPos("Z6_STATUS")
	nPosCtrl	:= GdFieldPos("Z6_CTRLSZ7")
	nPosTipo	:= GdFieldPos("Z6_TIPOPRE")
	nPosMedia 	:= GdFieldPos("Z6_MEDIA")
	nPosPerde 	:= GdFieldPos("Z6_PERDE")
	nPosContra	:= GdFieldPos("Z6_CONTRA")
	nTamHeader	:= Len(aHeader)+1
	
	If !Empty(aCols[n][nPosCtrl])
		DbSelectArea("SZ7")
		DbSetOrder(4)
		If DbSeek(xFilial("SZ7")+aCols[n][nPosCtrl])
			cControl := aCols[n][nPosCtrl]
			If SZ7->Z7_QTDE == SZ7->Z7_SALDO
				RecLock("SZ7",.f.)
				Delete
				MsUnLock()
				For nX:=1 to Len(aCols)
					If aCols[nX][nPosCtrl] == cControl
						If aCols[n][nPosTipo] == aCols[nX][nPosTipo]
							aCols[nX][nPosStat] := "1"
							aCols[nX][nPosCtrl] := ""
						EndIf
					EndIf
				Next
			Else
				Aviso("Atencao", "Não é permitido recalcular o preço de um lote quando este já tiver parte do saldo consumido ! Ou seja, já existe um Pedido de Compras gerado para este lote.", {"Voltar"})
				Return( .f. )
			EndIf
		EndIf
	EndIf
	
	If cCampo == "Z6_TOTTONS"
		GetdRefresh()
		RestArea(aArea)
		Return( .t. )
	EndIf
	
	CN9->(DbSetOrder(1))
	CN9->(DbSeek(xFilial("CN9")+GdFieldGet("Z6_CONTRA",n)))
	
	// Calculo da Media em Cents e Dollar
	For nX:=1 to Len(aCols)
		If !aCols[nX][nTamHeader]
			If aCols[nX][nPosMedia] == aCols[n][nPosMedia] .And. aCols[n][nPosTipo] == aCols[nX][nPosTipo]
				// 13/03/15 - Luis Felipe Nascimento - Inicio
				/*
				If aCols[nX][nPosMedia] == aCols[n][nPosMedia] .And. aCols[n][nPosTipo] == aCols[nX][nPosTipo]
				nMediaCts += aCols[nX][nPosLote] * If(n==nX,M->Z6_PRICING,aCols[nX][nPosPric])
				nLotes       += If(n==nX,aCols[n][nPosLote] ,aCols[nX][nPosLote])
				nLidas 	  += 1
				EndIf
				*/
				If cCampo == "Z6_LOTE"
					nMediaCts += If(n==nX,M->Z6_LOTE,aCols[nX][nPosLote]) * aCols[nX][nPosPric]
					nLotes    += If(n==nX,M->Z6_LOTE,aCols[nX][nPosLote])
				Else // Z6_PRICING
					nMediaCts += If(n==nX,aCols[n][nPosLote] ,aCols[nX][nPosLote]) * If(n==nX,M->Z6_PRICING,aCols[nX][nPosPric])
					nLotes    += If(n==nX,aCols[n][nPosLote] ,aCols[nX][nPosLote])
				EndIf
				// 13/03/15 - Luis Felipe Nascimento - Fim
				nLidas 	  += 1
			EndIf
		EndIf
	Next
	
	// Cents
	nMediaCts := nMediaCts / nLotes
	
	// Atualização do campo Media Cents
	For nX:=1 to Len(aCols)
		If !aCols[nX][nTamHeader]
			If aCols[nX][nPosMedia] == aCols[n][nPosMedia] .And. aCols[nX][nPosTipo] == aCols[n][nPosTipo]
				aCols[nX][nPosMdCts] := nMediaCts
				//				aCols[nX][nPosPreco] := nMediaCts * IF(Alltrim(M->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1) // 23/12/16 - Luis Felipe
				//				aCols[nX][nPosPreco] := nMediaCts * IF(Alltrim(M->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1)  // Luis Felipe - 21/08/17
				aCols[nX][nPosPreco] := nMediaCts * IF(Alltrim(M->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(M->Z5_TELA)<>'FX' ,22.0462,1)
			EndIf
		EndIf
	Next
	
	// Calculo do Premio de Polarização (Premio Pol USD/Ton)
	
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+M->Z5_CONTRA+M->Z5_PERDE))
	
	//	M->Z5_POLDP := If(SZ3->Z3_POLDP<>0,(((nMediaCts+M->Z5_PREMIO7+M->Z5_PREMIO6)*IF(Alltrim(M->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1))+M->Z5_PREMIO1+M->Z5_PREMIO3)*(SZ3->Z3_POLDP/100),0) // 23/12/16 - Luis Felipe
	//	M->Z5_POLDP := If(SZ3->Z3_POLDP<>0,(((nMediaCts+M->Z5_PREMIO7+M->Z5_PREMIO6)*IF(Alltrim(M->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1))+M->Z5_PREMIO1+M->Z5_PREMIO3)*(SZ3->Z3_POLDP/100),0) // 21/08/17 - Luis Felipe
	M->Z5_POLDP := If(SZ3->Z3_POLDP<>0,(((nMediaCts+M->Z5_PREMIO7+M->Z5_PREMIO6)*IF(Alltrim(M->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(M->Z5_TELA)<>'FX' ,22.0462,1))+M->Z5_PREMIO1+M->Z5_PREMIO3)*(SZ3->Z3_POLDP/100),0)
	
	
	
	// Calculo do Preço Fob
	//	nPrcFob := (aCols[n][nPosPreco]+M->Z5_POLDP+M->Z5_PREMIO3+M->Z5_PREMIO1+((M->Z5_PREMIO6+M->Z5_PREMIO7))*IF(Alltrim(M->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1)) // 23/12/16 - Luis Felipe
	//	nPrcFob := (aCols[n][nPosPreco]+M->Z5_POLDP+M->Z5_PREMIO3+M->Z5_PREMIO1+((M->Z5_PREMIO6+M->Z5_PREMIO7))*IF(Alltrim(M->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1)) // 21/08/17 - Luis Felipe
	nPrcFob := (aCols[n][nPosPreco]+M->Z5_POLDP+M->Z5_PREMIO3+M->Z5_PREMIO1+((M->Z5_PREMIO6+M->Z5_PREMIO7))*IF(Alltrim(M->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(M->Z5_TELA)<>'FX',22.0462,1))
	
	// Calculo do Preco Final / Atualização do campo Media Cents
	For nX:=1 to Len(aCols)
		If !aCols[nX][nTamHeader]
			If aCols[nX][nPosMedia] == aCols[n][nPosMedia] .And. aCols[nX][nPosTipo] == aCols[n][nPosTipo]
				//				aCols[nX][nPosVlFin] := Round(nPrcFob+M->Z5_PREMIO5+M->Z5_ELEVAC+M->Z5_PREMIO2,2) // 12/01/17 - Luis Felipe
				aCols[nX][nPosVlFin] := Round(nPrcFob+M->Z5_PREMIO5+If(CN9->CN9_MOEDA = 2,M->Z5_ELEVAC,M->Z5_PREMIO4)+M->Z5_PREMIO2,2)
			EndIf
		EndIf
	Next
	
	GetdRefresh()
	
ElseIf cOrigem == "CRONOGRAMA"
	
/*  11/10/17 - Luis Felipe
	cContra 	:= GdFieldGet("Z3_CONTRA",n)
	cPeriodo	:= GdFieldGet("Z3_PERIODO",n)
*/
	oModelx := FWModelActive() 					
	oModelxDet := oModelx:GetModel('SZ3DETAIL') 
	nPosCtr := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_CONTRA"})
	nPosDP 	:= aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_PERIODO"})
	nLinPos := oModelxDet:NLINE
	cContra	:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosCtr]
	cPeriodo:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosDP]

	If cCampo == "Z3_POLDP"
		
		cQuery := "SELECT CASE WHEN Z5_SALOT = 0 THEN 'S' ELSE 'N' END AS LOTES "
		cQuery += "FROM "+RetSqlName("SZ3")+" SZ3,"+RetSqlName("SZ5")+" SZ5 "
		cQuery += "WHERE SZ3.D_E_L_E_T_ = '' "
		cQuery += "AND SZ5.D_E_L_E_T_ = '' "
		cQuery += "AND SZ3.Z3_CONTRA  = SZ5.Z5_CONTRA "
		cQuery += "AND SZ3.Z3_PERIODO = SZ5.Z5_PERDE "
		cQuery += "AND SZ3.Z3_CONTRA  = '"+cContra+"' "
		cQuery += "AND SZ3.Z3_PERIODO = '"+cPeriodo+"' "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		If Select(cAlias) > 0
			If (cAlias)->LOTES == 'N'
				Alert("Não é permitido lançar a Polarização de um Contrato DP que ainda tenha lotes para fixar !")
				lContinua := .f.
			EndIf
		Else
			Alert("Não foi encontrada a precificação deste Contrato DP !")
			lContinua := .f.
		Endif
		
		(cAlias)->( dbCloseArea())
		
		If !lContinua
			RestArea(aArea)
			Return( lContinua )
		EndIf
	EndIf
	
/*  11/10/17 - Luis Felipe 
	nPREMIO1 	:= GdFieldGet("Z3_PREMIO1",n)
	nPREMIO2 	:= GdFieldGet("Z3_PREMIO2",n)
	nPREMIO3 	:= GdFieldGet("Z3_PREMIO3",n)
	nPREMIO4 	:= GdFieldGet("Z3_PREMIO4",n)
	nPREMIO5 	:= GdFieldGet("Z3_PREMIO5",n)
	nPREMIO6 	:= GdFieldGet("Z3_PREMIO6",n)
	nPREMIO7 	:= GdFieldGet("Z3_PREMIO7",n)
	nELEVAC  	:= GdFieldGet("Z3_ELEVAC",n)
*/	
	nPosPremio1 := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_PREMIO1"})
	nPosPremio2 := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_PREMIO2"})
	nPosPremio3 := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_PREMIO3"})
	nPosPremio4 := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_PREMIO4"})
	nPosPremio5 := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_PREMIO5"})
	nPosPremio6 := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_PREMIO6"})
	nPosPremio7 := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_PREMIO7"})
	nPosElevac  := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_ELEVAC"})
	nPosPol     := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_POLDP"})

	nPREMIO1 	:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosPremio1]
	nPREMIO2 	:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosPremio2]
	nPREMIO3 	:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosPremio3]
	nPREMIO4 	:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosPremio4]
	nPREMIO5 	:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosPremio5]
	nPREMIO6 	:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosPremio6]
	nPREMIO7 	:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosPremio7]
	nELEVAC 	:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosElevac]
	nPoldp	 	:= oModelxDet:ADATAMODEL[nLinPos][1][1][nPosPol]
	
	If cCampo == "Z3_POLDP"
//		nPoldp := If(SubStr(cContra,1,1)="S",M->Z3_POLDP,GdFieldGet("Z3_POLDP",n))
		nPoldp := If(SubStr(cContra,1,1)="S",M->Z3_POLDP,nPoldp)
	Else
//		nPoldp := GdFieldGet("Z3_POLDP",n)
		nPoldp := nPoldp
	EndIf
	
	SZ5->(DbSetOrder(1))
	If SZ5->(DbSeek(xFilial("SZ5")+cContra+cPeriodo))
		
		RecLock("SZ5",.f.)
		SZ5->Z5_PREMIO1 := nPREMIO1
		SZ5->Z5_PREMIO2 := nPREMIO2
		SZ5->Z5_PREMIO3 := nPREMIO3
		SZ5->Z5_PREMIO4 := nPREMIO4
		SZ5->Z5_PREMIO5 := nPREMIO5
		SZ5->Z5_PREMIO6 := nPREMIO6
		SZ5->Z5_PREMIO7 := nPREMIO7
		SZ5->Z5_ELEVAC  := nELEVAC
		Msunlock()
		
		CN9->(DbSetOrder(1))
		CN9->(DbSeek(xFilial("CN9")+cContra))
		
		SZ6->(DbSetOrder(1))
		SZ6->(DbSeek(xFilial("SZ6")+cContra+cPeriodo))
		
		// Calculo da Media em Cents e Dollar
		lAchou := .f.
		While cContra+cPeriodo == SZ6->(Z6_CONTRA+Z6_PERDE) .and. !Eof()
			If SubStr(cContra,1,1) == "S" // Vendas
				nRegAtu  := SZ6->(Recno())
				cControl := SZ6->Z6_CONTROL
				cChave	 := "P"+SubStr(cContra,2,14)+cPeriodo+SZ6->Z6_ITEM
				If !SZ6->(DbSeek(xFilial("SZ6")+cChave)) .or. SZ6->(DbSeek(xFilial("SZ6")+cChave)) .and. SZ6->Z6_CONTROL <> cControl
					SZ6->(DbGoto(nRegAtu))
					If SZ6->Z6_TIPOPRE == "2" .and. !lAchou
						cZ6_MEDIA := SZ6->Z6_MEDIA
						lAchou := .t.
					EndIf
					If SZ6->Z6_TIPOPRE == "2" .and. cZ6_MEDIA == SZ6->Z6_MEDIA
						nMediaCts += SZ6->Z6_LOTE * SZ6->Z6_PRICING
						nLotes    += SZ6->Z6_LOTE
						nLidas 	  += 1
					EndIf
				EndIf
				SZ6->(DbGoto(nRegAtu))
			Else // Compras
				If SZ6->Z6_TIPOPRE == "2" .and. !lAchou
					cZ6_MEDIA := SZ6->Z6_MEDIA
					lAchou := .t.
				EndIf
				If SZ6->Z6_TIPOPRE == "2" .and. cZ6_MEDIA == SZ6->Z6_MEDIA
					nMediaCts += SZ6->Z6_LOTE * SZ6->Z6_PRICING
					nLotes    += SZ6->Z6_LOTE
					nLidas 	  += 1
				EndIf
			EndIf
			SZ6->(DbSkip())
		End
		
		// Cents
		nMediaCts := nMediaCts / nLotes
		
		// Atualização do campo Media Cents
		
		SZ6->(DbSeek(xFilial("SZ6")+cContra+cPeriodo))
		
		While cContra+cPeriodo == SZ6->(Z6_CONTRA+Z6_PERDE) .and. !Eof()
			If SubStr(cContra,1,1) == "S" // Vendas
				nRegAtu  := SZ6->(Recno())
				cControl := SZ6->Z6_CONTROL
				cChave	 := "P"+SubStr(cContra,2,14)+cPeriodo+SZ6->Z6_ITEM
				If !SZ6->(DbSeek(xFilial("SZ6")+cChave)) .or. SZ6->(DbSeek(xFilial("SZ6")+cChave)) .and. SZ6->Z6_CONTROL <> cControl
					SZ6->(DbGoto(nRegAtu))
					If SZ6->Z6_TIPOPRE == "2" .and. cZ6_MEDIA == SZ6->Z6_MEDIA
						RecLock("SZ6",.f.)
						SZ6->Z6_MDCENTS := nMediaCts
						//						SZ6->Z6_PRECO 	:= nMediaCts * IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1) // 23/12/16 -  Luis Felipe
						//						SZ6->Z6_PRECO 	:= nMediaCts * IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1)
						SZ6->Z6_PRECO 	:= nMediaCts * IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(SZ5->Z5_TELA)<>'FX' ,22.0462,1) // 21/08/17 - Luis Felipe
						MsunLock()
						nPreco := SZ6->Z6_PRECO
					EndIf
				EndIf
				SZ6->(DbGoto(nRegAtu))
			Else // Compras
				If SZ6->Z6_TIPOPRE == "2" .and. cZ6_MEDIA == SZ6->Z6_MEDIA
					RecLock("SZ6",.f.)
					SZ6->Z6_MDCENTS := nMediaCts
					//					SZ6->Z6_PRECO 	:= nMediaCts * IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1) // 23/12/16 -  Luis Felipe
					//					SZ6->Z6_PRECO 	:= nMediaCts * IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1)  // 21/08/17 - Luis Felipe
					SZ6->Z6_PRECO 	:= nMediaCts * IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(SZ5->Z5_TELA)<>'FX',22.0462,1)
					MsunLock()
					nPreco := SZ6->Z6_PRECO
				EndIf
			EndIf
			SZ6->(DbSkip())
		End
		
		// Calculo do Premio de Polarização (Premio Pol USD/Ton)
		If cCampo == "Z3_POLDP"
			//			nPoldp := If(M->Z3_POLDP<>0,(((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(M->Z3_POLDP/100),0) // 23/12/16 -  Luis Felipe
			//			nPoldp := If(M->Z3_POLDP<>0,(((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(M->Z3_POLDP/100),0) // 21/08/17 - Luis Felipe
			nPoldp := If(M->Z3_POLDP<>0,(((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(SZ5->Z5_TELA)<>'FX',22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(M->Z3_POLDP/100),0)
		Else
			//			nPoldp := If(nPoldp<>0,(((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(nPoldp/100),0) // 23/12/16 -  Luis Felipe
			//			nPoldp := If(nPoldp<>0,(((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(nPoldp/100),0) // 21/08/17 - Luis Felipe
			nPoldp := If(nPoldp<>0,(((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(SZ5->Z5_TELA)<>'FX',22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(nPoldp/100),0)
		EndIf
		RecLock("SZ5",.f.)
		SZ5->Z5_POLDP := nPoldp
		Msunlock()
		
		// Calculo do Preço Fob
		//		nPrcFob := (nPreco+SZ5->Z5_POLDP+SZ5->Z5_PREMIO3+SZ5->Z5_PREMIO1+((SZ5->Z5_PREMIO6+SZ5->Z5_PREMIO7))*IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1)) // 23/12/16 -  Luis Felipe
		//		nPrcFob := (nPreco+SZ5->Z5_POLDP+SZ5->Z5_PREMIO3+SZ5->Z5_PREMIO1+((SZ5->Z5_PREMIO6+SZ5->Z5_PREMIO7))*IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1)) // 21/08/17 - Luis Felipe
		nPrcFob := (nPreco+SZ5->Z5_POLDP+SZ5->Z5_PREMIO3+SZ5->Z5_PREMIO1+((SZ5->Z5_PREMIO6+SZ5->Z5_PREMIO7))*IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(SZ5->Z5_TELA)<>'FX',22.0462,1))
		
		// Calculo do Preco Final / Atualização do campo Media Cents
		
		SZ6->(DbSeek(xFilial("SZ6")+cContra+cPeriodo))
		
		While cContra+cPeriodo == SZ6->(Z6_CONTRA+Z6_PERDE) .and. !Eof()
			If SubStr(cContra,1,1) == "S" // Vendas
				nRegAtu  := SZ6->(Recno())
				cControl := SZ6->Z6_CONTROL
				cChave	 := "P"+SubStr(cContra,2,14)+cPeriodo+SZ6->Z6_ITEM
				If !SZ6->(DbSeek(xFilial("SZ6")+cChave)) .or. SZ6->(DbSeek(xFilial("SZ6")+cChave)) .and. SZ6->Z6_CONTROL <> cControl
					SZ6->(DbGoto(nRegAtu))
					If SZ6->Z6_TIPOPRE == "2" .and. cZ6_MEDIA == SZ6->Z6_MEDIA
						RecLock("SZ6",.f.)
						//						SZ6->Z6_VLFINAL := Round(nPrcFob+SZ5->Z5_PREMIO5+SZ5->Z5_ELEVAC+SZ5->Z5_PREMIO2,2) // 12/01/17 - Luis Felipe
						SZ6->Z6_VLFINAL := Round(nPrcFob+SZ5->Z5_PREMIO5+If(CN9->CN9_MOEDA = 2,SZ5->Z5_ELEVAC,SZ5->Z5_PREMIO4)+SZ5->Z5_PREMIO2,2)
						MsunLock()
					EndIf
				EndIf
				SZ6->(DbGoto(nRegAtu))
			Else  // Compras
				If SZ6->Z6_TIPOPRE == "2" .and. cZ6_MEDIA == SZ6->Z6_MEDIA
					RecLock("SZ6",.f.)
					//					SZ6->Z6_VLFINAL := Round(nPrcFob+SZ5->Z5_PREMIO5+SZ5->Z5_ELEVAC+SZ5->Z5_PREMIO2,2)  // 12/01/17 - Luis Felipe
					SZ6->Z6_VLFINAL := Round(nPrcFob+SZ5->Z5_PREMIO5+If(CN9->CN9_MOEDA = 2,SZ5->Z5_ELEVAC,SZ5->Z5_PREMIO4)+SZ5->Z5_PREMIO2,2)
					MsunLock()
				EndIf
			EndIf
			SZ6->(DbSkip())
		End
	EndIf
Else
	
	CN9->(DbSetOrder(1))
	CN9->(DbSeek(xFilial("CN9")+cContra))
	
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(xFilial("SZ3")+cContra+cDP))
	
	SZ5->(DbSetOrder(1))
	If SZ5->(DbSeek(xFilial("SZ5")+cContra+cDP))
		
		SZ6->(DbSetOrder(1))
		SZ6->(DbSeek(xFilial("SZ6")+cContra+cDP))
		
		nVlFinal := SZ6->Z6_VLFINAL
		
		// Calculo da Media em Cents e Dollar
		lAchou := .f.
		While cContra+cDP == SZ6->(Z6_CONTRA+Z6_PERDE) .and. !Eof()
			If SZ6->Z6_TIPOPRE == "2" .and. !lAchou
				cZ6_MEDIA := SZ6->Z6_MEDIA
				lAchou := .t.
			EndIf
			If SZ6->Z6_TIPOPRE == "2" .and. cZ6_MEDIA == SZ6->Z6_MEDIA
				nMediaCts += SZ6->Z6_LOTE * SZ6->Z6_PRICING
				nLotes    += SZ6->Z6_LOTE
				nLidas 	  += 1
			EndIf
			SZ6->(DbSkip())
		End
		
		// Cents
		nMediaCts := nMediaCts / nLotes
		
		// Atualização do campo Media Cents
		
		SZ6->(DbSeek(xFilial("SZ6")+cContra+cDP))
		
		While cContra+cDP == SZ6->(Z6_CONTRA+Z6_PERDE) .and. !Eof()
			If SZ6->Z6_TIPOPRE == "2" .and. cZ6_MEDIA == SZ6->Z6_MEDIA
				RecLock("SZ6",.f.)
				SZ6->Z6_MDCENTS := nMediaCts
				//				SZ6->Z6_PRECO 	:= nMediaCts * IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1) // 23/12/16 -  Luis Felipe
				//				SZ6->Z6_PRECO 	:= nMediaCts * IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1) // 21/08/17 - Luis Felipe
				SZ6->Z6_PRECO 	:= nMediaCts * IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(SZ5->Z5_TELA)<>'FX' ,22.0462,1)
				MsunLock()
				nPreco := SZ6->Z6_PRECO
			EndIf
			SZ6->(DbSkip())
		End
		
		// Calculo do Premio de Polarização (Premio Pol USD/Ton)
		// 08/04/15 - Luis Felipe Nascimento - Inicio
		//	nPoldp := If(SZ5->Z5_POLDP<>0,(((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY",22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(SZ5->Z5_POLDP/100),0)
		If nPol == 0
			//			nPoldp := If(SZ3->Z3_POLDP<>0,(((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(SZ3->Z3_POLDP/100),0) // 23/12/16 -  Luis Felipe
			//			nPoldp := If(SZ3->Z3_POLDP<>0,(((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(SZ3->Z3_POLDP/100),0) // 21/08/17 - Luis Felipe
			nPoldp := If(SZ3->Z3_POLDP<>0,(((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(SZ5->Z5_TELA)<>'FX' ,22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(SZ3->Z3_POLDP/100),0)
		Else
			//			nPoldp := (((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(nPol/100) // 23/12/16 -  Luis Felipe
			//			nPoldp := (((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(nPol/100) // 21/08/17 - Luis Felipe
			nPoldp := (((nMediaCts+SZ5->Z5_PREMIO7+SZ5->Z5_PREMIO6)*IF(Alltrim(SZ5->Z5_BOLSA)="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(SZ5->Z5_TELA)<>'FX' ,22.0462,1))+SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3)*(nPol/100)
		EndIf
		// 08/04/15 - Luis Felipe Nascimento - Fim
		
		RecLock("SZ5",.f.)
		SZ5->Z5_POLDP := nPoldp
		Msunlock()
		
		// Calculo do Preço Fob
		//		nPrcFob := (nPreco+SZ5->Z5_POLDP+SZ5->Z5_PREMIO3+SZ5->Z5_PREMIO1+((SZ5->Z5_PREMIO6+SZ5->Z5_PREMIO7))*IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. SubStr(CN9->CN9_NUMERO,1,1) == "P",22.0462,1)) // 23/12/16 -  Luis Felipe
		//		nPrcFob := (nPreco+SZ5->Z5_POLDP+SZ5->Z5_PREMIO3+SZ5->Z5_PREMIO1+((SZ5->Z5_PREMIO6+SZ5->Z5_PREMIO7))*IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 ,22.0462,1)) // 21/08/17 - Luis Felipe
		nPrcFob := (nPreco+SZ5->Z5_POLDP+SZ5->Z5_PREMIO3+SZ5->Z5_PREMIO1+((SZ5->Z5_PREMIO6+SZ5->Z5_PREMIO7))*IF(Alltrim(SZ5->Z5_BOLSA)=="NY" .And. CN9->CN9_MOEDA = 2 .And. RTRIM(SZ5->Z5_TELA)<>'FX',22.0462,1))
		
		// Calculo do Preco Final / Atualização do campo Media Cents
		
		SZ6->(DbSeek(xFilial("SZ6")+cContra+cDP))
		
		While cContra+cDP == SZ6->(Z6_CONTRA+Z6_PERDE) .and. !Eof()
			If SZ6->Z6_TIPOPRE == "2" .and. cZ6_MEDIA == SZ6->Z6_MEDIA
				RecLock("SZ6",.f.)
				//				SZ6->Z6_VLFINAL := Round(nPrcFob+SZ5->Z5_PREMIO5+SZ5->Z5_ELEVAC+SZ5->Z5_PREMIO2,2) // 12/01/17 - Luis Felipe
				SZ6->Z6_VLFINAL := Round(nPrcFob+SZ5->Z5_PREMIO5+If(CN9->CN9_MOEDA = 2,SZ5->Z5_ELEVAC,SZ5->Z5_PREMIO4)+SZ5->Z5_PREMIO2,2)
				MsunLock()
			EndIf
			SZ6->(DbSkip())
		End
		
	EndIf
	
EndIf

RestArea(aArea)

Return( .t. )

// 29/09/15
// nPrcFob2:= (nMediaCts+SZ5->Z5_PREMIO6+SZ5->Z5_PREMIO7)* If(Alltrim(SZ5->Z5_BOLSA)='NY',22.0462,1) +SZ5->Z5_PREMIO1+SZ5->Z5_PREMIO3+SZ5->Z5_POLDP

