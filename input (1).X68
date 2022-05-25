*-----------------------------------------------------------
* Title      :
* Written by : Andy Zhong
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
* this program reads hexadecimal as a long into address 100

* Put program code here
    LEA $100, A1
    MOVE.B #2, D0
    TRAP   #15
    
    MOVE.L    #0,D4
    MOVE.L    #8, D5    
    
LP  CMP.L  D4, D5
    BEQ    NC
    ADDQ.L #1, D4
    CMP.B  #58, (A1)
    BLT    NE
    BRA    PO
   
NE  Subi.b #48,(A1)
    Adda.l #1, A1
    bra LP

PO  Subi.b #55,(A1)
    Adda.l #1, A1
    bra LP
    
NC  CLR D4
    MOVE.B $100, D4
    MULU   #16, D4
    ADD.B  $101, D4
    MOVE.B D4, $100
    
    CLR D4
    MOVE.B $102, D4
    MULU   #16, D4
    ADD.B  $103, D4
    MOVE.B D4, $101
    
    CLR D4
    MOVE.B $104, D4
    MULU   #16, D4
    ADD.B  $105, D4
    MOVE.B D4, $102
    
    CLR D4
    MOVE.B $106, D4
    MULU   #16, D4
    ADD.B  $107, D4
    MOVE.B D4, $103
    
        
    

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
