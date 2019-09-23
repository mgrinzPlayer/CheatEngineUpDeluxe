@echo off

rem check if you have SVN client in path
svn --version 1>nul 2>nul
svn --version 1>nul 2>nul
if not "%errorlevel%"=="0" (
  echo You don't have SVN client in PATH variable.
  echo.
  echo Suggestion: ^(re^)install TortoiseSVN with comand line client tools
  echo          or ^(re^)install Slik-Subversion
  pause 1>nul 2>nul
  goto :EOF
)

rem 1=32bit, 2=64bit, 3=both
set cpumode=3

rem 1=release, 2=debug
set buildmode=1

rem 1=clean lib
set clean=1

rem 1=fullClean
set fullClean=1

set prog=%cd%\lazarus\lazbuild.exe
echo Lazarus path: %prog%

svn.exe checkout --non-interactive --trust-server-cert -r HEAD "https://github.com/cheat-engine/cheat-engine/trunk/Cheat Engine" CheatEngine

cd CheatEngine

if "%fullClean%"=="1" (
  svn revert -R .
  svn cleanup --remove-unversioned
  svn cleanup --remove-ignored
)

if "%clean%"=="1" ( rmdir /s /q "lib" 2>nul )

if "%buildmode%"=="1" ( set buildmodetext=Buildmode: Release) else ( set buildmodetext=Buildmode: Debug)
if "%clean%"=="1"     ( set cleanmodetext=, CleanRelease)
if "%cpumode%"=="1" Title %buildmodetext%%cleanmodetext%, cpumode: Only 32bit
if "%cpumode%"=="2" Title %buildmodetext%%cleanmodetext%, cpumode: Only 64bit
if "%cpumode%"=="3" Title %buildmodetext%%cleanmodetext%, cpumode: 32bit and 64bit

if "%cpumode%"=="2" goto :cpumode64bit
ECHO.
del /f /q cheatengine.res 2>nul
  echo Building project "CheatEngine 32bit"
  if "%buildmode%"=="1" (
    %prog% --build-mode="Release 64-Bit" --os=win32 --cpu=i386 cheatengine.lpi > %temp%\lazarusCEBuildLog_32bit.txt) else (
    %prog% --build-mode="debug-nomt 64-bit" --os=win32 --cpu=i386 cheatengine.lpi > %temp%\lazarusCEBuildLog_32bit.txt )
  if %errorlevel% == 0 ( echo Project "CheatEngine 32bit" successfully built & ECHO.) else type %temp%\lazarusCEBuildLog_32bit.txt
ECHO.
if "%cpumode%"=="1" goto :skip

:cpumode64bit
ECHO.
del /f /q cheatengine.res 2>nul
  echo Building project "CheatEngine 64bit"
  if "%buildmode%"=="1" (
    %prog% --build-mode="Release 64-Bit" --os=win64 --cpu=x86_64 cheatengine.lpi > %temp%\lazarusCEBuildLog_64bit.txt) else (
    %prog% --build-mode="debug-nomt 64-bit" --os=win64 --cpu=x86_64 cheatengine.lpi > %temp%\lazarusCEBuildLog_64bit.txt )
  if %errorlevel% == 0 ( echo Project "CheatEngine 64bit" successfully built & ECHO.) else type %temp%\lazarusCEBuildLog_64bit.txt
ECHO.
:skip
del /f /q cheatengine.res 2>nul

pause
pause
