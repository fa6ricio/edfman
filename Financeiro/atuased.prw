/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUASED F3บAutor  ณFabiano Migoto        Data ณ  02/02/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para atualizacao das naturezas financeiras de      บฑฑ
ฑฑบ          ณPara                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AtuaSED()

If MsgYesNo('Deseja realmente continuar atualiza็ใo da natureza financeira?','Pergunta')
	DbSelectArea("SX3")
	DbSetOrder(2)
	If !DbSeek("ED_NOVANAT")
		Alert("O campo ED_NOVANAT nใo esta criado!")
		Return
	Endif
	_lSIMULA:=MsgYesNo('Deseja SOMENTE SIMULAR?','Pergunta')
	
	Processa( {|| AtuaSDEa()},"Conferindo Tabelas...")
Endif
Return
************************************************************************************
Static Function AtuaSDEa()
************************************************************************************
Local 	_aExist   :={}
Local   _aLogimp1 :={}
Local   _aTitulo
Local   _cTMP0 := "TRB0"

If SELECT("TRB0") <> 0
	TRB0->(DbCloseArea())
EndIf
If SELECT("TRB1") <> 0
	TRB1->(DbCloseArea())
EndIf

DbselectArea("SED")
DbSetOrder(1)

cFilDe := xFilial("SED")
cFilAte := xFilial("SED")

BeginSql alias _cTMP0
		SELECT *
		FROM %table:SED% SED
		WHERE  SED.ED_FILIAL BETWEEN %exp:cFilDe% AND %exp:cFilAte%
			   AND SED.%notDel%
EndSql

DBSELECTAREA( _cTMP0 )
ProcRegua(Reccount())
DbGotop()
While !Eof()                                          
	IncProc("Analisando a natureza: "+TRB0->ED_CODIGO)

/*
	If Empty(TRB0->ED_NOVANAT) .AND. Empty(TRB0->ED_MSBLQL) .AND. LEN(TRB0->ED_CODIGO) >= 8
		Alert("A natureza: "+TRB0->ED_CODIGO+" esta sem a natureza nova!")
	Endif
*/
	DbSelectArea("SED")
	If DbSeek(xFilial("SED")+TRB0->ED_NOVANAT) .and. SED->ED_NOVANAT  <> SED->ED_CODIGO
//		Alert("A natureza nova: "+TRB0->ED_NOVANAT+" existe no cadastro antigo e sera desconsiderada na atualiza็ใo!")
		AADD(_aExist,TRB0->ED_NOVANAT)
	Endif

	DbSelectArea("TRB0")
	DbSkip()
End

Private _aCampSED:={}
AADD(_aCampSED,{'ACG','ACG_NATURE',0})
AADD(_aCampSED,{'AFP','AFP_NATURE',0})
AADD(_aCampSED,{'BA0','BA0_NATURE',0})
AADD(_aCampSED,{'BA3','BA3_NATURE',0})
AADD(_aCampSED,{'BAU','BAU_NATURE',0})
AADD(_aCampSED,{'BG9','BG9_NATURE',0})
AADD(_aCampSED,{'BI3','BI3_NATURE',0})
AADD(_aCampSED,{'BMW','BMW_NATURE',0})
AADD(_aCampSED,{'BQC','BQC_NATURE',0})
AADD(_aCampSED,{'BT5','BT5_NATURE',0})
AADD(_aCampSED,{'BTV','BTV_NATURE',0})
AADD(_aCampSED,{'FT8','FT8_NATURE',0})
AADD(_aCampSED,{'FTD','FTD_NATURE',0})
AADD(_aCampSED,{'FTE','FTE_NATURE',0})
AADD(_aCampSED,{'FTF','FTF_NATURE',0})
AADD(_aCampSED,{'FTR','FTR_NATURE',0})
AADD(_aCampSED,{'JI7','JI7_NATURE',0})
AADD(_aCampSED,{'N15','N15_NATURE',0})
AADD(_aCampSED,{'NO1','NO1_NATURE',0})
AADD(_aCampSED,{'NO3','NO3_NATURE',0})
AADD(_aCampSED,{'NO7','NO7_NATURE',0})
AADD(_aCampSED,{'NO8','NO8_NATURE',0})
AADD(_aCampSED,{'NOA','NOA_NATURE',0})
AADD(_aCampSED,{'RC0','RC0_NATURE',0})
AADD(_aCampSED,{'RC1','RC1_NATURE',0})
AADD(_aCampSED,{'SA1','A1_NATUREZ',0})
AADD(_aCampSED,{'SA2','A2_NATUREZ',0})
AADD(_aCampSED,{'SC5','C5_NATUREZ',0})
AADD(_aCampSED,{'SE1','E1_NATUREZ',0})
AADD(_aCampSED,{'SE2','E2_NATUREZ',0})
AADD(_aCampSED,{'SE5','E5_NATUREZ',0})
AADD(_aCampSED,{'SE7','E7_NATUREZ',0})
AADD(_aCampSED,{'SEH','EH_NATUREZ',0})
AADD(_aCampSED,{'SEI','EI_NATUREZ',0})
AADD(_aCampSED,{'SEL','EL_NATUREZ',0})
AADD(_aCampSED,{'SET','ET_NATUREZ',0})
AADD(_aCampSED,{'SEV','EV_NATUREZ',0})
AADD(_aCampSED,{'SEW','EW_NATUREZ',0})
AADD(_aCampSED,{'SEZ','EZ_NATUREZ',0})
AADD(_aCampSED,{'SK0','K0_NATUREZ',0})
AADD(_aCampSED,{'SK1','K1_NATUREZ',0})
AADD(_aCampSED,{'SLJ','LJ_NATUREZ',0})
AADD(_aCampSED,{'SUS','US_NATUREZ',0})
AADD(_aCampSED,{'SY5','Y5_NATUREZ',0})
AADD(_aCampSED,{'VO4','VO4_NATURE',0})
AADD(_aCampSED,{'VVD','VVD_NATURE',0})
AADD(_aCampSED,{'VVF','VVF_NATURE',0})

Private _acampos1	:= {{"TABELA"  ,"C",	003,	0 },;
{"CAMPO"  ,"C",	10,	0 },;
{"_RECNO"  ,"N",	15,	0 },;
{"FEITO"  ,"C",	01,	0 },;
{"DESC"  ,"C",	30,	0 },;
{"NEW"  ,"C",	10,	0 },;
{"OLD"  ,"C",	10,	0 }}

cTMP1:="TRB1"
oTMP1:= FwTemporarytable():New(cTMP1,_acampos1)
oTMP1:Create()

ProcRegua(Len(_aCampSED))

For _iAtu:=1 to Len(_aCampSED)
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek(_aCampSED[_iAtu,2])
	DbSelectArea(_aCampSED[_iAtu,1])
	DbSetOrder(1)
	If DbSeek(xFilial(_aCampSED[_iAtu,1]))
		While !Eof() .and. If("FILIAL"$_aCampSED[_iAtu,2],xFilial(_aCampSED[_iAtu,1])=&(_aCampSED[_iAtu,1]+'->'+Alltrim(_aCampSED[_iAtu,2])),.T.)
			DbSelectArea("SED")
			DbSetOrder(1)
			If DbSeek(xFilial("SED")+&(_aCampSED[_iAtu,1]+"->"+_aCampSED[_iAtu,2]))
				If Empty(SED->ED_NOVANAT)
					_fGrava(_aCampSED[_iAtu],"",SED->ED_CODIGO,"N","Vazia",SED->(Recno()) )
				Else
					If Ascan(_aExist,SED->ED_CODIGO)<>0
						//_fGrava(_aCampSED[_iAtu],&(_aCampSED[_iAtu,1]+"->(Recno())"),SED->ED_CODIGO,"N","Novo igual antigo!",&(_aCampSED[_iAtu,1]+"->(Recno())"))
					Else
						_aCampSED[_iAtu,3]:=_aCampSED[_iAtu,3]+1
						_fGrava(_aCampSED[_iAtu],SED->ED_NOVANAT,SED->ED_CODIGO,"S","Ok!",&(_aCampSED[_iAtu,1]+"->(Recno())"))
					Endif
				Endif
			Else
				_fGrava(_aCampSED[_iAtu],"",&(_aCampSED[_iAtu,1]+"->"+_aCampSED[_iAtu,2]),"N","Sem Cadastro",&(_aCampSED[_iAtu,1]+"->(Recno())"))
			Endif
			DbSelectArea(_aCampSED[_iAtu,1])
			DbSkip()
		End
	Else
		_fGrava(_aCampSED[_iAtu],"","","N","Sem X3",0)
	Endif
	
	AADD(_aLogimp1,{_aCampSED[_iAtu,1]+"  "+_aCampSED[_iAtu,2]+" "+StrZero(_aCampSED[_iAtu,3],6,0)+" Registros!" })
	If  _iAtu < Len(_aCampSED)
		
		IncProc("Atualizando dados...."+_aCampSED[_iAtu+1,1])
		
	Endif
Next

If len(_aLogimp1)>0
	
	DbSelectArea("TRB1")
	
	IncProc("Criando log....")
	
	If MsgYesNo('Apresenta็ใo do log de tabelas: '+strzero(len(_aLogimp1),4,0)+' deseja continuar?','Pergunta')
		_aTitulo  := {"Log de tabelas e arquivo gerado: "}
		FMakeLog(_aLogImp1,_aTitulo," ",.T.," "," ","P","P","aReturn",.F.)
		Return
	Endif
	
Endif

Return Nil

**************************************************************************************
Static Function  _fGrava(_aTabela,_cNova,_cVelha,_cFez,_cDescr,_nRecno)
**************************************************************************************
Local _aOldArea:=GetArea()

DbSelectArea("TRB1")

If RecLock("TRB1",.t.)
	
	TRB1->TABELA  := _aTabela[1]
	TRB1->CAMPO   := _aTabela[2]
	TRB1->_RECNO  := _nRecno
	TRB1->FEITO   := _cFez
	TRB1->DESC    := _cDescr
	TRB1->NEW     := _cNova
	TRB1->OLD     := _cVelha
	
	MSUnlock()

	If !_lSIMULA .and. _cFez="S"
		DbSelectArea(_aTabela[1])
		If RecLock(_aTabela[1],.f.)
			&(Alltrim(_aTabela[1])+"->"+Alltrim(_aTabela[2])):=_cNova
			DbUnlock()
		Endif
		
	Endif
Endif
RestArea(_aOldArea)
Return
