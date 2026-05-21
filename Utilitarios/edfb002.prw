#Include "PROTHEUS.Ch"
#include "rwmake.ch"
#include "topconn.ch"

#DEFINE CENT	Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFB002  º Autor ³ Luis Felipe Nascim.º Data ³  11/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Visto que a média de produtos com bolsa fixada são informa-º±±
±±º          ³ dos manualmente sobre o campo uma campo de observações da  º±±
±±º          ³ da tabela de precificação de contratos SZ5 e relatório     º±±
±±º          ³ Transfer Price precisa dessa informação para compor sua re-º±±
±±º          ³ gra de calculo. Tornou-se necessário criar um novo campo   º±±
±±º          ³ para atender a essa necessidade e evitar possíveis de di-  º±±
±±º          ³ gitação. (Z5_MBOLSA)                                       º±±
±±º          ³ Essa programa visa transcrever os valores fixados nos campoº±±
±±º          ³ Z5_FIX100 p/ Z5_MBOLSA.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EDFB002()

Local aArea		:= GetArea()

Processa({|lEnd|Atualiza()})

Restarea(aArea)

Return

*-------------------------------*
Static Function Atualiza()
*-------------------------------*
Local nCountnx 	:= 0
Local nCount 	:= 0
Local cValor 	:= ''
Local nValor 	:= 0  
Local nx		:= 0

*-------------------------------*
*   Conta Total de Registros.   *
*-------------------------------*
DbSelectArea("SZ5")
SZ5->(DbSetOrder(1))
SZ5->(DbGoTop())
While SZ5->(!Eof())
	If SubStr(SZ5->Z5_FIX100,1,1) $ "1234567890"
		nCountnx ++
	EndIf
	SZ5->(DbSkip())
End
SZ5->(DbGoTop())

ProcRegua(nCountnx)

While SZ5->(!EOF())
	
	If SubStr(SZ5->Z5_FIX100,1,1) $ "1234567890"
		
		nCount ++
		
		IncProc("Processando correção ..."+Str(nCount,3)+"/"+Str(nCountnx,3))
		
		cValor := ''
		
		For nx:=1 to Len(SZ5->Z5_FIX100)
			If SubStr(SZ5->Z5_FIX100,nx,1) $ ",1234567890"
				If SubStr(SZ5->Z5_FIX100,nx,1) == ","
					cValor := cValor + '.'
				Else
					cValor := cValor + SubStr(SZ5->Z5_FIX100,nx,1)
				EndIf	
			Else
				Exit
			EndIf
		Next
		 
		nValor := Val(cValor)
		
		SZ5->(RecLock("SZ5",.f.))
		SZ5->Z5_MBOLSA := nValor
		SZ5->(MsUnlock())
		
	EndIf
	
	SZ5->(DbSkip())

End

Return
