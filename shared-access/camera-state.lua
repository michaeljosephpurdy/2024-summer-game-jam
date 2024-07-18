---@class CameraState
local CameraState = class('CameraState') --[[@as CameraState]]

function CameraState:initialize()
  self.screen_x = 0
  self.screen_y = 0
  self.screen_xx = 0
  self.screen_yy = 0
end

function CameraState:set_screen_rect(x, y, xx, yy)
  self.screen_x = x
  self.screen_y = y
  self.screen_xx = xx
  self.screen_yy = yy
end

function CameraState:get_screen_rect()
  return { x = self.screen_x, y = self.screen_y, xx = self.screen_xx, yy = self.screen_yy }
end

return CameraState
