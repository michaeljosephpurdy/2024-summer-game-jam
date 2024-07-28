local CollisionUpdateSystem = tiny.processingSystem()
local rejection_filter = tiny.rejectAny('is_solid', 'is_tile')
CollisionUpdateSystem.filter = tiny.requireAll(rejection_filter, 'collision_radius', 'x', 'y', 'dx', 'dy', 'speed')

function CollisionUpdateSystem:initialize(props)
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
end

function CollisionUpdateSystem:process(e, dt)
  self.collision_grid:update(e, e.future_x, e.future_y)
  e.x, e.y = e.future_x, e.future_y
end

return CollisionUpdateSystem
