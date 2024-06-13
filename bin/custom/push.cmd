@echo off
chcp 65001
rem 因github容易连不上, 所以间隔几秒循环执行, 一般10次以内都能成功 这里设置了100次, 如果需要永久循环 设置为(0,0,1)
echo git push
git rev-parse --is-inside-work-tree >nul 2>nul
if %errorlevel% equ 0 (
    for /l %%a in (1,1,100) do (echo %%a------------------- && git push && goto :EOF; sleep 3)
) else (
    echo 当前目录不是git仓库
)

:EOF
echo -------------------end