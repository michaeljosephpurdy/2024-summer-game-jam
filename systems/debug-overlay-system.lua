local DebugOverlaySystem = tiny.processingSystem()
DebugOverlaySystem.filter = tiny.requireAll('draw_debug', 'x', 'y')

function DebugOverlaySystem:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
  self.enabled = false
end

function DebugOverlaySystem:preWrap(dt)
  if self.keyboard_state:is_key_just_released('=') then
    self.enabled = not self.enabled
  end
end
function DebugOverlaySystem:process(e, dt)
  if not self.enabled then
    return
  end
  local x, y = e.x, e.y
  local y_buffer = 48
  love.graphics.push()
  if not e.is_solid then
    love.graphics.print('x: ' .. x, x, y - y_buffer)
    love.graphics.print('y: ' .. y, x, y - y_buffer + 8)
  end
  if e.speed then
    love.graphics.print('speed: ' .. e.speed, x, y - y_buffer + 16)
  end
  if e.width and e.height then
    love.graphics.rectangle('line', e.x, e.y, e.width, e.height)
  end
  if e.collision_radius then
    local fill_pattern = 'line'
    if e.collided then
      fill_pattern = 'fill'
    end
    love.graphics.circle('line', e.x, e.y, e.collision_radius)
  end
  love.graphics.pop()
end

return DebugOverlaySystem
