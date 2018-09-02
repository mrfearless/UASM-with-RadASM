Dll64 Project
Dll64Project
64Bit Dynamic Link Library
[*BEGINPRO*]
[*BEGINDEF*]
[MakeDef]
Menu=1,1,1,1,0,0,0,0,0,0
1=4,O,$B\RC.EXE /v,1
2=3,O,$B\UASM64.exe /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /I"$I",2
3=7,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /RELEASE /DLL /DEF:$6 /MACHINE:X64 /LIBPATH:"$L" /OUT:"$7",3,4
4=0,0,,5
5=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
6=*.obj,O,$B\UASM64.exe /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /I"$I",*.asm
7=0,0,"$E\x64\x64dbg",5
11=4,O,$B\RC.EXE /v,1
12=3,O,$B\UASM64.exe /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /Zi /Zd /nologo /I"$I",2
13=7,O,$B\LINK.EXE /SUBSYSTEM:WINDOWS /DEBUG /DEBUGTYPE:CV /PDB:"$18" /DLL /DEF:$6 /MACHINE:X64 /LIBPATH:"$L" /OUT:"$7",3,4
14=0,0,,5
15=rsrc.obj,O,$B\CVTRES.EXE,rsrc.res
16=*.obj,O,$B\UASM64.exe /c -win64 -Zp8 /Zi /win64 /D_WIN64 /Cp /nologo /W2 /I"$I",*.asm
17=0,0,"$E\x64\x64dbg",$.exe
[MakeFiles]
0=Dll64Project.rap
1=Dll64Project.rc
2=Dll64Project.asm
3=Dll64Project.obj
4=Dll64Project.res
5=Dll64Project.exe
6=Dll64Project.def
7=Dll64Project.dll
8=Dll64Project.txt
9=Dll64Project.lib
10=Dll64Project.mak
11=Dll64Project.hla
12=Dll64Project.com
13=Dll64Project.ocx
14=Dll64Project.idl
15=Dll64Project.tlb
16=Dll64Project.sys
17=Dll64Project.dp32
18=Dll64Project.pdb
[Resource]
1=,1,8,Dll64Project.xml
[StringTable]
[Accel]
[VerInf]
Nme=VERINF1
ID=1
FV=1.0.0.0
PV=1.0.0.0
VerOS=0x00000004
VerFT=0x00000000
VerLNG=0x00000409
VerCHS=0x000004B0
ProductVersion=1.0.0.0
ProductName=
OriginalFilename=
LegalTrademarks=
LegalCopyright=
InternalName=
FileDescription=HJWasm64 64bit DLL
FileVersion=1.0.0.0
CompanyName=
[Group]
Group=Assembly,Resources,Misc
1=1
2=1
3=1
4=2
5=3
6=
7=
8=
9=
10=
11=
[*ENDDEF*]
[*BEGINTXT*]
Dll64Project.Asm
;=====================================================================================
; [*PROJECTNAME*] by <yourname> 2015
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

Include [*PROJECTNAME*].inc

;=====================================================================================




.CODE

;=====================================================================================
; Main entry function for a DLL file  - required.
;-------------------------------------------------------------------------------------
DllMain PROC FRAME hInst:HINSTANCE, fdwReason:DWORD, lpvReserved:LPVOID
    .IF fdwReason == DLL_PROCESS_ATTACH
        mov rax, hInst
        mov hInstance, rax
    .ENDIF
    mov rax,TRUE
    ret
DllMain Endp



END DllMain
















[*ENDTXT*]
[*BEGINTXT*]
Dll64Project.Inc
;=====================================================================================
; [*PROJECTNAME*] include file
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

.CONST


.DATA
align 01
szDllName           DB "[*PROJECTNAME*]",0
szDllLoaded         DB "Dll64Project loaded.",0
szDllUnloaded       DB "Dll64Project unloaded.",0


.DATA?
align 08
hInstance           HINSTANCE ?

[*ENDTXT*]
[*BEGINTXT*]
Dll64Project.Def
;--------------------------------------------------------------------------------------------------------
; [*PROJECTNAME*] export definition file for your DLL
;
; [*PROJECTNAME*].def 
;--------------------------------------------------------------------------------------------------------

LIBRARY [*PROJECTNAME*]
EXPORTS DllMain

[*ENDTXT*]
[*BEGINTXT*]
Dll64Project.rc
#include "Res/Dll64ProjectRes.rc"
#include "Res/Dll64ProjectVer.rc"
[*ENDTXT*]
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
Res\Dll64ProjectRes.rc
#define MANIFEST 						24
1						MANIFEST  DISCARDABLE "[*PROJECTNAME*].xml"
[*ENDTXT*]
[*BEGINTXT*]
Res\Dll64ProjectVer.rc
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
      VALUE "FileDescription", "HJWasm64 64bit DLL\0"
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