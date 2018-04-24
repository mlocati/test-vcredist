@echo off
setlocal

set VSVERSION=%~1
set ARCHITECTURE=%~2
if "%VSVERSION%%ARCHITECTURE%" equ "" (
	echo Syntax: %0 ^<VSVersion^> ^<Architecture^>>&2
	exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2017x86" (
	call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2017x64" (
	call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2015x86" (
	call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2015x64" (
	call "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" /x64
	if errorlevel 1 exit /b 1
	call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86_amd64
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2013x86" (
	call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2013x64" (
	call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86_amd64
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2012x86" (
	call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2012x64" (
	call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86_amd64
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2010x86" (
	call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2010x64" (
	call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86_amd64
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2008x86" (
	call "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" x86
	if errorlevel 1 exit /b 1
) else if "%VSVERSION%%ARCHITECTURE%" equ "2008x64" (
	call "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" x86_amd64
	if errorlevel 1 exit /b 1
) else (
	echo Unrecognized VSVersion "%VSVERSION%" with architecture "%ARCHITECTURE%">&2
	exit /b 1
)


set COMPILER_FLAGS=
rem Don't show startup message
set COMPILER_FLAGS=%COMPILER_FLAGS% /nologo
rem Do not report errors to Microsoft
set COMPILER_FLAGS=%COMPILER_FLAGS% /errorReport:none
rem Compile without linking
set COMPILER_FLAGS=%COMPILER_FLAGS% /c
rem Set warnings level
set COMPILER_FLAGS=%COMPILER_FLAGS% /W3
rem Consider warnings as errors
set COMPILER_FLAGS=%COMPILER_FLAGS% /WX
rem Optimize for file size
set COMPILER_FLAGS=%COMPILER_FLAGS% /O1
rem Optimize for code size
set COMPILER_FLAGS=%COMPILER_FLAGS% /Os
rem Generates intrinsic functions.
set COMPILER_FLAGS=%COMPILER_FLAGS% /Oi
rem Do not omit frame pointer (x86 only)
if %ARCHITECTURE% equ x86 set COMPILER_FLAGS=%COMPILER_FLAGS% /Oy-
rem Optimize whole program
set COMPILER_FLAGS=%COMPILER_FLAGS% /GL
rem Disable minimal recompilation
set COMPILER_FLAGS=%COMPILER_FLAGS% /Gm-
rem Multithread runtime DLL library
set COMPILER_FLAGS=%COMPILER_FLAGS% /MD
rem Enable security check
set COMPILER_FLAGS=%COMPILER_FLAGS% /GS
rem Enable function-level linking
set COMPILER_FLAGS=%COMPILER_FLAGS% /Gy
rem Fast floating point model
set COMPILER_FLAGS=%COMPILER_FLAGS% /fp:precise
rem Consider WChar_t as a predefined type
set COMPILER_FLAGS=%COMPILER_FLAGS% /Zc:wchar_t
rem Remove unreferenced functions or data that are COMDATs or only have internal linkage (Visual Studio 2010+ only)
if %VSVERSION% leq 2010 set set COMPILER_FLAGS=%COMPILER_FLAGS% /Zc:inline
rem Use the __cdecl calling convention
set COMPILER_FLAGS=%COMPILER_FLAGS% /Gd
rem Turn off analysis
set COMPILER_FLAGS=%COMPILER_FLAGS% /analyze-
rem Define the "no debug" macro
set COMPILER_FLAGS=%COMPILER_FLAGS% /D NDEBUG
rem Define the "we are on Windows" macro
set COMPILER_FLAGS=%COMPILER_FLAGS% /D WIN32
rem Define the "this is a console application" macro
set COMPILER_FLAGS=%COMPILER_FLAGS% /D _CONSOLE
rem Tell the compiler to use MFC in a shared DLL
set COMPILER_FLAGS=%COMPILER_FLAGS% /D _AFXDLL

set LINKER_FLAGS=
rem Set .exe path
set LINKER_FLAGS=%LINKER_FLAGS% /OUT:"%dp0%tester.exe"
rem Don't show startup message
set LINKER_FLAGS=%LINKER_FLAGS% /NOLOGO
rem Do not report errors to Microsoft
set LINKER_FLAGS=%LINKER_FLAGS% /ERRORREPORT:none
rem No output file to be generated if the linker generates a warning
set LINKER_FLAGS=%LINKER_FLAGS% /WX
rem Turn off incremental build
set LINKER_FLAGS=%LINKER_FLAGS% /INCREMENTAL:NO
rem Do not create a manifest file
set LINKER_FLAGS=%LINKER_FLAGS% /MANIFEST:NO
rem Tell the linker that this is a character-mode application
set LINKER_FLAGS=%LINKER_FLAGS% /SUBSYSTEM:CONSOLE
rem Eliminate functions and data that are never referenced
set LINKER_FLAGS=%LINKER_FLAGS% /OPT:REF
rem Fold identical COMDAT
set LINKER_FLAGS=%LINKER_FLAGS% /OPT:ICF
rem Disable link-time code generation (Visual Studio 2015+ only)
if %VSVERSION% geq 2015 set LINKER_FLAGS=%LINKER_FLAGS% /LTCG:OFF
rem Without this: warning "MSIL .netmodule or module compiled with /GL found; restarting link with /LTCG; add /LTCG to the link command line to improve linker performance"
if %VSVERSION% leq 2010 set LINKER_FLAGS=%LINKER_FLAGS% /LTCG
rem The application should be randomly rebased at load time
set LINKER_FLAGS=%LINKER_FLAGS% /DYNAMICBASE
rem Do not generate a PDB
set LINKER_FLAGS=%LINKER_FLAGS% /DEBUG:NONE
rem Set target architecture
if %ARCHITECTURE% equ x86 set LINKER_FLAGS=%LINKER_FLAGS% /MACHINE:X86
if %ARCHITECTURE% equ x64 set LINKER_FLAGS=%LINKER_FLAGS% /MACHINE:X64

CL.exe  %COMPILER_FLAGS% "%~dp0tester.c"
if errorlevel 1 exit /b 1
link.exe  %LINKER_FLAGS% "%~dp0tester.obj"
if errorlevel 1 exit /b 1
del "%~dp0tester.obj"
exit /b 0