#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'  
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA017   ºAutor  ³Leandro Ribeiro     º Data ³  05/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para Calculo de Variação Cambial de Contratos ACC e º±±
±±º          ³ contabilização.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                                                      

User Function EDFA017()

Local aCpos		:= {}
Local aCampos	:= {}
Local aArea     := GetArea()
Local aAreaEF1  := EF1->(GetArea())            
Local aCampos	:= NomeCampo() 
Local _cQuery1  := ""    
Local cTrab1  	:= GetNextAlias() 
Local TRBC  	:= GetNextAlias()
Local _cArqEmp  := "" 
Local _aStruTrb := {} 
Local _aBrowse  := {} 
Local _aEmpMigr := {}

Local _lRetorno := .F. //Validacao da dialog criada oDlg
Local _nOpca 	:= 0 //Opcao da confirmacao
Local bOk 		:= {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() } //botao de ok
Local bCancel	:= {|| _nOpca:=0,oDlg:End() }        
Local lRet		:= .F.  
//Local _cPriDia  := DtoS(FirstDay(Ddatabase)) 
//Local _cUltDia  := DtoS(LastDay(Ddatabase)) 
Local _cPriDia  := AllTrim(STR(Val(Substr(DTOS(Ddatabase),1,6))-1))+"01" 
Local _cUltDia  := DTOS(LastDate(CTOD(Alltrim(Strzero((Val(Day2Str(Ddatabase))-1),2))+"/"+Alltrim(Strzero((Val(Month2Str(Ddatabase))-1),2))+"/"+Year2Str(Ddatabase)))) 
                       
Private aRotina    := {}
Private cCadastro  := "Calculo Automatico de Variação Cambial"
Private cMarca     := GetMark()    
Private lInverte   := .F.
Private aRecSel    := {} 
Private oBrwTrb       
Private oDlg
           
aRotina := { {"Processar","EDFA017C()",0,1}}     

aadd(_aStruTrb,{"NCONTRA" 	,"C",15,0})
aadd(_aStruTrb,{"TIPFIN" 	,"C",02,0})
aadd(_aStruTrb,{"LOJA" 		,"C",02,0})
aadd(_aStruTrb,{"VLFIN" 	,"N",17,2})
aadd(_aStruTrb,{"OK"   		,"C",02,0})
aadd(_aStruTrb,{"TPMODU"	,"C",01,0})        
aadd(_aStruTrb,{"MOEDA"		,"C",03,0})   

aadd(_aBrowse,{"OK" 	,,"" 			 })
aadd(_aBrowse,{"NCONTRA",,"N. Contrato"  })
aadd(_aBrowse,{"TIPFIN"	,,"Tipo Financ." })
aadd(_aBrowse,{"LOJA" 	,,"Loja" 		 })
aadd(_aBrowse,{"VLFIN"	,,"Valor Finac.","@E 999,999,999.99" }) 

If Select("TRB") > 0
 
TRB->(DbCloseArea()) 

Endif

_cArqEmp := "TRB"
oArqEmp:= FwTemporarytable():New(_cArqEmp,_aStruTrb)
oArqEmp:Create()

                                    
//+----------------------------------------------------------------------------
//| Monta o filtro especifico para MarkBrow()
//+----------------------------------------------------------------------------

_cQuery1 := " SELECT DISTINCT EF1.* " + c_ent 
_cQuery1 += " FROM " +RETSQLNAME("EF1")+ " EF1 " + c_ent
_cQuery1 += " INNER JOIN "+ RETSQLNAME("EF2") +" EF2 " + c_ent
_cQuery1 += " ON EF2_CONTRA = EF2_CONTRA " + c_ent
_cQuery1 += " INNER JOIN "+ RETSQLNAME("EF3") +" EF3 " + c_ent
_cQuery1 += " ON EF2_CONTRA = EF3_CONTRA " + c_ent
_cQuery1 += " WHERE " + c_ent 
// _cQuery1 += " EF3_DT_EVE BETWEEN '"+_cPriDia+"' AND '"+_cUltDia+"'" + c_ent   // 06/07/15 - Luis Felipe
_cQuery1 += " EF1_SLD_PM <> 0 " + c_ent 
_cQuery1 += " AND EF1_XDATAC <= '"+AllTrim(STR(Val(Substr(DTOS(Ddatabase),1,6))-1))+"'" + c_ent 
_cQuery1 += " AND EF1.D_E_L_E_T_ = ' ' " + c_ent
_cQuery1 += " AND EF2.D_E_L_E_T_ = ' ' " + c_ent 
_cQuery1 += " AND EF3.D_E_L_E_T_ = ' ' " + c_ent 
_cQuery1 += " ORDER BY EF1_CONTRA " + c_ent 
_cQuery1 := ChangeQuery(_cQuery1)              

If Select(cTrab1) > 0
	dbSelectArea(cTrab1)
	(cTrab1)->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),cTrab1,.T.,.T.)

DbSelectArea(cTrab1)
If(!Eof())
	While (cTrab1)->(!Eof())
 
	RecLock("TRB",.T.)
 		TRB->OK      := space(2)
		TRB->NCONTRA := (cTrab1)->EF1_CONTRA
		TRB->TIPFIN  := (cTrab1)->EF1_TP_FIN
		TRB->LOJA    := (cTrab1)->EF1_LOJA
		TRB->VLFIN   := (cTrab1)->EF1_VL_MOE  
		TRB->TPMODU	 := (cTrab1)->EF1_TPMODU
		TRB->MOEDA	 := (cTrab1)->EF1_MOEDA
	MsUnlock()

	(cTrab1)->(DbSkip())
 
	Enddo 
EndIf

(cTrab1)->(dbCloseArea())

@ 001,001 TO 400,700 DIALOG oDlg TITLE OemToAnsi("Calculo Automatico de Variação Cambial")
 
@ 015,005 SAY OemToAnsi("Selecione Contrato(s) para o Calculo de Variação Cambial: ")      

oBrwTrb := MsSelect():New("TRB","OK","",_aBrowse,@lInverte,@cMarca,{025,001,170,350})
 
oBrwTrb:oBrowse:lCanAllmark := .T.
 
Eval(oBrwTrb:oBrowse:bGoTop)
 
oBrwTrb:oBrowse:Refresh()   

Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,)) Centered VALID _lRetorno
 
TRB->(DbGotop())
 
If _nOpca == 1

	Do While TRB->(!Eof())
		If !Empty(TRB->OK)//se usuario marcou o registro
			aAdd(_aEmpMigr,{TRB->NCONTRA,TRB->TPMODU,TRB->MOEDA})
		EndIf
		TRB->(DbSkip())
	EndDo   

	If(!Len(_aEmpMigr) < 0)
		Processa({||lRet := EDFA017C(_aEmpMigr)},"Calculando a Variação...")
		If(lRet)
			Aviso("Aviso","Finalizado Processo de Calculo de Variação Cambial.",{"OK"})
		Else 
			Aviso("Erro","Não houve contabilização.",{"OK"})
		EndIf
	Else
		Aviso("Aviso","Nenhum Contrato Selecionado!",{"Ok"})
	EndIf	

EndIf    


//fecha area de trabalho e arquivo temporário criados
 
If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
	Ferase(_cArqEmp+OrdBagExt())    
EndIf


RestArea( aAreaEF1 )
RestArea( aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA017   ºAutor  ³Leandro Ribeiro     º Data ³  05/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para realizar o calculo e a contabilização.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EDFA017C(_cContra)
                                   
Local _cEDFA017C := GetArea()    
Local _cMesAnt   := LastDate(CToD(Day2Str(Ddatabase)+"/"+Alltrim(Strzero((Val(Month2Str(Ddatabase))-1),2))+"/"+Year2Str(Ddatabase)))
Local _nTaxUlt   := "" 
Local _cHistLote := "VC NAO REALIZADA "   
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
Local _lRet	     := .F. 
Local _nTaxUltV  := 0 
Local _nTaxUlt   := 0 
Local _cc		 := 0
                                   
Local oDoc
Local oLote  
Local oSubLote  

Local cArquivo  := ""
Local nHdlPrv   := 0 

Local _cRotina  := aRotina
                                            
Private cSubLote   := ""                    
Private cPadrao    := GetMv("MV_XCALACC")
Private nTotInf             
Private cLoteSub   := GetMv("MV_SUBLOTE")
Private lSubLote   := .F.          
Private __lCusto := .F.
Private __lItem    := .F.
Private __lCLVL	   := .F.
Private aTotRdpe   := {{0,0,0,0},{0,0,0,0}}         
Private _cChaveEF1 := ""
Private _cNumContr := ""
      
Private aHeader	 := {}    
Private oGetDB 
Private dDataLanc := Ddatabase  
Private _xxRet    := .F.
Private aRotina	  := {} 
Private _cNumSeq  := "" 

Public  _lNegativo:= .f.
Public  _cVincula := .f.

   aAdd(aRotina, { "Pesquisar"      , "AxPesqui"  , 			 0, 1})//"Pesquisar"
   aAdd(aRotina, { "Visualizar"     , "EX400Manut", 			 0, 2})//"Visualizar"
   aAdd(aRotina, { "Incluir"        , "EX400Manut", 			 0, 3})//"Incluir"
   aAdd(aRotina, { "Alterar"        , "EX400Manut", 			 0, 4})//"Alterar"
   aAdd(aRotina, { "Estornar"       , "EX400Manut", 			 0, 5})//"Estornar"
   aAdd(aRotina, { "Histórico"      , "EX400CHist", 			 0, 6})//"Histórico"
   aAdd(aRotina, { "Copiar"         , "EX401Copia", 			 0, 7})//"Copiar"
   aAdd(aRotina, { "Tot.p/Contrato" , "EX401TotCo", 			 0, 8})//"Tot.p/Contrato" 
                                                                                           
ProcRegua(20)

If(Substr(DTOS(Ddatabase),1,6) == Substr(DTOS(Ddatabase),1,4)+"01") 
	_cMesAnt := LastDate(CToD(Day2Str(Ddatabase)+"/12/"+Year2Str(Ddatabase)))
Else
	_cMesAnt := LastDate(CToD(Day2Str(Ddatabase)+"/"+Alltrim(Strzero((Val(Month2Str(Ddatabase))-1),2))+"/"+Year2Str(Ddatabase)))
EndIf
                                           
For _cc := 1 to Len(_cContra)  
    
	ProcRegua(Len(_cContra))
	IncProc()       
   
   	_nTaxUltV := u_EDFA017E(_cContra[_cc][1]) 
	    
	    If(_nTaxUltV == 0)   	
   	    	_nTaxUltV := EDFA017F(_cContra[_cc][1])
   	 	EndIf    

		DbSelectArea("SYE")
		DbSetOrder(1)
		If(DbSeek(xFilial("SYE")+DTOS(Ddatabase)+_cContra[_cc][3])) 
	
			_nTaxUlt := SYE->YE_VLCON_C 
	
		EndIf         
		
	If(Empty(_nTaxUlt))      
		Aviso("Aviso","Não existe taxa para o dia de hoje, favor verificar!",{"Ok"})
		Return()	
	EndIf

	DbSelectArea("EF1")
	DbSetOrder(1)
	If(DbSeek(xFilial("EF1")+PADR(_cContra[_cc][2],TAMSX3("EF1_TPMODU")[1])+PADR(_cContra[_cc][1],TAMSX3("EF1_CONTRA")[1])))
		
		DbSelectArea("EF3")
		DbSetOrder(1)
		If(DbSeek(xFilial("EF3")+PADR(_cContra[_cc][2],TAMSX3("EF1_TPMODU")[1])+PADR(_cContra[_cc][1],TAMSX3("EF1_CONTRA")[1])))                  

//	     	nTotInf := (EF1->EF1_SLD_PM * _nTaxUltV) - (EF1->EF1_SLD_PM * _nTaxUlt) // 02/07/15 - Luis Felipe - Regra invertida, quanto as taxas.
	     	nTotInf := (EF1->EF1_SLD_PM * _nTaxUlt) - (EF1->EF1_SLD_PM * _nTaxUltV)
	
		EndIf
	EndIf                
                                                                                                                                
    If(nTotInf <> 0)
    
    	_lNegativo := If(nTotInf<0,.t.,.f.) // 30/09/15 - Luis Felipe
    	
    	_cNumContr := Alltrim(EF1->EF1_CONTRA)
	    
	    _cChaveEF1 := xFilial("EF1")+PADR(_cContra[_cc][2],TAMSX3("EF1_TPMODU")[1])+PADR(_cContra[_cc][1],TAMSX3("EF1_CONTRA")[1])	                                                                                               
	    
	    C050Next(Ddatabase,@_cLote,@cSubLote,@_cDoc,oLote,oSubLote,oDoc,@CTF_LOCK,_cOpc,1)
	    
	    Ctba102Lan(_cOpc,Ddatabase,_cLote,cSubLote,_cDoc,"CT2",_nReg,CTF_LOCK,cPadrao,If(_lNegativo,nTotInf * -1,nTotInf),cCodSeq,_cHistLote)    
	    
	    _lRet := _xxRet   
	    
	    If(_lRet) 
	        _cNumSeq := IIf(Empty(_cNumSeq),"0001",STRZERO(Val(_cNumSeq)+1,4))	    	
	    	U_EDFA017D(_nTaxUlt,EF3->EF3_MOE_IN,EF3->EF3_PRACA,EF3->EF3_TPMODU,EF1->EF1_SEQCNT,EF3->EF3_BAN_FI,EF3->EF3_AGENFI,EF3->EF3_NCONFI,_cNumSeq)//Gravação da contabilização na EF3
	    EndIf
	EndIf
	
	_nTaxUltV := 0     

	("SYE")->(dbCloseArea())	    
	("EF1")->(dbCloseArea())
	("EF3")->(dbCloseArea())                                                                                   

Next _cc    

aRotina := _cRotina

RestArea(_cEDFA017C)

Return(_lRet)         
                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA017   ºAutor  ³Leandro Ribeiro     º Data ³  07/28/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para incluir a linha do contrato 777.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA017D(_nTaxUlt,_cMoein,_cPraca,_cTpmodu,_cSeqcnt,_cBanfi,_cAgenfi,_cNconfi,__cNumSeq) 

Local _cEF3Key := xFilial("EF3")+PADR(_cTpmodu,TAMSX3("EF3_TPMODU")[1])+PADR(Alltrim(EF1->EF1_CONTRA),TAMSX3("EF3_CONTRA")[1])+;
		PADR(_cBanfi,TAMSX3("EF3_BAN_FI")[1])+PADR(_cPraca,TAMSX3("EF3_PRACA")[1])+PADR(_cSeqcnt,TAMSX3("EF3_SEQCNT")[1])+;
		PADR("777",TAMSX3("EF3_CODEVE")[1])+DTOS(Ddatabase) 

	DbSelectArea("EF3")
	DbSetOrder(11)
	If(!DbSeek(_cEF3Key))
		RecLock("EF3",.T.)
			EF3->EF3_FILIAL := xFilial("EF3")
			EF3->EF3_CONTRA := Alltrim(EF1->EF1_CONTRA)
			EF3->EF3_TP_EVE := "01"
			EF3->EF3_CODEVE := "777"
			EF3->EF3_TX_MOE := _nTaxUlt
			EF3->EF3_DT_EVE := Ddatabase
			EF3->EF3_SEQ	:= __cNumSeq
			EF3->EF3_MOE_IN := _cMoein
			EF3->EF3_PRACA  := _cPraca 
			EF3->EF3_TPMODU := _cTpmodu
			EF3->EF3_SEQCNT := _cSeqcnt
			EF3->EF3_VL_REA :=  nTotInf // IIf(nTotInf > 0, nTotInf * -1,nTotInf * -1)  // 30/06/15 - Luis Felipe
			EF3->EF3_BAN_FI := _cBanfi
			EF3->EF3_AGENFI := _cAgenfi
			EF3->EF3_NCONFI := _cNconfi
		MsUnlock()                     
	EndIf
        
DbSelectArea("CT2")
DbSetOrder(1)
If(DbSeek(_cKeyEF3))
	RecLock("CT2",.F.)
		CT2->CT2_XCHEF3 := _cEF3Key
    MsUnlock()
EndIf

Return()                
                                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA017   ºAutor  ³Leandro Ribeiro     º Data ³  05/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para retornar os campos para ser utilizados na ta-  º±±
±±º          ³ bela temporaria.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function NomeCampo()

Local aAreaCmp := GetArea()
Local ArrCamp  := {"EF1_CONTRA","EF1_TP_FIN","EF1_SEQ_CNT","EF1_LOJA","EF1_VL_MOE"}
Local _cCampos := {}
Local _nn 	   := 0

For _nn := 1 to Len(ArrCamp)
	If EF1->(FielPos(ArrCamp[_nn])) > 0
		Aadd(_cCampos,{ArrCamp[_nn],Nil,IIF(_nn==1,UPPER(Trim(GetSX3Cache(ArrCamp[_nn],"X3_TITULO"))),Trim(GetSX3Cache(ArrCamp[_nn],"X3_TITULO"))),Trim(GetSX3Cache(ArrCamp[_nn],"X3_PICTURE"))})
	Endif
Next _nn

RestArea(aAreaCmp)

Return(_cCampos)    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA017   ºAutor  ³Leandro Ribeiro     º Data ³  10/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para retornar a taxa da moeda da ultima variação    º±±
±±º          ³ cambial.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA017E(_cContrato) 

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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA017   ºAutor  ³Leandro Ribeiro     º Data ³  12/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para retornar a taxa de abertura do contrato para o º±±
±±º          ³ calculo da variação cambial.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
