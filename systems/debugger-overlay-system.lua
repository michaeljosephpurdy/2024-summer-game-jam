local DebuggerOverlaySystem = tiny.processingSystem()
DebuggerOverlaySystem.filter = tiny.requireAny('print_debug', 'draw_debug')

function DebuggerOverlaySystem:postWrap()
  love.graphics.push()
  love.graphics.print(#self.entities, 5, 5)
  love.graphics.pop()
end

function DebuggerOverlaySystem:process(e, dt)
  if e.print_debug then
    local message = nil
    if e.get_value then
      message = e.get_value()
    else
      message = logger:parse_msg(e)
    end
    love.graphics.print(message, 5)
  end
  if e.draw_debug then
    love.graphics.rectangle(
      'line',
      e.x * EntityGridData.grid_size,
      e.y * EntityGridData.grid_size,
      EntityGridData.grid_size,
      EntityGridData.grid_size
    )
  end
end

return DebuggerOverlaySystem
