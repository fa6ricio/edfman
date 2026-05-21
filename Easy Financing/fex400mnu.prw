
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFEX400MNU บAutor  ณLeandro Ribeiro     บ Data ณ  05/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para inclusใo de rotinas no menu de a็๕es บฑฑ
ฑฑบ          ณ relacionadas na tela de manuten็ใo de contratos ACC.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FEX400MNU()  

Local aRotina := {}     

If nModulo == 30
   aAdd(aRotina, { "Pesquisar"      , "AxPesqui"  , 			 0, 1})//"Pesquisar"
   aAdd(aRotina, { "Visualizar"     , "EX400Manut", 			 0, 2})//"Visualizar"
   aAdd(aRotina, { "Incluir"        , "EX400Manut", 			 0, 3})//"Incluir"
   aAdd(aRotina, { "Alterar"        , "EX400Manut", 			 0, 4})//"Alterar"
   aAdd(aRotina, { "Estornar"       , "EX400Manut", 			 0, 5})//"Estornar"
   aAdd(aRotina, { "Hist๓rico"      , "EX400CHist", 			 0, 6})//"Hist๓rico"
   aAdd(aRotina, { "Copiar"         , "EX401Copia", 			 0, 7})//"Copiar"
   aAdd(aRotina, { "Tot.p/Contrato" , "EX401TotCo", 			 0, 8})//"Tot.p/Contrato"
Else
   aAdd(aRotina, { "Pesquisar"      , "AxPesqui"  , 0, 1})//"Pesquisar"
   aAdd(aRotina, { "Visualizar"     , "EX400Manut", 0, 2})//"Visualizar"
EndIf     


If(FunName() == "EFFEX400")               

    Aadd(aRotina,{"Calculo de Varia็ใo Cambial","U_EDFA017"   ,0,4,0,nil}) 
    
Endif  


Return(aRotina)