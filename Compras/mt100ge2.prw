#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"


//  ponto de entrada após a gravação do titulo a pagar, onde o mesmo apenas gravará o numero do contrato.
//  criado Davi Jesus  

//  18/12/13 - Luis Felipe Nasciment - Inclusão do preenchimento do campo nTxUSD

User Function MT100GE2()

Local __aArea   := GetArea()
Local _aAreaSA2 := SA2->(GetArea())
Local aCols 	:= PARAMIXB[1]
Local nOpc  	:= PARAMIXB[2]
Local aHeadSE2	:= PARAMIXB[3] 
Local lRet      := .f.  
Local nTxUSD 	:= 0

*'Vagner Almeida 24/07/13 (Inicio) -----------------------------------------------------------'*
If Type("__cPrvtContra") <> "L"                             
   _SetNamedPrvt( "__cPrvtContra" , .f. , "MATA103" ) 
   _SetNamedPrvt( "__cPrvtCtrT"   , .f. , "MATA103" ) 
EndIf   
*'Vagner Almeida 24/07/13 (Fim) --------------------------------------------------------------'*

*'Luis Felipe Nascimento 24/07/13-------------------------------------------------------------'*
If nOpc == 1 .and. FunName() == "MATA103"
	SC7->( DbSetOrder(1) ) 
	SC7->( DbSeek(xFilial("SC7")+SF1->F1_XPEDIDO) )
	RecLock("SE2",.F.) 
	SE2->E2_HIST := SC7->C7_OBS    	
	MsUnLock()
EndIf
*'Luis Felipe Nascimento 24/07/13-------------------------------------------------------------'*

*'Vagner Almeida 24/07/13 (Inicio) -----------------------------------------------------------'*
If !__cPrvtContra .And. FunName() <> "EDFA001"  // 20/09/13 - Luís Felipe Nascimento
	//If MSgYesNo("Deseja Gravar o Número do Contrato?","Selecione")
	lRet := MSgYesNo("Deseja Gravar o Número do Contrato?","Selecione")
	__cPrvtContra := .t.
EndIf

If lRet
   Grv_E2_CTR()
Endif         
*'Vagner Almeida 24/07/13 (Fim) --------------------------------------------------------------'*

//Para os casos de importacao de conhecimento de Frete grava somente na tabela SF1 - Atualizacao para gravar na SE2
If !Empty(SF1->F1_CONTRA)
	dbSelectarea("SE2")
	RecLock("SE2",.F.) 
	SE2->E2_CONTRA := SF1->F1_CONTRA		
	SE2->E2_XCONTRA := Posicione("SD1",1,xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"D1_COD")
	SE2->E2_HIST   := SC7->C7_OBS    	
	MsUnLock()
EndIf

*'Yttalo P Martins-INICIO---------------------------------------------------------------------'*

//Inclusão do código de barras do boleto recebido----------------------------------------------
//INICIO-07/07/14-Yttalo P Martins-------------------------------------------------------------
IF ALLTRIM(FunName()) <> "EDFA001"
	xGrvCodBar()
ENDIF

//FIM-07/07/14-Yttalo P Martins----------------------------------------------------------------

dbSelectarea("SE2")                                                                     
RecLock("SE2",.F.)                                                                            
	SE2->E2_XDESCGR := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_XDESCGR")
	// 18/11/13 - Luis Felipe Nascimento / Luiz pereira - 01_06_15 
	SE2->E2_XDOLAR  := Posicione(("SM2"),1,dDataBase,"M2_MOEDA2") //Posicione("SM2",1,DtoS(dDatabase),"M2_MOEDA2") 
If !Empty(SF1->F1_CONTRA) // 10/06/15 - Luiz Fernando
	SE2->E2_XCONTRA := Posicione("SD1",1,xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,"D1_COD")
Endif	

//D1_FILIAL+DTOS(D1_EMISSAO)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA

MsUnLock("SE2")                                                                                     


*'Yttalo P Martins-FIM------------------------------------------------------------------------'*

RestArea(__aArea)
RestArea(_aAreaSA2)

Return         

Static Function Grv_E2_CTR()

Local   oEdit1                                   
Local   cEdit1	 := Space(25)
Local   _aArea   := {}
Local   _aAlias  := {}
Private _oDlg

*'Vagner Almeida- INICIO- 24-07-2013 ------------------------------------------------------------------------------------'*

If !__cPrvtCtrT

   __cPrvtCtrT := .t. 

   DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Informações Adicionais") FROM C(271),C(293) TO C(399),C(614) PIXEL

	   // Cria Componentes Padroes do Sistema

	   @ C(012),C(088) MsGet oEdit1 Var cEdit1 F3 "CN9" valid !empty(cEdit1) Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlg
	   @ C(013),C(007) Say "Informe o Número do Contrato: " Size C(076),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	   DEFINE SBUTTON FROM C(035),C(121) TYPE 2 ENABLE OF _oDlg ACTION (lRet:=.f.,_oDlg:End())
	   DEFINE SBUTTON FROM C(036),C(082) TYPE 1 ENABLE OF _oDlg ACTION (lRet:=.t.,_oDlg:End())

   ACTIVATE MSDIALOG _oDlg CENTERED 
   
EndIf   

*'Vagner Almeida- Fim - 24-07-2013---------------------------------------------------------------------------------------'*

// GRAVA NO FINANCEIRO O NUMERO DO CONTRATO INFORMADO 

dbSelectarea("SE2")
//MsUnLock() 11/12/13 - Luis Felipe Nascimento
RecLock("SE2",.F.) 
  SE2->E2_CONTRA := cEdit1
MsUnLock()                                 

dbSelectarea("SF1")
MsUnLock()
RecLock("SF1",.F.) 
SF1->F1_CONTRA := cEdit1
MsUnLock()                                    
   
Return(.T.)

Static Function C(nTam)                                                         

Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor      

Do Case                                                                         
	Case nHRes == 640	//Resolucao 640x480                                         
		nTam *= 0.8                                                                
	Case nHRes == 800	//Resolucao 800x600                                         
		nTam *= 1                                                                  
	OtherWise			//Resolucao 1024x768 e acima                                
		nTam *= 1.28                                                               
EndCase                                                                         

Return Int(nTam)

**************************************************************************************************************************************************
//Inclusão do código de barras do boleto recebido----------------------------------------------
//07/07/14-Yttalo P Martins-------------------------------------------------------------
Static Function xGrvCodBar()

local oDlg
local _nOpc    := 0
local _cCodbar := SPACE( TAMSX3("F1_XCODBAR")[1] )

DEFINE MSDIALOG oDlg TITLE "Código de Barra do Boleto " FROM 000,000 TO 120,355 PIXEL
@ 010,009 Say   "Cod. Barra:"              Size 075,008 OF oDlg PIXEL 
@ 022,009 MSGET _cCodbar    Size 160,010 OF oDlg PIXEL PICTURE "@!" 
@ 040,080 Button "OK"                Size 040,012 PIXEL OF oDlg Action(_nOpc := 1,oDlg:End())
@ 040,130 Button "Cancelar"     Size 040,012 PIXEL OF oDlg Action oDlg:end()

ACTIVATE MSDIALOG oDlg CENTERED

If _nOpc == 1
	
	dbSelectarea("SE2")
	RecLock("SE2",.F.) 
	SE2->E2_XLINDIG := _cCodbar
	MsUnLock()	
	    
	_cCodbar := xConvld(_cCodbar) //static function neste PE 
	
	dbSelectarea("SF1")
	MsUnLock()
	RecLock("SF1",.F.) 
	SF1->F1_XCODBAR := _cCodbar
	MsUnLock()	                                   
		
	dbSelectarea("SE2")
	RecLock("SE2",.F.) 
	SE2->E2_CODBAR := _cCodbar
	MsUnLock()                                 

Endif

Return

//--------------------------------------------------------------------------------------------------------------------
//Função para Conversão da Representação Numérica do Código de Barras - Linha Digitável (LD) em Código de Barras (CB).
//--------------------------------------------------------------------------------------------------------------------
STATIC FUNCTION xConvld(_cCodbar)

LOCAL cStr := LTrim(RTrim(_cCodbar))

If ValType(_cCodbar) == Nil .OR. Empty(_cCodbar)
	// Se o Campo está em Branco não Converte nada.
	cStr := ""
Else
	// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
	// necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
	cStr := IIf(Len(cStr) < 44, cStr + REPL("0", 47 - Len(cStr)), cStr)
EndIf

Do Case
Case Len(cStr) == 47
	cStr := SubStr(cStr,1,4) + SubStr(cStr,33,15) + SubStr(cStr,5,5) + SubStr(cStr,11,10) + SubStr(cStr,22,10)
Case Len(cStr) == 48
	cStr := SubStr(cStr,1,11) + SubStr(cStr,13,11) + SubStr(cStr,25,11) + SubStr(cStr,37,11)
Otherwise
	cStr := cStr + SPACE(48 - LEN(cStr))
EndCase

RETURN(cStr)

**************************************************************************************************************************************************
/*

User Function MT100GE2 

Local aCols 	:= PARAMIXB[1]
Local nOpc  	:= PARAMIXB[2]
Local aHeadSE2	:= PARAMIXB[3] 

//.....Exemplo de customizaçãoLocal 
nPos := Ascan(aHeadSE2,{|x| Alltrim(x[2]) == 'E2_OBS'})  

If nOpc == 1 //.. inclusao       
	SE2->E2_OBS:=aCols[nPos]
EndIf 

Return Nil

*/