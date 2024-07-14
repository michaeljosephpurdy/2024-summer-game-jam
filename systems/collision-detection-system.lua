local CollisionDetectionSystem = tiny.processingSystem()
CollisionDetectionSystem.filter = tiny.requireAll('collision_detection_enabled', 'x', 'y')

function CollisionDetectionSystem:initialize(props)
  self.bump_world = props.bump_world
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
end

function CollisionDetectionSystem:process(e, dt)
  if not e.is_active then
    return
  end
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
    debug_rect.draw_debug = true
    debug_rect.time_to_live = 0
    self.world:addEntity(debug_rect)
    local max_distance = e.collision_radius + other.collision_radius
    local distance_squared = ((other.x - future_x) * (other.x - future_x))
      + ((other.y - future_y) * (other.y - future_y))
    if distance_squared <= max_distance * max_distance then
      if e.is_player and other.is_vehicle then
        e.nearest_vehicle = other
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
