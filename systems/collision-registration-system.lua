local CollisionRegistrationSystem = tiny.processingSystem()
CollisionRegistrationSystem.filter = tiny.requireAll('collision_radius', 'x', 'y')

function CollisionRegistrationSystem:initialize(props)
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
end

function CollisionRegistrationSystem:onAdd(e)
  self.collision_grid:register(e)
  e.repel_force_dx = 0
  e.repel_force_dy = 0
end

function CollisionRegistrationSystem:onRemove(e)
  self.collision_grid:remove(e)
end

return CollisionRegistrationSystem
