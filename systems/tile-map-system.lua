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
      sprite = image.image,
      draw_background = true,
    })
  end
  self.on_tile = function(tile)
    if tile.value == 1 then
      self.world:add({
        x = tile.x,
        y = tile.y,
        hitbox = { width = tile.width, height = tile.height },
        is_solid = true,
        draw_debug = true,
      })
    end
  end
  self.on_entity = function(e)
    local entity = self.entity_factory:build(e)
    -- feels a little dirty sliding this in here but here it is
    if entity.is_player_spawn then
      local player = self.entity_factory:build('PLAYER')
      local truck = self.entity_factory:build('PLAYER_TRUCK')
      player.x, player.y, player.rotation = entity.x, entity.y, entity.rotation
      truck.x, truck.y, truck.rotation = entity.x, entity.y, entity.rotation
      self.world:add(player)
      self.world:add(truck)
      return
    end
    self.world:add(entity)
  end
end

function TileMapSystem:onAdd(e)
  --local level_id = '6b43f440-25d0-11ef-9316-835ad4ed59ca'
  local level_id = 'Level_0'
  self.ldtk:load(level_id, self.on_image, self.on_tile, self.on_entity)
end

return TileMapSystem
