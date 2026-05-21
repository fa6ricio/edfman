#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'  
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EFFEX4001 ºAutor  ³Leandro Ribeiro     º Data ³  09/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada executada na rotina de manuteção de       º±±
±±º          ³ contratos de Financiamentos.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EFFEX400()

Local _cArea1    := GetArea()
Local _cParam    := If(Type("ParamIxb") = "A",ParamIxb1,If(Type("ParamIxb") = "C",ParamIxb,""))           
Local _lFlag1	 := Type("_cVincula") == "L"
Local _lFlag2	 := Type("_cExcluir") == "L" 
Local _lFlag3    := Type("_lLiquida") == "L"
Public _cControl

Do Case   
	Case(_cParam == "EX400Valid") 
		U_EDFA018B(cCampo)	// Qual o processo Vinculação ou Exclusão ?	 
		U_EDFA019A(cCampo)  // Case(_cCampo == "BX_FORCADA") =	_lLiquida := .T.     // Contabilização no liquidação do contrato.      
	Case(_cParam == "BROWSE_EF1") 
		U_EDFA018A()        // Declaracao de variáveis publicaas        
	Case(_cParam == "GRV_EVENTO_EFF") .and. cModulo=="EFF" // 24/02/16 - Luis Felipe
 		U_EDFA018C()        // Função para armazernar os valores da invoice vinculadas no array.        
	Case(_cParam == "VALIDA_CAPA_EF1")
		If(_lFlag1)
	    	IF(Type("_cContCTB") == "A") 
	    		_cControl := .T. 
	    	    U_EDFA018()    // Chamada para contabilização da variação da cambial da invoice Não Realizada e Gravacao do evento 888
				_cContCTB := Nil  
				If(Type("_cVincula") == "L") 
					_cVincula := Nil
				EndIf	         		     
			EndIf	   
		EndIf 
		If(_lFlag2)   
			U_EDFA018D() 
			If(Type("_cExcluir") == "L")
				_cExcluir := Nil
			EndIf         			
		EndIf
		If(_lFlag3) 
		    U_EDFA019() 
			If(Type("_lLiquida") == "L")
				_lLiquida := Nil
			EndIf         			
		EndIf                       
	Case(_cParam == "BROWSE_EF3")      
		U_EDFA018F() // Estorno na contabilidade (Exclusão de Invoice)
   	Case(_cParam == "INC_PARCELAS") 
		U_EDFA018E()  
	// 28/08/18 - Luis Felipe - inicio	    
   	Case(_cParam == "GRAVANDO_EF3") 

/*		If WORKEF3->EF3_CODEVE == '620' .and. !Empty(WORKEF3->EF3_SEQPER) 
			EF3->EF3_TITFIN := SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)                                                                                               
        EndIf
*/
	// 28/08/18 - Luis Felipe - fim


EndCase      
RestArea(_cArea1)

Return()        
 