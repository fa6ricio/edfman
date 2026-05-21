#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "Tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA001   บAutor  ณLuis Felipe Nascimento ณData ณ  09/07/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo de Templates x XML NF                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Estoque                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fontes associados a este:                                  บฑฑ
ฑฑบ          ณ A260GRV - Executado antes da confirma็ใo da Transferencia  บฑฑ
ฑฑบ          ณ           Usado para gravar o NUMSEQ da SD1.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณLuis Felipe Nascimento ณData ณ  06/03/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ Nใo permitir movimenta็๕es de transfer๊ncias das NFดs      บฑฑ
ฑฑบ          ณ quando esta for com data anterior ao ๚ltimo fechamento     บฑฑ
ฑฑบ          ณ mensal.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracao ณ          บAutor  ณLuis Felipe Nascimento ณData ณ  06/08/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณ Mudan็a de legisla็ใo conforme art. 5บ do artigo 61 do     บฑฑ
ฑฑบ          ณ RICMS/2000.                                                บฑฑ
ฑฑบ          ณ Adequa็ใo da qtd. recebida no terminal. D1_XQTDORI e       บฑฑ
ฑฑบ          ณ D1_XVLRORI.                                                บฑฑ
ฑฑบ          ณ TES 006 e 021 - Qtd. NF = Qtd. Entregue                    บฑฑ
ฑฑบ          ณ TES 206 e 221 - Qtd. NF # Qtd. Entregue                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EDFA001

BEGIN TRANSACTION

Processa ( { ||  EDFA001I()  } )

END TRANSACTION

Return

/*/ COLUNAS DO TEMPLATE //
1 - CNPJ USINA
2 - NOME
3 - NF REMESSA
4 - SERIE
5 - PESO LIQUIDO
6 - CNPJ TERMINA
7 - NOME TERMINAL
8 - DATA DESCARGA TERMINAL INTERIOR
9 - DATA DESCARGA NO PORTO
10- PLACA CAMINHAO
/*/

*-----------------------*
Static Function EDFA001I
*-----------------------*

Local 	lProcessa   := .t.
Local   lAlt 		:= .f.
Local	nRegistro	:= 0
Local	nDevol		:= 0
Local	nTransf		:= 0
Local	cQuery		:= ""
Local	cAlias		:= GetNextAlias()
Local	x
Local	a
Local	nX
Local	i

Private cBuffer		:= ""
Private cArquiv     := ""
Private cLog        := ""
Private aLog        := {}
Private cEnt        := Chr(13) + Chr(10)
private cAlias      := GetNextAlias()
Private aErroLog    := {}
Private aLog 	    := {}
Private aVetor      := {}
Private nHandle
Private lRet        := .F.        // variแvel de controle interno da rotina automatica que informa se houve erro durante o processamento
Private lMsErroAuto := .F.        // variแvel que define que o help deve ser gravado no arquivo de log e que as informa็๕es estใo vindo เ partir da rotina automแtica.
Private lMsHelpAuto	:= .F.        // for็a a grava็ใo das informa็๕es de erro em array para manipula็ใo da grava็ใo ao inv้s de gravar direto no arquivo temporแrio
Private aTmpDados   := {}
Private aInfo		:= {}
Private aSZD		:= {}
Private cSeqTemp	:= GetMV("MV_XSQTEMP")
Private	_nQtdRec 	:= 0
Private _nQtdRecPc	:= 0
Private __Ddatabase	:= Ddatabase
Private __dUlMes	:= GetMv("MV_ULMES")
Private lClass		:= .f.

Public 	cNumSeqSD1  := ""

Private cArquiv := cGetFile("Todos os Arquivos|*.*",OemToAnsi("Importa็ใo de Template ..."),0, ,.T.)

//Caso nใo exista nenhum arquivo para abertura retorna.
If Empty(cArquiv)
	Return
EndIf

*----------------------*
* Abre o Arquivo Texto *
*----------------------*
FT_FUSE(cArquiv)

*-----------------------------------------------------------------------------------------*
* Vai para o Inicio do Arquivo e Define o numero de Linhas para a Barra de Processamento. *
*-----------------------------------------------------------------------------------------*
FT_FGOTOP()
ProcRegua(FT_FLASTREC())

*-----------------------------*
* Leitura da linha do arquivo *
*-----------------------------*
cBuffer := FT_FREADLN()

FT_FSKIP() //pula primeira linha do arquivo.

*----------------------------------------*
* Percorre todo os itens do arquivo CSV. *
*----------------------------------------*
While !FT_FEOF()
	
	IncProc("Importando..")
	
	aSZD	  	:= {}
	aTmpDados 	:= {}
	nDevol		:= 0
	nTransf		:= 0
	_nQtdRec 	:= 0
	lClass		:= .f.
	lProcessa 	:= .t.
	
	*----------------------------------------------------------------*
	* Faz a Leitura da Linha do Arquivo e atribui a Variavel cBuffer *
	*----------------------------------------------------------------*
	cBuffer := FT_FREADLN()
	
	*---------------------------------------------------------------------*
	* Se ja passou por todos os registros da planilha "CSV" sai do While. *
	*---------------------------------------------------------------------*
	If Empty(cBuffer)
		Exit
	Endif
	
	*---------------------------------------------*
	* Retorna posicao em que foi encontrado o ";" *
	*---------------------------------------------*
	xPos := AT(";",cBuffer)
	
	*---------------------------------------------------------------------------------------------------*
	* Adiciona as informacoes no vetor ate o ";" e retira o conteudo inserido no vetor da linha cBuffer *
	*---------------------------------------------------------------------------------------------------*
	While xPos <> 0
		aInfo  := Alltrim(SubStr(cBuffer , 1, xPos-1 ))
		aAdd( aTmpDados , aInfo )
		cBuffer:= SubStr(cBuffer , xPos+1, Len(cBuffer)-xPos)
		xPos := AT(";",cBuffer)
	End
	
	*--------------------------------------------------------------------------------------------------*
	* Se ainda tiver informacao no cBuffer, adiciona a ultima parte do arquivo depois do ";" no vetor  *
	*--------------------------------------------------------------------------------------------------*
	If Len(cBuffer) > 0
		aInfo  := Alltrim(SubStr(cBuffer , 1, Len(cBuffer) ))
		aAdd( aTmpDados , aInfo )
	Else
		aInfo  := ""
		aAdd( aTmpDados , aInfo )
	EndIf
	
	cCgcUsina := ""
	For x := 1 to len(aTmpDados[1])
		If !Substr(aTmpDados[1],x,1) $ ".|/|-"
			cCgcUsina += Substr(aTmpDados[1],x,1)
		EndIf
	Next
	
	SA2->(DbSetOrder(3))
	If !SA2->(DbSeek(xFilial("SA2")+cCgcUsina))
		cTexto := "Consta no Template o CNPJ "+Alltrim(aTmpDados[1])+" errado ou de uma Usina ainda nใo cadastrada ! "
		aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
		FT_FSKIP()
		Loop
	EndIf
	
	cCgcTerm := ""
	For x := 1 to len(aTmpDados[6])
		If !Substr(aTmpDados[6],x,1) $ ".|/|-"
			cCgcTerm += Substr(aTmpDados[6],x,1)
		EndIf
	Next
	
	*----------------------------------------------------------------------------------*
	* Checa a exist๊ncia da NF Remessa, posicionando no ๚ltimo registro da NF Remessa, *
	* uma vez que pode haver entrada parcial.                                          *
	*----------------------------------------------------------------------------------*
	cQuery := " SELECT Max(R_E_C_N_O_) as RECNO"+cEnt
	cQuery += " FROM " + RetSqlName("SZD")+" SZD "+cEnt
	cQuery += " WHERE ZD_FILIAL = '"+xFilial("SZD")+"'"+cEnt
	cQuery += " AND ZD_CNPJUSI  = '"+cCgcUsina+"'"+cEnt
	cQuery += " AND ZD_NFREMES  = '"+StrZero(Val(aTmpDados[3]),9)+"'"+cEnt
	cQuery += " AND ZD_SERIER   = '"+Alltrim(aTmpDados[4])+Space(3-Len(Alltrim(aTmpDados[4])))+"'"+cEnt
	cQuery += " AND D_E_L_E_T_  = ' '"
	
	If Select(cAlias) > 0
		DbselectArea(cAlias)
		(cAlias)->(DbCloseArea())
	EndIf
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
	
	nRegistro := (cAlias)->RECNO
	
	(cAlias)->(DbCloseArea())
	
	dbSelectArea("SZD")
	SZD->(DbGoto(nRegistro))
	
	If nRegistro > 0 .and. SZD->ZD_STATUS <> "EX"
		*-------------------------------------------------------------------------------*
		* Checa se o terminal foi cadastrado previamente. Tabela de Terminais x Armazem.*
		*-------------------------------------------------------------------------------*
		SZE->(DbSetOrder(1))
		If SZE->(DbSeek(xFilial("SZE")+cCgcTerm))
			*--------------------------------------------------------------------------------------------*
			* Posiciona na tabela de Controle das entradas XML x Template                                *
			*--------------------------------------------------------------------------------------------*
			SZD->(DbGoto(nRegistro))
			*-----------------------------------------------------------------------------------------------*
			* Busca o total recebido pelas NFs Remessa de um mesmo Contrato + Perํodo + Mae                 *
			*-----------------------------------------------------------------------------------------------*
			cQuery := " SELECT Sum(ZD_QTDREC) as TOT_RECEB"+cEnt
			cQuery += " FROM " + RetSqlName("SZD")+" SZD "+cEnt
			cQuery += " WHERE ZD_FILIAL = '"+xFilial("SZD")+"'"+cEnt
			cQuery += " AND ZD_CNPJUSI  = '"+cCgcUsina+"'"+cEnt
			cQuery += " AND ZD_NFMAE    = '"+SZD->ZD_NFMAE+"'"+cEnt
			cQuery += " AND ZD_SERIEM   = '"+SZD->ZD_SERIEM+"'"+cEnt
			cQuery += " AND D_E_L_E_T_  = ' '"+cEnt
			
			If Select(cAlias) > 0
				DbselectArea(cAlias)
				(cAlias)->(DbCloseArea())
			EndIf
			
			DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), cAlias, .F., .T.)
			
			nTot_Rec := (cAlias)->TOT_RECEB
			
			(cAlias)->(DbCloseArea())
			
			*-----------------------------------------------------------------------------------*
			* Posiciona no ๚nico item da NF Remessa para gerar Transferencia ou Devolu็ใo desta *
			*-----------------------------------------------------------------------------------*
			SA2->(DbSetOrder(3))
			SA2->(DbSeek(xFilial("SA2")+cCgcUsina))
			
			_cNF     := StrZero(Val(aTmpDados[3]),9)
			_cSerie  := Alltrim(aTmpDados[4])+Space(3-Len(Alltrim(aTmpDados[4])))
			_cChave  := _cNF+_cSerie+SA2->A2_COD+SA2->A2_LOJA
			
			SD1->(DbSetOrder(1))
			SD1->(DbSeek(xFilial("SD1")+_cChave))
			
			cNumSeqSD1 := SD1->D1_NUMSEQ
			
			*--------------------------------------------------------------------------------------------*
			* Checa se ha saldo sobre a NF Remessa ?                                                     *
			*--------------------------------------------------------------------------------------------*
			
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
			
			lDecimais := .f.
			nDecimais := 0
			For a:=1 to Len(aTmpDados[5])
				If SubStr(aTmpDados[5],a,1) == ","
					lDecimais := .t.
				Else
					If lDecimais
						nDecimais += 1
					EndIf
				EndIf
			Next
			
			If  SB1->B1_SEGUM == SB1->B1_UM
				// Renuka e Revati
				If nDecimais <> 0
					_nQtdRec := Val(SubStr(aTmpDados[5],1,Len(aTmpDados[5])-(nDecimais+1)) + "." + SubStr(aTmpDados[5],Len(aTmpDados[5])-nDecimais+1,nDecimais))
				Else
					_nQtdRec := Val(aTmpDados[5])
				EndIf
				_nQtdRecPc := _nQtdRec
			Else
				If  nDecimais <> 0
					_nQtdRec := (Val(SubStr(aTmpDados[5],1,Len(aTmpDados[5])-(nDecimais+1)) + "." + SubStr(aTmpDados[5],Len(aTmpDados[5])-nDecimais+1,nDecimais))) / SB1->B1_CONV
				Else
					_nQtdRec := Val(aTmpDados[5]) / SB1->B1_CONV
				EndIf
				_nQtdRecPc := _nQtdRec * SB1->B1_CONV
			EndIf
			
			If _nQtdRec > SZD->ZD_SALDO
				If Aviso(" Aten็ใo ","A quantidade recebida:"+Transform(_nQtdRec,"@E 999,999,999.999")+" ้ maior do que saldo e ou quantidade prevista de: "+Transform(SZD->ZD_SALDO,"@E 999,999,999.999")+", sobre a Nota Fiscal de Remessa : "+SD1->D1_DOC+" ! Deseja confirmar a entrada mesmo assim ? ",{"Sim","Nใo"}) == 2
					cTexto := "A quantidade recebida sobre a NF Remessa "+SD1->D1_DOC+": "+Transform(_nQtdRec,"@E 999,999,999.999")+" ้ maior do que o saldo e ou quantidade prevista de: "+Transform(SZD->ZD_SALDO,"@E 999,999,999.999")+"."
					aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
					lProcessa := .f.
				EndIf
				*--------------------------------------------------------------------------------------------*
				* Saldo a devolver. Serแ amarrado com o n๚mero NUMSEQ da NF Remessa para fins de estorno     *
				*--------------------------------------------------------------------------------------------*
				If SZD->ZD_STATUS == "AT"
					// nDevol := -1 * (SZD->ZD_SALDO - _nQtdRec)  // 06/08/18 - Luis Felipe
					nDevol := 0
				Else
					*--------------------------------------------------------------------------------------------*
					* Caso exista um saldo a transferir (SZD). Primeiro farแ a transfer๊ncia do armazem ??01 p/  *
					* ?? e depois a devolu็ใo da quantidade recebida a maior.                                    *
					*--------------------------------------------------------------------------------------------*
					nDevol := _nQtdRec - SZD->ZD_SALDO
					nTransf:= SZD->ZD_SALDO
				EndIf
			Else
				*--------------------------------------------------------------------------------------------*
				* Saldo a Transferir. Serแ amarrado com o n๚mero NUMSEQ da NF Remessa para fins de estorno.  *
				* AT - Serแ classificada, sendo assim serแ transferida a diferen็a entre o total da NF e     *
				* a qtd. recebida (Nota - Recebido) - 03 p/ 0301.                                            *
				* Else - > entrada parcial, devolve para o armazem principal. 0301 p/ 01                     *
				*--------------------------------------------------------------------------------------------*
				If SZD->ZD_SALDO - _nQtdRec >= 0 
					If SZD->ZD_STATUS == "AT"
						// nTransf := SZD->ZD_SALDO - _nQtdRec // 06/08/18 - Luis Felipe
						nTransf := 0
					Else
						nTransf := _nQtdRec
					EndIf
				EndIf
			EndIf
			*--------------------------------------------------------------------------------------------*
			* Checa se ha saldo sobre a NF Mae ?                                                         *
			*--------------------------------------------------------------------------------------------*
			If !Empty(SZD->ZD_NFMAE)
				If _nQtdRec > (SZD->ZD_QTDMAE-nTot_Rec)
					If	Aviso(" Aten็ใo " ,"A quantidade recebida:"+Transform(_nQtdRec,"@E 999,999,999.999")+" ultrapassa a quantidade da NF Mae, prevista em: "+Transform(SZD->ZD_QTDMAE,"@E 999,999,999.999")+". Isso, porque o saldo recebido ้ de: "+Transform(nTot_Rec,"@E 999,999,999.999")+", restando: "+Transform(SZD->ZD_QTDMAE-nTot_Rec,"@E 999,999,999.999")+" ! Deseja confirmar a entrada da NF Remessa: "+SD1->D1_DOC+" mesmo assim ? ",{"Sim","Nใo"}) == 2
						cTexto := "A quantidade recebida:"+Transform(_nQtdRec,"@E 999,999,999.999")+" sobre a NF Remessa "+SD1->D1_DOC+" ultrapassa a quantidade da NF Mae, prevista em: "+Transform(SZD->ZD_QTDMAE,"@E 999,999,999.999")+". Isso, porque o saldo recebido ้ de: "+Transform(nTot_Rec,"@E 999,999,999.999")+", restando: "+Transform(SZD->ZD_QTDMAE-nTot_Rec,"@E 999,999,999.999")+". "
						aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
						lProcessa := .f.
					EndIf
				EndIf
			Else
				DbSelectArea("SC7")
				SC7->(DbSetOrder(1))
				SC7->(DbSeek(xFilial("SC7")+SZD->ZD_PEDIDOC))
				nSldSC7 := SC7->C7_QUANT - SC7->C7_QUJE
				If _nQtdRecPc > nSldSC7 // _nQtdRec > nSldSC7 - 22/05/14 - Luis Felipe
					If Aviso(" Aten็ใo " ,"A quantidade recebida sobre a NF de Remessa : "+SZD->ZD_NFREMES+" ้ maior que o saldo do Pedido de Compras de N. "+SZD->ZD_PEDIDOC+", quantidade: "+Transform(nSldSC7,"@E 999,999,999.999")+" . Confirmar a entrada ? ",{"Sim","Nใo"}) == 2
						cTexto := "A quantidade recebida sobre a NF de Remessa : "+SZD->ZD_NFREMES+" ้ maior que o saldo do Pedido de Compras de N. "+SZD->ZD_PEDIDOC+", quantidade: "+Transform(nSldSC7,"@E 999,999,999.999")
						aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRecPc,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
						lProcessa := .f.
					EndIf
				EndIf
			EndIf
			
			If  lProcessa
				
				*-------------------------------------------------------------*
				* Incrementa o sequencial do Template                         *
				*-------------------------------------------------------------*
				If  !lAlt
					cSeqTemp := Soma1(cSeqTemp)
					lAlt := .t.
				Endif
				If !Empty(aTmpDados[8])
					RecLock("SZD",.F.)
					SZD->ZD_QTDTERI := _nQtdRec
					SZD->ZD_CNPJTEI := cCgcTerm
					SZD->ZD_NOMETEI := SZE->ZE_NOME
					SZD->ZD_DTTERMI := CtoD(aTmpDados[8])
					SZD->ZD_SEQTEMP := cSeqTemp
					MsunLock()
				Else
					*--------------------------------------------------------------------------------------------*
					* Classificacao total da NF Remessa, primeira entrada.                                       *
					* Foi acordado com o cliente que existirแ apenas um item por NF Remessa pois, as quantidades *
					* recebidas do Terminal sใo em toneladas e nใo sใo informadas por item.                      *
					*--------------------------------------------------------------------------------------------*
					aSZD := {}
					If SZD->ZD_SALDO == SZD->ZD_QTDNFRE .and. SZD->ZD_STATUS == "AT"
						*--------------------------------------------------------------------------------------*
						* Confirma se a NF estแ classificada                                                   *
						*--------------------------------------------------------------------------------------*
						If Empty(SD1->D1_TES)
							If CtoD(aTmpDados[9]) > __dUlMes .and. CtoD(aTmpDados[9]) >= SD1->D1_EMISSAO
								lClass := Classifica(_cNF,_cSerie,SA2->A2_COD,SA2->A2_LOJA,SZE->ZE_LOCAL)
							Else
								If CtoD(aTmpDados[9]) < __dUlMes
									Aviso(" Aten็ใo " ,"A NF Remessa "+_cNF+" - "+_cSerie+" nใo foi classificada pois, a data de descarga no Porto deste documento ้ inferior a data do ๚ltimo fechamento ! ",{"Continuar"})
									cTexto := "A NF Remessa "+_cNF+" - "+_cSerie+" nใo foi classificada pois, a data de descarga no Porto deste documento ้ inferior a data do ๚ltimo fechamento ! "
									aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
								Else
									Aviso(" Aten็ใo " ,"A data de desembarque "+aTmpDados[9]+" ้ anterior a data de emissใo da NF Remessa "+_cNF+" - "+_cSerie+" ! Sendo assim, esta NF nใo serแ classificada.",{"Continuar"})
									cTexto := "A data de desembarque "+aTmpDados[9]+" ้ inferior a data de emissใo da NF Remessa "+_cNF+" - "+_cSerie+" ! Sendo assim, esta NF nใo serแ classificada."
									aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
								EndIf
								lClass := .f.
							EndIf
						Else
							Aviso(" Aten็ใo " ,"A NF Remessa "+_cNF+" - "+_cSerie+" foi classificada manualmente. Sendo assim, nใo poderemos controlar o saldo desta! ",{"Continuar"})
							cTexto := "NF Remessa foi classificada manualmente."
							aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
							lClass := .f.
						EndIf
						
						If lClass
							SD1->(DbSeek(xFilial("SD1")+_cChave))
							cNumSeqSD1 := SD1->D1_NUMSEQ
							
							If 	nTransf <> 0
								TrSD1xSD3(nTransf,"1")
							EndIf
							If	nDevol <> 0
								DevolSD1(nDevol)
							EndIf
							*--------------------------------------------------------------------------------------------------------*
							* Atualiza tabela de Controle das Entradas de NFดs de Remessa e Mae                                      *
							*--------------------------------------------------------------------------------------------------------*
							RecLock("SZD",.f.)
							SZD->ZD_SEQTEMP := cSeqTemp
							SZD->ZD_DTTEMPL := Ddatabase
							SZD->ZD_STATUS  := IIf(_nQtdRec == SZD->ZD_SALDO,"BX",If(_nQtdRec > SZD->ZD_SALDO,"QT","BP"))
							SZD->ZD_CNPJTER := cCgcTerm
							SZD->ZD_LOCAL	:= SZE->ZE_LOCAL
							SZD->ZD_CNPJTER := cCgcTerm
							SZD->ZD_NOMETER := SZE->ZE_NOME
							SZD->ZD_DTETERM := CtoD(aTmpDados[9])
							SZD->ZD_PLACA   := aTmpDados[10]
							*--------------------------------------------------------------------------------------------------------*
							* Atualiza saldo da parcela atual                                                                        *
							*--------------------------------------------------------------------------------------------------------*
							SZD->ZD_SALDO   := SZD->ZD_SALDO - _nQtdRec // If(_nQtdRec >= SZD->ZD_SALDO,0,SZD->ZD_SALDO - _nQtdRec)
							SZD->ZD_QTDREC  := _nQtdRec
							MsunLock()
						Endif
					Else
						// 06/03/14 - Luis Felipe Nascimento
						If CtoD(aTmpDados[9]) < __dUlMes
							Aviso(" Aten็ใo " ,"A NF Remessa "+_cNF+" - "+_cSerie+" nใo foi classificada pois, a data de descarga no Porto deste documento ้ inferior a data do ๚ltimo fechamento ! ",{"Continuar"})
							cTexto := "A NF Remessa "+_cNF+" - "+_cSerie+" nใo foi classificada pois, a data de descarga no Porto deste documento ้ inferior a data do ๚ltimo fechamento ! "
							aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
						Else
							If	nTransf <> 0
								TrSD1xSD3(nTransf,"2")
							EndIf
							If	nDevol <> 0
								DevolSD1(nDevol)
							EndIf
							*--------------------------------------------------------------*
							* Entrada parcial - Gerar novo registro para controle do saldo *
							*--------------------------------------------------------------*
							cParc 	:= Soma1(SZD->ZD_PARC)
							cContra	:= SZD->ZD_CONTRA
							cPeriodo:= SZD->ZD_PERIODO
							cCNPJUsi:= SZD->ZD_CNPJUSI
							cNUsina := SZD->ZD_NUSINA
							cNFMae	:= SZD->ZD_NFMAE
							cSerieM	:= SZD->ZD_SERIEM
							nQtdMae	:= SZD->ZD_QTDMAE
							cNFREMES:= SZD->ZD_NFREMES
							cSerieR	:= SZD->ZD_SERIER
							nQtdNFRe:= SZD->ZD_QTDNFRE
							nSaldo	:= SZD->ZD_SALDO
							cPedido	:= SZD->ZD_PEDIDOC
							cUM     := SZD->ZD_UM
							dEmisRem:= SZD->ZD_EMISREM
							nVlrNFRe:= SZD->ZD_VLRNFRE
							nVlrMae := SZD->ZD_VLRMAE
							*-----------------------------*
							* Transmite campos para o array
							*-----------------------------*
							For nX:= 1 To FCount()
								Aadd(aSZD, {fieldname(nX), fieldget(nX)})
							Next
							*--------------------------------------------------------------------------------------------------------*
							* Gera novo registro, a partir do registro atual                                                         *
							*--------------------------------------------------------------------------------------------------------*
							RecLock("SZD",.T.)
							For i:=1 to Len(aSZD)
								&(aSZD[i][1]) :=  aSZD[i][2]
							Next i
							SZD->ZD_FILIAL	:= xFilial("SZD")
							SZD->ZD_CONTRA	:= cContra
							SZD->ZD_PERIODO	:= cPeriodo
							SZD->ZD_CNPJUSI	:= cCNPJUsi
							SZD->ZD_NUSINA	:= cNUsina
							SZD->ZD_NFMAE	:= cNFMae
							SZD->ZD_SERIEM	:= cSerieM
							SZD->ZD_QTDMAE	:= nQtdMae
							SZD->ZD_NFREMES	:= cNFREMES
							SZD->ZD_SERIER	:= cSerieR
							SZD->ZD_QTDNFRE	:= nQtdNFRe
							SZD->ZD_PEDIDOC := cPedido
							SZD->ZD_SEQTEMP := cSeqTemp
							SZD->ZD_DTTEMPL := Ddatabase
							SZD->ZD_PARC	:= cParc
							SZD->ZD_STATUS  := IIf(_nQtdRec == nSaldo,"BX",If(_nQtdRec > nSaldo,"QT","BP"))
							SZD->ZD_CNPJTER := cCgcTerm
							SZD->ZD_NOMETER := SZE->ZE_NOME
							SZD->ZD_LOCAL	:= SZE->ZE_LOCAL
							SZD->ZD_DTETERM := CtoD(aTmpDados[9])
							SZD->ZD_PLACA   := aTmpDados[10]
							SZD->ZD_UM		:= cUM
							SZD->ZD_EMISREM := dEmisRem
							SZD->ZD_VLRNFRE := nVlrNFRe
							SZD->ZD_VLRMAE	:= nVlrMae
							*----------------------------------------------------------------------------------------------------------*
							* Atualiza saldo da parcela atual                                                                          *
							*----------------------------------------------------------------------------------------------------------*
							SZD->ZD_SALDO   := nSaldo - _nQtdRec // If(_nQtdRec >= nSaldo,0,nSaldo - _nQtdRec)
							SZD->ZD_QTDREC  := _nQtdRec
							*----------------------------------------------------------------------------------------------------------*
							* Limpa as informa็๕es do Terminal do Interior pois, pode existir uma novo preenchimento para esses campos *
							*----------------------------------------------------------------------------------------------------------*
							SZD->ZD_QTDTERI := 0
							SZD->ZD_CNPJTEI := ""
							SZD->ZD_DTTERMI := CtoD("  /  /  ")
							MsunLock()
						EndIf
					EndIf
					If lClass
						AtualizaPC(SZD->ZD_PEDIDOC,_nQtdRecPc,SZD->ZD_QTDMAE,nTot_Rec)
					EndIf
				Endif
				SF1->(DbSetOrder(1))
				SF1->(DbSeek(xFilial("SF1")+_cChave))
				if SF1->F1_TIPO == "N" .or. (SF1->F1_TIPO == "C" .and. SF1->F1_TPCOMPL == "2")
					//Gera Pedido de Venda
					cCLIENT := Posicione("SA1",3,xFilial("SA1")+SM0->M0_CGC,"A1_COD")
					cLOJAC := SA1->A1_LOJA
					cCODPAG := SA1->A1_COND
					cTpCli := SA1->A1_TIPO
					
					cNumPed := GetSX8Num( "SC5", "C5_NUM" )  
					//ConfirmSx8()
					
					/*
					dbSelectArea("SC5")
					SC5->(dbSetOrder(1))
					SC5->(MsSeek(xFilial("SC5")+"zzzzzz",.T.))
					SC5->(dbSkip(-1))
					cNumPed := SC5->C5_NUM
					If Empty(cNumPed)
					   cNumPed := StrZero(1,Len(SC5->C5_NUM))
					Else
					   cNumPEd := Soma1(cNumPed)
					EndIf
					*/
					
					nMoeda := 1       
					aItens := {}                  
					aCab := {}
					
					cItem := "01"                
					LMSERROAUTO := .F.

					cMenNot := "ATO DECLATำRIO N 70 DE 15/07/2005 NA 8 REGIรO FISCAL N DO "
					cMenNot += "RECINTO ALFANDEGADO 8931313, SETOR003 NAO INCIDENCIA DE ICMS "
					cMenNot += "CONF. ART 7 INC V DO DECRETO 45.490/00 E INCISO I DO CONV. "
					cMenNot += "83/2006 IPI SUSPENSO, ART. 43 INC V ITEM A DO DEC. "
					cMenNot += "7.212/2010 FORMACAO DE LOTE MERCADORIA ADQUIRIDA DE "
					cMenNot += ALLTRIM(POSICIONE("SA2",1,XFILIAL("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_NOME"))+" "
					cMenNot += "CNPJ: "+TRANSFORM(SA2->A2_CGC,IIF(LEN(ALLTRIM(SA2->A2_CGC))=14,"@R 99.999.999/9999-99","@R 999.999.999-99"))+" " 
					cMenNot += "NF "+ALLTRIM(SF1->F1_DOC)+" DE "+DTOC(SF1->F1_EMISSAO)+" "
					cMenNot += "TERMINAL: "+ALLTRIM(POSICIONE("NNR",1,XFILIAL("NNR")+SD1->D1_LOCAL,"NNR_DESCRI"))
					
					dDatabase2 := dDatabase
					
					Ddatabase := __Ddatabase
					
					aCabec:={	{"C5_NUM"	 ,cNumPed		,Nil},; // Numero do pedido
								{"C5_TIPO"	 ,"N"			,Nil},; // Tipo de pedido
								{"C5_TIPOCLI",cTpCli		,Nil},; // Tipo do cliente
								{"C5_CLIENTE",cClient    	,Nil},; // Codigo do cliente
								{"C5_LOJACLI",cLojaC     	,Nil},; // Loja do cliente
								{"C5_EMISSAO",dDatabase 	,Nil},; // Data de emissao
								{"C5_CONDPAG",cCodPag		,Nil},; // Condi็ใo de Pagamento
								{"C5_XNFORIG",_cChave		,Nil},; // Nota Fiscal de Origem
								{"C5_XMENNOT",cMenNot		,Nil},;
								{"C5_MOEDA"  ,nMoeda		,Nil}}	// Moeda 
					
					AAdd(aItens,{	{"C6_NUM"	 ,cNumped				,Nil},; // Numero do Pedido
									{"C6_ITEM"   ,cItem					,Nil},; // Numero do Item no Pedido
									{"C6_PRODUTO",SD1->D1_COD			,Nil},; // Codigo do Produto
									{"C6_QTDVEN" ,SD1->D1_QUANT			,Nil},; // Quantidade Vendida       				
									{"C6_PRCVEN" ,SD1->D1_VUNIT			,Nil},; // Preco Unitario Liquido
									{"C6_VALOR"  ,SD1->D1_TOTAL			,Nil},; // Valor Total do Item    
									{"C6_ENTREG" ,dDataBase				,Nil},; // Data da Entrega
									{"C6_OBSITEM","Gera็ใo Automatica."	,Nil},; // Obs do Item                         
									{"C6_LOCAL"  ,SD1->D1_LOCAL			,Nil},; // Armazem
									{"C6_TES"    ,GetMV("MV_XTESPV")	,Nil},; // Tipo de Entrada/Saida do Item
									{"C6_XCLVL"  ,GetMV("MV_XCLVL")		,Nil}})
							   
					BeginTran()
					
					lMSErroAuto := .F.
					MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabec,aItens,3)
					
					If lMsErroAuto
						rollbacksx8()
						MostraErro()
						DisarmTran()
					Else
						confirmsx8()
						//MSGALERT("PEDIDO DE VENDA GERADO: "+cNumPed)
						//MsgInfo("Pedido de Venda "+SC5->C5_NUM+" gerado.")
						cDoc := SC5->C5_NUM
						LiberaPV(cDoc)
						aRet := GeraNotaPV(cDoc/*,StrZero(Val(oXml:_Nfe:_InfNfe:_Ide:_nNF:Text),9)*/)
						If !aRet[1]
							MsgAlert(aRet[2])
							DisarmTran()
						else
							SF3->(DbSetOrder(4))
							If SF3->(DbSeek(xFilial("SF3")+cClient+cLojaC+aRet[3]+Padr(GetMv("MV_XSERIE"),TamSX3("F2_SERIE")[1])))
								SF3->(RecLock("SF3",.F.))
								SF3->F3_XNFORIG := _cChave
								Msunlock()
							EndIf						
							//MsgInfo("Nota Fiscal de Saํda "+aRet[3]+" gerada.")
							EndTran()
						EndIf
					ENDIF
					
					dDatabase := dDatabase2
					
				endif	
			EndIf
		Else
			cTexto := "Nใo existe armazem cadastrado para o terminal sob o CNPJ "+aTmpDados[6]+" informado !"
			aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
		EndIf
	Else
		cTexto := "Nใo foi encontrada a NF de Remessa de n๚mero "+aTmpDados[3]+" e serie "+aTmpDados[4]+" !"
		aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
	EndIf
	
	IncProc("Importando....")
	
	*------------------------*
	* Incrementa linha       *
	*------------------------*
	FT_FSKIP()
End

Ddatabase := __Ddatabase

// SZD->(DbReindex())

*--------------------------------*
* Atualiza sequencial do Template
*--------------------------------*
If lAlt
	PutMV("MV_XSQTEMP",cSeqTemp)
EndIf

If Len(aErroLog) > 0
	If MsgYesNo("Deseja Gerar Log com as inconsist๊ncias encontradas em Excel.")
		aCab := {"CNPJ Usina","Descricao Usina","Nบ NF remessa","Serie NF remessa","Qtd Recebida (lํquido) kg","CNPJ Terminal","Descricao terminal","Data descarga: Interior","Data descarga: Porto","Placa Caminhao/Vagao","Motivo"}
		DlgToExcel({{"ARRAY","",aCab,aErroLog}})
	EndIf
Else
	MsgInfo("Importa็ใo realizada sem inconsist๊ncias.")
EndIf

Return

*-----------------------------------------------------------*
Static Function Classifica(cNota,cSerie,cFornec,cLoja,cLocal)
*-----------------------------------------------------------*

Local cFilSD1 		:= xFilial("SD1")
Local cFilSF1 		:= xFilial("SF1")
Local cTes			:= SuperGetMV("MV_XTSNFRM",.t.,"006")
Local lMSErroAuto 	:= .F.
Local lRet 			:= .t.
Local aCab			:= {}
Local aItem	 		:= {}
Local nReg			:= 0
Local cCondicao		:= SuperGetMV("MV_XCONDRM",.t.,"100")
Local cNatureza		:= SuperGetMV("MV_XNATURM",.t.,"0068")
Local dVencto		:= Ctod("  /  /  ")
Local nXQTDORI 		:= 0
Local nXVLRORI 		:= 0
Local lNFDifPorto   := .f.
Local nX

SD1->( dbSetOrder(1) )
SD1->( DbSeek(cFilSD1+cNota+cSerie+cFornec+cLoja) )

// 06/08/18 - Luis Felipe - Inicio
If SD1->D1_QUANT <> _nQtdRec 
	lNFDifPorto := .t.
	nXQTDORI := SD1->D1_QUANT
	nXVLRORI := SD1->D1_TOTAL
	nFator := U_EDFFATOR(SD1->D1_COD)
	SD1->(RecLock("SD1",.F.))
	SD1->D1_QUANT 	:= _nQtdRec
	SD1->D1_QTSEGUM := _nQtdRec * If(nFator<>0.00,nFator,1)
	SD1->D1_TOTAL	:= _nQtdRec * SD1->D1_VUNIT                 
	Msunlock()
EndIf
// 06/08/18 - Luis Felipe - Fim

SF1->( DbSetOrder(1) )
SF1->( DbSeek(cFilSD1+cNota+cSerie+cFornec+cLoja ) )

// 06/08/18 - Luis Felipe - Inicio
If lNFDifPorto
	SF1->(RecLock("SF1",.F.))
	SF1->F1_VALMERC := SD1->D1_TOTAL
	SF1->F1_VALBRUT := SD1->D1_TOTAL
	Msunlock()
EndIf
// 06/08/18 - Luis Felipe - Fim

// 04/09/18 - Luis Felipe - Inicio
// Quando nใo houver NF Mae serแ gerado financeiro, por isso estamos informando com outra TES.
If Empty(SF1->F1_NFMAE)
	If !lNFDifPorto
		cTes := "021" 
	Else
		cTes := "221"
	EndIf	
Else	
	If lNFDifPorto
		cTes := "206"
	EndIf
EndIf
// 04/09/18 - Luis Felipe - Fim

SF4->( dbSetOrder(1) )
SF4->( dbSeek( xFilial("SF4")+cTes ) )

// nReg := SD1->(Recno())

// While SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == cFilSD1+cNota+cSerie+cFornec+cLoja // 06/09/18 - Luis Felipe
	
SA2->( dbSetOrder(1) )
SA2->( dbSeek( xFilial("SA2")+cFornec+cLoja ) )

SB1->( dbSetOrder(1) )
SB1->( dbSeek( xFilial("SB1")+SD1->D1_COD ) )

DdataBase := CtoD(aTmpDados[9])

aCab := {{"F1_TIPO"   , SF1->F1_TIPO	 ,NIL},;
{"F1_FORMUL" , "N"              ,NIL},;
{"F1_DOC"    , SF1->F1_DOC      ,NIL},;
{"F1_SERIE"  , SF1->F1_SERIE    ,NIL},;
{"F1_EMISSAO", SF1->F1_EMISSAO  ,NIL},;
{"F1_FORNECE", SF1->F1_FORNECE  ,NIL},;
{"F1_LOJA"   , SF1->F1_LOJA     ,NIL},;
{"F1_ESPECIE", 'NFE'            ,NIL},;
{"F1_DTDIGIT",CtoD(aTmpDados[9]),NIL}}

AAdd(aItem,{{"D1_ITEM"   ,SD1->D1_ITEM  ,Nil},;
{"D1_COD"    ,SD1->D1_COD ,Nil},;
{"D1_UM"     ,SD1->D1_UM              	,Nil},;
{"D1_QUANT"  ,SD1->D1_QUANT           	,Nil},;
{"D1_VUNIT"  ,SD1->D1_VUNIT 			,Nil},;
{"D1_TOTAL"  ,SD1->D1_TOTAL           	,Nil},;
{"D1_LOCAL"  ,cLocal                	,Nil},;
{"D1_TES"    ,cTes                    	,Nil},;
{"D1_CLVL", SUBSTR(TRIM(SF1->F1_NAVIO),1,9)  ,Nil},;
{"D1_IPI"    ,0                       	,Nil},;
{"D1_VALIPI" ,0                       	,Nil},;
{"D1_PICM"   ,0                       	,Nil},;
{"D1_VALICM" ,0   						,Nil},;
{"D1_BASEICM" ,0   						,Nil},;
{"D1_BASEIPI" ,0   						,Nil},;
{"D1_RATEIO" ,"2"                     	,Nil},;
{"D1_BRICMS" ,0                       	,Nil},;
{"D1_ICMSRET",0                       	,Nil},;
{"D1_DTDIGIT",CtoD(aTmpDados[9])		,NIL}})

//	SD1->(DbSkip())
// End

// SD1->(DbGoto(nReg)) 

MSExecAuto({|x,y,z| MATA103(x,y,z)},aCab,aItem,4)

If lMSErroAuto
	cTexto := ""
	For nX := 1 To Len(aLog)
		FWrite(nHandle,aLog[nX]+CHR(13)+CHR(10))
		cTexto += aLog[nX]+CHR(13)+CHR(10)
	Next nX
	aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
	lRet := .f.
Else
	If cTes $ "021|221" // cTes == "021" 06/09/18 - Luis Felipe
		SZ3->(DbSetOrder(1))
		If SZ3->(DbSeek(xFilial("SZ3")+SF1->F1_CONTRA+SF1->F1_XPERIOD))
			dVencto := DataValida(SZ3->Z3_DTFIM,.T.)
			SE2->(DbSetOrder(6))
			If SE2->(DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC))
				SE2->(RecLock("SE2",.F.))
				SE2->E2_VENCTO  := dVencto
				SE2->E2_VENCREA := dVencto
				SE2->E2_NATUREZ := cNatureza
				SE2->(MsUnlock())
			EndIf
		EndIf
	EndIf
	// 06/08/18 - Luis Felipe - Inicio
	If lNFDifPorto
		SD1->(RecLock("SD1",.F.))
		SD1->D1_XQTDORI := nXQTDORI
		SD1->D1_XVLRORI := nXVLRORI
		Msunlock()
		
		SF3->(DbSetOrder(4))
		If SF3->(DbSeek(xFilial("SF3")+SD1->(D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE)))
			SF3->(RecLock("SF3",.F.))
			SF3->F3_XQTDORI := nXQTDORI
			SF3->F3_XVLRORI := nXVLRORI
			SF3->F3_OBSERV  := "NF ESCR. CONF. RECEB." 
			Msunlock()
		EndIf

		SFT->(DbSetOrder(1))
		If SFT->(DbSeek(xFilial("SFT")+"E"+SD1->(D1_SERIE+D1_DOC+D1_FORNECE+D1_LOJA)))
			SFT->(RecLock("SFT",.F.))
			SFT->FT_OBSERV  := "NF ESCR. CONF. RECEB."
			Msunlock()
		EndIf
	EndIf
	// 06/08/18 - Luis Felipe - Fim

EndIf

Return( lRet )

*-----------------------------------------------------------------*
* Atualiza Pedido de Compras - NF Mae                             *
* Checa se jแ houve alguma Nota de Remessa Classifica. Isso para  *
* implantar o saldo inicial - a quantidade recebida.              *
*-----------------------------------------------------------------*

Static Function AtualizaPC(cPedido,nQtd,nQtdMae,nTot_Rec)

Local nDifer 	:= 0

SC7->(DbSetOrder(1))
If SC7->(DbSeek(xFilial("SC7")+cPedido))
	// 30/09/13 - Luis Felipe Nascimento
	// Toda a entrada serแ em toneladas e os pedidos tamb้m.
	nDifer  := If(SC7->C7_QUJE+nQtd > SC7->C7_QUANT,SC7->C7_QUANT - SC7->C7_QUJE,nQtd)
	RecLock("SC7",.F.)
	SC7->C7_QUJE 	+= nDifer
	SC7->C7_QTDACLA += nDifer
	Msunlock()
	/* Nใo poderแ ser usado pois, a entrada das NF de Remessas de um mesmo pedido tem vแrios armaz้ns de destino.
	SB2->(DbSetOrder(1))
	If SB2->(DbSeek(xFilial("SB2")+SD1->D1_COD+SD1->D1_LOCAL))
	RecLock("SB2",.F.)
	If nTot_Rec == 0
	SB2->B2_SALPEDI := nQtdMae - nDifer
	SB2->B2_SALPED2 := ConvUm(SD1->D1_COD,nQtdMae - nDifer,0,2)
	Else
	SB2->B2_SALPEDI -= nDifer
	SB2->B2_SALPED2 -= ConvUm(SD1->D1_COD,nDifer,0,2)
	EndIf
	Msunlock()
	EndIf
	*/
EndIf

Return

*----------------------------------------------------------------*
* a260Processa - Gera lan็amento de transferencia entre armazens *
* Tem que estar posicionado no item da NF Remessa                *
*----------------------------------------------------------------*

Static Function TrSD1xSD3(nQtd,cTipo)

Local cCodOrig 		:= SD1->D1_COD
Local cUmOrig  		:= SD1->D1_UM
Local cLocOrig 		:= If(cTipo=="1",SD1->D1_LOCAL,Alltrim(SD1->D1_LOCAL)+"01")
Local cLoclzOrig	:= ""
Local cNumLote  	:= ""
Local cNumSerie 	:= ""
Local cCodDest 		:= SD1->D1_COD
Local cUmDest  		:= SD1->D1_UM
Local cLocDest 		:= If(cTipo=="1",Alltrim(SD1->D1_LOCAL)+"01",SD1->D1_LOCAL)
Local cLoclzDest	:= ""
Local nQuant260 	:= nQtd
Local nQuant260D	:= ConvUm(SD1->D1_COD,nQtd,0,2)
Local cLoteDigi		:= ""
Local dDtValid 		:= CtoD("  /  /  ")
Local nPotencia 	:= 0
Local cDocto   		:= ""
Local dEmis260 		:= CtoD(aTmpDados[9])
Local cLoteDigi		:= ""
Local dDtVldDest	:= CtoD("  /  /  ")
Local aArea			:= GetArea()

Private cCusMed  	:= GetMv("MV_CUSMED")
Private cCadastro	:= OemToAnsi("Transfer๊ncias")
Private aRegSD3  	:= {}
Private aHeader	 	:= {}
Private aCols 	 	:= {}

If cCusMed == "O"
	Private nHdlPrv 			// Endereco do arquivo de contra prova dos lanctos cont.
	Private lCriaHeader := .T. 	// Para criar o header do arquivo Contra Prova
	Private cLoteEst 			// Numero do lote para lancamentos do estoque
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona numero do Lote para Lancamentos do Faturamento     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SX5")
	DbSeek(xFilial()+"09EST")
	cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
	Private nTotal := 0 		// Total dos lancamentos contabeis
	Private cArquivo			// Nome do arquivo contra prova
EndIf

a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,.F.,Nil,Nil,"MATA260",Nil,"",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,nPotencia,cLoteDigi,dDtVldDest)

RestArea(aArea)

Return

*---------------------------------------------------------------*
* Gera devolu็ใo pelas movimenta็๕es internas pois, a
* Quantidade recebida ้ maior do que a esperada.
*---------------------------------------------------------------*

Static Function DevolSD1(nQtd)

Local aVetor := {}
Local cTpMov := SuperGetMV("MV_XTPOMOV",.t.,"002")
Local cPath	 := "C:\Windows\Temp"

SB1->( dbSetOrder(1) )
SB1->( dbSeek( xFilial("SB1")+SD1->D1_COD ) )

aVetor:={{"D3_TM"     ,cTpMov        				,NIL},;
{"D3_COD"    ,SD1->D1_COD	 				,NIL},;
{"D3_LOCAL"  ,SD1->D1_LOCAL 				,NIL},;
{"D3_UM"     ,SD1->D1_UM  	 				,NIL},;
{"D3_QUANT"  ,nQtd			 				,NIL},;
{"D3_SEGUM"  ,SB1->B1_SEGUM                ,NIL},;
{"D3_QTSEGUM",ConvUm(SD1->D1_COD,nQtd,0,2) ,NIL},;
{"D3_DOC"    ,SD1->D1_DOC   				,NIL},;
{"D3_SERIE"  ,SD1->D1_SERIE 				,NIL},;
{"D3_ITEM"   ,SD1->D1_ITEM  				,NIL},;
{"D3_EMISSAO",CtoD(aTmpDados[9])			,NIL}}

MSExecAuto({|x,y| mata240(x,y)},aVetor,3)

If lMsErroAuto
	cTexto := MostraErro(cPath,"EDFA001")
	/*	For nX := 1 To Len(cTexto2)                       r
	FWrite(nHandle,cTexto2[nX]+CHR(13)+CHR(10))
	cTexto += cTexto2[nX]+CHR(13)+CHR(10)
	Next nX
	*/	aAdd(aErroLog,{aTmpDados[1],aTmpDados[2],aTmpDados[3],aTmpDados[4],_nQtdRec,aTmpDados[6],aTmpDados[7],aTmpDados[8],aTmpDados[9],aTmpDados[10],cTexto})
	lClass := .f.
Else
	RecLock("SD3",.f.)
	SD3->D3_XD1NSEQ := cNumSeqSD1
	MsUnlock()
Endif

Return

Static Function LiberaPV(cNumC5)

	Local aArea := GetArea()
	Local aAreaSC5 := SC5->(GetArea())
	Local aAreaSC6 := SC6->(GetArea()) 
	
	Private MV_PAR01 
	Private MV_PAR02 
	Private MV_PAR03 
	Private MV_PAR04 
	Private MV_PAR05 
	Private MV_PAR06 
	Private MV_PAR07 
	Private MV_PAR08 
	Private MV_PAR09 
	Private MV_PAR10 
	Private lLiber
	Private lTransf
	
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+cNumC5))
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+cNumC5))    
	
	MV_PAR01 := 1
	MV_PAR02 := cNumC5
	MV_PAR03 := cNumC5
	MV_PAR04 := SC5->C5_CLIENTE
	MV_PAR05 := SC5->C5_CLIENTE
	MV_PAR06 := SC6->C6_ENTREG
	MV_PAR07 := SC6->C6_ENTREG
	MV_PAR08 := 1
	MV_PAR09 := SC5->C5_LOJACLI
	MV_PAR10 := SC5->C5_LOJACLI
	
	a440Proces(,,,)
	
	MV_PAR01 := Nil
	MV_PAR02 := Nil 	
	MV_PAR03 := Nil
	MV_PAR04 := Nil
	MV_PAR05 := Nil
	MV_PAR06 := Nil
	MV_PAR07 := Nil
	MV_PAR08 := Nil 
	MV_PAR09 := Nil
	MV_PAR10 := Nil
			
	RestArea(aAreaSC6)
	RestArea(aAreaSC5)
	RestArea(aArea)

Return

Static Function GeraNotaPV(cNumC5/*,pNota*/)

	Local aArea := GetArea()
	Local aAreaSC5 := SC5->(GetArea())
	Local aAreaSC6 := SC6->(GetArea())
	Local lRet := .T.
	Local cMsgRet := ""
	Local aPVlNFs := {}
	Local cSerie := AllTrim(GetMv("MV_XSERIE"))
	Local cNota
	
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+cNumC5))
	
	DbSelectArea("SC9")                                       
	SC9->(DbSetOrder(2))
	SC9->(DbSeek(xFilial("SC9")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC5->C5_NUM))
	
	While SC9->(!EOF()) .And. ;
			SC9->C9_FILIAL == SC5->C5_FILIAL .And. ;
			SC9->C9_CLIENTE == SC5->C5_CLIENTE .And. ;
			SC9->C9_LOJA == SC5->C5_LOJACLI .And. ;
			SC9->C9_PEDIDO == SC5->C5_NUM
		
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM+SC9->C9_ITEM+SC9->C9_PRODUTO))
		
		aAdd(aPVlNFs,{	SC9->C9_PEDIDO,; 
						SC9->C9_ITEM,;
						SC9->C9_SEQUEN,;
						SC9->C9_QTDLIB,;
						SC9->C9_PRCVEN,;
						SC9->C9_PRODUTO,;
						SF4->F4_ISS=="S",;
						SC9->(RecNo()),;
						SC5->(Recno()),;
						SC6->(Recno()),;
						SE4->(Recno(Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,""))),;
						SB1->(Recno(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,""))),;
						SB2->(Recno(Posicione("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO,""))),;
						SF4->(Recno(Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,""))),;
						SC9->C9_LOCAL,;
						1,;
						SC9->C9_QTDLIB2,;
						SF4->F4_DUPLIC=="S"})
		
		If !Empty(SC9->C9_BLEST) .Or. !Empty(SC9->C9_BLCRED)
			lRet := .F.
			cMsgRet := "Nota Fiscal nใo foi gerada. Pedido Bloqueado."
			Return {lRet,cMsgRet}
		EndIf
		
		SC9->(DbSkip())
	End
	
	begintran()
	
	/*
	dbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	if SX5->(dbSeek(xFilial("SX5")+"01"+cSerie))
		RecLock("SX5",.F.)
		FieldPut(FieldPos("X5_DESCRI"),pNota)
		FieldPut(FieldPos("X5_DESCSPA"),pNota)
		FieldPut(FieldPos("X5_DESCENG"),pNota)
		SX5->(MsUnlock())
	else
		RecLock("SX5",.T.)
		FieldPut(FieldPos("SX5->X5_FILIAL"),xFilial("SX5"))
		FieldPut(FieldPos("SX5->X5_TABELA"),"01")
		FieldPut(FieldPos("SX5->X5_CHAVE"),cSerie)
		FieldPut(FieldPos("SX5->X5_DESCRI"),pNota)
		FieldPut(FieldPos("SX5->X5_DESCSPA"),pNota)
		FieldPut(FieldPos("SX5->X5_DESCENG"),pNota)
		SX5->(MsUnlock())					
	endif	
	*/
	
	cNota := MAPVLNFS(aPVlNFs,cSerie,.F.,.F.,.F.,.F.,.F.,1,0,.T.,.F.,,,) 
	
	endtran()

	/*
	If cNota <> pNota
		lRet := .F.
		cMsgRet := "Nota Fiscal gerada diferente do XML."
		Return {lRet,cMsgRet}
	EndIf
	*/
	
	if cNota == ""
		lRet := .F.
		cMsgRet := "Erro na gera็ใo da Nota Fiscal."
		Return {lRet,cMsgRet}
	endif
	
	RestArea(aAreaSC6)                 
	RestArea(aAreaSC5)
	RestArea(aArea)

Return {lRet,cMsgRet,cNota}
