#Include "Totvs.ch"

User Function FA090EST()
    Local aAreaSE2 := SE2->(GetArea())
    Local aAreaSE5 := SE5->(GetArea())

    // Dispara a regra centralizada no CNTEDF04 passando os dados do estorno
    U_EnvBxaSF(SE5->E5_VALOR, dDataBase, SE5->E5_DOCUM, "Estorno")

    RestArea(aAreaSE5)
    RestArea(aAreaSE2)
Return Nil
