/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103CAN  ºAutor  ³YTTALO P. MARTINS   º Data ³  01/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³LOCALIZAÇÃO : Function A103NFiscal() - CHAMADA DE QUALQUER   ±±
±±ºROTINA DA NFE                                                           ±±
±±º           EM QUE PONTO : Ao cancelar a tela da NF de entrada           ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³REFAZ MOVIMENTAÇÕES INTERNAS E TRANSFERÊNCIAS ESTORNADAS NO  ±±
±±º           PE MT103NFE ANTES DA ABERTURA DA TELA PARA ESTORNO DA        ±±
±±º           CLASSIFICAÇÃO E EXCLUSÃO DA NF DE ENTRADA                    ±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103CAN()

Local ni := 1
Local _cin:= ""
Local lRet := .T.

Private cAliasSD3 := ""
Private cAliasSD1 := ""
Private cQuery    := ""
Private cQuery2   := ""
Private cQuery3   := ""

Private aAreaAtu  := GetArea()
Private _aArea
Private _aArea2

If (INCLUI == .F. .AND. ALTERA == .F.)
	
	If ( Type("xEDFD3Seq") == "U" )
		Public xEDFD3Seq := {}
	EndIf
	
	If Len(xEDFD3Seq) > 0
		
		For ni := 1 To Len(xEDFD3Seq)
			
			If ni == 1
				_cin += "("
			EndIf
			
			_cin += "'"+ xEDFD3Seq[ni][1] +"',"
			
			If ni == Len(xEDFD3Seq)
				_cin := SUBSTR( _cin,1,(Len(_cin)-1) ) + ")"
				exit
			EndIf
							
		Next ni
		
		Begin Transaction
		
		cAliasSD3 := GetNextAlias()
		cQuery2 := "SELECT * FROM "+RetSqlName("SD3")+" SD3 "
		cQuery2 += "WHERE SD3.D3_FILIAL='"+xFilial("SD3")+"' "
		cQuery2 += "AND SD3.D3_NUMSEQ IN " + _cin + " "
		cQuery2 += "AND SD3.D3_ESTORNO <> ' ' "
		cQuery2 += "AND SD3.D_E_L_E_T_ = ' ' "
		cQuery2 += "AND SD3.D3_CHAVE = 'E0' "		
		cQuery2 += "ORDER BY D3_NUMSEQ ASC "
		
		cQuery2 := ChangeQuery(cQuery2)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAliasSD3,.T.,.T.)
		
		dbSelectArea(cAliasSD3)
		(cAliasSD3)->(dbGotop())
		
		If (cAliasSD3)->(!EOF())
			
			While (cAliasSD3)->(!EOF())
			           
				_aArea2 := GetArea()
				
				lMsErroAuto := .F.
				//-------------------------------------------------------------------
				//refaz movimentações internas-------------------------------------
				//-------------------------------------------------------------------
				If SUBSTR( (cAliasSD3)->D3_CF,1,2) <> 'PR' .AND. !( SUBSTR((cAliasSD3)->D3_CF,3,1) $ "2#4#5#7" )
					
					xMovInt()
					
				EndIf
				
				If lMsErroAuto == .F.
					//-------------------------------------------------------------------
					//estorna transferências---------------------------------------------
					//-------------------------------------------------------------------
					If (cAliasSD3)->D3_CF = 'DE4' .OR. (cAliasSD3)->D3_CF = 'RE4'
												
						lMsErroAuto := !(U_EDFA009())
						
						If lMsErroAuto
							MostraErro()
							
							MsgAlert("Erro: Transferência(XML-Template) não refeita!")
						
						Else
							RestArea(_aArea2)
							(cAliasSD3)->(dbSkip())	
						EndIf						
						
					EndIf
					
				EndIf				
				
				RestArea(_aArea2)
				
				
				lRet := IIF(lMsErroAuto == .T.,lRet := .F., lRet := .T.)
				
				If lRet == .F.
					
					DisarmTransaction()
					Break
					
				EndIf				
							
			
				(cAliasSD3)->(dbSkip())
			EndDo
			
		EndIf
		
		dbSelectArea(cAliasSD3)
		(cAliasSD3)->(dbCloseArea())    		
		
		End Transaction									
		
	EndIf
	
EndIf

RestArea(aAreaAtu)

Return()

*********************************************************************************************************************************************

Static Function xMovInt()

Local aVetor := {}
Local cTpMov := SuperGetMV("MV_TIPOMOV",.t.,"002")

dbSelectArea("SD3")
dbGoto((cAliasSD3)->R_E_C_N_O_)     				

aVetor:={{"D3_TM"     ,cTpMov        				,NIL},;   
		 {"D3_COD"    ,SD3->D3_COD	 				,NIL},;
		 {"D3_LOCAL"  ,SD3->D3_LOCAL 				,NIL},;   
		 {"D3_UM"     ,SD3->D3_UM  	 				,NIL},;
		 {"D3_QUANT"  ,SD3->D3_QUANT 				,NIL},;
		 {"D3_SEGUM"  ,SD3->D3_SEGUM                ,NIL},;
		 {"D3_QTSEGUM",SD3->D3_QTSEGUM 				,NIL},;
		 {"D3_DOC"    ,SD3->D3_DOC   				,NIL},;   
		 {"D3_SERIE"  ,SD3->D3_SERIE 				,NIL},;   
		 {"D3_ITEM"   ,SD3->D3_ITEM  				,NIL},;   
		 {"D3_EMISSAO",SD3->D3_EMISSAO 				,NIL}}

MSExecAuto({|x,y| mata240(x,y)},aVetor,3) 

If lMsErroAuto
	MostraErro()
	
	MsgAlert("Erro: Movimentação(XML-Template) não refeita!")
	
EndIf

Return()