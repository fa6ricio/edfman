#INCLUDE "PROTHEUS.ch"
#INCLUDE "APWEBEX.CH"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
//ฑฑบPrograma  ณ BRFAT001 บ Autor ณ Fabiano Migoto     บ Data ณ  31/01/11   บฑฑ
//ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
//ฑฑบDescricao ณ Relat๓rio de notas fiscais x complemento de pre็o          บฑฑ
//ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
//฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function BRFAT001()

SetPrvt("CQUERY, cPerg, X, aVet, cPeriodo, aCabec, aDados, aQuem")

cPerg:= "BRFAT00112"
aCabec := {}
aQuem := {'Dt Emissใo','Dt Vencimento'}
ValidPerg()

Pergunte( cPerg,.t. )                                                

If MsgYesNo("Gerar Planilha de Notas Fiscais?")
                               
    AaDd( aCabec, "NF ORIGINAL")
    AaDd( aCabec, "VALOR")
    AaDd( aCabec, "EMISSAO")
    AaDd( aCabec, "NF COMPLEMENTO")
    AaDd( aCabec, "EMISSAO")
    AaDd( aCabec, "VALOR")

	cQuery := " "
	cQuery += " SELECT D2_NFORI, "
	cQuery += " 	(SELECT F2_VALBRUT FROM "+RetSqlName("SF2")+" WHERE D_E_L_E_T_ = '' AND F2_DOC LIKE '%'+LTRIM(RTRIM(D2_NFORI))+'%') TOTAL_ORI, "
	cQuery += " 	(SELECT F2_EMISSAO FROM "+RetSqlName("SF2")+" WHERE D_E_L_E_T_ = '' AND F2_DOC LIKE '%'+LTRIM(RTRIM(D2_NFORI))+'%') EMISSAO_ORI, "
	cQuery += " 	D2_DOC, "
	cQuery += " 	(SELECT F2_EMISSAO FROM "+RetSqlName("SF2")+" WHERE D_E_L_E_T_ = '' AND F2_DOC = D2_DOC) EMISSAO_COM, "
	cQuery += " 	(SELECT F2_VALBRUT FROM "+RetSqlName("SF2")+" WHERE D_E_L_E_T_ = '' AND F2_DOC = D2_DOC) VALOR_COM "
	cQuery += " FROM "+RetSqlName("SD2")+" AS D2 INNER JOIN "+RetSqlName("SF2")+" AS F2 "
	cQuery += " 	ON F2_DOC LIKE '%'+LTRIM(RTRIM(D2_NFORI))+'%' "
	cQuery += " WHERE D2.D_E_L_E_T_ = '' "
	cQuery += "   AND F2.D_E_L_E_T_ = '' "
	cQuery += "   AND D2_NFORI <> '' "
	cQuery += "   AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += " ORDER BY D2.D2_NFORI "
	
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
	While TMA->( !EOF() )     
			AaDd( aDados, {TMA->D2_NFORI,TMA->TOTAL_ORI,DTOC(STOD(TMA->EMISSAO_ORI)),TMA->D2_DOC,DTOC(STOD(TMA->EMISSAO_COM)),STR(TMA->VALOR_COM,12,2)})
			nValor += TMA->VALOR_COM
			TMA->( DBSKIP() )		
	Enddo
	AaDd( aDados, {"", "", "", "","","",iif(nValor==0,"",nValor)} )

	DlgToExcel( { { "ARRAY", "Relat๓rio Nota Fiscal x Complementar ", aCabec, aDados} })                                  

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
AADD(aRegs,{cPerg,"01","Data de:   "   , "Data de    ", "Data de    "      ,"mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data ate:  "   , "Data ate   ", "Data ate   "      ,"mv_ch2","D",08,0,0,"G","NAOVAZIO()","mv_par02","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
		  if j < 28 
			FieldPut(j,aRegs[i,j])
		  endif
		Next
		MsUnlock()
        dbCommit()
	Endif
Next

dbSelectArea(_sAlias)

Return