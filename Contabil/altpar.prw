#include "rwmake.ch"
#include "topconn.ch"

USER FUNCTION ALTPAR()
LOCAL cUser, oDlg, lDlg
LOCAL dDATAFIS
LOCAL dDATAFIN
LOCAL dDATAEST 
LOCAL dXDBLCTB

BEGIN SEQUENCE
   
   dDATAFIS  := GETMV( "MV_DATAFIS" )
   dDATAFIN  := GETMV( "MV_DATAFIN" )
   dDATAEST  := GETMV( "MV_DBLQMOV" )
   dXDBLCTB  := GETMV( "MV_XDBLCTB" )
   
   @  040, 000  TO  455, 355 DIALOG oDlg TITLE "PARAMETROS DE FECHAMENTO MENSAL"
   @  010, 010  TO  190, 170 
   
   @  025, 015  SAY "MV_DATFIS: " 
   @  035, 060  TO  050, 165
   @  040, 065  SAY "Data encerramento de operações fiscais"
   
   @  070, 015  SAY "MV_DATFIN: "
   @  080, 060  TO  095, 165   
   @  085, 065  SAY "Data limite p/ operaçoes financeiras"
   
   @  115, 015  SAY "MV_DBLQMOV: "
   @  125, 060  TO  140, 165   
   @  130, 065  SAY "Data limite p/ operações nos Estoques"
   
   @  160, 015  SAY "MV_XDBLCTB: "
   @  170, 060  TO  140, 165   
   @  175, 065  SAY "Data limite do calendário contábil"

   @  025, 060  GET dDATAFIS  ;
                    PICTURE "@E";
                    VALID (dDATAFIS >= U_LDOM(U_FDOM(dDATABASE)-3600)) .AND. (dDATAFIS <= dDATABASE) 
   @  070, 060  GET dDATAFIN ;
                    PICTURE "@E";
                    VALID (dDATAFIN >= U_LDOM(U_FDOM(dDATABASE)-3600)) .AND. (dDATAFIN <= dDATABASE)                                         
   @  115, 060  GET dDATAEST ;
                    PICTURE "@E";
                    VALID (dDATAEST >= U_LDOM(U_FDOM(dDATABASE)-3600)) .AND. (dDATAEST <= dDATABASE)                                         
                           
   @  160, 060  GET dXDBLCTB ;
                    PICTURE "@E";
                    VALID (dXDBLCTB >= U_LDOM(U_FDOM(dDATABASE)-3600)) .AND. (dXDBLCTB <= dDATABASE)                                         

   @  195, 070 BMPBUTTON TYPE 1 ACTION ( OK(dDATAFIS, dDATAFIN, dDATAEST, dXDBLCTB), Close(oDlg) )
   @  195, 115 BMPBUTTON TYPE 2 ACTION ( Close(oDlg) )
   ACTIVATE DIALOG oDlg CENTERED  
END

RETURN NIL

***********************************************************
STATIC FUNCTION OK( dDATAFIS, dDATAFIN, dDATAEST, dXDBLCTB)
***********************************************************
PUTMV( "MV_DATAFIS", dDATAFIS )
PUTMV( "MV_DATAFIN", dDATAFIN )
PUTMV( "MV_DBLQMOV", dDATAEST )
PUTMV( "MV_XDBLCTB", dXDBLCTB )

RETURN NIL
   

/**********
*
*   FDOW() -> Retorna o primeiro dia util da semana (SEGUNDA)
*   --------    
*/
USER FUNCTION FDOW( dDate )
LOCAL dReturn

dReturn := CTOD( " " )

BEGIN SEQUENCE
   IF dDate = NIL .OR. ValType(dDate) != "D" .OR. EMPTY( dDate )
      BREAK
   ENDIF  
   DO CASE
   CASE DOW(dDate) = 2   //segunda
      dReturn := dDate
   CASE DOW(dDate) = 3   //terça
      dReturn := dDate - 1
   CASE DOW(dDate) = 4   //Quarta
      dReturn := dDate - 2
   CASE DOW(dDate) = 5   //Quinta
      dReturn := dDate - 3
   CASE DOW(dDate) = 6   //Sexta
      dReturn := dDate - 4
   CASE DOW(dDate) = 7   //Sabado
      dReturn := dDate - 5
   CASE DOW(dDate) = 1   //Domingo
      dReturn := dDate - 6      
   ENDCASE
END SEQUENCE      
*
RETURN dReturn
**                                        
/**********
*
*   FDOM() -> Retorna a data do primeiro dia do mes
*   ------    
*/
USER FUNCTION FDOM( dDate )
LOCAL dReturn

IF dDate = NIL .OR. ValType(dDate) != "D" .OR. EMPTY( dDate )
   dReturn := CTOD( " " )
ELSE
   dReturn := (dDate - DAY(dDate)+1)
ENDIF

RETURN dReturn


/**********
*
*   LDOM() -> Retorna a data do ultimo dia do mes
*   ------    
*/
USER FUNCTION LDOM( dDate )
LOCAL dReturn

IF dDate = NIL .OR. ValType(dDate) != "D" .OR. EMPTY( dDate )
   dReturn := CTOD( " " )
ELSE
   dReturn := (U_FDNM(dDate) - 1)
ENDIF

RETURN dReturn

                                                

/**********
*
*   FDNM() -> Retorna a data do Primeiro dia do próximo mes
*   ------    
*/
USER FUNCTION FDNM( dDate )
LOCAL nAno, nMes, cDateFormat, dReturn := CTOD( " " )

BEGIN SEQUENCE
   IF dDate = NIL .OR. ValType(dDate) != "D" .OR. EMPTY( dDate )
      BREAK 
   ENDIF
   //Salva o formato da data antes, ajustando-a p/ BRITISH
   cDateFormat := SET( _SET_DATEFORMAT, "dd/mm/yyyy" )
   nAno :=  YEAR(dDate)
   nMes :=  MONTH(dDate)+1
   IF nMes=13
      ++nAno
      nMes := 1
   ENDIF
   dReturn := CTOD(  "01/"+STR(nMes,2)+"/"+ LTRIM(STR(nAno))  )
   //Restaura o formato da data
   SET( _SET_DATEFORMAT, cDateFormat )
END SEQUENCE

RETURN dReturn
