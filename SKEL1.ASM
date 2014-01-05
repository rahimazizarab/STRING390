* Sample of a callable program (refreshable or re-enterable)
* This sample is usable also for reusable or non-reusable programs.
*
*
R0       EQU   0
R1       EQU   1
R2       EQU   2
R3       EQU   3
R4       EQU   4
R5       EQU   5
R6       EQU   6
R7       EQU   7
R8       EQU   8
R9       EQU   9
R10      EQU   10
R11      EQU   11
R12      EQU   12
R13      EQU   13
R14      EQU   14
R15      EQU   15
*
SUBPROG  CSECT
         USING SUBPROG,R15         Register 15 contains address
*UBPROG
         B     START               Skip data
         DC    C'SUBPROG '         Program-name
         DC    C'&SYSDATE'         Date
         DC    C'&SYSTIME'         Time
         DC    C'V1R2.05'          Version number
         DS    0H                  Re-align on halfword-boundary
*
START    STM   R14,R12,12(R13)     Save all registers
         DROP  R15                 No longer needed as base
         LR    R12,R15             Fill reg.12 with base address
         USING SUBPROG,R12         Use reg.12 as base
         LA    R1,PRIVLEN          Amount of storage required
         GETMAIN RU,LV=(R1)        Allocate storage for save-area etc.
* Address of allocated storage now in register 1
         USING PRIVATE,R13         Make storage addressable
         ST    R13,4(R1)           Point to previous save-area
         ST    R1,8(R13)           Point to next save-area
         LR    R13,R1              R13 points to a free save-area again
*        ...                       Other program-code
         OPEN  (SYSOUT,OUTPUT)
*        DISPLAY   'THIS IS DISPLAY'
         LA     R2,PIC3
         LA     R3,PIC3E
         SNAP  DCB=SYSOUT,SDATA=CB,STORAGE=((R2),(R3))
         SPACE                                                          08330000
         CLOSE (SYSOUT)
*        ABEND 0001,DUMP
*
         LR    R15,R15             Returncode in reg.15
EXIT     LR    R1,R13              Keep address of our private area
         L     R13,4(R13)          Get address of previous save-area
         LA    R2,PRIVLEN
         FREEMAIN RU,A=(R1),LV=(R2)   Free allocated storage
         LM    R14,R12,12(R13)     Restore all registers (except 13)
         BR    R14                 Return to caller
         DROP  R12                 Base no longer needed
*
SAVEAREA DS    18F
SYSOUT   DCB   DDNAME=SNAP,DSORG=PS,RECFM=VBA,LRECL=125,               X
               BLKSIZE=1632,MACRF=W
PIC3     DC    C'*** PIC3 ***'
PIC3E    EQU   *-1
         LTORG                     All literals
*
* This dsect describes all variables private to each caller.
PRIVATE  DSECT
P1       DS    1F
*        ...                       Other private variables
PRIVLEN  EQU   *-PRIVATE
         END   SUBPROG
