#Include "Protheus.ch"

/*
Programa...: EECIntCntr_rdm.prw
Objetivo...: Realizar a integração de containers cadastrados na tabela ZZ1 para a rotina padrão de estufagem.
Autor......: Julio de Paula Paz
Data/Hora..: 15/08/2012 - 10:00
Observações:
*/        

#define ENTER CHR(13)+CHR(10)

/*
Função.....: EECIntCntr()
Parâmetros.: Nenhum
Retorno....: Nil
Objetivo...: Realizar a integração de containers cadastrados na tabela ZZ1 para a rotina padrão de estufagem.
Autor......: Julio de Paula Paz
Data/Hora..: 15/08/2012 - 10:00
Observações:
*/
User Function EECIntCntr()
Local lRet
Local aOrd := SaveOrd({"EEC","EX9","EYH","EE9"})
Private cPreemb := EEC->EEC_PREEMB
Private cFilialZZ1 := xFilial("ZZ1")

Begin Sequence
   If ! MsgYesNo("Confirma a integração do cadastro de containers para a rotina de estufagem de mercadorias?","Atenção")
      Break
   EndIf                                                                                                   
   
   Processa({|| lRet := ValidaIntegracao("INICIO") },"Validando início da integração...")
   If ! lRet
      Break
   EndIf
                                                                                                            
   Processa({|| lRet := ValidaIntegracao("CADASTRO_CONTAINER") },"Validando o cadastro de Containers...")   
   If ! lRet
      Break
   EndIf
   
   Processa({|| lRet := ValidaIntegracao("COMPARA_CADASTRO_CONTAINER_X_ESTUFAGEM") },"Comparando dados: Cad.Containers X Rot.Estufagem...")   
   If ! lRet
      Break
   EndIf   
   
   Processa({|| lRet := ValidaIntegracao("EXISTE_CONTAINER_") },"Validando a existência de Containers...")  
   
   If lRet                                                                                                        
      If MsgYesNo("Já existem containers estufados. Para prosseguir com a integração é necessário excluir os containers estufados. "+ENTER+;
                  "Você confirma a exclusão dos containers estufados?","Atenção") 
                  
         EX9->(DbSetOrder(1)) // EX9_FILIAL+EX9_PREEMB+EX9_CONTNR
         EX9->(DbSeek(xFilial("EX9")+cPreemb))
         Do While ! EX9->(Eof()) .And. EX9->(EX9_FILIAL+EX9_PREEMB) == xFilial("EX9")+cPreemb 
            EX9->(RecLock("EX9",.F.))
            EX9->(DbDelete())
            EX9->(MsUnlock())
            EX9->(DbSkip())
         EndDo  
         
         // Exclusão das estruturas de containers não estufados.
         EYH->(DbSetOrder(1)) // EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_ID+EYH_IDVINC
         EYH->(DbSeek(xFilial("EYH")+"N"+cPreemb))
         Do While ! EYH->(Eof()) .And. EYH->(EYH_FILIAL+EYH_ESTUF+EYH_PREEMB) == xFilial("EYH")+"N"+cPreemb 
            EYH->(RecLock("EYH",.F.))
            EYH->(DbDelete())
            EYH->(MsUnlock())
            EYH->(DbSkip())
         EndDo
         
         // Exclusão das embalagens/lotes estufados.
         EYH->(DbSetOrder(1)) // EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_ID+EYH_IDVINC
         EYH->(DbSeek(xFilial("EYH")+"S"+cPreemb))
         Do While ! EYH->(Eof()) .And. EYH->(EYH_FILIAL+EYH_ESTUF+EYH_PREEMB) == xFilial("EYH")+"S"+cPreemb 
            EYH->(RecLock("EYH",.F.))
            EYH->(DbDelete())
            EYH->(MsUnlock())
            EYH->(DbSkip())
         EndDo
      Else
         MsgInfo("Rotina de integração de containers cancelada.","Atenção")
         Break
      EndIf
   Else
      // Exclusão de estruturas de containers não estufados.
      EYH->(DbSetOrder(1)) // EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_ID+EYH_IDVINC
      EYH->(DbSeek(xFilial("EYH")+"N"+cPreemb))
      Do While ! EYH->(Eof()) .And. EYH->(EYH_FILIAL+EYH_ESTUF+EYH_PREEMB) == xFilial("EYH")+"N"+cPreemb 
         EYH->(RecLock("EYH",.F.))
         EYH->(DbDelete())
         EYH->(MsUnlock())
         EYH->(DbSkip())
      EndDo
   EndIf
   
   // Inicia Processo de integração.
   Processa({|| lRet := IntegraCntr() },"Integrando os Containers...")   
   
   MsgInfo("Processo de integração do cadastro de containers para a rotina de estufagem finalizado.","Atenção")   
   
End Sequence

RestOrd(aOrd,.T.)

Return Nil

/*
Função.....: ValidaIntegracao(cOpcao)
Parâmetros.: cOpcao = opção da validação.
Retorno....: .T./.F.
Objetivo...: Realizar validações na integração de containers.
Autor......: Julio de Paula Paz
Data/Hora..: 15/08/2012 - 10:00
Observações:
*/                                                           
Static Function ValidaIntegracao(cOpcao)
Local lRet := .T.                
Local cProduto := ""
Local aOrd := SaveOrd({"EE9","ZZ1","EX9","EYH"})
Local aCadContainers, aItensEmbarque
Local nI, nJ
Local nTotalItem, nTotalCadCntr
Local cMsg

Begin Sequence
   Do Case
      Case cOpcao == "INICIO"                         
           EE9->(DbSetOrder(3)) // EE9_FILIAL+EE9_PREEMB+EE9_SEQEMB
           EE9->(DbSeek(xFilial("EE9")+cPreemb))
           Do While !EE9->(Eof()) .And. EE9->(EE9_FILIAL+EE9_PREEMB) == xFilial("EE9")+cPreemb
              If Empty(cProduto)                                                      
                 cProduto := EE9->EE9_COD_I
              Else
                 If cProduto <> EE9->EE9_COD_I
                    MsgInfo("Existe mais de um tipo de produto neste embarque de exportação. Esta rotina não permite integrar "+;
                            "produtos diferentes para a rotina de estufagem do Easy. "+ENTER+;
                            "A estufagem das mercadorias terá que ser realizada manualmente.","Atenção")
                    lRet := .F.
                    Break
                 EndIf
              EndIf
              EE9->(DbSkip())
           EndDo           
      
      Case cOpcao == "EXISTE_CONTAINER_"
           lRet := .F.
           EX9->(DbSetOrder(1)) // EX9_FILIAL+EX9_PREEMB+EX9_CONTNR
           If EX9->(DbSeek(xFilial("EX9")+cPreemb))
              lRet := .T.
              Break
           EndIf
           
           EYH->(DbSetOrder(1)) // EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_ID+EYH_IDVINC
           If EYH->(DbSeek(xFilial("EYH")+"S"+cPreemb))
              lRet := .T.
              Break
           EndIf
      
      Case cOpcao == "CADASTRO_CONTAINER" 
           lRet := .F.
           ZZ1->(DbSetOrder(1))//ZZ1_FILIAL+ZZ1_PREEMB+ZZ1_NRCNTR
           If ZZ1->(DbSeek(xFilial("ZZ1")+cPreemb))
              lRet := .T.                                      
           EndIf
           
      Case cOpcao == "COMPARA_CADASTRO_CONTAINER_X_ESTUFAGEM"
           aCadContainerS := {} // Dados do cadastro de containers.
           aItensEmbarquE := {} // Dados dos itens de embarque.    
                      	
           ZZ1->(DbSetFilter({|| ZZ1_FILIAL == cFilialZZ1 .And. ZZ1_PREEMB == cPreemb},;
                                "ZZ1_FILIAL == cFilialZZ1 .And. ZZ1_PREEMB == cPreemb"))           	
                                                    
           ZZ1->(DbSetOrder(1))//ZZ1_FILIAL+ZZ1_PREEMB+ZZ1_NRCNTR
           
           DbSeek(xFilial("ZZ1")+cPreemb)
           
           Do While ! ZZ1->(Eof()) .And. ZZ1->(ZZ1_FILIAL+ZZ1_PREEMB) == xFilial("ZZ1")+cPreemb
              Aadd(aCadContainerS, {ZZ1->ZZ1_NRCNTR,;   // Numero do Container        1
                                    ZZ1->ZZ1_TARA,;     // Tara do Container          2
                                    ZZ1->ZZ1_LACRE,;    // Nr.do Lacre do Container   3
                                    ZZ1->ZZ1_EMBAL,;    // Tipo de Embalagem          4
                                    ZZ1->ZZ1_QTDEMB,;   // Quantidade de Embalagens   5
                                    0,;                 // Quantidade do item         6        
                                    ZZ1->ZZ1_TIPCON})   // Tipo
              ZZ1->(DbSkip())
           EndDo

           ZZ1->(dbClearFilter())           
           *
           EE9->(DbSetOrder(3)) // EE9_FILIAL+EE9_PREEMB+EE9_SEQEMB
           EE9->(DbSeek(xFilial("EE9")+cPreemb))
           Do While !EE9->(Eof()) .And. EE9->(EE9_FILIAL+EE9_PREEMB) == xFilial("EE9")+cPreemb
              Aadd(aItensEmbarquE, {EE9->EE9_QE,;     // QTD NA EMBALAGEM   1
                                    EE9->EE9_QTDEM1,;  // QTD DE EMBALAGENS  2
                                    EE9->EE9_SLDINI,; // QTD DE ITENS       3
                                    EE9->(Recno())})  // Numero do registro 4
              
              EE9->(DbSkip())
           EndDo         
           
           nTotalItem := 0      
           nTotalCadCntr := 0
           
           For nI := 1 To Len(aItensEmbarquE)
               // by CAF 23/08/12 nTotalItem += aItensEmbarquE[nI,3] // Somando a quantidade de itens.
               nTotalItem += aItensEmbarquE[nI,2] // Somando a quantidade de EMBALAGENS.
           Next
           
           For nJ := 1 To Len(aCadContainerS)
               nTotalCadCntr += aCadContainerS[nJ,5] 
           Next
           
           If nTotalItem <> nTotalCadCntr
              cMsg := "As quantidades totais dos itens de embarque diferem das quantidades totais do cadastro de containers. "+ENTER
              cMsg += "Total de itens do embarque: "+AllTrim(Transform(nTotalItem,"@E 999,999,999,999.999"))+ENTER
              cMsg += "Total de itens do cadastro de containers: "+Alltrim(Transform(nTotalCadCntr,"@E 999,999,999,999.999"))+ENTER
              cMsg += "Diferença Total_Itens_Embarque - Total_Itens_Cadastro_Embalagens = "+ENTER
              cMsg += Alltrim(Transform(nTotalItem-nTotalCadCntr,"@E 999,999,999,999.999"))+ENTER
              cMsg += "Favor rever as quantidades do embarque e do cadastro de containers."

              MsgInfo(cMsg,"Atenção")
              
              lRet := .F.                                                                        
              
              Break
           EndIf
      
   EndCase
   
End Sequence

RestOrd(aOrd)

Return lRet

/*
Função.....: IntegraCntr()
Parâmetros.: Nenhum
Retorno....: Nil
Objetivo...: Realizar as Integrações do cadastro de containers para a rotina de estufagem.
Autor......: Julio de Paula Paz
Data/Hora..: 16/08/2012 - 16:00
Observações:
*/                                                           
Static Function IntegraCntr() 
Local lRet
Local aCadContainers, aItensEmbarque  

Begin Sequence
   aCadContainers := {} // Dados do cadastro de containers.
   aItensEmbarque := {} // Dados dos itens de embarque.    
                      	
   ZZ1->(DbSetFilter({|| ZZ1_FILIAL == cFilialZZ1 .And. ZZ1_PREEMB == cPreemb},;
                                "ZZ1_FILIAL == cFilialZZ1 .And. ZZ1_PREEMB == cPreemb"))           	
                                                    
   ZZ1->(DbSetOrder(1))//ZZ1_FILIAL+ZZ1_PREEMB+ZZ1_NRCNTR
           
   ZZ1->(DbSeek(xFilial("ZZ1")+cPreemb))
           
   Do While ! ZZ1->(Eof()) .And. ZZ1->(ZZ1_FILIAL+ZZ1_PREEMB) == xFilial("ZZ1")+cPreemb
      Aadd(aCadContainers, {ZZ1->ZZ1_NRCNTR,;   // Numero do Container        1
                            ZZ1->ZZ1_TARA,;     // Tara do Container          2
                            ZZ1->ZZ1_LACRE,;    // Nr.do Lacre do Container   3
                            ZZ1->ZZ1_EMBAL,;    // Tipo de Embalagem          4
                                    ZZ1->ZZ1_QTDEMB,;   // Quantidade de Embalagens   5
                                    0,;                 // Quantidade do item         6        
                                    ZZ1->ZZ1_TIPCON})   // Tipo
                            
      ZZ1->(DbSkip())
   EndDo

   ZZ1->(dbClearFilter())           
   *
   EE9->(DbSetOrder(3)) // EE9_FILIAL+EE9_PREEMB+EE9_SEQEMB
   EE9->(DbSeek(xFilial("EE9")+cPreemb))
   Do While !EE9->(Eof()) .And. EE9->(EE9_FILIAL+EE9_PREEMB) == xFilial("EE9")+cPreemb
      Aadd(aItensEmbarque, {EE9->EE9_QE,;     // QTD NA EMBALAGEM   1
                            EE9->EE9_QTDEM1,;  // QTD DE EMBALAGENS  2
                            EE9->EE9_SLDINI,; // QTD DE ITENS       3
                            EE9->(Recno())})  // Numero do registro 4
              
      EE9->(DbSkip())
   EndDo         
           
   nTotalItem := 0      
   nTotalCadCntr := 0
   nQtdEstuf := 0
      
   nI := 1        
   
   Do While (nI <= Len(aItensEmbarque))
      nTotalItem := aItensEmbarque[nI,2] // Somando a quantidade de itens.
      For nJ := 1 To Len(aCadContainers)
          nTotalCadCntr := aCadContainers[nJ,5]
          
          If nTotalCadCntr > nTotalItem 
             nQtdEstuf := 0
             Do While (nTotalCadCntr > nTotalItem)
                nQtdEstuf += nTotalItem                                                        
                nTotalCadCntr -= nTotalItem
                If (nI + 1) <= Len(aItensEmbarque) 
                   nI += 1                
                   nTotalItem := aItensEmbarque[nI,2] // Somando a quantidade de itens.              
                Else
                   Exit   
                EndIf
             EndDo
             If nTotalCadCntr <= nTotalItem
                nQtdEstuf += nTotalCadCntr
                nTotalItem -= nTotalCadCntr 
                EfetivaIntegracao(aItensEmbarque[nI,4],; // Numero do registro do item de embarque (Tabela EE9).
                                  aCadContainers[nJ,1],; // Numero do Container
                                  aCadContainers[nJ,2],; // Tara do Container
                                  aCadContainers[nJ,3],; // Nr.do Lacre do Container
                                  aCadContainers[nJ,4],; // Tipo de Embalagem
                                  aCadContainers[nJ,5],; // Quantidade de Embalagens
                                  nQtdEstuf, ;           // Quantidade de itens 
                                  aCadContainers[nJ,7])  // Tipo do Container
                Loop
             EndIf
          EndIf                         
          
          If nTotalCadCntr <= nTotalItem                      
             nQtdEstuf := nTotalCadCntr
             EfetivaIntegracao(aItensEmbarque[nI,4],; // Numero do registro do item de embarque (Tabela EE9).
                               aCadContainers[nJ,1],; // Numero do Container
                               aCadContainers[nJ,2],; // Tara do Container
                               aCadContainers[nJ,3],; // Nr.do Lacre do Container
                               aCadContainers[nJ,4],; // Tipo de Embalagem
                               aCadContainers[nJ,5],; // Quantidade de Embalagens
                                  nQtdEstuf,;             // Quantidade de itens 
                                  aCadContainers[nJ,7]) // Tipo do Container
                               
             If (nTotalItem - nTotalCadCntr) <> 0
                nTotalItem -= nTotalCadCntr
             EndIf          
          EndIf   
      Next   
      
      nI += 1 
      
   EndDo        
           

End Sequence

Return lRet

/*
Função.....: EfetivaIntegracao(nRegEE9, cNrContainer, nTara, cNrLacre, cTipoEmb, nQtdEmbalagem, nQtdItens)
Parâmetros.: nRegEE9      = Numero do registro do item de embarque (Tabela EE9)
             cNrContainer = Numero do Container
             nTara        = Tara do Container
             cNrLacre     = Nr.do Lacre do Container
             cTipoEmb     = Tipo de Embalagem
             nQtdEmb      = Quantidade de Embalagens
             nQtdItens    = Quantidade de itens
Retorno....: Nil
Objetivo...: Realizar as Integrações do cadastro de containers para a rotina de estufagem.
Autor......: Julio de Paula Paz
Data/Hora..: 16/08/2012 - 16:00
Observações:
*/                                                           
Static Function EfetivaIntegracao(nRegEE9, cNrContainer, nTara, cNrLacre, cTipoEmb, nQtdEmbalagem, nQtdItens, cTipCon)
Local cId, cId_Ctr, cId_EYH, cCodEmbal, lJaCadastrado := .F., cId_Emb, cIdVinc_Emb
Local nRegEmb, nQtdEmb, cNrId, nQtdAtu, nRegAtu, aQtdEstorno := {}
Local lRet, nPesoTot

Begin Sequence 
   EE9->(DbGoTo(nRegEE9))
   EX9->(DbSetOrder(1)) // EX9_FILIAL+EX9_PREEMB+EX9_CONTNR    
   // Já existe o container na tabela EX9.
   If EX9->(DbSeek(xFilial("EX9")+cPreemb+AvKey(cNrContainer,"EX9_CONTNR")))
      EE9->(DbSetOrder(2)) // EE9_FILIAL+EE9_PREEMB+EE9_PEDIDO+EE9_SEQUEN 
      EYH->(DbSetOrder(3)) //EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC  
      *
      Begin Transaction                             
         // Registro principal da tabela EYH. - Registro com os dados da embalagem.                 
         If !EYH->(DbSeek(xFilial("EYH")+"S"+cPreemb+EX9->EX9_ID))
            cId := Ae110NewId(.T., cPreemb)
            EYH->(DbAppend())                
            EYH->EYH_FILIAL := xFilial("EYH") 
            EYH->EYH_ESTUF  := "S" 
            EYH->EYH_PREEMB := cPreemb
            EYH->EYH_ID     := cId
            EYH->EYH_IDVINC := EX9->EX9_ID
            EYH->EYH_CODEMB := EE9->EE9_EMBAL1// Código da Embalagem
            EYH->EYH_DESEMB := Posicione("EE5", 1, xFilial("EE5")+EE9->EE9_EMBAL1, "EE5_DESC") // Descrição da embalagem
            EYH->EYH_SEQEMB := EE9->EE9_SEQEMB
            EYH->EYH_EMBSUP := ""
            EYH->EYH_RELSUP := 1
            EYH->EYH_PSLQUN :=  0 
            EYH->EYH_PSBRUN :=  0 
            EYH->EYH_PSLQTO :=  0 
            EYH->EYH_PSBRTO :=  0 
            EYH->EYH_PLT    := "N"
            *
            nRegEmb := EYH->(Recno())
            *
            cId_EYH := cId //EX9->EX9_ID 
            cId_Emb := cId    // Id Embalagens
            cIdVinc_Emb := EX9->EX9_ID // Id Vinc Embalagens                                 
         Else            
            lJaTemRegPri := .F.  
            // Verifica se já existe o registro com os dados da embalagem para o item que está sendo integrado.
            Do While !EYH->(Eof()) .And. EYH->(EYH_FILIAL+EYH_ESTUF+EYH_PREEMB+EYH_IDVINC) == xFilial("EYH")+"S"+cPreemb+EX9->EX9_ID
               If EYH->EYH_SEQEMB == EE9->EE9_SEQEMB 
                  lJaTemRegPri := .T.
                  cId_EYH := EYH->EYH_ID  
                  cId_Emb := EYH->EYH_ID // Id Embalagens
                  cIdVinc_Emb := EYH->EYH_IDVINC // Id Vinc Embalagens 
                  nRegEmb := EYH->(Recno())
               EndIf 
               EYH->(DbSkip())
            EndDo
            If ! lJaTemRegPri 
               // Se não existe o registro com os dados de embalagens, cria o regisgtro com os dados de embalagens.
               cId := Ae110NewId(.T., cPreemb)
               EYH->(DbAppend())                
               EYH->EYH_FILIAL := xFilial("EYH") 
               EYH->EYH_ESTUF  := "S" 
               EYH->EYH_PREEMB := cPreemb
               EYH->EYH_ID     := cId
               EYH->EYH_IDVINC := EX9->EX9_ID
               EYH->EYH_CODEMB := EE9->EE9_EMBAL1// Código da Embalagem
               EYH->EYH_DESEMB := Posicione("EE5", 1, xFilial("EE5")+EE9->EE9_EMBAL1, "EE5_DESC") // Descrição da embalagem
               EYH->EYH_SEQEMB := EE9->EE9_SEQEMB
               EYH->EYH_EMBSUP := ""
               EYH->EYH_RELSUP := 1
               EYH->EYH_PSLQUN :=  EE9->EE9_PSLQUN 
               EYH->EYH_PSBRUN :=  EE9->EE9_PSBRUN 
               EYH->EYH_PSLQTO :=  0 
               EYH->EYH_PSBRTO :=  0 
               EYH->EYH_PLT    := "N"
               *
               nRegEmb := EYH->(Recno())
               *
               
               cId_EYH := cId // EX9->EX9_ID
               cId_Emb := cId // Id Embalagens
               cIdVinc_Emb := EX9->EX9_ID // Id Vinc Embalagens 
            EndIf
         EndIf
      End Transaction
      *
      Begin Transaction 
         // Segundo Nível de registros da tabela EYH - Grava registro com os dados dos lotes
         cId := Ae110NewId(.T., cPreemb)   
         EYH->(DbAppend())                
         EYH->EYH_FILIAL := xFilial("EYH") 
         EYH->EYH_ESTUF  := "S" 
         EYH->EYH_PREEMB := cPreemb
         EYH->EYH_ID     := cId
         EYH->EYH_IDVINC := cId_EYH
         EYH->EYH_LOTE   := ""
         EYH->EYH_CODEMB := EE9->EE9_COD_I
         EYH->EYH_DESEMB := Posicione("SB1", 1, xFilial("SB1")+EE9->EE9_COD_I, "B1_DESC")
         EYH->EYH_QTDEMB := nQtdItens
         EYH->EYH_COD_I  := EE9->EE9_COD_I
         EYH->EYH_SEQEMB := EE9->EE9_SEQEMB
         EYH->EYH_SALDO  := nQtdItens
         EYH->EYH_UNIDAD := EE9->EE9_UNIDAD
         EYH->EYH_EMBSUP := ""
         EYH->EYH_RELSUP := 1
         EYH->EYH_PSLQUN := EE9->EE9_PSLQUN
         EYH->EYH_PSBRUN := EE9->EE9_PSBRUN
         EYH->EYH_PSLQTO := nQtdItens * EE9->EE9_PSLQUN 
         EYH->EYH_PSBRTO := nQtdItens * EE9->EE9_PSBRUN
         EYH->EYH_PLT    := "N"
         *
         EYH->(DbGoTo(nRegEmb))
         EYH->(RecLock("EYH",.F.))
         nQtdEmb := EYH->EYH_QTDEMB + nQtdItens
         EYH->EYH_QTDEMB := nQtdEmb
         
         nQtdEmb := EYH->EYH_SALDO  + nQtdItens
         EYH->EYH_SALDO  := nQtdEmb
         
         nPesoTot := EYH->EYH_PSLQTO + (nQtdItens * EE9->EE9_PSLQUN)
         EYH->EYH_PSLQTO := nPesoTot
         
         nPesoTot := EYH->EYH_PSBRTO + (nQtdItens * EE9->EE9_PSBRUN)
         EYH->EYH_PSBRTO := nPesoTot
         
         EYH->(MsUnLock())
      End Transaction
      *                              
   Else
      * 
      Begin Transaction
         // Registro com Containers - Capa - Registro principal com os dados do container.
         cId_Ctr := Ae110NewId(.T., cPreemb)
         EX9->(DbAppend())
         EX9->EX9_FILIAL := xFilial("EX9") 
         EX9->EX9_PREEMB := cPreemb
         EX9->EX9_CONTNR := cNrContainer  
         EX9->EX9_LACRE  := cNrLacre
         EX9->EX9_TARA   := nTara
         //EX9->EX9_TIPCON := cTipCon
         //ENS
         EX9->EX9_ENVTMP := cTipCon 
         EX9->EX9_TIPO := "22GP"
         
         EX9->EX9_ID     := cId_Ctr 
         
      End Transaction 
      *
      Begin Transaction
         // Registro principal da tabela EYH - Registro com os dados da embalagem.
         cId_EYH := Ae110NewId(.T., cPreemb)
         EYH->(DbAppend())                
         EYH->EYH_FILIAL := xFilial("EYH") 
         EYH->EYH_ESTUF  := "S" 
         EYH->EYH_PREEMB := cPreemb
         EYH->EYH_ID     := cId_EYH
         EYH->EYH_IDVINC := cId_Ctr
         EYH->EYH_CODEMB := EE9->EE9_EMBAL1// Código da Embalagem
         EYH->EYH_DESEMB := Posicione("EE5", 1, xFilial("EE5")+EE9->EE9_EMBAL1, "EE5_DESC") // Descrição da embalagem   
         //ENS 03/09/12
         //EYH->EYH_SEQEMB := EE9->EE9_SEQEMB
         EYH->EYH_EMBSUP := ""
         EYH->EYH_RELSUP := 1
         EYH->EYH_PSLQUN :=  EE9->EE9_PSLQUN
         EYH->EYH_PSBRUN :=  EE9->EE9_PSBRUN
         EYH->EYH_PSLQTO :=  nQtdItens * EE9->EE9_QE * EE9->EE9_PSLQUN // by CAF 14/09/12
         EYH->EYH_PSBRTO :=  nQtdItens * EE9->EE9_PSBRUN
         EYH->EYH_PLT    := "N" 
         *
         EYH->EYH_QTDEMB := nQtdItens
         EYH->EYH_SALDO  := nQtdItens
         *         
         cId_Emb := cId_EYH     // Id Embalagens
         cIdVinc_Emb := cId_Ctr // Id Vinc Embalagens                                 
      End Transaction 
      *
      Begin Transaction 
         // Segundo nível de registros da tabela EYH - Registro com os dados dos lotes              
         cId := Ae110NewId(.T., cPreemb)
         EYH->(DbAppend())                
         EYH->EYH_FILIAL := xFilial("EYH") 
         EYH->EYH_ESTUF  := "S" 
         EYH->EYH_PREEMB := cPreemb
         EYH->EYH_ID     := cId
         EYH->EYH_IDVINC := cId_EYH
         EYH->EYH_LOTE   := ""
         EYH->EYH_CODEMB := EE9->EE9_COD_I
         EYH->EYH_DESEMB := Posicione("SB1", 1, xFilial("SB1")+EE9->EE9_COD_I, "B1_DESC")
         EYH->EYH_QTDEMB := nQtdItens * EE9->EE9_QE // by CAF 14/09/12
         EYH->EYH_COD_I  := EE9->EE9_COD_I 
         EYH->EYH_SEQEMB := EE9->EE9_SEQEMB
         EYH->EYH_SALDO  := nQtdItens * EE9->EE9_QE // by CAF 14/09/12
         EYH->EYH_UNIDAD := EE9->EE9_UNIDAD
         EYH->EYH_EMBSUP := ""
         EYH->EYH_RELSUP := 1
         EYH->EYH_PSLQUN := EE9->EE9_PSLQUN
         EYH->EYH_PSBRUN := EE9->EE9_PSBRUN
         EYH->EYH_PSLQTO := EYH->EYH_QTDEMB * EE9->EE9_PSLQUN
         EYH->EYH_PSBRTO := nQtdItens * EE9->EE9_PSBRUN
         EYH->EYH_PLT    := "N"       
      End Transaction 
      *      
   EndIf     
   
End Sequence

Return lRet
