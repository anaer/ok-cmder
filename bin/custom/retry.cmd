@echo off
chcp 65001 >nul
powershell -ExecutionPolicy RemoteSigned -File "%~dpn0.ps1" %*
if %errorlevel% equ 0 (
    echo -------------------end
) else (
    echo Command failed after 100 attempts
)
