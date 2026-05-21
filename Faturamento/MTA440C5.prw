#Include "Totvs.ch"
 
//=================================================================================
/*/{Protheus.doc} MTA440C5
[SC5] Inclui Campos na Lista de Campos com permissão de alteração na 
liberação do Pedido de Venda [MATA440]
 
@type        function
@author         Thiago.Andrrade
@since        16/03/2021
@version    1.0    
/*/
//=================================================================================
User Function MTA440C5()
    Local aArea := GetArea()
    Local aCposC5 := {}
 
    aCposC5 := {"C5_XMENNOT"}
 
    RestArea(aArea)
Return(aCposC5)
