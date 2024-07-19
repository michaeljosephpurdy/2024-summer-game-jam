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
  self.is_done = false
end

function GameStateSystem:update(dt)
  if not self.game_state:are_controls_locked() then
    self.game_state:progress_time(dt)
    if self.game_state:is_game_over() and not self.is_done then
      self.is_done = true
      local end_message = 'Dispatcher: Try better next' .. NEW_LINE .. 'time.'
      if self.game_state.last_accident == 0 then
        end_message = 'Dispatcher: Time for pizza!'
      end
      self.world:addEntity({
        is_dialogue = true,
        -- stylua: ignore
        messages = {
          'Dispatcher: Alright, that\'s '..NEW_LINE..'it for the day.',
          end_message
        },
        time = 3,
        on_complete = function()
          self.world:clearEntities()
          self.game_state:toggle_controls()
          self.world:addEntity({
            is_dialogue = true,
            -- stylua: ignore
            messages = {
                'Thanks for playing!',
                'Thanks for playing!'..NEW_LINE..
                tostring(self.game_state.days - self.game_state.last_accident).. ' Days Since Last Accident',

                'Thanks for playing!'..NEW_LINE..
                tostring(self.game_state.max_days - self.game_state.last_accident).. ' Days Since Last Accident' ..NEW_LINE..
                'You delivered '..self.game_state.delivered.. ' packages',

                'Thanks for playing!'..NEW_LINE..
                tostring(self.game_state.max_days - self.game_state.last_accident).. ' Days Since Last Accident' ..NEW_LINE..
                'You delivered '..self.game_state.delivered.. ' packages'..NEW_LINE..
                'You made $'..self.game_state.money,

                'Thanks for playing!'..NEW_LINE..
                tostring(self.game_state.max_days - self.game_state.last_accident).. ' Days Since Last Accident' ..NEW_LINE..
                'You delivered '..self.game_state.delivered.. ' packages'..NEW_LINE..
                'You made $'..self.game_state.money..NEW_LINE..
                'You caused '..self.game_state.accidents..' accidents',

                'Thanks for playing!'..NEW_LINE..
                tostring(self.game_state.max_days - self.game_state.last_accident).. ' Days Since Last Accident' ..NEW_LINE..
                'You delivered '..self.game_state.delivered.. ' packages'..NEW_LINE..
                'You made $'..self.game_state.money..NEW_LINE..
                'You caused '..self.game_state.accidents..' accidents'..
                NEW_LINE..NEW_LINE..NEW_LINE..NEW_LINE..
                'game by Mike Purdy',
            },
            time = 2,
            on_complete = function()
              self.world:clearEntities()
            end,
          })
        end,
      })
    end
  end

  if self.game_state:is_game_over() then
    return
  end
  --
  love.graphics.push()
  love.graphics.origin()
  love.graphics.setColor(self.text_color_r, self.text_color_g, self.text_color_b)
  --love.graphics.setColor(self.rect_color_r, self.rect_color_g, self.rect_color_b)
  --love.graphics.rectangle('fill', 0, y, GAME_WIDTH, e.height)

  -- stylua: ignore start
  love.graphics.print( tostring(self.game_state.days - self.game_state.last_accident) .. ' Days Since Last Accident', self.font, 10, 10)
  love.graphics.print('Deliveries: ' .. self.game_state.delivered, self.font, 10, 20)
  love.graphics.print('Money: $' .. self.game_state.money, self.font, 10, 30)
  local display_hours = tostring(self.game_state.hours)
  if display_hours == '0' then display_hours = '00'
  end
  local display_minutes = tostring(math.floor(self.game_state.minutes))
  if display_minutes == '0' then display_minutes = '00'
  end
  love.graphics.print(display_hours .. ':' .. display_minutes, self.font, 10, 40)
  if self.game_state:get_current_destination() then
  love.graphics.print('Next Delivery: '..self.game_state.delivery_direction, self.font, 10, GAME_HEIGHT - 20)
  end
  -- stylua: ignore end
  love.graphics.pop()
end

return GameStateSystem
