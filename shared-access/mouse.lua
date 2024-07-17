---@class MouseState
---@field get_position function
MouseState = class('MouseState') --[[@as MouseState]]
MouseState.static.is_singleton = true

function MouseState:initialize()
  self.x, self.y = 0, 0
end

---@return number, number
function MouseState:get_position()
  return self.x, self.y
end

---@return number, number
--function MouseState:get_position_on_grid()
--return math.floor(self.x / EntityGridData.grid_size), math.floor(self.y / EntityGridData.grid_size)
--end

---@return boolean
function MouseState:is_left_click()
  return self.is_left_click_down
end

---@return boolean
function MouseState:is_right_click()
  return self.is_right_click_down
end

---@return boolean
function MouseState:is_left_click_just_relased()
  return self.was_left_click_just_released
end

---@return boolean
function MouseState:is_right_click_just_released()
  return self.was_right_click_just_released
end

function MouseState:update()
  self.x, self.y = love.mouse.getPosition()
  local was_left_click_down = self.is_left_click_down
  local was_right_click_down = self.is_right_click_down
  self.is_left_click_down = love.mouse.isDown(1)
  self.is_right_click_down = love.mouse.isDown(2)
  self.was_left_click_just_released = not was_left_click_down and self.is_left_click_down
  self.was_right_click_just_released = not was_right_click_down and self.is_right_click_down
end

return MouseState --[[@as MouseState]]
