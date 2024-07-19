local CharacterInputSystem = tiny.processingSystem()
CharacterInputSystem.filter = tiny.requireAny('is_player')

function CharacterInputSystem:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
  self.game_state = props.game_state --[[@as GameState]]
end

function CharacterInputSystem:process(e, dt)
  if self.game_state:are_controls_locked() then
    return
  end
  local move_forward = self.keyboard_state:is_key_down('up')
  local move_backward = self.keyboard_state:is_key_down('down')
  local turn_left = self.keyboard_state:is_key_down('left')
  local turn_right = self.keyboard_state:is_key_down('right')

  if not e.is_active then
    return
  end

  local rotation_direction = 1
  if move_backward then
    rotation_direction = -1
  end

  if turn_left then
    e.rotation = e.rotation - (e.rotation_speed * dt) * rotation_direction
  elseif turn_right then
    e.rotation = e.rotation + (e.rotation_speed * dt) * rotation_direction
  end

  -- you should walk slower if you are carrying a package
  local max_speed = e.max_speed
  if e.is_carrying_box then
    max_speed = max_speed / 2
  end
  if move_forward then
    e.speed = e.speed + e.acceleration
    if e.speed > e.max_speed then
      e.speed = e.max_speed
    end
    if e.speed > 0 then
      e.dx = 1 * math.cos(e.rotation)
      e.dy = 1 * math.sin(e.rotation)
    end
  elseif move_backward then
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

return CharacterInputSystem
