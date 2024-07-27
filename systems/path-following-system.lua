local PathFollowingSystem = tiny.processingSystem()
PathFollowingSystem.filter = tiny.requireAll('path')

function PathFollowingSystem:initialize(props)
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
end
-- each entity with a path will...
--  get a target_point, which is the next point in the path
--  if they reach the target_point, a new target_point is calculated
--  if they reach the end of the path, they will either stop or loop through path again

function PathFollowingSystem:onAdd(e)
  local path_points = {}
  for _, point in pairs(e.path) do
    local x = point.cx * TILE_SIZE
    local y = point.cy * TILE_SIZE
    local grid_x, grid_y = self.collision_grid:to_grid(e.level_x + x, e.level_y + y)
    table.insert(path_points, { x = x, y = y, grid_x = grid_x, grid_y = grid_y })
  end
  e.path_points = path_points
  local first_point = path_points[1]
  local last_point = path_points[#path_points]
  e.path_loops = first_point.x == last_point.x and first_point.y == last_point.y
  e.target_point = first_point
  e.current_point = 1
  -- add to collision grid and use colliders each frame
  print(string.format('entity x:%s, y:%s', self.collision_grid:to_grid(e.x, e.y)))
end

function PathFollowingSystem:process(e, dt)
  -- if there is no target point, then stop
  if not e.target_point then
    e.move_forward = false
    return
  end
  local grid_x, grid_y = self.collision_grid:to_grid(e.x, e.y)
  -- if we're at the target point
  -- calculate the next one
  if grid_x == e.target_point.grid_x and grid_y == e.target_point.grid_y then
    e.move_forward = false
    e.current_point = e.current_point + 1
    e.target_point = e.path_points[e.current_point]
    if not e.target_point and e.path_loops then
      print('found new point')
      e.target_point = e.path_points[1]
      e.current_point = 1
    end
    return
  end
  e.move_forward = true
  e.rotation = math.atan2(e.target_point.grid_y - grid_y, e.target_point.grid_x - grid_x)
end

return PathFollowingSystem
