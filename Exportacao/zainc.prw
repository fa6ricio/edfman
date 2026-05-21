
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Y1INC   ³ Autor ³Walter Caetano da Silva³ Data ³ 30/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de inclusao de especificacoes Modelo 2              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#INCLUDE "protheus.ch"
User Function ZAINC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcao de acesso para o Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza

nOpcx  := 3


_nProp := 0
_nUm   := 0
_nNorm := 0
_nEspe := 0

_sAlias := Alias()
_sRec   := Recno()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aHeader                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nUsado:=0
aHeader:={}
aCampos := RetCampos("SZB",.T.)
For nx := 1 to Len(aCampos)
	If AllTrim(aCampos[nx])=="ZB_FILIAL"
		Loop
	Endif
	If ( X3USO(GetSX3Cache(aCampos[nx],"X3_USADO")) .And. cNivel >= GetSX3Cache(aCampos[nx],"X3_NIVEL")) 
		nUsado:=nUsado+1
		AAdd(aHeader,{ Trim(GetSX3Cache(aCampos[nx],"X3_TITULO")),;
			AllTrim(aCampos[nx]),;
			GetSX3Cache(aCampos[nx],"X3_PICTURE"),;
			GetSX3Cache(aCampos[nx],"X3_TAMANHO"),;
			GetSX3Cache(aCampos[nx],"X3_DECIMAL"),;
			GetSX3Cache(aCampos[nx],"X3_VLDUSER"),;
			GetSX3Cache(aCampos[nx],"X3_USADO"),;
			GetSX3Cache(aCampos[nx],"X3_TIPO"),;
			GetSX3Cache(aCampos[nx],"X3_ARQUIVO"),;
			GetSX3Cache(aCampos[nx],"X3_CONTEXT") })
	Endif
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCols:=Array(1,nUsado+1)    
dbSelectArea("Sx3")
dbSeek("SZB")
nUsado:=0
For nx := 1 to Len(aCampos)
	If AllTrim(aCampos[nx])=="ZB_FILIAL" 
		Loop
	Endif
	If ( X3USO(GetSX3Cache(aCampos[nx],"X3_USADO")) .And. cNivel >= GetSX3Cache(aCampos[nx],"X3_NIVEL")) 
		IF nOpcx == 3
			nUsado:=nUsado+1
			IF GetSX3Cache(aCampos[nx],"X3_TIPO") == "C"
				aCOLS[1][nUsado] := SPACE(GetSX3Cache(aCampos[nx],"X3_TAMANHO"))
			Elseif GetSX3Cache(aCampos[nx],"X3_TIPO") == "N"
				aCOLS[1][nUsado] := 0
			Elseif GetSX3Cache(aCampos[nx],"X3_TIPO") == "D"
				aCOLS[1][nUsado] := dDataBase
			Elseif GetSX3Cache(aCampos[nx],"X3_TIPO") == "M"
				aCOLS[1][nUsado] := ""
			Else
				aCOLS[1][nUsado] := .F.
			Endif
		Endif
	Endif
Next nx

aCOLS[1][nUsado+1] := .F. 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Cabecalho do Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBook:=Space(20)
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
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

//AADD(aC,{"cProduto" ,{05,03} ,"C¢d. do Produto"   ,"@!"           ,"ExecBlock('Y1VALPRO',.F.,.F.)","SB1",})
AADD(aC,{"cBook" ,{15,03} ,"BOOKING"   ,"@!"           ,"!Empty(cBook)",,})
AADD(aC,{"cData"   ,{15,153} ,"Data"         ,"@!"           ,,,})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com descricao dos campos do Rodape do Modelo 2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.
nQtdTotalMV	:= Space(10)
//ATUALIZA A QUANTIDADE TOTAL DAS NOTAS FISCAIS JA INCLUIDAS
_AreaZB	:= GetArea()
cQuery	:= " SELECT SUM(ZB_QTDENF) TOTAL FROM "+RetSqlName("SZB")+" WHERE ZB_BOOKING = '"+cBook+"' AND D_E_L_E_T_ <> '*'"

dbUseArea(.T., "TOPCONN", TCGENQRY( , , cQuery), "TMP", .F., .T.)
DbSelectArea("TMP")
If !Empty(TMP->TOTAL)
	nQtdTotalMV	:= TMP->TOTAL
EndIf
dbSelectArea("TMP")
TMP->(DBCloseArea())
RestArea(_AreaZB)
AADD(aR,{"nQtdTotalMV" ,{50,10},"Total"    ,"@!",,,})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com coordenadas da GetDados no modelo2                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCGD:={138,144,46,104}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados da Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLinhaOk:="ExecBlock('ZBLINOK',.f.,.f.)"
cTudoOk:="ExecBlock('ZBTUDOK',.f.,.f.)"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Modelo2                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// lRetMod2 = .t. se confirmou 
// lRetMod2 = .f. se cancelou

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,,,.T.)

_nItem 	:= aScan(aHeader,{|x| x[2]=="ZB_ITEM"})
_nNF 	:= aScan(aHeader,{|x| x[2]=="ZB_NF"})
_nSerie := aScan(aHeader,{|x| x[2]=="ZB_SERIE"})
_nBook 	:= aScan(aHeader,{|x| x[2]=="ZB_BOOKING"})
_nQtde	:= aScan(aHeader,{|x| x[2]=="ZB_QTDENF"})
_nAvaria:= aScan(aHeader,{|x| x[2]=="ZB_AVARIA"})
_nSobra	:= aScan(aHeader,{|x| x[2]=="ZB_SOBRA"})
_nFalta	:= aScan(aHeader,{|x| x[2]=="ZB_FALTA"})
_nForn	:= aScan(aHeader,{|x| x[2]=="ZB_FORNECE"})

If lRetMod2 // Gravacao. . .
    For _l := 1 To Len(aCols)
        If !aCols[_l,Len(aHeader)+1]
            dbSelectArea("SZB")
            RecLock("SZB",.T.)
            SZB->ZB_FILIAL  := xFilial("SZB")
            //SY1->ZB_CODIGO  := cProduto
            SZB->ZB_ITEM    	:= aCols[_l,_nItem]
            SZB->ZB_NF 	   		:= aCols[_l,_nNF]
            SZB->ZB_SERIE     	:= aCols[_l,_nSerie]
            SZB->ZB_BOOKING   	:= cBook
            SZB->ZB_SOBRA		:= aCols[_l,_nSobra]
            SZB->ZB_FALTA		:= aCols[_l,_nFalta]
            SZB->ZB_QTDENF		:= aCols[_l,_nQtde]
            SZB->ZB_FORNECE		:= aCols[_l,_nForn]
            MsUnLock()
        EndIf
    Next _l 
    DbSelectArea("SZA")
    RecLock("SZA",.T.)
    SZA->ZA_FILIAL 		:= xFilial("SZA")
    SZA->ZA_BOOKING		:= cBook
    SZA->ZA_DATA		:= cData
    MsUnlock()
Endif

dbSelectArea(_sAlias)
dbGoto(_sRec)

Return

User Function ZBLINOK
Return .T.

User Function ZBTUDOK
Return .T.


Static Function RetCampos(cArq, lVirtual)		
Local aCampos := {}
Local aCmpRet := {}
Local cUsado := ""
Local nx := 1

DEFAULT lVirtual := .F.

aCampos := FWSX3Util():GetAllFields(cArq,lVirtual)
	
For nx := 1 to Len (aCampos)
	IF !("USERLG" $ aCampos[nx]) 
		cUsado   := X3OBRIGAT(aCampos[nx])
		// Verifica se o campo é usado
		If !Empty(cUsado)
			AADD(aCmpRet,{aCampos[nx],FWSX3Util():GetDescription( aCampos[nx] )})
		EndIf
	Endif
Next nx
Return aCmpRet	
