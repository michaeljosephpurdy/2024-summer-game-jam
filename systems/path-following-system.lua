local PathFollowingSystem = tiny.processingSystem()
PathFollowingSystem.filter = tiny.requireAll('path')

-- each entity with a path will...
--  get a target_point, which is the next point in the path
--  if they reach the target_point, a new target_point is calculated
--  if they reach the end of the path, they will either stop or loop through path again

function PathFollowingSystem:onAdd(e)
  local path_points = {}
  for _, points in pairs(e.path) do
    table.insert(path_points, { x = points.cx * TILE_SIZE, y = points.cy * TILE_SIZE })
  end
  e.path_points = path_points
  local first_point = path_points[1]
  local last_point = path_points[#path_points]
  e.path_loops = first_point.x == last_point.x and first_point.y == last_point.y
  e.target_point = first_point
  e.current_point = 1
end

function PathFollowingSystem:process(e, dt)
  -- if there is no target point, then stop
  if not e.target_point then
    return
  end
  -- if we're at the target point
  -- calculate the next one
  if math.floor(e.x) == e.target_point.x and math.floor(e.y) == e.target_point.y then
    e.current_point = e.current_point + 1
    e.target_point = e.path_points[e.current_point]
    return
  end
  if e.x > e.target_point.x then
    e.dx = 1
  elseif e.x < e.target_point.x then
    e.dx = -1
  else
    e.dx = 0
  end
  if e.y > e.target_point.y then
    e.dy = 1
  elseif e.y < e.target_point.y then
    e.dy = -1
  else
    e.dy = 0
  end
end

return PathFollowingSystem
