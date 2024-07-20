---@class GameState
local GameState = class('GameState') ---[[@as GameState]]

function GameState:initialize()
  self.game_started = false
  self.max_days = 5
  self.days = 4
  self.money = 0
  self.delivered = 0

  self.delivery_direction = ''
  self.accidents = 0
  self.last_accident = 0
  self.current_destination = nil
  self.boxes = {}
  self.stops = {}
  self.stops_without_boxes = {}
  self.boxes_without_stops = {}
  self.controls_locked = false
  self.stop_sign_count = 0

  self.seconds = 0
  self.minutes = 0
  self.hours = 9
  self.real_seconds_to_game_seconds = 10
end

function GameState:find_delivery_stop(box)
  for _, stop in pairs(self.stops) do
    if stop.linked == box then
      return box
    end
  end
end

function GameState:add_delivery_stop(stop)
  if stop.linked then
    assert(nil, 'stop already has a box')
    return
  end
  table.insert(self.stops, stop)
  local box = table.remove(self.boxes_without_stops, math.floor((math.random() * #self.boxes_without_stops)) + 1)
  if not box then
    table.insert(self.stops_without_boxes, stop)
    return
  end
  box.linked = stop
  stop.linked = box
end

function GameState:add_box(box)
  if box.linked then
    assert(nil, 'box already has a stop')
    return
  end
  table.insert(self.boxes, box)
  local stop = table.remove(self.stops_without_boxes, math.floor((math.random() * #self.stops_without_boxes)) + 1)
  if not stop then
    table.insert(self.boxes_without_stops, box)
    return
  end
  box.linked = stop
  stop.linked = box
end

function GameState:mark_box_as_current(current_box)
  if not current_box then
    self.current_destination = nil
  end
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
  self.delivery_direction = ''
  self.money = self.money + 5
  self.current_destination = nil
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
  self.last_accident = self.days
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
