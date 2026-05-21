#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA260D3  บAutor  ณLuis Felipe Nascimento ณData ณ  22/07/13 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada executado apos gravacao dos registros de  บฑฑ
ฑฑบ          ณ movimento, na inclusao de uma transferencia.  			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Estoque                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA260D3()    

Local aArea	:= GetArea() 
Local cUpd  := ""
Local cAlias:= GetNextAlias()

If FunName() == "EDFA001"
	cUpd := " Update "+RetSqlName("SD3")
	cUpd += " Set D3_XD1NSEQ = '"+cNumSeqSD1+"'"
	cUpd += " Where D_E_L_E_T_ <> '*'"
	cUpd += " And D3_NUMSEQ = '"+SD3->D3_NUMSEQ+"'"
    TcSqlExec(cUpd)
EndIf

If AllTrim(ProcName(3)) == "U_EDFA009"

	If ( Type("xEDFD3Seq") <> "U" )
    
		If Len(xEDFD3Seq) > 0
		
			cUpd := " Update "+RetSqlName("SD3")
			cUpd += " Set D3_XD1NSEQ = '"+xEDFD3Seq[1][2]+"'"
			cUpd += " Where D_E_L_E_T_ <> '*'"
			cUpd += " And D3_NUMSEQ = '"+SD3->D3_NUMSEQ+"'"
		    TcSqlExec(cUpd)
		    
		 EndIf
    
    EndIf
    
EndIF

RestArea(aArea)
	
Return( Nil )