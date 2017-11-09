        PUBLIC   _CalcAverage, _Sort
        EXTRN _BUF:BYTE, _BufferD:BYTE
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

;-------------------------------------------------;
; 子程序名：Exchange
; 功能：将两学生位置交换
; 入口参数：存储位置1，存储位置2
; 出口参数：无
;-------------------------------------------------;
Exchange PROC NEAR
         PUSH  BP
         MOV   BP, SP
         PUSH  AX
         PUSH  BX
         PUSH  CX
         PUSH  SI
         PUSH  DI

         MOV  AX, 4[BP]
         MOV  BX, 6[BP]
         
         MOV  BP, DS
         MOV  ES, BP

         MOV  SI, AX                    ;AX → buffer
         LEA  DI, _BufferD
         MOV  CX, UNIT
         CLD
         REP  MOVSB

         MOV  SI, BX                    ;BX → AX
         MOV  DI, AX
         MOV  CX, UNIT
         CLD
         REP  MOVSB

         LEA  SI, _BufferD              ;buffer → BX
         MOV  DI, BX
         MOV  CX, UNIT
         CLD
         REP  MOVSB

         POP  DI
         POP  SI
         POP  CX
         POP  BX
         POP  AX

         POP  BP
         ret 4
Exchange ENDP
;-------------------------------------------------;
; 子程序名：_Sort
; 功能：按平均分从高到低对学生排序，排序结果仍存放在原缓冲区中（冒泡排序）
; 入口参数：无
; 出口参数：无
;-------------------------------------------------;
_Sort   PROC NEAR
        PUSHA

        LEA   BX, _BUF
        MOV   CX, N - 1
Sort_L1:
        PUSH  BX
        PUSH  CX

Sort_L2:
        MOV   AL, [BX + average]
        MOV   AH, [BX + UNIT + average]
        CMP   AL, AH
        JB    Sort_change
        JMP   Sort_notChange 
Sort_change:
        MOV   DX, BX;
        PUSH  DX
        ADD   DX, UNIT
        PUSH  DX
        call  Exchange
Sort_notChange:
        ADD   BX, UNIT
        LOOP  Sort_L2


        POP   CX
        POP   BX
        LOOP  Sort_L1

        POPA
        ret
_Sort   ENDP

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
         LEA  BX, _BUF
         ADD  BX, AX
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
