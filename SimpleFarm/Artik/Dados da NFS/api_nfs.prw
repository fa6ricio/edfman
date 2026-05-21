#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include 'TopConn.ch'

/* ========================================================================== */
/* API DE DOCUMENTOS DE SAÍDA (INTEGRAÇÃO COM PEDIDO DE VENDA SC5)           */
/* ========================================================================== */

WSRESTFUL WSAPIINT DESCRIPTION "API de Documentos de Saida"

    WSDATA Page     AS INTEGER OPTIONAL
    WSDATA PageSize AS INTEGER OPTIONAL

    WSMETHOD GET DESCRIPTION "Lista notas fiscais baseada em regras do Pedido" WSSYNTAX "/v1/outbound-docs"
    WSMETHOD PUT DESCRIPTION "Atualiza integracao no Pedido de Venda" WSSYNTAX "/v1/outbound-docs"

END WSRESTFUL

/* -------------------------------------------------------------------------- */
/* GET: Busca notas filtrando pelo status do Pedido de Venda (SC5)            */
/* -------------------------------------------------------------------------- */
WSMETHOD GET WSRESTFUL WSAPIINT
    Local oJsonResp   := JsonObject():New()
    Local aDocs       := {}
    Local cQuery      := ""
    Local cAliasIds   := GetNextAlias()
    Local cAliasMain  := GetNextAlias()
    
    // Controle de Paginação
    Local nPPage      := IIf(Self:Page == 0, 1, Self:Page)
    Local nPSize      := IIf(Self:PageSize == 0, 50, Self:PageSize)
    Local nStart      := (nPPage - 1) * nPSize
    Local cListaRecs  := ""
    Local nCount      := 0
    
    // Variáveis de Controle de Quebra
    Local cKeyAtual   := ""
    Local cKeyAnt     := ""
    Local oJsonNf     := Nil
    Local oItem       := Nil
    Local aItens      := {}

    Self:SetContentType("application/json")

    // ----------------------------------------------------------------------
    // 1. PAGINAÇÃO: Busca apenas os IDs
    // ----------------------------------------------------------------------
    cQuery := " SELECT SF2.R_E_C_N_O_ AS REC_SF2 "
    cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
    cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' "
    cQuery += " AND SF2.F2_ESPECIE = 'SPED' "
    cQuery += " AND SF2.F2_CHVNFE <> '' "
    
    // Filtro de Negócio (SC5 via SD2)
    cQuery += " AND EXISTS ( "
    cQuery += "     SELECT 1 FROM " + RetSqlName("SD2") + " SD2 "
    cQuery += "     INNER JOIN " + RetSqlName("SC5") + " SC5 "
    cQuery += "         ON SC5.D_E_L_E_T_ = ' ' "
    cQuery += "         AND SC5.C5_FILIAL = SD2.D2_FILIAL "
    cQuery += "         AND SC5.C5_NUM    = SD2.D2_PEDIDO "
    cQuery += "     WHERE SD2.D_E_L_E_T_ = ' ' "
    cQuery += "         AND SD2.D2_FILIAL = SF2.F2_FILIAL "
    cQuery += "         AND SD2.D2_DOC    = SF2.F2_DOC "
    cQuery += "         AND SD2.D2_SERIE  = SF2.F2_SERIE "
    cQuery += "         AND SC5.C5_XINTSIM = 'S' " 
    cQuery += "         AND (SC5.C5_XDTINT = '' OR SC5.C5_XDTINT IS NULL) "
    cQuery += " ) "
    
    cQuery += " ORDER BY SF2.F2_EMISSAO, SF2.F2_DOC "
    
    MPSysOpenQuery(ChangeQuery(cQuery), cAliasIds)

    // Paginação
    While (cAliasIds)->(!Eof()) .And. nCount < nStart
        (cAliasIds)->(DbSkip())
        nCount++
    EndDo

    nCount := 0
    While (cAliasIds)->(!Eof()) .And. nCount < nPSize
        cListaRecs += cValToChar((cAliasIds)->REC_SF2) + ","
        nCount++
        (cAliasIds)->(DbSkip())
    EndDo
    (cAliasIds)->(DbCloseArea())

    If Empty(cListaRecs)
        oJsonResp['data'] := {}
        Self:SetResponse(oJsonResp:ToJson())
        Return .T.
    EndIf
    cListaRecs := SubStr(cListaRecs, 1, Len(cListaRecs)-1)

    // ----------------------------------------------------------------------
    // 2. QUERY PRINCIPAL 
    // ----------------------------------------------------------------------
    cQuery := " SELECT "
    // SF2 (Capa Nota)
    cQuery += " SF2.F2_FILIAL, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_EMISSAO, SF2.F2_HORA, "
    cQuery += " SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_COND, SF2.F2_MOEDA, SF2.F2_TIPO, "
    cQuery += " SF2.F2_CHVNFE, SF2.F2_VALMERC, SF2.F2_VALBRUT, "
    
    // SC5 (Dados Logísticos e Retirada)
    cQuery += " SC5.C5_PBRUTO, SC5.C5_PESOL, SC5.C5_VOLUME1, SC5.C5_ESPECI1, "
    cQuery += " SC5.C5_TRANSP, SC5.C5_CLIRET, SC5.C5_LOJARET, " 
    
    // SA4 (Transportadora do Pedido)
    cQuery += " SA4.A4_NOME, SA4.A4_CGC, SA4.A4_INSCRM, SA4.A4_END, SA4.A4_MUN, SA4.A4_EST, "
    
    // SA1 (Cliente/Entrega - Via Nota Fiscal)
    cQuery += " SA1.A1_NOME, SA1.A1_CGC, SA1.A1_INSCR, SA1.A1_END, SA1.A1_BAIRRO, "
    cQuery += " SA1.A1_CEP, SA1.A1_MUN, SA1.A1_EST, SA1.A1_TEL, "

    // SA1RET (Dados do Local de Retirada - Join com C5_CLIRET)
    cQuery += " SA1RET.A1_NOME AS RET_NOME, SA1RET.A1_CGC AS RET_CGC, SA1RET.A1_INSCR AS RET_IE, "
    cQuery += " SA1RET.A1_END AS RET_END, SA1RET.A1_BAIRRO AS RET_BAIRRO, SA1RET.A1_CEP AS RET_CEP, "
    cQuery += " SA1RET.A1_MUN AS RET_MUN, SA1RET.A1_EST AS RET_UF, SA1RET.A1_TEL AS RET_TEL, "
    
    // SD2 (Itens)
    cQuery += " SD2.D2_ITEM, SD2.D2_COD, SD2.D2_UM, SD2.D2_QUANT, SD2.D2_PRCVEN, "
    cQuery += " SD2.D2_TOTAL, SD2.D2_LOCAL, SD2.D2_TES, SD2.D2_LOTECTL "
    
    cQuery += " FROM " + RetSqlName("SF2") + " SF2 "
    
    // Join SD2
    cQuery += " INNER JOIN " + RetSqlName("SD2") + " SD2 "
    cQuery += "    ON SD2.D_E_L_E_T_ = ' ' "
    cQuery += "    AND SD2.D2_FILIAL = SF2.F2_FILIAL "
    cQuery += "    AND SD2.D2_DOC    = SF2.F2_DOC "
    cQuery += "    AND SD2.D2_SERIE  = SF2.F2_SERIE "
    
    // Join SC5 (Pedido)
    cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 "
    cQuery += "    ON SC5.D_E_L_E_T_ = ' ' "
    cQuery += "    AND SC5.C5_FILIAL = SD2.D2_FILIAL "
    cQuery += "    AND SC5.C5_NUM    = SD2.D2_PEDIDO "

    // Join SA4 (Transportadora do Pedido)
    cQuery += " LEFT JOIN " + RetSqlName("SA4") + " SA4 "
    cQuery += "    ON SA4.D_E_L_E_T_ = ' ' "
    cQuery += "    AND SA4.A4_FILIAL = '" + xFilial("SA4") + "' "
    cQuery += "    AND SA4.A4_COD    = SC5.C5_TRANSP " 
    
    // Join SA1 (Cliente da Nota - Para Endereço de Entrega)
    cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
    cQuery += "    ON SA1.D_E_L_E_T_ = ' ' "
    cQuery += "    AND SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
    cQuery += "    AND SA1.A1_COD    = SF2.F2_CLIENTE "
    cQuery += "    AND SA1.A1_LOJA   = SF2.F2_LOJA "

    // Join SA1RET (Local de Retirada)
    cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1RET "
    cQuery += "    ON SA1RET.D_E_L_E_T_ = ' ' "
    cQuery += "    AND SA1RET.A1_FILIAL = '" + xFilial("SA1") + "' "
    cQuery += "    AND SA1RET.A1_COD    = SC5.C5_CLIRET "
    cQuery += "    AND SA1RET.A1_LOJA   = SC5.C5_LOJARET "
    
    cQuery += " WHERE SF2.R_E_C_N_O_ IN (" + cListaRecs + ") "
    cQuery += " ORDER BY SF2.F2_DOC, SF2.F2_SERIE, SD2.D2_ITEM "

    MPSysOpenQuery(ChangeQuery(cQuery), cAliasMain)

    // ----------------------------------------------------------------------
    // 3. MONTAGEM DO JSON
    // ----------------------------------------------------------------------
    While (cAliasMain)->(!Eof())
        
        cKeyAtual := (cAliasMain)->F2_DOC + (cAliasMain)->F2_SERIE
        
        If cKeyAtual != cKeyAnt
            If oJsonNf != Nil
                oJsonNf['itens'] := aItens
                AAdd(aDocs, oJsonNf)
            EndIf
            
            oJsonNf := JsonObject():New()
            aItens  := {}
            cKeyAnt := cKeyAtual
            
            // --- Cabeçalho ---
            oJsonNf['filial']      := AllTrim((cAliasMain)->F2_FILIAL)
            oJsonNf['dtEmissao']   := DateToISO((cAliasMain)->F2_EMISSAO, (cAliasMain)->F2_HORA)
            oJsonNf['tipo']        := AllTrim((cAliasMain)->F2_TIPO)
            oJsonNf['codCli']      := AllTrim((cAliasMain)->F2_CLIENTE)
            oJsonNf['loja']        := AllTrim((cAliasMain)->F2_LOJA)
            oJsonNf['tipoCli']     := "F" 
            oJsonNf['condPag']     := AllTrim((cAliasMain)->F2_COND)
            oJsonNf['moeda']       := Iif((cAliasMain)->F2_MOEDA == 1, "BRL", "USD")

            oJsonNf['chaveAcesso'] := AllTrim((cAliasMain)->F2_CHVNFE)
            oJsonNf['numeroNf']    := AllTrim((cAliasMain)->F2_DOC)
            oJsonNf['serieNf']     := AllTrim((cAliasMain)->F2_SERIE)
            oJsonNf['naturezaOperacao'] := "" 
            oJsonNf['protocoloAutorizacao'] := "" 

            oJsonNf['valorTotalProdutos'] := (cAliasMain)->F2_VALMERC
            oJsonNf['valorTotalNota']     := (cAliasMain)->F2_VALBRUT
            
            // --- Dados do Pedido (SC5) ---
            oJsonNf['pesoBrutoTotal']     := (cAliasMain)->C5_PBRUTO
            oJsonNf['pesoLiquidoTotal']   := (cAliasMain)->C5_PESOL
            
            oJsonNf['fretePorConta'] := "" 
            oJsonNf['codigoAntt']    := "" 
            oJsonNf['placaVeiculo']  := "" 
            oJsonNf['ufPlaca']       := "" 

            // Transportadora
            oJsonNf['transportadoraNome']      := AllTrim((cAliasMain)->A4_NOME)
            oJsonNf['transportadoraCnpjCpf']   := AllTrim((cAliasMain)->A4_CGC)
            oJsonNf['transportadoraIe']        := AllTrim((cAliasMain)->A4_INSCRM)
            oJsonNf['transportadoraEndereco']  := AllTrim((cAliasMain)->A4_END)
            oJsonNf['transportadoraMunicipio'] := AllTrim((cAliasMain)->A4_MUN)
            oJsonNf['transportadoraUf']        := AllTrim((cAliasMain)->A4_EST)
            
            // LOCAL DE ENTRADA (Entrega) - Usa dados do SA1 (Cliente da Nota)
            oJsonNf['entregaNome']      := AllTrim((cAliasMain)->A1_NOME)
            oJsonNf['entregaCnpjCpf']   := AllTrim((cAliasMain)->A1_CGC)
            oJsonNf['entregaIe']        := AllTrim((cAliasMain)->A1_INSCR)
            oJsonNf['entregaEndereco']  := AllTrim((cAliasMain)->A1_END)
            oJsonNf['entregaBairro']    := AllTrim((cAliasMain)->A1_BAIRRO)
            oJsonNf['entregaCep']       := AllTrim((cAliasMain)->A1_CEP)
            oJsonNf['entregaMunicipio'] := AllTrim((cAliasMain)->A1_MUN)
            oJsonNf['entregaUf']        := AllTrim((cAliasMain)->A1_EST)
            oJsonNf['entregaFone']      := AllTrim((cAliasMain)->A1_TEL)

            // Volumes e Espécie (SC5)
            oJsonNf['volumesQuantidade'] := (cAliasMain)->C5_VOLUME1
            oJsonNf['volumesEspecie']    := AllTrim((cAliasMain)->C5_ESPECI1)
            oJsonNf['volumesMarca']      := ""
            oJsonNf['volumesNumeracao']  := ""

            // LOCAL DE RETIRADA (C5_CLIRET + C5_LOJARET via Join SA1RET)
            If !Empty((cAliasMain)->C5_CLIRET)
                oJsonNf['retiradaNome']      := AllTrim((cAliasMain)->RET_NOME)
                oJsonNf['retiradaCnpjCpf']   := AllTrim((cAliasMain)->RET_CGC)
                oJsonNf['retiradaIe']        := AllTrim((cAliasMain)->RET_IE)
                oJsonNf['retiradaEndereco']  := AllTrim((cAliasMain)->RET_END)
                oJsonNf['retiradaBairro']    := AllTrim((cAliasMain)->RET_BAIRRO)
                oJsonNf['retiradaCep']       := AllTrim((cAliasMain)->RET_CEP)
                oJsonNf['retiradaMunicipio'] := AllTrim((cAliasMain)->RET_MUN)
                oJsonNf['retiradaUf']        := AllTrim((cAliasMain)->RET_UF)
                oJsonNf['retiradaFone']      := AllTrim((cAliasMain)->RET_TEL)
            Else
                oJsonNf['retiradaNome']      := ""
                oJsonNf['retiradaCnpjCpf']   := ""
                oJsonNf['retiradaIe']        := ""
                oJsonNf['retiradaEndereco']  := ""
                oJsonNf['retiradaBairro']    := ""
                oJsonNf['retiradaCep']       := ""
                oJsonNf['retiradaMunicipio'] := ""
                oJsonNf['retiradaUf']        := ""
                oJsonNf['retiradaFone']      := ""
            EndIf
        EndIf

        // --- Itens ---
        oItem := JsonObject():New()
        oItem['codProduto']  := AllTrim((cAliasMain)->D2_COD)
        oItem['unMedida']    := AllTrim((cAliasMain)->D2_UM)
        oItem['qtd']         := (cAliasMain)->D2_QUANT
        oItem['precoUn']     := (cAliasMain)->D2_PRCVEN
        oItem['total']       := (cAliasMain)->D2_TOTAL
        oItem['codLoc']      := AllTrim((cAliasMain)->D2_LOCAL)
        oItem['tipoSaida']   := AllTrim((cAliasMain)->D2_TES)
        oItem['lote']        := AllTrim((cAliasMain)->D2_LOTECTL)
        oItem['romaneio']    := ""
        
        oItem['pesoLiquido'] := AllTrim((cAliasMain)->C5_PESOL)
        oItem['pesoBruto']   := AllTrim((cAliasMain)->C5_PBRUTO)
        oItem['qtdFardos']   := AllTrim((cAliasMain)->C5_VOLUME1)
        oItem['especie']     := AllTrim((cAliasMain)->C5_ESPECI1)
        
        AAdd(aItens, oItem)

        (cAliasMain)->(DbSkip())
    EndDo
    
    If oJsonNf != Nil
        oJsonNf['itens'] := aItens
        AAdd(aDocs, oJsonNf)
    EndIf

    (cAliasMain)->(DbCloseArea())

    oJsonResp['data'] := aDocs
    Self:SetResponse(oJsonResp:ToJson())

Return .T.

/* -------------------------------------------------------------------------- */

/* PUT: Atualiza Pedido de Venda (SC5) vinculado à Nota                       */

/* -------------------------------------------------------------------------- */

WSMETHOD PUT WSRESTFUL WSAPIINT
    Local cBody     := Self:GetContent()
    Local oJsonBody := JsonObject():New()
    Local oJsonResp := JsonObject():New()
    Local aFil   := ""
    Local cDoc      := ""
    Local cSerie    := ""
    Local cQuery    := ""
    Local cAliasPed := ""
    Local lEncontrou:= .F.
    Local cPedido   := ""
    Local cFilialPed:= ""
    // Variáveis para garantir formatação correta no SQL
    Local cDocSQL   := ""
    Local cSerieSQL := ""

    Self:SetContentType("application/json")

    If oJsonBody:FromJson(cBody) != NIL
        Self:SetStatus(400)
        Self:SetResponse('{"error": "JSON invalido"}')
        Return .F.
    EndIf
 // Validação de Payload
    If !oJsonBody:HasProperty("branch") .Or. !oJsonBody:HasProperty("doc_number") .Or. !oJsonBody:HasProperty("series")
        Self:SetStatus(400)
        Self:SetResponse('{"error": "Campos obrigatorios: branch, doc_number, series"}')
        Return .F.
    EndIf
    aFil := oJsonBody['branch']
    cDoc    := oJsonBody['doc_number']
    cSerie  := oJsonBody['series']
    cDocSQL   := PadL(AllTrim(cDoc), 9, "0")
    cSerieSQL := PadR(AllTrim(cSerie), 3)
    ConOut("API_PUT_DEBUG: Buscando Nota Filial: " + aFil + " Doc: " + cDocSQL + " Serie: " + cSerieSQL)

    cAliasPed := GetNextAlias()
    cQuery := " SELECT DISTINCT D2_PEDIDO, D2_FILIAL "
    cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
    cQuery += " WHERE D2_FILIAL = '" + aFil + "' "
    cQuery += " AND D2_DOC    = '" + cDocSQL + "' "
    cQuery += " AND D2_SERIE  = '" + cSerieSQL + "' "
    cQuery += " AND D2_PEDIDO <> '' "

    MPSysOpenQuery(cQuery, cAliasPed)

    ConOut("API_PUT_DEBUG: Query SD2: " + cQuery)

    If (cAliasPed)->(Eof())
        ConOut("API_PUT_DEBUG: Query SD2 retornou vazio.")
        Self:SetStatus(404)
        Self:SetResponse('{"error": "Nota Fiscal nao encontrada na tabela de itens (SD2) ou sem pedido vinculado"}')
        (cAliasPed)->(DbCloseArea())
        FreeObj(oJsonBody)
        FreeObj(oJsonResp)
        Return .T.
    EndIf

    DbSelectArea("SC5")
    SC5->(DbSetOrder(1)) // Indice 1: C5_FILIAL + C5_NUM
    // Itera pois uma nota pode vir de mais de um pedido (raro, mas possivel)

    While (cAliasPed)->(!Eof())
        cPedido    := (cAliasPed)->D2_PEDIDO
        cFilialPed := (cAliasPed)->D2_FILIAL
        ConOut("API_PUT_DEBUG: Tentando posicionar SC5 -> Filial: " + cFilialPed + " Pedido: " + cPedido)

        If SC5->(DbSeek(cFilialPed + cPedido))
            If RecLock("SC5", .F.)
                // Atualiza campos de controle
                SC5->C5_XDTINT := Date() // Data Atual
                SC5->C5_XPDINT := "N"    // Flag para não integrar novamente
                SC5->(MsUnlock())
                lEncontrou := .T.
                ConOut("API_PUT_DEBUG: SC5 Atualizado com sucesso.")
            Else
                ConOut("API_PUT_DEBUG: Falha no RecLock da SC5.")
            EndIf
        Else
            ConOut("API_PUT_DEBUG: DbSeek falhou na SC5. Pedido: " + cPedido)
        EndIf
        (cAliasPed)->(DbSkip())
    EndDo
    (cAliasPed)->(DbCloseArea())
     If lEncontrou
        Self:SetStatus(200)
        oJsonResp['message'] := "Pedidos vinculados a nota " + cDoc + " atualizados com sucesso."
        Self:SetResponse(oJsonResp:ToJson())
    Else
        Self:SetStatus(404)
        Self:SetResponse('{"error": "Nota encontrada, mas o Pedido de Venda vinculado nao foi localizado na SC5"}')
    EndIf
    FreeObj(oJsonBody)
    FreeObj(oJsonResp)
Return .T.

/* -------------------------------------------------------------------------- */
/* Helper: Formata Data ISO 8601                                              */
/* -------------------------------------------------------------------------- */
Static Function DateToISO(uParam, cTime)
    Local cRet  := ""
    Local cDate := ""

    // Verifica se é Data mesmo ou String que veio do SQL
    If ValType(uParam) == "D"
        cDate := DtoS(uParam)
    ElseIf ValType(uParam) == "C"
        cDate := AllTrim(uParam)
    EndIf

    If Empty(cDate)
        Return ""
    EndIf

    If Empty(cTime)
        cTime := "00:00:00"
    EndIf

    cRet := Transform(cDate, "@R 9999-99-99") + "T" + cTime + ".000Z"
Return cRet
