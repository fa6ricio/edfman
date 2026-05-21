#INCLUDE "topconn.ch"
#INCLUDE "Tbiconn.ch"  
#include 'RWMAKE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A140EXC  ºAutor  ³Luis Felipe Nascimento ³Data ³  31/07/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Pre-Nota - Mata140                                         º±±
±±º          ³ Alterar o Status na Tabela SZD   (Tabela de Controle das   º±±
±±º          ³ entradas de NF Mae x NF Remessa) p/ EX                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A140EXC()

Local cUpd 	:= ""
Local cAlias:= GetNextAlias()
Local lRet 	:= .T.                                        
Local cEnt  := Chr(13) + Chr(10)
Local cCNPJ := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC")

cUpd := " Update "+RetSqlName("SZD")+cEnt
cUpd += " SET ZD_STATUS   = 'EX'"+cEnt
cUpd += " WHERE ZD_FILIAL = '"+xFilial("SZD")+"'"+cEnt
cUpd += " AND ZD_NFMAE    = '"+SF1->F1_NFMAE+"'"+cEnt
cUpd += " AND ZD_SERIEM   = '"+SF1->F1_XSERMAE+"'"+cEnt
cUpd += " AND ZD_NFREMES  = '"+SF1->F1_DOC+"'"+cEnt
cUpd += " AND ZD_SERIER   = '"+SF1->F1_SERIE+"'"+cEnt
cUpd += " AND ZD_CNPJUSI  = '"+cCNPJ+"'"+cEnt	
cUpd += " AND D_E_L_E_T_  = ' ' ; "+cEnt
TcSqlexec(cUpd)

Return( lRet )