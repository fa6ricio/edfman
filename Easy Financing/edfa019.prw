#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'  
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA019   ºAutor  ³Leandro Ribeiro     º Data ³  16/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para realizar a contabilização da liquidação do     º±±
±±º          ³ contrato.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA019()

Local _cEDFA019  := GetArea() 
Local _nReg		 := RECNO()                
Local _cOpc		 := 3
Local CTF_LOCK	 := 0                     
Local _cDoc      := ""
Local _cLote	 := "000001"
Local _cRet	     := .F.  
Local cCodSeq	 := CtbRdia() 
Local cSeqCorr   := ""
Local _cHistLote := ""      
                                  
Local oDoc
Local oLote  
Local oSubLote    

Local _nUltTaxa	:= u_EDFA017E(EF1->EF1_CONTRA) // Taxa da Ultima calculo da variação cambial.
Local _nAbeTaxa := u_EDFA017E(EF1->EF1_CONTRA) // Taxa de Abertura do Contrato  

//Local _nRealiza  := 0  // 02/07/15 - Luis Felipe - Torna-las Publicas para a contabilização 
//Local _nNRealiza := 0 

Local _lRealiza  := 0
Local _lNRealiza := 0 

Local _nTaxaDia	 := 0     
        
Private cLoteSub   := GetMv("MV_SUBLOTE")
Private lSubLote   := .F.          
Private __lCusto   := .F.
Private __lItem    := .F.
Private __lCLVL	   := .F.
Private aTotRdpe   := {{0,0,0,0},{0,0,0,0}}
Private cSubLote   := ""                
Private cPadrao    :=  GetMv("MV_XLIQACC") // GetMv("MV_XVICINC") 30/06/15 - Luis Felipe
Private _cNumContr := Alltrim(EF1->EF1_CONTRA) 
Private nTotInf	:= 0 

Private _lRet    := .F.                                     
Private aHeader	 := {}    
Private oGetDB 
Private dDataLanc := Ddatabase  
//Private _xxRet    := .F.
Private aRotina	   := {}   
Private _lLiquida2 := .T.
Private _aVliquida := {}    

Public 	_lNegativo := .f.
Public _nRealiza   := 0
Public _nNRealiza  := 0   
Public _lVlRealNeg := .f.
Public _lVlNRealNeg := .f.
	
   aAdd(aRotina, { "Pesquisar"      , "AxPesqui"  , 			 0, 1})//"Pesquisar"
   aAdd(aRotina, { "Visualizar"     , "EX400Manut", 			 0, 2})//"Visualizar"
   aAdd(aRotina, { "Incluir"        , "EX400Manut", 			 0, 3})//"Incluir"
   aAdd(aRotina, { "Alterar"        , "EX400Manut", 			 0, 4})//"Alterar"
   aAdd(aRotina, { "Estornar"       , "EX400Manut", 			 0, 5})//"Estornar"
   aAdd(aRotina, { "Histórico"      , "EX400CHist", 			 0, 6})//"Histórico"
   aAdd(aRotina, { "Copiar"         , "EX401Copia", 			 0, 7})//"Copiar"
   aAdd(aRotina, { "Tot.p/Contrato" , "EX401TotCo", 			 0, 8})//"Tot.p/Contrato" 

	DbSelectArea("WORKEF3")
	DbSetOrder(5)
	If(DbSeek("180"))  
	
		//////////////////////////////////////////////////////////
		// CALCULO DO ESTORNO DA VARIAÇÃO CAMBIAL NÃO REALIZADA //	
		//////////////////////////////////////////////////////////    
	
		If(_nUltTaxa == 0)
			DbSelectArea("SYE")
			DbSetOrder(1)
			If(DbSeek(xFilial("SYE")+DTOS(Ddatabase)+EF1->EF1_MOEDA)) 
				_nUltTaxa := SYE->YE_VLCON_C // Alterado a cotação do dolar para compra - Leandro Ribeiro - 18/05/2015
				// _nUltTaxa := SYE->YE_TX_COMP // Retorno para a cotação de venda - 19/06/15 - Luis Felipe Nascimento
			Else                   
				Aviso("Aviso","Não existe taxa para o dia de hoje, favor verificar!",{"Ok"})
				Return()
			EndIf  
		EndIf
		
		_nNRealiza := (WORKEF3->EF3_VL_MOE * _nAbeTaxa) - (WORKEF3->EF3_VL_MOE * _nUltTaxa)   
	
		///////////////////////////////////////////
		// CALCULO DA VARIAÇÃO CAMBIAL REALIZADA //	
		///////////////////////////////////////////    
		DbSelectArea("SYE")
		DbSetOrder(1)
		If(DbSeek(xFilial("SYE")+DTOS(Ddatabase)+EF1->EF1_MOEDA)) 
			_nTaxaDia := SYE->YE_VLCON_C // Alterado a cotação do dolar para compra - Leandro Ribeiro - 18/05/2015
			// _nTaxaDia := SYE->YE_TX_COMP // Retorno para a cotação de venda - 19/06/15 - Luis Felipe Nascimento
		Else
			Aviso("Aviso","Não existe taxa para o dia de hoje, favor verificar!",{"Ok"})
			Return()
		EndIf  
	
//		_nRealiza := (WORKEF3->EF3_VL_MOE * _nAbeTaxa) - (WORKEF3->EF3_VL_MOE * _nTaxaDia) // 09/07/15 - Luis Felipe - Calculo está invertido
		_nRealiza := (WORKEF3->EF3_VL_MOE * _nTaxaDia) - (WORKEF3->EF3_VL_MOE * _nAbeTaxa) 
        
		// 30/06/15 - Luis Felipe - Inicio // Variaveis lógicas usadas na definição das Contas Contabeis
		// Evento 777 - VC Realizada e 888 - VN Não Realizada - Contabilização Positiva ou Negativa sem a inversão de contas 
		_lVlRealNeg  := If(_nRealiza<0,.t.,.f.)  
		_lVlNRealNeg := If(_nNRealiza<0,.t.,.f.) 
		// 30/06/15 - Luis Felipe - Fim

		nTotInf := WORKEF3->EF3_VL_MOE * _nTaxaDia // _nRealiza + _nNRealiza // 02/07/15 - Luis Felipe
		Aadd(_aVliquida,{_nNRealiza,_nRealiza,WORKEF3->EF3_VL_MOE,WORKEF3->EF3_VL_MOE * _nTaxaDia})

/*      07/07/15 - Luis Felipe - Deixar gravar o registro 888 como foi gerado positivo ou negativo.
	    //////////////////////////////////////////////////////////////////////////////
		// Multiplicar por -1 pois não pode lançar numero negativo na contabilidade //	    
	    //////////////////////////////////////////////////////////////////////////////                                                                         
	    _nRealiza   := Iif(_nRealiza  <= 0, _nRealiza * -1, _nRealiza) 
	    _nNRealiza  := Iif(_nNRealiza <= 0, _nNRealiza * -1, _nNRealiza) 
	    //////////////////////////////////////////////////////////////////////////////
*/
		C050Next(Ddatabase,@_cLote,@cSubLote,@_cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,_cOpc,1)
		    
		Ctba102Lan(_cOpc,Ddatabase,_cLote,cSubLote,_cDoc,"CT2",_nReg,CTF_LOCK,cPadrao,nTotInf,cCodSeq,_cHistLote) 
		While(!_lRet)
			Aviso("Aviso","Para prosseguir com o processo clique em Confirmar!",{"Ok"})
			Ctba102Lan(_cOpc,Ddatabase,_cLote,cSubLote,_cDoc,"CT2",_nReg,CTF_LOCK,cPadrao,nTotInf,cCodSeq,_cHistLote)  
		EndDo  
		// Retirado a Gravação do Evento 888 - Leandro Ribeiro - 18/05/2015
        // Reativado 888 - Estorno VC Não Realizada - Luis Felipe Nascimento - 22/06/2015
		If(_lRet)
			_cNumSeq := "0000"
			// U_EDFA019B(_nTaxaDia,WORKEF3->EF3_MOE_IN,WORKEF3->EF3_PRACA,WORKEF3->EF3_TPMODU,WORKEF3->EF3_SEQCNT,WORKEF3->EF3_BAN_FI,WORKEF3->EF3_AGENFI,WORKEF3->EF3_NCONFI,_cNumSeq,_nRealiza)
			U_EDFA019B(_nTaxaDia,WORKEF3->EF3_MOE_IN,WORKEF3->EF3_PRACA,WORKEF3->EF3_TPMODU,WORKEF3->EF3_SEQCNT,WORKEF3->EF3_BAN_FI,WORKEF3->EF3_AGENFI,WORKEF3->EF3_NCONFI,_cNumSeq,_nNRealiza,_lVlNRealNeg)
		EndIf	
	
	EndIf
	          
	("SYE")->(dbCloseArea())	    
	("EF1")->(dbCloseArea())
	("EF3")->(dbCloseArea())  
	
RestArea(_cEDFA019)

Return()     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA019A  ºAutor  ³Leandro Ribeiro     º Data ³  08/20/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para verificar qual processo esta sendo executado   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA019A(_cCampo)

Public _lLiquida  

Do Case
	Case(_cCampo == "BX_FORCADA")
    	_lLiquida := .T.
EndCase	

Return()
             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA019B  ºAutor  ³Leandro Ribeiro     º Data ³  15/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para incluir a linha do contrato codigo evento 888  º±±
±±º          ³ na liquidação do contrato.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA019B(_nTaxUlt,_cMoein,_cPraca,_cTpmodu,_cSeqcnt,_cBanfi,_cAgenfi,_cNconfi,__cNumSeq,_nValVaria,_lVlNRealNeg) 

Local _cArea1   := GetArea()  
Local _cEF3Key  := xFilial("EF3")+PADR(_cTpmodu,TAMSX3("EF3_TPMODU")[1])+PADR(Alltrim(EF1->EF1_CONTRA),TAMSX3("EF3_CONTRA")[1])+;
		PADR(_cBanfi,TAMSX3("EF3_BAN_FI")[1])+PADR(_cPraca,TAMSX3("EF3_PRACA")[1])+PADR(_cSeqcnt,TAMSX3("EF3_SEQCNT")[1])+;
		PADR("888",TAMSX3("EF3_CODEVE")[1])+DTOS(Ddatabase)

	DbSelectArea("EF3")
	DbSetOrder(11)
	If(!DbSeek(_cEF3Key))
		RecLock("EF3",.T.)
			EF3->EF3_FILIAL := xFilial("EF3")
			EF3->EF3_CONTRA := Alltrim(EF1->EF1_CONTRA)
			EF3->EF3_TP_EVE := "01"
			EF3->EF3_CODEVE := "888"
			EF3->EF3_TX_MOE := _nTaxUlt
			EF3->EF3_DT_EVE := Ddatabase
			EF3->EF3_SEQ	:= __cNumSeq
			EF3->EF3_MOE_IN := _cMoein
			EF3->EF3_PRACA  := _cPraca 
			EF3->EF3_TPMODU := _cTpmodu
			EF3->EF3_SEQCNT := _cSeqcnt
			EF3->EF3_VL_REA := _nValVaria 
			EF3->EF3_BAN_FI := _cBanfi
			EF3->EF3_AGENFI := _cAgenfi
			EF3->EF3_NCONFI := _cNconfi
		MsUnlock()                     
	EndIf

RestArea(_cArea1)

Return()  