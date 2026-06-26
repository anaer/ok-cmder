@echo off

if "%*" == "help" call :myHelp & exit /b
if "%*" == "" call :myHelp & exit /b

if "%1" == "-" (
    cd /d %OLDPATH%
    if not errorlevel 1 set OLDPATH="%cd%"
) else if "%1" == "~" (
    cd /d "%HOME%"
    if not errorlevel 1 set OLDPATH="%cd%"
) else if "%1" == "!" (
    cd /d "%CMDER_ROOT%"
    if not errorlevel 1 set OLDPATH="%cd%"
) else if "%1" == "@" (
    cd /d "%WORKSPACE%"
    if not errorlevel 1 set OLDPATH="%cd%"
) else (
    cd "%*"
    if not errorlevel 1 set OLDPATH="%cd%"
)

@REM 进入/离开目录时, 设置Python版本变量
call "%CMDER_ROOT%\config\user-config.bat"

exit /b

:myHelp
echo options:
echo    - last directory
echo    ~ home directory
echo    ! ok-cmder directory
echo    @ workspace directory
GOTO:EOF
