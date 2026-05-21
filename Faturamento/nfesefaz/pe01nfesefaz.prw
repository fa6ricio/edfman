#include "rwmake.ch"
#Include "TopConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE01NFESEFAZºAutor  ³YTTALO P MARTINS  º Data ³  18/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE UTILIZADO NO NFESEFAZ                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³ Luis Felipe Nascimento                º Data ³  26/05/17   º±±
±±º          ³ Adicionados os paramixb[13] e paramixb[14]                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PE01NFESEFAZ

Local aParam    := {}
Local aProd     := paramixb[1]
Local cMensCli  := paramixb[2]
Local cMensFis  := paramixb[3]
Local aDest     := paramixb[4]
Local aNota     := paramixb[5]
Local aInfoItem := paramixb[6]
Local aDupl     := paramixb[7]
Local aTransp   := paramixb[8]
Local aEntrega  := paramixb[9]
Local aRetirada := paramixb[10]
Local aVeiculo  := paramixb[11]
Local aReboque  := paramixb[12]
Local aNfVincRur:= paramixb[13]
Local aEspVol   := paramixb[14]
Local aNfVinc   := paramixb[15]
Local aDetPag   := paramixb[16]
Local aObsCont  := paramixb[17]

Local cTipo     := aNota [4]
Local cNota     := aNota [2]
Local cSerie    := aNota [1]
Local cprod
Local citem
Local ctes
Local cest      := SuperGetmv("MV_ESTADO")
Local xC5Menot  := ""
Local xnLinhas  := ""
Local xMemo     := ""
Local cQuery := ""

LOCAL xGrpDesc  := GetNewPar("MV_XGRPDES","001/002/003/004")

If cTipo == "1"   //  nota Fiscal de Saida
	
	For xnj := 1 To Len(aInfoItem)
		
		DBSELECTAREA("SC5")
		SC5->(dbSetOrder(1))
		SC5->(DBSeek( xFilial("SC5")+ aInfoItem[xnj][1] ))
		
		xC5Menot := SC5->C5_XMENNOT
		xnLinhas := MlCount(xC5Menot,105)
		For xni := 1 To xnLinhas
			
			xMemo := MemoLine(xC5Menot,105,xni)
			xMemo := STRTRAN(xMemo,Chr(13),"")
			
			If !AllTrim(xMemo) $ cMensCli
				
				If Len(cMensCli) > 0 .And. SubStr(cMensCli, Len(cMensCli), 1) <> " "
					cMensCli += " "
				EndIf
				
				cMensCli += AllTrim(xMemo)
				
			EndIF
			
		Next xni
		
		For xni := 1 To LEN(aProd)
			
			DBSELECTAREA("SB1")
			SB1->(dbSetOrder(1))
			IF SB1->(DBSeek( xFilial("SB1")+ aProd[xni][2] ))
				
				IF !EMPTY(SB1->B1_GRUPO)
					
					DBSELECTAREA("SBM")
					SBM->(dbSetOrder(1))
					IF SBM->(DBSeek( xFilial("SBM")+ SB1->B1_GRUPO ))
						
						IF !EMPTY(SBM->BM_DESC)
							
							IF ALLTRIM(SBM->BM_GRUPO) $ xGrpDesc
								aProd[xni][4] := SBM->BM_DESC
							ENDIF
							
						ENDIF
						
					ENDIF
					
				ENDIF
				
			ENDIF
			
		Next xni
		
		
	Next xnj
	
ElseIf cTipo == "2"   // nota fiscal de entrada
	
	
Endif


aadd ( aParam  ,  aProd     )
aadd ( aParam  ,  cMensCli  )
aadd ( aParam  ,  cMensFis  )
aadd ( aParam  ,  aDest     )
aadd ( aParam  ,  aNota     )
aadd ( aParam  ,  aInfoItem )
aadd ( aParam  ,  aDupl     )
aadd ( aParam  ,  aTransp   )
aadd ( aParam  ,  aEntrega  )
aadd ( aParam  ,  aRetirada )
aadd ( aParam  ,  aVeiculo  )
aadd ( aParam  ,  aReboque  )
aadd ( aParam  ,  aNfVincRur)
aadd ( aParam  ,  aEspVol   )
aadd ( aParam  ,  aNfVinc   )
aadd ( aParam  ,  aDetPag   )
aadd ( aParam  ,  aObsCont  )

Return aParam
