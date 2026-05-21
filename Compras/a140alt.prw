#INCLUDE "topconn.ch"
#INCLUDE "Tbiconn.ch"
#include 'RWMAKE.CH'
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A140ALT  ºAutor  ³Luis Felipe Nascimento ³Data ³  31/07/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pre-Nota - Mata140                                         º±±
±±º          ³ Não permitir a alteração de NF Remessa oriunda de entrada  º±±
±±º          ³ via Template                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A140ALT()

Local _aArea := GetArea()
Local lRet   := .T.
Local lResp  := 1

//PRivate xcRecno  := SF1->(Recno())

/*
If !Empty(SF1->F1_NFMAE)
Aviso("Atenção","Para fins de controle das entradas de documentos e garantia da integridade destes. A ED&F MAN não autoriza a alteração de Notas Fiscais de Remessa importadas através de suas rotinas específicas !",{"Voltar"})
lRet := .f.
EndIf
*/
SD1->(DbSetOrder(1))  
SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE))
SB1->(DbSeeK(xFilial("SB1")+SD1->D1_COD))

If !l140Auto .AND. Alltrim(SB1->B1_GRUPO) $ "001/002/003/004"
	If Empty(SF1->F1_NFMAE)
		lResp := Aviso("Rotina Especifica A140ALT","Essa NF faz referência a produtos comercializados pela ED&F MAN. Você gostaria de amarrar esta NF a um Contrato ?",{"Não","Sim"})
	Else
		lResp := Aviso("Rotina Especifica A140ALT","Por se tratar de uma NF de Remessa já amarrada a um Contrato, existe a possibilidade redirecionamento para outro Contrato e DP do mesmo fornecedor. Vc deseja redirecionar ?",{"Não","Sim"})
	EndIf	
	If lResp == 1
		Return( lRet )
	EndIf 
Else	
	Return( lRet )
EndIf

//Atualiza tabela SZD(tabela retaguarda)
u_xAtuNF_SZD(If(Empty(SF1->F1_NFMAE),.f.,.t.))

RestArea(_aArea)

Return( lRet )

*************************************************************************************************************************************************

User Function xAtuNF_SZD(lMae)

Local oVar1, oVar2, oVar3, oVar4, oVar5, oVar6, oVar7, oVar8, oVar9, oBtnOk, oBtnCan
Local lOk := .F.
Local cQuery4 := " "

Default lMae := .f.

Private oDlg, cContra, cDP, cNomfor, cNF, cSer, cNFMae, cSerMae, cForn, cLoja

cNomfor  	:= Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE + SF1->F1_LOJA,"A2_NOME")
cContraOri 	:= SF1->F1_CONTRA
cDPOri   	:= SF1->F1_XPERIOD
cNFMaeOri	:= SF1->F1_NFMAE
cSerMaeOri	:= SF1->F1_XSERMAE
cContraDes 	:= SPACE( TAMSX3("CN9_NUMERO")[1] )
cDPDes   	:= SPACE( TAMSX3("Z3_PERIODO")[1] )
cNFMaeDes	:= SPACE( TAMSX3("F1_DOC")[1] )
cSerMaeDes	:= SPACE( TAMSX3("F1_SERIE")[1] )
cForn    	:= SF1->F1_FORNECE
cLoja    	:= SF1->F1_LOJA
cNFRem   	:= SF1->F1_DOC   
cSeRem    	:= SF1->F1_SERIE 
cPedido		:= ""

If lMae
	
	Define MSDialog oDlg Title OemToAnsi("Complento de informações da pré-nota") From 0,0 To 445,410 Pixel
	
	@005,20 Say "O R I G E M" Pixel Of oDlg
	
	@020,20 Say "Contrato:" Pixel Of oDlg
	@020,90 MSGet oVar1  Var cContraOri Picture "@!" Size 70,10 When .f. OF oDlg PIXEL
	
	@035,20 Say "Dp:" Pixel Of oDlg
	@035,90 MSGet oVar2  Var cDpOri     Picture "@!" Size 70,10 When .f. OF oDlg PIXEL
	
	@050,20 Say "NF:" Pixel Of oDlg
	@050,90 MSGet oVar3  Var cNFMaeOri  Picture "@!" Size 70,10 When .f. OF oDlg PIXEL
	
	@065,20 Say "Serie:" Pixel Of oDlg
	@065,90 MSGet oVar4  Var cSerMaeOri Picture "@!" Size 70,10 When .f. OF oDlg PIXEL
	
	@080,20 Say "Fornecedor :" Pixel Of oDlg
	@080,90 MSGet oVar5  Var cNomFor    Picture "@!" Size 102,10 When .f. OF oDlg PIXEL
	
	@105,20 Say "D E S T I N O" Pixel Of oDlg
	
	@125,20 Say "Contrato:" Pixel Of oDlg
	@125,90 MSGet oVar6  Var cContraDes Picture "@!" Size 70,10  F3 "SZ3" Valid ExistCPO("SZ3",cContraDes) OF oDlg PIXEL
	
	@145,20 Say "Dp:" Pixel Of oDlg
	@145,90 MSGet oVar7  Var cDPDes Picture "@!" Size 70,10 OF oDlg PIXEL
	
	@165,20 Say "NF Mãe:" Pixel Of oDlg
	@165,90 MSGet oVar8  Var cNFMaeDes  Picture "@!" Size 70,10 F3 "SF1MAE" Valid {|| ExistCPO("SF1",cNFMaeDes),ValidMae(cNFMaeDes,cNFMaeOri)} OF oDlg PIXEL
	
	@185,20 Say "Serie Mãe:" Pixel Of oDlg
	@185,90 MSGet oVar9  Var cSerMaeDes  Picture "@!" Size 70,10 OF oDlg PIXEL
	
	@205,110 Button oBtnOk   Prompt "&Ok"    Size 30,15 Pixel Action (lOk := .T.,oDlg:End()) Of oDlg
	@205,150 Button oBtnCan  Prompt "&Sair"  Size 30,15 Pixel Action (oDlg:End()) Of oDlg
	
Else
	
	Define MSDialog oDlg Title OemToAnsi("Complento de informações da pré-nota") From 0,0 To 170,410 Pixel
	
	@005,20 Say "Contrato:" Pixel Of oDlg
	@005,90 MSGet oVar6  Var cContraDes Picture "@!" Size 70,10  F3 "SZ3" Valid ExistCPO("SZ3",cContraDes) OF oDlg PIXEL
	
	@020,20 Say "Dp:" Pixel Of oDlg
	@020,90 MSGet oVar7  Var cDPDes Picture "@!" Size 70,10 OF oDlg PIXEL
	
	@035,20 Say "NF Mãe:" Pixel Of oDlg
	@035,90 MSGet oVar8  Var cNFMaeDes  Picture "@!" Size 70,10 F3 "SF1MAE" Valid ExistCPO("SF1",cNFMaeDes) OF oDlg PIXEL
	
	@050,20 Say "Serie Mãe:" Pixel Of oDlg
	@050,90 MSGet oVar9  Var cSerMaeDes  Picture "@!" Size 70,10 OF oDlg PIXEL
	
	@065,110 Button oBtnOk   Prompt "&Ok"    Size 30,15 Pixel Action (lOk := .T.,oDlg:End()) Of oDlg
	@065,150 Button oBtnCan  Prompt "&Sair"  Size 30,15 Pixel Action (oDlg:End()) Of oDlg
	
EndIf

Activate MSDialog oDlg Centered

If lOk == .T. .and. !Empty(cContraDes) .and. !Empty(cNFMaeDes)
	
	dbselectarea("SF1")
	dbsetorder(1)
	If !dbseek(xFILIAL("SF1")+cNFMaeDes+cSerMaeDes+cForn+cLoja)//PONTEIRA NA NF MÃE
		ApMsgStop("Nota/Serie mãe não encontrada!")
		lOk := .F.
	Else
		cPedido := SF1->F1_XPEDIDO    
	EndIf
	
	dbSelectArea("SZ3")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZ3")+cContraDes+cDPDes)
		
		ApMsgStop("Contrato + DP inexistente no cronograma!")
		lOk := .F.
		
	EndIf
	
// FALTA O PEDIDO DE COMPRA NA NF MAE

	If lOk == .T.
		
	    SF1->(Dbseek(xFILIAL("SF1")+cNFRem+cSeRem+cForn+cLoja))

	    SD1->(DbSetOrder(1))
	    SD1->(Dbseek(xFILIAL("SD1")+cNFRem+cSeRem+cForn+cLoja))
		
		cNFREMES := SF1->F1_DOC
		cSERIER  := SF1->F1_SERIE
		nQTDNFRE := SD1->D1_QUANT

	    // 16/09/15 - Luis Felipe
		cUM 	:= SD1->D1_UM
		dEmissao:= SF1->F1_EMISSAO
		cNFREM	:= SF1->F1_DOC
		cSEIEREM:= SF1->F1_SERIE 
		nValmerc:= SF1->F1_VALMERC
		// 16/09/15 - Luis Felipe
		
		RECLOCK("SF1",.F.)
		SF1->F1_NFMAE    := cNFMaeDes
		SF1->F1_CONTRA   := cContraDes
		SF1->F1_XSERMAE  := cSerMaeDes
		SF1->F1_XPERIOD  := cDPDes
		SF1->F1_XPEDIDO  := cPedido  // 16/09/15 - Luis Felipe

		("SF1")->(MSUNLOCK())
		
		SZD->(DbSetOrder(1))
		If SZD->(DbSeek(xFilial("SZD")+cContraOri+cDPOri+cNFMaeOri+cSerMaeOri+SF1->F1_DOC+SF1->F1_SERIE+"01"))

			dbSelectArea("SA2")
			SA2->( dbSetOrder( 1 ) )
			SA2->( DbSeek( xFilial( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA  ) )

			cQuery4 := "UPDATE "+RetSQLName("SZD")+" SET "
			cQuery4 += "ZD_NFMAE = '"+cNFMaeDes+"', ZD_CONTRA = '"+cContraDes+"', ZD_SERIEM = '"+cSerMaeDes+"', ZD_PERIODO = '"+cDPDes+"' "
			cQuery4 += "WHERE ZD_FILIAL='"+xFilial("SZD")+"' "
			cQuery4 += "AND ZD_NFREMES = '" + SF1->F1_DOC + "' "
			cQuery4 += "AND ZD_SERIER = '" + SF1->F1_SERIE + "' "
			cQuery4 += "AND ZD_CNPJUSI = '" + SA2->A2_CGC + "' "
			cQuery4 += "AND D_E_L_E_T_ = ' '; "
			
			If TCSQLExec( cQuery4 ) <> 0
				UserException("Falha na Atualização da tabela XML-Template - " + TCSQLError() )
			EndIf
			
		Else
			
			RECLOCK("SZD",.T.)
			
			SZD->ZD_FILIAL  := xFilial("SZD")
			SZD->ZD_CONTRA  := cContraDes
			SZD->ZD_PERIODO := cDPDes
			SZD->ZD_NFMAE   := cNFMaeDes
			SZD->ZD_SERIEM  := cSerMaeDes
			SZD->ZD_NFREMES := cNFREMES
			SZD->ZD_SERIER  := cSERIER
			SZD->ZD_QTDNFRE := nQTDNFRE
			SZD->ZD_SALDO   := nQTDNFRE
			SZD->ZD_STATUS  := "AT"
			SZD->ZD_PARC    := "01"
			
			SF1->(Dbsetorder(1))
			SF1->(Dbseek(xFILIAL("SF1")+cNFMaeDes+cSerMaeDes+SF1->F1_FORNECE+SF1->F1_LOJA))
			SZD->ZD_PEDIDOC := SF1->F1_XPEDIDO
			
			SD1->(Dbsetorder(1))
			SD1->(Dbseek(xFILIAL("SD1")+cNFMaeDes+cSerMaeDes+SF1->F1_FORNECE+SF1->F1_LOJA))
			SZD->ZD_QTDMAE  := SD1->D1_QUANT
			SZD->ZD_VLRMAE	:= SF1->F1_VALMERC

			SA2->(Dbsetorder(1))
			SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA))
			
			SZD->ZD_CNPJUSI := SA2->A2_CGC
			SZD->ZD_NUSINA  := SA2->A2_NREDUZ
			                       
		    // 16/09/15 - Luis Felipe
			SZD->ZD_EMISREM	:= dEmissao
			SZD->ZD_NFREMES	:= cNFREM
			SZD->ZD_SERIER	:= cSEIEREM 
			SZD->ZD_UM 		:= cUM
			SZD->ZD_VLRNFRE := nValmerc
			// 16/09/15 - Luis Felipe
			
			("SZD")->(MSUNLOCK())
			
		EndIf
		
	EndIf

Else
	ApMsgStop("NF Remessa não será amarrada a um Contrato pois, nem todos os campos foram preenchidos ou a operação foi cancelada !")	
EndIf

Return()

Static Function ValidMae(cMaeOri,cMaeDes)

Local lRet := .t.
                                            
If cMaeOri == cMaeDes 
	Aviso("Atenção","Não é permitido informar como destino a mesma NF Mae de origem !",{"Voltar"})
	lRet := .f.
EndIf

Return( lRet )