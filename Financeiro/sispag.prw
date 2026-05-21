#Include "Protheus.ch"
#Include "Rwmake.ch"

/*===========================================================================
Autor    : Luciano Theodoro (+Soluções)				    Data     : 19/08/2009 
-----------------------------------------------------------------------------
Descrição: Rotina para tratamento de dados para SISPAG.
-----------------------------------------------------------------------------
Nome     : SISPAG
===========================================================================*/

**********************
User Function SISPAG01 
**********************
/*Rotina para tratar envio dos dados da Agência e C/C do Favorecido.*/
Local _cRet := Space(20)
Local cMod := "03"

DbSelectArea("SEA")
DbSetOrder(1)
IF DbSeek(xFilial("SEA")+SE2->E2_NUMBOR+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO)
	cMod := SEA->EA_MODELO
ENDIF

If !Empty(SE2->E2_XBENEF) .Or. !Empty(SE2->E2_XCNPJB) 
   If (Alltrim(cMod) <> '04' .AND. Alltrim(cMod) <> '10') .AND. (Empty(SE2->E2_XAGENB).Or. Empty(SE2->E2_XBCTAB) .Or. Empty(SE2->E2_XDACB))  
      MsgAlert("Agência, Conta e/ou DAC do Beneficiário não informada - título "+;
      AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+AllTrim(SE2->E2_PARCELA)+;
      ". Atualize o título indicado e execute esta rotina novamente.")
   Endif
   If SE2->E2_XBCOB == "341"
      _cRet := StrZero(Val(SubStr(SE2->E2_XAGENB,1,4)),5)+" "+StrZero(Val(AllTrim(SE2->E2_XBCTAB)),12)
      _cRet += " "+Left(AllTrim(SE2->E2_XDACB),1)
   Else     
      
      If !Empty(SE2->E2_XAGENB)
	      _cRet := StrZero(Val(SubStr(SE2->E2_XAGENB,1,4)),5)+" "+StrZero(Val(AllTrim(SE2->E2_XBCTAB)),12)   
      Else
	      _cRet := Replicate("0",5)+" "+StrZero(Val(AllTrim(SE2->E2_XBCTAB)),12)         
      Endif
        
      If Len(AllTrim(SE2->E2_XDACB)) > 1
         _cRet += SE2->E2_XDACB
      Else
         _cRet += " "+Left(AllTrim(SE2->E2_XDACB),1)
      Endif
   Endif
Else 
//  <<<
//  If SA2->A2_BANCO == "341"
//      _cRet := StrZero(Val(SubStr(SA2->A2_AGENCIA,1,4)),5)+" "+StrZero(Val(AllTrim(SA2->A2_NUMCON)),12)
//      _cRet += " "+Left(AllTrim(SA2->A2_XDAC),1)
//   Else     
//      _cRet := StrZero(Val(SubStr(SA2->A2_AGENCIA,1,4)),5)+" "+StrZero(Val(AllTrim(SA2->A2_NUMCON)),12)
//      If Len(AllTrim(SA2->A2_XDAC)) > 1
//         _cRet += SA2->A2_XDAC
//      Else
//         _cRet += " "+Left(AllTrim(SA2->A2_XDAC),1)
//      Endif
//   Endif 
//  <<<
  If SE2->E2_XBCOF == "341"
      _cRet := StrZero(Val(SubStr(SE2->E2_XAGENF,1,4)),5)+" "+StrZero(Val(AllTrim(SE2->E2_XCTAFO)),12)
      _cRet += " "+Left(AllTrim(SE2->E2_XDAC),1)
  Else     
     _cRet := StrZero(Val(SubStr(SE2->E2_XAGENF,1,4)),5)+" "+StrZero(Val(AllTrim(SE2->E2_XCTAFO)),12)
     If Len(AllTrim(SE2->E2_XDAC)) > 1
        _cRet += SE2->E2_XDAC
     Else
        _cRet += " "+Left(AllTrim(SE2->E2_XDAC),1)
     Endif
  Endif
Endif 

Return(_cRet)

**********************
User Function SISBANCO 
**********************
/*Rotina para tratar envio dos dados do Banco do Favorecido.*/
Local _cRet := Space(3)
Local cMod := "03"

DbSelectArea("SEA")
DbSetOrder(1)
IF DbSeek(xFilial("SEA")+SE2->E2_NUMBOR+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO)
	cMod := SEA->EA_MODELO
ENDIF
               
If !Empty(SE2->E2_XBENEF) .Or. !Empty(SE2->E2_XCNPJB) 
   If Alltrim(cMod) <> '04' .AND. Empty(SE2->E2_XBCOB)
      MsgAlert("Banco do Beneficiário não informado - título "+;
      AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+AllTrim(SE2->E2_PARCELA)+;
      ". Atualize o título indicado e execute esta rotina novamente.")
   Endif
   _cRet := SubStr(SE2->E2_XBCOB,1,3)   
Else
//   _cRet := SubStr(SA2->A2_BANCO,1,3)    <<<

     _cRet := SubStr(Iif(Empty(SE2->E2_XBCOF),REPLICATE("0",3),SE2->E2_XBCOF),1,3)
Endif

Return(_cRet)

**********************
User Function SISFAVOR 
**********************
/*Rotina para tratar envio do Nome do Favorecido.*/
Local _cRet := Space(30)
             
If !Empty(SE2->E2_XBENEF) .Or. !Empty(SE2->E2_XCNPJB) 
   If Empty(SE2->E2_XBENEF)
      MsgAlert("Nome do Beneficiário não informado - título "+;
      AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+AllTrim(SE2->E2_PARCELA)+;
      ". Atualize o título indicado e execute esta rotina novamente.")
   Endif
   _cRet := SubStr(SE2->E2_XBENEF,1,30)   
Else
   _cRet := SubStr(SA2->A2_NOME,1,30)
Endif

Return(_cRet)

**********************
User Function CGCFAVOR 
**********************
/*Rotina para tratar envio do CNPJ/CPF do Favorecido.*/
Local _cRet := Space(14)
             
If !Empty(SE2->E2_XBENEF) .Or. !Empty(SE2->E2_XCNPJB) 
   If Empty(SE2->E2_XCNPJB)
      MsgAlert("CNPJ/CPF do Beneficiário não informado - título "+;
      AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+AllTrim(SE2->E2_PARCELA)+;
      ". Atualize o título indicado e execute esta rotina novamente.")
   Endif
   _cRet := StrZero(Val(SE2->E2_XCNPJB),14)
Else
   _cRet := Strzero(Val(SA2->A2_CGC),14)
Endif      

Return(_cRet)                                   

**********************
User Function SISPAG06 
**********************
Local _cRet := Space(12)

IF AT(SA6->A6_NUMCON,"-") > 0
   _cRet := STRZERO(VAL(SUBSTR(SA6->A6_NUMCON,1,AT(SA6->A6_NUMCON,"-")-1)),12) 
ELSE
	//Alterado por Vinicius Figueiredo - Doit para concatenar o dv da conta caso não haja '-'.(20120820)
    _cRet := STRZERO(VAL(AllTrim(SA6->A6_NUMCON)),12)
	//este bloco abaixo é o atualizado por mim deve ser rehabilitado após validação do item 1 visto que os dois implicam na mesma rotina e o segundo depende de alterações na base
   //_cRet := STRZERO(VAL(SUBSTR(SA6->A6_NUMCON,1,LEN(SA6->A6_NUMCON)-1)+AllTrim(SA6->A6_DVCTA)),12) 
   
   
ENDIF
   
Return(_cRet)

**********************
User Function SISPAG02
**********************
/*Preencher o Seguimento N do arquivo SISPAG da posição 018 a 195.
  Pagamento de Tributos sem código de barras e FGTS.
  Retorna Dados do Tributo.*/

/*==============================
PAGAMENTO DE DARF / DARF SIMPLES
==============================*/  
If (SEA->EA_MODELO == "16" .Or. SEA->EA_MODELO == "18")   
   //Posicao 018 a 019: Identificacao do Tributo 02-Darf 03-Darf Simples
   _cRet := If(SEA->EA_MODELO=="18","03","02")                         
 
   //Posicao 020 a 023: Codigo da Receita
   If !Empty(SE2->E2_CODRET)
      _cRet += SE2->E2_CODRET
   Else
      _cRet += SA2->A2_XCODRET
   Endif
       
   //Posicao 024 a 024: Tipo Inscricao  1-CPF/2-CNPJ               
   If !Empty(SE2->E2_XCNPJC)
     _cRet += Iif(Len(AllTrim(SE2->E2_XCNPJC))>11,"2","1")
   Else               
     _cRet += Iif(Len(AllTrim(SM0->M0_CGC))>11,"2","1")
   Endif
  
   //Posicao 025 a 038: CNPJ/CPF do Contribuinte
   If !Empty(SE2->E2_XCONTR)
      If Empty(SE2->E2_XCNPJC)
         MsgAlert("O título de tributo "+AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+;
         AllTrim(SE2->E2_PARCELA)+" do Fornecedor "+AllTrim(SE2->E2_FORNECE)+" "+AllTrim(SE2->E2_LOJA)+;
         " está sem o CNPJ/CPF do Contribuinte. Atualize os dados no título e execute esta rotina novamente.")
      Endif
      _cRet += StrZero(Val(SE2->E2_XCNPJC),14)
   Else
      _cRet += Strzero(Val(SM0->M0_CGC),14)
   Endif
                                                                                       
   //Posicao 039 a 046: Periodo Apuracao
   _cRet += GravaData(SE2->E2_XAPUR,.F.,5)
   //Mensagem ALERTA se está sem período de apuração
   If Empty(SE2->E2_XAPUR)                              
      MsgAlert("Tributo sem Data de Apuração. Informe o campo 'Dt. Apuracao' no título: "+;
      AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+AllTrim(SE2->E2_PARCELA)+" Tipo: "+;
      AllTrim(SE2->E2_TIPO)+" Fornecedor/Loja: "+AllTrim(SE2->E2_FORNECE)+" "+AllTrim(SE2->E2_LOJA)+;
      " se necessário atualize o título e execute esta rotina novamente.")
   Endif      
            
   //Posicao 047 a 063: Referencia   
   _cRet += REPL("0",17) //StrZero(0,17)
  
   //Posicao 064 a 077: Valor Principal
	//Alterado vinicius Doit - 20121015 - Lista 2 Atv 3
   //_cRet += StrZero(SE2->E2_SALDO*100,14)                               
   _cRet += StrZero((SE2->E2_SALDO-SE2->E2_XVLRENT)*100,14)                               
            
   //Posicao 078 a 091: Multa             
   _cRet += StrZero(SE2->E2_XMULTA*100,14)         
            
   //Posicao 092 a 105: Juros        
   _cRet += StrZero(SE2->E2_VALJUR*100,14)
            
   //Posicao 106 a 119: Valor Total (Principal + Multa + Juros)
   _cRet += StrZero((SE2->E2_SALDO+SE2->E2_XMULTA+SE2->E2_VALJUR)*100,14)           

   //Posicao 120 a 127: Data Vencimento                           
   _cRet += GravaData(SE2->E2_VENCTO,.F.,5)                             

   //Posicao 128 a 135: Data Pagamento                            
   _cRet += GravaData(SE2->E2_VENCREA,.F.,5)                            

   //Posicao 136 a 165: Compl.Registro                          
   _cRet += Space(30)                                                   

   //Posicao 166 a 195: Nome do Contribuinte                 
   If !Empty(SE2->E2_XCNPJC)
      If Empty(SE2->E2_XCONTR)
         MsgAlert("Nome do Contribuinte não informado para a GPS - título "+;
         AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+AllTrim(SE2->E2_PARCELA)+;
         ". Atualize o Nome do Contribuinte no título indicado e execute esta rotina novamente.")
      Endif
      _cRet += SubStr(SE2->E2_XCONTR,1,30)   
   Else
      _cRet += SubStr(SM0->M0_NOMECOM,1,30)
   Endif                   
Endif

/*==============
PAGAMENTO DE GPS
==============*/
If (SEA->EA_MODELO == "17")   
   //Posicao 018 a 019: Identificacao do Tributo 01-GPS                    
   _cRet := "01"                                                       
   
   //Posicao 020 a 023: Codigo Pagamento                                 
   _cRet +=  SE2->E2_XCODGPS  
                                                 
   //Posicao 024 a 029: Competencia     
   _cRet += StrZero(Month(SE2->E2_XAPUR),2) + StrZero(Year(SE2->E2_XAPUR),4)
   //Mensagem ALERTA se está sem período de apuração
   If Empty(SE2->E2_XAPUR)                             
      MsgAlert("Tributo sem Competência. Informe o campo 'Dt. Apuracao' no título: "+;
      AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+AllTrim(SE2->E2_PARCELA)+" Tipo: "+;
      AllTrim(SE2->E2_TIPO)+" Fornecedor/Loja: "+AllTrim(SE2->E2_FORNECE)+" "+AllTrim(SE2->E2_LOJA)+;
      " se necessário atualize o título e execute esta rotina novamente.")
   Endif 
            
   //Posicao 030 a 043: CNPJ/CPF do Contribuinte
   If !Empty(SE2->E2_XCONTR)
      If Empty(SE2->E2_XCNPJC)
         MsgAlert("O título de tributo "+AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+;
         AllTrim(SE2->E2_PARCELA)+" do Fornecedor "+AllTrim(SE2->E2_FORNECE)+" "+AllTrim(SE2->E2_LOJA)+;
         " está sem o CNPJ/CPF do Contribuinte. Atualize os dados no título e execute esta rotina novamente.")
      Endif
      _cRet += StrZero(Val(SE2->E2_XCNPJC),14)
   Else
      _cRet += Strzero(Val(SM0->M0_CGC),14)
   Endif
  
   //Posicao 044 a 057: Valor Principal (Valor Titulo - Outras Entidades)
	//Alterado vinicius Doit - 20121015 - Lista 2 Atv 3
   //_cRet += Strzero(SE2->E2_SALDO*100,14)                               
   _cRet += Strzero((SE2->E2_SALDO-SE2->E2_XVLRENT)*100,14)                               
            
   //Posicao 058 a 071: Valor Outras Entidades
   _cRet += Strzero(SE2->E2_XVLRENT*100,14)            
            
   //Posicao 072 a 085: Atual. Monetária        
   _cRet += Strzero(SE2->E2_XCORREC*100,14)            
            
   //Posicao 086 a 099: Valor Total (Principal + Multa)
	//Altera vinicius Doit
   //_cRet += Strzero((SE2->E2_SALDO+SE2->E2_XMULTA-SE2->E2_XVLRENT)*100,14)              
	_cRet += Strzero((SE2->E2_SALDO+SE2->E2_XMULTA)*100,14)              
 
   //Posicao 100 a 107: Data Vencimento                           
   _cRet += GravaData(SE2->E2_VENCREA,.F.,5)                             

   //Posicao 108 a 115: Compl.Registro                          
   _cRet += Space(8)                                                   

   //Posicao 116 a 165: Informacoes Complementares              
   _cRet += Space(50)                                                  

   //Posicao 166 a 195: Nome do Contribuinte                                                  
   If !Empty(SE2->E2_XCNPJC)
      If Empty(SE2->E2_XCONTR)
         MsgAlert("Nome do Contribuinte não informado para a GPS - título "+;
         AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+AllTrim(SE2->E2_PARCELA)+;
         ". Atualize o Nome do Contribuinte no título indicado e execute esta rotina novamente.")
      Endif
      _cRet += SubStr(SE2->E2_XCONTR,1,30)   
   Else
      _cRet += SubStr(SM0->M0_NOMECOM,1,30)
   Endif                                                                                                                                       
Endif     

/*===============
PAGAMENTO DE DARJ
===============*/  
If (SEA->EA_MODELO == "21")   
   //Posicao 018 a 019: Identificacao do Tributo 01-GPS                    
   _cRet := "04"                                                       

   //Posicao 020 a 023: Codigo Pagamento                                 
   _cRet +=  SE2->E2_XCDDARJ  
       
   //Posicao 024 a 024: Tipo Inscricao  1-CPF/2-CNPJ               
   _cRet += Iif(Len(AllTrim(SM0->M0_CGC))>11,"2","1")
  
   //Posicao 025 a 038: CNPJ/CPF do Contribuinte
   _cRet += SubStr(SM0->M0_CGC,1,14)
                                                 
   //Posicao 039 a 046: INSCR. ESTADUAL do Contribuinte
   _cRet += SubStr(SM0->M0_INSC,1,8)
            
   //Posicao 047 a 062: Documento Origem   
   _cRet += StrZero(0,16) 
   //_cRet += StrZero(Val(SE2->E2_XORDARJ),16) 
  
   //Posicao 063 a 063: Compl.Registro   
   _cRet += Space(1) 
            
   //Posicao 064 a 077: Valor Principal
   _cRet += StrZero(SE2->E2_SALDO*100,14)                               
            
   //Posicao 078 a 091: Atual. Monetária
   _cRet += StrZero(SE2->E2_XCORREC*100,14)
                         
   //Posicao 092 a 105: Mora        
   _cRet += StrZero(SE2->E2_VALJUR*100,14)
  
   //Posicao 106 a 119: Multa        
   _cRet += StrZero(SE2->E2_XMULTA*100,14)
            
   //Posicao 120 a 133: Valor Total (Principal + Atual. + Mora + Multa)
   _cRet += StrZero((SE2->E2_SALDO+SE2->E2_XCORREC+SE2->E2_VALJUR+SE2->E2_XMULTA)*100,14)           

   //Posicao 134 a 141: Data Vencimento                           
   _cRet += GravaData(SE2->E2_VENCTO,.F.,5)                             
   
   //Posicao 142 a 149: Data Pagamento                            
   _cRet += GravaData(SE2->E2_VENCREA,.F.,5)
  
   //Posicao 150 a 155: Referência     
   _cRet += StrZero(Month(SE2->E2_XAPUR),2) + StrZero(Year(SE2->E2_XAPUR),4)
   //Mensagem ALERTA se está sem período de apuração
   If Empty(SE2->E2_XAPUR)                             
      MsgAlert("Tributo sem Período de Referência. Informe o campo 'Dt. Apuracao' no título: "+;
      AllTrim(SE2->E2_PREFIXO)+" "+AllTrim(SE2->E2_NUM)+" "+AllTrim(SE2->E2_PARCELA)+" Tipo: "+;
      AllTrim(SE2->E2_TIPO)+" Fornecedor/Loja: "+AllTrim(SE2->E2_FORNECE)+" "+AllTrim(SE2->E2_LOJA)+;
      " se necessário atualize o título e execute esta rotina novamente.")
   Endif                            

   //Posicao 156 a 165: Compl.Registro                          
   _cRet += Space(10)                                                   

   //Posicao 166 a 195: Nome do Contribuinte                 
   _cRet += SubStr(SM0->M0_NOMECOM,1,30)                                                                                                                                   
Endif

/*===============
PAGAMENTO DE FGTS
===============*/  
If (SEA->EA_MODELO == "35")   
   //Posicao 018 a 019: Identificacao do Tributo 01-GPS                    
   _cRet := "11"
                                                          
   //Posicao 020 a 023: Codigo Pagamento                                 
   _cRet +=  SE2->E2_XCDFGTS  
       
   //Posicao 024 a 024: Tipo Inscricao  2-CPF/1-CNPJ               
   _cRet += Iif(Len(AllTrim(SM0->M0_CGC))>11,"1","2")
  
   //Posicao 025 a 038: CNPJ/CPF do Contribuinte
   _cRet += SubStr(SM0->M0_CGC,1,14)
                                                 
   //Posicao 039 a 086: Cod. de Barras
   _cRet += SE2->E2_CODBAR
            
   //Posicao 087 a 102: Identificador
   //_cRet += StrZero(0,16)
   _cRet += StrZero(Val(SubStr(SE2->E2_XTRIBID,1,16)),16)
  
   //Posicao 103 a 113: Lacre; Digto Lacre  
   _cRet += REPL("0",11) //StrZero(0,11)
  
   //Posicao 114 a 143: Nome do Contribuinte                 
   _cRet += SubStr(SM0->M0_NOMECOM,1,30)                          
  
   //Posicao 144 a 151: Data Pagamento                            
   _cRet += GravaData(SE2->E2_VENCREA,.F.,5)
            
   //Posicao 152 a 165: Valor Principal
   _cRet += StrZero(SE2->E2_SALDO*100,14)                               
            
   //Posicao 166 a 195: Compl.Registro                          
   _cRet += Space(30)                                                   
Endif

Return(_cRet)
            
**********************
User Function SISPAGLT
**********************
/*Atualiza o valor do parâmetro com o próximo Número do Lote.
  Retorna a variável com o valor do Número do Lote.*/
  
Local cSISPGLT := GetMv("MV_SISPGLT")

cSISPGLT := StrZero(Val(cSISPGLT)+1,4)
PutMv("MV_SISPGLT",cSISPGLT)

Return(cSISPGLT)

/*=================================================================================================
Rotina para retornar campos do Código de Barras ou da Linha Digitável para pagamentos de bloquetos.
Onde:
      
+----------------------------------+
|FUNÇÃO   | RETORNA                |
+----------------------------------+
|SISPAG0A | Código do Banco        |
+----------------------------------+
|SISPAG0B | Código da Moeda        |
+----------------------------------+
|SISPAG0C | DV do Código de Barras |
+----------------------------------+
|SISPAG0D | Fator de Vencimento    |
+----------------------------------+
|SISPAG0E | Valor do Título        |
+----------------------------------+
|SISPAG0F | Campo Livre            |
+----------------------------------+

=================================================================================================*/
**********************              
User Function SISPAG0A
**********************
//Busca código do Banco.
Local _cCampo  := _cRet := ""
Local _Posicao := 1

If !Empty(SE2->E2_CODBAR)     		//Pega pelo Cód. Barras
   _cCampo := "E2_CODBAR"
Else								//Caso contrário pega pela Lin. Digitável
   //_cCampo := "E2_XLINDIG"
   MsgAlert("O Código de Barras está inválido. Título ["+NUMTITULO()+"]. Informe novamente.")
Endif
_cRet := SE2->(SUBSTR(&_cCampo,_Posicao,3))
			
Return(_cRet)

**********************
User Function SISPAG0B 
**********************
//Busca código da Moeda.
Local _cCampo  := _cRet := ""
Local _Posicao := 4

If !Empty(SE2->E2_CODBAR)     		//Pega pelo Cód. Barras
   _cCampo := "E2_CODBAR"
Else								//Caso contrário pega pela Lin. Digitável
   //_cCampo := "E2_XLINDIG"
   MsgAlert("O Código de Barras está inválido. Título ["+NUMTITULO()+"]. Informe novamente.")
Endif
_cRet := SE2->(SUBSTR(&_cCampo,_Posicao,1))
			
Return(_cRet)

**********************
User Function SISPAG0C
**********************
//Busca DV do Código de Barras.
Local _cCampo  := _cRet := ""
Local _Posicao := 0

If !Empty(SE2->E2_CODBAR)     		//Pega pelo Cód. Barras
   _Posicao := 5
   _cCampo  := "E2_CODBAR"
Else								//Caso contrário pega pela Lin. Digitável
   //_Posicao := 33
   //_cCampo  := "E2_XLINDIG"
   MsgAlert("O Código de Barras está inválido. Título ["+NUMTITULO()+"]. Informe novamente.")
Endif
_cRet := SE2->(SUBSTR(&_cCampo,_Posicao,1))
			
Return(_cRet)
	
**********************
User Function SISPAG0D
**********************
//Retorna o Fator de Vencimento.
Local _cCampo  := _cRet := ""
Local _Posicao := 0

If !Empty(SE2->E2_CODBAR)     		//Pega pelo Cód. Barras
   _Posicao := 6
   _cCampo  := "E2_CODBAR"
Else								//Caso contrário pega pela Lin. Digitável
   //_Posicao := 34
   //_cCampo  := "E2_XLINDIG"
   MsgAlert("O Código de Barras está inválido. Título ["+NUMTITULO()+"]. Informe novamente.")
Endif
_cRet := SE2->(SUBSTR(&_cCampo,_Posicao,4))
			
Return(_cRet)
                    
**********************
User Function SISPAG0E
**********************
//Retorna o Valor do Título.
Local _cCampo  := _cRet := ""
Local _Posicao := 0

If !Empty(SE2->E2_CODBAR)     		//Pega pelo Cód. Barras
   _Posicao := 10
   _cCampo  := "E2_CODBAR"
Else								//Caso contrário pega pela Lin. Digitável
   //_Posicao := 35
   //_cCampo  := "E2_XLINDIG"
   MsgAlert("O Código de Barras está inválido. Título ["+NUMTITULO()+"]. Informe novamente.")
Endif
_cRet := SE2->(SUBSTR(&_cCampo,_Posicao,10))                                                       
			
Return(_cRet)

**********************
User Function SISPAG0F
**********************
//Retorna Campo Livre.
Local _cCampo := _cRet := ""

If !Empty(SE2->E2_CODBAR)     		//Pega pelo Cód. Barras
   _cCampo := "E2_CODBAR"
   _cRet   := SE2->(SUBSTR(&_cCampo,20,25))
Else								//Caso contrário pega pela Lin. Digitável
   //_cCampo := "E2_XLINDIG"
   //_cRet   := SE2->(SUBSTR(&_cCampo,5,5))
   //_cRet   += SE2->(SUBSTR(&_cCampo,11,10))
   //_cRet   += SE2->(SUBSTR(&_cCampo,22,10))
   MsgAlert("O Código de Barras está inválido. Título ["+NUMTITULO()+"]. Informe novamente.")
Endif
			
Return(_cRet)

**********************
User Function INICIALT  
**********************
//Retorna o parâmetro para o valor inicial.  
Local cSISPGLT := "0000"

PutMv("MV_SISPGLT",cSISPGLT)

Return(cSISPGLT)                                                                                         

**********************
User Function SISPAG03
**********************
//Valor Pagamento.                
Local _TtAbat := _Juros := 0.00

//Funcao SOMAABAT() totaliza todos os titulos com E2_TIPO AB- relacionado ao titulo do parametro.     

_TtAbat := SOMAABAT(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)

//Alterado por Vinicius Figueiredo - Doit Considera o campo E2_XVLBORD onde sera informado o valor a ser enviado ao banco.(20120820)
_VlPar := SE2->E2_XVLBORD

If !Empty(SE2->E2_CODBAR) .And. SubStr(SE2->E2_CODBAR,1,1) # "8"
   _TtAbat += SE2->E2_DESCONT + SE2->E2_DECRESC + SE2->E2_XDEDUZ
   _Juros  := SE2->E2_XMULTA + SE2->E2_VALJUR + SE2->E2_ACRESC + SE2->E2_XACRESC

	//Alterado por Vinicius Figueiredo - Doit Considera o campo E2_XVLBORD onde sera informado o valor a ser enviado ao banco.(20120820)
	//    _Liqui  := (SE2->E2_VALOR - _TtAbat + _Juros)
	If _VlPar == 0 .OR. Empty(_VlPar)
		_VlPar := SE2->E2_VALOR		
	Endif

	_Liqui  := (_VlPar - _TtAbat + _Juros)             
	
Else
   _TtAbat += SE2->E2_DESCONT + SE2->E2_DECRESC
   _Juros  := SE2->E2_XMULTA + SE2->E2_VALJUR + SE2->E2_ACRESC 
   
	//Alterado por Vinicius Figueiredo - Doit Considera o campo E2_XVLBORD onde sera informado o valor a ser enviado ao banco.(20120820)
	//   _Liqui  := (SE2->E2_SALDO - _TtAbat + _Juros) 
	If _VlPar == 0 .OR. Empty(_VlPar)
		_VlPar := SE2->E2_SALDO	
	Endif

	_Liqui  := (_VlPar - _TtAbat + _Juros)             
   
Endif

_cRet   := Left(StrZero((_Liqui*100),15),15)

Return(_cRet) 

**********************
User Function SISPAG33
**********************
//Valor Pagamento.                
Local _TtAbat := _Juros := 0.00

//Funcao SOMAABAT() totaliza todos os titulos com E2_TIPO AB- relacionado ao titulo do parametro. 
_TtAbat := SOMAABAT(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)

If !Empty(SE2->E2_CODBAR) .And. SubStr(SE2->E2_CODBAR,1,1) # "8"
   _TtAbat += SE2->E2_DESCONT + SE2->E2_DECRESC + SE2->E2_XDEDUZ
   _Juros  := SE2->E2_XMULTA + SE2->E2_VALJUR + SE2->E2_ACRESC + SE2->E2_XACRESC

  _Liqui  := (SE2->E2_VALOR - _TtAbat + _Juros)
  
Else

   _TtAbat += SE2->E2_DESCONT + SE2->E2_DECRESC
   _Juros  := SE2->E2_XMULTA + SE2->E2_VALJUR + SE2->E2_ACRESC 
	
    _Liqui  := (SE2->E2_SALDO - _TtAbat + _Juros)    
   
Endif

_cRet   := Left(StrZero((_Liqui*100),15),15)

Return(_cRet)

**********************
User Function SISPAG04
**********************
//Valor Descontos.
//Alterado em 11/01/10 para incluir (-)Outras Deduções no pagto de boletos.
Local _TtAbat := 0.00
   
_TtAbat := SOMAABAT(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)

If !Empty(SE2->E2_CODBAR) .And. SubStr(SE2->E2_CODBAR,1,1) # "8"
   _TtAbat += SE2->E2_DESCONT + SE2->E2_DECRESC + SE2->E2_XDEDUZ
Else
   _TtAbat += SE2->E2_DESCONT + SE2->E2_DECRESC
Endif

_cRet   := Left(StrZero((_TtAbat*100),15),15)

Return(_cRet)

**********************
User Function SISPAG05
**********************
//Valor Acrescimos.
//Alterado em 11/01/10 para incluir (+)Outros Acréscimos no pagto de boletos.           
Local _Juros := 0.00
   
If !Empty(SE2->E2_CODBAR) .And. SubStr(SE2->E2_CODBAR,1,1) # "8"
   _Juros  := SE2->E2_XMULTA + SE2->E2_VALJUR + SE2->E2_ACRESC + SE2->E2_XACRESC
Else
   _Juros  := SE2->E2_XMULTA + SE2->E2_VALJUR + SE2->E2_ACRESC
Endif

_cRet  := Left(StrZero((_Juros*100),15),15)

Return(_cRet)     