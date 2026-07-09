@echo off
chcp 65001
rem commit local changes: pull first, then add+commit
echo git commit

git rev-parse --is-inside-work-tree >nul 2>nul
if %errorlevel% neq 0 (
    echo Not a git repository
    goto :end
)

rem ignore file mode changes
git config core.fileMode false

rem check if there are local changes
set "has_changes=0"
git diff --quiet || set "has_changes=1"
git diff --cached --quiet || set "has_changes=1"
if "%has_changes%"=="0" (
    echo No local changes to commit
    goto :end
)

echo.
echo Changed files:
git status --short

rem pull remote changes first
echo.
echo [1/4] Pulling remote changes...
for /l %%a in (1,1,100) do (
    git pull --no-rebase
    if not errorlevel 1 (
        echo Pull success
        goto :pull_done
    )
    echo Retry %%a... waiting 3s
    %SystemRoot%\System32\timeout.exe /t 3 /nobreak >nul
)
echo Pull failed after 100 retries
goto :end

:pull_done
rem check if already staged, otherwise stage all changes
echo.
echo [2/4] Checking staged changes...
git diff --cached --quiet
if %errorlevel% neq 0 (
    echo Already have staged changes
) else (
    echo No staged changes, staging all...
    git add .
    if %errorlevel% neq 0 (
        echo Staging failed
        goto :end
    )
)

rem commit changes
echo.
echo [3/4] Committing...
set "commit_msg=%*"
if "%commit_msg%"=="" (
    git commit -m "update"
) else (
    git commit -m "%commit_msg%"
)
if %errorlevel% neq 0 (
    echo Commit failed
    goto :end
)

echo.
echo Commit success

rem push only if no local changes remain
set "has_changes=0"
git diff --quiet || set "has_changes=1"
git diff --cached --quiet || set "has_changes=1"
if "%has_changes%"=="1" goto :skip_push

rem push changes
echo.
echo [4/4] Pushing...
git push
if %errorlevel% neq 0 (
    echo Push failed
    goto :end
)

echo.
echo Push success
goto :end

:skip_push
echo.
echo Local changes remain, skipping push

:end
echo -------------------------end