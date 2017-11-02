        ;NAME    WAN1
        ;EXTERN  PrintStorage:NEAR
        ;PUBLIC  BUF, NewLine

.386
STACK    SEGMENT     USE16   STACK
	     DB  200   DUP(0)
STACK    ENDS

N    EQU  5
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
MESSAGE_MENU     DB   '1 Enter names and scores of student', 0DH, 0AH
                 DB   '2 Calc average score of every student', 0DH, 0AH
                 DB   '3 Sorting students by score from high to low', 0DH, 0AH
                 DB   '4 Print average scores', 0DH, 0AH
                 DB   '5 Exit$'

MessageName      DB   'Please enter the name of student : $'
MessageChinese   DB   'Please enter the Chinese socre of sutdent : $'
MessageMath      DB   'Please enter the Math score of student : $'
MessageEnglish   DB   'Please enter the English score of student : $'

MESSAGE_NOFIND   DB   'Can not find this student.$'
MESSAGE_FIND     DB   'The grade of this student : $'
MESSAGE_ILLEGAL  DB   'Illegal input.$'
MESSAGE_Report   DB   'Name  Chinese  Math  English  Average $'
AVERAGE_VALUE    DB   '    $'
JUDGE_A  DB   'A$'
JUDGE_B  DB   'B$'
JUDGE_C  DB   'C$'
JUDGE_D  DB   'D$'
JUDGE_F  DB   'F$'
POIN     DW   0
CRLF     DB   0DH, 0AH, '$'
SPACE    DB   '  $'
Buffer   DB   11
BufferL  DB   0
BufferD  DB   11  DUP(0)
         DB   '$'
DATA     ENDS


CODE     SEGMENT   USE16   PARA  PUBLIC  'CODE'
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
; 子程序名：UserInput
; 功能：用户输入
; 入口参数：无
; 出口参数：无
;-------------------------------------------------;
UserInput PROC NEAR
         PUSH DX
         PUSH AX
         LEA  DX, Buffer
         MOV  AH, 10
         INT  21H
         POP  AX
         POP  DX
         ret
UserInput ENDP

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
;-------------------------------------------------;
; 子程序名：CalcAverage
; 功能：计算所有学生的平均成绩
; 入口参数：无
; 出口参数：无
;-------------------------------------------------;
CalcAverage PROC NEAR
         PUSHA
         MOV  CX, N
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
         Print MESSAGE_ILLEGAL
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


FlagA:   Print JUDGE_A
         JMP  JugeDisplayR
FlagB:   Print JUDGE_B
         JMP  JugeDisplayR
FlagC:   Print JUDGE_C
         JMP  JugeDisplayR
FlagD:   Print JUDGE_D
         JMP  JugeDisplayR
FlagF:   Print JUDGE_F
         JMP  JugeDisplayR

JugeDisplayR:                            ;选做题第三小问，显示平均成绩
         MOV  AH, 0
         MOV  CL, 10
         DIV  CL
         ADD  AL, '0'
         ADD  AH, '0'
         MOV  AVERAGE_VALUE, AL
         MOV  AVERAGE_VALUE + 1, AH

         Print MESSAGE_Report
         call NewLine 

         POP  DX
         POP  CX
         POP  BX
         POP  AX
         POP  BP
         ret  2
JudgeDisplay ENDP

;-------------------------------------------------;
; 菜单功能一: 录入N个学生
; 入口参数：学生起始存储位置
;-------------------------------------------------;
DataStorage PROC NEAR
         PUSH BP
         MOV  BP, SP
         PUSH AX;
         PUSH BX;
         PUSH CX;
         PUSH DX;
         PUSH SI;
         PUSH DI;

         MOV  BX, 4[BP]
         MOV  DI, BX

         call NewLine

         Print MessageName           ;录入学生姓名
         call UserInput
         MOV  CL, BufferL
         MOV  CH, 0
DataStorageL1:                         
         MOV  SI, OFFSET BufferD
         MOV  BP, CX
         MOV  DL, DS:[SI + BP - 1]
         MOV  [BX], DL
         INC  BX
         LOOP DataStorageL1
         MOV  BX, DI
         ADD  BX, Chinese


         call NewLine                   ;录入语文成绩
         Print MessageChinese
         call UserInput
         MOV  CL, BufferL
         MOV  CH, 0
DataStorageL2:                         
         MOV  SI, OFFSET BufferD
         MOV  BP, CX
         MOV  DL, DS:[SI + BP - 1]
         MOV  [BX], DL
         INC  BX
         LOOP DataStorageL2
         MOV  BX, DI
         ADD  BX, Math


         call NewLine                   ;录入数学成绩
         Print MessageMath
         call UserInput
         MOV  CL, BufferL
         MOV  CH, 0
DataStorageL3:                         
         MOV  SI, OFFSET BufferD
         MOV  BP, CX
         MOV  DL, DS:[SI + BP - 1]
         MOV  [BX], DL
         INC  BX
         LOOP DataStorageL3
         MOV  BX, DI
         ADD  BX, English


         call NewLine                   ;录入英语成绩
         Print MessageEnglish
         call UserInput
         MOV  CL, BufferL
         MOV  CH, 0
DataStorageL4:                         
         MOV  SI, OFFSET BufferD
         MOV  BP, CX
         MOV  DL, DS:[SI + BP - 1]
         MOV  [BX], DL
         INC  BX
         LOOP DataStorageL4

         POP  DI
         POP  SI
         POP  DX
         POP  CX
         POP  BX
         POP  AX

         POP  BP
         ret  2
DataStorage ENDP

;-------------------------------------------------;
;程序入口
;-------------------------------------------------;

START:   MOV  AX, DATA
         MOV  DS, AX
         MOV  AX, STACK
         MOV  SS, AX

Search:  
         Print MESSAGE_MENU   ;显示菜单
         call NEWLINE
 
         call UserInput

         CMP  BufferL, 1           ;根据用户选择的菜单项完成相应功能
         JNE  Search
         CMP  BufferD, '5'
         JE   exit
         CMP  BufferD, '4'
         JE   Menu4
         CMP  BufferD, '2'
         JE   Menu2
         CMP  BufferD, '1'
         JE   Menu1

         JMP  Search

Menu1:
         MOV  AX, OFFSET BUF
         MOV  CX, N
Menu1L:
         PUSH AX
         call DataStorage
         ADD  AX, UNIT
         LOOP Menu1L
         call NewLine
         JMP  Search

Menu2:
         call CalcAverage
         call NewLine
         JMP  Search

Menu4:
         MOV  AX, OFFSET BUF
         MOV  CX, N
Menu4L:
         PUSH AX
         ;call PrintStorage
         ADD  AX, UNIT
         LOOP Menu4L
         call NewLine
         JMP  Search
         
exit:    MOV  AH,4CH    ;程序结束
         INT  21H
CODE     ENDS
         END  START
