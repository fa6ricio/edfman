#INCLUDE "PROTHEUS.CH"                                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Imp_SZ4   ºAutor  ³ADRIANO MIGOTO PINTO  Data ³  23/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPORTAÇÃO DE CONHECIMENTOS DE TRANSPORTES                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ImpConhec()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg1
Local oBtnOk
Local oBtnCancel
/*
Define MSDialog oDlg Title "Importação de Conhecimentos" From 186,241 To 250,800 Pixel
   @10,200 Button oBtnOk     Prompt "&Importar"       Size 30,15 Pixel ;
             Action (RunCont(), oDlg:End()) Of oDlg
   @10,240 Button oBtnCancel Prompt "&Cancelar" Size 30,15 Pixel ;
              Action ( oDlg:End()) Cancel Of oDlg
Activate MSDialog oDlg Centered
Return(NIL)


Static Function RunCont
*/

// VARIÁVEIS PARA GERAR LOG
Local aLOG			:= {}  
Local aLOG2			:= {}
// VARIÁVEIS DE MANIPULAÇÃO
Local nTamFile, nTamLin, cBuffer, nBtLidos, _lint, _ultlint
Local col := y := x := u := 0
Local tamcol := colini := 0
Local coluna	:= {}                               
Private nHdl
Private mv_par01 := space(60)  // diretório + arquivo a ser migrado     
mv_par01 := cGetFile ( '*.*' , 'Localize o arquivo:', , , .F., GETF_LOCALHARD + GETF_NETWORKDRIVE)
If empty(mv_par01)
   //msgAlert("Escolha um arquivo!")
   Return
Endif
nHdl    := fOpen(mv_par01,68)
nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
ft_fuse(mv_par01)
FT_FGOTOP()
ProcRegua(nTamFile*1000)
While ! ft_feof()
	_item := 0
	IncProc()
	cBuffer := ft_freadln()+";"
	col := 0
	tamcol := 0
	colini := 0
	coluna := {}
	For x := 0 to Len(cBuffer)
		If Substr(cBuffer,x,1) == ";"
			aAdd(coluna,{colini+1,tamcol-1})
			colini := x
			tamcol := 0
			tamcol ++
		ElSe
			tamcol ++
		EndIf
	Next                 
	
	xTIPONF    := "N"
	xFORMUL    := "N"
	XNF        := ""     //03
	xSERIE     := "U"
	xEMISSAO   := ""     //04
	xFORNEC    := ""     //01
	xLOJA      := ""     //02
	xCONDPAG   := ""     //15
	xTIPODOC   := ""
	xCODPROD   := "000009"
	xITEM      := "001"
	xUM        := ""
    xQUANTIDADE:= 1
    xVALORUN   := ""     //10
    xVALORTOT  := ""     //10
    xLOCPAD    := ""
    xTES       := "012" 
    xCONTRATO  := ""         
    xNOMFOR    := ""
	
	For u := 0 to Len(coluna)                                                       
		if     u == 1
		   // FORNECEDOR                        
		   XCNPJ      := trim(substr(cBuffer,coluna[u][1],coluna[u][2]))		   
		   dbSelectArea("SA2")
		   dbsetorder(3)
		   dbseek(xFilial("SA2")+XCNPJ)
		   xFORNEC :="" 
		   xLOJA   :=""
		   if ! SA2->(eof())
		      xFORNEC := SA2->A2_COD
		      xLOJA   := SA2->A2_LOJA       
		      xNOMFOR := SA2->A2_NOME
		   endif
		elseif u == 2
		   XNF      := trim(substr(cBuffer,coluna[u][1],coluna[u][2])) // NÚMERO DO CONHECIMENTO DE TRANSPORTE
		elseif u == 3
		   xEMISSAO := CTOD(substr(cBuffer,coluna[u][1],coluna[u][2]))            
		elseif u == 4
		   xSERIE     := "U  "                                                                                  
		elseif u == 5
		   // NESSA POSIÇÃO FICA A NOTA FISCAL, ESSA NÃO SERÁ GRAVADA.
		elseif u == 6
		   //xQUANTIDADE:= VAL(substr(cBuffer,coluna[u][1],coluna[u][2]))   
		elseif u == 7
		   // PESO
		   xQUANTIDADE:= VAL(substr(cBuffer,coluna[u][1],coluna[u][2]))   
		elseif u == 8
		   xVALORUN  := VAL(substr(cBuffer,coluna[u][1],coluna[u][2]))   
		elseif u == 9   
		   xVALORTOT := VAL(substr(cBuffer,coluna[u][1],coluna[u][2]))   
	    elseif u == 10
	       xCODPROD   := "000009"
	    elseif u == 11   
	       //placa
	    elseif u == 12
	       xNAVIO     := trim(substr(cBuffer,coluna[u][1],coluna[u][2]))
	    elseif u == 13
	       //loja
	    elseif u == 14
           xTES       := trim(substr(cBuffer,coluna[u][1],coluna[u][2]))
        elseif u == 15
           xCONDPAG   := trim(substr(cBuffer,coluna[u][1],coluna[u][2]))
        elseif u == 16
           xESPECIE   := trim(substr(cBuffer,coluna[u][1],coluna[u][2]))      
        elseif u == 17
           xCONTRATO   := trim(substr(cBuffer,coluna[u][1],coluna[u][2]))      
           
        endif   
	Next                         
	                
	DBSELECTAREA("SF1")
	DBSETORDER(1)
	IF !DBSEEK(xFILIAL("SF1")+XNF+SPACE(9-LEN(XNF))+"U  "+xFORNEC+xLOJA)                        
       IF xFORNEC <>"" 
          GravaNota(xTIPONF, xFORMUL, xNF, xSERIE, xEMISSAO, xFORNEC, xLOJA, xCONDPAG, xTIPODOC, xCODPROD, xITEM, xUM,;
          xQUANTIDADE, xVALORUN, xVALORTOT, xLOCPAD, xNAVIO, xESPECIE, xCONTRATO)
       ENDIF   
    endif
    ft_fskip()
EndDo                                             
mv_par01=""
msginfo("Operação Concluída !")
Return                                                                   


Static Function GravaNota(TIPONF, FORMUL, NF, SERIE, EMISSAO, FORNEC, LOJA, CONDPAG, TIPODOC,CODPROD, ITEM, UM,;
 QUANTIDADE, VALORUN, VALORTOT, LOCPAD, NAVIO, ESPECIE)
Local aCab :={}
Local aItem:={}
aCab := {;
{"F1_TIPO"   , TIPONF   ,NIL},;
{"F1_FORMUL" , Formul   ,NIL},;
{"F1_DOC"    , NF       ,NIL},;
{"F1_SERIE"  , SERIE    ,NIL},;
{"F1_EMISSAO", EMISSAO  ,NIL},;
{"F1_FORNECE", FORNEC   ,NIL},;
{"F1_LOJA"   , LOJA     ,NIL},;
{"F1_ESPECIE", ESPECIE  ,NIL},;
{"F1_BASEICM", 0        ,NIL},;
{"F1_VALICM" , 0        ,NIL},;
{"F1_VALIPI" , 0        ,NIL},;
{"F1_ICMSRET", 0        ,NIL},;
{"F1_VALMERC", VALORTOT ,NIL},;
{"F1_VALBRUT", VALORTOT ,NIL},;
{"F1_ORIGEM" , "LEXML"  ,NIL},;
{"F1_TIPODOC", TIPODOC  ,Nil},;
{"F1_COND"   , CONDPAG  ,NIL}}
 
AAdd(aItem,{;
{"D1_COD"     , CODPROD     ,Nil},;
{"D1_ITEM"    , ITEM        ,Nil},;
{"D1_UM"      , "UN"        ,Nil},;
{"D1_QUANT"   , QUANTIDADE  ,Nil},;
{"D1_VUNIT"   , VALORUN 	,Nil},;
{"D1_TOTAL"   , VALORTOT    ,Nil},;
{"D1_IPI"     , 0           ,Nil},;
{"D1_VALIPI"  , 0           ,Nil},;
{"D1_PICM"    , 0           ,Nil},;
{"D1_VALICM"  , 0   		,Nil},;
{"D1_BASEICM" , 0   		,Nil},;
{"D1_BASEIPI" , 0   		,Nil},;
{"D1_RATEIO"  , "2"         ,Nil},;
{"D1_LOCAL"   , LOCPAD      ,Nil},;
{"D1_BRICMS"  , 0           ,Nil},; 
{"D1_CLVL"    , NAVIO       ,Nil},;
{"D1_ICMSRET" , 0           ,Nil}})

cEspecie:="CTR"

lMsErroAuto := .F.       
dDtDigit := Date()
ddatabase:=dDtDigit
MSExecAuto({|x,y,z| Mata140(x,y,z) }, aCab, aItem, 3)       

If lMsErroAuto
   MostraErro()	//"Falha na atualizacao do pedido"
Else
   dbSelectArea("SF1")
   dbSetOrder(1)
   dbSeek(xFilial("SF1")+ALLTRIM(NF)+SPACE(9-LEN(ALLTRIM(NF)))+SERIE+FORNEC+LOJA)   
   IF !SF1->(EOF())
      RecLock("SF1",.F.) 
      SF1->F1_CONTRA :=xCONTRATO
      SF1->F1_XNOMFOR:=xNOMFOR
      msunlock()
   ENDIF
   //Inclusao da informacao no Contas a Pagar
   dbSelectArea("SE2")
   dbSetOrder(6)   //E2_FILIAL, E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, R_E_C_N_O_, D_E_L_E_T_
   If dbSeek(xFilial("SE2")+FORNEC+LOJA+SERIE+ALLTRIM(NF)+SPACE(9-LEN(ALLTRIM(NF))))   
   		RecLock("SE2",.F.)
   		SE2->E2_CONTRA := xCONTRATO
   		MsUnlock()
   EndIf
EndIf

Return .T.