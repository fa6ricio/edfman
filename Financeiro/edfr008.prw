#INCLUDE "rwmake.ch"

#DEFINE CENT	Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EDFR008  บ Autor ณ Luis Felipe Nascim.บ Data ณ  04/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio de Posi็ใo de Custos Acess๓rios                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function EDFR008()

Local cDesc1         := "Posi็ใo de Custos Acess๓rios"
Local cDesc2         := ""
Local cDesc3         := ""
Local cPict          := ""
Local imprime        := .T.
Local aOrd           := {"Contrato"}
Local cPerg          := "EDFR008"

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "EDFR008"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "EDFR008"
Private titulo       := "Posi็ใo de Custos Acess๓rios"
Private nLin         := 80
Private Cabec1       := " CONTRATO                 CLAS.VLR. BOOKING NUMBER  NAVIO                TIPO    EMISSAO    VENC. REAL BAIXA      FORNECEDOR                        PERC.    QUANTIDADE     VALOR REAL TX.DOLAR    VALOR DOLAR NFISCAL   PRX"
Private Cabec2       := ""
Private cString      := "SZ3"

CriaSX1()

*------------------------------------*
*   Array das Informa็๕es do Excel   *
*------------------------------------*
Private aDadosExc := {}
Private aCabExc	  := {}

*-------------------------------------------------*
*   Chama Fun็ใo para Ajustar Parโmetros na SX1   *
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
*   Cabe็alho do Excel   *
*------------------------*
aCabExc := {"CONTRATO",;// 1
"CLAS.VLR.",;			// 2
"BOOKING NUMBER",;		// 3
"NAVIO",;				// 4
"TIPO",;				// 5
"EMISSAO",;				// 6
"VENC. REAL",;			// 7
"BAIXA",;				// 8
"FORNECEDOR",;			// 9
"TRANSACAO",;			// 10
"PERC.",;				// 11
"QUANTIDADE",;			// 12
"VALOR REAL",;			// 13
"TX.DOLAR",;			// 14
"VALOR DOLAR",;			// 15
"NFISCAL",;				// 16
"PRX",;					// 17
"OBSERVACAO"}			// 18

Processa({|lEnd| EDFR008T (wnRel)})

Return

*-----------------------------*
Static Function EDFR008T(wnRel)
*-----------------------------*

Local cAliasQry := GetNextAlias()
Local cQry      := ""

Private nCountnx:= 0
Private nCountny:= 1

cQry := "SELECT * FROM "+CENT
cQry += "(SELECT D1_CLVL, D1_XCONTRI, D1_DTDIGIT, A2_NREDUZ, D1_XDESCRI, (D1_TOTAL/F1_VALMERC) PERC, D1_QUANT, D1_TOTAL, M2_MOEDA2, F1_DOC, F1_SERIE, D1_XOBS, D1_FORNECE, D1_LOJA, D1_DOC, D1_SERIE, D1_XNAVIOI "+CENT
cQry += "FROM "+RetSqlName("SF1")+" SF1, "+RetSqlName("SD1")+" SD1, "+RetSqlName("SA2")+" SA2, "+RetSqlName("SM2")+" SM2 "+CENT
cQry += "WHERE F1_FILIAL = D1_FILIAL "+CENT
cQry += "AND F1_DOC      = D1_DOC "+CENT
cQry += "AND F1_SERIE    = D1_SERIE "+CENT
cQry += "AND F1_FORNECE  = D1_FORNECE "+CENT
cQry += "AND F1_LOJA     = D1_LOJA "+CENT
cQry += "AND F1_FORNECE  = A2_COD "+CENT
cQry += "AND F1_LOJA     = A2_LOJA "+CENT
cQry += "AND F1_DTDIGIT  = M2_DATA "+CENT
//
// Filtros do relat๓rio
//
If !Empty(MV_PAR01) .and. !Empty(MV_PAR02)
	cQry += " AND D1_DTDIGIT BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"'"+CENT
EndIf

If !Empty(MV_PAR03)
	cQry += " AND D1_XCONTRI = '"+MV_PAR03+"'"+CENT
Else
	cQry += " AND D1_XCONTRI <> ' '"+CENT
EndIf

If !Empty(MV_PAR04)
	cQry += " AND D1_XNAVIOI = '"+MV_PAR04+"'"+CENT
EndIf

If !Empty(MV_PAR05)
	cQry += " AND D1_FORNECE = '"+MV_PAR05+"'"+CENT
EndIf

cQry += "AND SF1.D_E_L_E_T_ = '' "+CENT
cQry += "AND SD1.D_E_L_E_T_ = '' "+CENT
cQry += "AND SA2.D_E_L_E_T_ = '' "+CENT
cQry += "AND SM2.D_E_L_E_T_ = '') "+CENT
cQry += "AS SD1 "+CENT
cQry += "LEFT JOIN "+CENT
cQry += "(SELECT CTH_CLVL,CTH_VESSEL,CTH_BOOKIN "+CENT
cQry += "FROM "+RetSqlName("CTH")+" CTH "+CENT
cQry += "WHERE D_E_L_E_T_ = '') "+CENT
cQry += "AS CTH "+CENT
cQry += "ON SD1.D1_CLVL = CTH.CTH_CLVL "+CENT
cQry += "LEFT JOIN "+CENT
cQry += "(SELECT E2_FORNECE,E2_LOJA,E2_NUM,E2_PREFIXO,E2_VENCREA,E2_BAIXA "+CENT
cQry += "FROM "+RetSqlName("SE2")+" SE2 "+CENT
cQry += "WHERE D_E_L_E_T_ = '') "+CENT
cQry += "AS SE2 "+CENT
cQry += "ON SD1.D1_FORNECE = SE2.E2_FORNECE AND SD1.D1_LOJA = SE2.E2_LOJA AND SD1.D1_DOC = SE2.E2_NUM AND SD1.D1_SERIE = SE2.E2_PREFIXO "+CENT
cQry += "ORDER BY 1,2 "+CENT

If Select(cAliasQry) > 0
	dbselectarea(cAliasQry)
	(cAliasQry)->(dbCloseArea())
Endif

MemoWrite("C:\Tmp\EDFR008.txt",cQry)
cQry := ChangeQuery(cQry)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),cAliasQry,.F.,.T.)
dbselectarea(cAliasQry)
(cAliasQry)->(DbGoTop())

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
	IncProc("Processando Impressใo...")
	
	While (cAliasQry)->(!EOF())
		
		IncProc("Imprimindo Relat๓rio - "+Alltrim(STR(nCountny))+" de "+Alltrim(STR(nCountnx))+" Registros...")
		
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
		
		*--------------------------------------------*
		*  Quebra para a totalizacao ......          *
		*--------------------------------------------*
		@nLin,001 PSay SubStr((cAliasQry)->D1_XCONTRI,1,24)
		@nLin,026 PSay (cAliasQry)->D1_CLVL
		@nLin,036 PSay (cAliasQry)->CTH_BOOKIN
		@nLin,052 PSay SubStr(If(!Empty((cAliasQry)->D1_XNAVIOI),(cAliasQry)->D1_XNAVIOI,(cAliasQry)->CTH_VESSEL),1,20)
		@nLin,073 PSay If(Alltrim((cAliasQry)->D1_CLVL) = 'INTERCO','Interco','Man Br')		
		@nLin,081 PSay StoD((cAliasQry)->D1_DTDIGIT) 	Picture "@D"
		@nLin,092 PSay StoD((cAliasQry)->E2_VENCREA) 	Picture "@D"
		@nLin,103 PSay StoD((cAliasQry)->E2_BAIXA) 		Picture "@D"
		@nLin,114 PSay SubStr((cAliasQry)->A2_NREDUZ,1,30)   	
		@nLin,147 PSay (cAliasQry)->PERC				Picture "@E 999.99"
		@nLin,154 PSay (cAliasQry)->D1_QUANT			Picture "@E 9,999,999.999"
		@nLin,168 PSay (cAliasQry)->D1_TOTAL   			Picture "@E 999,999,999.99"
		@nLin,183 PSay (cAliasQry)->M2_MOEDA2  			Picture "@E 999.9999"
		@nLin,192 PSay (cAliasQry)->D1_TOTAL/(cAliasQry)->M2_MOEDA2 Picture "@E 999,999,999.99"
		@nLin,207 PSay (cAliasQry)->F1_DOC		    	Picture "@!"
		@nLin,217 PSay (cAliasQry)->F1_SERIE		    Picture "@!"
		
		nLin++
		
		*--------------------------------------*
		*   Recebe Dados para Gera็ใo do Excel *
		*--------------------------------------*
		aAdd(aDadosExc,{(cAliasQry)->D1_XCONTRI,;
		(cAliasQry)->D1_CLVL,;
		(cAliasQry)->CTH_BOOKIN,;
		If(!Empty((cAliasQry)->D1_XNAVIOI),(cAliasQry)->D1_XNAVIOI,(cAliasQry)->CTH_VESSEL),;
		If(Alltrim((cAliasQry)->D1_CLVL) = 'INTERCO','Interco','Man Br'),;
		StoD((cAliasQry)->D1_DTDIGIT),;
		StoD((cAliasQry)->E2_VENCREA),;
		StoD((cAliasQry)->E2_BAIXA),;
		(cAliasQry)->A2_NREDUZ,;
		(cAliasQry)->D1_XDESCRI,;
		Round((cAliasQry)->PERC,2),;
		(cAliasQry)->D1_QUANT,;
		(cAliasQry)->D1_TOTAL,;
		(cAliasQry)->M2_MOEDA2,;
		Round((cAliasQry)->D1_TOTAL/(cAliasQry)->M2_MOEDA2,2),;
		"'"+(cAliasQry)->F1_DOC,;
		"'"+(cAliasQry)->F1_SERIE,;
		Upper((cAliasQry)->D1_XOBS)})

		(cAliasQry)->(dbSkip())
		nCountny++

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
* Finaliza Impressใo  *
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

//         1           2      3                        4                       5                        6           7     8   9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38  39  40  41  42  43
AADD(aSx1,{"EDFR008" , "01" , "Data De            ?" , "Data De           ?" , "Data De            ?" , "mv_ch1" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR008" , "02" , "Data Ate           ?" , "Data Ate          ?" , "Data Ate           ?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR008" , "03" , "Contrato           ?" , "Contrato          ?" , "Contrato           ?" , "mv_ch3" , "C" , 25 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR008" , "04" , "Navio         	  ?" , "Navio      		  ?" , "Navio         	   ?" , "mv_ch4" , "C" , 15 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR008" , "05" , "Fornecedor    	  ?" , "Fornecedor 		  ?" , "Fornecedor    	   ?" , "mv_ch5" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SA2A" , "" , "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR008   05")
	
	DbSeek("EDFR008")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR008"
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
CONTRATO                 CLAS.VLR. BOOKING NUMBER  NAVIO                TIPO    EMISSAO    VENC. REAL BAIXA      FORNECEDOR                        PERC.    QUANTIDADE     VALOR REAL TX.DOLAR    VALOR DOLAR NFISCAL   PRX
123456789-123456789-1234 123456789 123456789-12345 123456789-123456789- 1234567 12/12/1211 12/12/1211 12/12/1211 1213456789-1213456789-123456789- 999,99 9,999,999.999 999,999,999.99 999,9999 999,999,999.99 123456789 123
1                        26        36              52                   73      81         92         103        114                              147    154           168            183      192            207       217
123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789
		10         20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180      190       200       210
*/
