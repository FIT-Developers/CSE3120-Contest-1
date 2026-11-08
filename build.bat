@echo off
setlocal
cd /d "%~dp0"

where ml >nul 2>&1
if errorlevel 1 (
    echo Please use the x86 Visual Studio Developer Command Prompt.
    exit /b 1
)

ml /nologo /c /coff /I C:\Irvine main.asm
if errorlevel 1 exit /b 1

link /nologo /SUBSYSTEM:CONSOLE /LIBPATH:C:\Irvine main.obj Irvine32.lib kernel32.lib user32.lib
if errorlevel 1 exit /b 1

echo Build successful! Run main.exe to play.
