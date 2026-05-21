#Include "Protheus.ch"
#Include "Xmlxfun.ch"
#Include "Topconn.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO5     ºMARCOS  ³Microsiga          º Data ³  09/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  RIEX GERA XML                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RiexGerXml()

Local cError   	:= ""
Local cWarning 	:= ""
Local lXML

Private oXML	:= NIL

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Gera o arquivo e o objeto XML³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oXML := XmlParser( UnMGerXML(), "_", @cError, @cWarning )

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Processamento³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( { || UnM30Proc( ,cError ) }, "Exportando dados..." )

Return( oXML )



Static Function UnMGerXML()

Local cXML		:= ''
Local cCursoPad	:= ''
Local cPerLet	:= ''

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Abre as tabelas³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SC7" )
dbSelectArea( "SC5" )
dbSelectArea( "SC6" )

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Query que trara os dados a serem exportados³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*==> ESTA SOMA CAMPO C7_QUANT * 20 (SACARIA/TON). ORIGEM TABELA TASC7010 ONDE SC7010.C7_CONTRAT = BWS-033(CONTRATO DE COMPRA) - TABELA SC7010*/
cQuery := "SELECT SUM(C7_QUANT)*20  "
cQuery += " FROM "+RetSqlName("SC7")+" AS C7"
cQuery += " WHERE C7_CONTRAT = 'BWS10-033'" 
cQuery += " AND C7.D_E_L_E_T_ = ' '  "
/*==> ESTA QUERY SOMA A QUANT. ITENS VENDAS NA TABELA PEDIDO VENDA COM TABELA PEDIDO NA FILIAL C6=C5 E NUMERO PEDIDO C6=C5 E NÃO MARCADO COMO DELETADO, ONDE O CONTRATO É IGUAL A WS10 E NÃO MARCADO COMO DELETADO E CFOP = 7501*/
/*cQuery := " SELECT SUM(C6_QTDVEN) "
cQuery += " FROM "+RetSqlName("SC5") + "CS5"
cQuery += "	AS C5 "NNER JOIN"+ RetSqlName("SC6") + "C6"
cQuery += " ON C6_FILIAL = C5_FILIAL "
cQuery += " AND C6_NUM = C5_NUM "
cQuery += " AND C6.D_E_L_E_T_ = ' '  "
cQuery += " WHERE C5_CON RAT = 'WS10-033'  "
cQuery += " AND C5.D_E_L_E_T_ = ' '  "
cQuery += "	AND C6_CF = '7501' "*/ 
cQuery := ChangeQuery( cQuery )

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Garante que a area QYCURD nao esta em uso³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select( "QYCURD" ) > 0
	QYCURD->( dbCloseArea() )
EndIf

dbUseArea( .T., "TOPCONN", TCGenQry( ,,cQuery ), "QYCURD", .F., .F. )
QYCURD->( dbGoTop() )

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Criando as TAG's - XML³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cXML += '<?xml version="1.0" encoding="ISO-8859-1"?>'
cXML += '<RegistroExportacao>'

	While QYCURD->( !Eof() )
		cCursoPad := QYCURD->CURSO
		cXML += '<CTeste1>'
		cXML += '<CTeste2></CTeste2>'
		cXML += '<CTeste3></CTeste3>'
			While QYCURD->CURSO == cCursoPad
				cPerLet := QYCURD->PERLET
				cXML += '<Cteste4>'
					cXML += '<Cteste5></Cteste5>'

					While QYCURD->PERLET == cPerLet .And. QYCURD->CURSO == cCursoPad
						cXML += '<Cteste6>'
							cXML += '<CTeste7></CTeste7>'
							cXML += '<CTeste>8</CTeste8>'

							QYCURD->( dbSkip() )

						cXML += '</CTeste6>'
					Enddo

				cXML += '</CTeste4>'

			Enddo
		cXML += '</CTeste2>'

	Enddo
cXML += '</RegistroExportacao>'

QYCURD->( dbGoTop() )

Return( cXML )



//*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³ Faz o processamento de geracao do arquivo XML ja criando    º±±
//±±º          ³ o diretorio onde sera feita a gravacao.                     º±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Sintaxe   ³ UnM30Proc( cAlias, cError )                                 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³                                                             ³±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UnM30Proc( cAlias, cError )

Local oLbx, oPesq
Local aArea    	:= GetArea()
Local aAreaSX2 	:= SX2->(GetArea())
Local cPesq    	:= Space(20)
Local nPosLbx  	:= 0
Local nPosArq  	:= 0
Local cRet     	:= Iif( cAlias == NIL, "", cAlias)
Local lOk      	:= .F.
Local cFiltSX2 	:= ''
Local bFiltSX2 	:= NIL
Local nL		:= 0
Local nM		:= 0
Local nN		:= 0
Local aTabelas 	:= {}
Local nMakeDir
Local cCursoPad	:= ""
Local cPerLet	:= ""
Local cCoddis	:= ""
Local oBtnOk, oBtnCancel

Private oDlg

QYCURD->( dbGoTop() )


//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Caso seja o fim do arquivo, nao monta o LISTBOX e avisa que nao ha dados a serem exportados³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If QYCURD->( !Eof() )
	While QYCURD->( !Eof() )
		aAdd( aTabelas, { QYCURD->CURSO, QYCURD->PERLET, QYCURD->CODDIS, QYCURD->DESCDI } )
	
		QYCURD->( dbSkip() )
	Enddo
	
	nPosArq := IIf( !Empty( cRet ), aScan( aTabelas, { |z| AllTrim( cRet ) $ z[1] .Or. AllTrim( cRet ) $ z[2] } ), 1 )
	nPosLbx := nPosArq
	
	//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//*³Criacao da Dialog de Selecao do Arquivo a Exportar³
	//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Define MSDialog oDlg From  104, 179 To 449, 775 Title "Dados que serão exportados" Pixel
	
	@  5,   7 ListBox oLbx Fields Header "Curso Padrao" , "Periodo Letivo", "Disciplina", "Descricao discip.",;
										 Size 285, 137 Of oDlg Pixel On DblClick ( nPosLbx := oLbx:nAt, lOk := .T., oDlg:End() )
	oLbx:cToolTip := "Cursos e Disciplinas que serao exportados"
	oLbx:nAt      := nPosArq
	oLbx:SetArray( aTabelas )
	oLbx:bLine 	  := { || { aTabelas[oLbx:nAt, 1], aTabelas[oLbx:nAt, 2], aTabelas[oLbx:nAt, 3], aTabelas[oLbx:nAt, 4] } }
	
	@ 152,   7  Say "Pesquisar " Size 25, 7 Of oDlg Pixel
	@ 150,  42 MSGet oPesq  Var cPesq  Size 100, 10 Message "Pesquise pela proximidade do codigo do curso padrao ou pelo periodo letivo" ;
	Of oDlg Pixel Picture "@!" Valid ( nPosArq := Iif( !Empty( cPesq ), aScan( aTabelas, { |z| AllTrim( cPesq ) $ z[1] .Or.;
					   AllTrim( cPesq ) $ z[2]}), oLbx:nAt ), Iif( nPosArq <> 0, oLbx:nAt := nPosArq, Aviso( "Verifique a pesquisa",;
					   "Dado nao encontrado", { "Ok" } ) ), oLbx:Refresh(), Iif( nPosArq <> 0, nPosLbx := nPosArq, ), ( nPosArq <> 0 ) )
	
	Define SButton From 150, 222 Type 1 Enable Of oDlg Action ( lOk  := .T., Iif( UnM30Uso(), ( nPosLbx := oLbx:nAt, oDlg:End() ), ) )
	Define SButton From 150, 262 Type 2 Enable Of oDlg Action ( lOk  := .F., oDlg:End() )
	
	Activate MSDialog oDlg Centered 

	If lOk
	
		*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		*³Caso nao houve nenhum erro na criacao do objeto³
		*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty( cError )
			nXmlStatus := XMLError()
	
			If ( nXmlStatus == XERROR_SUCCESS )

				*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				*³Atribui os dados do arquivo QYCURD ao objeto oXML³
				*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				QYCURD->( dbGoTop() )
				While QYCURD->( !Eof() )
					nL ++
					nM := 0
					cCursoPad := QYCURD->CURSO
					oXML:_ProcessoEducacional:_CursoPadrao[nL]:_CodigoCurso:TEXT :=	UNM30Clear( QYCURD->CURSO )
					oXML:_ProcessoEducacional:_CursoPadrao[nL]:_NomeCurso:TEXT := UNM30Clear( QYCURD->DESCR )

					While QYCURD->CURSO == cCursoPad
						nM ++
						nN := 0
						cPerLet := QYCURD->PERLET
						oXML:_ProcessoEducacional:_CursoPadrao[nL]:_PeriodoLetivo[nM]:_PerLet:TEXT := UNM30Clear( QYCURD->PERLET )

						While QYCURD->PERLET == cPerLet .And. QYCURD->CURSO == cCursoPad
							nN ++
							If !Empty( oXML:_ProcessoEducacional:_CursoPadrao[nL]:_PeriodoLetivo[nM]:_Disciplina )
								oXML:_ProcessoEducacional:_CursoPadrao[nL]:_PeriodoLetivo[nM]:_Disciplina[nN]:_CodigoDisciplina:TEXT := ;
								UNM30Clear( QYCURD->CODDIS )
								oXML:_ProcessoEducacional:_CursoPadrao[nL]:_PeriodoLetivo[nM]:_Disciplina[nN]:_DescricaoDisciplina:TEXT := ;
								UNM30Clear( QYCURD->DESCDI )
							Else
								oXML:_ProcessoEducacional:_CursoPadrao[nL]:_PeriodoLetivo[nM]:_Disciplina:_CodigoDisciplina:TEXT := ;
								UNM30Clear( QYCURD->CODDIS )
								oXML:_ProcessoEducacional:_CursoPadrao[nL]:_PeriodoLetivo[nM]:_Disciplina:_DescricaoDisciplina:TEXT := ;
								UNM30Clear( QYCURD->DESCDI )
							EndIf

							QYCURD->( dbSkip() )
						Enddo
					Enddo
				Enddo               

				*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				*³Gera a string XML correspondente ao Objeto³
				*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   	SAVE oXML XMLSTRING cXML

				*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				*³Cria o diretorio caso nao exista³
				*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nMakeDir := MAKEDIR( "C:\XML" )
				If nMakeDir == 0
					ConOut( "O Diretório 'C:\XML' foi criado" )
					Aviso( "Importante", "O Diretório 'C:\XML' foi criado", { "Ok" } )
				EndIf

			   	ConOut( "SALVANDO ARQUIVO DIRETORIO \XML\EXP1.XML...." )
				SAVE oXML XMLFILE "C:\XML\EXP1.XML" NEWLINE

			Else
			   ConUut( "Erro (" + str( nXmlStatus, 3 ) + ") na criação do XML." )
			   MsgInfo( "Erro (" + str( nXmlStatus, 3 ) + ") na criação do XML." )
			EndIf   		

			ConOut( "Exportacao Finalizada..." )
			Aviso( "Exportação finalizada", "O arquivo esta gravado no diretório 'C:\XML\EXP1.XML'", { "Ok" } )
	    Else 
			ConOut( "Não foi possivel criar o objeto 'oXML'" )
			Aviso( "ERRO", "Não foi possivel criar o objeto 'oXML'", { "Ok" } )
	    EndIf
	Else
		ConOut( "Operacao cancelada pelo operador" )
		Aviso( "Cancelado", "Operacao cancelada pelo operador", { "Ok" } )
	EndIf
Else
	ConOut( "Não há dados a serem exportados" )
	Aviso( "Vazio", "Não há dados a serem exportados", { "Ok" } )
EndIf

RestArea( aAreaSX2 )
RestArea( aArea )

Return( oXML )


//*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Valida a confirmacao dos dados a serem exportados          º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UnM30Uso( )

Local lUsado 	:= .T.

Return  lUsado


//*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ Faz a limpeza dos dados a serem exportados.                º±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ cCpoLmp = Campo a ser verificado                           ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³ cCpoLmp = Campo limpo                                      ³±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function UNM30Clear( cCpoLmp )

Local cAcentos  := "çÇ€‡áéíóúÁÉÍÓÚâêîôûÂÊÎÔÛàéíóúÁÉÍÓÚäëïöüÄËÏÖÜãõÃÕÀÅ…† „¦åÈˆ‚èÌ¡ÒÖ“”•¢§ğÙ£ùÑñ%$ş÷İ°ºª¬"
Local cAcSubst  := "cCCcaeiouAEIOUaeiouAEIOUaeiouAEIOUaeiouAEIOUaoAOAAAAaaaaaaEEeeeIiiOOooooooUuuuNnPScoiooaq"
Local cCaraPont := "/\.,;:!@#$%&*()-+='[]{}~<>|?¨`"
Local nI        := 0
Local nPos      := 0

cCpoLmp 		:= AllTrim( cCpoLmp )
cCpoLmp 		:= NoAcento( OemToAnsi( cCpoLmp ) )

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Troca Acentos³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 To Len( cCpoLmp )
	If ( nPos := At( SubStr( cCpoLmp, nI, 1 ), cAcentos ) ) > 0
		cCpoLmp := SubStr( cCpoLmp, 1, nI - 1 ) + SubStr( cAcSubst, nPos, 1 ) +  SubStr( cCpoLmp, nI + 1 )
	EndIf
Next nI

//*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//*³Tira Caracteres de pontuacao³
//*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 To Len( cCpoLmp )
	If ( nPos := At( SubStr( cCpoLmp, nI, 1 ), cCaraPont ) ) > 0
		cCpoLmp := SubStr( cCpoLmp, 1, nI - 1 ) + '#' + SubStr( cCpoLmp, nI + 1 )
	EndIf
Next nI

cCpoLmp := StrTran( cCpoLmp, '"', "" )
cCpoLmp := StrTran( cCpoLmp, "#", "" )

cCpoLmp := StrTran( cCpoLmp, " " , "_" )
cCpoLmp := StrTran( cCpoLmp, "-" , "_" )
cCpoLmp := StrTran( cCpoLmp, "__", "_" )

Return( cCpoLmp )
