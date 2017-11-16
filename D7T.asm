.386

STACK1    SEGMENT     USE16   STACK
	     DB  200   DUP(0)
STACK1    ENDS

DATA      SEGMENT     USE16


DATA      ENDS

CODE     SEGMENT   USE16   PARA  PUBLIC  'CODE'
	     ASSUME CS:CODE, DS: DATA, SS: STACK1

T       PROC  NEAR
        MOV AX, 10H
        RET
T       ENDP


START:   CALL T


exit:    MOV  AH,4CH    ;程序结束
         INT  21H
CODE     ENDS
         END  START