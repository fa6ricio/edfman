#Include "XMLXFUN.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

// Ponto de entrada no final do processo de gravação para que seja possível a manutenção de alguma informação necessária.
// na entrada de nota fiscal de compra

/* ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT103FIM  º Autor ³Alexandre Santos    º Data ³  19/07/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³ Alterado para tratar fator de conversão atraves da função  º±±
±±º          ³  U_EDFFATOR(Par01)                                         º±±
±±º          ³  Par01 - Código do produto                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³  Analista :  Luis Felipe Nascimento       Data: 07/11/13   º±±
±±º          ³  Adequação no tratamento das Notas Fiscais Complementares  º±±
±±º          ³  para que esta seja valorizada na moeda5.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteração ³  Analista :  Luis Felipe Nascimento       Data: 05/12/13   º±±
±±º          ³  Adição forçada da inclusão do titulo a pagar pois, apesar º±±
±±º          ³  da TES estar informando que gera duplicata, devido as ca- º±±
±±º          ³  racteristiscas desta, o sistema não gera automaticamente. º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103FIM()

Local nOpcao        := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
Local nConfirma     := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFE
Local nFator        := 1          // Alexandre Santos 19/07/2013 - Tratamento do fator
Local aArea         := GetArea() 
Local lMSErroAuto   := .F.
Local aRotAuto      := {}
LOCAL XTIPNF        := ""

// Variaveis para a manipulacao e gravacao na ZX4
Local cAliasQZX4
Local cQueryZX4
Local lExisteZX4
Local cProxItem
Local cNomeForn

// u_SVMT103FIM() // 06/12/13 - Luis Felipe Nascimento

If INCLUI .AND. nConfirma=1
    cPEDIDO := POSICIONE("SD2",3,xFILIAL("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI, "D2_PEDIDO")
    nQTD    := SD1->D1_QUANT  //POSICIONE("SD2",3,xFILIAL("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI, "D2_QUANT")
    IF !EMPTY(cPEDIDO)
        cMEDIA :=POSICIONE("SC5",1,xFILIAL("SC5")+cPEDIDO, "C5_NRMEDIA")
        cCONTRA:=POSICIONE("SC5",1,xFILIAL("SC5")+cPEDIDO, "C5_CONTRAT")
        
        //'yTTALO P MARTINS-INICIO-ADICIONADO PERIODO NA CHAVE------------'*
        // dbSelectArea("SZ7")
        // dbSetOrder(2)
        // IF dbSeek(xFILIAL("SZ7")+cCONTRA+cMEDIA)
        
        cPERIODO := POSICIONE("SC5",1,xFILIAL("SC5")+cPEDIDO, "C5_XPERIOD")
        
        dbSelectArea("SZ7")
        dbSetOrder(3)
        IF dbSeek(xFILIAL("SZ7")+cCONTRA+cPERIODO+cMEDIA)
            
        //'yTTALO P MARTINS-FIM-------------------------------------------'*
            
            
            nFator := U_EDFFATOR(SD1->D1_COD)     // Alexandre Santos - 19/07/2013 - Alteracao para retirar o valor pre-fixado
            
            RecLock("SZ7",.F.)
            SZ7->Z7_SALDO+=(nQTD/nFator) // Alexandre Santos - 19/07/2013
            // SZ7->Z7_SALDO+=(nQTD/20) // Alexandre Santos - 19/07/2013
            MsUnLock()
        EndIf
        //GRAVAR NÚMERO DO CONTRATO NA SF1 / SD1
    ENDIF
    //CASO TES NAO GERE DUPLICATA
    // 11/12/13 - Luís Felipe Nascimento - Inicio
    If SF4->F4_DUPLIC == "S" // ValType(SE2->E2_NUM) <> "U" 
        DbSelectArea("SE2")
        DbSetOrder(6) 
        DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
        While !Eof() .and. SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC == SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM
            RecLock("SE2",.F.)
            SE2->E2_CLVLDB := SD1->D1_CLVL
            SE2->( MsUnLock() )
            DbSkip()
        End 
    EndIf
    // 11/12/13 - Luís Felipe Nascimento - Fim    
    
    // 07/11/13 - Luis Felipe Nascimento - Inicio
    If SD1->D1_TES $ "003/004/023"
        // aDados := FPedido()
        // If Len(aDados) <> 0
        //     RecLock("SF1",.f.)
        //     SF1->F1_CONTRA  := aDados[1][1]
        //     SF1->F1_XPERIOD := aDados[1][2]
        //     SF1->F1_XPEDIDO := aDados[1][3]
        //     MsUnlock()
        //     // Custo Moeda 5
        //     RecLock("SD1",.f.)
        //     SD1->D1_CUSTO5  := aDados[1][4]
        //     MsUnlock()
        // EndIf
        
        //'yTTALO P MARTINS-INICIO-GERAR FINANCEIRO PARA AS NOTAS DE COMPLEMENTO DE PREÇO-31/01/14-----------'*
                 
        If SF1->F1_TIPO == "C" .AND. SD1->D1_TES $ "003"
            
            IF SD1->D1_TES == "003"
                XTIPNF := "COMPL. PREÇO NF MAE "                
            ELSE 
                XTIPNF := "COMPL. PREÇO NF REMESSA "
            ENDIF
            
            dbSelectArea("SE2")
            SE2->(dbSetOrder(6))
            If (SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)) )==.F.
            
                //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
                //³ Gera nota de debito ao fornecedor          ³
                //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                AAdd( aRotAuto, { "E2_FILIAL" , XFILIAL("SE2"), NIL } )
                AAdd( aRotAuto, { "E2_PREFIXO", SF1->F1_SERIE, NIL } )              
                AAdd( aRotAuto, { "E2_NUM"    , SF1->F1_DOC, NIL } )
                AAdd( aRotAuto, { "E2_PARCELA", "", NIL } )
                AAdd( aRotAuto, { "E2_TIPO"   , "NF", NIL } )   
                AAdd( aRotAuto, { "E2_NATUREZ", "0068", NIL } )                         
                AAdd( aRotAuto, { "E2_FORNECE", SF1->F1_FORNECE, NIL } )
                AAdd( aRotAuto, { "E2_LOJA"   , SF1->F1_LOJA, NIL } )
                AAdd( aRotAuto, { "E2_EMISSAO", SF1->F1_EMISSAO, NIL } )
                AAdd( aRotAuto, { "E2_VENCTO" , dDatabase, NIL } )
                AAdd( aRotAuto, { "E2_VENCREA", dDatabase, NIL } )                              
                AAdd( aRotAuto, { "E2_VALOR"  , SD1->D1_TOTAL, NIL } )
                AAdd( aRotAuto, { "E2_EMIS1"  , SF1->F1_EMISSAO, NIL } )
                AADD( aRotAuto, { "E2_HIST"   , XTIPNF+SD1->D1_NFORI+" "+SD1->D1_SERIORI, NIL})
                AADD( aRotAuto, { "E2_LA"     , "S", NIL})                                          
                AADD( aRotAuto, { "E2_VENCORI", dDatabase, NIL })
                AADD( aRotAuto, { "E2_MOEDA"  , 1, NIL})
                AADD( aRotAuto, { "E2_MDCONTR", SF1->F1_CONTRA, NIL})
                AADD( aRotAuto, { "E2_ORIGEM" , "MATA100" , NIL})
                
                Begin Transaction
                
                MSExecAuto({|x, y| FINA050(x, y)}, aRotAuto, 3)
                
                IF lMsErroAuto
                    MostraErro()
                    DisarmTransaction()
                    
                    Break
                ELSE
                
                    dbSelectArea("SE2")
                    SE2->(dbSetOrder(6))
                    SE2->(dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC))

                    RecLock("SE2",.F.)
                        SE2->E2_LA  := "S"
                    ("SE2")->(MsUnlock())
        
                EndIF
                
                End Transaction
            
            ENDIF
            
        EndIf                                                                                                               
        
        //'yTTALO P MARTINS-FIM-GERAR FINANCEIRO PARA AS NOTAS DE COMPLEMENTO DE PREÇO-31/01/14--------------'* // 05/12/13 = Luís Felipe Nascimento - INICIO
        // If SF4->F4_DUPLIC == "S" .and. SD1->D1_TES == "003"
        //     AAdd( aRotAuto, { "E2_NUM"    , SF1->F1_DOC, NIL } )
        //     AAdd( aRotAuto, { "E2_PREFIXO", SF1->F1_SERIE, NIL } )
        //     AAdd( aRotAuto, { "E2_NATUREZ", "0068", NIL } )
        //     AAdd( aRotAuto, { "E2_PARCELA", "", NIL } )
        //     AAdd( aRotAuto, { "E2_TIPO"   , "NF", NIL } )
        //     AAdd( aRotAuto, { "E2_FORNECE", SF1->F1_FORNECE, NIL } )
        //     AAdd( aRotAuto, { "E2_LOJA"   , SF1->F1_LOJA, NIL } )
        //     AAdd( aRotAuto, { "E2_VALOR"  , SD1->D1_TOTAL, NIL } )
        //     AAdd( aRotAuto, { "E2_EMISSAO", SF1->F1_EMISSAO, NIL } )
        //     AAdd( aRotAuto, { "E2_VENCTO" , dDatabase, NIL } )
        //     AAdd( aRotAuto, { "E2_VENCREA", dDatabase, NIL } )
        //     AADD( aRotAuto, { "E2_VENCORI", dDatabase, NIL })
        //     AADD( aRotAuto, { "E2_MOEDA"  , 1, NIL})
        //     AADD( aRotAuto, { "E2_MDCONTR", SF1->F1_CONTRA, NIL})
        //     AADD( aRotAuto, { "E2_ORIGEM" , "PRENFE" , NIL})
        //     AADD( aRotAuto, { "E2_CLVLDB" , SD1->D1_CLVL , NIL})
        //     AADD( aRotAuto, { "E2_HIST"   , "COMPL.MAE "+SD1->D1_NFORI+" "+SD1->D1_SERIORI, NIL})
        //     AADD( aRotAuto, { "E2_LA"     , "S", NIL})
        //     
        //     MSExecAuto({|x, y| FINA050(x, y)}, aRotAuto, 3)
        //     
        //     If lMsErroAuto
        //         MostraErro()
        //     EndIf
        // EndIf
        // 05/12/13 = Luís Felipe Nascimento - FIM
        
    EndIf
    // 07/11/13 - Luis Felipe Nascimento - Fim
    
EndIf

//Chamada Simplefarfa
If (INCLUI .OR. nOpcao = 4) .AND. nConfirma=1
    cPedido     := ''
    cContraSF   := ''
    dbSelectArea('SC7')
    SC7->(dbSetOrder(1))
    cPedido := POSICIONE("SD1",1,xFILIAL("SD1")+SF1->F1_DOC+SF1->F1_SERIE, "D1_PEDIDO")
    IF !Empty(cPedido)
        IF SC7->(dbSeek(xFilial('SC7')+cPedido))
            cContraSF:=SC7->C7_XCONSI
            IF !Empty(cContraSF)
                If FindFunction("U_PUTEFENT")
                    U_PUTEFENT()
                Endif
                
                cAliasQZX4 := GetNextAlias()
                lExisteZX4 := .F.
                
                cQueryZX4 := "SELECT ZX4_NF FROM " + RetSqlName("ZX4") + " "
                cQueryZX4 += "WHERE ZX4_FILIAL = '" + xFilial("ZX4") + "' "
                cQueryZX4 += "AND ZX4_NF = '" + SF1->F1_DOC + "' "
                cQueryZX4 += "AND ZX4_SERIE = '" + SF1->F1_SERIE + "' "
                cQueryZX4 += "AND ZX4_FORNEC = '" + SF1->F1_FORNECE + "' "
                cQueryZX4 += "AND ZX4_LOJA = '" + SF1->F1_LOJA + "' "
                cQueryZX4 += "AND D_E_L_E_T_ = ' ' "
                
                cQueryZX4 := ChangeQuery(cQueryZX4)
                DBUseArea( .T., "TOPCONN", TcGenQry(,,cQueryZX4), cAliasQZX4, .F., .T. )
                
                If !(cAliasQZX4)->(Eof())
                    lExisteZX4 := .T.
                EndIf
                (cAliasQZX4)->(DbCloseArea())
                
                If !lExisteZX4
                    cProxItem  := "001"
                    cAliasQZX4 := GetNextAlias()
                    
                    cQueryZX4 := "SELECT MAX(ZX4_ITEM) AS MAXITEM FROM " + RetSqlName("ZX4") + " "
                    cQueryZX4 += "WHERE ZX4_FILIAL = '" + xFilial("ZX4") + "' "
                    cQueryZX4 += "AND ZX4_CODIGO = '" + cContraSF + "' "
                    cQueryZX4 += "AND D_E_L_E_T_ = ' ' "
                    
                    cQueryZX4 := ChangeQuery(cQueryZX4)
                    DBUseArea( .T., "TOPCONN", TcGenQry(,,cQueryZX4), cAliasQZX4, .F., .T. )
                    
                    If !(cAliasQZX4)->(Eof()) .And. !Empty((cAliasQZX4)->MAXITEM)
                        cProxItem := StrZero(Val((cAliasQZX4)->MAXITEM) + 1, TamSx3("ZX4_ITEM")[1])
                    EndIf
                    (cAliasQZX4)->(DbCloseArea())
                    
                    cNomeForn := ""
                    DbSelectArea("SA2")
                    SA2->(DbSetOrder(1)) 
                    If SA2->(DbSeek(xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA))
                        cNomeForn := SA2->A2_NOME
                    EndIf
                    
                    RecLock("ZX4", .T.)
                    ZX4->ZX4_FILIAL := xFilial("ZX4")
                    ZX4->ZX4_CODIGO := cContraSF
                    ZX4->ZX4_ITEM   := cProxItem
                    ZX4->ZX4_NF     := SF1->F1_DOC
                    ZX4->ZX4_SERIE  := SF1->F1_SERIE
                    ZX4->ZX4_FORNEC := SF1->F1_FORNECE
                    ZX4->ZX4_LOJA   := SF1->F1_LOJA
                    ZX4->ZX4_NOMFOR := cNomeForn
                    ZX4->ZX4_VLRTOT := SF1->F1_VALBRUT
                    ZX4->(MsUnlock())
                EndIf

            EndIF
        EndIf
    EndIF

    // Substituído blocos comentados problemáticos por comentários de linha dupla (//)
    // IF SF1->F1_TIPO = 'D' ;
    // .AND. Alltrim(POSICIONE("SD1",1,xFILIAL("SD1")+SF1->F1_DOC+SF1->F1_SERIE, "D1_COD")) = 'ALGODAO';
    // .AND. Alltrim(POSICIONE("SD1",1,xFILIAL("SD1")+SF1->F1_DOC+SF1->F1_SERIE, "D1_CF")) $ '2506/1506'
    //     If FindFunction("U_PUTEFENT")
    //         U_PUTEFENT()
    //     Endif
    // EndIF
Endif

RestArea(aArea)

Return

*-----------------------*
Static function FPedido()
*-----------------------*

Local oDlg
Local cContrato := Space(TamSx3("F1_CONTRA")[1])
Local cPedido   := Space(TamSx3("F1_XPEDIDO")[1])
Local cPeriodo  := Space(TamSx3("F1_XPERIOD")[1])
Local nPtax     := 0
Local cCNPJFor  := GetAdvFVal( "SA2", "A2_CGC", xFilial("SA2")+SA2->A2_COD, 1, " " )
Local nOpc      := 0
Local aDados    := {}
Private  lRet   := .t.

DEFINE MSDIALOG oDlg TITLE "Amarração NF Complementar" From 000,000 TO 210,300 PIXEL

@ 010,020 SAY "Contrato:" Pixel Of oDlg
@ 010,060 MSGET cContrato Picture PesqPict("SZ3","Z3_CONTRA") Size 70,10 F3 "SZ3" Valid (fValidaFor(cCNPJFor,SZ3->Z3_CONTRA),fVldCtr(SZ3->Z3_CONTRA),SZ3->Z3_PERIODO,dlgRefresh(oDlg)) OF oDlg PIXEL

@ 030,020 SAY "Período:" Pixel Of oDlg
@ 030,060 MSGET SZ3->Z3_PERIODO Picture PesqPict("SZ3","Z3_PERIODO") When .f. OF oDlg PIXEL

@ 050,020 SAY "Pedido:" Pixel Of oDlg
@ 050,060 MSGET cPedido Picture PesqPict("SF1","F1_XPEDIDO") Size 70,10 F3 "SC7_CS" OF oDlg PIXEL
//@ 050,060 MSGET cPedido Picture PesqPict("SF1","F1_XPEDIDO") Size 70,10 F3 "SC7_CS" Valid (!Empty(cPedido)) OF oDlg PIXEL // 12/11/13 - Luis Felipe Nascimento

@ 070,020 SAY "Ptax :" Pixel Of oDlg
@ 070,060 MSGET nPtax   Picture PesqPict("SC7","C7_TAXAUSD") Size 70,10 Valid (Empty(cPedido) .and. nPtax <> 0.0) OF oDlg PIXEL

DEFINE SBUTTON  FROM 090,090 TYPE 1 ACTION (nOpc == 1,LRET:=.T.,oDlg:End()) ENABLE OF oDlg PIXEL
DEFINE SBUTTON  FROM 090,120 TYPE 2 ACTION (nOpc == 0,LRET:=.F.,oDlg:End()) ENABLE OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTER

If nOpc == 0
    cPeriodo := SZ3->Z3_PERIODO
    Aadd(aDados,{cContrato,cPeriodo,cPedido,SD1->D1_CUSTO/nPtax})
EndIf

Return(aDados)

*---------------------------------------*
Static Function fValidaFor(cCNPJ,cContra)
*---------------------------------------*

SA2->(DbSetOrder(3))
SA2->(DbSeek(xFilial("SA2")+cCNPJ))

CNC->(DbSetOrder(1))
CNC->(DbSeek(xFilial("CNC")+cContra+SA2->(A2_COD+A2_LOJA)))

If SA2->(A2_COD+A2_LOJA) <> CNC->(CNC_CODIGO+CNC_LOJA)
    Aviso("Aviso","O Contrato selecionado não foi criado para o fornecedor desta Nota Fiscal !",{"Voltar"})
    lRet := .f.
EndIf

Return( lRet )

*---------------------------------------*
Static Function fVldCtr(cContra,cPeriodo)
*---------------------------------------*

Local cProduto  := Alltrim(cContra)+"-"+Alltrim(cPeriodo)

If  SD1->D1_COD <> cProduto .and. lRet
    Aviso("Atenção","O produto informado na Nota Fiscal não coincide com o Contrato + DP selecionado. Produto da NF "+ SD1->D1_COD + " versos " + cProduto + " !",{"Voltar"})
    lRet := .f.
EndIf

Return( lRet )
