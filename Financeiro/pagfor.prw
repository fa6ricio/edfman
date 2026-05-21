#Include "Protheus.ch"
#Include "Rwmake.ch"

//////////////////////////////////////////////////////////////////////////////////////////
// Programador: Rafael Nastri                                                           //
// Data: 18/01/2011                                                                     //
// Projeto: CNAB Bradesco Contas a Pagar - PagFor                                       //
// Descrição: Gerenciador de Funções para Geração do Arquivo de envio ao Banco.         //
//////////////////////////////////////////////////////////////////////////////////////////

User Function PagFor(cPar,cCond)
Local _xcRet :=""

If cPar == 'A'
	_xcRet:= PagId()
ElseIf cPar =='B'
	_xcRet:= PagBan()
ElseIf cPar == 'C'
	_xcRet:= PagAgen()
ElseIf cPar == 'D'
	_xcRet:= PagCta()
ElseIf cPar == 'E'
	_xcRet:= PagCar()
ElseIf cPar == 'F'
	_xcRet:= PagNnum()
ElseIf cPar == 'G'
	_xcRet:= PagVal(cCond)
ElseIf cPar == 'H'
	_xcRet:= PagTipo()
ElseIf cPar == 'I'
	_xcRet:= PagDoc()
ElseIf cPar == 'J'
	_xcRet:= CComple()
EndIf

Return ( _xcRet )

//*********************************************************************************************************************************************//
//*********************************************************************************************************************************************//
// Função para gravar o CNPJ/CPF do Fornecedor - Posição De:003 Até:017.

Static Function PagId ()
Private _cCgc := ""

If SA2->A2_TIPO == "J"
	_cCgc := "0"+Left(SA2->A2_CGC,8)+Substr(SA2->A2_CGC,9,4)+Right(SA2->A2_CGC,2)
ElseIf SA2->A2_TIPO <> "J"
	_cCgc := Left(SA2->A2_CGC,9)+"0000"+Substr(SA2->A2_CGC,10,2)
Endif

Return(_cCgc)

//*********************************************************************************************************************************************//
// Função para Separar o Banco do Codigo de Barras - Posição De:096 Até:098.

Static Function PagBan ()
Private _BANCO := ""

IF SUBSTR(SE2->E2_CODBAR,1,3) == "   " .AND. (SE2->E2_XDEPCON == "1"  .OR. EMPTY(SE2->E2_XDEPCON))
	_BANCO := SUBSTR(SA2->A2_BANCO,1,3)
ELSEIF SUBSTR(SE2->E2_CODBAR,1,3) == "   " .AND. SE2->E2_XDEPCON == "2"
	_BANCO := SUBSTR(SA2->A2_BANCO2,1,3)
ELSEIF SUBSTR(SE2->E2_CODBAR,1,3) == "   " .AND. SE2->E2_XDEPCON == "3"
	_BANCO := SUBSTR(SA2->A2_BANCO3,1,3)
ELSE
	_BANCO := SUBSTR(SE2->E2_CODBAR,1,3)
ENDIF

Return(_BANCO)

//*********************************************************************************************************************************************//
// Função para Separar a Agencia do Codigo de Barras - Posição De:099 Até:104.

Static Function PagAgen()
Private _AGENCIA 	:= ""
Private _RETDIG	:= ""
Private _DIG1	 	:= ""
Private _DIG2	 	:= ""
Private _DIG3	 	:= ""
Private _DIG4 	:= ""
Private _MULT	 	:= ""
Private _RESUL	:= ""
Private _RESTO	:= ""
Private _DIGITO	:= ""
Private _NPOSDV	:= ""
Private _DIGITOA 	:= ""

_Agencia := "000000"

IF SUBSTR(SE2->E2_CODBAR,1,3) == "237"
	//Retirado por Milton - Busca da Agencia da Linha Digitavel
	//_Agencia  :=  "0" + SUBSTR(SE2->E2_CODBAR,20,4)
	_Agencia	:= "0" + SUBSTR(SE2->E2_CODBAR,5,4)
	_RETDIG := " "
	_DIG1   := SUBSTR(SE2->E2_CODBAR,5,1)
	_DIG2   := SUBSTR(SE2->E2_CODBAR,6,1)
	_DIG3   := SUBSTR(SE2->E2_CODBAR,7,1)
	_DIG4   := SUBSTR(SE2->E2_CODBAR,8,1)
	
	_MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
	_RESUL  := INT(_MULT /11 )
	_RESTO  := INT(_MULT % 11)
	_DIGITO := 11 - _RESTO
	
	_RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,"0",ALLTRIM(STR(_DIGITO))))
	
	_Agencia:= _Agencia + _RETDIG
	
Else
	IF SA2->A2_BANCO == '237'	// Exclusivo para Contas Bradesco
		IF SE2->E2_XDEPCON == "1" .OR. EMPTY(SE2->E2_XDEPCON)
			_Agencia := STRZERO(VAL(SUBSTR(SA2->A2_AGENCIA,1,5)),6,0)	// Considera o digito para Bradesco
		ElseIf SE2->E2_XDEPCON == "2"
			_Agencia := STRZERO(VAL(SUBSTR(SA2->A2_AGENCI2,1,5)),6,0)	// Considera o digito para Bradesco
		ELSEIf SE2->E2_XDEPCON == "3"
			_Agencia := STRZERO(VAL(SUBSTR(SA2->A2_AGENCI3,1,5)),6,0)	// Considera o digito para Bradesco
		EndIf
	Else
		IF SE2->E2_XDEPCON == "1" .OR. EMPTY(SE2->E2_XDEPCON)
			_Agencia := STRZERO(VAL(SUBSTR(SA2->A2_AGENCIA,1,5)),5,0)
		ElseIf SE2->E2_XDEPCON == "2"
			_Agencia := STRZERO(VAL(SUBSTR(SA2->A2_AGENCI2,1,5)),5,0)
		ELSEIf SE2->E2_XDEPCON == "3"
			_Agencia := STRZERO(VAL(SUBSTR(SA2->A2_AGENCI3,1,5)),5,0)
		ELSE
			_Agencia := "000000"
		Endif
	EndIf
EndIf
Return(_Agencia)

//*********************************************************************************************************************************************//
// Função para Separar a C/C do Codigo de Barras - Posição De:105 Até:119.

Static Function PagCta ()
Private _CTACED   := ""
Private _RETDIG   := ""
Private _DIG1     := ""
Private _DIG2	    := ""
Private _DIG3	    := ""
Private _DIG4	 	:= ""
Private _DIG5	 	:= ""
Private _DIG6	 	:= ""
Private _DIG7	 	:= ""
Private _MULT	 	:= ""
Private _RESUL	:= ""
Private _RESTO 	:= ""
Private _DIGITO	:= ""
Private _DIGITOC 	:= ""
Private _DIGITOA 	:= ""

_CTACED := "0000000000000"

IF SUBSTR(SE2->E2_CODBAR,1,3) == "237"
	//_Ctaced :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,37,7)),13,0)
	_Ctaced :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,24,7)),13,0)
	_RETDIG := " "
	_DIG1   := SUBSTR(SE2->E2_CODBAR,24,1)
	_DIG2   := SUBSTR(SE2->E2_CODBAR,25,1)
	_DIG3   := SUBSTR(SE2->E2_CODBAR,26,1)
	_DIG4   := SUBSTR(SE2->E2_CODBAR,27,1)
	_DIG5   := SUBSTR(SE2->E2_CODBAR,28,1)
	_DIG6   := SUBSTR(SE2->E2_CODBAR,29,1)
	_DIG7   := SUBSTR(SE2->E2_CODBAR,30,1)
	
	_MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
	_RESUL  := INT(_MULT /11 )
	_RESTO  := INT(_MULT % 11)
	_DIGITO := STRZERO((11 - _RESTO),1,0)
	
	_RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))
	
	_Ctaced := _Ctaced + _RETDIG
Else
	IF SUBSTR(SE2->E2_CODBAR,1,3) == "   " .AND. (SE2->E2_XDEPCON == "1"  .OR. Empty(SE2->E2_XDEPCON))
		_DIGITOC := STR(VAL(RIGHT(ALLTRIM(SA2->A2_NUMCON),1)),1)
		_Ctaced  := STRZERO(VAL(Left(REPLACE(REPLACE(ALLTRIM(SA2->A2_NUMCON),".",""),"-",""),;
		(LEN(REPLACE(REPLACE(ALLTRIM(SA2->A2_NUMCON),".",""),"-",""))-1))),13)
		_Ctaced  += _DIGITOC
	ELSEIF SUBSTR(SE2->E2_CODBAR,1,3) == "   " .AND. SE2->E2_XDEPCON == "2"
		_DIGITOC := STR(VAL(RIGHT(ALLTRIM(SA2->A2_NUMCON2),1)),1)
		_Ctaced  := STRZERO(VAL(Left(REPLACE(REPLACE(ALLTRIM(SA2->A2_NUMCON2),".",""),"-",""),;
		(LEN(REPLACE(REPLACE(ALLTRIM(SA2->A2_NUMCON2),".",""),"-",""))-1))),13)
		_Ctaced  += _DIGITOC
	ELSEIF SUBSTR(SE2->E2_CODBAR,1,3) == "   " .AND. SE2->E2_XDEPCON == "3"
		_DIGITOC := STR(VAL(RIGHT(ALLTRIM(SA2->A2_NUMCON3),1)),1)
		_Ctaced  := STRZERO(VAL(Left(REPLACE(REPLACE(ALLTRIM(SA2->A2_NUMCON3),".",""),"-",""),;
		(LEN(REPLACE(REPLACE(ALLTRIM(SA2->A2_NUMCON3),".",""),"-",""))-1))),13)
		_Ctaced  += _DIGITOC
	Else
		_Ctaced  := "0000000000000"
	ENDIF
EndIf

Return(_Ctaced)

//*********************************************************************************************************************************************//
// Função para Selecionar a Carteira no Codigo de Barras - Posição De:136 Até:138.

Static Function PagCar ()
Private _RETCAR := ""

If Substr(SE2->E2_CODBAR,1,3) == "237"
	_RETCAR := "0" + Substr(SE2->E2_CODBAR,9,1) + Substr(SE2->E2_CODBAR,11,1)
Else
	_RETCAR := "000"
EndIf

Return(_RETCAR)

//*********************************************************************************************************************************************//
// Função para gravar o Nosso Numero com o valor no Codigo de Barras - Posição De:142 Até:150.

Static Function PagNnum ()
Private _RETNOS := ""

If Substr(SE2->E2_CODBAR,1,3) == '237'
	_RETNOS := "0" + Substr(SE2->E2_CODBAR,12,9)+Substr(SE2->E2_CODBAR,22,2)
Else
	//_RETNOS := "000000000"  Alterado por milton - posicao de 139 a 150
	_RETNOS := "000000000000"
EndIf

Return(_RETNOS)

//*********************************************************************************************************************************************//
// Função para gravar os valores referente a Titulo, Desconto, Juros, Acrescimo e etc. - Posição De:195 Até:204.

Static Function PagVal (cCond)
Private nVALOR :=0

IF cCOND =='1'
	nVALOR := STRZERO(SE2->E2_SALDO*100,10)
ELSEIF cCOND =='2'
	nVALOR := STRZERO(SE2->(E2_SALDO-E2_DECRESC+E2_ACRESC)*100,15)
ELSEIF cCOND =='3'
	nVALOR := STRZERO(SE2->E2_DECRESC*100,15)
ELSEIF cCOND =='4'
	nVALOR := STRZERO(SE2->E2_ACRESC*100,15)
ELSE
	nVALOR := STRZERO(0,15)
ENDIF

Return(nVALOR)

//*********************************************************************************************************************************************//
// Função para gravar o Tipo de Operação - Posição De:250 Até:251.

Static Function PagTipo ()
Private _TIPO := ""

IF SUBSTR(SE2->E2_TIPO,1,2) == "NF"
	_TIPO := "01"
ELSEIF SUBSTR(SE2->E2_TIPO,1,2) == "FT"
	_TIPO := "02"
ELSEIF SUBSTR(SE2->E2_TIPO,1,2) == "DP"
	_TIPO := "04"
ELSE
	_TIPO := "05"
ENDIF

Return(_TIPO)

//*********************************************************************************************************************************************//
// Função que grava as Informações Complementares - Posição De:374 Até:413.

Static Function PagDoc ()
Private _Doc := ""
Private _Mod := ""

_Mod := SUBSTR(SEA->EA_MODELO,1,2)

IF _Mod == "  "
	IF SUBSTR(SE2->E2_CODBAR,1,3) == "237"
		_Mod == "30"
	ELSE
		_Mod == "31"
	ENDIF
ENDIF

If _Mod == "03" .OR. _Mod == "07" .OR. _Mod == "08"
	_Doc := IIF(SA2->A2_CGC==SM0->M0_CGC,"D","C")+"000000"+"01"+"01"+SPACE(29)
ElseIf _Mod == "31"
	//_Doc := SUBSTR(SE2->E2_CODBAR,20,25)+SUBSTR(SE2->E2_CODBAR,5,1)+SUBSTR(SE2->E2_CODBAR,4,1)+SPACE(13)   Retirado por Milton
	_Doc := SUBSTR(SE2->E2_CODBAR,5,5)+SUBSTR(SE2->E2_CODBAR,11,10)+SUBSTR(SE2->E2_CODBAR,22,10)+SUBSTR(SE2->E2_CODBAR,33,1)+SUBSTR(SE2->E2_CODBAR,4,1)+SPACE(13)
Else
	_Doc := SPACE(40)
EndIf

Return(_Doc)

//*********************************************************************************************************************************************//
// Função para Tratamento da Conta Complementar - Posição De:480 Até:486.

Static Function CComple ()
Private cConta := ""

cConta := StrZero(Val(Substr(AllTrim(MV_PAR07),1,6)),7)

Return (cConta)
