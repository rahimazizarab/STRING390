//RAHIM001 JOB SYS,'LINKED ***',CLASS=A,REGION=4096K,                   00010000
//             MSGLEVEL=(1,1),MSGCLASS=A                                00020000
//JOBLIB  DD  DISP=SHR,DSN=RAHIM.Y2K.LOADLIB                            00030000
//*                                                                     00040000
//SKEL    EXEC PGM=SKEL1                                                00050000
//SYSOUT   DD  SYSOUT=*                                                 00060000
//SNAP     DD  SYSOUT=*                                                 00070000
//SYSPRINT DD  SYSOUT=*                                                 00080000
