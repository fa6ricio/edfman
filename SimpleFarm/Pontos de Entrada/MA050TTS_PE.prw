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

 

User Function MA050TTS      
Local cCodTra := ''

IF INCLUI .OR. ALTERA

    //Controle de semaforo para evitar que dois cadastros sejam feitos ao mesmo tempo pegando o mesmo codigo de integração
    While !LockByName("SPFARVEND",.T.,.F. )
        MsAguarde({|| Sleep(2000) }, "Semaforo de processamento...", "Aguarde, salvando registros")
    EndDo
    
    cQuery:= "SELECT MAX (A4_XCODFAR) AS COD FROM "+RetSqlName('SA4')+" WHERE D_E_L_E_T_ = ' ' "
    cQuery := ChangeQuery(cQuery)   
    DbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),'TRAC', .F., .T.)

    TRAC->(dbGoTop())
    
    cCodTra := TRAC->COD

    IF Alltrim(cCodTra) = ''
        cCodTra := 'T000001'
    Else
        cNum:= Val(SubStr(cCodTra,2,6)) + 1
        cCodTra := 'T'+StrZero(cNum,6)
    EndIF

    TRAC->(dbCloseArea())

    //Alert(cCodTra)

    IF SA4->A4_XINTFAR = 'S'
        IF Alltrim(SA4->A4_XCODFAR) = ''
            RecLock('SA4', .F.)
                SA4->A4_XCODFAR := cCodTra
                SA4->A4_XSINTE  := 'S'
            SA4->(MsUnlock())
        Else
            RecLock('SA4', .F.)
                SA4->A4_XSINTE  := 'S'
            SA4->(MsUnlock())
        EndIf
    EndIF


    UnLockByName("SPFARVEND",.T.,.F.)
    FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()

EndIF

Return
