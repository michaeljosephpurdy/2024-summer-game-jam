local TileMapSystem = tiny.processingSystem()
TileMapSystem.filter = tiny.requireAll('is_event', 'load_tile_map')

function TileMapSystem:initialize()
  self.ldtk = require('plugins.super-simple-ldtk')
  self.ldtk:init('world')
  self.ldtk:load_all()
  self.on_image = function(image)
    self.world:add({
      x = image.x,
      y = image.y,
      sprite = image.image,
      draw_background = true,
    })
    print('on_image')
  end
  self.on_tile = function(tile)
    print('on_tile')
  end
  self.on_entity = function(entity)
    print('on_entity')
  end
end

function TileMapSystem:onAdd(e)
  --local level_id = '6b43f440-25d0-11ef-9316-835ad4ed59ca'
  local level_id = 'Level_0'
  self.ldtk:load(level_id, self.on_image, self.on_tile, self.on_entity)
end

return TileMapSystem
