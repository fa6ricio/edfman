//Desfazer Riex

#include 'rwmake.ch'
#include "protheus.ch"
#include "TOPCONN.ch"
#include "Fileio.ch"

User function DesFazRiex
Private cPerg       := "Riex02"     

ValidPerg()
If pergunte(cPerg,.T.)
   dbselectarea("SZU")
   DBSETORDER(1)
   IF DBSEEK( xFILIAL("SZU")+ALLTRIM(mv_par01) )
      Do While !SZU->(EOF()) .AND. SZU->ZU_NOTA=mv_par01
         dbSelectArea("SD1")
         dbSetorder(1) 
             //  D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM                                                                                                     
         If DBSEEK( xFILIAL("SD1")+SZU->ZU_NFR+SZU->ZU_SRREM+SZU->ZU_FORNECE+SZU->ZU_LOJA+SZU->ZU_PRODUTO+SZU->ZU_ITEM )
            RecLock("SD1",.F.)
            SD1->D1_SDUTIL-=SZU->ZU_QTDUTZ
            SD1->D1_NFRIEX:=""
		    MsUnlock()
         ENDIF
         dbselectarea("SZU")
         RecLock("SZU",.F.)
  		 SZU->(dbDelete())
		 MsUnlock()
         SZU->(dbSkip())
      EndDo
   ENDIF
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
PutSx1(cPerg,"01","Nota de Venda?","","","mv_ch1","C",09,0,0,"G","","","","","mv_par01")   
Return .T.                                                                                         
