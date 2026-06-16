#INCLUDE "PROTHEUS.CH"
#Include "Totvs.ch"
#Include "FwMvcDef.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*
______________________________________________________________________________
|_____________________________________________________________________________|
|Programa  - SE5FI080    Autor  Fabricio Antunes      Data   16/06/2026   	  |
|_____________________________________________________________________________|
|Descricao|O ponto de entrada F80GRVFK sera executado para gravar dados       |
|         |complementares das tabelas FK´s.                                   |
|         |Utilizaremos para enviar dados das baixas para Simplefarm e        | 
|         |alimentar customizacao de contratos de algodao                     |
|_________|___________________________________________________________________|
|Uso      | ED & F                                                            | 
|_________|___________________________________________________________________|
|_____________________________________________________________________________|
*/


User Function SE5FI080()

Local cCamposE5 := ParamIxb[1] 
Local oSubModel := ParamIxb[2]

If oSubModel:cID == "FK2DETAIL" 
    If "NOR" $ oSubModel:GetValue("FK2_MOTBX") 

    EndIf 
EndIf

Return cCamposE5
