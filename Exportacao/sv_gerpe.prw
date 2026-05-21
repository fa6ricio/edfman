#include "protheus.ch"

/*
**	Função 
**	Descrição: 
**	Autor : 
**	Data: 
*/
*------------------------------------------------------------------------------------------------------------------*

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SV_GerPe  ºAutor  ³Alexandre Santos    º Data ³  22/17/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³  Alexandre Santos - 22/07/2013 Alterado para tratar fator  º±±
±±º          ³  de conversão atraves da função U_EDFFATOR(Par01)          º±±
±±º          ³  Par01 - Código do produto                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function SV_GerPe(cPedFat, cIdioma, cIncoterm, cCodForn, cLojaForn, cNForn, cViTransp, cOrigem, cDestino, cTpTrans, cPais, cEmbalagem, nQtdEmba, cFabr, cFabrlo)

Local nOldMod := nMOdulo
Local cOldMod := cModulo

private cCodBauche := cCodforn
private cLojaBauche := cLojaForn
private cDescBauche := cNForn
private cNumPex
Private cFilEE

dbSelectArea("EE7")
cNumpex := cPedFat // GetSxEnum("EE7", "EE7_PEDIDO",,1)

//Begin Transaction
   //alert("GravaEE7")
   GravaEE7(cPedFat, cIdioma, cIncoterm, cViTransp,cOrigem,cDestino,cTpTrans, cPais)
   //alert("GravaEE8")
   GravaEE8(cPedFat, cEmbalagem, nQtdEmba, cFabr, cFabrlo)
   cModulo := "EEC"
   nModulo := 29
   LTRATCOMIS := .F.
   COCORRE := ""
   //alert("Inicio AP105CallPrecoI")
   AP105CallPrecoI(,.F.)
   //alert("Fim AP105CallPrecoI")
//End Transaction

nMOdulo := nOldMod
cModulo := cOldMod

return .T.

/*
**	Função 
**	Descrição: 
**	Autor : 
**	Data: 
*/
*------------------------------------------------------------------------------------------------------------------*
Static Function GravaEE7(cPedFat, cIdioma, cIncoterm, cViTransp, cOrigem, cDestino,cTpTrans, cPais)
cFilEE := xFilial("EE7")

dbSelectArea("SC5")
SC5->(dbSetOrder(1))


SC5->(dbSeek(xFilial("SC5")+cPedFat))

if !SC5->(EOF())
	Reclock("EE7",.T.)
	EE7->EE7_FILIAL := cFilEE
	EE7->EE7_PEDIDO := M->cNumPex
	EE7->EE7_PEDFAT := M->cPedFat
	EE7->EE7_DTPROC := Date()
	EE7->EE7_DTPEDI := SC5->C5_EMISSAO
	EE7->EE7_IMPORT := SC5->C5_CLIENTE
	EE7->EE7_IMLOJA := SC5->C5_LOJACLI
	EE7->EE7_IMPODE := GetNClie(SC5->C5_CLIENTE, SC5->C5_LOJACLI)
	GetEndClie() 
	EE7->EE7_FORN   := M->cCodBauche
	EE7->EE7_FOLOJA := M->cLojaBauche
	//EE7->EE7_FORNDE := M->cDescBauche 
	EE7->EE7_IDIOMA := M->cIdioma
	EE7->EE7_CONDPA := BscCondPagEEC(SC5->C5_CONDPAG)
	EE7->EE7_DIASPA := SY6->Y6_DIAS_PA
	EE7->EE7_MPGEXP := GetMpgexp(EE7->EE7_CONDPA)
	EE7->EE7_INCOTE := M->cIncoterm
	EE7->EE7_MOEDA  := getMoeda(SC5->C5_MOEDA)
	EE7->EE7_FRPPCC := "PP"
	EE7->EE7_CALCEM := "2"  
	EE7->EE7_VIA    := M->cViTransp
	EE7->EE7_ORIGEM := M->cOrigem
	EE7->EE7_DEST   := M->cDestino
	//EE7->EE7_DSCORI := GetDesc(cOrigem)
	//EE7->EE7_DSCDES := GetDesc(cDestino)
	EE7->EE7_TIPTRA := M->cTpTrans
	EE7->EE7_PAISET := M->cPais 
	//EE7->EE7_KEY    := AP101GetKey("P")
    EE7->EE7_AMOSTR := "2"
    
    *'yTTALO P MARTINS-INICIO--------'*
	EE7->EE7_XSEQPV := SC5->C5_XSEQPV
	*'yTTALO P MARTINS-FIM-----------'*        		
		
	EE7->(MSUnlock())
	
	RecLock("SC5", .F.)	
	SC5->C5_PEDEXP := cNumPex	
	SC5->(MSUnlock())
endif

return

*------------------------------------------------------------------------------------------------------------------*
Static Function GravaEE8(cPedFat, cEmbalagem, nQtdEmba, cFabrit, cFabrloja)
local cEmbalagem
local nQtdEmba
Local cDesc := ""
Local nPesoEmb := 1 // 07/06/13 - Luis Felipe Nascimento // Necessário pelo liquido e bruto por item SC6 e regravar na EE8     
Local nFator   := 1 	  // Alexandre Santos - 22/07/2013 - Alteracao para retirar o valor pre-fixado 

private nPesoit
private cNcmit
private cDescit 

dbSelectArea("SC6")
SC6->(dbSeek(xFilial("SC6")+cPedFat))

if !SC6->(EOF())                      

    nFator := U_EDFFATOR(SC6->C6_PRODUTO) 	  // Alexandre Santos - 22/07/2013 - Alteracao para retirar o valor pre-fixado      

	GetDItem(SC6->C6_PRODUTO)
	cDesc := GetVMDESIT(SC6->C6_PRODUTO)

	Reclock("EE8", .T.)
	EE8->EE8_FILIAL  := cFilEE 
	EE8->EE8_PEDIDO  := cNumPex
	EE8->EE8_SEQUEN  := SC6->C6_ITEM
	EE8->EE8_COD_I   := SC6->C6_PRODUTO
	//EE8->EE8_UNIDAD  := SC6->C6_UM                 
    EE8->EE8_UNIDAD  := "TM"                                                                                           

	//EE8->EE8_VM_DES  := M->cDescit
	EE8->EE8_FORN    := M->cCodBauche
	EE8->EE8_FOLOJA  := M->cLojaBauche
//	EE8->EE8_FABR    := M->cFabrit     // 03/08/17 - Luis Felipe
//	EE8->EE8_FALOJA  := M->cFabrloja
	//EE8->EE8_SLDINI  := SC6->C6_QTDVEN
	//EE8->EE8_SLDATU  := SC6->C6_QTDVEN                                                                                               L
	EE8->EE8_SLDINI  := n_Qtde
	EE8->EE8_SLDATU  := n_Qtde 
//	EE8->EE8_UNPRC   := "TM"  // 19/02/14 - Luis Felipe
	
	EE8->EE8_UNPRC   :=	Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_UM") // 11/03/16 ENS
	
	EE8->EE8_EMBAL1  := M->cEmbalagem
	EE8->EE8_QE      := M->nQtdEmba
	EE8->EE8_QTDEM1  := M->(EE8->EE8_SLDATU / nQtdEmba)
	EE8->EE8_PRECO   := SC6->C6_PRCVEN
	EE8->EE8_PSLQUN  := (M->nPesoit*nFator)   // Alexandre Santos - 22/07/2013 
	//EE8->EE8_PSLQUN  := (M->nPesoit*20)   // Alexandre Santos - 22/07/2013 
	EE8->EE8_POSIPI  := M->cNcmit
	EE8->EE8_TES     := SC6->C6_TES
	EE8->EE8_CF      := GetCF(SC6->C6_TES) 
	EE8->EE8_FATIT   := SC6->C6_ITEM 
	EE8->EE8_LOCAL 	 := SC6->C6_LOCAL // 25/04/14 - Luís Felipe Nascimento
	EE8->EE8_PSLQTO  := M->(EE8->EE8_SLDATU * EE8->EE8_PSLQUN) 
	IF EE5->(dbSeek(xFilial("EE5")+cEmbalagem))
           nPesoEmb:=EE5->EE5_PESO   
	ENDIF 
	EE8->EE8_PSBRTO  := EE8->EE8_PSLQTO + (EE8->EE8_QTDEM1 * nPesoEmb)
	EE8->EE8_PSBRUN  := M->(EE8->EE8_PSBRTO / EE8->EE8_QTDEM1)
	    
    //	MSMM(,,,ALLTRIM(cDesc),1,,,"EE8","EE8_DESC") ENS 03/03/16      
   
	IF EMPTY(ALLTRIM(EE8->EE8_DESC) )
      	lIncMSMM:=.T.
		nNumMsmm:=0
   		SYP->(DBSEEK(xFilial()+'z',.T.))
   		SYP->(DBSKIP(-1))
   		nNumMsmm:=VAL(SYP->YP_CHAVE)
		nNumMsmm+=1
		MSMM(IF(!lIncMSMM,EE8->EE8_DESC,IF(.F.,STRZERO(nNumMsmm,6),)),TAMSX3("EE8_VM_DES")[1],,ALLTRIM(cDesc),1,,,"EE8","EE8_DESC") //ENS 03/03/16 
	ENDIF
	
	MSMM(,,,ALLTRIM(cDesc),1,,,"EE8","EE8_DESC")
 
	EE8->(MSUnlock()) 

Endif

return
*------------------------------------------------------------------------------------------------------------------*
Static Function GetNClie(cCodClie,cLoja)
local cNome := ""

dbSelectArea("SA1")

SA1->(dbSeek(xFilial("SA1")+cCodClie+cLoja))
if !SA1->(EOF())
	cNome := SA1->A1_NOME

endif

return cNome 
 
Static Function GetEndClie()
Private cEnd, cComp := ""

dbSelectArea("SA1")

SA1->(dbSeek(xFilial("SA1")+ SC5->C5_CLIENTE + SC5->C5_LOJACLI))
if !SA1->(EOF())
	cEnd  := SA1->A1_END
	cComp := alltrim(SA1->A1_BAIRRO) +" - "+E_FIELD("A1_PAIS","YA_DESCR") 
	EE7->EE7_ENDIMP := M->cEnd
	EE7->EE7_END2IM := M->cComp
	
endif

return ()

*------------------------------------------------------------------------------------------------------------------*
Static Function GetDItem(cCodItem)

dbSelectArea("SB1")

SB1->(dbSeek(xFilial("SB1")+cCodItem))
if !SB1->(EOF())
	nPesoit   := SB1->B1_PESO
	cNcmit    := SB1->B1_POSIPI
	cDescit   := SB1->B1_DESC
endif

return

*------------------------------------------------------------------------------------------------------------------*
Static Function GetMpgexp(cCodPag)
local cMgp := ""

dbSelectArea("SY6")

SY6->(dbSeek(xFilial("SY6")+cCodPag))
if !SY6->(EOF())
	cMgp := SY6->Y6_MDPGEXP
endif

return cMgp

*------------------------------------------------------------------------------------------------------------------*
Static Function GetCF(cCodTes)
local cCF := ""

dbSelectArea("SF4")

SF4->(dbSeek(xFilial("SF4")+cCodTes))
if !SF4->(EOF())
	cCF := SF4->F4_CF
endif

return cCF

*------------------------------------------------------------------------------------------------------------------*
Static Function GetDesc(cCod)
local cCF := ""

dbSelectArea("SY9")

SY9->(dbSeek(xFilial("SY9")+cCod))
if !SY9->(EOF())
	cCF := SY9->Y9_DESCR
endif

return cCF

*------------------------------------------------------------------------------------------------------------------*
Static Function GetMoeda(nNum)
local cCF := ""

dbSelectArea("SYF")    
SYF->(dbSeek(xFilial()))

while !SYF->(EOF() .And. YF_FILIAL == xFilial("SYF"))
   if SYF->YF_MOEFAT == nNum
    	cCF := SYF->YF_MOEDA
    	EXIT
   endif
SYF->(dbSkip())
end

return cCF

*------------------------------------------------------------------------------------------------------------------*
Static Function BscCondPagEEC(cCondPagSiga)
local cCF := ""

SY6->(dbSeek(xFilial()))
while !SY6->(EOF() .And. Y6_FILIAL == xFilial("SY6"))
   if SY6->Y6_SIGSE4 == cCondPagSiga
	  cCF := SY6->Y6_COD
	  EXIT
   endif
   SY6->(dbSkip())
end

return cCF

*------------------------------------------------------------------------------------------------------------------*
Static Function GetVMDESIT(cCodItem)
local nOldArea := Select()
local cMemo :=""
dbSelectArea("EE2")
EE2->(dbSetOrder(2))
if EE2->(dbSeek(xFilial()+"3*"+cCodItem+cIdioma))
	cMemo := MSMM(EE2->EE2_TEXTO, AVSX3("EE2_VM_TEX",3) ,,,3)
endif 

IF EMPTY (cMemo)
	SB1->(dbSeek(xFilial("SB1")+cCodItem))
	cMemo:= SB1->B1_DESC
ENDIF // 03/03/16 ENS

dbSelectArea(nOldArea)

return cMemo