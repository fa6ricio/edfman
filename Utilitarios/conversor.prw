#INCLUDE "PROTHEUS.CH"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CONVERSOR ºAutor  ³ Luis Felipe Nascimento³ Data  ³24/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                               º±±
±±ºDesc.     ³ PROGRAMA PARA CALCULAR PESO LIQUIDO E PESO BRUTO CONFORME     º±±
±±º          ³ O USUARIO INCLUI OS PRODUTOS NO PEDIDO DE VENDA. PREENCHEN-   º±±
±±º          ³ DO O TOTAL DO PESO LIQUIDO/BRUTO NO CABECALHO DO PV.          º±±
±±º          ³                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Conversor(cProd,nQtd)

Local aArea := GetArea()
Local _nQtd := nQtd
Local _cProd:= cProd

DbSelectarea("SB1")
If DbSeek(xFilial("SB1")+_cProd)
	If Empty(SB1->B1_TIPCONV) .or. Empty(SB1->B1_CONV)
		Aviso("ATENÇÃO" , "Favor checar o cadastro de produtos pois, os campos Tip.Conv e ou Fator estão vazios !", {"Voltar"})
	Else	
		If SB1->B1_TIPCONV == "D"
			_nQtd := _nQtd / SB1->B1_CONV
		Else
			_nQtd := _nQtd * SB1->B1_CONV
		EndIf
	EndIf
Else
	Aviso("ATENÇÃO" , "Produto inexistente !", {"OK"})
EndIf

Restarea(aArea)

Return(_nQtd)