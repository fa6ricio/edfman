#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO7     º Autor ³ AP6 IDE            º Data ³  05/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function GeraNFTS


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPerg       := "RELNFT"
Private oGeraTxt

Private cString := "TMP"
ValidPerg()
Pergunte( cPerg,.t. )
//dbSelectArea("TMP")
//dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " TMP                                                           "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  05/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cArqTxt := "E:\FINANCEIRO\FISCAL\NFTS.TXT"
Private nHdl    //:= fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"

If Right(AllTrim(mv_par04),1) == '\'
	cArqtxt	:= AllTrim(mv_par04)+AllTrim(mv_par03)
Else
	cArqtxt	:= AllTrim(mv_par04)+'\'+AllTrim(mv_par03)
EndIf

nHdl    := fCreate(cArqTxt)
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  05/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont

Local nTamLin, cLin, cCpo,cQuery
Local cNotasExc		:= ""
Local cCli			:= ""
cLin	:= '1001'
cLin	+= '34819614'//SM0->M0_INSC
cLin	+= DTOS(mv_par01)//mv_datainicial
cLin	+= DTOS(mv_par02)//mv_datafinal
cLin	+= cEOL
If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
    //Exit
    Endif
Endif

If !Empty(mv_par05)
	cNotasExc	:= StrTran(AllTrim(mv_par05),",","','")
	cNotasExc	:= StrTran(AllTrim(mv_par05),"/","','")
EndIf

If !Empty(mv_par06)
	cCli	:= StrTran(AllTrim(mv_par06),"/","','")
EndIf

cQuery		:= " SELECT F1_SERIE, F1_DOC, F1_EMISSAO, F1_FORNECE, F1_LOJA, A2_CGC, A2_NOME, A2_TIPO, A2_CEP, A2_RECISS,"
cQuery		+= " SUM(D1_VALISS) D1_VALISS, SUM(D1_TOTAL) D1_TOTAL"
cQuery		+= " FROM "+RetSqlName("SF1")+" F1"
cQuery		+= " INNER JOIN "+RetSqlName("SD1")+" D1"
cQuery		+= " ON F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA = D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA AND D1_COD NOT IN('000009','000077','000078') AND D1.D_E_L_E_T_ <> '*'"
cQuery		+= " INNER JOIN "+RetSqlName("SB1")+" B1"
cQuery		+= " ON D1_COD = B1_COD AND B1_TIPO = 'SV' AND B1.D_E_L_E_T_ <> '*'"
cQuery		+= " INNER JOIN "+RetSqlName("SA2")+" A2"
cQuery		+= " ON F1_FORNECE+F1_LOJA = A2_COD+A2_LOJA AND A2_COD_MUN <> '50308' AND A2.D_E_L_E_T_ <> '*'"
cQuery		+= " WHERE F1_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND F1.D_E_L_E_T_ <> '*'"
cQuery		+= " AND F1_DOC NOT IN('"+cNotasExc+"')"
If !Empty(mv_par06)
	cQUery	+= " AND F1_FORNECE IN ('"+cCli+"')"
EndIf
cQuery		+= " GROUP BY F1_SERIE, F1_DOC, F1_EMISSAO,  F1_FORNECE, F1_LOJA, A2_CGC, A2_NOME, A2_TIPO,A2_CEP,A2_RECISS"
cQuery		+= " ORDER BY F1_SERIE, F1_DOC, F1_FORNECE"
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbselectarea("TRB")  
TRB->(dbGoTop())
ProcRegua(RecCount()) // Numero de registros a processar

nTot4	:= 0
nSoma4	:= 0
While !EOF()

    IncProc()
    
    cLin	:= "4"
    cLin	+= "02"
    cLin	+= TRB->F1_SERIE+Space(2)
    cLin	+= TRB->F1_DOC+Space(3)
    cLin	+= (TRB->F1_EMISSAO)
    cLin	+= "N"
    cLin	+= "T"
    cLin	+= STRZero(TRB->D1_TOTAL*100,15)
    cLin	+= STRZero(0,15)	//verificar quais os campos de deducoes
    cLin	+= ConsultaItem(TRB->F1_SERIE+TRB->F1_DOC+TRB->F1_FORNECE,"B1_TRIBMUN",5)		//AllTrim(TRB->B1_TRIBMUN)+Space(5-Len(AllTrim(TRB->B1_TRIBMUN)))
    cLin	+= Space(4)
    cLin	+= IIF(TRB->A2_RECISS == 'N','0000',STRZero(ConsultaItem(TRB->F1_SERIE+TRB->F1_DOC+TRB->F1_FORNECE,"D1_ALIQISS",0)*100,4))
    cLin	+= IIF(TRB->D1_VALISS>0 .And. TRB->A2_RECISS == 'N',"1","2")
    cLin	+= IIF(TRB->A2_TIPO=="F","1","2")
    cLin	+= TRB->A2_CGC
    cLin	+= Space(8)		//ALLTRIM(Posicione("SA2",1,xFilial("SA2")+TRB->F1_FORNECE+TRB->F1_LOJA,"A2_INSCRM"))
    cLin	+= TRB->A2_NOME+Space(35)
    cLin	+= Space(3)
    cLin	+= Space(50)
    cLin	+= Space(10)
	cLin	+= Space(30)
	cLin	+= Space(30)
	cLin	+= Space(50)
	cLin	+= Space(2)
	cLin	+= TRB->A2_CEP
	cLin	+= Space(75)
	cLin	+= "1"
	cLin	+= "0"
	cLin	+= Space(8)
	cLin	+= ConsultaItem(TRB->F1_SERIE+TRB->F1_DOC+TRB->F1_FORNECE,"B1_DESC",0)//TRB->B1_DESC
	cLin	+= cEOL
	nTot4	++ 
	nSoma4	+= TRB->D1_TOTAL
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            //Exit
        Endif
    Endif

    TRB->(dbSkip())
EndDo

cLin	:= "9"
cLin	+= StrZero(nTot4,7)
cLin	+= StrZero(nSoma4*100,15)
cLin	+= StrZero(0,15)
cLin	+= cEOL
If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
        //Exit
    Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
Close(oGeraTxt)
TRB->(DbCloseArea())
MsgInfo("Arquivo gerado.")
Return

Static Function ValidPerg  
cPerg	:= PADR(cPerg,10)
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}              

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Data de:   "   , "Data de    ", "Data de    "      ,"mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data ate:  "   , "Data ate   ", "Data ate   "      ,"mv_ch2","D",08,0,0,"G","NAOVAZIO()","mv_par02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Nome do Arquivo","           ", "           "      ,"mv_ch3","C",15,0,0,"G","NAOVAZIO()","mv_par03","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Diretorio: "   , "           ", "           "      ,"mv_ch4","C",70,0,0,"G","NAOVAZIO()","mv_par04","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","NF´s a Excluir ", "           ", "           "     ,"mv_ch5","C",70,0,0,"G",""          ,"mv_par05","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Somente Fornecedores", "      ", "           "     ,"mv_ch6","C",70,0,0,"G",""          ,"mv_par06","","","","","","","","","","","","","","",""})
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERANFTS  ºAutor  ³Milton Nishimoto    º Data ³  09/20/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna os campos do item principal da Nota.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Bauche - Facri                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ConsultaItem(cChave,cCampo,nTam)
Local cVal	:= "" 
Local Area	:= GetArea()
cQuery	:= " SELECT TOP 1 * FROM "+RetSqlName("SD1")+" D1"
cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" B1 ON D1_COD = B1_COD AND B1_COD NOT IN('000009','000077','000078') AND B1.D_E_L_E_T_ <> '*'"
cQuery	+= " WHERE D1_SERIE+D1_DOC+D1_FORNECE = '"+cChave+"'"
cQuery	+= " AND B1_TIPO = 'SV' AND D1.D_E_L_E_T_ <> '*'"
cQuery	+= " ORDER BY D1_TOTAL"
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP",.F.,.T.)
dbselectarea("TMP")  
cVal	:=  &('TMP->'+cCampo)
If nTam > 0
	cVal	:= AllTrim(cVal)+Space(nTam-Len(AllTrim(cVal)))
EndIf
TMP->(DbCloseArea())
RestArea(Area)
Return cVal