local VehicleInteractionSystem = tiny.processingSystem()
VehicleInteractionSystem.filter = tiny.requireAll('is_vehicle')

function VehicleInteractionSystem:initialize(props) end

function VehicleInteractionSystem:process(e, _)
  if e.is_active then
    e.sprite = e.normal_sprite
  elseif e.driver_door.triggered then
    e.sprite = e.driver_door_open_sprite
  elseif e.passenger_door.triggered then
    e.sprite = e.passenger_door_open_sprite
  elseif e.back_door.triggered then
    e.sprite = e.trunk_door_open_sprite
  else
    e.sprite = e.normal_sprite
  end
end

return VehicleInteractionSystem
