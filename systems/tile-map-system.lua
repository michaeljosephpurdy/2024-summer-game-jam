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
    local entity = self.entity_factory:build(e)
    -- feels a little dirty sliding this in here but here it is
    if entity.is_player_spawn then
      local player = self.entity_factory:build('PLAYER')
      player.x, player.y, player.rotation = entity.x, entity.y, entity.rotation
      player.is_active = true
      self.world:add(player)
      return
    end
    -- if it's a vehicle, we need to add the door
    if entity.is_vehicle then
      local door = self.entity_factory:build('VEHICLE_DOOR')
      door.x, door.y, door.rotation = entity.x, entity.y, entity.rotation
      door.pivot_point = entity
      entity.door = door
      door.vehicle = entity
      self.world:add(entity)
      self.world:add(door)
      -- add door
      return
    end

    -- if it's a truck, we need to add a back door to get/store boxes
    if entity.is_truck then
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
