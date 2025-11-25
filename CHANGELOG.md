# CHANGELOG

## 25.1125.1032

1. 添加dl.cmd github加速下载脚本
   用法 `dl.cmd https://github.com/CJSen/lsx/releases/download/v1.1.0/lsx_windows_amd64.exe.zip`

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
