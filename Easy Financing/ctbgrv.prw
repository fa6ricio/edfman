#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'  
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBGRV    บAutor  ณLeandro Ribeiro     บ Data ณ  24/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada executado no final da contabiliza็ใo      บฑฑ
ฑฑบ          ณ para realizar o preenchimento do campo EF1_XDATAC e        บฑฑ 
ฑฑบ          ณ gravar as chaves da EF1, EF3 e CT2 na tabela ZZ2, para     บฑฑ
ฑฑบ          ณ guardas as invoices contabilizadas.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTBGRV()

Local _cCTBGRV    := GetArea()  
Local _lControl   := Type("_cControl") == "U"
Public _cChaveCT2  
Public _cKeyEF3   := ""
         
If(FUNNAME() == "EFFEX400")
	If(_lControl)  
		If(Type("_cChaveEF1") <> "U" )
			DbSelectArea("EF1")
			DbSetOrder(1)
			If(DbSeek(_cChaveEF1))
				RecLock("EF1",.F.)
					EF1->EF1_XDATAC := DTOS(Ddatabase)			
		        MsUnlock()
			EndIf   
			
			_xxRet := .T.	
			//------------------------------------------------------------------//
			//Grava a chave do contrato que houve o calculo de varia็ใo cambial.
				CT2->CT2_XCHAVE := _cChaveEF1 
				_cKeyEF3 := xFilial("CT2")+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC
			//------------------------------------------------------------------//  
		EndIf                                               
	Else 
		If(Type("_cChaveEF1") <> "U" )	   
			If(IsInCallStac("U_EDFA018"))
				DbSelectArea("ZZ2")
				Reclock("ZZ2",.T.)         
					ZZ2->ZZ2_FILIAL := xFilial("ZZ2")
					ZZ2->ZZ2_KEYEF1 := _cChaveEF1	
					ZZ2->ZZ2_KEYCT2 := xFilial("CT2")+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC
					ZZ2->ZZ2_KEYEF3 := _cChaveEF3
				MsUnlock()
			EndIf 			    
			//------------------------------------------------------------------//
			//Grava a chave do contrato que houve a vincula็ใo da Invoice.
				CT2->CT2_XCHAVE := _cChaveEF1
				_cKeyEF3 := xFilial("CT2")+DTOS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC 
			//------------------------------------------------------------------//  			
		EndIf
    EndIf
EndIf               
 
RestArea(_cCTBGRV)

Return()
