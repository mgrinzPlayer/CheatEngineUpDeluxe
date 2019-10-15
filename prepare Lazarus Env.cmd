@echo off
cd /d "%~dp0"

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

REM DOWNLOAD SECTION START
set FPCREVSTR=42444
set LAZREVSTR=60307
set     fpcBranchAndRev=-r 42444 https://svn.freepascal.org/svn/fpc/branches/fixes_3_2
set lazarusBranchAndRev=-r 60307 https://svn.freepascal.org/svn/lazarus/tags/lazarus_2_0_0

title CheatEngineUpDeluxe - prepare FPC and Lazarus environment
echo FPC 3.2.0, branch: fixes_3_2, revision 42444
echo Lazarus 2.0.0, tag: lazarus_2_0_0, revision 60307
echo.

:step1
echo.
echo Download FPC from [o]fficial source or [c]ompressed source or
set /p answer1=[r]eady to use Compiled 32bit FPC with crosscompiler[o,c,r]?
set answer1=%answer1:O=o%
set answer1=%answer1:C=c%
set answer1=%answer1:R=r%
if "%answer1%"=="r" (
rem
) else if "%answer1%"=="c" (
rem
) else if NOT "%answer1%"=="o" goto :step1

:step2
echo.
set /p answer2=Download Lazarus from [o]fficial source or [c]ompressed source [o,c]?
set answer2=%answer2:O=o%
set answer2=%answer2:C=c%
if "%answer2%"=="c" (
rem
) else if NOT "%answer2%"=="o" goto :step2

if "%answer1%"=="r" (
  rem 32bit with crosscompiler
  set answer3=t
  set answer4=y
  goto :nomorequestions
)

:step3
echo.
set /p answer3=Do you want [t]32 or [s]64 bit environment [t,s]?
set answer3=%answer3:T=t%
set answer3=%answer3:S=s%
if "%answer3%"=="s" (
rem
) else if NOT "%answer3%"=="t" goto :step3

:step4
echo.
set /p answer4=Do you want crosscompiler [y,n]?
set answer4=%answer4:Y=y%
set answer4=%answer4:N=n%
if "%answer4%"=="n" (
rem
) else if NOT "%answer4%"=="y" goto :step4

:nomorequestions

rem download 7za.exe - 7-Zip 19.00 standalone console version
if NOT EXIST 7za.exe ( svn.exe cat --non-interactive --trust-server-cert -r HEAD "https://github.com/mgrinzPlayer/CheatEngineUpDeluxe/trunk/tool/7za.exe" > 7za.exe )

echo.
echo.
echo.
if "%answer1%"=="o" (
  echo SVN checkout %fpcBranchAndRev%
  rem tests not needed
  svn.exe checkout -N --non-interactive --trust-server-cert %fpcBranchAndRev%/tests   fpcsrc/tests
  svn.exe checkout    --non-interactive --trust-server-cert %fpcBranchAndRev%         fpcsrc
  echo.
  rem TODO: apply patches (if any) before creating an archive
  echo Creating fpcsrc.7z
  7za.exe a fpcsrc.7z -y -mm=lzma2 -mx=1 -xr!".svn" fpcsrc 1>nul
  echo.
) else if "%answer1%"=="c" (
  if NOT EXIST fpcsrc.7z (
    echo Downloading FPC:   0%%
    svn.exe cat --non-interactive --trust-server-cert -r HEAD "https://github.com/mgrinzPlayer/CheatEngineUpDeluxe/trunk/fpcsrc.7z" > fpcsrc.7z
    echo Downloading FPC: 100%%
  ) else echo Downloading FPC: 100%%
  echo Extracting FPC...
  7za.exe x -bd -y fpcsrc.7z 1>nul
  rem TODO: if any patches exists, apply them and then update an archive
) else if "%answer1%"=="r" (
  if NOT EXIST compiled_fpc.7z.001 (
    echo Downloading Compiled FPC:  0%%
    svn.exe cat --non-interactive --trust-server-cert -r HEAD "https://github.com/mgrinzPlayer/CheatEngineUpDeluxe/trunk/compiledFPC/compiled_fpc.7z.001" > compiled_fpc.7z.001
    echo Downloading Compiled FPC: 35%%
    svn.exe cat --non-interactive --trust-server-cert -r HEAD "https://github.com/mgrinzPlayer/CheatEngineUpDeluxe/trunk/compiledFPC/compiled_fpc.7z.002" > compiled_fpc.7z.002
    echo Downloading Compiled FPC: 69%%
    svn.exe cat --non-interactive --trust-server-cert -r HEAD "https://github.com/mgrinzPlayer/CheatEngineUpDeluxe/trunk/compiledFPC/compiled_fpc.7z.003" > compiled_fpc.7z.003
    echo Downloading Compiled FPC: 100%%
  ) else echo Downloading Compiled FPC: 100%%
  echo Extracting Compiled FPC...
  7za.exe x -bd -y compiled_fpc.7z.001 1>nul
)

if "%answer2%"=="o" (
  echo SVN checkout %lazarusBranchAndRev%
  svn.exe checkout    --non-interactive --trust-server-cert %lazarusBranchAndRev% lazarus
  echo.
  rem TODO: apply patches (if any) before creating an archive
  echo Creating lazarus.7z
  7za.exe a lazarus.7z -y -mm=lzma2 -mx=1 -xr!".svn" lazarus 1>nul
  echo.
) else if "%answer2%"=="c" (
  if NOT EXIST lazarus.7z (
    echo Downloading Lazarus:   0%%
    svn.exe cat --non-interactive --trust-server-cert -r HEAD "https://github.com/mgrinzPlayer/CheatEngineUpDeluxe/trunk/lazarus.7z" > lazarus.7z
    echo Downloading Lazarus: 100%%
  ) else echo Downloading Lazarus: 100%%
  echo Extracting Lazarus...
  7za.exe x -bd -y lazarus.7z 1>nul
  rem TODO: if any patches exists, apply them and then update an archive
)

if "%answer1%"=="r" ( goto :bootstrapnotneeded )
if NOT EXIST bootstrap.7z (
  echo Downloading bootstrap:   0%%
  svn.exe cat --non-interactive --trust-server-cert -r HEAD "https://github.com/mgrinzPlayer/CheatEngineUpDeluxe/trunk/bootstrap.7z" > bootstrap.7z
  echo Downloading bootstrap: 100%%
) else echo Downloading bootstrap: 100%%
echo Extracting bootstrap...
7za.exe x -bd -y bootstrap.7z 1>nul
:bootstrapnotneeded

if NOT EXIST mingw.7z (
  echo Downloading GDB:   0%
  svn.exe cat --non-interactive --trust-server-cert -r HEAD "https://github.com/mgrinzPlayer/CheatEngineUpDeluxe/trunk/mingw.7z" > mingw.7z
  echo Downloading GDB: 100%%
) else echo Downloading GDB: 100%%
REM DOWNLOAD SECTION END




REM COMPILATION SECTION START
set target32Bit_source32Bit=OS_SOURCE=win32 CPU_SOURCE=i386   OS_TARGET=win32 CPU_TARGET=i386
set target64Bit_source32Bit=OS_SOURCE=win32 CPU_SOURCE=i386   OS_TARGET=win64 CPU_TARGET=x86_64
set target32Bit_source64Bit=OS_SOURCE=win64 CPU_SOURCE=x86_64 OS_TARGET=win32 CPU_TARGET=i386
set target64Bit_source64Bit=OS_SOURCE=win64 CPU_SOURCE=x86_64 OS_TARGET=win64 CPU_TARGET=x86_64

if "%answer3%"=="t" (
  set CPU_OS=i386-win32
) else (
  set CPU_OS=x86_64-win64
)

REM get current directory (without \ at the end)
set CurrentDir=%CD%
if "%CurrentDir:~-1%"=="\" set CurrentDir=%CurrentDir:~0,-1%

set FPCINSTALLPATH=%CurrentDir%\fpc\3.2.0
set OLDFPC32=%CurrentDir%\bootstrap\ppc386.exe
set OLDFPC64=%CurrentDir%\bootstrap\ppcx64.exe
set NEWFPC=%FPCINSTALLPATH%\bin\%CPU_OS%\fpc.exe
set CROSS32=%FPCINSTALLPATH%\bin\%CPU_OS%\ppcross386.exe
set CROSS64=%FPCINSTALLPATH%\bin\%CPU_OS%\ppcrossx64.exe
set      compOpts="OPT=-vw-n-h-l-d-u-t-p-c- -g- -Xs -O3 -CX -XX -OoREGVAR"
set compOpts64bit="OPT=-vw-n-h-l-d-u-t-p-c- -g- -Xs -O3 -CX -XX -OoREGVAR -dFPC_SOFT_FPUX80"
set fpcmakeppumove=FPCMAKE=%FPCINSTALLPATH%\bin\%CPU_OS%\fpcmake.exe PPUMOVE=%FPCINSTALLPATH%\bin\%CPU_OS%\ppumove.exe

if "%answer1%"=="r" ( goto :dolazarus )

md %FPCINSTALLPATH%\bin\%CPU_OS% 2>nul
copy /Y bootstrap\*  %FPCINSTALLPATH%\bin\%CPU_OS% 1>nul
rem remove old compiler
del /f /q "%FPCINSTALLPATH%\bin\%CPU_OS%\ppc386.exe" 2>nul
del /f /q "%FPCINSTALLPATH%\bin\%CPU_OS%\ppcx64.exe" 2>nul
del /f /q "%FPCINSTALLPATH%\bin\%CPU_OS%\ppcross386.exe" 2>nul
del /f /q "%FPCINSTALLPATH%\bin\%CPU_OS%\ppcrossx64.exe" 2>nul

set path=%CurrentDir%\bootstrap

set      Env32bit=--directory=fpcsrc  %fpcmakeppumove% INSTALL_PREFIX=%FPCINSTALLPATH% %target32Bit_source32Bit% REVSTR=%FPCREVSTR% REVINC=force
set Env32bitCross=--directory=fpcsrc  %fpcmakeppumove% INSTALL_PREFIX=%FPCINSTALLPATH% %target64Bit_source32Bit% REVSTR=%FPCREVSTR% REVINC=force CROSSINSTALL=1 NOGDBMI=1
set      Env64bit=--directory=fpcsrc  %fpcmakeppumove% INSTALL_PREFIX=%FPCINSTALLPATH% %target64Bit_source64Bit% REVSTR=%FPCREVSTR% REVINC=force
set Env64bitCross=--directory=fpcsrc  %fpcmakeppumove% INSTALL_PREFIX=%FPCINSTALLPATH% %target32Bit_source64Bit% REVSTR=%FPCREVSTR% REVINC=force CROSSINSTALL=1 NOGDBMI=1

if "%answer3%"=="s" ( goto :userWants64bit )

:userWants32bit
REM COMPILE 32bit FPC (crosscompiler optional)
echo 32bit FPC - all install
title 32bit FPC - all install
make --jobs=4 FPC=%OLDFPC32% %Env32bit% %compOpts% all install 1>LOG.txt 2>&1
if "%answer4%"=="y" (
REM COMPILE and install crosscompiler
echo crosscompiler - compiler
title crosscompiler - compiler
make --jobs=4 FPC=%NEWFPC% %Env32bitCross% %compOpts% compiler_cycle 1>>LOG.txt 2>&1
make --jobs=4 FPC=%NEWFPC% %Env32bitCross% %compOpts% compiler_install 1>>LOG.txt 2>&1
echo crosscompiler - rtl
title crosscompiler - rtl
make --jobs=4 FPC=%CROSS64% %Env32bitCross% %compOpts% rtl 1>>LOG.txt 2>&1
make --jobs=4 FPC=%CROSS64% %Env32bitCross% %compOpts% rtl_install 1>>LOG.txt 2>&1
echo crosscompiler - packages
title crosscompiler - packages
make --jobs=4 FPC=%CROSS64% %Env32bitCross% %compOpts% packages 1>>LOG.txt 2>&1
make --jobs=4 FPC=%CROSS64% %Env32bitCross% %compOpts% packages_install 1>>LOG.txt 2>&1
)
goto :extractSourceAndClean

:userWants64bit
REM COMPILE 64bit FPC (crosscompiler optional)
echo 64bit FPC - all install
title 64bit FPC - all install
make --jobs=4 FPC=%OLDFPC64% %Env64bit% %compOpts64bit% all install 1>LOG.txt 2>&1
if "%answer4%"=="y" (
REM COMPILE and install crosscompiler
echo crosscompiler - compiler
title crosscompiler - compiler
make --jobs=4 FPC=%NEWFPC% %Env64bitCross% %compOpts64bit% compiler_cycle 1>>LOG.txt 2>&1
make --jobs=4 FPC=%NEWFPC% %Env64bitCross% %compOpts64bit% compiler_install 1>>LOG.txt 2>&1
echo crosscompiler - rtl
title crosscompiler - rtl
make --jobs=4 FPC=%CROSS32% %Env64bitCross% %compOpts% rtl 1>>LOG.txt 2>&1
make --jobs=4 FPC=%CROSS32% %Env64bitCross% %compOpts% rtl_install 1>>LOG.txt 2>&1
echo crosscompiler - packages
title crosscompiler - packages
make --jobs=4 FPC=%CROSS32% %Env64bitCross% %compOpts% packages 1>>LOG.txt 2>&1
make --jobs=4 FPC=%CROSS32% %Env64bitCross% %compOpts% packages_install 1>>LOG.txt 2>&1
)

:extractSourceAndClean
rem remove bootstrap, remove "dirty" source, extract clean source
rem
rem maybe there is better method
rem "make distclean", "make clean" are slow
rem "svn revert -R .", "svn cleanup --remove-unversioned", "svn cleanup --remove-ignored" also slow
rem extracting again is much faster
echo cleaning
title cleaning
rmdir /s /q bootstrap 2>nul
rmdir /s /q fpcsrc 2>nul
echo creating clean source
title creating clean source
7za.exe x -bd -y fpcsrc.7z fpcsrc\rtl      -ofpc\3.2.0\  1>nul
7za.exe x -bd -y fpcsrc.7z fpcsrc\packages -ofpc\3.2.0\  1>nul
ren fpc\3.2.0\fpcsrc source 2>nul


REM COMPILE LAZARUS
:dolazarus
cd lazarus
set path=%FPCINSTALLPATH%\bin\%CPU_OS%\

"%FPCINSTALLPATH%\bin\%CPU_OS%\fpcmkcfg.exe" -d basepath=%FPCINSTALLPATH% -o "%FPCINSTALLPATH%\bin\%CPU_OS%\fpc.cfg"
echo --primary-config-path=%CD%\config>lazarus.cfg

echo // Created by Svn2RevisionInc>ide\revision.inc
echo const RevisionStr = '%LAZREVSTR%';>>ide\revision.inc

rem compile lazbuild, registration, lazutils, lcl, basecomponents and starter
echo Compiling Lazbuild
title Compiling Lazbuild
make FPC=%NEWFPC% --directory=. %fpcmakeppumove% INSTALL_PREFIX=. USESVN2REVISIONINC=0 %compOpts% lazbuild 1>>..\LOG.txt 2>&1

echo Compiling registration lazutils lcl basecomponents
title Compiling registration lazutils lcl basecomponents
make FPC=%NEWFPC% --directory=. %fpcmakeppumove% INSTALL_PREFIX=. USESVN2REVISIONINC=0 %compOpts% registration lazutils lcl basecomponents 1>>..\LOG.txt 2>&1

echo Compiling starter
title Compiling starter
make FPC=%NEWFPC% --directory=. %fpcmakeppumove% INSTALL_PREFIX=. USESVN2REVISIONINC=0 %compOpts% starter 1>>..\LOG.txt 2>&1

rem compile Lazarus
echo Compiling Lazarus
title Compiling Lazarus
lazbuild.exe --compiler=%NEWFPC% --add-package components\sqldb\sqldblaz.lpk 1>>..\LOG.txt 2>&1
lazbuild.exe --compiler=%NEWFPC% "--build-ide=-dKeepInstalledPackages -g- -Xs -O3 -CX -XX -OoREGVAR" 1>>..\LOG.txt 2>&1

REM COMPILATION SECTION END

echo.
echo.
echo Extracting GDB...
..\7za.exe x -bd -y ..\mingw.7z 1>nul
cd ..

REM compress log
7za.exe a LOG.7z -y -mm=lzma2 -mx=9 LOG.txt 1>nul
del /f /q LOG.txt 2>nul

echo.
echo.
title Finished
echo Open lazarus folder, launch lazarus.exe,
echo click "Upgrade", then launch IDE.
echo Hopefully everything went well...
echo Just in case, there should be log.7z file.

pause
pause
