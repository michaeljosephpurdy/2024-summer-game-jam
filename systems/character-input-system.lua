local CharacterInputSystem = tiny.processingSystem()
CharacterInputSystem.filter = tiny.requireAny('is_player')

function CharacterInputSystem:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
end

function CharacterInputSystem:process(e, _)
  local perform_action = self.keyboard_state:is_key_just_released('space')
  local move_forward = self.keyboard_state:is_key_down('up')
  local move_backward = self.keyboard_state:is_key_down('down')
  local turn_left = self.keyboard_state:is_key_down('left')
  local turn_right = self.keyboard_state:is_key_down('right')

  if perform_action then
    if e.is_driving then
      print('get in vehicle')
      e.vehicle.is_active = false
      e.is_driving = false
      e.pivot_point = nil
    elseif e.nearest_vehicle then
      print('get out of vehicle')
      e.vehicle = e.nearest_vehicle
      e.vehicle.is_active = true
      e.is_driving = true
      e.pivot_point = e.vehicle
    elseif e.nearest_box then
      print('pick up box')
      e.box.pivot_point = e
      e.is_carrying_box = true
      e.box_is_active = false
    elseif e.is_carrying_box then
      print('put down box')
      e.box.pivot_point = false
      e.is_carrying_box = false
      e.box.is_active = true
    end
  end
  -- apply friction, slowing down the player
  e.dx, e.dy = e.dx * e.friction, e.dy * e.friction

  -- player is not active if it is driving
  e.is_active = not e.is_driving
  -- if the player is active then hide it
  e.hidden = e.is_driving
  if not e.is_active then
    return
  end

  if turn_left then
    e.rotation = e.rotation - e.rotation_speed
  elseif turn_right then
    e.rotation = e.rotation + e.rotation_speed
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
