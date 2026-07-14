#Include 'Protheus.ch'
#Include 'TbiConn.ch'
  
/*/{Protheus.doc} F240AFIL
Ponto de Entrada para alterar o filtro de retorno dos Títulos conforme Modelo
@author Caio César Henrique
@since 29/05/2019
@version 1.0
@type function
@example U_F240AFIL()
/*/       
  
User Function F240FILTC()
    Local cMeuFiltro := ""
    
    /* * O Protheus já montou o SQL padrão gigante que você capturou.
     * Você só precisa iniciar a sua string com " AND ".
     *
     * IMPORTANTE: Como a string original capturada NÃO usa o alias "SE2.", 
     * nós também NÃO vamos usar para não quebrar a query. Use apenas os nomes dos campos.
     */
    
    // Exemplo: Filtrar apenas os títulos que o campo "Seu Campo" seja igual a algo
    // Lembre-se de respeitar os espaços em branco se o campo for maior!
    cMeuFiltro := " AND E2_ZZBLQPG <> '2' "
    
    // Outro exemplo (remova o comentário se for usar):
    // cMeuFiltro := " AND E2_PORTADO = '237' AND E2_TIPO = 'NF ' "
    
Return ( cMeuFiltro )
