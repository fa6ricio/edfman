#Include "rwmake.ch"
#Include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EECAP100  ºAutor  ³YTTALO P MARTINS    º Data ³  26/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³EXCLUSÃO DO PEDIDO DE EXPORTAÇÃO GERADO POR ROTINA CUSTOMIZAº±±
±±º          ³DA                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                           02/06/15  º±±
±±º          ³ Retirado o tratamento de estorno do saldo do contrato,     º±±
±±º          ³ o qual deverá ser tratado através do ponto de entrada      º±±
±±º          ³ M410STTS. Motivo a cada vez que se faz o cancelamento do   º±±
±±º          ³ Motivo: A cada cancelamento / eliminação de um embarque    º±±
±±º          ³ o saldo e estornado, fazendo com que o saldo fique errado. º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteração ³ Luis Felipe      -                              17/12/15   º±±
±±º          ³ RDM058 - Obrigatoriedade Tp Descon                         º±±              
±±º          ³ Alterações no dicionário de dados a fim de retirar a obri- º±±
±±º          ³ gatoriedade do campo Tp Descon.                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteração ³ Luis Felipe      -                              28/04/17   º±±
±±º          ³ Corredir a divergência do preço unitário entre os módulos  º±±              
±±º          ³ de Faturamento x Exportação.                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EECAP100()

	Local cParam:= ""
	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}
	Local nX     := 0
	Local nY     := 0
	Local cPath  := ""
	Local cFile  := ""
	Local lExit  := .F.
	Local _aArea := GetArea()
	Local _aAreaEE8:= EE8->(GetArea())
	Local cCHAVE := ""
	Local cPERIDO:= ""
	Local cMEDIA := ""
	Local n_Qtde := 0
	LOCAL cQuery  := ""
	LOCAL cQuery2 := ""

	PRIVATE lMsErroAuto := .F.

	If ValType(ParamIXB) == "C"
		cParam:= ParamIXB

	ElseIf ValType(ParamIXB) == "A"
		cParam:= ParamIXB[1]
	Else
		cParam:= ""
	EndIf

	//12-01-2026 - Thiago Reis
	EE8->(dbSetOrder(1)) //EE8_FILIAL+EE8_PEDIDO
	if EE8->(dbSeek(xFilial("EE8")+EE7->EE7_PEDIDO))

		if Posicione("SB1",1,xFilial("SB1")+AllTrim(EE8->EE8_COD_I),"B1_XCONTCT") == "2" //2-Não

			RestArea(_aAreaEE8)
			Return

		endif

	endif
	//

	RestArea(_aAreaEE8)

	If cParam $ "ESTORNO_PEDIDO"

		Begin Transaction

			dbSelectArea("SC5")
			dbSetOrder(1)
			If dbSeek(xFilial("SC5")+EE7->EE7_PEDIDO)

				aCabec := {}
				aItens := {}
				aadd(aCabec,{"C5_NUM",SC5->C5_NUM,Nil})
				aadd(aCabec,{"C5_TIPO",SC5->C5_TIPO,Nil})
				aadd(aCabec,{"C5_CLIENTE",SC5->C5_CLIENTE,Nil})
				aadd(aCabec,{"C5_LOJACLI",SC5->C5_LOJACLI,Nil})
				aadd(aCabec,{"C5_LOJAENT",SC5->C5_LOJAENT,Nil})
				aadd(aCabec,{"C5_CONDPAG",SC5->C5_CONDPAG,Nil})

				dbSelectArea("SC6")
				dbSetOrder(1)
				IF dbSeek(xFilial("SC6")+SC5->C5_NUM)

					If ALLTRIM(SC5->C5_XORIGEM) $ "GERVENPE"

						While SC6->(!Eof()) .And. SC6->C6_FILIAL == XFILIAL("SC6") .And. SC6->C6_NUM  == SC5->C5_NUM

							aLinha := {}
							aadd(aLinha,{"LINPOS","C6_ITEM",SC6->C6_ITEM})
							aadd(aLinha,{"AUTDELETA","N",Nil})
							aadd(aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO,Nil})
							aadd(aLinha,{"C6_QTDVEN",SC6->C6_QTDVEN,Nil})
							aadd(aLinha,{"C6_PRCVEN",SC6->C6_PRCVEN,Nil})
							aadd(aLinha,{"C6_PRUNIT",SC6->C6_PRUNIT,Nil})
							aadd(aLinha,{"C6_VALOR",SC6->C6_VALOR,Nil})
							aadd(aLinha,{"C6_TES",SC6->C6_TES,Nil})

							cCHAVE := SC5->C5_CONTRAT
							cPERIDO:= SC5->C5_XPERIOD
							cMEDIA := SC5->C5_NRMEDIA
							n_Qtde += SC6->C6_QTDVEN

							aAdd( aItens , aClone( aLinha ) )

							SC6->(DbSkip())
						End

						If Len(aCabec) > 0 .AND. Len(aItens) > 0

							dbSelectArea("SC5")
							dbSetOrder(1)

							MSExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,aItens,4)

							If lMsErroAuto

								makedir(cPath)
								cPath := "C:\LogSiga"
								cFile := StrTran(Dtoc(dDataBase),"/","")+"_"+StrTran(Time(),":","")+"_"+AllTrim(EE7->EE7_PEDIDO)+".log"
								MostraErro(cPath,cFile)

								MsgAlert("Pedido de Venda não alterado para a exclusão no faturamento."+chr(13)+chr(10)+;
									"Verifique o LOG (" + cFile + ") na pasta C:\LogSiga do sistema.", "Atencao !")

								DisarmTransaction()
								Break

							Else

								dbSelectArea("SC5")
								dbSetOrder(1)

								MSExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,aItens,5)

								If lMsErroAuto

									makedir(cPath)
									cPath := "C:\LogSiga"
									cFile := StrTran(Dtoc(dDataBase),"/","")+"_"+StrTran(Time(),":","")+"_"+AllTrim(EE7->EE7_PEDIDO)+".log"
									MostraErro(cPath,cFile)

									MsgAlert("Pedido de Venda não excluído no faturamento."+chr(13)+chr(10)+;
										"Verifique o LOG (" + cFile + ") na pasta C:\LogSiga do sistema.", "Atencao !")

									DisarmTransaction()
									Break

								EndIf

							EndIf

						EndIf

					ENDIF

				ENDIF

			EndIF

		End Transaction

// RDM058 - Obrigatoriedade Tp Descon
// 17/12/15 - Luis Felipe - Inicio

//ElseIf cParam $ "GETPESOS"

//cAqui := ""

//Validações retiradas conforme contato com Luis Felipe       09/03/16 ENS

/*ElseIf cParam == "GETPESOS_OK" 
    If Len(__TTSPUSH) == 2  // Confirmação do Pedido de Exportação     Erro causado variable does not exist EE7_CLLOJA on U_EECAP100(EECAP100A.PRW) 22/02/2016 14:16:56 line : 171
    	M->EE7_IMLOJA := M->EE7_CLLOJA  
    EndIf
ElseIf cParam $ "ANTES_TELA_PRINCIPAL" 
	SX3->(dbSelectArea("SX3"))
	SX3->(dbSetOrder(2))
	If SX3->(DbSeek('EE7_TPDESC'))
		SX3->(RecLock("SX3",.F.))
		 SX3->X3_RELACAO := '"0"' 
		 SX3->X3_CBOX    := "1=Subtrai;2=Soma;0=S/Desc" 
		 SX3->X3_CBOXSPA := "1=Resta;2=Suma;0=S/Desc"   
		 SX3->X3_CBOXENG := "1=Subtract;2=Add;0=S/Desc" 
		SX3->(MsUnlock())
	EndIf
// 17/12/15 - Luis Felipe - Fim */    

// 28/04/17 - Luis Felipe - Inicio
	ElseIf cParam $ "PE_GRV"
		If EE7->EE7_STATUS <> 'D'
			nRegEE8 := EE8->(Recno())
			cChave  := EE8->(EE8_FILIAL+EE8_PEDIDO)
			SC6->(DbSetOrder(1))
			EE8->(DbSetOrder(1))
			EE8->(DbSeek(xFilial("EE8")+EE8->(EE8_PEDIDO+EE8_FATIT)))
			While !EE8->(Eof()) .and. cChave == EE8->(EE8_FILIAL+EE8_PEDIDO)
				If SC6->(DbSeek(xFilial("SC6")+EE8->(RTRIM(EE8_PEDIDO)+EE8_FATIT)))
					SC6->(RecLock("SC6",.F.))      
					SC6->C6_PRCVEN := EE8->EE8_PRECO
					SC6->C6_PRUNIT := EE8->EE8_PRECO
					SC6->C6_VALOR  := Round(EE8->EE8_PRECO * SC6->C6_QTDVEN,2) 
					MsUnlock()   
				EndIf
				EE8->(DbSkip())
			End  
			EE8->(DbGoto(nRegEE8))
		EndIf	
	// 28/04/17 - Luis Felipe - Fim      
	EndIf

// 04/11/13 - Luis Felipe Nascimento - Inicio 
/* 02/06/15 - Luís Felipe - 
              Por este ponto de entrada ser usado tanto na exclusão dos embarques, quanto na exclusção dos Pedidos de Exportação, haviam duas  
			  formas possíveis de atualizar o saldo do contrato. Quando o embarque fosse excluído e o pedido de exportação também, dupla estorno,
			  ou quando houvesse a exclusão de um embarque. Neste segundo caso o pedido não foi excluido e poderá estar sendo usado por outro embarque.   
			  	 
If cParam == "PE_DEL_WORK"
	
	If Select("TMPSC5")>0
		dbSelectArea("TMPSC5")
		("TMPSC5")->(dbCloseArea())
	EndIf
	
	If Select("TMPSC6")>0
		dbSelectArea("TMPSC6")
		("TMPSC6")->(dbCloseArea())
	EndIf
	
	cQuery := "SELECT SC5.R_E_C_N_O_ SC5REC FROM "
	cQuery += RetSqlName("SC5") + " SC5 "
	cQuery += "WHERE "
	cQuery += "SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
	cQuery += "SC5.C5_NUM = '"+EE7->EE7_PEDFAT+"' AND "
	cQuery += "SC5.C5_XSEQPV = '"+EE7->EE7_XSEQPV+"' AND "
	cQuery += "SC5.D_E_L_E_T_= ''"
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSC5",.F.,.T.)
	DBSELECTAREA("TMPSC5")
	("TMPSC5")->(DbGoTop())
	
	IF ("TMPSC5")->(!EOF())
		
		DBSELECTAREA("SC5")
		SC5->(dbGoto(("TMPSC5")->SC5REC))
		
		cQuery2 := "SELECT SC6.R_E_C_N_O_ SC6REC FROM "
		cQuery2 += RetSqlName("SC6") + " SC6 "
		cQuery2 += "WHERE "
		cQuery2 += "SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND "
		cQuery2 += "SC6.C6_NUM = '"+EE7->EE7_PEDFAT+"' AND "
		cQuery2 += "SC6.C6_XSEQPV = '"+EE7->EE7_XSEQPV+"' AND "
		cQuery2 += "SC6.D_E_L_E_T_= ''"
		
		cQuery2 := ChangeQuery(cQuery2)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"TMPSC6",.F.,.T.)
		DBSELECTAREA("TMPSC6")
		("TMPSC6")->(DbGoTop())
		
		IF ("TMPSC6")->(!EOF())
			
			DBSELECTAREA("SC6")
			SC6->(dbGoto(("TMPSC6")->SC6REC))
			
			DBSELECTAREA("SZ7")
			SZ7->(DbSetOrder(3))
			If SZ7->(DbSeek(xFilial("SZ7")+SC5->C5_CONTRAT+SC5->C5_XPERIOD+SC5->C5_NRMEDIA+SC5->C5_XCONTRO))
				RecLock("SZ7",.F.)
				SZ7->Z7_SALDO+=SC6->C6_UNSVEN  // C6_QTDVEN // 27/11/13 - Luis Felipe
				If SZ7->Z7_SALDO == SZ7->Z7_QTDE
					SZ7->Z7_STATUS	:= ""
				endif
				MsUnLock()
			EndIf
			
		ENDIF
		
	ENDIF
	
	If Select("TMPSC5")>0
		dbSelectArea("TMPSC5")
		("TMPSC5")->(dbCloseArea())
	EndIf
	
	If Select("TMPSC6")>0
		dbSelectArea("TMPSC6")
		("TMPSC6")->(dbCloseArea())
	EndIf
	
EndIf                     
*/

	RestArea(_aArea)

RETURN
