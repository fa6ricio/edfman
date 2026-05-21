#include "Protheus.ch"
/*
Função......: EecCadCntr()
Parametros..: Nenhum
Retorno.....: Nil
Objetivo....: Dar manutenção no cadastro de Containers (Tabela: ZZ1).
Autor.......: Julio de Paula Paz
Data/Hora...: 03/08/2012 - 10:00
Observação..:
*/
User Function EecCadCntr()
Local lRet                   
Local aRotAdic := {{"Importa Containers","Eval(bImport)", 0, 3}}

Private cFilialZZ1 := xFilial("ZZ1")
Private aMemos := {}, bExcluiItem := {|| ExcluiItem()}, bValidaItemOk := {|| ValidaItemOk()}
Private bImport := {|| ImportContainer(), .F.}  

Begin Sequence
   ZZ1->(DbSetFilter({|| ZZ1_FILIAL == cFilialZZ1 .And. ZZ1_PREEMB == EEC->EEC_PREEMB},;
                        "ZZ1_FILIAL == cFilialZZ1 .And. ZZ1_PREEMB == EEC->EEC_PREEMB"))

   AxCadastro("ZZ1","Cadastro de Containers","Eval(bExcluiItem)","Eval(bValidaItemOK)",aRotAdic)

   ZZ1->(dbClearFilter())

End Sequence

Return lRet 

//-------------------------------------------------------------------------------------------
Static Function ImportContainer

Local aAreaZZ1 := ZZ1->(GetArea())

Local oGet, oBtn, oDlg                                                  
Local nOpcA := 0       
Local bVld := {|lRet| lRet := .F., IF(Empty(cArq),MsgInfo("Arquivo para importação não preenchido."),IF(!File(cArq),"Arquivo informado não existe.",lRet := .T.)), lRet }
Local bOk := {|| IF(Eval(bVld), (nOpcA := 1, oDlg:End()), ) }, bCancel := {|| oDlg:End()}

Private cArq := Space (255)

Begin Sequence
   ZZ1->(dbSetOrder(1))
   IF ZZ1->(dbSeek(xFilial()+EEC->EEC_PREEMB))
      MsgInfo("Atenção: Esse processo já possui containers cadastrados. Portanto, não será possivel a importação do arquivo Excel.")
      Break
   Endif             
             
   DEFINE MSDIALOG oDlg TITLE "Arquivo a ser importado" FROM 0,0 TO 200,600 OF oMainWnd PIXEL 
   
   
      @ 15, 10 SAY "Arquivo: " PIXEL OF oDlg
      @ 15, 40 MSGET oGet VAR cArq PIXEL of oDlg SIZE 300, 08
      
      @ 35, 40 BUTTON "Selecione o arquivo: " ACTION (cArq := ChooseFile(), oGet:Refresh()) OF oDlg   PIXEL
      
   ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)      
   
   IF nOpcA == 1
      ImportFile(cArq)
   Endif   

End Sequence                      

ZZ1->(RestArea(aAreaZZ1))

Return NIL

//-------------------------------------------------------------------------------------------
Static Function ImportFile(cArquivo)

Local cData := ""
Local cDataRow
Local cChar := ";"

Local i    
Local nAt         
Local cMsgErr := ""
Local bAddMsg := {|x| cMsgErr += IF(Empty(cMsgErr),"",CRLF)+x}

Local aZZ1 := {}

Begin Sequence     
   cData := MemoRead(cArquivo)
   
   For i:=2 To MlCount(cData)
      // Ler 1 linha do arquivo
      cDataRow := MemoLine(cData,,i)
      aDados := {}
      
      While (nAt := At(cChar,cDataRow)) > 0
         aAdd(aDados,Alltrim(Substr(cDataRow,1,nAt-1)))
         cDataRow := Substr(cDataRow,nAt+1,Len(cDataRow))      
      Enddo
      
      IF !Empty(cDataRow)
         aAdd(aDados,Alltrim(cDataRow))             
      Endif
      
      // Para cada linha temos:
      /*
      aDados[1] --> Nro do Container
      aDados[2] --> Tara
      aDados[3] --> Nro. Lacre
      aDados[4] --> Embalagem
      aDados[5] --> Qtd. Embalagem
      aDados[6] --> Tipo Container
      */
      
      IF Len(aDados) < 6
         Eval(bAddMsg, "Erro na leitura da linha "+Ltrim(str(i)))
         Eval(bAddMsg, "Processamento cancelado.")
         Break
      Endif                                       
      
      // Validar os dados
      cContainer := aDados[1]
      nTara      := Val(aDados[2])
      cNroLacre  := aDados[3]
      cEmbalagem := aDados[4]
      nQtdEmb    := Val(aDados[5])
      cTipoCon   := aDados[6]
           
      IF Empty(cContainer)
         Eval(bAddMsg,"Nro do Container não preenchido na linha"+Ltrim(str(i)))
      Endif      
      IF Empty(nTara)
         Eval(bAddMsg,"Tara não preenchida na linha"+Ltrim(str(i)))
      Endif
      IF Empty(cNroLacre)
         Eval(bAddMsg,"Nro do Lacre não preenchido na linha"+Ltrim(str(i)))
      Endif
      IF ! (cEmbalagem $ "S/B")
         Eval(bAddMsg,"Embalagem deve ser uma das opções (S) = Sacas ou (B) = Big Bags. Valor inválido na linha"+Ltrim(str(i)))
      Endif
      IF Empty(nQtdEmb)
         Eval(bAddMsg,"Qtde de Embalagens não preenchida na linha"+Ltrim(str(i)))
      Endif
      IF Empty(cTipoCon)
         Eval(bAddMsg,"Tipo do Container não preenchido na linha"+Ltrim(str(i)))
      Endif     
      
      aAdd(aZZ1, {cContainer, nTara, cNroLacre, cEmbalagem, nQtdEmb, cTipoCon})          
      
   Next i
   
   IF !Empty(cMsgErr)
      Break
   Endif
   
   For i:=1 To Len(aZZ1)
      ZZ1->(RecLock("ZZ1",.T.))
      ZZ1->ZZ1_FILIAL := xFilial("ZZ1")
      ZZ1->ZZ1_PREEMB := EEC->EEC_PREEMB
      ZZ1->ZZ1_NRCNTR := aZZ1[i,1]
      ZZ1->ZZ1_TARA   := aZZ1[i,2]
      ZZ1->ZZ1_LACRE  := aZZ1[i,3]
      ZZ1->ZZ1_EMBAL  := aZZ1[i,4]
      ZZ1->ZZ1_QTDEMB := aZZ1[i,5]
      ZZ1->ZZ1_TIPCON := aZZ1[i,6]
      
      ZZ1->(MsUnlock())
   Next i                       
   
   MsgInfo("Importação concluida com sucesso.")

End Sequence

IF !Empty(cMsgErr)
   EECVIEW(cMsgErr)
Endif

Return NIL

//-------------------------------------------------------------------------------------------
Static Function ChooseFile()

Local cTitle := "Arquivo a ser importado"
Local cMask  := "CSV (separado por vírgulas)(*.csv)|*.csv"
Local cFile  := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions:= GETF_OVERWRITEPROMPT+GETF_LOCALHARD+GETF_NETWORKDRIVE

cFile := cGetFile(cMask,cTitle,nDefaultMask,cDefaultDir,,nOptions)

Return cFile


/*
Função......: ValidaItemOK()
Parametros..: Nenhum
Retorno.....: .T. / .F.
Objetivo....: Validar a inclusão do item no cadastro de containers.
Autor.......: Julio de Paula Paz
Data/Hora...: 03/08/2012 - 10:00
Observação..:
*/
Static Function ValidaItemOK()
Local lRet := .T.  
Local aOrd := SaveOrd({"ZZ1"})
Local cOldFilter, bOldFilter

Begin Sequence   
   if !Inclui
      Break
   Endif
   cOldFilter := ZZ1->(dbFilter())
   bOldFilter := &("{|| "+if(Empty(cOldFilter),".T.",cOldFilter)+" }")

   dbSelectArea("ZZ1")
   SET FILTER TO
   
   ZZ1->(DbSetOrder(2))
   If ZZ1->(DbSeek(xFilial("ZZ1")+M->ZZ1_NRCNTR))
      MsgStop("Numero de container já cadastrado para o processo "+ZZ1->ZZ1_PREEMB,"Atenção")
      lRet := .F.
      Break
   EndIf 

End Sequence

If !Empty(cOldFilter)
    ZZ1->(dbSetFilter(bOldFilter,cOldFilter))
Endif

RestOrd(aOrd)

Return lRet

/*
Função......: ExcluiItem()
Parametros..: Nenhum
Retorno.....: .T. / .F.
Objetivo....: Validar a exclusão do item no cadastro de containers.
Autor.......: Julio de Paula Paz
Data/Hora...: 03/08/2012 - 10:00
Observação..:
*/
Static Function ExcluiItem()
Local lRet := .T.

Begin Sequence
   lRet := MsgYesNo("Confirma a exclusão do item?","Atenção")

End Sequence

Return lRet