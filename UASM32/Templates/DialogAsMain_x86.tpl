Win32 App
DialogAsMain_x86
Dialog As Main Window (x86)
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,1,1,1,1,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\UASM32.exe /c /coff /Cp /nologo /I"$I",2
3=5,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /LIBPATH:"$L" /OUT:"$5",3,4
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
6=*.obj,O,$B\UASM32.exe /c /coff /Cp /nologo /I"$I",*.asm
7=0,0,"$E\OllyDbg",5
11=4,O,$B\RC.EXE /v,1
12=3,O,$B\UASM32.exe /c /coff /Cp /Zi /Zd /nologo /I"$I",2
13=5,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /DEBUG /DEBUGTYPE:CV /PDB:"$18" /VERSION:4.0 /LIBPATH:"$L" /OUT:"$5",3,4
14=0,0,,5
15=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
16=*.obj,O,$B\UASM32.exe /c /coff /Cp /Zi /Zd /nologo /I"$I",*.asm
17=0,0,"$E\x64\x64dbg",$.exe
[MakeFiles]
0=DialogAsMain_x86.rap
1=DialogAsMain_x86.rc
2=DialogAsMain_x86.asm
3=DialogAsMain_x86.obj
4=DialogAsMain_x86.res
5=DialogAsMain_x86.exe
6=DialogAsMain_x86.def
7=DialogAsMain_x86.dll
8=DialogAsMain_x86.txt
9=DialogAsMain_x86.lib
10=DialogAsMain_x86.mak
11=DialogAsMain_x86.hla
12=DialogAsMain_x86.com
13=
14=
15=
16=
17=
18=DialogAsMain_x86.pdb
[Resource]
1=,1,8,DialogAsMain_x86.xml
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
DialogAsMain_x86.Asm
;.386
;.model flat,stdcall
;option casemap:none
.686
.MMX
.XMM
.model flat,stdcall
option casemap:none

;DEBUG32 EQU 1

IFDEF DEBUG32
    PRESERVEXMMREGS equ 1
    includelib M:\Masm32\lib\Debug32.lib
    DBG32LIB equ 1
    DEBUGEXE textequ <'M:\Masm32\DbgWin.exe'>
    include M:\Masm32\include\debug32.inc
ENDIF

include DialogAsMain_x86.inc

.code

start:

	Invoke GetModuleHandle,NULL
	mov hInstance, eax
	Invoke GetCommandLine
	mov CommandLine, eax
	Invoke InitCommonControls
	mov icc.dwSize, sizeof INITCOMMONCONTROLSEX
    mov icc.dwICC, ICC_COOL_CLASSES or ICC_STANDARD_CLASSES or ICC_WIN95_CLASSES
    Invoke InitCommonControlsEx, offset icc
	
	Invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
	Invoke ExitProcess, eax

;-------------------------------------------------------------------------------------
; WinMain
;-------------------------------------------------------------------------------------
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL wcex:WNDCLASSEX
	LOCAL msg:MSG

	mov [wcex.cbSize], sizeof WNDCLASSEX
	mov [wcex.style], CS_HREDRAW or CS_VREDRAW
	lea eax, [WndProc]
	mov [wcex.lpfnWndProc], eax
	mov [wcex.cbClsExtra], 0
	mov [wcex.cbWndExtra], DLGWINDOWEXTRA ;0
	mov eax, [hInst]
	mov [wcex.hInstance], eax
	mov [wcex.hbrBackground], COLOR_BTNFACE+1 ; COLOR_WINDOW+1
	mov [wcex.lpszMenuName], IDM_MENU ;NULL 
	lea eax, ClassName
	mov [wcex.lpszClassName], eax
	invoke LoadIcon, NULL, IDI_APPLICATION
	;Invoke LoadIcon, [hInstance], ICO_MAIN ; resource icon for main application icon
	;mov hIcoMain, eax ; main application icon	
	mov [wcex.hIcon], eax
	mov [wcex.hIconSm], eax
	invoke LoadCursor, NULL, IDC_ARROW
	mov [wcex.hCursor], eax
	invoke RegisterClassEx, addr wcex

	Invoke CreateDialogParam, [hInstance], IDD_DIALOG, NULL, addr WndProc, NULL
	mov [hWnd], eax
	
	invoke ShowWindow, [hWnd], SW_SHOWNORMAL
	invoke UpdateWindow, [hWnd]
	
	.while (TRUE)
		invoke GetMessage, addr msg, NULL, 0, 0
		.break .if (!eax)		
		
		invoke TranslateMessage, addr msg
		invoke DispatchMessage, addr msg
	.endw
	
	mov eax, msg.wParam
	ret	
WinMain endp


;-------------------------------------------------------------------------------------
; WndProc - Main Window Message Loop
;-------------------------------------------------------------------------------------
WndProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	
	mov eax, uMsg
	.IF eax == WM_INITDIALOG
		push hWin
		pop hWnd
		; Init Stuff Here
		
		
	.ELSEIF eax == WM_COMMAND
		mov eax, wParam
		and eax, 0FFFFh
		.IF eax == IDM_FILE_EXIT
			Invoke SendMessage, hWin, WM_CLOSE,0,0
			
		.ELSEIF eax == IDM_HELP_ABOUT
			Invoke ShellAbout, hWin, addr AppName, addr AboutMsg, NULL
			
		.ENDIF

	.ELSEIF eax == WM_CLOSE
		Invoke DestroyWindow, hWin
		
	.ELSEIF eax == WM_DESTROY
		Invoke PostQuitMessage, NULL
		
	.ELSE
		Invoke DefWindowProc, hWin, uMsg, wParam, lParam
		ret
	.ENDIF
	xor eax,eax
	ret
WndProc endp

end start
[*ENDTXT*]
[*BEGINTXT*]
DialogAsMain_x86.Inc
include windows.inc
include CommCtrl.inc

includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib
includelib comctl32.lib
includelib shell32.lib


;-----------------------------------------------------------------------------------------
; DialogAsMain_x86 Prototypes
;-----------------------------------------------------------------------------------------
WinMain                 PROTO WINSTDCALLCONV :HINSTANCE, :HINSTANCE, :LPSTR, :DWORD
WndProc                 PROTO WINSTDCALLCONV :HWND, :DWORD, :WPARAM, :LPARAM


.CONST
;-----------------------------------------------------------------------------------------
; DialogAsMain_x86 Constants
;-----------------------------------------------------------------------------------------
; Main Dialog
IDD_DIALOG				EQU 1000

; Main Menu 
IDM_MENU				EQU 10000
IDM_FILE_EXIT			EQU 10001
IDM_HELP_ABOUT			EQU 10101



.DATA
;-----------------------------------------------------------------------------------------
; DialogAsMain_x86 Initialized Data
;-----------------------------------------------------------------------------------------
ClassName				DB 'DLGCLASS',0
AppName					DB 'LTLI Dialog',0
AboutMsg				DB 'www.LetTheLight.in',13,10,'Copyright © fearless 2014',0





.DATA?
;-----------------------------------------------------------------------------------------
; DialogAsMain_x86 Uninitialized Data
;-----------------------------------------------------------------------------------------
icc 					INITCOMMONCONTROLSEX <>
hInstance				DD ?
CommandLine				DD ?
hWnd					DD ?





[*ENDTXT*]
[*BEGINTXT*]
DialogAsMain_x86.Rc
#include "Res/DialogAsMain_x86Mnu.rc"
#include "Res/DialogAsMain_x86Dlg.rc"
#include "Res/DialogAsMain_x86Res.rc"
[*ENDTXT*]
[*BEGINBIN*]
DialogAsMain_x86.dlg
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
DialogAsMain_x86.mnu
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
Res\DialogAsMain_x86Dlg.Rc
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
Res\DialogAsMain_x86Mnu.Rc
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
Res\DialogAsMain_x86Res.Rc
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
        processorArchitecture="X86"
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
                processorArchitecture="X86"
                publicKeyToken="6595b64144ccf1df"
                language="*"
            />
        </dependentAssembly>
    </dependency>
</assembly>
[*ENDTXT*]