#INCLUDE "PROTHEUS.CH"
 
/*
-----------------------------------------------------------------------------
=============================================================================
|||Programa  | MT20FOPOS|Autor  |Fabricio Antunes    | Data |  26/09/2025  ||
||===========|=============================================================||
|||Desc.     | Este ponto está localizado após a gravação do Fornecedor    ||
|||          | Inclusão do Produto), A010Altera (Alteração do Produto) e   ||
||           | A010Deleta (Deleção do Produto).                            ||
||===========|=============================================================||
|||Uso       | Integração SimpleFarm                                       ||
||=========================================================================||
=============================================================================
-----------------------------------------------------------------------------
*/

User Function CUSTOMERVENDOR()
    Local aArea := FWGetArea()
    Local aParam := PARAMIXB 
    Local xRet := .T.
    Local oObj := Nil
    Local cIdPonto := ""
    Local cIdModel := ""
    Local cCodFor := ''



    //Se tiver parametros
    If aParam != Nil
          
        //Pega informacoes dos parametros
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
              
        //Na validacao total do formulario 
        If cIdPonto == "FORMPOS" .And. cIdModel == "SA2MASTER"
            
    
        //Apos a gravacao total do modelo e dentro da transacao 
        ElseIf cIdPonto == "MODELCOMMITTTS"
            
        nOper := oObj:nOperation
    
        If nOper == 3 .OR. nOper == 4
            IF SA2->A2_XINTFAR = 'S'
            //Controle de semaforo para evitar que dois cadastros sejam feitos ao mesmo tempo pegando o mesmo codigo de integração
                While !LockByName("SPFARFOR",.T.,.F. )
                    MsAguarde({|| Sleep(2000) }, "Semaforo de processamento...", "Aguarde, salvando registros")
                EndDo

                cQuery:= "SELECT MAX (A2_XCODFAR) AS COD FROM "+RetSqlName('SA2')+" WHERE D_E_L_E_T_ = ' ' "
                cQuery := ChangeQuery(cQuery)   
                DbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),'FORC', .F., .T.)

                FORC->(dbGoTop())
                
                cCodFor := FORC->COD
            
                IF Alltrim(cCodFor) = ''
                    cCodFor := 'F000001'
                Else
                    cNum:= Val(SubStr(cCodFor,2,6)) + 1
                    cCodFor := 'F'+StrZero(cNum,6)
                EndIF

                FORC->(dbCloseArea())

                //Alert(cCodFor)


                IF Alltrim(SA2->A2_XCODFAR) = ''
                    RecLock('SA2', .F.)
                        SA2->A2_XCODFAR := cCodFor
                        SA2->A2_XSINTE  := 'S'
                    SA2->(MsUnlock())
                Else
                    RecLock('SA2', .F.)
                        SA2->A2_XSINTE  := 'S'
                    SA2->(MsUnlock())
                EndIf
                    
                UnLockByName("SPFARFOR",.T.,.F.)
                FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
            EndIF
        EndIF

  
        //Na validação do modelo de dados (pode impedir o usuário de abrir a tela) 
        ElseIf cIdPonto == "MODELVLDACTIVE"
     
  
        //Após a gravação total do modelo e fora da transação 
        ElseIf cIdPonto == "MODELCOMMITNTTS"
           
              
        //Para a inclusao de botoes na ControlBar 
        ElseIf cIdPonto == "BUTTONBAR"
           
        EndIf
          
    EndIf
      
    FWRestArea(aArea)
Return xRet
