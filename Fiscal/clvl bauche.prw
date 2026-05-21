#Include "Rwmake.Ch"
#include "topconn.ch"//If(Upper(FunName())="COMPLEME",U_ClVlExp(M->CDL_DOCORI),.t.)  
#Include "protheus.ch"                                                                                                       

//#DEFINE VALMERC	1 // Valor total do mercadoria liquido
//#DEFINE VALDESC	2 // Valor total do desconto
//#DEFINE FRETE   	3 // Valor total do Frete
//#DEFINE VALDESP 	4 // Valor total da despesa
//#DEFINE TOTF1		5 // Total de Despesas Folder 1
//#DEFINE TOTPED     6 // Total do Pedido
//#DEFINE SEGURO  	7 // Valor total do seguro
//#DEFINE TOTF3		8 // Total utilizado no Folder 3
//#DEFINE VALMERCB	9 // Valor total do mercadoria bruto
//#DEFINE NTRIB 		10// Valor das despesas nao tributadas - Portugal
//#DEFINE TARA		11// Valor da Tara - Portugal


User Function COMPLEME()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo os campos do arquivo que sempre deverao³
//³ aparecer no browse. (funcao mBrouse)                         ³
//³ ----------- Elementos contidos por dimensao ---------------- ³
//³ 1. Titulo do campo (Este nao pode ter mais de 12 caracteres) ³
//³ 2. Nome do campo a ser editado                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

LOCAL aFixe:={	{ "Numero da NF","D2_DOC    " },; //"Numero da NF"
	{ "Serie da NF ","D2_SERIE  " },; //"Serie da NF "
	{ "Cliente     ","D2_CLIENTE" } } //"Cliente     "
                                                             
Local aCores    := {	{'D2_TIPO=="N"'		,'DISABLE'   	},;	// NF Normal
						{'D2_TIPO=="P"'		,'BR_AZUL'   	},;	// NF de Compl. IPI
						{'D2_TIPO=="I"'		,'BR_MARROM' 	},;	// NF de Compl. ICMS
						{'D2_TIPO=="C"'		,'BR_PINK'   	},;	// NF de Compl. Preco/Frete
						{'D2_TIPO=="B"'		,'BR_CINZA'  	},;	// NF de Beneficiamento
						{'D2_TIPO=="D"'		,'BR_AMARELO'	} }	// NF de Devolucao


Private aRotina := {{ "Pesquisar"	,"AxPesqui"	, 0 , 1 , 0 ,.F.},;	//"Pesquisar"
                    { "Visualizar" 	,"a920NFSAI", 0 , 2 , 0 ,NIL},;	//"Visualizar"
                    { "Complementos" ,"U_Complea", 0 , 4 , 0 , NIL},; //"Complementos"
                    { "Legenda"   ,"ANFMLegenda", 0 , 2, 0, .F.}} // Legenda


PRIVATE cCadastro	:= "Notas Fiscais de Saída"
	mBrowse( 6, 1,22,75,"SD2",aFixe,"D2_TES",,,,aCores)

Return


*************************************************************************************
User function Complea()
*************************************************************************************

   compleb(SD2->D2_DOC,SD2->D2_SERIE,SF2->F2_ESPECIE,SD2->D2_CLIENTE,SD2->D2_LOJA,"S",SD2->D2_TIPO)
Return
*************************************************************************************
Static Function Compleb(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF)
*************************************************************************************
Local aObrigat :={}
Local aMantem		:= {{},{},{},{},{},{}}
Local aSugerido		:= {}
Local oDlgms
aBUTTONS:={}
AADD(aBUTTONS,{'S4WB005N',{|| U_ClVlExp(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF) }, "Complemento"		} )
Private		aHExp	:= {}
Private		aCExp	:= {}
Private oGetExp
Private lRet:=.f.
Processa({|| MCols(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,@aObrigat,@aMantem)})
DEFINE MSDIALOG oDlgms FROM C(178),C(181) TO C(400),C(700) TITLE "Complementos por documento fiscal" OF oMainWnd PIXEL //
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Monta a Getdados ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
				oGetExp := MsNewGetDados():New(15,10,c(100),c(260),GD_INSERT+GD_UPDATE+GD_DELETE,/*LinhaOk*/,/*GetDadosOk*/,/*cIniPos*/,/*aAlter*/,/*.F.*/,990,/*cAmpoOk*/,/*cSuperApagar*/,/*cApagaOk*/,,aHExp,aCExp)
				oGetExp:bLinhaOk 	:= &("{|| U_MExp(oGetExp,aObrigat,.F.) }")

	ACTIVATE MSDIALOG oDlgms ON INIT ;
	EnchoiceBar(oDlgms,{|| lValid :=U_MExp(oGetExp,aObrigat,.T.),;
	Iif(lValid,Processa({||lRet := U_MFim(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,aMantem,aSugerido,aObrigat)}),.F.),;
	if(lRet,oDlgms:End(),.T.)},;
	{|| oDlgms:End()},,aBUTTONS)
				

************************************************************************
User Function MFim(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,aMantem,aSugerido,aObrigat)
************************************************************************
Begin Transaction
		aHeader	:= aHExp
		aCols 	:= oGetExp:aCols
	    lRet 		:= .T.
		nPos	:= aScan(aHeader,{|x| Alltrim(x[2])=="CDL_NUMDE"})
		CDL->(DbsetOrder(1))
        CDL->(DbSeek(xFilial("CDL")+cDoc+cSerie+cClieFor+cLoja))
		While !Eof()
		   If RecLock("CDL",.f.)
		      Delete
		      MsUnlock()
		   Endif
           CDL->(DbSeek(xFilial("CDL")+cDoc+cSerie+cClieFor+cLoja))
		End
		If !(Len(aCols)=1 .and.Empty(aCols[1][GDFIELDPOS("CDL_FORNEC",aHeader)]) )
		For nY := 1 to Len(aCols)
			   CDL->(DbSetOrder(1))
		       lAtualiza 	:= .T.
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se o item nao esta excluido no aCols³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
			   If !aCols[nY][Len(aHeader)+1]
							
								RecLock("CDL",.T.)
								CDL->CDL_FILIAL	:= xFilial("CDL")
								CDL->CDL_DOC	:= cDoc
								CDL->CDL_SERIE	:= cSerie
								CDL->CDL_ESPEC	:= cEspecie
								CDL->CDL_CLIENT	:= cClieFor
								CDL->CDL_LOJA	:= cLoja
								CDL->CDL_ESPEXP :='SPED'
							
							For nZ := 1 To Len(aHeader)
								CDL->(FieldPut(FieldPos(aHeader[nZ][2]),aCols[nY][nZ]))
							Next nY
								
							MsUnLock()
							FkCommit()

			   Endif

		Next
		Endif		
End Transaction
Return	lRet	
*************************************************
Static Function MCols(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF,aObrigat,aMantem)
*************************************************
Local aCampos := {} 
Local aHeader	:= {}
Local aCols		:= {}     
Local aPermite	:= {}
Local aCabPer	:= {}

Local cTabela	:= "" 
Local cCampo	:= ""
Local cAlias	:= ""
Local cArqInd	:= ""
Local cChave	:= ""

Local lQuery	:= .F.
Local lPossui	:= .F.

Local nX 		:= 0
Local nY 		:= 0
Local nI		:= 0
Local nScan		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Da posicao 1 a 9, consideram-se os complementos e da 10 a 14, as informacoes complementares³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



	IncProc("Apresentando informações: " ) //

	aCampos		:= {} 
	aCols		:= {}
	aHeader		:= {}          
	aPermite 	:= {}   
	aCabPer		:= {}
	
			// exportacao
			aCampos := {"CDL_INDDOC","CDL_NUMDE","CDL_DTDE","CDL_NATEXP","CDL_NRREG","CDL_DTREG","CDL_CHCEMB","CDL_DTCHC","CDL_DTAVB","CDL_TPCHC","CDL_PAIS","CDL_NRMEMO","CDL_FORNECE","CDL_LOJFOR"}
			cTabela := "CDL"

	
	If Len(aCampos) > 0 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montando aHeader                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		bCampos := RetCampos("CDL",.T.)
		For nx := 1 to Len(bCampos)
			If !ALLTRIM(bCampos[nx]) $ 'CDL_FILIAL/CDL_DOC/CDL_SERIE/CDL_ESPEC/CDL_CLIENT/CDL_LOJA/CDL_ESPEXP' .or.;
				aScan(aCampos,{|x| Alltrim(x)==ALLTRIM(bCampos[nx])}) > 0
					If X3USO(GetSX3Cache(bCampos[nx],"X3_USADO"))                                                   
				
						cF3 	:= GetSX3Cache(bCampos[nx],"X3_F3")
						cValid	:= GetSX3Cache(bCampos[nx],"X3_VALID")

						aAdd(aHeader,{Alltrim(GetSX3Cache(bCampos[nx],"X3_TITULO")),;
							bCampos[nx],;
							GetSX3Cache(bCampos[nx],"X3_PICTURE"),;
							GetSX3Cache(bCampos[nx],"X3_TAMANHO"),;
							GetSX3Cache(bCampos[nx],"X3_DECIMAL"),;
							cValid,;
							GetSX3Cache(bCampos[nx],"X3_USADO"),;
							GetSX3Cache(bCampos[nx],"X3_TIPO"),;
							cF3,;
							GetSX3Cache(bCampos[nx],"X3_CONTEXT")})
					Endif                                         
					If X3Obrigat(aCampos[nx]) 
						aAdd(aObrigat,{aCampos[nx],GetSX3Cache(bCampos[nx],"X3_TIPO")})
					Endif
			Endif
		Next nx
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta os filtros para cada uma das tabelas para carregar o aCols ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lPossui := MFiltro(cTabela,cDoc,cSerie,cEspecie,cClieFor,cLoja,@cAlias) 

		If !lPossui
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Para os complementos por item, carrega com o conteudo dos itens do SFT³
			//³que permitem o complemento.                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Len(aPermite) > 0
				For nI := 1 to Len(aPermite)
					aAdd(aCols,Array(Len(aHeader)+1))
					For nY := 1 To Len(aHeader)
						aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
						aCols[Len(aCols)][Len(aHeader)+1] := .F.
						nScan := aScan(aCabPer,{|x| x == Alltrim(aHeader[nY][2])})
						If nScan > 0
							aCols[Len(aCols)][nY] := aPermite[nI][nScan]
						Endif
					Next nY 
				Next
			Else 
				aAdd(aCols,Array(Len(aHeader)+1))
				For nY := 1 To Len(aHeader)
					aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
					aCols[Len(aCols)][Len(aHeader)+1] := .F.
				Next nY
			Endif
		Else
			dbSelectArea(cAlias)
			While !Eof() 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Os complementos de agua somente possuem complemento por NF³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				aAdd(aMantem[1],{CDL_DOC,CDL_SERIE,CDL_CLIENT,CDL_LOJA,CDL_NUMDE,.F.})
				Aadd(aCols,Array(Len(aHeader)+1))
				
				For nY :=1 to Len(aHeader)
					aCols[Len(aCols)][nY] := (cAlias)->(FieldGet(FieldPos(aHeader[nY,2])))
				Next nY
				
				aCols[Len(aCols)][Len(aHeader)+1] := .F.
		        
				dbSkip()
		
			EndDo
		Endif                                                   
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Fecha as areas montadas para o filtro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	    RetIndex(cTabela)	
	    dbClearFilter()	
		// exportacao
		aHExp	:=	aHeader
		aCExp	:=	aCols
	      
	Endif 

Return .T.

**********************************************************************
Static Function MFiltro(cTabela,cDoc,cSerie,cEspecie,cClieFor,cLoja,cAlias) 
**********************************************************************
Local aArea		:= GetArea()
Local cWhere	:= ""
Local cCondicao := ""
Local cCampo	:= ""
Local lPossui	:= .F.
Local cFrom		:= ""
Local cOrder	:= ""


cAlias := cTabela
dbSelectArea(cTabela)
               
If Left(cTabela,2) $ "CD"
	cCampo	:= SubStr(cTabela,1,3)
Else                            
	cCampo	:= SubStr(cTabela,2,3)
Endif 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a chave e a condicao padrao para todos os filtros³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cFrom		:= "%" + RetSqlName(cTabela) + " " + cTabela + "%"
	cOrder		:= "%" + SqlOrder((cTabela)->(IndexKey())) + "%"			
	cWhere		:= "%" + cTabela + "." + cCampo + "_FILIAL" + " = '" + xFilial(cTabela) + "' AND "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta as expressoes de acordo com cada tabela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cWhere		+= "CDL.CDL_DOC = '" + cDoc + "' AND "
		cWhere		+= "CDL.CDL_SERIE = '" + cSerie + "' AND "
		cWhere		+= "CDL.CDL_CLIENT = '" + cClieFor + "' AND "
		cWhere		+= "CDL.CDL_LOJA = '" + cLoja  + "' AND "

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta a expressao para codebase³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCondicao 	+= 'CDL_DOC == "' + cDoc + '" .AND. '
		cCondicao 	+= 'CDL_SERIE == "' + cSerie + '" .AND. '
		cCondicao 	+= 'CDL_CLIENT == "' + cClieFor + '" .AND. '
		cCondicao 	+= 'CDL_LOJA == "' + cLoja + '"'



If !Empty(cWhere) .Or. !Empty(cCondicao) 
 
	
			lQuery 	:= .T.
			cAlias	:= GetNextAlias()         
			
			cWhere	+= cTabela + ".D_E_L_E_T_= ' ' %"

			BeginSql Alias cAlias
			
				SELECT *
				FROM %Exp:cFrom%
				WHERE %Exp:cWhere%
				ORDER BY %Exp:cOrder%
			EndSql
		
			dbSelectArea(cAlias)   

   aCampos := RetCampos("CDL",.F.)
   For nx := 1 to Len (aCampos)
   		IF GetSX3Cache(aCampos[nx],"X3_TIPO") <> "C"
    		TcSetField(cAlias,aCampos[nx],GetSX3Cache(aCampos[nx],"X3_TIPO"),GetSX3Cache(aCampos[nx],"X3_TAMANHO"),GetSX3Cache(aCampos[nx],"X3_DECIMAL"))
    	Endif
   Next nx					
Endif                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se possui o complemento ou será incluido.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do While !(cAlias)->(Eof())
	lPossui := .T.
	Exit
Enddo

(cAlias)->(dbGotop())

RestArea(aArea)

Return lPossui
		
		
***************************************************
User Function MExp(oGetExp,aObrigat,lFinal)
***************************************************
Local aCols		:= oGetExp:aCols
Local aPos		:= {}
Local aDocExp	:= {}

Local lRet		:= .T.
Local lRepete	:= .F.
Local lPis		:= .F.
Local lCofins	:= .F.
Local lObrigat	:= .F.

Local nX		:= 0
Local nI		:= 0
Local nAt		:= oGetExp:nAt
Local _npNUMDE:=aScan(aHExp,{|x| Alltrim(x[2])=="CDL_NUMDE"})
Local _npDOCOR:=aScan(aHExp,{|x| Alltrim(x[2])=="CDL_DOCORI"})
Local _npSEROR:=aScan(aHExp,{|x| Alltrim(x[2])=="CDL_SERORI"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se algum campo obrigatorio nao foi digitado³
//³(apenas da linha que esta sendo manipulada - aT)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lFinal .And. !(aCols[nAt][Len(aHExp)+1])
	If MObrig(aObrigat,aHExp,aCols[nAt])
		lObrigat := .T.
	Endif
Endif

For nX := 1 to Len(aCols)

	If !(aCols[nX][Len(aHExp)+1])
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se algum campo obrigatorio nao foi digitado em todos os itens³
		//³(somente quando for validacao do ok da rotina)                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFinal
			lObrigat := MObrig(aObrigat,aHExp,aCols[nX])
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o numero do documento de Exportacao nao foi informado em outra linha³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aScan(aDocExp,{|x| x == aCols[nX][_npNUMDE]+aCols[nX][_npDOCOR]+aCols[nX][_npSEROR]}) > 0
			lRepete := .T.	
		Endif
		aAdd(aDocExp,aCols[nX][_npNUMDE]+aCols[nX][_npDOCOR]+aCols[nX][_npSEROR])

		
	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informa que o numero do documento ja foi informado em outro item.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRepete
	Help("  ",1,"A926Exp")
	lRet := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Informa se existe algum campo obrigatorio que nao foi preenchido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lObrigat                                                       
	Help("  ",1,"A926ExpObr")
	lRet := .F.
Endif

Return lRet
**********************************************************		
Static Function MObrig(aObrigat,aHeader,aCols)  
**********************************************************		
Local lRet	:= .F.

Local nX	:= 0
Local nPos	:= 0                   

Local xConteudo	

For nX := 1 to Len(aObrigat)       
	
	nPos := aScan(aHeader,{|x| x[2] == aObrigat[nX][1]})
	If nPos > 0
		xConteudo	:= aCols[nPos]
		
		If aObrigat[nX][2] == "C"
			If Empty(xConteudo)
				lRet := .T.
			Endif
		ElseIf aObrigat[nX][2] == "N"
			If xConteudo == 0
				lRet := .T.
			Endif
		Endif
	Endif
		
Next

Return lRet 



**********************************************************************
User Function ClVlExp(cDoc,cSerie,cEspecie,cClieFor,cLoja,cEntSai,cTpNF)
**********************************************************************
Local cVar
Local aArea:=GetArea()
Local oDlg,oGet1,oSBtn2,oSBtn3,_nSai:=0
Local _aCampos

PosDTREG := GDFIELDPOS("CDL_DTREG",aHExp)
PosDTCHC := GDFIELDPOS("CDL_DTCHC",aHExp)
PosDTAVB := GDFIELDPOS("CDL_DTAVB",aHExp)
PosPAIS  := GDFIELDPOS("CDL_PAIS",aHExp)
PosNumDec:= GDFIELDPOS("CDL_NUMDE",aHExp)

PosUFEMB := GDFIELDPOS("CDL_UFEMB",aHExp)
PosLOCEMB:= GDFIELDPOS("CDL_LOCEMB",aHExp) 
_nPosAcols:= oGetExp:NAT

aCExp:=oGetExp:acols
_cCDL_DTREG := aCExp[_nPosAcols,PosDTREG]
_cCDL_DTCHC := aCExp[_nPosAcols,PosDTCHC]
_cCDL_DTAVB := aCExp[_nPosAcols,PosDTAVB]
_cCDL_PAIS  := aCExp[_nPosAcols,PosPAIS]

_cCDL_UFEMB := aCExp[_nPosAcols,PosUFEMB]
_cCDL_LOCEMB:= aCExp[_nPosAcols,PosLOCEMB]
_cCDL_NUMDEC:= aCExp[_nPosAcols,PosNumDec]

acExp2:={}
If Upper(FunName())<>"COMPLEME"
   Return .t.
Endif

_aCabPer1:={;			  
"CDL_ESPEXP",;
"CDL_DOC",;
"CDL_SERIE",;
"CDL_ESPEC",;
"CDL_CLIENT",;
"CDL_LOJA",; 
"CDL_NATEXP",;
"CDL_NRREG",;
"CDL_DTDE",;
"CDL_CHCEMB",;
"CDL_TPCHC",;
"CDL_FORNEC",;
"CDL_LOJFOR",;
"CDL_DOCORI",;
"CDL_SERORI",;
"CDL_NFEXP",;
"CDL_SEREXP",;
"CDL_EMIEXP",;
"CDL_QTDEXP",;
"CDL_UFEMB",;
"CDL_NUMDE",;
"CDL_INDDOC",;
"CDL_DTREG",;
"CDL_DTCHC",;
"CDL_DTAVB",;
"CDL_PAIS",;
"CDL_UFEMB",;
"CDL_LOCEMB",;
"CDL_CHVEXP"} 


_aCabPer2:={;
"TRBX->F2_ESPECIE",;
"TRBX->D2_DOC",;
"TRBX->D2_SERIE",;
"TRBX->F1_ESPECIE",;
"TRBX->D2_CLIENTE",;
"TRBX->D2_LOJA",;
"'1'",;
"TRBX->C5_BAURE",;
"TRBX->D1_EMISSAO",;
"TRBX->C5_BOOK",;
"'1'",;
"TRBX->D1_FORNECE",;
"TRBX->D1_LOJA",;
"TRBX->D1_DOC",;
"TRBX->D1_SERIE",;
"TRBX->D2_DOC",;
"TRBX->D2_SERIE",;
"TRBX->D2_EMISSAO",;
"TRBX->D2_QUANT",;
"TRBX->C5_XUFEMBA",;
"''",;
"'1'",;     
"",;
"",;
"",;
"",;
"",;
"TRBX->C5_XLOCEMB",;
"TRBX->F1_CHVNFE"} 

//CDL_ESPEXP  := F2_ESPECIE
//CDL_FILIAL  := xFilial('CDL')
//CDL_DOC     := D2_DOC
//CDL_SERIE   := D2_SERIE
//CDL_ESPEC   := F1_ESPECIE
//CDL_CLIENT  := D2_CLIENTE
//CDL_LOJA    := D2_LOJA
//CDL_NUMDE   := C5_NATUREZ
//CDL_DTDE    := D1_EMISSAO
//CDL_NATEXP  := '1'
//CDL_NRREG   := C5_BAURE
//CDL_TPCHC   := '10'
////CDL_PAIS    := 
//CDL_FORNECE := D1_FORNECE
//CDL_LOJA    := D1_LOJA
//CDL_DOCORI  := D1_DOC
//CDL_SERORI  := D1_SERIE
//CDL_NFEXP   := D2_DOC
//CDL_SEREXP  := D2_SERIE
//CDL_EMIEXP  := D2_EMISSAO
//CDL_QTDEXP  := D2_QUANT
//CDL_UFEMB   := C5_XUFEMBA
//CDL_LOCEMP  := C5_XLOCEMB              

PRIVATE oOK   := LOADBITMAP( GETRESOURCES(), "LBOK" )
PRIVATE oNO   := LOADBITMAP( GETRESOURCES(), "LBNO" )


//IF MsgBox('?',"","YESNO")
//Endif
     If SELECT("TRBX") <> 0
        TRBX->(DbCloseArea())
     EndIf


cQuery:=""
cQuery+=" SELECT D1_CLVL,F2_ESPECIE,F1_ESPECIE,D1_EMISSAO,D1_FORNECE,D1_LOJA,D1_QUANT "
cQuery+=" ,D1_DOC,D1_SERIE,D2_DOC,D2_SERIE,D2_EMISSAO,D2_QUANT "
cQuery+=" ,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,C5_BOOK,C5_XUFEMBA,C5_XLOCEMB,F1_CHVNFE     "
cQuery+=" ,C5_BAURE,C5_NATUREZ,  "
cQuery+=" (    SELECT SUM(CDL_QTDEXP) AS SOMA FROM "+RetSqlName('CDL')+" CDL WHERE  CDL.D_E_L_E_T_<>'*' AND CDL_DOCORI=SD1.D1_DOC AND SUBSTRING(D1_CLVL,3,9)=SUBSTRING(CDL_NUMDE,1,9) AND CDL_SERORI=SD1.D1_SERIE  ) AS USADO, SD1.R_E_C_N_O_ AS REC "
//cQuery+=" (    SELECT SUM(CDL_QTDEXP) AS SOMA FROM CDL010 WHERE  CDL_DOCORI=SD1.D1_DOC AND SUBSTRING(D1_CLVL,3,9)=SUBSTRING(CDL_NUMDE,1,9) AND CDL_SERORI=SD1.D1_SERIE AND CDL_DOC<> '"+cDoc+"' AND CDL_SERIE<> '"+cSerie+"' ) AS USADO, SD1.R_E_C_N_O_ AS REC "
cQuery+=" FROM "+RetSqlName('SD2')+" SD2 INNER JOIN "+RetSqlName('SD1')+" SD1 ON ((SD1.D1_CLVL = SD2.D2_CLVL AND D2_CLVL<> '         ') OR (D1_CLVL<> '         ' AND D2_CLVL= '         ')) AND SD1.D1_COD = SD2.D2_COD AND D1_TIPO='N' AND  SD1.D_E_L_E_T_<> '*' AND  SD2.D_E_L_E_T_<> '*'  AND SUBSTRING(D1_CF,1,4) NOT IN ('1922','2922','1949','2949') "
cQuery+=" INNER JOIN "+RetSqlName('SF1')+" SF1 ON F1_DOC        = D1_DOC     AND SF1.D_E_L_E_T_ = ' ' "
cQuery+=" INNER JOIN "+RetSqlName('SF2')+" SF2 ON F2_DOC        = D2_DOC     AND SF2.D_E_L_E_T_ = ' ' "
cQuery+=" INNER JOIN "+RetSqlName('SC5')+" SC5 ON C5_NUM        = D2_PEDIDO  AND SC5.D_E_L_E_T_ = ' ' "
cQuery+=" WHERE ((SD1.D1_CLVL = SD2.D2_CLVL AND D2_CLVL<> '         ') OR (D1_CLVL<> '         ' AND D2_CLVL= '         ')) AND SD2.D_E_L_E_T_<> '*' AND D2_TIPO = 'N'  AND SD2.D2_DOC ='"+cDoc+"' "
cQuery+=" ORDER BY D1_CLVL,D1_DOC,D1_SERIE "       // ADRIANO - 07/06/11 - COLOQUEI O CLVL NA ORDENAÇÃO.
memowrite("TELAMV.SQL",cQuery)
     TcQuery cQuery ALIAS TRBX NEW   

_acampos:={;
"D1_CLVL",;
"F2_ESPECIE",;
"F1_ESPECIE",;
"D1_EMISSAO",;
"D1_FORNECE",;
"D1_LOJA",;
"D1_QUANT",;
"D1_DOC",;
"D1_SERIE",;
"D2_DOC",;
"D2_SERIE",;
"D2_EMISSAO",;
"D2_QUANT",;
"D2_DOC",;
"D2_SERIE",;
"D2_CLIENTE",;
"D2_LOJA",;
"C5_XUFEMBA",;
"C5_XLOCEMB",;
"C5_BAURE",;
"C5_NATUREZ"}

For ix:=1 to Len(_aCampos)
   SX3->(DbSetOrder(2))
   If SX3->(DbSeek(_aCampos[ix]))
      IF GetSX3Cache(_aCampos[ix],"X3_TIPO") <> "C"
         TcSetField("TRBX",_aCampos[ix],GetSX3Cache(_aCampos[ix],"X3_TIPO"),GetSX3Cache(_aCampos[ix],"X3_TAMANHO"),GetSX3Cache(_aCampos[ix],"X3_DECIMAL"))
      Endif
   Endif
Next

   
 DbSelectArea('TRBX')
   aCLVL:= { } 
   DbGotop()
   While !Eof()
        If D1_QUANT - USADO > 0
           PosMV:=GDFIELDPOS("CDL_NUMDE",aHExp)
           PosNT:=GDFIELDPOS("CDL_DOCORI",aHExp)
           PosFn:=GDFIELDPOS("CDL_FORNEC",aHExp)
           PosQT:=GDFIELDPOS("CDL_QTDEXP",aHExp) 
           _nSaldo:=0
          For iq:=1 to Len(aCExp)
            _cNota:=Alltrim(D1_DOC)
            _cForn:=Alltrim(D1_FORNECE)
            If Upper(Substr(D1_CLVL,1,2))='MV'
               _cMV:= Alltrim(Substr(D1_CLVL,3,9))
            Else
               _cMV:= Alltrim(D1_CLVL)
            Endif
            If _cMV $ Alltrim(aCExp[iq,PosMV])   .AND. _cNota =Alltrim(aCExp[iq,PosNT])  .AND.  _cForn =Alltrim(aCExp[iq,PosFn])
               _nSaldo:= _nSaldo+aCExp[iq,PosQt]
            Endif
		  Next
		  If _nSaldo >0
		   If D1_QUANT - USADO-_nSaldo>0
		   AADD( aCLVL, {.f., D1_CLVL, D1_DOC,TRANSFORM((D1_QUANT),"@E 999,999.99"),TRANSFORM((D1_QUANT - USADO-_nSaldo),"@E 999,999.99"),REC,(D1_QUANT - USADO-_nSaldo) ,.F. } )
		   Endif
		  Else
		   If D1_QUANT - USADO>0
		   AADD( aCLVL, {.f., D1_CLVL, D1_DOC,TRANSFORM((D1_QUANT),"@E 999,999.99"),TRANSFORM((D1_QUANT - USADO),"@E 999,999.99"),REC,(D1_QUANT - USADO), .F. } )
		   Endif
		  Endif 
		 Endif
		 DbSkip()
   End
   If Empty(aCLVL)
      alert('Sem consulta para esta Nota!')
      RestArea(aArea)
      Return(.t.)
   Endif   
   oDlg := MSDIALOG():Create()
   oDlg:cName := "oDlg"
   oDlg:cCaption := "Diálogo"
   oDlg:nLeft := 0
   oDlg:nTop := 0
   oDlg:nWidth := 600
   oDlg:nHeight := 247
   oDlg:lShowHint := .F.
   oDlg:lCentered := .F.
  
	@ 010,05 LISTBOX oLBX VAR cVar FIELDS HEADER ;
	" ","MV", "Documento","Quantidade", "Saldo" FIELDSIZES 05,82, 32,32 ;
	SIZE 250,075 OF oDLG PIXEL ON DblClick(FMARK1(),oLbx:Refresh(),oLbx:Refresh())
	
	oLBX:SETARRAY( aCLVL )
	oLBX:bLINE := {|| { IIF(aCLVL[oLbx:nAt,1],oOk,oNo) , ;
	aCLVL[oLBX:nAT,2] , ;
	aCLVL[oLBX:nAT,3] , ;
	aCLVL[oLBX:nAT,4] , ;
	aCLVL[oLBX:nAT,5] } }


   oSBtn2 := SBUTTON():Create(oDlg)
   oSBtn2:cName := "oSBtn2"
   oSBtn2:cCaption := "oSBtn2"
   oSBtn2:nLeft := 350
   oSBtn2:nTop := 175
   oSBtn2:nWidth := 52
   oSBtn2:nHeight := 22
   oSBtn2:lShowHint := .F.
   oSBtn2:lReadOnly := .F.
   oSBtn2:Align := 0
   oSBtn2:lVisibleControl := .T.
   oSBtn2:nType := 1
   oSBtn2:bLClicked := {||_nSai:=1, odlg:End() }
   
   oSBtn3 := SBUTTON():Create(oDlg)
   oSBtn3:cName := "oSBtn3"
   oSBtn3:cCaption := "oSBtn3"
   oSBtn3:nLeft := 420
   oSBtn3:nTop := 175
   oSBtn3:nWidth := 52
   oSBtn3:nHeight := 22
   oSBtn3:lShowHint := .F.
   oSBtn3:lReadOnly := .F.
   oSBtn3:Align := 0
   oSBtn3:lVisibleControl := .T.
   oSBtn3:nType := 2
   oSBtn3:bLClicked := {||_nSai:=0, odlg:End() }
   oDlg:Activate()
   If  _nSai=1

       For I:= 1 to Len(aCLVL)
           If aCLVL[I,1]
              DbSelectArea('TRBX')
              DbGotop()
              While !Eof()    
                    If aCLVL[i,6] = REC
                       Exit
                    Endif
                    DbSkip()
              End
              If !Eof()
              
				  aAdd(aCExp2,Array(Len(aHExp)+1))
				  For nY := 1 To Len(aHExp)
					  aCExp2[Len(aCExp2)][nY] := CriaVar(aHExp[nY][2])
		
				  Next nY
					  aCExp2[Len(aCExp2)][Len(aHExp)+1] := .F.	  

			  For nY := 1 To Len(_aCabPer2)
						nScan := GDFIELDPOS(_aCabPer1[ny],aHExp)
						If nScan > 0   
						    If _aCabPer1[ny]== "CDL_QTDEXP" 
						       If  TRBX->D2_QUANT < aCLVL[I,7]
							      aCExp2[Len(aCExp2)][nScan] := TRBX->D2_QUANT
						       Else
							      aCExp2[Len(aCExp2)][nScan] := aCLVL[I,7]
							   Endif
							Elseif   _aCabPer1[ny]=="CDL_CHVEXP"   
							      aCExp2[Len(aCExp2)][nScan] := TRBX->F1_CHVNFE
   
							Elseif   _aCabPer1[ny]=="CDL_NUMDE" //_aCabPer1[ny]== "CDL_NUMDE"
/*/							   
							   _cTroca1:= &(_aCabPer2[ny])							   
							   _cTroca2:=""                 
							   For it:=1 to Len(_cTroca1)
							      _cTroca2:=_cTroca2+If(Substr(_cTroca1,it,1)$'0123456789',Substr(_cTroca1,it,1),"")
							   Next
							   aCExp2[Len(aCExp2)][nScan] := _cTroca2/*/
							   
//							   aCExp2[Len(aCExp2)][nScan] := "           "


							   aCExp2[Len(aCExp2)][nScan] := _cCDL_NUMDEC


							                                                                    
							Elseif _aCabPer1[ny]=="CDL_NRREG"
							   aCExp2[Len(aCExp2)][nScan] := "            "   
							Elseif _aCabPer1[ny]== "CDL_DTREG"
							   aCExp2[Len(aCExp2)][nScan] := _cCDL_DTREG 
							Elseif _aCabPer1[ny]== "CDL_DTCHC"
							   aCExp2[Len(aCExp2)][nScan] := _cCDL_DTCHC 
							Elseif _aCabPer1[ny]== "CDL_DTAVB"
							   aCExp2[Len(aCExp2)][nScan] := _cCDL_DTAVB 
							Elseif _aCabPer1[ny]== "CDL_PAIS"
							   aCExp2[Len(aCExp2)][nScan] := _cCDL_PAIS  
							Elseif _aCabPer1[ny]== "CDL_UFEMB"
							   aCExp2[Len(aCExp2)][nScan] := IF(Empty(&(_aCabPer2[ny])),_cCDL_UFEMB, &(_aCabPer2[ny]))
							Elseif _aCabPer1[ny]== "CDL_LOCEMB"
							   aCExp2[Len(aCExp2)][nScan] := IF(Empty(&(_aCabPer2[ny])),_cCDL_LOCEMB,&(_aCabPer2[ny]))    
							
							Elseif _aCabPer1[ny]== "CDL_TPCHC"
							   aCExp2[Len(aCExp2)][nScan] := "10"
							   
							Else

							   aCExp2[Len(aCExp2)][nScan] := &(_aCabPer2[ny])
							Endif
							
						Endif
			  Next nY 
			  Endif
           Endif
       Next
       xAcols1:={}
       For ii:=1 to Len(aCExp)
           If !Empty(aCExp[ii][GDFIELDPOS("CDL_FORNEC",aHExp)])
            aadd(xAcols1,aCExp[ii])
           Endif
       Next
       For ii:=1 to Len(aCExp2)
           If !Empty(aCExp2[ii][GDFIELDPOS("CDL_FORNEC",aHExp)])
            aadd(xAcols1,aCExp2[ii])
           Endif
       Next

       oGetExp:aCols:=xAcols1
       aCExp:=xAcols1
   Endif


RestArea(aArea)
Return(.t.) 
**********************************************************
STATIC FUNCTION FMARK1()
**********************************************************
LOCAL lRet   := .T.


IF aCLVL[oLbx:nAt,1]
	aCLVL[oLbx:nAt,1] := .F.
ELSE
	aCLVL[oLbx:nAt,1] := .T.
ENDIF

RETURN(lRet)






//SELECT SD2.D2_CLVL,SD2.D2_COD ,SD2.D2_DOC,D1_CLVL AS Navios, F1_NFMAE AS NF_Venda, F1_DOC AS NF_Remessa, F1_CONTRA AS CONTRATO, F1_XPEDIDO AS PEDIDO, F1_VALMERC, 
//F1_EMISSAO AS EMISSAO,F1_DTCHEGA AS CHEGADA,D1_QUANT AS SACAS, C7_QUANT AS TONS, D1_LOCAL AS ARMAZEM, D1_TES AS TES, 
//F1_XNOMFOR AS FORNECEDOR, (C7_VLFINAL*D1_QUANT)/20 AS VL_USD, C7_NRMEDIA AS MEDIA, C7_VLFINAL AS VL_FINAL, D1_LOCAL 
//FROM SD2010 SD2 INNER JOIN SD1010 SD1 ON         
//SD1.D1_CLVL = SD2.D2_CLVL AND SD1.D1_COD = SD2.D2_COD AND  SD1.D_E_L_E_T_<> '*' AND  SD2.D_E_L_E_T_<> '*'        
//INNER JOIN SF1010 SF1 ON F1_DOC        = D1_DOC AND SF1.D_E_L_E_T_ = ' ' 
//INNER JOIN SC7010 SC7 ON C7_NUM        = D1_PEDIDO AND SD1.D_E_L_E_T_ = ' '
//WHERE SD2.D2_CLVL =  'MV2011145' AND SD2.D_E_L_E_T_<> '*'  AND SD2.D2_DOC ='000001150'
//ORDER BY F1_NAVIO, F1_XPEDIDO

Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)                                                                


	
/*
dt registro - CDL_DTREG
dt conhec   - CDL_DTCHC
dt averb    - CDL_DTAVB
cod pais    - CDL_PAIS

uf emb      - CDL_UFEMB
local emb   - CDL_LOCEMB
  */
  

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
