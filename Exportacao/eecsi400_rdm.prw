#Include "protheus.ch"
#Include "topconn.ch"
#INCLUDE "eec.ch"
#include "DBTREE.ch"
#INCLUDE "eecsi400.ch"

/*
*****************************************************************************
 Programa: 	EECSI400_RDM
 Função	 :	Ponto de Entrada do Programa gerador de DDE de EXPORTAÇÃO
         :	para corrigir campo EEZ_PREEMB para as notas de Exportação
 Data	 : 	22/04/15
 Autor	 :	Luiz Pereira 
*****************************************************************************
*/

//-------------------------
   User Function EECSI400()
//-------------------------

Local cParam := If(Type("ParamIxb") = "A",ParamIxb[1],If(Type("ParamIxb") = "C",ParamIxb,""))

Do Case
	
   Case cParam == "PE_PREP"
     EEZ->(RECLOCK("EEZ",.F.))
        EEZ->EEZ_PREEMB := EEC->EEC_PREEMB 
        //Substr(cChaveEEZ,3,AVSX3("EEC_PREEMB",AV_TAMANHO))
     EEZ->(MSUnlock())
	
EndCase

Return