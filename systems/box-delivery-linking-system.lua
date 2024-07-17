local System = tiny.processingSystem()
System.filter = tiny.requireAny('is_box', 'is_delivery_stop')

function System:initialize(props)
  self.game_state = props.game_state --[[@as GameState]]
end

function System:onAdd(e)
  if e.is_box then
    self.game_state:add_box(e)
  elseif e.is_delivery_stop then
    self.game_state:add_delivery_stop(e)
  end
end

return System
