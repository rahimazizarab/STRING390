//RAHIM001 JOB SYS,'LINKED ***',CLASS=A,REGION=4096K,                   00010000
//             MSGLEVEL=(1,1),MSGCLASS=X,COND=(0,NE)                    00020000
//*                                                                     00030000
//LKED    EXEC PGM=IEWL,PARM='XREF,LIST,LET,AC=0'                       00040000
//SYSLMOD  DD  DSN=RAHIM.Y2K.LOADLIB,DISP=SHR                           00050000
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(8,1))                               00060000
//SYSPRINT DD  SYSOUT=*                                                 00070000
//SYSLIB   DD  DISP=SHR,DSN=RAHIM.QUEUE.OBJ                             00080000
//SYSLIN   DD  *                                                        00090000
 INCLUDE SYSLIB(SKEL1)                                                  00100000
 NAME SKEL1(R)                                                          00110000
