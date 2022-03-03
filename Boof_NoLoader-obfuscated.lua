local http_lib = require("Lightweight HTTP Library.lua")
local uidcheck = user.uid
local verified = false

local http = http_lib.new({
    task_interval = 0.3, -- polling intervals
    enable_debug = true, -- print http requests to the console
    timeout = 15 -- request expiration time
})

function tellDiscord(isVerified)
    local emoticonVal = ":x:"
    if(isVerified) then
        emoticonVal = ":white_check_mark:"
    end

    local params = {
        username = "Boof Inject Log",
        avatar_url = "https://avepointcom.azureedge.net/blog/wp-content/uploads/2021/10/system-administrator-software-developer-working-on-laptop-computer-in-vector-id1296795051.jpg",
        content = user.name .. " [" .. user.uid  .. "] has just tried to inject.\n `Verified?` " .. emoticonVal
    }
    
    http:post("https://discord.com/api/webhooks/948692882775236649/JhsuTJ1elHfQI3ork73mhgI1Z5qrdffsLJEuOMdyrZ3CdBVV7pg3ryCMvr0WubmFZtEP", params, function(data)
    end)
end

function tellDiscordLoaded(isLoaded)

    local emoticonVal2 = ":x:"
    if(isLoaded) then
        emoticonVal2 = ":white_check_mark:"
    end

    local params = {
        username = "Boof Load Log",
        avatar_url = "https://avepointcom.azureedge.net/blog/wp-content/uploads/2021/10/system-administrator-software-developer-working-on-laptop-computer-in-vector-id1296795051.jpg",
        content = user.name .. " [" .. user.uid  .. "] script initialized.\n `Loaded success?` " .. emoticonVal2
    }
    
    http:post("https://discord.com/api/webhooks/948692882775236649/JhsuTJ1elHfQI3ork73mhgI1Z5qrdffsLJEuOMdyrZ3CdBVV7pg3ryCMvr0WubmFZtEP", params, function(data)
    end)
end

function getScript()
    local getScriptReq = http_lib.new({0.3,true,10})
    getScriptReq:get("https://raw.githubusercontent.com/KerchooKult/boof-public/main/Boof_NoLoader-obfuscated.lua",function(data)
        local success = data.status == 200
        if not success then
            client.log('failed to get script')
            return
        else
            local runScript = loadstring(data.body)
            client.log(data.body)
            runScript()
            tellDiscordLoaded(true)
        end
    end)
end

function authenticate(data)
    local hwidTable = loadstring(data)()
    for i,v in pairs(hwidTable) do
        uidcasted = tonumber(v)
        if uidcasted == uidcheck then
            verified = true
            getScript()
            tellDiscord(verified)
        end
    end
    if(not verified) then
        tellDiscord(verified)
        client.log('verification failed')
        -- while(true) do
        -- client.log('lmao')
        -- end
    end
end

local new_request = http_lib.new({0.3,false,15})
new_request:get("https://raw.githubusercontent.com/KerchooKult/boof-public/main/whitelist-obfuscated%20(1).lua",function(data)
    local success = data.status == 200
    if not success then
        client.log('failed to get script')
        -- while(true) do
        --     client.log('lmao')
        -- end
        return
    end
    authenticate(data.body)
end)
