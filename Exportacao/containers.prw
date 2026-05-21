/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Y1BROW   ³ Autor ³Walter Caetano da Silva³ Data ³ 30/08/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exemplo da fun‡Æo Modelo2                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Containers
#IFNDEF WINDOWS
        ScreenDraw("SMT050", 3, 0, 0, 0)
#ENDIF

cCadastro := "Exemplo da Fun‡Æo Modelo2"

aRotina := {	{ "Pesquisar"    ,"AxPesqui" , 0, 1},;
                { "Visualizar"   ,'U_ZAALT(2)' , 0, 2},;
                { "Incluir"      ,'ExecBlock("ZAINC",.F.,.F.)' , 0, 3},;
                { "Alterar"      ,'U_ZAALT(4)' , 0, 4},;
                { "Alocar"      ,'U_ALOCCON()' , 0, 5},;
                { "Saldos"      ,'U_CONSSALDO()' , 0, 6},;
                { "Excluir"      ,'ExecBlock("ZAEXC",.F.,.F.)' , 0, 7},;
                { "Relatorio"      ,'U_RELCONTAIN()' , 0, 8}}

dbSelectArea("SZA")
mBrowse( 6,1,22,75,"SZA")
Return
