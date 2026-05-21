#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFC006   º Autor ³ Luis Felipe Mattos º Data ³  05/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Códigos de Serviços                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function EDFC006()

Local aRotAdic :={}
Local bPre := {||MsgAlert('Chamada antes da função')}
Local bOK  := {||MsgAlert('Chamada ao clicar em OK'), .T.}
Local bTTS  := {||MsgAlert('Chamada durante transacao')}
Local bNoTTS  := {||MsgAlert('Chamada após transacao')}
Local aButtons := {}//adiciona botões na tela de inclusão, alteração, visualização e exclusao
Private cMV_XTBSX5 := SuperGetMv("MV_XTBSX5", , "60" )

// aadd(aButtons,{ "PRODUTO", {|| MsgAlert("Teste")}, "Teste", "Botão Teste" }  ) //adiciona chamada no aRotina
// aadd(aRotAdic,{ "Adicional","U_Adic", 0 , 6 })
// AxCadastro("SX5", "CODIGOS DE SERVICOS DO ISS", "U_DelOk()", "U_COK()", aRotAdic, bPre, bOK, bTTS, bNoTTS, , , aButtons, , )

AxCadastro("SX5", "CADASTRO DE TABELAS 'SX5'", "U_DelOk()", "U_COK()", , , , , , , , , , )

Return(.T.)

*-------------------*
User Function DelOk()
*-------------------*
/*If SX5->X5_TABELA $ cMV_XTBSX5
	SX5->(RecLock("SX5",.F.))
	Delete
	SX5->(Msunlock())
Else
	Alert("As únicas operações nesta tabela são de Inclusão, Alteração e Exclusão sobre a(s) tabela(s) => "+Alltrim(cMV_XTBSX5)+" !")
EndIf*/
Alert("A SX5 não foi ajustada, realizar manutenção via sigacfg "+Alltrim(cMV_XTBSX5)+" !")
Return

*-----------------*
User Function COK()
*-----------------*
Local lRet := .t.
If !M->X5_TABELA $ cMV_XTBSX5
	Alert("As únicas operações nesta tabela são de Inclusão, Alteração e Exclusão sobre a(s) tabela(s) => "+Alltrim(cMV_XTBSX5)+" !")
	lRet := .f.
EndIf
Return lRet

/**------------------*
User Function Adic()
*------------------*
MsgAlert("Rotina adicional")
Return*/  
