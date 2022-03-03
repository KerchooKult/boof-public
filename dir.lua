-- local engine_client_interface = memory.create_interface("engine.dll", "VEngineClient014")
-- local get_net_channel_info = ffi.cast("void*(__thiscall*)(void*)",memory.get_vfunc(engine_client_interface,78))
-- local net_channel_info = get_net_channel_info(ffi.cast("void***",engine_client_interface))
-- local get_remote_frame = ffi.cast("void(__thiscall*)(void*,float*,float*,float*)",memory.get_vfunc(tonumber(ffi.cast("unsigned int",net_channel_info)),25))
-- -- local servercomm_names = {}
-- -- local server2v2_names = {}

-- local ref = {
--     screen_size = render.get_screen_size(),
--     master = menu.add_checkbox('picker', 'enable', false),
--     player = entity_list.get_local_player(),
--     items = {
--         selection = menu.add_selection('picker', 'type', { 'community', '2v2' }),
--         picker = menu.add_list('picker', 'servers', servercomm_names),
--     },
-- }

-- local menuItems = {
--     -- Welcome Text
--     text = menu.add_text("welcome", "Welcome to boof.gg, " .. user.name .. " [".. user.uid .."]"),
--     text2 = menu.add_text("welcome", "Thank you for using our scripts."),
--     text3 = menu.add_text("welcome","For support please contact us at d.gg/boof."),
--     -- Watermark
--     watermark_toggle = menu.add_checkbox("boof content", "watermark", false),
--     watermarkToxic = menu.add_checkbox("boof content", "toxic mode", false),
--     watermarkSelector = menu.add_multi_selection("boof watermark", "watermark options", {"name", "fps", "tick", "kills", "ping"}),
--     -- Clantag
--     clantag_toggle = menu.add_checkbox("boof content", "clantag", false),
--     -- KillSay
--     killSay = menu.add_checkbox("killsay", "killsay", false),
--     killSaySetting = menu.add_selection("killsay", "setting", {"boof.gg", "friendly", "anti-ruski","gay","among us"}),
--     -- Halo
--     haloToggle = menu.add_checkbox("meme", "halo announcer", false),
--     -- Logo Indicator
--     desyncIndicator = menu.add_checkbox("indicators (WIP)", "enable desync indicator", false),
-- }

local http_lib = require("Lightweight HTTP Library.lua")
local http = http_lib.new({
    task_interval = 0.3, -- polling intervals
    enable_debug = true, -- print http requests to the console
    timeout = 15 -- request expiration time
})

-- local modules = {
--   [1] = "",
--   [2] = ""
-- }

-- for i,v in ipairs(modules) do
--   http:get(modules[i],function(data)
--       local success = data.status == 200
--       if not success then
--         client.log('failed to module #' .. i)
--         return
--       end
--       loadstring(data.body)
--   end)
-- end
