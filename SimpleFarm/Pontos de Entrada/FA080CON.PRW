#Include "Totvs.ch"

User Function FA080CON()
    Local aAreaSE2 := SE2->(GetArea())
    Local aAreaSE5 := SE5->(GetArea())

    // Dispara a regra centralizada no CNTEDF04 passando os dados da baixa
    U_EnvBxaSF(SE5->E5_VALOR, SE5->E5_DATA, SE5->E5_DOCUM, "Baixa")

    RestArea(aAreaSE5)
    RestArea(aAreaSE2)
Return Nil
