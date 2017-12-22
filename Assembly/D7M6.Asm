.386
.model flat,stdcall
option casemap:none

include jzr.inc

.data
  szCaption        db 'bairuo',0

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
GetAssic proc uses eax ebx ecx, opd:DWORD, ops:DWORD
	mov ebx, ops
	mov al, [ebx]
	mov ebx, opd
	mov ah, 0
	.if al >= 100
		mov [ebx], byte ptr '1'
		mov [ebx] + 1, byte ptr '0'
		mov [ebx] + 2, byte ptr '0'
	.elseif al == 0
		mov [ebx], byte ptr ' '
		mov [ebx] + 1, byte ptr ' '
		mov [ebx] + 2, byte ptr ' '
	.elseif al < 10
		add al, '0'
		mov [ebx], al
		mov [ebx] + 1, byte ptr ' '
		mov [ebx] + 2, byte ptr ' '
	.else
		mov cl, 10
		div cl
		add al, '0'
		add ah, '0'
		mov [ebx], al
		mov [ebx + 1], ah
		mov [ebx + 2], byte ptr ' '
	.endif

	ret
GetAssic endp

CalcAverage proc uses eax ecx esi edi edx, stu:DWORD
	mov ax, 0
	mov esi, stu
	
	add al, [esi + 12]

	mov cl, [esi + 11]
	movzx di, cl
	add ax, di
	add ax, di

	mov cl, [esi + 10]
	movzx di, cl
	add ax, di
	add ax, di
	add ax, di
	add ax, di
	mov dl, 7
	div dl
	mov [esi + 13], al

	.if al >= 90
		mov [esi + 14], byte ptr 'A'
	.elseif al >= 80
		mov [esi + 14], byte ptr 'B'
	.elseif al >= 70
		mov [esi + 14], byte ptr 'C'
	.elseif al >= 60
	    mov [esi + 14], byte ptr 'D'
	.else
		mov [esi + 14], byte ptr 'F'
	.endif

	ret
CalcAverage endp

PrintStudent proc uses esi edi ecx ebx, Dc:HDC, stu:DWORD, x:DWORD, y:DWORD
	mov ecx, 0
	mov esi, stu
	mov edi, offset buffer
PrintStudent_L:
	.if ecx < 10
		mov bl, [esi + ecx]
		mov [edi + ecx], bl
		inc ecx
		jmp PrintStudent_L
	.endif

	mov esi, x
	mov edi, stu

	invoke  GetAssic, addr buffer.Chinese, addr [edi + 10]
	invoke  GetAssic, addr buffer.Maths, addr [edi + 11]
	invoke  GetAssic, addr buffer.English, addr [edi + 12]
	invoke  GetAssic, addr buffer.Average, addr [edi + 13]
	mov cl, [edi + 14]
	mov buffer.Grade, cl

	invoke  TextOut, Dc, esi, y, addr buffer.stuName, 10
	add esi, 95
	invoke  TextOut, Dc, esi, y, addr buffer.Chinese, 3
	add esi, 65
	invoke  TextOut, Dc, esi, y, addr buffer.Maths, 3
	add esi, 55
	invoke  TextOut, Dc, esi, y, addr buffer.English, 3
	add esi, 60
	invoke  TextOut, Dc, esi, y, addr buffer.Average, 3
	add esi, 65
	invoke  TextOut, Dc, esi, y, addr buffer.Grade, 1
	
	ret
PrintStudent endp

DisplayList proc Dc:HDC
    invoke PrintStudent, Dc, addr S1, 10, 85
	invoke PrintStudent, Dc, addr S2, 10, 110
	invoke PrintStudent, Dc, addr S3, 10, 135
	invoke PrintStudent, Dc, addr S4, 10, 160
	invoke PrintStudent, Dc, addr S5, 10, 185
	invoke PrintStudent, Dc, addr S6, 10, 210
	ret
DisplayList endp

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
		    invoke CalcAverage, addr S1
			invoke CalcAverage, addr S2
			invoke CalcAverage, addr S3
			invoke CalcAverage, addr S4
			invoke CalcAverage, addr S5
			invoke CalcAverage, addr S6
			invoke DisplayList, Dc
		.elseif eax == IDM_FILE_LIST
		    invoke TextOut, Dc, 10, 15, addr listTitle, num1   
            invoke TextOut, Dc, 10, 40, addr listForm, num2
            invoke TextOut, Dc, 10, 60, addr listLine, num3
			invoke DisplayList, Dc
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
