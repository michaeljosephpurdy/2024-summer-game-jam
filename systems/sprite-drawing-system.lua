local SpriteDrawingSystem = tiny.sortedProcessingSystem()
SpriteDrawingSystem.filter = tiny.requireAll('sprite', 'x', 'y')

local default_offset = { x = 0, y = 0 }

function SpriteDrawingSystem:initialize()
  self.ordered_sprites = {}
end

function SpriteDrawingSystem:compare(e1, e2)
  return (e1.z_index or 0) < (e2.z_index or 0)
end

function SpriteDrawingSystem:process(sprite, dt)
  if sprite.hidden then
    return
  end
  local x, y = sprite.x, sprite.y
  local offset = sprite.sprite_offset or default_offset
  local origin_offset = sprite.origin_offset or 0
  local rotation = sprite.rotation or 0
  local scale = sprite.scale or 1
  love.graphics.draw(sprite.sprite, x + offset.x, y + offset.y, rotation, scale, scale, origin_offset, origin_offset)
end

return SpriteDrawingSystem
