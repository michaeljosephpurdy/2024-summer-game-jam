local KeyPressEvent = class('KeyPressEvent')
KeyPressEvent.key_press = true
KeyPressEvent.is_event = true

function KeyPressEvent:initialize(keycode)
  self.keycode = keycode
end

return KeyPressEvent
