/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  ZAALT   ³ Autor ³ Milton Nishimoto      ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de atualizacao de espeficicacoes Modelo 2           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#INCLUDE "protheus.ch"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcao de acesso para o Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
User Function ZAALT(nOpcx)
//nOpcx  := 3
Local nx
cBook	:= SZA->ZA_BOOKING
cData	:= SZA->ZA_DATA
_nItem := 0
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
			"",;
			GetSX3Cache(aCampos[nx],"X3_USADO"),;
			GetSX3Cache(aCampos[nx],"X3_TIPO"),;
			GetSX3Cache(aCampos[nx],"X3_ARQUIVO"),;
			GetSX3Cache(aCampos[nx],"X3_CONTEXT") })
	Endif
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montando aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SZB")
dbSetOrder(1)
cBooking	:= SZA->ZA_BOOKING
dbSeek(xFilial("SZB")+cBooking)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Cabecalho do Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cLocal   := Space(2)
cDescr   := Space(10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do Rodape do Modelo 2                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cObs := Space(20)

dbSelectArea("SZB")
aCols := {}

While !EOF() .And. cBooking==SZB->ZB_BOOKING
    aAdd(aCols,{SZB->ZB_ITEM,SZB->ZB_NF,Posicione("SA2",1,xFilial("SA2")+SZB->ZB_FORNECE,"A2_NOME"),SZB->ZB_QTDENF,SZB->ZB_FALTA,SZB->ZB_AVARIA,SZB->ZB_SOBRA,SZB->ZB_FORNECE,SZB->ZB_SERIE,.F.})
    dbSkip()
EndDo

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

AADD(aC,{"cBook" ,{15,03} ,"BOOKING"   ,"@!"           ,"!Empty(cBook)",,.F.})
AADD(aC,{"cData"   ,{15,153} ,"Data"         ,"@!"           ,,,.F.})
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
nQtdTotalMV	:= 0
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

//aCGD:={08,04,16,74}
aCGD:={88,104,46,104}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validacoes na GetDados da Modelo 2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cLinhaOk:="ExecBlock('ATUTOTALZB',.F.,.F.)"
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

If nOpcx == 4//Alteracao
	If lRetMod2 // 
	    For _l := 1 To Len(aCols)
	        If !(aCols[_l,Len(aHeader)+1])
	            dbSelectArea("SZB")
	            dbSetOrder(1)//ZB_FILIAL+ZB_ITEM+ZB_BOOKING+ZB_NF+ZB_SERIE+ZB_CONTAIN
	            If !dbSeek(xFilial("SZB")+cBook+aCols[_l,_nItem]+aCols[_l,_nNF]+aCols[_l,_nSerie])
	                RecLock("SZB",.T.)
	            Else
	                RecLock("SZB",.F.)
	            Endif
	            SZB->ZB_FILIAL  := xFilial("SZB")
	            SZB->ZB_ITEM    	:= aCols[_l,_nItem]
	            SZB->ZB_NF 	   		:= aCols[_l,_nNF]
	            SZB->ZB_SERIE     	:= aCols[_l,_nSerie]
	            SZB->ZB_BOOKING   	:= cBook
	            SZB->ZB_AVARIA		:= aCols[_l,_nAvaria]
	            SZB->ZB_SOBRA		:= aCols[_l,_nSobra]
	            SZB->ZB_FALTA		:= aCols[_l,_nFalta]
	            SZB->ZB_QTDENF		:= aCols[_l,_nQtde]
	            SZB->ZB_FORNECE		:= aCols[_l,_nForn]
	            MsUnLock()
	        Else
	            dbSelectArea("SZB")
	            dbSetOrder(1)
	            If dbSeek(xFilial("SZB")+cBook+aCols[_l,_nItem]+aCols[_l,_nNF]+aCols[_l,_nSerie])
	                RecLock("SZB",.F.)
	                dbDelete()
	                MsUnLock()
	            Endif
	        EndIf
	    Next _l
	Endif
EndIf	
dbSelectArea(_sAlias)
dbGoto(_sRec)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZAALT     ºAutor  ³Microsiga           º Data ³  02/26/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ATUTOTALZB
Local nTot	:= 0
_nQtde	:= aScan(aHeader,{|x| x[2]=="ZB_QTDENF"})
For i := 1 To Len(aCols)
	nTot	+= aCols[i,_nQtde]
Next
nQtdTotalMV	:= nTot
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

