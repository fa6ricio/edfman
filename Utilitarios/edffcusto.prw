#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³EDFFCUSTO ³ Autor ³ Luis Felipe Nascimento³ Data ³ 14.10.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiazação do Custo5 - Kardex                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alterado ³ Luis Felipe nascimento                          06/06/2014 ³±±
±±³          ³ Modificado para buscar o Pedido de Compras independente da ³±±
±±³          ³ loja do fornacedor.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alterado ³ Luis Felipe nascimento                          10/08/2015 ³±±
±±³          ³ Como a numeração dos pedidos de compras está com sequencial³±±
±±³          ³ unico, independente das filiais, e   existem Notas de En-  ³±±
±±³          ³ trada com fornecedor diferente do pedido de compras, foi   ³±±
±±³          ³ retirada a amarração do código do fornecedor da query.     ³±±
±±³          ³ Casos encontrados para o mês 07/2015:                      ³±±
±±³          ³ P23191-12925, P23192-12941 e P23193-12955                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alterado ³ Luis Felipe nascimento                          06/06/2016 ³±±
±±³          ³ Solicitado que os produtos que não tenham Petax sejam cal- ³±±
±±³          ³ culados com a taxa do dolar do dia.                        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      

User Function EDFFCUSTO(MV_PAR01)

Local	aArea	:= GetArea()
Private lAuto	:= .F.
Private cPerg   := "EDFFCUSTO"

CriaSx1()

IF !Pergunte(cPerg,.T.)
	RETURN
ENDIF

If LastKey() == 27
	Return
Endif

//Testa se esta sendo rodado do menu
If	Select('SX2') == 0
	RPCSetType( 3 )						//Não consome licensa de uso
	RpcSetEnv('01','01',,,,GetEnvServer(),{ "SB9","SD1","SD2","SD3","SF1","SC7","CN9" })
	sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
	ConOut('Atualizando Custo dos Contratos (Kardex-Moeda5)... '+Dtoc(DATE())+' - '+Time())
	lAuto := .t.
EndIf

If	( ! lAuto )
	LjMsgRun(OemToAnsi('Atualizando Custo dos Contratos On-line.(Kardex-Moeda5)'),,{|| EDFCUSTO(MV_PAR01) } )
Else
	EDFCUSTO(MV_PAR01)
EndIf

If	( lAuto )
	RpcClearEnv()				//Libera o Environment
	ConOut('Kardex Moeda5 Atualizado !'+Dtoc(DATE())+' - '+Time())
EndIf

RestArea(aArea)

Return

*--------------------------------*
Static Function EDFCUSTO(MV_PAR01)                         
*--------------------------------*

Local cQuerySD1 := ""
Local cQuerySD2 := ""
Local cQuerySD3 := ""
Local cQuerySB9 := ""
Local dDataFec  := GetMV("MV_ULMES")
Local cQuery	:= ""   
Local cAlias 	:= GetNextAlias()

/*
cQuery := " SELECT DISTINCT D1_COD, C7_TAXAUSD"+ c_ent 
cQuery += " FROM "+RetSqlName("SC7")+" SC7, "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF1")+" SF1, "+RetSqlName("CN9")+" CN9 "+ c_ent 
cQuery += " WHERE C7_CONTRAT  = F1_CONTRA"+ c_ent 
cQuery += " AND C7_XPERIOD  = F1_XPERIOD"+ c_ent 
cQuery += " AND C7_FORNECE  = F1_FORNECE"+ c_ent 
cQuery += " AND C7_LOJA     = F1_LOJA"+ c_ent 
cQuery += " AND C7_NUM      = F1_XPEDIDO"+ c_ent 
cQuery += " AND F1_DOC      = D1_DOC"+ c_ent 
cQuery += " AND F1_SERIE    = D1_SERIE"+ c_ent 
cQuery += " AND F1_FORNECE  = D1_FORNECE"+ c_ent 
cQuery += " AND F1_LOJA     = D1_LOJA"+ c_ent 
cQuery += " AND C7_PRODUTO  = D1_COD"+ c_ent  
cQuery += " AND C7_CONTRAT  = CN9_NUMERO"+ c_ent  
cQuery += " AND CN9_SITUAC  = '05'"+ c_ent  
cQuery += " AND SC7.D_E_L_E_T_ <> '*'"+ c_ent 
cQuery += " AND SF1.D_E_L_E_T_ <> '*'"+ c_ent 
cQuery += " AND SD1.D_E_L_E_T_ <> '*'"+ c_ent 
cQuery += " AND CN9.D_E_L_E_T_ <> '*'"+ c_ent 
cQuery += " ORDER BY D1_COD "+ c_ent 
*/
cQuery := " SELECT DISTINCT D1_COD, C7_TAXAUSD"+ c_ent 
cQuery += " FROM "+RetSqlName("SC7")+" SC7, "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF1")+" SF1, "+RetSqlName("CN9")+" CN9 "+ c_ent 
/*cQuery += " WHERE C7_FORNECE  = F1_FORNECE"+ c_ent  // 10/08/15 - Luis Felipe
cQuery += " AND C7_NUM      = F1_XPEDIDO"+ c_ent */
cQuery += " WHERE C7_NUM    = F1_XPEDIDO"+ c_ent 
cQuery += " AND F1_DOC      = D1_DOC"+ c_ent 
cQuery += " AND F1_SERIE    = D1_SERIE"+ c_ent 
cQuery += " AND C7_PRODUTO  = D1_COD"+ c_ent  
cQuery += " AND C7_CONTRAT  = CN9_NUMERO"+ c_ent  
cQuery += " AND CN9_SITUAC  = '05'"+ c_ent  
If	!Empty(MV_PAR01)  
	cQuery += " AND D1_COD = '"+MV_PAR01+"'"+ c_ent
EndIf
cQuery += " AND SC7.D_E_L_E_T_ <> '*'"+ c_ent 
cQuery += " AND SF1.D_E_L_E_T_ <> '*'"+ c_ent 
cQuery += " AND SD1.D_E_L_E_T_ <> '*'"+ c_ent 
cQuery += " AND CN9.D_E_L_E_T_ <> '*'"+ c_ent 
cQuery += " ORDER BY D1_COD "+ c_ent 

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

DbSelectArea(cAlias)

ProcRegua(RecCount())

While !Eof()
	
	If !lAuto
		IncProc("Contrato + DP :"+(cAlias)->D1_COD)
		Inkey(1)
	EndIf

	cQuerySD1 := " UPDATE "+RetSqlName("SD1")+ c_ent 
	cQuerySD1 += " SET D1_CUSTO5  = D1_CUSTO / "+Str((cAlias)->C7_TAXAUSD,11,4)+ c_ent 
	cQuerySD1 += " WHERE D1_COD   = '"+(cAlias)->D1_COD+"'"+ c_ent 
	cQuerySD1 += " AND D1_DTDIGIT > '"+DtoS(dDataFec)+"'"+ c_ent 
	cQuerySD1 += " AND D_E_L_E_T_ <> '*'"+ c_ent 
	TCSQLExec( cQuerySD1 )

	cQuerySD2 := " UPDATE "+RetSqlName("SD2")+ c_ent 
	cQuerySD2 += " SET D2_CUSTO5  = D2_CUSTO1 / "+Str((cAlias)->C7_TAXAUSD,11,4)+ c_ent 
	cQuerySD2 += " WHERE D2_COD   = '"+(cAlias)->D1_COD+"'"+ c_ent 
	cQuerySD2 += " AND D2_EMISSAO > '"+DtoS(dDataFec)+"'"+ c_ent 
	cQuerySD2 += " AND D_E_L_E_T_ <> '*'"+ c_ent 
	TCSQLExec( cQuerySD2 )

	cQuerySD3 := " UPDATE "+RetSqlName("SD3")+ c_ent 
	cQuerySD3 += " SET D3_CUSTO5  = D3_CUSTO1 / "+Str((cAlias)->C7_TAXAUSD,11,4)+ c_ent 
	cQuerySD3 += " WHERE D3_COD   = '"+(cAlias)->D1_COD+"'"+ c_ent 
	cQuerySD3 += " AND D3_EMISSAO > '"+DtoS(dDataFec)+"'"+ c_ent 
	cQuerySD3 += " AND D_E_L_E_T_ <> '*'"+ c_ent 
	TCSQLExec( cQuerySD3 )

/*    // 10/07/17 - Luis Felipe - Inicio
	cQuerySB9 := " UPDATE  "+RetSqlName("SB9")+ c_ent    
	cQuerySB9 += " SET B9_VINI5 = B9_VINI2, B9_CM5 = B9_CM2" + c_ent
	cQuerySB9 += " WHERE (D_E_L_E_T_ <> '*')"+ c_ent 
	cQuerySD3 += " AND B9_COD = '"+(cAlias)->D1_COD+"'"+ c_ent 
	cQuerySB9 += " AND (B9_VINI1 <> 0 AND (B9_VINI2 <> B9_VINI5) AND (B9_COD LIKE '%-%' OR B9_COD LIKE '%AMOS%'))"+ c_ent 
	cQuerySB9 += " AND (NOT EXISTS (SELECT C7_PRODUTO FROM "+RetSqlName("SC7")+ " WHERE (C7_PRODUTO = "+RetSqlName("SB9")+ ".B9_COD))) AND (D_E_L_E_T_ <> '*')"+ c_ent 
	If TCSQLExec( cQuerySB9 ) <> 0
		UserException("Falha na atualização da tabela de Saldos de Virada - " + TCSQLError() )
	EndIf
    // 10/07/17 - Luis Felipe - Fim
 */
	(cAlias)->(DbSkip())
End

(cAlias)->(DbCloseArea())

// Produtos sem Petax serão calculados a partir do dolar do dia 

cQuerySD1 := " UPDATE "+RetSqlName("SD1")+ c_ent 
cQuerySD1 += " SET D1_CUSTO5 = D1_CUSTO2"+ c_ent             
cQuerySD1 += " FROM "+RetSqlName("SD1")+" SD1 CROSS JOIN "+RetSqlName("SF4")+" SF4"+ c_ent
cQuerySD1 += " WHERE D1_DTDIGIT > '"+DtoS(dDataFec)+"'"+ c_ent 
cQuerySD1 += " AND D1_TES = F4_CODIGO"+ c_ent                                          
cQuerySD1 += " AND F4_ESTOQUE = 'S'"+ c_ent
If	!Empty(MV_PAR01)  
	cQuerySD1 += " AND D1_COD = '"+MV_PAR01+"'"+ c_ent
EndIf
cQuerySD1 += " AND SD1.D_E_L_E_T_ <> '*'"+ c_ent
cQuerySD1 += " AND SF4.D_E_L_E_T_ <> '*'"+ c_ent
cQuerySD1 += " AND NOT EXISTS (SELECT C7_PRODUTO FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D1_COD AND D_E_L_E_T_ <> '*')"+ c_ent   
If TCSQLExec( cQuerySD1 ) <> 0
	UserException("Falha na atualização da tabela SD1 - " + TCSQLError() )
EndIf

cQuerySD2 := " UPDATE "+RetSqlName("SD2")+ c_ent 
cQuerySD2 += " SET D2_CUSTO5 = D2_CUSTO2"+ c_ent            
cQuerySD2 += " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF4")+" SF4"+ c_ent
cQuerySD2 += " WHERE D2_EMISSAO > '"+DtoS(dDataFec)+"'"+ c_ent 
cQuerySD2 += " AND D2_TES = F4_CODIGO"+ c_ent
cQuerySD2 += " AND F4_ESTOQUE = 'S'"+ c_ent
If	!Empty(MV_PAR01)  
	cQuerySD2 += " AND D2_COD = '"+MV_PAR01+"'"+ c_ent
EndIf
cQuerySD2 += " AND SD2.D_E_L_E_T_ <> '*'"+ c_ent 
cQuerySD2 += " AND SF4.D_E_L_E_T_ <> '*'"+ c_ent 
cQuerySD2 += " AND NOT EXISTS (SELECT C7_PRODUTO FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ <> '*')"+ c_ent   
If TCSQLExec( cQuerySD2 ) <> 0
	UserException("Falha na atualização da tabela SD2 - " + TCSQLError() )
EndIf

cQuerySD3 := " UPDATE "+RetSqlName("SD3")+ c_ent 
cQuerySD3 += " SET D3_CUSTO5 = D3_CUSTO2"+ c_ent            
cQuerySD3 += " FROM "+RetSqlName("SD3")+ c_ent
cQuerySD3 += " WHERE D3_EMISSAO > '"+DtoS(dDataFec)+"'"+ c_ent 
If	!Empty(MV_PAR01)  
	cQuerySD3 += " AND D3_COD = '"+MV_PAR01+"'"+ c_ent
EndIf
cQuerySD3 += " AND D_E_L_E_T_ <> '*' "+ c_ent
cQuerySD3 += " AND NOT EXISTS (SELECT C7_PRODUTO FROM "+RetSqlName("SC7")+" WHERE C7_PRODUTO = D3_COD AND D_E_L_E_T_ <> '*')"+ c_ent
If TCSQLExec( cQuerySD3 ) <> 0
	UserException("Falha na atualização da tabela SD3 - " + TCSQLError() )
EndIf

If	!Empty(MV_PAR01)  
	*------------------------------------------------------------*
	* Executado apenas uma vez para corrigir o passado.          *
	*------------------------------------------------------------*
	cQuerySB9 := " UPDATE  "+RetSqlName("SB9")+ c_ent    
	cQuerySB9 += " SET B9_VINI5 = B9_VINI2, B9_CM5 = B9_CM2" + c_ent
	cQuerySB9 += " WHERE (D_E_L_E_T_ <> '*')"+ c_ent 
	If	!Empty(MV_PAR01)  
		cQuerySB9 += " AND B9_COD = '"+MV_PAR01+"'"+ c_ent
	EndIf
	cQuerySB9 += " AND (B9_VINI1 <> 0 AND (B9_VINI2 <> B9_VINI5) AND (B9_COD LIKE '%-%' OR B9_COD LIKE '%AMOS%'))"+ c_ent 
	cQuerySB9 += " AND (NOT EXISTS (SELECT C7_PRODUTO FROM "+RetSqlName("SC7")+ " WHERE (C7_PRODUTO = "+RetSqlName("SB9")+ ".B9_COD))) AND (D_E_L_E_T_ <> '*')"+ c_ent 
	If TCSQLExec( cQuerySB9 ) <> 0
		UserException("Falha na atualização da tabela de Saldos de Virada - " + TCSQLError() )
	EndIf
EndIf

Return

/* 
Guardado para futuras análises caso necessário

SELECT D1_DTDIGIT, D1_COD, D1_CUSTO
FROM SD1010 SD1, SM2010 SM2, SF4010 SF4 
WHERE D1_CUSTO5 = 0
AND D1_DTDIGIT >= '20160201'
AND D1_DTDIGIT = M2_DATA
AND D1_TES = F4_CODIGO 
AND F4_ESTOQUE = 'S'
AND SD1.D_E_L_E_T_ <> '*' 
AND SM2.D_E_L_E_T_ <> '*' 
AND NOT EXISTS (SELECT C7_PRODUTO FROM SC7010 WHERE C7_PRODUTO = D1_COD AND D_E_L_E_T_ <> '*')  
ORDER BY D1_COD, D1_DTDIGIT

SELECT D2_EMISSAO, D2_COD, D2_CUSTO1
FROM SD2010 SD2, SM2010 SM2, SF4010 SF4 
WHERE D2_CUSTO5 = 0
AND D2_EMISSAO >= '20160501'
AND D2_EMISSAO = M2_DATA
AND D2_TES = F4_CODIGO
AND F4_ESTOQUE = 'S'
AND SD2.D_E_L_E_T_ <> '*' 
AND SM2.D_E_L_E_T_ <> '*' 
AND SF4.D_E_L_E_T_ <> '*' 
AND NOT EXISTS (SELECT C7_PRODUTO FROM SC7010 WHERE C7_PRODUTO = D2_COD AND D_E_L_E_T_ <> '*')  
ORDER BY D2_COD, D2_EMISSAO

SELECT D3_EMISSAO, D3_COD, D3_CUSTO1
FROM SD3010 SD3, SM2010 SM2
WHERE D3_CUSTO5 = 0
AND D3_EMISSAO >= '20160401'
AND D3_EMISSAO = M2_DATA
AND D3_COD LIKE '%-%'
AND SD3.D_E_L_E_T_ <> '*' 
AND SM2.D_E_L_E_T_ <> '*' 
AND NOT EXISTS (SELECT C7_PRODUTO FROM SC7010 WHERE C7_PRODUTO = D3_COD AND D_E_L_E_T_ <> '*')  
ORDER BY D3_COD, D3_EMISSAO   

*-----------------------------*
Media em Dolar - Não será usado
*-----------------------------*
SELECT B9_COD, B9_DATA, B9_VINI1, B9_VINI5
, (SELECT SUM(M2_MOEDA2) / COUNT(M2_MOEDA2) MEDIA FROM SM2010 SM WHERE YEAR(M2_DATA) = YEAR(B9_DATA) AND MONTH(M2_DATA) = MONTH(B9_DATA) AND Datepart(weekday,M2_DATA) NOT IN ('1','7') AND D_E_L_E_T_ = '') MEDIA
FROM SB9010 
WHERE D_E_L_E_T_ <> '*'
AND B9_VINI1 <> 0
AND (NOT EXISTS (SELECT C7_PRODUTO FROM SC7010 WHERE C7_PRODUTO = B9_COD) AND (D_E_L_E_T_ <> '*'))
ORDER BY B9_DATA   

*------------------------------------------------------------*
Correção das Medias em Dolar dos meses anteriores - 17/06/2016
*------------------------------------------------------------*
SELECT B9_FILIAL, B9_COD, B9_LOCAL, B9_DATA, B9_QINI, B9_VINI1, B9_VINI2, B9_VINI5, B9_CM1, B9_CM2, B9_CM5 
FROM SB9010 
WHERE D_E_L_E_T_ <> '*'
AND (B9_VINI1 <> 0 AND (B9_VINI2 <> B9_VINI5) AND (B9_COD LIKE '%-%' OR B9_COD LIKE '%AMOS%'))
AND (NOT EXISTS (SELECT C7_PRODUTO FROM SC7010 WHERE C7_PRODUTO = B9_COD) AND (D_E_L_E_T_ <> '*'))
ORDER BY B9_DATA   

*------------------------------------------------------------*
Executado apenas uma vez para corrigir o passado.
*------------------------------------------------------------*
cQuerySB9 := " UPDATE  "+RetSqlName("SB9")+ c_ent    
cQuerySB9 += " SET B9_VINI5 = B9_VINI2, B9_CM5 = B9_CM2" + c_ent
cQuerySB9 += " WHERE (D_E_L_E_T_ <> '*')"+ c_ent 
cQuerySB9 += " AND (B9_VINI1 <> 0 AND (B9_VINI2 <> B9_VINI5) AND (B9_COD LIKE '%-%' OR B9_COD LIKE '%AMOS%'))"+ c_ent 
cQuerySB9 += " AND (NOT EXISTS (SELECT C7_PRODUTO FROM "+RetSqlName("SC7")+ " WHERE (C7_PRODUTO = "+RetSqlName("SB9")+ ".B9_COD))) AND (D_E_L_E_T_ <> '*')"+ c_ent 
If TCSQLExec( cQuerySB9 ) <> 0
	UserException("Falha na atualização da tabela de Saldos de Virada - " + TCSQLError() )
EndIf

cQuerySB9 := " UPDATE "+RetSqlName("SB9")+ c_ent 
cQuerySB9 += " SET B9_VINI5   = (B9_VINI1 / "+Str((cAlias)->C7_TAXAUSD,11,4)+"), "+ c_ent 
cQuerySB9 += "     B9_CM5     = (B9_VINI1 / "+Str((cAlias)->C7_TAXAUSD,11,4)+") / B9_QINI "+ c_ent 
cQuerySB9 += " WHERE B9_COD   = '"+(cAlias)->D1_COD+"'"+ c_ent 
cQuerySB9 += " AND B9_VINI1   <>  '0'"+ c_ent 
cQuerySB9 += " AND D_E_L_E_T_ <> '*'"+ c_ent 
TCSQLExec( cQuerySB9 )
*/

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1             2      3                      4                        5                        6           7     8   9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24        25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40  41  42             43
AADD(aSx1,{"EDFFCUSTO" , "01" , "Produto       	  ?" , "Produto       	   ?" , "Produto       	    ?" , "mv_ch1" , "C" , 25 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SB1" , "" , "", "", "" , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFFCUSTO  01")
	
	DbSeek("EDFFCUSTO")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFFCUSTO"
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
