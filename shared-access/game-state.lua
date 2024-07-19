---@class GameState
local GameState = class('GameState') ---[[@as GameState]]

function GameState:initialize()
  self.max_days = 1
  self.money = 0
  self.delivered = 0

  self.delivery_direction = ''
  self.accidents = 0
  self.last_accident = 0
  self.current_destination = nil
  self.boxes = {}
  self.stops = {}
  self.controls_locked = false
  self.stop_sign_count = 0

  self.seconds = 0
  self.minutes = 0
  self.hours = 9
  self.days = 0
  self.real_seconds_to_game_seconds = 80
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
  self.delivery_direction = ''
  self.money = self.money + 5
end

function GameState:set_delivered(delivered)
  self.delivered = delivered
end

function GameState:get_current_destination()
  return self.current_destination
end

function GameState:calculate_direction(x, y)
  if not self.current_destination then
    self.delivery_direction = ''
    return
  end
  local angle = math.atan2(y - self.current_destination.y, x - self.current_destination.x)
  local dx = 1 * math.cos(angle)
  local dy = 1 * math.sin(angle)
  local NS = ''
  local EW = ''
  if dx > -0.5 and dx < 0.5 then
    EW = ''
  elseif dx > 0 then
    EW = 'W'
  else
    EW = 'E'
  end
  if dy > -0.5 and dy < 0.5 then
    NS = ''
  elseif dy > 0 then
    NS = 'N'
  else
    NS = 'S'
  end
  self.delivery_direction = NS .. EW
end

function GameState:toggle_controls()
  self.controls_locked = not self.controls_locked
end

function GameState:are_controls_locked()
  return self.controls_locked
end

function GameState:record_accident()
  self.accidents = self.accidents + 1
  self.money = self.money - 4
end

function GameState:progress_time(dt)
  self.seconds = self.seconds + (dt * self.real_seconds_to_game_seconds)
  if self.seconds >= 60 then
    self.minutes = self.minutes + 15
    self.seconds = 0
  end
  if self.minutes >= 60 then
    self.hours = self.hours + 1
    self.minutes = 0
  end
  if self.hours >= 24 then
    self.days = self.days + 1
    self.hours = 0
  end
end

function GameState:is_game_over()
  return self.days == self.max_days
end

return GameState
