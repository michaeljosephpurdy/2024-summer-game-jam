local GameStateDrawingSystem = tiny.system()

function GameStateDrawingSystem:initialize(props)
  self.game_state = props.game_state --[[@as GameState]]

  self.font = love.graphics.newFont('assets/RobotoMono-Regular.ttf', 8, 'mono')
  self.font:setFilter('nearest', 'nearest')

  self.text_color_r = 244 / 255
  self.text_color_g = 244 / 255
  self.text_color_b = 244 / 255
  self.rect_color_r = 41 / 255
  self.rect_color_g = 54 / 255
  self.rect_color_b = 111 / 255
end

function GameStateDrawingSystem:update(dt)
  love.graphics.push()
  love.graphics.origin()
  --love.graphics.setColor(self.rect_color_r, self.rect_color_g, self.rect_color_b)
  --love.graphics.rectangle('fill', 0, y, GAME_WIDTH, e.height)
  love.graphics.setColor(self.text_color_r, self.text_color_g, self.text_color_b)
  love.graphics.print('Packages: ' .. self.game_state.delivered, self.font, 10, 10)
  love.graphics.pop()
end

return GameStateDrawingSystem
