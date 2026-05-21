#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFI002   บAutor  ณLuis Felipe Nascimento ณData ณ  11/12/16 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina destinada a atualiza็ใo dos pre็os de alta, baixa ..บฑฑ
ฑฑบ          ณ praticados no mercado do futuro para os produtos A็ucar,   บฑฑ
ฑฑบ          ณ Milho e Soja.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบAlteracao ณ                                                    /  /    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EDFI002()

Private lAuto := .F.
Private nAberto, nAlta, nBaixa, nFechado := 0.000000
Private cMercado
Private dData

//Testa se esta sendo rodado do menu
If	Select('SX2') == 0
	RPCSetType( 3 )						//Nใo consome licensa de uso
	RpcSetEnv('01','01',,,,GetEnvServer(),{ "SM2" })
	sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
	ConOut('Atualizando Mercado Futuro ... '+Dtoc(DATE())+' - '+Time())
	lAuto := .T.
EndIf

If	( ! lAuto )
	LjMsgRun(OemToAnsi('Atualiza็ใo On-line Mercado Futuro'),,{|| fMercado()} )
Else
	fMercado()
EndIf

If	( lAuto )
	RpcClearEnv()	//Libera o Environment
	ConOut('Moedas do Mercado do Futuro Atualizadas. '+Dtoc(DATE())+' - '+Time())
EndIf

Return

*------------------------*
Static Function fMercado()
*------------------------*

Local nPass, cFile, cTexto, nLinhas, cLinha, cdata
Local cHttpHeader 	:= ""
Local cErro  		:= ""
Local cParam  		:= "cvQgrdrzG5EjfBnbktth"
Local cUrlProduts 	:= ""
Local cData  		:= "api_key=" + cParam
Local lDec 			:= .f.
Local nCount 		:= 0
Local xValor 		:= ''
Local nAno			:= Year(Ddatabase)

For nw:=nAno to nAno
	For nz:=1 to 24
		If	nz <= 5
			cMercado := "NY"
			If nz = 1
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/ICE/SBH"+Str(nw,4)+".csv"
			ElseIf nz = 2
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/ICE/SBK"+Str(nw,4)+".csv"
			ElseIf nz = 3
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/ICE/SBN"+Str(nw,4)+".csv"
			ElseIf nz = 4
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/ICE/SBV"+Str(nw,4)+".csv"
			ElseIf nz = 5
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/ICE/SBH"+Str(nw+1,4)+".csv"
			EndIf
		ElseIf	nz > 5 .and. nz <= 11
			cMercado 	:= "LIFFE"
			If nz = 6
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WH"+Str(nw,4)+".csv"
			ElseIf nz = 7
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WK"+Str(nw,4)+".csv"
			ElseIf nz = 8
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WQ"+Str(nw,4)+".csv"
			ElseIf nz = 9
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WV"+Str(nw,4)+".csv"
			ElseIf nz = 10
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WZ"+Str(nw,4)+".csv"
			ElseIf nz = 11
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WH"+Str(nw+1,4)+".csv"
			EndIf
		ElseIf	nz > 11 .and. nz <= 19
			cMercado 	:= "Soja"
			If nz = 12 // == '01'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SF"+Str(nw,4)+".csv"
			ElseIf nz = 13 // $ '02/03'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SH"+Str(nw,4)+".csv"
			ElseIf nz = 14 // $ '04/05'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SK"+Str(nw,4)+".csv"
			ElseIf nz = 15 // $ '06/07'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SN"+Str(nw,4)+".csv"
			ElseIf nz = 16 // == '08'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SQ"+Str(nw,4)+".csv"
			ElseIf nz = 17 // == '09'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SU"+Str(nw,4)+".csv"
			ElseIf nz = 18 // $ '10/11'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SX"+Str(nw,4)+".csv"
			ElseIf nz = 19 // == '12'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SF"+Str(nw+1,4)+".csv"
			EndIf
		Else
			cMercado 	:= "Milho"
			If nz = 20 // $ '01/02/03'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/CH"+Str(nw,4)+".csv"
			ElseIf nz = 21 // $ '04/05'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/CK"+Str(nw,4)+".csv"
			ElseIf nz = 22 // $ '06/07'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/CN"+Str(nw,4)+".csv"
			ElseIf nz = 23 // $ '08/09'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/CU"+Str(nw,4)+".csv"
			ElseIf nz = 24 // $ '10/11/12'
				cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/CZ"+Str(nw,4)+".csv"
			EndIf
		EndIf
		
		cTexto := HttpGet(cUrlProduts,cData,120000,,@cHttpHeader)

		If	( lAuto )
			ConOut('DownLoading from Mercado Futuro do '+cMercado)
		EndIf
		
		If !Empty(cTexto)
			For nx := 1 to Len(cTexto)
				If	Val(Substr(cTexto,nx,4)) > 2000 .and. Substr(cTexto,nx+4,1) == '-'
					dData := CtoD(Substr(cTexto,nx+8,2)+'/'+Substr(cTexto,nx+5,2)+'/'+Substr(cTexto,nx,4))
					cMes  := Substr(cTexto,nx+5,2)
					cAno  := Substr(cTexto,nx,4)
					nx += 11
					SZL->(DbSetorder(1))
					If !SZL->(DbSeek(DtoS(dData)+cMercado)) .and. dData <> Ctod("  /  /  ")
						For ny:=nx to Len(cTexto)
							If !Substr(cTexto,ny,1) $ '.,' .and. !lDec
								xValor += Substr(cTexto,ny,1)
							Else
								lDec := .t.
								If Substr(cTexto,ny,1) <> ','
									xValor += Substr(cTexto,ny,1)
								Else
									nCount ++
									nValor := Val(xValor)
									If nCount == 1
										nAberto := nValor
									ElseIf nCount == 2
										nAlta := nValor
									ElseIf nCount == 3
										nBaixa := nValor
									ElseIf (nCount == 4 .and. cMercado $ 'LIFFE/NY') .or. (nCount == 6 .and. cMercado $ 'Soja/Milho')
										nFechado := nValor
										nx := ny+1
										nCount := 0
										lDec := .f.
										xValor := ''
										
										//	If cAno == Str(Year(Ddatabase),4)
										
/*										LIFFE e NY (A็ucar) 1/11
										Soja               12/19
										Milho              20/24
										*/
										If 	((nz = 1  .and. cMes $ '01/02') 	.or.;
											(nz = 2  .and. cMes $ '02/03/04') 	.or.;
											(nz = 3  .and. cMes $ '04/05/06') 	.or.;
											(nz = 4  .and. cMes $ '06/07/08/09') .or.;
											(nz = 5  .and. cMes $ '09/10/11/12') .or.;
											(nz = 6  .and. cMes $ '01/02') 	.or.;  
											(nz = 7  .and. cMes $ '02/03/04') 	.or.;
											(nz = 8  .and. cMes $ '04/05/06/07') .or.;
											(nz = 9  .and. cMes $ '07/08/09') 	.or.;
											(nz = 10 .and. cMes $ '09/10/11') 	.or.;
											(nz = 11 .and. cMes $ '11/12') 	.or.;
											(nz = 12 .and. cMes == '01')   	.or.;
											(nz = 13 .and. cMes $ '02/03') 	.or.;
											(nz = 14 .and. cMes $ '03/04/05')  .or.;
											(nz = 15 .and. cMes $ '05/06/07')  .or.;
											(nz = 16 .and. cMes $ '07/08')   	.or.;
											(nz = 17 .and. cMes $ '08/09')    .or.;
											(nz = 18 .and. cMes $ '09/10/11')  .or.;              
											(nz = 19 .and. cMes $ '11/12')	.or.;
											(nz = 20 .and. cMes $ '01/02/03').or.;
											(nz = 21 .and. cMes $ '03/04/05')	.or.;
											(nz = 22 .and. cMes $ '05/06/07')	.or.;
											(nz = 23 .and. cMes $ '07/08/09')	.or.;
											(nz = 24 .and. cMes $ '09/10/11/12')) .and. cAno == Str(nw,4)
											DbSelectArea("SLZ")
											Reclock('SZL',.T.)
											SZL->ZL_DATA  	:= dData
											SZL->ZL_MERCADO	:= cMercado
											SZL->ZL_ABERTO  := nAberto
											SZL->ZL_ALTA   	:= nAlta
											SZL->ZL_BAIXA 	:= nBaixa
											SZL->ZL_FECHADO	:= nFechado
											SZL->(MsUnlock())
										EndIf
										Exit
									EndIf
									lDec := .f.
									xValor := ''
								EndIf
							EndIf
						Next
					EndIf
				EndIf
			Next
		Endif
	Next
Next

Return

*-------------------*
User function getCA()

Local cPFX := "\certs\tests.pfx"
Local cCA := "\certs\ca.pem"
Local cError := ""
Local cContent := ""
Local lRet

lRet := PFXCA2PEM( cPFX, cCA, @cError, "123" )
If( lRet == .F. )
   conout( "Error: " + cError )
Else
   cContent := MemoRead( cCA )
   varinfo( "CA", cContent )
Endif

Return

/*

If	nz <= 5
cMercado := "NY"
If nz = 1
cUrlProduts := "https://www.quandl.com/api/v3/datasets/ICE/SBH"+Str(Year(Ddatabase),4)+".csv"
ElseIf nz = 2
cUrlProduts := "https://www.quandl.com/api/v3/datasets/ICE/SBK"+Str(Year(Ddatabase),4)+".csv"
ElseIf nz = 3
cUrlProduts := "https://www.quandl.com/api/v3/datasets/ICE/SBN"+Str(Year(Ddatabase),4)+".csv"
ElseIf nz = 4
cUrlProduts := "https://www.quandl.com/api/v3/datasets/ICE/SBV"+Str(Year(Ddatabase),4)+".csv"
ElseIf nz = 5
cUrlProduts := "https://www.quandl.com/api/v3/datasets/ICE/SBH"+Str(Year(Ddatabase)+1,4)+".csv"
EndIf
ElseIf	nz > 5 .and. nz <= 11
cMercado 	:= "LIFFE"
If nz = 6
cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WH"+Str(Year(Ddatabase),4)+".csv"
ElseIf nz = 7
cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WK"+Str(Year(Ddatabase),4)+".csv"
ElseIf nz = 8
cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WQ"+Str(Year(Ddatabase),4)+".csv"
ElseIf nz = 9
cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WV"+Str(Year(Ddatabase),4)+".csv"
ElseIf nz = 10
cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WZ"+Str(Year(Ddatabase),4)+".csv"
ElseIf nz = 11
cUrlProduts := "https://www.quandl.com/api/v3/datasets/LIFFE/WH"+Str(Year(Ddatabase)+1,4)+".csv"
EndIf
ElseIf	nz > 11 .and. nz <= 19
cMercado 	:= "Soja"
//		cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SF"+Str(Year(Ddatabase),4)+".csv"
If nz = 12 // == '01'
cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SF2016.csv"
ElseIf nz = 13 // $ '02/03'
cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SH2016.csv"
ElseIf nz = 14 // $ '04/05'
cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SK2016.csv"
ElseIf nz = 15 // $ '06/07'
cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SN2016.csv"
ElseIf nz = 16 // == '08'
cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SQ2016.csv"
ElseIf nz = 17 // == '09'
cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SU2016.csv"
ElseIf nz = 18 // $ '10/11'
cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SX2016.csv"
ElseIf nz = 19 // == '12'
cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/SX2017.csv"
EndIf
ElseIf	nz == 20
cMercado 	:= "Milho"
cUrlProduts := "https://www.quandl.com/api/v3/datasets/CME/CH"+Str(Year(Ddatabase),4)+".csv"
EndIf
