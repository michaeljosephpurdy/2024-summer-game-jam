local RotationSystem = tiny.processingSystem()
RotationSystem.filter = tiny.requireAll('rotation', 'rotation_speed')

function RotationSystem:process(e, dt)
  local rotation_direction = 1
  if e.move_backward then
    rotation_direction = -1
  end
  if e.turn_left then
    e.rotation = e.rotation - (e.rotation_speed * dt) * rotation_direction
  elseif e.turn_right then
    e.rotation = e.rotation + (e.rotation_speed * dt) * rotation_direction
  end
end

return RotationSystem
