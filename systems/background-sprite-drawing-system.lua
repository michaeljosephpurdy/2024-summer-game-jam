local BackgroundSpriteDrawingSystem = tiny.processingSystem()
BackgroundSpriteDrawingSystem.filter = tiny.requireAll('draw_background', 'sprite', 'x', 'y')
BackgroundSpriteDrawingSystem.is_draw_system = true
local default_offset = { x = 0, y = 0 }

function BackgroundSpriteDrawingSystem:initialize()
  self.images = {}
end
function BackgroundSpriteDrawingSystem:onAdd(e)
  if not self.images[e.sprite] then
    self.images[e.sprite] = love.graphics.newImage(e.sprite)
  end
end

function BackgroundSpriteDrawingSystem:process(e, dt)
  local x, y = e.x, e.y
  local sprite = self.images[e.sprite]
  local offset = e.sprite_offset or default_offset
  love.graphics.draw(sprite, x + offset.x, y + offset.y)
end

return BackgroundSpriteDrawingSystem
