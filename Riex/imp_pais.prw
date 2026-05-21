// Importação de países
#INCLUDE "PROTHEUS.CH"                                     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Imp_SZ4   ºAutor  ³ADRIANO MIGOTO PINTO  Data ³  03/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPORTAÇÃO DE DADOS PARA A cth - países mv                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Importpais()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg1
Local oBtnOk
Local oBtnCancel
Private mv_par01 := space(60)  // diretório + arquivo a ser migrado
Define MSDialog oDlg Title "Importação de dados" From 186,241 To 250,800 Pixel
   @10,200 Button oBtnOk     Prompt "&Importar"       Size 30,15 Pixel ;
             Action (RunCont(), oDlg:End()) Of oDlg
   @10,240 Button oBtnCancel Prompt "&Cancelar" Size 30,15 Pixel ;
              Action ( oDlg:End()) Cancel Of oDlg
Activate MSDialog oDlg Centered
Return(NIL)


Static Function RunCont
// VARIÁVEIS PARA GERAR LOG
Local aLOG			:= {}  
Local aLOG2			:= {}
// VARIÁVEIS DE MANIPULAÇÃO
Local nTamFile, nTamLin, cBuffer, nBtLidos, _lint, _ultlint
Local col := y := x := u := 0
Local tamcol := colini := 0
Local coluna	:= {}                               
Private nHdl
mv_par01 := cGetFile ( '*.csv' , 'Localize o arquivo:', , , .F., GETF_LOCALHARD + GETF_NETWORKDRIVE)
If empty(mv_par01)
   msgAlert("Escolha um arquivo!")
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
	//xCONTRATO :=""   
	xMV  :=""
	xPAIS:=""
	For u := 0 to Len(coluna)                                                       
		if u == 1
    	   xMV   = substr(cBuffer,coluna[u][1],coluna[u][2])
		elseif u == 2
    	   xPAIS = substr(cBuffer,coluna[u][1],coluna[u][2])
        Endif                 
	Next                                                 
    dbSelectArea("CTH")
    dbSetOrder(1)
    dbSeek(xFilial("CTH")+ALLTRIM(xMV))  
    IF !CTH->(EOF()) .And. CTH->CTH_CLVL=xMV
       RecLock("CTH",.F.)
       CTH->CTH_PAIS:=xPAIS
       MsUnlock()          
    EndIF
    ft_fskip()
EndDo                                             
mv_par01=""
msginfo("Operação Concluída !")
Return


