local CharacterInteractionSystem = tiny.processingSystem()
CharacterInteractionSystem.filter = tiny.requireAll('is_character')

function CharacterInteractionSystem:initialize(props)
  self.game_state = props.game_state --[[@as GameState]]
end

function CharacterInteractionSystem:process(e, _)
  if e.move_forward or e.move_backward then
    if e.is_carrying_box then -- walking with box
      e.animation_sprite = e.carrying_walking_sprites
      -- TODO: half the animation time due to slower walking?
      if e.move_backward then
        e.animation_time = -e.walking_sprites_time
      else
        e.animation_time = e.walking_sprites_time
      end
    else -- walking without box
      e.animation_sprite = e.normal_walking_sprites
      e.animation_time = e.walking_sprites_time
    end
  else
    if e.is_carrying_box then -- idle with box
      e.animation_sprite = e.carrying_idle_sprites
      e.animation_time = 0
    else -- idle without box
      e.animation_sprite = e.normal_idle_sprites
      e.animation_time = 0
    end
  end
end

return CharacterInteractionSystem
