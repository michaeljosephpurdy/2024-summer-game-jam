local CollisionDetectionSystem = tiny.processingSystem()
CollisionDetectionSystem.filter = tiny.requireAll('collision_detection_enabled', 'collision_radius', 'x', 'y')

function CollisionDetectionSystem:initialize(props)
  self.bump_world = props.bump_world
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
end

function CollisionDetectionSystem:process(e, dt)
  e.nearest_vehicle = nil
  e.nearest_box = nil
  local future_x = e.x + (e.dx * e.speed * dt)
  local future_y = e.y + (e.dy * e.speed * dt)
  -- first, we'll check horizontal collisions
  local horizontal_collisions = self.collision_grid:single_query(future_x, e.y)
  local solid_on_horizontal = false
  for _, other in pairs(horizontal_collisions) do
    if other.is_tile and other.is_solid then
      solid_on_horizontal = true
      break
    end
  end
  -- second, we'll check vertical collisions
  local vertical_collisions = self.collision_grid:single_query(e.x, future_y)
  local solid_on_vertical = false
  for _, other in pairs(vertical_collisions) do
    if other.is_tile and other.is_solid then
      solid_on_vertical = true
      break
    end
  end
  -- third, we'll check all surrounding collisions
  local collisions = self.collision_grid:query(future_x, future_y)
  for _, other in pairs(collisions) do
    local debug_rect = self.collision_grid:get_rect(other)
    --debug_rect.draw_debug = true
    debug_rect.time_to_live = 0
    self.world:addEntity(debug_rect)
    local max_distance = e.collision_radius + other.collision_radius
    local distance_squared = ((other.x - future_x) * (other.x - future_x))
      + ((other.y - future_y) * (other.y - future_y))
    local overlaps = distance_squared <= max_distance * max_distance

    if overlaps then
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
      elseif e.is_player and other.is_trigger and other.is_vehicle_door then
        e.nearest_vehicle = other.trigger
      elseif e.is_player and other.is_trigger and other.trigger.is_box then
        e.nearest_box = other.trigger
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
    future_x = e.x
  end
  if solid_on_vertical then
    future_y = e.y
  end
  -- if there are no collisions, update the entity
  self.collision_grid:update(e, future_x, future_y)
  e.x, e.y = future_x, future_y
end

return CollisionDetectionSystem
