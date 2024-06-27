# CHANGELOG

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
```
:: 设置starship配置文件路径
set "STARSHIP_CONFIG=%CMDER_ROOT%\config\starship.toml"
```
1.5 starship配置说明 可查看: https://starship.rs/zh-CN/presets/

## 20240617

1. 更新clink -> v1.6.16
2. 修改clink-completions, clink-flex-prompt为子模块引入
3. 将flexprompt_autoconfig.lua移到config目录下