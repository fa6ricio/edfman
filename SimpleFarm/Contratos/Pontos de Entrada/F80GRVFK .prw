
#Include "Protheus.ch"

/*
______________________________________________________________________________
|_____________________________________________________________________________|
|Programa  - SE5FI080    Autor  Alex da Silva         Data   29/06/2026   	  |
|_____________________________________________________________________________|
|Descricao|O ponto de entrada F80GRVFK sera executado para gravar dados       |
|         |complementares das tabelas FK´s.                                   |
|         |Utilizaremos para enviar dados das baixas para Simplefarm e        | 
|         |alimentar customizacao de contratos de algodao                     |
|_________|___________________________________________________________________|
|Uso      | ED & F                                                            | 
|_________|___________________________________________________________________|
|_____________________________________________________________________________|
*/


User Function F80GRVFK()
    Local oObj := ParamIxb[1]
    Local nOpc := ParamIxb[2]
    
    // nOpc == 1 significa que está gravando a Baixa Principal (e não os acessórios como Juros/Multa)
    If nOpc == 1 
        
        // Dispara a regra centralizada no CNTEDF04 passando os dados da baixa.
        // O Protheus mantém a SE5 e a SE2 devidamente posicionadas neste exato momento da transação.
        U_EnvBxaSF(SE2->E2_VALOR, SE2->E2_BAIXA, SE5->E5_DOCUMEN, "Baixa", SE2->E2_ZZIDTIT)
        
    EndIf

    // Retorna o objeto inalterado para não quebrar a gravação padrão do Protheus
Return oObj
