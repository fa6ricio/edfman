#INCLUDE "TOTVS.CH"
 
User Function MyEECAP100()
Local cPedido := "EXT00001"
Private aPDocs       := {}
Private aPPedidos    := {}
Private aPAgentes    := {}
Private aPNotifys    := {}
Private aPProdutos   := {}
Private aCondPag    := {}
Private aEmb        := {}
 
/************************
//Inicializa o ambiente
*************************/
/*RpcSetEnv("01", "0109")
nModulo := 29
cModulo := "EEC"
__CUSERID := "000000"*/
 


IncAP100(cPedido, 3, 3)

  
 
 
Return Nil
/*****************************************************************
******************************************************************/
Static Function IncAP100(cPedido, nOpc, nOpcDet)
Local aCab := {}
Local aItens := {} 
Local aAux   := {}
Local nItem := 1
Private lMsErroAuto := .f.
 
aPDocs       := {}
aPPedidos    := {}
aPAgentes    := {}
aPNotifys    := {}
aPProdutos   := {}
aCondPag     := {}
aEmb         := {}

 
aItens := {}
aItem := {}
 
if nOpc == 3
 
      aCab := {}
      aadd(aCab, {'EE7_PEDIDO', cPedido                   , NIL})
      aadd(aCab, {'EE7_DTPROC', cTod( '21/01/2026' )      , NIL})
      aadd(aCab, {'EE7_DTPEDI', cTod( '21/01/2026' )      , NIL})
      aadd(aCab, {'EE7_IMPORT', "000201"                  , NIL})
      aadd(aCab, {'EE7_IMLOJA', "01"                      , NIL})
      aadd(aCab, {'EE7_IMPODE', "ED & F MAN NEDERLAND BV ", NIL})
      aadd(aCab, {'EE7_FORN'  , "028891"                  , NIL}) //Fornecedor é a filial que está exportando
      aadd(aCab, {'EE7_FOLOJA', "01"                      , NIL})
      aadd(aCab, {'EE7_FORNDE', "EDF MAN BRASIL LTDA MG"  , NIL})
      aadd(aCab, {'EE7_IDIOMA', "INGLES-INGLES"           , NIL})
      aadd(aCab, {'EE7_CONDPA', "001"                     , NIL})
      aadd(aCab, {'EE7_MPGEXP', "003"                     , NIL})
      aadd(aCab, {'EE7_INCOTE', 'FOB'                     , NIL})
      aadd(aCab, {'EE7_MOEDA' , 'US$'                     , NIL})
      aadd(aCab, {'EE7_VIA'   , "01"                      , NIL})
      aadd(aCab, {'EE7_ORIGEM', "SSZ"                     , NIL})
      aadd(aCab, {'EE7_DEST'  , "SHA"                     , NIL})
      aadd(aCab, {'EE7_PAISET', "160"                     , NIL})
      aadd(aCab, {'EE7_TIPTRA', "1"                       , NIL})
      aadd(aCab, {'EE7_FRPPCC', "PP"                      , NIL})
      aadd(aCab, {'EE7_CALCEM', '1'                       , NIL})
      
       
      //Enviando o ATUEMB igual a S, o sistema realizará a integração automática do Embarque de Exportação.
      aAdd(aCab, {"ATUEMB", "N", Nil})
 
 
      aadd(aItem, {'EE8_SEQUEN', str(nItem)        , NIL})
      aadd(aItem, {'EE8_COD_I' , "ALGODAO"         , NIL})
      aadd(aItem, {'EE8_VM_DES', "ALGODAO EM PLUMA", NIL})
      aadd(aItem, {'EE8_FORN'  , "028891"          , NIL})
      aadd(aItem, {'EE8_FOLOJA', "01"              , NIL})
      aadd(aItem, {'EE8_FABR'  , "000001"          , NIL})
      aadd(aItem, {'EE8_FALOJA', "01"              , NIL})
      aadd(aItem, {'EE8_SLDINI', 1000              , NIL})
      aadd(aItem, {'EE8_EMBAL1', "023"             , NIL})
      aadd(aItem, {'EE8_QE'    , 100               , NIL})
      aadd(aItem, {'EE8_QTDEM1', 10                , NIL})
      aadd(aItem, {'EE8_PRECO ', 1.65              , NIL})
      aadd(aItem, {'EE8_PSLQUN', 1                 , NIL})
      aadd(aItem, {'EE8_POSIPI', '52010020'        , NIL})
      aadd(aItem, {'EE8_TES'   , "811"             , NIL})
      aadd(aItem, {'EE8_CF'    , "7504"            , NIL})
      aadd(aItem, {"AUTDELETA" , "N"               , Nil})

      AADD( aItens, aClone(aItem))
      aItem := {}
      
      /*
      aAdd(aAgente, {"EEB_CODAGE", "001"           , Nil})
      aAdd(aAgente, {"EEB_TIPCOM", "1"             , Nil}) // 1-A Remeter | 2-Conta Grafcica | 3-Deduzir da Fatura
      aAdd(aAgente, {"EEB_TIPCVL", "2"             , Nil}) // 1-Percentual | 2-Valor Fixo | 3-Percentual por item
      aAdd(aAgente, {"EEB_VALCOM", 10              , Nil})
      aAdd(aAgente, {"EEB_REFAGE", "NOME AGENTE"   , Nil})

      aAdd(aAgentes, aAgente)
      aAdd(aAux, {"EEB", aAgentes})*/
 
EndIF 

 
   // execução DA rotina utomática
   MsAguarde({|| MSExecAuto( {|X,Y,Z,aAux| EECAP100(X,Y,Z,aAux)},aCab ,aItens, nOpc,aAux ) }, "Integrando Pedido Automático")
 
    If lMsErroAuto
        MostraErro()
        lMsErroAuto := .F.
    Else
        cAcao := iif( nOpc == 3 , " incluido",iif(nOpc==4," alterado"," excluido"))
        MsgInfo("Pedido " + cAcao + " com sucesso!", "Aviso")
    EndIf
 
 
Return
