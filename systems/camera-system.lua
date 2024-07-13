local CameraSystem = tiny.processingSystem()
CameraSystem.filter = tiny.requireAny('camera_follow', 'screen_shake', 'resize')
CameraSystem.is_draw_system = true

local function lerp(a, b, t)
  return a + (b - a) * t
end

function CameraSystem:initialize()
  self.push = require('plugins.push')
  local windowWidth, windowHeight = love.graphics.getDimensions()
  self.push:setupScreen(GAME_WIDTH, GAME_HEIGHT, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = true,
  })
  self.push:resize(windowWidth, windowHeight)
  self.push:setBorderColor(PALETTE.BACKGROUND)
  self.x = 0
  self.y = 0
  self.offset_x = -GAME_WIDTH / 2
  self.offset_y = -GAME_HEIGHT / 2
  -- boundaries -- TODO: stop hardcoding
  self.top_boundary = 0
  self.bot_boundary = 1000
  self.left_boundary = 0
  self.right_boundary = 1000
end

function CameraSystem:preWrap(dt)
  self.push:start()
end

function CameraSystem:postWrap(dt)
  self.push:finish()
end

function CameraSystem:onAdd(e)
  if e.resize and e.is_event then
    self.push:resize(e.width, e.height)
  end
end

function CameraSystem:process(e, dt)
  if e.camera_follow and e.is_active then
    self.old_x = self.x
    self.old_y = self.y
    self.x = e.x + self.offset_x
    self.y = e.y + self.offset_y
    local camera_offset_x = 0
    local camera_offset_y = 0
    -- only apply offset if player is driving the truck
    --if e.is_truck then
    -- camera_offset_x = e.dx * 10
    --camera_offset_y = e.dy * 10
    --end
    -- build x
    self.x = self.x + camera_offset_x
    if e.x + camera_offset_x >= self.right_boundary - GAME_WIDTH / 2 then
      self.x = self.right_boundary - GAME_WIDTH
    elseif e.x + camera_offset_x <= self.left_boundary + GAME_WIDTH / 2 then
      self.x = self.left_boundary
    end
    self.x = lerp(self.old_x, self.x, 4 * dt)
    -- build y
    self.y = self.y + camera_offset_y
    if e.y >= self.bot_boundary - GAME_HEIGHT / 2 then
      self.y = self.bot_boundary - GAME_HEIGHT
    elseif e.y <= self.top_boundary + GAME_HEIGHT / 2 then
      self.y = self.top_boundary
    end
    self.y = lerp(self.old_y, self.y, 25 * dt)
    love.graphics.translate(-self.x, -self.y)
  end
  if e.screen_shake then
    local shake = love.math.newTransform()
    shake:translate(love.math.random(-e.magnitude, e.magnitude), love.math.random(-e.magnitude, e.magnitude))
    love.graphics.applyTransform(shake)
  end
end

return CameraSystem
