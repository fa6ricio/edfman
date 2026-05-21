#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDef.CH"     
#INCLUDE "FWBROWSE.CH"
#INCLUDE "TOTVS.CH"   
#INCLUDE "TBICONN.CH"        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MASA004 ºAutor ³ Marcelo Amaral        º Data ³ 17/12/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inspetor de Objetos                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Estudo                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MASA004()

Private cArquivo := "Inspetor_"+dtos(Date())+"_"+;
StrTran(Time(),":","")+".xml"
Private cPath := cGetFile('*.*|*.*','Escolha o local para gravar o Inspetor',0,'C:\',.F.,;
nOR(GETF_LOCALHARD,GETF_LOCALFLOPPY,GETF_RETDIRECTORY),.T.,.T.)

if Empty(cPath)
    Return
endif

Processa({|| GeraInsp()},"Gerando o Inspetor de Objetos . . .")

Return

Static Function GeraInsp()

Local aData
Local aFontes := {}
Local nCont
Local aRelat := {}
Local aRelat2 := {}
Local aRelat3 := {}
Local aRelat4 := {}
Local aType := {}
Local aFile := {}
Local aLine := {}
Local aDate := {}
Local aTime := {}

// Fontes RPO Padrão e Customizado

aadd(aRelat,{})
aadd(aRelat[Len(aRelat)],"Nome")
aadd(aRelat[Len(aRelat)],"Linguagem")
aadd(aRelat[Len(aRelat)],"Compilação")
aadd(aRelat[Len(aRelat)],"Data")
aadd(aRelat[Len(aRelat)],"Hora")

aFontes := GetSrcArray("*")

ProcRegua(Len(aFontes))

For nCont := 1 to Len(aFontes)
	IncProc("Buscando Informações do Fonte "+aFontes[nCont]+" ("+cValToChar(nCont)+"/"+cValToChar(Len(aFontes))+") . . .")
    aData := GetAPOInfo(aFontes[nCont])
    aadd(aRelat,{})
    aadd(aRelat[Len(aRelat)],aData[1])
    aadd(aRelat[Len(aRelat)],aData[2])
    aadd(aRelat[Len(aRelat)],aData[3])
    aadd(aRelat[Len(aRelat)],aData[4])
    aadd(aRelat[Len(aRelat)],aData[5])
Next

// Fontes RPO Padrão

aadd(aRelat3,{})
aadd(aRelat3[Len(aRelat3)],"Nome")
aadd(aRelat3[Len(aRelat3)],"Linguagem")
aadd(aRelat3[Len(aRelat3)],"Compilação")
aadd(aRelat3[Len(aRelat3)],"Data")
aadd(aRelat3[Len(aRelat3)],"Hora")

aFontes := GetSrcArray("*",1)

ProcRegua(Len(aFontes))

For nCont := 1 to Len(aFontes)
	IncProc("Buscando Informações do Fonte "+aFontes[nCont]+" ("+cValToChar(nCont)+"/"+cValToChar(Len(aFontes))+") . . .")
    aData := GetAPOInfo(aFontes[nCont])
    aadd(aRelat3,{})
    aadd(aRelat3[Len(aRelat3)],aData[1])
    aadd(aRelat3[Len(aRelat3)],aData[2])
    aadd(aRelat3[Len(aRelat3)],aData[3])
    aadd(aRelat3[Len(aRelat3)],aData[4])
    aadd(aRelat3[Len(aRelat3)],aData[5])
Next

// Fontes RPO Customizado

aadd(aRelat4,{})
aadd(aRelat4[Len(aRelat4)],"Nome")
aadd(aRelat4[Len(aRelat4)],"Linguagem")
aadd(aRelat4[Len(aRelat4)],"Compilação")
aadd(aRelat4[Len(aRelat4)],"Data")
aadd(aRelat4[Len(aRelat4)],"Hora")

aFontes := GetSrcArray("*",3)

ProcRegua(Len(aFontes))

For nCont := 1 to Len(aFontes)
	IncProc("Buscando Informações do Fonte "+aFontes[nCont]+" ("+cValToChar(nCont)+"/"+cValToChar(Len(aFontes))+") . . .")
    aData := GetAPOInfo(aFontes[nCont])
    aadd(aRelat4,{})
    aadd(aRelat4[Len(aRelat4)],aData[1])
    aadd(aRelat4[Len(aRelat4)],aData[2])
    aadd(aRelat4[Len(aRelat4)],aData[3])
    aadd(aRelat4[Len(aRelat4)],aData[4])
    aadd(aRelat4[Len(aRelat4)],aData[5])
Next

// Funções

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
	IncProc("Buscando Informações da Função "+aFuncoes[nCont]+" ("+cValToChar(nCont)+"/"+cValToChar(Len(aFuncoes))+") . . .")
    aadd(aRelat2,{})
    aadd(aRelat2[Len(aRelat2)],aFuncoes[nCont])
    aadd(aRelat2[Len(aRelat2)],aType[nCont])
    aadd(aRelat2[Len(aRelat2)],aFile[nCont])
    aadd(aRelat2[Len(aRelat2)],aLine[nCont])
    aadd(aRelat2[Len(aRelat2)],aDate[nCont])
    aadd(aRelat2[Len(aRelat2)],aTime[nCont])
Next

/*
aData := GetAPOInfo("MATA103.prw")

alert(aData[1]) // Nome do fonte
alert(aData[2]) // Linguagem do fonte. Exemplo: AdvPL, 4GL, ...
alert(aData[3]) // Modo de Compilação
alert(aData[4]) // Data da última modificação do arquivo
alert(aData[5]) // Hora, minutos e segundos da última modificação realizada no arquivo
*/

/*
Modo de Compilação:
0 - BUILD_FULL
Usuário tem permissão para compilar qualquer tipo de fonte
2 - BUILD_PARTNER
Permissão de compilação da Fábrica de Software TOTVS
3 - BUILD_PATCH
Aplicação de Patch
1 - BUILD_USER
Usuário só pode compilar User Functions
*/

/*
aData := GetAPOInfo("MASA004.prw")

alert(aData[1]) // Nome do fonte
alert(aData[2]) // Linguagem do fonte. Exemplo: AdvPL, 4GL, ...
alert(aData[3]) // Modo de Compilação
alert(aData[4]) // Data da última modificação do arquivo
alert(aData[5]) // Hora, minutos e segundos da última modificação realizada no arquivo
*/

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

cWork1 := "Fontes RPO Padrão e Custom"
oPlan:AddWorkSheet(cWork1)
cTable1 := "Inspetor de Objetos - Ambiente "+GetEnvServer()
oPlan:AddTable(cWork1,cTable1)

ProcRegua(Len(aRelat))

For nCont := 1 to Len(aRelat[1])
	oPlan:AddColumn(cWork1,cTable1,aRelat[1,nCont],1,1)
Next

For nCont := 2 to Len(aRelat)
	IncProc("Gerando a Planilha ("+cValToChar(nCont)+"/"+cValToChar(Len(aRelat))+") . . .")
	oPlan:AddRow(cWork1,cTable1,aRelat[nCont])
Next

cWork3 := "Fontes RPO Padrão"
oPlan:AddWorkSheet(cWork3)
cTable3 := "Inspetor de Objetos - Ambiente "+GetEnvServer()
oPlan:AddTable(cWork3,cTable3)

ProcRegua(Len(aRelat3))

For nCont := 1 to Len(aRelat3[1])
	oPlan:AddColumn(cWork3,cTable3,aRelat3[1,nCont],1,1)
Next

For nCont := 2 to Len(aRelat3)
	IncProc("Gerando a Planilha ("+cValToChar(nCont)+"/"+cValToChar(Len(aRelat3))+") . . .")
	oPlan:AddRow(cWork3,cTable3,aRelat3[nCont])
Next

cWork4 := "Fontes RPO Customizado"
oPlan:AddWorkSheet(cWork4)
cTable4 := "Inspetor de Objetos - Ambiente "+GetEnvServer()
oPlan:AddTable(cWork4,cTable4)

ProcRegua(Len(aRelat4))

For nCont := 1 to Len(aRelat4[1])
	oPlan:AddColumn(cWork4,cTable4,aRelat4[1,nCont],1,1)
Next

For nCont := 2 to Len(aRelat4)
	IncProc("Gerando a Planilha ("+cValToChar(nCont)+"/"+cValToChar(Len(aRelat4))+") . . .")
	oPlan:AddRow(cWork4,cTable4,aRelat4[nCont])
Next

cWork2 := "Funções"
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
