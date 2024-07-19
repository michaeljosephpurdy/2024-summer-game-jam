local TileMapSystem = tiny.processingSystem()
TileMapSystem.filter = tiny.requireAll('is_event', 'load_tile_map')

function TileMapSystem:initialize(props)
  self.game_state = props.game_state --[[@as GameState]]
  self.ldtk = require('plugins.super-simple-ldtk')
  self.ldtk:init('world')
  self.ldtk:load_all()
  self.entity_factory = props.entity_factory --[[@as EntityFactory]]
  self.on_image = function(image)
    local image_data = {
      x = image.x,
      y = image.y,
      sprite = love.graphics.newImage(image.image),
      sprite_offset = { x = -8, y = -8 },
    }
    if image.layer == 'Background.png' then
      image_data.draw_background = true
    end
    if image.layer == 'Foreground.png' then
      image_data.draw_foreground = true
    end
    self.world:add(image_data)
  end
  self.on_tile = function(tile)
    if tile.value == 1 then
      self.world:add({
        x = tile.x,
        y = tile.y,
        is_solid = true,
        collision_radius = tile.width / 2,
        --draw_debug = true,
        is_tile = true,
      })
    end
  end

  self.on_entity = function(e)
    local entities = self.entity_factory:build(e)
    for _, entity in pairs(entities) do
      if entity.is_stop_sign then
        self.game_state.stop_sign_count = self.game_state.stop_sign_count + 1
      end
      self.world:add(entity)
    end
  end
end

function TileMapSystem:onAdd(e)
  --local level_id = '6b43f440-25d0-11ef-9316-835ad4ed59ca'
  local level_id = 'Level_0'
  self.ldtk:load(level_id, self.on_image, self.on_tile, self.on_entity)
end

return TileMapSystem
