@echo off
REM Usage: remove_submodule.bat libs\library

SET SUBMODULE_PATH=%1
IF "%SUBMODULE_PATH%"=="" (
    echo 请提供子模块路径，例如: remove_submodule.bat libs\library
    exit /b 1
)

echo 开始删除子模块: %SUBMODULE_PATH%

REM 1. 从索引移除子模块
git rm --cached %SUBMODULE_PATH% -r

REM 2. 删除 .gitmodules 中的条目
git config -f .gitmodules --remove-section submodule.%SUBMODULE_PATH% 2>nul

REM 3. 删除 .git/config 中的子模块配置
git config -f .git/config --remove-section submodule.%SUBMODULE_PATH% 2>nul

REM 4. 删除 .git\modules 下的元数据
rmdir /s /q .git\modules\%SUBMODULE_PATH%

REM 5. 提交更改
git add .gitmodules
git commit -m "Remove submodule %SUBMODULE_PATH% completely"

echo 子模块 %SUBMODULE_PATH% 已彻底删除
