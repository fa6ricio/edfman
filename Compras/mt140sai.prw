#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT140SAI  ºAutor  ³ Luis F. Nascimento       ³  05/04/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada disparado antes do retorno da rotina ao   º±±
±±º          ³ browse. Pré-Nota gerada pelo Totvs Colaboracao			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Compras X TOTVS Colaboracao - MATA140                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFinalidade³ Preencher campos customizados utilizados nas tabela de re- º±±
±±º          ³ taguarda e cabeçalho da NF para fins de vinculação das NF´sº±±
±±º          ³ de Remessa com as NF´s Mãe.                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//PARAMIXB[1] = Numero da operação - ( 2-Visualização, 3-Inclusão, 4-Alteração, 5-Exclusão )
//PARAMIXB[2] = Número da nota
//PARAMIXB[3] = Série da nota
//PARAMIXB[4] = Fornecedor
//PARAMIXB[5] = Loja
//PARAMIXB[6] = Tipo
//PARAMIXB[7] = Opção de Confirmação (1 = Confirma pré-nota; 0 = Não Confirma pré-nota)

User Function MT140SAI()

Local nOrdem := SF1->( IndexOrd() )
Local aArea	 := Getarea()

If Type("__TipoNF")=="U"
	__TipoNF := ""
EndIf

If !FunName() $ "LEXMLREM/LEXMLMAE"
	SA2->(DbSetOrder(1))
	SA2->( MsSeek( xFilial( 'SA2' ) + ParamIxb[4] + ParamIxb[5] ) )
	
	If SA2->A2_XDESCGR $ '000003/000008' 
		If ParamIxb[1] == 3
			SF1->( dbSetOrder( 1 ) )
			If SF1->( MsSeek( xFilial( 'SF1' ) + ParamIxb[2] + ParamIxb[3] + ParamIxb[4] + ParamIxb[5] ) )
				If __TipoNF == "M" // NF Mae
					RecLock("SF1",.F.)
					SF1->F1_NFMAE := SF1->F1_DOC
					Msunlock()
					u_CLSPRENF()
				EndIf
			EndIf
			SF1->( dbSetOrder( nOrdem ) )
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return( NIL )