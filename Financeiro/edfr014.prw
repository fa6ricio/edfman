#INCLUDE "rwmake.ch"

#DEFINE cEnt	Chr(13)+Chr(10)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ FUNR021  ∫ Autor ≥ Luis Felipe Nascim.∫ Data ≥  04/09/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ RelatÛrio de Titulos a Pagar x Impostos                    ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function EDFR014()

Local cDesc1         := "Este programa tem como objetivo demonstrar os"
Local cDesc2         := "titulos a pagar e os impostos a este assossiados "
Local cDesc3         := "independente do status de sua baixa."
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {"Fornecedores","Natureza","Centro Custo","Vencto Real"}
Local cPerg          := "EDFR014"

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "EDFR014"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "EDFR014"
Private titulo       := "RelatÛrio de Titulos a Pagar x Impostos"
Private nLin         := 80
Private Cabec1       := " FL   TP  NATUREZA                   TITULO PRX PC FORNECE LJ NREDUZ                 EMISSAO     VECNTO     V.REAL      BAIXA     VL. BRUTO VL. VALPIS VL. VALCOF VL.VALCSLL VL. VALISS VL.VALIRRF VL. VALINSS    VL. VALLIQ"
Private Cabec2       := "                                                           PREV.ENT   PREV.ENT   EMBARQUE   EMBARQUE CONTRAT. P.COMPRA       ENTREGUE       ALOCADOS       NAO ALOC       ENVIADA         ESTOQUE"
Private cString      := "SE2"

CriaSX1()

*------------------------------------*
*   Array das InformaÁıes do Excel   *
*------------------------------------*
Private aDadosExc := {}
Private aCabExc	  := {}

*-------------------------------------------------*
*   Chama FunÁ„o para Ajustar Par‚metros na SX1   *
*-------------------------------------------------*
Criasx1(cPerg)
If !Pergunte(cPerg,.T.)
	Return
EndIf

// Ordem por produto
If aReturn[8] == 1
	titulo := titulo+" - por Fornecedor"
ElseIf aReturn[8] == 2
	titulo := titulo+" - por Natureza"
ElseIf aReturn[8] == 3
	titulo := titulo+" - por Centro Custo"
ElseIf aReturn[8] == 4
	titulo := titulo+" - por Vencto Real"
EndIf

*-----------------------------------------------*
*   Monta a interface padrao com o usuario...   *
*-----------------------------------------------*
wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

*------------------------*
*   CabeÁalho do Excel   *
*------------------------*
aCabExc := {"FILIAL",; 	// 1
"TIPO",;				// 2
"NATUREZA",;			// 3
"TITULO",;				// 4
"PREFIXO",;				// 5
"PARC",;				// 6
"FORNECE",;				// 7
"LOJA",;				// 8
"NREDUZ",;				// 9
"EMISSAO",;				// 10
"VECNTO",;				// 11
"VENTOCREAL",;			// 12
"BAIXA",;				// 13
"VALBRUTO",;			// 14
"VALPIS",;				// 15
"VALCOF",;				// 16
"VALCSLL",;				// 17
"VALISS",;				// 18
"VALIRRF",;				// 19
"VALINSS",;				// 20
"VALLIQ",;				// 21
"NUM_CHEQUE",;			// 22
"HISTORICO",;			// 23
"CENTRO_CUSTO"}			// 24

Processa({|lEnd| EDFR014T (wnRel)})

Return

*-----------------------------*
Static Function EDFR014T(wnRel)
*-----------------------------*

Local cAliasQry := GetNextAlias()
Local cQuery    := ""
Local xQuebra

Private nCountnx:= 0
Private nCountny:= 1

Store 0 to nVALBRUTO,nVALPIS,nVALCOF,nVALCSLL,nVALISS,nVALIRRF,nVALINSS,nVALLIQ

_cQuery := " SELECT "+cEnt
_cQuery += " E2_FILORIG  AS FILIAL"+cEnt
_cQuery += " ,E2_TIPO    AS TIPO"+cEnt
_cQuery += " ,E2_NUM	 AS TITULO"+cEnt
_cQuery += " ,E2_PREFIXO AS PREFIXO"+cEnt
_cQuery += " ,E2_PARCELA AS PARC"+cEnt
_cQuery += " ,ED_DESCRIC AS NATUREZA"+cEnt
_cQuery += " ,E2_FORNECE AS FORNECE"+cEnt
_cQuery += " ,E2_LOJA    AS LOJA"+cEnt
_cQuery += " ,A2_NREDUZ  AS NOME"+cEnt
_cQuery += " ,E2_EMISSAO AS EMISSAO"+cEnt
_cQuery += " ,E2_VENCTO  AS VECNTO"+cEnt
_cQuery += " ,E2_VENCREA AS VENTOCREAL"+cEnt
_cQuery += " ,E2_BAIXA   AS BAIXA"+cEnt
_cQuery += " ,(E2_VALOR+E2_IRRF+E2_INSS+E2_ISS+E2_SEST) VALBRUTO"+cEnt
_cQuery += " ,ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'PIS'    AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) VALPIS"+cEnt
_cQuery += " ,ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'COFINS' AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) VALCOF"+cEnt
_cQuery += " ,ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'CSLL'   AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) VALCSLL"+cEnt
_cQuery += " ,ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'ISS'    AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) VALISS"+cEnt
_cQuery += " ,ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'IRF'    AND D_E_L_E_T_ <> '*' AND SUBSTRING(E2.E2_TITPAI,17,8) = (TITULO.E2_FORNECE+TITULO.E2_LOJA)),0) VALIRRF"+cEnt
_cQuery += " ,ISNULL((SELECT E2_VALOR FROM "+RetSqlName("SE2")+" E2 WHERE E2.E2_FILORIG = TITULO.E2_FILORIG AND E2.E2_NUM = TITULO.E2_NUM AND E2_TIPO IN ('TX ', 'ISS', 'INS') AND E2.E2_NATUREZ = 'INSS'   AND D_E_L_E_T_ <> '*'),0) VALINSS"+cEnt
_cQuery += " ,E2_VALOR   AS VALLIQ"+cEnt
_cQuery += " ,E2_NUMBCO  AS NUM_CHEQUE"+cEnt
_cQuery += " ,E2_HIST    AS HISTORICO"+cEnt
_cQuery += " ,E2_CCC	 AS CENTRO_CUSTO"+cEnt
_cQuery += " ,E2_NATUREZ"+cEnt
_cQuery += " FROM "+RetSqlName("SE2")+" TITULO, "+RetSqlName("SED")+" SED, "+RetSqlName("SA2")+" SA2"+cEnt
_cQuery += " WHERE TITULO.D_E_L_E_T_ <> '*'"+cEnt
_cQuery += " AND SED.D_E_L_E_T_ <> '*'"+cEnt
_cQuery += " AND SA2.D_E_L_E_T_ <> '*'"+cEnt
_cQuery += " AND E2_NATUREZ = ED_CODIGO"+cEnt
_cQuery += " AND E2_FORNECE = A2_COD"+cEnt
_cQuery += " AND E2_LOJA    = A2_LOJA"+cEnt

If !Empty(MV_PAR01) .and. !Empty(MV_PAR02)
	_cQuery += "	AND E2_FORNECE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"+cEnt
EndIf

If !Empty(MV_PAR03) .and. !Empty(MV_PAR04)
	_cQuery += "	AND E2_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"'"+cEnt
EndIf

If !Empty(MV_PAR05) .and. !Empty(MV_PAR06)
	_cQuery += "	AND E2_VENCREA BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"'"+cEnt
EndIf

If !Empty(MV_PAR07) .and. !Empty(MV_PAR08)
	_cQuery += "	AND E2_BAIXA BETWEEN '"+DtoS(MV_PAR07)+"' AND '"+DtoS(MV_PAR08)+"'"+cEnt
EndIf

If !Empty(MV_PAR09) .and. !Empty(MV_PAR10)
	_cQuery += "	AND E2_FILORIG BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"+cEnt
EndIf

If !Empty(MV_PAR11) .and. !Empty(MV_PAR12)
	_cQuery += "	AND E2_NUM BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'"+cEnt
EndIf

If !Empty(MV_PAR13) .and. !Empty(MV_PAR14)
	_cQuery += "	AND E2_NATUREZ BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"'"+cEnt
EndIf

If !Empty(MV_PAR15) .and. !Empty(MV_PAR16)
	_cQuery += "	AND E2_CCC BETWEEN '"+MV_PAR15+"' AND '"+MV_PAR16+"'"+cEnt
EndIf

If !Empty(MV_PAR17) .and. !Empty(MV_PAR18)
	_cQuery += "	AND E2_VALOR BETWEEN '"+Str(MV_PAR17,17,2)+"' AND '"+Str(MV_PAR18,17,2)+"'"+cEnt
EndIf

_cQuery += " AND E2_TIPO NOT IN ('TX ', 'ISS', 'INS')"+cEnt
_cQuery += " AND (E2_VRETPIS > 0 OR E2_VRETCOF > 0 OR E2_VRETCSL > 0 OR E2_IRRF > 0 OR E2_ISS > 0 OR E2_INSS > 0)"+cEnt

If aReturn[8] == 1
	_cQuery += " ORDER BY E2_FILORIG+E2_FORNECE"+cEnt
ElseIf aReturn[8] == 2
	_cQuery += " ORDER BY E2_FILORIG+E2_NATUREZ"+cEnt
ElseIf aReturn[8] == 3
	_cQuery += " ORDER BY E2_FILORIG+E2_CCC"+cEnt
ElseIf aReturn[8] == 4
	_cQuery += " ORDER BY E2_FILORIG+E2_VENCREA"+cEnt
EndIf

MemoWrite("C:\Tmp\EDFR014.txt",_cQuery)
_cQuery := ChangeQuery(_cQuery)

If Select(cAliasQry) > 0
	dbSelectArea(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAliasQry,.T.,.T.)

SB2->(DbSetOrder(1))

If (cAliasQry)->(!Eof())
	
	*-------------------------------*
	*   Conta Total de Registros.   *
	*-------------------------------*
	While (cAliasQry)->(!Eof())
		nCountnx ++
		(cAliasQry)->(DbSkip())
	EndDo
	(cAliasQry)->(DbGoTop())
	
	ProcRegua(nCountnx)
	IncProc("Processando Impress„o...")
	
	While (cAliasQry)->(!EOF())
		
		IncProc("Imprimindo RelatÛrio - "+Alltrim(STR(nCountny))+" de "+Alltrim(STR(nCountnx))+" Registros...")
		
		*-------------------------------------------*
		*  Verifica o cancelamento pelo usuario...  *
		*-------------------------------------------*
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		*--------------------------------------------*
		*  Impressao do cabecalho do relatorio. . .  *
		*--------------------------------------------*
		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 08
		Endif
		
		*--------------------------------------------*
		*  Quebra para a totalizacao ......          *
		*--------------------------------------------*
		If aReturn[8] == 1
			xQuebra := (cAliasQry)->FORNECE
		ElseIf aReturn[8] == 2
			xQuebra := (cAliasQry)->NATUREZA
		ElseIf aReturn[8] == 3
			xQuebra := (cAliasQry)->CENTRO_CUSTO
		ElseIf aReturn[8] == 4
			xQuebra := (cAliasQry)->VENTOCREAL
		EndIf

		@nLin,001 PSay (cAliasQry)->FILIAL
		@nLin,006 PSay (cAliasQry)->TIPO
		@nLin,010 PSay (cAliasQry)->NATUREZA
		@nLin,037 PSay (cAliasQry)->TITULO
		@nLin,044 PSay (cAliasQry)->PREFIXO
		@nLin,048 PSay (cAliasQry)->PARC	
		@nLin,051 PSay (cAliasQry)->FORNECE 	
		@nLin,059 PSay (cAliasQry)->LOJA        
		@nLin,062 PSay (cAliasQry)->NOME  	
		@nLin,083 PSay StoD((cAliasQry)->EMISSAO)   	Picture "@D"
		@nLin,093 PSay StoD((cAliasQry)->VECNTO)    	Picture "@D"
		@nLin,104 PSay StoD((cAliasQry)->VENTOCREAL)	Picture "@D"
		@nLin,115 PSay StoD((cAliasQry)->BAIXA)			Picture "@D"
		@nLin,126 PSay (cAliasQry)->VALBRUTO   			Picture "@E 99,999,999.99"
		@nLin,140 PSay (cAliasQry)->VALPIS     			Picture "@E 99,999,999.99"
		@nLin,151 PSay (cAliasQry)->VALCOF	   			Picture "@E 99,999,999.99"
		@nLin,162 PSay (cAliasQry)->VALCSLL		    	Picture "@E 99,999,999.99"
		@nLin,173 PSay (cAliasQry)->VALISS		    	Picture "@E 99,999,999.99"
		@nLin,184 PSay (cAliasQry)->VALIRRF		    	Picture "@E 99,999,999.99"
		@nLin,196 PSay (cAliasQry)->VALINSS		    	Picture "@E 99,999,999.99"
		@nLin,207 PSay (cAliasQry)->VALLIQ		    	Picture "@E 99,999,999.99"
		
		nLin++
		
		*--------------------------------------*
		*   Recebe Dados para GeraÁ„o do Excel *
		*--------------------------------------*
		aAdd(aDadosExc,{(cAliasQry)->FILIAL,;
		(cAliasQry)->TIPO,;
		(cAliasQry)->NATUREZA,;
		(cAliasQry)->TITULO,;
		(cAliasQry)->PREFIXO,;
		(cAliasQry)->PARC,;
		(cAliasQry)->FORNECE,;
		(cAliasQry)->LOJA,;
		(cAliasQry)->NOME,;
		StoD((cAliasQry)->EMISSAO),;
		StoD((cAliasQry)->VECNTO),;
		StoD((cAliasQry)->VENTOCREAL),;
		StoD((cAliasQry)->BAIXA),;
		(cAliasQry)->VALBRUTO,;
		(cAliasQry)->VALPIS,;
		(cAliasQry)->VALCOF,;
		(cAliasQry)->VALCSLL,;
		(cAliasQry)->VALISS,;
		(cAliasQry)->VALIRRF,;
		(cAliasQry)->VALINSS,;
		(cAliasQry)->VALLIQ,;
		(cAliasQry)->NUM_CHEQUE,;
		(cAliasQry)->HISTORICO,;
		(cAliasQry)->CENTRO_CUSTO})

		nVALBRUTO	+= (cAliasQry)->VALBRUTO
		nVALPIS  	+= (cAliasQry)->VALPIS  
		nVALCOF	 	+= (cAliasQry)->VALCOF	 
		nVALCSLL	+= (cAliasQry)->VALCSLL
		nVALISS		+= (cAliasQry)->VALISS	
		nVALIRRF	+= (cAliasQry)->VALIRRF
		nVALINSS	+= (cAliasQry)->VALINSS
		nVALLIQ		+= (cAliasQry)->VALLIQ		    	
				
		(cAliasQry)->(dbSkip())
		nCountny++
		
		If 	aReturn[8] == 2 .and. xQuebra <> (cAliasQry)->FORNECE .or.;
		   	aReturn[8] == 3 .and. xQuebra <> (cAliasQry)->NATUREZA .or.;
		   	aReturn[8] == 4 .and. xQuebra <> (cAliasQry)->CENTRO_CUSTO .or.;
	       	aReturn[8] == 5 .and. xQuebra <> (cAliasQry)->VENTOCREAL  
			nLin++
	  		@nLin,001 PSay Repl("-",220)
			nLin++
			@nLin,134 PSay nVALBRUTO Picture "@E 99,999,999.99"
			@nLin,149 PSay nVALPIS   Picture "@E 999,999.99"
			@nLin,164 PSay nVALCOF	 Picture "@E 999,999.99"
			@nLin,179 PSay nVALCSLL	 Picture "@E 999,999.99"
			@nLin,179 PSay nVALISS	 Picture "@E 999,999.99"
			@nLin,179 PSay nVALIRRF	 Picture "@E 999,999.99"
			@nLin,179 PSay nVALINSS	 Picture "@E 999,999.99"
			@nLin,179 PSay nVALLIQ	 Picture "@E 99,999,999.99"
			nLin++
			Store 0 to nVALBRUTO,nVALPIS,nVALCOF,nVALCSLL,nVALISS,nVALIRRF,nVALINSS,nVALLIQ
		Endif

	End
	
	*----------------------*
	*      Gera Excel      *
	*----------------------*
	//	aDadosExc := ASort(aDadosExc,,,{|x,y| DtoC(x[14])+x[12] < DtoC(y[14])+y[12]})
	If MsgYesNo("Deseja exportar para o Excel?")
		DlgToExcel({{"ARRAY","",aCabExc,aDadosExc}})
	EndIf
	
EndIf

*---------------------*
* Finaliza Impress„o  *
*---------------------*
SET DEVICE TO SCREEN
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

*           1          2      3                        4                       5                         6          7     8    9   10  11    12   13           14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38        39  40  41  42  43
AADD(aSx1,{"EDFR014" , "01" , "Fornecedor De......?" , "Fornecedor De......?" , "Fornecedor De......?" , "mv_ch1" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par01" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SA2"   , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "02" , "Fornecedor Ate.....?" , "Fornecedor Ate.....?" , "Fornecedor Ate.....?" , "mv_ch2" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par02" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SA2"   , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "03" , "Emissao De.........?" , "Emissao De.........?" , "Emissao De.........?" , "mv_ch3" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par03" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "04" , "Emissao Ate........?" , "Emissao Ate........?" , "Emissao Ate........?" , "mv_ch4" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par04" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "05" , "Vencto De..........?" , "Vencto De..........?" , "Vencto De..........?" , "mv_ch5" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par05" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "06" , "Vencto Ate.........?" , "Vencto Ate.........?" , "Vencto Ate.........?" , "mv_ch6" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par06" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "07" , "Baixa De ..........?" , "Baixa De ..........?" , "Baixa De ..........?" , "mv_ch7" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par07" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "08" , "Baixa Ate..........?" , "Baixa Ate..........?" , "Baixa Ate..........?" , "mv_ch8" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par08" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "09" , "Filial De..........?" , "Filial De..........?" , "Filial De..........?" , "mv_ch9" , "C" , 02 , 0 , 0 , "G" , "" , "mv_par09" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SM0"   , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "10" , "Filial Ate.........?" , "Filial Ate.........?" , "Filial Ate.........?" , "mv_cha" , "C" , 02 , 0 , 0 , "G" , "" , "mv_par10" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SM0"   , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "11" , "Num.Titulo De......?" , "Num.Titulo De......?" , "Num.Titulo De......?" , "mv_chb" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par11" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "12" , "Num.Titulo Ate.....?" , "Num.Titulo Ate.....?" , "Num.Titulo Ate.....?" , "mv_chc" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par12" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "13" , "Natureza De........?" , "Natureza De........?" , "Natureza De........?" , "mv_chd" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par13" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SED"   , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "14" , "Natureza Ate.......?" , "Natureza Ate.......?" , "Natureza Ate.......?" , "mv_che" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par14" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SED"   , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "15" , "Centro Custo De....?" , "Centro Custo De....?" , "Centro Custo De....?" , "mv_chf" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par15" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CTT"   , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "16" , "Centro Custo Ate...?" , "Centro Custo Ate...?" , "Centro Custo Ate...?" , "mv_chg" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par16" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CTT"   , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "17" , "Valor Bruto De.....?" , "Valor Bruto De.....?" , "Valor Bruto De.....?" , "mv_chh" , "N" , 17 , 2 , 0 , "G" , "" , "mv_par17" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})
AADD(aSx1,{"EDFR014" , "18" , "Valor Bruto Ate....?" , "Valor Bruto Ate....?" , "Valor Bruto Ate....?" , "mv_chi" , "N" , 17 , 2 , 0 , "G" , "" , "mv_par18" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR014   18")
	
	DbSeek("EDFR014")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR014"
		Reclock("SX1",.F.,.F.)
		DbDelete()
		MsunLock()
		DbSkip()
	End
	
	For X1:=1 to Len(aSX1)
		RecLock("SX1",.T.)
		For Z:=1 To FCount()
			FieldPut(Z,aSx1[X1,Z])
		Next
		MsunLock()
	Next
	
Endif*/

Return

/*
Consolidado
FL   TP  NATUREZA                   TITULO PRX PC FORNECE LJ NREDUZ                 EMISSAO     VECNTO     V.REAL      BAIXA     VL. BRUTO VL. VALPIS VL. VALCOF VL.VALCSLL VL. VALISS VL.VALIRRF VL. VALINSS    VL. VALLIQ 
1234 123 123456789-123456789-123456 123456 123 12 123456  12 123456789-123456789- 9/99/9999 99/99/9999 99/99/9999 99/99/9999 99,999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99  999,999.99 99,999,999.99 
1    6   10                         37     44  48 51      59 62                   83        93         104        115        126           140        151        162        173        184         196        207
123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789
		10         20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180      190       200       210



