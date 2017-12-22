.386

STACK1    SEGMENT     USE16   STACK
	     DB  200   DUP(0)
STACK1    ENDS


CODE     SEGMENT   USE16   PARA  PUBLIC  'CODE'
	     ASSUME CS:CODE, DS: DATA, SS: STACK1


START:   MOV  AX, DATA
         MOV  DS, AX
         MOV  AX, STACK1
         MOV  SS, AX

         MOV AH, 13H
         MOV AL, 0
         MOV BH, 0
         MOV CX, 10
         MOV DX, 0
         INT 10H


exit:    MOV  AH,4CH    ;程序结束
         INT  21H
CODE     ENDS
         END  START