local TruckPackageSystem = tiny.processingSystem()
TruckPackageSystem.filter = tiny.requireAll('is_truck_back_door')

function TruckPackageSystem:initialize(props)
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
end

function TruckPackageSystem:onAdd(e)
  e.boxes = {}
  e.next_box = nil
  e.max_box_size = 5
end

function TruckPackageSystem:process(e, dt)
  local box_count = #e.boxes
  if e.next_box then
    box_count = box_count + 1
  end
  e.can_fit_box = box_count < e.max_box_size
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
end

return TruckPackageSystem
