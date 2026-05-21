#Include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103NFE  ºAutor  ³YTTALO P. MARTINS   º Data ³  01/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³LOCALIZAÇÃO : Function A103NFiscal() - CHAMADA DE QUALQUER   ±±
±±ºROTINA DA NFE                                                           ±±
±±º           EM QUE PONTO : Ao acessar uma das opcoes da NFE (2=Visualiza/±±
±±º3=Incluir/ 4=Classificar/ 5=Excluir)                                    ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ESTORNA MOVIMENTAÇÕES INTERNAS E TRANSFERÊNCIAS ANTES DA    º±±
±±º          ³ABERTURA DA TELA PARA ESTORNO DA CLASSIFICAÇÃO E EXCLUSÃO DA ±±
±±º           NF DE ENTRADA. CASO A OPERAÇÃO SEJA CANCELADA AS MOVIMENTAÇÕES±
±±º           E TRANSFERÊNCIAS ESTORNADAS SERÃO REFEITAS                   ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ RDM_045_Estorno_de_Calssificacao_NF_Mae                    º±±
±±º          ³ As NF´s Mãe tem uma particularidade quanto a geração do ti- ±±
±±º          ³ tulo a pagar o qual é criado via MSExecAuto através do fon- ±±
±±º          ³ te PRENFE. Sendo assim, a rotina padrão não permite excluir ±±
±±º          ³ exceto se o titulo for excluido primeiro. Para que isso se -±±
±±º          ³ tornasse possível alterada a origem de criação do titulo    ±±
±±º          ³ para MATA100. (E2_ORIGEM)                                   ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103NFE()

Local xnOpc := PARAMIXB
Local lRet  := .T.

Private aAreaAtu  := GetArea()

IF xnOpc == 5
	
	Private cAliasSD3 := ""
	Private cAliasSD1 := ""
	Private cAliasSZD := ""
	Private cQuery    := ""
	Private cQuery2   := ""
	Private cQuery3   := ""
	Private cQuery4   := ""
	Private aVetMov   := {}
	Private aVetTransf:= {}
	Private aAreaSF1  := SF1->(GetArea())
	Private aAreaSA2  := SA2->(GetArea())
	Private aAreaSC7  := SC7->(GetArea())
	Private aAreaSB2  := SB2->(GetArea())
	Private aAreaSF4  := SF4->(GetArea())
	Private _aArea
	Private _aArea2
	
	Private lMsErroAuto := .F.
	Public xEDFD3Seq := {}
	
	//-------------------------------------------------------------------------------------------------------------------------------------
	//Verifica se a nota a ser estornada classificação/excluída é um NF Mãe, se for, verifica se existe NF remessa na tabela da retaguarda,
	//se existir não permite o estorno da classificação ou exclusão desta NF mãe.
	//-------------------------------------------------------------------------------------------------------------------------------------
	lRet := xDelNFMae()
	
	If lRet == .T.
		
		cAliasSD1 := GetNextAlias()
		cQuery := "SELECT * FROM "+RetSqlName("SD1")+" SD1 "
		cQuery += "WHERE SD1.D1_FILIAL='"+xFilial("SD1")+"' "
		cQuery += "AND SD1.D1_DOC='"+SF1->F1_DOC+"' "
		cQuery += "AND SD1.D1_SERIE='"+SF1->F1_SERIE+"' "
		cQuery += "AND SD1.D1_FORNECE='"+SF1->F1_FORNECE+"' "
		cQuery += "AND SD1.D1_LOJA='"+SF1->F1_LOJA+"' "
		cQuery += "AND SD1.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA "
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
		
		dbSelectArea(cAliasSD1)
		(cAliasSD1)->(dbGotop())
		If (cAliasSD1)->(!EOF())
			
			Begin Transaction
			
			cAliasSD3 := GetNextAlias()
			cQuery2 := "SELECT * FROM "+RetSqlName("SD3")+" SD3 "
			cQuery2 += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' "
			cQuery2 += "AND SD3.D3_XD1NSEQ = '" + (cAliasSD1)->D1_NUMSEQ + "' "
			cQuery2 += "AND SD3.D3_ESTORNO = ' ' "
			cQuery2 += "AND SD3.D_E_L_E_T_ = ' ' "
			cQuery2 += "ORDER BY D3_NUMSEQ DESC "
			
			cQuery2 := ChangeQuery(cQuery2)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAliasSD3,.T.,.T.)
			
			dbSelectArea(cAliasSD3)
			(cAliasSD3)->(dbGotop())
			
			If (cAliasSD3)->(!EOF())
				
				While (cAliasSD3)->(!EOF())
					
					If aScan(xEDFD3Seq,{|x| x[1]==(cAliasSD3)->D3_NUMSEQ} ) == 0
						
						AADD( xEDFD3Seq,{(cAliasSD3)->D3_NUMSEQ,(cAliasSD1)->D1_NUMSEQ} )
						
					EndIf
					
					_aArea2 := GetArea()
					
					
					lMsErroAuto := .F.
					//-------------------------------------------------------------------
					//estorna movimentações internas-------------------------------------
					//-------------------------------------------------------------------
					If SUBSTR( (cAliasSD3)->D3_CF,1,2) <> 'PR' .AND. !( SUBSTR((cAliasSD3)->D3_CF,3,1) $ "2#4#5#7" )
						
						xEstMovInt()
						
					EndIf
					
					If lMsErroAuto == .F.
						//-------------------------------------------------------------------
						//estorna transferências---------------------------------------------
						//-------------------------------------------------------------------
						If (cAliasSD3)->D3_CF = 'DE4' .OR. (cAliasSD3)->D3_CF = 'RE4'
							
							lMsErroAuto := !(U_EDFA008())
							
							If lMsErroAuto
								MostraErro()
								
								MsgAlert("Erro: Transferência(XML-Template) não estornada!")
								
							EndIf
							
						EndIf
						
					EndIf
					
					
					RestArea(_aArea2)
					
					
					lRet := IIF(lMsErroAuto == .T.,lRet := .F., lRet := .T.)
					
					If lRet == .F.
						
						DisarmTransaction()
						Break
						
					EndIf
					
					(cAliasSD3)->(dbSkip())
				EndDo
				
			EndIF
			
			dbSelectArea(cAliasSD3)
			(cAliasSD3)->(dbCloseArea())
			
			End Transaction
			
			
		EndIf
		
		
		dbSelectArea(cAliasSD1)
		(cAliasSD1)->(dbCloseArea())
		
	EndIF
	
	RestArea(aAreaSF1)
	RestArea(aAreaSA2)
	RestArea(aAreaSC7)
	RestArea(aAreaSB2)
	RestArea(aAreaSF4)
	
ENDIF

RestArea(aAreaAtu)

RETURN(lRet)

*********************************************************************************************************************************************

Static Function xEstMovInt()

aVetMov := {}

aAdd(aVetMov, {"D3_NUMSEQ" , (cAliasSD3)->D3_NUMSEQ   , Nil})
aAdd(aVetMov, {"INDEX"     , 4        , Nil})

dbSelectArea("SD3")
MSExecAuto({|x,y| MATA240(x,y)}, aVetMov, 5) //5-Estorno

If lMsErroAuto
	MostraErro()
	
	MsgAlert("Erro: Movimentação(XML-Template) não estornada!")
	
EndIf

Return()

*********************************************************************************************************************************************

Static Function xDelNFMae()

Local lOk := .T.
Local lExclui := .f.

cAliasSZD := GetNextAlias()
cQuery3 := "SELECT * FROM "+RetSQLName("SZD")+" SZD "
cQuery3 += "WHERE ZD_FILIAL='"+xFilial("SZD")+"' "
cQuery3 += "AND ZD_NFMAE='"+SF1->F1_DOC+"' "
cQuery3 += "AND ZD_SERIEM='"+SF1->F1_SERIE+"' "
cQuery3 += "AND ZD_STATUS<>'EX'"
cQuery3 += "AND D_E_L_E_T_ = ' ' "
cQuery3 := ChangeQuery(cQuery3)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery3),cAliasSZD,.T.,.T.)

dbSelectArea(cAliasSZD)
(cAliasSZD)->(dbGotop())
If (cAliasSZD)->(!EOF())
	lOk := .F.
	Aviso("Aviso","Esta é uma NF mãe e ainda possui NF(s) de remessa na tabela de retaguarda, portanto, esta operação será cancelada!",{"Voltar"})
EndIf

/* 03/03/15 - Luís Felipe Nascimento - Inicio
// RDM_045_Estorno_de_Calssificacao_NF_Mae
*/
If  !Empty(SF1->F1_DUPL) .and. SF1->F1_DOC == SF1->F1_NFMAE .and. lOk
	SE2->(DbSetOrder(6))
	If SE2->(DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC))
		Reclock("SE2",.f.)
		SE2->E2_ORIGEM := "MATA100"
		Msunlock()
	EndIf
EndIf
// 03/03/15 - Luís Felipe Nascimento - Fim

Return(lOk)
