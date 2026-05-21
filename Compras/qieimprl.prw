#Include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#include "tbiconn.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIEIMPRL  ºAutor  ³YTTALO P. MARTINS   º Data ³  29/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³LOCALIZAÇÃO : Function a103Grava() - Responsável pela Gravacao± 
±±º           da Nota Fiscal de Entrada.                                   ±±
±±º                                                                        ±±
±±º           EM QUE PONTO : Ponto de Entrada utilizando integração com QIE.± 
±±º           Após inclusão do Documento de Entrada.                       ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ALTERA STATUS DA PRE NOTA NA TABELA DE RETAGUARDA SZD        ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION QIEIMPRL()                       
Local lExp01 := PARAMIXB[1]//OPERAÇÃO UTILIZADA

Private aAreaAtu  := GetArea()
//Private aAreaSF1  := SF1->(GetArea())
//Private aAreaSA2  := SA2->(GetArea())

IF (INCLUI == .F. .AND. ALTERA == .F.)
    
	If ( Type("xlEDFSZD") == "U" )//variável criada no PE MT100GRV
		Public xlEDFSZD := .F.
	EndIf
	
	If xlEDFSZD == .T.
	
		//-------------------------------------------------------------------
		//Atualiza STATUS SZD------------------------------------------------
		//-------------------------------------------------------------------
		xStatSZD()
	
	EndIf

ELSEIF INCLUI == .T. .AND. ALTERA == .F.
	
	//-------------------------------------------
	//mantida lógica encontrada no fonte antigo--
	//-------------------------------------------
	dbSelectArea("SA2")
	SA2->( dbSetOrder( 1 ) )
	If SA2->( DbSeek( xFilial( "SA2" ) + cA100For + cLoja  ) )
		
		RecLock("SF1",.F.)
		SF1->F1_XNOMFOR := SA2->A2_NOME
		("SF1")->(Msunlock())
		
	EndIf
							
ENDIF

RestArea(aAreaAtu)
//RestArea(aAreaSF1)
//RestArea(aAreaSA2)

RETURN()

***************************************************************************************************************************
Static Function xStatSZD()

LOCAL XCSTATUS := IIF( SF1->(DELETED()),"EX","AT" )

dbSelectArea("SA2")
SA2->( dbSetOrder( 1 ) )
If SA2->( DbSeek( xFilial( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA  ) )
	
	Begin Transaction
	
	//DELETA LINHAS REFERENTES AS DEMAIS ENTRADAS PARCIAIS
	cQuery4 := "UPDATE "+RetSQLName("SZD")+" SET "
	cQuery4 += "ZD_STATUS = '"+XCSTATUS+"' "
	cQuery4 += "WHERE ZD_FILIAL='"+xFilial("SZD")+"' "
	cQuery4 += "AND ZD_NFREMES = '" + SF1->F1_DOC + "' "
	cQuery4 += "AND ZD_SERIER = '" + SF1->F1_SERIE + "' "
	cQuery4 += "AND ZD_CNPJUSI = '" + SA2->A2_CGC + "' "
	cQuery4 += "AND ZD_PARC = '01' " 
	cQuery4 += "AND ZD_STATUS <> 'EX' " // 12/09/13 - Luís Felipe Nascimento
	cQuery4 += "AND D_E_L_E_T_ = ' '; "
	
	If TCSQLExec( cQuery4 ) <> 0
		UserException("Falha na Atualização da tabela XML-Template - " + TCSQLError() )
		
		DisarmTransaction()
		
		Break
	EndIf
		
	End Transaction
	
EndIf


Return()