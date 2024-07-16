local FrictionSystem = tiny.processingSystem()
local rejection_filter = tiny.rejectAny('is_solid', 'is_tile')
FrictionSystem.filter = tiny.requireAll(rejection_filter, 'x', 'y')

function FrictionSystem:process(e, dt)
  local friction = e.friction or 0.09
  e.dx, e.dy = (e.dx or 0) * friction, (e.dy or 0) * friction
  e.repel_force_dx = (e.repel_force_dx or 0) * friction
  e.repel_force_dy = (e.repel_force_dy or 0) * friction
end

return FrictionSystem
