.386
STACK    SEGMENT     USE16   STACK
	     DB  200   DUP(0)
STACK    ENDS

N    EQU  30
UNIT EQU  14    ;每个学生14个字节
Chinese  EQU  10
Math     EQU  11
English  EQU  12
Average  EQU  13

DATA     SEGMENT    USE16
BUF      DB   'zhangsan', 0, 0
         DB   100, 85, 80, ?

         DB   'lisi', 6 DUP(0)
         DB   80, 100, 70, ?

         DB   N - 3 DUP('TempValue', 0, 80, 90, 95, ?)
        
         DB   'jiangzr', 0, 0, 0
         DB   85, 85, 100, ?
MESSAGE_INPUT    DB   'Please enter the name of student : $'
MESSAGE_NOFIND   DB   'Can not find this student.$'
MESSAGE_FIND     DB   'The grade of this student : $'
MESSAGE_ILLEGAL  DB   'Illegal input.$'
MESSAGE_AVERAGE  DB   ' ,Average socre : '
AVERAGE_VALUE    DB   '  $'
JUDGE_A  DB   'A$'
JUDGE_B  DB   'B$'
JUDGE_C  DB   'C$'
JUDGE_D  DB   'D$'
JUDGE_F  DB   'F$'
POIN     DW   0
CRLF     DB   0DH, 0AH, '$'
INNAME   DB   11
nameL    DB   0
in_name  DB   11  DUP(0)
DATA     ENDS


CODE     SEGMENT   USE16
	     ASSUME CS:CODE, DS: DATA, SS: STACK

;-------------------------------------------------;
; 子程序名：NewLine
; 功能：打印换行
; 入口参数：无
; 出口参数：无
;-------------------------------------------------;
NewLine  PROC NEAR
         PUSH DX
         PUSH AX
         LEA  DX, CRLF            ;输出回车换行
         MOV  AH, 9
         INT  21H
         POP AX
         POP DX
         ret
NewLine  ENDP

;-------------------------------------------------;
; 子程序名：PrintDX
; 功能：打印DX所指向内容
; 入口参数：DX——存放字符串首字节偏移地址
; 出口参数：无
;-------------------------------------------------;
PrintDX  PROC NEAR
         PUSH AX                  
         MOV  AH, 9
         INT  21H
         POP  AX
         ret
PrintDX  ENDP

;-------------------------------------------------;
; 子程序名：Strcmp
; 功能：比较两个字符串是否相同
; 出口参数：AX，1表示相同，0表示不同
;-------------------------------------------------;
Strcmp   PROC NEAR
         PUSH BP
         MOV  BP, SP
         
         PUSH BX
         PUSH SI
         PUSH CX
         PUSH DX

         MOV  BX, 4[BP]
         MOV  SI, 6[BP]

         MOV  CX, 10

strcmpL:      
         MOV  DL, [BX]          ;匹配学生姓名
         CMP  DL, [SI]
         JNE  strcmpFail

         INC  BX
         INC  SI
         LOOP strcmpL
         JMP  strcmpSuccess     ;当前的学生匹配

strcmpFail:    
         MOV  AX, 0
         JMP  strcmpEnd
strcmpSuccess: 
         MOV  AX, 1
         JMP  strcmpEnd
strcmpEnd:
         POP DX
         POP CX
         POP SI
         POP BX

         POP  BP
         ret  4

Strcmp   ENDP


;-------------------------------------------------;
; 子程序名：CalcAverage
; 功能：计算所有学生的平均成绩
; 入口参数：无
; 出口参数：无
;-------------------------------------------------;
CalcAverage PROC NEAR
         PUSHA
         MOV  CX, 30
         MOV  AX, 0

CalcAverageL:      
         MOV  BX, AX
         ADD  BX, OFFSET BUF
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
CalcAverage ENDP


PromptIllegal:
         call NewLine
         LEA  DX, MESSAGE_ILLEGAL
         call PrintDX
         call NewLine
         JMP  Search

;-------------------------------------------------;
; 子程序名：JudgeDisplay
; 功能：根据成绩显示评价等级
; 入口参数：学生成绩
; 出口参数：无
;-------------------------------------------------;
JudgeDisplay PROC NEAR
         PUSH BP
         MOV  BP, SP
         PUSH AX
         PUSH BX
         PUSH CX
         PUSH DX

         MOV  AL, 4[BP]
         
         CMP  AL, 90
         JGE  FlagA
         CMP  AL, 80
         JGE  FlagB
         CMP  AL, 70
         JGE  FlagC
         CMP  AL, 60
         JGE  FlagD
         JMP  FlagF


FlagA:   LEA  DX, JUDGE_A
         JMP  JugeDisplayR
FlagB:   LEA  DX, JUDGE_B
         JMP  JugeDisplayR
FlagC:   LEA  DX, JUDGE_C
         JMP  JugeDisplayR
FlagD:   LEA  DX, JUDGE_D
         JMP  JugeDisplayR
FlagF:   LEA  DX, JUDGE_F
         JMP  JugeDisplayR

JugeDisplayR:                            ;选做题第三小问，显示平均成绩
         MOV  AH, 0
         MOV  CL, 10
         DIV  CL
         ADD  AL, '0'
         ADD  AH, '0'
         MOV  AVERAGE_VALUE, AL
         MOV  AVERAGE_VALUE + 1, AH
         call PrintDX

         LEA  DX, MESSAGE_AVERAGE
         call PrintDX
         call NewLine 

         POP  DX
         POP  CX
         POP  BX
         POP  AX
         POP  BP
         ret  2
JudgeDisplay ENDP

;-------------------------------------------------;
;程序入口
;-------------------------------------------------;

START:   MOV  AX, DATA
         MOV  DS, AX
         MOV  AX, STACK
         MOV  SS, AX

         call CalcAverage

;-------------------------------------------------;
;功能一      ：提示并输入待查询成绩的学生姓名
;-------------------------------------------------;
Search:  LEA  DX, MESSAGE_INPUT   ;提示输入学生姓名
         MOV  AH, 9
         INT  21H

         call NEWLINE

         LEA  DX, INNAME          ;输入学生姓名
         MOV  AH, 10
         INT  21H

         CMP  nameL, 0            ;选做题5、6功能
         JE   Search 
         CMP  nameL, 1
         JNE  Search_Handle
         CMP  in_name, 'q'
         JNE  Search_Handle
         JMP  exit
         
Search_Handle:
         MOV  CL, nameL           ;选做题第1问功能合法性检测
         MOV  CH, 0
         MOV  SI, OFFSET in_name
Search_Test:
         MOV  BX, 0
         MOV  AL, [SI]
         CMP  AL, 'A'
         JB   PromptIllegal
         CMP  AL, 'z'
         JG   PromptIllegal
         CMP  AL, 'Z'
         JB   Search_TestEnd
         CMP  AL, 'a'
         JB   PromptIllegal

         INC  SI
         LOOP Search_Test

Search_TestEnd:

         MOV  BL, INNAME + 1      ;处理输入的回车
         MOV  BH, 0
         MOV  BYTE PTR  INNAME + 2[BX], 0

;-------------------------------------------------;
;功能二      ：查找学生
;-------------------------------------------------;
         MOV  CX, 30
         MOV  DX, 0

s1:      MOV  BX, DX
         ADD  BX, OFFSET BUF

         PUSH  BX
         PUSH  WORD PTR OFFSET in_name

         call  Strcmp
         CMP  AX, 1
         JNE  fail
         JMP  success

fail:    ADD  DX, UNIT          ;查找下一个学生
         LOOP s1

         call NewLine           ;完全未找到
         LEA  DX, MESSAGE_NOFIND
         call PrintDX
         call NewLine   
         JMP  Search
         
success: call NewLine           ;找到退出
         LEA  DX, MESSAGE_FIND
         MOV  AH, 9
         INT  21H 

         ;将起始地址保存到POIN字变量中
         ;EBX减去加的量为起始地址
         MOV  POIN, BX

         MOV  AL, [BX + Average]
         MOV  AH, 0
         PUSH AX
         call JudgeDisplay
         
exit:    MOV  AH,4CH    ;程序结束
         INT  21H
CODE     ENDS
         END  START
