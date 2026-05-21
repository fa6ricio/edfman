#include "protheus.ch"


User Function EECNF()

	Local xRet     := .T.
	Local aParam   := PARAMIXB
	Local oObj     := Nil
	Local cIdPonto := ""
	Local cIdModel := ""

	If aParam <> NIL
		oObj     := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]

		If cIdPonto == "MODELVLDACTIVE"
		ElseIf cIdPonto == "MODELPRE"
		ElseIf cIdPonto == "FORMPRE" .And. cIdModel == "EK6DETAIL"
			oObj:bLinePost := {|| .T.}
		endif

	endif

Return (xRet) 
