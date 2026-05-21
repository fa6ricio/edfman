#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ COM009   ³ Autor ³ Marcelo Franca        ³ Data ³ 09/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO PEDIDO DE COMPRA - INICIO DO PROCESSO         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function COM009()

cperg:="COM009"+space(04)

fCriaPerg()

Pergunte(cperg,.T.)

Processa({|lEnd|MontaRel()})

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO PEDIDO DE COMPRA - CONFIGURACAO               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nX := 0

oPrint:= TMSPrinter():New( "Pedido de Compras" )
oPrint:SetLandscape() // SetLandscape() ou SetPortrait()
oPrint:StartPage()   // Inicia uma nova página
ProcRegua(RecCount())


Impress(oPrint,{},{},{},{},{},{})
nX := nX + 1
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO PEDIDO DE COMPRA - SELECIONANDO PEDIDO        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)


Local nReem
Local nOrder
Local cCondBus
Local nSavRec
Local aPedido := {}
Local aPedMail:= {}
Local aSavRec := {}
Local nLinObs := 0
Local cFiltro := ""

_npula:=0
_npag:=1


ncw     := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
//                        1      2 3  4    5  6  7   8  9   0
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10n := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
nDescProd:= 0
nTotal   := 0
nTotMerc := 0
NumPed   := Space(6)

If ( cPaisLoc$"ARG|POR|EUA" )
	cCondBus	:=	"1"+strzero(val(mv_par01),6)
	nOrder	:=	10
	nTipo		:= 1
Else
	cCondBus	:=mv_par01
	nOrder	:=	1
EndIf

If mv_par12 == 2
	cFiltro := "SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)"
Elseif mv_par12 == 3
	cFiltro := "SC7->C7_QUANT > SC7->C7_QUJE"
EndIf
dbSelectArea("SC7")
dbSetOrder(nOrder)

dbSeek(xFilial("SC7")+cCondBus,.T.)
_numped:=sc7->c7_num
While !Eof() .And. SC7->C7_FILIAL = xFilial("SC7") .And. SC7->C7_NUM = mv_par01 
      
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	
	If	SC7->C7_EMITIDO == "S" .And. mv_par04 == 1
		dbSkip()
		Loop
	Endif
      
   	If	(SC7->C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
		(SC7->C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSkip()
		Loop
	Endif

	If	(SC7->C7_EMISSAO < mv_par02) .Or. (SC7->C7_EMISSAO > mv_par03)
		dbSkip()
		Loop
	Endif
	If	SC7->C7_TIPO == 2
		dbSkip()
		Loop
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. EM ABERTO                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par12 == 2
		If SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. ATENDIDOS                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	If mv_par12 == 3
		If SC7->C7_QUANT > SC7->C7_QUJE
			dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !MtrAValOP(mv_par09, 'SC7')
		dbSkip()
		Loop
	EndIf

	MaFisEnd()
	MaFisIniPC(SC7->C7_NUM,,,cFiltro)

	For ncw := 1 To mv_par07		// Imprime o numero de vias informadas
		ImpCabec(ncw)
		nTotal   := 0
		nTotMerc	:= 0
		nDescProd:= 0
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM
		nLinObs  := 0
		aPedido  := {SC7->C7_FILIAL,SC7->C7_NUM,SC7->C7_EMISSAO,SC7->C7_FORNECE,SC7->C7_LOJA,SC7->C7_TIPO}
        nRow1 := 120
        _nlinpdr:=1
		While !Eof() .And. SC7->C7_FILIAL = xFilial("SC7") .And. SC7->C7_NUM == NumPed

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste este item. EM ABERTO                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par12 == 2
				If SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)
					dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste este item. ATENDIDOS                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par12 == 3
				If SC7->C7_QUANT > SC7->C7_QUJE
					dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif
			Endif


    	    if _nlinpdr >= 51
		       oPrint:EndPage() // Finaliza a página
		       impcabec(ncw)
               _npula:=0
               _nlinpdr:=1
		    endif


			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif

		
		    oPrint:Say  (nRow1+0460+_npula,0060,STRZERO(VAL(SC7->C7_ITEM),4),oFont8)
		    oPrint:Say  (nRow1+0460+_npula,0160,ALLTRIM(SC7->C7_PRODUTO),oFont8)
		    
            ImpProd()
            _nlinpdr:= _nlinpdr+1

			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao do Pedido.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !EMPTY(SC7->C7_OBS) .And. nLinObs < 5
				nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
			dbSkip()
		EndDo
		dbGoto(nSavRec)
   	    if _nlinpdr >= 26
	       oPrint:EndPage() // Finaliza a página
           impcabec(ncw)
           _npula:=0
           _nlinpdr:=1
        endif
		FinalPed(nDescProd)		// Imprime os dados complementares do PC
	Next
	MaFisEnd()
	If Len(aSavRec)>0
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			Replace C7_EMITIDO With "S"
			MsUnLock()
		Next
		dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	Endif

	Aadd(aPedMail,aPedido)

	aSavRec := {}

	dbSkip()
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa o ponto de entrada M110MAIL quando a impressao for   ³
//³ enviada por email, fornecendo um Array para o usuario conten ³
//³ do os pedidos enviados para possivel manipulacao.            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("M110MAIL")
	lEnvMail := HasEmail(,,,,.F.)
	If lEnvMail
		Execblock("M110MAIL",.F.,.F.,{aPedMail})
	EndIf
EndIf

dbSelectArea("SC7")
dbClearFilter()
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//oPrint:EndPage() // Finaliza a página

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec(ncw)
Local nOrden, cCGC
LOCAL cMoeda

cMoeda := Iif(mv_par10<10,Str(mv_par10,1),Str(mv_par10,2))
cLogo      := "\workflow\Logo\Logo_small.bmp"

oPrint:StartPage()   // Inicia uma nova página

nRow1 := 0
//               linha,coluna,impressao,linha,coluna
oPrint:SayBitmap(nRow1+0070,040,cLogo,254,212)//logo da empresa
 
//Montando caixa superior esquerdo
oPrint:Line (nRow1+0050,050,nRow1+0050,1300)//= _________
oPrint:Line (nRow1+0050,050,nRow1+0370, 050)//= |
oPrint:Line (nRow1+0050,1300,nRow1+0370,1300)//= |
oPrint:Line (nRow1+0370,050,nRow1+0370,1300)//= _________

//Informações da empresa dentro da caixa superior esquerda
oPrint:Say  (nRow1+0070,300,alltrim(SM0->M0_NOMECOM),oFont10 )
oPrint:Say  (nRow1+0120,300,"Endereço: ",oFont10n )
oPrint:Say  (nRow1+0120,480,alltrim(SM0->M0_ENDENT),oFont10 )

oPrint:Say  (nRow1+0170,300,"CEP: ",oFont10n )
oPrint:Say  (nRow1+0170,390,SUBSTR(SM0->M0_CEPENT,1,5)+"-"+SUBSTR(SM0->M0_CEPENT,6,3),oFont10 )
oPrint:Say  (nRow1+0170,580,"Cidade: ",oFont10n )
oPrint:Say  (nRow1+0170,730,AllTrim(SM0->M0_CIDENT),oFont10 )
oPrint:Say  (nRow1+0170,1180,"UF: ",oFont10n )
oPrint:Say  (nRow1+0170,1240,AllTrim(SM0->M0_ESTENT),oFont10 )

oPrint:Say  (nRow1+0220,300,"Tel: ",oFont10n )
oPrint:Say  (nRow1+0220,390,alltrim(SM0->M0_TEL),oFont10 )
oPrint:Say  (nRow1+0220,660,"Fax: ",oFont10n )
oPrint:Say  (nRow1+0220,760,alltrim(SM0->M0_FAX),oFont10 )

oPrint:Say  (nRow1+0277,070,"CNPJ/CPF: ",oFont10n )
oPrint:Say  (nRow1+0270,280,substr(SM0->M0_CGC,1,2)+"."+substr(SM0->M0_CGC,3,3)+"."+substr(SM0->M0_CGC,6,3)+"/"+substr(SM0->M0_CGC,9,4)+"-"+substr(SM0->M0_CGC,13,2),oFont14  )
oPrint:Say  (nRow1+0277,750,"I.E.: ",oFont10n )
oPrint:Say  (nRow1+0270,850,substr(InscrEst(),1,3)+"."+substr(InscrEst(),4,3)+"."+substr(InscrEst(),7,3)+"."+substr(InscrEst(),10,3),oFont14 )


//Montando caixa superior direito
oPrint:Line (nRow1+0050,1330,nRow1+0050,3090)//= _________
oPrint:Line (nRow1+0050,1330,nRow1+0370,1330)//= |
oPrint:Line (nRow1+0050,3090,nRow1+0370,3090)//= |
oPrint:Line (nRow1+0370,1330,nRow1+0370,3090)//= _________

//Informações da empresa dentro da caixa superior esquerda

oPrint:Say  (nRow1+0070,1350,"INSTRUÇÃO DE FATURAMENTO No "+SC7->C7_NUM,oFont16n )
//oPrint:Say  (nRow1+0070,2450,IIf(SC7->C7_QTDREEM>0,Str(SC7->C7_QTDREEM+1,2)+"a.Emissão "+Str(ncw,2)+"a.VIA"," "),oFont10 )
//oPrint:Say  (nRow1+0070,2450,IIf(SC7->C7_QTDREEM>0,Str(SC7->C7_QTDREEM+1,2)+"a.Emissão "+Str(ncw,2)+"a.VIA"," "),oFont10 )
//oPrint:Say  (nRow1+0070,2850,substr(GetMV("MV_MOEDA"+cMoeda),1,5),oFont10)

dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
oPrint:Say  (nRow1+0170,1350,"Razão Social: ",oFont10n )
oPrint:Say  (nRow1+0170,1600,alltrim(SA2->A2_NOME),oFont10 )

oPrint:Say  (nRow1+0170,2600,"Código: ",oFont10n )
oPrint:Say  (nRow1+0170,2750,SA2->A2_COD,oFont10 )
oPrint:Say  (nRow1+0170,2890,"Loja : ",oFont10n )
oPrint:Say  (nRow1+0170,3000,SA2->A2_LOJA,oFont10 )

oPrint:Say  (nRow1+0220,1350,"Endereço: ",oFont10n )
oPrint:Say  (nRow1+0220,1550,ALLTRIM(SA2->A2_END),oFont10 )

oPrint:Say  (nRow1+0220,2450,"Bairro: ",oFont10n )
oPrint:Say  (nRow1+0220,2600,SA2->A2_BAIRRO,oFont10 )

oPrint:Say  (nRow1+0270,1350,"Município: ",oFont10n )
oPrint:Say  (nRow1+0270,1550,ALLTRIM(SA2->A2_MUN),oFont10 )
oPrint:Say  (nRow1+0270,1900,"Estado: ",oFont10n )
oPrint:Say  (nRow1+0270,2050,SA2->A2_EST,oFont10 )
oPrint:Say  (nRow1+0270,2130,"CEP: ",oFont10n )
oPrint:Say  (nRow1+0270,2260,substr(SA2->A2_CEP,1,5)+"-"+substr(SA2->A2_CEP,6,3),oFont10 )
oPrint:Say  (nRow1+0270,2450,"CNPJ/CPF: ",oFont10n )
oPrint:Say  (nRow1+0270,2650,SA2->A2_CGC,oFont10 )

oPrint:Say  (nRow1+0320,1350,"Fone: ",oFont10n )
oPrint:Say  (nRow1+0320,1460,"("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15),oFont10 )
oPrint:Say  (nRow1+0320,1900,"Fax:",oFont10n )
oPrint:Say  (nRow1+0320,2010,"("+Substr(SA2->A2_DDD,1,3)+") "+SubStr(SA2->A2_FAX,1,15),oFont10 )
oPrint:Say  (nRow1+0320,2450,"Ins. Estad.: ",oFont10n )
IF SA2->A2_INSCR <>  "ISENTO"
   _ins:=strtran(SA2->A2_INSCR,'.','')
   oPrint:Say  (nRow1+0320,2650,substr(_ins,1,3)+"."+substr(_ins,4,3)+"."+substr(_ins,7,3)+"."+substr(_ins,10,3),oFont10 )
ELSE
   oPrint:Say  (nRow1+0320,2650,SA2->A2_INSCR,oFont10 )
ENDIF
//cabecalho
oPrint:Line (nRow1+0380,0050,nRow1+2310,0050)//= |
oPrint:Line (nRow1+0380,3090,nRow1+2310,3090)//= |
oPrint:Line (nRow1+0380,0050,nRow1+0380,3090)//= _________
oPrint:Say  (nRow1+0400,0070,"IMPORTANTE: O número do nosso pedido de compra deverá constar na sua nota fiscal para que a mercadoria seja aceita. Contrato Nº "+SC7->C7_CONTRAT,oFont14n)

nRow1 := 120

oPrint:Say  (nRow1+0400,0060,"Item",oFont10)
oPrint:Say  (nRow1+0400,0160,"Produto",oFont10)
oPrint:Say  (nRow1+0400,0390,"Descrição",oFont10)
oPrint:Say  (nRow1+0400,1140,"Part Number",oFont10)
oPrint:Say  (nRow1+0400,1670,"UM",oFont10)
oPrint:Say  (nRow1+0400,1780,"Quantidade",oFont10)
oPrint:Say  (nRow1+0400,1990,"Valor Unitário",oFont10)
oPrint:Say  (nRow1+0400,2220,"IPI (%)",oFont10)
oPrint:Say  (nRow1+0400,2410,"Valor Total",oFont10)
oPrint:Say  (nRow1+0400,2590,"Dt. Entrega",oFont10)
oPrint:Say  (nRow1+0400,2790,"Centro de Custo",oFont10)

oPrint:Line (nRow1+0380,0050,nRow1+0380,3090)//= _________ legenda dos itens
oPrint:Line (nRow1+0450,0050,nRow1+0450,3090)//= _________ legenda dos itens
oPrint:Line (nRow1+0380,0150,nRow1+1200,0150)//= | caixa do item
oPrint:Line (nRow1+0380,0380,nRow1+1200,0380)//= | caixa do Produto
oPrint:Line (nRow1+0380,1130,nRow1+1200,1130)//= | descricao
oPrint:Line (nRow1+0380,1660,nRow1+1200,1660)//= | caixa da part number
oPrint:Line (nRow1+0380,1740,nRow1+1200,1740)//= | caixa da UM
oPrint:Line (nRow1+0380,1970,nRow1+1200,1970)//= | caixa da Quantidade
oPrint:Line (nRow1+0380,2210,nRow1+1200,2210)//= | caixa do Valor Unitário
oPrint:Line (nRow1+0380,2360,nRow1+1200,2360)//= | caixa do Aliq IPI
oPrint:Line (nRow1+0380,2580,nRow1+1200,2580)//= | caixa do Valor Total
oPrint:Line (nRow1+0380,2780,nRow1+1200,2780)//= | caixa da Dt.Entrega

dbSelectArea("SC7")
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir  dados Cadastrais do Produto.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpProd()
LOCAL nBegin := 0, cDescri := "", nLinha:=0
Local	nTamDesc := 50

If Empty(mv_par05)
	mv_par05 := "B1_DESC"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par05) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial("SB1")+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par05) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial("SB5")+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par05) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

If Empty(cDescri)
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek( xFilial("SB1")+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf

dbSelectArea("SA5")
dbSetOrder(1)
If dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO).And. !Empty(SA5->A5_CODPRF)
	cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
EndIf
dbSelectArea("SC7")

nLinha:= MLCount(cDescri,nTamDesc)

oPrint:Say  (nRow1+0460+_npula,0390,MemoLine(cDescri,nTamDesc,1),oFont8)



dbSelectArea("SB1")
dbSetOrder(1)
dbSeek( xFilial("SB1")+SC7->C7_PRODUTO )
cPartnu := " " //Alltrim(SB1->B1_PARTNUM)
dbSelectArea("SC7")

oPrint:Say  (nRow1+0460+_npula,1140,cPartnu,oFont8)

ImpCampos()
_npula:=_npula+30
Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCampos³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir dados Complementares do Produto no Pedido.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCampos(Void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCampos()

Local nTxMoeda := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
dbSelectArea("SC7")
nRow1 := 120

if _nlinpdr = 25
   oPrint:Line (nRow1+1200,0150,nRow1+2070,0150)//= | caixa do item
   oPrint:Line (nRow1+1200,0380,nRow1+2070,0380)//= | caixa do Produto
   oPrint:Line (nRow1+1200,1130,nRow1+2070,1130)//= | descricao
   oPrint:Line (nRow1+1200,1660,nRow1+2070,1660)//= | caixa da part number
   oPrint:Line (nRow1+1200,1740,nRow1+2070,1740)//= | caixa da UM
   oPrint:Line (nRow1+1200,1970,nRow1+2070,1970)//= | caixa da Quantidade
   oPrint:Line (nRow1+1200,2210,nRow1+2070,2210)//= | caixa do Valor Unitário
   oPrint:Line (nRow1+1200,2360,nRow1+2070,2360)//= | caixa do Aliq IPI
   oPrint:Line (nRow1+1200,2580,nRow1+2070,2580)//= | caixa do Valor Total
   oPrint:Line (nRow1+1200,2780,nRow1+2070,2780)//= | caixa da Dt.Entrega
   oPrint:Line (nRow1+2070,0050,nRow1+2070,3090)//= _________ final
   oPrint:Say  (nRow1+2090,0450,"CONTINUA",oFont16n )
   oPrint:Say  (nRow1+2090,2720,"Página "+alltrim(str(_npag)),oFont16n ) 
   oPrint:Line (nRow1+2190,0050,nRow1+2190,3090)//= _________ final
   _npag:=_npag+1
endif

If MV_PAR06 == 2 .And. !Empty(SC7->C7_SEGUM)
   oPrint:Say  (nRow1+0460+_npula,1670,SC7->C7_SEGUM,oFont8)		
Else
   oPrint:Say  (nRow1+0460+_npula,1670,SC7->C7_UM,oFont8)	
EndIf
If MV_PAR06 == 2 .And. !Empty(SC7->C7_QTSEGUM)
   oPrint:Say  (nRow1+0460+_npula,1960,TRANSFORM(SC7->C7_QTSEGUM,"@E 9,999,999.9"),oFont8,,,,1)
Else
   oPrint:Say  (nRow1+0460+_npula,1960,TRANSFORM(SC7->C7_QUANT,"@E 9,999,999,999.9"),oFont8,,,,1)
EndIf
If MV_PAR06 == 2 .And. !Empty(SC7->C7_QTSEGUM)
   oPrint:Say  (nRow1+0460+_npula,2200,TRANSFORM(xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@E 99,999,999.999999"),oFont8,,,,1)
Else
   oPrint:Say  (nRow1+0460+_npula,2200,TRANSFORM(xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@E 999,999.999999"),oFont8,,,,1)
EndIf

If cPaisLoc == "BRA"
   oPrint:Say  (nRow1+0460+_npula,2320,TRANSFORM(SC7->C7_IPI,"@E 99.99"),oFont8,,,,1)
EndIf
oPrint:Say  (nRow1+0460+_npula,2570,TRANSFORM(xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@E 999,999,999.99"),oFont8,,,,1)
oPrint:Say  (nRow1+0460+_npula,2620,dtoc(SC7->C7_DATPRF),oFont8)
oPrint:Say  (nRow1+0460+_npula,2790,SC7->C7_CC,oFont8)   


nTotal  :=nTotal+SC7->C7_TOTAL
nTotMerc:=MaFisRet(,"NF_TOTAL")
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalPed(nDescProd)

Local nk		:= 1,nG
Local nX		:= 0
Local nQuebra	:= 0
Local nTotDesc	:= nDescProd
Local lNewAlc	:= .F.
Local lLiber 	:= .F.
Local lImpLeg	:= .T.
Local lImpLeg2	:= .F.
Local cComprador:=""
LOcal cAlter	:=""
Local cAprov	:=""
Local nTotIpi	:= MaFisRet(,'NF_VALIPI')
Local nTotIcms	:= MaFisRet(,'NF_VALICM')
Local nTotDesp	:= MaFisRet(,'NF_DESPESA')
Local nTotFrete	:= MaFisRet(,'NF_FRETE')
Local nTotalNF	:= MaFisRet(,'NF_TOTAL')
Local nTotSeguro:= MaFisRet(,'NF_SEGURO')
Local aValIVA   := MaFisRet(,"NF_VALIMP")
Local nValIVA   :=0
Local aColuna   := Array(8), nTotLinhas
Local nTxMoeda  := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)


oPrint:Say  (nRow1+2090,2720,"Página "+alltrim(str(_npag)),oFont16n ) 

If cPaisLoc <> "BRA" .And. !Empty(aValIVA)
	For nG:=1 to Len(aValIVA)
		nValIVA+=aValIVA[nG]
	Next
Endif

cMensagem:= Formula(SC7->C7_MSG)

oPrint:Line (nRow1+1200,0050,nRow1+1200,3090)//= _________ caixa de descontos
oPrint:Line (nRow1+1290,0050,nRow1+1290,3090)//= _________ caixa de descontos
oPrint:Line (nRow1+1420,0050,nRow1+1420,3090)//= _________ local de cobranca
oPrint:Say  (nRow1+1220,0070,"D E S C O N T O S -->    "+transform(SC7->C7_DESC1,"999.99%")+"       "+transform(SC7->C7_DESC2,"999.99%")+"       "+transform(SC7->C7_DESC3,"999.99%")+"       "+TRANSFORM(xMoeda(nTotDesc,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@E 999,999,999.99"),oFont10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o Arquivo de Empresa SM0.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime endereco de entrega do SM0 somente se o MV_PAR11 =" "³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Empty(MV_PAR11)
   oPrint:Say  (nRow1+1310,0070,"Local de Entrega    : "+alltrim(SM0->M0_ENDENT)+ "   "+alltrim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT+" - CEP: "+Alltrim(SM0->M0_CEPENT),oFont10)
Else
   oPrint:Say  (nRow1+1310,0070,"Local de Entrega    : "+MV_PAR11,oFont10)
Endif
dbGoto(nRegistro)
dbSelectArea( cAlias )

oPrint:Say  (nRow1+1360,0070,"Local de Cobranca : "+alltrim(SM0->M0_ENDCOB)+"   "+alltrim(SM0->M0_CIDCOB)+" - "+SM0->M0_ESTCOB+" - CEP: "+ Alltrim(SM0->M0_CEPCOB),oFont10)
dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+SC7->C7_COND)
dbSelectArea("SC7")
oPrint:Say  (nRow1+1440,0070,"Condição de Pagto: "+SubStr(SE4->E4_COND,1,40),oFont10)
oPrint:Say  (nRow1+1440,1650,"Data de Emissão",oFont10)
oPrint:Say  (nRow1+1440,2260,"Total das Mercadorias: ",oFont10)
oPrint:Say  (nRow1+1440,3050,transform(xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@e 999,999,999.99"),oFont10,,,,1)
oPrint:Say  (nRow1+1480,0070,SubStr(SE4->E4_DESCRI,1,34),oFont10)
oPrint:Say  (nRow1+1480,1650,dtoc(SC7->C7_EMISSAO),oFont10)
oPrint:Line (nRow1+1540,0050,nRow1+1540,3090)//= _________ condicao de pagto
oPrint:Line (nRow1+1420,1630,nRow1+1890,1630)//= | Data de emissao
oPrint:Line (nRow1+1420,2240,nRow1+1890,2240)//= | Data de emissao
oPrint:Line (nRow1+1710,1630,nRow1+1710,3090)//= _________ seguro                    
oPrint:Line (nRow1+1800,2240,nRow1+1800,3090)//= _________ obs do frete              



If cPaisLoc<>"BRA"
   oPrint:Say  (nRow1+1480,2260,"Total de los Impuestos: ",oFont10)
   oPrint:Say  (nRow1+1480,3050,transform(xMoeda(nValIVA,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@e 999,999,999.99"),oFont10,,,,1)
Else
   oPrint:Say  (nRow1+1480,2260,"Total com Impostos: ",oFont10)
   oPrint:Say  (nRow1+1480,3050,transform(xMoeda(nTotMerc,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@e 999,999,999.99"),oFont10,,,,1)
Endif

dbSelectArea("SC7")

If cPaisLoc == "BRA"
    oPrint:Say  (nRow1+1570,1650,"IPI      :",oFont10)
    oPrint:Say  (nRow1+1570,2000,transform(xMoeda(nTotIPI,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@e 999,999,999.99"),oFont10,,,,1)
    oPrint:Say  (nRow1+1570,2260,"ICMS          :",oFont10)
    oPrint:Say  (nRow1+1570,3050,transform(xMoeda(nTotIcms,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@e 999,999,999.99"),oFont10,,,,1)
EndIf
oPrint:Say  (nRow1+1610,1650,"Frete  :",oFont10)
oPrint:Say  (nRow1+1610,2000,transform(xMoeda(nTotFrete,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@e 999,999,999.99"),oFont10,,,,1)
oPrint:Say  (nRow1+1610,2260,"Despesas  :",oFont10)
oPrint:Say  (nRow1+1610,3050,transform(xMoeda(nTotDesp,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@e 999,999,999.99"),oFont10,,,,1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializar campos de Observacoes.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cObs02)
	If Len(cObs01) > 70
		cObs := cObs01
		cObs01 := Substr(cObs,1,70)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(70*(nX-1))+1,70)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

dbSelectArea("SC7")
If !Empty(SC7->C7_APROV)
	lNewAlc := .T.
	cComprador := UsrFullName(SC7->C7_USER)
	If SC7->C7_CONAPRO != "B"
		lLiber := .T.
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+SC7->C7_NUM .And. SCR->CR_TIPO == "PC"
		cAprov += AllTrim(RetFullName(SCR->CR_USER))+" ["
        Do Case
        	Case SCR->CR_STATUS=="03" //Liberado
        		cAprov += "Ok"
        	Case SCR->CR_STATUS=="04" //Bloqueado
        		cAprov += "BLQ"
			Case SCR->CR_STATUS=="05" //Nivel Liberado
				cAprov += "##"
			OtherWise                 //Aguar.Lib
				cAprov += "??"
		EndCase
		cAprov += "] - "
		dbSelectArea("SCR")
		dbSkip()
	Enddo
	If !Empty(SC7->C7_GRUPCOM)
		dbSelectArea("SAJ")
		dbSetOrder(1)
		dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
		While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
			If SAJ->AJ_USER != SC7->C7_USER
				cAlter += AllTrim(RetFullName(SAJ->AJ_USER))+"/"
			EndIf
			dbSelectArea("SAJ")
			dbSkip()
		EndDo
	EndIf
EndIf
oPrint:Say  (nRow1+1650,2260,"SEGURO   :",oFont10)
oPrint:Say  (nRow1+1650,3050,TRANSFORM(xMoeda(nTotSeguro,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@E 999,999,999.99"),oFont10,,,,1)
oPrint:Say  (nRow1+1570,0070,"Observações:",oFont10)
oPrint:Say  (nRow1+1610,0070,cObs01,oFont10)
oPrint:Say  (nRow1+1650,0070,cObs02,oFont10)
oPrint:Say  (nRow1+1690,0070,cObs03,oFont10)
oPrint:Say  (nRow1+1730,0070,cObs04,oFont10)
oPrint:Line (nRow1+1890,0050,nRow1+1890,3090)//= _________ observacoes

If !lNewAlc
   oPrint:Say  (nRow1+1740,2260,"Total Geral :",oFont10)
   oPrint:Say  (nRow1+1740,3050,transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@e 999,999,999.99"),oFont10,,,,1)
Else
	If lLiber
       oPrint:Say  (nRow1+1740,2260,"Total Geral :",oFont10)
       oPrint:Say  (nRow1+1740,3050,transform(xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR10,SC7->C7_DATPRF,,nTxMoeda),"@e 999,999,999.99"),oFont10,,,,1)
	Else
       oPrint:Say  (nRow1+1740,2260,"Total Geral :",oFont10)
       oPrint:Say  (nRow1+1740,2510,"PEDIDO BLOQUEADO",oFont10)
	EndIf
EndIf

oPrint:Line (nRow1+2100,0050,nRow1+2100,1630)//= _________ legenda
oPrint:Line (nRow1+2100,1630,nRow1+2190,1630)//= | legenda
oPrint:Line (nRow1+2190,0050,nRow1+2190,3090)//= _________ final

_APRDESC:="Aprovador(es): "
If !lNewAlc
   oPrint:Say  (nRow1+1830,2260,"Obs. do Frete:  "+IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " )),oFont10)
   cLiberador := ""
   nPosicao := 0
   oPrint:Say  (nRow1+1920,0070,"Comprador Responsável : "+ cLiberador,oFont10)
Else
   oPrint:Say  (nRow1+1780,1650,IF(lLiber,"P E D I D O  L I B E R A D O","P E D I D O  B L O Q U E A D O"),oFont10)
   oPrint:Say  (nRow1+1830,2260,"Obs. do Frete:  "+IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " )),oFont10)
   oPrint:Say  (nRow1+1920,0070,"Comprador Responsável : "+ Substr(cComprador,1,60),oFont10)
   oPrint:Say  (nRow1+2130,0070,"Legendas da Aprovação : BLQ:Bloqueado    |  OK: Liberado | ??: Aguar.Lib  |  ##:Nível Lib",oFont10)
   nAuxLin := Len(cAlter)
   While nAuxLin > 0 .Or. lImpLeg
         oPrint:Say  (nRow1+1980,0070,"Comprador Alternativos : "+Substr(cAlter,Len(cAlter)-nAuxLin+1,200),oFont10)
         If lImpLeg
  			lImpLeg := .F.
		 EndIf
		nAuxLin -= 200
   EndDo
   nAuxLin := Len(cAprov)
   lImpLeg := .T.
   While nAuxLin > 0	.Or. lImpLeg
		If lImpLeg  // Imprimir soh a 1a vez
           _APRDESC:="Aprovador(es): "
		EndIf
        _APRDESC:=_APRDESC+" "+Substr(cAprov,Len(cAprov)-nAuxLin+1,200)
		If lImpLeg2  // Imprimir soh a 2a vez
		   _APRDESC:=_APRDESC+"[##]"
		   lImpLeg2 := .F.
		EndIf
		If lImpLeg   // Imprimir soh a 1a vez
		   _APRDESC:=_APRDESC+"[??]"
  		   lImpLeg  := .F.
		   lImpLeg2 := .T.
		EndIf
		nAuxLin -=200
	EndDo
	If lImpLeg2
		lImpLeg2 := .F.
	   _APRDESC:=_APRDESC+"[##]"
	EndIf
EndIf
oPrint:Say  (nRow1+2040,0070,_APRDESC,oFont10)

oPrint:EndPage()
Return .T.                                 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fCriaPerg³ Autor ³ Marcelo Franca        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria as perguntas caso nao exista                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                    4 5      6     7  8  9  10 11  12 13         14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39c 40 41 42 43
AADD(aRegistros,{cperg,"01","Pedido de Compra    ","","","mv_ch1","C",06,00,00,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cperg,"02","A Partir da Data    ","","","mv_ch2","D",08,00,00,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cperg,"03","Até a Data          ","","","mv_ch3","D",08,00,00,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cperg,"04","Somente os Novos    ","","","mv_ch4","N",01,00,00,"C","","mv_par04","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cperg,"05","Descrição Produto  ?","","","mv_ch5","C",10,00,00,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cperg,"06","Qual Unid.de Med.  ?","","","mv_ch6","N",01,00,00,"C","","mv_par06","Primária","","","","","Secundária","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cperg,"07","Número de Vias ?    ","","","mv_ch7","N",02,00,00,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cperg,"08","Imprime Pedidos ?   ","","","mv_ch8","N",01,00,00,"C","","mv_par08","Liberados","","","","","Bloqueados","","","","","Ambos","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cperg,"09","Considera SCs s ?   ","","","mv_ch9","N",01,00,00,"C","","mv_par09","Firmes","","","","","Previstas","","","","","Ambas","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cperg,"10","Qual Moeda ?        ","","","mv_chA","N",01,00,00,"C","","mv_par10","Moeda 1","","","","","Moeda 2","","","","","Moeda 3","","","","","Moeda 4","","","","","Moeda 5","","","","","","","","",""})
AADD(aRegistros,{cperg,"11","Endereço de Entrega?","","","mv_chB","C",40,00,00,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegistros,{cperg,"12","Lista Quais ?       ","","","mv_chC","N",01,00,00,"C","","mv_par12","Todos","","","","","Em Aberto","","","","","Atendidos","","","","","","","","","","","","","","","","","","",""})
                           
DbSelectArea("SX1")
DbSetOrder(1)
For i := 1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		While !RecLock("SX1",.T.)
		End
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock()
	Endif
Next i
dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])
Return(Nil)

Static Function RetFullName (cUser)
cUser:= UsrFullName(cUser)
Return cUser
