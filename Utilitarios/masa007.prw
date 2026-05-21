#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDef.CH"     
#INCLUDE "FWBROWSE.CH"
#INCLUDE "TOTVS.CH"   
#INCLUDE "TBICONN.CH"        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MASA007 บAutor ณ Marcelo Amaral        บ Data ณ 17/12/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pontos de Entrada                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Estudo                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MASA007()

Local aArea := GetArea()
Local aRet := {}
Local aParamBox := {}
Local cFonte
Local cFile := Space(60)
Local xMv_Par01
Private cCadastro := "Parโmetros"

Private cArquivo := "Inspetor_"+dtos(Date())+"_"+;
StrTran(Time(),":","")+".xml"
Private cPath := cGetFile('*.*|*.*','Escolha o local para gravar o Inspetor',0,'C:\',.F.,;
nOR(GETF_LOCALHARD,GETF_LOCALFLOPPY,GETF_RETDIRECTORY),.T.,.T.)

if Empty(cPath)
    Return
endif

xMv_Par01 := MV_PAR01

mv_par01 := cFile

AADD(aParamBox,{1,; 								// MsGet
                "Fonte(s)",;						// Descri็ใo
                MV_PAR01,;							// String contendo o inicializador do campo
                "@!",; 								// String contendo a Picture do campo
                "",;								// String contendo a valida็ใo
                "",; 								// Consulta F3
                ".T.",;								// String contendo a valida็ใo When
                100,; 								// Tamanho do MsGet
                .T.}) 								// Flag .T./.F. Parโmetro Obrigat๓rio ?

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
        if !Empty(aRet[1])
            cFile := Alltrim(aRet[1])
            exit
        endif
    else
        /*
        If MsgYesNo('Quer sair da Rotina?','Confirma็ใo')
            exit
        endif
        */
        cFile := ""
        exit
    Endif
end

MV_PAR01 := xMv_Par01

if Empty(cFile)
    Return
endif

cFonte := cFile

if At(".PRW",cFile) = 0 .and. At(".PRX",cFile) = 0 .and. At(".PRG",cFile) = 0
    cFonte += ".PRW"
endif

Processa({|| GeraInsp(cFonte)},"Gerando o Inspetor de Objetos . . .")

RestArea(aArea)

Return

Static Function GeraInsp(cFonte)

Local nCont
Local aRelat2 := {}
Local aType := {}
Local aFile := {}
Local aLine := {}
Local aDate := {}
Local aTime := {}

// Fun็๕es

aadd(aRelat2,{})
aadd(aRelat2[Len(aRelat2)],"Nome")
aadd(aRelat2[Len(aRelat2)],"Tipo")
aadd(aRelat2[Len(aRelat2)],"Fonte")
aadd(aRelat2[Len(aRelat2)],"Linha")
aadd(aRelat2[Len(aRelat2)],"Data")
aadd(aRelat2[Len(aRelat2)],"Hora")

aFuncoes := GetFuncArray('*',aType,aFile,aLine,aDate,aTime)

ProcRegua(Len(aFuncoes))

For nCont := 1 to Len(aFuncoes)
	IncProc("Buscando Informa็๕es da Fun็ใo "+aFuncoes[nCont]+" ("+cValToChar(nCont)+"/"+cValToChar(Len(aFuncoes))+") . . .")
    if Alltrim(aFile[nCont]) == cFonte
        aadd(aRelat2,{})
        aadd(aRelat2[Len(aRelat2)],aFuncoes[nCont])
        aadd(aRelat2[Len(aRelat2)],aType[nCont])
        aadd(aRelat2[Len(aRelat2)],aFile[nCont])
        aadd(aRelat2[Len(aRelat2)],aLine[nCont])
        aadd(aRelat2[Len(aRelat2)],aDate[nCont])
        aadd(aRelat2[Len(aRelat2)],aTime[nCont])
    endif
Next

oPlan := FWMsExcel():New() 

oPlan:SetTitleBold(.T.)    
oPlan:SetTitleBgColor("#870a28")
oPlan:SetTitleFrColor("#ffffff")      
oPlan:SetBgColorHeader("#00613c")
oPlan:SetFrColorHeader("#ffffff")
oPlan:SetLineBgColor("#ffffff")
oPlan:SetLineFrColor("#00613c")       
oPlan:Set2LineBgColor("#ffffff")
oPlan:Set2LineFrColor("#870a28")      

cWork2 := "Fun็๕es"
oPlan:AddWorkSheet(cWork2)
cTable2 := "Inspetor de Objetos - Ambiente "+GetEnvServer()
oPlan:AddTable(cWork2,cTable2)

ProcRegua(Len(aRelat2))

For nCont := 1 to Len(aRelat2[1])
	oPlan:AddColumn(cWork2,cTable2,aRelat2[1,nCont],1,1)
Next

For nCont := 2 to Len(aRelat2)
	IncProc("Gerando a Planilha ("+cValToChar(nCont)+"/"+cValToChar(Len(aRelat2))+") . . .")
	oPlan:AddRow(cWork2,cTable2,aRelat2[nCont])
Next

If !Empty(oPlan:aWorkSheet)
	oPlan:Activate()
	LjMsgRun("Gerando o arquivo, aguarde . . .","Inspetor de Objetos",{|| oPlan:GetXMLFile(cArquivo)})
	CpyS2T("\SYSTEM\"+cArquivo,cPath)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath+cArquivo) // Abre a planilha
	oExcelApp:SetVisible(.T.)
EndIf

Return
