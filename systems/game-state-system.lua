local GameStateSystem = tiny.system()

function GameStateSystem:initialize(props)
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

function GameStateSystem:update(dt)
  if not self.game_state:are_controls_locked() then
    self.game_state:progress_time(dt)
    if self.game_state:is_game_over() then
      self.world:clearEntities()
      self.game_state:toggle_controls()
      self.world:addEntity({
        is_dialogue = true,
        -- stylua: ignore
        messages = {
            'Thanks for playing!',
            tostring(self.game_state.max_days - self.game_state.last_accident).. ' Days Since Last Accident',
            tostring(self.game_state.max_days - self.game_state.last_accident).. ' Days Since Last Accident' ..NEW_LINE..
            'You delivered '..self.game_state.delivered.. 'packages',
            tostring(self.game_state.max_days - self.game_state.last_accident).. ' Days Since Last Accident' ..NEW_LINE..
            'You delivered '..self.game_state.delivered.. 'packages'..NEW_LINE..
            'You made $'..self.game_state.money,
        },
        time = 3,
        on_complete = function()
          self.world:clearEntities()
        end,
      })
    end
  end

  --
  love.graphics.push()
  love.graphics.origin()
  love.graphics.setColor(self.text_color_r, self.text_color_g, self.text_color_b)
  --love.graphics.setColor(self.rect_color_r, self.rect_color_g, self.rect_color_b)
  --love.graphics.rectangle('fill', 0, y, GAME_WIDTH, e.height)

  -- stylua: ignore start
  love.graphics.print( self.game_state.last_accident .. ' Days Since Last Accident', self.font, 10, 10)
  love.graphics.print('Deliveries: ' .. self.game_state.delivered, self.font, 10, 20)
  love.graphics.print('Money: $' .. self.game_state.money, self.font, 10, 30)
  love.graphics.print(self.game_state.hours .. ':' .. math.floor(self.game_state.minutes), self.font, 10, 40)
  love.graphics.print('Next Delivery: '..self.game_state.delivery_direction, self.font, 10, GAME_HEIGHT - 20)
  -- stylua: ignore end
  love.graphics.pop()
end

return GameStateSystem
