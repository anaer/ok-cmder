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
mci=chcp 65001 && mvnd clean install $*
mci-s=chcp 65001 && mvnd clean install -DskipTests $*
mvn-tree=mvnd dependency:tree $*
mvn-dep=mvnd dependency:analyze $*
mvn-u=mvnd dependency:resolve -U $*
;= 下载源码
mvn-ds=mvnd dependency:resolve -Dclassifier=sources $*
;= 下载文档
mvn-dd=mvnd dependency:resolve -Dclassifier=javadoc $*
;= 检查依赖版本更新
mvn-v=mvnd versions:display-dependency-updates -DallowSnapshots=false $*
mvn-v2=mvnd versions:display-dependency-updates -DallowSnapshots=false -DallowMajorUpdates=false $*
mvn-v3=mvnd versions:display-dependency-updates -DallowSnapshots=false -DallowMajorUpdates=false -DallowMinorUpdates=false $*