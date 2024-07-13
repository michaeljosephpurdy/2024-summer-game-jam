local CollisionDetectionSystem = tiny.processingSystem()
CollisionDetectionSystem.filter = tiny.requireAll('collision_detection_enabled', 'x', 'y')

function CollisionDetectionSystem:initialize(props)
  self.bump_world = props.bump_world
end

local function collision_filter(e1, e2)
  if e1.is_player and e1.is_truck then
    return 'cross'
  end

  local player = e1 --[[@as Player]]

  --if e2.class == SolidPlatform then
  --return 'slide'
  --end

  --if e2.class == SideCheckingGate then
  --local other = e2 --[[@as SideCheckingGate]]
  --if other.crossed then
  --return 'cross'
  --end
  --if other.sides == player.sides then
  --return 'cross'
  --else
  --return 'slide'
  --end
  --end
  return 'cross'
end

function CollisionDetectionSystem:process(e, dt)
  local cols, len
  local future_x = e.x + (e.dx * e.speed * dt)
  local future_y = e.y + (e.dy * e.speed * dt)
  e.x, e.y, cols, len = self.bump_world:move(e, future_x, future_y, collision_filter)
  for i = 1, len do
    local col = cols[i]
    local collided = true
    if e.class ~= Player then
      return
    end
    -- any other entity below this will be player
    if col.other.crossed then
      return
    end
    if col.type == 'cross' then
    elseif col.type == 'slide' then
    end
  end
end

return CollisionDetectionSystem
