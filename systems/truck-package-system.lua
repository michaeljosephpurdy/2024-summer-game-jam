local TruckPackageSystem = tiny.processingSystem()
TruckPackageSystem.filter = tiny.requireAll('is_truck_back_door')

function TruckPackageSystem:initialize(props)
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
end

function TruckPackageSystem:onAdd(e)
  e.boxes = {}
  e.box_count = 0
  e.next_box = nil
  e.max_box_size = 5
  e.vehicle.box_count = e.box_count
  e.vehicle.max_boxes = e.max_box_size
end

function TruckPackageSystem:process(e, dt)
  e.box_count = #e.boxes
  if e.next_box then
    e.box_count = e.box_count + 1
  end
  local total_boxes = e.box_count
  e.can_fit_box = e.box_count < e.max_box_size
  -- if there are boxes, set the last one to the next box
  if not e.next_box and #e.boxes > 0 then
    e.next_box = table.remove(e.boxes)
    print('next box is ' .. tostring(e.next_box) .. ' and we have a total of ' .. #e.boxes)
  end
  if e.latest_placed_box then
    table.insert(e.boxes, e.next_box)
    e.next_box = nil
    table.insert(e.boxes, e.latest_placed_box)
    print('latest placed box is ' .. tostring(e.latest_placed_box) .. ' and we have a total of ' .. #e.boxes)
    e.latest_placed_box = nil
  end
  e.vehicle.box_count = e.box_count
end

return TruckPackageSystem
