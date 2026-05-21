#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "Tbiconn.ch"
#DEFINE __cCRLF CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFR004  ºAutor  ³Luis Felipe Nascimento ³Data ³  28/10/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Balancete em Excel                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contabilidade                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºSaldoConta³ Retorna o saldo atual [1] da conta 2101 na database do  	  º±±
±±º          ³ sistema para o moeda 1, saldo 1                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFR004()

Local aArea 		:= GetArea()

Private lCtb       	:= CtbInUse()
Private cString    	:= "CT1"
Private wnrel      	:= "EDFR004"
Private aOrd       	:= {"Conta"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Relatorio de Balancete das Contas Contábeis"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Relatorio de Balancete das Contas Contábeis", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR004"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR004"
Private wnrel      	:= "EDFR004"

CriaSx1()

Pergunte(cPerg,.T.)

If LastKey() == 27
	Return
Endif

If nLastKey == 27
	Return
Endif

If !Empty(MV_PAR01)
	Processa({|| EDFR004A() },"Calculando Saldos Contábeis ... ")
Else
	Aviso("Atenção","É necessário informar uma data para gerar a planilha com o Saldo das Contas Contábeis !",{"Sair"})
EndIf

RestArea(aArea)

Return

*------------------------*
Static Function EDFR004A()
*------------------------*

Local cPeriodo  := SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4)
Local aCabec 	:= {"Cod. Conta","Descrição","Mês "+cPeriodo+" BRL","Mês "+cPeriodo+" USD","FX","Sld. "+cPeriodo+" BRL","Sld. "+cPeriodo+" USD","FX"}
Local aSldConta := {} 
Local cEmpresa  := SM0->M0_CODIGO
Local nRecnoSM0 := SM0->(Recno())    
Local aFiliais  := {}
Local aSldCtaMes:= {}

Private dDataI  := CtoD("01/"+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4))
Private dDataf  := LastDay(CtoD("01/"+SubStr(MV_PAR01,1,2)+"/"+SubStr(MV_PAR01,3,4)))

DbSelectArea("SM0")
DbGotop()

While !Eof()
 	If SM0->M0_CODIGO == cEmpresa
	 	Aadd(aFiliais,Alltrim(SM0->M0_CODFIL))
	EndIf 	
	DbSkip()
End

DbSelectArea("CT1")
DbSetOrder(1)
DbGotop()

ProcRegua(RecCount())

While !Eof()

	If CT1->CT1_CLASSE <> "2" .or. CT1->CT1_CONTA < MV_PAR03 .or. CT1->CT1_CONTA > MV_PAR04
		DbSkip()
		Loop
	EndIf

	Store 0 to nSaldoM1,nSaldoM2
	Store 0 to nSldMesM1,nSldMesM2
	
	IncProc("Da Conta : "+CT1->CT1_CONTA)

	For a:=1 to Len(aFiliais) 
		nSaldoM1 := nSaldoM1 + SaldoConta(CT1->CT1_CONTA,dDataf,"01","1",1,0,MV_PAR02,aFiliais[a])
		nSaldoM2 := nSaldoM2 + SaldoConta(CT1->CT1_CONTA,dDataf,"02","1",1,0,MV_PAR02,aFiliais[a])
	Next
	nSldMesM1 := fSldMes("01",CT1->CT1_CONTA)
	nSldMesM2 := fSldMes("02",CT1->CT1_CONTA)
	If MV_PAR05 == 1 .and. nSldMesM1 == 0 .and. nSldMesM2 == 0 .and. nSaldoM1 == 0 .and. nSaldoM2 == 0 
		DbSelectArea("CT1")
		DbSkip()
		Loop
	EndIf
	
	Aadd(aSldConta,{CT1->CT1_CONTA,CT1->CT1_DESC01,nSldMesM1,nSldMesM2,nSldMesM1/nSldMesM2,-1*nSaldoM1,-1*nSaldoM2,nSaldoM1/nSaldoM2})
	
	DbSelectArea("CT1")
	DbSkip()

End

DbSelectArea("SM0")
DbGoto(nRecnoSM0)

DlgToExcel({ {"ARRAY", "", aCabec, aSldConta} })

Return

*------------------------------------*
Static Function fSldMes(cMoeda,cConta)
*------------------------------------*

Local cQuery := "" 
Local cAlias := GetNextAlias()
Local nValor := 0

cQuery := " SELECT  "+__cCRLF
cQuery += "	( CASE WHEN ( ISNULL(D.CT1_CONTA,' ') = ' ' ) THEN C.CT1_CONTA ELSE D.CT1_CONTA END ) AS CT1_CONTA,"+__cCRLF
cQuery += "	( CASE WHEN ( ISNULL(D.CT1_DESC01,' ') = ' ' ) THEN C.CT1_DESC01 ELSE D.CT1_DESC01 END ) AS CT1_DESC01,"+__cCRLF
cQuery += "	( "+__cCRLF
cQuery += "		( CASE WHEN ( ISNULL(D.CT2_VALOR,0) = 0  ) THEN 0 ELSE D.CT2_VALOR END )"+__cCRLF
cQuery += "		-"+__cCRLF
cQuery += "		( CASE WHEN ( ISNULL( C.CT2_VALOR , 0 ) = 0  ) THEN 0 ELSE C.CT2_VALOR END ) "+__cCRLF
cQuery += "	) AS CT2_VALOR"+__cCRLF
cQuery += "FROM"+__cCRLF
cQuery += "("+__cCRLF
cQuery += "	SELECT "+__cCRLF
cQuery += "		CT1.CT1_CONTA,"+__cCRLF
cQuery += "		CT1.CT1_DESC01,"+__cCRLF
cQuery += "		SUM(CT2.CT2_VALOR) AS CT2_VALOR,"+__cCRLF
cQuery += "		'D' AS CT2_DC"+__cCRLF
cQuery += "FROM "+__cCRLF
cQuery += "	" + RetSqlName("CT1") + " CT1, "+__cCRLF
cQuery += "	" + RetSqlName("CT2") + " CT2 "+__cCRLF
cQuery += "	WHERE"+__cCRLF
cQuery += "		CT1.D_E_L_E_T_ = ' '"+__cCRLF
cQuery += "	AND"+__cCRLF
cQuery += "		CT2.D_E_L_E_T_ = ' '"+__cCRLF
cQuery += "	AND"+__cCRLF
cQuery += "		CT2.CT2_DEBITO = '"+cConta+"'"+__cCRLF
cQuery += "	AND"+__cCRLF
cQuery += "		(CT2_MOEDLC = '"+cMoeda+"' AND (CT2.CT2_DC = '1' OR CT2.CT2_DC = '3'))"+__cCRLF
cQuery += "	AND"+__cCRLF
cQuery += "	    CT2.CT2_DATA Between '" + DtoS(dDataI) + "' AND '"+ DtoS(dDataF) + "'"+__cCRLF
cQuery += "	GROUP BY"+__cCRLF
cQuery += "		CT1.CT1_CONTA,"+__cCRLF
cQuery += "		CT1.CT1_DESC01"+__cCRLF
cQuery += ") AS D"+__cCRLF
cQuery += "FULL OUTER JOIN"+__cCRLF
cQuery += "(	"+__cCRLF
cQuery += "	SELECT "+__cCRLF
cQuery += "		CT1.CT1_CONTA,"+__cCRLF
cQuery += "		CT1.CT1_DESC01,"+__cCRLF
cQuery += "		SUM(CT2.CT2_VALOR) AS CT2_VALOR,"+__cCRLF
cQuery += "		'C' AS CT2_DC"+__cCRLF
cQuery += "	FROM "+__cCRLF
cQuery += "	" + RetSqlName("CT1") + " CT1, "+__cCRLF
cQuery += "	" + RetSqlName("CT2") + " CT2 "+__cCRLF
cQuery += "	WHERE"+__cCRLF
cQuery += "		CT1.D_E_L_E_T_ = ' '"+__cCRLF
cQuery += "	AND"+__cCRLF
cQuery += "		CT2.D_E_L_E_T_ = ' '"+__cCRLF
cQuery += "	AND"+__cCRLF
cQuery += "		CT2.CT2_CREDIT = '"+cConta+"'"+__cCRLF
cQuery += "	AND"+__cCRLF
cQuery += "		(CT2_MOEDLC = '"+cMoeda+"' AND (CT2.CT2_DC = '2' OR CT2.CT2_DC = '3'))	"+__cCRLF
cQuery += "	AND"+__cCRLF
cQuery += "	    CT2.CT2_DATA Between '" + DtoS(dDataI) + "' AND '"+ DtoS(dDataF) + "'"+__cCRLF
cQuery += "	GROUP BY"+__cCRLF
cQuery += "		CT1.CT1_CONTA,"+__cCRLF
cQuery += "		CT1.CT1_DESC01"+__cCRLF
cQuery += ") AS C"+__cCRLF
cQuery += "ON"+__cCRLF
cQuery += "	D.CT1_CONTA = C.CT1_CONTA"+__cCRLF
cQuery += "ORDER BY"+__cCRLF
cQuery += "	CT1_CONTA,"+__cCRLF
cQuery += "	CT1_DESC01"+__cCRLF

If Select(cAlias) > 0
	(cAlias)->(DbCloseArea())
Endif

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)

Dbselectarea(cAlias)       

nValor := (cAlias)->CT2_VALOR

(cAlias)->(DbCloseArea())

Return(nValor)

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                     4                       5                      6          7     8    9  10   11  12   13             14      15   16   17   18   19      20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38      39   40  41  42            43
AADD(aSx1,{"EDFR004" , "01" , "Mês/Ano          ?" , "Mês/Ano          ?" , "Mês/Ano          ?" , "mv_ch1" , "C" , 07 , 0 , 0 , "G" , "" , "mv_par01" , ""    , "" , "" , "" , "" , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "@R 99/9999", ""})
AADD(aSx1,{"EDFR004" , "02" , "Dt.Lucros Perdas ?" , "Dt.Lucros Perdas ?" , "Dt.Lucros Perdas ?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , ""    , "" , "" , "" , "" , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", ""          , ""})
AADD(aSx1,{"EDFR004" , "03" , "Conta De         ?" , "Conta De         ?" , "Conta De         ?" , "mv_ch3" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par03" , ""    , "" , "" , "" , "" , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1" , "" , "", "", ""          , ""})
AADD(aSx1,{"EDFR004" , "04" , "Conta Ate        ?" , "Conta Ate        ?" , "Conta Ate        ?" , "mv_ch4" , "C" , 20 , 0 , 0 , "G" , "" , "mv_par04" , ""    , "" , "" , "" , "" , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CT1" , "" , "", "", ""          , ""})
AADD(aSx1,{"EDFR004" , "05" , "Contas Zeradas   ?" , "Conta Zeradas    ?" , "Conta Zeradas    ?" , "mv_ch5" , "N" , 01 , 0 , 0 , "C" , "" , "mv_par05" , "Não" , "" , "" , "" , "" , "Sim" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", ""          , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR004   05")
	
	DbSeek("EDFR004")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR004"
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
