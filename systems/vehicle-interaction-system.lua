local VehicleInteractionSystem = tiny.processingSystem()
VehicleInteractionSystem.filter = tiny.requireAll('is_vehicle')

function VehicleInteractionSystem:initialize(props)
  self.game_state = props.game_state --[[@as GameState]]
end

function VehicleInteractionSystem:process(e, _)
  self.game_state.current_truck_box_count = ''
  self.game_state.display_truck_states = false
  e.sprite = e.normal_sprite
  if e.is_active then
    self.game_state.current_truck_box_count = tostring(e.box_count) .. '/' .. tostring(e.max_boxes)
    self.game_state.display_truck_states = true
  elseif e.driver_door.triggered then
    e.sprite = e.driver_door_open_sprite
  elseif e.passenger_door.triggered then
    e.sprite = e.passenger_door_open_sprite
  elseif e.back_door.triggered then
    e.sprite = e.trunk_door_open_sprite
    self.world:addEntity({
      is_text = true,
      text = tostring(e.box_count) .. '/' .. tostring(e.max_boxes),
      x = e.x,
      y = e.y,
      time_to_live = 0,
    })
  end
end

return VehicleInteractionSystem
