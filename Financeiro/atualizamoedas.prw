#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"

//////////////////////////////////////////////////////////////////////////////////////////////////
// Autor: Rafael Nastri-------------------------------------------------------------------------//
// Data:  31/01/2011----------------------------------------------------------------------------//
// Desenvolvimento: Alterado o Programa para Gerenciar o Preenchimento das Tx. Câmbio ----------//
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
// Autor: Luis Felipe Nascimento                                                                //
// Data:  19/04/2016                                                                            //
// Alterações: Devido a alterações complexas no tratamento das datas e da gravação,o formato an-//
// terior deve ser analisado com base na copia guardada sobre o arquivo AtualizaMoedas_15052013 //
// Motivo: Como ocorriam situações em que data dos feriádos eram modificadas o programa se per- //
// dia e deixava de atualizar a moeda. A verificação dos feriados passou a ser tratada pela fun-//
// ção DataValid. Mudança no tratamento da data de gravação e repetição das taxas nos finais de //
// semana.                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////

User Function AtuMoedas()

Private lAuto		:= .F.
Private nValReal	:= 1.000000
Private nValUfir	:= 1.064100
Private nValEuro
Private nValLibra
Private nVendEuro
Private nVendLibra
Private nN			:= 0
Private nDiasPro	:= 999
Private nDiasreg	:= 999
Private dDataRef
Private dData
Private dDataGrv
Private nValDolar
Private nValYen
Private nValEuro
Private nS1
Private nS2
Private nS3
Private nI1
Private nI2
Private nI3
Private oDlg
Private nDia 
Private NCOMBAU  // 24/08/18 - Luis Felipe

//Testa se esta sendo rodado do menu
If	Select('SX2') == 0
	RPCSetType( 3 )						//Não consome licensa de uso
	RpcSetEnv('01','01',,,,GetEnvServer(),{ "SM2" })
	sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
	ConOut('Atualizando Moedas... '+Dtoc(DATE())+' - '+Time())
	lAuto := .T.
EndIf

If	( ! lAuto )
	LjMsgRun(OemToAnsi('Atualização On-line BCB'),,{|| xExecMoeda()} )
Else
	xExecMoeda()
EndIf

If	( lAuto )
	RpcClearEnv()		   				//Libera o Environment
	ConOut('Moedas Atualizadas. '+Dtoc(DATE())+' - '+Time())
EndIf
Return
//---------------------------------------------------------------------------------------------------------------------------------------------

Static Function xExecMoeda()
Local nPass, cFile, cTexto, nLinhas, cLinha, cdata, cCompra, cVenda, J, K, dBauDate

Local cParam  		:= "cvQgrdrzG5EjfBnbktth"
Local cUrlProduts 	:= ""
Local cData  		:= "api_key=" + cParam
Local cHttpHeader   := ''

For nPass := 5 to 1 step -1					//Refaz os ultimos 6 dias. O BCB não disponibiliza periodo maior de uma semana
    
	dDataRef := dDataBase - nPass
	nDia := Dow(dDataRef)

    dDataGrv := dDataRef + 1
	dDataRef := DataValida(dDataRef,.f.)

	cFile := Dtos(dDataRef)+'.csv'
	
	// cTexto := HttpGet('http://www4.bcb.gov.br/download/fechamento/'+cFile) // 24/08/18 - Luis Felipe
	cTexto := HttpGet('https://www4.bcb.gov.br/download/fechamento/'+cFile)

	If	( lAuto )
		ConOut('DownLoading from BCB '+cFile+' In '+Dtoc(DATE()))
	EndIf
	
	If ! Empty(cTexto)
		nLinhas := MLCount(cTexto, 81)
		For J	:= 1 to nLinhas
			cLinha	:= Memoline(cTexto,81,j)
			cData  	:= Substr(cLinha,1,10)
			cCompra := StrTran(Substr(cLinha,22,10),',','.')
			cVenda  := StrTran(Substr(cLinha,33,10),',','.')
			
			If	( Substr(cLinha,12,3)=='220' )	//Seleciona o Valor do Dolar
				dData		:= Ctod(cData)
				nValDolar	:= Val(cCompra)
				nComBau		:= Val(cVenda)
			
			/*
			ElseIf 	( Substr(cLinha,12,3)=='978' )	//Seleciona o Valor do Euro
				dData		:= Ctod(cData)
				nValEuro	:= Val(cCompra)
				nVendEuro		:= Val(cVenda)
							
			ElseIf 	( Substr(cLinha,12,3)=='540' )	//Seleciona o Valor da Libra Esterlina
				dData		:= Ctod(cData)
				nValLibra	:= Val(cCompra)
				nVendLibra		:= Val(cVenda)
			*/								
			EndIf
		Next
	Endif
	GravaDados()
Next

Return
//---------------------------------------------------------------------------------------------------------------------------------------------

Static Function GravaDados()

DbSelectArea("SM2")	//Grava Moedas
SM2->(DbSetorder(1))

If SM2->(DbSeek(Dtos(dDataGrv)))
	Reclock('SM2',.F.)
Else
	Reclock('SM2',.T.)
	SM2->M2_DATA	:= dDataGrv
EndIf
SM2->M2_MOEDA1	:= nValReal		//Real
SM2->M2_MOEDA2	:= nValDolar	//Dolar
SM2->M2_MOEDA3	:= nValUfir     //UFIR
SM2->M2_BMOEDA6	:= nComBau		//Dolar de Venda		
SM2->M2_MOEDA4	:= nComBau		//Dolar de Venda --13/11/2013--Yttalo P Martins
SM2->M2_INFORM	:= "S"  
SM2->(MsUnlock())


DbSelectArea('CTP')	//Grava Tabela de Cambio
CTP->(DbSetorder(1))

If CTP->(DbSeek(xfilial('CTP')+Dtos(dDataGrv)+'01'))	//Real - INDICE - CTP_FILIAL+DTOS(CTP_DATA)+CTP_MOEDA
	RecLock('CTP',.F.)
Else
	RecLock('CTP',.T.)
	CTP->CTP_FILIAL := xfilial('CTP') //'01'
	CTP->CTP_DATA	:= dDataGrv
EndIf
CTP->CTP_MOEDA	:= '01'
CTP->CTP_TAXA	:= nValReal
CTP->CTP_BLOQ	:= '2'
CTP->(MsUnlock())

If CTP->(DbSeek(xfilial('CTP')+Dtos(dDataGrv)+'02'))	//Dolar - INDICE - CTP_FILIAL+DTOS(CTP_DATA)+CTP_MOEDA
	RecLock('CTP',.F.)
Else
	RecLock('CTP',.T.)
	CTP->CTP_FILIAL := xfilial('CTP')//'01'
	CTP->CTP_DATA	:= dDataGrv
EndIf
CTP->CTP_MOEDA	:= '02'
CTP->CTP_TAXA	:= nValDolar
CTP->CTP_BLOQ	:= '2'
CTP->(MsUnlock())

If CTP->(DbSeek(xfilial('CTP')+Dtos(dDataGrv)+'06'))	//Dolar Venda - INDICE - CTP_FILIAL+DTOS(CTP_DATA)+CTP_MOEDA
	RecLock('CTP',.F.)
Else
	RecLock('CTP',.T.)
	CTP->CTP_FILIAL := xfilial('CTP')//'01'
	CTP->CTP_DATA	:= dDataGrv
EndIf
CTP->CTP_MOEDA	:= '06'
CTP->CTP_TAXA	:= nComBau
CTP->CTP_BLOQ	:= '2'
CTP->(MsUnlock())

If CTP->(DbSeek(xfilial('CTP')+Dtos(dDataGrv)+'04'))	//Real - INDICE - CTP_FILIAL+DTOS(CTP_DATA)+CTP_MOEDA
	RecLock('CTP',.F.)
Else
	RecLock('CTP',.T.)
	CTP->CTP_FILIAL := xfilial('CTP')//'01'
	CTP->CTP_DATA	:= dDataGrv 
EndIf	
CTP->CTP_MOEDA	:= '04'
CTP->CTP_TAXA	:= nComBau
CTP->CTP_BLOQ	:= '2'
CTP->(MsUnlock())


DbSelectArea('SYE')	//Grava Tabela de Taxa de Moeda
SYE->(DbSetorder(1))

If !SYE->(DbSeek(xfilial('SYE')+Dtos(dDataGrv)+GETMV('MV_SIMB1')))	//Real - INDICE - YE_FILIAL+DTOS(YE_DATA)+YE_MOEDA
	SYE->(RecLock('SYE',.T.))
	SYE->YE_FILIAL  := xFilial("SYE")  
	SYE->YE_MOE_FIN	:= '1'                   		
	SYE->YE_MOEDA	:= GETMV('MV_SIMB1')                    
	SYE->YE_DATA	:= dDataGrv
Else
	SYE->(RecLock('SYE',.F.))	
EndIf               
SYE->YE_VLCON_C	:= nValReal
SYE->YE_VLFISCA	:= nValReal
SYE->YE_TX_COMP := nValReal		
SYE->(MsUnlock())

If !SYE->(DbSeek(xfilial('SYE')+Dtos(dDataGrv)+GETMV('MV_SIMB2')))	//Dolar - INDICE - YE_FILIAL+DTOS(YE_DATA)+YE_MOEDA
	SYE->(RecLock('SYE',.T.))
	SYE->YE_FILIAL  := xFilial("SYE")
	SYE->YE_MOE_FIN	:= '2'                   		
	SYE->YE_MOEDA	:= GETMV('MV_SIMB2')                    
	SYE->YE_DATA	:= dDataGrv		
Else
	SYE->(RecLock('SYE',.F.))	
EndIf
SYE->YE_VLCON_C	:= nComBau
SYE->YE_VLFISCA	:= nValDolar
SYE->YE_TX_COMP := nValDolar		
SYE->(MsUnlock())

Return