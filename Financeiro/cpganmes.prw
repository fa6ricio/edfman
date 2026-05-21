#include "TOPCONN.CH"
#include "RWMAKE.CH"        

#DEFINE CRLF CHR(13)+CHR(10)      // Indica <Enter>

User Function CPGANMES()
SetPrvt("CQUERY, cPerg, X, aVet, cPeriodo, aCabec, aDados, aQuem")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ³±±
±±³Fun‡„o    ³CPGANMES³ Autor ³ Davi Jesus de Oliveira  ³ Data ³ 06/11/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Pagamentos Mes a mes Analitico                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

cPerg:= "mesmesANba"
aCabec := {}
aQuem := {'Dt Emissão','Dt Vencimento'}
ValidPerg()

Pergunte( cPerg,.t. )                                                

If MsgYesNo("Gerar Planilha de Pagamentos?")
                               
    AaDd( aCabec, "PREFIXO")
    AaDd( aCabec, "TITULO")
    AaDd( aCabec, "PARCELA")
    AaDd( aCabec, "EMISSAO")
    AaDd( aCabec, "VENCTO")
    AaDd( aCabec, "VALOR")
    AaDd( aCabec, "MOEDA")
    AaDd( aCabec, "NATUREZA")
    AaDd( aCabec, "HISTORICO")
	
	cQuery := "SELECT * FROM "+RetSqlName('SE2')+" AS E2 "
	cQuery += " WHERE E2.D_E_L_E_T_ = ' '"
	iF mv_par02 == 1
		cQuery += " AND E2_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
	Else
		cQuery += " AND E2_VENCTO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'"
	
	Endif
	cQuery += " AND E2_NATUREZ = '"+MV_PAR01+"'"
	cQuery += " AND E2.D_E_L_E_T_ = ' '"
	iF mv_par02 == 1
		cQuery += " ORDER BY E2_EMISSAO"
	Else
		cQuery += " ORDER BY E2_VENCTO"
	Endif
	
    If SELECT("TMX") > 0 
       TMX->( dbCloseArea() )
    Endif

	TCQUERY cQuery NEW ALIAS "TMX"
	

	DbSelectArea("TMX")
	TMX->(DbGoTop())
                       
    aDados := {}
    cMesAno := ""
    nValor := 0
	While TMX->( !EOF() )     
	        If cMesAno <> IIF(MV_PAR02==1,SUBSTR(TMX->E2_EMISSAO,1,6),SUBSTR(TMX->E2_VENCTO,1,6))
			    cMesAno := IIF(MV_PAR02==1,SUBSTR(TMX->E2_EMISSAO,1,6),SUBSTR(TMX->E2_VENCTO,1,6))
				AaDd( aDados, {"", "", "", "","",iif(nValor==0,"",nValor),"","",""} )
				AaDd( aDados, {substr(cMesAno,5,2)+"/"+substr(cMesAno,1,4), "", "", "","","","","",""} )
				nValor := 0
            Endif
			AaDd( aDados, {" "+TMX->E2_PREFIXO, " "+TMX->E2_NUM, TMX->E2_PARCELA, " "+DTOC(STOD(TMX->E2_EMISSAO)),DTOC(STOD(TMX->E2_VENCTO)),TMX->E2_VALOR,TMX->E2_MOEDA,TMX->E2_NATUREZ,TMX->E2_HIST})
			nValor += TMX->E2_VALOR
			TMX->( DBSKIP() )		
	End
	AaDd( aDados, {"", "", "", "","",iif(nValor==0,"",nValor),"","",""} )

	DlgToExcel( { { "ARRAY", "Relatório Pagamentos Mês a Mês Base "+aQuem[mv_par02], aCabec, aDados} })                                  

	MsgAlert("Relatorio Finalizado com Sucesso...")
Else	
	MsgAlert("Geração Abortada pelo usuário!")
	
endif


Return 


Static Function ValidPerg
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}              

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Natureza de  ?", "Natureza de  ?", "Natureza de  ?","mv_ch1","C",len(SED->ED_CODIGO),0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SED"})
AADD(aRegs,{cPerg,"02","Considerar:"   , "Considerar:", "Considerar:"      ,"mv_ch2","N",01,0,0,"C","","mv_par02","Emissao","","","","","Vencimento","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Data de:   "   , "Data de    ", "Data de    "      ,"mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Data ate:  "   , "Data ate   ", "Data ate   "      ,"mv_ch4","D",08,0,0,"G","NAOVAZIO()","mv_par04","","","","","","","","","","","","","","",""})

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