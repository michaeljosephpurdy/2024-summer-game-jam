local VehicleInputSystem = tiny.processingSystem()
VehicleInputSystem.filter = tiny.requireAny('is_vehicle')

function VehicleInputSystem:initialize(props)
  self.game_state = props.game_state --[[@as GameState]]
end

function VehicleInputSystem:process(e, dt)
  if self.game_state:are_controls_locked() then
    return
  end
  if not e.is_active then
    return
  end

  -- vehicles go backwards 2x slower than forward
  e.current_max_speed = e.max_speed
  if e.move_backward then
    e.current_max_speed = e.max_speed / 2
  end

  if e.move_forward then
    self.game_state:calculate_direction(e.x, e.y)
  elseif e.move_backward then
    self.game_state:calculate_direction(e.x, e.y)
  end
end

return VehicleInputSystem
