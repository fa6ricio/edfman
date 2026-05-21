#INCLUDE "Rwmake.Ch"

User Function ConvLD()
/*/f/ 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ 
<Descricao> : FunÁ„o para Convers„o da RepresentaÁ„o NumÈrica do CÛdigo de Barras - Linha Digit·vel (LD) em CÛdigo de Barras (CB).
	Para utilizaÁ„o dessa FunÁ„o, deve-se criar um Gatilho para o campo E2_CODBAR, Conta DomÌnio: E2_CODBAR, Tipo: Prim·rio, Regra: EXECBLOCK("CONVLD",.T.), Posiciona: N„o.               
	Utilize tambÈm a ValidaÁ„o do Usu·rio para o Campo E2_CODBAR EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.          
<Autor> : 
<Data> : 28/11/08
<Parametros> : Nenhum
<Retorno> : Nil 
<Processo> : ValidaÁ„o do CÛdigo de Barras
<Rotina> : Financeiro
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : E
<Obs> : 
SENDO UTILIZADO PARA O CLIENTE EUROCOLCHOES PELO ANALISTA CHRISTIAN MOURA 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ 
*/  
	SetPrvt("cStr")
	
	cStr := LTrim(RTrim(M->E2_CODBAR))
	
	If ValType(M->E2_CODBAR) == Nil .OR. Empty(M->E2_CODBAR)
		// Se o Campo est· em Branco n„o Converte nada.
		cStr := ""
	Else
		// Se o Tamanho do String for menor que 44, completa com zeros atÈ 47 dÌgitos. Isso È
		// necess·rio para Bloquetos que N¬O tÍm o vencimento e/ou o valor informados na LD.
		cStr := IIf(Len(cStr) < 44, cStr + REPL("0", 47 - Len(cStr)), cStr)
	EndIf
	
	Do Case
	Case Len(cStr) == 47
		cStr := SubStr(cStr,1,4) + SubStr(cStr,33,15) + SubStr(cStr,5,5) + SubStr(cStr,11,10) + SubStr(cStr,22,10)
	Case Len(cStr) == 48
		cStr := SubStr(cStr,1,11) + SubStr(cStr,13,11) + SubStr(cStr,25,11) + SubStr(cStr,37,11)
	Otherwise
		cStr := cStr + SPACE(48 - LEN(cStr))
	EndCase
	
Return(cStr)