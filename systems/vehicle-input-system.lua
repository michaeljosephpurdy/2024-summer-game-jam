local VehicleInputSystem = tiny.processingSystem()
VehicleInputSystem.filter = tiny.requireAny('is_vehicle')

function VehicleInputSystem:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
  self.game_state = props.game_state --[[@as GameState]]
end

function VehicleInputSystem:process(e, dt)
  if self.game_state:are_controls_locked() then
    return
  end
  if not e.is_active then
    return
  end
  local move_forward = self.keyboard_state:is_key_down('up')
  local move_backward = self.keyboard_state:is_key_down('down')
  local is_moving = move_forward or move_backward
  local can_turn = is_moving
  local turn_left = can_turn and self.keyboard_state:is_key_down('left')
  local turn_right = can_turn and self.keyboard_state:is_key_down('right')

  -- apply friction, slowing down the player
  e.dx, e.dy = e.dx * e.friction, e.dy * e.friction

  local rotation_direction = 1
  if move_backward then
    rotation_direction = -1
  end
  if turn_left then
    e.rotation = e.rotation - (e.rotation_speed * rotation_direction) * dt
  elseif turn_right then
    e.rotation = e.rotation + (e.rotation_speed * rotation_direction) * dt
  end

  -- vehicles go backwards 2x slower than forward
  local max_speed = e.max_speed
  if move_backward then
    max_speed = max_speed / 2
  end
  if move_forward then
    self.game_state:calculate_direction(e.x, e.y)
    e.speed = e.speed + e.acceleration
    if e.speed > e.max_speed then
      e.speed = e.max_speed
    end
    if e.speed > 0 then
      e.dx = 1 * math.cos(e.rotation)
      e.dy = 1 * math.sin(e.rotation)
    end
  elseif move_backward then
    self.game_state:calculate_direction(e.x, e.y)
    e.speed = e.speed - e.acceleration
    if e.speed < -e.max_speed then
      e.speed = -e.max_speed
    end
    if e.speed < 0 then
      e.dx = 1 * math.cos(e.rotation)
      e.dy = 1 * math.sin(e.rotation)
    end
  else
    e.speed = e.speed * e.friction
  end
end

return VehicleInputSystem
