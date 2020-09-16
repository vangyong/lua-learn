local token = ngx.var.remote_addr..ngx.var.host
local dict = ngx.shared._dict
local blacklist = ngx.shared._blacklist
local whitelist = ngx.shared._whitelist
local rate = tonumber(ngx.arg[1])
local seconds = tonumber(ngx.arg[2])
local duration = tonumber(ngx.arg[3])


local in_whitelist = whitelist:get(token)
if in_whitelist ~= nil then
    return 0
end

local in_blacklist, _ = blacklist:get(token)
if in_blacklist ~= nil then
    return 1
end

local req, _ = dict:get(token)
if req then
    dict:incr(token, 1)
    req = req + 1
    if req > rate then
        blacklist:set(token, true, duration)
        return 1
    end
else
    dict:set(token, 1, seconds)
end

return 0
