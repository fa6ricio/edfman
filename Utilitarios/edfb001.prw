#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT	Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EDFB001  บ Autor ณ Luis Felipe Nascim.บ Data ณ  26/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Durante a valida็ใo do Relat๓rio Sumario Navio o usuแrio   บฑฑ
ฑฑบ          ณ observou a aus๊ncia de um Pedido de Vendas 001140 o qual   บฑฑ
ฑฑบ          ณ havia sido faturado e deveria constar sobre a tabela EES   บฑฑ
ฑฑบ          ณ Notas Fiscais por Itens. 								  บฑฑ
ฑฑบ          ณ Como haviam outros registros al้m do registro apontado pe- บฑฑ
ฑฑบ          ณ lo Leonardo Santos, foi desenvolvida essa rotina provis๓riaบฑฑ
ฑฑบ          ณ a fim de corrigir eventuais aus๊cias de novos registros.   บฑฑ
ฑฑบ          ณ Os registros recuperados serใo marcados sobre o campo      บฑฑ
ฑฑบ          ณ EES_CCERP classificados como Manuais.                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function EDFB001()    

Local aArea		:= GetArea() 
Local cQry  	:= ""
Private cAliasQry := GetNextAlias()

cQry := " SELECT 	D2_FILIAL   AS EES_FILIAL"+CENT
cQry += " 			,F2_DOC     AS EES_NRNF"+CENT
cQry += "        	,D2_SERIE   AS EES_SERIE"+CENT
cQry += "        	,D2_PREEMB  AS EES_PREEMB"+CENT
cQry += "        	,D2_EMISSAO AS EES_DTNF"+CENT
cQry += "        	,D2_TOTAL   AS EES_VLNF"+CENT
cQry += "        	,F2_VALMERC AS EES_VLMERC"+CENT
cQry += "        	,D2_COD     AS EES_COD_I"+CENT 
cQry += "        	,D2_PEDIDO  AS EES_PEDIDO"+CENT
cQry += " 	   		,'01'       AS EES_SEQUEN"+CENT
cQry += "        	,D2_QUANT   AS EES_QTDE "+CENT
cQry += "        	,D2_TOTAL / M2_MOEDA2 AS EES_VLNFM"+CENT
cQry += " 			,D2_TOTAL / M2_MOEDA2 AS EES_VLMERM"+CENT
cQry += " 			,'01'       AS EES_FATSEQ"+CENT
cQry += " 	   		,'MANUAL'   AS EES_CCERP"+CENT
cQry += " FROM "+RetSqlName("EE9")+" EE9, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SM2")+" SM2"+CENT
cQry += " Where EE9_NF <> ''"+CENT
cQry += " AND EE9_NF = D2_DOC"+CENT
cQry += " AND  EE9_SERIE = D2_SERIE"+CENT
cQry += " AND F2_DOC = D2_DOC"+CENT
cQry += " AND F2_SERIE = D2_SERIE"+CENT
cQry += " AND D2_EMISSAO = M2_DATA"+CENT
cQry += " AND SF2.D_E_L_E_T_ = ''"+CENT
cQry += " AND SD2.D_E_L_E_T_ = ''"+CENT
cQry += " AND SM2.D_E_L_E_T_ = ''"+CENT
cQry += " AND EE9.D_E_L_E_T_ = ''"+CENT
cQry += " AND NOT EXISTS (SELECT EES_NRNF FROM "+RetSqlName("EES")+" WHERE EE9.EE9_NF = EES_NRNF AND D_E_L_E_T_ = '')"+CENT

MemoWrite("C:\Tmp\BACA_UPD.txt",cQry)
cQry := ChangeQuery(cQry)

If Select(cAliasQry) > 0
	dbselectarea(cAliasQry)
	(cAliasQry)->(dbCloseArea())
Endif
 
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),cAliasQry,.F.,.T.)
dbselectarea(cAliasQry)
(cAliasQry)->(dbGoTop())

If (cAliasQry)->(!Eof())
	Processa({|lEnd|Atualiza()})
EndIf

Restarea(aArea)
	   
Return 
	
*-------------------------------*
Static Function Atualiza()
*-------------------------------*
Local nCountnx 	:= 0
Local nCount 	:= 0

*-------------------------------*
*   Conta Total de Registros.   *
*-------------------------------*
While (cAliasQry)->(!Eof())
	nCountnx ++
	(cAliasQry)->(DbSkip())
End
(cAliasQry)->(DbGoTop())

ProcRegua(nCountnx)

While (cAliasQry)->(!EOF())
	nCount ++
	IncProc("Processando corre็ใo ..."+Str(nCount,3)+"/"+Str(nCountnx,3))
	RecLock("EES",.t.) 
	    EES_FILIAL 	:= (cAliasQry)->EES_FILIAL 	
		EES_NRNF 	:= (cAliasQry)->EES_NRNF 	
		EES_SERIE 	:= (cAliasQry)->EES_SERIE 	
		EES_PREEMB 	:= (cAliasQry)->EES_PREEMB 	
	    EES_DTNF 	:= StoD((cAliasQry)->EES_DTNF) 	
		EES_VLNF 	:= (cAliasQry)->EES_VLNF 	
		EES_VLMERC 	:= (cAliasQry)->EES_VLMERC 	
		EES_COD_I 	:= (cAliasQry)->EES_COD_I 	
		EES_PEDIDO 	:= (cAliasQry)->EES_PEDIDO 	
		EES_SEQUEN 	:= (cAliasQry)->EES_SEQUEN 	
		EES_QTDE 	:= (cAliasQry)->EES_QTDE 	
		EES_VLNFM  	:= (cAliasQry)->EES_VLNFM 	
		EES_VLMERM 	:= (cAliasQry)->EES_VLMERM 	
		EES_FATSEQ 	:= (cAliasQry)->EES_FATSEQ 	
		EES_CCERP 	:= (cAliasQry)->EES_CCERP 	
	MsUnlock()
    (cAliasQry)->(DbSkip())	  	
End

Return