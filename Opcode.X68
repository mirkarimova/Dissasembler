
*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    
INPUT1
    LEA     DEFAULTOUTPUT, A1
    MOVE    #14, D0
    TRAP    #15
    
    LEA     $100, A1
    MOVE.B  #2, D0
    TRAP    #15
    
    MOVE.L    #0,D4
    MOVE.L    #8, D5    
    
*input method for address $100    
LP  CMP.L   D4, D5
    BEQ     NC
    ADDQ.L  #1, D4
    CMP.B   #58, (A1)
    BLT     NE
    BRA     PO
   
NE  Subi.b  #48,(A1)
    Adda.l  #1, A1
    bra     LP

PO  Subi.b  #55,(A1)
    Adda.l  #1, A1
    bra     LP
    
NC  CLR     D4
    MOVE.B  $100, D4
    MULU    #16, D4
    ADD.B   $101, D4
    MOVE.B  D4, $100
    
    CLR     D4
    MOVE.B  $102, D4
    MULU    #16, D4
    ADD.B   $103, D4
    MOVE.B  D4, $101
    
    CLR     D4
    MOVE.B  $104, D4
    MULU    #16, D4
    ADD.B   $105, D4
    MOVE.B  D4, $102
    
    CLR     D4
    MOVE.B  $106, D4
    MULU    #16, D4
    ADD.B   $107, D4
    MOVE.B  D4, $103
    
    MOVE.L  $100,A3
    
    MOVE.L  #0,(AIV)

*input method for address $110  
INPUT2
    LEA     DEFAULTOUTPUT1, A1
    MOVE    #14, D0
    TRAP    #15
    
    LEA     $110, A1
    MOVE.B  #2, D0
    TRAP    #15
    
    MOVE.L  #0,D4
    MOVE.L  #8, D5

LP1  
    CMP.L   D4, D5
    BEQ     NC1
    ADDQ.L  #1, D4
    CMP.B   #58, (A1)
    BLT     NE1
    BRA     PO1
   
NE1  
    Subi.b  #48,(A1)
    Adda.l  #1, A1
    bra     LP1

PO1  
    Subi.b  #55,(A1)
    Adda.l  #1, A1
    bra LP1
    
NC1  
    CLR D4
    MOVE.B  $110, D4
    MULU    #16, D4
    ADD.B   $111, D4
    MOVE.B  D4, $110
    
    CLR     D4
    MOVE.B  $112, D4
    MULU    #16, D4
    ADD.B   $113, D4
    MOVE.B  D4, $111
    
    CLR D4
    MOVE.B  $114, D4
    MULU    #16, D4
    ADD.B   $115, D4
    MOVE.B  D4, $112
    
    CLR     D4
    MOVE.B  $116, D4
    MULU    #16, D4
    ADD.B   $117, D4
    MOVE.B  D4, $113
    
*    MOVE.L  $110,A3
    
    MOVE.L  #0, (AIV)
    
    *************END_OF_INPUT***************************************
    *******************test input*************************************
     MOVE.W #$5246, $8000
    
   * MOVE.L   #$00000099,$8002   *test input
   * MOVE.L   #$00010000,$8006   *test input
    ******************************************************************
    MOVE.W  #0, (CURR_LINE)
    BRA     ST
********************* 5/31 **************************************************
RESET_LINE 
    MOVE.W  #0, (CURR_LINE)
    MOVE.B  #5, D0
    TRAP    #15
    BLT     CHECKED

CHECK_LINE 
    CMPI    #30, (CURR_LINE)
    BEQ     RESET_LINE
    BLT     CHECKED 
****************** 5/31 *****************************************************
    
ST  *increment address A3 by var amount AIV
    *set var AIV amount to 0 
    *ANDY HERE***********************************************
    CMP.L   $110, A3
    BEQ     INPUT1    
    CMP.L   $110, A3
    BGT     INPUT1
    *ANDY ENDS HERE******************************************
    BRA     CHECK_LINE

CHECKED ************************************************ added in 5/31 just this line 
 
    ADDA.L  (AIV), A3
    MOVE.L  #0, (AIV)
    
    *ANDY Memory print routine ends here 
    LEA     $50, A1
    MOVE.L  A3, D2
    MOVE.L  #8, D1
    JSR     PRINT_EA
    
    LEA     SPACEOUTPUT, A1
    MOVE.B  #14, D0 
    TRAP    #15 
    *ANDY Memory print routine ends here 

    CLR     D7
    MOVE.W  (A3),D7

    CLR     D3
    MOVE.W (A3), D3
    
    *get first 4 bits
    LSR.W   #8, D3
    LSR.W   #4, D3
    
    LEA     $990, A2
    MOVE.W  D3, (A2)
*********My code starts here *****************************************************************    
MI  CMP.W   #%0100, (A2)
    BEQ     MI1
    BRA     AD
    
AD CMP.W    #%0101, (A2)
    BEQ     ADDQ1
    BRA     AND

AND CMP.W   #%1100, (A2)
    BEQ     AND_OP
    BRA     AddOrAdda
    
AddOrAdda
    CMP.W   #%1101, (A2)
    BEQ     AddOrAdda2
    BRA     OR
    
OR  
    CMP.W   #%1000, (A2)
    BEQ     OR_OP
    BRA     MOVE_TYPE_LONG
    
MOVE_TYPE_LONG
    CMP.W   #%0010, (A2)
    BEQ     MOVE_LONG_OP
    BRA     CMP_MOVEQ
    
CMP_MOVEQ   
    CMP.W   #%0111, (A2)
    BEQ     CHECK_MOVEQ
    BRA     BCC
    
BCC 
    CMP.W   #%0110, (A2)
    BEQ     BCC2
    BRA     SUB

SUB 
    CMP.W   #%1001, (A2)
    BEQ     SUB1
    BRA     MOVE_TYPE_WORD
    
MOVE_TYPE_WORD
    CMP.W   #%0011, (A2)
    BEQ     MOVE_WORD_OP
    BRA     MOVE_BYTE
    
MOVE_BYTE
    CMP.W   #%0001, (A2)
    BEQ     MOVE_BYTE_OP
    BRA     SHIFT_OP
    
SHIFT_OP
    CMP.W   #%1110,(A2)
    BEQ     CHECK_1110
    BRA     INVALID
    
MI1
    *compare the full byte value to NOP bits value as NOP is full of default values
    CMP.W   #%0100111001110001,D7
    BEQ     NOP_OUT
    
    *compare the full byte value to RTS bits value as RTS is full of default values
    CMP.W   #%0100111001110101,D7
    BEQ     RTS_OUT    
    
    *separate the bytes in group of 3 bits
    *D3 hold the destination register for LEA, bits 11,10,9
    CLR     D3
    MOVE.W  D7, D3
    LSL.W   #4, D3
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    *D4 holds the default value %111 for LEA, bits 8,7,6
    CLR     D4
    MOVE.W  D7, D4
    LSL.W   #7, D4
    LSR.W   #8, D4
    LSR.W   #5, D4

    *D5 holds the source mode value for LEA, bits 5,4,3
    CLR     D5
    MOVE.W  D7, D5
    LSL.W   #8, D5
    LSL.W   #2, D5
    LSR.W   #8, D5
    LSR.W   #5, D5
    
    *D6 holds the source register value for LEA, bits 2,1,0
    CLR     D6
    MOVE.W  D7, D6
    LSL.W   #8, D6
    LSL.W   #5, D6
    LSR.W   #8, D6
    LSR.W   #5, D6
    
    *compare 111 with D4 which will show if the value is LEA
    CMP     #%111,D4
    BEQ     LEA_OUT
    
    *compare 011 with D3 which will show if the value is NOT
    CMP     #%011,D3
    BEQ     NOT_OUT
    
    CMP     #%111,D3
    BEQ     JSR_OUT
    
    BRA     INVALID
    
NOT_OUT
    *Output 'NOT'
    LEA      NOTOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    *compare %000 to check if the size is Byte
    CMP     #%000, D4
    BEQ     NOT_BYTE
    
    *compare %001 to check if the size is Word
    CMP     #%001, D4
    BEQ     NOT_WORD

    *compare %010 to check if the size is Long
    CMP     #%010, D4
    BEQ     NOT_LONG

CONTINUE    
    
    CMP     #%000,D5
    BEQ     EA_D_OUTPUT1
    
    CMP     #%010,D5
    BEQ     INDIRECT_EA_OUTPUT1

    CMP     #%011,D5
    BEQ     INDIRECT_EA_PLUS_OUTPUT1
    
    CMP     #%100,D5
    BEQ     INDIRECT_EA_MINUS_OUTPUT1
    
    CMP     #%111,D5
    BEQ     EA_REGISTER    *output address
    
    BRA     END
    
*used to output the .B after NOT    
NOT_BYTE
    LEA      MB19, A1
    MOVE.B   #14, D0
    TRAP     #15    
    BRA      CONTINUE

*used to output the .W after NOT    
NOT_WORD
    LEA      MB17, A1
    MOVE.B   #14, D0
    TRAP     #15    
    BRA      CONTINUE 

*used to output the .L after NOT    
NOT_LONG
    LEA      MB16, A1
    MOVE.B   #14, D0
    TRAP     #15    
    BRA      CONTINUE
    

LEA_BRANCH
    MOVE.W  (A3), D4
    LSL.W   #8, D4
    LSL.W   #5, D4
    LSR.W   #8, D4
    LSR.W   #5, D4
    
    CMP.W   #000, D4
    BEQ     LEA_WORD
    CMP.W   #001, D4
    BEQ     LEA_LONG
    
LEA_WORD
    ADDI.L  #2, (AIV)
    ADDA.L  #2, A3
    MOVE.L  #4, D1
    MOVE.W  (A3), D2
    JSR     PRINT_EA
    SUBA.L  #2, A3
    BRA     LEA_FIN
LEA_LONG
    ADDI.L  #4, (AIV)
    ADDA.L  #2, A3
    MOVE.L  #8, D1
    MOVE.L  (A3), D2
    JSR     PRINT_EA
    SUBA.L  #2, A3
    BRA     LEA_FIN

LEA_FIN
    LEA      COMMAOUTPUT ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    *output the destination register, 'A', and a comma
    LEA      MB11,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    MOVE.W  D3,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    BRA     END  
  
LEA_OUT
    *Load the LEA message
    LEA      LEAOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    CMP.W   #%111,D5 *dont know how to output address $####
    BEQ     LEA_BRANCH
    
    *if D5 is not %111 then output (A#)
    LEA      MB12 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB11 ,A1
    MOVE.B   #14, D0
    TRAP     #15

    *output (A) value
    MOVE.W  D6,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    LEA      MB13 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      COMMAOUTPUT ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    *output the destination register, 'A', and a comma
    LEA      MB11,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    MOVE.W  D3,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    BRA     END
*Compare register to determine if the register is a long or a word    
EA_REGISTER
    CMP     #%000, D6 *register (xxx).W
    BEQ     REGISTER_W
    
    CMP     #%001, D6 *register (xxx).L
    BEQ     REGISTER_L
    
    CMP     #%100, D6
    BEQ     REGISTER_INT
    
    BRA     INVALID

***********EA WORD and LONG*******************
REGISTER_INT
    MOVE.W  (A3), D1
    LSR.W   #8, D1
    LSR.W   #4, D1
    CMP.W   #%0011, D1
    BEQ     REGISTER_INT_WORD
    CMP.W   #%0010, D1
    BEQ     REGISTER_INT_LONG
    BRA     INVALID
    
REGISTER_INT_WORD
    ADDI.L  #2, (AIV)
    ADDA.L  #2, A3
    
    MOVE.W  (A3),D2
    MOVE.L  #4,D1
    
    JSR     PRINT_EA1
    SUBA.L  #2, A3
    
    RTS

REGISTER_INT_LONG
    ADDI.L  #4, (AIV)
     
    ADDA.L  #2, A3
    MOVE.L  (A3),D2
    MOVE.L  #8,D1
    JSR     PRINT_EA1
    SUBA.L  #2, A3
    
    RTS
    
REGISTER_W 
    ADDI.L      #2, (AIV)
    
    ADDA.L      #2,A3    
    MOVE.W      (A3),D2
    MOVE.L      #4,D1
    
    JSR         PRINT_EA
    
    SUBA.L      #2,A3
    
    RTS
    
    BRA         END
    
REGISTER_L
    ADDI.L  #4, (AIV)
    
    ADDA.L  #2,A3
    MOVE.L  (A3),D2
    MOVE.L  #8,D1
    
    JSR     PRINT_EA
    
    SUBA.L  #2,A3
    
    RTS
    
    BRA     END
**********************************************
INDIRECT_EA_OUTPUT *output (A#)
    LEA      MB12 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB11 ,A1
    MOVE.B   #14, D0
    TRAP     #15

    *output (A) value
    MOVE.W   D6,D1
    MOVE.B   #3,D0
    TRAP     #15
    
    LEA      MB13 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    RTS 
    
    BRA     END

INDIRECT_EA_OUTPUT1 *output (A#)
    LEA      MB12 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB11 ,A1
    MOVE.B   #14, D0
    TRAP     #15

    *output (A) value
    MOVE.W  D6,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    LEA      MB13 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    BRA     END
INDIRECT_EA_PLUS_OUTPUT *output (A#)+
    LEA      MB12 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB11 ,A1
    MOVE.B   #14, D0
    TRAP     #15

    *output (A) value
    MOVE.W   D6,D1
    MOVE.B   #3,D0
    TRAP     #15
    
    LEA      MB13 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    *output + sign 
    MOVE.W   #$2B,D1
    MOVE.B   #6,D0
    TRAP     #15
    
    RTS
    
    BRA      END    

INDIRECT_EA_PLUS_OUTPUT1 *output (A#)+
    LEA      MB12 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB11 ,A1
    MOVE.B   #14, D0
    TRAP     #15

    *output (A) value
    MOVE.W   D6,D1
    MOVE.B   #3,D0
    TRAP     #15
    
    LEA      MB13 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    *output + sign 
    MOVE.W   #$2B,D1
    MOVE.B   #6,D0
    TRAP     #15
    
    BRA      END 
INDIRECT_EA_MINUS_OUTPUT    *output -(A#)
    *output - sign 
    MOVE.W   #$2D,D1
    MOVE.B   #6,D0
    TRAP     #15
    
    LEA      MB12 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB11 ,A1
    MOVE.B   #14, D0
    TRAP     #15

    *output (A) value
    MOVE.W   D6,D1
    MOVE.B   #3,D0
    TRAP     #15
    
    LEA      MB13 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    RTS
    
    BRA END
   
INDIRECT_EA_MINUS_OUTPUT1    *output -(A#)
    *output - sign 
    MOVE.W   #$2D,D1
    MOVE.B   #6,D0
    TRAP     #15
    
    LEA      MB12 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB11 ,A1
    MOVE.B   #14, D0
    TRAP     #15

    *output (A) value
    MOVE.W   D6,D1
    MOVE.B   #3,D0
    TRAP     #15
    
    LEA      MB13 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    BRA END
 
EA_D_OUTPUT *output 'D' and its value
    LEA      MB10 ,A1
    MOVE.B   #14, D0
    TRAP     #15    
    
    *output D6 value
    MOVE.W   D6,D1
    MOVE.B   #3,D0
    TRAP     #15 
    
    RTS
    
    BRA      END

EA_D_OUTPUT1 *output 'D' and its value
    LEA      MB10 ,A1
    MOVE.B   #14, D0
    TRAP     #15    
    
    *output D6 value
    MOVE.W   D6,D1
    MOVE.B   #3,D0
    TRAP     #15 
    
    BRA      END
    
EA_A_OUTPUT *output A#
    LEA     MB11,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  D6,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    RTS 
    
    BRA      END

A_OUTPUT
    LEA      MB11 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    MOVE.W   D6,D1
    MOVE.B   #3,D0
    TRAP     #15
    
    BRA      END
    
NOP_OUT *output 'NOP'
    LEA      NOPOUTPUT,A1
    MOVE.B   #14, D0
    TRAP     #15

    BRA      END
    
RTS_OUT *output 'RTS'
    LEA      RTSOUTPUT,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    BRA      END
    
JSR_OUT *output (JSR)
    LEA      JSROUTPUT,A1
    MOVE.B   #14, D0
    TRAP     #15   
    
    
    *check for invalid mode for destination address
    CMP.W   #%000,D5
    BEQ     INVALID
    
    CMP.W   #%001,D5
    BEQ     INVALID
    
    CMP.W   #%011,D5
    BEQ     INVALID
    
    CMP.W   #%100,D5
    BEQ     INVALID
    
    CMP.W   #%101,D5
    BEQ     INVALID
    
    CMP.W   #%110,D5
    BEQ     INVALID
    
    *address is in a3
    MOVE.W  (A3), D3
    *left 10, right 13
    LSL.W   #8, D3
    LSL.W   #2, D3
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    *if it is a word or a long address
    CMP.W   #%111, D3
    BEQ     AddPrintEA1
    *Before going to subroutine, change d1 based on EA register
    
    *else check for the 4 An modes
    
    *Now we know it is not .W or .L so we check what statement to output
    * for the address register as the source

    *we can use the same subroutine to print this stuff for DNfirst
    *(An)
    CMP.W   #%010, D3
    BEQ     AddSourcePAn1
    
    BRA     INVALID

*******************************************************************
*********ADDQ*************************************************************************    
ADDQ1
   *separate the bytes in group of 3 bits
    *D3 hold the Data between 000-111 for ADDQ and the Data register for SUB, bits 11,10,9
    MOVE.W (A3), D0
    LSR.W #8, D0
    LSR.W #4, D0
    CMP #5, D0
    BNE INVALID
    
    CLR     D3
    MOVE.W  D7, D3
    LSL.W   #4, D3
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    *D4 holds the size for ADDQ and theh Opmode for SUB, bits 8,7,6
    CLR     D4
    MOVE.W  D7, D4
    LSL.W   #7, D4
    LSR.W   #8, D4
    LSR.W   #5, D4

    *D5 holds the source mode value both, bits 5,4,3
    CLR     D5
    MOVE.W  D7, D5
    LSL.W   #8, D5
    LSL.W   #2, D5
    LSR.W   #8, D5
    LSR.W   #5, D5
    
    *D6 holds the source register value for both, bits 2,1,0
    CLR     D6
    MOVE.W  D7, D6
    LSL.W   #8, D6
    LSL.W   #5, D6
    LSR.W   #8, D6
    LSR.W   #5, D6
    
    *output ADDQ
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%101, D0
    BEQ INVALID
    CMP.W #%110, D0
    BEQ INVALID    
    CMP.W #%111, D0
    BEQ checkADDQ 
    BRA ADDQNEXT
checkADDQ
    MOVE.W (A3), D0
    LSL.W #8, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #8, D0
    
    CMP.W #%000, D0
    BEQ ADDQNEXT
    
    CMP.W #%001, D0
    BEQ ADDQNEXT
    
    BRA INVALID
ADDQNEXT
    LEA     ADDQOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *compare %000 to check if the size is Byte
    CMP     #%000, D4
    BEQ     ADDQ_BYTE
    
    *compare %001 to check if the size is Word
    CMP     #%001, D4
    BEQ     ADDQ_WORD

    *compare %010 to check if the size is Long
    CMP     #%010, D4
    BEQ     ADDQ_LONG
    
DATARANGE
    CMP     #%000,D3
    BLT     INVALID
    
    CMP     #%111,D3
    BGT     INVALID
    
    *output '#'
    LEA     MB18,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *output the data value
    MOVE.W  D3,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
 
    *output D# 
    CMP     #%000,D5
    BEQ     EA_D_OUTPUT1
    
    *output A# 
    CMP     #%001,D5
    BEQ     A_OUTPUT
    
    *output (An)
    CMP     #%010,D5
    BEQ     INDIRECT_EA_OUTPUT1
    
    *output (An)+
    CMP     #%011,D5
    BEQ     INDIRECT_EA_PLUS_OUTPUT1
    
    *output -(An)
    CMP     #%100,D5
    BEQ     INDIRECT_EA_MINUS_OUTPUT1
    
    *output $value
    CMP     #%111, D5
    BEQ     ADDQNEXT4
    
    BRA     INVALID
ADDQNEXT4
    JSR EA_REGISTER
    BRA END
    
ADDQ_BYTE
    LEA      MB19, A1
    MOVE.B   #14, D0
    TRAP     #15    
    BRA      DATARANGE
    
ADDQ_WORD
    LEA      MB17, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA      DATARANGE
    
ADDQ_LONG
    LEA      MB16, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA      DATARANGE
    
INVALID 

*print A3
    MOVE.L A3, D2
    MOVE.L #8, D1
    JSR PRINT_EA

*print message " DATA "
    LEA      DATAOUTPUT , A1
    MOVE.B   #14, D0
    TRAP     #15  
*print word value at (A3)    
    
    MOVE.W (A3), D2
    MOVE.L #4, D1
    JSR PRINT_EA
    
    BRA      END  
    

    
    
**************************************************************************************** 

*********OUTPUT_HEX*********************************************************************
PRINT_EA
   *LETS say hexadecimal is stored in d2
   
   *this program uses A6, A5, A1
   LEA      MB20, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   *code starts HERE:
   MOVE.B   #0, LoopVar1

   *since 0 - 1000 is free, use that as memory
   LEA      $400, A1
   LEA      $200, A5
   MOVE.L   D2, (A5)
   LEA      $300, A6
   
FOR CMP.B   #4, LoopVar1
    BEQ     NEXT
    CLR     D7
    MOVE.B  (A5), D7
    LSR.W   #4, D7
    MOVE.B  D7, (A6)+    
  
    MOVE.B  (A5), (A6)
    SUBA.L  #1, A6
    
    AND.B   #$0F, (A6)+ 
    AND.B   #$0F, (A6)
    
 
    ADDA.L  #1, A5
    ADDA.L  #1, A6
    
    ADDI.B  #1, LoopVar1
    BRA     FOR
    
NEXT MOVE.B #0, LoopVar1
     LEA    $300, A6
     BRA    N1
     
N1  CMP.B   #8, LoopVar1
    BEQ     ED
    CMP.B   #9, (A6)
    BGT     LETTER
    BRA     NUMBER
    
LETTER 
    ADDI.B  #55, (A6)+
    ADDI.B  #1, LoopVar1
    BRA     N1

NUMBER 
    ADDI.B  #48, (A6)+
    ADDI.B  #1, LoopVar1
    BRA     N1
    
ED  LEA     $300, A6
* this is if long
    MOVE.L  (A6)+, (A1)+
    MOVE.L  (A6), (A1)
    LEA     $400, A1    
    
    CMP.B   #2, D1
    BEQ     ED1
    
    CMP.B   #4, D1
    BEQ     ED2
    
    BRA     ED3

ED1 ADDA.W  #6, A1 
    BRA     ED4

ED2 ADDA.L  #4, A1
    BRA     ED4
ED3   
    BRA     ED4 
    
ED4 MOVE.B  #1, D0
    TRAP    #15
     
    RTS
***************************************************************************************

***********************AND*************************************************************
MULS MOVE.W (A2), D7
     BRA INVALID
     
AND_OP
    
    LSR.W #6, D7
    AND.W #%00000111, D7
    CMPI #%111, D7
    BEQ MULS
    
    *output 'AND'
    LEA     ANDOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     COMMON_ROUTINE
    
    BRA     INVALID
    
D_BYTE
    *output the size
    LEA     MB19,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *output 'D'
    LEA     MB10,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *output D value
    MOVE.B  D3,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    *output ,
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     AND_EA
    BRA     END
D_WORD
    *output the size
    LEA     MB17,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *output 'D'
    LEA     MB10,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *output D value
    MOVE.B  D3,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    *output ,
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     AND_EA
    
    BRA     END
D_LONG
    *output the size
    LEA     MB16,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *output 'D'
    LEA     MB10,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *output D value
    MOVE.B  D3,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    *output ','
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     AND_EA
    
    BRA     END
AND_EA
*output D
    CMP     #%000,D5
    BEQ     EA_D_OUTPUT
    
    *output (An)
    CMP     #%010,D5
    BEQ     INDIRECT_EA_OUTPUT
    
    *output (An)+
    CMP     #%011,D5
    BEQ     INDIRECT_EA_PLUS_OUTPUT
    
    *output -(An)
    CMP     #%100,D5
    BEQ     INDIRECT_EA_MINUS_OUTPUT
    
    *output $value
    CMP     #%111, D5
    BEQ     EA_REGISTER 
    
    RTS
    
    BRA     END
    
EA_BYTE
    *output the size
    LEA     MB19,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     AND_EA
    
    *output ','
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15

    JSR     DESTINATION_D_OUTPUT
    
    BRA     END
 
EA_WORD
    *output the size
    LEA     MB17,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     AND_EA
    
    *output ','
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15

    JSR     DESTINATION_D_OUTPUT
    
    BRA     END
    
EA_LONG   
    *output the size
    LEA     MB16,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *output the correct tpye of An and its value
    JSR     AND_EA
    
    *output ','
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15

    JSR     DESTINATION_D_OUTPUT
    
    BRA     END

DESTINATION_D_OUTPUT *output 'D' and its value
    LEA      MB10 ,A1
    MOVE.B   #14, D0
    TRAP     #15    
    
    *output D6 value
    MOVE.W   D3,D1
    MOVE.B   #3,D0
    TRAP     #15     
    
    RTS
    
    BRA      END
***************************************************************************************

*********Andy's code starts here *****************************************************************       
AddOrAdda2
    CLR     D3
    MOVE.W  (A3), D4
    LSL.W   #7, D4
    LSR.W   #8, D4
    LSR.W   #5, D4
    CMP.W   #%011, D4
    BEQ     Adda
    CMP.W   #%111, D4
    Beq     Adda
    
    CMP.W   #%000, D4
    BEQ     Add
    CMP.W   #%100, D4
    BEQ     Add
    CMP.W   #%001, D4
    BEQ     Add
    CMP.W   #%101, D4
    BEQ     Add
    CMP.W   #%010, D4
    BEQ     Add
    CMP.W   #%110, D4
    BEQ     Add    
    BRA     INVALID
    
*determined if it is Add
Add 
    CMP.W #%000, D4
    BEQ EaScanError
    Cmp.W #%001, D4
    BEQ EaScanError
    CMP.W #%010, D4
    BEQ EaScanError
    BRA DnScanError
    
EaScanError
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%101, D0
    BEQ INVALID
    CMP.W #%110, D0
    BEQ INVALID    
    BRA Add1
DnScanError
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%000, D0
    BEQ INVALID
    CMP.W #%001, D0
    BEQ INVALID
    CMP.W #%101, D0
    BEQ INVALID
    CMP.W #%110, D0
    BEQ INVALID  
    BRA Add1
    
Add1
    LEA      ADDOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA      NEXT1
NEXT1
    *opmode is still in d4
    CMP.W   #%000, D4
    BEQ     AddPrintB
    CMP.W   #%100, D4
    BEQ     AddPrintB
    
    CMP.W   #%001, D4
    BEQ     AddPrintW
    CMP.W   #%101, D4
    BEQ     AddPrintW
    
    CMP.W   #%110, D4
    BEQ     AddPrintL
    CMP.W   #%010, D4
    BEQ     AddPrintL
    
    BRA     INVALID
*size printers
AddPrintB
    LEA      MB19, A1
    MOVE.B   #14, D0
    TRAP     #15
    CMP.W    #%000, D4
    BEQ      EAfirst
    BRA      DnFirst

AddPrintW
    LEA      MB17, A1
    MOVE.B   #14, D0
    TRAP     #15
    CMP.W   #%001, D4
    BEQ     EAfirst
    BRA     DnFirst

AddPrintL
    LEA      MB16, A1
    MOVE.B   #14, D0
    TRAP     #15
    CMP.W   #%010, D4
    BEQ     EAfirst
    BRA     DnFirst
*end of size printers
*this means source operand is first
EAfirst
    
    *address is in a3
    MOVE.W  (A3), D3
    *left 10, right 13
    LSL.W   #8, D3
    LSL.W   #2, D3
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    *if it is a word or a long address
    CMP.W   #%111, D3
    BEQ     AddPrintEA
    *Before going to subroutine, change d1 based on EA register
    
    *else check for the 4 An modes
    
    *Now we know it is not .W or .L so we check what statement to output
    * for the address register as the source
    
    *Dn
    CMP.W   #%000, D3
    BEQ     AddSourceDn
    *we can use the same subroutine to print this stuff for DNfirst
    
    *An
    CMP.W   #%001, D3
    BEQ     AddSourceAn
    
    *(An)
    CMP.W   #%010, D3
    BEQ     AddSourcePAn
    *(An)+
    CMP.W   #%011, D3
    BEQ     AddSourceIAn
    *-(An)
    CMP.W   #%100, D3
    BEQ     AddSourceDAn
    
    BRA     INVALID


*Dn
AddSourceDn
    LEA      MB10, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    CLR         D3
    MOVE.W      (A3), D3
    LSL.W       #8, D3
    LSL.W       #5, D3
    
    LSR.W       #8, D3
    LSR.W       #5, D3
    
    MOVE.W      D3, D1
    MOVE.W      #3, D0
    TRAP        #15
    
    BRA         AddPrintDest

*An
AddSourceAn
    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    CLR         D3
    MOVE.W      (A3), D3
    LSL.W       #8, D3
    LSL.W       #5, D3
    
    LSR.W       #8, D3
    LSR.W       #5, D3
    
    MOVE.W      D3, D1
    MOVE.W      #3, D0
    TRAP        #15

    BRA         AddPrintDest

*(An)
AddSourcePAn
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR     D3
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #5, D3
    
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    MOVE.B  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15

    BRA     AddPrintDest

AddSourcePAn1
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR      D3
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #5, D3
    
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    MOVE.B  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA      END
    
*(An)+
AddSourceIAn
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR      D3 
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #5, D3
    
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    MOVE.B  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB14, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA      AddPrintDest

*-(An)
AddSourceDAn
    LEA      MB15, A1
    MOVE.B   #14, D0
    TRAP     #15
   
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR      D3
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #5, D3
    
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    MOVE.B  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA     AddPrintDest

DnFirst
*output the data register
   LEA      MB10, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   CLR      D3
   MOVE.W   (A3), D3
   LSL.W    #4, D3
   LSR.W    #8, D3
   LSR.W    #5, D3
   
   MOVE.W   D3, D1
   MOVE.B   #3, D0
   TRAP     #15
   
   LEA      COMMAOUTPUT, A1
   MOVE.B   #14, D0
   TRAP     #15
   
    
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #2, D3
    LSR.W   #8, D3
    LSR.W   #5, D3
        
    *if it is a word or a long address
    CMP.W   #%111, D3
    BEQ     DnFirstWL
    
    *(An)
    CMP.W   #%010, D3
    BEQ     DnAn
    
    *(An)+
    CMP.W   #%011, D3
    BEQ     DnAnPlus
    
    *-(An)
    CMP.W   #%100, D3
    BEQ     DnAnMinus
    
    BRA     INVALID
DnAn
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR     D3
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #5, D3
    
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    MOVE.B  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    BRA      END
DnAnPlus
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR      D3
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #5, D3
    
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    MOVE.B  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB14, A1
    MOVE.B   #14, D0
    TRAP     #15

    BRA     END
    
DnAnMinus
    LEA      MB15, A1
    MOVE.B   #14, D0
    TRAP     #15
   
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR      D3
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #5, D3
    
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    MOVE.B  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15

    BRA     END
   
*find which one to output next
*Destination wise, 3 of the (An) is allowed and .W and .L are too

*word or long
DnFirstWL
   MOVE.W   (A3), D3
   LSL.W    #8, D3
   LSL.W    #5, D3
   LSR.W    #8, D3
   LSR.W    #5, D3
   
   CMP.W    #%000, D3
   BEQ      DnW
   BRA      DnL

DnW
*increment AIV and A3
* call print  EA which will print D value and Word
   ADDI.L   #2, (AIV)
   
   ADDA.L   #2, A3
   MOVE.W   (A3), D2
   MOVE.L   #4, D1
   JSR      PRINT_EA
   SUBA.L   #2, A3
   BRA      END

DnL
*increment AIV and A3
* call print  EA which will print D value and Long
   ADDI.L   #4, (AIV)
   ADDA.L   #2, A3
   MOVE.L   (A3), D2
   MOVE.L   #8, D1
   
   JSR      PRINT_EA
   SUBA.L   #2, A3
   BRA      END

AddPrintEA
   
   MOVE.W   (A3), D3
   LSL.W    #8, D3
   LSL.W    #5, D3
   LSR.W    #8, D3
   LSR.W    #5, D3
   
   CMP.W    #%000, D3
   BEQ      AddPrintSourceW
   
   CMP.W    #%100, D3
   BEQ      AddPrintIm
   
   BRA      AddPrintSourceL

AddPrintEA1
    MOVE.W  (A3), D3
   LSL.W    #8, D3
   LSL.W    #5, D3
   LSR.W    #8, D3
   LSR.W    #5, D3
   
   CMP.W    #%000, D3
   BEQ      AddPrintSourceW1
   
   CMP.W    #%001, D3
   BEQ      AddPrintSourceL1
   
   BRA      INVALID

AddPrintSourceW1
   ADDI.L   #2, (AIV)
   ADDA.L   #2, A3
   
   MOVE.W   (A3), D2
   MOVE.L   #4, D1
   
   JSR      PRINT_EA
   SUBA.L   #2, A3
   BRA      END
   
AddPrintSourceL1
   ADDI.L   #4, (AIV)
   ADDA.L   #2, A3
   MOVE.B   (A3), D2
   MOVE.L   #8, D1
   JSR      PRINT_EA
   SUBA.L   #2, A3
   BRA      END
   
AddPrintIM
   MOVE.W   (A3), D3
   LSL.W    #7, D3
   LSR.W    #8, D3
   LSR.W    #5, D3
   CMP.W    #%000, D3
   BEQ      AddPrintIMW
   CMP.W    #%001, D3
   BEQ      AddPrintIMW
   BRA      AddPrintIML
   
AddPrintIMW
   ADDI.L  #2, (AIV)

   ADDA.L   #2, A3
   MOVE.W   (A3), D2
   MOVE.L   #4, D1
   JSR      PRINT_EA1
   SUBA.L   #2, A3
   BRA      AddPrintDest
   
AddPrintIML
   ADDI.L   #4, (AIV)

   ADDA.L   #2, A3
   MOVE.B   (A3), D2
   MOVE.L   #8, D1
   JSR      PRINT_EA1
   SUBA.L   #2, A3
   BRA      AddPrintDest
   
AddPrintSourceW
   ADDI.L   #2, (AIV)

   ADDA.L   #2, A3
   MOVE.W   (A3), D2
   MOVE.L   #4, D1
   JSR      PRINT_EA
   SUBA.L   #2, A3
   
   BRA      AddPrintDest
AddPrintSourceL
   ADDI.L   #4, (AIV)

   ADDA.L   #2, A3
   MOVE.L   (A3), D2
   MOVE.L   #8, D1
   JSR      PRINT_EA
   SUBA.L   #2, A3
   BRA      AddPrintDest
AddPrintDest
   LEA      COMMAOUTPUT, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   LEA      MB10, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   CLR      D3
   MOVE.W   (A3), D3
   LSL.W #4, D3
   LSR.W #8, D3
   LSR.W #5, D3
   
   
   MOVE.W   D3, D1
   MOVE.B   #3, D0
   TRAP     #15
   
   BRA      END

********************************ADDA**************************************************************
*determined it is Adda    
Adda 
    *opcode is stored in d3 and it is valid
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%101, D0
    BEQ INVALID
    CMP.W #%110, D0
    BEQ INVALID
    
    LEA      ADDAOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    CMP.W   #%011, D3
    BEQ     AddaW
    BRA     AddaL
*determined if it is Add
AddaW
    LEA      MB17, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    BRA     AddaPrintEA

AddaL
    LEA      MB16, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    BRA     AddaPrintEA
    
AddaPrintEA
    *address is in a3
    MOVE.W  (A3), D3
    *left 10, right 13
    LSL.W   #8, D3
    LSL.W   #2, D3
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    *this takes care of .W, .L, and #
    CMP.W   #%111, D3
    BEQ     AddaWL
    
    *Dn
    CMP.W   #%000, D3
    BEQ     AddaDn
    
    *An
    CMP.W   #%001, D3
    BEQ     AddaAn
    
    *(An)
    CMP.W   #%010, D3
    BEQ     AddaPan
    
    *(An)+
    CMP.W   #%011, D3
    BEQ     AddaPlus
    
    *-(An)
    CMP.W   #%100, D3
    BEQ     AddaMinus
    
    
    
    
*figure out if word or long or intermediate
*intermediate is always stored in 8, so treat as a long
*BUT output a different symbol    
AddaWL
   *address is in a3
    MOVE.W  (A3), D3
    *left 13, right 13
    LSL.W   #8, D3
    LSL.W   #5, D3
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    *000 branch to Word
    CMP.W   #%000, D3
    BEQ     AddaWLW
    
    *001 branch to Long
    CMP.W   #%001, D3
    BEQ     AddaWLL
    
    *100 branch to intermediate
    CMP.W   #%100, D3
    BEQ     AddaWLI
    *intermediate length based on opcode
    
    BRA     INVALID
    *branch invalid
    
AddaWLW
   ADDI.L  #2, (AIV)
   
   ADDA.L   #2, A3
   MOVE.W   (A3), D2
   MOVE.L   #4, D1
   JSR      PRINT_EA
   SUBA.L   #2, A3
   BRA      AddaEnd

AddaWLL
   ADDI.L   #4, (AIV)
   
   ADDA.L   #2, A3
   MOVE.L   (A3), D2
   MOVE.L   #8, D1
   JSR      PRINT_EA
   SUBA.L   #2, A3
   BRA      AddaEnd

AddaWLI
   *address is in a3
    MOVE.W  (A3), D3
    *left 13, right 13
    LSL.W   #7, D3
    LSR.W   #8, D3
    LSR.W   #5, D3
    *011 word size
    CMP.W   #%011, D3
    BEQ     AddaWLIW
    BRA     ADDAWLIL
    
AddaWLIW
   ADDI.L   #2, (AIV)
   
   ADDA.L   #2, A3
   MOVE.W   (A3), D2
   MOVE.L   #4, D1
   JSR      PRINT_EA1    
   SUBA.L   #2, A3
   BRA      AddaEnd    
   
ADDAWLIL
   ADDI.L   #4, (AIV)
   
   ADDA.L   #2, A3
   MOVE.L   (A3), D2
   MOVE.L   #8, D1
   JSR      PRINT_EA1
   SUBA.L   #2, A3
   BRA      AddaEnd

*Dn
AddaDn
   LEA      MB10, A1
   MOVE.B   #14, D0
   TRAP     #15
    
   CLR      D3
   MOVE.W   (A3), D3
   LSL.W    #8, D3
   LSL.W    #5, D3
   
   LSR.W    #8, D3
   LSR.W    #5, D3
    
   MOVE.W   D3, D1
   MOVE.W   #3, D0
   TRAP     #15
   BRA      AddaEnd

*An
AddaAn
    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    CLR      D3
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #5, D3
    
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    MOVE.W  D3, D1
    MOVE.W  #3, D0
    TRAP    #15
   BRA      AddaEnd
   
*(An)
AddaPAn
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR      D3
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #5, D3
    
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    MOVE.B  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15

   BRA      AddaEnd
*(An)+
AddaPlus
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR      D3
    MOVE.W   (A3), D3
    LSL.W    #8, D3
    LSL.W    #5, D3
    
    LSR.W    #8, D3
    LSR.W    #5, D3
    
    MOVE.B   D3, D1
    MOVE.B   #3, D0
    TRAP     #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB14, A1
    MOVE.B   #14, D0
    TRAP     #15
   BRA       AddaEnd
*-(An)
AddaMinus
    LEA      MB15, A1
    MOVE.B   #14, D0
    TRAP     #15
   
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR      D3
    MOVE.W  (A3), D3
    LSL.W   #8, D3
    LSL.W   #5, D3
    
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    MOVE.B  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
   BRA      AddaEnd

AddaEnd
   LEA      COMMAOUTPUT, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   LEA      MB11, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   MOVE.W   (A3), D3
   LSL.W    #4, D3
   LSR.W    #8, D3
   LSR.W    #5, D3
   
   CLR      D1
   MOVE.W   D3, D1
   MOVE.B   #3, D0
   TRAP     #15
   
   BRA      END
********************************************END OF ADDA************************************************
********************************Print # intermediate**********************************************
PRINT_EA1
   *LETS say hexadecimal is stored in d2
   
   *this program uses A6, A5, A1
   LEA      MB18, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   BRA      PRINT_EA
*************************************************************************************************

******************OR_OP*************************************************************************

DIVU MOVE.W (A2), D7
     BRA INVALID

OR_OP
    
    LSR.W #6, D7
    AND.W #%00000111, D7
    CMPI #%011, D7
    BEQ DIVU
    
    *output 'AND'
    LEA     OROUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    BRA     COMMON_ROUTINE
    
    BRA     INVALID
*******************OR_OP END********************************************************************
*******************MOVE_LONG_OP START***********************************************************
MOVE_LONG_OP
    *separate the bytes in group of 3 bits
    *D3 hold the destination register for LEA, bits 11,10,9
    CLR     D3
    MOVE.W  D7, D3
    LSL.W   #4, D3
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    *D4 holds the default value %111 for LEA, bits 8,7,6
    CLR     D4
    MOVE.W  D7, D4
    LSL.W   #7, D4
    LSR.W   #8, D4
    LSR.W   #5, D4

    *D5 holds the source mode value for LEA, bits 5,4,3
    CLR     D5
    MOVE.W  D7, D5
    LSL.W   #8, D5
    LSL.W   #2, D5
    LSR.W   #8, D5
    LSR.W   #5, D5
    
    *D6 holds the source register value for LEA, bits 2,1,0
    CLR     D6
    MOVE.W  D7, D6
    LSL.W   #8, D6
    LSL.W   #5, D6
    LSR.W   #8, D6
    LSR.W   #5, D6
    
    CMP.W   #%001,D4 *if D4 is %001 then it is a MOVEA type
    BEQ     MOVEA_LONG
    
    BRA     MOVE_LONG
    
    BRA     END

MOVE_LONG
    *output 'MOVE.L'
    MOVE.W (A3), D0
    LSL.W #7, D0
    LSR.W #8, D0
    LSR.W #5, D0
    
    CMP.W #%001, D0
    BEQ INVALID
    
    CMP.W #%101, D0
    BEQ INVALID
    
    CMP.W #%110, D0
    BEQ INVALID
    
    CMP.W #%111, D0
    BEQ CheckLongReg
    BRA MOVE_LONGNEXT
CheckLongReg
    MOVE.W (A3), D0
    LSL.W #4, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%000, D0
    BEQ MOVE_LONGNEXT
    CMP.W #%001, D0
    BEQ MOVE_LONGNEXT
    BRA INVALID
    
MOVE_LONGNEXT
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    
    CMP.W #%101, D0
    BEQ INVALID
    
    CMP.W #%110, D0
    BEQ INVALID
    
    
    CMP.W #%111, D0
    BEQ CheckLongReg1
    BRA MOVE_LONGNEXT1
CheckLongReg1
    MOVE.W (A3), D0
    LSL.W #8, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%000, D0
    BEQ MOVE_LONGNEXT1
    CMP.W #%001, D0
    BEQ MOVE_LONGNEXT1
    BRA INVALID

MOVE_LONGNEXT1
    LEA     MOVEOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     MB16,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     MOVEA_EA *this will output the source address
    
    *output comma and destination adress A#
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    
    JSR     MOVEA_DESTINATION
    
    BRA     END
    
MOVEA_DESTINATION
    CMP     #%000,D4
    BEQ     D_DESTINATION
    
    CMP     #%010,D4
    BEQ     INDIRECT_A_DESTINATION    
    
    CMP     #%011,D4
    BEQ     INDIRECT_A_PLUS_DESTINATION
    
    CMP     #%100,D4
    BEQ     INDIRECT_A_MINUS_DESTINATION
    
    *output $value
    ADDA.L  (AIV), A3
    MOVE.L #0, (AIV)

    CMP     #%111, D4
    BEQ     EA_REGISTER 
    
    
    BRA     INVALID

D_DESTINATION
    LEA     MB10,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  D3,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    RTS
    BRA     END

A_DESTINATION
    LEA     MB11,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  D3,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    RTS
    
    BRA     END
    
INDIRECT_A_DESTINATION
    LEA     MB12,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     A_DESTINATION
    
    LEA     MB13,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    RTS
    BRA     END

INDIRECT_A_PLUS_DESTINATION
    JSR     INDIRECT_A_DESTINATION
    *output + sign 
    MOVE.W   #$2B,D1
    MOVE.B   #6,D0
    TRAP     #15

    RTS
    BRA     END  

INDIRECT_A_MINUS_DESTINATION
    *output - sign 
    MOVE.W   #$2D,D1
    MOVE.B   #6,D0
    TRAP     #15
    
    JSR     INDIRECT_A_DESTINATION
    
    RTS
    BRA     END    
     
MOVEA_LONG  
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #8, D0
    
    CMP.W #%101, D0
    BEQ INVALID
    
    CMP.W #%110, D0
    BEQ INVALID
    
    LEA     MOVEAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     MB16,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     MOVEA_EA
    
    *output comma and destination adress A#
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     MB11,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  D3,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    BRA     END
    
MOVEA_EA *this method output all type of effective address
*output D
    CMP     #%000,D5
    BEQ     EA_D_OUTPUT
    
    *output (An)
    CMP     #%010,D5
    BEQ     INDIRECT_EA_OUTPUT
    
    *output (An)+
    CMP     #%011,D5
    BEQ     INDIRECT_EA_PLUS_OUTPUT
    
    *output -(An)
    CMP     #%100,D5
    BEQ     INDIRECT_EA_MINUS_OUTPUT
    
    *output $value
    CMP     #%111, D5
    BEQ     EA_REGISTER 
    
    CMP     #%001,D5
    BEQ     EA_A_OUTPUT 
    
    BRA     END
    

******************************************MOVEQ**********************************************
CHECK_MOVEQ CLR     D3
           MOVE.W   (A3), D7
           LSR.W    #8, D7
           AND.W    #%00000001, D7 *Checking bit 8 to make sure that it is 0
           CMPI     #0, D7 
           BNE      INVALID * Right now just ending program if invalid 
           
           MOVE.W   (A3), D7
           LSR.W    #8, D7
           LSR.W    #1, D7
           AND.W    #%0000111, D7 *Checking bits 11 10 9 to make sure that it is valid data register
           CMPI     #7, D7
           BGT      INVALID
           
           CMPI     #0, D7
           BLT      INVALID
           
           MOVE.B   D7, D6 *Storing data register number of opcode in D3 
           MOVE.W   (A3),D7
           AND.W    #%0000000011111111, D7
           MOVE.W   D7, D1 *Storing source immediate data value in register D1 (# betw -127 and 127)
           
           BRA      PRINT_MOVEQ  *Clear d7/d6/d4/d1

PRINT_MOVEQ LEA     MOVEQOUTPUT, A1
            MOVE.B  #14, D0
            TRAP    #15
            
            LEA     MB18, A1
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVE.B  #3, D0 * Outputting source immediate data value located in D1 
            TRAP    #15
            
            LEA     COMMAOUTPUT, A1
            MOVE.B  #14, D0
            TRAP    #15
            
            JSR     EA_D_OUTPUT
            
            CLR     D7
            CLR     D6
            CLR     D4
            CLR     D0
            CLR     D1
            BRA     END 

**************************************MOVEQ END****************************************************   

*********SUB**************************************************************************************
SUB1 
    MOVE.W (A3), D4
    LSL.W #7, D4
    LSR.W #8, D4
    LSR.W #5, D4
    CMP.W #%000, D4
    BEQ EaScanError1
    Cmp.W #%001, D4
    BEQ EaScanError1
    CMP.W #%010, D4
    BEQ EaScanError1
    BRA DnScanError1
EaScanError1
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%101, D0
    BEQ INVALID
    CMP.W #%110, D0
    BEQ INVALID    
    
    MOVE.W D0, D4
    
    BRA SubBranch
DnScanError1
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%000, D0
    BEQ INVALID
    CMP.W #%001, D0
    BEQ INVALID
    CMP.W #%101, D0
    BEQ INVALID
    CMP.W #%110, D0
    BEQ INVALID  
    BRA SubBranch
     *Output 'Sub'
SubBranch
     LEA        SUBOUTPUT, A1
     MOVE.B     #14, D0
     TRAP       #15
     
     
     
     BRA        COMMON_ROUTINE
     
COMMON_ROUTINE
   *separate the bytes in group of 3 bits
    *D3 hold the destination register for LEA, bits 11,10,9
    CLR     D3
    MOVE.W  D7, D3
    LSL.W   #4, D3
    LSR.W   #8, D3
    LSR.W   #5, D3
    
    *D4 holds the default value %111 for LEA, bits 8,7,6
    CLR     D4
    MOVE.W  D7, D4
    LSL.W   #7, D4
    LSR.W   #8, D4
    LSR.W   #5, D4

    *D5 holds the source mode value for LEA, bits 5,4,3
    CLR     D5
    MOVE.W  D7, D5
    LSL.W   #8, D5
    LSL.W   #2, D5
    LSR.W   #8, D5
    LSR.W   #5, D5
    
    *D6 holds the source register value for LEA, bits 2,1,0
    CLR     D6
    MOVE.W  D7, D6
    LSL.W   #8, D6
    LSL.W   #5, D6
    LSR.W   #8, D6
    LSR.W   #5, D6
     
    *SUB uses the same format as AddaW and AddaL
    BRA         NEXT1
*********SUB ENDS*********************************************************************************

*********Andy Bcc (BEQ, BLE, BGT, BRA)*****************************************    
BCC2
    MOVE.W      (A3), D3
    LSL.W       #4, D3
    LSR.W       #8, D3
    LSR.W       #4, D3
    
    CMP.W       #%1111, D3
    BEQ         BLE
    
    CMP.W       #%0111, D3
    BEQ         BEQ
    
    CMP.W       #%1110, D3
    BEQ         BGT
    
    CMP.W       #%1110, D3
    BEQ         BGT
        
    CMP.W       #%0000, D3
    BEQ         BRRA
    
    BRA         INVALID

BLE LEA         BLEOUTPUT, A1
    MOVE.B      #14, D0
    TRAP        #15
    BRA         BCC3

BEQ LEA         BEQOUTPUT, A1
    MOVE.B      #14, D0
    TRAP        #15
    BRA         BCC3

BGT LEA         BGTOUTPUT, A1
    MOVE.B      #14, D0
    TRAP        #15
    BRA         BCC3
    
BRRA
    LEA         BRAOUTPUT, A1
    MOVE.B      #14, D0
    TRAP        #15
    BRA         BCC3

BCC3 CLR        D3
     MOVE.W     (A3), D3
     LSL.W      #8, D3
     LSR.W      #8, D3
     
     CMP.W      #$FF, D3
     BEQ        ScanLong
     
     CMP.W      #$00, D3
     BEQ        ScanWord
     
     BRA        ScanOp
     
ScanLong
     BRA        DnL

ScanWord
     Bra        DnW

ScanOp
     CLR        D2
     MOVE.W     D3, D2
     MOVE.L     #2, D1
     JSR        PRINT_EA
     BRA END


********Andy Bcc ends here************************************************

******************MOVE_BYTE_OP******************************************************
MOVE_BYTE_OP
    *separate the bytes in group of 3 bits
    *D3 holds, bits 11,10,9
    CLR         D3
    MOVE.W      D7, D3
    LSL.W       #4, D3
    LSR.W       #8, D3
    LSR.W       #5, D3
    
    *D4 holds, bits 8,7,6
    CLR         D4
    MOVE.W      D7, D4
    LSL.W       #7, D4
    LSR.W       #8, D4
    LSR.W       #5, D4

    *D5 holds the source mode value, bits 5,4,3
    CLR         D5
    MOVE.W      D7, D5
    LSL.W       #8, D5
    LSL.W       #2, D5
    LSR.W       #8, D5
    LSR.W       #5, D5
    
    *D6 holds the source register value, bits 2,1,0
    CLR         D6
    MOVE.W      D7, D6
    LSL.W       #8, D6
    LSL.W       #5, D6
    LSR.W       #8, D6
    LSR.W       #5, D6

    CMP.W       #%001,D4 *if D4 is %001 then it is invalid because it means the destination MODE is A#
    BEQ         INVALID
    
    BRA         MOVE_BYTE_OUT
    
    BRA         END

************************************************************************************
******************MOVE_WORD_OP******************************************************
MOVE_WORD_OP
    *separate the bytes in group of 3 bits
    *D3 holds, bits 11,10,9
    CLR         D3
    MOVE.W      D7, D3
    LSL.W       #4, D3
    LSR.W       #8, D3
    LSR.W       #5, D3
    
    *D4 holds, bits 8,7,6
    CLR         D4
    MOVE.W      D7, D4
    LSL.W       #7, D4
    LSR.W       #8, D4
    LSR.W       #5, D4

    *D5 holds the source mode value, bits 5,4,3
    CLR         D5
    MOVE.W      D7, D5
    LSL.W       #8, D5
    LSL.W       #2, D5
    LSR.W       #8, D5
    LSR.W       #5, D5
    
    *D6 holds the source register value, bits 2,1,0
    CLR         D6
    MOVE.W      D7, D6
    LSL.W       #8, D6
    LSL.W       #5, D6
    LSR.W       #8, D6
    LSR.W       #5, D6

    CMP.W       #%001,D4 *if D4 is %001 then it is a MOVEA type
    BEQ         MOVEA_WORD
        
    BRA         MOVE_WORD
    
    BRA         END
    
MOVE_BYTE_OUT
*output 'MOVE.L'
    MOVE.W (A3), D0
    LSL.W #7, D0
    LSR.W #8, D0
    LSR.W #5, D0
    
    CMP.W #%001, D0
    BEQ INVALID
    
    CMP.W #%101, D0
    BEQ INVALID
    
    CMP.W #%110, D0
    BEQ INVALID
    
    CMP.W #%111, D0
    BEQ CheckByteReg
    BRA MOVE_BYTENEXT 
CheckByteReg
    MOVE.W (A3), D0
    LSL.W #4, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%000, D0
    BEQ MOVE_BYTENEXT 
    CMP.W #%001, D0
    BEQ MOVE_BYTENEXT 
    BRA INVALID
    
MOVE_BYTENEXT   
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    
    CMP.W #%101, D0
    BEQ INVALID
    
    CMP.W #%110, D0
    BEQ INVALID
    
    CMP.W #%111, D0
    BEQ CheckByteReg1
    BRA MOVE_BYTENEXT1
    
CheckByteReg1
    MOVE.W (A3), D0
    LSL.W #8, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%000, D0
    BEQ MOVE_BYTENEXT1
    CMP.W #%001, D0
    BEQ MOVE_BYTENEXT1
    BRA INVALID
    
MOVE_BYTENEXT1
    LEA         MOVEOUTPUT,A1
    MOVE.B      #14,D0
    TRAP        #15
    
    LEA         MB19,A1
    MOVE.B      #14,D0
    TRAP        #15
    
    JSR         MOVEA_EA *this will output the source address
    
    *output comma and destination adress A#
    LEA         COMMAOUTPUT,A1
    MOVE.B      #14,D0
    TRAP        #15
        
    JSR         MOVEA_DESTINATION
    
    BRA         END
    
MOVE_WORD
    *output 'MOVE.W'
    MOVE.W (A3), D0
    LSL.W #7, D0
    LSR.W #8, D0
    LSR.W #5, D0
    
    CMP.W #%001, D0
    BEQ INVALID
    
    CMP.W #%101, D0
    BEQ INVALID
    
    CMP.W #%110, D0
    BEQ INVALID
    
    CMP.W #%111, D0
    BEQ CheckWordNEXT
    BRA MOVE_WORDNEXT
CheckWordNEXT
    MOVE.W (A3), D0
    LSL.W #4, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%000, D0
    BEQ MOVE_WORDNEXT
    CMP.W #%001, D0
    BEQ MOVE_WORDNEXT
    BRA INVALID
    
MOVE_WORDNEXT
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    
    CMP.W #%101, D0
    BEQ INVALID
    
    CMP.W #%110, D0
    BEQ INVALID
    
    CMP.W #%111, D0
    BEQ CheckWordReg1
    BRA MOVE_WORDNEXT1
CheckWordReg1
    MOVE.W (A3), D0
    LSL.W #8, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #5, D0
    CMP.W #%000, D0
    BEQ MOVE_WORDNEXT1
    CMP.W #%001, D0
    BEQ MOVE_WORDNEXT1
    BRA INVALID

MOVE_WORDNEXT1
    LEA     MOVEOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     MB17,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     MOVEA_EA *this will output the source address
    
    *output comma and destination adress A#
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     MOVEA_DESTINATION
    
    BRA     END
    
MOVEA_WORD  
    MOVE.W (A3), D0
    LSL.W #5, D0
    LSL.W #5, D0
    LSR.W #8, D0
    LSR.W #8, D0
    
    CMP.W #%101, D0
    BEQ INVALID
    
    CMP.W #%110, D0
    BEQ INVALID

    LEA     MOVEAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     MB17,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     MOVEA_EA
    
    *output comma and destination adress A#
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     MB11,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  D3,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    BRA     END    
************************************************************************************
*************** ANNA OPCODES 1110 *************************************************************************


CHECK_1110 CLR      D0
           CLR      D1
           CLR      D2
           CLR      D3
           CLR      D4
           CLR      D5
           CLR      D6
           CLR      D7
           MOVE.W   (A3),D7 
           BRA      MEMORYSHIFT_1110

MEMORYSHIFT_1110 LSR    #6, D7
                 CMPI   #%1110001111, D7 *LSL Memory shift 
                 BEQ    LSL_MEMSHIFT
                 
                 CMPI   #%1110001011, D7 *LSR Memory shift
                 BEQ    LSR_MEMSHIFT
                 
                 CMPI   #%1110000111, D7 *ASL Memory shift
                 BEQ    ASL_MEMSHIFT
                 
                 CMPI   #%1110000011, D7 *ASR Memory shift
                 BEQ    ASR_MEMSHIFT
                 
                 CMPI   #%1110011111, D7 *ROL Memory shift
                 BEQ    ROL_MEMSHIFT
                 
                 CMPI   #%1110011011, D7 *ROR Memory shift
                 BEQ    ROR_MEMSHIFT
                 
                 BRA    REGISTERSHIFT_1110

LSX_MODE:
         MOVE.W         (A3), D7
         LSR.W          #3, D7
         AND.W          #%000000000111, D7 *Comparing mode bits 010:An 011:(An)+  100:(An)-  aka 2/3/4
         CMPI           #2, D7
         BLT            INVALID *INVALID
         
         CMPI           #4, D7
         BGT            INVALID *INVALID
         
         MOVE.W         D7, D2 *Storing mode in D2
         RTS 


AN_1110 *output An for 1110
        LEA     MB12, A1
        MOVE.B  #14, D0
        TRAP    #15
        
        LEA     MB11, A1
        MOVE.B  #14, D0
        TRAP    #15
        
        MOVE.W  D3, D1
        MOVE.B  #3, D0
        TRAP    #15
        
        LEA     MB13, A1
        MOVE.B  #14, D0
        TRAP    #15
        
        BRA     END *END 
        
ANP_1110 *output (A#)+ for 1110
         LEA    MB12, A1
         MOVE.B #14, D0
         TRAP   #15
         
         LEA    MB11, A1
         MOVE.B #14, D0
         TRAP   #15
         
         MOVE.W D3, D1
         MOVE.B #3, D0
         TRAP   #15
         
         LEA    MB13, A1
         MOVE.B #14, D0
         TRAP   #15
         
         LEA    MB14, A1
         MOVE.B #14, D0
         TRAP   #15
         
         BRA    END *END 

ANM_1110 *output -(An) for 1110
         LEA    MB15, A1
         MOVE.B #14, D0
         TRAP   #15
         
         LEA    MB12, A1
         MOVE.B #14, D0
         TRAP   #15
         
         LEA    MB11, A1
         MOVE.B #14, D0
         TRAP   #15
         
         MOVE.W D3, D1
         MOVE.B #3, D0
         TRAP   #15
         
         LEA    MB13, A1
         MOVE.B #14, D0
         TRAP   #15
         
         BRA    END *END 

LSL_MEMSHIFT 
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7  *Checking the register # of EA bits 0 1
             
             CMPI       #7, D7
             BGT        INVALID * INVALID
             
             CMPI       #0, D7
             BLT        INVALID *INVALID 
             
             MOVE.W     D7, D3 *Moving the register number to D3 
             JSR        LSX_MODE *If it comes back printout
             
             LEA        LSLOUTPUT, A1 
             MOVE.B     #14, D0
             TRAP       #15
             
             CMPI       #2, D2 *Printing out mode
             BEQ        AN_1110
             
             CMPI       #3, D2
             BEQ        ANP_1110
             
             CMPI       #4, D2
             BEQ        ANM_1110
             
             BRA        END *END 
             
             
             
LSR_MEMSHIFT 
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7  *Checking the register # of EA bits 0 1
             
             CMPI       #7, D7
             BGT        INVALID * INVALID
             
             CMPI       #0, D7
             BLT        INVALID *INVALID 
             
             MOVE.W     D7, D3 *Moving the register number to D3 
             JSR        LSX_MODE *If it comes back printout
             
             LEA        LSROUTPUT, A1 
             MOVE.B     #14, D0
             TRAP       #15
             
             CMPI       #2, D2 *Printing out mode
             BEQ        AN_1110
             
             CMPI       #3, D2
             BEQ        ANP_1110
             
             CMPI       #4, D2
             BEQ        ANM_1110
             
             BRA        END *END 
             
ASL_MEMSHIFT 
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7  *Checking the register # of EA bits 0 1
             
             CMPI       #7, D7
             BGT        INVALID * INVALID
             
             CMPI       #0, D7
             BLT        INVALID *INVALID 
             
             MOVE.W     D7, D3 *Moving the register number to D3 
             JSR        LSX_MODE *If it comes back printout
             
             LEA        ASLOUTPUT, A1 
             MOVE.B     #14, D0
             TRAP       #15
             
             CMPI       #2, D2 *Printing out mode
             BEQ        AN_1110
             
             CMPI       #3, D2
             BEQ        ANP_1110
             
             CMPI       #4, D2
             BEQ        ANM_1110
             
             BRA        END *END 
             
ASR_MEMSHIFT 
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7  *Checking the register # of EA bits 0 1
  
             CMPI       #7, D7
             BGT        INVALID * INVALID
             
             CMPI       #0, D7
             BLT        INVALID *INVALID 
             
             MOVE.W     D7, D3 *Moving the register number to D3 
             JSR        LSX_MODE *If it comes back printout
             
             LEA        ASROUTPUT, A1 
             MOVE.B     #14, D0
             TRAP       #15
             
             CMPI       #2, D2 *Printing out mode
             BEQ        AN_1110
             
             CMPI       #3, D2
             BEQ        ANP_1110
             
             CMPI       #4, D2
             BEQ        ANM_1110
             
             BRA        END *END 
             
ROL_MEMSHIFT 
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7  *Checking the register # of EA bits 0 1
             
             CMPI       #7, D7
             BGT        INVALID * INVALID
             
             CMPI       #0, D7
             BLT        INVALID *INVALID 
             
             MOVE.W     D7, D3 *Moving the register number to D3 
             JSR        LSX_MODE *If it comes back printout
             
             LEA        ROLOUTPUT, A1 
             MOVE.B     #14, D0
             TRAP       #15
             
             CMPI       #2, D2 *Printing out mode
             BEQ        AN_1110
             
             CMPI       #3, D2
             BEQ        ANP_1110 
  
             CMPI       #4, D2
             BEQ        ANM_1110
             
             BRA        END *END 
             
ROR_MEMSHIFT 
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7  *Checking the register # of EA bits 0 1
             
             CMPI       #7, D7
             BGT        INVALID * INVALID
             
             CMPI       #0, D7
             BLT        INVALID *INVALID 
             
             MOVE.W     D7, D3 *Moving the register number to D3 
             JSR        LSX_MODE *If it comes back printout
             
             LEA        ROROUTPUT, A1 
             MOVE.B     #14, D0
             TRAP       #15
             
             CMPI       #2, D2 *Printing out mode
             BEQ        AN_1110
             
             CMPI       #3, D2
             BEQ        ANP_1110
             
             CMPI       #4, D2
             BEQ        ANM_1110
             
             BRA        END *END 

REGISTERSHIFT_1110 
                   MOVE.W   (A3), D7
                   LSR.W    #3, D7
                   AND.W    #%0000000000000011, D7 *Comparing bits 3 4
                   
                   CMPI     #%01, D7
                   BEQ      LSLLSR_1000 
                   
                   CMPI     #%00, D7
                   BEQ      ASLASR_1000
                   
                   CMPI     #%11, D7
                   BEQ      ROLROR_1000
                   
                   BRA      INVALID *Invalid 
                   

LSLLSR_1000 
            MOVE.W  (A3), D7 *Determining if LSL/LSR 
            LSR.W   #8, D7
            AND.W   #%00000001, D7 *Comparing bit 8 1:left 0:right 
            
            CMPI    #%1, D7
            BEQ     LSL_REGSHIFT
            
            CMPI    #%0, D7
            BEQ     LSR_REGSHIFT
            
            BRA     INVALID *Invalid 

SIZE_1110 
          CMPI      #0, D4 *Printing size 0:B/ 1:W/ 2:L
          BEQ       BYTE_1110
          
          CMPI      #1, D4
          BEQ       WORD_1110
          
          CMPI      #2, D4
          BEQ       LONG_1110
          
          BRA       INVALID *Invalid 
          
BYTE_1110 
          LEA       MB19, A1
          MOVE.B    #14, D0
          TRAP      #15
          
          CMPI      #0, D6 *Checking if data reg or shift count for 11 10 9 
          BEQ       SHIFT_1110
          
          CMPI      #1, D6
          BEQ       DREG_1110
          
          BRA       INVALID *Invalid 
          
WORD_1110 
          LEA       MB17, A1
          MOVE.B    #14, D0
          TRAP      #15
          
          CMPI      #0, D6 *Checking if data reg or shift count for 11 10 9 
          BEQ       SHIFT_1110
          
          CMPI      #1, D6
          BEQ       DREG_1110
          
          BRA       INVALID *Invalid

LONG_1110 LEA       MB16, A1
          MOVE.B    #14, D0
          TRAP      #15
          
          CMPI      #0, D6 *Checking if data reg or shift count for 11 10 9 
          BEQ       SHIFT_1110
          
          CMPI      #1, D6
          BEQ       DREG_1110
          
          BRA       INVALID *Invalid 

SHIFT8_1110 MOVEQ   #8, D1
            BRA     ASHIFT8
     
SHIFT_1110 LEA      MB18, A1 *Printing # 
           MOVE.B   #14, D0
           TRAP     #15
           
           MOVE.W   D5, D1 *Printing out shift count
           CMPI     #0, D1 *If value is 0 that represents 8 not 0 
           BEQ      SHIFT8_1110
           
ASHIFT8    MOVE.B   #3, D0
           TRAP     #15
           
           LEA      COMMAOUTPUT, A1
           MOVE.B   #14, D0
           TRAP     #15
           
           LEA      MB10, A1
           MOVE.B   #14, D0
           TRAP     #15
           
           MOVE.B   D3, D1
           MOVE.B   #3, D0
           TRAP     #15
           
           BRA      END

DREG_1110  LEA      MB10, A1
           MOVE.B   #14, D0
           TRAP     #15
           
           MOVE.B   D5, D1
           MOVE.B   #3, D0
           TRAP     #15
           
           LEA      COMMAOUTPUT, A1
           MOVE.B   #14, D0
           TRAP     #15
           
           LEA      MB10, A1
           MOVE.B   #14, D0
           TRAP     #15
           
           MOVE.B   D3, D1
           MOVE.B   #3, D0
           TRAP     #15
           
           BRA END
            
LSL_REGSHIFT MOVE.W     (A3), D7 *Determining if operand shift count or data reg 
             LSR.W      #5, D7
             AND.W      #%00000000001, D7
             CMPI       #0, D7  
             BLT        INVALID *invalid 
             
             CMPI       #1, D7
             BGT        INVALID *invalid
             
             MOVE.W     D7, D6 *If valid then put into D6
             MOVE.W     (A3), D7
             LSR.W      #8, D7
             LSR.W      #1, D7
             AND.W      #%0000111, D7 *Shift count amount or data register number 
             
             CMPI       #7, D7
             BGT        INVALID *Invalid
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D5 *Storing count/register number in D5
             MOVE.W     (A3), D7
             LSR.W      #6, D7
             AND.W      #%0000000011, D7 * Bits 6 7 size  (B/W/L)
             
             CMPI       #0, D7
             BLT        INVALID *Invalid
             
             CMPI       #2, D7
             BGT        INVALID *Invalid 
             
             MOVE.W     D7, D4 * Storing (B/W/L) size in D4
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7 *Validing data reg number 
             
             CMPI       #7, D7
             BGT        INVALID *Invalid 
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D3 *Storing data reg # in D3 
             LEA        LSLOUTPUT2, A1 *Printing LSL
             MOVE.B     #14, D0
             TRAP       #15
             
             BRA        SIZE_1110 

LSR_REGSHIFT MOVE.W     (A3), D7 *Determining if operand shift count or data reg 
             LSR.W      #5, D7
             AND.W      #%00000000001, D7
             CMPI       #0, D7  *Bit 5 Either 0:shift count 1:data reg number
             BLT        INVALID *Invalid  
             
             CMPI       #1, D7
             BGT        INVALID *Invalid
             
             MOVE.W     D7, D6 *If valid then put into D6
             MOVE.W     (A3), D7
             LSR.W      #8, D7
             LSR.W      #1, D7
             AND.W      #%0000111, D7 *Shift count amount or data register number 
             
             CMPI       #7, D7
             BGT        INVALID *Invalid 
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D5 *Storing count/register number in D5
             MOVE.W     (A3), D7
             LSR.W      #6, D7
             AND.W      #%0000000011, D7 * Bits 6 7 size  (B/W/L)
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             CMPI       #2, D7
             BGT        INVALID *Invalid 
             
             MOVE.W     D7, D4 * Storing (B/W/L) size in D4
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7 *Validing data reg number 
             CMPI       #7, D7
             BGT        INVALID *Invalid
 
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D3 *Storing data reg # in D3 
             LEA        LSROUTPUT2, A1 *Printing LSL
             MOVE.B     #14, D0
             TRAP       #15
             
             BRA        SIZE_1110 
            
            
ASLASR_1000 MOVE.W      (A3), D7 *Determining if ASL/ASR 
            LSR.W       #8, D7
            AND.W       #%00000001, D7 *Comparing bit 8 1:left 0:right 
            CMPI        #%1, D7
            BEQ         ASL_REGSHIFT
            
            CMPI        #%0, D7
            BEQ         ASR_REGSHIFT
            
            BRA         INVALID *Invalid 
            
ASL_REGSHIFT MOVE.W     (A3), D7 *Determining if operand shift count or data reg 
             LSR.W      #5, D7
             AND.W      #%00000000001, D7
             CMPI       #0, D7  
             BLT        INVALID *Invalid 
             
             CMPI       #1, D7
             BGT        INVALID *Invalid  
             
             MOVE.W     D7, D6 *If valid then put into D6
             MOVE.W     (A3), D7
             LSR.W      #8, D7
             LSR.W      #1, D7
             AND.W      #%0000111, D7 *Shift count amount or data register number 
             CMPI       #7, D7
             BGT        INVALID *Invalid 
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D5 *Storing count/register number in D5
             MOVE.W     (A3), D7
             LSR.W      #6, D7
             AND.W      #%0000000011, D7 * Bits 6 7 size  (B/W/L)
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             CMPI       #2, D7
             BGT        INVALID *Invalid 
             
             MOVE.W     D7, D4 * Storing (B/W/L) size in D4
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7 *Validing data reg number 
             CMPI       #7, D7
             BGT        INVALID *Invalid 
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D3 *Storing data reg # in D3 
             LEA        ASLOUTPUT2, A1 *Printing LSL
             MOVE.B     #14, D0
             TRAP       #15
             
             BRA        SIZE_1110  

ASR_REGSHIFT MOVE.W     (A3), D7 *Determining if operand shift count or data reg 
             LSR.W      #5, D7
             AND.W      #%00000000001, D7
             CMPI       #0, D7  
             BLT        INVALID *Invalid 
             
             CMPI       #1, D7
             BGT        INVALID *Invalid 
             
             MOVE.W     D7, D6 *If valid then put into D6
             MOVE.W     (A3), D7
             LSR.W      #8, D7
             LSR.W      #1, D7
             AND.W      #%0000111, D7 *Shift count amount or data register number 
             
             CMPI       #7, D7
             BGT        INVALID *Invalid 
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D5 *Storing count/register number in D5
             MOVE.W     (A3), D7
             LSR.W      #6, D7
             AND.W      #%0000000011, D7 * Bits 6 7 size  (B/W/L)
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             CMPI       #2, D7
             BGT        INVALID *Invalid 
             
             MOVE.W     D7, D4 * Storing (B/W/L) size in D4
             MOVE.W     (A3), D7
             
             AND.W      #%0000000000000111, D7 *Validing data reg number 
             CMPI       #7, D7
             BGT        INVALID *Invalid 
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D3 *Storing data reg # in D3 
             LEA        ASROUTPUT2, A1 *Printing LSL
             MOVE.B     #14, D0
             TRAP       #15
             
             BRA        SIZE_1110  

ROLROR_1000 MOVE.W      (A3), D7 *Determining if ROL/ROR 
            LSR.W       #8, D7
            AND.W       #%00000001, D7 *Comparing bit 8 1:left 0:right 
            
            CMPI        #%1, D7
            BEQ         ROL_REGSHIFT
            
            CMPI        #%0, D7
            BEQ         ROR_REGSHIFT
            
            BRA         INVALID *Invalid 
            
ROL_REGSHIFT MOVE.W     (A3), D7 *Determining if operand shift count or data reg 
             LSR.W      #5, D7
             AND.W      #%00000000001, D7
             CMPI       #0, D7  
             BLT        INVALID *Invalid 
             
             CMPI       #1, D7
             BGT        INVALID *Invalid 
             
             MOVE.W     D7, D6 *If valid then put into D6
             MOVE.W     (A3), D7
             LSR.W      #8, D7
             LSR.W      #1, D7
             AND.W      #%0000111, D7 *Shift count amount or data register number 
             CMPI       #7, D7
             BGT        INVALID *Invalid 
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D5 *Storing count/register number in D5
             MOVE.W     (A3), D7
             LSR.W      #6, D7
             AND.W      #%0000000011, D7 * Bits 6 7 size  (B/W/L)
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             CMPI       #2, D7
             BGT        INVALID *Invalid 
             
             MOVE.W     D7, D4 * Storing (B/W/L) size in D4
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7 *Validing data reg number 
             CMPI       #7, D7
             BGT        INVALID *Invalid 
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D3 *Storing data reg # in D3 
             
             LEA        ROLOUTPUT2, A1 *Printing LSL
             MOVE.B     #14, D0
             TRAP       #15
             
             BRA        SIZE_1110 

ROR_REGSHIFT MOVE.W     (A3), D7 *Determining if operand shift count or data reg 
             LSR.W      #5, D7
             AND.W      #%00000000001, D7
             CMPI       #0, D7  
             BLT        INVALID *Invalid 
             
             CMPI       #1, D7
             BGT        INVALID *Invalid 
             
             MOVE.W     D7, D6 *If valid then put into D6
             MOVE.W     (A3), D7
             LSR.W      #8, D7
             LSR.W      #1, D7
             AND.W      #%0000111, D7 *Shift count amount or data register number 
             CMPI       #7, D7
             BGT        INVALID *Invalid 
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
 
             MOVE.W     D7, D5 *Storing count/register number in D5
             MOVE.W     (A3), D7
             LSR.W      #6, D7
             AND.W      #%0000000011, D7 * Bits 6 7 size  (B/W/L)
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             CMPI       #2, D7
             BGT        INVALID *Invalid 
             
             MOVE.W     D7, D4 * Storing (B/W/L) size in D4
             MOVE.W     (A3), D7
             AND.W      #%0000000000000111, D7 *Validing data reg number 
             CMPI       #7, D7
             BGT        INVALID *Invalid 
             
             CMPI       #0, D7
             BLT        INVALID *Invalid 
             
             MOVE.W     D7, D3 *Storing data reg # in D3 
             LEA        ROROUTPUT2, A1 *Printing LSL
             MOVE.B     #14, D0
             TRAP       #15
             
             BRA        SIZE_1110 


************************************************************************************
* opcodes branch here after being done
* default address increment will be 2 bytes
* if scanned byte after, increment by 1 byte
* if scanned word after, increment another 2 bytes
* if scanned long after, increment by 4 bytes
* branch to start, called ST

END ADDA.L   #2, A3

    LEA      MB9 ,A1
    MOVE.B   #13, D0
    TRAP     #15 
    ADDI.W   #1, (CURR_LINE) ********************************************************************************************** 5/31 just this line 
    BRA ST

    SIMHALT             ; halt simulator
* Put variables and constants here
CR          EQU $0D            
LF          EQU $0A  

LoopVar1    DC.B    1
*address increment var
AIV         DC.L    $80


*******************************************************************************************************************5/31
CURR_LINE DC.W 1

********************************************* 5/31 end

*common syntax
MB9  DC.B      '', 0
MB10 DC.B      'D', 0
MB11 DC.B      'A', 0
MB12 DC.B      '(', 0
MB13 DC.B      ')', 0
MB14 DC.B      '+', 0
MB15 DC.B      '-', 0
MB16 DC.B      '.L ', 0
MB17 DC.B      '.W ', 0
MB18 DC.B      '#', 0
MB19 DC.B      '.B ',0
MB20 DC.B      '$',0

SPACEOUTPUT DC.B ' ', 0
LEAOUTPUT   DC.B    'LEA ',0
COMMAOUTPUT DC.B    ', ',0
NOPOUTPUT   DC.B    'NOP ',0
RTSOUTPUT   DC.B    'RTS ',0
NOTOUTPUT   DC.B    'NOT',0
JSROUTPUT   DC.B    'JSR ',0
INVALIDOUTPUT DC.B    'INVALID', 0

DEFAULTOUTPUT DC.L    'Enter Starting Address as 8 hexadecimal format: ', 0
DEFAULTOUTPUT1 DC.L    'Enter Ending Address as 8 hexadecimal format: ', 0

*Add and sub output
ADDQOUTPUT DC.B 'ADDQ', 0
ADDAOUTPUT  DC.B    'ADDA',0
ADDOUTPUT   DC.B    'ADD',0
SUBOUTPUT  DC.B    'SUB',0

*AND OR
OROUTPUT    DC.B    'OR',0
ANDOUTPUT   DC.B    'AND',0

*MOVE output
MOVEAOUTPUT DC.B    'MOVEA',0
MOVEOUTPUT  DC.B    'MOVE',0
MOVEQOUTPUT DC.B    'MOVEQ ',0

DATAOUTPUT DC.B    ' DATA ',0

*comparator output
BEQOUTPUT DC.B 'BEQ ', 0
BLEOUTPUT DC.B 'BLE ', 0
BGTOUTPUT DC.B 'BGT ', 0
BRAOUTPUT DC.B 'BRA ', 0

*1110 output reg shift 
LSLOUTPUT2 DC.B 'LSL', 0
LSROUTPUT2 DC.B 'LSR', 0
ASLOUTPUT2 DC.B 'ASL', 0
ASROUTPUT2 DC.B 'ASR', 0
ROLOUTPUT2 DC.B 'ROL', 0
ROROUTPUT2 DC.B 'ROR', 0

*1110 output mem shift 
LSLOUTPUT DC.B 'LSL ', 0
LSROUTPUT DC.B 'LSR ', 0
ASLOUTPUT DC.B 'ASL ', 0
ASROUTPUT DC.B 'ASR ', 0
ROLOUTPUT DC.B 'ROL ', 0
ROROUTPUT DC.B 'ROR ', 0

DONE

    END    START        ; last line of source
