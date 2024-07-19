local CharacterInteractionSystem = tiny.processingSystem()
CharacterInteractionSystem.filter = tiny.requireAll('is_player')

function CharacterInteractionSystem:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
  self.game_state = props.game_state --[[@as GameState]]
end

function CharacterInteractionSystem:process(e, _)
  if self.game_state:are_controls_locked() then
    return
  end
  local move_foward = self.keyboard_state:is_key_down('up')
  local move_backward = self.keyboard_state:is_key_down('down')
  local moving = move_foward or move_backward
  local perform_action = self.keyboard_state:is_key_just_released('space')

  if perform_action then
    if e.is_driving then
      print('get in vehicle')
      e.vehicle.is_active = false
      e.is_driving = false
      e.pivot_point = nil
      e.animation_sprite = e.normal_idle_sprites
      e.animation_time = 0
    elseif e.nearest_vehicle then
      print('get out of vehicle')
      e.vehicle = e.nearest_vehicle
      e.vehicle.is_active = true
      e.is_driving = true
      e.pivot_point = e.vehicle
    elseif e.is_carrying_box then
      print('put down box')
      e.box.hidden = false
      e.box.is_active = true
      e.is_carrying_box = false
      e.box.pivot_point = false
      e.box = nil
    elseif e.nearest_box and not e.nearest_box.is_delivered then
      print('pick up box')
      e.is_carrying_box = true
      e.box = e.nearest_box
      e.box.is_active = false
      e.box.hidden = true
      e.box.pivot_point = e
      self.game_state:mark_box_as_current(e.box)
    end
  end

  -- player is not active if it is driving
  e.is_active = not e.is_driving
  -- if the player is active then hide it
  e.hidden = e.is_driving

  if moving then
    if e.is_carrying_box then -- walking with box
      e.animation_sprite = e.carrying_walking_sprites
      -- TODO: half the animation time due to slower walking?
      if move_backward then
        e.animation_time = -e.walking_sprites_time
      else
        e.animation_time = e.walking_sprites_time
      end
    else -- walking without box
      e.animation_sprite = e.normal_walking_sprites
      e.animation_time = e.walking_sprites_time
    end
  else
    if e.is_carrying_box then -- idle with box
      e.animation_sprite = e.carrying_idle_sprites
      e.animation_time = 0
    else -- idle without box
      e.animation_sprite = e.normal_idle_sprites
      e.animation_time = 0
    end
  end
end

return CharacterInteractionSystem
