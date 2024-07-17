local RepelSystem = tiny.processingSystem()
local rejection_filter = tiny.rejectAny('is_solid', 'is_tile')
RepelSystem.filter = tiny.requireAll(rejection_filter, 'collision_radius', 'can_be_repelled')

function RepelSystem:initialize(props)
  self.collision_grid = props.collision_grid
  self.max_repel_force = 32
end

function RepelSystem:onAdd(e)
  e.repel_force_dx = 0
  e.repel_force_dy = 0
end

function RepelSystem:process(e, dt)
  if e.repel_force_dy > self.max_repel_force then
    e.repel_force_dy = self.max_repel_force
  elseif e.repel_force_dy < -self.max_repel_force then
    e.repel_force_dy = -self.max_repel_force
  end
  if e.repel_force_dx > self.max_repel_force then
    e.repel_force_dx = self.max_repel_force
  elseif e.repel_force_dx < -self.max_repel_force then
    e.repel_force_dx = -self.max_repel_force
  end

  local future_x = e.x + e.repel_force_dx * dt
  local future_y = e.y + e.repel_force_dy * dt
  self.collision_grid:update(e, future_x, future_y)
  e.x, e.y = future_x, future_y
end

return RepelSystem
