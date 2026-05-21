#include "Protheus.ch"
/*
Função......: EecPem42()
Parametros..: Nenhum
Retorno.....: Nil
Objetivo....: Ponto de entrada do programa EECAE100, antes de chamar a função MBrouse.
Autor.......: Julio de Paula Paz
Data/Hora...: 03/08/2012 - 10:00
Observação..:
*/
User Function EecPem42()
Local lRet := .T., cParam := If(Type("PARAMIXB")== "A",ParamIxb[1],ParamIxb)

Begin Sequence
   Do Case
      Case cParam == "EMBARQUE"
           aAdd(aRotina,{"Cad.Containers","U_EecCadCntr",0,4})           
           aAdd(aRotina,{"Integra Cad.Cntr","U_EECIntCntr",0,4})
           aAdd(aRotina,{"Compl. Preço","U_EecComplPrc",0,4})
   End Case

End Sequence

Return lRet 
