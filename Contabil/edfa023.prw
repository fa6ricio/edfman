#include "rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFA023  ºAutor  ³ Luis Felipe Nascimento  º Data ³  03/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada executado a partir da confirmação do cadastro  º±±
±±º          ³ de clientes.                                        	           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                     		   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³ Armazenar na tabela SZM o histórico das Variações Monetárias.  º±±
±±º          ³ Com a atualização da P12 o sistema passou a excluir os históri- º±±
±±º          ³ co das variações cambiais dos contratos sobre a tabela SE5.     º±±
±±º          ³ Os dados gravados na SZM irão compor o relatório de Variação    º±±
±±º          ³ Cambial EDFR023.prw.                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA023()

Local _aArea := GetArea()
Local cCampo1:= ''
Local cCampo2:= ''
Private nLastKey:= 0
Private cPerg:= "EDFA023"
Private cCampos:= '' // Campos alterados

CriaSx1()
     
IF !Pergunte(cPerg,.T.)
	RETURN
ENDIF

If LastKey() == 27
	Return
Endif

/*SX3->(DbSetOrder(1))
SX3->(DbSeek('SE5'))

While !SX3->(Eof()) .and. SX3->X3_ARQUIVO == 'SE5'
	If X3Uso(SX3->X3_USADO)
		nRegSX3 := SX3->(Recno())
		SX3->(DbSetOrder(2))
		cCampo := Alltrim(SX3->X3_CAMPO)
		If SX3->(DbSeek(Alltrim("ZM_"+SubStr(SX3->X3_CAMPO,4,10))))
			cCampo1 := "M->"+cCampo
			cCampo2 := "SE5->"+cCampo
			If  SX3->X3_CONTEXT <> 'V'
				If	&cCampo1 <> &cCampo2
					cCampos += Alltrim(SX3->X3_TITULO)+" / "
				EndIf
			EndIf
		Else
			Alert("Atenção : O campo "+cCampo+" foi criado sobre a tabela de clientes SE5 e para o correto funcionamento da rotina atualização do histórico este campo precisa ser criado sobre a tabela SZM !")
		EndIf
		SX3->(DbSetOrder(1))
		SX3->(DbGoto(nRegSX3))
	Endif
	SX3->(DbSkip())
End

If	Len(cCampos) > 2
	Processa( {|| fCopiaSE5()},"Iniciando Copia...")
EndIf

MsUnLockAll()

RestArea(_aArea)*/

Return

*-------------------------*
Static Function fCopiaSE5()
*-------------------------*

/*Local aArea2 := GetArea()
Local nCount := 0 
Local nTrans := 0 

aSZM := {}

DbSelectArea("SZM")
SZM->(DbsetOrder(1))

DbSelectArea("SE5")
If Empty(MV_PAR01)
	SE5->(DbsetOrder(0))
	SE5->(DbGotop())
Else
	SE5->(DbsetOrder(1))
	SE5->(DbSeek(xFilial("SE5")+DtoS(MV_PAR01),.t.))
EndIf

ProcRegua(LastRec())

While SE5->(!Eof())
	
	nCount ++
	
	IncProc("Transferidos "+Str(nTrans,5)+" / "+Str(nCount,5))

	If SE5->E5_TIPODOC <> "VM" .or. SE5->E5_RECPAG <> "P"
		SE5->(DbSkip())
		Loop
	EndIf
	
	DbSelectArea("SZM")
	If !DbSeek(SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ))
		
		nTrans ++ 
	
		*-----------------------------------------------------------------------------------*
		* Transmite campos do cadastro de Movimentacoes Bancarias para o array
		*-----------------------------------------------------------------------------------*
		
		DbSelectArea("SE5")
		For nX:= 1 To FCount()
			Aadd(aSZM, {fieldname(nX), fieldget(nX)})
		Next
		
		*-----------------------------------------------------------------------------------*
		* Gera registro na SZM
		*-----------------------------------------------------------------------------------*
		
		DbSelectArea("SZM")
		SZM->(RecLock("SZM",.T.))
		For i:=1 to Len(aSZM)
			cCampo  := "SZM->ZM_"+SubStr(aSZM[i][1],4,10)
			&cCampo :=  aSZM[i][2]
		Next
		SZM->ZM_REGSE5 := SE5->(RECNO())
		
		MsunLock()
	EndIf  
	SE5->(DbSelectArea("SE5"))
	SE5->(DbSkip())
End

RestArea(aArea2)*/

Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                        4                        5                        6           7     8   9   10  11    12   13           14           15      16      17   18   19               20      21      22      23   24        25   26   27   28   29        30   31   32   33   34   35   36   37   38        39   40  41  42   43
AADD(aSx1,{"EDFA023" , "01" , "Data Início   	  ?" , "Data Início   	   ?" , "Data Início   	    ?" , "mv_ch1" , "D" , 08 , 0 , 0 , "G" , "" , "MV_PAR01" , ""         , ""    , ""    , "" , "" , ""             , ""    , ""    , ""    , "" , ""      , "" , "" , "" , "" , ""      , "" , "" , "" , "" , "" , "" , "" , "" , ""      , "" , "", "", "" , ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFA023   01")
	
	DbSeek("EDFA023")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFA023"
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

