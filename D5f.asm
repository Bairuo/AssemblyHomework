        PUBLIC   _CalcAverage, _Sort
        EXTRN _BUF:BYTE
.386

N    EQU  3
UNIT EQU  14
Chinese  EQU  10
Math     EQU  11
English  EQU  12
Average  EQU  13

STACK1    SEGMENT     USE16   STACK
	     DB  200   DUP(0)
STACK1    ENDS


_TEXT     SEGMENT   USE16   PARA  PUBLIC  'CODE'
	     ASSUME CS:_TEXT, SS: STACK1


UseLocalBegin MACRO             ;使用本地的数据段和栈
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


;-------------------------------------------------;
; 子程序名：_Sort
; 功能：按平均分从高到低对学生排序，排序结果仍存放在原缓冲区中（冒泡排序）
; 入口参数：无
; 出口参数：无
;-------------------------------------------------;
_Sort PROC NEAR

        ret
_Sort ENDP

;-------------------------------------------------;
; 子程序名：_CalcAverage
; 功能：计算所有学生的平均成绩
; 入口参数：无
; 出口参数：无
;-------------------------------------------------;
_CalcAverage PROC NEAR
         PUSHA
         MOV  CX, N
         MOV  AX, 0

CalcAverageL:      
         MOV  BX, AX
         ADD  BX, OFFSET _BUF
         PUSH AX
         PUSH CX

         MOV  AX, [BX + English]     ;计算保存每一个学生的平均成绩
         MOV  DL, 2
         DIV  DL
         MOV  AH, 0
         MOV  CL, [BX + Math]
         MOVZX SI, CL
         ADD  AX, SI

         MOV  CL, [BX + Chinese]
         MOVZX SI, CL
         ADD  AX, SI
         ADD  AX, SI
         SAL  AX, 1
         MOV  DL, 7
         DIV  DL
         MOV  [BX] + Average, AL

         POP  CX
         POP  AX
         ADD  AX, UNIT
         
         LOOP CalcAverageL
         POPA
         ret
_CalcAverage ENDP

_TEXT     ENDS
          END
