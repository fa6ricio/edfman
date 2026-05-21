#Include "Protheus.Ch"
#Include "TbiConn.Ch"
#Include "TopConn.Ch"

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao>  : XDOCCOM - Programa para listar e abrir os documentos anexados no processo de compras
<Autor>      : Marcelo Amaral
<Data>       : 07/04/2020
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/ 

User Function XDOCCOM()
	Local aArea	:= GetArea()
	MsgRun( "Consultando Documentos", "Aguarde...", { || ConsDoc() } )
	Restarea(aArea)	
Return


/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao>  : Lista os documentos anexados na SC7, SF1 e SE2
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/ 

Static Function ConsDoc()
Local area 		:= GetArea()
Local cAlias  	:= GetNextAlias()
Local cAliasGCT := GetNextAlias()
//  Local aArqs 	:= {}
Local aLista 	:= {}
//  Local aPed		:= {}
//  Local aSolic	:= {}
//  Local aDados 	:= {}
Local aDirStruct:= {}	
Local cQry 	  	:= ""
//  Local cPed 		:= ""
Local cDirDoc	:= ""
//  Local cChavePc 	:= ""
//  Local cChaveMed := ""
//  Local cChaveSc 	:= ""
//  Local cSC		:= ""
//  Local nI 		:= 0
Local oDlg
Local oPanel
Local oLbx
Local cVar
Local cDirParam	:= MsDocRmvBar( AllTrim( GetMV( "MV_DIRDOC" ) ) )
Local cContrato := ''
Local cNmPedido := ''
Local lCNDSC7   := .F.


// Monta o diretÛrio onde os arquivos est„o sendo gravados
AAdd( aDirStruct, If( Left( cDirParam, 1 ) == "\", "", "\" ) + cDirParam )
AAdd( aDirStruct, "CO" + cEmpAnt )
AAdd( aDirStruct, If( FWModeAccess("ACB",3)=="C", "SHARED", "BR" + Alltrim(xFilial( "ACB" ) ) )  )

cDirDoc := aDirStruct[ 1 ] + "\" + aDirStruct[ 2 ] + "\" + aDirStruct[ 3 ]

If Empty( StrTran( aDirStruct[ 1 ], "\", "" ) )
	Help( " ", 1, "DIRDOCPAR" ) // Nao foi definido diretorio para o banco de conhecimento	
EndIf

If ExistDir(cDirDoc) == .T.

	/*	
	DbSelectArea("SD1")
	DbSetOrder(1)
	If DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	While !EOF() .And. SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA 
	If Empty(cPed) .Or. cPed <> SD1->D1_PEDIDO
	cPed :=  SD1->D1_PEDIDO
	AADD(aPed, SD1->D1_PEDIDO)	
	EndIf
	SD1->(DbSkip())
	Enddo
	Endif
	DbCloseArea("SD1") 

	If Len(aPed) > 0
	For n:= 1 to Len(aPed)

	dbSelectArea("SC7")
	dbSetOrder(1)
	If dbSeek( xFilial("SC7") + aPed[n] )
	While !EOF() .And. SC7->C7_NUM == aPed[n]				

	If !Empty(SC7->C7_NUMSC) .And. cSC <> SC7->C7_NUMSC
	cSC := SC7->C7_NUMSC
	Aadd(aSolic, SC7->C7_NUMSC)					
	EndIf					

	// Grava a chave do Pedido de Compras
	If cChavePc <> SC7->C7_FILIAL + SC7->C7_NUM + SC7->C7_ITEM + SC7->C7_SEQUEN + SC7->C7_ITEMGRD
	cChavePc := SC7->C7_FILIAL + SC7->C7_NUM + SC7->C7_ITEM + SC7->C7_SEQUEN + SC7->C7_ITEMGRD
	AAdd(aDados, {"SC7", cChavePc})			
	EndIf					

	// Grava a chave da mediÁ„o
	If !EmptY(SC7->C7_CONTRA + SC7->C7_CONTREV + SC7->C7_PLANILH + SC7->C7_MEDICAO) .And. cChaveMed <> SC7->C7_CONTRA + SC7->C7_CONTREV + SC7->C7_PLANILH + SC7->C7_MEDICAO
	cChaveMed := SC7->C7_CONTRA + SC7->C7_CONTREV + SC7->C7_PLANILH + SC7->C7_MEDICAO
	AAdd(aDados, {"CND", cChaveMed})	
	EndIf								

	SC7->(dbSkip())

	Enddo
	EndIf

	DbCloseArea("SC7")	
	Next n

	EndIf	

	If Len(aSolic)> 0
	For n:= 1 to Len(aSolic)
	dbSelectArea("SC1")
	dbSetOrder(1)
	If dbSeek(xFilial("SC1") + aSolic[n] )

	While !Eof() .And. SC1->C1_NUM == aSolic[n] 
	If cChaveSc <> SC1->C1_FILIAL + SC1->C1_NUM + SC1->C1_ITEM + SC1->C1_ITEMGRD
	cChaveSc := SC1->C1_FILIAL + SC1->C1_NUM + SC1->C1_ITEM + SC1->C1_ITEMGRD
	aADD(aDados, {"SC1", cChaveSc})
	EndIf
	SC1->(dbSkip())

	EndDo
	EndIf
	dbCloseArea("SC1")

	Next n

	Endif	

	If Len(aDados) > 0
	For n := 1 to Len(aDados)

	cQry  := " SELECT AC9_ENTIDA, AC9_CODENT, ACB.ACB_OBJETO " 
	cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
	cQry  += " WHERE AC9.D_E_L_E_T_ = ' '  "
	cQry  += "   AND ACB.D_E_L_E_T_ = ' '  "
	cQry  += "   AND ACB.ACB_FILIAL = AC9.AC9_FILIAL "
	cQry  += "   AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ "
	cQry  += "   AND AC9.AC9_ENTIDA	= '" + aDados[n][1]+ "'  "
	cQry  += "   AND AC9.AC9_CODENT	= '" + aDados[n][2]+ "' "

	DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQry), cAlias, .F., .T.)

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	If (cAlias)->(Eof()) 
	Aviso("AtenÁ„o","N„o existem documentos anexados para esse processo.",{"Ok"})

	DbCloseArea(cAlias)	
	Restarea(area)		
	Return
	Else
	While !(cAlias)->(Eof())

	aAdd( aArqs, {aDados[n][1], (cAlias)->ACB_OBJETO})		
	(cAlias)->(DbSkip())	 
	Enddo
	DbCloseArea(cAlias)
	EndIf	

	Next n
	EndIf
	*/	

	// 08/10/19 - Luis Felipe - RDMF0716 - Inicio
	xFilial   := ''     	  
	cFornec	  := ''
	cLoja	  := ''
	cContrato := ''
	cNmPedido := ''
	cItemPC	  := ''
	cItemSC   := ''
	cNumSC	  := ''	

	/*
	If Funname() == 'MATA103' // Documento de Entrada
		xFilial   := SF1->F1_FILIAL     	  
		cFornec	  := SF1->F1_FORNECE
		cLoja	  := SF1->F1_LOJA
	ElseIf Funname() == 'MATA110' // SolicitaÁ„o de Compras
		SC7->(DbSetorder(6))
		If SC7->(DbSeek(xFilial('SC7')+SC1->(C1_PRODUTO+C1_FORNECE+C1_LOJA+C1_PEDIDO)))
			xFilial   := SC7->C7_FILIAL     	  
			cContrato := SC7->C7_CONTRA
			cNmPedido := SC7->C7_NUM
			cItemPC   := SC7->C7_ITEM
		EndIf
		xFilial   := SC1->C1_FILIAL     	  
		cFornec	  := SC1->C1_FORNECE
		cLoja	  := SC1->C1_LOJA
		cItemSC	  := SC1->C1_ITEM
		cNumSC	  := SC1->C1_NUM	
	ElseIf Funname() == 'MATA121' // Pedidos de Compras
		xFilial   := SC7->C7_FILIAL     	  
		cFornec	  := SC7->C7_FORNECE
		cLoja	  := SC7->C7_LOJA
		cContrato := SC7->C7_CONTRA
		cNmPedido := SC7->C7_NUM 
		cItemPC	  := SC7->C7_ITEM
		cNumSC	  := SC7->C7_NUMSC
		cItemSC	  := SC7->C7_ITEMSC
	ElseIf Funname() == 'MATA150' // Atualiza CotaÁıes    
		SC7->(DbSetorder(6))
		If SC7->(DbSeek(xFilial('SC7')+SC8->(C8_PRODUTO+C8_FORNECE+C8_LOJA+C8_NUMPED)))
			xFilial   := SC7->C7_FILIAL     	  
			cContrato := SC7->C7_CONTRA
			cNmPedido := SC7->C7_NUM
		EndIf
		xFilial   := SC8->C8_FILIAL     	  
		cFornec	  := SC8->C8_FORNECE
		cLoja	  := SC8->C8_LOJA
		cItemPC	  := SC8->C8_ITEMPED
		cNumSC	  := SC8->C8_NUMSC
		cItemSC	  := SC8->C8_ITEMSC
	EndIf   
	// 08/10/19 - Luis Felipe - RDMF0716 - Fim
	*/
	
	/*
	If Funname() == 'MATA103' // Documento de Entrada

		// RDMF0589 - Don Junior
		// Buscar o n˙mero do contrato do tÌtulo (SF1+SD1)
		//	cQryGCT  := "SELECT SD1.D1_XCONTRA, SD1.D1_PEDIDO " // 08/10/19 - Luis Felipe - RDMF0716 
		cQryGCT  := "SELECT SD1.D1_XCONTRA, SD1.D1_PEDIDO, SD1.D1_COD "
		cQryGCT  += "  FROM " + RetSqlName("SD1") + " SD1, " + RetSqlName("SF1")+ " SF1 "
		cQryGCT  += " WHERE SD1.D1_FILIAL  = '" + SF1->F1_FILIAL  + "' "
		cQryGCT  += "   AND SD1.D1_DOC     = '" + SF1->F1_DOC     + "' "
		cQryGCT  += "   AND SD1.D1_SERIE   = '" + SF1->F1_SERIE   + "' "
		cQryGCT  += "   AND SD1.D1_FORNECE = '" + SF1->F1_FORNECE + "' "
		cQryGCT  += "   AND SD1.D1_LOJA    = '" + SF1->F1_LOJA    + "' "
		cQryGCT  += "   AND SD1.D_E_L_E_T_ = ' ' "
		cQryGCT  += "   AND SF1.D_E_L_E_T_ = ' ' "
		cQryGCT  += "GROUP BY SD1.D1_XCONTRA, D1_PEDIDO, D1_COD "       

		cQryGCT := ChangeQuery(cQryGCT)

		DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQryGCT), cAliasGCT, .F., .T.)

		DbSelectArea(cAliasGCT)
		(cAliasGCT)->(DbGoTop())
	*/

/*		// 08/10/19 - Luis Felipe - RDMF0716

		If (cAliasGCT)->(Eof()) 
			Aviso("AtenÁ„o","N„o foi possÌvel buscar o numero pedido!",{"Ok"})

			(cAliasGCT)->(DbCloseArea())
			Restarea(area)		
			Return
		Else
*/
 	/*
		While !(cAliasGCT)->(Eof()) 
			
			cContrato := (cAliasGCT)->D1_XCONTRA // CÛdigo do contrato
			cNmPedido := (cAliasGCT)->D1_PEDIDO  // N˙mero do pedido
			SC7->(DbSetorder(6))
			If SC7->(DbSeek(xFilial('SC7')+(cAliasGCT)->D1_COD+SF1->(F1_FORNECE+F1_LOJA)+cNmPedido))
				xFilial   := SC7->C7_FILIAL     	  
				cContrato := SC7->C7_CONTRA
				cNmPedido := SC7->C7_NUM
				cItemPC   := SC7->C7_ITEM
			EndIf
			SC1->(DbSetorder(6))
			If SC1->(DbSeek(xFilial('SC1')+cNmPedido+cItemPC+(cAliasGCT)->D1_COD))
				xFilial   := SC1->C1_FILIAL     	  
				cItemSC	  := SC1->C1_ITEM
				cNumSC	  := SC1->C1_NUM	
			EndIf

			If !Empty(cContrato) .And. !Empty(cNmPedido)

				// Buscar os conhecimentos pelo contrato
//				cQry  := " SELECT AC9_FILENT, AC9_ENTIDA, AC9_CODENT, AC9_CODOBJ,  ACB_OBJETO, ACB_DESCRI "
				cQry  := " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
				cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
				cQry  += "  WHERE AC9.D_E_L_E_T_ = ' ' 
				cQry  += "    AND ACB.D_E_L_E_T_ = ' ' 
				cQry  += "    AND ACB.ACB_FILIAL = AC9.AC9_FILIAL 
				cQry  += "    AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ
				cQry  += "    AND ( (AC9.AC9_ENTIDA = 'CND' AND AC9.AC9_CODENT = (SELECT (C7_CONTRA+C7_CONTREV+'000001'+C7_MEDICAO) AS 'CODENT' "
				cQry  += "    						                              FROM " + RetSqlName("SC7") + " SC7 " 
				cQry  += "    				                                      WHERE D_E_L_E_T_    = '' "
				cQry  += "    							 		    	      	  AND SC7.C7_NUM    = '" + cNmPedido + "' "
				cQry  += "    							 			    	      AND SC7.C7_CONTRA = '" + cContrato + "' " 
				cQry  += "    							 				          GROUP BY (C7_CONTRA+C7_CONTREV+'000001'+C7_MEDICAO) )) "
				cQry  += "    OR (AC9.AC9_ENTIDA = 'SC7' AND SUBSTRING(AC9.AC9_CODENT,1,8) IN (SELECT (C7_FILIAL+C7_NUM) AS 'CODENT' "
				cQry  += "    							                          FROM " + RetSqlName("SC7") + " SC7 " 
				cQry  += "    					                                  WHERE SC7.D_E_L_E_T_ = ' ' " 
				cQry  += "    								                      AND SC7.C7_NUM    = '" + cNmPedido + "' "
				cQry  += "    											          AND SC7.C7_CONTRA = '" + cContrato + "' "
				cQry  += "    											          GROUP BY (C7_FILIAL+C7_NUM) ))) "

				cQry  += "GROUP BY AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
				cQry  += "ORDER BY AC9_ENTIDA, ACB_OBJETO "

				cQry := ChangeQuery(cQry)

				DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQry), cAlias, .F., .T.)

				DbSelectArea(cAlias)
				(cAlias)->(DbGoTop())

				If (cAlias)->(Eof()) 
//						Aviso("AtenÁ„o","N„o existem documentos anexados para esse processo.",{"Ok"}) // 08/10/19 - Luis Felipe - RDMF0716

					(cAlias)->(DbCloseArea())	
					Restarea(area)		
					Return
				Else
					While !(cAlias)->(Eof())

						If !Ascan(aLista,{|x| x[2] = (cAlias)->ACB_OBJETO})
							aAdd( aLista, { (cAlias)->AC9_ENTIDA, (cAlias)->ACB_OBJETO})
						EndIf		
						(cAlias)->(DbSkip())	 
					Enddo
					(cAlias)->(DbCloseArea())
				EndIf
			Else
				MsgInfo("N„o foi possÌvel identificar o n˙mero do Pedido/Contrato.")
			EndIf
			(cAliasGCT)->(Dbskip()) 
		End
		
		(cAliasGCT)->(DbCloseArea())

		lCNDSC7 := .T.

	EndIf			
	*/
	
	/*
	// 08/10/19 - Luis Felipe - RDMF0716 - Inicio
	cQry  := " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
	cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
	cQry  += "  WHERE AC9.D_E_L_E_T_ = ' ' 
	cQry  += "    AND ACB.D_E_L_E_T_ = ' ' 
	cQry  += "    AND ACB.ACB_FILIAL = AC9.AC9_FILIAL 
	cQry  += "    AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ

	cQry  += "    AND ((AC9.AC9_ENTIDA = 'SA2' AND AC9.AC9_CODENT IN    (SELECT A2_COD+A2_LOJA AS 'CODENT' "
	cQry  += "    							                          FROM " + RetSqlName("SA2") + " SA2 " 
	cQry  += "    					                                  WHERE SA2.D_E_L_E_T_ = ' ' " 
	cQry  += "    								                      AND SA2.A2_COD    = '" + cFornec  + "' "
	cQry  += "    											          AND SA2.A2_LOJA   = '" + cLoja    + "' "
	cQry  += "    											          GROUP BY A2_COD,A2_LOJA ))) "
	*/

	cQry  := " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
	cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
	cQry  += "  WHERE AC9.D_E_L_E_T_ = ' ' "
	cQry  += "    AND ACB.D_E_L_E_T_ = ' ' "
	cQry  += "    AND ACB.ACB_FILIAL = AC9.AC9_FILIAL "
	cQry  += "    AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ "

	cQry  += "    AND ((AC9.AC9_ENTIDA = 'SE2' AND AC9.AC9_CODENT IN    (SELECT E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA AS 'CODENT' "
	cQry  += "    							                          FROM " + RetSqlName("SE2") + " SE2 " 
	cQry  += "    					                                  WHERE SE2.D_E_L_E_T_ = ' ' " 
	cQry  += "    								                      AND SE2.E2_FILIAL = '" + SE2->E2_FILIAL + "' "
	cQry  += "    								                      AND SE2.E2_PREFIXO = '" + SE2->E2_PREFIXO + "' "
	cQry  += "    											          AND SE2.E2_NUM = '" + SE2->E2_NUM + "' "
	cQry  += "    								                      AND SE2.E2_PARCELA = '" + SE2->E2_PARCELA + "' "
	cQry  += "    											          AND SE2.E2_TIPO = '" + SE2->E2_TIPO + "' "
	cQry  += "    								                      AND SE2.E2_FORNECE = '" + SE2->E2_FORNECE + "' "
	cQry  += "    											          AND SE2.E2_LOJA = '" + SE2->E2_LOJA + "' "
	cQry  += "    											          GROUP BY E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA ))) "

	cQry  += " UNION " 
	cQry  += " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
	cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
	cQry  += "  WHERE AC9.D_E_L_E_T_ = ' ' "
	cQry  += "    AND ACB.D_E_L_E_T_ = ' ' "
	cQry  += "    AND ACB.ACB_FILIAL = AC9.AC9_FILIAL "
	cQry  += "    AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ "
	
	cQry  += "    AND ((AC9.AC9_ENTIDA = 'SF1' AND AC9.AC9_CODENT IN (SELECT (F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA) AS 'CODENT' "
	cQry  += "    							                          FROM " + RetSqlName("SF1") + " SF1 " 
	cQry  += "    					                                  WHERE SF1.D_E_L_E_T_ = ' ' " 
	cQry  += "    								                      AND SF1.F1_FILIAL = '" + SE2->E2_FILORIG + "' "
	cQry  += "    								                      AND SF1.F1_DOC = '" + SE2->E2_NUM + "' "
	cQry  += "    								                      AND SF1.F1_SERIE = '" + SE2->E2_PREFIXO + "' "
	cQry  += "    								                      AND SF1.F1_FORNECE = '" + SE2->E2_FORNECE + "' "
	cQry  += "    								                      AND SF1.F1_LOJA = '" + SE2->E2_LOJA + "' "
	cQry  += "    											          GROUP BY F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA ))) "

	cQry  += " UNION " 
	cQry  += " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
	cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
	cQry  += "  WHERE AC9.D_E_L_E_T_ = ' ' "
	cQry  += "    AND ACB.D_E_L_E_T_ = ' ' "
	cQry  += "    AND ACB.ACB_FILIAL = AC9.AC9_FILIAL "
	cQry  += "    AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ "
	
	cQry  += "    AND ((AC9.AC9_ENTIDA = 'SC7' AND AC9.AC9_CODENT IN (SELECT (C7_FILIAL+C7_NUM+C7_ITEM) AS 'CODENT' "
	cQry  += "    							                          FROM " + RetSqlName("SC7") + " SC7, " 
	cQry  += "    							                               " + RetSqlName("SD1") + " SD1 " 
	cQry  += "    					                                  WHERE SC7.D_E_L_E_T_ = ' ' " 
	cQry  += "    					                                  AND SD1.D_E_L_E_T_ = ' ' " 
	cQry  += "    							                          AND SC7.C7_FILIAL = SD1.D1_FILIAL " 
	cQry  += "    							                          AND SC7.C7_NUM = SD1.D1_PEDIDO " 
	cQry  += "    							                          AND SC7.C7_ITEM = SD1.D1_ITEMPC " 
	cQry  += "    							                          AND SC7.C7_FORNECE = SD1.D1_FORNECE " 
	cQry  += "    							                          AND SC7.C7_LOJA = SD1.D1_LOJA " 
	cQry  += "    								                      AND SD1.D1_FILIAL = '" + SE2->E2_FILORIG + "' "
	cQry  += "    								                      AND SD1.D1_DOC = '" + SE2->E2_NUM + "' "
	cQry  += "    								                      AND SD1.D1_SERIE = '" + SE2->E2_PREFIXO + "' "
	cQry  += "    								                      AND SD1.D1_FORNECE = '" + SE2->E2_FORNECE + "' "
	cQry  += "    								                      AND SD1.D1_LOJA = '" + SE2->E2_LOJA + "' "
	cQry  += "    											          GROUP BY C7_FILIAL,C7_NUM,C7_ITEM ))) "
	
	/*
	If !Empty(cNmPedido) .and. Empty(cContrato)
		cQry  += " UNION " 
		cQry  += " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
		cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
		cQry  += "  WHERE AC9.D_E_L_E_T_ = ' ' 
		cQry  += "    AND ACB.D_E_L_E_T_ = ' ' 
		cQry  += "    AND ACB.ACB_FILIAL = AC9.AC9_FILIAL 
		cQry  += "    AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ
		cQry  += "    AND ((AC9.AC9_ENTIDA = 'SC7' AND SUBSTRING(AC9.AC9_CODENT,1,8) = (SELECT (C7_FILIAL+C7_NUM) AS 'CODENT' "
		cQry  += "    							                          FROM " + RetSqlName("SC7") + " SC7 " 
		cQry  += "    					                                  WHERE SC7.D_E_L_E_T_ = ' ' " 
		cQry  += "    								                      AND SC7.C7_FILIAL= '" + xFilial + "' "
		cQry  += "    								                      AND SC7.C7_NUM   = '" + cNmPedido + "' "
		cQry  += "    											          AND SC7.C7_ITEM  = '" + cItemPC + "' "
		cQry  += "    											          GROUP BY C7_FILIAL+C7_NUM ))) "
	EndIf 
		
	If !Empty(cNumSC) 
		cQry  += " UNION " 
		cQry  += " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
		cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
		cQry  += "  WHERE AC9.D_E_L_E_T_ = ' ' 
		cQry  += "    AND ACB.D_E_L_E_T_ = ' ' 
		cQry  += "    AND ACB.ACB_FILIAL = AC9.AC9_FILIAL 
		cQry  += "    AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ
		cQry  += "    AND ((AC9.AC9_ENTIDA = 'SC1' AND SUBSTRING(AC9.AC9_CODENT,1,8) = (SELECT (C1_FILIAL+C1_NUM) AS 'CODENT' "
		cQry  += "    							                          FROM " + RetSqlName("SC1") + " SC1 " 
		cQry  += "    					                                  WHERE SC1.D_E_L_E_T_ = ' ' " 
		cQry  += "    								                      AND SC1.C1_FILIAL= '" + xFilial + "' "
		cQry  += "    								                      AND SC1.C1_NUM   = '" + cNumSC + "' "
		cQry  += "    											          AND SC1.C1_ITEM  = '" + cItemSC + "' "
		cQry  += "    											          GROUP BY C1_FILIAL+C1_NUM ))) "
	EndIf 

	If !Empty(cContrato) .And. !Empty(cNmPedido) .And. !lCNDSC7 
		cQry  += " UNION " 
		cQry  += " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
		cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
		cQry  += " WHERE AC9.D_E_L_E_T_ = ' ' 
		cQry  += " AND ACB.D_E_L_E_T_ = ' ' 
		cQry  += " AND ACB.ACB_FILIAL = AC9.AC9_FILIAL 
		cQry  += " AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ
		cQry  += " AND ((AC9.AC9_ENTIDA = 'SC7' AND SUBSTRING(AC9.AC9_CODENT,1,8) = (SELECT (C7_FILIAL+C7_NUM) AS 'CODENT' "
		cQry  += "    							                          FROM " + RetSqlName("SC7") + " SC7 " 
		cQry  += "    					                                  WHERE SC7.D_E_L_E_T_ = ' ' " 
		cQry  += "    								                      AND SC7.C7_FILIAL= '" + xFilial + "' "
		cQry  += "    								                      AND SC7.C7_NUM    = '" + cNmPedido + "' "
		cQry  += "    											          AND SC7.C7_CONTRA = '" + cContrato + "' "
		cQry  += "    											          GROUP BY C7_FILIAL+C7_NUM ))) "

		cQry  += " UNION " 
		cQry  += " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
		cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
		cQry  += " WHERE AC9.D_E_L_E_T_ = ' ' 
		cQry  += " AND ACB.D_E_L_E_T_ = ' ' 
		cQry  += " AND ACB.ACB_FILIAL = AC9.AC9_FILIAL 
		cQry  += " AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ
		cQry  += " AND ((AC9.AC9_ENTIDA = 'CND' AND AC9.AC9_CODENT =     (SELECT (C7_CONTRA+C7_CONTREV+'000001'+C7_MEDICAO) AS 'CODENT' "
		cQry  += "    						                              FROM " + RetSqlName("SC7") + " SC7 " 
		cQry  += "    				                                      WHERE D_E_L_E_T_    = '' "
		cQry  += "    								                      AND SC7.C7_FILIAL= '" + xFilial + "' "
		cQry  += "    							 		    	      	  AND SC7.C7_NUM    = '" + cNmPedido + "' "
		cQry  += "    							 			    	      AND SC7.C7_CONTRA = '" + cContrato + "' " 
		cQry  += "    							 				          GROUP BY C7_CONTRA+C7_CONTREV+'000001'+C7_MEDICAO ))) "

		cQry  += " UNION " 
		cQry  += " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
		cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
		cQry  += " WHERE AC9.D_E_L_E_T_ = ' ' 
		cQry  += " AND ACB.D_E_L_E_T_ = ' ' 
		cQry  += " AND ACB.ACB_FILIAL = AC9.AC9_FILIAL 
		cQry  += " AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ
		cQry  += " AND ((AC9.AC9_ENTIDA = 'CN9' AND AC9.AC9_CODENT   =    (SELECT CN9_NUMERO AS 'CODENT' "
		cQry  += "    							                          FROM " + RetSqlName("CN9") + " CN9 " 
		cQry  += "    					                                  WHERE CN9.D_E_L_E_T_ = ' ' " 
		cQry  += "    								                      AND CN9.CN9_FILIAL = '" + xFilial + "' "
		cQry  += "    											          AND CN9.CN9_NUMERO = '" + cContrato + "' "
		cQry  += "    											          GROUP BY CN9_NUMERO ))) "
	EndIf	

	If !Empty(cNmPedido) .And. !Empty(cFornec) 
		cQry  += " UNION " 
		cQry  += " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
		cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
		cQry  += "  WHERE AC9.D_E_L_E_T_ = ' ' 
		cQry  += "    AND ACB.D_E_L_E_T_ = ' ' 
		cQry  += "    AND ACB.ACB_FILIAL = AC9.AC9_FILIAL 
		cQry  += "    AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ
//		cQry  += "    AND ((AC9.AC9_ENTIDA = 'SC8' AND SubString(AC9.AC9_CODENT,1,25) =  (SELECT TOP 1 C8_FILIAL+C8_NUM+C8_ITEM+'   '+C8_FORNECE+C8_LOJA AS 'CODENT' "
		cQry  += "    AND ((AC9.AC9_ENTIDA = 'SC8' AND SubString(AC9.AC9_CODENT,1,12) =  (SELECT TOP 1 C8_FILIAL+C8_NUM+C8_ITEM AS 'CODENT' "
		cQry  += "    							                          FROM " + RetSqlName("SC8") + " SC8 " 
		cQry  += "    					                                  WHERE SC8.D_E_L_E_T_ = ' ' " 
		cQry  += "    								                      AND SC8.C8_FILIAL  = '" + xFilial + "' "
		cQry  += "    											          AND SC8.C8_NUMPED  = '" + cNmPedido + "' "
		cQry  += "    											          AND SC8.C8_FORNECE = '" + cFornec + "' "
		cQry  += "    											          AND SC8.C8_LOJA    = '" + cLoja + "' "
		cQry  += "    											          GROUP BY C8_FILIAL,C8_NUM,C8_ITEM,C8_FORNECE,C8_LOJA ))) "
	EndIf	

	If !Empty(cNmPedido) .and. Empty(cContrato)
	 	DbSelectArea("SD1")
	 	SD1->(DbSetOrder(22))
	 	If SD1->(DbSeek(xFilial("SD1")+cNmPedido+cItemPC))
			cQry  += " UNION " 
			cQry  += " SELECT DISTINCT AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
			cQry  += " FROM " + RetSqlName("AC9") + " AC9, " + RetSqlName("ACB")+ " ACB "
			cQry  += "  WHERE AC9.D_E_L_E_T_ = ' ' 
			cQry  += "    AND ACB.D_E_L_E_T_ = ' ' 
			cQry  += "    AND ACB.ACB_FILIAL = AC9.AC9_FILIAL 
			cQry  += "    AND ACB.ACB_CODOBJ = AC9.AC9_CODOBJ
			cQry  += "    AND ((AC9.AC9_ENTIDA = 'SF1' AND SUBSTRING(AC9.AC9_CODENT,1,22) = (SELECT TOP 1 (D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) AS 'CODENT' "
			cQry  += "    							                          FROM " + RetSqlName("SD1") + " SD1 " 
			cQry  += "    					                                  WHERE SD1.D_E_L_E_T_ = ' ' " 
			cQry  += "    								                      AND SD1.D1_FILIAL  = '" + xFilial + "' "
			cQry  += "    								                      AND SD1.D1_PEDIDO  = '" + cNmPedido + "' "
			cQry  += "    											          AND SD1.D1_ITEMPC  = '" + cItemPC + "' "
			cQry  += "    											          GROUP BY D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA ))) "
		EndIf
	EndIf 
	*/
	
	cQry  += "GROUP BY AC9_ENTIDA, ACB_OBJETO, ACB_DESCRI "
	cQry  += "ORDER BY AC9_ENTIDA, ACB_OBJETO "

	cQry := ChangeQuery(cQry)

	DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQry), cAlias, .F., .T.)

	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	While !(cAlias)->(Eof())
		If !Ascan(aLista,{|x| x[2] = (cAlias)->ACB_OBJETO})
			aAdd( aLista, { (cAlias)->AC9_ENTIDA, (cAlias)->ACB_OBJETO})
		EndIf		
		(cAlias)->(DbSkip())	 
	Enddo

	(cAlias)->(DbCloseArea())

	// 08/10/19 - Luis Felipe - RDMF0716 - Fim

	If Len(aLista) >  0

		DEFINE MSDIALOG oDlg FROM 0,0 TO 200,400 TITLE "Selecione Arquivo" OF oMainWnd PIXEL

		@ 001,001 LISTBOX oLbx VAR cVar FIELDS HEADER "Tabela", "Arquivo" SIZE 80,50 OF oDlg PIXEL

		oLbx:SetArray(aLista)
		oLbx:bLine := {|| {aLista[oLbx:nAt,1], aLista[oLbx:nAt,2] }}

		@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED 
		oPanel:Align := CONTROL_ALIGN_BOTTOM
		oLbx:Align := CONTROL_ALIGN_ALLCLIENT

		@ 4,090 BUTTON "Visualizar" SIZE 32,10 FONT oDlg:oFont ACTION {|| (ViewArq(cDirDoc + "\"+ aLista[oLbx:nAt,2], aLista[oLbx:nAt,2])) } OF oPanel PIXEL
		@ 4,125 BUTTON "Fechar" SIZE 32,10 FONT oDlg:oFont ACTION {|| (oDlg:End()) } OF oPanel PIXEL 

		ACTIVATE MSDIALOG oDlg CENTERED

	Else
		Aviso("Atencao!","Nao existem arquivos para esse documento",{"Voltar"},2)
	EndIf
Else
	Aviso("Atencao!","DiretÛrio " + cDirDoc + " n„o encontrado.",{"Voltar"},2)

EndIf
Restarea(area)	

Return


/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao>  : FunÁ„o para abrir o documento
<Autor>      : Leonardo Paiva
<Data>       : 03/05/2016
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/ 

Static Function ViewArq(cArq, cTemp)

	Local cFileName := ""
	Local cDrive := ""
	Local cDir := ""
	Local nRet := 0

	If File(cArq)
		cFileName := GetTempPath()+cTemp
		SmCopy(cArq,cFileName )
		SplitPath(cFileName, @cDrive, @cDir )
		cDir := Alltrim(cDrive) + Alltrim(cDir)
		nRet := ShellExecute("open",cFileName,"",cDir, 1 )
		If nRet <= 32
			Aviso( "Erro na abertura do arquivo", "Atencao! Nao foi possivel abrir o documento selecionado.", { "OK" }, 2 )
		EndIf
	Else
		Conout(cArq)
		Aviso("Atencao!","Arquivo n„o localizado.",{"Voltar"},2)
	EndIf

Return 