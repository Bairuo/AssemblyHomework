        NAME    WAN2
        EXTERN  BUF:BYTE, PrintDX:NEAR, NewLine:NEAR
        PUBLIC  PrintStorage
.386

N    EQU  5
UNIT EQU  14
Chinese  EQU  10
Math     EQU  11
English  EQU  12
Average  EQU  13

DATA     SEGMENT    USE16

DATA     ENDS
;-------------------------------------------------;
; 菜单功能四：输出成绩单
;-------------------------------------------------;
CODE     SEGMENT   USE16   PARA  PUBLIC  'CODE'

PrintStorage PROC NEAR
        PUSH BP
        mov  BP, SP
        PUSH AX

        mov  AX, 4[BP]

        POP AX
        POP BP
        ret 2
PrintStorage ENDP

;-------------------------------------------------;
; 菜单功能三：按平均分从高到低排序
;-------------------------------------------------;
Sort    PROC NEAR
        

Sort    ENDP

CODE    ENDS
        END