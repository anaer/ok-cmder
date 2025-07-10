@echo off

:: set GIT_FOR_WIN_ROOT=%CMDER_ROOT%\vendor\git_for_windows

if not exist "%HOME%\.vim" (
    cd /d "%HOME%"
    git clone https://github.com/VundleVim/Vundle.vim.git ./.vim/bundle/Vundle.vim
)
