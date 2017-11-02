.386
STACK    SEGMENT     USE16   STACK
	 DB  200   DUP(0)
STACK    ENDS
DATA SEGMENT USE16
MSG1  DB 'Hello 123'
LEN   =  $ - MSG1                 ; MSG1中字符的个数
MSG2  DB  LEN  DUP ( 0 )
DATA  ENDS
CODE     SEGMENT   USE16
	 ASSUME CS:CODE, DS: DATA,SS: STACK
START:   MOV  AX,DATA
         MOV  DS,AX
	     MOV  ESI,OFFSET  MSG1
         MOV  EDI,OFFSET  MSG2
	     MOV  ECX,LEN

LOPA:    MOV  AL,[ESI + ECX - 1]      ;移动数据到AL
         MOV  [EDI],AL

         INC  EDI
         DEC  ECX
         JNZ  LOPA

         MOV  AH,4CH              ;程序结束
         INT  21H
CODE     ENDS
         END  START
