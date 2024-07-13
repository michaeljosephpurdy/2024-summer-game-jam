local DebugOverlaySystem = tiny.processingSystem()
DebugOverlaySystem.filter = tiny.requireAll('draw_debug', 'x', 'y')
DebugOverlaySystem.is_draw_system = true

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
  love.graphics.print('x: ' .. x, x, y - y_buffer)
  love.graphics.print('y: ' .. y, x, y - y_buffer + 8)
  love.graphics.print('speed: ' .. e.speed, x, y - y_buffer + 16)
  if e.hitbox then
    love.graphics.rectangle('line', e.x, e.y, e.hitbox.width, e.hitbox.height)
  end
  love.graphics.pop()
end

return DebugOverlaySystem
