#Include "Totvs.ch"
#Include "FwMvcDef.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} Programa  - F080BXVL
Ponto de entrada de validação de baixa de títulos de contas a pagar

@author Alex da Silva
@since  18/06/2026
/*/


User Function FA080TIT()
    Local lRet := .T.
    
    // Como o PE é chamado pela rotina padrão, a tabela SE2 já está posicionada.
    If SE2->E2_ZZBLQPG == "2"
        
        // Exibe a mensagem de alerta para o usuário
        MsgStop("Este título está com o bloqueio de pagamento ativado pelo Contrato de Algodão." + CRLF + ;
                "Para prosseguir com a baixa, remova o bloqueio na rotina de Contratos.", "Baixa Bloqueada")
                
        // Retorna .F. para abortar imediatamente o processo de baixa do Protheus
        lRet := .F.
        
    EndIf
    
Return lRet
