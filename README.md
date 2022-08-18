# UASM-with-RadASM

Support for UASM x86 and x64 assembler in RadASM 2.2.2.x

[![](https://img.shields.io/badge/Assembler-UASM%20v2.55-green.svg?style=flat-square&logo=visual-studio-code&logoColor=white&colorB=1CC887)](http://www.terraspace.co.uk/uasm.html) [![](https://img.shields.io/badge/RadASM%20-v2.2.2.x%20-red.svg?style=flat-square&colorB=C94C1E&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAgCAYAAAASYli2AAACcklEQVR42tWVXWiPURzHz/FyQZOiVuatuFEoKzfKSCs35EJeCqFcEEa5s2heNrXiApuXFDYveUlKSywlIRfczM0WjZvJlGKTRLb5fHvOU6fT+T/PY3bj1Kff8z8vn+f8znPO+dshihnBYv8L4awRcl2FRTarBy8bQzgEjdbabzl9nxCW2IwOFYTrsBTKEH7PET4lLLYlGpcTrkC5qxqL8HeO8CVhoQ0qRxMOw34Y5TVVIPyYI+whTLVehZ9iWgZAL1mN8G6GbArhA/TZEilqKx2HCbADXkAV0oESwhOEfdChbXOUh1ovxS+wlcH3aNvC82VX3wx7Qyl9NhEugXZEU7ixX8E6Br13nTVDPU927R3QCl0wTX2h2rUNQqUv/ATLkHUGM1hLuBF8pFipZ+zBcIZKpw1O0vjYk24mnIXxEZHGNMIBxgxJ2M2P2PF7DafhGh1/0G8Gzzv1cWASfIZn0EJ7VzpIQqWyUguulFUXiDXwApxhYE9O2ibc2PMJNbAxkp5Oyh3NGvHzQkJPrK/aANtLjNNuOAU3kf/KFTrpGsJtaIdxbu3C0gvn4Dzi3qLCI3Su4/cCnnfDBvcCv/yEW0a7o6gwWI5tJvniMwutYZbQa9elsUqzgun/JKStjKAzvAvmDXuG1M1xqerkTAyG6Cy3FREeM8k2kag6MomvcBGaefG7LOF6k1wK6SUbFl0iOpqt/v+NjYjmEva4NQpPi9K6b5JN/UiXQTg+vbF1nlc4USytPpNcok1Iuk1G0eWgS0Hnd3akXbeIbuqWvP9lXxhOW2k9cOvzMJZWUWG/Sf4/lNbbv5GEwjeSSIaof7iitPwBoSgbVud1Jo0AAAAASUVORK5CYII=)](http://www.softpedia.com/get/Programming/File-Editors/RadASM.shtml)

# Setup

* Download the latest release and extract the files to your RadASM folder. The latest release can be found in the [Release](https://github.com/mrfearless/UASM-with-RadASM/tree/master/Release) folder, or via the [releases](https://github.com/mrfearless/UASM-with-RadASM/releases) section of this Github repository or can be downloaded directly from [here](https://github.com/mrfearless/UASM-with-RadASM/blob/master/Release/UASM-with-RadASM.zip?raw=true).
* Edit RadASM.ini file to add UASM32 and UASM64 to the `Assembler` entry under the `Assembler` section:
```
[Assembler]
Assembler=masm,UASM32,UASM64,JWasm,GoAsm,fasm,nasm,html
```
* Restart RadASM if required, select new project and select from the assembler drop down list one of the new UASM entries. All projects will default to save to \RadASM\UASMxx\Projects.

# Notes
The support for UASM with RadASM makes assumptions that your UASM installation uses the following folder structure:

```
\UASM\bin
\UASM\include
\UASM\lib
\UASM\lib\x64
```
**Includes & Libraries** 

Includes for both x86 and x64 can be obtained from using the WinInc package.

Libraries for **x86** can be copied from the MASM32 SDK `\MASM32\lib` folder to the `UASM\lib` folder.

Libraries for **x64** can be obtained via (assuming default installed locations):
* Installed Windows SDK: `\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Lib\x64`
* Installed Windows Kit: `\Program Files (x86)\Windows Kits\8.1\Lib\winv6.3\um\x64`
* PellesC - `\PellesC\Lib\Win64`

These **x64** libraries should be copied to the `UASM\lib\x64` folder.



**Other Binaries**

There are other binary tools required that will have to be sourced from a Visual Studio installation and placed in the `UASM\bin` folder:
* Resource Compiler: `rc.exe`, `rcdll.dll`
* Resource Converter: `cvtres.exe`, `cvtres.exe.config`
* Linker & Lib Manager: `lib.exe`, `link.exe`, `link.exe.config`, `msobj120.dll`, `mspdb120.dll`, `mspdbcore.dll` and the c runtime `msvcr120.dll`

# Resources

* [RadASM IDE](http://www.softpedia.com/get/Programming/File-Editors/RadASM.shtml)
* [Masm32](http://www.masm32.com/download.htm)
* [UASM](http://www.terraspace.co.uk/uasm.html)
* [WinInc](http://www.terraspace.co.uk/WinInc209.zip)
* [Windows SDK archive](https://developer.microsoft.com/en-us/windows/downloads/sdk-archive)
* [Visual Studio](https://visualstudio.microsoft.com/)
* [PellesC 8.00](http://www.pellesc.de/download_start.php?file=800/setup64.exe)
