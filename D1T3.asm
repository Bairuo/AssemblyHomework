.386
STACK    SEGMENT     USE16   STACK
	 DB  200   DUP(0)
STACK    ENDS
DATA     SEGMENT    USE16
BUF1     DB   0, 1, 2, 3, 4, 5, 6, 7, 8, 9
BUF2     DB   10  DUP(0)
BUF3     DB   10  DUP(0)
BUF4     DB   10  DUP(0)
DATA     ENDS
CODE     SEGMENT   USE16
	 ASSUME CS:CODE, DS: DATA,SS: STACK
START:   MOV  AX,DATA
 	 MOV  DS,AX
	 MOV  ESI,OFFSET  BUF1
     MOV  EDI,OFFSET  BUF2
	 MOV  ECX,10
LOPA:    MOV  AL,[ESI]      ;移动数据到AL

         MOV  [EDI],AL
         INC  AL
         MOV  [EDI + 10],AL
         ADD  AL,3
         MOV  DS:[EDI + 20],AL
         INC  ESI
         INC  EDI
         DEC  ECX
         JNZ  LOPA
         MOV  AH,4CH
         INT  21H
CODE     ENDS
         END  START
