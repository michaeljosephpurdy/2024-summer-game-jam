local ScreenResizeEvent = class('ScreenResizeEvent')
ScreenResizeEvent.resize = true
ScreenResizeEvent.is_event = true

function ScreenResizeEvent:initialize(width, height)
  self.width = width
  self.height = height
end

return ScreenResizeEvent
