local KeyReleaseEvent = class('KeyReleaseEvent')
KeyReleaseEvent.key_release = true
KeyReleaseEvent.is_event = true

function KeyReleaseEvent:initialize(keycode)
  self.keycode = keycode
end

return KeyReleaseEvent
