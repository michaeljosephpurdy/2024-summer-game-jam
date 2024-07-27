local PlayerInputSystem = tiny.processingSystem()
PlayerInputSystem.filter = tiny.requireAll('is_controllable')

function PlayerInputSystem:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
end

function PlayerInputSystem:process(e, dt)
  e.move_forward = e.is_active and self.keyboard_state:is_key_down('up')
  e.move_backward = e.is_active and self.keyboard_state:is_key_down('down')
  e.is_moving = e.move_forward or e.move_backward
  local can_turn = not e.is_vehicle or e.is_moving
  e.turn_left = e.is_active and can_turn and self.keyboard_state:is_key_down('left')
  e.turn_right = e.is_active and can_turn and self.keyboard_state:is_key_down('right')
  e.perform_action = self.keyboard_state:is_key_just_released('space')
end

return PlayerInputSystem
