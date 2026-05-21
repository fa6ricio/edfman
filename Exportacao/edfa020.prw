#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FILEIO.CH'
#define ENTER CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA020 ºAutor Yttalo P Martins        º Data ³  11/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Complemento de PreçosXInvoice Complementar                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma  ³        ºAutor Luis Felipe Nascimento  º Data ³  18/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Adicionada as informações da NF de origem no pedido da NF  º±±
±±º          ³ Complementar. C5_XMENNOT                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EDFA020()

LOCAL __AAREA := GETAREA()
Local lRet := .f.
Local cMsg := ""

Local aOrd := SaveOrd("SF2")
Local cNota:= ""
Local aRotAuto      := {}


Private nValorTot := 0
Private cTES      := Space(Len(SC6->C6_TES))
Private lEstorno  := !Empty(EEC->EEC_XINVCP) //! Empty(EEC->EEC_XNFCP)--- Luiz Fernando 12/06/15
PRIVATE cInvCompl := ""
PRIVATE cPedido   := ""
PRIVATE xcSeqEmb  := ""
PRIVATE xMennota  := ""
PRIVATE cPedido   := ""
/* Campos para controle:
EEC_PEDEMB --> Nro do Pedido de Complemento
EEC_XNFCP  --> Nro da NF de Complemento
EEC_XVLNF  --> Valor da NF de Complemento em moeda estrangeira
*/

Private cMsgErr := ""
Private lMostraCtb,lAglCtb,lContab,lCarteira,lMsErroAuto

*** Luiz Fernando - 15/06/2015
***********************************
If lEstorno
	IF !MsgYesNo("Deseja Estornar Pedido: "+Alltrim(EEC_PEDEMB)+" da Invoice "+Alltrim(EEC->EEC_XINVCP)+" de complemento de preço?")
		Return
	Endif
	IF Empty(EEC->EEC_XNFCP) .And. SC5->(dbSeek(xFilial("SC5")+EEC->EEC_PEDEMB))
		aCabec := {}
		aadd(aCabec,{"C5_NUM"   , EEC->EEC_PEDEMB  , Nil})
		
		SC9->(dbSetOrder(1))
		SC9->(dbSeek(xFilial()+EEC->EEC_PEDEMB))
		While SC9->(!Eof() .And. C9_FILIAL == xFilial("SC9") .And. C9_PEDIDO == EEC->EEC_PEDEMB)
			SC9->(a460Estorna())
			SC9->(dbSkip())
		Enddo
		
		lMSErroAuto := .F.
		MsExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,{},5)
		
		If lMsErroAuto
			MostraErro()
			AddMsg("Erro no estorno do Pedido "+EEC->EEC_PEDEMB+" na filial "+xFilial("SC5"))
			lRet := .F.
		Else
			IF SC5->(dbSeek(xFilial("SC5")+EEC->EEC_PEDEMB))
				AddMsg("Erro no estorno do Pedido "+EEC->EEC_PEDEMB+" na filial "+xFilial("SC5"))
				lRet := .F.
			Endif
		EndIf
	Endif
	
	If !lMsErroAuto
		DbSelectArea("EXP")
		EXP->(dbSetOrder(1))
		IF EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB+PADR(EEC->EEC_XINVCP,TAMSX3("EXP_NRINVO")[1] )))

			Begin Transaction

			dbSelectArea("EXR")
			EXR->(dbSetOrder(1))
			IF EXR->(dbSeek(xFilial("EXR")+EEC->EEC_PREEMB+EXP->EXP_NRINVO))
				
				*** Exclui a Capa da Invoice Compl
				************************************
				RecLock("EXP",.F.)
				("EXP")->(dbDelete())
				("EXP")->(MsUnlock())
				
				dbSelectArea("EE9")
				EE9->(dbSetOrder(3))
				IF EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+EXR->EXR_SEQEMB))
					
					*** Exclui os Itens da Invoice Compl
					**************************************
					RecLock("EXR",.F.)
					("EXR")->(dbDelete())
					("EXR")->(MsUnlock())
					
					dbSelectArea("EE7")
					EE7->(dbSetOrder(1))
					IF EE7->(dbSeek(xFilial("EE7")+EE9->EE9_PEDIDO))
						
						*** Exclui os Itens Embarque Compl
						**************************************
						RecLock("EE9",.F.)
						("EE9")->(dbDelete())
						("EE9")->(MsUnlock())
						
					ENDIF
					
					dbSelectArea("EE8")
					EE8->(dbSetOrder(1))
					IF EE8->(dbSeek(xFilial("EE8")+EE7->EE7_PEDIDO))
						cPedido := EE7->EE7_PEDIDO
						*** Exclui os Capa Pedido Export Compl
						******************************************
						RecLock("EE7",.F.)
						("EE7")->(dbDelete())
						("EE7")->(MsUnlock())
						
						While EE8->EE8_PEDIDO == cPedido .and. !Eof()
							RecLock("EE8",.F.)
							("EE8")->(dbDelete())
							("EE8")->(MsUnlock())
							EE8->(DbSkip())
						Enddo

					ENDIF
					
					// 17/03/17 - Luis Felipe  - Inicio
					// Não estava estornando a Precificação da NF Complementar
					
					xcProd := EE9->EE9_COD_I
					xPos := AT("-",xcProd)
					
					xcContra := Alltrim(SubStr(xcProd , 1, xPos-1 ))
					xcContra := PADR(xcContra,TAMSX3("Z5_CONTRA")[1] )
					
					xcPeriod := Alltrim(SubStr(xcProd , xPos+1, Len(xcProd)-xPos ))
					xcPeriod := PADR(xcPeriod,TAMSX3("Z5_PERDE")[1] )

					cQuery := "UPDATE "+ RetSQLName("SZ6")+" " 
					cQuery += "SET D_E_L_E_T_ = '*' "
					cQuery += "Where Z6_FILIAL = '"+xFilial("SZ6")+"' AND "
					cQuery += "Z6_CONTRA = '"+ xcContra +"' AND "
					cQuery += "Z6_PERDE = '"+ xcPeriod +"' AND "
					cQuery += "Z6_XINVCP = '"+ EEC->EEC_XINVCP +"' AND "
					cQuery += "D_E_L_E_T_ = ' '; "
					
					If TCSQLExec( cQuery ) <> 0
						UserException("Falha na Atualização da tabela SZ6 " + TCSQLError() )
						DisarmTransaction()
						Break
					EndIf

					// 17/03/17 - Luis Felipe  - Inicio
					
					// 16/08/18 -Luis Felipe - Inicio
					BEGIN TRANSACTION
					
					AAdd( aRotAuto, { "E1_NUM"    , EEC->EEC_XINVCP, NIL} )
					AAdd( aRotAuto, { "E1_PREFIXO", "EEC", NIL 		  } )
					AAdd( aRotAuto, { "E1_NATUREZ", "0072", NIL 	  } )
					AAdd( aRotAuto, { "E1_TIPO"   , "INV", NIL 		  } )
					AAdd( aRotAuto, { "E1_CLIENTE", EEC->EEC_IMPORT, NIL  } )
					AAdd( aRotAuto, { "E1_LOJA"   , EEC->EEC_IMLOJA, NIL } )
					
					MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 5)
					
					If lMsErroAuto
						
						MostraErro()
						AddMsg("Erro na exlusão do título de invoice no financeiro "+EEC->EEC_XINVCP+" na filial "+xfilial("SE1"))
						
						lRet := .F.
						DisarmTransaction()
						Break
					EndIf
					
					END TRANSACTION
					// 16/08/18 -Luis Felipe - Fim

				ENDIF
				
			ENDIF

			End Transaction

			MsgInfo("Invoice Complementar e Pedido de Venda de complemento de preço estornados com sucesso.")
	
		ENDIF
		
	Endif
	
Endif
*********** Fim Luiz Fernando ************************

Begin Sequence

IF !TemNFS(EEC->EEC_PREEMB)
	MsgInfo("Para gerar a nota fiscal complementar é necessário vincular as notas fiscais de saída.")
	Break
Endif

//IF !Empty(EEC->EEC_DTEMBA)
//	MsgInfo("O processo já foi embarcado, não é possivel gerar Nota Fiscal de Complemento de Preço.")
//	Break
//Endif

// 19/11/14 - Luís Felipe Nascimento - Início
DbSelectArea("EXP")
EXP->(dbSetOrder(1))
If !EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB))
	MsgInfo("Não existe Invoice para o processo solicitado "+Alltrim(EEC->EEC_PREEMB)+" ! Sendo assim, não poderá ser criada uma Invoice Complementar.")
	Break
EndIf
// 19/11/14 - Luís Felipe Nascimento - Fim

IF lEstorno
	
	DbSelectArea("EXP")
	EXP->(dbSetOrder(1))
	EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB+PADR(EEC->EEC_XINVCP,TAMSX3("EXP_NRINVO")[1] )))
	
	DbSelectArea("SF2")
	SF2->(dbSetOrder(1))
	IF SF2->(dbSeek(xFilial()+AvKey(EEC->EEC_XNFCP,"F2_DOC")+AvKey(GetSerie(EEC->EEC_PREEMB),"F2_SERIE"))) // AQUI 28/09/18 - Luis Felipe - EEC_XNFCP - Não é mas usado EEC_XINVCP
		cMsg += "Atenção: A Nota Fiscal de Complemento nro "+EEC->EEC_XNFCP+" e Invoice "+ CRLF
		cMsg += "Complementar nro "+EXP->EXP_NRINVO+" já foram geradas para o "+ CRLF
		cMsg += "processo selecionado."+ CRLF
		cMsg += CRLF+"Tem certeza que deseja estorná-las?"
		IF !EECView(cMsg)
			Break
		Endif
	Else
		// A nota fiscal de complemento anterior já foi estornada. Limpar as flags
		EEC->(RecLock("EEC",.F.))
		EEC->EEC_PEDEMB   := ""
		EEC->EEC_XNFCP := ""
		EEC->EEC_XVLNF := 0
		EEC->EEC_XINVCP   := ""
		EEC->(MsUnlock())
		lEstorno := .F.
	Endif
Endif

IF lEstorno
	
	lMostraCtb := .T.
	lAglCtb    := .F.
	lContab    := .T.
	lCarteira  := .F.
	
	IF !EstornaNF(AvKey(GetSerie(EEC->EEC_PREEMB),"F2_SERIE"),AvKey(EEC->EEC_XNFCP,"F2_DOC"),EEC->EEC_PEDEMB) // AQUI 28/09/18 - Luis Felipe - EEC_XNFCP ? - EEC_XINVCP
		cMsg := "Atenção: A nota fiscal de complemento nro "+EEC->EEC_XNFCP+" não pode ser estornada."
		cMsg += CRLF+"Tem certeza que deseja continuar?"
		IF !EECView(cMsg)
			Break
		Endif
	Endif
	
	// A nota fiscal de complemento anterior já foi estornada. Limpar as flags
	EEC->(RecLock("EEC",.F.))
	EEC->EEC_PEDEMB   := ""
	EEC->EEC_XNFCP := ""
	EEC->EEC_XVLNF := 0
	EEC->EEC_XINVCP   := ""
	EEC->(MsUnlock())
	
	MsgInfo("Invoice Complementar e Nota fiscal de complemento de preço estornadas com sucesso.")
	Break
Endif

//IF !MsgYesNo("Deseja gerar a Invoice Complementar e Nota fiscal de complemento de preço?")
IF !MsgYesNo("Deseja gerar a Invoice Complementar e o Pedido de Venda de complemento de preço?")
	Break                                                                                       
Endif	

IF ! TelaGets()
	Break
Endif

IF !fDocs()
	Break
Endif

IF !GeraNF(nValorTot, @cNota, cPedido)
	Break
Endif

//MsgInfo("Nota Fiscal de Complemento nro "+cNota+" e Invoice Complementar nro "+cInvCompl+" geradas com sucesso.")
MsgInfo("Pedido de Venda nro "+SC5->C5_NUM+" e Invoice Complementar nro "+cInvCompl+" geradas com sucesso.")

lRet := .T.
End Sequence

RestOrd(aOrd,.T.)

RESTAREA(__AAREA)

Return lRet

//---------------------------------------------------------------
Static Function TelaGets

Local lRet := .F.
Local nOpc := 0
Local oDlg
Local oMemo
Local cTexto := ""

Begin Sequence

DEFINE MSDIALOG oDlg TITLE "[ Complemento de Preço ] - [ EDFA020.prw ]" FROM 0, 0 TO 240,460 OF oMainWnd PIXEL

@ 40, 05 SAY "Valor: "+EEC->EEC_MOEDA PIXEL
@ 40, 40 MSGET nValorTot PICTURE "@E 999,999,999.99" VALID Positivo() PIXEL

@ 55, 05 SAY "Tes: " PIXEL
@ 55, 40 MSGET cTES PICTURE "@!" VALID ExistCpo("SF4",cTES) F3 "SF4" pixel

@ 70, 05 SAY "Obs: " PIXEL
@ 70, 40 Get oMemo  Var cTexto MEMO Size 180,35 Of oDlg Pixel
oMemo:bRClicked := {||AllwaysTrue()}

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IF(VldOk(),(nOpc:=1, oDlg:End()),)},{||oDlg:End()}) CENTERED

IF nOpc == 1
	xMennota  := cTexto
	lRet      := .T.
Endif

End Sequence

Return lRet

//------------------------------------------------------------------
Static Function VldOk

Local lRet     := .F.
Local cMsg     := ""

Begin Sequence
IF Empty(cTES)
	cMsg += IF(!Empty(cMsg),ENTER,"")+"O campo TES não foi preenchido."
Endif

IF Empty(nValorTot)
	cMsg += IF(!Empty(cMsg),ENTER,"")+"O campo Valor Total não foi preenchido."
Endif

IF Empty(cMsg)
	lRet := .T.
Else
	EECView(cMsg)
Endif

End Sequence

Return lRet

//------------------------------------------------------------------
Static Function GeraNF(nValor, cNota, cPedido)

Local aOrd      := SaveOrd({"SD2"})
Local lRet      := .F.
Local aCab      := {}, aReg := {}, aItens := {}
Local nValTotal := 0, nValorIt := 0
LOCAL xnMoeda   := POSICIONE("SYF",1,XFILIAL("SYF")+EEC->EEC_MOEDA,"YF_MOEFAT")
LOCAL xnQtdVen    := 0
LOCAL xcUnidade   := ""
LOCAL xnPrcUniMed := 0
LOCAL xnSaldo     := 0
LOCAL lSegUnMed   := .F.
LOCAL cCf         := ""
LOCAL cClasFis    := ""
LOCAL cDesc       := ""

Begin Sequence

dbSelectArea("EE9")
EE9->(dbSetOrder(2))
//EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB)) // 17/03/17 - Luis Felipe Nascimento
EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+cPedido))

cPedido  := EE9->EE9_PEDIDO
cSerieNF := GetSerie(EEC->EEC_PREEMB)

dbSelectArea("EE8")
EE8->(DbSetOrder(1))
EE8->(Dbseek(xFilial("EE8")+cPedido+EE9->EE9_SEQUEN))

dbSelectArea("EE7")
EE7->(DbSetOrder(1))
EE7->(Dbseek(xFilial("EE7")+EE8->EE8_PEDIDO))

dbSelectArea("SB1")
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+EE8->EE8_COD_I))

// 18/11/14 - Luis Felipe Nascimento - Inicio
dbSelectArea("SC5")
SC5->(dbSetOrder(1))
SC5->(dbSeek(xFilial("SC5")+EE7->EE7_PEDFAT))
cXMENNOT := SC5->C5_XMENNOT
// 18/11/14 - Luis Felipe Nascimento - Fim

dbSelectArea("SF4") // TES
dbSetOrder(1)       // Codigo
dbSeek(xFilial("SF4") + cTes)

cCf      := SF4->F4_CF
cClasFis := SB1->B1_ORIGEM
cClasFis += SF4->F4_SITTRIB
cDesc    := SB1->B1_DESC

xcUnidade   := EE8->EE8_UNIDAD
xnPrcUniMed := nValorTot
lSegUnMed   := If(AllTrim(EE8->EE8_UNIDAD) <> AllTrim(SB1->B1_UM), .T., .F.)

cCondPag := Posicione("SY6",1,xFilial("SY6")+EEC->EEC_CONDPA+AvKey(EEC->EEC_DIASPA,"Y6_DIAS_PA"),"Y6_SIGSE4")

IF ! SA1->(dbSeek(xFilial()+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
	MsgInfo("Importador não cadastrado !","Aviso")
	Break
Endif

IF Empty(cCondPag)
	MsgInfo("O campo Cond.Pagto no/ SIGAFAT não foi preenchido !","Aviso")
	BREAK
EndiF

aAdd(aCab,{"C5_NUM",GetSXENum("SC5"),nil}) // Nro.do Pedido
aAdd(aCab,{"C5_TIPO","C"         	,nil}) // Tipo COMPLEMNTO
aAdd(aCab,{"C5_CLIENTE",SA1->A1_COD ,nil}) // Cod. Cliente
aAdd(aCab,{"C5_LOJACLI",SA1->A1_LOJA,nil}) // Loja Cliente
aAdd(aCab,{"C5_TIPOCLI","X"         ,nil}) // Tipo Cli**ente
aAdd(aCab,{"C5_CONDPAG",cCondPag	,nil})
aAdd(aCab,{"C5_MOEDA",1				,nil})
aAdd(aCab,{"C5_ESPECI1",'TON'		,nil})// 16/08/18 - Luis Felipe
aAdd(aCab,{"C5_TPCOMPL",'1'   		,nil})// 16/08/18 - Luis Felipe
aAdd(aCab,{"C5_SLENVT", '2'   		,nil})// 16/08/18 - Luis Felipe
aAdd(aCab,{"C5_RET20G", 'N'   		,nil})// 16/08/18 - Luis Felipe

aCab := xOrdVetSX3(aCab,"SC5")

aItens := {}
cItem := "01"
lMSErroAuto := .F.
//lMSHelpAuto := .F. // para mostrar os erros na tela

/*  // 17/03/17 - Luis Felipe 
dbSelectArea("EE9")
EE9->(dbSetOrder(2))
EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+cPedido))
*/

dbSelectArea("SC6")
SC6->(dbSetOrder(1))
SC6->(dbSeek(xFilial("SC6")+EE7->EE7_PEDFAT+EE8->EE8_FATIT))

If lSegUnMed
	
	//aAdd(aReg,{"C6_UNSVEN",0,nil}) //DFS - 22/09/2011 - Inclusão de tratamento para segunda unidade de medida quando o PE for alterado
	Fat2SegUnidade(@xcUnidade, @xnQtdVen, @xnPrcUniMed, @xnSaldo)
EndIf

If ( xnMoeda <> 1 )
	xnPrcUniMed := xMoeda(xnPrcUniMed,xnMoeda,1,dDataBase)
	
	IF xnPrcUniMed <= 0
		MsgStop("Taxa do dia não cadastrada para a moeda: "+ALLTRIM(STR(xnMoeda))+". Processo cancelado!")
		Break
	ENDIF
	
EndIf

aReg := {}
aAdd(aReg,{"C6_NUM"    ,aCab[1][2]     ,NIL	}) // Pedido
aAdd(aReg,{"C6_ITEM"   ,cItem          ,NIL	}) // Item sequencial
aAdd(aReg,{"C6_PRODUTO",PADR(EE9->EE9_COD_I,TAMSX3("C6_PRODUTO")[1]),NIL	}) // Cod.Item
// aAdd(aReg,{"C6_DESCRI" ,cDesc,NIL			}) // Descricao do Produto // 16/08/18 - Luis Felipe
// aAdd(aReg,{"C6_UM",xcUnidade,nil			}) // Unidade // 16/08/18 - Luis Felipe
// aAdd(aReg,{"C6_SEGUM",cSegum,nil			}) // cSegum // 17/02/14 - Luis Felipe Nascimento
// aAdd(aReg,{"C6_QTDVEN",0,nil				}) // Quantidade// 16/08/18 - Luis Felipe
// aAdd(aReg,{"C6_QTDLIB",0,nil				}) // Quantidade liberada// 16/08/18 - Luis Felipe
aAdd(aReg,{"C6_PRCVEN",xnPrcUniMed,nil		}) // Preco Unit.
// aAdd(aReg,{"C6_PRUNIT",xnPrcUniMed,nil		}) // Preco Unit.// 16/08/18 - Luis Felipe
aAdd(aReg,{"C6_VALOR" ,xnPrcUniMed,nil		}) // Valor Tot.
// aAdd(aReg,{"C6_CLI"   ,SA1->A1_COD,NIL		}) // Obrigatorio // 16/08/18 - Luis Felipe
// aAdd(aReg,{"C6_LOJA"  ,SA1->A1_LOJA,NIL		}) // Obrigatorio // 16/08/18 - Luis Felipe
aAdd(aReg,{"C6_TES" , cTES ,Nil				}) // Tipo de Saida ...
// aAdd(aReg,{"C6_CF"  , cCf  ,Nil				}) // Codigo Fiscal ... // 16/08/18 - Luis Felipe
// aAdd(aReg,{"C6_CLASFIS"  , cClasFis  ,Nil	}) // Classificação Fiscal ... // 16/08/18 - Luis Felipe
aAdd(aReg,{"C6_LOCAL"   ,SC6->C6_LOCAL,nil	}) // Almoxarifado
// aAdd(aReg,{"C6_LOTECTL" ,SC6->C6_LOTECTL,NIL}) // Lote // 16/08/18 - Luis Felipe
// aAdd(aReg,{"C6_DTVALID" ,SC6->C6_DTVALID,NIL}) // Lote // 16/08/18 - Luis Felipe
aAdd(aReg,{"C6_ENTREG"  ,dDataBase     ,nil	}) // Dt.Entrega
aAdd(aReg,{"C6_NFORI"   ,EE9->EE9_NF   ,nil	}) // NF. Origem.
aAdd(aReg,{"C6_SERIORI" ,EE9->EE9_SERIE,nil	}) // Serie Origem.
aAdd(aReg,{"C6_ITEMORI" ,'01'          ,nil	}) // Item Origem.
aAdd(aReg,{"C6_XCLVL"   ,SC6->C6_XCLVL,nil	}) // Classe de valor

aReg := xOrdVetSX3(aReg,"SC6")

aAdd(aItens,aClone(aReg))


IF lMSErroAuto
	Break
Else
	//lMSErroAuto := ! AVMata410(aCab, aItens, 3)
	DBSELECTAREA("SC5")
	Set Filter To
	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItens,3)
Endif

IF !lMSErroAuto

	SC5->(RecLock("SC5",.F.))
	SC5->C5_PEDEXP := SC5->C5_NUM
	SC5->C5_XMENNOT:= cXMENNOT+" - "+Alltrim(xMennota)
	SC5->C5_NAVIO  := EEC->EEC_PREEMB // 13/08/18 - Luis Felipe
	SC5->(MsUnlock())
	
	**** Conforme Dpto Fiscal Nao irá incluir a nota automaticamente
	*****************************************************************
	//Pergunte("MT460A",.F.)
	
	//xIncNota(aCAB[1,2],cSerieNF,EEC->EEC_PREEMB)
	********* Luiz Fernando - 12/06/15
	*****************************************************************
	
	//cria/atualiza parâmetro para número da invoice complementar
//	xAtuSX6(1) // 21/08/18 - Luis Felipe 
	
	EEC->(RecLock("EEC",.F.))
	EEC->EEC_PEDEMB   := aCAB[1,2]
	EEC->EEC_XNFCP    := " " // SF2->F2_DOC -- Luiz Fernando - 15/06/15
	EEC->EEC_XVLNF    := nValor
	EEC->EEC_XINVCP   := Alltrim(EEC->EEC_NRINVO)+"C" // cInvCompl // 21/08/18 - Luis Felipe 
	EEC->(MsUnlock())
	
	cNota := "" //SF2->F2_DOC
	
	//inclui/exclui itens embarque
	xItEmb(1)
	
	//inclui/exclui pedido de exportação
	xPedExp(1)
	
	//inclui/exclui invoice
	xInvoice(1)
	
	//inclui/exclui precificação
	xPrecific(1)
	
	//cria/atualiza parâmetro para número da invoice complementar
//	xAtuSX6(3) // 21/08/18 - Luis Felipe 
	
	// cria titulo no financeiro  // 16/08/18 - Luis Felipe
	xFinanSE1(1)
	
	lRet := .T.
	
Else
	
	MostraErro()
	Break
	
Endif

End Sequence

RestOrd(aOrd)

Return(lRet)

//----------------------------------------------------------------------------
Static Function GetSerie(cPreemb)

Local cSerie := ""
Local aOrd   := SaveOrd("EE9")

Begin Sequence
// Regra padrão: Puxar a mesma série da nota original de saída.
EE9->(dbSetOrder(2))
IF EE9->(dbSeek(xFilial()+cPreemb))
	cSerie := EE9->EE9_SERIE
Endif
End Sequence

RestOrd(aOrd,.T.)

Return cSerie

//----------------------------------------------------------------------------
Static Function TemNFS(cPreemb)

Local lRet   := .F.
Local aOrd   := SaveOrd("EE9")

Begin Sequence
EE9->(dbSetOrder(2))
IF EE9->(dbSeek(xFilial()+cPreemb))
	IF !Empty(EE9->EE9_NF)
		lRet := .T.
	Endif
Endif
End Sequence

RestOrd(aOrd,.T.)

Return lRet

//----------------------------------------------------------------------------
Static Function EstornaNF(cSerie, cNota, cPedido)

Local lRet   := .F.
Local aNfs

Begin Sequence
Private cMsgErr := ""
aNfs := {}
aAdd(aNfs,{xFilial("SF2"), cNota, cSerie, cPedido})
IF EstNF(aNfs)
	lRet := .T.
Endif
IF !Empty(cMsgErr)
	EECView(cMsgErr)
Endif
End Sequence

Return lRet

//------------------------------------------------------------------------
Static Function EstNF(aNfs)

Local i
Local lRet := .T.

Local aRegSD2 := {}, aRegSE1 := {}, aRegSE2 := {}
Local lContinue := .T.

Local cFilOld := cFilAnt

Private lMSErroAuto := .F.
Private lMSHelpAuto := .F.

Private aCabec := {}

Begin Sequence
For i:=1 To Len(aNFs)
	cFilAnt := aNfs[i,1]
	
	lContinue := .T.
	
	Begin Transaction
	
	IF !Empty(aNfs[i,2])
		IF ! SF2->(dbSeek(aNfs[i,1]+aNfs[i,2]+aNfs[i,3]))
			AddMsg("Erro no estorno da NF: "+aNfs[I,2]+" da Serie "+aNfs[i,3]+". Nota fiscal não encontrada na base de dados. Verifique.")
			lRet := .F.
			lContinue := .F.
			DisarmTransaction()
			Break
		Endif
		
		aRegSD2 := {}
		aRegSE1 := {}
		aRegSE2 := {}
		
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(aNfs[i,1]+aNfs[i,3]+aNfs[i,2]))
		While SE1->(!Eof() .And. E1_FILIAL == aNfs[i,1] .And. E1_PREFIXO == aNfs[i,3] .And. E1_NUM == aNfs[i,2])
			IF Empty(SE1->E1_BAIXA) .And. SE1->E1_SITUACA <> "0"
				IF SE1->(RecLock("SE1",.F.)) .And. SE1->E1_VALOR = SE1->E1_SALDO
					SE1->E1_SITUACA := "0" // Força jogar na carteira.
					SE1->(MsUnlock())
				Endif
			Endif
			
			SE1->(dbSkip())
		Enddo
		
		If MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)
			PcoIniLan("000102")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estorna o documento de saida                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))
			
			PcoFinLan("000102")
			SF2->(dbSetOrder(1))
			IF SF2->(dbSeek(aNfs[i,1]+aNfs[i,2]+aNfs[i,3]))
				AddMsg("Erro no estorno da NF: "+aNfs[I,2]+" da Serie "+aNfs[i,3]+" verifique.")
				lRet := .F.
				lContinue := .F.
				DisarmTransaction()
				Break
			Endif
		Else
			AddMsg("Erro no estorno da NF: "+aNfs[I,2]+" da Serie "+aNfs[i,3]+" verifique.")
			lRet := .F.
			lContinue := .F.
			DisarmTransaction()
			Break
		EndIf
	Endif
	
	IF lContinue
		IF !Empty(aNfs[i,4]) .And. SC5->(dbSeek(aNfs[i,1]+aNfs[i,4]))
			aCabec := {}
			aadd(aCabec,{"C5_NUM"   , aNfs[i,4]  , Nil})
			
			SC9->(dbSetOrder(1))
			SC9->(dbSeek(xFilial()+aNfs[i,4]))
			While SC9->(!Eof() .And. C9_FILIAL == xFilial("SC9") .And. C9_PEDIDO == aNfs[i,4])
				SC9->(a460Estorna())
				SC9->(dbSkip())
			Enddo
			
			lMSErroAuto := .F.
			MsExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,{},5)
			
			If lMsErroAuto
				MostraErro()
				AddMsg("Erro no estorno do Pedido "+aNfs[i,4]+" na filial "+aNfs[i,1])
				lRet := .F.
			Else
				IF SC5->(dbSeek(aNfs[i,1]+aNfs[i,4]))
					AddMsg("Erro no estorno do Pedido "+aNfs[i,4]+" na filial "+aNfs[i,1])
					lRet := .F.
				Endif
			EndIf
		Endif
	Endif
	
	//cria/atualiza parâmetro para número da invoice complementar
// 	xAtuSX6(2) // 21/08/18 - Luis Felipe 
	
	//inclui/exclui pedido de exportação
	xPedExp(2)
	
	//inclui/exclui itens embarque
	xItEmb(2)
	
	//inclui/exclui invoice
	xInvoice(2)
	
	//inclui/exclui precificação
	xPrecific(2)
	
	End Transaction
	
	MsUnlockAll()
Next i

IF !lRet
	Break
Endif

End Sequence

cFilAnt := cFilOld

Return lRet

//------------------------------------------------------------------------
Static Function AddMsg(cMsg)

IF Type("cMsgErr") == "C"
	IF !Empty(cMsgErr)
		cMsgErr += CRLF
	Endif
	cMsgErr += cMsg
Endif

Return NIL

//------------------------------------------------------------------------
Static Function xItEmb(lAction)

LOCAL aTmp     := {}
DEFAULT lAction := 1

IF lAction == 1
	
	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
	
	dbSelectArea("EE9")
	EE9->(dbSetOrder(2))
	EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB))
	WHILE EE9->(!EOF()) .AND. EE9->EE9_FILIAL == xFilial("EE9") .AND. EE9->EE9_PREEMB == EEC->EEC_PREEMB
		
		xcSeqEmb := EE9->EE9_SEQEMB
		EE9->(dbSKIP())
	ENDDO
	xcSeqEmb := Str( Val(xcSeqEmb)+1,tamSx3("EE9_SEQEMB")[1] )
	
	dbSelectArea("EE9")
	EE9->(dbSetOrder(2))
	EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+cPedido))
	*-----------------------------------------------------------------------------------*
	*Transmite campos para o array
	*-----------------------------------------------------------------------------------*
	
	For nX:= 1 To FCount()
		Aadd(aTmp, {fieldname(nX), fieldget(nX)})
	Next
	
	*-----------------------------------------------------------------------------------*
	*Gera registro de Revisao, copiando o registro atual
	*-----------------------------------------------------------------------------------*
	
	DbSelectArea("EE9")
	RecLock("EE9",.T.)
	For i:=1 to Len(aTmp)
		&(aTmp[i][1]) :=  aTmp[i][2]
	Next i
	
	EE9->EE9_FILIAL	    := XFILIAL("EE9")
	EE9->EE9_SEQEMB	    := xcSeqEmb
	EE9->EE9_PEDIDO	    := SC5->C5_NUM
	EE9->EE9_PRECO	    := EEC->EEC_XVLNF
	EE9->EE9_SLDINI	    := 1 // 13/08/18 - Luis Felipe
	EE9->EE9_QE	        := 0
	EE9->EE9_QTDEM1	    := 0
	EE9->EE9_PRECOI	    := EEC->EEC_XVLNF
	EE9->EE9_PSLQUN     := 0
	EE9->EE9_PSBRUN	    := 0
	EE9->EE9_PSBRTO	    := 0
	EE9->EE9_PSLQTO	    := 0
	EE9->EE9_PRCTOT	    := EEC->EEC_XVLNF
	EE9->EE9_PRCINC	    := EEC->EEC_XVLNF
	EE9->EE9_NF	        := " " //SF2->F2_DOC - Luiz Fernando
	EE9->EE9_SERIE      := " " //SF2->F2_SERIE - Luiz Fernando
	EE9->EE9_PRCUN	    := EEC->EEC_XVLNF
	EE9->EE9_TES  	    := SC6->C6_TES
	EE9->EE9_CF 	    := SC6->C6_CF
	
	MsunLock()
	
ELSE
	
	DbSelectArea("EXP")
	EXP->(dbSetOrder(1))
	IF EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB+PADR(EEC->EEC_XINVCP,TAMSX3("EXP_NRINVO")[1] )))
		
		dbSelectArea("EXR")
		EXR->(dbSetOrder(1))
		IF EXR->(dbSeek(xFilial("EXR")+EEC->EEC_PREEMB+EXP->EXP_NRINVO))
			
			dbSelectArea("EE9")
			EE9->(dbSetOrder(3))
			IF EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+EXR->EXR_SEQEMB))
				
				RecLock("EE9",.F.)
				("EE9")->(dbDelete())
				("EE9")->(MsUnlock())
				
			ENDIF
			
		ENDIF
		
	ENDIF
	
	
ENDIF

RETURN


//------------------------------------------------------------------------
Static Function xPedExp(lAction)

LOCAL aTmp := {}
DEFAULT lAction := 1

IF lAction == 1
	
	dbSelectArea("SC6")
	SC6->(dbSetOrder(1))
	SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))
	
	dbSelectArea("EE9")
	EE9->(dbSetOrder(2))
	EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+cPedido))
	
	dbSelectArea("EE7")
	EE7->(dbSetOrder(1))
	EE7->(dbSeek(xFilial("EE7")+cPedido))
	*-----------------------------------------------------------------------------------*
	*Transmite campos para o array
	*-----------------------------------------------------------------------------------*
	
	For nX:= 1 To FCount()
		Aadd(aTmp, {fieldname(nX), fieldget(nX)})
	Next
	
	*-----------------------------------------------------------------------------------*
	*Gera registro de Revisao, copiando o registro atual
	*-----------------------------------------------------------------------------------*
	
	DbSelectArea("EE7")
	RecLock("EE7",.T.)
	For i:=1 to Len(aTmp)
		&(aTmp[i][1]) :=  aTmp[i][2]
	Next i
	
	EE7->EE7_FILIAL	    := XFILIAL("EE7")
	EE7->EE7_KEY	    := 0
	EE7->EE7_TOTPED	    := EEC->EEC_XVLNF
	EE7->EE7_VLFOB	    := EEC->EEC_XVLNF
	EE7->EE7_FATURA	    := CRIAVAR("EE7_FATURA")
	EE7->EE7_BRUEMB	    := CRIAVAR("EE7_BRUEMB")
	EE7->EE7_PESLIQ	    := 0
	EE7->EE7_PESBRU	    := 0
	EE7->EE7_PEDFAT	    := SC5->C5_NUM
	EE7->EE7_PEDIDO	    := SC5->C5_NUM
	EE7->EE7_DTPROC	    := DDATABASE
	EE7->EE7_DTPEDI	    := DDATABASE
	EE7->EE7_FIM_PE	    := DDATABASE
	EE7->EE7_STATUS	    := "B"
	EE7->EE7_STTDES     := "Aguardando Faturamento"
	
	MsunLock()
	
	aTmp := {}
	
	dbSelectArea("EE9")
	EE9->(dbSetOrder(2))
	EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+cPedido))
	
	dbSelectArea("EE8")
	EE8->(DbSetOrder(1))
	EE8->(Dbseek(xFilial("EE8")+cPedido+EE9->EE9_SEQUEN))
	*-----------------------------------------------------------------------------------*
	*Transmite campos para o array
	*-----------------------------------------------------------------------------------*
	
	For nX:= 1 To FCount()
		Aadd(aTmp, {fieldname(nX), fieldget(nX)})
	Next
	
	*-----------------------------------------------------------------------------------*
	*Gera registro de Revisao, copiando o registro atual
	*-----------------------------------------------------------------------------------*
	
	DbSelectArea("EE8")
	RecLock("EE8",.T.)
	For i:=1 to Len(aTmp)
		&(aTmp[i][1]) :=  aTmp[i][2]
	Next i
	
	EE8->EE8_FILIAL	    := XFILIAL("EE8")
	EE8->EE8_SLDINI	    := 0
	EE8->EE8_QE 	    := 0
	EE8->EE8_QTDEM1	    := 0
	EE8->EE8_PEDIDO	    := SC5->C5_NUM
	EE8->EE8_PRECO 	    := EEC->EEC_XVLNF
	EE8->EE8_DTPREM 	:= DDATABASE
	EE8->EE8_DTENTR 	:= DDATABASE
	EE8->EE8_PRECOI	    := EEC->EEC_XVLNF
	EE8->EE8_PRCTOT	    := EEC->EEC_XVLNF
	EE8->EE8_SLDATU	    := 0
	EE8->EE8_PSLQUN     := 0
	EE8->EE8_PSLQTO     := 0
	EE8->EE8_PSBRTO     := 0
	EE8->EE8_TES  	    := SC6->C6_TES
	EE8->EE8_CF 	    := SC6->C6_CF
	EE8->EE8_PRCINC	    := EEC->EEC_XVLNF
	EE8->EE8_PRCUN 	    := EEC->EEC_XVLNF
	
	MsunLock()
	
ELSE
	
	DbSelectArea("EXP")
	EXP->(dbSetOrder(1))
	IF EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB+PADR(EEC->EEC_XINVCP,TAMSX3("EXP_NRINVO")[1] )))
		
		dbSelectArea("EXR")
		EXR->(dbSetOrder(1))
		IF EXR->(dbSeek(xFilial("EXR")+EEC->EEC_PREEMB+EXP->EXP_NRINVO))
			
			dbSelectArea("EE9")
			EE9->(dbSetOrder(3))
			IF EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+EXR->EXR_SEQEMB))
				
				dbSelectArea("EE7")
				EE7->(dbSetOrder(1))
				IF EE7->(dbSeek(xFilial("EE7")+EE9->EE9_PEDIDO))
					
					RecLock("EE7",.F.)
					("EE7")->(dbDelete())
					("EE7")->(MsUnlock())
					
				ENDIF
				
				dbSelectArea("EE8")
				EE8->(dbSetOrder(1))
				IF EE8->(dbSeek(xFilial("EE8")+EE9->EE9_PEDIDO))
					
					RecLock("EE8",.F.)
					("EE8")->(dbDelete())
					("EE8")->(MsUnlock())
					
				ENDIF
				
			ENDIF
			
		ENDIF
		
	ENDIF
	
ENDIF


RETURN


//------------------------------------------------------------------------
Static Function xInvoice(lAction)

LOCAL aTmp      := {}
LOCAL xcInvTMP  := ""
DEFAULT lAction := 1

IF lAction == 1
	
	dbSelectArea("EE9")
	EE9->(dbSetOrder(2))
	EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+cPedido))
	
	dbSelectArea("EXP")
	EXP->(dbSetOrder(1))
	EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB))
	
	xcInvTMP  := EXP->EXP_NRINVO
	*-----------------------------------------------------------------------------------*
	*Transmite campos para o array
	*-----------------------------------------------------------------------------------*
	
	For nX:= 1 To FCount()
		Aadd(aTmp, {fieldname(nX), fieldget(nX)})
	Next
	
	*-----------------------------------------------------------------------------------*
	*Gera registro de Revisao, copiando o registro atual
	*-----------------------------------------------------------------------------------*
	
	DbSelectArea("EXP")
	RecLock("EXP",.T.)
	For i:=1 to Len(aTmp)
		&(aTmp[i][1]) :=  aTmp[i][2]
	Next i
	
	EXP->EXP_FILIAL	    := XFILIAL("EXP")
	EXP->EXP_NRINVO	    := Alltrim(EEC->EEC_NRINVO)+"C" // cInvCompl // 21/08/18 - Luis Felipe 
	EXP->EXP_DTINVO 	:= DDATABASE
	EXP->EXP_VLFOB  	:= EEC->EEC_XVLNF
	EXP->EXP_TOTPED	    := EEC->EEC_XVLNF
	EXP->EXP_PESLIQ	    := 0
	EXP->EXP_PESBRU	    := 0
	
	MsunLock()
	
	aTmp := {}
	
	dbSelectArea("EE9")
	EE9->(dbSetOrder(2))
	EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+cPedido))
	
	dbSelectArea("EXP")
	EXP->(dbSetOrder(1))
	EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB))
	
	dbSelectArea("EXR")
	EXR->(dbSetOrder(1))
	EXR->(dbSeek(xFilial("EXR")+EEC->EEC_PREEMB+xcInvTMP))
	*-----------------------------------------------------------------------------------*
	*Transmite campos para o array
	*-----------------------------------------------------------------------------------*
	
	For nX:= 1 To FCount()
		Aadd(aTmp, {fieldname(nX), fieldget(nX)})
	Next
	
	*-----------------------------------------------------------------------------------*
	*Gera registro de Revisao, copiando o registro atual
	*-----------------------------------------------------------------------------------*
	
	DbSelectArea("EXR")
	RecLock("EXR",.T.)
	For i:=1 to Len(aTmp)
		&(aTmp[i][1]) :=  aTmp[i][2]
	Next i
	
	EXR->EXR_FILIAL	    := XFILIAL("EXR")
	EXR->EXR_NRINVO	    := Alltrim(EEC->EEC_NRINVO)+"C" // cInvCompl // 21/08/18 - Luis Felipe 
	EXR->EXR_SEQEMB	    := xcSeqEmb
	EXR->EXR_SLDINI	    := 0
	EXR->EXR_PRCTOT 	:= EEC->EEC_XVLNF
	EXR->EXR_PRCINC  	:= EEC->EEC_XVLNF
	EXR->EXR_PSBRTO	    := 0
	EXR->EXR_PSLQTO	    := 0
	
	MsunLock()
	
	
ELSE
	
	DbSelectArea("EXP")
	EXP->(dbSetOrder(1))
	IF EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB+PADR(EEC->EEC_XINVCP,TAMSX3("EXP_NRINVO")[1] )))
		
		dbSelectArea("EXR")
		EXR->(dbSetOrder(1))
		IF EXR->(dbSeek(xFilial("EXR")+EEC->EEC_PREEMB+EXP->EXP_NRINVO))
			
			RecLock("EXR",.F.)
			("EXR")->(dbDelete())
			("EXR")->(MsUnlock())
			
		ENDIF
		
		RecLock("EXP",.F.)
		("EXP")->(dbDelete())
		("EXP")->(MsUnlock())
		
	ENDIF
	
	
ENDIF

RETURN

//------------------------------------------------------------------------
Static Function xPrecific(lAction)

LOCAL aTmp     := {}
Local xcContra := ""
Local xcPeriod := ""
LOCAL xPos     := 0
Local xcProd   := ""
LOCAL cQuery   := ""
DEFAULT lAction := 1

IF lAction == 1
	
	dbSelectArea("EE9")
	EE9->(dbSetOrder(2))
	EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+cPedido))
	
	xcProd := EE9->EE9_COD_I
	xPos := AT("-",xcProd)
	
	xcContra := Alltrim(SubStr(xcProd , 1, xPos-1 ))
	xcContra := PADR(xcContra,TAMSX3("Z5_CONTRA")[1] )
	
	xcPeriod := Alltrim(SubStr(xcProd , xPos+1, Len(xcProd)-xPos ))
	xcPeriod := PADR(xcPeriod,TAMSX3("Z5_PERDE")[1] )
	
	dbSelectArea("SZ5")
	SZ5->(DBSETORDER(1))
	IF SZ5->(DBSEEK(xFilial("SZ5")+xcContra+xcPeriod))
		
		cQuery := "Select MAX(SZ6.Z6_ITEM) as Z6_ITEM from "+ RetSQLName("SZ6") +" SZ6 "
		cQuery += "where SZ6.Z6_FILIAL = '"+xFilial("SZ6")+"' AND "
		cQuery += "SZ6.Z6_CONTRA = '"+ SZ5->Z5_CONTRA +"' AND "
		cQuery += "SZ6.Z6_PERDE = '"+ SZ5->Z5_PERDE +"' AND "
		cQuery += "SZ6.D_E_L_E_T_ = ' '"
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SZ6TMP",.F.,.T.)
		
		cItem := Soma1(SZ6TMP->Z6_ITEM)
		
		SZ6TMP->(dbCloseArea())
		
		dbSelectArea("SZ6")
		dbSetOrder(1)  //  ORDENADO POR FILIAL + NUMERO DO CONTRATO
		DbSeek( xFilial("SZ6")+SZ5->Z5_CONTRA+SZ5->Z5_PERDE )
		
		*-----------------------------------------------------------------------------------*
		*Transmite campos para o array
		*-----------------------------------------------------------------------------------*
		
		For nX:= 1 To FCount()
			Aadd(aTmp, {fieldname(nX), CriaVar(fieldname(nX))})
		Next
		
		*-----------------------------------------------------------------------------------*
		*Gera registro de Revisao, copiando o registro atual
		*-----------------------------------------------------------------------------------*
		
		DbSelectArea("SZ6")
		RecLock("SZ6",.T.)
		For i:=1 to Len(aTmp)
			&(aTmp[i][1]) :=  aTmp[i][2]
		Next i
		
		SZ6->Z6_FILIAL  := xFilial("SZ6")
		SZ6->Z6_CONTRA  := SZ5->Z5_CONTRA
		SZ6->Z6_PERDE   := SZ5->Z5_PERDE
		SZ6->Z6_VLFINAL := EEC->EEC_XVLNF
		SZ6->Z6_ITEM    := cItem
		SZ6->Z6_TIPOPRE := "4"
		SZ6->Z6_XINVCP  := Alltrim(EEC->EEC_NRINVO)+"C" // cInvCompl // 21/08/18 - Luis Felipe 
		
		MsunLock()
		
	ENDIF
	
ELSE
	
	dbSelectArea("EE9")
	EE9->(dbSetOrder(2))
	EE9->(dbSeek(xFilial("EE9")+EEC->EEC_PREEMB+cPedido))
	
	xcProd := EE9->EE9_COD_I
	xPos := AT("-",xcProd)
	
	xcContra := Alltrim(SubStr(xcProd , 1, xPos-1 ))
	xcContra := PADR(xcContra,TAMSX3("Z5_CONTRA")[1] )
	
	xcPeriod := Alltrim(SubStr(xcProd , xPos+1, Len(xcProd)-xPos ))
	xcPeriod := PADR(xcPeriod,TAMSX3("Z5_PERDE")[1] )
	
	dbSelectArea("SZ5")
	SZ5->(DBSETORDER(1))
	IF SZ5->(DBSEEK(xFilial("SZ5")+xcContra+xcPeriod))
		
		dbSelectArea("SZ6")
		dbSetOrder(1)  //  ORDENADO POR FILIAL + NUMERO DO CONTRATO
		IF DbSeek( xFilial("SZ6")+SZ5->Z5_CONTRA+SZ5->Z5_PERDE )
			
			While SZ6->( !EOF() ) .AND. SZ6->Z6_FILIAL+SZ6->Z6_CONTRA+SZ6->Z6_PERDE == XFILIAL("SZ6")+SZ5->Z5_CONTRA+SZ5->Z5_PERDE
				
				IF SZ6->Z6_XINVCP  == PADR(EEC->EEC_XINVCP,TAMSX3("Z6_XINVCP")[1] )
					
					RecLock("SZ6",.F.)
					dbDelete()
					MsUnlock()
					
				ENDIF
				
				SZ6->(dbSkip())
			End
			
		ENDIF
		
	ENDIF
	
ENDIF

RETURN


//---------------------------------------------------------------------------
/* STATIC FUNCTION xAtuSX6(lAction) // 21/08/18 - Luis Felipe  
DEFAULT lAction := 1

IF lAction == 1
	dbSelectArea("SX6")
	dbSetOrder(1)
	If ! dbSeek( XFILIAL("SX6") + "MV_XINVCPL" )
		RecLock("SX6",.T.)
		SX6->X6_VAR 		:= "MV_XINVCPL"
		SX6->X6_TIPO		:= "C"
		SX6->X6_CONTEUD	    := PADR( SOMA1("INVC00000"), TAMSX3("E1_NUM")[1])
		SX6->X6_CONTSPA	    := SX6->X6_CONTEUD
		SX6->X6_CONTENG	    := SX6->X6_CONTEUD
		SX6->X6_DESCRIC	    := "Controla numeracao proxima invoice complementar"
		MsUnlock()
		
		cInvCompl := SX6->X6_CONTEUD
		
	ELSE
		cInvCompl := SX6->X6_CONTEUD
	EndIf
	
ELSEIF lAction == 3
	
	dbSelectArea("SX6")
	dbSetOrder(1)
	If dbSeek( XFILIAL("SX6") + "MV_XINVCPL" )
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD	    := PADR( SOMA1(ALLTRIM(cInvCompl)), TAMSX3("E1_NUM")[1])
		MsUnlock()
		
		//cInvCompl := SX6->X6_CONTEUD
	EndIf
	
ELSE
	
	DbSelectArea("EXP")
	EXP->(dbSetOrder(1))
	EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB+PADR(EEC->EEC_XINVCP,TAMSX3("EXP_NRINVO")[1] )))
	
	cInvCompl := EEC->EEC_XINVCP
	
ENDIF

RETURN
*/

//---------------------------------------------------------------------------------------------

STATIC FUNCTION xFinanSE1(lAction)

LOCAL   lRet        := .T.
LOCAL aRotAuto      := {}
Private lMSErroAuto := .F.
Private lMSHelpAuto := .F.

DEFAULT lAction := 1

Begin Sequence

IF lAction == 1
	
	BEGIN TRANSACTION
	
	dbSelectArea("EXP")
	EXP->(dbSetOrder(1))
	EXP->(dbSeek(xFilial("EXP")+EEC->EEC_PREEMB))
	
	AAdd( aRotAuto, { "E1_NUM"    , EEC->EEC_XINVCP, NIL } )
	AAdd( aRotAuto, { "E1_PREFIXO", "EEC", NIL 		  } )
	AAdd( aRotAuto, { "E1_NATUREZ", "0072", NIL 	  } )
	AAdd( aRotAuto, { "E1_TIPO"   , "INV", NIL 		  } )
	AAdd( aRotAuto, { "E1_CLIENTE", SA1->A1_COD, NIL  } )
	AAdd( aRotAuto, { "E1_LOJA"   , SA1->A1_LOJA, NIL } )
	AAdd( aRotAuto, { "E1_VALOR"  , nValorTot, NIL 	  } )
	AAdd( aRotAuto, { "E1_EMISSAO", EEC->EEC_DTEMBA, NIL	  } )
	AAdd( aRotAuto, { "E1_VENCTO" , EEC->EEC_DTEMBA, NIL	  } )
	AAdd( aRotAuto, { "E1_VENCREA", DataValida( EEC->EEC_DTEMBA ), NIL } )
	AADD( aRotAuto, { "E1_VENCORI", DataValida( EEC->EEC_DTEMBA,.T.),NIL })
	AADD( aRotAuto, { "E1_MOEDA"  , POSICIONE("SYF",1,XFILIAL("SYF")+EEC->EEC_MOEDA,"YF_MOEFAT"), NIL})
	AAdd( aRotAuto, { "E1_VLCRUZ" , xMoeda(nValorTot,2,1,EEC->EEC_DTEMBA), NIL } )
	AADD( aRotAuto, { "E1_ORIGEM" , "FINA040"     , NIL})
	
	MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3)
	
	If lMsErroAuto
		
		MostraErro()
		AddMsg("Erro na inclusão do título de invoice no financeiro "+EEC->EEC_XINVCP+" na filial "+xfilial("SE1"))
		
		lRet := .F.
		DisarmTransaction()
		Break
	EndIf
	
	END TRANSACTION
	
ELSE

ENDIF


IF !lRet
	Break
Endif

End Sequence


RETURN

************************************************************************************************************************************************8
STATIC FUNCTION xIncNota(cPedido,cSerieNF,cEmbarq)

Local   cQritem := ""
Local   ni      := 1
Local   nReg    := 0
Local   cPedNoIden := ""
Local   lRet    := .T.
Local   aNFs   := {}
Local   lExec  := .F.
Private cArea   := GetArea()
Private cArea2  := GetArea()
Private aPvlNfs := {}
Private xMarca  := GetMark(,"SF2","F2_OK")

If !EMPTY(cPedido)
	
	cQritem := ""
	cQritem += "SELECT C9_PEDIDO, C9_ITEM, C9_PRODUTO, C9_QTDLIB, C9_SEQUEN, R_E_C_N_O_ FROM "
	cQritem += RetSqlName("SC9") + "   "
	cQritem += "WHERE D_E_L_E_T_ = ' ' AND C9_FILIAL = '" + xFilial("SC9") + "' "
	cQritem += "AND C9_PEDIDO =  '" +cPedido+"' "
	cQritem += "AND C9_NFISCAL = ' ' AND C9_BLEST = ' ' AND C9_BLCRED = ' ' "
	cQritem += "ORDER BY C9_PEDIDO, C9_ITEM, C9_SEQUEN "
	
	If (Select("NFITEM") <> 0)
		dbSelectArea("NFITEM")
		("NFITEM")->(dbCloseArea())
	Endif
	
	TCQUERY cQritem NEW ALIAS "NFITEM"
	
	dbSelectArea("NFITEM")
	("NFITEM")->(dbGoTop())
	Count to nReg
	
	dbSelectArea("NFITEM")
	("NFITEM")->(dbGoTop())
	ProcREgua(nReg)
	While ("NFITEM")->(!Eof())
		
		cArea2  := GetArea()
		
		//IncProc("Processando pedido -> "+NFITEM->C9_PEDIDO+" item -> "+NFITEM->C9_ITEM+" - "+NFITEM->C9_PRODUTO)
		
		DbSelectArea ("SC9")
		DbSetOrder(1)
		DbGoTop()
		
		DbGoTo( NFITEM->R_E_C_N_O_ )
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)
		
		dbSelectArea("SC6")
		dbSetOrder(1)
		MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
		
		dbSelectArea("SB2")
		dbSetOrder(1)
		MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC9->C9_LOCAL)
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		MsSeek(xFilial("SF4")+SC6->C6_TES)
		
		dbSelectArea("SE4")
		dbSetOrder(1)
		MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)
		
		aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
		SC9->C9_ITEM,;
		SC9->C9_SEQUEN,;
		SC9->C9_QTDLIB,;
		SC9->C9_PRCVEN,;
		SC9->C9_PRODUTO,;
		SF4->F4_ISS=="S",;
		SC9->(RecNo()),;
		SC5->(RecNo()),;
		SC6->(RecNo()),;
		SE4->(RecNo()),;
		SB1->(RecNo()),;
		SB2->(RecNo()),;
		SF4->(RecNo()),;
		SB2->B2_LOCAL,;
		0,;
		SC9->C9_QTDLIB2})
		
		lExec  := .T.
		
		RestArea(cArea2)
		
		Dbselectarea("NFITEM")
		("NFITEM")->(Dbskip())
		
	Enddo
	
	If (Select("NFITEM") <> 0)
		dbSelectArea("NFITEM")
		("NFITEM")->(dbCloseArea())
	Endif
	
	If lExec  == .T.
		lRet := xGravaNFs(@aNFs,cSerieNF,cEmbarq)
	EndIf
	
EndIf

nReg    := 0
aPvlNfs := {}

RestArea(cArea)

RETURN

//-------------------------------------------------------------------------------------------------------------------------------
Static Function xGravaNFs(aNFs,cSerieNF,cEmbarq)

Local lRet   := .T.
Local lEnd   := .F.
lOCAL cNota  := ""

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaPvlNfs  ³                                                  ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inclusao de Nota fiscal de Saida atraves do PV liberado     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com os itens a serem gerados                   ³±±
±±³          ³ExpC2: Serie da Nota Fiscal                                 ³±±
±±³          ³ExpL3: Mostra Lct.Contabil                                  ³±±
±±³          ³ExpL4: Aglutina Lct.Contabil                                ³±±
±±³          ³ExpL5: Contabiliza On-Line                                  ³±±
±±³          ³ExpL6: Contabiliza Custo On-Line                            ³±±
±±³          ³ExpL7: Reajuste de preco na nota fiscal                     ³±±
±±³          ³ExpN8: Tipo de Acrescimo Financeiro                         ³±±
±±³          ³ExpN9: Tipo de Arredondamento                               ³±±
±±³          ³ExpLA: Atualiza Amarracao Cliente x Produto                 ³±±
±±³          ³ExplB: Cupom Fiscal                                         ³±±
±±³          ³ExpCC: Numero do Embarque de Exportacao                     ³±±
±±³          ³ExpBD: Code block para complemento de atualizacao dos titu- ³±±
±±³          ³       los financeiros.                                     ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

//IncProc("Faturando pedido(s)... ")
cNota := MaPvlNfs(aPvlNfs,cSerieNF, .T., .F., .T., .F., .F., 0, 0, .F., .F.,cEmbarq)

aPvlNfs := {}

Return(lRet)

****************************************************************************************************************************************

Static Function Fat2SegUnidade(cUnidade, nQuantidade, nPreco, nSaldo)
Default cUnidade:= ""
Default nQuantidade:= 0,;
nPreco     := 0,;
nSaldo     := 0

Begin Sequence

If SB1->B1_CONV == 0
	
	MsgStop("Fator Conversão do produto não cadastrado. Processo cancelado!")
	Break
	
EndIf

cUnidade  := SB1->B1_UM

//Será realizado a operação inversa para a conversão da quantidade
//If !(SB1->B1_TIPCONV == "M")  // GFP - 29/11/2012
If (SB1->B1_TIPCONV == "M")
	nQuantidade:= nQuantidade / SB1->B1_CONV
	nSaldo     := nSaldo / SB1->B1_CONV
	If SB1->B1_UM <> EE8->EE8_UNPRC
		nPreco     := Round(nPreco * SB1->B1_CONV, TAMSX3("C6_PRCVEN")[2])
	EndIf
Else
	nQuantidade:= nQuantidade * SB1->B1_CONV
	nSaldo     := nSaldo * SB1->B1_CONV
	If SB1->B1_UM <> EE8->EE8_UNPRC
		nPreco     := Round(nPreco / SB1->B1_CONV, TAMSX3("C6_PRCVEN")[2])
	EndIf
EndIf

End Sequence
Return Nil

**********************************************************************************************************************************

STATIC Function xOrdVetSX3(_aArray, cAliasSX3)

Local _aSX3Area := SX3->(GETAREA())
Local _aAux     := {}
Local _nPos     := 0
Local aCampos,nx

aCampos:= RetCampos(cAliasSX3,.T.)

If len(aCampos) > 0
	For nx := 1 to len(aCampos)
		//Acerta array com somente uma linha
		If (_nPos:= aScan(_aArray,{|x| Alltrim(x[1]) == Alltrim(aCampos[nx]) })) <> 0
			aadd(_aAux,aClone(_aArray[_nPos]))
		EndIf
	Next nx
else
	_aAux := _aArray
Endif


RESTAREA(_aSX3Area)

Return(_aAux) 

// 17/03/2017 - Luis Felipe Nascimento -   Inicio

*'--------------------'*
Static Function fDocs()
*'--------------------'*

Local _aArea        := GetArea()
Local nLastKey      := 0
Local cArqQry1 		:= GetNextAlias()
Local cQuery		:= ""
Local oOk 	   		:= LoadBitmap( GetResources(), "LBOK"       )
Local oNo 	   		:= LoadBitmap( GetResources(), "LBNO"       )
Local lAllMark		:= .F.	// Seleciona todos os itens.   
Local oAllMark     
Local oInverte
Local lRet			:=  .f.
Private _oTela, oMark, _cMark
Private lInverte    := .F.
Private _lOK        := .F.
Private oDlg
Private oCombo
Private nCombo 		:= "1"
Private l_Ok 		:= .F.
Private aAmb        := {"1 = Finame","2 = Ativo","3 = Ambos","4 = Comprador"}
Private lTpAlc      := .F.
Private _nJ	      	:= 0
Private aListBox1	:= {}
Private cNumMe		:= ""
Private oListBox1
Private oFont		:= TFont():New("Arial",,14,,.T.)

*'------------------------------------------------------'*
*'Query para filtrar os NFS que podem ser complementadas 
*'------------------------------------------------------'*
cQuery := " SELECT EE9_PREEMB,EE9_NF,EE9_SERIE,EE9_PEDIDO,EE9_COD_I"
cQuery += " FROM " + RetSqlName("EE9")+" EE9 "
cQuery += " WHERE EE9_FILIAL = '" + xFilial("EE9") + "' "
cQuery += " AND   EE9_PREEMB = '" + EEC->EEC_PREEMB + "' "
cQuery += " AND EE9.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY EE9_PEDIDO,EE9_NF"

*--------------------------------------*
*** Verifica se o alias esta em uso
*--------------------------------------*
If Select( cArqQry1) > 0
	dbSelectArea( cArqQry1 )
	dbCloseArea()
EndIf

*--------------------------------------------*
*** Cria o alias executando a query
*--------------------------------------------*
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cArqQry1 , .F., .T.)

*---------------------------------------------------*
***Compatibiliza os campos de acordo com a TopField
*---------------------------------------------------*
aEval( EE9->(dbStruct()),{|x| If(x[2]!="C", TcSetField(cArqQry1,AllTrim(x[1]),x[2],x[3],x[4]),Nil)})

DbSelectArea(cArqQry1)
dbGoTop()

If !(cArqQry1)->(Eof())
	//Preenche o ListBox 
	While !(cArqQry1)->(Eof())
		Aadd(aListBox1,{.F.,(cArqQry1)->EE9_PREEMB,(cArqQry1)->EE9_NF,(cArqQry1)->EE9_SERIE,(cArqQry1)->EE9_PEDIDO,(cArqQry1)->EE9_COD_I})
		(cArqQry1)->(DbSkip())
	Enddo

	// CRIA INTERFACE
	DEFINE MSDIALOG _oTela From 350,000 To 525,600 TITLE "[ NF Complementar s/ Documentos Embarcados ] - [ EDFA020.prw ]" PIXEL

	//LIN INI,COLUNA INI                                                                    //COL FIM,LIN FIM
	@ 005,005 ListBox oListBox1 Fields HEADER "","Embarque","Doc. Saida","Serie","Pedido","Contrato" Size 295,065 Of oDlg Pixel;
	ColSizes 10,30,30,50,50,50,40,40,50;
	On DBLCLICK ( aListBox1[oListBox1:nAt,1] := !(aListBox1[oListBox1:nAt,1]), oListBox1:Refresh() )
	
	oListBox1:SetArray(aListBox1)
	// Cria ExecBlocks das ListBoxes
	oListBox1:bLine := {|| {;
	Iif(aListBox1[oListBox1:nAT,01],oOk,oNo),;
	aListBox1[oListBox1:nAT,02],;
	aListBox1[oListBox1:nAT,03],;
	aListBox1[oListBox1:nAT,04],;
	aListBox1[oListBox1:nAT,05],;
	aListBox1[oListBox1:nAT,06]	}}
	
	DEFINE SBUTTON FROM 073,235 Type  1 ENABLE OF _oTela ACTION( _lOK := .T., _oTela:End()) PIXEL 
	DEFINE SBUTTON FROM 073,265 Type  2 ENABLE OF _oTela ACTION(_lOK := .F., _oTela:End()) PIXEL    
	
	ACTIVATE DIALOG _oTela CENTERED

	If _lOK
		For _nJ := 1 to Len(aListBox1)
			If aListBox1[_nJ][1]
				cPedido := aListBox1[_nJ][5]    
				lRet := .t.
				Exit	
			Endif
		Next
	EndIf
	
EndIf

If Select( cArqQry1 ) > 0
	dbSelectArea( cArqQry1 )
	dbCloseArea()
EndIf

RestArea(_aArea)

Return(lRet)

// 17/03/2017 - Luis Felipe Nascimento -   Fim


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
