client.log('boof.gg has cloud-loaded')

local servers_community = {
    ['Heretic | East'] = '74.91.125.35:27015',
    ['Heretic | West'] = '64.94.101.122:27015',
    ['Big Steppa | DM'] = '74.91.124.24:27015',
    ['No Hyper | Scout'] = '192.223.24.31:27015',
    ['No Hyper | AWP'] = '74.91.123.177:27015',
    ['Noble | Mirage Only'] = '135.148.136.239:27015',
    ['Luckys'] = '192.223.26.36:27015',
    ['Doc HVH'] = '74.91.124.40:27015',
    ['Rampage HVH'] = '104.192.227.26:27022',
    ['Profits'] = '135.148.53.7:27015',
    ['Jinx HVH'] = '162.248.93.4:27015',
    ['Cobras HVH'] = '107.175.92.50:27015',
}

local servers_2v2 = {
    ['Solar | 2v2'] = '135.148.53.7:27030; password solar',
    ['Profits | 2v2'] = '135.148.53.7:27018; password profits2v2',
    ['Ace | 2v2'] = '135.148.53.7:27019; password ace2v2',
    ['Arctic | 2v2'] = '135.148.53.7:27017; password arctic2v2',
    ['OG | 2v2'] = 'og2v2.game.nfoservers.com; password OG2v2',
    ['Profits | 5v5'] = '135.148.53.7:27016; password profits5v5',
    ['Gamesense'] = '135.148.53.7:27031; password gamesense',
    ['Gamesense #2'] = '135.148.53.7:27032; password gamesense',
    ['Profits 2v2 | Central'] = 'profits2v2.game.nfoservers.com:27015; password profits2v2',
    ['blackpeople2v2'] = 'csgo.blackpeople.wtf; password blackpeople2v2',
}

local engine_client_interface = memory.create_interface("engine.dll", "VEngineClient014")
local get_net_channel_info = ffi.cast("void*(__thiscall*)(void*)",memory.get_vfunc(engine_client_interface,78))
local net_channel_info = get_net_channel_info(ffi.cast("void***",engine_client_interface))
local get_remote_frame = ffi.cast("void(__thiscall*)(void*,float*,float*,float*)",memory.get_vfunc(tonumber(ffi.cast("unsigned int",net_channel_info)),25))


local servercomm_names = {}

local server2v2_names = {}

local ref = {
    screen_size = render.get_screen_size(),
    master = menu.add_checkbox('picker', 'enable', false),
    player = entity_list.get_local_player(),
    fakelag_amount = menu.find("antiaim", "main", "fakelag", "amount"),
    x = (render.get_screen_size().x / 2),
    y = (render.get_screen_size().y / 2),
    items = {
        selection = menu.add_selection('picker', 'type', { 'community', '2v2' }),
        picker = menu.add_list('picker', 'servers', servercomm_names),
    },
}


local function on_button()
    local selection = ref.items.selection:get()

    local name = ref.items.picker:get_item_name(ref.items.picker:get())
    connect(name, selection == 1 and servers_community[name] or servers_2v2[name])
end

local button = menu.add_button('picker', 'connect', on_button)

local menu = {
    -- Welcome Text
    text = menu.add_text("welcome", "Welcome to boof.gg, " .. user.name .. " [".. user.uid .."]"),
    text2 = menu.add_text("welcome", "Thank you for using our scripts."),
    text3 = menu.add_text("welcome","For support please contact us at gg/boof."),
    -- Watermark
    watermark_toggle = menu.add_checkbox("boof content", "watermark", false),
    watermarkSelector = menu.add_multi_selection("boof content", "watermark options", {"name", "fps", "tick", "kills", "ping"}),
    watermarkToxic = menu.add_checkbox("boof content", "toxic mode", false),
    -- Clantag
    clantag_toggle = menu.add_checkbox("boof content", "clantag", false),
    -- KillSay
    killSay = menu.add_checkbox("killsay", "killsay", false),
    killSaySetting = menu.add_selection("killsay", "setting", {"boof.gg", "friendly", "anti-ruski","gay","among us"}),
    -- Indics
    font_select = menu.add_selection("font", "fonts", {"Arial", "Verdana", "Comic sans", "Pixel", "Tahoma"}),
    font_weight = menu.add_selection("font", "weights", {"500", "600", "650", "700", "750"}),
    health_armorToggle = menu.add_checkbox("visuals", "health/armor bars"),
    fake_lag_circle = menu.add_checkbox("visuals", "fake lag circle"),
    net_graph = menu.add_checkbox("visuals", "net graph"),
    fire_indicator = menu.add_checkbox("visuals", "can fire indicator"),
    fL_indicator = menu.add_checkbox("visuals", "fakelag indicator"),
    fake_indicator = menu.add_checkbox("visuals", "desync indicator"),
    charge_indicator = menu.add_checkbox("visuals", "charge indicator"),
    chat_logs = menu.add_checkbox("chat", "chat indicators"),
    
    -- Halo
    haloToggle = menu.add_checkbox("meme", "halo announcer", false),
    -- Logo Indicator
    desyncIndicator = menu.add_checkbox("indicators (WIP)", "enable desync indicator", false),
}

local vars = {
    stored_cur_time = -1, -- watermark timer
    stored_cur_time2 = -1, -- clantag timer
    killCount = 0, -- session killcount
    indicator_font = render.create_font( "Tahoma", 60, 700, e_font_flags.OUTLINE, e_font_flags.ANTIALIAS),
    indicator_font2 = render.create_font( "Tahoma", 60, 700, e_font_flags.ANTIALIAS),
    degrees_font = render.create_font("Verdana", 30, 700, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE),
    flags_font = render.create_font("Verdana", 35, 700, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE),
    boofMode = {"hh is my dog, now bark for me","Homo is by choice, that is why they are vile and guilty","hdf dog","is your monitor on?","lmao get fucked hh","retard","who r u hh","no mutuals hh","how much did you pay for that hh lmao","enter the seated position, hh","hh pov:","obv u never touched a woman lmao","boofd on","prim moment","just hit a clip on hh","pov not using prim","first I do skeet now i do yous girlfren","Pushin p ? , no you get headshot.","i kill skeet, now i kill u.","say hi to allah for me hh"},
    friendlyMode = {"great game hh! :)","hey man it was good playing with you!!","with love <3 from "..user.name,"hey man! nice cheat :)","hh awesome config. good playing with you :D","epic fight hh! had fun","good try!","almost there hh...","you did great today!","hh... YOU ARE VALUED! :)","Thank you for the wonderful fight!","We should play again sometime :D","Friend request sent! :)","You are an amazing HVHer hh :D"},
    russianMode = {"козёл lit", "дура","дурак", "курва", "шлюха", "отвянь!", "пиздуй отсюда", "на три буквы"},
    gayMode = {"hh was fucked roughly by large bbc","hh gay","hh kinda hot tho",user.name.." matched with hh","god ur hot","suck my dick zaddy","ugly ass","call me later bb hh :)","hh go back to gay porn"},
    amongUsMode = {"when hh is SUS :o","hh was voted off the ship...",user.name.." ejected the impostor (hh)","sus hh","hh faked his tasks!!","red sus","hh vented","hh was killed by the impostor (sus)","hh amog us"},
    canFireText = "no",
    canFireColor = {0,0,0,155},
    main_font = render.create_font("Arial", 20, 600, e_font_flags.ANTIALIAS, e_font_flags.ITALIC, e_font_flags.DROPSHADOW),
    main_size = 700,
    color = menu.net_graph:add_color_picker("text color"),
    fonts = {
        avaliable_fonts = {
            "Arial",
            "Verdana",
            "Comic Sans",
            "Small Fonts",
            "Tahoma",
        },
        font_ptr = {},
    },
    sizes = {
        avaliable_sizes = {
            500,
            600,
            650,
            700,
            750,
        },
        sizes_ptr = {},
    },
}

-- Watermark
local motds = {"kys hh lmao","sit down and get some mutuals","hh is a boofer","doxxing you","1 lmao","wtf.","its boof or nothing","discord.gg/boof","die","ping spoofing","die","planets gay","now with shit mode!!","go back to minecraft","uninstall","alt+f4","shitter","discord.gg/boof","futurama stan","bruh","go to BEEEDDDDD","WOMBO COMBO","you're a rat."}
local motdNumber = client.random_int(1, #motds)
function on_draw_watermark()
    if(menu.watermarkToxic:get()) then
        menu.watermarkSelector:set_visible(false)
    else
        menu.watermarkSelector:set_visible(true)
    end

    local fps = client.get_fps()
    local tickrate = client.get_tickrate()
    local latency = math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 800 + 0.5) or 0

    if (menu.watermark_toggle:get() == true) then
        if global_vars.cur_time() - vars.stored_cur_time > 3 then
            -- run ur code
            motdNumber = client.random_int(1, #motds)
            vars.stored_cur_time = global_vars.cur_time()
        end

        local s = "broken code lmao"
        if(menu.watermarkToxic:get() == true) then
            text = " boof.gg" .. " | " .. motds[motdNumber]
            s = string.gsub(text, "hh", user.name)
            return s
        else
            s = "boof.gg" .. "aabbccddee"

            if(menu.watermarkSelector:get("name")) then
                s = string.gsub(s,"aa"," | " ..user.name.." ["..user.uid.."]")
            else
                s = string.gsub(s,"aa","")
            end

            if(menu.watermarkSelector:get("fps")) then
                s = string.gsub(s,"bb"," | "..fps.." fps")
            else
                s = string.gsub(s,"bb","")
            end

            if(menu.watermarkSelector:get("tick")) then
                s = string.gsub(s,"cc"," | "..tickrate.." tick")
            else
                s = string.gsub(s,"cc","")
            end
    
            if(menu.watermarkSelector:get("kills")) then
                s = string.gsub(s,"dd"," | "..vars.killCount.." kills")
            else
                s = string.gsub(s,"dd","")
            end

            if(menu.watermarkSelector:get("ping")) then
                s = string.gsub(s,"ee"," | "..latency.." ms")
            else
                s = string.gsub(s,"ee","")
            end

            return s
        end
    end
end

-- Indicators
-- local hideShots = menu.find("aimbot","general","exploits","hideshots")
-- client.log(hideShots:set(false))

local function normalize(yaw) 
    return math.fmod(yaw + 180, 360) - 180;
end

local function map_var( value, min, max )
    return ( value - min ) / ( max - min )
end

local function Client_can_fire(canFireText, canFireColor)
    if engine.is_in_game() then
        canFire = client.can_fire()
        if(not canFire) then
            vars.canFireText = "FIRE"
            canFireColor = {255,0,0,255}
        else
            vars.canFireText =  "FIRE"
            canFireColor = {0,255,0,255}
        end
        colorFR = canFireColor[1]
        colorFG = canFireColor[2]
        colorFB = canFireColor[3]
        colorFA = canFireColor[4]
    end
end

local function FLcolor(fakelag_amount)
    chokedTicks = engine.get_choked_commands()
    if(chokedTicks < 10) then
        colorFL = {255, 0, 0}
    elseif(chokedTicks < 8) then
        colorFL = {255, 255, 0}
    else
        colorFL = {0, 255, 0}
    end

    colorR = colorFL[1]
    colorG = colorFL[2]
    colorB = colorFL[3]
end

local function on_aimbot_hit(hit)
    local hitboxShot = "none"
    if(hit.aim_hitgroup == e_hitgroups.GENERIC) then
        hitboxShot = "generic"
    elseif(hit.aim_hitgroup == e_hitgroups.HEAD) then
        hitboxShot = "head"
    elseif(hit.aim_hitgroup == e_hitgroups.CHEST) then
        hitboxShot = "chest"
    elseif(hit.aim_hitgroup == e_hitgroups.STOMACH) then
        hitboxShot = "stomach"
    elseif(hit.aim_hitgroup == e_hitgroups.LEFT_ARM) then
        hitboxShot = "left arm"
    elseif(hit.aim_hitgroup == e_hitgroups.RIGHT_ARM) then
        hitboxShot = "right arm"
    elseif(hit.aim_hitgroup == e_hitgroups.LEFT_LEG) then
        hitboxShot = "left leg"
    elseif(hit.aim_hitgroup == e_hitgroups.RIGHT_LEG) then
        hitboxShot = "right leg"
    elseif(hit.aim_hitgroup == e_hitgroups.NECK) then
        hitboxShot = "neck"
    end
    if(menu.chat_logs:get()) then
        chatLib.print_player(0, ("{blue}[boof] {white}hit {blue}"..hit.player:get_name().."{white}'s {blue}"..hitboxShot.." {white}for {blue}"..hit.damage.." {white}[hc: {blue}"..hit.aim_hitchance.."{white}] [safe: {blue}"..tostring(hit.aim_safepoint).."{white}] [bt: {blue}"..hit.backtrack_ticks.."{white}]"))
    end
end

local function on_aimbot_miss(miss)
    local hitboxShot = "none"
    if(miss.aim_hitgroup == e_hitgroups.GENERIC) then
        hitboxShot = "generic"
    elseif(miss.aim_hitgroup == e_hitgroups.HEAD) then
        hitboxShot = "head"
    elseif(miss.aim_hitgroup == e_hitgroups.CHEST) then
        hitboxShot = "chest"
    elseif(miss.aim_hitgroup == e_hitgroups.STOMACH) then
        hitboxShot = "stomach"
    elseif(miss.aim_hitgroup == e_hitgroups.LEFT_ARM) then
        hitboxShot = "left arm"
    elseif(miss.aim_hitgroup == e_hitgroups.RIGHT_ARM) then
        hitboxShot = "right arm"
    elseif(miss.aim_hitgroup == e_hitgroups.LEFT_LEG) then
        hitboxShot = "left leg"
    elseif(miss.aim_hitgroup == e_hitgroups.RIGHT_LEG) then
        hitboxShot = "right leg"
    elseif(miss.aim_hitgroup == e_hitgroups.NECK) then
        hitboxShot = "neck"
    end

    if(menu.chat_logs:get()) then
        chatLib.print_player(0, ("{blue}[boof] {white}missed {blue}"..miss.player:get_name().."{white}'s {blue}"..hitboxShot.." {white}for reason {blue}"..miss.reason_string.."{white} with {blue}"..miss.aim_damage.." {white}[hc: {blue}"..miss.aim_hitchance.."{white}] [safe: {blue}"..tostring(miss.aim_safepoint).."{white}] [bt: {blue}"..miss.backtrack_ticks.."{white}]"))
    end
end

function draw_indicators()
    if not ref.player or not engine.is_in_game() then return end
        max_desync = math.abs( antiaim.get_max_desync_range( ) )
        cur_desync = math.floor( math.abs( normalize( antiaim.get_fake_angle( ) - antiaim.get_real_angle( ) ) ) )
        cur_desync_real = math.floor(normalize(antiaim.get_fake_angle() - antiaim.get_real_angle()))
        if(menu.desyncIndicator:get()) then
            -- boof logo
            local text_size = render.get_text_size(vars.indicator_font, "boof")
            clipSize = map_var( max_desync, 0, 58 ) * text_size.x
            velo = math.floor(ref.player:get_prop('m_vecVelocity'):length2d())
            chokedTicks = engine.get_choked_commands()
            ping = math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 800)
            fps = client.get_fps()
            hp = ref.player:get_prop("m_iHealth")
            armor = ref.player:get_prop("m_ArmorValue")
            
            local text_size = render.get_text_size(vars.fonts.font_ptr[menu.font_select:get()], "FAKE")
            local text_size_boof = render.get_text_size(vars.fonts.font_ptr[menu.font_select:get()], "boof")
          
            max_desync = math.abs( antiaim.get_max_desync_range( ) )
            cur_desync = math.floor( math.abs( normalize( antiaim.get_fake_angle( ) - antiaim.get_real_angle( ) ) ) )
            cur_desync_real = math.floor(  normalize( antiaim.get_fake_angle( ) - antiaim.get_real_angle())) 
            size = map_var( max_desync, 0, 58 ) * text_size.x
            sizeDesync = map_var( max_desync, -58, 58 ) * text_size.x
            ---fake indicator math
        
            ---cahrge indicator math
            cur_charge = exploits.get_charge()
            max_charge = exploits.get_max_charge()
            sizeCharge = map_var(max_charge, 0, cur_charge) * text_size.x
        
            -----charge
        
            -----fake lag math
            sizeFL = map_var(ref.fakelag_amount:get(), 0, chokedTicks) * text_size.x
            ----fake lag
        
            ------net var
            local frame_time = ffi.new("float[1]")
            local frame_std_deviation = ffi.new("float[1]")
            local frame_start_deviation = ffi.new("float[1]")
            local server_var = 0
            if(get_net_channel_info == nil or net_channel_info == nil or get_remote_frame == nil) then return end
            get_remote_frame(net_channel_info,frame_time,frame_std_deviation,frame_start_deviation)
            if frame_time ~= nil and frame_std_deviation ~= nil and frame_std_deviation ~= nil then
                server_var = frame_start_deviation[0] * 1000
            end
            local var_rounded = tonumber(string.format("%." .. (1 or 0) .. "f", server_var))
            -------net var
            
        
            indicator_size = vec2_t(ref.screen_size.x * 0.2, 6 )
            indicator_pos = vec2_t((ref.screen_size.x * 0.5 ) - indicator_size.x * 0.5, ref.screen_size.y - 30 )
            FLcolor(chokedTicks)
            Client_can_fire(canFire)
        
        
            if engine.is_connected()  then
                if ref.player ~= nil then
                    if(menu.fake_lag_circle:get()) then    
                        render.circle_filled(vec2_t.new(145, 690), 10, color_t.new(25,25,25,155))
                        if(chokedTicks > 0) then    
                            render.progress_circle(vec2_t.new(145, 690), 9, color_t.new(colorR,colorG,colorB), 4, chokedTicks/15)
                        end
                    end
        
                    if(menu.net_graph:get()) then
                        render.rect_fade(vec2_t(ref.x-240, ref.y+455), vec2_t(250, 30), color_t(0, 0, 0, 0), color_t(0, 0, 0, 200), true)
                        render.rect_fade(vec2_t(ref.x+10, ref.y+455), vec2_t(250, 30), color_t(0, 0, 0, 200), color_t(0, 0, 0, 0), true)
                        
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], string.format("%i fps    %i m/s     %i ping      %i var", fps, velo, ping, var_rounded), vec2_t(ref.x, ref.y+470),(vars.color:get()), true)
                    end
                    
                    
                    if(menu.health_armorToggle:get()) then
                        --the bar being filled
                        fillHP = map_var(hp, 0, 100 ) * indicator_size.x
                        fillArmor = map_var(armor, 0, 100 ) * indicator_size.x
                        
                        -- render the indicator
                        render.rect_filled(vec2_t(indicator_pos.x - 20, indicator_pos.y), vec2_t(indicator_size.x /2, indicator_size.y), color_t( 45, 45, 45, 155), 3)
                        render.rect_filled(vec2_t(indicator_pos.x + 190, indicator_pos.y), vec2_t(indicator_size.x /2, indicator_size.y), color_t( 45, 45, 45, 155), 3)
                        -- fill
                        render.rect_filled(vec2_t(indicator_pos.x - 20, indicator_pos.y), vec2_t(fillHP/2, indicator_size.y),  color_t(0, 255, 0, 255), 3)
                        render.rect_filled(vec2_t(indicator_pos.x + 190, indicator_pos.y), vec2_t(fillArmor/2, indicator_size.y),  color_t(0, 0, 230, 255), 3)
                        -- outline
                        render.rect(vec2_t(indicator_pos.x - 21, indicator_pos.y - 1), vec2_t(indicator_size.x/2 + 1, indicator_size.y + 1), color_t(15, 15, 15), 3)
                        render.rect(vec2_t(indicator_pos.x + 189, indicator_pos.y - 1), vec2_t(indicator_size.x/2 + 1, indicator_size.y + 1), color_t(15, 15, 15), 3)
                        --text
                        render.text(vars.main_font, "health", vec2_t(indicator_pos.x + 45, indicator_pos.y - 25), color_t(0,255,0,155))
                    end
        
                    if(menu.fire_indicator:get()) then
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], tostring(vars.canFireText), vec2_t(20, 600), color_t(colorFR,colorFG,colorFB,colorFA))
                    end
        
                    if(menu.fake_indicator:get()) then
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], "FAKE", vec2_t(20, 625), color_t(255, 0, 0))
                        render.push_clip(vec2_t(20, 625), vec2_t(size, text_size.y))
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], "FAKE", vec2_t(20, 625), color_t(0, 255, 0))
                        render.pop_clip()
        
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], tostring(cur_desync_real), vec2_t(ref.x, ref.y-100), color_t(255,255,255,155))
        
        
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], "boof", vec2_t(ref.x, ref.y-140), color_t(255,255,255,255))
                        --render.push_clip(vec2_t(ref.x+40, ref.y), vec2_t(sizeDesync, text_size_boof.y))
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], "boof", vec2_t(ref.x, ref.y-140), color_t(33,132,255,155))
                        
                        render.pop_clip()
        
                    end
                    if(menu.charge_indicator:get()) then
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], "CHARGE", vec2_t(20, 650), color_t(255, 0, 0))
                        render.push_clip(vec2_t(20, 650), vec2_t(sizeCharge, text_size.y))
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], "CHARGE", vec2_t(20, 650), color_t(0, 255, 0))
                        render.pop_clip()
                    end
                     if(menu.fL_indicator:get()) then
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], "FAKELAG", vec2_t(20, 675), color_t(colorR, colorG, colorB))
                        render.push_clip(vec2_t(20, 625), vec2_t(sizeFL, text_size.y))
                        render.text(vars.fonts.font_ptr[menu.font_select:get()], "FAKELAG", vec2_t(20, 675), color_t(colorR, colorG, colorB))
                        render.pop_clip()
                     end
                    
                end
            end



            render.text(vars.indicator_font, "boof", vec2_t(ref.screen_size.x / 2, ref.screen_size.y / 2 + 300), color_t(255, 255, 255, 255), true)
            render.push_clip(vec2_t(ref.screen_size.x / 2 + 5, ref.screen_size.y / 2 + 280), vec2_t(clipSize, text_size.y))
            render.text(vars.indicator_font2, "boof", vec2_t(ref.screen_size.x / 2, ref.screen_size.y / 2 + 300), color_t(33, 122, 255, 255), true)
            render.pop_clip()

            render.rect_filled(vec2_t(ref.screen_size.x / 2 - 95, ref.screen_size.y / 2 + 335), vec2_t(200, 13), color_t(200,200,200))
            render.rect(vec2_t(ref.screen_size.x / 2 - 95, ref.screen_size.y / 2 + 335), vec2_t(200, 13), color_t(0,0,0))
            render.text(vars.degrees_font, tostring(math.floor(cur_desync_real)) .. "°" or "0°", vec2_t(ref.screen_size.x / 2, ref.screen_size.y / 2 + 380), color_t(33, 122, 255, 255), true)
            local opacity = 50
            local color = {
                255,255,255
            }
            if(exploits.get_charge() ~= 0 and exploits.get_charge() ~= 14) then
                opacity = 100
            elseif(exploits.get_charge() == 14) then
                opacity = 200
                color = {
                    33,122,255
                }
            end
            local opacity2 = 50

            if(hideShots) then
                opacity2 = 200
            end
            render.text(vars.flags_font, "doubletap", vec2_t(ref.screen_size.x / 2, ref.screen_size.y / 2 + 410), color_t(color[1], color[2], color[3], opacity), true)
            render.text(vars.flags_font, "hideshots", vec2_t(ref.screen_size.x / 2, ref.screen_size.y / 2 + 442), color_t(255, 255, 255, opacity2), true)
        end
end 

-- KillSays
function killChat(event_info)
    if(menu.killSay:get()) then
        local attacker = entity_list.get_player_from_userid(event_info.attacker)
        local victim = entity_list.get_player_from_userid(event_info.userid)
        if attacker == nil then return end
        if(attacker:get_name() ~= entity_list.get_local_player():get_name()) then
            return
        end
        if(attacker:get_name() == victim:get_name()) then return end
        local dumbassname = victim:get_name()
        local s = "my killsay is ass lmao"

        if (menu.killSaySetting:get() == 1) then
            s = vars.boofMode[client.random_int(1, #vars.boofMode)]
        elseif (menu.killSaySetting:get() == 2) then
            s = vars.friendlyMode[client.random_int(1, #vars.friendlyMode)]
        elseif(menu.killSaySetting:get() == 3) then
            s = vars.russianMode[client.random_int(1, #vars.russianMode)]
        elseif(menu.killSaySetting:get() == 4) then
            s = vars.gayMode[client.random_int(1, #vars.gayMode)]
        elseif(menu.killSaySetting:get() == 5) then
            s = vars.amongUsMode[client.random_int(1, #vars.amongUsMode)]
        else                
            s = vars.boofMode[client.random_int(1, #vars.boofMode)]
        end

        s = string.gsub(s, "hh", dumbassname)
        client.log(s)
        engine.execute_cmd("say " .. s)
    end
    vars.killCount = vars.killCount + 1
end

-- Halo
local killNumber = 0
local hasKilledRecently = false
function reduceKill()
    if(hasKilledRecently ~= true) then
        killNumber = 0
    end
end
function hasntKilled()
    hasKilledRecently = false
end
function endRound()
    client.log('reset kill count')
    hasKilledRecently = false
    killNumber = 0
end
local function haloSay(event_info)
    if(menu.haloToggle:get()) then
        local attacker = entity_list.get_player_from_userid(event_info.attacker)
        local victim = entity_list.get_player_from_userid(event_info.userid)
        if attacker == nil then 
            return 
        end
        -- make local deaths not count
        if(attacker:get_name() ~= entity_list.get_local_player():get_name()) then
            return
        end

        killNumber = killNumber + 1
        hasKilledRecently = true
        client.delay_call(hasntKilled, 5.0)
        client.delay_call(reduceKill, 7.0)

        if(killNumber == 2) then
            engine.play_sound("2k.wav", 40, 100) -- change the 100 to up/lower the pitch of classys voice :)
        end

        if(killNumber == 3) then
            engine.play_sound("3k.wav", 40, 100)
        end

        if(killNumber == 4) then
            engine.play_sound("4k.wav", 40, 100)
        end

        if(killNumber == 5) then
            engine.play_sound("5k.wav", 40, 100)
        end

        if(killNumber == 5) then
            engine.play_sound("6k.wav", 40, 100)
            killNumber = 0
        end
    end
end

-- Server Picker
for k, v in pairs(servers_community) do
    table.insert(servercomm_names, k)
end

for k, v in pairs(servers_2v2) do
    table.insert(server2v2_names, k)
end

local function connect(name, ip)
    client.log_screen('Connecting to ' .. name .. ' [' .. ip .. '] ')
    engine.execute_cmd('connect ' .. ip)
end

local function SetVisibility(table, condition)
    for k, v in pairs(table) do
        if (type(v) == 'table') then
            for j, i in pairs(v) do
                i:set_visible(condition)
            end
        else 
            v:set_visible(condition)
        end
    end
end

callbacks.add(e_callbacks.PAINT, function()
    local toggle = ref.master:get()
    local selection = ref.items.selection:get()

    SetVisibility(ref.items, toggle)
    button:set_visible(toggle)

    ref.items.picker:set_items(selection == 1 and servercomm_names or server2v2_names)
end)

-- CTAG
local hasCleared = false
local replacingZero = false
local lastChar = false
local send_clan_tag_addr = memory.find_pattern( "engine.dll", "53 56 57 8B DA 8B F9 FF 15" )
local send_clan_tag = ffi.cast( "void( __fastcall* )( const char*, const char* )", send_clan_tag_addr )
local clan_tag = "boof.gg ♥"
local clan_tag_delay = 66
clan_stored_index = -1
clan_index = 0
cur_tag = ""
prev_tag = ""
stored_clan_tag = ""
clantagTable = {}
function get_clantagTable_length(clantagTable)
    local length = 0

    for i in pairs(clantagTable) do 
        length = length + 1 
    end

    return length
end

function split_str_into_chars(str)
    local clantagTable = {}

    for i = 1, #str do
        clantagTable[ i ] = str:sub(i, i) 
    end

    return clantagTable
end
function on_paint(  )
    local local_plyr = entity_list.get_local_player( )

    if not local_plyr then
        vars.stored_cur_time2 = -1
        return
    end

    -- we changed, reset
    if stored_clan_tag ~= clan_tag and clan_tag ~= "" then
        clan_index = 0
        cur_tag = ""
        clantagTable = split_str_into_chars( clan_tag )
        stored_clan_tag = clan_tag
    end

    -- update
    if global_vars.cur_time( ) - vars.stored_cur_time2 > clan_tag_delay * 0.01 then
        clan_index = clan_index + 1
        vars.stored_cur_time2 = global_vars.cur_time( )
    end

    -- we're at the end, start over
    if clan_index > get_clantagTable_length( clantagTable ) then
        lastChar = false
        cur_tag = ""
        clan_index = 0
    end
    
    -- add the next char to our str
    if clan_stored_index ~= clan_index then
        if(clan_index == 2 or clan_index == 3) then
            if(replacingZero) then
                cur_tag = cur_tag:sub(0, -2) .. ( clantagTable[ clan_index ] or "" )
                replacingZero = false
                clan_stored_index = clan_index
            else
                cur_tag = cur_tag .. '0'
                clan_index = clan_index - 1
                replacingZero = true
            end
        elseif(clan_index == 9) then
            if(lastChar) then
                cur_tag = cur_tag .. ( clantagTable[ clan_index ] or "" )
                clan_stored_index = clan_index
            else
                lastChar = true
                clan_index = clan_index - 1
            end
        else
            cur_tag = cur_tag .. ( clantagTable[ clan_index ] or "" )
            clan_stored_index = clan_index
        end
    end

    -- send our clantag if it's different
    if prev_tag ~= cur_tag and menu.clantag_toggle:get() then
        hasCleared = false
        send_clan_tag( cur_tag, cur_tag )
        prev_tag = cur_tag
    end

    if not hasCleared and not menu.clantag_toggle:get() then
        hasCleared = true
        send_clan_tag("","")
    end
end

-- Clear clan-tag
local function on_shutdown()
    send_clan_tag("","")
end


for k, v in pairs(vars.fonts.avaliable_fonts) do
    vars.fonts.font_ptr[k] = render.create_font(v, 26, 650, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
end


callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)
callbacks.add(e_callbacks.EVENT,killChat,"player_death")
callbacks.add(e_callbacks.EVENT,haloSay,"player_death")
callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.PAINT, draw_indicators)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.AIMBOT_HIT, on_aimbot_hit)
callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)
