#Include "PROTHEUS.Ch"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ F240FIL  บAutor  ณLuis Felipe Nascimento ณData ณ 14/06/18  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada - Filtro sobre a rotina FINA240- Bordero  บฑฑ
ฑฑบ          ณe                                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ED&F Man                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบObjetivo  ณ Criar filtro complementar a  ranger doctos de saํda.       บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบAltera็ใo ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function F240FIL()

Local cPerg     := "EDFPR01"
Local aArea     := GetArea()
// Inicializa a variแvel jแ com a condi็ใo que deve estar SEMPRE presente
Local cFiltro   := "E2_ZZBLQPG <> '2'" 

//alert("F240FIL")

Criasx1(/*cPerg*/)

cMv_Par01 := MV_PAR01

If !Pergunte(cPerg,.T.)
    MV_PAR01 := cMv_Par01
    Restarea(aArea)
    // Se cancelar, ele retorna "E2_ZZBLQPG <> '2'"
    Return cFiltro
EndIf

// Se passou pelo Pergunte e digitou fornecedor, adiciona ao filtro base
If !Empty(MV_PAR01)
    cFiltro += " .AND. E2_FORNECE = '"+MV_PAR01+"'" 
EndIf

MV_PAR01 := cMv_Par01 

Restarea(aArea)

Return cFiltro

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                        4                        5                        6          7      8   9   10  11    12   13           14              15      16      17   18   19            20    21     22   23   24           25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40  41  42  43
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
