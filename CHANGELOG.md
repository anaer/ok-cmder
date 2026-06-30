# CHANGELOG

## 26.0630.1000

1. 安全修复：PowerShell ExecutionPolicy Bypass → RemoteSigned
   - `config/user-ConEmu.xml:530,539` 改用 RemoteSigned，移除 Invoke-Expression 反模式

2. 安全修复：Cygwin 安装添加 GPG 签名验证
   - `Install.bat:73` 添加 `-K` 参数验证镜像包签名

3. 安全修复：PATH 操作添加路径存在性检查
   - `vendor/lib/lib_path.cmd` enhance_path 和 enhance_path_recursive 函数

4. 安全修复：io.popen() 命令注入防护
   - `vendor/clink.lua` 所有 io.popen 调用改用环境变量或完整路径

5. 安全修复：profile.d 脚本自动执行验证
   - `vendor/profile.ps1` 跳过 `_` 前缀文件（约定为不自动执行）

6. 修复：for 循环内 goto :EOF 异常跳转
   - `bin/custom/push.cmd` 和 `bin/custom/pull.cmd` 改用标签跳转

7. 改进：别名输入验证
   - `bin/alias.bat` 添加别名名称正则验证（仅允许字母数字、下划线、连字符）

8. 改进：PATH 清理
   - `config/user-profile.cmd` 移除 `.` 和硬编码路径

9. 改进：编辑器别名相对路径
   - `config/user-aliases.cmd` vi/vim/code 改用 `%CMDER_ROOT%` 相对路径

10. 改进：ExecutionPolicy 安全化
    - `config/user-aliases.cmd` pwsh/dsizes 别名改用 RemoteSigned

11. 改进：io.popen nil 保护
    - `vendor/clink.lua` 和 `vendor/zoxide/zoxide.lua` 所有 io.popen 调用加 nil guard

12. 修复：$gitLoaded 变量作用域
    - `vendor/profile.ps1` 改用 $script:gitLoaded

13. 改进：全局变量本地化
    - `vendor/zoxide/zoxide.lua` 和 `vendor/clink.lua` 全局变量加 local

14. 清理：移除注释死代码
    - `vendor/init.bat` 移除约 90 行已注释的 git 检测代码

15. 改进：临时文件处理
    - `Install.bat` 临时文件写入 %TEMP% 目录

16. 修复：timeout 命令被 Cygwin 拦截
    - `bin/custom/push.cmd` 和 `bin/custom/pull.cmd` 使用完整路径 `%SystemRoot%\System32\timeout.exe`

## 25.1125.1032

1. 添加dl.cmd github加速下载脚本
   用法 `dl.cmd https://github.com/CJSen/lsx/releases/download/v1.1.0/lsx_windows_amd64.exe.zip`

2. 添加systools\lsx.exe 查询命令用法

## 25.1013.948

1. 更新clink->1.8.6
2. 删除z.lua子模块, 已经使用同类型的zoxide

## 25.306.1038

1. 更新clink->1.7.11
2. 添加apull.cmd脚本

## 25.110.1344

1. 添加z.lua子模块
  配置时需要在user-profile.cmd中配置环境变量添加lua.exe程序路径和z.lua路径

## 20240627

1. 停用starship, 恢复使用flex-prompt

## 20240618

1. 添加starship
1.1 添加程序文件: bin\systools\starship.exe
1.2 clink.lua添加配置
```lua
-- 启用starship
load(io.popen('starship init cmd'):read("*a"))()
```
1.3 添加starship配置文件: config\starship.toml
1.4 user-profile.cmd添加环境变量配置

```conf
:: 设置starship配置文件路径
set "STARSHIP_CONFIG=%CMDER_ROOT%\config\starship.toml"
```
1.5 starship配置说明 可查看: https://starship.rs/zh-CN/presets/

## 20240617

1. 更新clink -> v1.6.16
2. 修改clink-completions, clink-flex-prompt为子模块引入
3. 将flexprompt_autoconfig.lua移到config目录下
