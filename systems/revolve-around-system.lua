local RevolveAroundSystem = tiny.processingSystem()
RevolveAroundSystem.filter = tiny.requireAll('revolve_around')

function RevolveAroundSystem:initialize(props)
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
end

function RevolveAroundSystem:process(e)
  -- don't put pivot_point in filter because this will be removed
  -- when we don't want entity revolving
  if not e.pivot_point then
    return
  end
  local x = e.pivot_point.x + (math.cos(e.pivot_point.rotation + e.pivot_offset) * e.origin_offset)
  local y = e.pivot_point.y + (math.sin(e.pivot_point.rotation + e.pivot_offset) * e.origin_offset)
  self.collision_grid:update(e, x, y)
  e.x, e.y = x, y
  e.y = y
end

return RevolveAroundSystem
