#INCLUDE "PROTHEUS.ch"
#INCLUDE "APWEBEX.CH"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณRELCONTAINบ Autor ณ Milton Nishimoto   บ Data ณ  06/06/13   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ                                                            บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function RELCONTAIN()

SetPrvt("CQUERY, cPerg, X, aVet, cPeriodo, aCabec, aDados, aQuem")

cPerg:= "RELCONTAIN"
aCabec := {}
aQuem := {'Dt Emissใo','Dt Vencimento'}
ValidPerg()

Pergunte( cPerg,.t. )                                                

If MsgYesNo("Gerar Planilha Informa็oes dos Containers X Aloca็ใo?")
                               
    AaDd( aCabec, "BOOKING")
    AaDd( aCabec, "FORNECEDOR(USINA)")
    AaDd( aCabec, "NOTA FISCAL")
    AaDd( aCabec, "VOLUME")
    AaDd( aCabec, "EMISSAO")
    AaDd( aCabec, "FALTAS")
	AaDd( aCabec, "AVARIAS")
	AaDd( aCabec, "SOBRAS")

	cQuery := " "
	cQuery += " SELECT ZB.*, F1_EMISSAO,A2_NOME "
	cQuery += " FROM SZB010 ZB"
	cQuery += " INNER JOIN SF1010 F1 ON F1_DOC+F1_SERIE+F1_FORNECE = ZB_NF+ZB_SERIE+ZB_FORNECE AND F1.D_E_L_E_T_ <> '*'"
	cQuery += " INNER JOIN SA2010 A2 ON ZB_FORNECE = A2_COD AND A2.D_E_L_E_T_ <> '*'"
	cQuery += " WHERE ZB.D_E_L_E_T_ <> '*'"
	cQuery += " AND ZB_BOOKING = '"+(mv_par01)+"'"
	
    If SELECT("TMA") > 0 
       TMA->( dbCloseArea() )
    Endif

//	TCQUERY cQuery NEW ALIAS "TMA"

	cQuery := ChangeQuery(cQuery)

	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMA",.F.,.T.)
	
	DbSelectArea("TMA")                                                           	
	TMA->(DbGoTop())
                       
    aDados := {}
    cMesAno := ""
    nValor := 0
    nFalta	:= 0
    nAvaria	:= 0
    nSobra	:= 0
	While TMA->( !EOF() )     
		AaDd( aDados, {TMA->ZB_BOOKING,TMA->ZB_FORNECE+' '+TMA->A2_NOME,TMA->ZB_NF,TMA->ZB_QTDENF,DTOC(STOD(TMA->F1_EMISSAO)),TMA->ZB_FALTA,TMA->ZB_AVARIA,TMA->ZB_SOBRA})
		nValor	+= TMA->ZB_QTDENF		
		nFalta	+= TMA->ZB_FALTA
   		nAvaria	+= TMA->ZB_AVARIA
	    nSobra	+= TMA->ZB_SOBRA 
    	TMA->( DBSKIP() )
	Enddo
	AaDd( aDados, {"TOTAL/CARGA:","","",nValor-nFalta-nAvaria+nSobra,})
	//AaDd( aDados, {"", "", "", "","","",iif(nValor==0,"",nValor)} )
	//Segundo cabecalho
	AaDd( aDados, {""})
	AaDd( aDados, {""})
	AaDd( aDados, {"CONTAINER","LACRE","TARA","NOTA FISCAL","VOLUME PARCIAL","VOLUME TOTAL"})

	cQuery := " "
	cQuery += " SELECT * "
	cQuery += " FROM "+RetSqlName("SZC")+" ZC"
	cQuery += " INNER JOIN "+RetSqlName("ZZ1")+" ZZ1 ON ZZ1_NRCNTR = ZC_CONTAIN AND ZZ1_PREEMB = ZC_BOOKING AND ZZ1.D_E_L_E_T_ <> '*'"
	cQuery += " WHERE ZC.D_E_L_E_T_ <> '*'"
	cQuery += " AND ZC_BOOKING = '"+(mv_par01)+"'"
	
    If SELECT("TMA") > 0 
       TMA->( dbCloseArea() )
    Endif
	cQuery := ChangeQuery(cQuery)

	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMA",.F.,.T.)
	
	DbSelectArea("TMA")                                                           	
	TMA->(DbGoTop())
    nValor := 0
    While TMA->( !EOF() )     
			AaDd( aDados, {TMA->ZC_CONTAIN,TMA->ZZ1_LACRE,TMA->ZZ1_TARA,TMA->ZC_NF,TMA->ZC_QTDALOC,TMA->ZZ1_QTDEMB})
			nValor += TMA->ZC_QTDALOC
			TMA->( DBSKIP() )
	Enddo
	AaDd( aDados, {"TOTAL ALOCADO","","","",nValor})
	
	DlgToExcel( { { "ARRAY", "Relat๓rio Containers x Aloca็ใo ", aCabec, aDados} })                                  
	TMA->( dbCloseArea() )
	MsgAlert("Relatorio Finalizado com Sucesso...")
Else	
	MsgAlert("Gera็ใo Abortada pelo usuแrio!")
	
endif


Return 


Static Function ValidPerg
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}              

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Booking "   , "Booking   ", "Booking   ","mv_ch1"  ,"C",20,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","SZ0","SZ1","SZA"})
//aAdd(aReg,{cPerg,"08","Banco de?          ","mv_ch8","C",03,0,0,"G","",						"mv_par08","","","","","","","","","","","","","","","SA6"})
//AADD(aRegs,{cPerg,"02","Data ate:  "   , "Data ate   ", "Data ate   "      ,"mv_ch2","D",08,0,0,"G","NAOVAZIO()","mv_par02","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
		  if j < 39 
			FieldPut(j,aRegs[i,j])
		  endif
		Next
		MsUnlock()
        dbCommit()
	Endif
Next

dbSelectArea(_sAlias)

Return