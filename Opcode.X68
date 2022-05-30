
   
*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    *LEA, NOT, RTS, NOP, JSR Testing
    *JSR (A5)
    *MOVE.W #%0100010111111001, $7000 * LEA $7000, A2 (unable to print $7000)
    *MOVE.W #%0100010111010000, $7000 * LEA (A0),A2
    *MOVE.W #%0100011111010101, $7000 * LEA (A5),A3
    *MOVE.W #%0100011111111000, $7000 * LEA $7000,A3 (unable to print $7000)
    *MOVE.W #%0100111001110001 *NOP
    *MOVE.W #%0100111001110101 *RTS
    *MOVE.W #%0100011000000000  * NOT.B D0
    *MOVE.W #%0100011000010101  *NOT.B  (A5)
    *MOVE.W #%0100011001010101  *NOT.W  (A5)
    *MOVE.W #%0100011010010101  *NOT.L  (A5)
    *MOVE.W #%0100011010011101  *NOT.L  (A5)+
    *MOVE.W #%0100011010100101  *NOT.L  -(A5)
    *MOVE.W #%0100111010010101  *JSR    (A5)
    
    *ADDQ testing
    *MOVE.W #%0101101001000101, $7000 *ADDQ    #5,D5
    *MOVE.W #%0101101000000101, $7000 *ADDQ.B    #5,D5
    *MOVE.W #%0101101001000101, $7000 *ADDQ.W    #5,D5
    *MOVE.W #%0101101010000101, $7000 *ADDQ.L    #5,D5
    *MOVE.W #%0101101001001101, $7000 *ADDQ    #5,A5
    *MOVE.W #%0101101001010101, $7000 *ADDQ    #5,(A5)
    *MOVE.W #%0101101001011101, $7000 *ADDQ    #5,(A5)+
    *MOVE.W #%0101101001100101, $7000 *ADDQ    #5,-(A5)
    *#%0101101001111000, $7000 *ADDQ    #5,$7000
    *AND $8000,D4        *C879 00008000
    *AND D4,$8000        *C779 00008000
    
    *AND (A5),D4         *C855 
    *AND (A5)+,D4        *C85D
    *AND -(A5),D4        *C865
    
    *AND D4,(A5)         *C955
    *AND.B D4,(A5)       *C915
    *AND.L D4,(A5)
    *AND D4,(A5)+        *C95D
    *AND D4,-(A5)        *C965
    *AND D4,D5           *CA44
    
    *OR.W       D0,D1     *8240
    *OR.B       D0,D1     *8200
    *OR.L       D0,D1     *8280
    *OR.L       D2,$8000     *85B8
    *OR.W       D3,$8000     *8779
    *OR.B       D1,$8000     *8339
    *OR.L       $8000,D2     *84B8
    *OR.W       $8000,D6     *8C79
    *OR.B       $8000,D1     *8238
    *OR.W       D1,(A5)      *8355
    *OR.B      (A5),D7       *8E15
    *OR.W       D1,-(A3)     *8363
    *OR.L      -(A5),D7      *8EA5
    *OR.W       D1,(A3)+     *835B
    *OR.L      (A5)+,D7      *8E9D
    *OR.B        #11,D7      *8E3C
    
    *MOVEA.L   (A0),A3
    *MOVEA.L    A3,A4
    *MOVEA.L    D4,A4
    *MOVEA.L     $8000,A4
    *MOVEA.L   (A0)+,A3
    *MOVEA.L   -(A0),A3
    
   * MOVE.L    D0,D1

   * MOVE.L    D0,(A0)

    *MOVE.L    D0,(A0)+

    *MOVE.L    D0,-(A0)
    ***************INPUT*******************************************
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
    
    MOVE.L  $100,A3
    
    *************END_OF_INPUT***************************************
    *******************test input*************************************
     MOVE.W #$84B8, $8000
    
    *LEA     $7000,A3    *A3 is initialize by input
    MOVE.W   #$8000,$8002   *test input
    ******************************************************************
    CLR D7
    *MOVE.W #%0101101001111000, D7
    MOVE.W  (A3),D7

    CLR D3
    MOVE.W (A3), D3
    
    *get first 4 bits
    LSR.W #8, D3
    LSR.W #4, D3
    
    LEA $6000, A2
    MOVE.W D3, (A2)
*********My code starts here *****************************************************************    
MI  CMP.W   #%0100, (A2)
    BEQ     MI1
    BRA     AD
    
AD CMP.W    #%0101, (A2)
    BEQ     ADDQ
    BRA     AND

AND CMP.W #%1100, (A2)
    BEQ   AND_OP
    BRA   AddOrAdda
    
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
    CMP.W #%0111, (A2)
    BEQ CHECK_MOVEQ
    BRA BCC
    
BCC 
    CMP.W #%0110, (A2)
    BEQ BCC2
    BRA SUB

SUB 
    CMP.W #%1001, (A2)
    BEQ SUB1
    BRA MOVE_TYPE_WORD
    
MOVE_TYPE_WORD
    CMP.W   #%0011, (A2)
    BEQ     MOVE_WORD_OP
    BRA     MOVE_BYTE
    
MOVE_BYTE
    CMP.W   #%0001, (A2)
    BEQ     MOVE_BYTE_OP
    BRA     INVALID
    
MI1
    *compare the full byte value to NOP bits value as NOP is full of default values
    CMP.W #%0100111001110001,D7
    BEQ   NOP_OUT
    
    *compare the full byte value to RTS bits value as RTS is full of default values
    CMP.W #%0100111001110101,D7
    BEQ   RTS_OUT    
    
    *separate the bytes in group of 3 bits
    *D3 hold the destination register for LEA, bits 11,10,9
    CLR D3
    MOVE.W D7, D3
    LSL.W #4, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *D4 holds the default value %111 for LEA, bits 8,7,6
    CLR D4
    MOVE.W D7, D4
    LSL.W #7, D4
    LSR.W #8, D4
    LSR.W #5, D4

    *D5 holds the source mode value for LEA, bits 5,4,3
    CLR D5
    MOVE.W D7, D5
    LSL.W #8, D5
    LSL.W #2, D5
    LSR.W #8, D5
    LSR.W #5, D5
    
    *D6 holds the source register value for LEA, bits 2,1,0
    CLR D6
    MOVE.W D7, D6
    LSL.W #8, D6
    LSL.W #5, D6
    LSR.W #8, D6
    LSR.W #5, D6
    
    *compare 111 with D4 which will show if the value is LEA
    CMP #%111,D4
    BEQ LEA_OUT
    
    *compare 011 with D3 which will show if the value is NOT
    CMP #%011,D3
    BEQ NOT_OUT
    
    CMP #%111,D3
    BEQ JSR_OUT
    
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
    BEQ     EA_D_OUTPUT
    
    CMP     #%010,D5
    BEQ     INDIRECT_EA_OUTPUT

    CMP     #%011,D5
    BEQ     INDIRECT_EA_PLUS_OUTPUT
    
    CMP     #%100,D5
    BEQ     INDIRECT_EA_MINUS_OUTPUT
    
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
        
LEA_OUT
    *Load the LEA message
    LEA      LEAOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    CMP.W   #%111,D5 *dont know how to output address $####
    BEQ     EA_REGISTER
    
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
    
    LEA     COMMAOUTPUT ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    *output the destination register, 'A', and a comma
    LEA     MB11,A1
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
    BRA     REGISTER_L
    
    BRA     INVALID

***********EA WORD and LONG*******************
REGISTER_W 
    ADDA.L  #2,A3
    MOVE.W  (A3)+,D2
     
    JSR     PRINT_EA
    
    RTS
    
    BRA     END
REGISTER_L
    ADDA.L  #2,A3
    MOVE.L  (A3)+,D2
    
    JSR     PRINT_EA
    
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
    MOVE.W  D6,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    LEA      MB13 ,A1
    MOVE.B   #14, D0
    TRAP     #15
    
    RTS
    
    BRA     END

INDIRECT_EA_PLUS_OUTPUT *output (A#)+
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
    
    *output + sign 
    MOVE.W   #$2B,D1
    MOVE.B   #6,D0
    TRAP     #15
    
    RTS
    
    BRA      END    

INDIRECT_EA_MINUS_OUTPUT    *output -(A#)
    *output - sign 
    MOVE.W   #$2D,D1
    MOVE.B   #6,D0
    TRAP     #15
    
    BRA INDIRECT_EA_OUTPUT
    
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

EA_A_OUTPUT *output A#
    LEA     MB11,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.W  D6,D1
    MOVE.B  #3,D0
    TRAP    #15
    
    RTS
    
    BRA      END
    
NOP_OUT *output 'NOP'
    LEA     NOPOUTPUT,A1
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

    BRA      INDIRECT_EA_OUTPUT

*******************************************************************
*********ADDQ*************************************************************************    
ADDQ
   *separate the bytes in group of 3 bits
    *D3 hold the Data between 000-111 for ADDQ and the Data register for SUB, bits 11,10,9
    CLR D3
    MOVE.W D7, D3
    LSL.W #4, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *D4 holds the size for ADDQ and theh Opmode for SUB, bits 8,7,6
    CLR D4
    MOVE.W D7, D4
    LSL.W #7, D4
    LSR.W #8, D4
    LSR.W #5, D4

    *D5 holds the source mode value both, bits 5,4,3
    CLR D5
    MOVE.W D7, D5
    LSL.W #8, D5
    LSL.W #2, D5
    LSR.W #8, D5
    LSR.W #5, D5
    
    *D6 holds the source register value for both, bits 2,1,0
    CLR D6
    MOVE.W D7, D6
    LSL.W #8, D6
    LSL.W #5, D6
    LSR.W #8, D6
    LSR.W #5, D6
    
    *output ADDQ
    LEA ADDQOUTPUT,A1
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
    
    LEA    COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
 
    *output D# 
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
    
    BRA     END
    
ADDQ_BYTE
    LEA      MB19, A1
    MOVE.B   #14, D0
    TRAP     #15    
    BRA     DATARANGE
    
ADDQ_WORD
    LEA      MB17, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA     DATARANGE
    
ADDQ_LONG
    LEA      MB16, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA     DATARANGE
    
INVALID 
    LEA      INVALIDOUTPUT , A1
    MOVE.B   #14, D0
    TRAP     #15  
    BRA     END  
**************************************************************************************** 

*********OUTPUT_HEX*********************************************************************
PRINT_EA
   *LETS say hexadecimal is stored in d2
   
   *this program uses A6, A5, A1
   LEA      MB20, A1
   MOVE.B   #14, D0
   TRAP     #15
   
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
* this is if long
    MOVE.L (A6)+, (A1)+
    MOVE.L (A6), (A1)
    LEA $400, A1    
    
    CMP.B #2, D1
    BEQ ED1
    
    CMP.B #4, D1
    BEQ ED2
    
    BRA ED3

ED1 ADDA.W #6, A1 
    BRA ED4

ED2 ADDA.L #4, A1
    BRA ED4
ED3   
    BRA ED4 
    
ED4 MOVE.B #1, D0
    TRAP #15
     
    RTS
***************************************************************************************

***********************AND*************************************************************
AND_OP
    *separate the bytes in group of 3 bits
    *D3 hold the register which is Dn or An, bits 11, 10, 9
    CLR D3
    MOVE.W D7, D3
    LSL.W #4, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *D4 holds the opmode, bits 8,7,6
    CLR D4
    MOVE.W D7, D4
    LSL.W #7, D4
    LSR.W #8, D4
    LSR.W #5, D4

    *D5 holds the effective address mode value, bits 5,4,3
    CLR D5
    MOVE.W D7, D5
    LSL.W #8, D5
    LSL.W #2, D5
    LSR.W #8, D5
    LSR.W #5, D5
    
    *D6 holds the effective address register value, bits 2,1,0
    CLR D6
    MOVE.W D7, D6
    LSL.W #8, D6
    LSL.W #5, D6
    LSR.W #8, D6
    LSR.W #5, D6
    
    *output 'AND'
    LEA     ANDOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *compare D4 to determine what type of opmode it has
    *The value is Dn and Byte
    CMP.W   #%100,D4
    BEQ     D_BYTE
    
    *The value is Dn and Word
    CMP.W   #%101,D4
    BEQ     D_WORD
    
    *The value is Dn and Long
    CMP.W   #%110,D4
    BEQ     D_LONG
    
    *The value is An and Byte
    CMP.W   #%000,D4
    BEQ     EA_BYTE
    
    *The value is An and Word
    CMP.W   #%001,D4
    BEQ     EA_WORD
    
    *The value is An and Long
    CMP.W   #%010,D4
    BEQ     EA_LONG
    
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
    CLR D3
    MOVE.W (A3), D3
    LSL.W #7, D3
    LSR.W #8, D3
    LSR.W #5, D3
    CMP.W #%011, D3
    BEQ Adda
    CMP.W #%111, D3
    Beq Adda
    
    CMP.W #%000, D3
    BEQ Add
    CMP.W #%100, D3
    BEQ Add
    CMP.W #%001, D3
    BEQ Add
    CMP.W #%101, D3
    BEQ Add
    CMP.W #%010, D3
    BEQ Add
    CMP.W #%110, D3
    BEQ Add    
    BRA INVALID
    
*determined if it is Add
Add 
    LEA      ADDOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    *opmode is still in d3
    CMP.W #%000, D3
    BEQ AddPrintB
    CMP.W #%100, D3
    BEQ AddPrintB
    
    CMP.W #%001, D3
    BEQ AddPrintW
    CMP.W #%101, D3
    BEQ AddPrintW
    
    CMP.W #%110, D3
    BEQ AddPrintL
    CMP.W #%010, D3
    BEQ AddPrintL
    
    BRA invalid
*size printers
AddPrintB
    LEA      MB19, A1
    MOVE.B   #14, D0
    TRAP     #15
    CMP.W #%000, D3
    BEQ EAfirst
    BRA DnFirst

AddPrintW
    LEA      MB17, A1
    MOVE.B   #14, D0
    TRAP     #15
    CMP.W #%001, D3
    BEQ EAfirst
    BRA DnFirst

AddPrintL
    LEA      MB16, A1
    MOVE.B   #14, D0
    TRAP     #15
    CMP.W #%010, D3
    BEQ EAfirst
    BRA DnFirst
*end of size printers
*this means source operand is first
EAfirst
    
    *address is in a3
    MOVE.W (A3), D3
    *left 10, right 13
    LSL.W #8, D3
    LSL.W #2, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *if it is a word or a long address
    CMP.W #%111, D3
    BEQ AddPrintEA
    *Before going to subroutine, change d1 based on EA register
    
    *else check for the 4 An modes
    
    *Now we know it is not .W or .L so we check what statement to output
    * for the address register as the source
    
    *Dn
    CMP.W #%000, D3
    BEQ AddSourceDn
    *we can use the same subroutine to print this stuff for DNfirst
    
    *An
    CMP.W #%001, D3
    BEQ AddSourceAn
    
    *(An)
    CMP.W #%010, D3
    BEQ AddSourcePAn
    *(An)+
    CMP.W #%011, D3
    BEQ AddSourceIAn
    *-(An)
    CMP.W #%100, D3
    BEQ AddSourceDAn
    
    BRA INVALID
 
*Dn
AddSourceDn
    LEA      MB10, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.W D3, D1
    MOVE.W #3, D0
    TRAP #15
    
    BRA AddPrintDest

*An
AddSourceAn
    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.W D3, D1
    MOVE.W #3, D0
    TRAP #15

    BRA AddPrintDest

*(An)
AddSourcePAn
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.B D3, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15

    BRA AddPrintDest

*(An)+
AddSourceIAn
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.B D3, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB14, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA AddPrintDest

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

    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.B D3, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA AddPrintDest

DnFirst
*output the data register
   LEA      MB10, A1
   MOVE.B   #14, D0
   TRAP     #15
   CLR D3
   MOVE.W (A3), D3
   LSL.W #4, D3
   LSR.W #8, D3
   LSR.W #5, D3
   
   
   MOVE.W D3, D1
   MOVE.B   #3, D0
   TRAP     #15
   
   LEA      COMMAOUTPUT, A1
   MOVE.B   #14, D0
   TRAP     #15
   
    
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #2, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *if it is a word or a long address
    CMP.W #%111, D3
    BEQ DnFirstWL
    
    *(An)
    CMP.W #%010, D3
    BEQ DnAn
    
    *(An)+
    CMP.W #%011, D3
    BEQ DnAnPlus
    
    *-(An)
    CMP.W #%100, D3
    BEQ DnAnMinus
    
    BRA INVALID
DnAn
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.B D3, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    BRA END
DnAnPlus
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.B D3, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB14, A1
    MOVE.B   #14, D0
    TRAP     #15

    BRA END
    
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

    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.B D3, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15

    BRA END
   
*find which one to output next
*Destination wise, 3 of the (An) is allowed and .W and .L are too

*word or long
DnFirstWL
   MOVE.W (A3), D3
   LSL.W #8, D3
   LSL.W #5, D3
   LSR.W #8, D3
   LSR.W #5, D3
   CMP.W #%000, D3
   BEQ DnW
   BRA DnL

DnW
   ADDA.L #2, A3
   MOVE.W (A3), D2
   MOVE.L #4, D1
   JSR PRINT_EA
   SUBA.L #2, A3
   BRA END

DnL
   ADDA.L #2, A3
   MOVE.L (A3), D2
   MOVE.L #8, D1
   JSR PRINT_EA
   SUBA.L #2, A3
   BRA END

AddPrintEA
   
   MOVE.W (A3), D3
   LSL.W #8, D3
   LSL.W #5, D3
   LSR.W #8, D3
   LSR.W #5, D3
   
   CMP.W #%000, D3
   BEQ AddPrintSourceW
   
   CMP.W #%100, D3
   BEQ AddPrintIm
   
   BRA AddPrintSourceL
   
AddPrintIM
   MOVE.W (A3), D3
   LSL.W #7, D3
   LSR.W #8, D3
   LSR.W #5, D3
   CMP.W #%000, D3
   BEQ AddPrintIMB
   CMP.W #%001, D3
   BEQ AddPrintIMW
   BRA AddPrintIML
   
AddPrintIMB
   ADDA.L #2, A3
   MOVE.W (A3), D2
   MOVE.L #2, D1
   JSR PRINT_EA1
   SUBA.L #2, A3
   BRA AddPrintDest
   
AddPrintIMW
   ADDA.L #2, A3
   MOVE.W (A3), D2
   MOVE.L #4, D1
   JSR PRINT_EA1
   SUBA.L #2, A3
   BRA AddPrintDest
   
AddPrintIML
   ADDA.L #2, A3
   MOVE.B (A3), D2
   MOVE.L #8, D1
   JSR PRINT_EA1
   SUBA.L #2, A3
   BRA AddPrintDest
   
AddPrintSourceW
   ADDA.L #2, A3
   MOVE.W (A3), D2
   MOVE.L #4, D1
   JSR PRINT_EA
   SUBA.L #2, A3
   
   BRA AddPrintDest
AddPrintSourceL
   ADDA.L #2, A3
   MOVE.L (A3), D2
   MOVE.L #8, D1
   JSR PRINT_EA
   SUBA.L #2, A3
   BRA AddPrintDest
AddPrintDest
   LEA      COMMAOUTPUT, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   LEA      MB10, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   
   CLR D3
   MOVE.W (A3), D3
   LSL.W #4, D3
   LSR.W #8, D3
   LSR.W #5, D3
   
   
   MOVE.W D3, D1
   MOVE.B   #3, D0
   TRAP     #15
   BRA END

********************************ADDA**************************************************************
*determined it is Adda    
Adda 
    *opcode is stored in d3 and it is valid
    LEA      ADDAOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    CMP.W #%011, D3
    BEQ AddaW
    BRA AddaL
*determined if it is Add
AddaW
    LEA      MB17, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    BRA AddaPrintEA

AddaL
    LEA      MB16, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    BRA AddaPrintEA
    
AddaPrintEA
    *address is in a3
    MOVE.W (A3), D3
    *left 10, right 13
    LSL.W #8, D3
    LSL.W #2, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *this takes care of .W, .L, and #
    CMP.W #%111, D3
    BEQ AddaWL
    
    *Dn
    CMP.W #%000, D3
    BEQ AddaDn
    
    *An
    CMP.W #%001, D3
    BEQ AddaAn
    
    *(An)
    CMP.W #%010, D3
    BEQ AddaPan
    
    *(An)+
    CMP.W #%011, D3
    BEQ AddaPlus
    
    *-(An)
    CMP.W #%100, D3
    BEQ AddaMinus
    
    
    
    
*figure out if word or long or intermediate
*intermediate is always stored in 8, so treat as a long
*BUT output a different symbol    
AddaWL
   *address is in a3
    MOVE.W (A3), D3
    *left 13, right 13
    LSL.W #8, D3
    LSL.W #5, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *000 branch to Word
    CMP.W #%000, D3
    BEQ AddaWLW
    
    *001 branch to Long
    CMP.W #%001, D3
    BEQ AddaWLL
    
    *100 branch to intermediate
    CMP.W #%100, D3
    BEQ AddaWLI
    *intermediate length based on opcode
    
    BRA INVALID
    *branch invalid
    
AddaWLW
   ADDA.L #2, A3
   MOVE.W (A3), D2
   MOVE.L #4, D1
   JSR PRINT_EA
   SUBA.L #2, A3
   BRA AddaEnd

AddaWLL
   ADDA.L #2, A3
   MOVE.L (A3), D2
   MOVE.L #8, D1
   JSR PRINT_EA
   SUBA.L #2, A3
   BRA AddaEnd

AddaWLI
   *address is in a3
    MOVE.W (A3), D3
    *left 13, right 13
    LSL.W #7, D3
    LSR.W #8, D3
    LSR.W #5, D3
    *011 word size
    CMP.W #%011, D3
    BEQ AddaWLIW
    BRA ADDAWLIL
    
AddaWLIW
   ADDA.L #2, A3
   MOVE.W (A3), D2
   MOVE.L #4, D1
   JSR PRINT_EA1
   SUBA.L #2, A3
   BRA AddaEnd    
   
ADDAWLIL
   ADDA.L #2, A3
   MOVE.L (A3), D2
   MOVE.L #8, D1
   JSR PRINT_EA1
   SUBA.L #2, A3
   BRA AddaEnd

*Dn
AddaDn
   LEA      MB10, A1
   MOVE.B   #14, D0
   TRAP     #15
    
   CLR D3
   MOVE.W (A3), D3
   LSL.W #8, D3
   LSL.W #5, D3
   
   LSR.W #8, D3
   LSR.W #5, D3
    
   MOVE.W D3, D1
   MOVE.W #3, D0
   TRAP #15
   BRA AddaEnd

*An
AddaAn
    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.W D3, D1
    MOVE.W #3, D0
    TRAP #15
   BRA AddaEnd
*(An)
AddaPAn
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.B D3, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15

   BRA AddaEnd
*(An)+
AddaPlus
    LEA      MB12, A1
    MOVE.B   #14, D0
    TRAP     #15

    LEA      MB11, A1
    MOVE.B   #14, D0
    TRAP     #15

    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.B D3, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
    
    LEA      MB14, A1
    MOVE.B   #14, D0
    TRAP     #15
   BRA AddaEnd
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

    CLR D3
    MOVE.W (A3), D3
    LSL.W #8, D3
    LSL.W #5, D3
    
    LSR.W #8, D3
    LSR.W #5, D3
    
    MOVE.B D3, D1
    MOVE.B #3, D0
    TRAP #15
    
    LEA      MB13, A1
    MOVE.B   #14, D0
    TRAP     #15
   BRA AddaEnd

AddaEnd
   LEA      COMMAOUTPUT, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   LEA      MB11, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   MOVE.W (A3), D3
   LSL.W #4, D3
   LSR.W #8, D3
   LSR.W #5, D3
   
   CLR D1
   MOVE.W D3, D1
   MOVE.B #3, D0
   TRAP #15
   
   BRA END
********************************************END OF ADDA************************************************
********************************Print # intermediate**********************************************
PRINT_EA1
   *LETS say hexadecimal is stored in d2
   
   *this program uses A6, A5, A1
   LEA      MB18, A1
   MOVE.B   #14, D0
   TRAP     #15
   
   BRA PRINT_EA
*************************************************************************************************

******************OR_OP*************************************************************************
OR_OP
    *separate the bytes in group of 3 bits
    *D3 hold the register which is Dn or An, bits 11, 10, 9
    CLR D3
    MOVE.W D7, D3
    LSL.W #4, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *D4 holds the opmode, bits 8,7,6
    CLR D4
    MOVE.W D7, D4
    LSL.W #7, D4
    LSR.W #8, D4
    LSR.W #5, D4

    *D5 holds the effective address mode value, bits 5,4,3
    CLR D5
    MOVE.W D7, D5
    LSL.W #8, D5
    LSL.W #2, D5
    LSR.W #8, D5
    LSR.W #5, D5
    
    *D6 holds the effective address register value, bits 2,1,0
    CLR D6
    MOVE.W D7, D6
    LSL.W #8, D6
    LSL.W #5, D6
    LSR.W #8, D6
    LSR.W #5, D6
    
    *output 'AND'
    LEA     OROUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    *compare D4 to determine what type of opmode it has
    *The value is Dn and Byte
    CMP.W   #%100,D4
    BEQ     D_BYTE
    
    *The value is Dn and Word
    CMP.W   #%101,D4
    BEQ     D_WORD
    
    *The value is Dn and Long
    CMP.W   #%110,D4
    BEQ     D_LONG
    
    *The value is An and Byte
    CMP.W   #%000,D4
    BEQ     EA_BYTE
    
    *The value is An and Word
    CMP.W   #%001,D4
    BEQ     EA_WORD
    
    *The value is An and Long
    CMP.W   #%010,D4
    BEQ     EA_LONG
    
    BRA     INVALID
*******************OR_OP END********************************************************************
*******************MOVE_LONG_OP START***********************************************************
MOVE_LONG_OP
    *separate the bytes in group of 3 bits
    *D3 hold the destination register for LEA, bits 11,10,9
    CLR D3
    MOVE.W D7, D3
    LSL.W #4, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *D4 holds the default value %111 for LEA, bits 8,7,6
    CLR D4
    MOVE.W D7, D4
    LSL.W #7, D4
    LSR.W #8, D4
    LSR.W #5, D4

    *D5 holds the source mode value for LEA, bits 5,4,3
    CLR D5
    MOVE.W D7, D5
    LSL.W #8, D5
    LSL.W #2, D5
    LSR.W #8, D5
    LSR.W #5, D5
    
    *D6 holds the source register value for LEA, bits 2,1,0
    CLR D6
    MOVE.W D7, D6
    LSL.W #8, D6
    LSL.W #5, D6
    LSR.W #8, D6
    LSR.W #5, D6

    CMP.W   #%001,D4 *if D4 is %001 then it is a MOVEA type
    BEQ     MOVEA_LONG
    
    BRA     MOVE_LONG
    
    BRA     END

MOVE_LONG
    *output 'MOVE.L'
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
    
    RTS
    
    BRA     END

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
    
    RTS
    
    BRA     END
    
******************************************MOVEQ**********************************************
CHECK_MOVEQ CLR D3
           MOVE.W (A3), D7
           LSR.W  #8, D7
           AND.W  #%00000001, D7 *Checking bit 8 to make sure that it is 0
           CMPI #0, D7 
           BNE  INVALID * Right now just ending program if invalid 
           MOVE.W (A3), D7
           LSR.W #8, D7
           LSR.W #1, D7
           AND.W #%0000111, D7 *Checking bits 11 10 9 to make sure that it is valid data register
           CMPI #7, D7
           BGT INVALID
           CMPI #0, D7
           BLT INVALID
           MOVE.B D7, D6 *Storing data register number of opcode in D3 
           MOVE.W (A3),D7
           AND.W #%0000000011111111, D7
           MOVE.W D7, D1 *Storing source immediate data value in register D1 (# betw -127 and 127)
           BRA PRINT_MOVEQ  *Clear d7/d6/d4/d1

PRINT_MOVEQ LEA MOVEQOUTPUT, A1
            MOVE.B #14, D0
            TRAP #15
            
            LEA MB18, A1
            MOVE.B #14, D0
            TRAP #15
            
            MOVE.B #3, D0 * Outputting source immediate data value located in D1 
            TRAP #15
            
            LEA COMMAOUTPUT, A1
            MOVE.B #14, D0
            TRAP #15
            
            JSR EA_D_OUTPUT
            
            CLR D7
            CLR D6
            CLR D4
            CLR D0
            CLR D1
            BRA END 

**************************************MOVEQ END****************************************************   

*********SUB**************************************************************************************
SUB1 
     *Output 'Sub'
     LEA      SUBOUTPUT, A1
     MOVE.B   #14, D0
     TRAP     #15
     
     CLR D3
     MOVE.W (A3), D3
     LSL.W #7, D3
     LSR.W #8, D3
     LSR.W #5, D3
     
    *SUB uses the same format as AddaW and AddaL
    CMP.W #%011, D3
    BEQ AddaW
    BRA AddaL
      

*********SUB ENDS*********************************************************************************

*********Andy Bcc (BEQ, BLE, BGT, BRA)*****************************************    
BCC2
    MOVE.W (A3), D3
    LSL.W #4, D3
    LSR.W #8, D3
    LSR.W #4, D3
    
    CMP.W #%1111, D3
    BEQ BLE
    
    CMP.W #%0111, D3
    BEQ BEQ
    
    CMP.W #%1110, D3
    BEQ BGT
    
    CMP.W #%1110, D3
    BEQ BGT
    
    CMP.W #%0000, D3
    BEQ BRRA
    
    BRA INVALID

BLE LEA      BLEOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA BCC3

BEQ LEA      BEQOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA BCC3

BGT LEA      BGTOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA BCC3
    
BRRA
    LEA      BRAOUTPUT, A1
    MOVE.B   #14, D0
    TRAP     #15
    BRA BCC3

BCC3 CLR D3
     MOVE.W (A3), D3
     LSL.W #8, D3
     LSR.W #8, D3
     
     CMP.W #$FF, D3
     BEQ  ScanLong
     
     CMP.W #$00, D3
     BEQ ScanWord
     
     BRA ScanOp
     
ScanLong
     BRA DnL

ScanWord
     Bra DnW

ScanOp
     CLR D2
     MOVE.W D3, D2
     MOVE.L #2, D1
     BRA PRINT_EA


********Andy Bcc ends here************************************************

******************MOVE_BYTE_OP******************************************************
MOVE_BYTE_OP
    *separate the bytes in group of 3 bits
    *D3 holds, bits 11,10,9
    CLR D3
    MOVE.W D7, D3
    LSL.W #4, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *D4 holds, bits 8,7,6
    CLR D4
    MOVE.W D7, D4
    LSL.W #7, D4
    LSR.W #8, D4
    LSR.W #5, D4

    *D5 holds the source mode value, bits 5,4,3
    CLR D5
    MOVE.W D7, D5
    LSL.W #8, D5
    LSL.W #2, D5
    LSR.W #8, D5
    LSR.W #5, D5
    
    *D6 holds the source register value, bits 2,1,0
    CLR D6
    MOVE.W D7, D6
    LSL.W #8, D6
    LSL.W #5, D6
    LSR.W #8, D6
    LSR.W #5, D6

    CMP.W   #%001,D4 *if D4 is %001 then it is invalid because it means the destination MODE is A#
    BEQ     INVALID
    
    BRA     MOVE_BYTE_OUT
    
    BRA     END

************************************************************************************
******************MOVE_WORD_OP******************************************************
MOVE_WORD_OP
    *separate the bytes in group of 3 bits
    *D3 holds, bits 11,10,9
    CLR D3
    MOVE.W D7, D3
    LSL.W #4, D3
    LSR.W #8, D3
    LSR.W #5, D3
    
    *D4 holds, bits 8,7,6
    CLR D4
    MOVE.W D7, D4
    LSL.W #7, D4
    LSR.W #8, D4
    LSR.W #5, D4

    *D5 holds the source mode value, bits 5,4,3
    CLR D5
    MOVE.W D7, D5
    LSL.W #8, D5
    LSL.W #2, D5
    LSR.W #8, D5
    LSR.W #5, D5
    
    *D6 holds the source register value, bits 2,1,0
    CLR D6
    MOVE.W D7, D6
    LSL.W #8, D6
    LSL.W #5, D6
    LSR.W #8, D6
    LSR.W #5, D6

    CMP.W   #%001,D4 *if D4 is %001 then it is a MOVEA type
    BEQ     MOVEA_WORD
    
    BRA     MOVE_WORD
    
    BRA     END
    
MOVE_BYTE_OUT
*output 'MOVE.L'
    LEA     MOVEOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    LEA     MB19,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     MOVEA_EA *this will output the source address
    
    *output comma and destination adress A#
    LEA     COMMAOUTPUT,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    JSR     MOVEA_DESTINATION
    
    BRA     END
    
MOVE_WORD
    *output 'MOVE.L'
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

END

    SIMHALT             ; halt simulator
* Put variables and constants here
CR      EQU $0D            
LF      EQU $0A  

LoopVar1    DC.B    1

*common syntax
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

LEAOUTPUT   DC.B    'LEA ',0
COMMAOUTPUT DC.B    ', ',0
NOPOUTPUT   DC.B    'NOP ',0
RTSOUTPUT   DC.B    'RTS ',0
NOTOUTPUT   DC.B    'NOT',0
JSROUTPUT   DC.B    'JSR ',0
INVALIDOUTPUT DC.B    'INVALID', 0

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

*comparator output
BEQOUTPUT DC.B 'BEQ ', 0
BLEOUTPUT DC.B 'BLE ', 0
BGTOUTPUT DC.B 'BGT ', 0
BRAOUTPUT DC.B 'BRA ', 0


    END    START        ; last line of source
