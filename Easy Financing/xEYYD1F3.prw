#include 'protheus.ch'
#include 'parmtype.ch'
#Include "EEC.CH"
#Include "EECAE110.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FWBROWSE.CH"
#Include "TOPCONN.CH"
#Include "AVERAGE.CH"
#Include "TOTVS.CH"

#Define SOMAR    1
#Define SUBTRAIR 2

/*
Função     : xEYYD1F3()
Objetivo   : Exibir itens da SD1 que podem ser associados aos itens do embarque, destinados
             à exportação indireta
Parâmetros :
Retorno    :
Autor      : WFS
Data       : jun/2016
Observações: Variável lExecConPad1 é de controle; indica se a consulta padrão via validação do campo EYY_NFENT deve ser executada
Revisão    :
*/
user Function xEYYD1F3()
Local aEnchoice:= {}
Local nCont
Local oDlg, oMsMget, oBrowse
//Local aDados:= {}
Local aSeek := {}
//Local bOk:= {|| If( ValOkF3(aCampos, aDados[oBrowse:nAt]) , ( GrvDados(aCampos, aDados[oBrowse:nAt]), lRet:= .T., lExecConPad1:= .F.,  oDlg:End() ) , ) }
Local bOk:= {|| if ( fGrava(), (lRet:= .T., lExecConPad1:= .F., oDlg:End() ), ) }
Local bCancel:= {|| lRet:= .F., lExecConPad1:= .T., If(Empty(M->EYY_NFENT),M->EYY_NFENT:= WK_NFRem->EYY_NFENT,), oDlg:End()}
Local lRet:= .T.
Local nRecNoOrig:= WK_NFRem->(RecNo())
//Local cChaveWkIp:= ""
//Local aOrdWkIp  := {}
Local lFiltNcm := EasyGParam("MV_EEC0051",,.F.)
Local nTamDesc := IF(WK_NFRem->(FieldPos("EYY_VM_DES")) > 0,mlcount(WK_NFRem->EYY_VM_DES,AvSx3("EYY_VM_DES", AV_TAMANHO)),5)//LRS - 11/07/2018
Local nAlTela  := If(nTamDesc > 5, 130 , 50 +  (5 * nTamDesc ) )   // If( AvSx3("EYY_VM_DES", AV_TIPO) == "C",50,130)
Local lFimEspecNew := AvFlags("ROTINA_VINC_FIM_ESPECIFICO_RP12.1.20")
Local lBkpAlt
Local lBkpInc

Private aTela:= {}, aGets:= {}
Private cTitulo:= STR0184 //"Notas fiscais de entrada"
Private aCampos:= {}
Private aDados := {}
Private aFilter:= {}

Begin Sequence

   If EasyGParam("MV_EEC0050",,0) > 0
      cTitulo += ", " + STR0185 //"com emissão em até ### dias."
      cTitulo:= StrTran(cTitulo, "###", AllTrim(Str(EasyGParam("MV_EEC0050"))))
      If lFiltNcm
         cTitulo += " "
      EndIf
   EndIf

   If lFiltNcm
      cTitulo += STR0186 //"Filtro por N.C.M. "
   EndIf

   /* Carrega em memória os registros da parte superior. */
   aEnchoice:= {"EYY_COD_I"}
   //LRS - 11/07/2018
   IF WK_NFRem->(FieldPos("EYY_VM_DES")) > 0
      AADD(aEnchoice,{"EYY_VM_DES"})
      M->EYY_VM_DES:= WK_NFRem->EYY_VM_DES
   EndIF

   M->EYY_COD_I := WK_NFRem->EYY_COD_I

   If lFimEspecNew
      aAdd(aEnchoice, "EYY_UNIDAD")
      M->EYY_UNIDAD:= WK_NFRem->EYY_UNIDAD
   EndIf

   If lFiltNcm
      AAdd(aEnchoice, "EYY_POSIPI")
      M->EYY_POSIPI:= WK_NFRem->EYY_POSIPI
   EndIf

   /* Campos que serão exibidos na parte inferior */
   aCampos:= {"D1_DOC", "D1_SERIE", "D1_EMISSAO", "D1_FORNECE", "D1_LOJA", "D1_ITEM", "D1_TES", "D1_CF", "D1_SLDEXP", "D1_QUANT", "D1_UM" ,"R_E_C_N_O_"}

   If lFimEspecNew
      aAdd(aCampos,"SLD_UM_CONV")
   EndIf

   If lFiltNcm
      aAdd(aCampos, NIL)
      aIns(aCampos, 6)
      aCampos[6] := "D1_COD"

      AAdd(aCampos, NIL)
      AIns(aCampos, 7)
      aCampos[7]:= "B1_DESC"
   EndIf

   /* Campos usados na pesquisa */
   AAdd(aSeek, {AvSx3("D1_DOC", AV_TITULO)    , {{"", AvSx3("D1_DOC", AV_TIPO)    , AvSx3("D1_DOC", AV_TAMANHO)    , AvSx3("D1_DOC", AV_DECIMAL)    , AvSx3("D1_DOC"    , AV_TITULO)}}})
   AAdd(aSeek, {AvSx3("D1_FORNECE", AV_TITULO), {{"", AvSx3("D1_FORNECE", AV_TIPO), AvSx3("D1_FORNECE", AV_TAMANHO), AvSx3("D1_FORNECE", AV_DECIMAL), AvSx3("D1_FORNECE", AV_TITULO)}}})


   /* Campos usados no filtro */
   AAdd(aFilter, {AvSx3("D1_DOC", AV_TITULO)    , AvSx3("D1_DOC", AV_TITULO)    , AvSx3("D1_DOC", AV_TIPO)    , AvSx3("D1_DOC", AV_TAMANHO)    , AvSx3("D1_DOC", AV_DECIMAL), ""})
   AAdd(aFilter, {AvSx3("D1_SERIE", AV_TITULO)  , AvSx3("D1_SERIE", AV_TITULO)  , AvSx3("D1_SERIE", AV_TIPO)  , AvSx3("D1_SERIE", AV_TAMANHO)  , AvSx3("D1_SERIE", AV_DECIMAL), ""})
   AAdd(aFilter, {AvSx3("D1_EMISSAO", AV_TITULO), AvSx3("D1_EMISSAO", AV_TITULO), AvSx3("D1_EMISSAO", AV_TIPO), AvSx3("D1_EMISSAO", AV_TAMANHO), AvSx3("D1_EMISSAO", AV_DECIMAL), ""})
   AAdd(aFilter, {AvSx3("D1_FORNECE", AV_TITULO), AvSx3("D1_FORNECE", AV_TITULO), AvSx3("D1_FORNECE", AV_TIPO), AvSx3("D1_FORNECE", AV_TAMANHO), AvSx3("D1_FORNECE", AV_DECIMAL), ""})
   AAdd(aFilter, {AvSx3("D1_LOJA", AV_TITULO)   , AvSx3("D1_LOJA", AV_TITULO)   , AvSx3("D1_LOJA", AV_TIPO)   , AvSx3("D1_LOJA", AV_TAMANHO)   , AvSx3("D1_LOJA", AV_DECIMAL), ""})
   AAdd(aFilter, {AvSx3("D1_TES", AV_TITULO)    , AvSx3("D1_TES", AV_TITULO)    , AvSx3("D1_TES", AV_TIPO)    , AvSx3("D1_TES", AV_TAMANHO)    , AvSx3("D1_TES", AV_DECIMAL), ""})
   AAdd(aFilter, {AvSx3("D1_CF", AV_TITULO )    , AvSx3("D1_CF", AV_TITULO)     , AvSx3("D1_CF", AV_TIPO)     , AvSx3("D1_CF", AV_TAMANHO)     , AvSx3("D1_CF", AV_DECIMAL), ""})

   /*If lFiltNcm // NCF - 08/07/2016 - Posicionar a Work IP para a query
      cChaveWkIp:= WK_NFRem->(EYY_SEQEMB + EYY_NFSAI + EYY_SERSAI)
      aOrdWkIp := SaveOrd("WorkIp")
      WorkIp->(DBSetOrder(2)) //EE9_SEQEMB + EE9_NF + EE9_SERIE
      WorkIp->(DBSeek(cChaveWkIp))
   EndIf*/

   If EasyEntryPoint("EECAE110")
      ExecBlock("EECAE110", .F., .F., "ADD_CAMPOS")
   EndIf

   /* Retorna os dados que serão exibidos na parte inferior. */
   aDados:= RetSD1(aCampos)

   /* Se não houver dados, redefine a ação do botão OK. */
   If Len(aDados) == 0
      bOk:= bCancel
   EndIf

   /*If lFiltNcm
      RestOrd(aOrdWkIp,.T.)
   EndIf*/
   
   For nCont := 1 to Len(aDados)
   	aadd(aDados[nCont],.F.)
   Next
   
   Define MsDialog oDlg Title STR0184 From DLG_LIN_INI, DLG_COL_INI To DLG_LIN_FIM * 0.9, DLG_COL_FIM * 0.9 Of oMainWnd Pixel //"Notas fiscais de entrada"

      /* Parte superior */
      lBkpAlt := ALTERA
      lBkpInc := INCLUI

      oMsMget:= MsmGet():New("EYY",, 2,,,, aEnchoice, {0, 0,nAlTela, 0}, {},,,,, oDlg,.T.,.T.,,, .T.)

      ALTERA := lBkpAlt
      INCLUI := lBkpInc

      oMsMget:oBox:Align:= CONTROL_ALIGN_TOP

      /* Parte inferior */
      oBrowse:= FWBrowse():New(oDlg)

         oBrowse:SetDataArray()
         oBrowse:SetArray(aDados)
         oBrowse:SetDescription(cTitulo)

         oBrowse:AddMarkColumns({||If(aDados[oBrowse:nAt][len(aDados[oBrowse:nAt])],'LBOK','LBNO')},{|oBrowse|If(aDados[oBrowse:nAt][len(aDados[oBrowse:nAt])],aDados[oBrowse:nAt][len(aDados[oBrowse:nAt])]:=.F.,aDados[oBrowse:nAt][len(aDados[oBrowse:nAt])]:=.T.)},)
         
         For nCont:= 1 To Len(aCampos)
            If aCampos[nCont] <> "R_E_C_N_O_"
               If lFimEspecNew .And. aCampos[nCont] == "SLD_UM_CONV"                             //"Saldo Conv.Unid.Embarque"
                  Add COLUMN oColumn Data &("{|| aDados[oBrowse:nAt][" + Str(nCont) + "]}") Title STR0190 Size AvSx3("D1_QUANT", AV_TAMANHO) Picture AvSx3("D1_QUANT", AV_PICTURE) Of oBrowse
               ElseIf lFimEspecNew .And. aCampos[nCont] == "D1_QUANT"                            //"Saldo Qtde. da Nota Fiscal"
                  Add COLUMN oColumn Data &("{|| aDados[oBrowse:nAt][" + Str(nCont) + "]}") Title STR0191 Size AvSx3(aCampos[nCont], AV_TAMANHO) Picture AvSx3(aCampos[nCont], AV_PICTURE) Of oBrowse
               ElseIf lFimEspecNew .And. aCampos[nCont] == "D1_SLDEXP"                           //"Saldo Disp.Export.(Unid.Med.da NF)"
                  Add COLUMN oColumn Data &("{|| aDados[oBrowse:nAt][" + Str(nCont) + "]}") Title STR0192 Size AvSx3(aCampos[nCont], AV_TAMANHO) Picture AvSx3(aCampos[nCont], AV_PICTURE) Of oBrowse
               ElseIf lFimEspecNew .And. aCampos[nCont] == "D1_UM"                               //"Unidade de Medida da NF"
                  Add COLUMN oColumn Data &("{|| aDados[oBrowse:nAt][" + Str(nCont) + "]}") Title STR0193 Size AvSx3(aCampos[nCont], AV_TAMANHO) Picture AvSx3(aCampos[nCont], AV_PICTURE) Of oBrowse
               Else
                  Add COLUMN oColumn Data &("{|| aDados[oBrowse:nAt][" + Str(nCont) + "]}") Title AvSx3(aCampos[nCont], AV_TITULO) Size AvSx3(aCampos[nCont], AV_TAMANHO) Picture AvSx3(aCampos[nCont], AV_PICTURE) Of oBrowse
               EndIf
            EndIf
         Next
         
         /* Pesquisa */
         oBrowse:SetSeek(, aSeek)

         /* Filtro */
         oBrowse:SetUseFilter()
         oBrowse:SetFieldFilter(aFilter)

      oBrowse:Activate()

	Activate MsDialog oDlg On Init (EnchoiceBar(oDlg, bOk, bCancel,,,,,,,.F.))

End Sequence

/* Atualização do browse */
oGetNfRem:oBrowse:Refresh()
If nRecNoOrig <> WK_NFRem->(RecNo())
   nBrLin:= nRecNoOrig
   WK_NFRem->(DBGoTo(nRecNoOrig))
EndIf

Return lRet

/*
Função     : RetSD1()
Objetivo   : Listar as notas fiscais de entrada que podem ser usadas para vinculação ao processo de exportação
Parâmetros : aCampos - campos a serem considerados no retorno de dados
Retorno    : aDados - array as notas fiscais que podem ser exibidas
Autor      : WFS
Data       : jun/2016
Revisão    :
*/
Static Function RetSD1(aCampos)
Local cWhere:= "", cDelete:= "", cPrefixo:= ""
Local nCont, nPos
Local aDados:= {}, aReg:= {}
Local aArea:= GetArea()
Local nSldUsado
Local lFiltNcm := EasyGParam("MV_EEC0051",,.F.)
Local nPosCpoUMD, nPosCpoSld
Local lFimEspecNew := AvFlags("ROTINA_VINC_FIM_ESPECIFICO_RP12.1.20")
Local cUnidPara := ""

Private cQuery:= ""

Begin Sequence

   DBSelectArea("SD1")

   If TcSrvType() <> "AS/400"
      cDelete := " And D1.D_E_L_E_T_ <> '*'"
   EndIf

   cQuery:= "Select "
   For nCont:= 1 To Len(aCampos)

      If aCampos[nCont] == "SLD_UM_CONV"
         Loop
      EndIf

      If nCont > 1
         cQuery += ", "
      EndIf

      If aCampos[nCont] == "R_E_C_N_O_"
         cPrefixo:= "D1."
      ElseIf SubStr(aCampos[nCont], 1, 1) == "S"
         cPrefixo:= SubStr(aCampos[nCont], 1, 3) + "."
      Else
         cPrefixo:= SubStr(aCampos[nCont], 1, 2) + "."
      EndIf
      cQuery +=  cPrefixo + aCampos[nCont]
   Next

   cQuery += " From " + RetSqlName("SD1") + " D1"

   If lFiltNcm
      cQuery += " Inner Join " + RetSqlName("SB1") + " B1"                       //NCF - 08/07/2016 - Trazer Itens de NF por N.c.m
      cQuery += " On D1.D1_COD = B1.B1_COD"
   EndIf

   cWhere:= " Where D1.D1_FILIAL = '" + SD1->(xFilial()) + "' And D1.D1_SLDEXP <> 0"

   If lFiltNcm
      cWhere += " AND B1.B1_POSIPI = '" + WK_NFRem->EYY_POSIPI + "'"
   Else
      cWhere += " And D1.D1_COD = '" + WK_NFRem->EYY_COD_I + "'"
   EndIf

   If EasyGParam("MV_EEC0050",.T.)
      cWhere  += " And D1.D1_EMISSAO > '" + DtoS(dDataBase - EasyGParam("MV_EEC0050")) + "'"
   EndIf

   /* Montagem da Query */
   cQuery += cWhere + cDelete

   If EasyEntryPoint("EECAE110")
      ExecBlock("EECAE110", .F., .F., "MUDA_QUERY")
   EndIf

   cQuery:= ChangeQuery(cQuery)
   TcQuery cQuery Alias "SD1TMP" New

   For nCont:= 1 To Len(aCampos)
      If aCampos[nCont] <> "R_E_C_N_O_" .And. ( !lFimEspecNew .Or. !(aCampos[nCont] == "SLD_UM_CONV") )
         If AvSx3(aCampos[nCont], AV_TIPO) == "N"
            TcSetField("SD1TMP", aCampos[nCont], "N", AvSx3(aCampos[nCont], AV_TAMANHO), AvSx3(aCampos[nCont], AV_DECIMAL))
         ElseIf AvSx3(aCampos[nCont], AV_TIPO) == "C"
            TcSetField("SD1TMP", aCampos[nCont], "C", AvSx3(aCampos[nCont], AV_TAMANHO))
         ElseIf AvSx3(aCampos[nCont], AV_TIPO) == "D"
            TcSetField("SD1TMP", aCampos[nCont], "D")
         EndIf
      EndIf
   Next

   nPosCpoUMD := aScan(aCampos,"D1_UM")
   nPosCpoSld := aScan(aCampos,"D1_SLDEXP")

   /* Array com os registros a serem exibidos. */
   SD1TMP->(DBGoTop())
   While SD1TMP->(!Eof())

      /* Atualização do saldo.
         Serão abatidas as quantidades associadas ao processo em edição. */
      nSldUsado:= 0
      If (nPos:= AScan(aSaldoNFE, {|x| x[1] == SD1TMP->R_E_C_N_O_})) > 0
         nSldUsado:= aSaldoNFE[nPos][2]
      EndIf

      /* Se o saldo se mantiver superior a 0, será exibido */
      If (SD1TMP->D1_SLDEXP - nSldUsado) > 0
         aReg:= {}
         For nCont:= 1 To SD1TMP->(FCount())
            If SD1TMP->(FieldName(nCont)) <> "D1_SLDEXP"
               AAdd(aReg, SD1TMP->&(FieldName(nCont)))
            Else
               AAdd(aReg, SD1TMP->&(FieldName(nCont)) - nSldUsado)
            EndIf
         Next
         AAdd(aDados, AClone(aReg))
         If lFimEspecNew //NCF - 15/02/2017
            If Alltrim(aDados[Len(aDados)][nPosCpoUMD]) == "KG"
               cUnidPara := If(!Empty(WorkIP->EE9_UNPES), WorkIP->EE9_UNPES,If(!Empty(EEC->EEC_UNIDAD),EEC->EEC_UNIDAD,"KG"))
            Else
               cUnidPara := M->EYY_UNIDAD
            EndIf
            AAdd( aDados[Len(aDados)] , EasyConvQt( M->EYY_COD_I , GetEYYQtds( "Wk_NFRem" ,"ARRAY" , aDados[Len(aDados)][nPosCpoUMD] , aDados[Len(aDados)][nPosCpoUMD], aDados , aCampos , "2"  ) , cUnidPara ) )
         EndIf
      EndIf

      SD1TMP->(DBSkip())
   EndDo

   SD1TMP->(DBCloseArea())

End Sequence

RestArea(aArea)
Return AClone(aDados)

Static Function GetEYYQtds( cAliasEYY, cTpObj , cUnMedDE , cUnMedSD1, aDados, aCampos , cTipo  )
Local aRet
Local bGet := If(cTpObj <> "ARRAY", {|x,y,z| &( x+"->EYY_QUANT" ) } , {|x,y,z| y[Len(y)][aScan(z,"D1_SLDEXP")] }  )

If cTipo == "1"  // Conversao da qtde. na unidade do embarque para qtde. na unidade da nota
        //   Unidade DE[*]                                            Qtde. DE[*]
   aRet := { { cUnMedDE                                             , Eval(bGet, cAliasEYY ,aDados, aCampos)                                }, ;
             { If(!Empty(WorkIP->EE9_UNPES), WorkIP->EE9_UNPES,"KG"), ( Eval({|x| &( x+"->EYY_QUANT" ) }, cAliasEYY ) * WorkIP->EE9_PSLQUN) }  }
Else
   aRet := {{ cUnMedSD1 , Eval(bGet, cAliasEYY ,aDados, aCampos) }} //Conversão da Qtde. do item da NFe no array aDados para Qtde. do item no embarque
EndIf

Return aRet

Static Function ValOkF3(aCampos, aDados)

Local lRet := .T.
//NCF - 22/02/2017 - WFS 21/05/2010 - Validação do fornecedor informado
If (WorkIp->EE9_FABR + WorkIp->EE9_FALOJA) <> ( aDados[AScan(aCampos, "D1_FORNECE")] + aDados[AScan(aCampos, "D1_LOJA")] )
   If !MsgYesNo(STR0025,STR0001) //O fabricante desta nota fiscal não é o mesmo do item do processo. Deseja prosseguir?
      lRet := .F.
   EndIF
EndIf
//THTS - 05/03/2018 - Verifica se a nota de entrada possui Chave de Acesso F1_CHVNFE
If !EYYCHVNFE(xFilial("SF1"), aDados[AScan(aCampos, "D1_DOC")], aDados[AScan(aCampos, "D1_SERIE")], aDados[AScan(aCampos, "D1_FORNECE")], aDados[AScan(aCampos, "D1_LOJA")])
   lRet := .F.
EndIf

Return lRet

/*
Função     : EYYCHVNFE
Objetivo   : Retorna .T. quando existir a chave da nota (F1_CHVNFE) e .F. quando nao existir ou quando nao for possivel verificar (fatam informacoes)
Parâmetros :
Retorno    : .T. - Posicionou SF1 e existe F1_CHVNFE; .F. nao posicionou ou nao existe a informacao F1_CHVNFE
Autor      : THTS - Tiago Henrique Tudisco dos Santos
Data       : Marco/2018
*/
Static Function EYYCHVNFE(cFilialSF1,cDocSF1,cSerieSF1,cFornSF1,cLojaSF1,cChaveNFE)
Local lRet        := .T.
Local aAreaSF1    := SF1->(GetArea())

Default cChaveNFE := ""

If !Empty(cFilialSF1) .And. !Empty(cDocSF1) .And. !Empty(cSerieSF1) .And. !Empty(cFornSF1) .And. !Empty(cLojaSF1)
  SF1->(dbSetOrder(1))//F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO
  If !AvFlags("EEC_LOGIX") .And. SF1->(DbSeek(AvKey(cFilialSF1,"F1_FILIAL") + AvKey(cDocSF1,"F1_DOC") + AvKey(cSerieSF1,"F1_SERIE") + AvKey(cFornSF1,"F1_FORNECE") + AvKey(cLojaSF1,"F1_LOJA")))

    If Empty(SF1->F1_CHVNFE)
      MsgInfo("Esta nota fiscal não pode ser associada, pois não há chave de registro da Nota Fiscal na Sefaz. Efetue a transmissão para a Sefaz para efetuar a associação ao embarque.", STR0001) //"Esta nota fiscal não pode ser associada, pois não há chave de registro da Nota Fiscal na Sefaz. Efetue a transmissão para a Sefaz para efetuar a associação ao embarque." #### "Atenção"
      cChaveNFE := ""
      lRet := .F.
    Else
      cChaveNFE := SF1->F1_CHVNFE
    EndIf

  EndIf
EndIf

RestArea(aAreaSF1)
Return lRet

/*
Função     : GrvDados()
Objetivo   : Atualizar os dados da work WK_NFRem, controlar o saldo usado e
             posicionar a SD1 para retorno das demais informações
             - Deve controlar a inclusão/ exclusão da linha na work, de acordo com o  saldo
               vindo da tabela SD1
             - Deve controlar o saldo do item usado, para atualização da tabela SD1
             com o saldo que estiver vindo da
Parâmetros : aCampos - campos exibidos na consulta padrão
             aDados - array as informações da linha posicionada
Retorno    :
Autor      : WFS
Data       : jun/2016
Revisão    :
*/
Static Function GrvDados(aCampos, aDados)
Local lRet:= .T.
Local nPos:= 0
Local nRecNoSD1
Local nQuantidade, nQtdeUMEmb , nQtdeUMNFe
Local lFimEspecNew := AvFlags("ROTINA_VINC_FIM_ESPECIFICO_RP12.1.20")
Local cUMPesItEmb, cUMNFeIt, nQtdeBxSD1

Begin Sequence

   If Len(aDados) == 0
      Break
   EndIf

   nRecNoSD1:= aDados[AScan(aCampos, "R_E_C_N_O_")]

   cUMPesItEmb := Alltrim( If(!Empty(WorkIP->EE9_UNPES), WorkIP->EE9_UNPES,If(!Empty(EEC->EEC_UNIDAD),EEC->EEC_UNIDAD,"KG")) )
   cUMNFeIt    := Alltrim( aDados[AScan(aCampos, "D1_UM") ] )
   nQtdeBxSD1  := WK_NFRem->EYY_QUANT

   If cUMNFeIt == "KG"
      If cUMPesItEmb <> cUMNFeIt
         nQtdeBxSD1 := EasyConvQt(WorkIP->EE9_COD_I,{{cUMPesItEmb, WK_NFRem->EYY_QUANT * WorkIP->EE9_PSLQUN }},cUMNFeIt,.F.,)
      Else
         nQtdeBxSD1 := WK_NFRem->EYY_QUANT * WorkIP->EE9_PSLQUN
      EndIf
   EndIf

   /* Verifica se o item em edição possui associação à uma nota de entrada
      Se houver, o saldo deve ser abatido, para associação da outra nota informada. */
   SaldoTmpSD1(WK_NFRem->SD1_RECNO, nQtdeBxSD1 /*WK_NFRem->EYY_QUANT*/, SUBTRAIR)

   /* Se a quantidade da nota de entrada for superior a quantidade do item na WK_NFRem,
      assume-se a quantidade da work. Se a quantidade for inferior, ela será assumida e
      deve ser criada uma linha com o residual na work. */
   nQtdeUMEmb := aDados[AScan(aCampos, If( lFimEspecNew , "SLD_UM_CONV" , "D1_SLDEXP" ) )]
   nQtdeUMNFe := aDados[AScan(aCampos, "D1_SLDEXP"   )]

   If nQtdeUMEmb >= WK_NFRem->EYY_QUANT
      nQtdeUMEmb := WK_NFRem->EYY_QUANT
   Else
      AtuWK_NFRem(nQtdeUMEmb, WK_NFRem->EYY_QUANT)
   EndIf

   /* Verifica se o recno da nota de entrada já consta na relação de notas associadas, para
      atualização do saldo consumido */
   SaldoTmpSD1(nRecNoSD1, If( cUMNFeIt <> "KG", nQtdeUMNFe, nQtdeBxSD1 ) , SOMAR)

   /* Posiciona do registro da SD1 para retorno da consulta padrão */
   SD1->(DBGoTo(nRecNoSD1))

   /* Atualiza os valores da WK_NFRem */
   WK_NFRem->(RecLock("WK_NFRem", .F.))

   WK_NFRem->EYY_QUANT := nQtdeUMEmb
   WK_NFRem->SD1_RECNO := nRecNoSD1
   If lFimEspecNew
      Wk_NfRem->EYY_UMDSD1:= SD1->D1_UM
   EndIf
   WK_NFRem->EYY_D1ITEM:= SD1->D1_ITEM
   If EasyGParam("MV_EEC0051",, .F.) .Or. WK_NFRem->(FieldPos("EYY_D1PROD")) > 0 //Manter a gravação do campo, para histórico. Quando o parâmetro estiver desabilitado esta informação será a mesma do campo EYY_COD_I
      WK_NFRem->EYY_D1PROD:= SD1->D1_COD      //NCF - 14/07/2016
   EndIf
   WK_NFRem->EYY_NFENT := SD1->D1_DOC
   WK_NFRem->EYY_SERENT:= SD1->D1_SERIE
   WK_NFRem->EYY_FORN  := SD1->D1_FORNECE
   WK_NFRem->EYY_FOLOJA:= SD1->D1_LOJA

   WK_NFRem->(MsUnlock())

End Sequence

Return lRet

/*
Função     : SaldoTmpSD1()
Objetivo   : Atualizar o array aSaldoNFE com os dados em edição da tabela SD1
Parâmetros : - Quantidade consumida do item da nota de entrada
             - RecNo do registro da tabela SD1
             - nOperacao: SOMAR = 1; SUBTRAIR = 2
Retorno    :
Autor      : WFS
Data       : jun/2016
Revisão    :
*/
Static Function SaldoTmpSD1(nRecNoSD1, nQuantidade, nOperacao)
Local nPos
Default nQuantidade:= 0
Default nRecNoSD1:= 0
Default nOperacao:= SOMAR

Begin Sequence

   If nRecNoSD1 == 0
      Break
   EndIf

   /* agrega no recno da SD1 ou adiciona no array de controle */
   If nOperacao == SOMAR
      nPos:= AScan(aSaldoNFE, {|x| x[1] == nRecNoSD1})
      If nPos > 0
         aSaldoNFE[nPos][2] += nQuantidade
      Else
         AAdd(aSaldoNFE, {nRecNoSD1, nQuantidade})
      EndIf
   EndIf

   /* abate a quantidade substituida ou deletada da work */
   If nOperacao == SUBTRAIR
      nPos:= AScan(aSaldoNFE, {|x| x[1] == nRecNoSD1})
      If nPos > 0
         aSaldoNFE[nPos][2] -= nQuantidade
      EndIf
   EndIf

End Sequence
Return

Static Function fGrava()

Local lRet := .F.
Local nCont

For nCont := 1 to Len(aDados)
	if aDados[nCont][len(aDados[nCont])]
		If ValOkF3(aCampos, aDados[nCont])
			WK_NFRem->(dbGoTop())
			While !WK_NFRem->(EOF())
				if Empty(WK_NFRem->EYY_NFENT)
					GrvDados(aCampos, aDados[nCont])
					lRet := .T.
					exit
				endif
				WK_NFRem->(dbSkip())
			end
		endif
	endif
Next

Return lRet

/*
Função     : AtuWK_NFRem()
Objetivo   : Atualizar a work WK_NFRem.
             - Quando a quantidade informada for menor que a quantidade "disponível" da WorkIP,
               incluir uma linha nova com o saldo residual para vinculação da nota de entrada
             - Caso seja alterada a nota de entrada e a quantidade de algum registro, deve verificar
               se existe linha sem nota fiscal de entrada associada e atualizar o saldo
             - Caso o saldo fique 0 (zero), excluir a linha da work
Parâmetros : Quantidade digitada pelo usuário
             Saldo residual atual
Retorno    :
Autor      : WFS
Data       : jun/2016
Revisão    :
*/
Static Function AtuWK_NFRem(nQtdInformada, nSaldoAtual)
Local aOrd:= SaveOrd({"WK_NFRem", "WorkIp"})
Local cChave
Local lTemRegistro
Local nNovoSldResidual
Local nRecNoAtual

Begin Sequence

   /* Dados do registro em edição */
   cChave:= WK_NFRem->(EYY_SEQEMB + EYY_NFSAI + EYY_SERSAI)
   nRecNoAtual:= WK_NFRem->(RecNo())
   WK_NFRem->(DBSetOrder(1)) //EYY_SEQEMB + EYY_NFSAI + EYY_SERSAI

   /* A WorkIp deve estar posicionada para atualização da WK_NFRem */
   WorkIp->(DBSetOrder(2)) //EE9_SEQEMB + EE9_NF + EE9_SERIE
   WorkIp->(DBSeek(cChave))

   lTemRegistro:= .F.
   While WK_NFRem->(!Eof()) .And. WK_NFRem->(EYY_SEQEMB + EYY_NFSAI + EYY_SERSAI) == cChave

      /* se não possui possuir nota fiscal associada, atualizar a quantidade ou excluir o registro */
      If Empty(WK_NFRem->EYY_NFENT) .And. WK_NFRem->(RecNo()) <> nRecNoAtual
         lTemRegistro:= .T.
         Exit
      EndIf
      WK_NFRem->(DBSkip())
   EndDo

   /* Se tiver registro, reapura o saldo considerando os novos valores informados */
   If lTemRegistro
      nNovoSldResidual:= WK_NFRem->EYY_QUANT + (nSaldoAtual - nQtdInformada)
   EndIf

   /* Se a quantidade informada for menor que o saldo residual, verificar se será necessário incluir ou alterar uma linha
      que não possui vinculação com uma nota fiscal de entrada. */
   If nQtdInformada < nSaldoAtual

      If lTemRegistro
         /* Atualização da quantidade */
         GravaWk_NfRem(ALTERAR, nNovoSldResidual)
      Else
         /* Cria uma nova linha em brando, com o saldo residual para vinculação do documento de entrada. */
         GravaWk_NfRem(INCLUIR, nSaldoAtual - nQtdInformada)
      EndIf
   EndIf

   /* Se a quantidade informada for maior que o saldo residual, verificar se a linha que não possui vinculação
      com a nota de entrada permanecerá com saldo.
      Caso o saldo residual seja 0 (zero), a linha deve ser excluída */
   If nQtdInformada > nSaldoAtual

      If !lTemRegistro //neste cenário, não faz sentido não ter registro! Deve ser bloqueado na validação da quantidade informada
         MsgAlert(STR0187, STR0001) //"A quantidade informada é superior que o saldo residual/ quantidade do item no embarque. Problema de vinculação", "Atenção"
         Break
      EndIf

      If nNovoSldResidual > 0
         /* Atualização da linha atual */
         GravaWk_NfRem(ALTERAR, nNovoSldResidual)
      Else
         GravaWk_NfRem(EXCLUIR)
      EndIf
   EndIf

End Sequence

RestOrd(aOrd, .T.)

Return

/*
Função     : GravaWk_NfRem(nOpc, nQuantidade)
Objetivo   : Inclusão/ atualização dos dados na work
Parâmetros : nOpc
             3 = INCLUIR
             4 = ALTERAR
             5 = EXCLUIR
             nQuantidade - saldo do item para vinculação da nota fiscal de entrada
Retorno    :
Autor      : WFS
Data       : jun/2016
Revisão    :
Observação : A WorkIp deve estar posicionada
*/
Static Function GravaWk_NfRem(nOpc, nQuantidade)
Local lFiltNcm := EasyGParam("MV_EEC0051",,.F.)
Local lFimEspecNew := AvFlags("ROTINA_VINC_FIM_ESPECIFICO_RP12.1.20")

Begin Sequence


   //fase embarque
   Do Case
      Case nOpc == INCLUIR .Or. nOpc == ALTERAR

         Wk_NfRem->(RecLock("Wk_NfRem", nOpc == INCLUIR))

         WK_NFRem->EYY_PREEMB:= WorkIp->EE9_PREEMB
         WK_NFRem->EYY_SEQEMB:= WorkIp->EE9_SEQEMB
         WK_NFRem->EYY_PEDIDO:= WorkIp->EE9_PEDIDO
         WK_NFRem->EYY_SEQUEN:= WorkIp->EE9_SEQUEN
         WK_NFRem->EYY_COD_I := WorkIp->EE9_COD_I
         WK_NFRem->EYY_VM_DES:= /*MemoLine(*/WorkIP->EE9_VM_DES/*, 60, 1)*/
         WK_NFRem->EYY_NFSAI := WorkIp->EE9_NF
         WK_NFRem->EYY_SERSAI:= WorkIp->EE9_SERIE
         WK_NFRem->EYY_RE    := WorkIp->EE9_RE
         Wk_NfRem->EYY_QUANT := nQuantidade
         If lFiltNcm
            WK_NFRem->EYY_POSIPI:= WorkIp->EE9_POSIPI
         EndIf
         If lFimEspecNew
            WK_NFRem->EYY_UNIDAD := WorkIp->EE9_UNIDAD
         EndIf
         Wk_NfRem->(MsUnlock())

      Case nOpc == EXCLUIR
         Wk_NfRem->(RecLock("Wk_NfRem", .F.))
         Wk_NfRem->(DBDelete())
         Wk_NfRem->(MsUnlock())

   End Case
End Sequence

Return
