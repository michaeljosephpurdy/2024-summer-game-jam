local ForegroundSpriteDrawingSystem = tiny.processingSystem()
ForegroundSpriteDrawingSystem.filter = tiny.requireAll('draw_foreground', 'sprite', 'x', 'y')
ForegroundSpriteDrawingSystem.is_draw_system = true
local default_offset = { x = 0, y = 0 }

function ForegroundSpriteDrawingSystem:process(e, dt)
  local x, y = e.x, e.y
  local offset = e.sprite_offset or default_offset
  if e.snap_to_grid then
    x = x * EntityGridData.grid_size
    y = y * EntityGridData.grid_size
  end
  love.graphics.draw(e.sprite, x + offset.x, y + offset.y)
end

return ForegroundSpriteDrawingSystem
