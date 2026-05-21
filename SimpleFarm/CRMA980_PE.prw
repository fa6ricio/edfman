#INCLUDE "PROTHEUS.CH"
#Include "Totvs.ch"
/*
-----------------------------------------------------------------------------
=============================================================================
|||Programa  | MT010CAN |Autor  |Fabricio Antunes    | Data |  26/09/2025  ||
||===========|=============================================================||
|||Desc.     | Ponto de entrada no cadastro de clientes MVC                ||
|||          | A documentacao de como fazer o p.e. esta disponivel em      ||
||           |https://tdn.totvs.com/pages/releaseview.action?pageId=208345968||
||===========|=============================================================||
|||Uso       | Integração SimpleFarm                                       ||
||=========================================================================||
=============================================================================
-----------------------------------------------------------------------------
*/
 

User Function CRMA980()
    Local aArea := FWGetArea()
    Local aParam := PARAMIXB 
    Local xRet := .T.
    Local oObj := Nil
    Local cIdPonto := ""
    Local cIdModel := ""
    Local cCodCli := ''


    //Se tiver parametros
    If aParam != Nil
          
        //Pega informacoes dos parametros
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
              
        //Na validacao total do formulario 
        If cIdPonto == "FORMPOS" .And. cIdModel == "SA1MASTER"
            
  
        //Apos a gravacao total do modelo e dentro da transacao 
        ElseIf cIdPonto == "MODELCOMMITTTS"
           
            nOper := oObj:nOperation

            If nOper == 3 .OR. nOper == 4
                IF SA1->A1_XINTFAR = 'S'
                    //Controle de semaforo para evitar que dois cadastros sejam feitos ao mesmo tempo pegando o mesmo codigo de integração
                    While !LockByName("SPFARCLI",.T.,.F. )
                        MsAguarde({|| Sleep(2000) }, "Semaforo de processamento...", "Aguarde, salvando registros")
                    EndDo


                    cQuery:= "SELECT MAX (A1_XCODFAR) AS COD FROM "+RetSqlName('SA1')+" WHERE D_E_L_E_T_ = ' ' "
                    cQuery := ChangeQuery(cQuery)   
                    DbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),'CLIC', .F., .T.)

                    CLIC->(dbGoTop())
                    
                    cCodCli := CLIC->COD
                
                    IF Alltrim(cCodCli) = ''
                        cCodCli := 'C000001'
                    Else
                        cNum:= Val(SubStr(cCodCli,2,6)) + 1
                        cCodCli := 'C'+StrZero(cNum,6)
                    EndIF

                    CLIC->(dbCloseArea())
                    //Alert(cCodCli)
            
                    IF Alltrim(SA1->A1_XCODFAR) = ''
                        RecLock('SA1', .F.)
                            SA1->A1_XCODFAR := cCodCli
                            SA1->A1_XSINTE  := 'S'
                        SA1->(MsUnlock())
                                                
                    Else
                        RecLock('SA1', .F.)
                            SA1->A1_XSINTE  := 'S'
                        SA1->(MsUnlock())
                    EndIf


                    UnLockByName("SPFARCLI",.T.,.F.)
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
 
  