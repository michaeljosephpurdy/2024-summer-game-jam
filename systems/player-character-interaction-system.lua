local PlayerCharacterInteractionSystem = tiny.processingSystem()
PlayerCharacterInteractionSystem.filter = tiny.requireAll('is_player', 'is_character')

function PlayerCharacterInteractionSystem:initialize(props)
  self.game_state = props.game_state --[[@as GameState]]
end

function PlayerCharacterInteractionSystem:process(e, _)
  if e.is_carrying_box then
    self.game_state:mark_box_as_current(e.box)
  elseif e.is_driving and e.vehicle.back_door.next_box then
    self.game_state:mark_box_as_current(e.vehicle.back_door.next_box)
  else
    self.game_state:mark_box_as_current(nil)
  end

  if e.perform_action then
    if e.is_driving then
      e.vehicle.is_active = false
      e.is_driving = false
      e.pivot_point = nil
      e.animation_sprite = e.normal_idle_sprites
      e.animation_time = 0
    elseif not e.is_carrying_box and e.nearest_box and not e.nearest_box.is_delivered then
      e.is_carrying_box = true
      e.box = e.nearest_box
      e.box.on_ground = false
      e.box.in_truck = false
      e.box.is_active = false
      e.box.hidden = true
      e.box.pivot_point = e
    elseif not e.is_carrying_box and e.nearest_vehicle then
      e.vehicle = e.nearest_vehicle
      e.vehicle.is_active = true
      e.is_driving = true
      e.pivot_point = e.vehicle
    elseif not e.is_carrying_box and e.nearest_back_door and e.nearest_back_door.next_box then
      e.is_carrying_box = true
      e.box = e.nearest_back_door.next_box
      e.box.on_ground = false
      e.box.in_truck = false
      e.box.is_active = false
      e.box.hidden = false
      e.box.pivot_point = e
      e.nearest_back_door.next_box = nil
    elseif e.is_carry_box and e.nearest_delivery_stop then
      e.box.on_ground = true
      e.box.in_truck = false
      e.box.hidden = false
      e.box.is_active = true
      e.is_carrying_box = false
      e.box = nil
    elseif e.is_carrying_box and e.nearest_back_door and e.nearest_back_door.can_fit_box then
      e.box.on_ground = false
      e.box.in_truck = true
      e.box.hidden = true
      e.box.is_active = false
      e.is_carrying_box = false
      e.box.pivot_point = e.nearest_back_door.vehicle
      e.nearest_back_door.latest_placed_box = e.box
      e.box = nil
    elseif e.is_carrying_box then
      e.box.on_ground = true
      e.box.in_truck = false
      e.box.hidden = false
      e.box.is_active = true
      e.is_carrying_box = false
      e.box.pivot_point = false
      e.box = nil
    end
  end

  -- player is not active if it is driving
  e.is_active = not e.is_driving
  -- if the player is active then hide it
  e.hidden = e.is_driving
end

return PlayerCharacterInteractionSystem
