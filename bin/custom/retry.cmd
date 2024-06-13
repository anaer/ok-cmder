@echo off
chcp 65001
echo %*
for /l %%a in (1,1,100) do (echo %%a------------------- && %* && goto :EOF; sleep 3)

:EOF
echo -------------------end