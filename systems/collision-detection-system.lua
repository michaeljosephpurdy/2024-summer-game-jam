local CollisionDetectionSystem = tiny.processingSystem()
CollisionDetectionSystem.filter = tiny.requireAll('collision_detection_enabled', 'collision_radius', 'x', 'y')

function CollisionDetectionSystem:initialize(props)
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
end

function CollisionDetectionSystem:process(e, dt)
  e.nearest_vehicle = nil
  e.nearest_box = nil
  e.nearest_back_door = nil
  e.nearest_delivery_stop = nil
  -- first, we'll check horizontal collisions
  local horizontal_collisions = self.collision_grid:single_query(e.future_x, e.y)
  local solid_on_horizontal = false
  for _, other in pairs(horizontal_collisions) do
    if other.is_tile and other.is_solid then
      solid_on_horizontal = true
      break
    end
  end
  -- second, we'll check vertical collisions
  local vertical_collisions = self.collision_grid:single_query(e.x, e.future_y)
  local solid_on_vertical = false
  for _, other in pairs(vertical_collisions) do
    if other.is_tile and other.is_solid then
      solid_on_vertical = true
      break
    end
  end
  -- third, we'll check all surrounding collisions
  local collisions = self.collision_grid:query(e.future_x, e.future_y)
  for _, other in pairs(collisions) do
    local max_distance = e.collision_radius + other.collision_radius
    local distance_squared = ((other.x - e.future_x) * (other.x - e.future_x))
      + ((other.y - e.future_y) * (other.y - e.future_y))
    local overlaps = distance_squared <= max_distance * max_distance

    if overlaps then
      if e.is_player and other.is_trigger then
        other.triggered = true
      end
      local other_push_player = other.can_repel
      local player_push_other = other.can_be_repelled
      local power_from_other = other.repel_force
      local power_from_player = e.repel_force
      if e == other then
        other_push_player = false
        player_push_other = false
      elseif other.is_solid then
        other_push_player = false
        player_push_other = false
      elseif e.is_player and other.is_delivery_stop then
        e.nearest_delivery_stop = other
      elseif e.is_player and other.is_trigger and other.is_vehicle_door then
        e.nearest_vehicle = other.trigger
        other.trigger.near_player = true
      elseif e.is_player and other.is_trigger and other.trigger.is_box then
        e.nearest_box = other.trigger
      elseif e.is_player and other.is_truck_back_door then
        e.nearest_back_door = other
        other.trigger.near_player = true
      elseif e.is_vehicle and other.is_vehicle then
        e.speed = 0
      elseif e.is_vehicle and e.is_active and other.is_box and other.on_ground then
        self.world:addEntity({ accident_type = 'BOX', entity = other })
      elseif
        e.is_vehicle
        and e.is_active
        and (e.move_forward or e.move_backward)
        and other.is_character
        and not other.is_player
      then
        self.world:addEntity({ accident_type = 'PERSON', entity = other })
      elseif e.is_vehicle and e.is_active and other.is_stop_sign then
        self.world:addEntity({ accident_type = 'STOP_SIGN', entity = other })
      end
      if other_push_player or player_push_other then
        local angle = math.atan2(other.y - e.y, other.x - e.x)
        local other_radius = other.collision_radius + (other.repel_offset or 0)
        local repel_force = (e.collision_radius + other_radius - distance_squared) / (e.collision_radius + other_radius)
        if player_push_other then
          other.repel_force_dx = other.repel_force_dx - math.cos(angle) * repel_force * power_from_player
          other.repel_force_dy = other.repel_force_dy - math.sin(angle) * repel_force * power_from_player
        end
        if other_push_player then
          e.repel_force_dx = e.repel_force_dx + math.cos(angle) * repel_force * power_from_other
          e.repel_force_dy = e.repel_force_dy + math.sin(angle) * repel_force * power_from_other
        end
      end
    end
  end
  if solid_on_horizontal then
    e.future_x = e.x
  end
  if solid_on_vertical then
    e.future_y = e.y
  end
end

return CollisionDetectionSystem
