@echo off
setlocal enabledelayedexpansion

:: 设置默认参数
set "SOURCE_BRANCH=%~1"
set "TARGET_BASE=%~2"
set "NEW_BRANCH=%~3"

if "%SOURCE_BRANCH%"=="" set "SOURCE_BRANCH=feature"
if "%TARGET_BASE%"=="" set "TARGET_BASE=master"
if "%NEW_BRANCH%"=="" set "NEW_BRANCH=feature1"

echo "🚀 Git智能变更提取器 (批处理版)"
echo "使用方法: gitc.bat [source_branch] [target_base] [new_branch]"
echo "================================"
echo.

:: 检查Git环境
echo "ℹ️  检查Git环境..."
git --version >nul 2>&1
if errorlevel 1 (
    echo "❌ Git未安装或不在PATH中"
    echo "请从 https://git-scm.com/download/win 下载安装Git"
    pause
    exit /b 1
)

:: 检查是否在Git仓库中
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo "❌ 当前目录不是Git仓库"
    pause
    exit /b 1
)

:: 检查分支是否存在
git show-ref --verify --quiet refs/heads/%SOURCE_BRANCH%
if errorlevel 1 (
    echo "❌ 源分支 %SOURCE_BRANCH% 不存在"
    echo "可用分支:"
    git branch
    pause
    exit /b 1
)

git show-ref --verify --quiet refs/heads/%TARGET_BASE%
if errorlevel 1 (
    echo "❌ 目标基础分支 %TARGET_BASE% 不存在"
    pause
    exit /b 1
)

echo "✅ 环境检查通过"

:: 检查工作区状态
git diff-index --quiet HEAD --
if errorlevel 1 (
    echo "⚠️  工作区有未提交的变更"
    set /p "STASH_CHOICE=是否要暂存这些变更? (y/n): "
    if /i "!STASH_CHOICE!"=="y" (
        git stash push -m "Auto stash before branch extraction"
        echo "✅ 变更已暂存"
    ) else (
        echo "❌ 请先处理工作区的变更"
        pause
        exit /b 1
    )
)

:: 分析变更
echo "ℹ️  分析变更复杂度..."

:: 获取提交数量
for /f %%i in ('git rev-list --count %TARGET_BASE%..%SOURCE_BRANCH%') do set "COMMIT_COUNT=%%i"

:: 获取变更文件数量
for /f %%i in ('git diff --name-only %TARGET_BASE%..%SOURCE_BRANCH% ^| find /c /v ""') do set "CHANGED_FILES=%%i"

echo "📊 变更统计:"
echo "  - 提交数量: %COMMIT_COUNT%"
echo "  - 变更文件: %CHANGED_FILES%"

:: 选择方法
set "METHOD=patch"
if %COMMIT_COUNT% gtr 1 set "METHOD=cherry-pick"
if %CHANGED_FILES% gtr 20 set "METHOD=merge"

echo "🎯 选择方法: %METHOD%"

:: 切换到目标基础分支
echo "ℹ️  切换到 %TARGET_BASE% 分支..."
git checkout %TARGET_BASE%

:: 尝试更新分支
git pull origin %TARGET_BASE% >nul 2>&1
if errorlevel 1 (
    echo "⚠️  无法从远程更新 %TARGET_BASE% 分支"
) else (
    echo "✅ 已更新 %TARGET_BASE% 分支"
)

git show-ref --verify --quiet refs/heads/%NEW_BRANCH%
if not errorlevel 1 (
    echo "⚠️  分支 %NEW_BRANCH% 已存在"
    set /p "DELETE_CHOICE=是否要删除现有分支? (y/n): "
    if /i "!DELETE_CHOICE!"=="y" (
        git branch -D %NEW_BRANCH%
        echo "✅ 已删除现有分支"
    ) else (
        echo "❌ 操作取消"
        pause
        exit /b 1
    )
)

echo "ℹ️  创建新分支 %NEW_BRANCH%..."
git checkout -b %NEW_BRANCH%
echo "✅ 创建新分支: %NEW_BRANCH%"

:: 根据方法执行操作
if "%METHOD%"=="patch" goto :patch_method
if "%METHOD%"=="cherry-pick" goto :cherry_pick_method
if "%METHOD%"=="merge" goto :merge_method

:patch_method
echo "ℹ️  使用补丁方法提取变更..."
set "PATCH_FILE=%TEMP%\git-changes-%RANDOM%.patch"
git diff %TARGET_BASE%..%SOURCE_BRANCH% > "%PATCH_FILE%"

git apply --check "%PATCH_FILE%" >nul 2>&1
if errorlevel 1 (
    echo "❌ 补丁应用检查失败，存在冲突"
    del "%PATCH_FILE%"
    pause
    exit /b 1
)

git apply "%PATCH_FILE%"

del "%PATCH_FILE%"
echo "✅ 补丁应用成功"
goto :finish

:cherry_pick_method
echo "ℹ️  使用Cherry-pick方法提取变更..."

:: 获取提交列表并逐个应用
for /f %%i in ('git rev-list --reverse %TARGET_BASE%..%SOURCE_BRANCH%') do (
    echo "应用提交: %%i"
    git cherry-pick %%i
    if errorlevel 1 (
        echo "❌ Cherry-pick失败，存在冲突"
        echo "请手动解决冲突后运行: git cherry-pick --continue"
        echo "或运行 git cherry-pick --abort 取消操作"
        pause
        exit /b 1
    )
)

echo "✅ 所有提交已成功cherry-pick"
goto :finish

:merge_method
echo "ℹ️  使用合并方法提取变更..."

git merge --no-commit --no-ff %SOURCE_BRANCH%
if errorlevel 1 (
    echo "❌ 合并失败，存在冲突"
    echo "请手动解决冲突后运行: git commit"
    echo "或运行 git merge --abort 取消合并"
    pause
    exit /b 1
)

echo "✅ 合并完成"
goto :finish

:finish
set /p "PUSH_CHOICE=是否要推送新分支到远程? (y/n): "
if /i "%PUSH_CHOICE%"=="y" (
    git push origin %NEW_BRANCH%
    if errorlevel 1 (
        echo "⚠️  推送失败"
    ) else (
        echo "✅ 新分支已推送到远程"
    )
)

pause