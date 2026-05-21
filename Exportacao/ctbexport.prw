#include "protheus.ch"
#include "topconn.ch"

User Function CtbExport(cPEvento)
                          
Local cEvento := Upper(Alltrim(cPEvento))
Local xVal := 0

Begin Sequence          
   Do Case
      Case cEvento = "DEB_EMBARQUE" // Retornar a conta debito no momento do embarque
         xVal := "216010001"  //Posicione("SB1",1,xFilial("SB1")+EE9->EE9_COD_I,"B1_ZCTA_P")

      Case cEvento = "CRE_EMBARQUE" // Retornar a conta crédito no momento do embarque
      
         xVal := ""
         SD2->(dbSetOrder(3))
         IF SD2->(dbSeek(xFilial()+SE1->E1_NUM+SE1->E1_PREFIXO))
            xVal := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_CONTA_R")
         Endif

      Case cEvento = "EMBARQUE"     
         IF u_IsCtbExport("EMBARQUE")
            xVal := SE1->E1_VLCRUZ
         Else
            xVal := 0
         Endif
      
      Case cEvento = "EST_EMBARQUE"   
         IF u_IsCtbExport("EMBARQUE")
            xVal := SE1->E1_VLCRUZ
         Else
            xVal := 0
         Endif

      Case cEvento = "CAMBIO"
         IF u_IsCtbExport("CAMBIO")
            u_PosEEC(SE1->E1_NUM)  
            if EEQ->EEQ_FI_TOT <> "S"
               xVal := SE5->E5_VALOR //-SE5->E5_VLCORRE
            Else
            xVal := 0 
            endif
         Endif 
         
         Case cEvento = "EFF"
         IF u_IsCtbExport("CAMBIO")
            u_PosEEC(SE1->E1_NUM)  
            if EEQ->EEQ_FI_TOT == "S" 
              xVal := SE5->E5_VALOR //-SE5->E5_VLCORRE
            Else
            xVal := 0 
            endif
         Endif 
         
      
      Case cEvento = "EST_CAMBIO"   
         IF u_IsCtbExport("CAMBIO")
            u_PosEEC(SE1->E1_NUM)
            xVal := SE5->E5_VALOR //-SE5->E5_VLCORRE
         Else
            xVal := 0
         Endif
         
   End case   
   
End Sequence

Return xVal

/*----------------------------------------------------------------
 Identifica se é uma contabilização de embarque de exportação.
 Utilizar nos Lançamentos Padrão: 
 FASE = EMBARQUE
 520 - Baixa de titulo  (efetivação do embarque)
 527 - Estorno da baixa (cancelamento do embarque)
 
 FASE = CAMBIO
 520 - Baixa de titulo
----------------------------------------------------------------
*/
User Function IsCtbExport(cPFase)
Local lRet := .F.     
Local cFase := Upper(Alltrim(cPFase))
Local cRotina := Upper(Alltrim(FunName()))
Local aOrd := SaveOrd({"SD2","SC5"})                                   
Local lEEC := .F.

Begin Sequence                      
   SD2->(dbSetOrder(3))
   IF SD2->(dbSeek(SE1->(E1_FILORIG+E1_NUM+E1_SERIE)))
      SC5->(dbSetOrder(1))
      IF SC5->(dbSeek(xFilial()+SD2->D2_PEDIDO))
         IF !Empty(SC5->C5_PEDEXP)
            lEEC := .T.
         Endif
      Endif
   Endif   
   
   Do Case
      Case cFase == "EMBARQUE"
         lRet := (lEEC .And. SE1->E1_PREFIXO <> "EEC")
         /*
         IF cRotina == "EECAE100"  // Type("dDtEmba") == "D"
            lRet := .T.       
         Endif
         */
         
      Case cFase == "CAMBIO"
         lRet := Alltrim(SE1->E1_PREFIXO) == "EEC"
         /*
         IF cRotina $ "EECAF200/EECAF300" 
            lRet := .T.       
         Endif
         */

   Otherwise
      IF u_IsCtbExport("EMBARQUE") .Or. u_IsCtbExport("CAMBIO")
         lRet := .T.
      Endif

   EndCase

End Sequence

RestOrd(aOrd,.T.)

Return lRet

//------------------------------------------------------
User Function PosEEC(cNum)

Local lRet   := .F.
//Local cQry   := "SELECT TOP 1 EEQ_PREEMB FROM %EEQ% WHERE D_E_L_E_T_ = ' ' AND EEQ_FINNUM = '%EEQ_FINNUM%' " //Alterado por Milton(erro na contabilizacao)
Local nVal := alltrim(Str(SE5->E5_VLMOED2))
Local cQry   := "SELECT TOP 1 EEQ_PREEMB, R_E_C_N_O_ AS WK_REC FROM "+RetSqlName("EEQ")+" WHERE D_E_L_E_T_ = ' ' AND EEQ_FINNUM = '%EEQ_FINNUM%' AND EEQ_VL = " + nVal 
//Local cQry   := "SELECT TOP 1 EEQ_PREEMB, R_E_C_N_O_ AS WK_REC FROM "+RetSqlName("EEQ")+" WHERE D_E_L_E_T_ = ' ' AND EEQ_FINNUM = '%EEQ_FINNUM%' "
Local cAlias := GetNextAlias()

Begin Sequence                
   cQry := StrTran(cQry,"%EEQ_FINNUM%",cNum)   
   TcQuery cQry Alias (cAlias) New
   
   IF !Empty((cAlias)->EEQ_PREEMB)
      IF EEC->(dbSeek(xFilial()+(cAlias)->EEQ_PREEMB))
         lRet := .T.
      Endif
      
      IF (cAlias)->WK_REC > 0
         EEQ->(dbGoTo((cAlias)->WK_REC))
      Endif
   Endif
   
   (cAlias)->(dbCloseArea())

End Sequence

Return lRet
