local CharacterInputSystem = tiny.processingSystem()
CharacterInputSystem.filter = tiny.requireAny('is_player')

function CharacterInputSystem:initialize(props)
  self.game_state = props.game_state --[[@as GameState]]
end

function CharacterInputSystem:process(e, dt)
  if not e.is_active then
    return
  end

  -- you should walk slower if you are carrying a package
  e.current_max_speed = e.max_speed
  if e.is_carrying_box then
    e.current_max_speed = e.max_speed * 0.5
  end

  if e.move_forward then
    self.game_state:calculate_direction(e.x, e.y)
  elseif e.move_backward then
    self.game_state:calculate_direction(e.x, e.y)
  end
end

return CharacterInputSystem
