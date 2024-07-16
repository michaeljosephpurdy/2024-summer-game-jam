local TileMapSystem = tiny.processingSystem()
TileMapSystem.filter = tiny.requireAll('is_event', 'load_tile_map')

function TileMapSystem:initialize(props)
  self.ldtk = require('plugins.super-simple-ldtk')
  self.ldtk:init('world')
  self.ldtk:load_all()
  self.entity_factory = props.entity_factory --[[@as EntityFactory]]
  self.on_image = function(image)
    self.world:add({
      x = image.x,
      y = image.y,
      sprite = love.graphics.newImage(image.image),
      sprite_offset = { x = -8, y = -8 },
      draw_background = true,
    })
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
