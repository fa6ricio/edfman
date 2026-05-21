#Include "PROTHEUS.Ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F240FIL  ºAutor  ³Luis Felipe Nascimento ³Data ³ 14/06/18  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada - Filtro sobre a rotina FINA240- Bordero  º±±
±±º          ³e                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ED&F Man                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºObjetivo  ³ Criar filtro complementar a  ranger doctos de saída.		  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºAlteração ³                 		    								  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F240FIL()

Local cPerg     := "EDFPR01"
Local aArea		:= GetArea()
Local cFiltro	:= ""

//alert("F240FIL")

Criasx1(/*cPerg*/)

cMv_Par01 := MV_PAR01

If !Pergunte(cPerg,.T.)
	MV_PAR01 := cMv_Par01
	Restarea(aArea)
	Return cFiltro
EndIf

If !Empty(MV_PAR01)
	cFiltro := "E2_FORNECE = '"+MV_PAR01+"'" 
EndIf

MV_PAR01 := cMv_Par01 

Restarea(aArea)

Return cFiltro

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                        4                       5                        6           7     8   9   10  11    12   13           14      		  15      16      17   18   19      	  20    21     22   23   24           25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40  41  42  43
AADD(aSx1,{"EDFPR01" , "01" , "Fornecedor ?        " , "Fornecedor ?        " , "Fornecedor ?        " , "mv_ch1" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par01" , ""           , ""    , ""    , "" , "" , ""          , ""  , ""   , "" , "" , ""         , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SA2" , "" , "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFPR01   01")
	
	DbSeek("EDFPR01")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFPR01"
		Reclock("SX1",.F.,.F.)
		DbDelete()
		MsunLock()
		DbSkip()
	End
	
	For X1:=1 to Len(aSX1)
		RecLock("SX1",.T.)
		For Z:=1 To FCount()
			FieldPut(Z,aSx1[X1,Z])
		Next
		MsunLock()
	Next
	
Endif*/

Return
