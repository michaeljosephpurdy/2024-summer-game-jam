local DialogueSystem = tiny.processingSystem()
DialogueSystem.filter = tiny.requireAll('is_dialogue')

function DialogueSystem:initialize(props)
  self.keyboard_state = props.keyboard_state --[[@as KeyboardState]]
  self.game_state = props.game_state --[[@as GameState]]

  self.font = love.graphics.newFont('assets/RobotoMono-Regular.ttf', 10, 'mono')
  self.font:setFilter('nearest', 'nearest')

  self.text_color_r = 244 / 255
  self.text_color_g = 244 / 255
  self.text_color_b = 244 / 255
  self.rect_color_r = 41 / 255
  self.rect_color_g = 54 / 255
  self.rect_color_b = 111 / 255
end

local function count_lines(base)
  return select(2, string.gsub(base, string.char(10), '')) + 1
end

function DialogueSystem:onAdd(e)
  e.message_index = 0
  self:next_message(e)
  if not e.time then
    self.game_state:toggle_controls()
  end
end

function DialogueSystem:next_message(e)
  e.current_time = 0
  e.message_index = e.message_index + 1
  e.current_message = e.messages[e.message_index]
  if e.current_message then
    e.offset = self.font:getWidth(e.current_message) / 2
    e.height = self.font:getHeight(e.current_message) * count_lines(e.current_message)
  end
  return e.current_message
end

function DialogueSystem:process(e, dt)
  if e.time then
    e.current_time = e.current_time + dt
    if e.current_time > e.time then
      if not self:next_message(e) then
        self.world:remove(e)
        return
      end
    end
  else
    if self.keyboard_state:is_key_just_released('space') then
      if not self:next_message(e) then
        self.world:remove(e)
        return
      end
    end
  end
  local x = (e.x or GAME_WIDTH / 2) - e.offset
  local y = e.y or 10
  love.graphics.push()
  love.graphics.origin()
  love.graphics.setColor(self.rect_color_r, self.rect_color_g, self.rect_color_b)
  love.graphics.rectangle('fill', 0, y, GAME_WIDTH, e.height)
  love.graphics.setColor(self.text_color_r, self.text_color_g, self.text_color_b)
  love.graphics.print(e.current_message, self.font, x, y)
  love.graphics.pop()
end

function DialogueSystem:onRemove(e)
  if not e.time then
    self.game_state:toggle_controls()
  end
  if e.on_complete then
    e:on_complete()
  end
end

return DialogueSystem
