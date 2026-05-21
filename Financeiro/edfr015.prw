#INCLUDE "rwmake.ch"

#DEFINE CENT	Chr(13)+Chr(10)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ EDFR015  ∫ Autor ≥ Luis Felipe Nascim.∫ Data ≥  02/10/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ RelatÛrio de CompensaÁıes de Titulos a Pagar das Usinas    ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function EDFR015()

Local cDesc1         := "RelaÁ„o de Baixas por meio de CompensaÁıes de"
Local cDesc2         := "adiantamentos de titulos a pagar."
Local cDesc3         := ""
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {"Fornecedores"}
Local cPerg          := "EDFR015"

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "EDFR015"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "EDFR015"
Private titulo       := "RelatÛrio de Titulos a Pagar Compensados"
Private nLin         := 80
Private Cabec1       := " FL   CONTRATO       DP     QTD.CONT. N.FISCAL  SERIE  QUANTIDADE          VALOR PEDIDO PRX TITULO    TIPO  QUANTIDADE     VLR. BAIXA LOCAL DESCRICAO DO ARMAZEM           FORNECEDOR                               DT.BAIXA"
Private Cabec2       := ""
Private cString      := "SE5"

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
"CONTRATO",;			// 2
"PERIODO",;			    // 3
"QTD.CONTR.",;			// 4
"PREFIXO",;				// 5 
"TITULO",;				// 6 
"TIPO",;			    // 7 
"QTD.TON",;				// 8 
"VL.BAIXA",;			// 9 
"BAIXA",;			    // 10
"NFMAE",;				// 11
"SERIEMAE",;			// 12 
"QTD.MAE",;				// 13
"VALOR",;				// 14
"PEDIDO",;				// 15
"ARMAZEM",;				// 16
"NOME",;				// 17
"FORNECEDOR",;			// 18
"LOJA",;				// 19
"NOME"}					// 20


Processa({|lEnd| EDFR015T (wnRel)})

Return

*-----------------------------*
Static Function EDFR015T(wnRel)
*-----------------------------*

Local cAliasQry 	:= GetNextAlias()
Local cQry	 		:= ""
Local lTitulo 		:= .t.
Local lPa			:= .t.
Local lPrimeira		:= .t.   
Local nZ3_QUANT   	:= 0
Local nD1_QUANT   	:= 0
Local nF1_VALBRUT 	:= 0
Local nE2_QTDTON  	:= 0
Local nE5_VALOR	  	:= 0 
Local cChave		:= ""
Local nRegs			:= 0
Local cNum			:= ""
Local cTITPA		:= ""

Private nCountnx:= 0
Private nCountny:= 1

cQry := "SELECT DISTINCT E2_FILIAL, SE5.E2_NUM AS TITPA, SE5.E2_TIPO"+CENT
cQry += " ,SZ3.Z3_DTINIC, SZ3.Z3_DTFIM"+CENT
cQry += " ,SF1.F1_XPERIOD"+CENT
cQry += " ,SE5.E2_QTDTON"+CENT
cQry += " ,SE5.E2_XSUBTIP"+CENT
cQry += " ,SE2V.CTH_VESSEL"+CENT
cQry += " ,SE5.E5_VALOR"+CENT
cQry += " ,SE5.E2_PREPAGO, SE5.E2_VLFINAL, SE5.E2_XLOCAL"+CENT
cQry += " ,SE2.E2_NUM, SE2.E2_PREFIXO, SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_BAIXA, SZE.ZE_NOME, E2_NOMFOR"+CENT
cQry += " ,SF1.F1_CONTRA,  SF1.F1_NFMAE, SF1.F1_XSERMAE, SF1.F1_XPEDIDO, SF1.F1_VALBRUT, SF1.D1_QUANT, SF1.D1_LOCAL"+CENT
cQry += " ,SZ3.Z3_QUANT, SE5.E5_DATA"+CENT
cQry += " FROM"+CENT

// SeleÁ„o das Baixas Por CompensaÁ„o 

cQry += " (SELECT DISTINCT E5_DOCUMEN ,E5_VALOR ,E2_NUM ,E2_TIPO, E2_XLOCAL, E2_PREPAGO, E2_VLFINAL, E2_QTDTON, E2_XSUBTIP, E5_DATA"+CENT
cQry += " FROM "+RetSqlName("SE2")+" SE2,"+RetSqlName("SE5")+" SE5 "+CENT
cQry += " WHERE SE2.D_E_L_E_T_= ''"+CENT
cQry += " AND SE5.D_E_L_E_T_= ''"+CENT
cQry += " AND E2_TIPO		= E5_TIPO"+CENT 
cQry += " AND E2_NUM		= E5_NUMERO"+CENT
cQry += " AND E2_FORNECE	= CASE WHEN E5_FORNADT <> E2_FORNECE THEN E5_CLIFOR ELSE E5_FORNADT END"+CENT
cQry += " AND E2_LOJA		= CASE WHEN E5_LOJAADT <> E2_LOJA	 THEN E5_LOJA   ELSE E5_LOJAADT END"+CENT
cQry += " AND E2_TIPO		= 'PA '"+CENT
cQry += " AND E5_TIPODOC	= 'BA ')"+CENT
cQry += " AS SE5"+CENT

// Titulo Baixado

cQry += " LEFT JOIN"+CENT
cQry += " (SELECT DISTINCT E2_FILIAL, E2_NUM, E2_PREFIXO, E2_FORNECE, E2_LOJA, E2_BAIXA, E2_CLVLDB, E2_NOMFOR"+CENT
cQry += " FROM "+RetSqlName("SE2")+" SE2"+CENT
cQry += " WHERE SE2.D_E_L_E_T_= '')"+CENT
cQry += " AS SE2"+CENT
cQry += " ON SubString(SE5.E5_DOCUMEN,4,9) = SE2.E2_NUM AND SubString(SE5.E5_DOCUMEN,1,3) = SE2.E2_PREFIXO AND SubString(SE5.E5_DOCUMEN,17,6) = SE2.E2_FORNECE AND SubString(SE5.E5_DOCUMEN,23,2) = SE2.E2_LOJA"+CENT

// Armazem

cQry += " LEFT JOIN"+CENT
cQry += " (SELECT DISTINCT ZE_LOCAL, ZE_NOME"+CENT
cQry += " FROM "+RetSqlName("SZE")+" SZE"+CENT
cQry += " WHERE SZE.D_E_L_E_T_= '')"+CENT
cQry += " AS SZE"+CENT
cQry += " ON SE5.E2_XLOCAL = SZE.ZE_LOCAL"+CENT

// SeleÁ„o das NF¥s Mae ou Remessa

cQry += " LEFT JOIN"+CENT
cQry += " (SELECT F1_FORNECE, F1_LOJA, F1_NFMAE, F1_XSERMAE, F1_XPEDIDO, F1_DOC, F1_SERIE, D1_QUANT, D1_COD, D1_LOCAL"+CENT 
cQry += " ,CASE WHEN F1_VALBRUT = '' THEN F1_VNAGREG ELSE F1_VALBRUT END AS F1_VALBRUT"+CENT
cQry += " ,CASE WHEN F1_CONTRA  = '' THEN Z2_CONTRA ELSE F1_CONTRA END AS F1_CONTRA"+CENT
cQry += " ,CASE WHEN F1_XPERIOD = '' THEN SubString(Z2_CODPRO,Len(Rtrim(Z2_CONTRA))+2,10) ELSE F1_XPERIOD END AS F1_XPERIOD"+CENT
cQry += " FROM "+RetSqlName("SD1")+" SD1,"+RetSqlName("SF1")+" SF1, "+RetSqlName("SZ2")+" SZ2 "+CENT
cQry += " WHERE SD1.D_E_L_E_T_ = ''"+CENT
cQry += " AND SF1.D_E_L_E_T_   = ''"+CENT
cQry += " AND SZ2.D_E_L_E_T_   = ''"+CENT
cQry += " AND D1_DOC		   = F1_DOC"+CENT
cQry += " AND D1_SERIE	       = F1_SERIE"+CENT
cQry += " AND D1_FORNECE	   = F1_FORNECE"+CENT
cQry += " AND D1_LOJA	 	   = F1_LOJA
cQry += " AND D1_COD		   = Z2_CODPRO
cQry += " AND SubString(Z2_CONTRA,1,1)='P')"+CENT
cQry += " AS SF1"+CENT
cQry += " ON SubString(SE5.E5_DOCUMEN,4,9) = SF1.F1_DOC AND SubString(SE5.E5_DOCUMEN,1,3) = SF1.F1_SERIE AND SubString(SE5.E5_DOCUMEN,17,6) = SF1.F1_FORNECE AND SubString(SE5.E5_DOCUMEN,23,2) = SF1.F1_LOJA"+CENT

// PerÌodo dos Contratos - DP

cQry += " LEFT JOIN"+CENT
cQry += " (SELECT Z3_CONTRA, Z3_PERIODO, Z3_DTINIC, Z3_DTFIM, Z3_QUANT"+CENT
cQry += " FROM "+RetSqlName("SZ3")+" SZ3 "+CENT
cQry += " WHERE SZ3.D_E_L_E_T_= '')"+CENT
cQry += " AS SZ3"+CENT
cQry += " ON SF1.F1_CONTRA = SZ3.Z3_CONTRA AND SF1.F1_XPERIOD = SZ3.Z3_PERIODO"+CENT
cQry += " LEFT JOIN"+CENT
cQry += " (SELECT CTH_CLVL, CTH_VESSEL"+CENT
cQry += " FROM "+RetSqlName("CTH")+" CTH "+CENT
cQry += " WHERE CTH.D_E_L_E_T_= '')"+CENT
cQry += " AS SE2V"+CENT
cQry += " ON SE2.E2_CLVLDB  = SE2V.CTH_CLVL"+CENT
cQry += " WHERE SE2.E2_NUM  <> ''"+CENT
If  !Empty(MV_PAR01) .and. !Empty(MV_PAR02) 
	cQry += " AND F1_CONTRA     = '"+MV_PAR01+"'"+CENT	
	cQry += " AND F1_XPERIOD    = '"+MV_PAR02+"'"+CENT 
EndIf
cQry += " AND E2_BAIXA     <> ''"+CENT
cQry += " AND F1_CONTRA    <> ''"+CENT
cQry += " ORDER BY SF1.F1_CONTRA,SF1.F1_XPERIOD,SE2.E2_NUM"+CENT

MemoWrite("C:\Tmp\EDFR015.txt",cQry)
cQry := ChangeQuery(cQry)

If Select(cAliasQry) > 0
	dbselectarea(cAliasQry)
	(cAliasQry)->(dbCloseArea())
Endif
 
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),cAliasQry,.F.,.T.)
dbselectarea(cAliasQry)
(cAliasQry)->(dbGoTop())

If (cAliasQry)->(!Eof())
	
	*-------------------------------*
	*   Conta Total de Registros.   *
	*-------------------------------*
	While (cAliasQry)->(!Eof())
		nCountnx ++
		(cAliasQry)->(DbSkip())
	End
	(cAliasQry)->(DbGoTop())
	
	ProcRegua(nCountnx)
	IncProc("Processando Impress„o...")
	
	cChave 	:= (cAliasQry)->F1_CONTRA+(cAliasQry)->F1_XPERIOD 
    cNum 	:= (cAliasQry)->E2_NUM
    cTITPA	:= (cAliasQry)->TITPA 
	
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
		If nLin > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 08
		Endif
		
		*----------------------------------------------------*
		*  Impressao da linha de detalhes do relatorio. . .  *
		*----------------------------------------------------*

		If lPrimeira .or. nLin == 08 
			@nLin,001 PSay (cAliasQry)->E2_FILIAL 
			@nLin,006 PSay SubStr((cAliasQry)->F1_CONTRA,1,14)
			@nLin,021 PSay SubStr((cAliasQry)->F1_XPERIOD,1,6)
			@nLin,028 PSay (cAliasQry)->Z3_QUANT    		Picture "@E 9,999,999"
		EndIf
		If lTitulo .or. nLin == 08 
			@nLin,038 PSay If(!Empty((cAliasQry)->F1_NFMAE)  ,(cAliasQry)->F1_NFMAE  ,(cAliasQry)->E2_NUM)
			@nLin,048 PSay If(!Empty((cAliasQry)->F1_XSERMAE),(cAliasQry)->F1_XSERMAE,(cAliasQry)->E2_PREFIXO)
			@nLin,054 PSay (cAliasQry)->D1_QUANT			Picture "@E 999,999.999"
			@nLin,066 PSay (cAliasQry)->F1_VALBRUT 			Picture "@E 99,999,999.99"
			@nLin,081 PSay (cAliasQry)->F1_XPEDIDO        
		EndIf
		If lPa .or. nLin == 08  
			@nLin,088 PSay (cAliasQry)->E2_PREFIXO  	
			@nLin,092 PSay (cAliasQry)->TITPA   	
			@nLin,103 PSay (cAliasQry)->E2_TIPO    	
			@nLin,107 PSay (cAliasQry)->E2_QTDTON			Picture "@E 999,999.999"
		EndIf
		@nLin,119 PSay (cAliasQry)->E5_VALOR				Picture "@E 99,999,999.99"
		@nLin,135 PSay (cAliasQry)->E2_XLOCAL   			
		@nLin,140 PSay SubStr((cAliasQry)->ZE_NOME,1,30)
		@nLin,171 PSay (cAliasQry)->E2_FORNECE
		@nLin,178 PSay (cAliasQry)->E2_LOJA	
		@nLin,181 PSay SubStr((cAliasQry)->E2_NOMFOR,1,27)
		@nLin,210 PSay StoD((cAliasQry)->E5_DATA)        	Picture "@D"
		
		nLin++

		*--------------------------------------*
		*   Recebe Dados para GeraÁ„o do Excel *
		*--------------------------------------*
		aAdd(aDadosExc,{"'"+(cAliasQry)->E2_FILIAL,;
		(cAliasQry)->F1_CONTRA,;
		"'"+(cAliasQry)->F1_XPERIOD,;
		If(lPrimeira,(cAliasQry)->Z3_QUANT,0),;
	    "'"+(cAliasQry)->E2_PREFIXO,;
		"'"+(cAliasQry)->TITPA,;
		(cAliasQry)->E2_TIPO,;
		If(lPa,(cAliasQry)->E2_QTDTON,0),;
		(cAliasQry)->E5_VALOR,;
		StoD((cAliasQry)->E5_DATA),;
		"'"+If(!Empty((cAliasQry)->F1_NFMAE)  ,(cAliasQry)->F1_NFMAE  ,(cAliasQry)->E2_NUM),;
		"'"+If(!Empty((cAliasQry)->F1_XSERMAE),(cAliasQry)->F1_XSERMAE,(cAliasQry)->E2_PREFIXO),;
		If(lTitulo,(cAliasQry)->D1_QUANT,0),;
		If(lTitulo,(cAliasQry)->F1_VALBRUT,0),;
		"'"+(cAliasQry)->F1_XPEDIDO,;
		"'"+(cAliasQry)->E2_XLOCAL,;
		(cAliasQry)->ZE_NOME,;
		"'"+(cAliasQry)->E2_FORNECE,;
		"'"+(cAliasQry)->E2_LOJA,;
		(cAliasQry)->E2_NOMFOR})

		*----------------------------------*
		*  Acumuladores do relatorio. . .  *
		*----------------------------------*

		If  lPrimeira
			nZ3_QUANT 	+= (cAliasQry)->Z3_QUANT
			lPrimeira := .f.   
		EndIF
		If  lPa      
			nE2_QTDTON 	+= (cAliasQry)->E2_QTDTON 
			lPa := .f.   
		EndIF
		nD1_QUANT 	+= (cAliasQry)->D1_QUANT
		nF1_VALBRUT += (cAliasQry)->F1_VALBRUT
		nE5_VALOR	+= (cAliasQry)->E5_VALOR

		(cAliasQry)->(dbSkip())
		nCountny++

		*-------------------------------------*
		*  Linha de totais do relatorio. . .  *
		*-------------------------------------*  
		
		If cChave <> (cAliasQry)->F1_CONTRA+(cAliasQry)->F1_XPERIOD 
			If nRegs > 1
				@nLin,001 PSay Repl("-",220)
				nLin++ 
				@nLin,028 PSay nZ3_QUANT    Picture "@E 9,999,999"
				@nLin,054 PSay nD1_QUANT	Picture "@E 999,999.999"
				@nLin,066 PSay nF1_VALBRUT 	Picture "@E 99,999,999.99"
				@nLin,107 PSay nE2_QTDTON	Picture "@E 999,999.999"
				@nLin,119 PSay nE5_VALOR	Picture "@E 99,999,999.99"
				nLin++
				@nLin,001 PSay Repl("-",220)
				nLin++ 
			Else
				@nLin,001 PSay Repl("-",220)
				nLin++
			EndIf	
			Stor 0 to nZ3_QUANT,nD1_QUANT,nF1_VALBRUT,nE2_QTDTON,nE5_VALOR	 
			cChave 		:= (cAliasQry)->F1_CONTRA+(cAliasQry)->F1_XPERIOD
			cNum 		:= (cAliasQry)->E2_NUM 
			cTITPA		:= (cAliasQry)->TITPA
			lPrimeira	:= .t. 
			lTitulo 	:= .t.
			lPa			:= .t.
			nRegs 		:= 0
		Else	       
			If cTITPA <> (cAliasQry)->TITPA .or. (cAliasQry)->E2_NUM <> cNum
				If cTITPA <> (cAliasQry)->TITPA 
					cTITPA	:= (cAliasQry)->TITPA
					lPa		:= .t.
                EndIf
				If (cAliasQry)->E2_NUM <> cNum
					cNum 	:= (cAliasQry)->E2_NUM 
					lTitulo := .t.
				EndIf	
				If cTITPA == (cAliasQry)->TITPA .and. (cAliasQry)->E2_NUM <> cNum
					lPa		:= .t.
				EndIf	
			Else
				lPa		:= .f.
				lTitulo := .f.
			EndIf	
		EndIf
		nRegs ++
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

//         1           2      3                           4                           5                           6          7     8    9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38         39   40  41  42  43
AADD(aSx1,{"EDFR015" , "01" , "Contrato (opcional)   ?" , "Contrato              ?" , "Contrato              ?" , "mv_ch1" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZ3"    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR015" , "02" , "DP (opcional)         ?" , "DP                    ?" , "DP                    ?" , "mv_ch2" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""       , "" , "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR015   02")
	
	DbSeek("EDFR015")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR015"
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
FL   CONTRATO       DP     QTD.CONT. N.FISCAL  SERIE  QUANTIDADE          VALOR PEDIDO PRX TITULO    TIPO  QUANTIDADE     VLR. BAIXA LOCAL DESCRICAO DO ARMAZEM           FORNECEDOR                               DT.BAIXA
1234 123456789-1234 123456 9,999,999 123456789 123   999,999.999 999,999,999.99 123456 123 123456789   PA 999,999.999 999,999,999.99  1234 123456789-123456789-123456789- 123456 12 123456789-123456789-12345678 99/99/9999
1    6              21     28        38        48    54          66             81     88  92         103 107         119             135  140                            171    178 181                         210  
123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789
		10         20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180      190       200       210




