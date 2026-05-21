#include "protheus.ch"

#define ENTER CHR(13)+CHR(10)

/*
Função......: EecComplPrc()
Parametros..: Nenhum
Retorno.....: Nil
Objetivo....: Complemento de Preços
Autor.......: Cristiano A. Ferreira
Data/Hora...: 03/08/2012 - 10:00
Observação..:
*/
User Function EecComplPrc

Local lRet := .f.
Local cMsg := ""

Local aOrd := SaveOrd("SF2")
Local cNota:= ""

Private nValorTot := 0
Private cTES      := Space(Len(SC6->C6_TES))
Private lEstorno  := ! Empty(EEC->EEC_ZNF_COMP)

/* Campos para controle:
EEC_PEDEMB   --> Nro do Pedido de Complemento
EEC_ZNF_COMP --> Nro da NF de Complemento
EEC_ZVL_COMP --> Valor da NF de Complemento em moeda estrangeira
*/

Private cMsgErr := ""
Private lMostraCtb,lAglCtb,lContab,lCarteira
Private MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04
      
Pergunte("MTA521",.F.)
lMostraCtb := MV_PAR01==1
lAglCtb    := MV_PAR02==1
lContab    := MV_PAR03==1
lCarteira  := MV_PAR04==1
                          
Begin Sequence            
   IF !TemNFS(EEC->EEC_PREEMB)
      MsgInfo("Para gerar a nota fiscal complementar é necessário vincular as notas fiscais de saída.")
      Break
   Endif        
   
   IF !Empty(EEC->EEC_DTEMBA)
      MsgInfo("O processo já foi embarcado, não é possivel gerar notas de complemento de preço.")
      Break
   Endif

   IF lEstorno                                                                                                            
      SF2->(dbSetOrder(1))
      IF SF2->(dbSeek(xFilial()+AvKey(EEC->EEC_ZNF_COMP,"F2_DOC")+AvKey(GetSerie(EEC->EEC_PREEMB),"F2_SERIE")))
         cMsg += "Atenção: A nota fiscal de complemento nro "+EEC->EEC_ZNF_COMP+" já foi gerado para o processo selecionado."
         cMsg += CRLF+"Tem certeza que deseja estorna-la?"
         IF !EECView(cMsg)
            Break
         Endif
      Else 
         // A nota fiscal de complemento anterior já foi estornada. Limpar as flags
         EEC->(RecLock("EEC",.F.))
         EEC->EEC_PEDEMB   := ""
         EEC->EEC_ZNF_COMP := ""
         EEC->EEC_ZVL_COMP := 0
         EEC->(MsUnlock())
         lEstorno := .F.
      Endif
   Endif                        
     
   IF lEstorno
      IF !EstornaNF(AvKey(GetSerie(EEC->EEC_PREEMB),"F2_SERIE"),AvKey(EEC->EEC_ZNF_COMP,"F2_DOC"),EEC->EEC_PEDEMB)   
         cMsg := "Atenção: A nota fiscal de complemento nro "+EEC->EEC_ZNF_COMP+" não pode ser estornada."
         cMsg += CRLF+"Tem certeza que deseja continuar?"
         IF !EECView(cMsg)
            Break
         Endif      
      Endif

      // A nota fiscal de complemento anterior já foi estornada. Limpar as flags
      EEC->(RecLock("EEC",.F.))
      EEC->EEC_PEDEMB   := ""
      EEC->EEC_ZNF_COMP := ""
      EEC->EEC_ZVL_COMP := 0
      EEC->(MsUnlock())  
      
      MsgInfo("Nota fiscal de complemento de preço estornada com sucesso.")
      Break
   Endif      
      
   IF !MsgYesNo("Deseja gerar uma nota de complemento de preço?")
      Break      
   Endif

   IF ! TelaGets()
      Break
   Endif      
   
   IF !GeraNF(nValorTot, @cNota)
      Break
   Endif
   
   MsgInfo("Nota fiscal nro "+cNota+" gerada com sucesso.")
                    
   lRet := .T.
End Sequence                

RestOrd(aOrd,.T.)

Return lRet 
                       
//---------------------------------------------------------------
Static Function TelaGets

Local lRet := .F.
Local nOpc := 0
Local oDlg

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE "Complemento de Preços" FROM 0, 0 TO 190,460 OF oMainWnd PIXEL
   
      @ 30, 10 SAY "Valor Total: "+EEC->EEC_MOEDA PIXEL
      @ 30, 80 MSGET nValorTot PICTURE "@E 999,999,999.99" VALID Positivo() PIXEL
      
      @ 45, 10 SAY "TES: " PIXEL
      @ 45, 80 MSGET cTES PICTURE "@!" VALID ExistCpo("SF4",cTES) F3 "SF4" pixel
   
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IF(VldOk(),(nOpc:=1, oDlg:End()),)},{||oDlg:End()}) CENTERED
   
   IF nOpc == 1
      lRet := .T.
   Endif

End Sequence

Return lRet

//------------------------------------------------------------------
Static Function VldOk
              
Local lRet     := .F.
Local cMsg     := ""

Begin Sequence   
   IF Empty(cTES)   
      cMsg += IF(!Empty(cMsg),ENTER,"")+"O campo TES não foi preenchido."
   Endif
   
   IF Empty(nValorTot)
      cMsg += IF(!Empty(cMsg),ENTER,"")+"O campo Valor Total não foi preenchido."
   Endif
   
   IF Empty(cMsg)
      lRet := .T.
   Else 
      EECView(cMsg)
   Endif

End Sequence

Return lRet
              
//------------------------------------------------------------------
Static Function GeraNF(nValor, cNota)
              
Local aOrd     := SaveOrd({"SD2"})
Local lRet     := .F.

Local aCab := {}, aReg := {}, aItens := {}
Local nValTotal := 0, nValorIt := 0
Local lArred := GetMV("MV_ARREFAT")=="S"

Begin Sequence   

   SD2->(dbSetOrder(8))

   aAdd(aCab,{"C5_NUM",GetSXENum("SC5"),nil}) // Nro.do Pedido
   
   IF ! SA1->(dbSeek(xFilial()+EEC->EEC_IMPORT+EEC->EEC_IMLOJA))
      MsgInfo("Importador não cadastrado !","Aviso")
      Break
   Endif

   aAdd(aCab,{"C5_TIPO","C"         ,nil}) //Tipo COMPLEMNTO
   aAdd(aCab,{"C5_CLIENTE",SA1->A1_COD, nil}) //Cod. Cliente
   aAdd(aCab,{"C5_LOJACLI",SA1->A1_LOJA,nil}) //Loja Cliente
   aAdd(aCab,{"C5_TIPOCLI","X"         ,nil}) //Tipo Cli**ente

   cCondPag := Posicione("SY6",1,xFilial("SY6")+EEC->EEC_CONDPA+AvKey(EEC->EEC_DIASPA,"Y6_DIAS_PA"),"Y6_SIGSE4")

   IF Empty(cCondPag)
      MsgInfo("O campo Cond.Pagto no/ SIGAFAT não foi preenchido !","Aviso")
      BREAK
   Endif

   aAdd(aCab,{"C5_CONDPAG",cCondPag,nil})
   aAdd(aCab,{"C5_MOEDA",POSICIONE("SYF",1,XFILIAL("SYF")+EEC->EEC_MOEDA,"YF_MOEFAT"),nil})    

   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB)) //efetuar rateio 
   DO While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And.;
         EE9->EE9_PREEMB == EEC->EEC_PREEMB

      If lConvUnid 
         nValTotal :=nValTotal + (AvTransUnid(EE9->EE9_UNIDAD,EE9->EE9_UNPRC,EE9->EE9_COD_I,;
                                  EE9->EE9_SLDINI,.F.) * EE9->EE9_PRECO)               
      Else
         nValTotal := nValTotal + (EE9->EE9_SLDINI * EE9->EE9_PRECO)
      EndIf
      EE9->(dbSkip())    
   Enddo
      
   aItens := {}
   cItem := "01"
   lMSErroAuto := .f.
   lMSHelpAuto := .F. // para mostrar os erros na tela

   EE9->(dbSeek(xFilial()+EEC->EEC_PREEMB))

   DO While EE9->(!Eof() .And. EE9_FILIAL == xFilial("EE9")) .And. EE9->EE9_PREEMB == EEC->EEC_PREEMB
      SD2->(dbSetOrder(3))
      SD2->(dbSeek(xFilial()+AvKey(EE9->EE9_NF,"D2_DOC")+AvKey(EE9->EE9_SERIE,"D2_SERIE")))

      If lConvUnid 
         nValorIt := (AvTransUnid(EE9->EE9_UNIDAD,EE9->EE9_UNPRC,EE9->EE9_COD_I,;
                               EE9->EE9_SLDINI,.F.) * EE9->EE9_PRECO)               
      Else
         nValorIt := EE9->(EE9_SLDINI*EE9_PRECO)
      EndIf
         
      nFator := (nValorIt / nValTotal)
                  
      nValorIt := (nFator * nValor)
         
      If lArred 
         nValorIt := ROUND(nValorIt,AVSX3("C6_VALOR",4))
      Else
         nValorIt := NOROUND(nValorIt,AVSX3("C6_VALOR",4))
      EndIf       

      aReg := {}
      aAdd(aReg,{"C6_NUM"    ,aCab[1][2]     ,NIL}) // Pedido
      aAdd(aReg,{"C6_ITEM"   ,cItem          ,NIL}) // Item sequencial
      aAdd(aReg,{"C6_PRODUTO",EE9->EE9_COD_I ,nil})    // Cod.Item
      aAdd(aReg,{"C6_UM"     ,EE9->EE9_UNIDAD,nil})    // Unidade
      aAdd(aReg,{"C6_QTDVEN" ,1,nil})                  // Quantidade
      aAdd(aReg,{"C6_PRCVEN" ,nValorIt       ,nil})    // Preco Unit.
      aAdd(aReg,{"C6_PRUNIT" ,nValorIt       ,nil})    // Preco Unit.
      aAdd(aReg,{"C6_VALOR"  ,nValorIt       ,nil})    // Valor Tot.

      aAdd(aReg,{"C6_TES" , cTES ,Nil})  // Tipo de Saida ...      
      aAdd(aReg,{"C6_CF"  , Posicione("SF4",1,xFilial("SF4")+cTES,"F4_CF")  ,Nil})  // Codigo Fiscal ...                  

      EE7->(dbSetOrder(1))
      EE7->(dbSeek(xFilial()+EE9->EE9_PEDIDO)) 
      EE8->(DbSetOrder(1))
      EE8->(Dbseek(xFilial()+EE9->EE9_PEDIDO+EE9->EE9_SEQUEN))      
      SC6->(dbSetOrder(1))
      SC6->(dbSeek(xFilial()+EE7->EE7_PEDFAT+EE8->EE8_FATIT))

      aAdd(aReg,{"C6_LOCAL"   ,SC6->C6_LOCAL,nil}) // Almoxarifado
      aAdd(aReg,{"C6_ENTREG"  ,dDataBase     ,nil}) // Dt.Entrega
      aAdd(aReg,{"C6_NFORI"   ,EE9->EE9_NF   ,nil}) // NF. Origem.
      aAdd(aReg,{"C6_SERIORI" ,EE9->EE9_SERIE,nil}) // Serie Origem.

      aAdd(aItens,aClone(aReg))
      cItem := SomaIt(cItem)
      IF cItem > "Z9"
         MsgStop("Excedeu o limite de itens do SIGAFAT !")
         lMSErroAuto := .T.
         Exit
      Endif
      EE9->(dbSkip())
   Enddo
                  
   ASORT(aItens,,, { |x, y| x[2,2] < y[2,2] })

   IF lMSErroAuto
      Break
   Else
      lMSErroAuto := ! AVMata410(aCab, aItens, 3)
   Endif
      
   IF !lMSErroAuto 

      cSerieNF := GetSerie(EEC->EEC_PREEMB)
      IncNota(aCAB[1,2],cSerieNF,EEC->EEC_PREEMB)         

      EEC->(RecLock("EEC",.F.))
      EEC->EEC_PEDEMB   := aCAB[1,2]
      EEC->EEC_ZNF_COMP := SF2->F2_DOC
      EEC->EEC_ZVL_COMP := nValor
      EEC->(MsUnlock())                   
      
      cNota := SF2->F2_DOC
      lRet := .T.
   Endif

End Sequence

RestOrd(aOrd)

Return(lRet)
              
//----------------------------------------------------------------------------
Static Function GetSerie(cPreemb)

Local cSerie := ""               
Local aOrd   := SaveOrd("EE9")

Begin Sequence                    
   // Regra padrão: Puxar a mesma série da nota original de saída.
   EE9->(dbSetOrder(2))
   IF EE9->(dbSeek(xFilial()+cPreemb))
      cSerie := EE9->EE9_SERIE	
   Endif
End Sequence
                              
RestOrd(aOrd,.T.)

Return cSerie              

//----------------------------------------------------------------------------
Static Function TemNFS(cPreemb)

Local lRet   := .F.
Local aOrd   := SaveOrd("EE9")

Begin Sequence                    
   EE9->(dbSetOrder(2))
   IF EE9->(dbSeek(xFilial()+cPreemb))
      IF !Empty(EE9->EE9_NF)
         lRet := .T.
      Endif
   Endif
End Sequence
                              
RestOrd(aOrd,.T.)

Return lRet              
              
//----------------------------------------------------------------------------
Static Function EstornaNF(cSerie, cNota, cPedido)

Local lRet   := .F.
Local aNfs
             
Begin Sequence
   Private cMsgErr := ""                    
   aNfs := {}
   aAdd(aNfs,{xFilial("SF2"), cNota, cSerie, cPedido})
   IF EstNF(aNfs)
      lRet := .T.       
   Endif
   IF !Empty(cMsgErr)
      EECView(cMsgErr)
   Endif
End Sequence
                              
Return lRet              
              
//------------------------------------------------------------------------
Static Function EstNF(aNfs)

Local i
Local lRet := .T.

Local aRegSD2 := {}, aRegSE1 := {}, aRegSE2 := {}
Local lContinue := .T.            

Local cFilOld := cFilAnt

Private lMSErroAuto := .F.
Private lMSHelpAuto := .F.

Private aCabec := {}

Begin Sequence
   For i:=1 To Len(aNFs)
      cFilAnt := aNfs[i,1]
         
      lContinue := .T.

      Begin Transaction      
      
      IF !Empty(aNfs[i,2])
         IF ! SF2->(dbSeek(aNfs[i,1]+aNfs[i,2]+aNfs[i,3]))
            AddMsg("Erro no estorno da NF: "+aNfs[I,2]+" da Serie "+aNfs[i,3]+". Nota fiscal não encontrada na base de dados. Verifique.")         
            lRet := .F.         
            lContinue := .F.
            DisarmTransaction()
            Break
         Endif
      
         aRegSD2 := {}
         aRegSE1 := {}
         aRegSE2 := {}
      
         SE1->(dbSetOrder(1))
         SE1->(dbSeek(aNfs[i,1]+aNfs[i,3]+aNfs[i,2]))
         While SE1->(!Eof() .And. E1_FILIAL == aNfs[i,1] .And. E1_PREFIXO == aNfs[i,3] .And. E1_NUM == aNfs[i,2])     
            IF Empty(SE1->E1_BAIXA) .And. SE1->E1_SITUACA <> "0"
               IF SE1->(RecLock("SE1",.F.)) .And. SE1->E1_VALOR = SE1->E1_SALDO
                  SE1->E1_SITUACA := "0" // Força jogar na carteira.
                  SE1->(MsUnlock())
               Endif
            Endif
      
            SE1->(dbSkip())
         Enddo
               
         If MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)
            PcoIniLan("000102")
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Estorna o documento de saida                                   ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
            SF2->(MaDelNFS(aRegSD2,aRegSE1,aRegSE2,lMostraCtb,lAglCtb,lContab,lCarteira))

            PcoFinLan("000102")
            SF2->(dbSetOrder(1))
            IF SF2->(dbSeek(aNfs[i,1]+aNfs[i,2]+aNfs[i,3]))
               AddMsg("Erro no estorno da NF: "+aNfs[I,2]+" da Serie "+aNfs[i,3]+" verifique.")         
               lRet := .F.
               lContinue := .F.
               DisarmTransaction()
               Break
            Endif            
         Else
            AddMsg("Erro no estorno da NF: "+aNfs[I,2]+" da Serie "+aNfs[i,3]+" verifique.")         
            lRet := .F.
            lContinue := .F.
            DisarmTransaction()
            Break
         EndIf       
      Endif
      
      IF lContinue 
         IF !Empty(aNfs[i,4]) .And. SC5->(dbSeek(aNfs[i,1]+aNfs[i,4]))  
            aCabec := {}
            aadd(aCabec,{"C5_NUM"   , aNfs[i,4]  , Nil})
      
            SC9->(dbSetOrder(1))
            SC9->(dbSeek(xFilial()+aNfs[i,4]))
            While SC9->(!Eof() .And. C9_FILIAL == xFilial("SC9") .And. C9_PEDIDO == aNfs[i,4])
               SC9->(a460Estorna())
               SC9->(dbSkip())
            Enddo

            lMSErroAuto := .F.            
            MsExecAuto({|x,y,z| MATA410(x,y,z)},aCabec,{},5)     

            If lMsErroAuto
               MostraErro()
               AddMsg("Erro no estorno do Pedido "+aNfs[i,4]+" na filial "+aNfs[i,1])         
               lRet := .F.            
            Else
               IF SC5->(dbSeek(aNfs[i,1]+aNfs[i,4]))  
                  AddMsg("Erro no estorno do Pedido "+aNfs[i,4]+" na filial "+aNfs[i,1])         
                  lRet := .F.
               Endif
            EndIf                     
         Endif
      Endif
      
      End Transaction     
      
      MsUnlockAll()
   Next i 
   
   IF !lRet
      Break
   Endif
      
End Sequence

cFilAnt := cFilOld

Return lRet

//------------------------------------------------------------------------
Static Function AddMsg(cMsg)

IF Type("cMsgErr") == "C"
   IF !Empty(cMsgErr)
      cMsgErr += CRLF
   Endif
   cMsgErr += cMsg
Endif

Return NIL
