@echo off
set errorlevel=0
set CURRENT_PATH=%CD%
set CYGWIN_ORIG=
if defined CYGWIN (
  set CYGWIN_ORIG=%CYGWIN%
  set CYGWIN=%CYGWIN%,winsymlinks:native
) else (
  set CYGWIN=winsymlinks:native
)

set BATCH_PATH=%~dp0
cd /d "%BATCH_PATH%"
rem cd
.\setup-x86_64.exe %*
set BATCH_PATH=

echo errorlevel = %errorlevel%
set BATCH_PATH=
cd /d %CURRENT_PATH%
set CURRENT_PATH=
if defined CYGWIN_ORIG (
  set CYGWIN=%CYGWIN_ORIG%
  set CYGWIN_ORIG=
) else (
  set CYGWIN=
)


rem set args=%*
rem for %%a in (%args%) do (
rem   echo %%a
rem )
rem set CURRENT_PATH=%CD%
