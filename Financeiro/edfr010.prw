#include "colors.ch"
#include "Protheus.ch"
#include "TopConn.ch"
#include "TbiConn.ch"
#include "rwmake.ch"

#Define ALIN_NONE   0
#Define ALIN_TOP    1
#Define ALIN_BOTTOM 2
#Define ALIN_LEFT   3
#Define ALIN_RIGHT  4
#Define ALIN_MIDDLE 5
#Define RGB_FUNDO {200,200,200}
#Define RGB_FUNDO1 {200,200,200} //cinza
#Define RGB_FUNDO2 {255,255,0}   //Amarelo Escuro
#Define RGB_FUNDO3 {255,255,128} //Amarelo Claro
#Define RGB_FUNDO4 {31,69,108}   //Azul Escuro
#Define RGB_FUNDO5 {71,107,145}  //Azul Claro
#Define RGB_FUNDO6 {52,148,100}  //Verde Escuro
#Define RGB_FUNDO7 {149,220,185} //Verde Claro
#Define RGB_FUNDO8 {136,21,21}   //Vermelho Escuro
#Define RGB_FUNDO9 {227,119,119} //Vermelho Claro
#Define RGB_FUNDOA {193,114,30}  //Beje
#Define RGB_FUNDOB {255,255,255} //Branco
#Define RGB_FUNDOC {211,234,205} //Verde muito Claro
//#Define cEnt CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ EDFR010  ºAutor  ³ Luis Felipe Mattos º Data ³  05/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Payment Request - Espelho de Pagamento                     º±±
±±º          ³ Chamado via Ponto de Entrada - F050BUT                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteração ³ Luis Felipe Nascimento					Data: 01/04/15	  º±±
±±º          ³ Alterações no tratamento do campo E2_XSUBTIP.			  º±±
±±º          ³ Alterações na impressão do banco do exterior. 			  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

***********************
User Function EDFR010()
***********************

Local __aArea := GetArea()

//Fontes do Relatorio
oFntTitulo:= TFont():New("Arial"       ,, 22,,.T.,,,,   ,.F.)
oFntTit16 := TFont():New("Arial"       ,, 16,,.T.,,,,.T.,.F.)
oFntTit11 := TFont():New("Arial"       ,, 11,,.F.,,,,.F.,.F.)
oFntTit10 := TFont():New("Arial"       ,, 10,,.F.,,,,.T.,.F.)
oFntTit09 := TFont():New("Arial"       ,, 09,,.F.,,,,.T.,.F.)
oFntTit08 := TFont():New("Arial"       ,, 08,,.F.,,,,.T.,.F.)
oFntTit07 := TFont():New("Arial"       ,, 07,,.F.,,,,.T.,.F.)
oFntCp16  := TFont():New("Arial"       ,, 16,,.F.,,,,.T.,.F.)
oFntCp12  := TFont():New("Arial"       ,, 12,,.T.,,,,.F.,.F.)
oFntCp11  := TFont():New("Arial"       ,, 11,,.T.,,,,   ,.F.)
oFntCp10  := TFont():New("Arial"       ,, 10,,.F.,,,,   ,.F.)
oFntCp09  := TFont():New("Arial"       ,, 09,,.F.,,,,   ,.F.)
oFntCp08  := TFont():New("Arial"       ,, 08,,.F.,,,,   ,.F.)
oFntCpX   := TFont():New("Arial"       ,, 18,,.T.,,,,   ,.F.)
cColorBlue:= CLR_BLUE

oPrn:=TMSPrinter():New("Payment Request")
oPrn:SetPortrait()  // oPrn:SetLandsCape()
oPrn:Setup()

Processa({|| Impressao() },"Aguarde Impressão...")

oPrn:Preview()

RestArea(__aArea)

Return

***************************
Static Function Impressao()
***************************

Local _cAlias	  := GetNextAlias()
Local _cQuery	  := ""
Local xContra 	  := ""
Local aAprov	  := {}

Private nMaxCol   := 2350

SZ3->(DbSetOrder(1))
SZ3->(DbSeek(xFilial("SZ3")+SE2->E2_CONTRA+SE2->E2_XPERIOD))

oPrn:StartPage()

LayOut()

nLin:= 500

DbSelectArea("SM0")
DbSetOrder(1)
DbSeek(SM0->M0_CODIGO+SE2->E2_FILORIG)

oPrn:Say(nLin,nMaxCol*.18,SE2->E2_NUM             	,oFntCp16  ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin,nMaxCol*.82,DtoC(SE2->E2_VENCREA)   	,oFntTit11 ,ALIN_MIDDLE,,,0)

nLin += 155

cNatureza := ""
If SE2->E2_XTPAGTO == '1'
	cNatureza := "PRODUCT"
Elseif SE2->E2_XTPAGTO == '2'
	cNatureza := "SHIPPING"
Elseif SE2->E2_XTPAGTO == '3'
	cNatureza := "TERMINAL"
Elseif SE2->E2_XTPAGTO == '4'
	cNatureza := "OTHER EXPENSES"
Endif

SX5->(dbSeek(xFilial("SX5")+"Z4"+SE2->E2_XTPGT2)) 
aSX5 := FWGetSX5("Z4",SX2->E2_XTPGT2,"en")

oPrn:Say(nLin,nMaxCol*.12,SM0->M0_NOMECOM  			,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
oPrn:Say(nLin,nMaxCol*.53,cNatureza  		   		,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
oPrn:Say(nLin,nMaxCol*.82,aSX5[1,4]     			,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)

nLin += 50

oPrn:Say(nLin,nMaxCol*.12,SE2->E2_NOMFOR   							 ,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
If Alltrim(SE2->E2_TIPO) == 'PA' 
	oPrn:Say(nLin,nMaxCol*.53,TRANSFORM(SE2->E2_VENCTO,"@D 99/99/9999") ,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
Else
	oPrn:Say(nLin,nMaxCol*.53,TRANSFORM(SE2->E2_BAIXA  ,"@D 99/99/9999") ,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
EndIf
oPrn:Say(nLin,nMaxCol*.82,TRANSFORM(SE2->E2_TXUSD  ,"@E 999.9999")   ,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)

nLin += 55

cCNPJ := GetAdvFVal("SA2","A2_CGC",xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA, 1, " " )

oPrn:Say(nLin,nMaxCol*.12,TRANSFORM(cCNPJ  ,"@R 99.999.999/9999-99")  	,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
oPrn:Say(nLin,nMaxCol*.55,TRANSFORM(SE2->E2_VALOR  ,"@E     999,999,999.99")  	,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0) 

cForma := ""
If SE2->E2_XFORMPG == '1'
	cForma := 'CHECK'  
ElseIf	SE2->E2_XFORMPG == '2'
	cForma := 'CASH'  
ElseIf	SE2->E2_XFORMPG == '3'
	cForma := 'MONEY TRANSFER'  
ElseIf	SE2->E2_XFORMPG == '4'
	cForma := 'OTHER'  
EndIf

oPrn:Say(nLin,nMaxCol*.82,cForma  												,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)

nLin += 50

If !Empty(SE2->E2_CONTRA) 
   xContra := Alltrim(SE2->E2_CONTRA)
ElseIf !Empty(SE2->E2_XCONTRA)
	For nX:=1 to Len(SE2->E2_XCONTRA)
		If Substr(SE2->E2_XCONTRA,nX,1) $ "P0123456789"
			xContra += Substr(SE2->E2_XCONTRA,nX,1)
		Else
			Exit	
		EndIf
	Next
EndIf
      
/* 26/12/16 - Luis Felipe
CN9->(DbSetOrder(1))         
If CN9->(DbSeek(xFilial("CN9")+xContra))
	oPrn:Say(nLin,nMaxCol*.12,CN9->CN9_XFORNE										,oFntTit12,ALIN_LEFT,ALIN_LEFT,,0)
EndIf	
*/
oPrn:Say(nLin,nMaxCol*.12,SE2->E2_NOMFOR										,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
oPrn:Say(nLin,nMaxCol*.53,TRANSFORM(SE2->E2_XTXJURO ,"@E     999,999,999.99")	,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)

nLin += 205

/* 01/04/15 - Luis Felipe Nascimento
SE5->(DbSetOrder(7))
SE5->(DbSeek(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))

SA6->(DbSeek(xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
cEnder := Alltrim(SA6->A6_END)+" - "+Alltrim(SA6->A6_BAIRRO)+" - "+Alltrim(SA6->A6_MUN)+" - "+Alltrim(SA6->A6_CEP)+" - "+Alltrim(SA6->A6_EST)

oPrn:Say(nLin,nMaxCol*.14,SE5->E5_BANCO+" - "+SubStr(SA6->A6_NOME,1,16)		  	,oFntTit12,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.14,SE5->E5_AGENCIA+" - "+SubStr(SA6->A6_NOMEAGE,1,14) 	,oFntTit12,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.14,SE5->E5_CONTA                          		  		,oFntTit12,ALIN_LEFT,ALIN_LEFT,,0)
*/

SZ9->(DbSetOrder(1))
SZ9->(DbSeek(xFilial("SZ9")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_XBANCO+SE2->E2_XAGEN+SE2->E2_XCONTA))

oPrn:Say(nLin,nMaxCol*.14,SE2->E2_XBANCO+" - "+SZ9->Z9_NOME					  	,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.14,SE2->E2_XAGEN+"-"+SE2->E2_XDVAGE+" "+SZ9->Z9_NOMEAGE  ,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.14,SE2->E2_XCONTA+"-"+SE2->E2_XDVCTA        		  		,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.14,SubStr(SZ9->Z9_END,1,40)                 		  		,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.14,SubStr(SZ9->Z9_END,41,40)                		  		,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.14,SubStr(SZ9->Z9_END,81,20)               		  		,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 100

nLin -= 350

SZ9->(DbSetOrder(1))
SZ9->(DbSeek(xFilial("SZ9")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_XBANCO2+SE2->E2_XAGEN2+SE2->E2_XCONTA2))

oPrn:Say(nLin,nMaxCol*.63,SE2->E2_XBANCO2+" - "+SZ9->Z9_NOME				  	,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50 
oPrn:Say(nLin,nMaxCol*.63,SE2->E2_XAGEN2+"-"+SE2->E2_XDVAGE2+" "+SZ9->Z9_NOMEAGE ,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.63,SE2->E2_XCONTA2+"-"+SE2->E2_XDVCTA2      		  		,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.63,SZ9->Z9_ABA                            		  		,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.63,SZ9->Z9_FED                            		  		,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.63,SZ9->Z9_CHIPS                          		  		,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
oPrn:Say(nLin,nMaxCol*.92,SZ9->Z9_SWIFT                          		  		,oFntTit11,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 50
oPrn:Say(nLin,nMaxCol*.63,SubStr(SZ9->Z9_END,1,50)                 		  		,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
nLin += 35
oPrn:Say(nLin,nMaxCol*.63,SubStr(SZ9->Z9_END,51,50)                		  		,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)

nLin += 155

If !Empty(SE2->E2_XHIST2)
	nLinh:= MLCount(SE2->E2_XHIST2,122)
	For nCont := 1 To nLinh
		oPrn:Say(nLin,nMaxCol*.01,MemoLine(SE2->E2_XHIST2,122,nCont) ,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
		nLin+= 35
	Next
EndIf

cTipo := ""
/* // 01/04/15 - Luís Felipe Nascimento
If SE2->E2_XSUBTIP == "1"
	cTipo := "CAD BCO"
ElseIf SE2->E2_XSUBTIP == "2"
	cTipo := "LC(C.CRED)"
ElseIf SE2->E2_XSUBTIP == "3"
	cTipo := "CAFD(COP.DOCS)"
ElseIf SE2->E2_XSUBTIP == "4"
	cTipo := "SF80/70%"        
ElseIf SE2->E2_XSUBTIP == "5"
	cTipo := "SF100/70%"
ElseIf SE2->E2_XSUBTIP == "6"
	cTipo := "SF90/80%"
ElseIf SE2->E2_XSUBTIP == "7"
	cTipo := "CAD WITHOUT PROD"
ElseIf SE2->E2_XSUBTIP == "8"
	cTipo := "CAD"
ElseIf SE2->E2_XSUBTIP == "9"
	cTipo := "CAD WITHOUT PROD"
ElseIf SE2->E2_XSUBTIP == "A"
	cTipo := "CAD"
EndIf
*/

If SE2->E2_XSUBTIP == "1"
	cTipo := "CAD BCO"
ElseIf SE2->E2_XSUBTIP == "2"
	cTipo := "LC(C.CRED)"
ElseIf SE2->E2_XSUBTIP == "3"
	cTipo := "CAFD(COP.DOCS)"
ElseIf SE2->E2_XSUBTIP == "4"
	cTipo := "STOCK FINANCE"
ElseIf SE2->E2_XSUBTIP == "5"
	cTipo := "STANDBY"
ElseIf SE2->E2_XSUBTIP == "6"
	cTipo := "PART.PAYMENT"
ElseIf SE2->E2_XSUBTIP == "7"
	cTipo := "CAD WITHOUT PROD"
ElseIf SE2->E2_XSUBTIP == "8"
	cTipo := "CAD"
ElseIf SE2->E2_XSUBTIP == "9"
	cTipo := "Prepayment"
EndIf

SZE->(DbSetOrder(3))         
SZE->(DbSeek(xFilial("SZE")+SE2->E2_XLOCAL))

nLin := 1960

SX5->(dbSeek(xFilial("SX5")+"Z3"+SE2->E2_XTPDESP)) 

// // 16/04/15 - Luis Felipe - Inicio
// oPrn:Say(nLin   ,nMaxCol*.01,SE2->E2_CONTRA                        		    ,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0) 
If  Empty(SE2->E2_XCONTRA)
	oPrn:Say(nLin   ,nMaxCol*.01,SE2->E2_CONTRA                        			,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0) 
	oPrn:Say(nLin+35,nMaxCol*.01,SE2->E2_XPERIOD                       			,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin   ,nMaxCol*.07,TRANSFORM(SZ3->Z3_DTINIC,"@D 99/99/9999")  	,oFntTit07,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin+35,nMaxCol*.07,TRANSFORM(SZ3->Z3_DTFIM,"@D 99/99/9999")   	,oFntTit07,ALIN_LEFT,ALIN_LEFT,,0)
Else
	cContra := "" 
	cPer 	:= ""
	lContra := .f.
    For nx:=1 to Len(SE2->E2_XCONTRA)
		If SubStr(SE2->E2_XCONTRA,nx,1) $ "P0123456789" .and. !lContra 
			cContra := cContra + SubStr(SE2->E2_XCONTRA,nx,1) 
		Else
			lContra := .t.
			If SubStr(SE2->E2_XCONTRA,nx,1) $ "0123456789" 
				cPer := cPer + SubStr(SE2->E2_XCONTRA,nx,1) 
			EndIf
		EndIf		    
    Next
	oPrn:Say(nLin   ,nMaxCol*.01,cContra                        				,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin+35,nMaxCol*.01,cPer                       					,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin   ,nMaxCol*.07,TRANSFORM(SE2->E2_XDTINIC,"@D 99/99/9999")  	,oFntTit07,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin+35,nMaxCol*.07,TRANSFORM(SE2->E2_XDTFIM,"@D 99/99/9999")   	,oFntTit07,ALIN_LEFT,ALIN_LEFT,,0)
EndIf
// // 16/04/15 - Luis Felipe - Fim                                              

If SE2->E2_XSUBTIP = "7"
	oPrn:Say(nLin   ,nMaxCol*.14,SubStr(cTipo,1,11)                    	  		,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
	oPrn:Say(nLin+35,nMaxCol*.14,SubStr(cTipo,13,04)                    	  	,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
Else
	oPrn:Say(nLin   ,nMaxCol*.14,cTipo                    	  					,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
EndIf	

If SE2->E2_XSUBTIP $ "4/5/6"
	oPrn:Say(nLin+35   ,nMaxCol*.17,Str(SE2->E2_XPERPGT,3)+"%"	  				,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0)
EndIf

CTH->(DbSetOrder(1))
CTH->(DbSeek(xFilial("CTH")+SE2->E2_NAVIO))

oPrn:Say(nLin    ,nMaxCol*.26,SubStr(SZE->ZE_NOME,1,22)         		  		  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0)
oPrn:Say(nLin+35 ,nMaxCol*.26,SubStr(SZE->ZE_NOME,23,22)        		  		  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0)
oPrn:Say(nLin    ,nMaxCol*.45,SubStr(SE2->E2_XBOOK,1,12)              		  	  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
oPrn:Say(nLin+35 ,nMaxCol*.45,SubStr(SE2->E2_XBOOK,13,3)              		  	  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 

If Len(Alltrim(CTH->CTH_DESC01)) > 20
	oPrn:Say(nLin-35 ,nMaxCol*.57,Substr(CTH->CTH_DESC01,1,09)          		  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
	oPrn:Say(nLin    ,nMaxCol*.57,Substr(CTH->CTH_DESC01,10,09)         		  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
	oPrn:Say(nLin+35 ,nMaxCol*.57,Substr(CTH->CTH_DESC01,19,09)         		  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
	oPrn:Say(nLin+70 ,nMaxCol*.57,Substr(CTH->CTH_DESC01,28,09)         		  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
Else
	oPrn:Say(nLin    ,nMaxCol*.57,Substr(CTH->CTH_DESC01,1,09)          		  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
	oPrn:Say(nLin+35 ,nMaxCol*.57,Substr(CTH->CTH_DESC01,10,09)         		  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
	oPrn:Say(nLin+70 ,nMaxCol*.57,Substr(CTH->CTH_DESC01,19,02)         		  ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0) 
EndIf

oPrn:Say(nLin    ,nMaxCol*.64,TRANSFORM(SE2->E2_QTDTON ,"@E     999,999,999.999"),oFntTit08,ALIN_LEFT,ALIN_LEFT,,0)
oPrn:Say(nLin    ,nMaxCol*.73,TRANSFORM(SE2->E2_VLORIG ,"@E     999,999,999.99") ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0)

nConvAmt :=  SE2->E2_VLORIG / SE2->E2_TXUSD
oPrn:Say(nLin    ,nMaxCol*.82,TRANSFORM(nConvAmt       ,"@E     999,999,999.99") ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0)
oPrn:Say(nLin    ,nMaxCol*.88,TRANSFORM(SE2->E2_PREPGR ,"@E     999,999,999.99") ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0)
oPrn:Say(nLin    ,nMaxCol*.93,TRANSFORM(SE2->E2_PREPAGO,"@E     999,999,999.99") ,oFntTit08,ALIN_LEFT,ALIN_LEFT,,0)

nLin += 235

If !Empty(SE2->E2_XTPDES1)
	SX5->(dbSeek(xFilial("SX5")+"Z1"+SE2->E2_XTPDES1))
	aSX5 := FWGetSX5("Z1",SE2->E2_XTPDES1,"en")
	oPrn:Say(nLin   ,nMaxCol*.01,aSX5[1,4]                          		  		,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin   ,nMaxCol*.27,SE2->E2_XPERIOD                       		  		,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin   ,nMaxCol*.29,TRANSFORM(SE2->E2_QTDTON ,"@E    999,999,999.999") ,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin   ,nMaxCol*.38,TRANSFORM(SE2->E2_XVLDC1 ,"@E     999,999,999.99") ,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
EndIf

nLin += 35

If !Empty(SE2->E2_XTPDES2)
	SX5->(dbSeek(xFilial("SX5")+"Z1"+SE2->E2_XTPDES2))
	aSX5 := FWGetSX5("Z1",SE2->E2_XTPDES2,"en")
	oPrn:Say(nLin  ,nMaxCol*.01,aSX5[1,4]                       		  			,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin   ,nMaxCol*.38,TRANSFORM(SE2->E2_XVLDC2 ,"@E     999,999,999.99") ,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
EndIf

nLin += 35

If !Empty(SE2->E2_XTPDES3)
	SX5->(dbSeek(xFilial("SX5")+"Z1"+SE2->E2_XTPDES3))
	aSX5 := FWGetSX5("Z1",SE2->E2_XTPDES3,"en")
	oPrn:Say(nLin  ,nMaxCol*.01,aSX5[1,4]                       		  			,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin   ,nMaxCol*.38,TRANSFORM(SE2->E2_XVLDC3 ,"@E     999,999,999.99") ,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
EndIf

nLin += 140

If !Empty(SE2->E2_XTPAC1)
	SX5->(dbSeek(xFilial("SX5")+"Z2"+SE2->E2_XTPAC1))
	aSX5 := FWGetSX5("Z2",SE2->E2_XTPAC1,"en")
	oPrn:Say(nLin  ,nMaxCol*.01,aSX5[1,4]                       		  			,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin   ,nMaxCol*.38,TRANSFORM(SE2->E2_XVLAC1 ,"@E     999,999,999.99") ,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
EndIf

nLin += 35

If !Empty(SE2->E2_XTPAC2)
	SX5->(dbSeek(xFilial("SX5")+"Z2"+SE2->E2_XTPAC2))
	aSX5 := FWGetSX5("Z2",SE2->E2_XTPAC2,"en")
	oPrn:Say(nLin  ,nMaxCol*.01,aSX5[1,4]   	                   		  			,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin   ,nMaxCol*.38,TRANSFORM(SE2->E2_XVLAC2 ,"@E     999,999,999.99") ,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
EndIf

nLin += 35

If !Empty(SE2->E2_XTPAC3)
	SX5->(dbSeek(xFilial("SX5")+"Z2"+SE2->E2_XTPAC3))
	aSX5 := FWGetSX5("Z2",SE2->E2_XTPAC3,"en")
	oPrn:Say(nLin  ,nMaxCol*.01,aSX5[1,4]	                   		  			,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
	oPrn:Say(nLin   ,nMaxCol*.38,TRANSFORM(SE2->E2_XVLAC3 ,"@E     999,999,999.99") ,oFntTit09,ALIN_LEFT,ALIN_LEFT,,0)
EndIf

oPrn:EndPage()

Return

************************
Static Function LayOut()
************************

Local cFileLogo := FisxLogo("1")

oPrn:SayBitMap(060,0100,cFileLogo,0360,0250)

nLin := 150

oPrn:Say(nLin+0120,1000,"PAYMENT REQUEST" 			,oFntTitulo,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0350,nMaxCol*.010,"PAYMENT ID:"     	,oFntTit16 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0500,nMaxCol*.010,"Paid By"       	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0500,nMaxCol*.380,"Nature Type"  		,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0500,nMaxCol*.720,"Expense"      		,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0500,nMaxCol*.095,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0500,nMaxCol*.510,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0500,nMaxCol*.805,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0560,nMaxCol*.010,"Paid To"			,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0560,nMaxCol*.380,"Value Dt."			,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0560,nMaxCol*.720,"US$ Rate"      	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0560,nMaxCol*.095,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0560,nMaxCol*.510,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0560,nMaxCol*.805,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0610,nMaxCol*.010,"CNPJ"				,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0610,nMaxCol*.380,"Amount R$"			,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0610,nMaxCol*.720,"Method" 			,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0610,nMaxCol*.095,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0610,nMaxCol*.510,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0610,nMaxCol*.805,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0660,nMaxCol*.010,"Supplier"  	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0660,nMaxCol*.380,"Interest Rate"  	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0660,nMaxCol*.510,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0800,nMaxCol*.010,"LOCAL BANK INFORMATION "   ,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0800,nMaxCol*.500,"FOREIGN BANK INFORMATION " ,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0860,nMaxCol*.010,"Bank" 				,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0860,nMaxCol*.500,"Bank Name"     	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0860,nMaxCol*.132,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0860,nMaxCol*.620,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0910,nMaxCol*.010,"Branch Name"      	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0910,nMaxCol*.500,"Branch Name"		,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0910,nMaxCol*.132,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0910,nMaxCol*.620,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0960,nMaxCol*.010,"Account Nbr"    	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0960,nMaxCol*.500,"Account Nbr"     	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+0960,nMaxCol*.132,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+0960,nMaxCol*.620,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+1010,nMaxCol*.010,"Address"        	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1010,nMaxCol*.132,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1010,nMaxCol*.500,"ABA"		      	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1010,nMaxCol*.620,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+1060,nMaxCol*.500,"FED Number"      	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1060,nMaxCol*.620,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+1110,nMaxCol*.500,"CHIPS UID"     	,oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1110,nMaxCol*.620,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+1110,nMaxCol*.720,"Swift",oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1110,nMaxCol*.805,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+1160,nMaxCol*.500,"Address",oFntCp12 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1160,nMaxCol*.620,":"             	,oFntCp12 ,ALIN_MIDDLE,,,0)

// Notes
DrawBox(nLin+1300,0010       ,nLin+1350,nMaxCol    ,"Notes" ,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1300,0010       ,nLin+1530,nMaxCol    ,""      ,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})

oPrn:Say(nLin+1550,nMaxCol*.010," Payment Allocation: " ,oFntCp12 ,ALIN_MIDDLE,,,0)

// Payment Allocation
DrawBox(nLin+1600,0010       ,nLin+1770,nMaxCol*.06,""                  ,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1600,nMaxCol*.06,nLin+1770,nMaxCol*.13,""                  ,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1600,nMaxCol*.13,nLin+1770,nMaxCol*.25,""          	    ,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1600,nMaxCol*.25,nLin+1770,nMaxCol*.44,""                  ,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1600,nMaxCol*.44,nLin+1770,nMaxCol*.56,""                 	,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1600,nMaxCol*.56,nLin+1770,nMaxCol*.65,""                 	,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1600,nMaxCol*.65,nLin+1770,nMaxCol*.73,""                 	,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1600,nMaxCol*.73,nLin+1770,nMaxCol*.82,""                	,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1600,nMaxCol*.82,nLin+1770,nMaxCol*.90,""                 	,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1600,nMaxCol*.90,nLin+1770,nMaxCol*.95,""                 ,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)
DrawBox(nLin+1600,nMaxCol*.95,nLin+1770,nMaxCol    ,""                 ,oFntTit09,ALIN_LEFT,ALIN_TOP,.T.,RGB_FUNDOC)

DrawBox(nLin+1770,0010       ,nLin+1930,nMaxCol*.06,""  				,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
DrawBox(nLin+1770,nMaxCol*.06,nLin+1930,nMaxCol*.13,""               	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
DrawBox(nLin+1770,nMaxCol*.13,nLin+1930,nMaxCol*.25,""                  ,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
DrawBox(nLin+1770,nMaxCol*.25,nLin+1930,nMaxCol*.44,""                  ,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
DrawBox(nLin+1770,nMaxCol*.44,nLin+1930,nMaxCol*.56,""                  ,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
DrawBox(nLin+1770,nMaxCol*.56,nLin+1930,nMaxCol*.65,""               	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
DrawBox(nLin+1770,nMaxCol*.65,nLin+1930,nMaxCol*.73,""               	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
DrawBox(nLin+1770,nMaxCol*.73,nLin+1930,nMaxCol*.82,""               	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
DrawBox(nLin+1770,nMaxCol*.82,nLin+1930,nMaxCol*.90,""               	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
DrawBox(nLin+1770,nMaxCol*.90,nLin+1930,nMaxCol*.95,""               	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
DrawBox(nLin+1770,nMaxCol*.95,nLin+1930,nMaxCol    ,""              	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})

oPrn:Say(nLin+1670,0020        ,"Contract"		,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1640,nMaxCol*.067,"Delivery"  	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1670,nMaxCol*.180,"Type"  		,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1670,nMaxCol*.310,"Location"  	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1670,nMaxCol*.475,"Booking"  		,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1670,nMaxCol*.580,"Shipment"  	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1670,nMaxCol*.660,"Quantity"  	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1640,nMaxCol*.750,"Amount"  		,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1640,nMaxCol*.830,"Converted"  	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1620,nMaxCol*.910,"Unit"  		,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1620,nMaxCol*.960,"Unit"  		,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+1690,nMaxCol*.067,"Period"  		,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1690,nMaxCol*.760,"R$"         	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1690,nMaxCol*.845,"Amt"        	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1670,nMaxCol*.910,"Cost"    		,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1670,nMaxCol*.960,"Cost"    		,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+1720,nMaxCol*.910,"R$"      		,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1720,nMaxCol*.960,"US$"     		,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+1945,nMaxCol*.010,"Discount" 		,oFntCp11  ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+1980,nMaxCol*.010,"Description Delivery Period                   Qty     Amount R$" ,oFntCp11 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2150,nMaxCol*.010,"Increase" 		,oFntCp11 ,ALIN_MIDDLE,,,0)


oPrn:Say(nLin+2000,nMaxCol*.690,"Authorized By:",oFntCp12 ,ALIN_MIDDLE,,,0)

nheight := 0
For nx:=1 to 10
	nheight += 70
	DrawBox(nLin+2024+nheight,nMaxCol*.51,nLin+2094+nheight,nMaxCol*.56    ,"" 	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
	DrawBox(nLin+2024+nheight,nMaxCol*.56,nLin+2094+nheight,nMaxCol*.75    ,"" 	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
	DrawBox(nLin+2024+nheight,nMaxCol*.75,nLin+2094+nheight,nMaxCol*.80    ,"" 	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
	DrawBox(nLin+2024+nheight,nMaxCol*.80,nLin+2094+nheight,nMaxCol        ,"" 	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})
Next 

oPrn:Say(nLin+2112,nMaxCol*.525,"CG:"   ,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2112,nMaxCol*.760,"Date:"	,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2187,nMaxCol*.525,"RO:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2187,nMaxCol*.760,"Date:"	,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2260,nMaxCol*.525,"GO:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2260,nMaxCol*.760,"Date:"	,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2329,nMaxCol*.525,"EP:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2329,nMaxCol*.760,"Date:"	,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2405,nMaxCol*.525,"RD:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2405,nMaxCol*.760,"Date:"	,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2475,nMaxCol*.525,"FD:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2475,nMaxCol*.760,"Date:"	,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2542,nMaxCol*.525,"TC:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2542,nMaxCol*.760,"Date:"	,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2612,nMaxCol*.525,"TP:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2612,nMaxCol*.760,"Date:"	,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2675,nMaxCol*.525,"RS:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2675,nMaxCol*.760,"Date:"	,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2750,nMaxCol*.525,"LM:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2750,nMaxCol*.760,"Date:"	,oFntTit09 ,ALIN_MIDDLE,,,0)

PswOrder(1)
PswSeek(SE2->E2_XUSERID)
aUser := PswRet()   
cNome := aUser[1][2]     // Nome do Usuário (C,15)

DrawBox(nLin+2350,0010       ,nLin+2800,nMaxCol*.51,"" 	,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})

oPrn:Say(nLin+2450,nMaxCol*.020,"Request By:"				,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2450,nMaxCol*.100,Upper(cNome)				,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2450,nMaxCol*.320,"Date: "+DtoC(SE2->E2_EMISSAO) ,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2550,nMaxCol*.020,"Agreed By:"				,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2550,nMaxCol*.100,"GO ___________________"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2550,nMaxCol*.310,"Date: _____/_____/_____ "  ,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2650,nMaxCol*.100,"TC ___________________"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2650,nMaxCol*.310,"Date: _____/_____/_____"   ,oFntTit09 ,ALIN_MIDDLE,,,0)

DrawBox(nLin+2800,0010       ,nLin+3000,nMaxCol    ,"" 		,oFntTit09,ALIN_LEFT,ALIN_TOP,.F.,{})

oPrn:Say(nLin+2850,nMaxCol*.035,"First Authorization By:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2850,nMaxCol*.300,"Date: _____/_____/_____ "  ,oFntTit09 ,ALIN_MIDDLE,,,0)

oPrn:Say(nLin+2930,nMaxCol*.020,"Second Authorization By:"	,oFntTit09 ,ALIN_MIDDLE,,,0)
oPrn:Say(nLin+2930,nMaxCol*.300,"Date: _____/_____/_____ "  ,oFntTit09 ,ALIN_MIDDLE,,,0)

Return

*****************************************************************************
Static Function DrawBox(Y1,X1,Y2,X2,cTexto,oFont,nAlinH,nAlinV,lFundo,aFundo)
*****************************************************************************

nTamHgt := 0
nTamWdt := 0
nPosV   := 0
nPosH   := 0
nAlin   := 0

//Desenhando o BOX
oPrn:Box(Y1,X1,Y2,X2)// linha inicial, coluna inicial, linha final, coluna final

//Cor de Fundo do BOX
If lFundo
	oBru01 := TBrush():New(,RGB(aFundo[1],aFundo[2],aFundo[3]))
	oPrn:FillRect({Y1+2,X1+2,Y2-2,X2-2}, oBru01)
EndIf

//Texto a ser Incluido ao BOX
If Len(cTexto) > 0
	nTamHgt := oPrn:GetTextHeight(cTexto,oFont)
	nTamWdt := oPrn:GetTextWidth(cTexto ,oFont)
	
	//Ponto Vertical
	If nAlinV = ALIN_MIDDLE
		nPosV := ((Y1 + Y2) / 2) - (nTamHgt/4)
	ElseIf nAlinV = ALIN_BOTTOM
		nPosV := Y2 - nTamHgt - 10
	Else
		nPosV := Y1 + 10
	EndIf
	
	//Ponto Horizontal
	If nAlinH = ALIN_MIDDLE
		nPosH := (X1 + X2) / 2
		nAlin := 2
	ElseIf nAlinH = ALIN_RIGHT
		nPosH  := X2 - 20
		nAling := 1
	Else
		nPosH  := X1 + 20
		nAling := 0
	EndIf
EndIf

oPrn:Say(nPosV,nPosH,cTexto,oFont,,,,nAlin)

Return

**************************
Static Function fLegenda()
**************************

aLegenda := {}
For L:=1 To Len(aCores)
	Aadd(aLegenda,{aCores[L,2],aCores[L,3]})
Next
BrwLegenda("Legenda","Status",aLegenda)
oBrwSel:SetFocus()

Return
