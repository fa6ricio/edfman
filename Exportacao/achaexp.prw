#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AchaEXP  º Autor ³ Luiz Pereira        º Data ³  27/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Execblock Utilizando no ponto de entrada EEC_DTEMB de      º±±
±±º          ³ sequencia 003 para nao permitir que a data de encerramento º±±
±±º          ³ seja digitada se existir uma invoice vinculada ao embarque º±±
±±º          ³ na tabela EXPs											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ED&Fman                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*************************
User Function AchaEXP()
	*************************
	Local aArea     := GetArea()
	Local aAreaEE9  := EE9->(GetArea())
	Local _dRet		:= M->EEC_DTEMBA
	Public dDataOLD := M->EEC_DTEMBA

	//12-01-2026 - Thiago Reis
	EE9->(DbSetOrder(2))
	if EE9->(Dbseek(xFilial("EE9")+M->EEC_PREEMB))

		if Posicione("SB1",1,xFilial("SB1")+AllTrim(EE9->EE9_COD_I),"B1_XCONTCT") == "2" //2-Não
			RestArea(aArea)
			RestArea(aAreaEE9)
			Return (_dRet)
		endif

	endif
	//

	If WorkInv->(Eof() .And. Bof()) .And. !Empty(M->EEC_DTEMBA) // Se não houver Invoice Cadastrada
		MsgStop("Necessário incluir a Invoice para digitação da data de encerramento!"+chr(13)+chr(10)+"Digitação Dta Embarque/Encerramento será cancelada!")
		dDataOLD := Ctod("  /  /  ")
	Endif

	RestArea(aArea)
	RestArea(aAreaEE9)

Return(dDataOLD)
