/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONTAINERSºAutor  ³Microsiga           º Data ³  05/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de consulta                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CONSSALDO

Local cQuery	:= ""
Private cPerg	:= "CONSSALDO "
_sAlias := Alias()
_sRec   := Recno()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nUsado:=0
aHeader:={}
	AADD(aHeader,{ TRIM(GetSX3Cache("F1_DOC","X3_TITULO")), AllTrim(GetSX3Cache("F1_DOC","X3_CAMPO")), GetSX3Cache("F1_DOC","X3_PICTURE"),GetSX3Cache("F1_DOC","X3_TAMANHO"), GetSX3Cache("F1_DOC","X3_DECIMAL"), GetSX3Cache("F1_DOC","X3_VLDUSER"), GetSX3Cache("F1_DOC","X3_USADO"), GetSX3Cache("F1_DOC","X3_TIPO"), GetSX3Cache("F1_DOC","X3_ARQUIVO"), GetSX3Cache("F1_DOC","X3_CONTEXT") } )
	//aAdd(aHeader,{"Numero"   ,"NF", ,9,0,,cUsad,"C",})
	AADD(aHeader,{ TRIM(GetSX3Cache("F1_SERIE","X3_TITULO")), AllTrim(GetSX3Cache("F1_SERIE","X3_CAMPO")), GetSX3Cache("F1_SERIE","X3_PICTURE"),GetSX3Cache("F1_SERIE","X3_TAMANHO"), GetSX3Cache("F1_SERIE","X3_DECIMAL"), GetSX3Cache("F1_SERIE","X3_VLDUSER"), GetSX3Cache("F1_SERIE","X3_USADO"), GetSX3Cache("F1_SERIE","X3_TIPO"), GetSX3Cache("F1_SERIE","X3_ARQUIVO"), GetSX3Cache("F1_SERIE","X3_CONTEXT") } )
	Posicione("SX3",2,"D1_QUANT","X3_USADO")
	AADD(aHeader,{ TRIM(GetSX3Cache("D1_QUANT","X3_TITULO")), AllTrim(GetSX3Cache("D1_QUANT","X3_CAMPO")), GetSX3Cache("D1_QUANT","X3_PICTURE"),GetSX3Cache("D1_QUANT","X3_TAMANHO"), GetSX3Cache("D1_QUANT","X3_DECIMAL"), GetSX3Cache("D1_QUANT","X3_VLDUSER"), GetSX3Cache("D1_QUANT","X3_USADO"), GetSX3Cache("D1_QUANT","X3_TIPO"), GetSX3Cache("D1_QUANT","X3_ARQUIVO"), GetSX3Cache("D1_QUANT","X3_CONTEXT") } )
	AADD(aHeader,{ TRIM("Saldo"), "SALDO", GetSX3Cache("D1_QUANT","X3_PICTURE"),GetSX3Cache("D1_QUANT","X3_TAMANHO"), GetSX3Cache("D1_QUANT","X3_DECIMAL"), GetSX3Cache("D1_QUANT","X3_VLDUSER"), GetSX3Cache("D1_QUANT","X3_USADO"), GetSX3Cache("D1_QUANT","X3_TIPO"), GetSX3Cache("D1_QUANT","X3_ARQUIVO"), GetSX3Cache("D1_QUANT","X3_CONTEXT") } )
	AADD(aHeader,{ TRIM("Alocado"), "ALOC", GetSX3Cache("D1_QUANT","X3_PICTURE"),GetSX3Cache("D1_QUANT","X3_TAMANHO"), GetSX3Cache("D1_QUANT","X3_DECIMAL"), GetSX3Cache("D1_QUANT","X3_VLDUSER"), GetSX3Cache("D1_QUANT","X3_USADO"), GetSX3Cache("D1_QUANT","X3_TIPO"), GetSX3Cache("D1_QUANT","X3_ARQUIVO"), GetSX3Cache("D1_QUANT","X3_CONTEXT") } )
	//aAdd(aHeader,{"Serie"   ,"SERIE", ,3,0,,cUsad,"C",})
	//aAdd(aHeader,{"Saldo"   ,"SALDO", ,12,2,,cUsad,"N",})
	//AADD(aHeader,{ TRIM(x3_titulo), AllTrim(x3_campo), x3_picture,x3_tamanho, x3_decimal, x3_vlduser, x3_usado, x3_tipo, x3_arquivo, x3_context } )
ValidPerg()	
pergunte(cPerg,.T.)
//aCols:=Array(1,nUsado+1) 
cQuery	+= " SELECT D1_DOC, D1_SERIE, SUM(D1_QUANT) D1_QUANT, SUM(D1_QUANT)-ISNULL(SUM(ZC_QTDALOC),0) D1_XSALDO, ISNULL(SUM(ZC_QTDALOC),0) ALOC"
cQuery	+= "  FROM "+RetSqlName("SD1")+" D1"
cQuery	+= " LEFT JOIN "+RetSqlName("SZC")+" ZC ON D1_DOC+D1_SERIE = ZC_NF+ZC_SERIE AND ZC.D_E_L_E_T_ <> '*'"
cQuery	+= " WHERE D1_FORNECE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery	+= " AND D1_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'AND D1.D_E_L_E_T_ <> '*'"
cQuery	+= " GROUP BY D1_DOC, D1_SERIE"
dbUseArea(.T., "TOPCONN", TCGENQRY( , , cQuery), "TMP", .F., .T.)
DbSelectArea("TMP")

aCols:={}

//While !EOF() .And. cBook==SZC->ZC_BOOKING .And. cContainer == SZC->ZC_CONTAIN
While TMP->(!EOF())
	aAdd(aCols,{TMP->D1_DOC,TMP->D1_SERIE,TMP->D1_QUANT,TMP->D1_XSALDO,TMP->ALOC,.F.})
	//aAdd(aCols,{SD1->D1_DOC,SD1->D1_SERIE,.F.})
	TMP->(dbSkip())
EndDo
//TMP->(DbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Cabecalho do Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cBook:=Space(20)
cLocal  :=Space(2)
cDescr  :=Space(40)
cData	:=Date()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Rodape do Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cObs:=Space(50)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Titulo da Janela                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="Cadastro de Especifica‡”es"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Cabecalho do Modelo 2      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aC:={}
//AADD(aC,{"cProduto" ,{05,03} ,"C¢d. do Produto"   ,"@!"           ,"ExecBlock('Y1VALPRO',.F.,.F.)","SB1",})
/*AADD(aC,{"cBook" ,{15,06} ,"BOOKING"   ,"@!"           ,"!Empty(cBook)",,.F.})
AADD(aC,{"cData"   ,{15,159} ,"Data"         ,"@!"           ,,,.F.})
AADD(aC,{"cContainer" ,{30,06} ,"CONTAINER"   ,"@!"           ,,,.F.})
*/
aR:={}
//AADD(aR,{"cObs" ,{20,03},"Observa‡„o"    ,"@!",,,})

aCGD:={138,144,46,104}
cLinhaOk:="ExecBlock('QTDEALOC',.f.,.f.)"
cTudoOk:="ExecBlock('ZBTUDOK',.f.,.f.)"
n:=1
nOpcx:= 2

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,,,.T.)
TMP->(DbCloseArea())
Return

Static Function ValidPerg()
//PutSx1(cPerg,"01","Contrato      ?","","","mv_ch1","C",15,00,00,"G","","CN9","","","mv_par01","","","","","","","","","","","","","","","","",{"Digite o Numero do Contrato"},{},{},"")

PutSx1(cPerg,"01","Emissao De    ?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{"Digite a data inicial"},{},{},"")
PutSx1(cPerg,"02","Emissao Ate   ?","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{"Digite a data final"},{},{},"")
PutSx1(cPerg,"03","Fornecedor De ?","","","mv_ch3","C",6,0,0,"G","","SA2","","","mv_par03","","","","","","","","","","","","","","","","",{"Digite o Codigo do Fornecedor inicial"},{},{},"")
PutSx1(cPerg,"04","Fornecedor Ate?","","","mv_ch4","C",6,0,0,"G","","SA2","","","mv_par04","","","","","","","","","","","","","","","","",{"Digite o Codigo do Fornecedor  final"},{},{},"")

Return .T.
