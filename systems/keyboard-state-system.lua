local System = tiny.processingSystem()
local keyboard_events = tiny.requireAny('key_press', 'key_release')
System.filter = tiny.requireAll(keyboard_events, 'is_event')

function System:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
end

function System:onAdd(e)
  if e.key_press then
    self.keyboard_state:push(e.keycode)
  elseif e.key_release then
    self.keyboard_state:release(e.keycode)
  end
end

function System:postWrap(dt)
  self.keyboard_state:reset()
end

return System
