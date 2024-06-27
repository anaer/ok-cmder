-- WARNING:  This file gets overwritten by the 'flexprompt configure' wizard!
--
-- If you want to make changes, consider copying the file to
-- 'flexprompt_config.lua' and editing that file instead.

flexprompt = flexprompt or {}
flexprompt.settings = flexprompt.settings or {}
flexprompt.settings.charset = "unicode"
flexprompt.settings.connection = "disconnected"
flexprompt.settings.flow = "concise"
flexprompt.settings.frame_color =
{
    "brightblack",
    "brightblack",
    "darkwhite",
    "darkblack",
}

-- 头尾形状 round: 圆形
flexprompt.settings.heads = "round"
flexprompt.settings.tails = "round"

flexprompt.settings.left_frame = "none"
flexprompt.settings.lines = "two"
flexprompt.settings.nerdfonts_version = 3
flexprompt.settings.nerdfonts_width = 2
flexprompt.settings.right_frame = "none"

-- 左侧提示栏
flexprompt.settings.left_prompt = "{histlabel}{cwd}{git}{exit}{duration}{time:dim:format=%a %H:%M}"
-- 右侧提示栏
flexprompt.settings.right_prompt = ""

-- 分隔符形状 pointed: >
flexprompt.settings.separators = "pointed"
flexprompt.settings.spacing = "sparse"
flexprompt.settings.style = "rainbow"

flexprompt.settings.git_fetch_interval = 15
flexprompt.settings.duration_threshold = 1

-- 判断是否管理员
local _,_,ret = os.execute("net session 1>nul 2>nul")
local isAdmin = ret == 0

-- 管理员: λ, 普通用户: ❯
flexprompt.settings.symbols.prompt = isAdmin and "λ" or "❯"