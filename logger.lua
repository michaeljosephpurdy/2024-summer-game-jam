---@class Logger
local Logger = class('Logger')

function Logger:initialize()
  local valid = love.filesystem.getInfo('log.txt')
  if valid then
    return
  end
  love.filesystem.newFile('log.txt')
end

---@param msg any
---@return string
function Logger:parse_msg(msg)
  if type(msg) ~= 'table' then
    return msg
  end
  return json.encode(msg)
  --local log_msg = '{\n'
  --for k, v in pairs(msg) do
  --log_msg = log_msg .. ' "' .. k .. '": ' .. self:parse_msg(v)
  --end
  --log_msg = log_msg .. '\n}'
  --return log_msg
end

---@param msg any
function Logger:to_file(msg)
  local log_msg = self:parse_msg(msg)
  love.filesystem.append('log.txt', tostring(log_msg) .. '\n')
end

---@param msg any
---@param ttl number
function Logger:to_screen(msg, ttl)
  local log_msg = self:parse_msg(msg)
  tiny_world:addEntity({
    print_debug = true,
    time_to_live = ttl or 2,
    get_value = function()
      return log_msg
    end,
  })
end

return Logger
