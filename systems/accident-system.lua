local AccidentSystem = tiny.processingSystem()
AccidentSystem.filter = tiny.requireAll('accident_type')

function AccidentSystem:initialize(props)
  self.entity_factory = props.entity_factory --[[@as EntityFactory]]
  self.game_state = props.game_state --[[@as GameState]]
end

function AccidentSystem:onAdd(e)
  local entity = e.entity
  if entity.accident_recorded then
    return
  end
  -- TODO: There is likely a better place to put this logic
  if entity.triggered_by then
    for _, trigger in pairs(entity.triggered_by) do
      self.world:removeEntity(trigger)
    end
  end
  entity.accident_recorded = true
  self.game_state:record_accident()
  local publish_message = true
  if self.game_state.accidents == 1 then
    self.world:addEntity({
      is_dialogue = true,
      --@stylua: ignore
      messages = {
        'Dispatch: Ugh...',
        'Dispatch: There goes the' .. NEW_LINE .. 'pizza party.',
      },
      time = 3,
    })
    publish_message = false
  end
  if e.accident_type == 'PERSON' then
    self.world:addEntity({
      sprite = entity.dead_sprite,
      x = entity.x,
      y = entity.y,
      sprite_offset = entity.sprite_offset,
      origin_offset = entity.origin_offset,
      rotation = entity.rotation,
      draw_lower = true,
    })
    self.world:removeEntity(entity)
    self.world:addEntity({
      is_dialogue = true,
      --@stylua: ignore
      messages = {
        'Dispatch: Holy shit!',
        'Dispatch: Are they okay?!',
      },
      time = 2,
    })
  elseif e.accident_type == 'BOX' then
    local crushed_box = self.entity_factory:build_single({
      x = entity.x,
      y = entity.y,
      rotation = entity.rotation,
      type = 'CRUSHED_BOX',
    })
    self.world:addEntity(crushed_box)
    self.world:removeEntity(entity)
    if publish_message then
      self.world:addEntity({
        is_dialogue = true,
        --@stylua: ignore
        messages = {
          "Dispatch: You're supposed" .. NEW_LINE .. 'to deliver them, NOT run  ' .. NEW_LINE .. 'them over!',
        },
        time = 3,
      })
    end
  elseif e.accident_type == 'STOP_SIGN' then
    self.game_state.stop_sign_count = self.game_state.stop_sign_count - 1
    print(self.game_state.stop_sign_count .. ' stopsigns')
    local crushed = self.entity_factory:build_single({
      x = entity.x,
      y = entity.y,
      rotation = entity.rotation,
      type = 'CRUSHED_STOP_SIGN',
    })
    self.world:addEntity(crushed)
    self.world:removeEntity(entity)
    if publish_message then
      if self.game_state.stop_sign_count > 0 then
        self.world:addEntity({
          is_dialogue = true,
          --@stylua: ignore
          messages = {
            'Dispatch: Not the stop sign...',
          },
          time = 3,
        })
      else
        self.world:addEntity({
          is_dialogue = true,
          --@stylua: ignore
          messages = {
            "Dispatch: I can't believe" .. NEW_LINE .. 'you knocked them all down',
          },
          time = 3,
        })
      end
    end
  end
  self.world:removeEntity(entity)
end

return AccidentSystem
