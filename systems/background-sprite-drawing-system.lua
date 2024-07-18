local BackgroundDrawingSystem = tiny.processingSystem()
BackgroundDrawingSystem.filter = tiny.requireAll('draw_background', 'sprite', 'x', 'y')
BackgroundDrawingSystem.is_draw_system = true
local default_offset = { x = 0, y = 0 }

function BackgroundDrawingSystem:process(e, dt)
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

return BackgroundDrawingSystem
