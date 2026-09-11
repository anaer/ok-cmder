@echo off
setlocal enabledelayedexpansion

:: *****************************
:: ok-cmder 别名自检
:: 检查 config\user-aliases.cmd 中:
::   1. 指向不存在文件的别名
::   2. 覆盖 cmd 内部命令的别名(如 start / path)
:: *****************************

:: 本脚本位于 bin\custom, 上两级才是 cmder 根目录
if not defined CMDER_ROOT set "CMDER_ROOT=%~dp0..\.."
for %%I in ("%CMDER_ROOT%\.") do set "CMDER_ROOT=%%~fI"

set "ALIAS_FILE=%CMDER_ROOT%\config\user-aliases.cmd"
if not exist "%ALIAS_FILE%" (
    echo [ERROR] 未找到别名文件: %ALIAS_FILE%
    exit /b 1
)

:: cmd 内部命令清单
set "INTERNALS=assoc break call cd chcp cls color copy date del dir echo endlocal erase exit for ftype goto if keys md mkdir move path pause popd prompt pushd rd rem ren rename rmdir set setlocal shift start time title type ver verify vol"
:: 已知有意为之的覆盖, 不重复告警
set "WHITELIST=cd"

set "n_total=0"
set "n_shadow=0"
set "n_missing=0"

echo.
echo ==== ok-cmder 别名自检 ====
echo 别名文件: %ALIAS_FILE%
echo.

:: eol=; 会自动跳过 ";= " 开头的注释行; tokens=1,* 保证值中的等号不被切开
for /f "usebackq tokens=1,* delims==" %%A in ("%ALIAS_FILE%") do (
    set "aname=%%A"
    set "acmd=%%B"
    set "aprog="
    if defined acmd (
        set /a n_total+=1
        for /f "tokens=1 delims= " %%P in ("%%B") do if not defined aprog set "aprog=%%P"
    )
    if defined aprog (
        set "aprog=!aprog:%%CMDER_ROOT%%=%CMDER_ROOT%!"
        set "aprog=!aprog:%%SystemRoot%%=%SystemRoot%!"
        set "aprog=!aprog:%%USERPROFILE%%=%USERPROFILE%!"
        set "aprog=!aprog:"=!"
    )
    if defined aprog (
        set "hit=0"
        for %%K in (!INTERNALS!) do if /i "!aname!"=="%%~K" set "hit=1"
        set "allow=0"
        for %%W in (!WHITELIST!) do if /i "!aname!"=="%%~W" set "allow=1"
        if "!hit!"=="1" if "!allow!"=="0" (
            set /a n_shadow+=1
            echo [覆盖内部命令] !aname! = !acmd!
        )
        set "tail=!aprog:~-4!"
        if /i "!tail!"==".exe" call :checkExist
        if /i "!tail!"==".bat" call :checkExist
        if /i "!tail!"==".cmd" call :checkExist
    )
)

echo.
echo ---- 汇总 ----
echo 别名总数    : %n_total%
echo 覆盖内部命令: %n_shadow%
echo 目标文件缺失: %n_missing%
if "%n_missing%"=="0" if "%n_shadow%"=="0" (
    echo 结果: 未发现问题.
) else (
    echo 结果: 存在待处理项, 请按上面提示修正 config\user-aliases.cmd
)
echo.
exit /b 0

:checkExist
set "chk=!aprog!"
if not exist "!chk!" if exist "%CMDER_ROOT%\!chk!" set "chk=%CMDER_ROOT%\!chk!"
if not exist "!chk!" if exist "%CMDER_ROOT%\bin\!chk!" set "chk=%CMDER_ROOT%\bin\!chk!"
if exist "!chk!" goto :eof
:: 再按 PATH 解析, 例如 bin 下的 mycd.bat 或 System32 下的 explorer.exe
for %%Q in ("!aprog!") do set "chk=%%~$PATH:Q"
if defined chk if exist "!chk!" goto :eof
set /a n_missing+=1
echo [目标缺失] !aname! = !acmd!
echo             未找到: !aprog!
goto :eof
