local DeliveryDetectionSystem = tiny.processingSystem()
DeliveryDetectionSystem.filter = tiny.requireAll('is_delivery_stop')

function DeliveryDetectionSystem:initialize(props)
  self.collision_grid = props.collision_grid --[[@as CollisionGrid]]
  self.game_state = props.game_state --[[@as GameState]]
end

function DeliveryDetectionSystem:onAdd(e)
  self.collision_grid:register(e)
end

function DeliveryDetectionSystem:process(e, dt)
  e.hidden = e ~= self.game_state:get_current_destination()
  e.rotation = e.rotation + e.rotation_speed * dt
  e.scale = math.sin(e.rotation) / 8 + 1
  e.xx, e.yy = e.x + 1, e.y + 1
  local overlapping_entities = self.collision_grid:query(e.x, e.y)
  for _, entity in pairs(overlapping_entities) do
    if entity.is_box and entity.is_active == true and entity.linked == e and not entity.is_delivered then
      entity.is_delivered = true
      self.game_state:increment_delivered()
      self.world:remove(e)
    end
  end
end

return DeliveryDetectionSystem
