#include 'TOPCONN.CH'
#include 'RWMAKE.CH'
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EDFA021  ºAutor  ³Luis F.Nascimento   º Data ³  10/09/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Rotina de atualização da amarração do Contrato x Periodo x a±±
±±º          ³ NF Mae x Serie x Pedido.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFA021()

Local oVar1,oVar2,oVar3,oVar4,oVar5,oVar6,oVar7,oVar8,oVar9
Local oVar10,oVar11,oVar12,oVar13,oVar14,oVar15,oVar16,oVar17,oVar18,oVar19
Local oVar20,oVar21,oVar22,oVar23,oVar24,oVar25,oVar26,oVar27,oVar28,oVar29
Local oVar30,oVar31,oVar32,oVar33,oVar34,oVar35,oVar36,oVar37,oVar38,oVar39
Local oVar40,oVar41,oVar42,oVar43,oVar44,oVar45,oVar46,oVar47,oVar48,oVar49,oVar50,oVar51,oVar52
Local oBtnOk, oBtnCancel

Local aComboTp	:= {}	
Local oComboTp	   	

Local aComboSTp	:= {}	
Local oComboSTp	

Local aComboFpg	:= {}	
Local oComboFpg	

Private oDlg, Memo, cMemo := ""

Private cComboTp := Space(1)
Private cComboSTp:= Space(1)

Private cContra  := SE2->E2_CONTRA 
Private cPeriodo := SE2->E2_XPERIOD 
Private cNFMae   := SE2->E2_NFMAE 
Private cSerMae  := SE2->E2_XSERMAE 
Private cPC      := SE2->E2_XPEDIDO 
Private cXTPAGTO := SE2->E2_XTPAGTO
Private cXSUBTIP := SE2->E2_XSUBTIP
Private cXLOCAL  := SE2->E2_XLOCAL 
Private cXTPGT2  := SE2->E2_XTPGT2
Private cXFORMPG := SE2->E2_XFORMPG
Private nXTXJURO := SE2->E2_XTXJURO
Private cXTPDESP := SE2->E2_XTPDESP   
Private cXFORMPG := SE2->E2_XFORMPG
Private cXTPGT2	 := SE2->E2_XTPGT2
Private cNavio	 := SE2->E2_NAVIO 
Private nXPERPGT := SE2->E2_XPERPGT
Private nQTDTON	 := SE2->E2_QTDTON
Private nPREPAGO := SE2->E2_PREPAGO
Private nTXUSD	 := SE2->E2_TXUSD
Private nVLFINAL := SE2->E2_VLFINAL
Private nVLORIG  := SE2->E2_VLORIG
Private nPREPGR  := SE2->E2_PREPGR 
Private nXMEDPOL := SE2->E2_XMEDPOL  
Private cXTPDES1 := SE2->E2_XTPDES1 
Private nXVLDC1	 := SE2->E2_XVLDC1  
Private cXTPDES2 := SE2->E2_XTPDES2 
Private nXVLDC2  := SE2->E2_XVLDC2  
Private cXTPDES3 := SE2->E2_XTPDES3 
Private nXVLDC3  := SE2->E2_XVLDC3  
Private cXTPAC1	 := SE2->E2_XTPAC1
Private nXVLAC1  := SE2->E2_XVLAC1
Private cXTPAC2	 := SE2->E2_XTPAC2
Private nXVLAC2  := SE2->E2_XVLAC2
Private cXTPAC3  := SE2->E2_XTPAC3
Private nXVLAC3  := SE2->E2_XVLAC3
Private cBooking := SE2->E2_XBOOK      
Private nValor   := SE2->E2_VALOR
Private cBanco	 := SE2->E2_XBANCO
Private cAgenc	 := SE2->E2_XAGEN   
Private cDigAge  :=	SE2->E2_XDVAGE 
Private cConta   := SE2->E2_XCONTA 
Private cDigCon	 := SE2->E2_XDVCTA 
Private cBanco2	 := SE2->E2_XBANCO2
Private cAgenc2	 := SE2->E2_XAGEN2   
Private cDigAge2 :=	SE2->E2_XDVAGE2 
Private cConta2  := SE2->E2_XCONTA2 
Private cDigCon2 := SE2->E2_XDVCTA2 
Private cContraPG:= SE2->E2_XCONTRA
Private dDtInic  := SE2->E2_XDTINIC
Private dDtFim   := SE2->E2_XDTFIM  
Private lCritica := .f. 


cGrupo := GetAdvFVal("SA2","A2_XDESCGR",xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA, 1, " " )

If SE2->E2_TIPO <> "PA " .or. !cGrupo $ "000003/000008"
	Aviso("Atenção","Rotina específica de alteração dos Adiantamentos as Usinas !",{"Voltar"})
	Return
EndIf

SE5->(DbSetOrder(7))
If SE5->(DbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
	Aviso("Atenção","Como este titulo já sofreu movimentação financeira não será possível alterar os campos Qtd. Ton, Vlr USD/TM, Tx USD PA, Descontos e Acréscimo !",{"Continuar"})
	lCritica := .t.
EndIf

//+----------------------------------------------------------------------------
//| Atribuição as matrizes
//+----------------------------------------------------------------------------

// Tipo de Pagto 

aAdd( aComboTp, "1-PRODUTO" )
aAdd( aComboTp, "2-FRETE" )
aAdd( aComboTp, "3-TERMINAL" )
aAdd( aComboTp, "4-OUTRAS DESPESAS" )

// Sub_Tipo PA 

aAdd( aComboSTp, "1-CAD Bco" )
aAdd( aComboSTp, "2-LC(C.Cred)" )
aAdd( aComboSTp, "3-CAFD(cop.docs)" )
aAdd( aComboSTp, "4-STOCK FINANCE" )
aAdd( aComboSTp, "5-Standby" )
aAdd( aComboSTp, "6-Part.Payment" )
aAdd( aComboSTp, "7-CAD Without Prod." )
aAdd( aComboSTp, "8-CAD" )
aAdd( aComboSTp, "9-Payment" )

//  Forma de Pagto

aAdd( aComboFpg, "1-Cheque" )
aAdd( aComboFpg, "2-Especie" )
aAdd( aComboFpg, "3-Transf. Dinheiro" )
aAdd( aComboFpg, "4-Outras" )

cMemo := SE2->E2_XHIST2 

Define MSDialog oDlg Title OemToAnsi("Alteração de Adiantamentos a Fornecedores - Usinas") From 0,0 To 680,950 Pixel

@ 015,410 GET oMemo  VAR cMemo MEMO Size 054,245 Of oDlg Pixel
oMemo:bRClicked := {||.f.}//{||AllwaysTrue()}

@005,405  TO 265,470 Label "Histórico" Of oDlg Pixel       

@005,003  TO 285,400 Label "Adiantamento a Usina" Of oDlg Pixel 

@015,010  TO 062,395 Label "Padrões" Of oDlg Pixel 

@025,015 Say "Prefixo"    	Pixel Of oDlg             
@025,035 MSGet oVar1      	Var SE2->E2_PREFIXO  Picture "@!" Size 20,10 Pixel When .f. Of oDlg      
@025,080 Say "Titulo"     	Pixel Of oDlg             
@025,095 MSGet oVar2      	Var SE2->E2_NUM      Picture "@!" Size 40,10 Pixel When .f. Of oDlg      
@025,147 Say "Parcela"    	Pixel Of oDlg             
@025,170 MSGet oVar3      	Var SE2->E2_PARCELA  Picture "@!" Size 10,10 Pixel When .f. Of oDlg      
@025,200 Say "Tipo"       	Pixel Of oDlg             
@025,215 MSGet oVar4      	Var SE2->E2_TIPO     Picture "@!" Size 15,10 Pixel When .f. Of oDlg      
@025,260 Say "Vlr.Titulo" 	Pixel Of oDlg             
@025,285 MSGet oVar5      	Var nVALOR    		 Picture  PesqPict("SE2","E2_VALOR") Size 60,10 Pixel When .f. Of oDlg      

@045,015 Say "Fornecedor" 	Pixel Of oDlg             
@045,050 MSGet oVar6      	Var SE2->E2_FORNECE  Picture "@!" Size 50,10 Pixel When .f. Of oDlg      
@045,110 Say "Loja"       	Pixel Of oDlg             
@045,130 MSGet oVar7      	Var SE2->E2_LOJA     Picture "@!" Size 50,10 Pixel When .f. Of oDlg      
@045,190 Say "Nome"       	Pixel Of oDlg             
@045,210 MSGet oVar8      	Var SE2->E2_NOMFOR   Picture "@!" Size 80,10 Pixel When .f. Of oDlg      

@065,010  TO 280,395 Label "Específicos" Of oDlg Pixel 

@080,015 Say "Contrato"   	Pixel Of oDlg             
@090,015 MSGet oVar9      	Var cContra  			Picture "@!" Size 50,10 Pixel F3 "NFMPA" Of oDlg      
@080,095 Say "Periodo"    	Pixel Of oDlg	             
@090,095 MSGet oVar10     	Var cPeriodo 			Picture "@!" Size 30,10 Pixel When .f. Of oDlg      
@080,155 Say "NF Mae"     	Pixel Of oDlg             
@090,155 MSGet oVar11     	Var cNFMae   			Picture "@!" Size 50,10 Pixel When .f. Of oDlg      
@080,215 Say "Serie"      	Pixel Of oDlg             
@090,215 MSGet oVar12     	Var cSerMae  			Picture "@!" Size 20,10 Pixel When .f. Of oDlg      
@080,275 Say "Pedido"     	Pixel Of oDlg             
@090,275 MSGet oVar13     	Var cPC      			Picture "@!" Size 30,10 Pixel When .f. Of oDlg      
@080,335 Say "Terminal"   	Pixel Of oDlg             
@090,335 MSGet oVar14     	Var cXLOCAL  			Picture "@!" Size 20,10 Pixel f3 "SZE_2" Of oDlg      

cXTPAGTO := aComboTp[Val(cXTPAGTO)]

@105,015 Say "Tipo Pagto" 	Pixel Of oDlg             
@115,015 Combobox oComboTp  Var cXTPAGTO ITEMS aComboTp SIZE 60,10  Pixel OF oDlg

@105,095 Say "Outras.Desp." Pixel Of oDlg             
@115,095 MSGet oVar15     	Var cXTPGT2 	   		Picture "@!" Size 15,10 Pixel F3 "Z4" Of oDlg      

cXFORMPG := aComboFpg[Val(cXFORMPG)]
@105,140 Say "Forma Pagto" 	Pixel Of oDlg             
@115,140 Combobox oComboFpg Var cXFORMPG ITEMS aComboFpg SIZE 60,10 Pixel OF oDlg

@105,215 Say "Tx. Juros" 	Pixel Of oDlg             
@115,215 MSGet oVar16     	Var nXTXJURO 			Picture PesqPict("SE2","E2_XTXJURO") Size 20,10 Pixel Of oDlg      
@105,270 Say "Booking" 		Pixel Of oDlg             
@115,270 MSGet oVar17     	Var cXTPDESP		 	Picture "@!" Size 15,10 Pixel F3 "Z3" Of oDlg      

cXSUBTIP := aComboSTp[Val(cXSUBTIP)]

@105,320 Say "Sub-Tipo PA"	Pixel Of oDlg             
@115,320 Combobox oComboSTp Var cXSUBTIP ITEMS aComboSTp SIZE 60,10 Pixel OF oDlg

@130,015 Say "Navio"		Pixel Of oDlg             
@140,015 MSGet oVar18     	Var cNavio   	 		Picture "@!" Size 60,10 Pixel F3 "CTH" Of oDlg      
@130,095 Say "% Pagamento"	Pixel Of oDlg             
@140,095 MSGet oVar19     	Var nXPERPGT 	 		Picture PesqPict("SE2","E2_XPERPGT") Size 20,10 Pixel Of oDlg   
@130,155 Say "Qtd. Ton."	Pixel Of oDlg             
If !lCritica
	@140,155 MSGet oVar20     	Var nQTDTON  	 		Picture PesqPict("SE2","E2_QTDTON") Size 50,10 Pixel Valid fRealcVl() Of oDlg   
Else
	@140,155 MSGet oVar20     	Var nQTDTON  	 		Picture PesqPict("SE2","E2_QTDTON") Size 50,10 Pixel  When .f.  Of oDlg   
EndIf

@130,215 Say "Vlr USD/TM"	Pixel Of oDlg             
If !lCritica
	@140,215 MSGet oVar21     	Var nPREPAGO 	 		Picture PesqPict("SE2","E2_PREPAGO") Size 50,10 Pixel Valid fRealcVl() Of oDlg      
Else
	@140,215 MSGet oVar21     	Var nPREPAGO 	 		Picture PesqPict("SE2","E2_PREPAGO") Size 50,10 Pixel When .f. Of oDlg      
EndIf

@130,275 Say "Tx USD PA"	Pixel Of oDlg             
If !lCritica
	@140,275 MSGet oVar22     	Var nTXUSD   	 		Picture PesqPict("SE2","E2_TXUSD") Size 50,10 Pixel Valid fRealcVl() Of oDlg      
Else
	@140,275 MSGet oVar22     	Var nTXUSD   	 		Picture PesqPict("SE2","E2_TXUSD") Size 50,10 Pixel When .f. Of oDlg      
EndIf

@130,335 Say "Vlr Tot.USD"	Pixel Of oDlg             
@140,335 MSGet oVar23     	Var nVLFINAL   	  		Picture PesqPict("SE2","E2_VLFINAL") Size 50,10 Pixel When .f. Of oDlg      

@155,015 Say "Vlr R$/TM"	Pixel Of oDlg             
@165,015 MSGet oVar24     	Var nPREPGR 	  		Picture PesqPict("SE2","E2_PREPGR") Size 50,10 Pixel When .f. Of oDlg      
@155,095 Say "Vlr Tot.R$ "	Pixel Of oDlg             
@165,095 MSGet oVar25     	Var nVLORIG   	  		Picture PesqPict("SE2","E2_VLORIG") Size 50,10 Pixel When .f. Of oDlg      
@155,155 Say "Vlr POL"		Pixel Of oDlg             
@165,155 MSGet oVar26     	Var nXMEDPOL  	  		Picture PesqPict("SE2","E2_XMEDPOL") Size 50,10 Pixel Of oDlg      
// 27/03/15 - Luis Felipe Nascimento - Inicio
@155,215 Say "Contrato PG"  Pixel Of oDlg             
@165,215 MSGet oVar27     	Var cContraPG 	  		Picture PesqPict("SE2","E2_XCONTRA") Size 50,10 F3 "SZ3COD" Pixel Of oDlg      
@155,275 Say "Inic. Entr."  Pixel Of oDlg             
@165,275 MSGet oVar28     	Var dDtInic   	  		Picture "@D" Size 50,10 Pixel Of oDlg      
@155,335 Say "Fim. Entr."   Pixel Of oDlg             
@165,335 MSGet oVar29     	Var dDtFim   	  		Picture "@D" Size 50,10 Pixel Of oDlg      
// 27/03/15 - Luis Felipe Nascimento - Fim

@180,015 Say "Tipo Desc.01"	Pixel Of oDlg             
@190,015 MSGet oVar30     	Var cXTPDES1 	  		Picture "@e" Size 15,10 Pixel f3 "Z1" Of oDlg      
@180,065 Say "Vlr. Desc.01"	Pixel Of oDlg             
If !lCritica
	@190,065 MSGet oVar31     	Var nXVLDC1 	  		Picture PesqPict("SE2","E2_XVLDC1") Size 50,10 Pixel Valid fRealcVl() Of oDlg      
Else
	@190,065 MSGet oVar31     	Var nXVLDC1 	  		Picture PesqPict("SE2","E2_XVLDC1") Size 50,10 Pixel  When .f. Of oDlg      
EndIf

@180,150 Say "Tipo Desc.02"	Pixel Of oDlg             
@190,150 MSGet oVar32     	Var cXTPDES2 	  		Picture "@e" Size 15,10 Pixel f3 "Z1" Of oDlg      
@180,195 Say "Vlr. Desc.02"	Pixel Of oDlg             
If !lCritica
	@190,195 MSGet oVar33     	Var nXVLDC2 	  		Picture PesqPict("SE2","E2_XVLDC2") Size 50,10 Pixel Valid fRealcVl() Of oDlg      
Else
	@190,195 MSGet oVar33     	Var nXVLDC2 	  		Picture PesqPict("SE2","E2_XVLDC2") Size 50,10 Pixel When .f. Of oDlg      
EndIf

@180,280 Say "Tipo Desc.03"	Pixel Of oDlg             
@190,280 MSGet oVar34     	Var cXTPDES3 	  		Picture "@e" Size 15,10 Pixel f3 "Z1" Of oDlg      
@180,325 Say "Vlr. Desc.03"	Pixel Of oDlg             
If !lCritica
	@190,325 MSGet oVar35     	Var nXVLDC3 	  		Picture PesqPict("SE2","E2_XVLDC3") Size 50,10 Pixel Valid fRealcVl() Of oDlg      
Else
	@190,325 MSGet oVar35     	Var nXVLDC3 	  		Picture PesqPict("SE2","E2_XVLDC3") Size 50,10 Pixel When .f. Of oDlg      
EndIf


@205,015 Say "Tipo Acres.1"	Pixel Of oDlg             
@215,015 MSGet oVar36     	Var cXTPAC1  	  		Picture "@e" Size 15,10 Pixel f3 "Z2" Of oDlg      
@205,065 Say "Vlr. Acres.1"	Pixel Of oDlg             
If !lCritica
	@215,065 MSGet oVar37     	Var nXVLAC1  	  	Picture PesqPict("SE2","E2_XVLAC1") Size 50,10 Pixel Valid fRealcVl() Of oDlg      
Else
	@215,065 MSGet oVar37     	Var nXVLAC1  	  	Picture PesqPict("SE2","E2_XVLAC1") Size 50,10 Pixel When .f. Of oDlg      
EndIf

@205,150 Say "Tipo Acres.2"	Pixel Of oDlg             
@215,150 MSGet oVar38     	Var cXTPAC2 	  		Picture "@e" Size 15,10 Pixel f3 "Z2" Of oDlg      
@205,195 Say "Vlr. Acres.2"	Pixel Of oDlg             
If !lCritica
	@215,195 MSGet oVar39     	Var nXVLAC2 	  	Picture PesqPict("SE2","E2_XVLAC2") Size 50,10 Pixel Valid fRealcVl() Of oDlg      
Else
	@215,195 MSGet oVar39     	Var nXVLAC2 	  	Picture PesqPict("SE2","E2_XVLAC2") Size 50,10 Pixel When .f. Of oDlg      
EndIf

@205,280 Say "Tipo Acres.3"	Pixel Of oDlg             
@215,280 MSGet oVar40     	Var cXTPAC3 	  		Picture "@e" Size 15,10 Pixel f3 "Z2" Of oDlg      
@205,325 Say "Vlr. Acres.3"	Pixel Of oDlg             
If !lCritica
	@215,325 MSGet oVar41     	Var nXVLAC3 	  	Picture PesqPict("SE2","E2_XVLAC3") Size 50,10 Pixel Valid fRealcVl() Of oDlg      
Else
	@215,325 MSGet oVar41     	Var nXVLAC3 	  	Picture PesqPict("SE2","E2_XVLAC3") Size 50,10 Pixel When .f. Of oDlg      
EndIf

@230,015 Say "Bco Favor."   Pixel Of oDlg             
@240,015 MSGet oVar42      	Var cBanco   			Picture "@!" Size 30,10 Pixel F3 "SZ9" Of oDlg      
@230,095 Say "Agencia"    	Pixel Of oDlg	             
@240,095 MSGet oVar43     	Var cAgenc   			Picture "@!" Size 40,10 Pixel When .f. Of oDlg      
@230,155 Say "Dv.Agencia"   Pixel Of oDlg             
@240,155 MSGet oVar44     	Var cDigAge  			Picture "@!" Size 10,10 Pixel When .f. Of oDlg      
@230,215 Say "Conta"      	Pixel Of oDlg             
@240,215 MSGet oVar45     	Var cConta   			Picture "@!" Size 40,10 Pixel When .f. Of oDlg      
@230,275 Say "Dv.Conta"     Pixel Of oDlg             
@240,275 MSGet oVar46     	Var cDigCon  			Picture "@!" Size 10,10 Pixel When .f. Of oDlg      

@255,015 Say "Bco Fav.Ext"  Pixel Of oDlg             
@265,015 MSGet oVar47      	Var cBanco2  			Picture "@!" Size 30,10 Pixel F3 "SZ9" Of oDlg      
@255,095 Say "Agencia"    	Pixel Of oDlg	             
@265,095 MSGet oVar48     	Var cAgenc2  			Picture "@!" Size 40,10 Pixel When .f. Of oDlg      
@255,155 Say "Dv.Agencia"   Pixel Of oDlg             
@265,155 MSGet oVar49     	Var cDigAge2 			Picture "@!" Size 10,10 Pixel When .f. Of oDlg      
@255,215 Say "Conta"      	Pixel Of oDlg             
@265,215 MSGet oVar50     	Var cConta2  			Picture "@!" Size 40,10 Pixel When .f. Of oDlg      
@255,275 Say "Dv.Conta"     Pixel Of oDlg             
@265,275 MSGet oVar51     	Var cDigCon2 			Picture "@!" Size 10,10 Pixel When .f. Of oDlg      

@255,330 Say "Booking"		Pixel Of oDlg             
@265,330 MSGet oVar52     	Var cBooking  	  		Picture PesqPict("SE2","E2_XBOOK") Size 50,10 Pixel Of oDlg      

@270,405 Button oBtnOk     Prompt "&Grava"         Size 30,15 Pixel Action (Grava(), oDlg:End()) Of oDlg
@270,440 Button oBtnCancel Prompt "C&ancela"       Size 30,15 Pixel Action oDlg:End()

Activate MSDialog oDlg Centered

Static Function Grava()    

RecLock("SE2",.F.)
 SE2->E2_CONTRA  := cContra
 SE2->E2_XPERIOD := cPeriodo
 SE2->E2_NFMAE   := cNFMae
 SE2->E2_XSERMAE := cSerMae
 SE2->E2_XPEDIDO := cPC 
 SE2->E2_XTPAGTO := cXTPAGTO
 SE2->E2_XSUBTIP := cXSUBTIP
 SE2->E2_XLOCAL  := cXLOCAL
 SE2->E2_XTPGT2  := cXTPGT2 
 SE2->E2_XFORMPG := cXFORMPG
 SE2->E2_XTXJURO := nXTXJURO
 SE2->E2_XTPDESP := cXTPDESP 
 SE2->E2_XFORMPG := cXFORMPG
 SE2->E2_XTPGT2  := cXTPGT2 
 SE2->E2_NAVIO	 := cNavio
 SE2->E2_XPERPGT := nXPERPGT
 SE2->E2_QTDTON	 := nQTDTON
 SE2->E2_PREPAGO := nPREPAGO
 SE2->E2_TXUSD   := nTXUSD
 SE2->E2_VLFINAL := nVLFINAL
 SE2->E2_VLORIG  := nVLORIG 
 SE2->E2_PREPGR  := nPREPGR
 SE2->E2_XMEDPOL := nXMEDPOL 
 SE2->E2_XTPDES1 := cXTPDES1
 SE2->E2_XVLDC1  := nXVLDC1
 SE2->E2_XTPDES2 := cXTPDES2
 SE2->E2_XVLDC2  := nXVLDC2
 SE2->E2_XTPDES3 := cXTPDES3
 SE2->E2_XVLDC3  := nXVLDC3
 SE2->E2_XTPAC1  := cXTPAC1
 SE2->E2_XVLAC1  := nXVLAC1
 SE2->E2_XTPAC2  := cXTPAC2
 SE2->E2_XVLAC2  := nXVLAC2
 SE2->E2_XTPAC3  := cXTPAC3
 SE2->E2_XVLAC3  := nXVLAC3
 SE2->E2_XBOOK	 := cBooking 
 SE2->E2_VALOR	 := nValor
 SE2->E2_VLCRUZ	 := nValor 
 SE2->E2_XBANCO  := cBanco
 SE2->E2_XAGEN   := cAgenc 
 SE2->E2_XDVAGE  := cDigAge
 SE2->E2_XCONTA  := cConta
 SE2->E2_XDVCTA  := cDigCon
 SE2->E2_XBANCO2 := cBanco2
 SE2->E2_XAGEN2  := cAgenc2 
 SE2->E2_XDVAGE2 := cDigAge2
 SE2->E2_XCONTA2 := cConta2
 SE2->E2_XDVCTA2 := cDigCon2  
 SE2->E2_XCONTRA := If(!Empty(cContraPG),cContraPG,If(!Empty(cContra),Alltrim(cContra)+"-"+Alltrim(cPeriodo),""))      
 SE2->E2_XHIST2  := cMemo 
 SE2->E2_XDTINIC := dDtInic
 SE2->E2_XDTFIM	 := dDtFim  
MsUnLock()                             

Return 

Static Function fRealcVl()
nVLFINAL := nQTDTON * nPREPAGO
nPREPGR  := nTXUSD  * nPREPAGO
nVLORIG	 := nQTDTON * nPREPGR 

If !lCritica
	nValor  := nVLORIG + (nXVLAC1+nXVLAC2+nXVLAC3) - (nXVLDC1+nXVLDC2+nXVLDC3)
EndIf

oDlg:Refresh()

Return()