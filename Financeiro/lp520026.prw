User Function LP520026

Local _aArea := GetArea() 
Local _nRet := 0

//_nRet := IF((FORMULA("TXB")+FORMULA("TXC")*-1)>0 .AND. SE1->E1_PREFIXO="EEC" .AND. SE1->E1_MOEDA=2 , ((SE5->E5_VLMOED2*FORMULA("L52"))-(SE5->E5_VLMOED2*SE1->E1_TXMOED2)),0)                                                                                                                                                                                              
_nRet := IF((FORMULA("TXB")+FORMULA("TXC")*-1)>0 .AND. SE1->E1_PREFIXO="EEC" .AND. SE1->E1_MOEDA=2 , ((SE5->E5_VLMOED2*FORMULA("L52"))-(SE5->E5_VLMOED2*SE1->E1_XDOLAR)),0)                                                                                                                                                                                              
  
                        
If(_nRet < 0)
   _nRet := _nRet * -1
EndIf                  
                                                
RestArea(_aArea)
                                                 
Return(_nRet)

                                                       