;----------------------------
STACK	SEGMENT STACK
	DB	200 DUP(0)
STACK	ENDS
;----------------------------
DATA	SEGMENT
XUEHAO	DB	4 DUP(0)
DATA	ENDS
;------------------------------
CODE SEGMENT
        ASSUME CS:CODE,DS:DATA,SS:STACK
BEGIN:	
	MOV BX, OFFSET XUEHAO
	
	MOV BYTE PTR [BX],'4'		;寄存器间接寻址
	
	MOV BYTE PTR 1[BX],'8'		;变址寻址

	
	MOV SI, 1
	MOV BYTE PTR 1[BX][SI],'7'	;基址加变址寻址

	
	MOV XUEHAO + 3,'3'			;直接寻址
 
	MOV AH,4CH   ;exit
	INT 21H
;-----------------------------
CODE	ENDS
	END BEGIN