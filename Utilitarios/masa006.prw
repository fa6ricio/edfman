
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MASA006 บAutor ณ Marcelo Amaral        บ Data ณ 28/12/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Utilitแrios                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Estudo                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MASA006()

Local aArea := GetArea()
Local aRet := {}
Local aParamBox := {}
Local aCombo := {   "Inspetor",;
                    "Pontos de Entrada"}
Local cOper := ""
Local xMv_Par01
Private cCadastro := "Parโmetros"

xMv_Par01 := MV_PAR01

mv_par01 := 1

AADD(aParamBox,{2,; 			// Combo
                "Opera็ใo",;    // Descri็ใo
                MV_PAR01,;		// Num้rico contendo a op็ใo inicial do combo
                aCombo,; 		// Array contendo as op็๕es do Combo
                80,; 			// Tamanho do Combo
                ".T.",;			// Valida็ใo
                .T.}) 			// Flag .T./.F. Parโmetro Obrigat๓rio ?

// Parametros da fun็ใo Parambox()
// -------------------------------
// 1 - < aParametros > - Vetor com as configura็๕es
// 2 - < cTitle >      - Tํtulo da janela
// 3 - < aRet >        - Vetor passador por referencia que cont้m o retorno dos parโmetros
// 4 - < bOk >         - Code block para validar o botใo Ok
// 5 - < aButtons >    - Vetor com mais bot๕es al้m dos bot๕es de Ok e Cancel
// 6 - < lCentered >   - Centralizar a janela
// 7 - < nPosX >       - Se nใo centralizar janela coordenada X para inํcio
// 8 - < nPosY >       - Se nใo centralizar janela coordenada Y para inํcio
// 9 - < oDlgWizard >  - Utiliza o objeto da janela ativa
//10 - < cLoad >       - Nome do perfil se caso for carregar
//11 - < lCanSave >    - Salvar os dados informados nos parโmetros por perfil
//12 - < lUserSave >   - Configura็ใo por usuแrio

// Caso alguns parโmetros para a fun็ใo nใo seja passada serแ considerado DEFAULT as seguintes abaixo:
// DEFAULT bOk   := {|| (.T.)}
// DEFAULT aButtons := {}
// DEFAULT lCentered := .T.
// DEFAULT nPosX  := 0
// DEFAULT nPosY  := 0
// DEFAULT cLoad     := ProcName(1)
// DEFAULT lCanSave := .T.
// DEFAULT lUserSave := .F.

While .T.
    If ParamBox(aParamBox,"Informe os Parโmetros...",@aRet,,,,,,,"",.F.,.F.)
        if ValType(aRet[1]) == "N"
            cOper := aCombo[aRet[1]]
        else
            cOper := aRet[1]
        endif
        if cOper == "Inspetor"
            U_MASA004()
        elseif cOper == "Pontos de Entrada"
            U_MASA007()
        endif
    else
        /*
        If MsgYesNo('Quer sair da Rotina?','Confirma็ใo')
            exit
        endif
        */
        exit
    Endif
end

MV_PAR01 := xMv_Par01

RestArea(aArea)

Return
