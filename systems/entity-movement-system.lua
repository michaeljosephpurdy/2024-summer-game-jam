local EntityMovementSystem = tiny.processingSystem()
local rejection_filter = tiny.rejectAll('collision_detection_enabled')
EntityMovementSystem.filter = tiny.requireAll(rejection_filter, 'x', 'y', 'dx', 'dy', 'speed')

function EntityMovementSystem:process(e, dt)
  e.x = e.x + e.dx * e.speed * dt
  e.y = e.y + e.dy * e.speed * dt
end

return EntityMovementSystem
