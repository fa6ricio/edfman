#include "protheus.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "DBTREE.CH"

#DEFINE   c_ent      CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CTA100MNU บAutor  ณ Luis Felipe Nasc. บ Data ณ  20/09/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para alterar bot๕es do Browse da rotina   บฑฑ
ฑฑบ          ณ CNTA100.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGCT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบAlterado  ณ CTA100MNU บAutor  ณ                    บ Data ณ    /  /    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTA100MNU()

aAdd(aRotina, { OemToAnsi("Gera P.C.") 		, "u_GerCom"		, 0, 7, 0, nil})  
aAdd(aRotina, { OemToAnsi("Gera P.V.") 		, "u_GerVenPE"		, 0, 7, 0, nil})  
aAdd(aRotina, { OemToAnsi("Copia Contrato") , "U_EDFA003"		, 0, 7, 0, nil})  
aAdd(aRotina, { OemToAnsi("Legenda") 		, "U_b001Legenda"	, 0, 7, 0, nil})  
aAdd(aRotina, { OemToAnsi("Contrato") 		, "U_CNTA300_MVCL"	, 0, 4, 0, nil})  

Return