@echo off

:: set GIT_FOR_WIN_ROOT=%CMDER_ROOT%\vendor\git_for_windows

::
cd /d "%HOME%"
if not exist "%HOME%\.vim" (
    git clone https://github.com/VundleVim/Vundle.vim.git ./.vim/bundle/Vundle.vim
)
