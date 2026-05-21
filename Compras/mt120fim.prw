#include 'TOPCONN.CH'
#include 'RWMAKE.CH'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120FIM  ºAutor  ³YTTALO P MARTINS    º Data ³  23/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³O ponto se encontra no final da função A120PEDIDO. Após a    ±±
±±º           restauração do filtro da FilBrowse depois de fechar a operação± 
±±º           realizada no pedido de compras, é a ultima instrução da função± 
±±º           A120Pedido.                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RETORNAR SALDO PARA O CONTRATO                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120FIM()

Local nOpcao := PARAMIXB[1]   // Opção Escolhida pelo usuario 
Local cNumPC := PARAMIXB[2]   // Numero do Pedido de Compras
Local nOpcA  := PARAMIXB[3]   // Indica se a ação foi Cancelada = 0  ou Confirmada = 1.CODIGO DE APLICAÇÃO DO USUARIO.....
Local _aArea := GetArea()
LOCAL cQuery := ""

IF nOpcA == 1 .AND. nOpcao == 5//EXCLUSÃO

	If Select("TMPSC7") > 0
		dbSelectArea("TMPSC7")
		("TMPSC7")->(DbCloseArea())
	Endif
	
	cQuery:=" SELECT * FROM "+RetSqlname("SC7")+" "                                                                                
	cQuery+=" WHERE C7_FILIAL = '"+XFILIAL("SC7")+"' "
	cQuery+=" AND C7_NUM = '"+cNumPC+"' "
	
	cQuery := ChangeQuery(cQuery)
	
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMPSC7",.F.,.T.)
	
	DbSelectArea("TMPSC7")
	("TMPSC7")->(dbGotop())
	
	If ("TMPSC7")->(!EOF())    
	 
		DbSelectArea("SC7")  
		dbGoto(("TMPSC7")->R_E_C_N_O_)
	
		Dbselectarea("SZ7")
		DbSetOrder(3)   
		If SZ7->(Dbseek(xFilial("SZ7")+SC7->C7_CONTRAT+SC7->C7_XPERIOD+SC7->C7_NRMEDIA))
		
			RecLock("SZ7" ,.F.)
				SZ7->Z7_SALDO += SC7->C7_QUANT
				
				If SZ7->Z7_SALDO == SZ7->Z7_QTDE
					SZ7->Z7_STATUS	:= ""
				endif		
				
			MsUnlock()
		
		EndIf	                                 
	
	
	EndIf
	
	If Select("TMPSC7") > 0
		dbSelectArea("TMPSC7")
		("TMPSC7")->(DbCloseArea())
	Endif

ENDIF

RestArea(_aArea)

Return



            	   