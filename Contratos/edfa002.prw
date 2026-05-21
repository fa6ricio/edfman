/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFA002  ºAutor  ³ Luis Felipe Nascimento º Data ³ 09/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Controle das Importacoes XML x Template     	     º±±
±±º          ³ Tabela "SZD".                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "Protheus.Ch"
#Include "TopConn.Ch"

*---------------------*
User Function EDFA002()
*---------------------*

Private cCadastro  := "Manutenção das Importações XML x Template"
Private aRotina 	 := {}
Private _aCores 	 := {{ 'AllTrim( ZD_STATUS ) == "AT"' , 'BR_VERDE' 	 } ,;
						 { 'AllTrim( ZD_STATUS ) == "BP"' , 'BR_LARANJA' } ,;
						 { 'AllTrim( ZD_STATUS ) == "BX"' , 'BR_VERMELHO'} ,;
						 { 'AllTrim( ZD_STATUS ) == "PL"' , 'BR_BRANCO'  } ,;
						 { 'AllTrim( ZD_STATUS ) == "CR"' , 'BR_AZUL'    } ,;
						 { 'AllTrim( ZD_STATUS ) == "EX"' , 'BR_CINZA'   } ,;
						 { 'AllTrim( ZD_STATUS ) == "QT"' , 'BR_AMARELO' }}

aAdd( aRotina,{ "Pesquisar" 		, "AxPesqui"   , 0, 1 } )
aAdd( aRotina,{ "Visualizar"		, "AxVisual"   , 0, 2 } )
// aAdd( aRotina,{ "Incluir"			, "U_EDFA002I" , 0, 3 } ) // Desabilitado
// aAdd( aRotina,{ "Alterar"			, "U_EDFA002A" , 0, 4 } ) // Substituido por opção em ações relacionadas
aAdd( aRotina,{ "Excluir"			, "U_EDFA002E" , 0, 5 } )
aAdd( aRotina,{ "Legenda"   		, "U_EDFA002L" , 0, 6 } )
aAdd( aRotina,{ "Gera Excel"		, "U_EDFA002X" , 0, 7 } )
aAdd( aRotina,{ "Justificar"		, "U_EDFA002J" , 0, 8 } )

mBrowse( 06, 01, 22, 75, "SZD",,,,,, _aCores)

Return

*----------------------*
User Function EDFA002L()
*----------------------*
Local _aLegenda := { { 'BR_VERDE'    , "(AT) Aguardando Template"} ,;
					 { 'BR_LARANJA'	 , "(BP) Baixa Parcial"      } ,;
					 { 'BR_VERMELHO' , "(BX) Baixa Integral"     } ,;
					 { 'BR_BRANCO' 	 , "(PL) Pedido Dev. Aguardando Liberação"} ,;
					 { 'BR_AZUL'	 , "(CR) Justificado"        } ,;
					 { 'BR_CINZA'	 , "(EX) NF Remessa Cancelada"} ,;
					 { 'BR_AMARELO'	 , "(QT) Qtd. Recebida > NF Remessa"}}
					 
BrwLegenda( "Status das Importações", "Legenda" , _aLegenda )

Return .T.

*--------------------------------------------------*
User Function EDFA002A( __cAlias, __nRecNo, __nOpc )
*--------------------------------------------------*
Local    _nOpcao  := 0
Local    _aArea   := GetArea()

If !(SZD->ZD_STATUS $ "AT")
	Aviso( "Atenção", "Somente notas com status 'Aguardando Template' podem ser alteradas." , { "Ok" } )
	Return
EndIF

_nOpcao := AxAltera( "SZD", __nRecNo, __nOpc )

RecLock("SZD",.f.)

If !Empty(SZD->ZD_MOTIVO)
	SZD->ZD_STATUS := "CR"
Else
	SZD->ZD_STATUS := "AT"
EndIf

MsunLock()

RestArea( _aArea )

Return

*--------------------------------------------------*
User Function EDFA002J( __cAlias, __nRecNo, __nOpc )
*--------------------------------------------------*
Local oDlg
Local _nOpcao  := 0
Local _aArea   := GetArea()
Local cMotivo  := SZD->ZD_MOTIVO
Local lMotivo  := .F.

/*
If !(SZD->ZD_STATUS $ "AT")
	Aviso( "Atenção", "Somente notas com status 'Aguardando Template' podem ser justificadas." , { "Ok" } )
	Return
EndIF
*/

/****************************************************************************************
                              Justificativa do Cancelamento
****************************************************************************************/

DEFINE  MSDIALOG oDlg FROM 0,0 TO 100,350 PIXEL TITLE "Motivo do Cancelamento"
DEFINE  SBUTTON  FROM 030, 115 TYPE 1 ACTION (lMotivo  := .T.,oDlg:End()) ENABLE OF oDlg
DEFINE  SBUTTON  FROM 030, 143 TYPE 2 ACTION (lMotivo  := .F.,oDlg:End()) ENABLE OF oDlg

@ 10,10 MSGET    cMotivo   PICTURE "@!" SIZE 160,08 OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

/*************************************************************************************/

If lMotivo
	
	RecLock("SZD",.F.)
	
	SZD->ZD_MOTIVO := cMotivo
	
	If SZD->ZD_STATUS $ "AT"
	
		If !Empty(SZD->ZD_MOTIVO)
			SZD->ZD_STATUS := "CR"
		EndIf
	
	EndIf
	
	MsunLock()
	
EndIf

RestArea( _aArea )

Return

*--------------------------------------------------*
User Function EDFA002E( __cAlias, __nRecNo, __nOpc )
*--------------------------------------------------*

If SZD->ZD_STATUS <> "AT"
	Aviso( "Atenção", "Somente Notas Fiscais de Remessa que não tenham sido classificadas podem ser excluidas! Favor estornar a classificação da Nota Fiscal e depois retornar a esta rotina." , { "Voltar" } )
Else
	RecLock("F",.f.)
	Delete
	Msunlock()
EndIf

Return

*----------------------*
User Function EDFA002X()
*----------------------*
Local aArea := GetArea()
Local cQry		:= ""
Local cPerg 	:= "EDFR001"
Local cEnt      := CHR(13)+CHR(10)
Local cAlias	:= GetNextAlias()
Local aArray    := {}
Local aTitulo   := {}
Local aCampos   := {}
Local aDetail   := {}
Local aTipoC    := {}
Local cTitulo   := ""
Local cCampos   := ""
Local cDetail   := ""
Local cType     := ""

/*****************************************************
Busca Informações de Titulo e Campos na Tabela SZD
*****************************************************/

aCampos := RetCampos("SZD",.T.)
For nx := 1 to Len(aCampos)	
	cTitulo += GetSX3Cache(aCampos[nx],"X3_TITULO")+"+"
	cCampos += AllTrim(aCampos[nx])+"+"
Next nx

/************************************************************************************************
Substitui Sinal de (+) da Última Posição dos Campos
************************************************************************************************/

cTitulo := IIF( SUBSTR(cTitulo,Len(cTitulo),1) == "+",SUBSTR(cTitulo,1,Len(cTitulo)-1),cTitulo )
cCampos := IIF( SUBSTR(cCampos,Len(cCampos),1) == "+",SUBSTR(cCampos,1,Len(cCampos)-1),cCampos )

/************************************************************************************************
Transforma Campos concatenas em elementos de um Vetor
************************************************************************************************/

aTitulo  := &("{'"+StrTran(cTitulo,'+',"','")+"'}")
aCampos  := &("{'"+StrTran(cCampos,'+',"','")+"'}")

/*********************************************************************************************************
Inclui Vetor no Array para planilha Excel (Linha de Cabeçalhos (Linhas do Vetor, Viram Coluna do Array)
*********************************************************************************************************/

aadd(aArray, aTitulo)

DbCloseArea("SX3")

CriaSx1()

Pergunte(cPerg,.T.)

If LastKey() == 27
	Return
Endif

cQuery := " SELECT * "                                          + cEnt
cQuery += " FROM " + RetSqlName("SZD") + " SZD " 				+ cEnt
cQuery += " WHERE ZD_DTETERM  >= '" + dtos(mv_par01) + "'" 		+ cEnt
cQuery += " AND ZD_DTETERM  <= '" + dtos(mv_par02) + "'"     	+ cEnt

IF !Empty(mv_par03)
	cQuery += " AND ZD_STATUS   = '" + mv_par03 + "'" 			+ cEnt
EndIf

IF !Empty(mv_par04)
	cQuery += " AND ZD_CNPJTER  = '" + mv_par04 + "'" 			+ cEnt
EndIf

IF !Empty(mv_par05)
	cQuery += " AND ZD_SEQTEMP  = '" + mv_par05 + "'" 			+ cEnt
EndIf

IF mv_par06 = "Sim"
	cQuery += " AND ZD_SALDO  > 0" 								+ cEnt
EndIf

IF mv_par07 = "Sim"
	cQuery += " AND ZD_NFDEVOL != 0" 							+ cEnt
EndIf

IF !Empty(mv_par08)
	cQuery += " AND ZD_NFMAE    = '" + mv_par08 + "'" 			+ cEnt
EndIf

/*
Confirmar critérios para filtro

"NF´s a Vender em Dias ?" ,""

IF !Empty(mv_par09)
cQuery += " AND = mv_par09" + cEnt
EndIf
*/

IF !Empty(mv_par10)
	cQuery += " AND ZD_CNPJUSI = '" + mv_par10 + "'" 			+ cEnt
EndIf

IF !Empty(mv_par11)
	cQuery += " AND ZD_CONTRA  = '" + mv_par11 + "'" 			+ cEnt
EndIf

IF !Empty(mv_par12)
	cQuery += " AND ZD_PERIODO  = '" + mv_par12 + "'" 			+ cEnt
EndIf

IF !Empty(mv_par13)
	cQuery += " AND ZD_PEDIDOC  = '" + mv_par13 + "'" 			+ cEnt
EndIf

IF !Empty(mv_par14)
	cQuery += " AND ZD_NUSINA  Like '" + mv_par14 + "'" 		+ cEnt
EndIf

IF !Empty(mv_par15)
	cQuery += " AND ZD_CNPJTEI  = '" + mv_par15 + "'" 			+ cEnt
EndIf

cQuery += " AND D_E_L_E_T_ = ''"                                                    	+ cEnt
cQuery += "ORDER BY ZD_NUSINA, ZD_CONTRA, ZD_PERIODO, ZD_NFMAE, ZD_NFREMES, ZD_PARC"	+ cEnt

Memowrite("c:\TR1.txt",cQuery)

DbUseArea(.t., "TOPCONN", TcGenqry(,,cQuery), "TR1", .f., .t.)

DbSelectArea("TR1")

If Eof() .or. EMPTY(mv_par01) .AND. EMPTY(mv_par02)   //Rafaela Trajano - 26/10/2013
	Aviso( "Atenção", "Não existem dados para a impressão do relatório ! Favor rever os parâmetros." , { "Voltar" } )
	DBCloseArea ("TR1")
	restArea(aArea)
	return
EndIf

/***********************************************************
Linhas da Planilha
***********************************************************/

While !Eof()
	
	/********************************************************
	Prepara Variaveis para processar Linhas da Tabela
	********************************************************/
	
	cDetail := ""
	aDetail := {}
	
	/********************************************************/
	
	For nI := 1 To len(aCampos)
		
		/*****************************************************
		Macro para pegar o conteúdo dos campos da SZD
		*****************************************************/
		


		cType     := Valtype(&( "TR1->"+aCampos[nI] ))
		//TransForm(SM0->M0_CGC,PesqPict("SM0","M0_CGC"))
		//TransForm(ccgcex,PesqPict("SA2","A2_CGC"))
		
		if aCampos[nI] $ "ZD_DTETERM#ZD_DTTEMPL#ZD_DTTERMI#ZD_EMISREM"
		  
		 cType :="D"    
		 
		 // stod( &( "TR1->" + aCampos[nI] ) ) 
		
		endif
		 
		If cType == "D"
			IF EMPTY( &( "TR1->"+aCampos[nI] ) )
				cDetail += "  /  /  " +"+"
			ELSE
				cDetail += DTOC(stod( &( "TR1->"+aCampos[nI] ) ) ) +"+"
		    ENDIF
               

		ElseIf cType == "N"  
		    nConteudo := &( "TR1->" + aCampos[nI])
			cDetail += TRANSFORM( nConteudo,"@E 999,999,999,999.999") + "+"
			  
				Else
			cDetail += ( &( "TR1->"+aCampos[nI] ) ) +"+"
		EndIf
		
	Next
	
	cDetail := IIF( SUBSTR(cDetail,Len(cDetail),1) == "+",SUBSTR(cDetail,1,Len(cDetail)-1),cDetail )
	aDetail := &("{'"+StrTran(cDetail,'+',"','")+"'}")
	
	/***********************************************************************************************
	Formata Campos do Excel
	***********************************************************************************************/
	/*
	For nI := 1 To Len(aTipoC)
	
	If aTipoC == "D"
	Transform(aDetail[nI], "@D" )
	EndIf
	
	Next
	
	*/
	if !Empty( aDetail[01] )
		aDetail[01] := "'"+adetail[01]
	EndIf
	
	If !Empty( aDetail[02] )
		aDetail[02] := "'"+adetail[02]
	EndIf
	
	If !Empty( aDetail[03] )
		aDetail[03] := "'"+adetail[03]
	EndIf
	
	If !Empty( aDetail[04] )
		aDetail[04] := "'"+adetail[04]
	EndIf
	
	If !Empty( aDetail[06] )
		aDetail[06] := "'"+adetail[06]
	EndIf
	
	If !Empty( aDetail[26] )
		aDetail[26] := "'"+adetail[26]
	EndIf
	
	If !Empty( aDetail[28] )
		aDetail[28] := "'"+adetail[28]
	EndIf
	
	
	/***********************************************************************************************/
	
	Aadd(aArray, aDetail)
	
	DbSelectArea("TR1")
	DbSkip()
	
EndDo

/**********************************************************/

DbCloseArea("TR1")

DlgToExcel({ {"ARRAY", "", "", aArray} })

restArea(aArea)
Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                           4                           5                           6          7     8    9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38      39   40  41  42  43
AADD(aSx1,{"EDFR001" , "01" , "Data De               ?" , "Data De               ?" , "Data De               ?" , "mv_ch1" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "02" , "Data Ate              ?" , "Data Ate              ?" , "Data Ate              ?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "03" , "Status                ?" , "Status                ?" , "Status                ?" , "mv_ch3" , "C" , 02 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "04" , "CNPJ Terminal         ?" , "CNPJ Terminal         ?" , "CNPJ Terminal         ?" , "mv_ch4" , "C" , 14 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZE" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "05" , "Template              ?" , "Template              ?" , "Template              ?" , "mv_ch5" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "06" , "NF´s com Saldo        ?" , "NF´s com Saldo        ?" , "NF´s com Saldo        ?" , "mv_ch6" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par06" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "07" , "NF´s Devolvidas       ?" , "NF´s Devolvidas       ?" , "NF´s Devolvidas       ?" , "mv_ch7" , "C" , 01 , 0 , 0 , "G" , "" , "mv_par07" , "Sim" , "Sim" , "Sim" , "" , "" , "Nao" , "Nao" , "Nao" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "08" , "NF Mãe                ?" , "NF Mãe                ?" , "NF Mãe                ?" , "mv_ch8" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par08" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "09" , "NF´s a Vencer em Dias ?" , "NF´s a Vencer em Dias ?" , "NF´s a Vencer em Dias ?" , "mv_ch9" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par09" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "10" , "CNPJ Usina            ?" , "CNPJ Usina            ?" , "CNPJ Usina            ?" , "mv_cha" , "C" , 14 , 0 , 0 , "G" , "" , "mv_par10" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SA2" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "11" , "Contrato              ?" , "Contrato              ?" , "Contrato              ?" , "mv_chb" , "C" , 25 , 0 , 0 , "G" , "" , "mv_par11" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZ3" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "12" , "DP                    ?" , "DP                    ?" , "DP                    ?" , "mv_chc" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par12" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SC7" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "13" , "Pedido de Compras     ?" , "Pedido de Compras     ?" , "Pedido de Compras     ?" , "mv_chc" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par13" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SC7" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "14" , "Parte Nome Usina      ?" , "Parte Nome Usina      ?" , "Parte Nome Usina      ?" , "mv_chd" , "C" , 14 , 0 , 0 , "G" , "" , "mv_par14" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "15" , "CNPJ Terminal Interior?" , "CNPJ Terminal Interior?" , "CNPJ Terminal Interior?" , "mv_che" , "C" , 14 , 0 , 0 , "G" , "" , "mv_par15" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZE" , "" , "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR001   15")
	
	DbSeek("EDFR001")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR001"
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



Static Function RetCampos(cArq, lVirtual)		
Local aCampos := {}
Local aCmpRet := {}
Local cUsado := ""
Local nx := 1

DEFAULT lVirtual := .F.

aCampos := FWSX3Util():GetAllFields(cArq,lVirtual)
	
For nx := 1 to Len (aCampos)
	IF !("USERLG" $ aCampos[nx]) 
		cUsado   := X3OBRIGAT(aCampos[nx])
		// Verifica se o campo é usado
		If !Empty(cUsado)
			AADD(aCmpRet,{aCampos[nx],FWSX3Util():GetDescription( aCampos[nx] )})
		EndIf
	Endif
Next nx
Return aCmpRet	
