        NAME    WAN2
        EXTERN  BUF:BYTE, NewLine:NEAR, BufferD:BYTE, MESSAGE_Report:BYTE, ValueDisplay:BYTE
        PUBLIC  Sort, PrintAllReport
.386
N    EQU  3
UNIT EQU  14
Chinese  EQU  10
Math     EQU  11
English  EQU  12
Average  EQU  13

CODE     SEGMENT   USE16   PARA  PUBLIC  'CODE'

Print    MACRO Address
         PUSH DX
         PUSH AX
         LEA  DX, Address
         MOV  AH, 9
         INT  21H
         POP  AX
         POP  DX
ENDM

;----------------------------------------------------------------;
; 菜单功能四：输出成绩单
;----------------------------------------------------------------;

;-------------------------------------------------;
; 子程序名：PrintName
; 功能：打印学生姓名
; 入口参数：学生首地址
; 出口参数：无
;-------------------------------------------------;
PrintName PROC NEAR
         PUSH BP
         MOV  BP, SP
         PUSH AX
         PUSH BX

         MOV  BX, 4[BP]
         MOV  AL, [BX + Chinese]
         MOV  BYTE PTR [BX + Chinese], '$'
         Print [BX]
         MOV  [BX + Chinese], AL

         POP  BX
         POP  AX
         POP  BP
         ret  2
PrintName ENDP
;-------------------------------------------------;
; 子程序名：PrintScore
; 功能：打印成绩（字节）
; 入口参数：成绩地址
; 出口参数：无
;-------------------------------------------------;
PrintScore PROC NEAR
         PUSH BP
         MOV  BP, SP
         PUSH AX
         PUSH BX
         PUSH CX

         MOV  BX, 4[BP]
         MOV  AL, [BX]
         CMP  AL, 100
         JE   PrintScore_Full
         CMP  AL, 10
         JB   PrintScore_Single
         JMP  PrintScore_Normal

PrintScore_Full:
         MOV  ValueDisplay, '1'
         MOV  ValueDisplay + 1, '0'
         MOV  ValueDisplay + 2, '0'
         JMP  PrintScore_Print

PrintScore_Single:
         ADD  AL, '0'
         MOV  ValueDisplay, AL
         MOV  ValueDisplay + 1, 0
         MOV  ValueDisplay + 2, 0
         JMP  PrintScore_Print

PrintScore_Normal:
         MOV  AH, 0
         MOV  CL, 10
         DIV  CL
         ADD  AL, '0'
         ADD  AH, '0'
         MOV  ValueDisplay, AL
         MOV  ValueDisplay + 1, AH
         MOV  BYTE PTR ValueDisplay + 2, 0
         JMP  PrintScore_Print

PrintScore_Print:
         Print ValueDisplay

         POP CX
         POP BX
         POP AX
         POP BP
         ret 2
PrintScore ENDP
;-------------------------------------------------;
; 子程序名：PrintReport
; 功能：打印指定学生成绩单
; 入口参数：学生首地址
; 出口参数：无
;-------------------------------------------------;
PrintReport PROC NEAR
         PUSH BP
         MOV  BP, SP
         PUSH BX

         MOV  BX, 4[BP]
         PUSH BX
         call PrintName
         ADD  BX, Chinese
         PUSH BX
         call PrintScore
         ADD  BX, 1
         PUSH BX
         call PrintScore
         ADD  BX, 1
         PUSH BX
         call PrintScore
         ADD  BX, 1
         PUSH BX
         call PrintScore

         call NewLine

         POP  BX
         POP  BP
         ret  2
PrintReport ENDP
;-------------------------------------------------;
; 子程序名：PrintAllReport
; 功能：打印所有学生成绩单
; 入口参数：学生数据区首地址
; 出口参数：无
;-------------------------------------------------;
PrintAllReport PROC NEAR
         PUSH BP
         MOV  BP, SP
         PUSH AX
         PUSH CX
         
         call NewLine
         call NewLine
         Print MESSAGE_Report
         call NewLine

         MOV  AX, 4[BP]
         MOV  CX, N
PrintAllReport_L:
         PUSH AX
         call PrintReport
         ADD  AX, UNIT
         LOOP PrintAllReport_L
         call NewLine

         POP  CX
         POP  AX
         POP  BP
         ret  2
PrintAllReport ENDP

;----------------------------------------------------------------;
; 菜单功能三：按平均分从高到低排序
;----------------------------------------------------------------;

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
         MOV  DI, OFFSET BufferD
         MOV  CX, UNIT
         CLD
         REP  MOVSB

         MOV  SI, BX                    ;BX → AX
         MOV  DI, AX
         MOV  CX, UNIT
         CLD
         REP  MOVSB

         MOV  SI, OFFSET BufferD        ;buffer → BX
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
; 子程序名：Sort
; 功能：按平均分从高到低对学生排序，排序结果仍存放在原缓冲区中（冒泡排序）
; 入口参数：无
; 出口参数：无
;-------------------------------------------------;
Sort    PROC NEAR
        PUSHA

        MOV   BX, OFFSET BUF
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
        ADD   BX, UNIT
        LOOP  Sort_L1

        POPA
        ret
Sort    ENDP

CODE    ENDS
        END