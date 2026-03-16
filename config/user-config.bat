@echo off

:: set GIT_FOR_WIN_ROOT=%CMDER_ROOT%\vendor\git_for_windows

if not exist "%HOME%\.vim" (
    cd /d "%HOME%"
    git clone https://github.com/VundleVim/Vundle.vim.git ./.vim/bundle/Vundle.vim
)

@REM 判断是否存在 .venv 文件夹，如果存在则激活Python虚拟环境
if exist ".venv" (
    call .venv\Scripts\activate.bat
)
