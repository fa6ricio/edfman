#INCLUDE 'TOTVS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'     

#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA018   บAutor  ณLeandro Ribeiro     บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para contabiliza็ใo da invoice vinculada ao contratoบฑฑ
ฑฑบ          ณ de financiamento.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                                                      

User Function EDFA018()
                       
Local _cArea2    := GetArea()
Local _cHistLote := ""   
Local cCodSeq	 := CtbRdia() 
Local cSeqCorr   := ""

Local aCampos	 := {}
Local aAltera	 := {}
Local cArq1
Local cArq2         
                      
Local _nReg		 := RECNO()                
Local _cOpc		 := 3
Local CTF_LOCK	 := 0                     
Local _cDoc      := ""
Local _cLote	 := "000001"
Local _cRet	     := .F.     
                                  
Local oDoc
Local oLote  
Local oSubLote  

Local cArquivo  := ""
Local nHdlPrv   := 0 
                                               
Local _cRotina  := aRotina
Local _cNumSeq  := EDFA018H(EF1->EF1_CONTRA)   // Restaurado evento - 888 - Estorno VN Nใo realizada - Luis Felipe - 22/06/2015      

Private cSubLote   := ""                    
Private cPadrao    := GetMv("MV_XVICINC")
Private nTotInf    := 0    
Private cLoteSub   := GetMv("MV_SUBLOTE")
Private lSubLote   := .F.          
Private __lCusto   := .F.
Private __lItem    := .F.
Private __lCLVL	   := .F.
Private aTotRdpe   := {{0,0,0,0},{0,0,0,0}}
Private _cNumContr := Alltrim(EF1->EF1_CONTRA)
Private _lRet     := .F.                              
Private aHeader	 := {}    
Private oGetDB 
Private dDataLanc := Ddatabase  
Private aRotina	  := {}
Private _aCalAcc  := {}   
Private _nValVaria:= 0
Public _cChaveEF1 := xFilial("EF1")+EF1->EF1_TPMODU+EF1->EF1_CONTRA+EF1->EF1_BAN_FI+EF1->EF1_PRACA+EF1->EF1_SEQCNT
Public _cChaveEF3 := ""

   aAdd(aRotina, { "Pesquisar"      , "AxPesqui"  , 			 0, 1})//"Pesquisar"
   aAdd(aRotina, { "Visualizar"     , "EX400Manut", 			 0, 2})//"Visualizar"
   aAdd(aRotina, { "Incluir"        , "EX400Manut", 			 0, 3})//"Incluir"
   aAdd(aRotina, { "Alterar"        , "EX400Manut", 			 0, 4})//"Alterar"
   aAdd(aRotina, { "Estornar"       , "EX400Manut", 			 0, 5})//"Estornar"
   aAdd(aRotina, { "Hist๓rico"      , "EX400CHist", 			 0, 6})//"Hist๓rico"
   aAdd(aRotina, { "Copiar"         , "EX401Copia", 			 0, 7})//"Copiar"
   aAdd(aRotina, { "Tot.p/Contrato" , "EX401TotCo", 			 0, 8})//"Tot.p/Contrato"      
   
/* // 21/11/16 - Luis Felipe - A contabiliza็ใo e registro das Invoices Vinculadas na tabela EF3 sob o n. 888 passou a ser consolidado.  
   For _cc := 1 to Len(_cContCTB)
   		_aCalAcc := {}  
	   	If(!EMPTY(_cContCTB[_cc][1]))
//	   		Aadd(_aCalAcc,{_cContCTB[_cc][1],_cContCTB[_cc][2],_cContCTB[_cc][4]}) // Array para fazer o lan็amento na tela de contabilidade. // 14/11/16 - Luis Felipe - Reabilitado 
//	   		_aCalAcc   := aClone(_cContCTB) // 02/07/15 - Luis Felipe // 14/11/16 - Luis Felipe
			Aadd(_aCalAcc,{_cContCTB[_cc][1],_cContCTB[_cc][3],_cContCTB[_cc][3],_cContCTB[_cc][4],_cContCTB[_cc][5]}) // 14/11/16 - Luis Felipe
   	   		
   	   		nTotInf := _cContCTB[_cc][3] * _cContCTB[_cc][4] // 0 // 30/06/15 - Luis Felipe
	   		
	   		_cChaveEF3 := _cContEF3[_cc] 
	       
		    C050Next(Ddatabase,@_cLote,@cSubLote,@_cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,_cOpc,1)
		    	    
		    Ctba102Lan(_cOpc,Ddatabase,_cLote,cSubLote,_cDoc,"CT2",_nReg,CTF_LOCK,cPadrao,nTotInf,cCodSeq,_cHistLote) 
			While(!_lRet)
				Aviso("Aviso","Para prosseguir com o processo clique em Confirmar!",{"Ok"})
				Ctba102Lan(_cOpc,Ddatabase,_cLote,cSubLote,_cDoc,"CT2",_nReg,CTF_LOCK,cPadrao,nTotInf,cCodSeq,_cHistLote)  
			EndDo      
			// Retirado a Grava็ใo do Evento 888 - Leandro Ribeiro - 18/05/2015   
			// Reativado como 888 - Estorno de VC Nใo Realizada // 22/06/15 - Luis Felipe Nascimento
			If(_lRet) 
				_cNumSeq := IIf(Empty(_cNumSeq),"0001",STRZERO(Val(_cNumSeq)+1,4))
//				U_EDFA018G(_cContCTB[_cc][3],EF1->EF1_MOEDA,EF1->EF1_PRACA,EF1->EF1_TPMODU,EF1->EF1_SEQCNT,EF1->EF1_BAN_FI,EF1->EF1_AGENFI,EF1->EF1_NCONFI,_cNumSeq,_cContCTB[_cc][2])
				U_EDFA018G(_cContCTB[_cc][3],EF1->EF1_MOEDA,EF1->EF1_PRACA,EF1->EF1_TPMODU,EF1->EF1_SEQCNT,EF1->EF1_BAN_FI,EF1->EF1_AGENFI,EF1->EF1_NCONFI,_cNumSeq,_cContCTB[_cc][1])
			EndIf
		Else
			_cVincula := Nil 
	    EndIF	 
	    _aCalAcc := {}   
   Next _cc
*/

_aCalAcc := {}
_aCalAcc := aClone(_cContCTB)
For _cc := 1 to Len(_cContCTB)
	If(!EMPTY(_cContCTB[_cc][1]))
		nTotInf += _cContCTB[_cc][3] * _cContCTB[_cc][4]
		_nValVaria += _cContCTB[_cc][1]
		_cChaveEF3 := _cContEF3[_cc]
	Else
		_cVincula := Nil
	EndIF
Next _cc

C050Next(Ddatabase,@_cLote,@cSubLote,@_cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,_cOpc,1)
Ctba102Lan(_cOpc,Ddatabase,_cLote,cSubLote,_cDoc,"CT2",_nReg,CTF_LOCK,cPadrao,nTotInf,cCodSeq,_cHistLote)

While(!_lRet)
	Aviso("Aviso","Para prosseguir com o processo clique em Confirmar!",{"Ok"})
	Ctba102Lan(_cOpc,Ddatabase,_cLote,cSubLote,_cDoc,"CT2",_nReg,CTF_LOCK,cPadrao,nTotInf,cCodSeq,_cHistLote)
End

// Retirado a Grava็ใo do Evento 888 - Leandro Ribeiro - 18/05/2015
// Reativado como 888 - Estorno de VC Nใo Realizada // 22/06/15 - Luis Felipe Nascimento
If(_lRet)
	_cNumSeq := IIf(Empty(_cNumSeq),"0001",STRZERO(Val(_cNumSeq)+1,4))
	U_EDFA018G(_cContCTB[1][3],EF1->EF1_MOEDA,EF1->EF1_PRACA,EF1->EF1_TPMODU,EF1->EF1_SEQCNT,EF1->EF1_BAN_FI,EF1->EF1_AGENFI,EF1->EF1_NCONFI,_cNumSeq,_nValVaria)
EndIf

aRotina := _cRotina  
//----------------------------------------------------------------------------//
//Fun็ใo para Anulando todas as variaveis publicas utilizadas
//----------------------------------------------------------------------------//
_cVincula  := Nil
_cContCTB  := Nil
_cContEF3  := Nil
_cChaveEF1 := Nil 
_cChaveEF3 := Nil
	
RestArea(_cArea2)

Return()              


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA018C  บAutor  ณLeandro Ribeiro     บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para gravar os valores das invoices vinculadas e a  บฑฑ
ฑฑบ          ณ chave da EF3 da invoice.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                                                      

User Function EDFA018C()

Local _cArea3 	 := GetArea() 
Local _nValNRea  := 0 //Varia็ใo Cambial Nใo Realizada  
Local _nValReal  := 0 //Varia็ใo Cambial Realizada     
Local _nUltTaxa	 := u_EDFA017E(EF1->EF1_CONTRA) // Taxa da Ultima calculo da varia็ใo cambial.
Local _nAbeTaxa  := u_EDFA017F(EF1->EF1_CONTRA) // Taxa de Abertura do Contrato  
Local _nTaxVenda := 0

Public _lVlRealNeg := .f.
Public _lVlNRealNeg := .f.

///////////////////////////////////////////////
// Varia็ใo Cambial Nใo Realizada - Reversใo //
///////////////////////////////////////////////
    
If(_nUltTaxa == 0)   	
	_nUltTaxa := WORKINV->TX_VINC // Taxa do Dia
EndIf    

// _nValNRea := WORKINV->VL_INV * _nAbeTaxa - WORKINV->VL_INV * _nUltTaxa  // 29/06/15 - Luis Felipe
_nValNRea := WORKINV->VINCULADO * _nAbeTaxa - WORKINV->VINCULADO * _nUltTaxa

////////////////////////////////                        	
// Varia็ใo Cambial Realizada //
////////////////////////////////   

DbSelectArea("SYE")
DbSetOrder(1)
If(DbSeek(xFilial("SYE")+DTOS(Ddatabase)+EF1->EF1_MOEDA)) 
	_nTaxVenda := SYE->YE_VLCON_C // Alterado a cota็ใo do dolar para compra - Leandro Ribeiro - 18/05/2015
   //	_nTaxVenda := SYE->YE_TX_COMP  // // Retorno para a cota็ใo de venda - 19/06/15 - Luis Felipe Nascimento
EndIf  
    
//_nValReal := WORKINV->VL_INV * _nAbeTaxa - WORKINV->VL_INV * _nTaxVenda // 29/06/15 - Luis Felipe
// _nValReal := WORKINV->VINCULADO * _nAbeTaxa - WORKINV->VINCULADO * _nTaxVenda // 07/07/15 - Luis Felipe - Inversใo do calculo conforme evento 500 V.C. ACC
_nValReal := WORKINV->VINCULADO * _nTaxVenda - WORKINV->VINCULADO * _nAbeTaxa 

// Obs: Estou ajustando para dar certo quando a taxa de abertura do contrato for menor que a taxa do dia. Se no teste com a taxa 
// de abertura maior que a taxa do dia der errado, analisar a possibilidade enxergar o valor do evento 500.  

// Evento 888 - VN Nใo Realizada - Contabiliza็ใo Invertida
If WORKEF3->EF3_CODEVE == "500" // V.C. ACC - Positivo
	_lVlNRealNeg := If(_nValNRea<0,.t.,.f.) // Negativo e Nใo houve inversใo
	_lVlRealNeg  := If(_nValReal<0,.t.,.f.) // Positivo e Nใo houve inversใo
ElseIf WORKEF3->EF3_CODEVE == "501" // V.C. ACC - Negativo
	_lVlNRealNeg := If(_nValNRea<0,.f.,.t.) // Positivo e houve inversใo
	_lVlRealNeg  := If(_nValReal<0,.f.,.t.) // Negativa e houve inversใo
EndIf

//Aadd(_cContCTB,{_nValNRea,_nValReal,_nTaxVenda})  02/07/15 - Luis Felipe
//Aadd(_cContCTB,{_nValNRea,_nValReal,_nTaxVenda,WORKINV->VINCULADO})
Aadd(_cContCTB,{_nValNRea,_nValReal,_nTaxVenda,WORKINV->VINCULADO,WORKEF3->EF3_INVOIC}) // 14/11/16 - Luis Felipe
Aadd(_cContEF3,xFilial("EF3")+WORKEF3->EF3_TPMODU+WORKEF3->EF3_CONTRA+WORKEF3->EF3_BAN_FI+WORKEF3->EF3_PRACA+WORKEF3->EF3_SEQCNT+WORKEF3->EF3_INVOIC) 
		
RestArea(_cArea3)

Return()          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA018A  บAutor  ณLeandro Ribeiro     บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para declarar as variveis publicas que serแ utiliza-บฑฑ
ฑฑบ          ณ das durante o processamento da rotina.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                                                      

User Function EDFA018A()

Public _cContCTB := {}
Public _cContEF3 := {}  
Public _cEstoEF3 := {}
Public _cValoEF3 := {}

Return()     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA018B  บAutor  ณLeandro Ribeiro     บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para verificar qual processo esta sendo executado   บฑฑ
ฑฑบ          ณ Vincula็ใo ou Exclusใo.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                                                      

User Function EDFA018B(_xCampo)

Public _cVincula 
Public _cExcluir  

Do Case
	Case(_xCampo == "VINC_INVOICES")
    	_cVincula := .T.
	Case(_xCampo == "EX_EVENTO")
		_cExcluir := .T.
EndCase	
	
Return()     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA018D  บAutor  ณLeandro Ribeiro     บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para contabiliza็ใo do estorno da invoice vinculada บฑฑ
ฑฑบ          ณ ao contrato de financiamento.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                                                      

User Function EDFA018D()
                       
Local _cArea3    := GetArea()
Local _cHistLote := "Contabilizacao da Vinculacao da Invoice - Estorno"   
Local cCodSeq	 := CtbRdia() 
Local cSeqCorr   := ""

Local aCampos	 := {}
Local aAltera	 := {}
Local cArq1
Local cArq2         
                      
Local _nReg		            
Local _cOpc		 := 6
Local CTF_LOCK	 := 0                     
Local _cRet	     := .F.
                                  
Local oDoc
Local oLote  
Local oSubLote  

Local cArquivo  := ""
Local nHdlPrv   := 0 

Local _cRotina  := aRotina
Local _cIndEF1   := ""
Local _cIndEF3   := "" 
Local _cKeyEstor  := ""
Local lEstorno   := .T.

Private cDoc      := ""
Private cLote	  := "000001"                                            
Private cSubLote  := ""                    
Private cPadrao   := GetMv("MV_XVICINC")
Private nTotInf   
Private cLoteSub  := GetMv("MV_SUBLOTE")
Private lSubLote  := .F.          
Private __lCusto  := .F.
Private __lItem   := .F.
Private __lCLVL	  := .F.
Private aTotRdpe  := {{0,0,0,0},{0,0,0,0}}

Private _lRet    := .F.                                
Private aHeader	  := {}    
Private oGetDB 
Private dDataLanc := Ddatabase  
Private aRotina	  := {}  
Private _cEstorno := .T. 
Private aCtbEntid   
Private nQtdEntid        
Private _aEstAcc  := {} 

   aAdd(aRotina, { "Pesquisar"      , "AxPesqui"  , 			 0, 1})//"Pesquisar"
   aAdd(aRotina, { "Visualizar"     , "EX400Manut", 			 0, 2})//"Visualizar"
   aAdd(aRotina, { "Incluir"        , "EX400Manut", 			 0, 3})//"Incluir"
   aAdd(aRotina, { "Alterar"        , "EX400Manut", 			 0, 4})//"Alterar"
   aAdd(aRotina, { "Estornar"       , "EX400Manut", 			 0, 5})//"Estornar"
   aAdd(aRotina, { "Hist๓rico"      , "EX400CHist", 			 0, 6})//"Hist๓rico"
   aAdd(aRotina, { "Copiar"         , "EX401Copia", 			 0, 7})//"Copiar"
   aAdd(aRotina, { "Tot.p/Contrato" , "EX401TotCo", 			 0, 8})//"Tot.p/Contrato"   

If nQtdEntid == NIL
	nQtdEntid := If(FindFunction("CtbQtdEntd"),CtbQtdEntd(),4) //sao 4 entidades padroes -> conta /centro custo /item contabil/ classe de valor
EndIf
                  
If aCtbEntid == NIL
	aCtbEntid := Array(2,nQtdEntid)  //posicao 1=debito  2=credito
EndIf

//DEBITO
aCtbEntid[1,1] := {|| TMP->CT2_DEBITO 	}
aCtbEntid[1,2] := {|| TMP->CT2_CCD		}
aCtbEntid[1,3] := {|| TMP->CT2_ITEMD 	}
aCtbEntid[1,4] := {|| TMP->CT2_CLVLDB 	}
//CREDITO
aCtbEntid[2,1] := {|| TMP->CT2_CREDITO }
aCtbEntid[2,2] := {|| TMP->CT2_CCC		}
aCtbEntid[2,3] := {|| TMP->CT2_ITEMC 	}
aCtbEntid[2,4] := {|| TMP->CT2_CLVLCR 	}

lEstorno := Type("_cEstorno") <> "U"

For _xx := 1 to Len(_cEstoEF3)        

_cIndEF1 := xFilial("EF1")+EF1->EF1_TPMODU+EF1->EF1_CONTRA+EF1->EF1_BAN_FI+EF1->EF1_PRACA+EF1->EF1_SEQCNT
_cIndEF3 := _cEstoEF3[_xx]  

	If(!EMPTY(_cValoEF3[_xx]))
		DbSelectArea("ZZ2")
		DbSetOrder(1)
		If(DbSeek(xFilial("ZZ2")+PADR(_cIndEF1,TAMSX3("ZZ2_KEYEF1")[1])+PADR(_cIndEF3,TAMSX3("ZZ2_KEYEF3")[1])))
			
			DbSelectArea("CT2")
			DbSetOrder(1)
			If(DbSeek(AllTrim(ZZ2->ZZ2_KEYCT2)))
				
				_cKeyEstor := CT2->CT2_XCHEF3
				
				Aadd(_aEstAcc,{_cValoEF3[_xx][1],_cValoEF3[_xx][2]}) // Alimenta o Array para o preenchimento das linhas da contabilidade
				
				nTotInf := _cValoEF3[_xx][3] 
				_nReg := CT2->(RECNO()) 	       
					 
					C050Next(Ddatabase,@cLote,@cSubLote,@cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,_cOpc,1) 
					   		    
					Ctba102Lan(_cOpc,Ddatabase,CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,"CT2",_nReg,CTF_LOCK,cPadrao,nTotInf,cCodSeq,_cHistLote) 
					While(!_lRet)
					Aviso("Aviso","Para prosseguir com o processo clique em Confirmar!",{"Ok"})
						Ctba102Lan(_cOpc,Ddatabase,CT2->CT2_LOTE,CT2->CT2_SBLOTE,CT2->CT2_DOC,"CT2",_nReg,CTF_LOCK,cPadrao,nTotInf,cCodSeq,_cHistLote) 
					EndDo   				
			Else 
				Aviso("Aviso","Lan็amento Contabil nใo encontrado, favor verificar!",{"OK"})   
			EndIf
			
			DbSelectArea("ZZ2")
			DbSetOrder(1)
			If(DbSeek(xFilial("ZZ2")+PADR(_cIndEF1,TAMSX3("ZZ2_KEYEF1")[1])+PADR(_cIndEF3,TAMSX3("ZZ2_KEYEF3")[1])))
				While ZZ2->(!Eof())
					If(xFilial("ZZ2")+ZZ2->ZZ2_KEYEF1+ZZ2->ZZ2_KEYEF3) == (xFilial("ZZ2")+PADR(_cIndEF1,TAMSX3("ZZ2_KEYEF1")[1])+PADR(_cIndEF3,TAMSX3("ZZ2_KEYEF3")[1]))
						RecLock("ZZ2", .F.)
							DbDelete()
						MsUnLock()
					EndIf
					ZZ2->(DbSkip())
		        EndDo
		   EndIf     
		   	// Retirado a exclusใo do Evento 888 - Leandro Ribeiro - 18/05/2015
		   	// Reativado como 888  - Estorno de VC Nใo Realizada - 22/06/15 - Luis Felipe Nascimento
		    // Para excluir a linha de cod evento 888
			If lEstorno 
				DbSelectArea("EF3")
				DbSetOrder(11)
				If(DbSeek(_cKeyEstor))
					RecLock("EF3",.F.)
						DbDelete()			
			        MsUnlock()
				EndIf   
			EndIf		
		   
		EndIf
	Else
		_cExcluir := Nil
	EndIf	
Next _xx           

	("ZZ2")->(dbCloseArea())	    
	("EF1")->(dbCloseArea())
	("CT2")->(dbCloseArea())
	("EF3")->(dbCloseArea())  

aRotina := _cRotina 
//----------------------------------------------------------------------------//
//Fun็ใo para Anulando todas as variaveis publicas utilizadas
//----------------------------------------------------------------------------//
_cControl  := Nil 
_cExcluir  := Nil
_cEstoEF3  := Nil
_cValoEF3  := Nil
	
RestArea(_cArea3)

Return()   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA018F  บAutor  ณLeandro Ribeiro     บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para gravar os valores das invoices vinculadas e a  บฑฑ
ฑฑบ          ณ chave da EF3 da invoice estornadas.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                                                      

User Function EDFA018F()

Local _cArea5    := GetArea() 
Local _nNRealiza := 0 //Varia็ใo Cambial Nใo Realizada  
Local _nRealiza  := 0 //Varia็ใo Cambial Realizada     
Local _nUltTaxa	 := EDFA018I(EF1->EF1_CONTRA,WORKEF3->EF3_DT_EVE) // Taxa da Ultima calculo da varia็ใo cambial.
Local _nAbeTaxa  := EDFA017F(EF1->EF1_CONTRA) // Taxa de Abertura do Contrato 
Local _nTaxVenda := 0 
Local _nValInf	 := 0

///////////////////////////////////////////////
// Varia็ใo Cambial Nใo Realizada - Reversใo //
///////////////////////////////////////////////
    
_nNRealiza := WORKEF3->EF3_VL_INV * _nAbeTaxa - WORKEF3->EF3_VL_INV * _nUltTaxa

////////////////////////////////
// Varia็ใo Cambial Realizada //
////////////////////////////////
    
DbSelectArea("SYE")
DbSetOrder(1)
If(DbSeek(xFilial("SYE")+DTOS(Ddatabase)+EF1->EF1_MOEDA)) 
	_nTaxVenda := SYE->YE_VLCON_C // Alterado a cota็ใo do dolar para compra - Leandro Ribeiro - 18/05/2015
	// _nTaxVenda := SYE->YE_TX_COMP // Retorno para a cota็ใo de venda - 19/06/15 - Luis Felipe Nascimento
EndIf  

_nRealiza := WORKEF3->EF3_VL_INV * _nAbeTaxa - WORKEF3->EF3_VL_INV * _nTaxVenda
                    
_nValInf := Iif(_nNRealiza <= 0, _nNRealiza * -1, _nNRealiza) + Iif(_nRealiza <= 0, _nRealiza * -1, _nRealiza) 

If(Select("WORKEF3") > 0)
	Aadd(_cValoEF3,{_nNRealiza,_nRealiza,_nValInf})
	Aadd(_cEstoEF3,xFilial("EF3")+WORKEF3->EF3_TPMODU+WORKEF3->EF3_CONTRA+WORKEF3->EF3_BAN_FI+WORKEF3->EF3_PRACA+WORKEF3->EF3_SEQCNT+WORKEF3->EF3_INVOIC)
EndIf
	
RestArea(_cArea5)
	
Return()                                                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA018E  บAutor  ณLeandro Ribeiro     บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para Anulando todas as variaveis publicas utilizadasบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                                                      

User Function EDFA018E()

Local _cArea4 := GetArea()

_cControl  := Nil 
_cVincula  := Nil
_cExcluir  := Nil
_cContCTB  := Nil
_cContEF3  := Nil
_cEstoEF3  := Nil
_cValoEF3  := Nil
_cChaveEF1 := Nil 
_cChaveEF3 := Nil
	
RestArea(_cArea4)
	
Return()              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA018G  บAutor  ณLeandro Ribeiro     บ Data ณ  15/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para incluir a linha do contrato codigo evento 888  บฑฑ
ฑฑบ          ณ na vincula็ใo da invoice.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EDFA018G(_nTaxUlt,_cMoein,_cPraca,_cTpmodu,_cSeqcnt,_cBanfi,_cAgenfi,_cNconfi,__cNumSeq,_nValVaria) 

Local _cArea7   := GetArea()  
Local _cCT2Area 
Local _cEF3Key  := xFilial("EF3")+PADR(_cTpmodu,TAMSX3("EF3_TPMODU")[1])+PADR(Alltrim(EF1->EF1_CONTRA),TAMSX3("EF3_CONTRA")[1])+;
		PADR(_cBanfi,TAMSX3("EF3_BAN_FI")[1])+PADR(_cPraca,TAMSX3("EF3_PRACA")[1])+PADR(_cSeqcnt,TAMSX3("EF3_SEQCNT")[1])+;
		PADR("888",TAMSX3("EF3_CODEVE")[1])+DTOS(Ddatabase)+PADR(__cNumSeq,TAMSX3("EF3_SEQ")[1]) 

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

_cCT2Area := CT2->(GetArea())
      
DbSelectArea("CT2")
DbSetOrder(1)
If(DbSeek(_cKeyEF3))
	While (CT2->(!Eof()) .AND. (xFilial("CT2")+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC == _cKeyEF3))  
			RecLock("CT2",.F.)
				CT2->CT2_XCHEF3 := _cEF3Key
    		MsUnlock()
    	CT2->(DbSkip())
    Enddo
EndIf             
                
RestArea(_cCT2Area)
RestArea(_cArea7)

Return()     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA018H  บAutor  ณLeandro Ribeiro     บ Data ณ  15/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar o ultimo sequencial do codigo evento  บฑฑ
ฑฑบ          ณ 888 Varia็ใo Cambial Realizado.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EDFA018H(_cContrato) 

Local _cArea1  := GetArea()
Local _cQuery1 := ""
Local _cTrab1  := GetNextAlias()
Local _cRet1   := ""

_cQuery1 := " SELECT TOP 1 EF3_TX_MOE, EF3_SEQ" 
_cQuery1 += " FROM "+RETSQLNAME("EF3")+ " EF3"
_cQuery1 += " WHERE
_cQuery1 += " EF3_CONTRA = '"+AllTrim(_cContrato)+"'
_cQuery1 += " AND EF3_CODEVE = '888'"
_cQuery1 += " AND EF3.D_E_L_E_T_ = ' '"
_cQuery1 += " ORDER BY EF3_SEQ DESC " 
_cQuery1 := ChangeQuery(_cQuery1)      

If Select(_cTrab1) > 0
	dbSelectArea(_cTrab1)
	(_cTrab1)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cTrab1,.T.,.T.)
                                              
If((_cTrab1)->(!Eof()))
	While !(_cTrab1)->(Eof())
   		    _cRet1 := (_cTrab1)->EF3_SEQ			
    	(_cTrab1)->(DbSkip())
	Enddo
EndIf  

(_cTrab1)->(dbCloseArea())

RestArea(_cArea1)

Return(_cRet1)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA018I  บAutor  ณLeandro Ribeiro     บ Data ณ  15/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar o ultimo sequencial do codigo evento  บฑฑ
ฑฑบ          ณ 777 Varia็ใo Cambial Realizado.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EDFA018I(_cContrato,_cData) 

Local _cArea6  := GetArea()
Local _cQuery6 := ""
Local _cTrab6  := GetNextAlias()
Local _nRet6   := 0

_cQuery6 := " SELECT TOP 1 EF3_TX_MOE, EF3_SEQ, EF3_DT_EVE" 
_cQuery6 += " FROM "+RETSQLNAME("EF3")+ " EF3"
_cQuery6 += " WHERE
_cQuery6 += " EF3_CONTRA = '"+AllTrim(_cContrato)+"'
_cQuery6 += " AND EF3_CODEVE = '777'"
_cQuery6 += " AND EF3_DT_EVE <= '"+DTOS(_cData)+"'
_cQuery6 += " AND EF3.D_E_L_E_T_ = ' '"
_cQuery6 += " ORDER BY EF3_DT_EVE DESC" 
_cQuery6 := ChangeQuery(_cQuery6)      

If Select(_cTrab6) > 0
	dbSelectArea(_cTrab6)
	(_cTrab6)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery6),_cTrab6,.T.,.T.)
                                              
If((_cTrab6)->(!Eof()))
	While !(_cTrab6)->(Eof())
   		    _nRet6 := (_cTrab6)->EF3_TX_MOE			
    	(_cTrab6)->(DbSkip())
	Enddo
EndIf  

(_cTrab6)->(dbCloseArea())

RestArea(_cArea6)

Return(_nRet6)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA017   บAutor  ณLeandro Ribeiro     บ Data ณ  10/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar a taxa da moeda da ultima varia็ใo    บฑฑ
ฑฑบ          ณ cambial.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EDFA017E(_cContrato) 

Local _cArea1  := GetArea()
Local _cQuery1 := ""
Local _cTrab1  := GetNextAlias()
Local _nRet    := 0

_cQuery1 := " SELECT EF3_TX_MOE, EF3_SEQ" 
_cQuery1 += " FROM "+RETSQLNAME("EF3")+ " EF3"
_cQuery1 += " WHERE
_cQuery1 += " EF3_CONTRA = '"+AllTrim(_cContrato)+"'
_cQuery1 += " AND EF3_CODEVE = '777'"
_cQuery1 += " AND EF3.D_E_L_E_T_ = ' '"
_cQuery1 := ChangeQuery(_cQuery1)      

If Select(_cTrab1) > 0
	dbSelectArea(_cTrab1)
	(_cTrab1)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cTrab1,.T.,.T.)
                                              
If(!Eof())
	While !(_cTrab1)->(Eof())
   			_nRet := (_cTrab1)->EF3_TX_MOE 
   			_cNumSeq := (_cTrab1)->EF3_SEQ			
    	(_cTrab1)->(DbSkip())
	Enddo
EndIf  

(_cTrab1)->(dbCloseArea())

RestArea(_cArea1)

Return(_nRet)     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEDFA017   บAutor  ณLeandro Ribeiro     บ Data ณ  12/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar a taxa de abertura do contrato para o บฑฑ
ฑฑบ          ณ calculo da varia็ใo cambial.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EDFA017F(_cContrato) 

Local _cArea2  := GetArea()
Local _cQuery2 := ""
Local _cTrab2  := GetNextAlias()
Local _nRet    := 0

_cQuery2 := " SELECT EF3_TX_MOE, EF3_SEQ" 
_cQuery2 += " FROM "+RETSQLNAME("EF3")+ " EF3"
_cQuery2 += " WHERE
_cQuery2 += " EF3_CONTRA = '"+AllTrim(_cContrato)+"'
_cQuery2 += " AND EF3_CODEVE = '100'"
_cQuery2 += " AND EF3.D_E_L_E_T_ = ' '"
_cQuery2 := ChangeQuery(_cQuery2)      

If Select(_cTrab2) > 0
	dbSelectArea(_cTrab2)
	(_cTrab2)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cTrab2,.T.,.T.)
                                              
If(!Eof())
	While !(_cTrab2)->(Eof())
   			_nRet := (_cTrab2)->EF3_TX_MOE 			
    	(_cTrab2)->(DbSkip())
	Enddo
EndIf  

(_cTrab2)->(dbCloseArea())

RestArea(_cArea2)

Return(_nRet)
