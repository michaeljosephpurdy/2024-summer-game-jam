local DeliveryIndicatorSystem = tiny.processingSystem()
DeliveryIndicatorSystem.filter = tiny.requireAll('is_delivery_stop')

function DeliveryIndicatorSystem:initialize(props)
  self.game_state = props.game_state --[[@as GameState]]
  self.camera_state = props.camera_state --[[@as CameraState]]
  local entity_factory = props.entity_factory --[[@as EntityFactory]]
  self.indicator = entity_factory:build({ type = 'INDICATOR' })[1]
end

function DeliveryIndicatorSystem:onAddToWorld(world)
  world:add(self.indicator)
end

local function overlaps(rect1, rect2)
  return rect1.xx > rect2.x and rect1.x < rect2.xx and rect1.yy > rect2.y and rect1.y < rect2.yy
end

function DeliveryIndicatorSystem:process(e, dt)
  local destination = self.game_state:get_current_destination()
  if e ~= destination then
    return
  end
  local destination_on_screen = overlaps(self.camera_state:get_screen_rect(), e)
  self.indicator.is_hidden = destination_on_screen

  -- if the item is on the screen (can do distance check)
  --   then don't do anything
  -- if it's not on the screen
  --   calculate dx and dy from player to point to delivery stop
  --   create new entity w/ time_to_live of 0 (or a regular entity I guess and populate)
  --
  --local angle = math.atan2(other.y - e.y, other.x - e.x)
  --e.repel_force_dx = e.repel_force_dx + math.cos(angle) * repel_force * power_from_other
  --e.repel_force_dy = e.repel_force_dy + math.sin(angle) * repel_force * power_from_other
end

return DeliveryIndicatorSystem
