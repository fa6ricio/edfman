#include "rwmake.ch"
#include 'protheus.ch'

/*/{Protheus.doc} MT103IPC
Ponto de Entrada na amarracao do pedido de compra na nota fiscal de entrada 
Finalidade: atualizar campo D1_ZZDESCR (Descricao do Prod).

@type		Function
@author 	Fabricio Antunes -  TOTVS IP Campinas
@since		02/10/2025
@return	lRet
/*/

User Function MT103IPC()

	Local nItem		:= PARAMIXB[1]
	Local nPosDesc	:= GDFIELDPOS("D1_XDESCRI")

	If nPosDesc > 0 .and. nItem > 0
		aCols[ nItem , nPosDesc ] := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")
	Endif

Return
