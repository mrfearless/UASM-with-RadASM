Win64 App
DialogAsMain_x64
Dialog As Main Window (x64)
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,1,1,1,1,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\UASM64.exe /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /I"$I",2
3=5,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /MACHINE:X64 /LIBPATH:"$L" /OUT:"$5",3,4
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
6=*.obj,O,$B\UASM64.EXE /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /I"$I",*.asm
7=0,0,"$E\x64\x64dbg",5
11=4,O,$B\RC.EXE /v,1
12=3,O,$B\UASM64.EXE /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /Zi /Zd /nologo /I"$I",2
13=5,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /DEBUG /DEBUGTYPE:CV /PDB:"$18" /VERSION:4.0 /MACHINE:X64 /LIBPATH:"$L" /OUT:"$5",3,4
14=0,0,,5
15=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
16=*.obj,O,$B\UASM64.EXE /c /coff /Cp /Zi /Zd /nologo /I"$I",*.asm
17=0,0,"$E\x64\x64dbg",$.exe
[MakeFiles]
0=DialogAsMain_x64.rap
1=DialogAsMain_x64.rc
2=DialogAsMain_x64.asm
3=DialogAsMain_x64.obj
4=DialogAsMain_x64.res
5=DialogAsMain_x64.exe
6=DialogAsMain_x64.def
7=DialogAsMain_x64.dll
8=DialogAsMain_x64.txt
9=DialogAsMain_x64.lib
10=DialogAsMain_x64.mak
11=DialogAsMain_x64.hla
12=DialogAsMain_x64.com
13=
14=
15=
16=
17=
18=DialogAsMain_x64.pdb
[Resource]
1=,1,8,DialogAsMain_x64.xml
[StringTable]
[VerInf]
[Group]
Group=Assembly,Resources,Misc
1=1
2=1
3=2
4=2
5=2
[*ENDDEF*]
[*BEGINTXT*]
DialogAsMain_x64.Asm
.686
.MMX
.XMM
.x64

option casemap : none
option win64 : 11
option frame : auto
option stackbase : rsp

_WIN64 EQU 1
WINVER equ 0501h

DEBUG64 EQU 1

IFDEF DEBUG64
    PRESERVEXMMREGS equ 1
    includelib \UASM\lib\x64\Debug64.lib
    DBG64LIB equ 1
    DEBUGEXE textequ <'\UASM\bin\DbgWin.exe'>
    include \UASM\include\debug64.inc
    .DATA
    RDBG_DbgWin	DB DEBUGEXE,0
    .CODE
ENDIF

include DialogAsMain_x64.inc

.CODE

;-------------------------------------------------------------------------------------
; Startup
;-------------------------------------------------------------------------------------
WinMainCRTStartup proc FRAME
	Invoke GetModuleHandle, NULL
	mov hInstance, rax
	Invoke GetCommandLine
	mov CommandLine, rax
	Invoke InitCommonControls
	mov icc.dwSize, sizeof INITCOMMONCONTROLSEX
    mov icc.dwICC, ICC_COOL_CLASSES or ICC_STANDARD_CLASSES or ICC_WIN95_CLASSES
    Invoke InitCommonControlsEx, offset icc
	Invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
	Invoke ExitProcess, eax
    ret
WinMainCRTStartup endp
	

;-------------------------------------------------------------------------------------
; WinMain
;-------------------------------------------------------------------------------------
WinMain proc FRAME hInst:HINSTANCE, hPrev:HINSTANCE, CmdLine:LPSTR, iShow:DWORD
	LOCAL msg:MSG
	LOCAL wcex:WNDCLASSEX
	
	mov wcex.cbSize, sizeof WNDCLASSEX
	mov wcex.style, CS_HREDRAW or CS_VREDRAW
	lea rax, WndProc
	mov wcex.lpfnWndProc, rax
	mov wcex.cbClsExtra, 0
	mov wcex.cbWndExtra, DLGWINDOWEXTRA
	mov rax, hInst
	mov wcex.hInstance, rax
	mov wcex.hbrBackground, COLOR_WINDOW+1 ; COLOR_BTNFACE+1
	mov wcex.lpszMenuName, IDM_MENU ;NULL 
	lea rax, ClassName
	mov wcex.lpszClassName, rax
	Invoke LoadIcon, NULL, IDI_APPLICATION
	;Invoke LoadIcon, hInst, ICO_MAIN ; resource icon for main application icon
	;mov hIcoMain, eax ; main application icon	
	mov wcex.hIcon, rax
	mov wcex.hIconSm, rax
	Invoke LoadCursor, NULL, IDC_ARROW
	mov wcex.hCursor, rax
	Invoke RegisterClassEx, addr wcex
	
	;Invoke CreateWindowEx, 0, addr ClassName, addr szAppName, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInstance, NULL
	Invoke CreateDialogParam, hInstance, IDD_DIALOG, 0, Addr WndProc, 0
	mov hWnd, rax
	
	Invoke ShowWindow, hWnd, SW_SHOWNORMAL
	Invoke UpdateWindow, hWnd
	
	.WHILE (TRUE)
		Invoke GetMessage, addr msg, NULL, 0, 0
		.BREAK .IF (!rax)		
		
        Invoke IsDialogMessage, hWnd, addr msg
        .IF rax == 0
            Invoke TranslateMessage, addr msg
            Invoke DispatchMessage, addr msg
        .ENDIF
	.ENDW
	
	mov rax, msg.wParam
	ret	
WinMain endp


;-------------------------------------------------------------------------------------
; WndProc - Main Window Message Loop
;-------------------------------------------------------------------------------------
WndProc proc FRAME hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    
    mov eax, uMsg
	.IF eax == WM_INITDIALOG
		; Init Stuff Here
		
		
	.ELSEIF eax == WM_COMMAND
        mov rax, wParam
		.IF rax == IDM_FILE_EXIT
			Invoke SendMessage, hWin, WM_CLOSE, 0, 0
			
		.ELSEIF rax == IDM_HELP_ABOUT
			Invoke ShellAbout, hWin, Addr AppName, Addr AboutMsg, NULL
			
		.ENDIF

	.ELSEIF eax == WM_CLOSE
		Invoke DestroyWindow, hWin
		
	.ELSEIF eax == WM_DESTROY
		Invoke PostQuitMessage, NULL
		
	.ELSE
		Invoke DefWindowProc, hWin, uMsg, wParam, lParam ; rcx, edx, r8, r9
		ret
	.ENDIF
	xor rax, rax
	ret
WndProc endp







end WinMainCRTStartup

[*ENDTXT*]
[*BEGINTXT*]
DialogAsMain_x64.Inc
include windows.inc
include CommCtrl.inc
include shellapi.inc

includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib
includelib comctl32.lib
includelib shell32.lib


;-----------------------------------------------------------------------------------------
; DialogAsMain_x64 Prototypes
;-----------------------------------------------------------------------------------------



.CONST
;-----------------------------------------------------------------------------------------
; DialogAsMain_x64 Constants
;-----------------------------------------------------------------------------------------
; Main Dialog
IDD_DIALOG				EQU 1000

; Main Menu 
IDM_MENU				EQU 10000
IDM_FILE_EXIT			EQU 10001
IDM_HELP_ABOUT			EQU 10101



.DATA
;-----------------------------------------------------------------------------------------
; DialogAsMain_x64 Initialized Data
;-----------------------------------------------------------------------------------------
align 01
szClass					db 'Win64class', 0
szAppName				db 'First Window', 0

ClassName				DB 'DLGCLASS',0
AppName					DB 'LTLI Dialog',0
AboutMsg				DB 'www.LetTheLight.in',13,10,'Copyright © fearless 2014',0





.DATA?
;-----------------------------------------------------------------------------------------
; DialogAsMain_x64 Uninitialized Data
;-----------------------------------------------------------------------------------------
align 08
icc 					INITCOMMONCONTROLSEX <>
hInstance				HINSTANCE ?
CommandLine				LPSTR ?
hWnd					HWND ?





[*ENDTXT*]
[*BEGINTXT*]
DialogAsMain_x64.Rc
#include "Res/DialogAsMain_x64Mnu.rc"
#include "Res/DialogAsMain_x64Dlg.rc"
#include "Res/DialogAsMain_x64Res.rc"
[*ENDTXT*]
[*BEGINBIN*]
DialogAsMain_x64.dlg
6500000001000000444C47434C41535300000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000004D532053616E732053657269660000000000000000000000
000000000000000008000000F6FFFFFF00000000E90300000000000000000000
00000000000000005403000000000000800D00000100000022A54100740D0000
000000000008CF10000000000A0000000A0000002C010000C80000004469616C
6F67204173204D61696E00000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000E8030000494444
5F4449414C4F4700000000000000000000000000000000000000000000000000
0000000000
[*ENDBIN*]
[*BEGINBIN*]
DialogAsMain_x64.mnu
49444D5F4D454E55000000000000000000000000000000000000000000000000
10270000112700000100000000444D5F00000000000000000000000000000000
000000000000000000000000000000002646696C650000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0100000049444D5F46494C455F45584954000000000000000000000000000000
0000000011270000452678697400000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000010000000000000000000000000000000100000000444D5F
0000000000000000000000000000000000000000000000000000000000000000
2648656C70000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000100000049444D5F48454C505F41424F
5554000000000000000000000000000000000000752700002641626F75740000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000100000000000000
0000000000000000
[*ENDBIN*]
[*ENDPRO*]
[*BEGINTXT*]
Res\DialogAsMain_x64Dlg.Rc
#define IDD_DIALOG 1000
IDD_DIALOG DIALOGEX 6,6,194,106
CAPTION "Dialog As Main"
FONT 8,"Segoe UI",400,0
CLASS "DLGCLASS"
STYLE 0x10CF0800
EXSTYLE 0x00000000
BEGIN
END
[*ENDTXT*]
[*BEGINTXT*]
Res\DialogAsMain_x64Mnu.Rc
#define IDM_MENU 10000
#define IDM_FILE_EXIT 10001
#define IDM_HELP_ABOUT 10101
IDM_MENU MENUEX
BEGIN
  POPUP "&File",,,
  BEGIN
    MENUITEM "E&xit",IDM_FILE_EXIT,,
  END
  POPUP "&Help",,,
  BEGIN
    MENUITEM "&About",IDM_HELP_ABOUT,,
  END
END
[*ENDTXT*]
[*BEGINTXT*]
Res\DialogAsMain_x64Res.Rc
#define MANIFEST 24
1 MANIFEST DISCARDABLE "[*PROJECTNAME*].xml"
[*ENDTXT*]
[*BEGINTXT*]
[*PROJECTNAME*].xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly
    xmlns="urn:schemas-microsoft-com:asm.v1"
    manifestVersion="1.0">
    <assemblyIdentity
        version="1.0.0.0"
        processorArchitecture="amd64"
        name="Company.Product.Application"
        type="Win32"
    />
    <description>[*PROJECTNAME*]</description>
    <dependency>
        <dependentAssembly>
            <assemblyIdentity
                type="win32"
                name="Microsoft.Windows.Common-Controls"
                version="6.0.0.0"
                processorArchitecture="amd64"
                publicKeyToken="6595b64144ccf1df"
                language="*"
            />
        </dependentAssembly>
    </dependency>
</assembly>
[*ENDTXT*]