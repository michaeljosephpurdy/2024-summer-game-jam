local SpriteAnimatingSystem = tiny.processingSystem()
SpriteAnimatingSystem.filter = tiny.requireAll('animation_sprite', 'animation_time')

function SpriteAnimatingSystem:onAdd(e)
  e.current_frame = 1
end

function SpriteAnimatingSystem:process(e, dt)
  if e.old_animation_sprite ~= e.animation_sprite then
    e.current_frame = 1
  end
  local frame = e.current_frame + (e.animation_time * dt)
  -- are in incrementing?
  if e.animation_time > 0 then
    if frame >= #e.animation_sprite then
      if e.animation_loop then
        frame = 1
      else
        frame = #e.animation_sprite
      end
    end
  -- or are we decrementing?
  elseif e.animation_time < 0 then
    if frame <= 1 then
      if e.animation_loop then
        frame = #e.animation_sprite
      else
        frame = 1
      end
    end
  end
  e.sprite = e.animation_sprite[math.floor(frame)]
  e.old_animation_sprite = e.animation_sprite
  e.current_frame = frame
end

return SpriteAnimatingSystem
