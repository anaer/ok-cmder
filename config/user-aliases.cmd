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

;= 快捷导航 =================================================
..=cd /d ..
...=cd /d ..\..
....=cd /d ..\..\..
~=cd /d "%HOME%"
!=cd /d "%CMDER_ROOT%"
@=cd /d "%WORKSPACE%"

;= 网络工具 =================================================
;= 显示公网IP
myip=curl -s ifconfig.me
;= 显示局域网IP
lanip=ipconfig | findstr /i "IPv4"
;= 显示监听端口
ports=netstat -ano | findstr "LISTENING"
;= 快速测试Google DNS
ping8=ping -n 4 8.8.8.8
;= DNS查询
dns=nslookup $*
;= 路由追踪
trace=tracert $*
;= 下载文件
wget=curl -L -O $*

;= 文件操作 =================================================
;= 创建空文件
mkfile=type nul > $*
;= 显示文件内容
cat=type $*
;= 复制文件
cp=copy $*
;= 移动文件
mv=move $*
;= 删除文件
rm=del $*
;= 删除目录
rf=rd /s /q $*
;= 列出文件(不含目录)
lsf=dir /b /a-d $*
;= 列出目录
lsd=dir /b /ad $*

;= 系统监控 =================================================
;= 查找进程
ps=tasklist | findstr $*
;= 结束进程
kill=taskkill /f /im $*
;= 内存信息
mem=systeminfo | findstr /i "memory"
;= 磁盘空间
disk=wmic logicaldisk get size,freespace,caption
;= 系统启动时间
uptime=systeminfo | findstr /i "boot time"
;= 显示环境变量
env=set $*
;= 显示PATH
path=echo %PATH%

;= Git 增强别名 =================================================
;= Git状态
gst=git status $*
;= Git切换分支
gco=git checkout $*
;= Git分支列表
gbr=git branch $*
;= Git提交
gcmt=git commit -m $*
;= Git添加
gadd=git add $*
;= Git差异
gdf=git diff $*
;= Git暂存
gsh=git stash $*
;= Git恢复暂存
gshp=git stash pop $*
;= Git拉取
gpl=git pull $*
;= Git推送
gps=git push $*
;= 图形化日志
glg=git log --oneline --graph --decorate -20
;= 清理未跟踪文件
gclean=git clean -fd $*

;= 压缩解压 =================================================
;= 解压tar
tarx=tar -xf $*
;= 压缩tar.gz
tarc=tar -czf $*
;= 7-Zip压缩
7z=bin\systools\7z.exe $*
;= 解压zip
unzip=busybox unzip $*

;= 文本处理 =================================================
;= JSON格式化
json=python -m json.tool $*
;= 统计行数单词
wc=busybox wc $*
;= 排序
sort=busybox sort $*
;= 去重
uniq=busybox uniq $*
;= 文件比较
diff=busybox diff $*
;= 文本搜索
grep=busybox grep $*
;= 流编辑器
sed=busybox sed $*
;= 输出到文件和屏幕
tee=busybox tee $*

;= 开发工具 =================================================
;= 显示目录树
tree=tree /f $*
;= JSON美化
json_pp=python -m json.tool
;= Base64编解码
base64=busybox base64 $*
;= MD5校验
md5=busybox md5sum $*
;= SHA256校验
sha256=busybox sha256sum $*

;= Powershell别名 =================================================
pwsh=%SystemRoot%/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy RemoteSigned -NoLogo -NoProfile -NoExit -Command ". '%CMDER_ROOT%/vendor/profile.ps1'"

;= 展示当前目录下最大的10个目录 按大小降序
dsizes=%SystemRoot%/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy RemoteSigned -NoLogo -NoProfile -NoExit -Command ". '%CMDER_ROOT%/bin/custom/dir-sizes.ps1'"

;= 清理当前目录下的所有空目录
emptydir=powershell -Command "Get-ChildItem -Directory -Recurse | Where-Object { (Get-ChildItem $_.FullName -Force).Count -eq 0 } | Sort-Object FullName -Descending | Remove-Item -Force"

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
vi="%CMDER_ROOT%\vendor\cygwin\bin\vim.exe" $*
vim="%CMDER_ROOT%\vendor\cygwin\bin\vim.exe" $*
code="%CMDER_ROOT%\vendor\cygwin\bin\vim.exe" $*

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
mvn-ds=mvnd dependency:resolve -Dclassifier=sources
;= 检查依赖版本更新 禁用快照版本和大版本更新
mvn-v=mvnd versions:display-dependency-updates -DallowSnapshots=false -DallowMajorUpdates=false $*
;= 检查依赖版本更新 禁用快照版本和大版本更新和小版本更新
mvn-v3=mvnd versions:display-dependency-updates -DallowSnapshots=false -DallowMajorUpdates=false -DallowMinorUpdates=false $*
;= 单元测试 执行时带上指定的Test类
mvn-t=mvnd test -Dsurefire.failIfNoSpecifiedTests=false -Dtest=$*