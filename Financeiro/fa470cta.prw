#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³FA470CTA º Autor ³                         º Data ³ 17/08/12 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para a identificacao de Agencia/Conta º±±
±±º ³ da Reconciliacao Automatica º±±
±±º ³ ** Dado gravado no campo SA6->A6_PAISBCO com string inteiraº±±
±±º ³ no formato º±±
±±º ³ 0040310000027044549 004031 - Ag+dv (arquivo) º±±
±±º ³ 0000027044549 - Conta_dv º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ p11 Financeiro - Reconciliacao Automatica º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 

User Function FA470CTA() 


Local aArea := GetArea()

Local cBanco := ParamIxb[1]
Local cAgencia:= ParamIxb[2]
Local cConta := ParamIxb[3]
Local _mBanco
Local _mAgencia 
Local _mCtaCor


//
//alert("Parametros: Bco:"+ParamIxb[1]+"/ Ag:"+ParamIxb[2]+"/ Cta:"+ParamIxb[3]+"/")
// 
IF cBanco = '341'
DbSelectArea("SA6")
DbSetOrder(1)
If DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta) 
_mBanco := MV_PAR03
_mAgencia := cAgencia
_mCtaCor := cConta
Else
_mBanco := MV_PAR03
_mAgencia := cAgencia
_mCtaCor := cConta
Endif
// 
//alert("Cad Banco: "+_mBanco+" "+_mAgencia+" "+_mCtaCor+" - "+SA6->A6_PAISBCO)
//
//aConta := {_mBanco,_mAgencia,_mCtaCor}
aConta := {alltrim(_mBanco),alltrim(_mAgencia),alltrim(_mCtaCor)}

Elseif cBanco = '237'

DbSelectArea("SA6")
DbSetOrder(1)
If DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta) 
_mBanco := MV_PAR03
_mAgencia := cAgencia
_mCtaCor := substr(cConta,1,6)+substr(cConta,7,1) 
Endif
// 
//alert("Cad Banco: "+_mBanco+" "+_mAgencia+" "+_mCtaCor+" - "+SA6->A6_PAISBCO)
//
//aConta := {_mBanco,_mAgencia,_mCtaCor}
aConta := {alltrim(_mBanco),alltrim(_mAgencia),alltrim(_mCtaCor)}

else

DbSelectArea("SA6")
DbSetOrder(1)
If DbSeek(xFilial("SA6")+cBanco+cAgencia+cConta) 
_mBanco := MV_PAR03
_mAgencia := cAgencia
_mCtaCor := cConta 
Endif
// 
//alert("Cad Banco: "+_mBanco+" "+_mAgencia+" "+_mCtaCor+" - "+SA6->A6_PAISBCO)
//
aConta := {_mBanco,_mAgencia,_mCtaCor}
//aConta := {alltrim(_mBanco),alltrim(_mAgencia),alltrim(_mCtaCor)}

endif



// 
RestArea(aArea)
//
Return(aConta)
