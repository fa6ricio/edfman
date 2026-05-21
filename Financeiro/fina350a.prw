#INCLUDE "FINA350.CH"
#INCLUDE "PROTHEUS.CH"

// 17/08/2009 - Compilacao para o campo filial de 4 posicoes
// 18/08/2009 - Compilacao para o campo filial de 4 posicoes

/*
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ?FINA350    ?Autor ?Pilar S. Albaladejo ?Data ?26.03.95 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ?Lancamentos Correcao Monetaria                             낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿞intaxe   ?FINA350A()                                                 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛arametros?                                                           낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?Uso      ?SIGAFIN                                                    낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴눙?
굇?  DATA   ?PROGRAMADOR   쿘ANUTENCAO EFETUADA    쿍OPS:   00000136412 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴눙?
굇?21/11/07 ?Pedro P Lima  ?A rotina nao estava buscando os valores das낢?
굇?         ?   TI6434     ?contas de debito quando o LP 598 era       낢?
굇?         ?              ?para utilizar como valor o campo           낢?
굇?         ?              ?SA1->A1_CONTA. Quando era executada havendo낢?
굇?         ?              ?dois ou mais clientes o valor da Conta     낢?
굇?         ?              ?Debito do primeiro cliente na verdade      낢?
굇?         ?              ?apresentava o valor da conta debito do     낢?
굇?         ?              ?segundo cliente, e o segundo aparecia em   낢?
굇?         ?              ?branco.                                    낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴눙?
굇?Alteracao?Luis Felipe M 쿘ANUTENCAO EFETUADA    ?DATA:  16/05/2014  낢?
굇?         ?              ?Criadas novas perguntas para filtrar apenas낢?
굇?         ?              ?um titulo a pagar ou receber.              낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
User Function FINA350A()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Define Variaveis                                                          ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
LOCAL nOpca := 0
Local aSays:={}, aButtons:={}
Local lCont	:= .T.
Private cCadastro := OemToAnsi("Contabiliza Correcao monetaria") //"Contabiliza Corre뇙o monet쟲ia"

AjustaSX1()

Pergunte("AFI350",.F.)

m->Mv_PAR08 := RecMoeda(dDataBase,mv_par02)
m->Mv_PAR09 := RecMoeda(dDataBase,mv_par02)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Inicializa o log de processamento                            ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
ProcLogIni( aButtons )

AADD(aSays,OemToAnsi( "O objetivo deste programa consiste em efetuar a  apura뇙o  da diferen놹" ) ) //"O objetivo deste programa consiste em efetuar a  apura뇙o  da diferen놹"
AADD(aSays,OemToAnsi( "entre a data de emiss꼘 e data base dos t죜ulos em aberto em moeda for-" ) ) //"entre a data de emiss꼘 e data base dos t죜ulos em aberto em moeda for-"
AADD(aSays,OemToAnsi( "te. A diferen놹 ser?lan놹da na contabilidade (Varia뇙o Monet쟲ia)." ) ) //"te. A diferen놹 ser?lan놹da na contabilidade (Varia뇙o Monet쟲ia)."
If lPanelFin  //Chamado pelo Painel Financeiro			
	aButtonTxt := {}			
	If Len(aButtons) > 0
		AADD(aButtonTxt,{"Visualizar","Visualizar",aButtons[1][3]}) // Visualizar			
	Endif
	AADD(aButtonTxt,{"Parametros","Parametros", {||F350BTOP()}}) // Parametros						
	FaMyFormBatch(aSays,aButtonTxt,{||nOpca:=1},{||nOpca:=0})	
Else                  			
	AADD(aButtons, { 5,.T.,{|| Pergunte("AFI350",.T. ) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	FormBatch( cCadastro, aSays, aButtons,,,450 )
Endif
	
Private nMoeda
Private lSkip

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Variaveis utilizadas para parametros                          ?
//?MV_PAR01 - Carteira -> Receber/Pagar/Ambas                    ?
//?MV_PAR02 - Moeda?                                             ?
//?MV_PAR03 - Mostra lancamento contabil?                        ?
//?MV_PAR04 - Aglutina?                                          ?
//?MV_PAR05 - Contabliza por Clinte/Fornecedor ou Titulo         ?
//?MV_PAR06 - Contabiliza Variacao de Taxa Contratada ?          ?
//| MV_PAR07 - Considera titulos com emissao futura ?			      |
//| MV_PAR08 - Informe a taxa de venda da moeda             	   |
//| MV_PAR09 - Informe a taxa de venda da compra             	   |
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

If ExistBlock("F350CONF")
	lCont:= ExecBlock("F350CONF",.F.,.F.)
Endif
If nOpcA == 1 .And. lCont
	nMoeda := mv_par02
	Processa({|lEnd| FA350Calc()})  // Chamada da funcao de contabiliza눯o
Endif 

If lPanelFin //Chamado pelo Painel Financeiro			   
   dbSelectArea(FinWindow:cAliasFile)
   ReCreateBrow(FinWindow:cAliasFile,FinWindow)      	
Endif

Return

/*
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ?Fa350Calc  ?Autor ?Pilar S. Albaladejo   ?Data ?25/03/95 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ?Calculo da variacao dos titulos                              낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?Uso      ?FINA350                                                      낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/
Static Function FA350Calc()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Definicao das variaveis a serem utilizadas pela rotina              ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
Local nHdlPrv
Local cArquivo
Local cPadrao
Local nTotal     := 0
Local lHeadProva  := .F.
Local lPadrao
Local nValor1     := 0
Local nValorM     := 0
Local lF350Cm		:= ExistBlock("F350CM")
Local lF350Cm2		:= ExistBlock("F350CM2")
Local lF350SE1		:= ExistBlock("F350SE1")
Local lF350SE2		:= ExistBlock("F350SE2")
Local lF350GE1		:= ExistBlock("F350GE1")
Local lF350GE2		:= ExistBlock("F350GE2")
Local nTxVenda	:= Iif (MV_PAR08 > 0,MV_PAR08,RecMoeda(dDataBase,MV_PAR02))
Local nTxCompra	:= Iif (MV_PAR09 > 0,MV_PAR09,RecMoeda(dDataBase,MV_PAR02))
Local cAliasSE1
Local cAliasSE2
Local aFlagCTB := {}
Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/) 
Local lCNTA100  := SuperGetMV("MV_CNFI350",.F.,.F.)
   
#IFDEF TOP
	Local cWhere := ""
#ENDIF

Private aRotina := {{"", "", 0, 1}, ;
                    {"", "", 0, 2}, ;
                    {"", "", 0, 3}, ;
                    {"", "", 0, 4} }

Private cLote


VALOR := 0

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Verifica o numero do Lote                                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
LoteCont("FIN")

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Atualiza o log de processamento   ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
ProcLogAtu("INICIO")

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//?Inicia calculo do SE1                                            ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If mv_par01 == 1 // .Or. mv_par01 == 3

	
	ProcRegua(RecCount())	  
	
	#IFDEF TOP
		cAliasSE1 := GetNextAlias()
		
		If MV_PAR06 == 2
			cWhere := "E1_TXMOEDA = 0 AND "
		Endif

		If MV_PAR07 == 2
			cWhere += "E1_EMISSAO <= '"+DTOS(dDataBase)+"' AND "
		EndIf

        // 16/05/14 - Luis Felipe Nascimento - Inicio
		cWhere += "E1_NUM     = '"+MV_PAR16+"' AND "
		cWhere += "E1_PREFIXO = '"+MV_PAR17+"' AND "
		cWhere += "E1_PARCELA = '"+MV_PAR18+"' AND "
		cWhere += "E1_TIPO    = '"+MV_PAR19+"' AND "
		cWhere += "E1_CLIENTE = '"+MV_PAR20+"' AND "
		cWhere += "E1_LOJA    = '"+MV_PAR21+"' AND "
        // 16/05/14 - Luis Felipe Nascimento - Fim

		cWhere += "E1_MOEDA = "+Alltrim(Str(mv_par02))+" AND "
		cWhere += "(E1_TIPO NOT IN " + FORMATIN(MVPROVIS+"|"+MVABATIM,"|")
		//-- Parametro para realizaar contab. var. cambial dos titulos provisorios do SIGAGCT
		If lCNTA100
			cWhere += " OR E1_ORIGEM = 'CNTA100'"
		EndIf
		cWhere += ") "
		cWhere := "%"+cWhere+"%"
		
		BeginSql alias cAliasSE1
			SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_LOJA, E1_MOEDA, E1_SALDO, E1_TXMOEDA, E1_EMISSAO, E1_DTVARIA, E1_VALOR, E1_VLCRUZ, E1_EMISSAO, E1_NATUREZ, SE1.R_E_C_N_O_ RECNOE1
			FROM %table:SE1% SE1
			JOIN %table:SA1% SA1 ON  
			A1_COD = E1_CLIENTE AND SA1.%NotDel%
			WHERE E1_FILIAL = %xFilial:SE1% AND
				E1_SALDO > 0 AND
			  	%Exp:cWhere% AND
			  	SE1.%NotDel%
		  	ORDER BY %Order:SE1%
		EndSql
		
	#ELSE
		cAliasSe1 := "SE1"
		dbSelectArea("SE1")
		dbSetOrder(2)
		dbSeek(cFilial)
	#ENDIF
	While (cAliasSE1)->(!Eof()) .and. (cAliasSE1)->E1_FILIAL == xFilial("SE1")

		IncProc()

		cCliente   :=E1_Cliente
		cLoja      :=E1_Loja
		lSkip := .F.
		
		#IFNDEF TOP
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Posiciona no cadastro de clientes                                ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			dbSelectArea("SA1")  
			SA1->( MsSeek(cFilial+cCliente+cLoja) )
		#ENDIF
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		//?Acumula a variacao de todos os titulos do cliente atual           ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		While (cAliasSE1)->(!Eof()) .And.  (cAliasSE1)->E1_Filial   == xFilial("SE1") .And. ;
						(cAliasSE1)->E1_Cliente == cCliente .And. ;
						(cAliasSE1)->E1_Loja    == cLoja
	
			#IFDEF TOP
				SE1->(MsGOTO((cAliasSE1)->RECNOE1))
			#ENDIF
			
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//?Despreza os titulos que nao satisfacam as condicoes do programa ?
			//?1. Emitido na moeda diferente                                   ?
			//?2. Ja baixado                                                   ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			IF SE1->E1_MOEDA != nMoeda .or. SE1->E1_SALDO == 0
				(cAliasSE1)->(dbSkip())
				Loop
			EndIf

			If MV_PAR06 == 2 .And. SE1->E1_TXMOEDA <> 0
				(cAliasSE1)->(dbSkip())
				Loop
			EndIf
	
			IF SE1->E1_TIPO $ MVPROVIS .or. SE1->E1_TIPO $ MVABATIM
				If AllTrim(SE1->E1_ORIGEM) # "CNTA100" .Or. !lCNTA100
					(cAliasSE1)->(dbSkip())
					Loop
				EndIf
			Endif
			
			// Se nao considera titulos com emissao futura, ignora o titulo se ele estiver com emissao futura
			If MV_PAR07 == 2 .And. SE1->E1_EMISSAO > dDataBase
				(cAliasSE1)->(dbSkip())
				Loop
			EndIf
			
			If lF350SE1
				If !(ExecBlock("F350SE1",.F.,.F.))
					(cAliasSE1)->(dbSkip())
					Loop
				EndIf
			EndIf				

			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//?Calcula o valor na moeda escolhida na data da ultima variacao   ?
			//?ou na data de emissao (caso nao tenha sofrido ainda nenhuma     ?
			//?variacao.                                                       |
			//?Calcula o valor na moeda escolhida para a database.             ?
			//?Subtrai um valor do outro para apurar a variacao.               ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//Caso seja a primeira apuracao de variacao monetaria
			If Empty(SE1->E1_TXMOEDA) .and. Empty(SE1->E1_DTVARIA) .and. STR(SE1->E1_SALDO,17,2) == STR(SE1->E1_VALOR,17,2)
				nValor1 := SE1->E1_VLCRUZ
			Else
				If(SE1->(FieldPos("E1_TXMDCOR")>0 ) .And. !Empty(SE1->E1_TXMDCOR))
					nValor1 := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,Iif(Empty(SE1->E1_DTVARIA),SE1->E1_EMISSAO,SE1->E1_DTVARIA),,SE1->E1_TXMDCOR)										
				Else
					nValor1 := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,Iif(Empty(SE1->E1_DTVARIA),SE1->E1_EMISSAO,SE1->E1_DTVARIA),,Iif(Empty(SE1->E1_DTVARIA),SE1->E1_TXMOEDA,0))
				EndIf
			Endif 
			
		  	nValorM  :=  xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,1,dDataBase,,nTxVenda)

			If lF350CM
				VALOR += Execblock("F350CM",.F.,.F.)
			Else
				VALOR += (nValorM - nValor1)
			Endif
	
			If VALOR != 0
				RecLock("SE1")
				Replace E1_DTVARIA With dDataBase
				If SE1->(FieldPos("E1_TXMDCOR"))>0
					Replace E1_TXMDCOR with nTxVenda 
				EndIf
				MsUnlock()
				
				If lF350GE1
					ExecBlock ("F350GE1",.F.,.F.,VALOR)
				Endif
								
			Endif

			If mv_par05 == 2		//contabiliza por titulo
				lSkip := .T.
				Exit
			Endif
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//?Passa para o proximo titulo                                     ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			(cAliasSE1)->(dbSkip())
		Enddo

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		//?Contabiliza para o cliente verificado                             ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		If VALOR != 0
			dbSelectArea("SED")
			dbSeek(xFilial("SED")+SE1->E1_NATUREZ)
			dbSelectArea("SA1")
			SA1->(MsSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA)))

			If mv_par05 == 2
				Reclock("SE5",.T.)
				Replace E5_FILIAL With xFilial()
				Replace E5_PREFIXO With SE1->E1_PREFIXO
				Replace E5_NUMERO  With SE1->E1_NUM
				Replace E5_PARCELA With SE1->E1_PARCELA
				Replace E5_TIPO    With SE1->E1_TIPO
				Replace E5_CLIFOR  With SE1->E1_CLIENTE
				Replace E5_LOJA    With SE1->E1_LOJA
				Replace E5_VALOR   With VALOR
				Replace E5_VLMOED2 With xMoeda(VALOR,1,SE1->E1_MOEDA)
				Replace E5_DATA    With dDataBase
				Replace E5_NATUREZ With SE1->E1_NATUREZ
				Replace E5_RECPAG  With "R"
				Replace E5_TIPODOC With "VM"
				If !lUsaFlag
					Replace E5_LA      With "S"
				Endif
				Replace E5_DTDIGIT With dDataBase
				Replace E5_DTDISPO With dDataBase
				Replace E5_HISTOR  With "CORREC MONET."
				MsUnlock()
			Endif
			cPadrao   :="598"
			lPadrao   :=VerPadrao(cPadrao)
			IF lPadrao
				IF !lHeadProva
					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
					//?Inicializa Lancamento Contabil                                   ?
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
						nHdlPrv := HeadProva( cLote,;
						                      "FINA350" /*cPrograma*/,;
						                      Substr( cUsuario, 7, 6 ),;
						                      @cArquivo )

					lHeadProva := .T.
				End
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//?Prepara Lancamento Contabil                                      ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil 
						// aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
					Endif
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA350" /*cPrograma*/,;
					                    cLote,;
					                    /*nLinha*/,;
					                    /*lExecuta*/,;
					                    /*cCriterio*/,;
					                    /*lRateio*/,;
					                    /*cChaveBusca*/,;
					                    /*aCT5*/,;
					                    /*lPosiciona*/,;
					                    @aFlagCTB,;
					                    /*aTabRecOri*/,;
					                    /*aDadosProva*/ )

			 Endif
		Endif
		If mv_par05 == 2
			// por titulo, vai para o proximo registro
			If lSkip
				(cAliasSE1)->(dbSkip())
			Endif
		Endif
		VALOR := 0
	Enddo
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//?Volta o arquivo para a chave primaria                            ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	#IFDEF TOP
		(cAliasSE1)->(dbCloseArea())
		cWhere := ""
	#ENDIF
	dbSelectArea("SE1")
	dbSetOrder(1)

	VALOR    := 0
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Inicia calculo do SE2                                         ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
If mv_par01 == 2 // .or. mv_par01 == 3
	ProcRegua(RecCount())
	#IFDEF TOP
	
		cAliasSE2 := GetNextAlias()		

		If MV_PAR06 == 2
			cWhere := "E2_TXMOEDA = 0 AND "
		Endif

		If MV_PAR07 == 2
			cWhere += "E2_EMISSAO <= '"+DTOS(dDataBase)+"' AND "
		EndIf

        // 16/05/14 - Luis Felipe Nascimento - Inicio
		cWhere += "E2_NUM     = '"+MV_PAR10+"' AND "
		cWhere += "E2_PREFIXO = '"+MV_PAR11+"' AND "
		cWhere += "E2_PARCELA = '"+MV_PAR12+"' AND "
		cWhere += "E2_TIPO    = '"+MV_PAR13+"' AND "
		cWhere += "E2_FORNECE = '"+MV_PAR14+"' AND "
		cWhere += "E2_LOJA    = '"+MV_PAR15+"' AND "
        // 16/05/14 - Luis Felipe Nascimento - Fim

		cWhere += "E2_MOEDA = "+Alltrim(Str(mv_par02))+" AND "
		cWhere += "(E2_TIPO NOT IN " + FORMATIN(MVPROVIS+"|"+MVABATIM,"|")
		//-- Parametro para realizaar contab. var. cambial dos titulos provisorios do SIGAGCT
		If lCNTA100
			cWhere += " OR E2_ORIGEM = 'CNTA100'"
		EndIf
		cWhere += ") "
		cWhere := "%"+cWhere+"%"				
		
		BeginSql alias cAliasSE2			
			SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, E2_MOEDA, E2_SALDO, E2_TXMOEDA, E2_EMISSAO, E2_DTVARIA, E2_VALOR, E2_VLCRUZ, E2_NATUREZ, SE2.R_E_C_N_O_ RECNOE2
			FROM %table:SE2% SE2
			JOIN %table:SA2% SA2 ON 
			A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND SA2.%NotDel%
			WHERE E2_FILIAL = %xFilial:SE2% AND
				E2_SALDO > 0 AND
			  	%Exp:cWhere% AND
			  	SE2.%NotDel%
		  	ORDER BY %Order:SE2%
		EndSql
		
	#ELSE
		cAliasSE2 := "SE2"
		dbSelectArea("SE2")
		dbSetOrder(6)
		dbSeek(xFilial("SE2"))
	#ENDIF

	While (cAliasSE2)->(!Eof()) .and. (cAliasSE2)->E2_FILIAL == xFilial("SE2")

		IncProc()

		cFornece := E2_Fornece
		cLoja    := E2_Loja
		lSkip := .F.
		
		#IFNDEF TOP
			dbSelectArea("SA2")
			dbSeek(cFilial+SE2->E2_FORNECE+SE2->E2_LOJA)
		#ENDIF
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		//?Acumula a variacao de todos os titulos do fornecedor atual        ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		While (cAliasSE2)->(!Eof()) .And.   (cAliasSE2)->E2_Filial   == xFilial("SE2")  .And. ;
							(cAliasSE2)->E2_Fornece  == cFornece .And. ;
							(cAliasSE2)->E2_Loja     == cLoja

			#IFDEF TOP
				SE2->(MsGOTO((cAliasSE2)->RECNOE2))
			#ENDIF
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
			//?Despreza os titulos que nao satisfacam as condicoes do programa?
			//?1. Emitido na moeda solicitada                                 ?
			//?2. Ja baixado                                                  ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
			IF SE2->E2_MOEDA != nMoeda .or. SE2->E2_SALDO = 0
				(cAliasSE2)->(dbSkip( ))
				Loop
			Endif
	
			IF SE2->E2_TIPO $ MVPROVIS .or. SE2->E2_TIPO $ MVABATIM
				If AllTrim(SE2->E2_ORIGEM) # "CNTA100" .Or. !lCNTA100
					(cAliasSE2)->(dbSkip( ))
					Loop
				EndIf
			Endif
			
			If MV_PAR06 == 2 .And. SE2->E2_TXMOEDA <> 0
				(cAliasSE2)->(dbSkip())
				Loop
			EndIf
			
			// Se nao considera titulos com emissao futura, ignora o titulo se ele estiver com emissao futura
			If MV_PAR07 == 2 .And. SE2->E2_EMIS1 > dDataBase
				(cAliasSE2)->(dbSkip())
				Loop
			EndIf
	
			If lF350SE2
				If !(ExecBlock("F350SE2",.F.,.F.))
					(cAliasSE2)->(dbSkip())
					Loop
				EndIf
			Endif
	
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//?Calcula o valor na moeda escolhida na data da ultima variacao   ?
			//?ou na data de emissao (caso nao tenha sofrido ainda nenhuma     ?
			//?variacao.                                                       ?
			//?Calcula o valor na moeda escolhida para a database.             ?
			//?Subtrai um valor do outro para apurar a variacao.               ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//Caso seja a primeira apuracao de variacao monetaria
			If Empty(SE2->E2_TXMOEDA) .and. Empty(SE2->E2_DTVARIA) .and. STR(SE2->E2_SALDO,17,2) == STR(SE2->E2_VALOR,17,2)
				nValor1 := SE2->E2_VLCRUZ
			Else 
				If(SE2->(FieldPos("E2_TXMDCOR")>0 ) .And. !Empty(SE2->E2_TXMDCOR))
					nValor1 := xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,Iif(Empty(SE2->E2_DTVARIA),SE2->E2_EMISSAO,SE2->E2_DTVARIA),TamSX3("E2_TXMDCOR")[2],SE2->E2_TXMDCOR)
				Else
					nValor1 := xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,Iif(Empty(SE2->E2_DTVARIA),SE2->E2_EMISSAO,SE2->E2_DTVARIA),TamSX3("E2_TXMDCOR")[2],Iif(Empty(SE2->E2_DTVARIA),SE2->E2_TXMOEDA,0))
				EndIf
			Endif	
            
			nValorM  :=    xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,dDataBase,TamSX3("E2_TXMDCOR")[2],nTxCompra)

			If lF350CM2
				VALOR += Execblock("F350CM2",.F.,.F.)
			Else
				VALOR += (nValorM - nValor1)
			Endif
	
			If VALOR != 0
				RecLock("SE2")
				Replace E2_DTVARIA With dDataBase 
				If SE2->(FieldPos("E2_TXMDCOR")>0)
					Replace E2_TXMDCOR With nTxCompra
				EndIf
				MsUnlock()
				
				If lF350GE2
					ExecBlock ("F350GE2",.F.,.F.,VALOR)
				Endif
								
			Endif
				
			If mv_par05 == 2			// contabiliza por titulo
				lSkip := .T.
				Exit
			Endif
				
			//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			//?Passa para o proximo titulo                                   ?
			//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
			(cAliasSE2)->(dbSkip())
		Enddo

		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		//?Contabiliza para o fornecedor verificado                          ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
		If VALOR != 0
			dbSelectArea("SED")
			dbSeek(xFilial("SED")+SE2->E2_NATUREZ)
			dbSelectArea("SA2")
			dbSeek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA))

			If mv_par05 == 2
				Reclock("SE5",.T.)
				Replace E5_FILIAL With xFilial()
				Replace E5_PREFIXO With SE2->E2_PREFIXO
				Replace E5_NUMERO  With SE2->E2_NUM
				Replace E5_PARCELA With SE2->E2_PARCELA
				Replace E5_TIPO    With SE2->E2_TIPO
				Replace E5_CLIFOR  With SE2->E2_FORNECE
				Replace E5_LOJA    With SE2->E2_LOJA
				Replace E5_VALOR   With VALOR
				Replace E5_VLMOED2 With xMoeda(VALOR,1,SE2->E2_MOEDA)
				Replace E5_DATA    With dDataBase
				Replace E5_NATUREZ With SE2->E2_NATUREZ
				Replace E5_RECPAG  With "P"
				Replace E5_TIPODOC With "VM"
				If !lUsaFlag
					Replace E5_LA With "S"
				Endif
				Replace E5_DTDIGIT With dDataBase
				Replace E5_DTDISPO With dDataBase
				Replace E5_HISTOR  With "CORREC MONET."
				MsUnlock()
			Endif			

			cPadrao:="599"
			lPadrao:=VerPadrao(cPadrao)
			IF lPadrao
				IF !lHeadProva
					SA2->(DbSetOrder(1))
					SA2->(dbSeek( xFilial("SA2") + cFornece+cLoja))   
					//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
					//?Inicializa Lancamento Contabil                                   ?
					//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
						nHdlPrv := HeadProva( cLote,;
						                      "FINA350" /*cPrograma*/,;
						                      Substr( cUsuario, 7, 6 ),;
						                      @cArquivo )
					lHeadProva := .T.
				End
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
				//?Prepara Lancamento Contabil                                      ?
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
					If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil 
						// aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
					Endif
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA350" /*cPrograma*/,;
					                    cLote,;
					                    /*nLinha*/,;
					                    /*lExecuta*/,;
					                    /*cCriterio*/,;
					                    /*lRateio*/,;
					                    /*cChaveBusca*/,;
					                    /*aCT5*/,;
					                    /*lPosiciona*/,;
					                    @aFlagCTB,;
					                    /*aTabRecOri*/,;
					                    /*aDadosProva*/ )
			Endif
		Endif
		If mv_par05 == 2
			// por titulo, vai para o proximo registro
			If lSkip
				(cAliasSE2)->(dbSkip())
			Endif
		Endif
		VALOR := 0
	Enddo   
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//?Volta o arquivo para a chave primaria                            ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	#IFDEF TOP
		(cAliasSE2)->(dbCloseArea())
	#ENDIF	
	dbSelectArea("SE2")
	dbSetOrder(1)
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Se houve variacao serao efetuados lancamentos contabeis ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
IF lHeadProva
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//?Chama tela de lanc contabeis para usuario confirmar          ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		lDigita  :=Iif(mv_par03==1,.T.,.F.)
		lAglutina:=Iif(mv_par04==1,.T.,.F.)

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//?Efetiva Lan놹mento Contabil                                      ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		RodaProva( nHdlPrv,;
		           nTotal)

		cA100Incl( cArquivo,;
		           nHdlPrv,;
		           3 /*nOpcx*/,;
		           cLote,;
		           lDigita,;
		           lAglutina,;
		           /*cOnLine*/,;
		           /*dData*/,;
		           /*dReproc*/,;
		           @aFlagCTB,;
		           /*aDadosProva*/,;
		           /*aDiario*/ )
		aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
	
Endif

If nHdlPrv != NIL
	FClose(nHdlPrv)
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//?Atualiza o log de processamento   ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
ProcLogAtu("FIM")

Return NIL

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    쿑350VlPerg() ?Autor ?Paulo Augusto    ?Data ?16.05.05 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ?Ajusta Pergunta Moedas ?       				    	    낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/                                  
Static Function F350VlPerg()    

Local lRet:= .F.

If mv_par02 > 1 .and. mv_par02 <= MoedFin()
	lRet:= .T.
EndIf
If lRet
	M->Mv_PAR08 := RecMoeda(dDataBase,m->mv_par02)
	M->Mv_PAR09 := RecMoeda(dDataBase,m->mv_par02)
EndIf

Return (lRet)

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ?AjustaSX1?Autor ?Gustavo Henrique      ?Data ?06/11/07 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ?Ajusta pergunta mv_par02 "Moeda"                           낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/
Static Function AjustaSX1()
/*LOCAL aStruct 	  := SX1->( dbStruct() )
Local nPosCpo	  := 0

SX1->( dbSetOrder(1) )

// Pesquisa pergunta de moeda como COMBO. Se encontrar, altera para GET que a forma correta
If	SX1->( MsSeek( PadR( "AFI350", Len(SX1->X1_GRUPO) ) + "02" ) ) .And.;
	SX1->X1_GSC == "C"
	
	RecLock("SX1",.F.)
	For nPosCpo := 1 To Len( aStruct ) 
		IF Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_GSC"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "G" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_CNT01"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "2" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEF01"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEFSPA1"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEFENG1"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEF02"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEFSPA2"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEFENG2"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEF03"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEFSPA3"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEFENG3"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEF04"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEFSPA4"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		elseif Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_DEFENG4"
			SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "" )
		ENDIF
	Next nPosCpo
	MsUnlock()

EndIf

If	SX1->( MsSeek( PadR( "AFI350", Len(SX1->X1_GRUPO) ) + "09" ) )
	If "VENTA" $ AllTrim( Upper( SX1->X1_PERSPA ) )
		RecLock("SX1",.F.)
		For nPosCpo := 1 To Len( aStruct ) 
			IF Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_PERSPA"
				SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "풲asa de compra de la moneda ?" )
			ENDIF
		Next nPosCpo
		MsUnlock()
	EndIf
	If "SELL" $ AllTrim( Upper( SX1->X1_PERENG ) )
		RecLock("SX1",.F.)
		For nPosCpo := 1 To Len( aStruct ) 
			IF Upper( AllTrim( aStruct[ nPosCpo , 1 ] ) ) == "X1_PERENG"
				SX1->FieldPut( FieldPos ( aStruct[ nPosCpo , 1 ] ) , "Currency purchase rate ?" )
			ENDIF
		Next nPosCpo
		MsUnlock()
	EndIf
EndIf	*/

Return Nil


Static Function F350BTOP()  
	Pergunte("AFI350",.T. )
	LimpaMoeda()	
Return
