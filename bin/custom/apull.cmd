@echo off
chcp 65001 >nul
echo 正在检查本地变更...
git update-index -q --refresh
:: 判断是否有未暂存/未提交的修改
git diff --quiet HEAD -- 2>nul
if %errorlevel% equ 0 (
    echo █ 没有本地修改，直接拉取更新...
) else (
    echo █ 检测到未保存的修改，正在临时存储...
    git stash push -m "AutoStash_%DATE%_%TIME%" --quiet
    echo █ 已暂存本地修改： && git stash list | findstr "AutoStash"
)
:: 执行拉取操作
echo █ 正在从远程仓库拉取更新...
git pull
:: 如果有暂存则恢复
if %errorlevel% equ 0 if exist .git/refs/stash (
    echo █ 正在恢复暂存的修改...
    git stash pop --index --quiet
    echo 本地修改已恢复 ^!
)
echo █ 操作完成 ^!
