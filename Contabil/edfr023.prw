#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT Chr(13) + Chr(10)

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo	 ≥ EDFR023     ≥ Autor ≥ Luis Felipe Mattos	≥ Data ≥ 10.03.16 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Relatorio Variacao Cambial        				 		  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Uso 		 ≥ Gera Excel - Contratos			                      	  ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥ Nenhum													  ≥±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
                                                 
User Function EDFR023()

Local 	nOrdem
Local 	cQuery		:= ""
Private cAliasQry 	:= GetNextAlias()
Private cAliasQry2 	:= GetNextAlias()
Private cString    	:= "SZ3"
Private wnrel      	:= "EDFR023"
Private aOrd       	:= {"Comprador"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Relatorio Variacao Cambial"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Relatorio Variacao Cambial", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR023"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR023"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:= "EDFR023"
Private _nlin      	:= 70
Private Cabec1     	:= " "
Private Cabec2     	:= " "
Private nCountnx    := 0
Private aDados      := {}
Private aPos        := {}
Private LCPTXDIA    := .f.

CriaSx1()
     
IF !Pergunte(cPerg,.T.)
	RETURN
ENDIF

If LastKey() == 27
	Return
Endif

If Empty(MV_PAR01)
	MV_PAR01 := LastDay(dDatabase)
EndIf

MV_PAR00 := FirstDay(FirstDay(MV_PAR01)-1) 

// Contas a Pagar ou Ambos
If MV_PAR02 == 1 .or. MV_PAR02 == 3
	cQuery := " SELECT DISTINCT E5_CLIFOR CLIFOR, A2_NREDUZ NREDUZ "+CENT
	cQuery += " ,CASE WHEN A2_CONTA5 <> '' THEN A2_CONTA5 ELSE A2_CONTA END CONTA, A2_CONTA2 CONTA2, A2_CONTA3 CONTA3, A2_CONTA4 CONTA4 "+CENT
	cQuery += " ,E5_PREFIXO PREFIXO, E5_NUMERO NUM, E5_PARCELA PARCELA, 'Pagar'   Modalidade, '' NATUREZA "+CENT
	cQuery += " , CASE WHEN E2_EMIS1 <> '' AND E2_PREFIXO <> 'EFF' THEN E2_EMIS1 ELSE CASE WHEN E2_PREFIXO = 'EFF' THEN CASE WHEN (SELECT EF2_DT_INI FROM EF2010 EF2, EF3010 EF3 WHERE E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = EF3_TITFIN AND EF3_CONTRA = EF2_CONTRA AND EF3_SEQPER = EF2_SEQPER AND EF2.D_E_L_E_T_ = '' AND EF3.D_E_L_E_T_ = '') <> '' THEN (SELECT EF2_DT_INI FROM EF2010 EF2, EF3010 EF3 WHERE E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = EF3_TITFIN AND EF3_CONTRA = EF2_CONTRA AND EF3_SEQPER = EF2_SEQPER AND EF2.D_E_L_E_T_ = '' AND EF3.D_E_L_E_T_ = '') ELSE E2_EMISSAO END END END EMISSAO "+CENT
	cQuery += "	,E2_VALOR VALOR, CASE WHEN E2_TXMOEDA <> '' THEN E2_TXMOEDA ELSE E2_XDOLAR END XDOLAR, E2_VLCRUZ VLCRUZ, E5_DATA DATAMV ,E5_HISTOR HISTOR, SE5.R_E_C_N_O_, E5_TIPO "+CENT
	cQuery += " ,CASE WHEN E5_TXMOEDA <> 0 THEN E5_TXMOEDA ELSE CASE WHEN E5_DATA <= '20161231' THEN M2_MOEDA2 ELSE CASE WHEN E5_TIPODOC = 'CP' THEN E2_XDOLAR ELSE M2_BMOEDA6 END END END TXMOEDA, E5_VALOR, E5_TIPODOC "+CENT
	cQuery += " ,E5_CLIFOR, E5_LOJA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_RECPAG, E5_VLMOED2, E2_SALDO SALDO, E2_HIST HISTTIT, E2_NATUREZ CODNATUR"+CENT
	cQuery += " FROM "+RetSqlName("SE5")+" SE5, "+RetSqlName("SM2")+" SM2, "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2"+CENT
	cQuery += "	WHERE E5_DATA = M2_DATA"+CENT
	cQuery += "	AND E5_CLIFOR = A2_COD"+CENT                                                              
	cQuery += "	AND E5_LOJA = A2_LOJA"+CENT
	cQuery += "	AND E5_CLIFOR = E2_FORNECE"+CENT
	cQuery += "	AND E5_LOJA = E2_LOJA"+CENT
	cQuery += "	AND E5_PREFIXO = E2_PREFIXO"+CENT
	cQuery += "	AND E5_NUMERO = E2_NUM"+CENT
	cQuery += "	AND E5_PARCELA = E2_PARCELA"+CENT
	cQuery += "	AND E5_TIPO = E2_TIPO"+CENT
	cQuery += "	AND E5_SITUACA = ''"+CENT
	cQuery += " AND E5_TIPODOC IN ('VM','VL','CM','BA','CP')"+CENT
	cQuery += " AND E5_RECPAG = 'P'"+CENT
	cQuery += " AND E2_MOEDA = '02'"+CENT

	If MV_PAR02 == 1 // SÛ filtrar quando ambos.
		cQuery += " AND E2_TIPO <> 'PA '"+CENT  
	EndIf	

	cQuery += "	AND E5_DATA <= '"+DtoS(MV_PAR01)+"'"+CENT
	cQuery += "	AND EXISTS (SELECT E5_NUMERO FROM "+RetSqlName("SE5")+" WHERE SE2.E2_NUM = E5_NUMERO AND SE2.E2_PREFIXO = E5_PREFIXO AND SE2.E2_FORNECE = E5_CLIFOR AND SE2.E2_LOJA = E5_LOJA AND E5_DATA BETWEEN '"+DtoS(MV_PAR00)+"' AND '"+DtoS(MV_PAR01)+"')"+CENT // 18/04/17 - Luis Felipe
	cQuery += " AND NOT EXISTS (SELECT E5_NUMERO FROM "+RetSqlName("SE5")+" WHERE SE5.E5_NUMERO = E5_NUMERO AND SE5.E5_PREFIXO = E5_PREFIXO AND SE5.E5_CLIFOR = E5_CLIFOR AND SE5.E5_LOJA = E5_LOJA AND SE5.E5_SEQ = E5_SEQ AND E5_TIPODOC = 'ES')"+CENT // 19/04/17 - Luis Felipe
	If !Empty(MV_PAR05)
		If !Empty(MV_PAR06)
			cQuery += "	AND A2_COD = '"+MV_PAR05+"'"+CENT
			cQuery += "	AND A2_LOJA = '"+MV_PAR06+"'"+CENT
		Else
			cQuery += "	AND A2_COD = '"+MV_PAR05+"'"+CENT
		EndIf
	EndIf
	If !Empty(MV_PAR07)
		cQuery += "	AND E5_NUMERO = '"+Alltrim(MV_PAR07)+"'"+CENT
	EndIf
	cQuery += " AND SA2.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SE2.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SE5.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SM2.D_E_L_E_T_ = ''"+CENT

    // 30/08/18 - Luis Felipe - Inicio 
    // Com a atualizaÁ„o de vers„o P12 as baixas de titulos ACC s„o criadas sobre a SE5 fazendo referÍncia ao campo KEY.
        
	cQuery += " UNION "+CENT 	

	cQuery += " SELECT DISTINCT E5_CLIFOR CLIFOR, A2_NREDUZ NREDUZ "+CENT
	cQuery += " ,CASE WHEN A2_CONTA5 <> '' THEN A2_CONTA5 ELSE A2_CONTA END CONTA, A2_CONTA2 CONTA2, A2_CONTA3 CONTA3, A2_CONTA4 CONTA4 "+CENT
	cQuery += " ,E2_PREFIXO PREFIXO, E2_NUM NUM, E2_PARCELA PARCELA, 'Pagar'   Modalidade, '' NATUREZA "+CENT
	cQuery += " , CASE WHEN E2_EMIS1 <> '' AND E2_PREFIXO <> 'EFF' THEN E2_EMIS1 ELSE CASE WHEN E2_PREFIXO = 'EFF' THEN (SELECT EF2_DT_INI FROM "+RetSqlName("EF2")+" EF2, "+RetSqlName("EF3")+" EF3 WHERE E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = EF3_TITFIN AND EF3_CONTRA = EF2_CONTRA AND EF3_SEQPER = EF2_SEQPER AND EF2.D_E_L_E_T_ = '' AND EF3.D_E_L_E_T_ = '') ELSE E2_EMISSAO END END EMISSAO
	cQuery += "	,E2_VALOR VALOR, CASE WHEN E2_TXMOEDA <> '' THEN E2_TXMOEDA ELSE E2_XDOLAR END XDOLAR, E2_VLCRUZ VLCRUZ, E5_DATA DATAMV ,E5_HISTOR HISTOR, SE5.R_E_C_N_O_, Substring(E5_KEY,14,3) E5_TIPO "+CENT
	cQuery += " ,CASE WHEN E5_TXMOEDA <> 0 THEN E5_TXMOEDA ELSE CASE WHEN E5_DATA <= '20161231' THEN M2_MOEDA2 ELSE M2_BMOEDA6 END END TXMOEDA, E5_VALOR, E5_TIPODOC"+CENT 
	cQuery += " ,E5_CLIFOR, E5_LOJA, E2_PREFIXO E5_PREFIXO, E2_NUM E5_NUMERO, E2_PARCELA E5_PARCELA, E5_RECPAG, E5_VLMOED2, E2_SALDO SALDO, E2_HIST HISTTIT, E2_NATUREZ CODNATUR"+CENT
	cQuery += " FROM "+RetSqlName("SE5")+" SE5, "+RetSqlName("SM2")+" SM2, "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2"+CENT
	cQuery += "	WHERE E5_DATA = M2_DATA"+CENT
	cQuery += "	AND E5_CLIFOR = A2_COD"+CENT                                                              
	cQuery += "	AND E5_LOJA = A2_LOJA"+CENT
	cQuery += " AND E5_KEY = E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA"+CENT		
	cQuery += "	AND E5_SITUACA = ''"+CENT
	cQuery += " AND E5_TIPODOC IN ('VM','VL','CM','BA','CP')"+CENT
	cQuery += " AND E5_RECPAG = 'P'"+CENT
	cQuery += " AND E2_MOEDA = '02'"+CENT
	cQuery += " AND E5_NUMERO = ''"+CENT
	If MV_PAR02 == 1 
		cQuery += " AND E2_TIPO <> 'PA '"+CENT 
	EndIf	
	cQuery += "	AND E5_DATA <= '"+DtoS(MV_PAR01)+"'"+CENT
	cQuery += "	AND EXISTS (SELECT E5_NUMERO FROM "+RetSqlName("SE5")+" WHERE SE5.E5_KEY = E5_KEY AND E5_DATA BETWEEN '"+DtoS(MV_PAR00)+"' AND '"+DtoS(MV_PAR01)+"')"+CENT 
	cQuery += " AND NOT EXISTS (SELECT E5_NUMERO FROM "+RetSqlName("SE5")+" WHERE SE5.E5_KEY = E5_KEY AND SE5.E5_SEQ = E5_SEQ AND E5_TIPODOC = 'ES')"+CENT 

	If !Empty(MV_PAR05)
		If !Empty(MV_PAR06)
			cQuery += "	AND A2_COD = '"+MV_PAR05+"'"+CENT
			cQuery += "	AND A2_LOJA = '"+MV_PAR06+"'"+CENT
		Else
			cQuery += "	AND A2_COD = '"+MV_PAR05+"'"+CENT
		EndIf
	EndIf
	If !Empty(MV_PAR07)
		cQuery += "	AND E2_NUM = '"+Alltrim(MV_PAR07)+"'"+CENT
	EndIf
	cQuery += " AND SA2.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SE2.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SE5.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SM2.D_E_L_E_T_ = ''"+CENT
    // 30/08/18 - Luis Felipe - Fim

    // 03/09/18 - Luis Felipe - Inicio
    // Com a atualizaÁ„o de vers„o P12 ao se prorrogar ou liquidar um titulo de juros ACC o sistema exclui toda a movimentaÁ„o de variaÁ„o cambial e o titulo a pagar.
    // ApÛs isso recria o titulo com a data de emiss„o do dia da movimentaÁ„o. Perdendo, com isso, todo o histÛrico do tÌtulo.
    // Para recompor o relatÛrio de VariaÁ„o Cambial criamos uma tabela especÌfica a SZM, onde ser„o armazenados os registros de VariaÁ„o Cambial antes de sua execlus„o. E 
    // puxamos esses dados atravÈs da query abaixo. 

	cQuery += " UNION "+CENT 	

	cQuery += " SELECT DISTINCT ZM_CLIFOR CLIFOR, A2_NREDUZ NREDUZ"+CENT
	cQuery += " ,CASE WHEN A2_CONTA5 <> '' THEN A2_CONTA5 ELSE A2_CONTA END CONTA, A2_CONTA2 CONTA2, A2_CONTA3 CONTA3, A2_CONTA4 CONTA4"+CENT
	cQuery += " ,ZM_PREFIXO PREFIXO, ZM_NUMERO NUM, ZM_PARCELA PARCELA, 'Pagar'   Modalidade, '' NATUREZA"+CENT
	cQuery += " ,CASE WHEN (SELECT EF2_DT_INI FROM "+RetSqlName("EF2")+" EF2, "+RetSqlName("EF3")+" EF3 WHERE E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = EF3_TITFIN AND EF3_CONTRA = EF2_CONTRA AND EF3_SEQPER = EF2_SEQPER AND EF2.D_E_L_E_T_ = '' AND EF3.D_E_L_E_T_ = '') <> '' THEN (SELECT EF2_DT_INI FROM "+RetSqlName("EF2")+" EF2, "+RetSqlName("EF3")+" EF3 WHERE E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA = EF3_TITFIN AND EF3_CONTRA = EF2_CONTRA AND EF3_SEQPER = EF2_SEQPER AND EF2.D_E_L_E_T_ = '' AND EF3.D_E_L_E_T_ = '') ELSE E2_EMIS1 END EMISSAO"+CENT
	cQuery += " ,E2_VALOR VALOR, E2_XDOLAR XDOLAR, E2_VLCRUZ VLCRUZ, ZM_DATA DATAMV ,ZM_HISTOR HISTOR, ZM_REGSE5 R_E_C_N_O_, ZM_TIPO E5_TIPO"+CENT
	cQuery += " ,CASE WHEN ZM_TXMOEDA <> 0 THEN ZM_TXMOEDA ELSE CASE WHEN ZM_DATA <= '20161231' THEN M2_MOEDA2 ELSE M2_BMOEDA6 END END TXMOEDA, ZM_VALOR E5_VALOR, ZM_TIPODOC E5_TIPODOC"+CENT
	cQuery += " ,ZM_CLIFOR E5_CLIFOR, ZM_LOJA E5_LOJA, ZM_PREFIXO E5_PREFIXO, ZM_NUMERO E5_NUMERO, ZM_PARCELA E5_PARCELA, ZM_RECPAG  E5_RECPAG, ZM_VLMOED2 E5_VLMOED2, E2_SALDO SALDO, E2_HIST HISTTIT, E2_NATUREZ CODNATUR"+CENT
	cQuery += " FROM "+RetSqlName("SZM")+" SZM, "+RetSqlName("SM2")+" SM2, "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2"+CENT
	cQuery += " WHERE ZM_DATA = M2_DATA"+CENT
	cQuery += " AND ZM_CLIFOR = A2_COD"+CENT
	cQuery += " AND ZM_LOJA = A2_LOJA"+CENT
	cQuery += " AND ZM_CLIFOR = E2_FORNECE"+CENT
	cQuery += " AND ZM_LOJA = E2_LOJA"+CENT
	cQuery += " AND ZM_PREFIXO = E2_PREFIXO"+CENT
	cQuery += " AND ZM_NUMERO = E2_NUM"+CENT
	cQuery += " AND ZM_PARCELA = E2_PARCELA"+CENT
	cQuery += " AND ZM_TIPO = E2_TIPO"+CENT
	cQuery += " AND ZM_SITUACA = ''"+CENT
	cQuery += " AND ZM_TIPODOC = 'VM'"+CENT
	cQuery += " AND ZM_RECPAG = 'P'"+CENT
	cQuery += " AND E2_MOEDA = '02'"+CENT
	cQuery += " AND E2_PREFIXO = 'EFF'"+CENT
	cQuery += "	AND ZM_DATA <= '"+DtoS(MV_PAR01)+"'"+CENT
	If !Empty(MV_PAR07)
		cQuery += "	AND E2_NUM = '"+Alltrim(MV_PAR07)+"'"+CENT
	EndIf
	cQuery += " AND SA2.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SE2.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SZM.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SM2.D_E_L_E_T_ = ''"+CENT
    // 03/09/18 - Luis Felipe - Fim   
EndIf

// Contas a Pagar ou Contas a Receber ou Ambos
If MV_PAR02 == 1 .or. MV_PAR02 == 2 .or. MV_PAR02 == 3
	If MV_PAR02 == 2 // Contas a Receber
		cQuery := " SELECT DISTINCT E5_CLIFOR CLIFOR, A1_NREDUZ NREDUZ"+CENT
		cQuery += " ,CASE WHEN A1_CONTA5 <> '' THEN A1_CONTA5 ELSE A1_CONTA END CONTA, A1_CONTA2 CONTA2, A1_CONTA3 CONTA3, A1_CONTA4 CONTA4"+CENT
		cQuery += "	,E5_PREFIXO PREFIXO, E1_NUM NUM, E5_PARCELA PARCELA, 'Receber' Modalidade, '' NATUREZA"+CENT
		cQuery += "	,(CASE WHEN E1_EMIS1 <> '' THEN E1_EMIS1 ELSE (SELECT E1_EMISSAO FROM "+RetSqlName("SE1")+" E1 WHERE SubString(SE1.E1_NUM,1,Len(Rtrim(SE1.E1_NUM))-1) = Rtrim(E1.E1_NUM)  AND E1.E1_PREFIXO = SE1.E1_PREFIXO AND E1.E1_TIPO = SE1.E1_TIPO AND E1.E1_PARCELA = SE1.E1_PARCELA AND E1.D_E_L_E_T_ = '') END) AS EMISSAO"+CENT
		cQuery += "	,E1_VALOR VALOR,E1_XDOLAR XDOLAR, E1_VLCRUZ VLCRUZ, E5_DATA DATAMV ,E5_HISTOR HISTOR, SE5.R_E_C_N_O_, E5_TIPO"+CENT
	Else             
		cQuery += "UNION"+CENT
		cQuery += " SELECT DISTINCT E5_CLIFOR CLIFOR, A1_NREDUZ NREDUZ"+CENT
		cQuery += " ,CASE WHEN A1_CONTA5 <> '' THEN A1_CONTA5 ELSE A1_CONTA END CONTA, A1_CONTA2 CONTA2, A1_CONTA3 CONTA3, A1_CONTA4 CONTA4"+CENT
		cQuery += " ,E5_PREFIXO PREFIXO, E1_NUM NUM, E5_PARCELA PARCELA, CASE WHEN E1_TIPO = 'RA ' THEN 'Pagar' ELSE 'Receber' END Modalidade, '' NATUREZA"+CENT
		cQuery += "	,(CASE WHEN E1_EMIS1 <> '' THEN E1_EMIS1 ELSE (SELECT E1_EMISSAO FROM "+RetSqlName("SE1")+" E1 WHERE SubString(SE1.E1_NUM,1,Len(Rtrim(SE1.E1_NUM))-1) = Rtrim(E1.E1_NUM)  AND E1.E1_PREFIXO = SE1.E1_PREFIXO AND E1.E1_TIPO = SE1.E1_TIPO AND E1.E1_PARCELA = SE1.E1_PARCELA AND E1.D_E_L_E_T_ = '') END) AS EMISSAO"+CENT
		cQuery += " ,E1_VALOR VALOR, E1_XDOLAR XDOLAR, E1_VLCRUZ VLCRUZ, E5_DATA DATAMV ,E5_HISTOR HISTOR, SE5.R_E_C_N_O_, E5_TIPO"+CENT
	EndIf
	cQuery += " ,CASE WHEN E5_TXMOEDA <> 0 THEN E5_TXMOEDA ELSE M2_MOEDA2 END TXMOEDA,E5_VALOR,E5_TIPODOC"+CENT
	cQuery += " ,E5_CLIFOR, E5_LOJA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_RECPAG, E5_VLMOED2, E1_SALDO SALDO, E1_HIST HISTTIT, E1_NATUREZ CODNATUR"+CENT
	cQuery += " FROM "+RetSqlName("SE5")+" SE5, "+RetSqlName("SM2")+" SM2, "+RetSqlName("SE1")+" SE1, "+RetSqlName("SA1")+" SA1"+CENT
	cQuery += "	WHERE E5_DATA = M2_DATA"+CENT
	cQuery += "	AND E5_CLIFOR = A1_COD"+CENT
	cQuery += "	AND E5_LOJA = A1_LOJA"+CENT
	cQuery += "	AND E5_CLIFOR = E1_CLIENTE"+CENT
	cQuery += "	AND E5_LOJA = E1_LOJA"+CENT
	cQuery += "	AND E5_PREFIXO = E1_PREFIXO"+CENT
	cQuery += "	AND E5_NUMERO = E1_NUM"+CENT
	cQuery += "	AND E5_PARCELA = E1_PARCELA"+CENT
	cQuery += "	AND E5_TIPO = E1_TIPO"+CENT
	cQuery += "	AND E5_SITUACA = ''"+CENT
	cQuery += " AND E5_TIPODOC IN ('VM','VL','CM','BA','CP')"+CENT
	cQuery += " AND E5_RECPAG = 'R'"+CENT
	cQuery += " AND E1_MOEDA = '02'"+CENT
	cQuery += "	AND E5_DATA <= '"+DtoS(MV_PAR01)+"'"+CENT

	// Contas a Receber ou Ambos
	If MV_PAR02 == 2 .or. MV_PAR02 == 3 // SÛ filtrar quando ambos.
		cQuery += " AND E1_TIPO <> 'RA '"+CENT  
	Else
		cQuery += " AND E1_TIPO = 'RA '"+CENT  
	EndIf	

	cQuery += "	AND EXISTS (SELECT E5_NUMERO FROM "+RetSqlName("SE5")+" WHERE SE1.E1_NUM = E5_NUMERO AND SE1.E1_PREFIXO = E5_PREFIXO AND SE1.E1_CLIENTE = E5_CLIFOR AND SE1.E1_LOJA = E5_LOJA AND E5_DATA BETWEEN '"+DtoS(MV_PAR00)+"' AND '"+DtoS(MV_PAR01)+"')"+CENT // 18/04/17 - Luis Felipe
	cQuery += " AND NOT EXISTS (SELECT E5_NUMERO FROM "+RetSqlName("SE5")+" WHERE SE5.E5_NUMERO = E5_NUMERO AND SE5.E5_PREFIXO = E5_PREFIXO AND SE5.E5_CLIFOR = E5_CLIFOR AND SE5.E5_LOJA = E5_LOJA AND SE5.E5_SEQ = E5_SEQ AND E5_TIPODOC = 'ES')"+CENT // 19/04/17 - Luis Felipe
	If !Empty(MV_PAR03)
		If !Empty(MV_PAR04)
			cQuery += "	AND A1_COD = '"+MV_PAR03+"'"+CENT
			cQuery += "	AND A1_LOJA = '"+MV_PAR04+"'"+CENT
		Else
			cQuery += "	AND A1_COD = '"+MV_PAR03+"'"+CENT
		EndIf
	EndIf
	If !Empty(MV_PAR07)
		cQuery += "	AND E5_NUMERO = '"+Alltrim(MV_PAR07)+"'"+CENT
	EndIf
	cQuery += " AND SA1.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SE1.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SE5.D_E_L_E_T_ = ''"+CENT
	cQuery += " AND SM2.D_E_L_E_T_ = ''"+CENT
	cQuery += "	AND NOT EXISTS (SELECT E5_PREFIXO,E5_NUMERO,E5_PARCELA,E5_TIPO,E5_CLIFOR,E5_LOJA"+CENT
	cQuery += "	FROM "+RetSqlName("SE5")+" E5 WHERE E5.E5_PREFIXO = E1_PREFIXO AND E5.E5_NUMERO = E1_NUM "+CENT
	cQuery += "	AND E5.E5_PARCELA = E1_PARCELA AND E5.E5_TIPO = E1_TIPO AND E5.E5_CLIFOR = E1_CLIENTE "+CENT
	cQuery += "	AND E5.E5_LOJA = E1_LOJA AND E5.E5_TIPODOC = 'ES' "+CENT
	cQuery += "	AND E5.E5_RECPAG = 'P' AND E5.E5_SEQ = SE5.E5_SEQ AND E5.D_E_L_E_T_ = '')"+CENT

    // 29/08/18 - Luis Felipe - Inicio
	// Os titulos do tipo PA - Pagamento Antecipado, por razıes cont·beis, devem contas nas movimentaÁıes do Contas a Receber  
	
	If MV_PAR02 == 2 .or. MV_PAR02 == 3 // SÛ filtrar quando for Receber ou ambos.
		cQuery += "UNION" +CENT
		cQuery += " SELECT DISTINCT E5_CLIFOR CLIFOR, A2_NREDUZ NREDUZ "+CENT
		cQuery += " ,CASE WHEN A2_CONTA5 <> '' THEN A2_CONTA5 ELSE A2_CONTA END CONTA, A2_CONTA2 CONTA2, A2_CONTA3 CONTA3, A2_CONTA4 CONTA4 "+CENT
		cQuery += " ,E5_PREFIXO PREFIXO, E5_NUMERO NUM, E5_PARCELA PARCELA, 'Receber'   Modalidade, '' NATUREZA, CASE WHEN E2_EMIS1 <> '' THEN E2_EMIS1 ELSE E2_EMISSAO END EMISSAO "+CENT
		cQuery += "	,E2_VALOR VALOR, CASE WHEN E2_TXMOEDA <> '' THEN E2_TXMOEDA ELSE E2_XDOLAR END XDOLAR, E2_VLCRUZ VLCRUZ, E5_DATA DATAMV ,E5_HISTOR HISTOR, SE5.R_E_C_N_O_, E5_TIPO "+CENT
		cQuery += " ,CASE WHEN E5_TXMOEDA <> 0 THEN E5_TXMOEDA ELSE CASE WHEN E5_DATA <= '20161231' THEN M2_BMOEDA6 ELSE M2_MOEDA2 END END TXMOEDA, E5_VALOR, E5_TIPODOC"+CENT // 19/04/17 - Luis Felipe - Restaurado // 20/04/17 - Luis Felipe 
		cQuery += " ,E5_CLIFOR, E5_LOJA, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_RECPAG, E5_VLMOED2, E2_SALDO SALDO, E2_HIST HISTTIT, E2_NATUREZ CODNATUR"+CENT
		cQuery += " FROM "+RetSqlName("SE5")+" SE5, "+RetSqlName("SM2")+" SM2, "+RetSqlName("SE2")+" SE2, "+RetSqlName("SA2")+" SA2"+CENT
		cQuery += "	WHERE E5_DATA = M2_DATA"+CENT
		cQuery += "	AND E5_CLIFOR = A2_COD"+CENT                                                              
		cQuery += "	AND E5_LOJA = A2_LOJA"+CENT
		cQuery += "	AND E5_CLIFOR = E2_FORNECE"+CENT
		cQuery += "	AND E5_LOJA = E2_LOJA"+CENT
		cQuery += "	AND E5_PREFIXO = E2_PREFIXO"+CENT
		cQuery += "	AND E5_NUMERO = E2_NUM"+CENT
		cQuery += "	AND E5_PARCELA = E2_PARCELA"+CENT
		cQuery += "	AND E5_TIPO = E2_TIPO"+CENT
		cQuery += "	AND E5_SITUACA = ''"+CENT
		cQuery += " AND E5_TIPODOC IN ('VM','VL','CM','BA','CP')"+CENT
		cQuery += " AND E5_RECPAG = 'P'"+CENT
		cQuery += " AND E2_MOEDA = '02'"+CENT
		cQuery += " AND E2_TIPO = 'PA '"+CENT
		cQuery += "	AND E5_DATA <= '"+DtoS(MV_PAR01)+"'"+CENT
		cQuery += "	AND EXISTS (SELECT E5_NUMERO FROM "+RetSqlName("SE5")+" WHERE SE2.E2_NUM = E5_NUMERO AND SE2.E2_PREFIXO = E5_PREFIXO AND SE2.E2_FORNECE = E5_CLIFOR AND SE2.E2_LOJA = E5_LOJA AND E5_DATA BETWEEN '"+DtoS(MV_PAR00)+"' AND '"+DtoS(MV_PAR01)+"')"+CENT // 18/04/17 - Luis Felipe
		cQuery += " AND NOT EXISTS (SELECT E5_NUMERO FROM "+RetSqlName("SE5")+" WHERE SE5.E5_NUMERO = E5_NUMERO AND SE5.E5_PREFIXO = E5_PREFIXO AND SE5.E5_CLIFOR = E5_CLIFOR AND SE5.E5_LOJA = E5_LOJA AND SE5.E5_SEQ = E5_SEQ AND E5_TIPODOC = 'ES')"+CENT // 19/04/17 - Luis Felipe
		If !Empty(MV_PAR05)
			If !Empty(MV_PAR06)
				cQuery += "	AND A2_COD = '"+MV_PAR05+"'"+CENT
				cQuery += "	AND A2_LOJA = '"+MV_PAR06+"'"+CENT
			Else
				cQuery += "	AND A2_COD = '"+MV_PAR05+"'"+CENT
			EndIf
		EndIf
		If !Empty(MV_PAR07)
			cQuery += "	AND E5_NUMERO = '"+Alltrim(MV_PAR07)+"'"+CENT
		EndIf
		cQuery += " AND SA2.D_E_L_E_T_ = ''"+CENT
		cQuery += " AND SE2.D_E_L_E_T_ = ''"+CENT
		cQuery += " AND SE5.D_E_L_E_T_ = ''"+CENT
		cQuery += " AND SM2.D_E_L_E_T_ = ''"+CENT
	EndIf
    // 29/08/18 - Luis Felipe - Fim
EndIf
cQuery += " ORDER BY EMISSAO, E5_TIPO, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_DATA, R_E_C_N_O_"+CENT
	
MemoWrite("C:\Tmp\EDFR023.txt",cQuery)
cQuery := ChangeQuery(cQuery)

If Select(cAliasQry) > 0
	dbSelectArea(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

Processa ( { ||  GeraPlan()  } )

If Select(cAliasQry) > 0
	dbselectarea(cAliasQry)
	(cAliasQry)->(dbCloseArea())
Endif

Return

**************************
Static Function GeraPlan()
**************************

Local oExcel
Local cArq
Local nArq
Local cPath
Local cXml 		:= ""
Local nLin 		:= 15
Local nCont		:= 0
Local nVBRL1 	:= 0
Local nVBRL2 	:= 0
Local nTVCNR 	:= 0
Local nVCNR1 	:= 0
Local nVCNR2 	:= 0
Local nTVCR  	:= 0
Local nVCR1 	:= 0
Local nVCR2 	:= 0
Local nTSaldoUS := 0
Local nTSaldoR  := 0
Local nSaldo 	:= 0
Local nPosParc	:= 0 
Local lMudaTx   := .t.
Local nUltTxCor := 0 
Local nUltTxCor16 := 0
Local nUltTxCor22 := 0
Local cChave    := ''
Local nTVCNRx   := 0
Local nValorUSD := 0 
Local nValorBrl := 0 
Local lCorrige  := 0
Local lSaldo	:= .f. 
Local nUltTxFM  := 0

If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel n„o instalado!")
	Return
EndIf

cArq := CriaTrab(Nil, .F.)
cPath := "C:\TEMP\"
Makedir(cPath)

nArq := FCreate(cPath + cArq + ".xml")

If nArq == -1
	MsgAlert("Erro ao criar o arquivo: "+cPath + cArq + ".xml")
	Return
EndIf

If !(cAliasQry)->(EOF())          
	
	While !(cAliasQry)->(EOf())
	   
		lSaldo := .f.

		// Existem correÁıes monet·rias sobre tÌtulos do contas a receber excluidos
		If	Empty((cAliasQry)->NUM) .or. ('LIQUIDAC‰O JU' $ (cAliasQry)->HISTTIT .and. (cAliasQry)->PARCELA = '0') .or. ;
		    ((MV_PAR02 == 2 .or. MV_PAR02 == 3) .and. (cAliasQry)->CLIFOR=='000061')
			(cAliasQry)->(Dbskip())
			Loop
		EndIf

		cConta := Alltrim((cAliasQry)->CONTA)		

		If	'MTM' $ (cAliasQry)->NREDUZ .and. (cAliasQry)->E5_RECPAG == 'P'
			If Rtrim((cAliasQry)->E5_TIPO) $ 'JP|JUR' 
				If (cAliasQry)->PREFIXO == 'GRA'  
					cConta := '22101061'
				Else
					cConta := '22101060'		
				EndIf		
			Else
				If	Rtrim((cAliasQry)->PARCELA) == '0' .and. (cAliasQry)->PREFIXO == 'EFF'	 
					cConta := '21400060'		
				ElseIf Rtrim((cAliasQry)->PARCELA) == '1' .and. (cAliasQry)->PREFIXO == 'EFF'	 
					cConta := '21401064'
				Else	
					cConta := '21700020'		
				EndIf 
			EndIf
		EndIf
        
		If Rtrim((cAliasQry)->E5_TIPO) == 'PA'
			If Rtrim((cAliasQry)->CODNATUR) == '0053'
				cConta := '11302020'
			ElseIf Rtrim((cAliasQry)->CODNATUR) == '0057'
				cConta := '11402020'
			EndIf	
		EndIf

		If Rtrim((cAliasQry)->CODNATUR) == 'HEDGE' 
			If (cAliasQry)->E5_RECPAG == 'R'
				cConta := '11202085'
			Else
				cConta := '21700022'
			EndIf	
		EndIf

		If Rtrim((cAliasQry)->E5_TIPO) == 'RA'
			cConta := '21500010'
		EndIf

		// Conta de funcion·rio 
		If Rtrim((cAliasQry)->CONTA) == '21200010' .and. !cConta $ '11302020|11402020'
			cConta := '21200020'
		EndIf

		If	!Empty(MV_PAR08) 
		    If Rtrim(cConta) <> Alltrim(MV_PAR08)
				(cAliasQry)->(Dbskip())
				Loop
			EndIf	 
		EndIf	 

		// Pesquisa a taxa da ˙ltima correÁ„o monet·ria calculada
		If Month(StoD((cAliasQry)->DATAMV)) <> Month(MV_PAR01)
			dDtMov := LastDay(MV_PAR01-70)
		Else
			dDtMov := FirstDay(CtoD(SubStr((cAliasQry)->DATAMV,7,2)+"/"+SubStr((cAliasQry)->DATAMV,5,2)+"/"+SubStr((cAliasQry)->DATAMV,1,4)))-1
		EndIF	  
		
		If (cAliasQry)->E5_RECPAG <> 'P'
			cQuery := ""
			cQuery += " SELECT M2_MOEDA2 E5_TXMOEDA"+CENT
			cQuery += " FROM "+RetSqlName("SM2")+CENT
			If !(cAliasQry)->E5_TIPODOC $ 'CM/VM' 
				cQuery += " WHERE M2_DATA = '"+DtoS(dDtMov)+"'"+CENT
			Else
				cQuery += " WHERE M2_DATA = '"+(cAliasQry)->DATAMV+"'"+CENT
			EndIf
			MemoWrite("C:\Tmp\EDFR023T.txt",cQuery)
			cQuery := ChangeQuery(cQuery)

			If Select(cAliasQry2) > 0
				dbSelectArea(cAliasQry2)
				(cAliasQry2)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry2,.T.,.T.)
			
			nUltTxCor := (cAliasQry2)->E5_TXMOEDA
		Else
			// Devido ao a mudanÁa de uso de taxa de compra e vendas entre o que est· antes de 2017 e o que est· apÛs 
			// e existirem calculos para titulos a pagar e receber tornou-se necess·rio criar variaÁıes de taxa por 
			// vari·vel dando origem nUltTxCor16, usada para titulos a pagar sobre a coluna 16, nUltTxCor16 tambÈm
			// para titulos a pagar,porÈm, sobre a coluna 22 do relatÛrio e por fim nUltTxCor para os tÌtulos a 
			// receber que sempre s„o calculados com o dolar de compra. 

			SM2->(DbSetOrder(1))
			If !(cAliasQry)->E5_TIPODOC $ 'CM/VM' 
				SM2->(DBSeek(DtoS(dDtMov)))
			Else
				SM2->(DBSeek((cAliasQry)->DATAMV))
			EndIf
			
			nUltTxCor16 := If((cAliasQry)->DATAMV <= '20161231' .and. (cAliasQry)->EMISSAO <='20161231',SM2->M2_MOEDA2,If((cAliasQry)->DATAMV > '20161231' .and. (cAliasQry)->EMISSAO > '20161231',SM2->M2_BMOEDA6,If(((cAliasQry)->DATAMV >= '20170101' .and. (cAliasQry)->DATAMV <= '20170131') .and. (cAliasQry)->EMISSAO <= '20161231',SM2->M2_MOEDA2,SM2->M2_BMOEDA6)))
			If  (cAliasQry)->E5_RECPAG == 'P'  
				nUltTxCor16 := SM2->M2_MOEDA2
			EndIf
			nUltTxCor22 := SM2->M2_BMOEDA6

			// ExceÁ„o de CompensaÁ„o de TÌtulos - Taxa do dia.
			lCPTxDia  := .f.
			If (cAliasQry)->E5_RECPAG == 'P' .and. (cAliasQry)->E5_TIPO == 'NF '.and. (cAliasQry)->E5_TIPODOC == 'CP'  
				SM2->(DBSeek((cAliasQry)->DATAMV))
				lCPTxDia  := .t.
            EndIf
		EndIf
			
		// Ultima taxa de correÁ„o fora meses selecionados - Se Out - traz tx de Ago
		If Month(StoD((cAliasQry)->DATAMV)) <> Month(MV_PAR01) .and. lMudaTx  
			nUltTxFM := If((cAliasQry)->E5_RECPAG == 'P',nUltTxCor16,nUltTxCor) // » usada apenas uma vez na criaÁ„o da linha   
			lMudaTx  := .f.
			cChave   := (cAliasQry)->E5_NUMERO + (cAliasQry)->E5_PARCELA 
		EndIf
	
		nPos := aScan(aPos,{|x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6] == (cAliasQry)->(CLIFOR+PREFIXO+NUM+PARCELA+Modalidade+E5_TIPO)})
		
		If	nPos == 0
			nLin ++
			Aadd(aPos  ,{(cAliasQry)->CLIFOR,(cAliasQry)->PREFIXO,(cAliasQry)->NUM,(cAliasQry)->PARCELA,(cAliasQry)->Modalidade,(cAliasQry)->E5_TIPO})
			
			Aadd(aDados,{(cAliasQry)->CLIFOR,;                           																	// 1
			Alltrim((cAliasQry)->NREDUZ),;                               																	// 2
			cConta,;                                																						// 3
			Alltrim((cAliasQry)->CONTA2),;                               																	// 4
			Alltrim((cAliasQry)->CONTA3),;                               																	// 5
			Alltrim((cAliasQry)->CONTA4),;                               																	// 6
			(cAliasQry)->NUM,;                                           																	// 7
			(cAliasQry)->MODALIDADE,;                                    																	// 8
			(cAliasQry)->NATUREZA,;                                      																	// 9
			(cAliasQry)->EMISSAO,;                                       																	// 10
			(cAliasQry)->VALOR,;  																											// 11 // 30/08/18 - Luis Felipe                    
			(cAliasQry)->XDOLAR,;                                        																	// 12
			(cAliasQry)->VALOR * (cAliasQry)->XDOLAR,;																						// 13 // 30/08/18 - Luis Felipe
			'',;																															// 14
			'',;																															// 15
			0,;																																// 16
			0,;																																// 17
			0,;																																// 18
			0,;																																// 19
			'',;																															// 20
			'',;																															// 21
			0,;																																// 22
			0,;																																// 23
			0,;																																// 24
			0,;																																// 25
			0,;																																// 26
			(cAliasQry)->E5_TIPO,;                                                                                                          // 27
			(cAliasQry)->CLIFOR+(cAliasQry)->E5_LOJA,;																						// 28
			(cAliasQry)->PREFIXO,;																											// 29
			(cAliasQry)->NUM,;																												// 30
			(cAliasQry)->PARCELA,;																											// 31
			(cAliasQry)->Modalidade,;																										// 32
			(cAliasQry)->E5_TIPO,;                                                                                                          // 33
			0})																																// 34
		EndIf

//      30/08/18 - Luis Felipe 
//      Colunas 11 e 13 antes da alteraÁ„o - com a mudanÁa de vers„o o sistema passou excluir as VM anteriores a baixa
            
//		If(!Empty((cAliasQry)->E5_VLMOED2) .and. (cAliasQry)->E5_TIPODOC $ 'VL/BA',(cAliasQry)->E5_VLMOED2,(cAliasQry)->VALOR),;  								// 11 // 28/08/17 - Luis Felipe - antes 'VL/BA/CP'
//		If(!Empty((cAliasQry)->E5_VLMOED2) .and. (cAliasQry)->E5_TIPODOC $ 'VL/BA',(cAliasQry)->E5_VLMOED2,(cAliasQry)->VALOR) * (cAliasQry)->XDOLAR,;			// 13 // 28/08/17 - Luis Felipe - antes 'VL/BA/CP'

		nPos := Len(aDados)  // Ultima sequencia de registro novo
		
		// Posiciona no registro da baixa parcial
		If	nSaldo <> 0 .and. (cAliasQry)->(CLIFOR+PREFIXO+NUM+PARCELA+Modalidade+E5_TIPO) == aDados[nPosParc][28]+aDados[nPosParc][29]+aDados[nPosParc][30]+aDados[nPosParc][31]+aDados[nPosParc][32]+aDados[nPosParc][33]
		    nPos := nPosParc
		EndIf

		// Caso tenha movimentaÁ„o mÍs anterior ao de referÍncia  
		// Colunas mÍs 1
		If Month(StoD((cAliasQry)->DATAMV)) <> Month(MV_PAR01) .and. (cAliasQry)->E5_TIPODOC <> 'CM' 
			aDados[nPos][14] := (cAliasQry)->DATAMV                               
			aDados[nPos][15] := Alltrim((cAliasQry)->HISTOR)                      
			aDados[nPos][16] := If(lCPTxDia,SM2->M2_MOEDA2,(cAliasQry)->TXMOEDA)           
			aDados[nPos][17] := aDados[nPos][11] * aDados[nPos][16]          
			If (cAliasQry)->E5_TIPODOC $ 'VL/BA/CP' 
				aDados[nPos][18] := If(Month(StoD((cAliasQry)->EMISSAO)) == Month(StoD((cAliasQry)->DATAMV)),0,((If((cAliasQry)->E5_RECPAG == 'P',nUltTxCor16,nUltTxCor)*aDados[nPos][11])-aDados[nPos][12]*aDados[nPos][11])*-1)  
			Else
				If Month(StoD((cAliasQry)->EMISSAO)) == Month(StoD((cAliasQry)->DATAMV)) .and. Year(StoD((cAliasQry)->EMISSAO)) == Year(StoD((cAliasQry)->DATAMV))
					aDados[nPos][18] := ((aDados[nPos][16] * aDados[nPos][11])-(aDados[nPos][12] * aDados[nPos][11])) 
				Else
					aDados[nPos][18] := ((aDados[nPos][16] * aDados[nPos][11])-(If((cAliasQry)->E5_RECPAG == 'P',nUltTxCor16,nUltTxCor) * aDados[nPos][11]))
				EndIf
			EndIf
			aDados[nPos][19] := aDados[nPos][17] - aDados[nPos][13]
			If Month(StoD((cAliasQry)->DATAMV)) + Year(StoD((cAliasQry)->DATAMV)) == Month(MV_PAR00) + Year(MV_PAR00) .and. aDados[nPos][34] == 0
				aDados[nPos][34] := If((cAliasQry)->E5_RECPAG == 'P',nUltTxCor16,nUltTxCor)
			Else	
				aDados[nPos][34] := If((cAliasQry)->E5_RECPAG == 'P',aDados[nPos][12],nUltTxCor)
			EndIf	
		Else
			// Caso sÛ tenha movimentaÁ„o mÍs atual
			// Como o relatÛrio segue rigorosamente as movimentaÁıes sobre a tabela SE5 e o usu·rio pode n„o respeitar essa ordem 
			// fazendo baixas no prÛprio mÍs apÛs a correÁ„o monet·ria. Ser· necess·rio refazer os calculos de correÁ„o monet·ria 
			// sobre o saldo do tÌtulo no mÍs anterior ao do fechamento. Isso ocorrer· apenas para os titulos com emiss„o anterior
			// ao mÍs em an·lise.
			 
			lCorrige := If(Strzero(Month(StoD((cAliasQry)->EMISSAO)),2)+Str(Year(StoD((cAliasQry)->EMISSAO)),4) <> Strzero(Month(MV_PAR01),2)+Str(Year(MV_PAR01),4),.T.,.F.)
			
			If  lCorrige .and. Empty(aDados[nPos][14]) .and. (cAliasQry)->E5_TIPODOC <> 'CM' 
				aDados[nPos][14] := DtoS(LastDay(FirstDay(MV_PAR01)-1)) 
				aDados[nPos][15] := "CORREC MONET."                      
     			aDados[nPos][16] := If((cAliasQry)->E5_RECPAG == 'P',If(lCPTxDia,SM2->M2_MOEDA2,nUltTxCor16),nUltTxCor)        
      			aDados[nPos][17] := aDados[nPos][11] * aDados[nPos][16]
				If Month(StoD((cAliasQry)->EMISSAO)) == Month(StoD((cAliasQry)->DATAMV))  
					aDados[nPos][18] := If(Month(StoD((cAliasQry)->EMISSAO)) == Month(StoD((cAliasQry)->DATAMV)),0,((If((cAliasQry)->E5_RECPAG == 'P',nUltTxCor16,nUltTxCor)*aDados[nPos][11])-aDados[nPos][12]*aDados[nPos][11])*-1)  
				Else
			  		aDados[nPos][18] := ((aDados[nPos][16] * aDados[nPos][11])-(If((cAliasQry)->E5_RECPAG == 'P',aDados[nPos][34],nUltTxCor) * aDados[nPos][11])) 
				EndIf
				aDados[nPos][19] := (aDados[nPos][11] * aDados[nPos][16]) - (aDados[nPos][11] * aDados[nPos][12]) 
			EndIf

			lCorrige := If(Strzero(Month(StoD((cAliasQry)->DATAMV)),2)+Str(Year(StoD((cAliasQry)->DATAMV)),4) == Strzero(Month(MV_PAR01),2)+Str(Year(MV_PAR01),4),.T.,.F.)

			If lCorrige .and. (cAliasQry)->E5_TIPODOC <> 'CM'      
				aDados[nPos][20] := (cAliasQry)->DATAMV                               
				aDados[nPos][21] := Alltrim((cAliasQry)->HISTOR)                      
				aDados[nPos][22] := If((cAliasQry)->E5_RECPAG == 'P',If(lCPTxDia,SM2->M2_MOEDA2,nUltTxCor16),nUltTxCor)                          
				aDados[nPos][23] := aDados[nPos][11] * aDados[nPos][22]    
				If (cAliasQry)->E5_TIPODOC $ 'VL/BA/CP'
					aDados[nPos][24] := -1 * If(Month(StoD((cAliasQry)->EMISSAO)) == Month(StoD((cAliasQry)->DATAMV)) .and. Year(StoD((cAliasQry)->EMISSAO)) == Year(StoD((cAliasQry)->DATAMV)) ,0,((aDados[nPos][16]*aDados[nPos][11])-(aDados[nPos][12]*aDados[nPos][11])))  
				Else
					If !Empty(aDados[nPos][14]) 
					    // CorreÁ„o sobre o prÛprio mÍs em an·lise 
						aDados[nPos][24] := ((aDados[nPos][22]*aDados[nPos][11])-(aDados[nPos][16]*aDados[nPos][11])) 
					Else 
					    // Quando n„o houver correÁ„o sobre o mÍs anterior
						aDados[nPos][24] := ((aDados[nPos][22]*aDados[nPos][11])-(aDados[nPos][12]*aDados[nPos][11])) 
					EndIf
				EndIf
				aDados[nPos][25] := aDados[nPos][23] - (aDados[nPos][11] *  aDados[nPos][12])
			EndIf
		EndIf
        
		// LiquidaÁ„o de Titulos - Total ou Parcial
		If (cAliasQry)->E5_TIPODOC $ 'VL/BA/CP' .and. (cAliasQry)->E5_VLMOED2 <> aDados[nPos][11] 

			// Recalculo das colunas sobre saldo residual 
			nSaldo := aDados[nPos][11] - If((cAliasQry)->E5_VLMOED2<(cAliasQry)->E5_VALOR,(cAliasQry)->E5_VLMOED2,(cAliasQry)->E5_VALOR) 
	
			// Valor da baixa
			aDados[nPos][11] := If((cAliasQry)->E5_VLMOED2<(cAliasQry)->E5_VALOR,(cAliasQry)->E5_VLMOED2,(cAliasQry)->E5_VALOR) 

			aDados[nPos][13] := aDados[nPos][11] * aDados[nPos][12] // Recalcula o preco em Reais 
			aDados[nPos][17] := aDados[nPos][16] * aDados[nPos][11] // Recalcula o preco em Reais 
			If Month(StoD((cAliasQry)->EMISSAO)) == Month(StoD((cAliasQry)->DATAMV)) .and. Year(StoD((cAliasQry)->EMISSAO)) == Year(StoD((cAliasQry)->DATAMV))
				aDados[nPos][18] := If(Month(StoD((cAliasQry)->EMISSAO)) == Month(StoD((cAliasQry)->DATAMV)),0,((aDados[nPos][16] * aDados[nPos][11])-(aDados[nPos][12] * aDados[nPos][11]))) 
			Else
				If Month(MV_PAR01) <> Month(StoD((cAliasQry)->DATAMV))
					aDados[nPos][18] := ((aDados[nPos][12] * aDados[nPos][11])-(If((cAliasQry)->E5_RECPAG == 'P',aDados[nPos][34],nUltTxCor) * aDados[nPos][11])) 
				Else
					aDados[nPos][18] := ((aDados[nPos][16] * aDados[nPos][11])-(If((cAliasQry)->E5_RECPAG == 'P',aDados[nPos][34],nUltTxCor) * aDados[nPos][11])) 
                    EndIf
			EndIf   
			// VC Realizada 
			aDados[nPos][19] := (aDados[nPos][11] * aDados[nPos][16]) - (aDados[nPos][11] * aDados[nPos][12]) 
			
			If Month(StoD((cAliasQry)->DATAMV)) == Month(MV_PAR01) .and. Year(StoD((cAliasQry)->DATAMV)) == Year(MV_PAR01)
				aDados[nPos][22] := If((cAliasQry)->E5_RECPAG == 'P',If(lCPTxDia,SM2->M2_MOEDA2,nUltTxCor16),nUltTxCor)                          
				aDados[nPos][23] := aDados[nPos][11] * aDados[nPos][22] 
				If Month(StoD((cAliasQry)->EMISSAO)) == Month(StoD((cAliasQry)->DATAMV)) .and. Year(StoD((cAliasQry)->EMISSAO)) == Year(StoD((cAliasQry)->DATAMV))
					aDados[nPos][24] := 0
				Else
					aDados[nPos][24] :=	If((cAliasQry)->E5_TIPODOC $ 'VL/BA/CP',-1,1) * ((aDados[nPos][16]*aDados[nPos][11])-(aDados[nPos][12]*aDados[nPos][11])) 
				EndIf	
				 // VC Realizada
				aDados[nPos][25] := aDados[nPos][23] - (aDados[nPos][11] *  aDados[nPos][12])
			EndIf

			// Novo linha do Saldo do Titulo
			If nSaldo > 0
				nLin ++
				Aadd(aDados,{(cAliasQry)->CLIFOR,;                           					// 1  - Codigo Cliente
				Alltrim((cAliasQry)->NREDUZ),;                               					// 2  - Nome Fantasia
				cConta,;					                                					// 3  - Conta Contabil
				Alltrim((cAliasQry)->CONTA2),;                               					// 4  - 
				Alltrim((cAliasQry)->CONTA3),;                               					// 5
				Alltrim((cAliasQry)->CONTA4),;                               					// 6
				(cAliasQry)->NUM,;                                           					// 7  - Numero Titulo
				(cAliasQry)->MODALIDADE,;                                    					// 8  - Receber ou Pagar
				(cAliasQry)->NATUREZA,;                                      					// 9  - Natureza
				(cAliasQry)->EMISSAO,;                                       					// 10 - Dt. Emissao
			    nSaldo,; 							      				   				     	// 11 - Saldo Residual
				(cAliasQry)->XDOLAR,;                                        					// 12 - Taxa da Emissao
				nSaldo * (cAliasQry)->XDOLAR,;                                                  // 13 - Vlr. Original BRL
				'',;                  															// 14 - Dt. Mvto
				'',;               																// 15 - Tp. Mvto.
				aDados[nPos][16],;																// 16 - Tx. Dolar
				nSaldo * aDados[nPos][16],;														// 17 - Novo Vlr. BRL
				-1 * ((nSaldo * nUltTxFM) - (nSaldo * aDados[nPos][16])),;						// 18 - VC nao Realizada
				0,;																				// 19 - VC Realizada
				'',;																			// 20 - Dt. Mvto
				'',;																			// 21 - Tp. Mvto.
				0,;																				// 22 - Tx. Dolar
				0,;																				// 23 - Novo Vlr. BRL
				0,;																				// 24 - VC nao Realizada
				0,;																				// 25 - VC Realizada
				0,;   																			// 26                 
				(cAliasQry)->E5_TIPO,;															// 27              
				(cAliasQry)->CLIFOR,;															// 28                        
				(cAliasQry)->PREFIXO,;															// 29                     
				(cAliasQry)->NUM,;																// 30
				(cAliasQry)->PARCELA,;															// 31
				(cAliasQry)->Modalidade,;														// 32
				(cAliasQry)->E5_TIPO,aDados[nPos][34]}) 	    								// 33 e 34
				nPosParc := Len(aDados)
				lSaldo := .t. 
			EndIf
			
        EndIf

		// Refaz o calculo da variaÁ„o cambial para o saldo dos titulos baixados quando n„o h· mais movimentaÁ„o de correÁ„o e ou baixa sobre os mesmos.
		
		If lSaldo 

			If StoD(aDados[nPosParc][10]) <= LastDay(FirstDay(MV_PAR01)-1)
				
				aDados[nPosParc][14] := DtoS(dDtMov) 
				aDados[nPosParc][15] := "CORREC MONET."                      
     			aDados[nPosParc][16] := If((cAliasQry)->E5_RECPAG == 'P',If(lCPTxDia,SM2->M2_MOEDA2,nUltTxCor16),nUltTxCor)        
				aDados[nPosParc][13] := aDados[nPosParc][11] * aDados[nPosParc][12]  
				aDados[nPosParc][17] := aDados[nPosParc][16] * aDados[nPosParc][11] 

				If Month(StoD((cAliasQry)->EMISSAO)) == Month(StoD((cAliasQry)->DATAMV)) .and. Year(StoD((cAliasQry)->EMISSAO)) == Year(StoD((cAliasQry)->DATAMV))  
					aDados[nPosParc][18] := ((aDados[nPosParc][16] * aDados[nPosParc][11])-(aDados[nPosParc][12] * aDados[nPosParc][11]))
				Else
					aDados[nPosParc][18] := ((aDados[nPosParc][16] * aDados[nPosParc][11])-(If((cAliasQry)->E5_RECPAG == 'P',aDados[nPosParc][34],nUltTxCor) * aDados[nPosParc][11])) 
				EndIf

				aDados[nPosParc][19] := aDados[nPosParc][17] - (aDados[nPosParc][11] * aDados[nPosParc][12])
		        
	 		EndIf
	 		
			lCorrige := If(Strzero(Month(StoD((cAliasQry)->DATAMV)),2)+Str(Year(StoD((cAliasQry)->DATAMV)),4) == Strzero(Month(MV_PAR01),2)+Str(Year(MV_PAR01),4),.T.,.F.)

			If  lCorrige
				aDados[nPosParc][20] := DtoS(MV_PAR01) 
				aDados[nPosParc][21] := "CORREC MONET."                      
				aDados[nPosParc][22] := If((cAliasQry)->E5_RECPAG == 'P',If(lCPTxDia,SM2->M2_MOEDA2,nUltTxCor16),nUltTxCor)                             
				aDados[nPosParc][23] := aDados[nPosParc][11] * aDados[nPosParc][22] 
				If Month(StoD((cAliasQry)->EMISSAO)) == Month(StoD((cAliasQry)->DATAMV)) .and. Year(StoD((cAliasQry)->DATAMV)) == Year(MV_PAR01)
					aDados[nPosParc][24] := ((aDados[nPosParc][22] * aDados[nPosParc][11])-(aDados[nPosParc][12] * aDados[nPosParc][11])) 
				Else
					aDados[nPosParc][24] := ((aDados[nPosParc][22] * aDados[nPosParc][11])-(If((cAliasQry)->E5_RECPAG == 'P',nUltTxCor22,nUltTxCor) * aDados[nPosParc][11])) 
				EndIf
				aDados[nPosParc][25] := aDados[nPosParc][23] - (aDados[nPosParc][11] *  aDados[nPosParc][12])
			EndIf	
        EndIf

		(cAliasQry)->(DbSkip())
		If cChave <> (cAliasQry)->E5_NUMERO + (cAliasQry)->E5_PARCELA
			lMudaTx  := .t.
		EndIf
	End
	
	ProcRegua(nLin)
	
	cXml := '<?xml version="1.0"?>'+CENT
	cXml += '<?mso-application progid="Excel.Sheet"?>'+CENT
	cXml += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
	cXml += ' xmlns:o="urn:schemas-microsoft-com:office:office"'+CENT
	cXml += ' xmlns:x="urn:schemas-microsoft-com:office:excel"'+CENT
	cXml += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'+CENT
	cXml += ' xmlns:html="http://www.w3.org/TR/REC-html40">'+CENT
	cXml += ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'+CENT
	cXml += '  <Author>Luis Filipe Nascimento</Author>'+CENT
	cXml += '  <LastAuthor>Luis Filipe Nascimento</LastAuthor>'+CENT
	cXml += '  <Created>2016-02-17T17:39:18Z</Created>'+CENT
	cXml += '  <LastSaved>2016-03-17T20:11:37Z</LastSaved>'+CENT
	cXml += '  <Version>15.00</Version>'+CENT
	cXml += ' </DocumentProperties>'+CENT
	cXml += ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">'+CENT
	cXml += '  <AllowPNG/>'+CENT
	cXml += ' </OfficeDocumentSettings>'+CENT
	cXml += ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
	cXml += '  <WindowHeight>7755</WindowHeight>'+CENT
	cXml += '  <WindowWidth>20490</WindowWidth>'+CENT
	cXml += '  <WindowTopX>0</WindowTopX>'+CENT
	cXml += '  <WindowTopY>0</WindowTopY>'+CENT
	cXml += '  <ActiveSheet>1</ActiveSheet>'+CENT
	cXml += '  <Iteration/>'+CENT
	cXml += '  <ProtectStructure>False</ProtectStructure>'+CENT
	cXml += '  <ProtectWindows>False</ProtectWindows>'+CENT
	cXml += ' </ExcelWorkbook>'+CENT
	cXml += ' <Styles>'+CENT
	cXml += '  <Style ss:ID="Default" ss:Name="Normal">'+CENT
	cXml += '   <Alignment ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior/>'+CENT
	cXml += '   <NumberFormat/>'+CENT
	cXml += '   <Protection/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s62" ss:Name="Normal 7">'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s16" ss:Name="VÌrgula">'+CENT
	cXml += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m106110359520">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m106110359540">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="mmmm/yyyy"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m106110359560">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#A9D08E" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="mmmm/yyyy"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="m106110359580" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s70">'+CENT
	cXml += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"'+CENT
	cXml += '    ss:Bold="1"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s101" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s102" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s103" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s104" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s105" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s106" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s107" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s108" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s109" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s110" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s111" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s112" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Double" ss:Weight="3"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s113" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#A9D08E" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s114" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#A9D08E" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s115" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#A9D08E" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s116" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Color="#000000"/>'+CENT
	cXml += '   <Interior ss:Color="#A9D08E" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s117" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s118">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s119">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s120">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s121" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s122" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s123" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s124">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s125" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s126" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s127" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s128">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s129">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s130" ss:Parent="s62">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s131" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s132">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="_-* #,##0.0000_-;\-* #,##0.0000_-;_-* &quot;-&quot;??_-;_-@_-"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s133" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s134" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s135" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s136" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8" ss:Bold="1"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s137" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s138" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s139" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s140" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s141" ss:Parent="s16">'+CENT
	cXml += '   <Alignment ss:Horizontal="Right" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders>'+CENT
	cXml += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+CENT
	cXml += '   </Borders>'+CENT
	cXml += '   <Font ss:FontName="Courier New" x:Family="Modern" ss:Size="8"/>'+CENT
	cXml += '   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s143">'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s144">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '   <NumberFormat ss:Format="Short Date"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += '  <Style ss:ID="s145">'+CENT
	cXml += '   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>'+CENT
	cXml += '   <Borders/>'+CENT
	cXml += '   <Interior ss:Color="#C6E0B4" ss:Pattern="Solid"/>'+CENT
	cXml += '  </Style>'+CENT
	cXml += ' </Styles>'+CENT
	cXml += ' <Worksheet ss:Name="Parametros">'+CENT
	cXml += '  <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="6" x:FullColumns="1"'+CENT
	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
	cXml += '   <Column ss:Width="98.25"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="138"/>'+CENT
	
	cMV_PAR00	:= SubStr(DtoS(MV_PAR00),1,4)+"-"+SubStr(DtoS(MV_PAR00),5,2)+"-"+SubStr(DtoS(MV_PAR00),7,2)+"T00:00:00.000"
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s143"><Data ss:Type="String">Data De</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s144"><Data ss:Type="DateTime">'+cMV_PAR00+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cMV_PAR01	:= SubStr(DtoS(MV_PAR01),1,4)+"-"+SubStr(DtoS(MV_PAR01),5,2)+"-"+SubStr(DtoS(MV_PAR01),7,2)+"T00:00:00.000"
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s143"><Data ss:Type="String">Data Ate</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s144"><Data ss:Type="DateTime">'+cMV_PAR01+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cMV_PAR02 := IIf(MV_PAR02==1,"Pagar",If(MV_PAR02==3,"Ambas","Receber"))
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s143"><Data ss:Type="String">Modalidade</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s145"><Data ss:Type="String">'+cMV_PAR02+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	If	MV_PAR02==1
		cXml += '    <Cell ss:StyleID="s143"><Data ss:Type="String">Fornecedor</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s145"><Data ss:Type="String">'+MV_PAR05+'-'+MV_PAR06+'</Data></Cell>'+CENT
	ElseIf	MV_PAR02==2
		cXml += '    <Cell ss:StyleID="s143"><Data ss:Type="String">Cliente</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s145"><Data ss:Type="String">'+MV_PAR03+'-'+MV_PAR04+'</Data></Cell>'+CENT
	Else
		cXml += '    <Cell ss:StyleID="s143"><Data ss:Type="String">Cliente/Fornecedor</Data></Cell>'+CENT
		cXml += '    <Cell ss:StyleID="s145"><Data ss:Type="String">'+MV_PAR03+'-'+MV_PAR04+' '+MV_PAR05+'-'+MV_PAR06+'</Data></Cell>'+CENT
	EndIf
	
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s143"><Data ss:Type="String">Titulo</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s145"><Data ss:Type="String">'+MV_PAR07+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	
	cMV_PAR08 := "Historico"

	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s143"><Data ss:Type="String">Tipo </Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s145"><Data ss:Type="String">'+cMV_PAR08+'</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '  </Table>'+CENT
	cXml += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
	cXml += '   <PageSetup>'+CENT
	cXml += '    <Header x:Margin="0.31496062000000002"/>'+CENT
	cXml += '    <Footer x:Margin="0.31496062000000002"/>'+CENT
	cXml += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT
	cXml += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT
	cXml += '   </PageSetup>'+CENT
	cXml += '   <Unsynced/>'+CENT
	cXml += '   <Panes>'+CENT
	cXml += '    <Pane>'+CENT
	cXml += '     <Number>3</Number>'+CENT
	cXml += '     <ActiveRow>3</ActiveRow>'+CENT
	cXml += '    </Pane>'+CENT
	cXml += '   </Panes>'+CENT
	cXml += '   <ProtectObjects>False</ProtectObjects>'+CENT
	cXml += '   <ProtectScenarios>False</ProtectScenarios>'+CENT
	cXml += '  </WorksheetOptions>'+CENT
	cXml += ' </Worksheet>'+CENT
	cXml += ' <Worksheet ss:Name="Relatorio">'+CENT
	cXml += '  <Table ss:ExpandedColumnCount="29" ss:ExpandedRowCount="'+Alltrim(Str(nLin*200))+'" x:FullColumns="1"'+CENT
	cXml += '   x:FullRows="1" ss:DefaultRowHeight="15">'+CENT
	cXml += '   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="128.25"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="69.75" ss:Span="3"/>'+CENT
	cXml += '   <Column ss:Index="7" ss:Width="63" ss:Span="1"/>'+CENT
	cXml += '   <Column ss:Index="9" ss:AutoFitWidth="0" ss:Width="63.75"/>'+CENT
	cXml += '   <Column ss:Width="57.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="92.25"/>'+CENT
	cXml += '   <Column ss:Index="13" ss:AutoFitWidth="0" ss:Width="97.5"/>'+CENT
	cXml += '   <Column ss:Width="57.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="107.25"/>'+CENT
	cXml += '   <Column ss:Index="17" ss:AutoFitWidth="0" ss:Width="82.5" ss:Span="1"/>'+CENT
	cXml += '   <Column ss:Index="19" ss:AutoFitWidth="0" ss:Width="70.5"/>'+CENT
	cXml += '   <Column ss:Width="57.75"/>'+CENT
	cXml += '   <Column ss:AutoFitWidth="0" ss:Width="138"/>'+CENT
	cXml += '   <Column ss:Index="23" ss:AutoFitWidth="0" ss:Width="74.25" ss:Span="6"/>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="16.5" ss:StyleID="s70">'+CENT

	MV_PAR00 := FirstDay(FirstDay(MV_PAR01)-1) // 2 Meses

	cMV_PAR01 := Strzero(Month(MV_PAR01),2)+"/"+Str(Year(MV_PAR01),4)
	cPeriodo1 := MesExtenso(Month(MV_PAR00))+" de "+Str(Year(MV_PAR00),4)
	cPeriodo2 := MesExtenso(Month(MV_PAR01))+" de "+Str(Year(MV_PAR01),4)
    
	cXml += '    <Cell ss:MergeAcross="12" ss:StyleID="m106110359520"><Data ss:Type="String">Memoria de Calculo da Variacao Cambial ref. '+cMV_PAR01+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="5" ss:StyleID="m106110359540"><Data ss:Type="String">'+cPeriodo1+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="5" ss:StyleID="m106110359560"><Data ss:Type="String">'+cPeriodo2+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:MergeAcross="3" ss:StyleID="m106110359580"><Data ss:Type="String">SALDO</Data></Cell>'+CENT
	cXml += '   </Row>'+CENT
	cXml += '   <Row ss:AutoFitHeight="0" ss:Height="34.5">'+CENT
	cXml += '    <Cell ss:StyleID="s101"><Data ss:Type="String">Cliente</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Nome Cliente</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s103"><Data ss:Type="String">Conta Contabil</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s104"><Data ss:Type="String">VC Provisao </Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s103"><Data ss:Type="String">VC Nao Realizada</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s103"><Data ss:Type="String">VC Realizada</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">No. Titulo - Parcela</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Modalidade</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Natureza</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s105"><Data ss:Type="String">Dt. de Emissao</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s102"><Data ss:Type="String">Vlr. Original USD</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s106"><Data ss:Type="String">Tx. Emissao</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s107"><Data ss:Type="String">Vlr. Original BRL</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s108"><Data ss:Type="String">Dt. Movto.</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s109"><Data ss:Type="String">Tp. Mvto.</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s109"><Data ss:Type="String">Tx. Dolar</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s110"><Data ss:Type="String">Novo Vlr. BRL</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s111"><Data ss:Type="String">VC nao Realizada</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s112"><Data ss:Type="String">VC Realizada</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s113"><Data ss:Type="String">Dt. Movto.</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s114"><Data ss:Type="String">Tp Mvto</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s114"><Data ss:Type="String">Tx. Dolar</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s114"><Data ss:Type="String">Novo Vlr. BRL</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s115"><Data ss:Type="String">VC nao Realizada</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s116"><Data ss:Type="String">VC Realizada</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s117"><Data ss:Type="String">Saldo em Dolar</Data></Cell>'+CENT
	cXml += '   <Cell ss:StyleID="s117"><Data ss:Type="String">Saldo em R$</Data></Cell>'+CENT
	cXml += '   <Cell ss:StyleID="s118"><Data ss:Type="String">VC. Nao Realizada Ate '+DtoC(MV_PAR01)+'</Data></Cell>'+CENT
	cXml += '   <Cell ss:StyleID="s119"><Data ss:Type="String">VC. Realizada Ate '+DtoC(MV_PAR01)+'</Data></Cell>'+CENT
	cXml += '  </Row>'+CENT
	
	FWrite(nArq,cXml)
	
	ncount		:= 0
	ncountq 	:= 0
	cXml		:= ""
	lFez		:= .f.
	
	For nx:=1 to Len(aDados)
		ncount += 1
		ncountq += 1
		nValorUSD := 0
		nValorBrl := 0
		
		IncProc(Str(ncount,5)+" de "+Str(nLin-15,5)+ " registros" )
		
		cEMISSAO := If(!Empty(aDados[nx][10]),SubStr(aDados[nx][10],1,4)+"-"+SubStr(aDados[nx][10],5,2)+"-"+SubStr(aDados[nx][10],7,2)+"T00:00:00.000",'')
		cDtVM1   := If(!Empty(aDados[nx][14]),SubStr(aDados[nx][14],1,4)+"-"+SubStr(aDados[nx][14],5,2)+"-"+SubStr(aDados[nx][14],7,2)+"T00:00:00.000",'')
		cDtVM2   := If(!Empty(aDados[nx][20]),SubStr(aDados[nx][20],1,4)+"-"+SubStr(aDados[nx][20],5,2)+"-"+SubStr(aDados[nx][20],7,2)+"T00:00:00.000",'')
		
		cXml += '  <Row ss:AutoFitHeight="0" ss:StyleID="s120">'+CENT
		cXml += '   <Cell ss:StyleID="s121"><Data ss:Type="String">'+aDados[nx][01]+'</Data></Cell>'+CENT
		cXml += '   <Cell ss:StyleID="s122"><Data ss:Type="String">'+aDados[nx][02]+'</Data></Cell>'+CENT
		cXml += '   <Cell ss:StyleID="s123"><Data ss:Type="String">'+aDados[nx][03]+'</Data></Cell>'+CENT
		cXml += '   <Cell ss:StyleID="s123"><Data ss:Type="String">'+aDados[nx][04]+'</Data></Cell>'+CENT
		cXml += '   <Cell ss:StyleID="s123"><Data ss:Type="String">'+aDados[nx][05]+'</Data></Cell>'+CENT
		cXml += '   <Cell ss:StyleID="s123"><Data ss:Type="String">'+aDados[nx][06]+'</Data></Cell>'+CENT
		cXml += '   <Cell ss:StyleID="s122"><Data ss:Type="String">'+aDados[nx][29]+'-'+aDados[nx][07]+'-'+aDados[nx][31]+'</Data></Cell>'+CENT
		cXml += '   <Cell ss:StyleID="s122"><Data ss:Type="String">'+aDados[nx][08]+'</Data></Cell>'+CENT
		cXml += '   <Cell ss:StyleID="s122"/>'+CENT
		If !Empty(cEMISSAO)
			cXml += '   <Cell ss:StyleID="s124"><Data ss:Type="DateTime">'+cEMISSAO+'</Data></Cell>'+CENT
		Else
			cXml += '   <Cell ss:StyleID="s124"><Data ss:Type="String">'+cEMISSAO+'</Data></Cell>'+CENT
		EndIf
		cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String">'+Transform(aDados[nx][11],"@E 999,999,999.99")+'</Data></Cell>'+CENT
		cXml += '   <Cell ss:StyleID="s126"><Data ss:Type="String">'+Transform(aDados[nx][12],"@E 999.9999")+'</Data></Cell>'+CENT
		cXml += '   <Cell ss:StyleID="s127"><Data ss:Type="String">'+Transform(aDados[nx][13],"@E 999,999,999.99")+'</Data></Cell>'+CENT
		
		// Tratamento especÌfico para as invoices baixadas pelo mÛdulo de exportaÁ„o
		If SubStr(aDados[nx][15],1,5) == 'Emb.:' 
        	aDados[nx][15] := 'Valor recebido s/ Titulo'
        EndIf    
		If SubStr(aDados[nx][21],1,5) == 'Emb.:'
        	aDados[nx][21] := 'Valor recebido s/ Titulo'
        EndIf    

		// ApÛs abrirmos o perÌodo de datas para puxar a VariaÁ„o Realizada dos meses anteriores, visto que o relatÛrio È truncado para apenas dois meses, 
		// tornou-se obrigatÛrio por motivos de auditoria, apresentar apenas movimentaÁıes do mÍs a ser exibido.   
		If !Empty(cDtVM1) .and. Strzero(Month(StoD(aDados[nx][14])),2)+Str(Year(StoD(aDados[nx][14])),4) == Strzero(Month(MV_PAR00),2)+Str(Year(MV_PAR00),4) 
			cXml += '   <Cell ss:StyleID="s128"><Data ss:Type="DateTime">'+cDtVM1+'</Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s129"><Data ss:Type="String">'+aDados[nx][15]+'</Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s126"><Data ss:Type="String">'+Transform(aDados[nx][16],"@E 999.9999")+'</Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String">'+Transform(aDados[nx][17],"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String">'+Transform(aDados[nx][18],"@E 999,999,999.99")+'</Data></Cell>'+CENT
	        If  aDados[nx][15] $ 'Valor pago s/ Titulo|Baixa via SIGAEFF|Baixa por Compensacao|Valor recebido s/ Titulo|Valor recebido por compensac‰o|Compens. Adiantamento'
				cXml += '   <Cell ss:StyleID="s127"><Data ss:Type="String">'+Transform(aDados[nx][19],"@E 999,999,999.99")+'</Data></Cell>'+CENT
			Else	
				aDados[nx][19] := 0
				cXml += '   <Cell ss:StyleID="s127"><Data ss:Type="String">'+"-"+'</Data></Cell>'+CENT
	        EndIf
		Else
			cXml += '   <Cell ss:StyleID="s128"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s129"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s126"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s127"><Data ss:Type="String"></Data></Cell>'+CENT   
			aDados[nx][16] := 0
			aDados[nx][17] := 0
			aDados[nx][18] := 0
			aDados[nx][19] := 0
		EndIf
        
		// ApÛs abrirmos o perÌodo de datas para puxar a VariaÁ„o Realizada dos meses anteriores, visto que o relatÛrio È truncado para apenas dois meses, 
		// tornou-se obrigatÛrio por motivos de auditoria, apresentar apenas movimentaÁıes do mÍs a ser exibido.   
		If !Empty(cDtVM2) .and. Strzero(Month(StoD(aDados[nx][20])),2)+Str(Year(StoD(aDados[nx][20])),4) == Strzero(Month(MV_PAR01),2)+Str(Year(MV_PAR01),4) 
			cXml += '   <Cell ss:StyleID="s130"><Data ss:Type="DateTime">'+cDtVM2+'</Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s131"><Data ss:Type="String">'+aDados[nx][21]+'</Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s132"><Data ss:Type="String">'+Transform(aDados[nx][22],"@E 999.9999")+'</Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String">'+Transform(aDados[nx][23],"@E 999,999,999.99")+'</Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String">'+Transform(aDados[nx][24],"@E 999,999,999.99")+'</Data></Cell>'+CENT
	        If  aDados[nx][21] $ 'Valor pago s/ Titulo|Baixa via SIGAEFF|Baixa por Compensacao|Valor recebido s/ Titulo|Valor recebido por compensac‰o|Compens. Adiantamento'
				cXml += '   <Cell ss:StyleID="s127"><Data ss:Type="String">'+Transform(aDados[nx][25],"@E 999,999,999.99")+'</Data></Cell>'+CENT
			Else	
				aDados[nx][25] := 0
				cXml += '   <Cell ss:StyleID="s127"><Data ss:Type="String">'+"-"+'</Data></Cell>'+CENT
	        EndIf
		Else
			cXml += '   <Cell ss:StyleID="s130"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s131"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s132"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String"></Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s127"><Data ss:Type="String"></Data></Cell>'+CENT
			aDados[nx][22] := 0
			aDados[nx][23] := 0
			aDados[nx][24] := 0
			aDados[nx][25] := 0
		EndIf
	
		// ApÛs abrirmos o perÌodo de datas para puxar a VariaÁ„o Realizada dos meses anteriores, visto que o relatÛrio È truncado para apenas dois meses, 
		// tornou-se obrigatÛrio por motivos de auditoria, apresentar apenas movimentaÁıes do mÍs a ser exibido.   
		If (!Empty(cDtVM1) .and. Strzero(Month(StoD(aDados[nx][14])),2)+Str(Year(StoD(aDados[nx][14])),4) == Strzero(Month(MV_PAR00),2)+Str(Year(MV_PAR00),4)) .or. ;
		   (!Empty(cDtVM2) .and. Strzero(Month(StoD(aDados[nx][20])),2)+Str(Year(StoD(aDados[nx][20])),4) == Strzero(Month(MV_PAR01),2)+Str(Year(MV_PAR01),4)) 
			
			nValorUSD := aDados[nx][11]
			nValorBrl := aDados[nx][23]
	
			If aDados[nx][21] == "CORREC MONET."
				cXml += '   <Cell ss:StyleID="s133"><Data ss:Type="String">'+Transform(nValorUSD,"@E 999,999,999.99")+'</Data></Cell>'+CENT
			Else
				nValorUSD := 0
				cXml += '   <Cell ss:StyleID="s133"><Data ss:Type="String">'+"-"+'</Data></Cell>'+CENT
			EndIf
			
			If nValorUSD <> 0
				cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String">'+Transform(aDados[nx][23],"@E 999,999,999.99")+'</Data></Cell>'+CENT
			Else
				nValorBrl := 0
				cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String">'+"-"+'</Data></Cell>'+CENT
			EndIf
	
			nTVCNRx := 0
			If !aDados[nx][21] $ 'Valor pago s/ Titulo|Baixa via SIGAEFF|Baixa por Compensacao|Valor recebido s/ Titulo|Valor recebido por compensac‰o|Compens. Adiantamento' .and. !Empty(aDados[nx][21])
				cXml += '    <Cell ss:StyleID="s125"><Data ss:Type="String">'+Transform(aDados[nx][23]-aDados[nx][13],"@E 999,999,999.99")+'</Data></Cell>'+CENT
				nTVCNRx := aDados[nx][23]-aDados[nx][13]
			Else 
				cXml += '    <Cell ss:StyleID="s125"><Data ss:Type="String">'+"-"+'</Data></Cell>'+CENT
			EndIf
		Else
			cXml += '   <Cell ss:StyleID="s133"><Data ss:Type="String">'+"-"+'</Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String">'+"-"+'</Data></Cell>'+CENT
			cXml += '   <Cell ss:StyleID="s125"><Data ss:Type="String">'+"-"+'</Data></Cell>'+CENT
		EndIf

		cXml += '    <Cell ss:StyleID="s127"><Data ss:Type="String">'+Transform(aDados[nx][19]+aDados[nx][25],"@E 999,999,999.99")+'</Data></Cell>'+CENT
		cXml += '   </Row>'+CENT
		
		If !Empty(cDtVM1) .and. Strzero(Month(StoD(aDados[nx][14])),2)+Str(Year(StoD(aDados[nx][14])),4) == Strzero(Month(MV_PAR00),2)+Str(Year(MV_PAR00),4) 
	 		nVBRL1+= aDados[nx][17]
			nVCNR1+= aDados[nx][18]
			nVCR1 += aDados[nx][19]
		EndIf
		
		If !Empty(cDtVM2) .and. Strzero(Month(StoD(aDados[nx][20])),2)+Str(Year(StoD(aDados[nx][20])),4) == Strzero(Month(MV_PAR01),2)+Str(Year(MV_PAR01),4) 
			nVBRL2+= aDados[nx][23]
			nVCNR2+= aDados[nx][24]
			nVCR2 += aDados[nx][25]
		EndIf
		
		nTSaldoUS += nValorUSD
		nTSaldoR  += nValorBrl
		nTVCNR    += nTVCNRx
		nTVCR     += aDados[nx][19] + aDados[nx][25]
		
		If	ncountq == 380 .or. nx == Len(aDados)
			FWrite(nArq,cXml)
			cXml := ""
			ncountq := 0
		EndIf
		
	Next
	
	cXml += '   <Row ss:AutoFitHeight="0">'+CENT
	cXml += '    <Cell ss:StyleID="s134"/>'+CENT
	cXml += '    <Cell ss:StyleID="s135"/>'+CENT
	cXml += '    <Cell ss:StyleID="s136"/>'+CENT
	cXml += '    <Cell ss:StyleID="s136"/>'+CENT
	cXml += '    <Cell ss:StyleID="s136"/>'+CENT
	cXml += '    <Cell ss:StyleID="s136"/>'+CENT
	cXml += '    <Cell ss:StyleID="s135"/>'+CENT
	cXml += '    <Cell ss:StyleID="s135"/>'+CENT
	cXml += '    <Cell ss:StyleID="s135"/>'+CENT
	cXml += '    <Cell ss:StyleID="s135"/>'+CENT
	cXml += '    <Cell ss:StyleID="s135"/>'+CENT
	cXml += '    <Cell ss:StyleID="s135"/>'+CENT
	cXml += '    <Cell ss:StyleID="s135"/>'+CENT
	cXml += '    <Cell ss:StyleID="s137"/>'+CENT
	cXml += '    <Cell ss:StyleID="s138"/>'+CENT
	cXml += '    <Cell ss:StyleID="s139"/>'+CENT
	cXml += '    <Cell ss:StyleID="s139"><Data ss:Type="String">'+Transform(nVBRL1	,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s139"><Data ss:Type="String">'+Transform(nVCNR1	,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s140"><Data ss:Type="String">'+Transform(nVCR1	,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s137"/>'+CENT
	cXml += '    <Cell ss:StyleID="s138"/>'+CENT
	cXml += '    <Cell ss:StyleID="s139"/>'+CENT
	cXml += '    <Cell ss:StyleID="s139"><Data ss:Type="String">'+Transform(nVBRL2	,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s139"><Data ss:Type="String">'+Transform(nVCNR2	,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s140"><Data ss:Type="String">'+Transform(nVCR2	,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s141"><Data ss:Type="String">'+Transform(nTSaldoUS,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s139"><Data ss:Type="String">'+Transform(nTSaldoR,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '    <Cell ss:StyleID="s139"><Data ss:Type="String">'+Transform(nTVCNR	,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '   <Cell ss:StyleID="s140"><Data ss:Type="String">'+Transform(nTVCR	,"@E 999,999,999.99")+'</Data></Cell>'+CENT
	cXml += '  </Row>'+CENT
	cXml += ' </Table>'+CENT
	cXml += ' <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">'+CENT
	cXml += '  <PageSetup>'+CENT
	cXml += '   <Header x:Margin="0.31496062000000002"/>'+CENT
	cXml += '   <Footer x:Margin="0.31496062000000002"/>'+CENT
	cXml += '   <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"'+CENT
	cXml += '    x:Right="0.511811024" x:Top="0.78740157499999996"/>'+CENT
	cXml += '  </PageSetup>'+CENT
	cXml += '  <Unsynced/>'+CENT
	cXml += '  <Print>'+CENT
	cXml += '   <ValidPrinterInfo/>'+CENT
	cXml += '   <PaperSizeIndex>9</PaperSizeIndex>'+CENT
	cXml += '   <HorizontalResolution>-3</HorizontalResolution>'+CENT
	cXml += '   <VerticalResolution>-3</VerticalResolution>'+CENT
	cXml += '  </Print>'+CENT
	cXml += '  <Selected/>'+CENT
	cXml += '  <Panes>'+CENT
	cXml += '   <Pane>'+CENT
	cXml += '    <Number>3</Number>'+CENT
	cXml += '    <ActiveRow>1</ActiveRow>'+CENT
	cXml += '    <ActiveCol>1</ActiveCol>'+CENT
	cXml += '   </Pane>'+CENT
	cXml += '  </Panes>'+CENT
	cXml += '  <ProtectObjects>False</ProtectObjects>'+CENT
	cXml += '  <ProtectScenarios>False</ProtectScenarios>'+CENT
	cXml += ' </WorksheetOptions>'+CENT
	cXml += '</Worksheet>'+CENT
	cXml += '</Workbook>'+CENT
	
	FWrite(nArq,cXml)
	
	shellExecute( "Open", cPath + cArq + ".xml", " /k dir", "C:\", 1 )
	
EndIf

FClose(nArq)

Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                        4                        5                        6           7     8   9   10  11    12   13           14           15      16      17   18   19               20      21      22      23   24        25   26   27   28   29        30   31   32   33   34   35   36   37   38        39   40  41  42   43
AADD(aSx1,{"EDFR023" , "01" , "Data          	  ?" , "Data          	   ?" , "Data          	    ?" , "mv_ch1" , "D" , 08 , 0 , 0 , "G" , "" , "MV_PAR01" , ""         , ""    , ""    , "" , "" , ""             , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR023" , "02" , "Modalidade    	  ?" , "Modalidade    	   ?" , "Modalidade    	    ?" , "mv_ch2" , "N" , 01 , 0 , 0 , "C" , "" , "MV_PAR02" , "Pagar"    , ""    , ""    , "" , "" , "Receber"      , ""    , ""    , ""    , "" , "Ambos" , "" , "" , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR023" , "03" , "Cliente            ?" , "Cliente            ?" , "Cliente            ?" , "mv_ch3" , "C" , 06 , 0 , 0 , "G" , "" , "MV_PAR03" , ""         , ""    , ""    , "" , "" , ""             , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "SA1" , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR023" , "04" , "Loja               ?" , "Loja               ?" , "Loja               ?" , "mv_ch4" , "C" , 02 , 0 , 0 , "G" , "" , "MV_PAR04" , ""         , ""    , ""    , "" , "" , ""             , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR023" , "05" , "Fornecedor         ?" , "Fornecedor         ?" , "Fornecedor         ?" , "mv_ch5" , "C" , 06 , 0 , 0 , "G" , "" , "MV_PAR05" , ""         , ""    , ""    , "" , "" , ""             , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , "SA2A", "" , "", "", "" , ""})
AADD(aSx1,{"EDFR023" , "06" , "Loja               ?" , "Loja               ?" , "Loja               ?" , "mv_ch6" , "C" , 02 , 0 , 0 , "G" , "" , "MV_PAR06" , ""         , ""    , ""    , "" , "" , ""             , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR023" , "07" , "Titulo             ?" , "Titulo             ?" , "Titulo             ?" , "mv_ch7" , "C" , 09 , 0 , 0 , "G" , "" , "MV_PAR07" , ""         , ""    , ""    , "" , "" , ""             , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "" , ""})
AADD(aSx1,{"EDFR023" , "08" , "Conta Cont·bil     ?" , "Conta Cint·bil     ?" , "Conta Cont·bil     ?" , "mv_ch8" , "C" , 20 , 0 , 0 , "G" , "" , "MV_PAR08" , ""         , ""    , ""    , "" , "" , ""             , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , "" 		, "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "" , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR023   08")
	
	DbSeek("EDFR023")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR023"
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
