        ;NAME    WAN1
        ;EXTERN  PrintStorage:NEAR
        ;PUBLIC  BUF, NewLine

.386
STACK    SEGMENT     USE16   STACK
	     DB  200   DUP(0)
STACK    ENDS

N    EQU  3
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

         ;DB   N - 3 DUP('TempValue', 0, 80, 90, 95, ?)
        
         DB   'jiangzr', 0, 0, 0
         DB   85, 85, 100, ?
MESSAGE_MENU     DB   '1 Enter names and scores of student', 0DH, 0AH
                 DB   '2 Calc average score of every student', 0DH, 0AH
                 DB   '3 Sorting students by score from high to low', 0DH, 0AH
                 DB   '4 Print score report', 0DH, 0AH
                 DB   '5 Exit$'

MessageName      DB   'Please enter the name of student : $'
MessageChinese   DB   'Please enter the Chinese socre of sutdent : $'
MessageMath      DB   'Please enter the Math score of student : $'
MessageEnglish   DB   'Please enter the English score of student : $'


MESSAGE_Report   DB   'Name  Chinese  Math  English  Average $'
ValueDisplay    DB   '     $'
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
         JNE  PrintScore_Normal
         JMP  PrintScore_Full

PrintScore_Full:
         MOV  ValueDisplay, '1'
         MOV  ValueDisplay + 1, '0'
         MOV  ValueDisplay + 2, '0'
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
;-------------------------------------------------;
; 子程序名：ToInt
; 功能：将指定长度的字符串转换为数字（不超过100）以字节形式储存到指定位置
; 入口参数：字符串位置，字符串长度，存储位置
; 出口参数：无
;-------------------------------------------------;
StorageScore MACRO origin, length, target
           PUSH origin
           PUSH length
           PUSH target
           call StorageInt
ENDM

StorageInt PROC NEAR
           PUSH BP
           MOV  BP, SP
           PUSH AX
           PUSH BX
           PUSH CX
           PUSH DX
           PUSH SI

           MOV  SI, 4[BP]
           MOV  CX, 6[BP]
           MOV  BX, 8[BP]

           CMP  CX, 3
           JNE  StorageInt_Normal
           JMP  StorageInt_Full

StorageInt_Full:
           MOV  BYTE PTR [BX], 100
           JMP  StorageInt_End

StorageInt_Normal:
           MOV  AL, [SI]
           SUB  AL, '0'
           MOV  DL, 10
           MUL  DL
           MOV  AH, 0
           ADD  AL, [SI + 1]
           SUB  AL, '0'
           MOV  [BX], AL
StorageInt_End:

           POP  SI
           POP  DX
           POP  CX
           POP  BX
           POP  AX
           POP  BP
           ret 6
StorageInt ENDP
;-------------------------------------------------;
; 菜单功能一: 录入学生
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

         call NewLine

         Print MessageName              ;录入学生姓名
         call UserInput
         MOV  AL, BufferL
         MOV  AH, 0

         MOV  CX, 10
         SUB  CX, AX
         MOV  SI, OFFSET BufferD
         ADD  SI, AX
DataStorage_L:
         MOV  BYTE PTR [SI], 0
         INC  SI
         LOOP DataStorage_L

         MOV  DI, BX
         MOV  SI, OFFSET BufferD
         MOV  BP, DS
         MOV  ES, BP
         MOV  CX, 10
         CLD
         REP  MOVSB


         call NewLine                   ;录入语文成绩
         Print MessageChinese
         call UserInput

         ADD  BX, Chinese
         MOV  AL, BufferL
         MOV  AX, 0
         StorageScore <OFFSET BufferD>, AX, BX


         call NewLine                   ;录入数学成绩
         Print MessageMath
         call UserInput

         INC  BX
         MOV  AL, BufferL
         MOV  AX, 0
         StorageScore <OFFSET BufferD>, AX, BX

         call NewLine                   ;录入英语成绩
         Print MessageEnglish
         call UserInput

         INC  BX
         MOV  AL, BufferL
         MOV  AX, 0
         StorageScore <OFFSET BufferD>, AX, BX

         call NewLine

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

DisplayMenu:  
         Print MESSAGE_MENU   ;显示菜单
         call NewLine
         call NewLine

WaitCommend:
         call UserInput

         CMP  BufferL, 1           ;根据用户选择的菜单项完成相应功能
         JNE  DisplayMenu
         CMP  BufferD, '5'
         JE   exit
         CMP  BufferD, '4'
         JE   Menu4
         CMP  BufferD, '3'
         JE   Menu3
         CMP  BufferD, '2'
         JE   Menu2
         CMP  BufferD, '1'
         JE   Menu1

         JMP  DisplayMenu

Menu1:
         MOV  AX, OFFSET BUF
         MOV  CX, N
Menu1L:
         PUSH AX
         call DataStorage
         ADD  AX, UNIT
         LOOP Menu1L
         call NewLine
         JMP  WaitCommend

Menu2:
         call CalcAverage
         call NewLine
         JMP  WaitCommend

Menu3:
         JMP  WaitCommend

Menu4:
         PUSH OFFSET BUF
         call PrintAllReport
         JMP  WaitCommend
         
exit:    MOV  AH,4CH    ;程序结束
         INT  21H
CODE     ENDS
         END  START
