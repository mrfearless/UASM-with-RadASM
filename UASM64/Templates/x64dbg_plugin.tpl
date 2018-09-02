Dll64 Project
x64dbg_plugin
x64dbg plugin for x64dbg
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,0,0,0,0,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\UASM64.EXE /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /I"$I",2
3=7,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /RELEASE /DLL /DEF:$6 /LIBPATH:"$L" /OUT:"$17",3,4
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
6=*.obj,O,$B\UASM64.EXE /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /I"$I",*.asm
7=0,0,"$E\x64\x64dbg",5
11=4,O,$B\RC.EXE /v,1
12=3,O,$B\UASM64.EXE /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /Zi /Zd /nologo /I"$I",2
13=7,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /DEBUG /DEBUGTYPE:CV /PDB:"$18" /DLL /DEF:$6 /LIBPATH:"$L" /OUT:"$17",3,4
14=0,0,,5
15=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
16=*.obj,O,$B\UASM64.EXE /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /I"$I",*.asm
17=0,0,"$E\x64\x64dbg",$.exe
[MakeFiles]
0=x64dbg_plugin.rap
1=x64dbg_plugin.rc
2=x64dbg_plugin.asm
3=x64dbg_plugin.obj
4=x64dbg_plugin.res
5=x64dbg_plugin.exe
6=x64dbg_plugin.def
7=x64dbg_plugin.dll
8=x64dbg_plugin.txt
9=x64dbg_plugin.lib
10=x64dbg_plugin.mak
11=x64dbg_plugin.hla
12=x64dbg_plugin.com
13=x64dbg_plugin.ocx
14=x64dbg_plugin.idl
15=x64dbg_plugin.tlb
16=x64dbg_plugin.sys
17=x64dbg_plugin.dp64
18=x64dbg_plugin.pdb
[Resource]
[StringTable]
[Accel]
[VerInf]
Nme=VERINF1
ID=1
FV=1.0.0.0
PV=1.0.0.0
VerOS=0x00000004
VerFT=0x00000002
VerLNG=0x00000409
VerCHS=0x000004B0
ProductVersion=1.0.0.0
ProductName=
OriginalFilename=
LegalTrademarks=
LegalCopyright=
InternalName=
FileDescription=UASM64 plugin for x64dbg
FileVersion=1.0.0.0
CompanyName=
[Group]
Group=Assembly,Resources,Misc
1=1
2=1
3=1
4=2
5=2
6=3
7=
8=
9=
10=
11=
[*ENDDEF*]
[*BEGINTXT*]
x64dbg_plugin.Asm
;=====================================================================================
; x64dbg plugin SDK for Masm - fearless 2015
;
; [*PROJECTNAME*].asm
;
;-------------------------------------------------------------------------------------
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
    includelib \JWasm\lib\x64\Debug64.lib
    DBG64LIB equ 1
    DEBUGEXE textequ <'\Jwasm\bin\DbgWin.exe'>
    include \JWasm\include\debug64.inc
    .DATA
    RDBG_DbgWin	DB DEBUGEXE,0
    .CODE
ENDIF

Include x64dbgpluginsdk.inc               ; Main x64dbg Plugin SDK for your program, and prototypes for the main exports 

Include [*PROJECTNAME*].inc                   ; plugin's include file

pluginit	        PROTO :QWORD            ; Required prototype and export for x64dbg plugin SDK
plugstop            PROTO                   ; Required prototype and export for x64dbg plugin SDK
plugsetup           PROTO :QWORD            ; Required prototype and export for x64dbg plugin SDK
;=====================================================================================


.CONST
PLUGIN_VERSION      EQU 1

.DATA
align 01
PLUGIN_NAME         DB "[*PROJECTNAME*]",0

.DATA?
;-------------------------------------------------------------------------------------
; GLOBAL Plugin SDK variables
;-------------------------------------------------------------------------------------
align 08

PUBLIC              pluginHandle
PUBLIC              hwndDlg
PUBLIC              hMenu
PUBLIC              hMenuDisasm
PUBLIC              hMenuDump
PUBLIC              hMenuStack

pluginHandle        DD ?
hwndDlg             DQ ?
hMenu               DD ?
hMenuDisasm         DD ?
hMenuDump           DD ?
hMenuStack          DD ?
;-------------------------------------------------------------------------------------


.CODE

;=====================================================================================
; Main entry function for a DLL file  - required.
;-------------------------------------------------------------------------------------
DllMain PROC hInst:HINSTANCE, fdwReason:DWORD, lpvReserved:LPVOID
    .IF fdwReason == DLL_PROCESS_ATTACH
        mov rax, hInst
        mov hInstance, rax
    .ENDIF
    mov rax,TRUE
    ret
DllMain Endp


;=====================================================================================
; pluginit - Called by debugger when plugin.dp64 is loaded - needs to be EXPORTED
; 
; Arguments: initStruct - a pointer to a PLUG_INITSTRUCT structure
;
; Notes:     you must fill in the pluginVersion, sdkVersion and pluginName members. 
;            The pluginHandle is obtained from the same structure - it may be needed in
;            other function calls.
;
;            you can call your own setup routine from within this function to setup 
;            menus and commands, and pass the initStruct parameter to this function.
;
;-------------------------------------------------------------------------------------
pluginit PROC FRAME USES RBX initStruct:QWORD
    mov rbx, initStruct

    ; Fill in required information of initStruct, which is a pointer to a PLUG_INITSTRUCT structure
    mov eax, PLUGIN_VERSION
    mov [rbx].PLUG_INITSTRUCT.pluginVersion, eax
    mov eax, PLUG_SDKVERSION
    mov [rbx].PLUG_INITSTRUCT.sdkVersion, eax
    Invoke lstrcpy, Addr [rbx].PLUG_INITSTRUCT.pluginName, Addr PLUGIN_NAME
    
    mov rbx, initStruct
    mov eax, [rbx].PLUG_INITSTRUCT.pluginHandle
    mov pluginHandle, eax
    
    ; Do any other initialization here

	mov rax, TRUE
	ret
pluginit endp


;=====================================================================================
; plugstop - Called by debugger when the plugin.dp64 is unloaded - needs to be EXPORTED
;
; Arguments: none
; 
; Notes:     perform cleanup operations here, clearing menus and other housekeeping
;
;-------------------------------------------------------------------------------------
plugstop PROC FRAME
    
    ; remove any menus, unregister any callbacks etc
    Invoke _plugin_menuclear, hMenu
    Invoke GuiAddLogMessage, Addr szPluginUnloaded
    
    mov eax, TRUE
    ret
plugstop endp


;=====================================================================================
; plugsetup - Called by debugger to initialize your plugins setup - needs to be EXPORTED
;
; Arguments: setupStruct - a pointer to a PLUG_SETUPSTRUCT structure
; 
; Notes:     setupStruct contains useful handles for use within x64dbg, mainly Qt 
;            menu handles (which are not supported with win32 api) and the main window
;            handle with this information you can add your own menus and menu items 
;            to an existing menu, or one of the predefined supported right click 
;            context menus: hMenuDisam, hMenuDump & hMenuStack
;            
;            plugsetup is called after pluginit. 
;-------------------------------------------------------------------------------------
plugsetup PROC FRAME USES RBX setupStruct:QWORD
    mov rbx, setupStruct

    ; Extract handles from setupStruct which is a pointer to a PLUG_SETUPSTRUCT structure  
    mov rax, [rbx].PLUG_SETUPSTRUCT.hwndDlg
    mov hwndDlg, rax
    mov eax, [rbx].PLUG_SETUPSTRUCT.hMenu
    mov hMenu, eax
    mov eax, [rbx].PLUG_SETUPSTRUCT.hMenuDisasm
    mov hMenuDisasm, eax
    mov eax, [rbx].PLUG_SETUPSTRUCT.hMenuDump
    mov hMenuDump, eax
    mov eax, [rbx].PLUG_SETUPSTRUCT.hMenuStack
    mov hMenuStack, eax
    
    ; Do any setup here: add menus, menu items, callback and commands etc
    Invoke GuiAddLogMessage, Addr szPluginLoaded
    Invoke _plugin_menuaddentry, hMenu, MENU_PLUGIN1, Addr szMenuPlugin1
    
    ret
plugsetup endp


;=====================================================================================
; CBMENUENTRY - Called by debugger when a menu item is clicked - needs to be EXPORTED
;
; Arguments: cbType
;            cbInfo - a pointer to a PLUG_CB_MENUENTRY structure. The hEntry contains 
;            the resource id of menu item identifiers
;  
; Notes:     hEntry can be used to determine if the user has clicked on your plugins
;            menu item(s) and to do something in response to it.
;            Needs to be PROC C type procedure call to be compatible with debugger
;-------------------------------------------------------------------------------------
CBMENUENTRY PROC FRAME USES RBX cbType:QWORD, cbInfo:QWORD
    mov rbx, cbInfo
    mov eax, [rbx].PLUG_CB_MENUENTRY.hEntry
    
    .IF eax == MENU_PLUGIN1
        Invoke DialogBoxParam, hInstance, IDD_PluginDlg, hwndDlg, OFFSET PluginDlgProc, NULL
    .ENDIF
    
    ret

CBMENUENTRY endp


;=====================================================================================
; Plugin Dialog Procedure
;-------------------------------------------------------------------------------------
PluginDlgProc PROC FRAME hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

    mov eax, uMsg
    .IF eax == WM_INITDIALOG
        ; Any initialization here
        
	.ELSEIF eax == WM_CLOSE
        Invoke EndDialog, hWin, NULL
        
	.ELSEIF eax == WM_COMMAND
        mov rax, wParam
        and rax, 0FFFFh
        .IF rax == IDC_PLUGINDLG_OK
            Invoke SendMessage, hWin, WM_CLOSE, NULL, NULL
        .ENDIF
    .ELSE
        mov rax, FALSE
        ret
	.ENDIF
    mov rax, TRUE
    ret
PluginDlgProc endp


END DllMain
















[*ENDTXT*]
[*BEGINTXT*]
x64dbg_plugin.Inc
;=====================================================================================
; x64dbg plugin SDK for Masm - fearless 2015
;
; [*PROJECTNAME*].inc
;
;-------------------------------------------------------------------------------------
include windows.inc
include CommCtrl.inc
include shellapi.inc

includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib
includelib comctl32.lib
includelib shell32.lib

PluginDlgProc       PROTO :HWND, :UINT, :WPARAM, :LPARAM

.CONST
CRLF                TEXTEQU <13,10,0> ; carriage return and linefeed for strings that require them (GuiAddLogMessage for example) 

MENU_PLUGIN1        EQU 1
IDD_PluginDlg       EQU 1000
IDC_PLUGINDLG_OK    EQU 1001

.DATA
align 01
szMenuPlugin1       DB "x64dbg_plugin",0
szPluginLoaded      DB "x64dbg_plugin loaded.",CRLF
szPluginUnloaded    DB "x64dbg_plugin unloaded.",CRLF


.DATA?
align 08
hInstance           HINSTANCE ?

[*ENDTXT*]
[*BEGINTXT*]
x64dbg_plugin.Def
;--------------------------------------------------------------------------------------------------------
; x64dbg plugin SDK for Masm32 - fearless 2015
;
; Export definition file for your plugin
;--------------------------------------------------------------------------------------------------------

LIBRARY [*PROJECTNAME*]
EXPORTS ; Main plugin exports - only pluginit is required, but others can be included for ease of use.
        ;
        pluginit
        plugstop
        plugsetup
        ;
        ; Plugin callbacks - only export (uncomment) the callbacks you are using in your plugin, comment out the others.
        ;
        ;CBINITDEBUG
        ;CBSTOPDEBUG
        ;CBCREATEPROCESS
        ;CBEXITPROCESS
        ;CBCREATETHREAD
        ;CBEXITTHREAD
        ;CBSYSTEMBREAKPOINT
        ;CBLOADDLL
        ;CBUNLOADDLL
        ;CBOUTPUTDEBUGSTRING
        ;CBEXCEPTION
        ;CBBREAKPOINT
        ;CBPAUSEDEBUG
        ;CBRESUMEDEBUG
        ;CBSTEPPED
        ;CBATTACH
        ;CBDETACH
        ;CBDEBUGEVENT
        CBMENUENTRY
        ;CBWINEVENT
        ;CBWINEVENTGLOBAL
[*ENDTXT*]
[*BEGINTXT*]
x64dbg_plugin.rc
#include "Res/x64dbg_pluginDlg.rc"
#include "Res/x64dbg_pluginRes.rc"
#include "Res/x64dbg_pluginVer.rc"
[*ENDTXT*]
[*BEGINBIN*]
x64dbg_plugin.dlg
6600000001000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000005365676F6520554900657269660000000000000000000000
000000000000000008000000F5FFFFFF00000000E90300000000000000000000
00000000000000008D400A2C00009001E61242000000000097074200FE081301
000000000008CC10000000000A0000000A0000002C010000C8000000506C7567
696E204469616C6F670000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000E8030000494444
5F506C7567696E446C6700000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
00000000002204440000000000D314FFFFE61242000000000000000150000000
005400000074000000750000001D0000004F6B005F42544E0000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
0000040000000400000000000000E90300004944435F504C5547494E444C475F
4F4B005400000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000
[*ENDBIN*]
[*BEGINTXT*]
[*PROJECTNAME*]-readme.txt
;=====================================================================================
;
; [*PROJECTNAME*]-readme.txt
;
;-------------------------------------------------------------------------------------



[*ENDTXT*]
[*ENDPRO*]
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
[*BEGINTXT*]
Res\x64dbg_pluginRes.rc
#define MANIFEST 						24
1						MANIFEST  DISCARDABLE "[*PROJECTNAME*].xml"
[*ENDTXT*]
[*BEGINTXT*]
Res\x64dbg_pluginVer.rc
#define VERINF1 1
VERINF1 VERSIONINFO
FILEVERSION 1,0,0,0
PRODUCTVERSION 1,0,0,0
FILEOS 0x00000004
FILETYPE 0x00000000
BEGIN
  BLOCK "StringFileInfo"
  BEGIN
    BLOCK "040904B0"
    BEGIN
      VALUE "FileVersion", "1.0.0.0\0"
      VALUE "FileDescription", "Masm32 plugin for x64dbg\0"
      VALUE "InternalName", "[*PROJECTNAME*]\0"
      VALUE "OriginalFilename", "[*PROJECTNAME*].dll\0"
      VALUE "ProductName", "[*PROJECTNAME*]\0"
      VALUE "ProductVersion", "1.0.0.0\0"
    END
  END
  BLOCK "VarFileInfo"
  BEGIN
    VALUE "Translation", 0x0409, 0x04B0
  END
END
[*ENDTXT*]
[*BEGINTXT*]
Res\x64dbg_pluginDlg.rc
#define IDD_PluginDlg 1000
#define IDC_PLUGINDLG_OK 1001
IDD_PluginDlg DIALOGEX 6,6,189,99
CAPTION "Plugin Dialog"
FONT 8,"Segoe UI",400,0
STYLE 0x10CC0800
EXSTYLE 0x00000000
BEGIN
  CONTROL "Ok",IDC_PLUGINDLG_OK,"Button",0x50010000,56,71,78,17,0x00000000
END
[*ENDTXT*]