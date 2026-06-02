;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
e.=explorer .
gl=git log --oneline --all --graph --decorate  $*
ls=ls --show-control-chars -F --color $*
ll=ls --show-control-chars -F --color $*
pwd=cd
clear=cls
unalias=alias /d $1
vi=vim $*
cmder_home=cd /d "%CMDER_ROOT%"

cd=mycd.bat $*

open=explorer.exe $*
start=explorer.exe $*

pwsh=%SystemRoot%/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Bypass -NoLogo -NoProfile -NoExit -Command "Invoke-Expression '. ''%CMDER_ROOT%/vendor/profile.ps1'''"
awk=gawk $*
rg=ag
ad=alias /reload
vim=code

;= mvn 命令别名
mvn-h=alias|grep mvn
;= 编译安装
mci=chcp 65001 && mvnd clean install $*
;= 跳过测试
mci-s=chcp 65001 && mvnd clean install -DskipTests $*
;= 显示依赖树
mvn-tree=mvnd dependency:tree $*
;= 分析依赖，找出未使用的依赖和缺失的依赖
mvn-dep=mvnd dependency:analyze $*
;= 强制更新依赖
mvn-u=mvnd dependency:resolve -U $*
;= 下载源码
mvn-ds=mvnd dependency:resolve -Dclassifier=sources $*
;= 下载文档
mvn-dd=mvnd dependency:resolve -Dclassifier=javadoc $*
;= 检查依赖版本更新 禁用快照版本
mvn-v=mvnd versions:display-dependency-updates -DallowSnapshots=false $*
;= 检查依赖版本更新 禁用快照版本和大版本更新
mvn-v2=mvnd versions:display-dependency-updates -DallowSnapshots=false -DallowMajorUpdates=false $*
;= 检查依赖版本更新 禁用快照版本和大版本更新和小版本更新
mvn-v3=mvnd versions:display-dependency-updates -DallowSnapshots=false -DallowMajorUpdates=false -DallowMinorUpdates=false $*
;= 单元测试 执行时带上指定的Test类
mvn-t=mvnd test -Dsurefire.failIfNoSpecifiedTests=false -Dtest=$*