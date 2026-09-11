@echo off
setlocal enabledelayedexpansion

:: *****************************
:: Configure the User Environment for Cmder.exe
:: *****************************
set "cmder_path=%~dp0"
set "cmder_root=%cmder_path:~0,-1%"

set "REG_KEY=HKCU\Environment"
set "reg_type=REG_EXPAND_SZ"
set "user_path="
set "new_path="
set "path_changed=0"

@REM 只取含 REG_ 的行, 避开 reg query 输出的空行与 "End of search" 附加行
@REM tokens=2,* 让 %%B 取到含空格的完整值
@REM 旧写法 tokens=1-3 会在首个空格处截断 PATH, 回写时会损坏用户 PATH
for /f "usebackq tokens=2,* delims= " %%A in (`reg query "%REG_KEY%" /v Path 2^>nul ^| findstr /i /c:"REG_"`) do (
    set "reg_type=%%A"
    set "user_path=%%B"
)

@REM 去掉 %%B 可能残留的前导空格
if defined user_path for /f "tokens=* delims= " %%P in ("!user_path!") do set "user_path=%%P"

@REM 以实际路径精确判重, 不再依赖目录名是否为 ok-cmder
if defined user_path (
    if "!user_path:%cmder_root%=!"=="!user_path!" (
        set "new_path=!user_path!;%cmder_root%"
        set "path_changed=1"
    )
) else (
    set "new_path=%cmder_root%"
    set "path_changed=1"
)

if "!path_changed!"=="1" (
    call :strlen plen "!new_path!"
    if !plen! gtr 1800 (
        echo [WARN] PATH 长度为 !plen! 字符, 已接近 2048 上限, 继续写入可能被截断.
        echo [WARN] 已跳过本次 PATH 写入, 请手动清理用户 PATH 后重新运行.
    ) else (
        reg export "%REG_KEY%" "%TEMP%\cmder_path_backup.reg" /y >nul 2>&1
        reg add "%REG_KEY%" /f /t !reg_type! /v Path /d "!new_path!" >nul
        if errorlevel 1 (
            echo [ERROR] PATH 写入失败, 注册表备份见 %TEMP%\cmder_path_backup.reg
        ) else (
            echo [OK] PATH 已添加: %cmder_root%
            echo [OK] 原 PATH 已备份: %TEMP%\cmder_path_backup.reg
        )
    )
) else (
    echo [OK] PATH 已包含 %cmder_root%, 无需修改.
)

:: *****************************
:: Configure local git config
:: set /p tip="if need to configure git?[y/n]: "
:: set gitcmd=%~dp0vendor\cygwin\bin\git.exe
:: if "%tip%"=="N" set tip=n
:: if "%tip%"=="n" goto nogitconfig
:: :: if "%tip%"=="Y" set tip=y
:: :: if "%tip%"=="y" goto gitconfig
:: ::
:: :: :gitconfig
:: set option=null
:: set /p option="Please input user name: "
:: if not "%option%"=="null" (
:: 	%gitcmd% config --local user.name %option%
:: )
:: set /p option="Please input user email: "
:: if not "%option%"=="null" (
:: 	%gitcmd% config --local user.email %option%
:: )
::
:: %gitcmd% config --local alias.st status
:: %gitcmd% config --local alias.co checkout
:: %gitcmd% config --local alias.ci commit
:: %gitcmd% config --local alias.br branch
:: %gitcmd% config --local alias.df diff
::
:: echo "Success to configure git conig..."
:: :nogitconfig

:: *****************************
:: To install cygwin
set /p tip="if the first install, recommend to install cygwin?[y/n]: "
if "%tip%"=="N" set tip=n
if "%tip%"=="n" goto configend

set INSTALL_DIR=%~dp0src-install

:: Install cygwin command packages
:: %INSTALL_DIR%\setup-x86_64.exe -q -n -s https://mirrors.tuna.tsinghua.edu.cn/cygwin/ -R D:\ok-cmder\vendor\git-for-windows\cygwin

:: Install gcc compiler
%INSTALL_DIR%\setup-x86_64.exe -q -n -W -s https://mirrors.aliyun.com/cygwin/ --root %~dp0vendor\cygwin -l %INSTALL_DIR%\tmp -K https://mirrors.aliyun.com/cygwin/ ^
-P gcc-core -P gcc-g++ -P make -P gdb -P binutils ^
-P cmake ^
-P vim -P git ^
-P cscope -P ctags ^
-P python -P python3 ^
-P inetutils -P gawk ^
-P curl -P jq ^
-P patch

rd /s /q %INSTALL_DIR%\tmp

copy %cmder_root%\config\vimrc.orig %cmder_root%\vendor\cygwin\etc\vimrc
copy %cmder_root%\config\taglist_46\plugin\taglist.vim %cmder_root%\vendor\cygwin\usr\share\vim\vim91\plugin\taglist.vim
copy %cmder_root%\config\taglist_46\doc\taglist.txt %cmder_root%\vendor\cygwin\usr\share\vim\vim91\doc\taglist.txt

@REM 创建clink软链接, 已存在时跳过
if not exist "%cmder_root%\vendor\conemu-maximus5\ConEmu\clink" (
    mklink /D "%cmder_root%\vendor\conemu-maximus5\ConEmu\clink" "%cmder_root%\vendor\clink"
)

@REM 直接使用 vendor 下的 clink, 不再依赖 PATH 中是否已存在 clink 命令
set "CLINK_EXE=%cmder_root%\vendor\clink\clink_x64.exe"
if not exist "%CLINK_EXE%" set "CLINK_EXE=%cmder_root%\vendor\clink\clink_x86.exe"

@REM 设置fzf.exe程序路径
"%CLINK_EXE%" set fzf.exe_location %cmder_root%\bin\systools

"%CLINK_EXE%" installscripts %cmder_root%\vendor\clink-completions\
"%CLINK_EXE%" installscripts %cmder_root%\vendor\clink-flex-prompt\
"%CLINK_EXE%" installscripts %cmder_root%\vendor\clink-gizmos\
"%CLINK_EXE%" installscripts %cmder_root%\vendor\zoxide\

@REM clink set autosuggest.strategy fuzzy_history
@REM clink set fishcomplete.enable true

echo "Success to install..."

:configend
endlocal
pause
exit /b 0

:: *****************************
:: 计算字符串长度: call :strlen <结果变量> <字符串>
:: *****************************
:strlen
set "s=%~2"
set "n=0"
:strlen_loop
if not defined s goto strlen_done
set "s=!s:~1!"
set /a n+=1
goto strlen_loop
:strlen_done
set "%~1=%n%"
set "s="
set "n="
goto :eof
