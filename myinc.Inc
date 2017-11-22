;------ include inc and lib ----
include windows.inc
include user32.inc
include kernel32.inc
include gdi32.inc
include shell32.inc
include comctl32.inc
include comdlg32.inc

includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib
includelib shell32.lib
includelib comctl32.lib
includelib comdlg32.lib

;--- User function ---------
WinMain	      PROTO :DWORD,:DWORD,:DWORD,:DWORD
WndProc       PROTO :DWORD,:DWORD,:DWORD,:DWORD
WMPaint       proto :DWORD
NextGate      proto
KeyDownProc   proto :DWORD
Repaint       proto
XYtoPos       proto :DWORD,:DWORD
ManMove       proto :DWORD
Check         proto

ShowMessage proto :DWORD

.const
IDM_FILE_EXIT		equ 10001
IDM_HELP_ABOUT		equ 10101
IDM_FILE_AVERAGE        equ 10102
IDM_FILE_LIST           equ 10103

.data
 ;--- Toolbar ---
            
aboutTitle          db 'About Me', 0
aboutMessage        db 'bairuo', 0
aboutOK             equ 0

listTitle           db 'List'
num1 = $ - listTitle
listForm            db 'Name        Chinese   Maths   English   Average   Grade'
num2 = $ - listForm
listLine            db '_______________________________________________________'
num3 = $ - listLine


unit = 10 + 4 + 3*4 + 3*4 + 1
StuDisplay  STRUCT
        stuName db '          '
                db '    '
        Chinese db 3  dup(0)
                db '   '
        Maths   db 3  dup(0)
                db '   '
        English db 3  dup(0)
                db '   '
        Average db 3  dup(0)
                db '   '
        Grade   db 0
StuDisplay  ENDS

Student     STRUCT
        stuName db  '          '
        Chinese db  0
        Maths   db  0
        English db  0
        Average db  0
        Grade   db  0
Student     ENDS


;S1  Student  <>
S1  Student  <'xueba','1','2','3','4','5'>
;S2  Student  <'xuezha', 46, 55, 58, 50>
;S3  Student  <'zhangsan', 70, 86, 87, 77>
;S4  Student  <'lisigsan', 67, 76, 61, 68>
;S5  Student  <'wangwuan', 77, 56, 69, 69>
;S6  Student  <'bairuo', 99, 100, 99, 99>


ClassName			db 'DLGCLASS',0
MenuName			db 'MyMenu',0
DlgName				db 'MyDialog',0


.data?

hInstance			dd ?
CommandLine			dd ?
hWnd				dd ?
