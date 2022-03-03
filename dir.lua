local http_lib = require("Lightweight HTTP Library.lua")
local http = http_lib.new({
    task_interval = 0.3, -- polling intervals
    enable_debug = true, -- print http requests to the console
    timeout = 15 -- request expiration time
})

local modules = {
  [1] = "",
  [2] = ""
}

for i,v in ipairs(modules) do
  http:get(modules[i],function(data)
      local success = data.status == 200
      if not success then
        client.log('failed to module #' .. i)
        return
      end
      loadstring(data.body)
  end)
end
