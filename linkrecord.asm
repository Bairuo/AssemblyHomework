        PUBLIC   _PrintMenu
.386

DATA     SEGMENT    USE16
MESSAGE_MENU     DB   '1 Enter names and scores of student', 0DH, 0AH
                 DB   '2 Calc average score of every student', 0DH, 0AH
                 DB   '3 Sorting students by score from high to low', 0DH, 0AH
                 DB   '4 Print score report', 0DH, 0AH
                 DB   '5 Exit$'

DATA     ENDS

STACK1    SEGMENT     USE16   STACK
	     DB  200   DUP(0)
STACK1    ENDS


_TEXT     SEGMENT   USE16   PARA  PUBLIC  'CODE'
	     ASSUME CS:_TEXT, DS: DATA, SS: STACK1

;-------------------------------------------------;
; 宏名：Print
; 功能：打印参数所指向内容
; 入口参数：存放字符串首字节偏移地址
; 出口参数：无
;-------------------------------------------------;
Print    MACRO Address
         PUSH DX
         PUSH AX
         LEA  DX, Address
         MOV  AH, 9
         INT  21H
         POP  AX
         POP  DX
ENDM

UseLocalBegin MACRO
        PUSHA

        MOV  SI, DS
        MOV  DI, SS

        MOV  AX, DATA
        MOV  BX, STACK1

        MOV  DS, AX
        MOV  SS, BX
ENDM

UseLocalEnd MACRO
        MOV  AX, SI
        MOV  BX, DI

        MOV  DS, AX
        MOV  SS, BX       

        POPA
ENDM

_PrintMenu PROC NEAR
        UseLocalBegin

        Print MESSAGE_MENU

        UseLocalEnd

        ret       
_PrintMenu ENDP

_TEXT     ENDS
          END
