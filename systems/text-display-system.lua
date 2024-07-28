local TextDisplaySystem = tiny.processingSystem()
TextDisplaySystem.filter = tiny.requireAll('is_text', 'x', 'y')

function TextDisplaySystem:initialize(props)
  self.font = love.graphics.newFont('assets/RobotoMono-Regular.ttf', 10, 'mono')
  self.font:setFilter('nearest', 'nearest')

  self.text_color_r = 244 / 255
  self.text_color_g = 244 / 255
  self.text_color_b = 244 / 255
end

function TextDisplaySystem:process(e, dt)
  e.offset_x = self.font:getWidth(e.text) / 2
  e.offset_y = self.font:getHeight(e.text) / 2
  local x = e.x - e.offset_x
  local y = e.y - e.offset_y
  love.graphics.push()
  love.graphics.setColor(self.text_color_r, self.text_color_g, self.text_color_b)
  love.graphics.print(e.text, self.font, x, y)
  love.graphics.pop()
end

return TextDisplaySystem
