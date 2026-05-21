#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ COMCOLRT   ³ Autor ³ Luis Felipe Mattos	³ Data ³ 13.09.16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Botão na rotina de Monitoramento do Totvs Colaboração	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso 		 ³ COMXCOL                                              	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Estornar o status de documentos gerados que por alguma fa- ³±±
±±³          ³ lha não gerou pré-nota.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³                                            Data:   /  /    ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±³Parametros³ Nenhum													  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// ----------- Elementos contidos por dimensao ------------
// 1. Nome a aparecer no cabecalho                            
// 2. Nome da Rotina associada                                
// 3. Usado pela rotina                                       
// 4. Tipo de Transacao a ser efetuada                        
//    1 - Pesquisa e Posiciona em um Banco de Dados           
//    2 - Simplesmente Mostra os Campos                       
//    3 - Inclui registros no Bancos de Dados                 
//    4 - Altera o registro corrente                          
//    5 - Remove o registro corrente do Banco de Dados        
//    6 - Altera determinados campos sem incluir novos Regs

User Function ComColRt()

Local aRotina := ParamIxb[1]

AAdd( aRotina,{ 'Estorno NF', 'U_Estorno',0,4,0,NIL} )

Return( aRotina )               

*-----------------------*
User Function Estorno()
*-----------------------*

SF1->(DbSetOrder(1))
If	!SF1->(DbSeek(xFilial("SF1")+SDS->(DS_DOC+DS_SERIE+DS_FORNEC+DS_LOJA+DS_TIPO))) 
	SDS->(RecLock("SDS",.F.))  
	SDS->DS_STATUS := ''
	SDS->(MsUnLock())
Else
	Alert("Para estornar este documento é necessário acessar a rotina de Pré-Nota !")	
EndIf

Return