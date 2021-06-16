//WAZIASM1 JOB ,NOTIFY=&SYSUID,
// MSGCLASS=H,MSGLEVEL=(1,1),REGION=0M,COND=(4,LT)
//*
//****************************************************************
//* LICENSED MATERIALS - PROPERTY OF IBM
//* "RESTRICTED MATERIALS OF IBM"
//* (C) COPYRIGHT IBM CORPORATION 2020. ALL RIGHTS RESERVED
//* US GOVERNMENT USERS RESTRICTED RIGHTS - USE, DUPLICATION,
//* OR DISCLOSURE RESTRICTED BY GSA ADP SCHEDULE
//* CONTRACT WITH IBM CORPORATION
//*****************************************************************
//*
//* THE FOLLOWING SYMBOLICS NEED TO BE UPDATED WITH THE ASSEMBLER
//* LIBRARIES AND YOUR TSO USER ID.
//*
//*****************************************************************
//    SET MACLIB='SYS1.MACLIB'            *Z/OS MACRO LIBRARY
//    SET SCEEMAC='CEE.SCEEMAC'           *ASSEMBLER MACRO LIBRARY
//    SET MODGEN='SYS1.MODGEN'            *ASM MODGEN LIBRARY
//    SET LINKLIB='CEE.SCEELKED'          *LINK LIBRARY
//    SET HLQ='IBMUSER'                   *TSO USER ID
//    SET SPACE1='SYSALLDA,SPACE=(CYL,(1,1))' *SPACE ALLOCATION
//    SET DBGLIB='EQAE20.SEQAMOD'         *DEBUGGER LIBRARY
//    SET LANGXLIB='EQAE20.SIVPMODA'      *EQALANGX LIBRARY
//*************************
//* CLEAN UP
//*************************
//DELETE   EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//DD1      DD DSN=&HLQ..SAMPLE.ASM.FILEOUT,
//            DISP=(MOD,DELETE,DELETE),
//            UNIT=SYSDA,SPACE=(CYL,(0))
//*************************
//* COMPILE ASAM1
//*************************
//ASM1      EXEC PGM=ASMA90,PARM='DECK,ALIGN,ADATA,OBJ'
//SYSLIB   DD  DISP=SHR,DSN=&MACLIB
//         DD  DISP=SHR,DSN=&MODGEN
//         DD  DISP=SHR,DSN=&SCEEMAC
//         DD  DISP=SHR,DSN=&HLQ..SAMPLE.ASMCOPY
//SYSPUNCH DD  DISP=SHR,DSN=&HLQ..SAMPLE.ASMOBJ(ASAM1)
//SYSPRINT DD  SYSOUT=*
//SYSADATA DD DISP=(NEW,PASS),DSN=&&SYSADATA,
//         SPACE=(TRK,(20,20)),UNIT=SYSALLDA
//SYSUT1   DD  UNIT=&SPACE1
//SYSUT2   DD  UNIT=&SPACE1
//SYSUT3   DD  UNIT=&SPACE1
//SYSLIN   DD  DUMMY
//SYSIN    DD  DISP=SHR,DSN=&HLQ..SAMPLE.ASM(ASAM1)
//*************************
//* EQALANGX ASAM1
//*************************
//XTRACT   EXEC PGM=EQALANGX,REGION=32M,
//  PARM='(ASM ERROR'
//STEPLIB  DD DISP=SHR,DSN=&LANGXLIB
//SYSADATA DD DSN=&&SYSADATA,DISP=(OLD,DELETE)
//IDILANGX DD DSN=&HLQ..SAMPLE.EQALANGX,DISP=SHR
//*************************
//* LINK ASAM1
//*************************
//LKED     EXEC PGM=IEWL,REGION=3000K
//SYSLMOD  DD  DSN=&HLQ..SAMPLE.ASMLOAD,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=SYSALLDA,SPACE=(CYL,(3,3))
//SYSLIB   DD  DISP=SHR,DSN=&LINKLIB
//OBJ      DD  DISP=SHR,DSN=&HLQ..SAMPLE.ASMOBJ
//SYSLIN   DD *
     INCLUDE OBJ(ASAM1)
     NAME ASAM1(R)
/*
//*************************
//* RUN ASAM1 WITH REMOTE DEBUG SERVICE
//*************************
//EXECUTE  EXEC PGM=EQANMDBG,REGION=0K,
//       PARM=('ASAM1,TEST(,CMDS,,RDS:*)/')
//STEPLIB  DD  DSN=&HLQ..SAMPLE.ASMLOAD,DISP=SHR
//         DD DISP=SHR,DSN=&DBGLIB
//EQADEBUG DD DISP=SHR,DSN=&HLQ..SAMPLE.EQALANGX
//CMDS         DD *
          LDD (ASAM1);
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//* INPUT FILE
//FILEIN   DD  DSN=&HLQ..SAMPLE.ASM.FILEIN,DISP=SHR
//* OUTPUT FILE
//FILEOUT  DD  DSN=&HLQ..SAMPLE.ASM.FILEOUT,
//     DISP=(NEW,CATLG),UNIT=SYSALLDA,SPACE=(TRK,(10,10),RLSE),
//     DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=0
//*
