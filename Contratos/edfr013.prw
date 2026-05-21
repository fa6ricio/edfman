#INCLUDE "rwmake.ch"

#DEFINE cEnt	Chr(13)+Chr(10)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ EDFR013  ∫ Autor ≥ Luis Felipe Nascim.∫ Data ≥  26/08/14   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ RelatÛrio de PosiÁ„o Contrato x Estoque		              ∫±±
±±∫          ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±∫Alteracao ≥ Luis Felipe                                        /  /    ∫±±
±±∫          ≥ AdequaÁ„o para o tratamento do armazem.                    ∫±±
±±∫          ≥ Em andamento.                                              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function EDFR013()

Local cDesc1         := "PosiÁ„o Contrato x Estoque em Toneladas"
Local cDesc2         := ""
Local cDesc3         := ""
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {}
Local cPerg          := "EDFR013"

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "EDFR013" 
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "EDFR013" 
Private titulo       := "RelatÛrio de PosiÁ„o Contrato x Estoque em Toneladas"
Private nLin         := 80
Private Cabec1       := " SAFRA PORTO                FORNECEDOR          CONTRATO PERIODO PRD   DT.INIC.   DT.FINAL QUANTID. P.COMPRA       A     EM TRANSITO       DESCARGA      EXPORTADO      OUTRAS    OUTRAS          ESTOQUE     ESTOQUE C/ AR"
Private Cabec2       := "                                                                       PREV.ENT   PREV.ENT CONTRAT. COLOCADO    CARREGAR    (XML)          CLS.TEMP                     SAIDAS    ENTRADAS        FISCAL      EMBARQUE   MZ"
Private cString      := "SZ3"
Private cAliasQry    := GetNextAlias()
Private cAliasQry2   := GetNextAlias()
Private cQuery       := ""
  
CriaSX1()

*------------------------------------*
*   Array das InformaÁıes do Excel   *
*------------------------------------*
Private aDadosExc := {}
Private aCabExc	  := {}
	
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
titulo 	:= titulo+" - "+If(!Empty(MV_PAR06),DtoC(MV_PAR06),DtoC(Ddatabase))
MV_PAR06:= If(!Empty(MV_PAR06),MV_PAR06,dDatabase)
wnrel 	:= SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
aCabExc := {"FILIAL",;    // 1
"SAFRA",;                 // 2         
"PORTO",;             	  // 3	   
"FORNECEDOR",;            // 4        
"CONTRATO",;              // 5        
"PERIODO",;               // 6		  
"PROD",;                  // 7		  
"DT.INIC.PREV.ENT",;      // 8        
"DT.FINALPREV.ENT",;      // 9        
"QTD.CONTRATADA",;        // 10        
"P.COMPRA COLOCADO",;     // 11         
"A CARREGAR",;            // 12        
"EM TRANSITO",;           // 13        
"DESCARGA CLAS.TEMPL.",;  // 14        
"EXPORTADO",;             // 15        
"OUTRAS SAIDAS",;         // 16        
"OUTRAS ENTRADAS",;       // 17        
"ESTOQUE FISCAL",;        // 18        
"ESTOQUE C/ EMBARQUE",;   // 19        
"TERMINAL",; 		      // 21        
"ORDEM_IMP"} 		      // 22        
//"EXP. C/ BL",;		      // 20        

Processa({|lEnd| EDFR013T (wnRel)})

Return

*-----------------------------*
Static Function EDFR013T(wnRel)
*-----------------------------*

Local nOrdem
Local cAlias	   	:= GetNextAlias()    
Local nSaldo 		:= 0
Local nEstEmb		:= 0 
Private nCountnx   	:= 0
Private nCountny   	:= 1

cQuery := " SELECT"+cEnt
cQuery += "	Z3_SAFRA"+cEnt
cQuery += "	,Y9_DESCR"+cEnt
cQuery += "	,CN9_XFORNE"+cEnt
cQuery += "	,Z3_CONTRA"+cEnt
cQuery += "	,Z3_PERIODO"+cEnt
cQuery += "	,TIPO"+cEnt
cQuery += "	,Z3_DTINIC"+cEnt	
cQuery += "	,Z3_DTFIM"+cEnt
cQuery += "	,Z3_QUANT"+cEnt
cQuery += "	,PC_COLOC"+cEnt
cQuery += "	,NF_TRANSITO"+cEnt			
cQuery += "	,PC_COLOC - NF_RECEBIDA AS A_CARREGAR"+cEnt
cQuery += "	,NF_DESCARGA-OUT_ENT_REP AS NF_DESCARGA "+cEnt	
cQuery += "	,PV_EXPORT"+cEnt	
cQuery += "	,OUT_ENT + INT_ENT AS OUT_ENT"+cEnt
cQuery += "	,OUT_SAI + INT_SAI AS OUT_SAI"+cEnt
cQuery += "	,SLD_EST,Z2_CODPRO,PV_EXPDTBL"+cEnt
If	MV_PAR09 == 1
	cQuery += "	,ZE_LOCAL"+cEnt
EndIf
cQuery += "	FROM"+cEnt
cQuery += "	(SELECT DISTINCT"+cEnt
cQuery += "	Z3_SAFRA"+cEnt
cQuery += "	,Y9_DESCR"+cEnt
cQuery += "	,CN9_XFORNE"+cEnt
cQuery += "	,Z3_CONTRA"+cEnt
cQuery += "	,Z3_PERIODO"+cEnt
cQuery += " ,(CASE WHEN BM_DESC LIKE '%VHP%' THEN 'VHP' ELSE (CASE WHEN BM_DESC LIKE '%XTL%'  THEN 'XTL' ELSE 'REF' END) END) TIPO"+cEnt
cQuery += "	,Z3_DTINIC"+cEnt
cQuery += "	,Z3_DTFIM"+cEnt
cQuery += "	,Z3_QUANT"+cEnt
cQuery += "	,ISNULL((SELECT SUM(C7_QUANT) FROM "+RetSqlName("SC7")+" C7 WHERE C7.C7_PRODUTO = Z2_CODPRO "+If(MV_PAR09 == 1,"AND C7_LOCAL = ZE_LOCAL","")+" AND C7_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND C7.D_E_L_E_T_ = '' GROUP BY C7_PRODUTO),0) AS PC_COLOC"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(ZD_QTDNFRE) * B1_CONV ELSE SUM(ZD_QTDNFRE) END FROM "+RetSqlName("SZD")+" ZD WHERE ZD.ZD_CONTRA = SZ3.Z3_CONTRA AND ZD.ZD_PERIODO = SZ3.Z3_PERIODO  "+If(MV_PAR09 == 1,"AND ZD_LOCAL = ZE_LOCAL","")+" AND ZD_PARC = '01' AND ZD_STATUS <> 'EX' AND ZD_EMISREM <= '"+DtoS(MV_PAR06)+"' AND ZD.D_E_L_E_T_ = '' GROUP BY ZD.ZD_CONTRA+ZD.ZD_PERIODO),0) AS NF_RECEBIDA"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(ZD_QTDNFRE) * B1_CONV ELSE SUM(ZD_QTDNFRE) END FROM "+RetSqlName("SZD")+" ZD WHERE ZD.ZD_CONTRA = SZ3.Z3_CONTRA AND ZD.ZD_PERIODO = SZ3.Z3_PERIODO  "+If(MV_PAR09 == 1,"AND ZD_LOCAL = ZE_LOCAL","")+" AND ZD_STATUS = 'AT' AND ZD_EMISREM <= '"+DtoS(MV_PAR06)+"' AND ZD.D_E_L_E_T_ = '' GROUP BY ZD.ZD_CONTRA+ZD.ZD_PERIODO),0) AS NF_TRANSITO"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(ZD_QTDREC)  * B1_CONV ELSE SUM(ZD_QTDREC)  END FROM "+RetSqlName("SZD")+" ZD WHERE ZD.ZD_CONTRA = SZ3.Z3_CONTRA AND ZD.ZD_PERIODO = SZ3.Z3_PERIODO  "+If(MV_PAR09 == 1,"AND ZD_LOCAL = ZE_LOCAL","")+" AND ZD_DTETERM <= '"+DtoS(MV_PAR06)+"' AND ZD.D_E_L_E_T_ = '' GROUP BY ZD.ZD_CONTRA+ZD.ZD_PERIODO),0) AS NF_DESCARGA"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(C6_QTDENT)  * B1_CONV ELSE SUM(C6_QTDENT)  END FROM "+RetSqlName("SC5")+" C5, "+RetSqlName("SC6")+" C6 WHERE C6.C6_PRODUTO = SZ2.Z2_CODPRO  "+If(MV_PAR09 == 1,"AND C6_LOCAL = ZE_LOCAL","")+" AND C6.C6_CF = '7501' AND C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5_TIPO = 'N' AND C5_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' GROUP BY C6.C6_PRODUTO),0) AS PV_EXPORT"+cEnt
//cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(C6_QTDENT)  * B1_CONV ELSE SUM(C6_QTDENT)  END FROM "+RetSqlName("SC5")+" C5, "+RetSqlName("SC6")+" C6 , "+RetSqlName("EEC")+" EC WHERE C6.C6_PRODUTO = SZ2.Z2_CODPRO  "+If(MV_PAR09 == 1,"AND C6_LOCAL = ZE_LOCAL","")+" AND C6.C6_CF = '7501' AND C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C6.C6_NUM = EC.EEC_PEDREF AND EC.EEC_DTEMBA <> '' AND C5_TIPO = 'N' AND C5_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' AND EC.D_E_L_E_T_ = '' GROUP BY C6.C6_PRODUTO),0) AS PV_EXPDTBL"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(C6_QTDENT)  * B1_CONV ELSE SUM(C6_QTDENT)  END FROM "+RetSqlName("SC5")+" C5, "+RetSqlName("SC6")+" C6 , "+RetSqlName("EEC")+" EC WHERE C6.C6_PRODUTO = SZ2.Z2_CODPRO  "+If(MV_PAR09 == 1,"AND C6_LOCAL = ZE_LOCAL","")+" AND C6.C6_CF = '7501' AND C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C6.C6_XCLVL = EC.EEC_PREEMB AND EC.EEC_DTEMBA <> '' AND C5_TIPO = 'N' AND C5_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' AND EC.D_E_L_E_T_ = '' GROUP BY C6.C6_PRODUTO),0) AS PV_EXPDTBL"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D1_QUANT)   * B1_CONV ELSE SUM(D1_QUANT)   END FROM "+RetSqlName("SD1")+" D1, "+RetSqlName("SF4")+" F4 WHERE D1.D1_COD = SZ2.Z2_CODPRO  "+If(MV_PAR09 == 1,"AND D1_LOCAL = ZE_LOCAL","")+" AND F4_ESTOQUE = 'S' AND F4_CODIGO = D1_TES AND (SUBSTRING(D1_CF,2,3) <> '501' OR D1_TES = '021') AND D1.D_E_L_E_T_ = '' AND D1_DTDIGIT <= '"+DtoS(MV_PAR06)+"' AND F4.D_E_L_E_T_ = ''	GROUP BY D1.D1_COD),0) AS OUT_ENT"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D1_QUANT)   * B1_CONV ELSE SUM(D1_QUANT)   END FROM "+RetSqlName("SD1")+" D1, "+RetSqlName("SF4")+" F4 WHERE D1.D1_COD = SZ2.Z2_CODPRO  "+If(MV_PAR09 == 1,"AND D1_LOCAL = ZE_LOCAL","")+" AND F4_ESTOQUE = 'S' AND F4_CODIGO = D1_TES AND D1_TES = '021' AND D1.D_E_L_E_T_ = '' AND D1_DTDIGIT <= '"+DtoS(MV_PAR06)+"' AND F4.D_E_L_E_T_ = ''	GROUP BY D1.D1_COD),0) AS OUT_ENT_REP"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D2_QUANT)   * B1_CONV ELSE SUM(D2_QUANT)   END FROM "+RetSqlName("SD2")+" D2, "+RetSqlName("SF4")+" F4 WHERE D2.D2_COD = SZ2.Z2_CODPRO  "+If(MV_PAR09 == 1,"AND D2_LOCAL = ZE_LOCAL","")+" AND F4_ESTOQUE = 'S' AND F4_CODIGO = D2_TES AND D2_CF <> '7501' AND D2.D_E_L_E_T_ = ''	AND D2_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND F4.D_E_L_E_T_ = ''	GROUP BY D2.D2_COD),0) AS OUT_SAI"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D3_QUANT)   * B1_CONV ELSE SUM(D3_QUANT)   END FROM "+RetSqlName("SD3")+" D3 WHERE D3.D3_COD = SZ2.Z2_CODPRO  "+If(MV_PAR09 == 1,"AND D3_LOCAL = ZE_LOCAL","")+" AND D3_TM  <= '500' AND D3_ESTORNO <> 'S' AND D3_XD1NSEQ = '' AND D3_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND D3.D_E_L_E_T_ = '' GROUP BY D3.D3_COD),0) AS INT_ENT"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D3_QUANT)   * B1_CONV ELSE SUM(D3_QUANT)   END FROM "+RetSqlName("SD3")+" D3 WHERE D3.D3_COD = SZ2.Z2_CODPRO  "+If(MV_PAR09 == 1,"AND D3_LOCAL = ZE_LOCAL","")+" AND D3_TM  >= '501' AND D3_ESTORNO <> 'S' AND D3_XD1NSEQ = '' AND D3_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND D3.D_E_L_E_T_ = '' GROUP BY D3.D3_COD),0) AS INT_SAI"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(B2_QATU)    * B1_CONV ELSE SUM(B2_QATU)	   END FROM "+RetSqlName("SB2")+" B2 WHERE B2_COD = Z2_CODPRO  "+If(MV_PAR09 == 1,"AND B2_LOCAL = ZE_LOCAL","")+" AND D_E_L_E_T_ = ''),0) AS SLD_EST"+cEnt
cQuery += "	,Z2_CODPRO"+cEnt
If	MV_PAR09 == 1
	cQuery += "	,ZE_LOCAL"+cEnt
EndIf
cQuery += "	FROM "+RetSqlName("SZ2")+" SZ2, "+RetSqlName("SZ3")+" SZ3, "+RetSqlName("SY9")+" SY9, "+RetSqlName("CN9")+" CN9, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SZE")+" SZE ,"+RetSqlName("SBM")+" SBM "+cEnt
cQuery += "	WHERE"+cEnt
cQuery += "	SubString(Z2_CONTRA,1,1)='P'"+cEnt
cQuery += "	AND Z2_CONTRA = Z3_CONTRA"+cEnt
cQuery += "	AND SubString(Z2_CODPRO,LEN(RTRIM(Z2_CONTRA))+2,10) = Z3_PERIODO"+cEnt
cQuery += "	AND Z3_PORTO		= Y9_COD"+cEnt
cQuery += "	AND CN9_NUMERO		= Z2_CONTRA"+cEnt
cQuery += "	AND B1_COD			= Z2_CODPRO"+cEnt                                                          
cQuery += "	AND B1_GRUPO		= BM_GRUPO"+cEnt

If !Empty(MV_PAR01)
	cQuery += "	AND Y9_COD = '"+MV_PAR01+"'"+cEnt
EndIf

If !Empty(MV_PAR02)
//	cQuery += "	AND C7_FORNECE = '"+MV_PAR02+"'"+cEnt // 03/11/16
	cQuery += "	AND CN9_XFORNE LIKE '%"+Alltrim(MV_PAR02)+"%'"+cEnt
EndIf
 
If !Empty(MV_PAR03)
	cQuery += "	AND Z3_SAFRA = '"+MV_PAR03+"'"+cEnt
EndIf

If !Empty(MV_PAR04) 
	cQuery += "	AND Z3_CONTRA = '"+MV_PAR04+"'"+cEnt
	If !Empty(MV_PAR05)
		cQuery += "	AND Z3_PERIODO = '"+MV_PAR05+"'"+cEnt
	EndIf	
EndIf

If !Empty(MV_PAR07) .AND. MV_PAR09 == 1 
	cQuery += "	AND ZE_LOCAL = '"+MV_PAR07+"'"+cEnt
EndIf

If !Empty(MV_PAR08) .and. MV_PAR08 <> 4
	If MV_PAR08 == 1
		cQuery += "	AND BM_DESC LIKE '%VHP%'"+cEnt
	ElseIf MV_PAR08 == 2
		cQuery += "	AND BM_DESC LIKE '%XTL%'"+cEnt
	Else
		cQuery += "	AND BM_DESC LIKE '%REF%'"+cEnt
	EndIf
EndIf

cQuery += "	AND SZ2.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND SZ3.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND SY9.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND CN9.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND SB1.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND SZE.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND SBM.D_E_L_E_T_	= ''"+cEnt
If MV_PAR09 == 1
	cQuery += "	GROUP BY Z3_SAFRA, Z2_CODPRO, Z3_CONTRA, CN9_XFORNE, Z3_PERIODO, Z3_DTINIC, Z3_DTFIM, Z3_DTINEM, Z3_DTFIEM, Z3_QUANT, Y9_DESCR, B1_GRUPO, B1_CONV, ZE_LOCAL, BM_DESC)"+cEnt
Else
	cQuery += "	GROUP BY Z3_SAFRA, Z2_CODPRO, Z3_CONTRA, CN9_XFORNE, Z3_PERIODO, Z3_DTINIC, Z3_DTFIM, Z3_DTINEM, Z3_DTFIEM, Z3_QUANT, Y9_DESCR, B1_GRUPO, B1_CONV, BM_DESC)"+cEnt
EndIf
cQuery += "	AS SZ2"+cEnt
If MV_PAR09 == 1 .AND. Empty(MV_PAR07) // Analitico
	cQuery += "	WHERE (PC_COLOC <> 0 OR NF_TRANSITO <> 0 OR NF_RECEBIDA <> 0 OR NF_DESCARGA <> 0 OR PV_EXPORT <> 0 OR OUT_ENT <> 0 OR OUT_SAI <> 0 OR SLD_EST <> 0)"+cEnt
	cQuery += "	ORDER BY Z3_CONTRA, Z3_PERIODO, ZE_LOCAL"+cEnt     
Else
	cQuery += "	ORDER BY Z3_CONTRA, Z3_PERIODO"+cEnt     
EndIf

MemoWrite("C:\Tmp\EDFR013.txt",cQuery)
cQuery := ChangeQuery(cQuery)

If Select(cAliasQry) > 0
	dbSelectArea(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

*---------------------------------------------------------------------------------------------------------------------------------------------*

cData	 := CtoD('01/01/1998')
cDataIni := DtoS(cData)
cDataFim := DtoS(MV_PAR06)
cDataSB9 := DtoS(LastDay(cData))

cQuery := "SELECT DISTINCT B2_FILIAL, B2_COD, B2_LOCAL, B1_TIPO, B1_GRUPO, B1_DESC, B1_UM, B1_SEGUM, B1_CONTA, B1_CONV, B1_TIPCONV, BM_DESC, "+cEnt

cQuery += "ISNULL(SB9.B9_QINI,0)    				   			AS B9_QINI, "+cEnt    
cQuery += "ISNULL(SB9.B9_VINI1,0)	  							AS B9_VINI1, "+cEnt

cQuery += "ISNULL(SD1.D1_QUANT,0) + ISNULL(SD3.D3_QTDE1,0)		AS QENTRADA, "+cEnt
cQuery += "ISNULL(SD1.D1_CUSTO,0) + ISNULL(SD3.D3_CUSTE1,0)		AS VENTRADA, "+cEnt

cQuery += "ISNULL(SD2.D2_QUANT,0) + ISNULL(SD3.D3_QTDS1,0)		AS QSAIDA, "+cEnt
cQuery += "ISNULL(SD2.D2_CUSTO1,0)+ ISNULL(SD3.D3_CUSTS1,0)		AS VSAIDA, "+cEnt

cQuery += "(ISNULL(SB9.B9_QINI,0)  + ISNULL(SD1.D1_QUANT,0)  + ISNULL(SD3.D3_QTDE1,0)  - (ISNULL(SD2.D2_QUANT,0)  + ISNULL(SD3.D3_QTDS1 ,0))) - (ISNULL(D3_QTDTE1,0)  - ISNULL(D3_QTDTS1,0))  AS QSLD1, "+cEnt
cQuery += "(ISNULL(SB9.B9_VINI1,0) + ISNULL(SD1.D1_CUSTO,0)  + ISNULL(SD3.D3_CUSTE1,0) - (ISNULL(SD2.D2_CUSTO1,0) + ISNULL(SD3.D3_CUSTS1,0))) - (ISNULL(D3_CUSTTE1,0) - ISNULL(D3_CUSTTS1,0)) AS VSLD1, "+cEnt

cQuery += "ISNULL(B9_QINITRA,0)   + ISNULL(D3_QTDTE1,0)	 - ISNULL(D3_QTDTS1,0)  AS QTRANSITO, "+cEnt 
cQuery += "ISNULL(B9_VINITRA,0)   + ISNULL(D3_CUSTTE1,0)	 - ISNULL(D3_CUSTTS1,0) AS VTRANSITO, "+cEnt 

cQuery += "ISNULL(SB9.B9_VINI5,0) + ISNULL(SD1.D1_CUSTO5,0) + ISNULL(SD3.D3_CUSTE5,0) - (ISNULL(SD2.D2_CUSTO5,0) + ISNULL(SD3.D3_CUSTS5,0)) - (ISNULL(D3_CUSTTE5,0) - ISNULL(D3_CUSTTS5,0)) AS VSLD5, "+cEnt

cQuery += "SZE.ZE_NOME "+cEnt
cQuery += "FROM "+cEnt
cQuery += "(SELECT DISTINCT B2_COD, B2_FILIAL,B2_LOCAL,B1_TIPO, B1_GRUPO, B1_DESC, B1_UM, B1_SEGUM, B1_CONTA, B1_CONV, B1_TIPCONV, BM_DESC "+cEnt
cQuery += "FROM "+RetSqlName("SB1")+" SB1, "+RetSqlName("SB2")+" SB2, "+RetSqlName("SBM")+" SBM "+cEnt
cQuery += "WHERE B1_COD = B2_COD "+cEnt              
cQuery += "AND Len(Rtrim(B2_LOCAL)) = 2 "+cEnt   
cQuery += "AND B1_GRUPO = BM_GRUPO "+cEnt  
cQuery += "AND B2_CM1 <> 0 "+cEnt    
cQuery += "AND (BM_DESC LIKE '%VHP%' OR BM_DESC LIKE '%XTL%' OR BM_DESC LIKE '%REF%')"+cEnt

If !Empty(MV_PAR04) 
	cQuery += "	AND B2_COD LIKE '%"+Alltrim(MV_PAR04)+"%'"+cEnt
	If !Empty(MV_PAR05)
		cQuery += "	AND B2_COD = '"+Alltrim(MV_PAR04)+"-"+Alltrim(MV_PAR05)+"'"+cEnt
	EndIf	
EndIf

If !Empty(MV_PAR07) 
	cQuery += "AND RTRIM(B2_LOCAL) = '"+MV_PAR07+"'"+cEnt
EndIf

If !Empty(MV_PAR08) .and. MV_PAR08 <> 4
	If MV_PAR08 == 1
		cQuery += "	AND BM_DESC LIKE '%VHP%'"+cEnt
	ElseIf MV_PAR08 == 2
		cQuery += "	AND BM_DESC LIKE '%XTL%'"+cEnt
	Else
		cQuery += "	AND BM_DESC LIKE '%REF%'"+cEnt
	EndIf
EndIf

cQuery += "AND SB1.D_E_L_E_T_ = '' "+cEnt
cQuery += "AND SB2.D_E_L_E_T_ = '' "+cEnt
cQuery += "AND SBM.D_E_L_E_T_ = '' "+cEnt
cQuery += ") AS SB2 "+cEnt

cQuery += "LEFT JOIN "+cEnt
cQuery += "(SELECT DISTINCT D1_FILIAL,D1_COD,D1_LOCAL,CASE WHEN B1_CONV <> 1 THEN SUM(D1_QUANT) * B1_CONV ELSE SUM(D1_QUANT) END AS D1_QUANT,SUM(D1_CUSTO) AS D1_CUSTO, SUM(D1_CUSTO5) AS D1_CUSTO5 "+cEnt
cQuery += "FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF4")+" SF4, "+RetSqlName("SB1")+" SB1 "+cEnt
cQuery += "WHERE D1_TES = F4_CODIGO "+cEnt
cQuery += "AND D1_COD = B1_COD "+cEnt
cQuery += "AND D1_DTDIGIT BETWEEN '"+cDataIni+"' AND '"+cDataFim+"'"+cEnt
cQuery += "AND SF4.F4_ESTOQUE = 'S' "+cEnt
cQuery += "AND SD1.D_E_L_E_T_ = '' "+cEnt
cQuery += "AND SF4.D_E_L_E_T_ = '' "+cEnt
cQuery += "AND SB1.D_E_L_E_T_ = ''"+cEnt
cQuery += "GROUP BY D1_FILIAL,D1_COD,D1_LOCAL,B1_CONV "+cEnt
cQuery += ") AS SD1 "+cEnt
cQuery += "ON SB2.B2_FILIAL+SB2.B2_COD+SB2.B2_LOCAL = SD1.D1_FILIAL+SD1.D1_COD+SD1.D1_LOCAL "+cEnt

cQuery += "LEFT JOIN "+cEnt
cQuery += "(SELECT D2_FILIAL,D2_COD,D2_LOCAL,CASE WHEN B1_CONV <> 1 THEN SUM(D2_QUANT) * B1_CONV ELSE SUM(D2_QUANT) END AS D2_QUANT,SUM(D2_CUSTO1) AS D2_CUSTO1, SUM(D2_CUSTO5) AS D2_CUSTO5 "+cEnt
cQuery += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF4")+" SF4, "+RetSqlName("SB1")+" SB1 "+cEnt
cQuery += "WHERE D2_TES = F4_CODIGO "+cEnt
cQuery += "AND D2_COD = B1_COD "+cEnt
cQuery += "AND SD2.D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"'"+cEnt
cQuery += "AND SF4.F4_ESTOQUE = 'S' "+cEnt
cQuery += "AND SD2.D_E_L_E_T_ = '' "+cEnt
cQuery += "AND SF4.D_E_L_E_T_ = '' "+cEnt
cQuery += "AND SB1.D_E_L_E_T_ = ''"+cEnt
cQuery += "GROUP BY D2_FILIAL,D2_COD,D2_LOCAL,B1_CONV "+cEnt
cQuery += ") AS SD2 "+cEnt
cQuery += "ON SB2.B2_FILIAL+SB2.B2_COD+SB2.B2_LOCAL = SD2.D2_FILIAL+SD2.D2_COD+SD2.D2_LOCAL "+cEnt

cQuery += "LEFT JOIN "+cEnt
cQuery += "(SELECT D3_FILIAL,D3_COD,D3_LOCAL, "+cEnt
cQuery += "(SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D3_QUANT) * B1_CONV ELSE SUM(D3_QUANT) END FROM "+RetSqlName("SD3")+" D3, "+RetSqlName("SB1")+" B1 WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_COD = B1_COD AND SD3.D3_LOCAL = D3_LOCAL AND (D3_TM <= 500 AND D3_XD1NSEQ = '' OR D3_TM = 002 AND D3_XD1NSEQ <> '') AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND B1.D_E_L_E_T_ = '' AND D3.D_E_L_E_T_ = '' GROUP BY B1_CONV) AS D3_QTDE1, "+cEnt
cQuery += "(SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D3_QUANT) * B1_CONV ELSE SUM(D3_QUANT) END FROM "+RetSqlName("SD3")+" D3, "+RetSqlName("SB1")+" B1 WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_COD = B1_COD AND SD3.D3_LOCAL = D3_LOCAL AND D3_TM >  500 AND D3_TM <> '999' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND B1.D_E_L_E_T_ = '' AND D3.D_E_L_E_T_ = '' GROUP BY B1_CONV) AS D3_QTDS1, "+cEnt
cQuery += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND (D3_TM <= 500 AND D3_XD1NSEQ = '' OR D3_TM = 002 AND D3_XD1NSEQ <> '') AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTE1, "+cEnt
cQuery += "(SELECT SUM(D3_CUSTO5) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND (D3_TM <= 500 AND D3_XD1NSEQ = '' OR D3_TM = 002 AND D3_XD1NSEQ <> '') AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTE5, "+cEnt
cQuery += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND D3_TM >  500 AND D3_TM <> '999' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTS1, "+cEnt
cQuery += "(SELECT SUM(D3_CUSTO5) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND SD3.D3_LOCAL = D3_LOCAL AND D3_TM >  500 AND D3_TM <> '999' AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTS5, "+cEnt

// EM TRANSITO
cQuery += "(SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D3_QUANT) * B1_CONV ELSE SUM(D3_QUANT) END FROM "+RetSqlName("SD3")+" D3, "+RetSqlName("SB1")+" B1 WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_COD = B1_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM <= 500 AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND B1.D_E_L_E_T_ = '' AND D3.D_E_L_E_T_ = '' GROUP BY B1_CONV) AS D3_QTDTE1, "+cEnt
cQuery += "(SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D3_QUANT) * B1_CONV ELSE SUM(D3_QUANT) END FROM "+RetSqlName("SD3")+" D3, "+RetSqlName("SB1")+" B1 WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_COD = B1_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM >  500 AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND B1.D_E_L_E_T_ = '' AND D3.D_E_L_E_T_ = '' GROUP BY B1_CONV) AS D3_QTDTS1, "+cEnt
cQuery += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM <= 500 AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTTE1, "+cEnt
cQuery += "(SELECT SUM(D3_CUSTO1) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM >  500 AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTTS1,"+cEnt
cQuery += "(SELECT SUM(D3_CUSTO5) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM <= 500 AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTTE5, "+cEnt
cQuery += "(SELECT SUM(D3_CUSTO5) FROM "+RetSqlName("SD3")+" WHERE SD3.D3_FILIAL = D3_FILIAL AND SD3.D3_COD = D3_COD AND D3_LOCAL = SubString(SD3.D3_LOCAL,1,2)+'01' AND D3_TM >  500 AND D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' AND D3_ESTORNO <> 'S' AND D_E_L_E_T_ = '') AS D3_CUSTTS5 "+cEnt
cQuery += "FROM "+RetSqlName("SD3")+" SD3 "+cEnt
cQuery += "WHERE D3_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "+cEnt
cQuery += "AND D3_ESTORNO <> 'S'"+cEnt
cQuery += "AND SD3.D_E_L_E_T_ = ''"+cEnt
cQuery += "GROUP BY SD3.D3_FILIAL,SD3.D3_COD,SD3.D3_LOCAL "+cEnt
cQuery += ") AS SD3 "+cEnt
cQuery += "ON SB2.B2_FILIAL+SB2.B2_COD+SB2.B2_LOCAL = SD3.D3_FILIAL+SD3.D3_COD+SD3.D3_LOCAL "+cEnt

cQuery += "LEFT JOIN "+cEnt
cQuery += "(SELECT B9_FILIAL,B9_COD,B9_LOCAL,B9_VINI1,B9_VINI5, "+cEnt      
cQuery += "(SELECT CASE WHEN B1_CONV <> 1 THEN SUM(B9_QINI) * B1_CONV ELSE SUM(B9_QINI) END AS B9_QINI FROM "+RetSqlName("SB9")+" B9, "+RetSqlName("SB1")+" B1 WHERE SB9.B9_FILIAL = B9_FILIAL AND SB9.B9_COD = B9_COD AND B1_COD = B9_COD AND SB9.B9_DATA = B9_DATA AND B9_LOCAL = SB9.B9_LOCAL AND B1.D_E_L_E_T_ = '' AND B9.D_E_L_E_T_ = '' GROUP BY B1_CONV) AS B9_QINI, "+cEnt      
cQuery += "(SELECT CASE WHEN B1_CONV <> 1 THEN SUM(B9_QINI) * B1_CONV ELSE SUM(B9_QINI) END AS B9_QINI FROM "+RetSqlName("SB9")+" B9, "+RetSqlName("SB1")+" B1 WHERE SB9.B9_FILIAL = B9_FILIAL AND SB9.B9_COD = B9_COD AND B1_COD = B9_COD AND SB9.B9_DATA = B9_DATA AND B9_LOCAL = SubString(SB9.B9_LOCAL,1,2)+'01' AND B1.D_E_L_E_T_ = '' AND B9.D_E_L_E_T_ = '' GROUP BY B1_CONV) AS B9_QINITRA, "+cEnt      
cQuery += "(SELECT B9_VINI1 FROM "+RetSqlName("SB9")+" WHERE SB9.B9_FILIAL = B9_FILIAL AND SB9.B9_COD = B9_COD AND SB9.B9_DATA = B9_DATA AND B9_LOCAL = SubString(SB9.B9_LOCAL,1,2)+'01' AND D_E_L_E_T_ = '') AS B9_VINITRA, "+cEnt      
cQuery += "(SELECT B9_VINI5 FROM "+RetSqlName("SB9")+" WHERE SB9.B9_FILIAL = B9_FILIAL AND SB9.B9_COD = B9_COD AND SB9.B9_DATA = B9_DATA AND B9_LOCAL = SubString(SB9.B9_LOCAL,1,2)+'01' AND D_E_L_E_T_ = '') AS B9_VINITRA5 "+cEnt      
cQuery += "FROM "+RetSqlName("SB9")+" SB9 "+cEnt
cQuery += "WHERE SB9.D_E_L_E_T_ = ''"+cEnt
cQuery += "AND SUBSTRING(B9_COD,1,1)='P' "+cEnt
cQuery += "AND B9_QINI <> 0 "+cEnt
cQuery += "AND B9_VINI1 <> 0 "+cEnt
cQuery += "AND LEN(RTRIM(B9_LOCAL)) = 2 "+cEnt
cQuery += "AND B9_DATA IN (SELECT MIN(B9_DATA) FROM "+RetSqlName("SB9")+" B9 WHERE  SB9.B9_FILIAL = B9_FILIAL AND SB9.B9_COD = B9_COD AND SB9.B9_LOCAL = B9_LOCAL AND D_E_L_E_T_ = ''
cQuery += "AND NOT EXISTS (SELECT D1_COD FROM "+RetSqlName("SD1")+" WHERE D1_COD = B9.B9_COD AND D1_DTDIGIT <= B9.B9_DATA AND D_E_L_E_T_ = '')
cQuery += "AND NOT EXISTS (SELECT D2_COD FROM "+RetSqlName("SD2")+" WHERE D2_COD = B9.B9_COD AND D2_EMISSAO <= B9.B9_DATA AND D_E_L_E_T_ = '')
cQuery += "AND NOT EXISTS (SELECT D3_COD FROM "+RetSqlName("SD3")+" WHERE D3_COD = B9.B9_COD AND D3_EMISSAO <= B9.B9_DATA AND D_E_L_E_T_ = ''))
cQuery += ") AS SB9 "+cEnt
cQuery += "ON SB2.B2_FILIAL+SB2.B2_COD+SB2.B2_LOCAL = SB9.B9_FILIAL+SB9.B9_COD+SB9.B9_LOCAL "+cEnt

cQuery += "LEFT JOIN "+cEnt
cQuery += "(SELECT ZE_LOCAL,ZE_NOME  "+cEnt
cQuery += "FROM "+RetSqlName("SZE")+" SZE "+cEnt
cQuery += "WHERE D_E_L_E_T_ = '' "+cEnt
cQuery += ") AS SZE "+cEnt
cQuery += "ON SB2.B2_LOCAL = SZE.ZE_LOCAL "+cEnt
cQuery += "ORDER BY 2,3,1 "+cEnt

MemoWrite("C:\Tmp\EDFR0132.txt",cQuery)
cQuery := ChangeQuery(cQuery)

If Select(cAliasQry2) > 0
	dbSelectArea(cAliasQry2)
	(cAliasQry2)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry2,.T.,.T.)

aSaldo := {}

While (cAliasQry2)->(!Eof())
   	Aadd(aSaldo,{(cAliasQry2)->B2_COD,(cAliasQry2)->B2_LOCAL,(cAliasQry2)->ZE_NOME,(cAliasQry2)->(B9_QINI + QENTRADA - QSAIDA),(cAliasQry2)->B2_FILIAL,0}) 
	(cAliasQry2)->(DbSkip())
End

If (cAliasQry)->(!Eof()) .and. Len(aSaldo) > 0
	
	*-------------------------------*
	*   Conta Total de Registros.   *
	*-------------------------------*
	While (cAliasQry)->(!Eof())
		nEstEmb := (cAliasQry)->NF_DESCARGA - (cAliasQry)->OUT_SAI + (cAliasQry)->OUT_ENT - (cAliasQry)->PV_EXPDTBL
		If MV_PAR09 == 1
			nPos := aScan( aSaldo,{|x| x[1]+x[2] == (cAliasQry)->Z2_CODPRO+(cAliasQry)->ZE_LOCAL}) 
			If nPos <> 0
				aSaldo[nPos][6] := nEstEmb 
			EndIf	
		Else
			nPos := aScan( aSaldo,{|x| x[1] == (cAliasQry)->Z2_CODPRO}) 
			If nPos <> 0
				aSaldo[nPos][6] += nEstEmb 
			EndIf	
		EndIf
		If nPos <> 0
			nCountnx ++
		EndIf
		(cAliasQry)->(DbSkip())
	EndDo
	(cAliasQry)->(DbGoTop())
	
	ProcRegua(nCountnx)
	IncProc("Processando Impress„o...")

	While (cAliasQry)->(!EOF())
		
		IncProc("Imprimindo RelatÛrio - "+Alltrim(STR(nCountny))+" de "+Alltrim(STR(nCountnx))+" Registros...")
		
		*-------------------------------------------*
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
			nLin := 09
		Endif
		
	    If MV_PAR09 == 1
	    	nPos 	:= aScan( aSaldo,{|x| x[1]+x[2] == (cAliasQry)->Z2_CODPRO+(cAliasQry)->ZE_LOCAL})
			nSaldo 	:= u_SldSb2((cAliasQry)->Z2_CODPRO,(cAliasQry)->ZE_LOCAL,MV_PAR06)        
		Else
	    	nPos 	:= aScan( aSaldo,{|x| x[1] == (cAliasQry)->Z2_CODPRO})
			nSaldo 	:= u_SldSb2((cAliasQry)->Z2_CODPRO,"",MV_PAR06)         
		EndIf

		cContrato := (cAliasQry)->Z3_CONTRA 
		
		If nPos <> 0
			@nLin,001 PSay (cAliasQry)->Z3_SAFRA  
			@nLin,007 PSay SubStr((cAliasQry)->Y9_DESCR,1,20)  
			@nLin,028 PSay Substr((cAliasQry)->CN9_XFORNE,1,23)
			@nLin,049 PSay Substr((cAliasQry)->Z3_CONTRA,1,8)
			@nLin,058 PSay Substr((cAliasQry)->Z3_PERIODO,1,7)
			@nLin,066 PSay (cAliasQry)->TIPO
			@nLin,070 PSay StoD((cAliasQry)->Z3_DTINIC)						Picture "@D"  
			@nLin,081 PSay StoD((cAliasQry)->Z3_DTFIM) 						Picture "@D"
			@nLin,093 PSay (cAliasQry)->Z3_QUANT 							Picture "@E 999,999"
			@nLin,102 PSay (cAliasQry)->PC_COLOC       						Picture "@E 999,999"
			@nLin,110 PSay (cAliasQry)->A_CARREGAR 	 						Picture "@E 999,999.999"
			@nLin,122 PSay (cAliasQry)->NF_TRANSITO  					 	Picture "@E 999,999.999"
			@nLin,134 PSay (cAliasQry)->NF_DESCARGA   					 	Picture "@E 99,999,999.999"
			@nLin,149 PSay (cAliasQry)->PV_EXPORT	 						Picture "@E 99,999,999.999"
			@nLin,164 PSay (cAliasQry)->OUT_SAI	  						    Picture "@E 999,999.999"
			@nLin,176 PSay (cAliasQry)->OUT_ENT		   						Picture "@E 999,999.999"
			@nLin,188 PSay nSaldo 											Picture "@E 99,999,999.999" 
//			@nLin,203 PSay nEstEmb											Picture "@E 99,999,999.999" 
			@nLin,203 PSay aSaldo[nPos][6]									Picture "@E 99,999,999.999" 

			If MV_PAR09 = 1
				@nLin,218 PSay (cAliasQry)->ZE_LOCAL						Picture "@!" 
			Else
				@nLin,218 PSay "CO"											Picture "@!" 
			EndIf	
	   		nLin++
			*--------------------------------------*
			*   Recebe Dados para GeraÁ„o do Excel *
			*--------------------------------------*
	
			nPosExc := 0
			For a:=nPos to Len(aSaldo)   
				If (cAliasQry)->Z2_CODPRO == aSaldo[a][1] 
				   lInclui := .t.
				   If MV_PAR09 = 1
				   		If (cAliasQry)->ZE_LOCAL <> aSaldo[a][2] 
						   lInclui := .f.
				   		EndIf
				   Else
				   		nPosExc	:= aScan(aDadosExc,{|x| x[21] == Alltrim((cAliasQry)->Z2_CODPRO)+" - CONSOLIDADO"})   
				   		If nPosExc <> 0
 					    	lInclui := .f.
 					    EndIf	
				   EndIf
				   If 	lInclui 
						aAdd(aDadosExc,{"'"+aSaldo[a][5],;
						(cAliasQry)->Z3_SAFRA,;
						(cAliasQry)->Y9_DESCR,;
						(cAliasQry)->CN9_XFORNE,;
						(cAliasQry)->Z3_CONTRA,;
						(cAliasQry)->Z3_PERIODO,;
						(cAliasQry)->TIPO,;
						StoD((cAliasQry)->Z3_DTINIC),;
						StoD((cAliasQry)->Z3_DTFIM),;
						(cAliasQry)->Z3_QUANT,;
						(cAliasQry)->PC_COLOC,;
						(cAliasQry)->A_CARREGAR,;
						(cAliasQry)->NF_TRANSITO,;
						(cAliasQry)->NF_DESCARGA,;
						(cAliasQry)->PV_EXPORT,;
						(cAliasQry)->OUT_SAI,;
						(cAliasQry)->OUT_ENT,;
						aSaldo[a][4],;
						aSaldo[a][6],;           
						If(MV_PAR09 = 2,'',aSaldo[a][3]),;
						aSaldo[a][1]+aSaldo[a][2]}) 
//						(cAliasQry)->PV_EXPDTBL,; // 20/06/16 - Luis Felipe
						If MV_PAR09 = 2
							aDadosExc[Len(aDadosExc)][21] := Alltrim(aSaldo[a][1])+" - CONSOLIDADO"
						EndIf
				   Else	
					   If nPosExc <> 0
							aDadosExc[nPosExc][18] += aSaldo[a][4]
					   EndIf
				   EndIf
				Else
					Exit    
				EndIf
			Next
		EndIf

		(cAliasQry)->(dbSkip())
		
		If cContrato <> (cAliasQry)->Z3_CONTRA .and. nPos <> 0
			nCountny++               
		Endif 
		
	End
	
	*----------------------*
	*      Gera Excel      *
	*----------------------*

   	aDadosExc := ASort(aDadosExc,,,{|x,y| x[1]+X[21] < y[1]+Y[21] })
	If MsgYesNo("Deseja exportar para o Excel?") 
		DlgToExcel({{"ARRAY","",aCabExc,aDadosExc}})
	EndIf
	
EndIf

(cAliasQry)->(dbCloseArea())
(cAliasQry2)->(dbCloseArea())

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

 *           1          2      3                            4                           5                           6          7     8    9   10  11    12   13           14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38       39  40  41  42  43
 AADD(aSx1,{"EDFR013" , "01" , "Porto.......(opcional)?" , "Porto.......(opcional)?" , "Porto.......(opcional)?" , "mv_ch1" , "C" , 05 , 0 , 0 , "G" , "" , "mv_par01" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SY9"  , "", "", "", "", ""})
 AADD(aSx1,{"EDFR013" , "02" , "Usina.......(opcional)?" , "Usina.......(opcional)?" , "Usina.......(opcional)?" , "mv_ch2" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par02" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "Z6_FOR" , "", "", "", "", ""})
 AADD(aSx1,{"EDFR013" , "03" , "Safra 13/14 (opcional)?" , "Safra 13/14 (opcional)?" , "Safra 13/14 (opcional)?" , "mv_ch3" , "C" , 05 , 0 , 0 , "G" , "" , "mv_par03" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "", "", "", "", ""})
 AADD(aSx1,{"EDFR013" , "04" , "Contrato... (opcional)?" , "Contrato... (opcional)?" , "Contrato... (opcional)?" , "mv_ch4" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par04" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZ3"  , "", "", "", "", ""})
 AADD(aSx1,{"EDFR013" , "05" , "DP..........(opcional)?" , "DP..........(opcional)?" , "DP..........(opcional)?" , "mv_ch5" , "C" , 10 , 0 , 0 , "G" , "" , "mv_par05" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "", "", "", "", ""})
 AADD(aSx1,{"EDFR013" , "06" , "Dt. Ult. Dia Mes......?" , "Dt. Ult. Dia Mes......?" , "Dt. Ult. Dia Mes......?" , "mv_ch6" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par06" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""     , "", "", "", "", ""})
 AADD(aSx1,{"EDFR013" , "07" , "Terminal... (opcional)?" , "Terminal... (opcional)?" , "Terminal... (opcional)?" , "mv_ch7" , "C" , 04 , 0 , 0 , "G" , "" , "mv_par07" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZE_2", "", "", "", "", ""})
 AADD(aSx1,{"EDFR013" , "08" , "Tipo de Produto.......?" , "Tipo de Produto.......?" , "Tipo de Produto.......?" , "mv_ch8" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par08" , "VHP"         , "" , "" , "" , "" , "XTL"       , "" , "" , "" , "" , "REFINADO" , "" , "" , "" , "" , "Todos" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})
 AADD(aSx1,{"EDFR013" , "09" , "Tipo de Impressao.....?" , "Tipo de Impressao.....?" , "Tipo de Impressao.....?" , "mv_ch9" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par09" , "Analitico"   , "" , "" , "" , "" , "Sintetico" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "", "", "", "", ""})

 DbSelectArea("SX1")
 DbSetOrder(1)

 If !DbSeek("EDFR013   09")

    DbSeek("EDFR013")

    While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR013"
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

 Endif */

Return

/*
Y9_DESCR,CN9_XFORNE,Z3_CONTRA,Z3_PERIODO,TIPO,Z3_DTINIC,Z3_DTFIM,Z3_QUANT,PC_COLOC,A_CARREGAR,NF_TRANSITO,NF_DESCARGA,PV_EXPORT,OUT_SAI,OUT_ENT,SLD_EST


SAFRA PORTO                FORNECEDOR           CONTRATO PERIODO PRD   DT.INIC.   DT.FINAL QUANTID. P.COMPRA       A     EM TRANSITO       DESCARGA      EXPORTADO      OUTRAS    OUTRAS          ESTOQUE     ESTOQUE C/ AR
                                                                       PREV.ENT   PREV.ENT CONTRAT. COLOCADO    CARREGAR    (XML)          CLS.TEMP                     SAIDAS    ENTRADAS        FISCAL      EMBARQUE   MZ

12/12 123456789-123456789- 123456789-123456789- 1234567  P21546  VHP 99/99/9999 99/99/9999  999.999  999.999 999,999.999 999,999.999 99,999,999.999 99,999,999.999 999,999.999 999,999.999 99,999,999.999 99,999,999.999 12
1     7                    28                   50       58      66  70         81          93       102     110         122         134            149            164         176         188            203            218
123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789
        10         20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180      190       200       210

/*
cQuery := " SELECT"+cEnt
cQuery += "	Z3_SAFRA"+cEnt
cQuery += "	,Y9_DESCR"+cEnt
cQuery += "	,CN9_XFORNE"+cEnt
cQuery += "	,Z3_CONTRA"+cEnt
cQuery += "	,Z3_PERIODO"+cEnt
cQuery += "	,TIPO"+cEnt
cQuery += "	,Z3_DTINIC"+cEnt	
cQuery += "	,Z3_DTFIM"+cEnt
cQuery += "	,Z3_QUANT"+cEnt
cQuery += "	,PC_COLOC"+cEnt
cQuery += "	,NF_TRANSITO"+cEnt			
cQuery += "	,PC_COLOC - NF_RECEBIDA AS A_CARREGAR"+cEnt
cQuery += "	,NF_DESCARGA"+cEnt	
cQuery += "	,PV_EXPORT"+cEnt	
cQuery += "	,OUT_ENT + INT_ENT AS OUT_ENT"+cEnt
cQuery += "	,OUT_SAI + INT_SAI AS OUT_SAI"+cEnt
cQuery += "	,SLD_EST,Z2_CODPRO,PV_EXPDTBL"+cEnt
cQuery += "	FROM"+cEnt
cQuery += "	(SELECT DISTINCT"+cEnt
cQuery += "	Z3_SAFRA"+cEnt
cQuery += "	,Y9_DESCR"+cEnt
cQuery += "	,CN9_XFORNE"+cEnt
cQuery += "	,Z3_CONTRA"+cEnt
cQuery += "	,Z3_PERIODO"+cEnt
cQuery += " ,(CASE WHEN BM_DESC LIKE '%VHP%' THEN 'VHP' ELSE (CASE WHEN BM_DESC LIKE '%XTL%'  THEN 'XTL' ELSE 'REF' END) END) TIPO"+cEnt
cQuery += "	,Z3_DTINIC"+cEnt
cQuery += "	,Z3_DTFIM"+cEnt
cQuery += "	,Z3_QUANT"+cEnt
cQuery += "	,ISNULL((SELECT SUM(C7_QUANT) FROM "+RetSqlName("SC7")+" C7 WHERE C7.C7_PRODUTO = Z2_CODPRO AND C7_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND C7.D_E_L_E_T_ = '' GROUP BY C7_PRODUTO),0) AS PC_COLOC"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(ZD_QTDNFRE) * B1_CONV ELSE SUM(ZD_QTDNFRE) END FROM "+RetSqlName("SZD")+" ZD WHERE ZD.ZD_CONTRA = SZ3.Z3_CONTRA AND ZD.ZD_PERIODO = SZ3.Z3_PERIODO AND ZD_PARC = '01' AND ZD_STATUS <> 'EX' AND ZD_EMISREM <= '"+DtoS(MV_PAR06)+"' AND ZD.D_E_L_E_T_ = '' GROUP BY ZD.ZD_CONTRA+ZD.ZD_PERIODO),0) AS NF_RECEBIDA"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(ZD_QTDNFRE) * B1_CONV ELSE SUM(ZD_QTDNFRE) END FROM "+RetSqlName("SZD")+" ZD WHERE ZD.ZD_CONTRA = SZ3.Z3_CONTRA AND ZD.ZD_PERIODO = SZ3.Z3_PERIODO AND ZD_STATUS = 'AT' AND ZD_EMISREM <= '"+DtoS(MV_PAR06)+"' AND ZD.D_E_L_E_T_ = '' GROUP BY ZD.ZD_CONTRA+ZD.ZD_PERIODO),0) AS NF_TRANSITO"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(ZD_QTDREC)  * B1_CONV ELSE SUM(ZD_QTDREC)  END FROM "+RetSqlName("SZD")+" ZD WHERE ZD.ZD_CONTRA = SZ3.Z3_CONTRA AND ZD.ZD_PERIODO = SZ3.Z3_PERIODO AND ZD_DTETERM <= '"+DtoS(MV_PAR06)+"' AND ZD.D_E_L_E_T_ = '' GROUP BY ZD.ZD_CONTRA+ZD.ZD_PERIODO),0) AS NF_DESCARGA"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(C6_QTDENT)  * B1_CONV ELSE SUM(C6_QTDENT)  END FROM "+RetSqlName("SC5")+" C5, "+RetSqlName("SC6")+" C6 WHERE C6.C6_PRODUTO = SZ2.Z2_CODPRO AND C6.C6_CF = '7501' AND C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C5_TIPO = 'N' AND C5_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' GROUP BY C6.C6_PRODUTO),0) AS PV_EXPORT"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(C6_QTDENT)  * B1_CONV ELSE SUM(C6_QTDENT)  END FROM "+RetSqlName("SC5")+" C5, "+RetSqlName("SC6")+" C6 , "+RetSqlName("EEC")+" EC WHERE C6.C6_PRODUTO = SZ2.Z2_CODPRO AND C6.C6_CF = '7501' AND C6.C6_FILIAL = C5.C5_FILIAL AND C6.C6_NUM = C5.C5_NUM AND C6.C6_NUM = EC.EEC_PEDREF AND EC.EEC_DTEMBA <> '' AND C5_TIPO = 'N' AND C5_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND C5.D_E_L_E_T_ = '' AND C6.D_E_L_E_T_ = '' AND EC.D_E_L_E_T_ = '' GROUP BY C6.C6_PRODUTO),0) AS PV_EXPDTBL"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D1_QUANT)   * B1_CONV ELSE SUM(D1_QUANT)   END FROM "+RetSqlName("SD1")+" D1, "+RetSqlName("SF4")+" F4 WHERE D1.D1_COD = SZ2.Z2_CODPRO AND F4_ESTOQUE = 'S' AND F4_CODIGO = D1_TES AND D1_CF <> '1501' AND D1.D_E_L_E_T_ = '' AND D1_DTDIGIT <= '"+DtoS(MV_PAR06)+"' AND F4.D_E_L_E_T_ = ''	GROUP BY D1.D1_COD),0) AS OUT_ENT"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D2_QUANT)   * B1_CONV ELSE SUM(D2_QUANT)	  END FROM "+RetSqlName("SD2")+" D2, "+RetSqlName("SF4")+" F4 WHERE D2.D2_COD = SZ2.Z2_CODPRO AND F4_ESTOQUE = 'S' AND F4_CODIGO = D2_TES AND D2_CF <> '7501' AND D2.D_E_L_E_T_ = ''	AND D2_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND F4.D_E_L_E_T_ = ''	GROUP BY D2.D2_COD),0) AS OUT_SAI"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D3_QUANT)   * B1_CONV ELSE SUM(D3_QUANT)	  END FROM "+RetSqlName("SD3")+" D3 WHERE D3.D3_COD = SZ2.Z2_CODPRO AND D3_TM  <= '500' AND D3_ESTORNO <> 'S' AND D3_XD1NSEQ = '' AND D3_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND D3.D_E_L_E_T_ = '' GROUP BY D3.D3_COD),0) AS INT_ENT"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(D3_QUANT)   * B1_CONV ELSE SUM(D3_QUANT)	  END FROM "+RetSqlName("SD3")+" D3 WHERE D3.D3_COD = SZ2.Z2_CODPRO AND D3_TM  >= '501' AND D3_ESTORNO <> 'S' AND D3_XD1NSEQ = '' AND D3_EMISSAO <= '"+DtoS(MV_PAR06)+"' AND D3.D_E_L_E_T_ = '' GROUP BY D3.D3_COD),0) AS INT_SAI"+cEnt
cQuery += "	,ISNULL((SELECT CASE WHEN B1_CONV <> 1 THEN SUM(B2_QATU)    * B1_CONV ELSE SUM(B2_QATU)	  END FROM "+RetSqlName("SB2")+" B2 WHERE B2_COD = Z2_CODPRO AND D_E_L_E_T_ = ''),0) AS SLD_EST"+cEnt
cQuery += "	,Z2_CODPRO"+cEnt
cQuery += "	FROM "+RetSqlName("SZ2")+" SZ2, "+RetSqlName("SZ3")+" SZ3, "+RetSqlName("SY9")+" SY9, "+RetSqlName("CN9")+" CN9, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SBM")+" SBM "+cEnt
cQuery += "	WHERE"+cEnt
cQuery += "	SubString(Z2_CONTRA,1,1)='P'"+cEnt
cQuery += "	AND Z2_CONTRA = Z3_CONTRA"+cEnt
cQuery += "	AND SubString(Z2_CODPRO,LEN(RTRIM(Z2_CONTRA))+2,10) = Z3_PERIODO"+cEnt
cQuery += "	AND Z3_PORTO		= Y9_COD"+cEnt
cQuery += "	AND CN9_NUMERO		= Z2_CONTRA"+cEnt
cQuery += "	AND B1_COD			= Z2_CODPRO"+cEnt                                                          
cQuery += "	AND B1_GRUPO		= BM_GRUPO"+cEnt

If !Empty(MV_PAR01)
	cQuery += "	AND Y9_COD = '"+MV_PAR01+"'"+cEnt
EndIf

If !Empty(MV_PAR02)
	cQuery += "	AND CN9_XFORNE LIKE '%"+Alltrim(MV_PAR02)+"%'"+cEnt
EndIf
 
If !Empty(MV_PAR03)
	cQuery += "	AND Z3_SAFRA = '"+MV_PAR03+"'"+cEnt
EndIf

If !Empty(MV_PAR04) .AND. !Empty(MV_PAR05)
	cQuery += "	AND Z3_CONTRA = '"+MV_PAR04+"'"+cEnt
	cQuery += "	AND Z3_PERIODO = '"+MV_PAR05+"'"+cEnt
EndIf

If !Empty(MV_PAR08) .and. MV_PAR08 <> 4
	If MV_PAR08 == 1
		cQuery += "	AND BM_DESC LIKE '%VHP%'"+cEnt
	ElseIf MV_PAR08 == 2
		cQuery += "	AND BM_DESC LIKE '%XTL%'"+cEnt
	Else
		cQuery += "	AND BM_DESC LIKE '%REF%'"+cEnt
	EndIf
EndIf

cQuery += "	AND SZ2.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND SZ3.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND SY9.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND CN9.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND SB1.D_E_L_E_T_	= ''"+cEnt
cQuery += "	AND SBM.D_E_L_E_T_	= ''"+cEnt
cQuery += "	GROUP BY Z3_SAFRA, Z2_CODPRO, Z3_CONTRA, CN9_XFORNE, Z3_PERIODO, Z3_DTINIC, Z3_DTFIM, Z3_DTINEM, Z3_DTFIEM, Z3_QUANT, Y9_DESCR, B1_GRUPO, B1_CONV, BM_DESC)"+cEnt
cQuery += "	AS SZ2"+cEnt
cQuery += "	ORDER BY Z3_CONTRA, Z3_PERIODO"+cEnt

