---@class GameState
local GameState = class('GameState') ---[[@as GameState]]

function GameState:initialize()
  self.delivered = 0
  self.current_destination = nil
  self.boxes = {}
  self.stops = {}
  self.controls_locked = false
end

local function find_random(tbl, filter)
  local found = {}
  local length = 0
  for _, item in pairs(tbl) do
    length = length + 1
    if filter(item) then
      table.insert(found, item)
    end
  end
  return found[math.floor((math.random() * length)) + 1]
end

function GameState:find_delivery_stop(box)
  for _, stop in pairs(self.stops) do
    if stop.linked == box then
      return box
    end
  end
end

function GameState:add_delivery_stop(stop)
  table.insert(self.stops, stop)
  if stop.linked then
    return
  end
  local box = find_random(self.boxes, function(box)
    return box.linked ~= stop
  end)
  if not box then
    return
  end
  box.linked = stop
  stop.linked = box
end

function GameState:add_box(box)
  table.insert(self.boxes, box)
  if box.linked then
    return
  end
  local stop = find_random(self.stops, function(stop)
    return stop.linked ~= box
  end)
  if not stop then
    return
  end
  box.linked = stop
  stop.linked = box
end

function GameState:mark_box_as_current(current_box)
  for _, box in pairs(self.boxes) do
    local current = box == current_box
    box.current = current
    if box.linked then
      box.linked.current = current
      if current then
        self.current_destination = box.linked
      end
    end
  end
end

function GameState:increment_delivered()
  self.delivered = self.delivered + 1
  print('delieverd is now ' .. self.delivered)
end

function GameState:set_delivered(delivered)
  self.delivered = delivered
end

function GameState:get_current_destination()
  return self.current_destination
end

function GameState:toggle_controls()
  self.controls_locked = not self.controls_locked
end

function GameState:are_controls_locked()
  return self.controls_locked
end

return GameState
