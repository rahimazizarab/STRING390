         MACRO                                                          00010000
&NAME    STRING &INTO=,&PRINT='NOGEN'                                   00020000
.NOGEN   ANOP                                                           00030000
         AIF    (N'&SYSLIST GT 0).OKLIST                                00040000
.OKLIST  ANOP                                                           00050000
         LCLA   &I,&J,&N,&LABEL,&LQ,&P2L,&FLAG,&LEN2,&L                 00060000
         LCLC   &TO1,&TO2,&TO3,&P1S,&P2C,&P3C,&P3L                      00070000
         GBLA   &FIELD,&MAXBL                                           00080000
         GBLC   &SYSDATC,&FIELDS(9999)                                  00090000
&SYSDATC SETC  '20'.'&SYSDATE'(7,2)'&SYSDATE'(1,2)'&SYSDATE'(4,2)       00100000
         MNOTE 0,'SYSTEM DATE IS &SYSDATC'                              00110000
         AIF   (N'&SYSLIST EQ 0).ERR1  NO POSITIONAL OPERANDS, ERROR    00120000
         AIF   (T'&INTO EQ 'O').ERR2   NO RECEIVING FIELD, ERROR        00130000
         AIF   (N'&INTO GT 2).ERR2     INTO=(A,32,BLURB)                00140000
         AIF    (N'&SYSLIST EQ 1 AND '&SYSLIST(1)' EQ 'FINAL_CALL'     X00150000
                AND T'&INTO EQ 'O').GENL                                00160000
.*                                                                      00170000
.GENL    ANOP                                                           00180000
&TO1     SETC   '=C'                                                    00190000
&L       SETA  K'&SYSLIST(1)                   LENGTH OF TEXT           00200000
&J       SETA  N'&SYSLIST                      NUMBER OF TEXT           00210000
&N       SETA  &L-2                                                     00220000
&TO2     SETC  '(&N)'                                                   00230000
         AGO   .MOV                                                     00240000
N&SYSNDX DC    C&SYSLIST(1)                                             00250000
.MOV     ANOP                                                           00260000
         MVC   &INTO&TO2,&TO1&SYSLIST(1)                                00270000
         AGO   .MEND                                                    00280000
.ERR1    MNOTE 12,'AT LEAST ONE INPUT FIELD MUST BE SPECIFIED'          00290000
         AGO   .MEND                                                    00300000
.ERR2    MNOTE 12,'INVALID OUTPUT AREA SPECIFICATION'                   00310000
         AGO   .MEND                                                    00320000
.MEND    ANOP                                                           00330000
         MEND                                                           00340000
ADD      TITLE 'TEST PROGRAM'                                           00350000
ADD      CSECT                                                          00360000
*                                                                       00370000
*-------------------------------------------------------------------    00380000
*                                                                       00390000
*        register equates                                               00400000
*                                                                       00410000
*-------------------------------------------------------------------    00420000
*                                                                       00430000
R0       EQU   0                       register 0                       00440000
R1       EQU   1                       register 1                       00450000
R2       EQU   2                       register 2                       00460000
R3       EQU   3                       register 3                       00470000
R4       EQU   4                       register 4                       00480000
R5       EQU   5                       register 5                       00490000
R6       EQU   6                       register 6                       00500000
R7       EQU   7                       register 7                       00510000
R8       EQU   8                       register 8                       00520000
R9       EQU   9                       register 9                       00530000
R10      EQU   10                      register 10                      00540000
R11      EQU   11                      register 11                      00550000
R12      EQU   12                      base register                    00560000
R13      EQU   13                      save area register               00570000
R14      EQU   14                      caller's return address          00580000
ENTRYREG EQU   15                      entry address                    00590000
R15      EQU   15                      return code                      00600000
         EJECT                                                          00610000
*                                                                       00620000
*-------------------------------------------------------------------    00630000
*                                                                       00640000
*        standard entry setup, save area chaining, establish            00650000
*        base register and addressibility                               00660000
*                                                                       00670000
*-------------------------------------------------------------------    00680000
*                                                                       00690000
         USING ADD,R15            establish addressibility              00700000
         B     SETUP                   branch around eyecatcher         00710000
         DC    CL8'ADD'                program name                     00720000
         DC    CL8'&SYSDATE'           program assembled date           00730000
SETUP    STM   R14,R12,12(R13)  save caller's registers                 00740000
         BALR  R12,R0              establish base register              00750000
         USING *,R12               establish addressibilty              00760000
         ST    R13,SAVEMAIN+4     save main  Address                    00770000
         LA    R13,SAVEMAIN       save saveare address                  00780000
*                                          area                         00790000
         EJECT                                                          00800000
*                                                                       00810000
*-------------------------------------------------------------------    00820000
*                                                                       00830000
*        program body                                                   00840000
*                                                                       00850000
*-------------------------------------------------------------------    00860000
         OPEN  (PRTLINE,OUTPUT)                                         00870000
         STRING 'MACRO  MSG',INTO=LINE+1                                00880000
         L     R15,=A(SUB1)       ! LOAD ADDRESS OF SUBROUTINE IN R15   00890000
         BALR  R14,R15            ! save return address in r14 and s    00900000
         PUT   PRTLINE,LINE                                             00910000
         STRING ' DATE is ',INTO=LINE+1                                 00920000
         PUT   PRTLINE,LINE                                             00930000
LOOPINIT DS    0H                                                       00940000
         MVC   LINE+1(77),STATLIN                                       00950000
         L     R2,COUNTER                                               00960000
*                                                                       00970000
LOOP     DS    0H                                                       00980000
*                                                                       00990000
         ED    OUT,TOT                                                  01000000
         MVC   LINE+77(6),OUT                                           01010000
         PUT   PRTLINE,LINE                                             01020000
         MVC   OUT,=X'402020202020'                                     01030000
         AP    TOT,ONE                                                  01040000
*                                                                       01050000
         BCT   R2,LOOP                                                  01060000
*                                                                       01070000
         CLOSE (PRTLINE)                                                01080000
*                                                                       01090000
*-------------------------------------------------------------------    01100000
*                                                                       01110000
*        standard exit -  restore caller's registers and                01120000
*        return to caller                                               01130000
*                                                                       01140000
*-------------------------------------------------------------------    01150000
*                                                                       01160000
EXIT     DS    0H                      halfword boundary alignment      01170000
         XR    R15,R15                 SET RETURN CODE                  01180000
         WTO   'EXIT GOOD      *************    ',ROUTCDE=11            01190000
         L     R13,SAVEMAIN+4  restore caller's save area ad            01200000
         LM    R14,R12,12(R13)  restore all regs. except reg1           01210000
         BR    R14                  return to caller                    01220000
         EJECT                                                          01230000
*                                                                       01240000
*-------------------------------------------------------------------    01250000
*                                                                       01260000
*        storage and constant definitions.                              01270000
*        print output definition.                                       01280000
*                                                                       01290000
*-------------------------------------------------------------------    01300000
*                                                                       01310000
STATLIN  DC    0CL132' '                                                01320000
         DC    C'WELCOME TO THE ASSEBLER  CHALLENGE!! '                 01330000
         DC    C'THIS IS  A   TEST        LINE      ONLY.'              01340000
*                                                                       01350000
LINE     DS    0CL81                                                    01360000
         DC    C' '                                                     01370000
         DS    CL80                                                     01380000
PRTLINE  DCB   DSORG=PS,DDNAME=SYSOUT,MACRF=PM,                        X01390000
               RECFM=FA,LRECL=133,BLKSIZE=133                           01400000
ONE      DC    P'01'                                                    01410000
TOT      DC    PL3'1000'                                                01420000
OUT      DC    X'402020202020'                                          01430000
SAVEMAIN DC    18F'-1'                 register save area               01440000
COUNTER  DC    F'9001'                                                  01450000
SUB1     EQU   *                                                        01460000
         STM   R14,R12,12(R13)   store multiple registers into caller's 01470000
         ST    R13,SAVESUB1+4                                           01480000
         LA    R13,SAVESUB1     ! load address of my save area          01490000
*      ... body of subroutine ...                                       01500000
*        MVC   WTOID(8),0(R11)       move ID                            01510000
*        WTO   MF=(E,WTOBLOCK)                                          01520000
         WTO   'SUBROUTINE     *************    ',ROUTCDE=11            01530000
*                                                                       01540000
         L    R13,SAVESUB1+4     ! load address of caller's save are    01550000
         LM   R14,R12,12(R13)    ! load multiple registers from call    01560000
         BR   R14                ! return to caller                     01570000
SAVESUB1 DC    18F'-1'                 register save area               01580000
WTOBLOCK DC    H'84'                                                    01590000
         DC    XL2'0000'                                                01600000
WTOID    DC    CL8'????????'                                            01610000
         DC    CL72' ASM370A1 failed on or after this instruction...'   01620000
         END   ADD                                                      01630000
