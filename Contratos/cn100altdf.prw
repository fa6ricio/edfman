#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CN100DtFim  ³ Autor ³ Marcelo Custodio      ³ Data ³13.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Calcula data final de acordo com a vigencia escolhida        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ dExp01 := CN100DtFim(cExp02,dExp03,cExp04)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dExp01 - Data calculada                                      ³±±
±±³          ³ cExp04 - Tipo de Vigencia                                    ³±±
±±³          ³          "1" - Dias                                          ³±±
±±³          ³          "2" - Meses                                         ³±±
±±³          ³          "3" - Anos                                          ³±±
±±³          ³ cExp02 - Data calculada                                      ³±±
±±³          ³ dExp03 - Vigencia                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CN100ALTDF(cTipV,dDtIni,nVig)

Local nx
Local dDtUsr  
Local nDiaIni

Default cTipV := If(!Empty(M->CN9_UNVIGE),M->CN9_UNVIGE,'1')
Default dDtIni:= M->CN9_DTINIC
Default nVig := M->CN9_VIGE

Do Case
	Case cTipV == "1"//Dia
		dDtIni += nVig
	Case cTipV == "2"//Mes  
		nDiaIni := Day(dDtIni) //Dia do início do contrato.
		For nX:=1 to nVig    
			dDtIni += CalcAvanco(dDtIni,.F.,.F.,nDiaIni) 
		Next
	Case cTipV == "3"//Ano
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida ano bissexto                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		if Day(dDtIni) == 29 .And. Month(dDtIni) == 2 .And. ((Year(dDtIni)+nVig) % 4 != 0)
			dDtIni := cTod("28/02/"+str(Year(dDtIni)+nVig))
		else
			dDtIni := cTod(str(Day(dDtIni))+"/"+str(Month(dDtIni))+"/"+str(Year(dDtIni)+nVig))
		EndIf
	Case cTipV == "4"//Indeterminada
		dDtIni := CTOD("31/12/49")//Retorna data limite do sistema
EndCase

Return dDtIni