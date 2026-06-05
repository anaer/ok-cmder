;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here



ls=ls --show-control-chars -F --color $*
ll=ls --show-control-chars -F --color $*

clear=cls


awk=gawk $*
rg=ag

;= Powershell别名 =================================================
pwsh=%SystemRoot%/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Bypass -NoLogo -NoProfile -NoExit -Command "Invoke-Expression '. ''%CMDER_ROOT%/vendor/profile.ps1'''"

;= 展示当前目录下最大的10个目录 按大小降序
dsizes=%SystemRoot%/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Bypass -NoLogo -NoProfile -NoExit -Command "Invoke-Expression '. ''%CMDER_ROOT%/bin/custom/dir-sizes.ps1'''"

;= Git 命令别名 =================================================
;= Git 默认使用 less 作为分页器，可能卡住报错, 需要禁用分页器 添加参数--no-pager 或者修改配置 git config --global core.pager ""
;= 查看最近10日志修改日志, 支持传参指定文件
gl=git log -10 --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all $*
;= 查看文件变更
gp=git status --porcelain

;= 别名管理 =================================================
;= 重新加载别名
ad=alias /reload
;= 取消别名
unalias=alias /d $1

;= 目录管理 =================================================
;= cd显示Windows格式的当前路径
pwd=cd
;= 切换到CMDER_ROOT目录
cdh=cd /d "%CMDER_ROOT%"
cd=mycd.bat $*

;= 文件管理器 =================================================
;= 打开当前目录
e.=explorer .
open=explorer.exe $*
start=explorer.exe $*

;= 编辑器 =================================================
vi="D:\Microsoft VS Code Insiders\Code - Insiders.exe" $*
vim="D:\Microsoft VS Code Insiders\Code - Insiders.exe" $*
code="D:\Microsoft VS Code Insiders\Code - Insiders.exe" $*

;= mvn 命令别名 =================================================
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
;= 下载文档源码
mvn-dd=mvnd dependency:resolve -Dclassifier=javadoc && mvnd dependency:resolve -Dclassifier=sources
;= 检查依赖版本更新 禁用快照版本和大版本更新
mvn-v=mvnd versions:display-dependency-updates -DallowSnapshots=false -DallowMajorUpdates=false $*
;= 检查依赖版本更新 禁用快照版本和大版本更新和小版本更新
mvn-v3=mvnd versions:display-dependency-updates -DallowSnapshots=false -DallowMajorUpdates=false -DallowMinorUpdates=false $*
;= 单元测试 执行时带上指定的Test类
mvn-t=mvnd test -Dsurefire.failIfNoSpecifiedTests=false -Dtest=$*