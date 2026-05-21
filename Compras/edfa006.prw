#include "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA006   ºAutor  ³Leandro Ribeiiro    º Data ³  17/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para o preenchimento da tabela Detalhamento dos     º±±                                                     
±±º          ³ Premio (SZF) rotina executada dentro da validação dos      º±±
±±º          ³ campos da tabela SZ3.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA006()
lOCAL nx
	Local _cEDFA006   := GetArea()
/* // 11/10/17- Luis Felipe
Local _BkpHeader  := aClone(aHeader) //Backup do aHeader da tela anterior
Local _BkpaCols   := aClone(aCols)   //Backup do aCols da tela anterior
*/
	Local _BkpHeader  := {}
	Local _BkpaCols   := {}
	Local cContrato   := Space(15)
	Local cPeriodo	  := Space(5)
	Local cPremio	  := Space(10)
	Local _LinAcols   := 0 // n // Preservar a posição do Acols // 11/10/17- Luis Felipe
	Local _NomeCamp	  := SubStr(Readvar(),4)//Retorna o campo posicionado na tela
/*  // 11/10/17- Luis Felipe
Local _nPosPerio  := aScan(_BkpHeader, {|x| Upper(AllTrim(x[2])) == "Z3_PERIODO"})
Local _xPeriodo	  := AllTrim(_BkpaCols[_LinAcols][_nPosPerio])
Local _xCampSet	  := aScan(_BkpHeader, {|x| Upper(AllTrim(x[2])) == _NomeCamp})
*/
	Local _xOpca
	Local __vRet
	Local nI
	Local oGetDados
	Local nUsado      := 0
	Local _controlTo  := .F.
	Private _cSomaTot   := 0
	Private _cAliasZF := "TMPSZF"
	Private cTotal    := Space(11)//Space(TAMSX3("ZD_QTDREC")[1])//Space(11)
	Private lRefresh  := .T.
	Private aHeader   := {}
	Private aCols     := {}
	Private aStruSZF  := SZF->(dbStruct())
	Private cArqSZF   := ""
	Private aRotina := {{"Pesquisar", "AxPesqui", 0, 1},;
		{"Visualizar", "AxVisual", 0, 2},;
		{"Incluir", "AxInclui", 0, 3},;
		{"Alterar", "AxAltera", 0, 4},;
		{"Excluir", "AxDeleta", 0, 5}}

	oModelx := FWModelActive()
	oModelxDet := oModelx:GetModel('SZ3DETAIL')

	_BkpHeader  := aClone(oModelxDet:AHEADER)		//Backup do aHeader da tela anterior
	_BkpaCols   := aClone(oModelxDet:ADATAMODEL)   	//Backup do aCols da tela anterior
	_LinAcols   := oModelxDet:NLINE 				// Preservar a posição do Acols
	_nPosPerio  := aScan(oModelxDet:AHEADER, {|x| x[2] == "Z3_PERIODO"})
	_xPeriodo	:= oModelxDet:ADATAMODEL[_LinAcols][1][1][_nPosPerio]
	_xCampSet	:= aScan(oModelxDet:AHEADER, {|x| Upper(AllTrim(x[2])) == _NomeCamp})

	If(inclui)
		_xOpca := 3
	ElseIf(altera)
		_xOpca := 4
	Else
		_xOpca := 2
	EndIf

//-------------------------------------------------------------------------------------------------------------------------
//MONTAGEM DO AHEADER E DO ACOLS
//-------------------------------------------------------------------------------------------------------------------------

	n:= 1 // Reposionando o Acols

	aCampos := RetCampos("SZF",.T.)
	For nx := 1 to Len(aCampos)
		If	(ALLTRIM(aCampos[nx,1]) $ "ZF_DESPESA|ZF_VALOR") .And. ;
			( X3USO(GetSX3Cache(aCampos[nx,1],"X3_USADO")) .And. ;
			cNivel >= GetSX3Cache(aCampos[nx,1],"X3_NIVEL"))
			
			nUsado++
			
			AAdd(aHeader,{AllTrim(GetSX3Cache(aCampos[nx,1],"X3_TITULO")),;
				AllTrim(aCampos[nx,1]),;
				GetSX3Cache(aCampos[nx,1],"X3_PICTURE"),;
				GetSX3Cache(aCampos[nx,1],"X3_TAMANHO"),;
				GetSX3Cache(aCampos[nx,1],"X3_DECIMAL"),;
				GetSX3Cache(aCampos[nx,1],"X3_VALID"),;
				"",;
				GetSX3Cache(aCampos[nx,1],"X3_TIPO"),;
				"",;
				"" })
		Endif
	Next nx

	AADD(aCols,Array(nUsado+1))

	For nI := 1 To nUsado
		aCols[1][nI] := CriaVar(aHeader[nI][2])
	Next

	aCols[1][nUsado+1] := .F.

//-------------------------------------------------------------------------------------------------------------------------
//If(Inclui .or. Altera)

	If(!Select(_cAliasZF) > 0)

		CriaSZF(aStruSZF,cArqSZF)
		__vRet := EDFA006B()
	Else
		__vRet := .T.
	EndIF

	If(__vRet)

		aCols := {}

		DbSelectArea(_cAliasZF)
		DbSetOrder(1)
		If(DbSeek(xFilial("SZF")+M->CN9_NUMERO+PADR(_xPeriodo,TAMSX3("ZF_DP")[1])+_NomeCamp))

			While !Eof() .And. xFilial("SZF")+M->CN9_NUMERO+Alltrim(_xPeriodo)+_NomeCamp == xFilial("SZF")+(_cAliasZF)->ZF_CONTRA+;
					AllTrim((_cAliasZF)->ZF_DP)+(_cAliasZF)->ZF_CAMPO

				Aadd(aCols,{(_cAliasZF)->ZF_DESPESA,(_cAliasZF)->ZF_VALOR,.F.})
				_cSomaTot  := _cSomaTot + (_cAliasZF)->ZF_VALOR
				_controlTo := .T.

				DbSkip()
			EndDo
		EndIf

	EndIf

//EndIf
//-------------------------------------------------------------------------------------------------------------------------		

	Define MSDialog oDlg Title "Detalhamento" From 0,0 To 345,443 Pixel STYLE DS_MODALFRAME    //400,600

	@010,010 Say "Contrato"          Pixel Of oDlg
	@017,010 Get cContrato WHEN .F.  Pixel Of oDlg

	@010,110 Say "Periodo"           Pixel Of oDlg
	@017,110 Get cPeriodo WHEN .F.   Pixel Of oDlg

	@010,150 Say "Prêmio"          Pixel Of oDlg
	@017,150 Get cPremio WHEN .F.  Pixel Of oDlg

	@030,010 Say "Detalhamento"       Pixel Of oDlg

	Define Font oFont Name 'Courier New' Size 0, -12

	oGetDados := MsGetDados():New(037,010, 125, 210, _xOpca, "U_EDFLINOK", "U_EDFTUDOOK",,.T.,, ,.F.,,,,,, oDlg)

	@130,145 Say "Total"		         Pixel Of oDlg
	@137,145 Get cTotal SIZE 65,10 WHEN .F. PICTURE X3PICTURE("ZF_VALOR")   Pixel Of oDlg

	@155,135 BUTTON "&Ok"		SIZE 36,12 PIXEL ACTION (oDlg:End(),EDFA006A(cTotal,_NomeCamp,_LinAcols,_xPeriodo,_BkpHeader,_BkpaCols))
	@155,175 BUTTON "&Cancelar"	SIZE 36,12 PIXEL ACTION (oDlg:End()) Of oDlg Pixel

	cContrato := M->CN9_NUMERO
	cPeriodo  := _xPeriodo
	cPremio   := RetTitle(SubStr(Readvar(),4))
	cTotal    := Iif(_controlTo,_cSomaTot,0)

	ACTIVATE MSDIALOG oDlg CENTER

	n := _LinAcols //Volta a posição do Acols2

	aCols   := {}
	aHeader := {}

	aHeader := aClone(_BkpHeader)
	aCols   := aClone(_BkpaCols)

//-------------------------------------------------------------------------------------------------------------------------//
//Refresh na tela.              																						   //
//-------------------------------------------------------------------------------------------------------------------------//
// oGetDad2:aCols[n][_xCampSet]:= cTotal:= _cSomaTot                                                                                                              
	oModelxDet:ADATAMODEL[_LinAcols][1][1][_xCampSet] := cTotal:= _cSomaTot
//-------------------------------------------------------------------------------------------------------------------------//
	RestArea(_cEDFA006)

Return(.T.)


//-------------------------------------------------------------------------------------------------------------------------//

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFLINOK  ºAutor  ³Leandro Ribeiro     º Data ³  07/17/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para Validação das Linhas do Acols.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFLINOK()
lOCAL _cx,_dx
	Local _cRet     := .T.
	Local nPosDesp  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "ZF_DESPESA"})
	Local nPosValor := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "ZF_VALOR"})
	Local _Position := {}

	Aadd(_Position,{nPosDesp,nPosValor})

	For _cx := 1 to Len(aCols)
		For _dx := 1 to Len(_Position[1])
			If(Empty(aCols[_cx][_Position[1][_dx]]))
				_cRet := .F.
			EndIf
		Next _dx
	Next _cx

	IF(_cRet)
		cTotal := CalcTotal(aCols,nPosValor)
		GetdRefresh()
	EndIf

Return(_cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CalcTotal  ºAutor  ³Leandro Ribeiro     º Data ³  07/17/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para atualização dos valores do totalizador da tela.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

Static Function CalcTotal(aCols,nPosValor)
Local _ss
	Local _cCalc  := 0

	For _ss := 1 to Len(aCols)
		_cCalc := aCols[_ss][nPosValor]+_cCalc
		If(aCols[_ss][3])
			_cCalc := _cCalc - aCols[_ss][nPosValor]
		EndIf
	Next _ss

Return(_cCalc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFTUDOOK  ºAutor  ³Leandro Ribeiro     º Data ³  07/17/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para Validação de todas as Linhas do Acols.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
User Function EDFTUDOOK()

	Local _lRet := U_EDFLINOK()

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA006A  ºAutor  ³Leandro Ribeiro     º Data ³  07/17/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para realização da gravação dos registros do acols  º±±
±±º          ³ na tabela temporaria.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EDFA006A(cTotal,_posCampo,_LinAcols,_xPeriodo,_BkpHeader,_BkpaCols)
Local _gg
	Local _cEDFA006A := GetArea()
	Local _cCotDel	 := 0
// Local nPosPrem   := aScan(_BkpHeader, {|x| Upper(AllTrim(x[2])) == _posCampo}) // 11/10/17 - Luis Felipe
// Local nPosPerio	 := aScan(_BkpHeader, {|x| Upper(AllTrim(x[2])) == "Z3_PERIODO"}) // 11/10/17 - Luis Felipe
	Local nTotal     := 0

	For _gg:= 1 to Len(aCols)

		DbSelectArea(_cAliasZF)
		If(!DbSeek(xFilial("SZF")+M->CN9_NUMERO+PADR(_xPeriodo,TAMSX3("ZF_DP")[1])+_posCampo+STRZERO(_gg,4)))
			Reclock(_cAliasZF,.T.)
			(_cAliasZF)->ZF_FILIAL  := xFilial("SZF")
			(_cAliasZF)->ZF_CONTRA  := M->CN9_NUMERO
			(_cAliasZF)->ZF_DP	     := _xPeriodo // _BkpaCols[_LinAcols][nPosPerio] // 11/10/17 - Luis Felipe
			(_cAliasZF)->ZF_CAMPO	 := _posCampo
			(_cAliasZF)->ZF_DESPESA := aCols[_gg][1]
			(_cAliasZF)->ZF_VALOR   := aCols[_gg][2]
			(_cAliasZF)->ZF_CONTA 	 := STRZERO(_gg,4)
			MsUnlock()
		Else
			Reclock(_cAliasZF,.F.)
			(_cAliasZF)->ZF_FILIAL  := xFilial("SZF")
			(_cAliasZF)->ZF_CONTRA  := M->CN9_NUMERO
			(_cAliasZF)->ZF_DP	     := _xPeriodo // _BkpaCols[_LinAcols][nPosPerio] // 11/10/17 - Luis Felipe
			(_cAliasZF)->ZF_CAMPO	 := _posCampo
			(_cAliasZF)->ZF_DESPESA := aCols[_gg][1]
			(_cAliasZF)->ZF_VALOR   := aCols[_gg][2]
			(_cAliasZF)->ZF_CONTA 	 := STRZERO(_gg-_cCotDel,4)
			MsUnlock()
			If(aCols[_gg][3])
				DBDelete()
				_cCotDel := _cCotDel+1
			EndIf
		EndIf
		If(!aCols[_gg][3])
			nTotal += aCols[_gg][2]
		EndIf
	Next _gg

	_cSomaTot := nTotal

	GetdRefresh()

	RestArea(_cEDFA006A)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA006B  ºAutor  ³Leandro Ribeiro     º Data ³  07/17/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para realização da gravação dos registros oriundos  º±±
±±º          ³ da tabela SZF na tabela temporaria, essa função e somente  º±±
±±º          ³ executada no momento da alteração.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EDFA006B()
Local _aa
	Local _cEDFA006B := GetArea()
	Local _cArray2   := {}
	Local __xRet	 := .F.

	DbSelectArea("SZF")
	DbSetOrder(1)
	DbSeek(xFilial("SZF")+M->CN9_NUMERO)

	While !Eof()
		Aadd(_cArray2,{xFilial("SZF"),SZF->ZF_CONTRA,SZF->ZF_DP,SZF->ZF_CAMPO,SZF->ZF_DESPESA,SZF->ZF_VALOR,SZF->ZF_CONTA})
		DbSkip()
		__xRet := .T.
	EndDo

	For _aa:= 1 to Len(_cArray2)

		DbSelectArea("TMPSZF")
		DbSetOrder(1)
		Reclock("TMPSZF",.T.)
		TMPSZF->ZF_FILIAL  := xFilial("SZF")
		TMPSZF->ZF_CONTRA  := _cArray2[_aa][2]
		TMPSZF->ZF_DP	    := _cArray2[_aa][3]
		TMPSZF->ZF_CAMPO	:= _cArray2[_aa][4]
		TMPSZF->ZF_DESPESA := _cArray2[_aa][5]
		TMPSZF->ZF_VALOR   := _cArray2[_aa][6]
		TMPSZF->ZF_CONTA 	:= _cArray2[_aa][7]
		MsUnlock()
	Next _aa

	RestArea(_cEDFA006B)

Return(__xRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSZF   ºAutor  ³Leandro Ribeiro     º Data ³  07/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criação da Tabela Temporaria, essa função so será executadaº±±
±±º          ³ se a tabela não existir.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaSZF(aStruSZF,cArqSZF)

	Local CriaSZF   := GetArea()
	//Local _cAliasZF	:= GetNextAlias()

	if Select(_cAliasZF) > 0
		(_cAliasZF)->(dbCloseArea())
	EndIf
	oArqSZF:= FwTemporarytable():New(_cAliasZF,aStruSZF)
	oArqSZF:AddIndex(Left(_cAliasZF,8)+'01',{'ZF_FILIAL','ZF_CONTRA','ZF_DP','ZF_CAMPO','ZF_CONTA'})
	oArqSZF:Create()

	RestArea(CriaSZF)

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvEDFA006 ºAutor  ³Leandro Ribeiro    º Data ³  07/22/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para realizar a gravação dos registros da tabela    º±±
±±º          ³ temporaria na tabela fisica SZF.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GrvEDFA006()
Local _tt,_dd
	Local _cGrvEDFA := GetArea()
	Local _cArray   := {}
	Local _cCotDel  := 0
	Local _xContra  := aScan(aHeader2, {|x| Upper(AllTrim(x[2])) == "Z3_CONTRA"})
	Local _xPeriod  := aScan(aHeader2, {|x| Upper(AllTrim(x[2])) == "Z3_PERIODO"})

	If(Select("TMPSZF") > 0)
		If(inclui .or. altera)

			DbSelectArea("TMPSZF")
			DbSetOrder(1)
			Set Delete OFF
			DbSeek(xFilial("SZF")+M->CN9_NUMERO)

			While !Eof()

				Aadd(_cArray,{xFilial("SZF"),TMPSZF->ZF_CONTRA,TMPSZF->ZF_DP,TMPSZF->ZF_CAMPO,TMPSZF->ZF_DESPESA,TMPSZF->ZF_VALOR,TMPSZF->ZF_CONTA,TMPSZF->D_E_L_E_T_})
				DbSkip()
			EndDo

			For _tt:= 1 to Len(_cArray)

				DbSelectArea("SZF")
				Set Delete ON
				DbSetOrder(1)
				If(!DbSeek(xFilial("SZF")+_cArray[_tt][2]+_cArray[_tt][3]+_cArray[_tt][4]+STRZERO(Val(_cArray[_tt][7])+_cCotDel,4)))
					Reclock("SZF",.T.)
					SZF->ZF_FILIAL  := xFilial("SZF")
					SZF->ZF_CONTRA  := _cArray[_tt][2]
					SZF->ZF_DP	     := _cArray[_tt][3]
					SZF->ZF_CAMPO	 := _cArray[_tt][4]
					SZF->ZF_DESPESA := _cArray[_tt][5]
					SZF->ZF_VALOR   := _cArray[_tt][6]
					SZF->ZF_CONTA 	 := _cArray[_tt][7]
					MsUnlock()
				Else
					Reclock("SZF",.F.)
					SZF->ZF_FILIAL  := xFilial("SZF")
					SZF->ZF_CONTRA  := _cArray[_tt][2]
					SZF->ZF_DP	     := _cArray[_tt][3]
					SZF->ZF_CAMPO	 := _cArray[_tt][4]
					SZF->ZF_DESPESA := _cArray[_tt][5]
					SZF->ZF_VALOR   := _cArray[_tt][6]
					SZF->ZF_CONTA 	 := _cArray[_tt][7]
					If(_cArray[_tt][8] == "*")
						DBDelete()
						_cCotDel:=_cCotDel+1
					EndIf
					MsUnlock()
				EndIf
			Next _tt
		EndIf
	EndIf

//-------------------------------------------------------------------------------------------------------------------------//
//Exclusão de Registros na SZF no quando a Linha do Cronograma e deletada
//-------------------------------------------------------------------------------------------------------------------------//
	For _dd := 1 to Len(aCols2)
		If(aCols2[_dd,Len(aHeader2)+1])
			DbSelectArea("SZF")
			DbSetOrder(1)
			If(DbSeek(xFilial("SZF")+aCols2[_dd][_xContra]+AllTrim(aCols2[_dd][_xPeriod])))
				While !Eof() .AND. DbSeek(xFilial("SZF")+aCols2[_dd][_xContra]+AllTrim(aCols2[_dd][_xPeriod]))
					Reclock("SZF",.F.)
					DBDelete()
					MsUnlock()
					DbSkip()
				EndDo
			EndIf
		EndIf
	Next _dd

//-------------------------------------------------------------------------------------------------------------------------//
	DbCloseArea()

	RestArea(_cGrvEDFA)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FecEDFA006 ºAutor  ³Leandro Ribeiro    º Data ³  07/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para realizar o fechamento da tabela temporaria.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FecEDFA006()

	Local _cFecEDFA := GetArea()

	If(Select("TMPSZF") > 0)
		DbSelectArea("TMPSZF")
		DbCloseArea()
	Endif

	RestArea(_cFecEDFA)

Return()


Static Function RetCampos(cArq, lVirtual)
	Local aCampos := {}
	Local aCmpRet := {}
	Local nx := 1

	DEFAULT lVirtual := .F.

	aCampos := FWSX3Util():GetAllFields(cArq,lVirtual)

	For nx := 1 to Len (aCampos)
		IF !("USERLG" $ aCampos[nx])
			If x3uSO(GetSX3Cache(aCampos[nX],'X3_USADO'))
				AADD(aCmpRet,{aCampos[nx],FWSX3Util():GetDescription( aCampos[nx] )})
			EndIf
		Endif
	Next nx
Return aCmpRet
