local PlayerInputSystem = tiny.processingSystem()
PlayerInputSystem.filter = tiny.requireAny('is_player')

function PlayerInputSystem:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
end

function PlayerInputSystem:process(e, dt)
  local perform_action = self.keyboard_state:is_key_just_released('space')
  local move_forward = self.keyboard_state:is_key_down('up')
  local move_backward = self.keyboard_state:is_key_down('down')
  local is_moving = move_forward or move_backward
  local can_turn = not e.is_truck or is_moving
  local turn_left = can_turn and self.keyboard_state:is_key_down('left')
  local turn_right = can_turn and self.keyboard_state:is_key_down('right')

  if perform_action then
    e.is_active = not e.is_active
  end
  -- apply friction, slowing down the player
  e.dx, e.dy = e.dx * e.friction, e.dy * e.friction

  -- if the player is not in the truck, then do not show the player
  if not e.is_truck then
    e.hidden = not e.is_active
  end
  -- if the player is not in the truck, then do not move the truck
  if not e.is_active then
    return
  end

  if turn_left then
    e.rotation = e.rotation - e.rotation_speed
  elseif turn_right then
    e.rotation = e.rotation + e.rotation_speed
  end

  -- you should walk slower if you are carrying a package
  -- or if you are backing up in the truck
  local max_speed = e.max_speed
  if e.is_carrying_box or (e.is_truck and move_backward) then
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

return PlayerInputSystem
