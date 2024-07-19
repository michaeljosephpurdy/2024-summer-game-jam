local AccidentSystem = tiny.processingSystem()
AccidentSystem.filter = tiny.requireAll('accident_type')

function AccidentSystem:initialize(props)
  self.entity_factory = props.entity_factory --[[@as EntityFactory]]
  self.game_state = props.game_state --[[@as GameState]]
end

function AccidentSystem:onAdd(e)
  if e.entity.accident_recorded then
    return
  end
  e.entity.accident_recorded = true
  if e.accident_type == 'BOX' then
    local crushed_box = self.entity_factory:build_single({
      x = e.entity.x,
      y = e.entity.y,
      rotation = e.entity.rotation,
      type = 'CRUSHED_BOX',
    })
    self.world:addEntity(crushed_box)
    self.world:removeEntity(e.entity)
    self.world:addEntity({
      is_dialogue = true,
      --@stylua: ignore
      messages = {
        "Dispatch: You're supposed" .. NEW_LINE .. 'to deliver them, NOT run  ' .. NEW_LINE .. 'them over!',
      },
      time = 3,
    })
  elseif e.accident_type == 'STOP_SIGN' then
    self.game_state.stop_sign_count = self.game_state.stop_sign_count - 1
    print(self.game_state.stop_sign_count .. ' stopsigns')
    local crushed = self.entity_factory:build_single({
      x = e.entity.x,
      y = e.entity.y,
      rotation = e.entity.rotation,
      type = 'CRUSHED_STOP_SIGN',
    })
    self.world:addEntity(crushed)
    self.world:removeEntity(e.entity)
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
  self.game_state:record_accident()
  self.world:removeEntity(e.entity)
end

return AccidentSystem
