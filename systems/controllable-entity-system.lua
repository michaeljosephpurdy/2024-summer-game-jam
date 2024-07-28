local PlayerInputSystem = tiny.processingSystem()
PlayerInputSystem.filter = tiny.requireAll('is_controllable')

function PlayerInputSystem:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
  self.game_state = props.game_state --[[@as GameState]]
end

function PlayerInputSystem:process(e, dt)
  local controls_locked = self.game_state:are_controls_locked()
  local can_move = not controls_locked and e.is_active
  e.move_forward = can_move and self.keyboard_state:is_key_down('up')
  e.move_backward = can_move and self.keyboard_state:is_key_down('down')
  e.is_moving = e.move_forward or e.move_backward
  local can_turn = not e.is_vehicle or e.is_moving
  e.turn_left = can_move and can_turn and self.keyboard_state:is_key_down('left')
  e.turn_right = can_move and can_turn and self.keyboard_state:is_key_down('right')
  e.perform_action = not controls_locked and self.keyboard_state:is_key_just_released('space')
end

return PlayerInputSystem
