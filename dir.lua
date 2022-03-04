-- Boof Efficient Loader
-- Explanation: Client downloads Loader -> loader grabs directory -> directory loads all modules
-- Client loader then sends a discord webhook to the discord server to notify us.

local uidURL = "https://raw.githubusercontent.com/KerchooKult/boof-public/main/whitelist.lua"
local dirURL = "https://raw.githubusercontent.com/KerchooKult/boof-public/main/dir.lua"
local webhookURL = "https://discord.com/api/webhooks/948831635732824064/QprfdEe5ruR-tcGSp6RIwacCygxjObicKgpuZnD42IBJpchM00_ISoud7261VtzbgBDr"

local http_lib = require("Lightweight HTTP Library.lua")
-- init the http library to cloud load
local http = http_lib.new({
    task_interval = 0.3, -- polling intervals
    enable_debug = true, -- print http requests to the console
    timeout = 20 -- request expiration time
})

function tellDiscord(valOne, valTwo)
    if(valOne) then
        local params = {
            username = "Boof Admin Notification",
            avatar_url = "https://avepointcom.azureedge.net/blog/wp-content/uploads/2021/10/system-administrator-software-developer-working-on-laptop-computer-in-vector-id1296795051.jpg",
            content = user.name .. " [" .. user.uid .. "] has just tried to inject Boof.gg.\n `Verified?`: " .. tostring(valTwo) .. "." 
        }
        
        http:post(webhookURL, params, function(data)
        end)
    else
        local params = {
            username = "Boof Admin Notification",
            avatar_url = "https://avepointcom.azureedge.net/blog/wp-content/uploads/2021/10/system-administrator-software-developer-working-on-laptop-computer-in-vector-id1296795051.jpg",
            content = user.name .. " [" .. user.uid  .. "] has just tried to load Boof.gg.\n `Did launch?`: " .. tostring(valTwo) .. "." 
        }
        
        http:post(webhookURL, params, function(data)
        end)
    end
end

function loadDirectory()
  http:get(dirURL, function (data)
      local success = data.status == 200
      if not success then
        client.log('error loading directory retry')
        return
      end
      local doScript = loadstring(tostring(data.body))
      doScript()
      callbacks.add(e_callbacks.PAINT, doScript(paint_function))
      tellDiscord(false, true)
  end)
end

local uidcheck = user.uid
function processData(data)
    -- process data
    local verifiedBool = false
    local hwidTable = loadstring(data.body)()
    for i,v in pairs(hwidTable) do
      uidcasted = tonumber(v)
      if uidcasted == uidcheck then
          -- users uid matches
          verifiedBool = true
          tellDiscord(true, true)
          loadDirectory()
      end
    end
    if(not verifiedBool) then
      tellDiscord(true, false)
    --   while(true) do
    --     client.log('buy boof. discord.gg/boof')
    --   end
    end
end

local retryCount = 0
http:get(uidURL, function (data)
     -- retrieve data
    local success = data.status == 200
    if not success then
        client.log('failed to get script')
        retryCount = retryCount + 1
        if(retryCount > 3) then
        --   while(true) do
        --       client.log    ('lmao')
        --   end
        end
        return
    end
    processData(data)
end)
