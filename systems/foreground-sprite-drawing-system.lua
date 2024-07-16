local ForegroundDrawingSystem = tiny.processingSystem()
local rejection_filter = tiny.rejectAny('draw_background')
ForegroundDrawingSystem.filter = tiny.requireAll(rejection_filter, 'draw_foreground', 'sprite', 'x', 'y')
ForegroundDrawingSystem.is_draw_system = true
local default_offset = { x = 0, y = 0 }

function ForegroundDrawingSystem:process(e, dt)
  if e.hidden then
    return
  end
  local x, y = e.x, e.y
  local offset = e.sprite_offset or default_offset
  local origin_offset = e.origin_offset or 0
  local rotation = e.rotation or 0
  local scale = e.scale or 1
  love.graphics.draw(e.sprite, x + offset.x, y + offset.y, rotation, scale, scale, origin_offset, origin_offset)
end

return ForegroundDrawingSystem
