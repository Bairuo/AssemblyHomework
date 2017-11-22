.386
.model flat,stdcall
option casemap:none

include myinc.inc

.data
  szCaption        db 'Assembly Window',0

.code

start:

	invoke GetModuleHandle,NULL
	mov    hInstance,eax
	invoke GetCommandLine
	mov CommandLine,eax
	invoke InitCommonControls
	invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	invoke ExitProcess,eax

;------------------窗口主程序-------------------
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL	wc:WNDCLASSEX
	LOCAL	msg:MSG

	mov		wc.cbSize,SIZEOF WNDCLASSEX
	mov		wc.style,CS_HREDRAW or CS_VREDRAW
	mov		wc.lpfnWndProc,OFFSET WndProc
	mov		wc.cbClsExtra,NULL
	mov		wc.cbWndExtra,DLGWINDOWEXTRA
	push	hInst
	pop		wc.hInstance
	mov		wc.hbrBackground,COLOR_BTNFACE
	mov		wc.lpszMenuName,OFFSET MenuName
	mov		wc.lpszClassName,OFFSET ClassName
	invoke LoadIcon,NULL,IDI_APPLICATION        ;装入系统默认图标
	mov		wc.hIcon,eax
	mov		wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW            ;装入系统默认光标
	mov		wc.hCursor,eax
	invoke RegisterClassEx,addr wc              ;保存光标的句柄

    invoke CreateWindowEx,NULL,addr ClassName, 
    addr szCaption,
    WS_OVERLAPPEDWINDOW + WS_VISIBLE,
    CW_USEDEFAULT, CW_USEDEFAULT,
    600, 400,
    NULL, NULL,
    hInst, NULL
    mov hWnd, eax

	.while TRUE
		invoke GetMessage,addr msg,NULL,0,0
	  .BREAK .if !eax
		invoke TranslateMessage,addr msg
		invoke DispatchMessage,addr msg
	.endw
	mov		eax,msg.wParam
	ret

WinMain endp


;------------------窗口消息处理程序-------------------
GetAssic proc uses eax, opd:DWORD, ops:DWORD


	ret
GetAssic endp

PrintStudent proc uses esi edi, Dc:HDC, stu:DWORD, x:DWORD, y:DWORD
LOCAL buffer:StuDisplay
	mov esi, x
	mov edi, stu
	;转移名字
	
	invoke  GetAssic, addr buffer.Chinese, addr [edi + 10]

	;invoke  TextOut, Dc, esi, y, addr buffer, unit
	;invoke TextOut, Dc, esi, y, edi, 10
	;invoke TextOut, Dc, esi, y, addr [edi + 10], 1
	;invoke TextOut, Dc, x + 17, y, addr stu.Maths, 1
	;invoke TextOut, Dc, x + 20, y, addr stu.English, 1
	;invoke TextOut, Dc, x + 23, y, addr stu.Average, 1
	;invoke TextOut, Dc, x + 26, y, addr stu.Grade, 1
	ret
PrintStudent endp

WndProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
LOCAL ps :PAINTSTRUCT
LOCAL Dc:HDC

    invoke  GetDC, hWnd
    mov     Dc, eax

	mov		eax,uMsg
	.if eax == WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
		.if eax == IDM_FILE_EXIT
			invoke SendMessage,hWin,WM_CLOSE,0,0
		.elseif eax == IDM_HELP_ABOUT
            invoke MessageBoxA, 0, addr aboutMessage, addr aboutTitle, aboutOK
		.elseif eax == IDM_FILE_AVERAGE
		    ;invoke SelectGate,CurrGate
		.elseif eax == IDM_FILE_LIST
		    invoke TextOut, Dc, 10, 15, addr listTitle, num1   
            invoke TextOut, Dc, 10, 40, addr listForm, num2
            invoke TextOut, Dc, 10, 60, addr listLine, num3
            invoke PrintStudent, Dc, addr S1, 10, 85
		.endif
	.elseif eax == WM_CLOSE
		invoke DestroyWindow,hWin
	.elseif eax == WM_DESTROY
		invoke PostQuitMessage,NULL
    .else
		invoke DefWindowProc,hWin,uMsg,wParam,lParam
		ret
	.endif
	xor    eax,eax
	ret

WndProc endp


end start
