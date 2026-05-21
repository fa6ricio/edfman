#include "Protheus.ch"
#include "TopConn.ch"
#include "TbiConn.ch"
#include "rwmake.ch"
                                                                     
#DEFINE ABANDONA					

#IFNDEF WINDOWS
	#DEFINE PSay Say
#ENDIF

/*                                                                       
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    : EDFR001  ³ Autor : Vagner Almeida       ³ Data : 08/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ RELATÓRIO DE ACOMPANHAMENTO DAS NF´S ENTRADA                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EDFR001()

CriaSx1()

Private lCtb       	:= CtbInUse()
Private cString    	:= "SZD"
Private wnrel      	:= "EDFR001"
Private aOrd       	:= {"Usina","Contrato","Periodo","NF Mae","Remessa"}
Private CbTxt     	:= ""
Private cDesc1     	:= "Relatorio de Acompanhamento das NF´S de Entrada"
Private cDesc2     	:= ""
Private Tamanho    	:= "G"
Private aReturn    	:= { "Zebrado", 1,"Relatorio de Acompanhamento das NF´S de Entrada", 2, 2, 1, "",1 }
Private nLastKey   	:= 0
Private cPerg      	:= "EDFR001"
Private cRodaTxt   	:= ""
Private nCntImpr   	:= 0
Private nTipo      	:= 0
Private nomeprog   	:= "EDFR001"
Private cCondicao  	:= ""
Private m_pag      	:= 01
Private wnrel      	:="EDFR001"
Private _nlin      	:= 70
Private Cabec1     	:= " "
Private Cabec2     	:= " "
Private aCond      	:= {}

Pergunte(cPerg,.T.)

If LastKey() == 27
	Return
Endif

Private Titulo := "Relatorio de Acompanhamento das NF´S de Entrada"

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,"",.F.,aOrd)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Cabec1 := "Usina                          Contrato        Periodo    NF Mae           Qtd. Total NF Remessa    Parc Dt.Entrada   Qtd.Remessa  Qtd.Recebida         Saldo NF Devol          Qtd. Dev. Terminal          Placa    Pedido"

Cabec2 := ""

#IFDEF WINDOWS
	RptStatus({|| CriaArq()})
	Return
#ELSE
    If mv_par01 > mv_par02
       Aviso( "Data Até Menor que Data De")
    Else
	   CriaArq()
#ENDIF

*************************
Static Function CriaArq()
*************************

Local cEnt      := CHR(13)+CHR(10)
Local cAuxUsi   := ""
Local cAuxNFM   := ""
Local cAuxRem   := ""
Local cAuxCnt   := ""
Local cAuxPer   := ""
Local dDtAux    := 0
Local nAcRRem   := 0.00
Local nAcRRec   := 0.00
Local nAcMRem   := 0.00
Local nAcMRec   := 0.00
Local nAcPRem   := 0.00
Local nAcPRec   := 0.00
Local nAcCRem   := 0.00
Local nAcCRec   := 0.00
Local nAcURem   := 0.00
Local nAcURec   := 0.00                    
Local nNumCnt   := 0
Local nNumPer   := 0
Local nNumMae   := 0
Local nNumRes   := 0

cQuery := " SELECT ZD_FILIAL, ZD_NUSINA, ZD_NFMAE, ZD_CONTRA, ZD_PERIODO, ZD_QTDMAE, ZD_NFREMES, ZD_PARC, ZD_DTTERMI, " + cEnt
cQuery += " ZD_DTETERM, ZD_QTDNFRE, ZD_QTDREC, ZD_QTDDEV, ZD_PLACA, ZD_PEDIDOC, ZD_CNPJUSI, ZD_SALDO, ZD_NFDEVOL,  " + cEnt
cQuery += " ZD_SERIEM,  ZD_SERIER, ZD_SERIEDV, ZD_NOMETER, ZD_NOMETEI " + cEnt
cQuery += " FROM " + RetSqlName("SZD") + " SZD " + cEnt
cQuery += " WHERE ZD_FILIAL = '" + xFilial("SZD") +"'"+ cEnt

IF Empty(ZD_CNPJUSI)
    cQuery += " AND ZD_DTTERMI  >= '" + dtos(mv_par01) + "'" + cEnt
    cQuery += " AND ZD_DTTERMI  <= '" + dtos(mv_par02) + "'" + cEnt
Else
    cQuery += " AND ZD_DTETERM  >= '" + dtos(mv_par01) + "'" + cEnt
    cQuery += " AND ZD_DTETERM  <= '" + dtos(mv_par02) + "'" + cEnt
EndIf    

IF !Empty(mv_par03)
   cQuery += " AND ZD_STATUS   = '" + mv_par03 + "'" + cEnt
EndIf

IF !Empty(mv_par04)
   cQuery += " AND ZD_CNPJTER  = '" + mv_par04 + "'" + cEnt
EndIf

IF !Empty(mv_par05)
   cQuery += " AND ZD_SEQTEMP  = '" + mv_par05 + "'" + cEnt
EndIf

IF mv_par06 = "Sim"
   cQuery += " AND ZD_SALDO  > 0" + cEnt
EndIf

IF mv_par07 = "Sim"
   cQuery += " AND ZD_NFDEVOL != 0" + cEnt
EndIf

IF !Empty(mv_par08)
   cQuery += " AND ZD_NFMAE    = '" + mv_par03 + "'" + cEnt
EndIf

/*
Confirmar critérios para filtro

"NF´s a Vender em Dias ?" ,""

IF !Empty(mv_par09)
   cQuery += " AND = mv_par09" + cEnt
EndIf
*/

IF !Empty(mv_par10)
   cQuery += " AND ZD_CNPJUSI = '" + mv_par10 + "'" + cEnt
EndIf

IF !Empty(mv_par11)
   cQuery += " AND ZD_CONTRA  = '" + mv_par11 + "'" + cEnt
EndIf

IF !Empty(mv_par12)
   cQuery += " AND ZD_PEDIDOC  = '" + mv_par12 + "'" + cEnt
EndIf

IF !Empty(mv_par13)
   cQuery += " AND ZD_NUSINA  Like '" + mv_par13 + "'" + cEnt
EndIf

IF !Empty(mv_par14)
   cQuery += " AND ZD_CNPJTEI  = '" + mv_par14 + "'" + cEnt
EndIf

cQuery += " AND D_E_L_E_T_ = ''" + cEnt
cQuery += "ORDER BY ZD_NUSINA, ZD_CONTRA, ZD_PERIODO, ZD_NFMAE, ZD_NFREMES, ZD_PARC"+ cEnt

Memowrite("c:\TR1.txt",cQuery)

DbUseArea(.t., "TOPCONN", TcGenqry(,,cQuery), "TR1", .f., .t.)

_nlin    := 60

DbSelectArea("TR1")
SetRegua(Reccount())

If Eof()
	Aviso( "Atenção", "Não existem dados para a impressão do relatório ! Favor rever os parâmetros." , { "Voltar" } )
EndIf

While !Eof()
	
	If lAbortPrint
		@ nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	If _nlin > 57
	     Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	    _nlin := 8
	EndIf

    cAuxUsi := TR1->ZD_NUSINA
    nAcURem := 0.00
    nAcURec := 0.00


    @ _nLin, 001 Psay TR1->ZD_NUSINA

    While !Eof() .and. cAuxUsi = TR1->ZD_NUSINA

        nAcCRem   := 0.00
        nAcCRec   := 0.00
        nNumCnt   := 0
        cAuxCnt   := TR1->ZD_CONTRA

        @ _nLin, 032 Psay TR1->ZD_CONTRA
        While !Eof() .and. cAuxUsi = TR1->ZD_NUSINA .and. cAuxCnt = TR1->ZD_CONTRA

            cAuxPer   := TR1->ZD_PERIODO
            nAcPRem   := 0.00
            nAcPRec   := 0.00
            nNumCnt   += 1
            nNumPer   := 0

            @ _nLin, 048 Psay TR1->ZD_PERIODO
            
            While !Eof() .and. cAuxUsi = TR1->ZD_NUSINA .and. cAuxCnt = TR1->ZD_CONTRA .and. cAuxPer = TR1->ZD_PERIODO

                cAuxNFM   := TR1->ZD_NFMAE
                nAcMRem   := 0.00
                nAcMRec   := 0.00
                nNumMae   := 0
                nNumPer   += 1

                @ _nLin, 059 Psay (TR1->ZD_NFMAE+'-'+AllTrim(ZD_SERIEM))
                @ _nLin, 073 Psay TR1->ZD_QTDMAE  		    Picture "@e 9,999,999.999"

                While !Eof() .and. cAuxUsi = TR1->ZD_NUSINA .and. cAuxCnt = TR1->ZD_CONTRA .and. cAuxPer = TR1->ZD_PERIODO .and. cAuxNFM = TR1->ZD_NFMAE
      
                    cAuxRes         := TR1->ZD_NFREMES
                    nNumRes         := 0
                    nNumMae         += 1
                    nAcRRem         := 0.00
                    nAcRRec         := 0.00

                    @ _nLin, 087 Psay TR1->ZD_NFREMES

                    While !Eof() .and. cAuxUsi = TR1->ZD_NUSINA .and. cAuxCnt = TR1->ZD_CONTRA .and. cAuxPer = TR1->ZD_PERIODO .and. cAuxNFM = TR1->ZD_NFMAE .and. cAuxRes = TR1->ZD_NFREMES

                        nNumRes  += 1
                        nAcRRec  += TR1->ZD_QTDREC

	                    IncRegua()
	
	                    If _nlin > 57
		                   Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		                   _nlin := 8

                           //   Imprime Informações da Usina, Nota Mae e Remessa
            
                           @ _nLin, 001 Psay TR1->ZD_NUSINA
                           @ _nLin, 032 Psay TR1->ZD_CONTRA
                           @ _nLin, 048 Psay TR1->ZD_PERIODO
                           @ _nLin, 059 Psay (TR1->ZD_NFMAE+'-'+AllTrim(ZD_SERIEM))
                           @ _nLin, 073 Psay TR1->ZD_QTDMAE  		    Picture "@e 9,999,999.999"
                           @ _nLin, 087 Psay (TR1->ZD_NFREMES+'-'+AllTrim(ZD_SERIER))
	                    EndIf
	      
	                    @ _nLin, 102 Psay TR1->ZD_PARC
          											
                        IF Empty(ZD_CNPJUSI)
                           @ _nLin, 107 Psay STOD(TR1->ZD_DTTERMI)	Picture "@d"
                           dDtAux := TR1->ZD_DTTERMI
                        Else
                           @ _nLin, 107 Psay STOD(TR1->ZD_DTETERM)  Picture "@d"
                           dDtAux := TR1->ZD_DTETERM
                        EndIf    
                        
                        If ZD_PARC = "01" // Imprime Quantidade Remessa Apenas para primeira Parcela
                           nAcRRem  += TR1->ZD_QTDNFRE // Só acumula a quantidade da remessa para a primeira parcela
                           @ _nLin, 117 Psay TR1->ZD_QTDNFRE        Picture "@e 9,999,999.999"
                        EndIf
                           
                        @ _nLin, 131 Psay TR1->ZD_QTDREC			Picture "@e 9,999,999.999"
                        @ _nLin, 145 Psay TR1->ZD_SALDO		     	Picture "@e 9,999,999.999"
                        If !Empty(TR1->ZD_NFDEVOL)
                           @ _nLin, 159 Psay (TR1->ZD_NFDEVOL+'-'+AllTrim(ZD_SERIEDV))
                        EndIf
                        
                        @ _nLin, 173 Psay TR1->ZD_QTDDEV				Picture "@e 9,999,999.999"
          
                        IF Empty(ZD_CNPJUSI)
                           @ _nLin, 187 Psay TR1->ZD_NOMETER
                        Else                                 
                           @ _nLin, 187 Psay TR1->ZD_NOMETEI
                        EndIf                                
          
                        @ _nLin, 205 Psay TR1->ZD_PLACA              
                        @ _nLin, 214 Psay TR1->ZD_PEDIDOC
                        
                        _nLin := _nLin + 1																		    
																	     
	                    DbSelectArea("TR1")
	                    DbSkip()
	         
	                EndDo
                        
                        //      Totaliza Remessas     //

                        nAcMRem         += nAcRRem
                        nAcMRec         += nAcRRec
          
                        if nNumRes  > 1
                           @ _nLin, 117 Psay nAcRRem            Picture "@e 9,999,999.999"
                           @ _nLin, 131 Psay nAcRRec            Picture "@e 9,999,999.999"
                           _nLin := _nLin + 1																		    

                           @ _nLin, 001 Psay Replicate(" ",220)
                           _nLin := _nLin + 1																		    
                        
                        EndIf
                        
	            EndDo
                    
                    //         Totaliza Nota Mae          //
                    
                    nAcPRem         += nAcMRem
                    nAcPRec         += nAcMRec
          
                    if nNumMae  > 1  // Imprime Total da Nota Mae se houver mais de Uma //
                       @ _nLin, 001 Psay Replicate(" ",220)
                       _nLin := _nLin + 1																		    
                    
                       @ _nLin, 117 Psay nAcMRem            Picture "@e 9,999,999.999"
                       @ _nLin, 131 Psay nAcMRec            Picture "@e 9,999,999.999"
                      _nLin := _nLin + 1																		    
                    EndIf
                    
	        EndDo

                //    Totaliza Periodo    //
                
                nAcCRem        += nAcPRem
                nAcCRec        += nAcPRec
                
                if nNumPer > 1
                   @ _nLin, 001 Psay Replicate(" ",220)
                   _nLin := _nLin + 1																		    

                   @ _nLin, 117 Psay nAcPRem            Picture "@e 9,999,999.999"
                   @ _nLin, 131 Psay nAcPRec            Picture "@e 9,999,999.999"
                   _nLin := _nLin + 1
                EndIf   
        EndDo
 
            //     Totaliza Contrato       //

            nAcURem  += nAcCRem
            nAcURec  += nAcCRec

            if nNumCnt > 1
               @ _nLin, 001 Psay Replicate(" ",220)
               _nLin := _nLin + 1																		    

               @ _nLin, 117 Psay nAcCRem             Picture "@e 9,999,999.999"
               @ _nLin, 131 Psay nAcCRec             Picture "@e 9,999,999.999"
               _nLin := _nLin + 1
            EndIf   
    EndDo          

        //        Totaliza Usina          //
        
            if !(nAcURem = nAcCRem .and. nAcURec = nAcCRec)
               @ _nLin, 001 Psay Replicate(" ",220)
               _nLin := _nLin + 1																		    

               @ _nLin, 117 Psay nAcURem             Picture "@e 9,999,999.999"
               @ _nLin, 131 Psay nAcURec             Picture "@e 9,999,999.999"
               _nLin := _nLin + 1																		    
            EndIf
            
        @ _nLin, 001 Psay  Replicate("-",220)
        _nLin := _nLin + 1																		    
        
EndDo

Tr1->(DbClosearea())

Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

*************************
Static Function CriaSX1()
*************************

/*aSx1 := {}

//         1           2      3                           4                           5                           6          7     8    9   10  11    12   13           14      15      16      17   18   19      20      21      22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38      39   40  41  42  43
AADD(aSx1,{"EDFR001" , "01" , "Data De               ?" , "Data De               ?" , "Data De               ?" , "mv_ch1" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par01" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "02" , "Data Ate              ?" , "Data Ate              ?" , "Data Ate              ?" , "mv_ch2" , "D" , 08 , 0 , 0 , "G" , "" , "mv_par02" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "03" , "Status                ?" , "Status                ?" , "Status                ?" , "mv_ch3" , "C" , 02 , 0 , 0 , "G" , "" , "mv_par03" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "04" , "CNPJ Terminal         ?" , "CNPJ Terminal         ?" , "CNPJ Terminal         ?" , "mv_ch4" , "C" , 14 , 0 , 0 , "G" , "" , "mv_par04" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZE" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "05" , "Template              ?" , "Template              ?" , "Template              ?" , "mv_ch5" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par05" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "06" , "NF´s com Saldo        ?" , "NF´s com Saldo        ?" , "NF´s com Saldo        ?" , "mv_ch6" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par06" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "07" , "NF´s Devolvidas       ?" , "NF´s Devolvidas       ?" , "NF´s Devolvidas       ?" , "mv_ch7" , "C" , 01 , 0 , 0 , "G" , "" , "mv_par07" , "Sim" , "Sim" , "Sim" , "" , "" , "Nao" , "Nao" , "Nao" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "08" , "NF Mãe                ?" , "NF Mãe                ?" , "NF Mãe                ?" , "mv_ch8" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par08" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "09" , "NF´s a Vencer em Dias ?" , "NF´s a Vencer em Dias ?" , "NF´s a Vencer em Dias ?" , "mv_ch9" , "C" , 09 , 0 , 0 , "G" , "" , "mv_par09" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "10" , "CNPJ Usina            ?" , "CNPJ Usina            ?" , "CNPJ Usina            ?" , "mv_cha" , "C" , 14 , 0 , 0 , "G" , "" , "mv_par10" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SA2" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "11" , "Contrato              ?" , "Contrato              ?" , "Contrato              ?" , "mv_chb" , "C" , 25 , 0 , 0 , "G" , "" , "mv_par11" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "CN9" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "12" , "Pedido de Compras     ?" , "Pedido de Compras     ?" , "Pedido de Compras     ?" , "mv_chc" , "C" , 06 , 0 , 0 , "G" , "" , "mv_par12" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SC7" , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "13" , "Parte Nome Usina      ?" , "Parte Nome Usina      ?" , "Parte Nome Usina      ?" , "mv_chd" , "C" , 14 , 0 , 0 , "G" , "" , "mv_par13" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""    , "" , "", "", "", ""})
AADD(aSx1,{"EDFR001" , "14" , "CNPJ Terminal Interior?" , "CNPJ Terminal Interior?" , "CNPJ Terminal Interior?" , "mv_che" , "C" , 14 , 0 , 0 , "G" , "" , "mv_par14" , ""    , ""    , ""    , "" , "" , ""    , ""    , ""    , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "SZE" , "" , "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek("EDFR001   14")
	
	DbSeek("EDFR001")
	
	While !Eof() .And. Alltrim(SX1->X1_GRUPO) == "EDFR001"
		Reclock("SX1",.F.,.F.)
		DbDelete()
		MsunLock()
		DbSkip()
	End
	
	For X1:=1 to Len(aSX1)
		RecLock("SX1",.T.)
		For Z:=1 To FCount()
			FieldPut(Z,aSx1[X1,Z])
		Next
		MsunLock()
	Next
	
Endif*/

Return

/*                                   
LAY-OUT

                                                                                                            
Usina                          Contrato        Periodo    NF Mae           Qtd. Total NF Remessa    Parc Dt.Entrada   Qtd.Remessa  Qtd.Recebida         Saldo NF Devol          Qtd. Dev. Terminal          Placa    Pedido
123456789-123456789-123456789- 123456789-12345 123456789- 123456789-123 9,999,999.999 123456789-123  01   99/99/99  9,999,999.999 9,999,999.999 9,999,999.999 999999999-999 9,999,999.999 12345678901234567 xxx-9999 999999
1                     23         34                                        76         87                         114                        141                        168                        195
123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789
000000000111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111
         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210
*/
