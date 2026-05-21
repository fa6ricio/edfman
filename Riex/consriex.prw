///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | CONSRIEX.prw         | AUTOR | FABIANO      | DATA | 13/12/2011 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Gera Riex a partir de n.f. selecionadas                         |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

#include 'rwmake.ch'
#include "protheus.ch"
#include "TOPCONN.ch"
#include "Fileio.ch"


User Function CONSRIEX()    
                     
Local _lRetorno     := .F.                                                     //Validacao da dialog criada oDlg 
Local _nOpca        := 0                                                       //Opcao da confirmacao 
Local bOk           := {|| _nOpca:=1,_lRetorno:=.T.,oDlg:End() }               //botao de ok 
Local bCancel       := {|| _nOpca:=0,oDlg:End() }                              //botao de cancelamento 
Local _cArqEmp      := ""                                                      //Arquivo temporario com as empresas a serem escolhidas 
Local _aStruTrb     := {}                                                      //estrutura do temporario 
Local _aBrowse      := {}                                                      //array do browse para demonstracao das empresas 
Local _aEmpMigr     := {}                                                        //array de retorno com as empresas escolhidas   
Private lInverte    := .F.                                                     //Variaveis para o MsSelect 
Private cMarca      := GetMark()                                               //Variaveis para o MsSelect 
Private oBrwTrb                                                                   //objeto do msselect 
Private oDlg 

Private nSaldoTot :=0  // Controla o Saldo utilizado.               
Private nDiferen  :=0  // Controla a diferença que falta alocar. (ou seja, qtd que ainda falta pra zerar a n.f. de venda... na tela)      


private aFields   := {}
Private aButtons  :={}
private cCadastro := "Consultar Notas"
Private cPerg       := "Riex02"      
Private cAlias   
Private oQtda                                                

// Define campos temporários
//aadd(aFields,{'OK', 'C', 02,0})
aadd(aFields,{'NF'   , 'C', 09,0})
aadd(aFields,{'SERIE','C',03,0})  
aadd(aFields,{'EMISSAO','D',08,0})
aadd(aFields,{'FORNEC','C',06,0})                        
aadd(aFields,{'LOJA','C',02,0})
//aadd(aFields,{'UF','C',02,0})
//aadd(aFields,{'TES'  , 'C', 03,0})                 
//aadd(aFields,{'QTD'  , 'N', 14,2})   
//aadd(aFields,{'UTILIZ','N',14,2})        
//aadd(aFields,{'QTDTELA','N',14,2})   
aadd(aFields,{'PRODUTO','C',15,0})
//aadd(aFields,{'VALOR','N',16,2})   
aadd(aFields,{'ITEM','C',4,0})   
// Cria arquivo

if SELECT("TMP") > 0 
   TMP->( dbCloseArea() )
Endif

cAliasTrb := "TMP"
oAliasTrb:= FwTemporarytable():New(cAliasTrb,aFields)
oAliasTrb:Create()

aadd(_aBrowse,{'NF'   , , 'N.F.'})
aadd(_aBrowse,{'SERIE',,'Série'}) 
aadd(_aBrowse,{'EMISSAO',,'Emissão'})
aadd(_aBrowse,{'FORNEC', ,'Fornec.'})
aadd(_aBrowse,{'LOJA', ,'Loja'})
aadd(_aBrowse,{'PRODUTO', ,'Produto'})
aadd(_aBrowse,{'ITEM', , 'Item'})
dbselectarea('TMP')
dbgotop()

//aadd(aButtons,{"CARGA", {|| ALTQTD()}, "Alterar Qtd."})
//aadd(aButtons,{"HISTORIC", {|| LimpaHist()}, "Limpa Histórico"})

ValidPerg()
If pergunte(cPerg,.T.)
                             
   cQuery := " SELECT ZU_NOTA AS DOC, ZU_SERIE AS SERIE, ZU_FORNECE AS FORCLI, ZU_LOJA AS LOJA, ZU_DATA AS EMISSAO, "
   cQuery += " ZU_PRODUTO AS COD, ZU_ITEM AS ITEM "
   cQuery += " FROM " + RetSqlName("SZU")
   cQuery += " WHERE ZU_NFR = '" + MV_PAR01 + "' "    
   cQuery += "   AND D_E_L_E_T_ = '' "
   
   cQuery := ChangeQuery(cQuery)
   If Select("TRB") > 0
      TRB->(DbCloseArea())
   Endif
   DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
   
   dbselectarea("TRB")       
   While !TRB->(EOF())                         
	      RecLock("TMP",.T.)                   
	      TMP->NF := TRB->DOC
	      TMP->SERIE:=TRB->SERIE         
	      TMP->EMISSAO:=STOD(TRB->EMISSAO)
	      TMP->FORNEC:= TRB->FORCLI  
	      TMP->LOJA:=TRB->LOJA      
	      TMP->PRODUTO	:= TRB->COD             
	      TMP->ITEM		:= TRB->ITEM
	      Msunlock()  
      
      TRB->(dbSkip())

   End
    
   TMP->(dbGoTop())
   cAlias:=ALIAS()        
   
   @ 001,001 TO 500,1200 DIALOG oDlg TITLE OemToAnsi("Consulta de Notas Fiscais para o RIEX") 
  
   oBrwTrb := MsSelect():New("TMP","","",_aBrowse,@lInverte,@cMarca,{025,001,230,600})   
   
   Activate MsDialog oDlg On Init (EnchoiceBar(oDlg,bOk,bCancel,,)) Centered VALID _lRetorno //.and. v_dif(nDiferen)
   
   TRB->(dbCloseArea())
   TMP->(dbCloseArea())
EndIf                                                           

Return .T.



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValidPerg ³ Autor ³Adriano Migoto Pinto   ³ Data ³ 14/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ajuste de Perguntas (SX1)                 			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ValidPerg()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MP8                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValidPerg()
PutSx1(cPerg,"01","Nota            ?" ,"","","mv_ch1","C", 9,0,0,"G","","","","","mv_par01")
Return .T.                                                                                         



