        NAME    WAN1
        EXTERN  PrintStorage:NEAR
        PUBLIC  BUF, PrintDX, NewLine

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
MESSAGE_AVERAGE  DB   ' ,Average socre : '
AVERAGE_VALUE    DB   '  $'
JUDGE_A  DB   'A$'
JUDGE_B  DB   'B$'
JUDGE_C  DB   'C$'
JUDGE_D  DB   'D$'
JUDGE_F  DB   'F$'
POIN     DW   0
CRLF     DB   0DH, 0AH, '$'
SPACE    DB   '  $'
INNAME   DB   11
nameL    DB   0
in_name  DB   11  DUP(0)
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
         LEA  DX, INNAME
         MOV  AH, 10
         INT  21H
         POP  AX
         POP  DX
         ret
UserInput ENDP

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
         mov  DI, BX

         call NewLine

         LEA  DX, MessageName           ;录入学生姓名
         call PrintDX
         call UserInput
         MOV  CL, nameL
         MOV  CH, 0
DataStorageL1:                         
         MOV  SI, OFFSET in_name
         MOV  BP, CX
         MOV  DL, DS:[SI + BP - 1]
         MOV  [BX], DL
         INC  BX
         LOOP DataStorageL1
         MOV  BX, DI
         ADD  BX, Chinese


         call NewLine                   ;录入语文成绩
         LEA  DX, MessageChinese
         call PrintDX
         call UserInput
         MOV  CL, nameL
         MOV  CH, 0
DataStorageL2:                         
         MOV  SI, OFFSET in_name
         MOV  BP, CX
         MOV  DL, DS:[SI + BP - 1]
         MOV  [BX], DL
         INC  BX
         LOOP DataStorageL2
         MOV  BX, DI
         ADD  BX, Math


         call NewLine                   ;录入数学成绩
         LEA  DX, MessageMath
         call PrintDX
         call UserInput
         MOV  CL, nameL
         MOV  CH, 0
DataStorageL3:                         
         MOV  SI, OFFSET in_name
         MOV  BP, CX
         MOV  DL, DS:[SI + BP - 1]
         MOV  [BX], DL
         INC  BX
         LOOP DataStorageL3
         MOV  BX, DI
         ADD  BX, English


         call NewLine                   ;录入英语成绩
         LEA  DX, MessageEnglish
         call PrintDX
         call UserInput
         MOV  CL, nameL
         MOV  CH, 0
DataStorageL4:                         
         MOV  SI, OFFSET in_name
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
         LEA  DX, MESSAGE_MENU   ;显示菜单
         call PrintDX
         call NEWLINE
 
         call UserInput

         CMP  nameL, 1           ;根据用户选择的菜单项完成相应功能
         JNE  Search
         CMP  in_name, '5'
         JE   exit
         CMP  in_name, '4'
         JE   Menu4
         CMP  in_name, '2'
         JE   Menu2
         CMP  in_name, '1'
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
         call PrintStorage
         ADD  AX, UNIT
         LOOP Menu4L
         call NewLine
         JMP  Search

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
         MOV  CX, N
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
