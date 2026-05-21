User Function LP531025

Local _aArea := GetArea()
Local _nRet  := 0

_nRet := IF(SE5->E5_VLCORRE>0 .AND. SE2->E2_PREFIXO="EFF".AND. !EMPTY(SE2->E2_TXMDCOR), (((SE5->E5_VLMOED2*(SE5->E5_VALOR/SE5->E5_VLMOED2))-(SE5->E5_VLMOED2*SE2->E2_XDOLAR))),0)                                                                                                                  

If(_nRet < 0)
   _nRet := _nRet * -1
EndIf

RestArea(_aArea)

Return(_nRet)