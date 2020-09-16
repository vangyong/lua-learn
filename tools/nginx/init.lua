local whitelist = ngx.shared._whitelist
local config = require "whitelist"

for host, list in pairs(config.whitelist) do
    for j, ip in pairs(list) do
        local token = ip..host
        whitelist:set(token, true)
    end
end
