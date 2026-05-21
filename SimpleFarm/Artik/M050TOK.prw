#INCLUDE "PROTHEUS.CH"

/*
================================================================================
| Ponto de Entrada  | M050TOK                                                 |
|------------------------------------------------------------------------------|
| Autor             | Bruno Mendes/Artiq                                       |
| Data              | 15/10/2025                                               |
| Descrição         | Altera o campo A4_XSINTE para 'S' após a confirmação     |
|                   | de uma alteração no cadastro de clientes.                |
|------------------------------------------------------------------------------|
| Observações       | Este PE executa APÓS a gravação principal. Ele realiza   |
|                   | uma segunda operação de lock e unlock no banco de dados  |
|                   | para atualizar o campo customizado.                      |
================================================================================
*/

User Function M050TOK()
Local lRet := .T. // O retorno deste PE não interfere no fluxo padrão

// Verifica se o campo já não está com o valor desejado, para evitar gravações desnecessárias.
If SA4->A4_XSINTE <> 'S'

    // Inicia o tratamento de erro para garantir que o registro não fique travado.
    Begin Transaction

        // RecLock no registro já posicionado. O .F. indica para não procurar novamente.
        // Se outro usuário estiver editando, o Protheus aguardará a liberação.
        RecLock("SA4", .F.)

        // Atribui o novo valor ao campo.
        SA4->A4_XSINTE := 'S'

        // Efetiva a gravação no banco e libera o registro.
        SA4->(MsUnLock())

    End Transaction

EndIf

Return lRet
