#INCLUDE "PROTHEUS.ch"
#INCLUDE "APWEBEX.CH"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ BRERIEX º Autor ³ Davi Jesus         º Data ³  26/10/11    º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Relação das NF SEM RIEX                                    º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function BRERIEX()

Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2     := "de NF´S (exportação) sem amarrações ao RIEX. "
Local cDesc3     := "NFs Exportação sem USO Riex"
Local cPict      := ""
Local titulo     := "NFs Exportação sem USO Riex"
Local nLin       := 80
Local Cabec1     := "  Nota      Data       Numero                 Codigo          Quantidade "
Local Cabec2     := " Fiscal    Emissão     Contrato               Produto          Exportada "
//                   999999999  99/99/9999  xxxxxxxxxxxxxxxxxxxxx  999999999  999,999,999.999 
//                   123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                            1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22        23        24

Local imprime        := .T.
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 120
Private tamanho      := "M"
Private nomeprog     := "breriex"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "breriex001"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "breriex"

CriaSx1(cPerg)

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint("SF2",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,"SF2")

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RepRFAT(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºFun‡„o    ³REPRFAT º Autor ³ Davi Jesus           º Data ³  26/10/11   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
//±±º          ³ monta a janela com a regua de processamento.               º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ Programa principal                                         º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function REPRFAT(Cabec1,Cabec2,Titulo,nLin)
Local cQuery  := ""

cQuery := "SELECT F2_DOC, F2_EMISSAO, C5_CONTRAT, D2_COD, SUM(D2_QUANT) as D2_QUANT FROM "+RetSqlName("SF2")+" AS F2"
cQuery += "  INNER JOIN "+RetSqlName("SD2")+" AS D2 ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE "
cQuery += "  INNER JOIN "+RetSqlName("SC5")+" AS C5 ON C5_NUM = D2_PEDIDO   "
cQuery += " WHERE D2_CF = '7501' AND F2_TIPO = 'N'"
cQuery += "  AND D2.D_E_L_E_T_ = ' ' AND F2.D_E_L_E_T_ = ' '"
cQuery += "  AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
cQuery += "  AND F2_DOC NOT IN (SELECT DISTINCT ZU_NOTA FROM "+RetSqlName("SZU")+" AS ZU WHERE D_E_L_E_T_ = ' ')"
cQuery += " GROUP BY F2_DOC, F2_EMISSAO, C5_CONTRAT, D2_COD"
cQuery += " ORDER BY F2_EMISSAO"

If select("TRB") > 0
   TRB->( dbCloseArea() )
Endif
    
cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .F. )

dbSelectArea("TRB")
SetRegua( RecCount() )
dbGoTop()

While TRB->(!EOF())
	
    Incregua()
  
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 63
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif

    @++nLin,001 PSAY ALLTRIM(TRB->F2_DOC)
    @  nLin,012 PSAY STOD(TRB->F2_EMISSAO)
	@  nLin,024 PSAY ALLTRIM(TRB->C5_CONTRAT)
	@  nLin,047 PSAY ALLTRIM(TRB->D2_COD)
	@  nLin,058 PSAY TRANSFORM(TRB->D2_QUANT,"@e 999,999,999.999")
    		
	dbSelectArea("TRB")
	TRB->( dbSkip() )
End

dbCloseArea("TRB")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

*********************************************************************************************************
Static Function CriaSx1(cPerg)
*********************************************************************************************************
Local nX := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Nota Emitida de? ","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"02","Nota Emitida Ate?","mv_ch2","D",08,0,0,"G","NAOVAZIO()","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)
For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny
RestArea(aAreaSX1)
RestArea(aAreaAnt)
Return Nil