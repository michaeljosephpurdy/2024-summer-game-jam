local SpriteDrawingSystem = tiny.processingSystem()
local rejection_filter = tiny.rejectAny('draw_foreground', 'draw_background')
local quad_filter = tiny.requireAny('texture', 'quad')
local sprite_or_quad_filter = tiny.requireAny('sprite', quad_filter)
SpriteDrawingSystem.filter = tiny.requireAll(rejection_filter, sprite_or_quad_filter, 'x', 'y')
SpriteDrawingSystem.is_draw_system = true
local default_offset = { x = 0, y = 0 }

function SpriteDrawingSystem:initialize()
  self.images = {}
end

function SpriteDrawingSystem:onAdd(e)
  if e.sprite then
    if not self.images[e.sprite] then
      self.images[e.sprite] = love.graphics.newImage(e.sprite)
    end
  end
end

function SpriteDrawingSystem:process(e, dt)
  if e.hidden then
    return
  end
  local sprite = e.image or self.images[e.sprite]
  local x, y = e.x, e.y
  local offset = e.sprite_offset or default_offset
  local origin_offset = e.origin_offset or 0
  local rotation = e.rotation or 0
  local scale = e.scale or 1
  if e.sprite then
    love.graphics.draw(
      self.images[e.sprite],
      x + offset.x,
      y + offset.y,
      rotation,
      scale,
      scale,
      origin_offset,
      origin_offset
    )
  elseif e.quad then
    love.graphics.draw(
      e.texture,
      e.quad,
      x + offset.x,
      y + offset.y,
      rotation,
      scale,
      scale,
      origin_offset,
      origin_offset
    )
  end
end

return SpriteDrawingSystem
