#Include "Protheus.Ch"
#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA012   ºAutor  ³YTTALO P MARTINS    º Data ³  18/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ROTINA CHAMADA NO ESTORNO CLASSIFICAÇÃO E EXCLUSÃO DA NOTA  º±±
±±º          ³PARA EXCLUSÃO DO TÍTULO CRIADO NA FONTE PRENFE.PRW          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION EDFA012()
LOCAL aArray := {}
LOCAL cQuery := ""
 
PRIVATE lMsErroAuto := .F.

If Select("TMPSE2") > 0
	dbSelectArea("TMPSE2")
	("TMPSE2")->(DbCloseArea())
Endif

cQuery:=" SELECT * FROM "+RetSqlname("SE2")+" "                                                                                
cQuery+=" WHERE E2_FILIAL = '"+XFILIAL("SE2")+"' "
cQuery+=" AND E2_NUM = '"+SF1->F1_DOC+"' "
cQuery+=" AND E2_PREFIXO = '"+SF1->F1_SERIE+"' "
cQuery+=" AND E2_FORNECE = '"+SF1->F1_FORNECE+"' "
cQuery+=" AND E2_LOJA = '"+SF1->F1_LOJA+"' "
cQuery+=" AND E2_ORIGEM = 'PRENFE' "
cQuery+=" AND D_E_L_E_T_= ' ' "

cQuery := ChangeQuery(cQuery)

DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMPSE2",.F.,.T.)

DbSelectArea("TMPSE2")
("TMPSE2")->(dbGotop())

If ("TMPSE2")->(!EOF())    
 
	DbSelectArea("SE2")  
	dbGoto(("TMPSE2")->R_E_C_N_O_)
	                                 
	aArray := { { "E2_PREFIXO" , SE2->E2_PREFIXO , NIL },;
	                { "E2_NUM"     , SE2->E2_NUM     , NIL } }
	 
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	 
	If lMsErroAuto
	    MostraErro()
	Else
	    //Alert("Exclusão do Título com sucesso!")
	Endif

EndIf

If Select("TMPSE2") > 0
	dbSelectArea("TMPSE2")
	("TMPSE2")->(DbCloseArea())
Endif
 
Return