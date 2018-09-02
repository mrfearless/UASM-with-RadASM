Dll Project
x32dbg_plugin
x32dbg plugin for x64dbg
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\UASM32.EXE /c /coff /Cp /nologo /I"$I",2
3=7,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /RELEASE /DLL /DEF:$6 /LIBPATH:"$L" /OUT:"$17",3,4
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
6=*.obj,O,$B\UASM32.EXE /c /coff /Cp /nologo /I"$I",*.asm
7=0,0,"$E\x32dbg.exe",5
11=4,O,$B\RC.EXE /v,1
12=3,O,$B\UASM32.EXE /c /coff /Cp /Zi /Zd /nologo /I"$I",2
13=7,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /DEBUG /DEBUGTYPE:CV /PDB:"$18" /DLL /DEF:$6 /LIBPATH:"$L" /OUT:"$17",3,4
14=0,0,,5
15=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
16=*.obj,O,$B\UASM32.EXE /c /coff /Cp /Zi /Zd /nologo /I"$I",*.asm
17=0,0,"$E\x32dbg.exe",5
[MakeFiles]
0=x32dbg_plugin.rap
1=x32dbg_plugin.rc
2=x32dbg_plugin.asm
3=x32dbg_plugin.obj
4=x32dbg_plugin.res
5=x32dbg_plugin.exe
6=x32dbg_plugin.def
7=x32dbg_plugin.dll
8=x32dbg_plugin.txt
9=x32dbg_plugin.lib
10=x32dbg_plugin.mak
11=x32dbg_plugin.hla
12=x32dbg_plugin.com
13=x32dbg_plugin.ocx
14=x32dbg_plugin.idl
15=x32dbg_plugin.tlb
16=x32dbg_plugin.sys
17=x32dbg_plugin.dp32
18=x32dbg_plugin.pdb
[Resource]
1=,1,8,x32dbg_plugin.xml
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
FileDescription=Masm32 plugin for x32dbg
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
x32dbg_plugin.Asm
;=====================================================================================
; x64dbg plugin SDK for Masm - fearless 2016 - www.LetTheLight.in
;
; [*PROJECTNAME*].asm
;
;-------------------------------------------------------------------------------------

.686
.MMX
.XMM
.model flat,stdcall
option casemap:none

DEBUG32 EQU 1

IFDEF DEBUG32
    PRESERVEXMMREGS equ 1
    includelib M:\Masm32\lib\Debug32.lib
    DBG32LIB equ 1
    DEBUGEXE textequ <'M:\Masm32\DbgWin.exe'>
    include M:\Masm32\include\debug32.inc
ENDIF

Include x64dbgpluginsdk.inc               ; Main x64dbg Plugin SDK for your program, and prototypes for the main exports 

Include [*PROJECTNAME*].inc ; plugin's include file

;=====================================================================================


.CONST
PLUGIN_VERSION      EQU 1

.DATA
PLUGIN_NAME         DB "[*PROJECTNAME*]",0

.DATA?
;-------------------------------------------------------------------------------------
; GLOBAL Plugin SDK variables
;-------------------------------------------------------------------------------------
PUBLIC              pluginHandle
PUBLIC              hwndDlg
PUBLIC              hMenu
PUBLIC              hMenuDisasm
PUBLIC              hMenuDump
PUBLIC              hMenuStack

pluginHandle        DD ?
hwndDlg             DD ?
hMenu               DD ?
hMenuDisasm         DD ?
hMenuDump           DD ?
hMenuStack          DD ?
;-------------------------------------------------------------------------------------


.CODE

;=====================================================================================
; Main entry function for a DLL file  - required.
;-------------------------------------------------------------------------------------
DllMain PROC hinstDLL:HINSTANCE, fdwReason:DWORD, lpvReserved:DWORD
    .IF fdwReason == DLL_PROCESS_ATTACH
        mov eax, hinstDLL
        mov hInstance, eax
    .ENDIF
    mov eax,TRUE
    ret
DllMain ENDP


;=====================================================================================
; pluginit - Called by debugger when plugin.dp32 is loaded - needs to be EXPORTED
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
pluginit PROC C PUBLIC USES EBX initStruct:DWORD
    mov ebx, initStruct

    ; Fill in required information of initStruct, which is a pointer to a PLUG_INITSTRUCT structure
    mov eax, PLUGIN_VERSION
    mov [ebx].PLUG_INITSTRUCT.pluginVersion, eax
    mov eax, PLUG_SDKVERSION
    mov [ebx].PLUG_INITSTRUCT.sdkVersion, eax
    Invoke lstrcpy, Addr [ebx].PLUG_INITSTRUCT.pluginName, Addr PLUGIN_NAME
    
    mov ebx, initStruct
    mov eax, [ebx].PLUG_INITSTRUCT.pluginHandle
    mov pluginHandle, eax
    
    ; Do any other initialization here

	mov eax, TRUE
	ret
pluginit ENDP


;=====================================================================================
; plugstop - Called by debugger when the plugin.dp32 is unloaded - needs to be EXPORTED
;
; Arguments: none
; 
; Notes:     perform cleanup operations here, clearing menus and other housekeeping
;
;-------------------------------------------------------------------------------------
plugstop PROC C PUBLIC 
    
    ; remove any menus, unregister any callbacks etc
    Invoke _plugin_menuclear, hMenu
    Invoke GuiAddLogMessage, Addr sz[*PROJECTNAME*]Unloaded
    
    mov eax, TRUE
    ret
plugstop ENDP


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
plugsetup PROC C PUBLIC USES EBX setupStruct:DWORD
    mov ebx, setupStruct

    ; Extract handles from setupStruct which is a pointer to a PLUG_SETUPSTRUCT structure  
    mov eax, [ebx].PLUG_SETUPSTRUCT.hwndDlg
    mov hwndDlg, eax
    mov eax, [ebx].PLUG_SETUPSTRUCT.hMenu
    mov hMenu, eax
    mov eax, [ebx].PLUG_SETUPSTRUCT.hMenuDisasm
    mov hMenuDisasm, eax
    mov eax, [ebx].PLUG_SETUPSTRUCT.hMenuDump
    mov hMenuDump, eax
    mov eax, [ebx].PLUG_SETUPSTRUCT.hMenuStack
    mov hMenuStack, eax
    
    ; Do any setup here: add menus, menu items, callback and commands etc
    Invoke GuiAddLogMessage, Addr sz[*PROJECTNAME*]Loaded
    Invoke _plugin_menuaddentry, hMenu, MENU_[*PROJECTNAME*], Addr sz[*PROJECTNAME*]
    
    ret
plugsetup ENDP


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
CBMENUENTRY PROC C PUBLIC USES EBX cbType:DWORD, cbInfo:DWORD
    mov ebx, cbInfo
    mov eax, [ebx].PLUG_CB_MENUENTRY.hEntry
    
    .IF eax == MENU_[*PROJECTNAME*]
        Invoke DialogBoxParam, hInstance, IDD_PluginDlg, hwndDlg, OFFSET [*PROJECTNAME*]DlgProc, NULL
    .ENDIF
    
    ret

CBMENUENTRY ENDP


;=====================================================================================
; [*PROJECTNAME*] Dialog Procedure
;-------------------------------------------------------------------------------------
[*PROJECTNAME*]DlgProc PROC hWin:HWND,iMsg:DWORD,wParam:WPARAM, lParam:LPARAM

    mov eax, iMsg
    .IF eax == WM_INITDIALOG
        ; Any initialization here
        
	.ELSEIF eax == WM_CLOSE
        Invoke EndDialog, hWin, NULL
        
	.ELSEIF eax == WM_COMMAND
        mov eax, wParam
        and eax, 0FFFFh
        .IF eax == IDC_PLUGINDLG_OK
            Invoke SendMessage, hWin, WM_CLOSE, NULL, NULL
        .ENDIF
    .ELSE
        mov eax, FALSE
        ret
	.ENDIF
    mov eax, TRUE
    ret
[*PROJECTNAME*]DlgProc ENDP


END DllMain
















[*ENDTXT*]
[*BEGINTXT*]
x32dbg_plugin.Inc
;=====================================================================================
; x64dbg plugin SDK For Assembler x86 - fearless
; https://github.com/mrfearless/x64dbg-Plugin-SDK-for-x86-Assembler
;
; [*PROJECTNAME*].inc
;
;-------------------------------------------------------------------------------------
include windows.inc
include user32.inc
include kernel32.inc
includelib user32.lib
includelib kernel32.lib

[*PROJECTNAME*]DlgProc       PROTO :DWORD, :DWORD, :DWORD, :DWORD

.CONST
CRLF                TEXTEQU <13,10,0> ; carriage return and linefeed for strings that require them (GuiAddLogMessage for example) 

MENU_[*PROJECTNAME*]        EQU 1
IDD_PluginDlg       EQU 1000
IDC_PLUGINDLG_OK    EQU 1001

.DATA
sz[*PROJECTNAME*]       DB "[*PROJECTNAME*]",0
sz[*PROJECTNAME*]Loaded      DB "[*PROJECTNAME*] loaded.",CRLF
sz[*PROJECTNAME*]Unloaded    DB "[*PROJECTNAME*] unloaded.",CRLF
sz[*PROJECTNAME*]Info       DB 13,10         
                    DB "[*PROJECTNAME*] x32dbg plugin by fearless 2016 - www.LetTheLight.in",13,10
                    DB 13,10
                    DB "[*PROJECTNAME*] Features & Usage:",13,10
                    DB " - ",13,10  
                    DB 13,10,0

.DATA?
hInstance           DD ?

[*ENDTXT*]
[*BEGINTXT*]
x32dbg_plugin.Def
;--------------------------------------------------------------------------------------------------------
; x64dbg plugin SDK For Assembler x86 - fearless
;
; [*PROJECTNAME*].def - Export definition file for your plugin
;
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
x32dbg_plugin.rc
#include "Res/x32dbg_pluginDlg.rc"
#include "Res/x32dbg_pluginRes.rc"
#include "Res/x32dbg_pluginVer.rc"
[*ENDTXT*]
[*BEGINBIN*]
x32dbg_plugin.dlg
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
[*BEGINTXT*]
Res\x32dbg_pluginRes.rc
#define MANIFEST 24
1 MANIFEST DISCARDABLE "[*PROJECTNAME*].xml"
[*ENDTXT*]
[*BEGINTXT*]
Res\x32dbg_pluginVer.rc
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
      VALUE "FileDescription", "Masm32 plugin for x32_dbg\0"
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
Res\x32dbg_pluginDlg.rc
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
[*BEGINTXT*]
go.bat
Copy [*PROJECTNAME*].dp32 M:\x64dbg\x32\plugins\[*PROJECTNAME*].dp32 /y > NUL
[*ENDTXT*]
[*BEGINTXT*]
packagebitbucket.bat
@echo off
echo x64dbg plugin sdk for Masm - Creating packages
echo.
echo Creating [*PROJECTNAME*] source package...
del [*PROJECTNAME*]Source.zip
"Z:\Program Files\Compression Programs\WinRAR\WinRar.exe" a -m5 -r [*PROJECTNAME*]Source.zip [*PROJECTNAME*].rap [*PROJECTNAME*].Inc [*PROJECTNAME*].Asm [*PROJECTNAME*]-readme.txt [*PROJECTNAME*].rc [*PROJECTNAME*].Def [*PROJECTNAME*].xml .\Images\*.png .\Res\*.*
echo.
echo Creating [*PROJECTNAME*] full package including source...
del [*PROJECTNAME*]-FullPackageIncSource.zip
"Z:\Program Files\Compression Programs\WinRAR\WinRar.exe" a -m5 [*PROJECTNAME*]-FullPackageIncSource.zip APIInfoSource.zip [*PROJECTNAME*]-readme.txt [*PROJECTNAME*].dp32
echo.
echo.Copying files to BitBucker project folders...
Copy /Y [*PROJECTNAME*]Source.zip M:\Bitbucket\x64dbg-plugin-sdk-for-masm\extras\plugins\ >> NUL
Copy /Y [*PROJECTNAME*]-readme.txt M:\Bitbucket\x64dbg-plugin-sdk-for-masm\extras\plugins\ >> NUL
Copy /Y [*PROJECTNAME*]-readme.txt M:\Bitbucket\x64dbg-plugin-sdk-for-masm\downloads\ >> NUL
Copy /Y [*PROJECTNAME*].dp32 M:\Bitbucket\x64dbg-plugin-sdk-for-masm\extras\plugins\ >> NUL
Copy /Y [*PROJECTNAME*].dp32 M:\Bitbucket\x64dbg-plugin-sdk-for-masm\downloads\ >> NUL
Copy /Y [*PROJECTNAME*]-FullPackageIncSource.zip M:\Bitbucket\x64dbg-plugin-sdk-for-masm\downloads\ >> NUL
echo.
echo.Finished
[*ENDTXT*]
[*BEGINTXT*]
copytolocalgithubrepo.bat
@echo off
echo [*PROJECTNAME*] - x86 Plugin For x64dbg
echo.
echo.Copying files to GitHub project folders...
md M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]
md M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\images
md M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\res
md M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\release
md M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\downloads
md M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\screenshots


copy /Y [*PROJECTNAME*].rap M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\ >> NUL
copy /Y [*PROJECTNAME*].asm M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\ >> NUL
copy /Y [*PROJECTNAME*].inc M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\ >> NUL
copy /Y [*PROJECTNAME*].def M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\ >> NUL
copy /Y [*PROJECTNAME*].dlg M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\ >> NUL
copy /Y [*PROJECTNAME*].xml M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\ >> NUL
copy /Y [*PROJECTNAME*].rc M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\ >> NUL
copy /Y [*PROJECTNAME*]-readme.txt M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\ >> NUL


copy /Y Images\*.* M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\images\ >> NUL
copy /Y Res\*.* M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\res\ >> NUL
copy /Y [*PROJECTNAME*].dp32 M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\release\ >> NUL
copy /Y [*PROJECTNAME*]-readme.txt M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\release\ >> NUL
copy /Y [*PROJECTNAME*].dp32 M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\downloads\ >> NUL
copy /Y [*PROJECTNAME*]-readme.txt M:\GitProjects\x64dbg_plugins\[*PROJECTNAME*]\downloads\ >> NUL
[*ENDTXT*]