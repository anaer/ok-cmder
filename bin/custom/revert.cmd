@echo off
chcp 65001
rem revert last commit: undo the last commit while keeping changes staged
echo git revert last commit

git rev-parse --is-inside-work-tree >nul 2>nul
if %errorlevel% neq 0 (
    echo Not a git repository
    goto :end
)

rem check if there are any commits
git log --oneline -1 >nul 2>nul
if %errorlevel% neq 0 (
    echo No commits to revert
    goto :end
)

rem show the commit to be reverted
echo.
echo Last commit:
git log --oneline -1

rem ask for confirmation
echo.
set /p "confirm=Revert this commit? (y/n): "
if /i not "%confirm%"=="y" (
    echo Revert cancelled
    goto :end
)

rem revert last commit (soft reset - keeps changes staged)
echo.
echo Reverting last commit...
git reset --soft HEAD~1
if %errorlevel% neq 0 (
    echo Revert failed
    goto :end
)

echo.
echo Revert success
echo Changes from the reverted commit are now staged

:end
echo -------------------------end