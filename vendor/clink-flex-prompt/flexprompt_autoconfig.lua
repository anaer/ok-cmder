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
flexprompt.settings.heads = "flat"
flexprompt.settings.left_frame = "none"
flexprompt.settings.left_prompt = "{battery:breakright}{histlabel}{cwd}{git}{exit}{duration}{time:dim:format=%a %H:%M}"
flexprompt.settings.lines = "two"
flexprompt.settings.nerdfonts_version = 3
flexprompt.settings.nerdfonts_width = 2
flexprompt.settings.right_frame = "none"
flexprompt.settings.separators = "vertical"
flexprompt.settings.spacing = "sparse"
flexprompt.settings.style = "rainbow"
flexprompt.settings.symbols =
{
    prompt = "❯",
}
flexprompt.settings.tails = "flat"