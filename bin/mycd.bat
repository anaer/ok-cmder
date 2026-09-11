@echo off

if "%*" == "help" goto myHelp
if "%*" == "" goto myHelp

@REM 首次使用时 OLDPATH 未定义, 以当前目录初始化
if not defined OLDPATH set "OLDPATH=%cd%"

@REM 先记录切换前的目录, 切换成功后再写入 OLDPATH, 使 cd - 能真正回跳
set "MYCD_CUR=%cd%"

if "%1" == "-" (set "MYCD_TARGET=%OLDPATH%" & goto doCd)
if "%1" == "~" (set "MYCD_TARGET=%HOME%" & goto doCd)
if "%1" == "!" (set "MYCD_TARGET=%CMDER_ROOT%" & goto doCd)
if "%1" == "@" (set "MYCD_TARGET=%WORKSPACE%" & goto doCd)
set "MYCD_TARGET=%*"

:doCd
@REM 去掉调用方可能自带的引号, 避免与下面的引号叠成双引号
for /f "delims=" %%D in ("%MYCD_TARGET%") do set "MYCD_TARGET=%%~D"
@REM /d 允许跨盘符切换
cd /d "%MYCD_TARGET%"
if errorlevel 1 goto afterCd
set "OLDPATH=%MYCD_CUR%"

:afterCd
set "MYCD_CUR="
set "MYCD_TARGET="

@REM 进入/离开目录时, 设置Python版本变量
call "%CMDER_ROOT%\config\user-config.bat"

exit /b

:myHelp
echo options:
echo    - last directory
echo    ~ home directory
echo    ! ok-cmder directory
echo    @ workspace directory
exit /b
