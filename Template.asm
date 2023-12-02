; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; General Asm Template by Lahar 
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

.686					;Use 686 instuction set to have all inel commands
.model flat, stdcall	;Use flat memory model since we are in 32bit 
option casemap: none	;Variables and others are case sensitive

include Template.inc	;Include our files containing libraries

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; Our initialised variables will go into in this .data section
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
.data
	szAppName	db	"Application Name",0
	szFormat	db	"%I64u",0
	szDrive		db	"C:\"

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; Our uninitialised variables will go into in this .data? section
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
.data?
	hInstance	HINSTANCE	?
	lpTotalFreeBytes	QWORD	?
	lpTotalBytes		QWORD	?
	lpFreeBytes			QWORD	?
	szBuffer		db	500	dup(?)

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; Our constant values will go onto this section
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
.const
	IDD_DLGBOX	equ	1001
	IDC_EXIT	equ	1002
	IDC_GETDATA	EQU	1003
	IDC_TOTAL	EQU	1004
	IDC_FREE	EQU	1005
	APP_ICON	equ	2000

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; This is the section to write our main code
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
.code

start:	
	invoke GetModuleHandle, NULL
	mov hInstance, eax
	invoke InitCommonControls
	invoke DialogBoxParam, hInstance, IDD_DLGBOX, NULL, addr DlgProc, NULL
	invoke ExitProcess, NULL

DlgProc		proc	hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	.if uMsg == WM_INITDIALOG
		invoke SetWindowText, hWnd, addr szAppName
		invoke LoadIcon, hInstance, APP_ICON
		invoke SendMessage, hWnd, WM_SETICON, 1, eax
	.elseif uMsg == WM_COMMAND
		mov eax, wParam
		.if eax == IDC_EXIT
			invoke SendMessage, hWnd, WM_CLOSE, 0, 0
		.elseif eax == IDC_GETDATA
			invoke GetDiskFreeSpaceEx,NULL, addr lpFreeBytes, addr lpTotalBytes,addr lpTotalFreeBytes
			invoke wsprintf, addr szBuffer, addr szFormat,addr lpTotalBytes
			invoke SetDlgItemText, hWnd, IDC_TOTAL,addr szBuffer
			invoke wsprintf, addr szBuffer, addr szFormat,addr lpTotalFreeBytes
			invoke SetDlgItemText, hWnd, IDC_FREE,addr szBuffer
		.endif
	.elseif uMsg == WM_CLOSE
		invoke EndDialog, hWnd, NULL
	.endif
	
	xor eax, eax				 
	Ret
DlgProc EndP

end start	
	 