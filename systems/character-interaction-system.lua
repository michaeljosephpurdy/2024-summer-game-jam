local CharacterInteractionSystem = tiny.processingSystem()
CharacterInteractionSystem.filter = tiny.requireAll('is_player')

function CharacterInteractionSystem:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
end

function CharacterInteractionSystem:process(e, _)
  local perform_action = self.keyboard_state:is_key_just_released('space')
  if not perform_action then
    return
  end
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
    elseif e.is_carrying_box then
      print('put down box')
      e.box.hidden = false
      e.box.is_active = true
      e.is_carrying_box = false
      e.box.pivot_point = false
      e.box = nil
    elseif e.nearest_box then
      print('pick up box')
      e.is_carrying_box = true
      e.box = e.nearest_box
      e.box.is_active = false
      e.box.hidden = true
      e.box.pivot_point = e
    end
  end

  -- player is not active if it is driving
  e.is_active = not e.is_driving
  -- if the player is active then hide it
  e.hidden = e.is_driving
end
return CharacterInteractionSystem
