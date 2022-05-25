*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

   MOVE.L #$AAAA8888, D2
   *LETS say hexadecimal is stored in d2
   
   *this program uses A6, A5, A1
   
   
   *code starts HERE:
   MOVE.B #0, LoopVar1

   *since 0 - 1000 is free, use that as memory
   LEA $400, A1
   LEA $200, A5
   MOVE.L D2, (A5)
   LEA $300, A6
FOR CMP.B #4, LoopVar1
    BEQ NEXT
    CLR D7
    MOVE.B (A5), D7
    LSR.W #4, D7
    MOVE.B D7, (A6)+    
  
    MOVE.B (A5), (A6)
    SUBA.L #1, A6
    
    AND.B #$0F, (A6)+ 
    AND.B #$0F, (A6)
    
 
    ADDA.L #1, A5
    ADDA.L #1, A6
    
    ADDI.B #1, LoopVar1
    BRA FOR
NEXT MOVE.B #0, LoopVar1
     LEA $300, A6
     BRA N1
N1  CMP.B #8, LoopVar1
    BEQ ED
    CMP.B #9, (A6)
    BGT LETTER
    BRA NUMBER
    
LETTER 
    ADDI.B #55, (A6)+
    ADDI.B #1, LoopVar1
    BRA N1

NUMBER 
    ADDI.B #48, (A6)+
    ADDI.B #1, LoopVar1
    BRA N1
ED  LEA $300, A6
    MOVE.L (A6)+, (A1)+
    MOVE.L (A6), (A1)
    LEA $400, A1
    MOVE.L #8, D1
    MOVE.B #1, D0
    TRAP #15
     

* Put variables and constants here

LoopVar1    DC.B    1
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
