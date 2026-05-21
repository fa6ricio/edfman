#include "TOPCONN.CH"
#include "RWMAKE.CH"        

#DEFINE CRLF CHR(13)+CHR(10)      // Indica <Enter>

User Function CPGMES()
SetPrvt("CQUERY, cPerg, X, aVet, cPeriodo, aCabec, aDados, aQuem")

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ≥±±
±±≥FunáÑo    ≥PPRODSM ≥ Autor ≥ Davi Jesus de Oliveira  ≥ Data ≥ 06/11/11 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥ Pagamentos Mes a mes                                       ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

cPerg:= "mesmesESba"
aCabec := {}
aQuem := {'Dt Emiss„o','Dt Vencimento'}
ValidPerg()

Pergunte( cPerg,.t. )                                                

If MsgYesNo("Gerar Planilha de Pagamentos?")
    aVet := {}
    cPeriodo := substr(dtos(ddatabase),1,6)
    For x:=1 to 370
        If ascan(aVet, {|y| y==cPeriodo}) == 0
           AaDd(aVet,cPeriodo)
        Endif                 
        cPeriodo := substr(dtos(ddatabase-X),1,6)
    Next X
                               
    AaDd( aCabec, "Natureza")
    AaDd( aCabec, "DescriÁ„o")
	For X:=12 to 1 step -1
	     AaDd( aCabec, SUBSTR(aVet[X],5,2)+"/"+SUBSTR(aVet[X],1,4) )
	Next X
	
	cQuery := "SELECT ED_CODIGO AS CODIGO, ED_DESCRIC AS DESCRICAO,"
	iF mv_par03 == 1
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[01]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[01]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[01]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[01]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A01," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[02]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[02]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[02]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[02]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A02," 
				
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[03]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[03]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[03]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[03]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A03," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[04]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[04]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[04]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[04]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A04," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[05]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[05]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[05]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[05]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A05," 
		
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[06]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[06]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[06]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[06]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A06," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[07]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[07]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[07]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[07]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A07," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[08]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[08]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[08]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[08]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A08," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[09]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[09]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[09]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[09]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A09," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[10]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[10]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[10]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[10]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A10," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[11]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[11]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[11]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[11]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A11," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[12]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_EMISSAO,1,6) = '"+aVet[12]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[12]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[12]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A12" 
	Else 
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[01]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[01]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[01]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[01]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A01," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[02]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[02]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[02]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[02]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A02," 
				
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[03]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[03]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[03]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[03]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A03," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[04]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[04]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[04]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[04]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A04," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[05]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[05]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[05]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[05]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A05," 
		
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[06]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[06]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[06]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[06]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A06," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[07]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[07]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[07]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[07]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A07," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[08]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[08]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[08]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[08]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A08," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[09]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[09]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[09]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[09]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A09," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[10]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[10]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[10]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[10]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A10," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[11]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[11]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[11]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[11]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A11," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCREA,1,6) = '"+aVet[12]+"' AND E1_NATUREZ = ED_CODIGO),0) -" 
		cQuery += " ISNULL((SELECT SUM(E2_VALOR) FROM "+RetSqlName("SE2")+" AS E2 WHERE E2.D_E_L_E_T_ = ' ' AND SUBSTRING(E2_VENCREA,1,6) = '"+aVet[12]+"' AND E2_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[12]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) -"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[12]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'P' AND E5_TIPO = ''),0) AS A12 " 
	Endif
	cQuery += " FROM "+RetSqlName('SED')+" AS ED "
	cQuery += " WHERE ED.D_E_L_E_T_ = ' '"
	cQuery += " AND ED_CODIGO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	cQuery += " AND ED.D_E_L_E_T_ = ' '"
	//Filtra Naturezas bloqueadas
	If mv_par04 == 1
		cQuery += " AND ED_MSBLQL <> '1'"
	EndIf
    /*
	//INCLUSAO DE TITULOS E MOVIMENTOS A RECEBER - RECEITA
	cQuery += " UNION ALL"
	cQuery += " SELECT ED_CODIGO AS CODIGO, ED_DESCRIC AS DESCRICAO,"
	iF mv_par03 == 1
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[01]+"' AND E1_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[01]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A01," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[02]+"' AND E1_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[02]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A02," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[03]+"' AND E1_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[03]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A03," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[04]+"' AND E1_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[04]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A04," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[05]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[05]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A05,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[06]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[06]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A06,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[07]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[07]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A07,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[08]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[08]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A08,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[09]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[09]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A09,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[10]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[10]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A10,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[11]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[11]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A11,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_EMISSAO,1,6) = '"+aVet[12]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[12]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A12"
	Else 
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[01]+"' AND E1_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[01]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A01," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[02]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[02]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A02," 
		 
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[03]+"' AND E1_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[03]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A03," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[04]+"' AND E1_NATUREZ = ED_CODIGO),0) +" 
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[04]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A04," 
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[05]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[05]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A05,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[06]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[06]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A06,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[07]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[07]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A07,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[08]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[08]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A08,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[09]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[09]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A09,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[10]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[10]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A10,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[11]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
		cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[11]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A11,"
		
		cQuery += " ISNULL((SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" AS E1 WHERE E1.D_E_L_E_T_ = ' ' AND SUBSTRING(E1_VENCTO,1,6) = '"+aVet[12]+"' AND E1_NATUREZ = ED_CODIGO),0) +"
	    cQuery += " ISNULL((SELECT SUM(E5_VALOR) FROM "+RetSqlName("SE5")+" AS E5 WHERE E5.D_E_L_E_T_ = ' ' AND SUBSTRING(E5_DATA,1,6) = '"+aVet[12]+"' AND E5_NATUREZ = ED_CODIGO AND E5_RECPAG = 'R' AND E5_TIPO = ''),0) AS A12"                                                                                                                
	Endif
	cQuery += " FROM "+RetSqlName('SED')+" AS ED "
	cQuery += " WHERE ED.D_E_L_E_T_ = ' '"
	cQuery += " AND ED_CODIGO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	cQuery += " AND ED.D_E_L_E_T_ = ' '"
	
	//Filtra Naturezas bloqueadas
	If mv_par04 == 1
		cQuery += " AND ED_MSBLQL <> '1'"
	EndIf
	*/
	cQuery += " ORDER BY ED_CODIGO"
    If SELECT("TMX") > 0 
       TMX->( dbCloseArea() )
    Endif
    //Alert(cQuery)
    //MemoWrite("CPGMES.sql",cQuery)
	TCQUERY cQuery NEW ALIAS "TMX"
	

	DbSelectArea("TMX")
	TMX->(DbGoTop())
                       
    aDados := {}
	While TMX->( !EOF() )
		   AaDd( aDados, {"."+TMX->CODIGO, TMX->DESCRICAO, TMX->A12, TMX->A11,TMX->A10,TMX->A09,TMX->A08,TMX->A07,TMX->A06,TMX->A05,TMX->A04,TMX->A03,TMX->A02,TMX->A01,})
			
			TMX->( DBSKIP() )		
	End

	DlgToExcel( { { "ARRAY", "RelatÛrio Pagamentos MÍs a MÍs Base "+aQuem[mv_par03], aCabec, aDados} })                                  

	MsgAlert("Relatorio Finalizado com Sucesso...")
Else	
	MsgAlert("GeraÁ„o Abortada pelo usu·rio!")
	
endif


Return 


Static Function ValidPerg
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}              

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Natureza de  ?", "Natureza de  ?", "Natureza de  ?","mv_ch1","C",len(SED->ED_CODIGO),0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"02","Natureza ate ?", "Natureza ate ?", "Natureza ate ?","mv_ch2","C",LEN(SED->ED_CODIGO),0,0,"G","NAOVAZIO()","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"03","Considerar:", "Considerar:", "Considerar:"         ,"mv_ch3","N",01,0,0,"C","","mv_par03","Emissao","","","","","Vencimento","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Filtra Naturezas Bloqueadas?", "Filtra Naturezas Bloqueadas?", "Filtra Naturezas Bloqueadas?","mv_ch4","N",01,0,0,"C","","mv_par04","1=Sim","","","","","2=Nao","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
		  if j < 28 
			FieldPut(j,aRegs[i,j])
		  endif
		Next
		MsUnlock()
        dbCommit()
	Endif
Next

dbSelectArea(_sAlias)

Return