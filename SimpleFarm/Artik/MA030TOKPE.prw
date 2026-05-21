#INCLUDE "PROTHEUS.CH"

/*
================================================================================
| Ponto de Entrada  | MA030TOK                                                 |
|------------------------------------------------------------------------------|
| Autor             | Bruno Mendes/Artiq                                       |
| Data              | 15/10/2025                                               |
| Descrição         | Altera o campo A1_XSINTE para 'S' após a confirmação     |
|                   | de uma alteração no cadastro de clientes.                |
|------------------------------------------------------------------------------|
| Observações       | Este PE executa APÓS a gravação principal. Ele realiza   |
|                   | uma segunda operação de lock e unlock no banco de dados  |
|                   | para atualizar o campo customizado.                      |
================================================================================
*/

User Function MA030TOK()
Local lRet := .T. // O retorno deste PE não interfere no fluxo padrão


// Verifica se o campo já não está com o valor desejado, para evitar gravações desnecessárias.
If SA1->A1_XSINTE <> 'S'

    // Inicia o tratamento de erro para garantir que o registro não fique travado.
    Begin Transaction

        // RecLock no registro já posicionado. O .F. indica para não procurar novamente.
        // Se outro usuário estiver editando, o Protheus aguardará a liberação.
        RecLock("SA1", .F.)

        // Atribui o novo valor ao campo.
        SA1->A1_XSINTE := 'S'

        // Efetiva a gravação no banco e libera o registro.
        SA1->(MsUnLock())

    End Transaction

EndIf

Return lRet
