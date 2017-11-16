.386

STACK1    SEGMENT     USE16   STACK
	     DB  200   DUP(0)
STACK1    ENDS


CODE     SEGMENT   USE16   PARA  PUBLIC  'CODE'
	     ASSUME CS:CODE, DS: CODE, SS: STACK1

COUNT    DB  18
HOUR     DB  ?,?,':'
MIN      DB  ?,?,':'
SEC      DB  ?,?
LEN = $ - HOUR
CURSOR   DW  ?
Old08H   DW  ?,?


New08H   PROC   FAR
         PUSHF
         Call   DWORD  PTR  CS:Old08H

         DEC    CS:COUNT
         JZ     DISP
         IRET

DISP:    MOV    CS:COUNT, 18
         STI

         PUSHA
         PUSH   DS
         PUSH   ES
         MOV    AX, CS
         MOV    DS, AX
         MOV    ES, AX
         Call   GetTime
         MOV    BH, 0
         MOV    AH, 3
         INT    10H
         MOV    CURSOR, DX
         MOV    BP, OFFSET HOUR
         MOV    BH, 0
         MOV    DH, 0
         MOV    DL, 0
         MOV    BL, 07H
         MOV    CX, LEN
         MOV    AL, 0
         MOV    AH, 13H
         INT    10H
         MOV    BH, 0
         MOV    DX, CURSOR
         MOV    AH, 2
         INT    10H

         POP    ES
         POP    DS
         POPA

         IRET
New08H   ENDP

GetTime  PROC
         MOV    AL, 4
         OUT    70H, AL
         JMP    $ + 2
         IN     AL, 71H
         MOV    AH, AL
         AND    AL, 0FH
         SHR    AH, 4
         ADD    AX, 3030H

         XCHG   AH, AL
         MOV    WORD PTR HOUR, AX

         MOV    AL, 2
         OUT    70H, AL
         JMP    $ + 2
         IN     AL, 71H
         MOV    AH, AL
         AND    AL, 0FH
         SHR    AH, 4
         ADD    AX, 3030H
         XCHG   AH, AL
         MOV    WORD PTR MIN, AX
         MOV    AL, 0
         OUT    70H, AL
         JMP    $ + 2
         IN     AL, 71H
         MOV    AH, AL
         AND    AL, 0FH
         SHR    AH, 4
         ADD    AX, 3030H
         XCHG   AH, AL
         MOV    WORD PTR SEC, AX

         RET
GetTime  ENDP


RESIDULE_INTR8      PROC            ;将新的中断处理程序驻留内存
        MOV   DX, OFFSET RESIDULE_INTR8 + 15
        MOV   CL, 4
        SHR   DX, CL
        ADD   DX, 10H
        ADD   DX, 70H
        MOV   AL, 0
        
        MOV   AH, 31H
        INT   21H

RESIDULE_INTR8   ENDP

START:   
         MOV  AX, STACK1
         MOV  SS, AX


         PUSH  CS
         POP   DS
         MOV   AX, 3508H
         INT   21H

         MOV   Old08H, BX
         MOV   Old08H + 2, ES
         LEA   DX, New08H
         MOV   AX, 2508H
         INT   21H

Next:
         MOV   AH, 0
         INT   16H
         CMP   AL, 'q'
         JNE   Next

         Call  RESIDULE_INTR8

CODE     ENDS
         END  START