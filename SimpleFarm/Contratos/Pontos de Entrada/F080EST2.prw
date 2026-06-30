#Include "Totvs.ch"

/*
______________________________________________________________________________
|_____________________________________________________________________________|
|Programa  - F080EST2    Autor  Alex da Silva         Data   29/06/2026   	  |
|_____________________________________________________________________________|
|Descricao|O ponto de entrada F080EST2 sera utilizado para gravacoes          |
|         |complementares apos confirmar o registro de estorno ou cancelamento|
|         |da baixa do titulo de contas a pagar. Este ponto de entrada sera   | 
|         |executado apos gravar os dados no SE5. Nao tem retorno nem recebe  |
|         |parametros.                                                        |
|_________|___________________________________________________________________|
|Uso      | ED & F                                                            | 
|_________|___________________________________________________________________|
|_____________________________________________________________________________|
*/

User Function F080EST2()
    Local aAreaSE2 := SE2->(GetArea())
    Local aAreaSE5 := SE5->(GetArea())

    // Como é um estorno, a data do movimento passa a ser a data base atual do sistema (dDataBase).
    // O SE5->E5_VALOR contém o valor que está sendo devolvido ao título.
    U_EnvBxaSF(SE5->E5_VALOR, dDataBase, SE5->E5_DOCUMEN, "Estorno")

    RestArea(aAreaSE5)
    RestArea(aAreaSE2)
Return Nil
