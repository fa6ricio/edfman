#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE   c_ent      CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA050INC º Autor  ³ Luis Felipe Nascim.º Data ³  04/06/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ O ponto de entrada FA050INC - será executado na validação  º±±
±±º          ³ da Tudo Ok na inclusão do contas a pagar.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro - Contas a Pagar                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºObjetivo  ³ Garantir que todos os campos julgados importantes para o   º±±
±±º          ³ efetivo controle dos pagamentos das Usinas estejam preen-  º±±
±±º          ³ chidos.                 			             			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlteracao ³ Luis Felipe Nascimento                           18/08/15  º±±
±±º          ³ Criado cheque automático da numeração dos PA´s destinados  º±±
±±º          ³ as Usinas para que não ocorra a duplicidade da numeração.  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050INC()

Local aArea		:= GetArea()
Local lRet  	:= .t.
Local cGrupo	:= GetAdvFVal("SA2","A2_XDESCGR",xFilial("SA2")+M->E2_FORNECE+M->E2_LOJA, 1, " " )
Local lTxMoeda 	:= IIf(Posicione(("SM2"),1,dDataBase,"M2_MOEDA2") == 0, .F.,.T.)
Local cQry 		:= ""
Local cAlias 	:= GetNextAlias()

**** Luiz Pereira -- 20/05/2015
***********************************
If !lTxMoeda
   MsgAlert("Não existe Taxa do Dolar Cadastrada ! Impossível Incluir Títulos de C.Pagar !"+chr(13)+chr(10)+"Favor Conferir as Taxas no Cadastro de Moedas !","Atenção !") 
   lRet  := .F.
Endif
***********************************

If cGrupo $ "000003/000008" .and. Alltrim(M->E2_TIPO) == "PA"  .and. lTxMoeda
	If Empty(M->E2_XLOCAL) // .or. Empty(M->E2_XPERIOD) 26/09/14 - Luís Felipe Nascimento
//       Aviso("Atenção","Quando se tratar de adiantamento a fornecedores que façam parte do grupo Usinas, os campos Contrato, Período e Terminal são obrigatórios ! Favor preencher os campos indicados e confirmar a inclusão novamente.",{"Voltar"})
       Aviso("Atenção","Quando se tratar de adiantamento o campo Terminal deverá ser preenchido ! Favor preencher o campo indicado e confirmar a inclusão novamente.",{"Voltar"})
       lRet := .f.
	EndIf
	
	***********************************************************************************************************************
	** 18/08/15 - Luis Felipe - Inicio - Garantiar que não haja a duplicidade de numeração dos PA´s destinados as Usinas **
	***********************************************************************************************************************
	cQuery := " Select R_E_C_N_O_ as Registro " + c_ent
    cQuery += " From " +RetSqlName("SE2")+ c_ent
	cQuery += " Where E2_NUM = '"+ M->E2_NUM+"'" + c_ent
	cQuery += " And   E2_TIPO = '"+ M->E2_TIPO+"'" + c_ent
	cQuery += " And   E2_PREFIXO = 'USI'"+ c_ent
	cQuery += " And   D_E_L_E_T_ = ''"+ c_ent
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	nReg := (cAlias)->Registro
	
	(cAlias)->(DbCloseArea())

	If nReg <> 0
		cAlias := GetNextAlias()
		cQuery := " Select Max(E2_NUM) As PROXNUM" + c_ent
	    cQuery += " From" +RetSqlName("SE2")+ c_ent
		cQuery += " Where D_E_L_E_T_ = ''" + c_ent
		cQuery += " And   E2_TIPO = 'PA ' "+ c_ent
		cQuery += " And   E2_PREFIXO = 'USI' "+ c_ent
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
		
		cNum := Soma1((cAlias)->PROXNUM)
		
		M->E2_NUM := cNum
		(cAlias)->(DbCloseArea())
		
	EndIf 
	********************************************************************************************************************
	** 18/08/15 - Luis Felipe - Fim - Garantiar que não haja a duplicidade de numeração dos PA´s destinados as Usinas **
	********************************************************************************************************************
    
EndIf

RestArea(aArea)

Return( lRet )