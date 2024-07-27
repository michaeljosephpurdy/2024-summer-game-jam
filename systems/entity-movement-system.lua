local EntityMovementSystem = tiny.processingSystem()
local rejection_filter = tiny.rejectAny('is_solid', 'is_tile')
EntityMovementSystem.filter = tiny.requireAll(rejection_filter, 'x', 'y', 'dx', 'dy', 'speed')

function EntityMovementSystem:onAdd(e)
  e.current_max_speed = e.current_max_speed
end

function EntityMovementSystem:process(e, dt)
  if e.move_forward then
    e.speed = e.speed + e.acceleration
    if e.speed > e.current_max_speed then
      e.speed = e.current_max_speed
    end
    if e.speed > 0 then
      e.dx = 1 * math.cos(e.rotation)
      e.dy = 1 * math.sin(e.rotation)
    end
  elseif e.move_backward then
    e.speed = e.speed - e.acceleration
    if e.speed < -e.current_max_speed then
      e.speed = -e.current_max_speed
    end
    if e.speed < 0 then
      e.dx = 1 * math.cos(e.rotation)
      e.dy = 1 * math.sin(e.rotation)
    end
  end
  e.future_x = e.x + (e.dx * e.speed * dt)
  e.future_y = e.y + (e.dy * e.speed * dt)
end

return EntityMovementSystem
