---@class EntityFactory
local EntityFactory = class('EntityFactory') --[[@as EntityFactory]]
---@enum EntityTypes
local EntityTypes = {
  PLAYER = 'PLAYER',
  PLAYER_TRUCK = 'PLAYER_TRUCK',
}
EntityFactory.types = EntityTypes

---@private
---@type { [EntityTypes]: table }
EntityFactory.entities = {
  [EntityTypes.PLAYER] = {
    is_player = true,
    camera_follow = true,
    x = 50,
    y = 50,
    dx = 0,
    dy = 0,
    sprite = 'assets/player.png',
    sprite_offset = { x = 8, y = 8 },
    rotation = 0,
    friction = 0.09,
    acceleration = 10,
    speed = 0,
    max_speed = 50,
    rotation_speed = 0.1,
    hitbox = { width = 16, height = 16 },
    draw_debug = true,
    collision_detection_enabled = true,
  },
  [EntityTypes.PLAYER_TRUCK] = {
    is_player = true,
    is_truck = true,
    is_active = true,
    camera_follow = true,
    x = 150,
    y = 50,
    dx = 0,
    dy = 0,
    sprite = 'assets/player-truck.png',
    sprite_offset = { x = 12, y = 24 },
    rotation = 0,
    friction = 0.9,
    acceleration = 5,
    speed = 0,
    max_speed = 100,
    rotation_speed = 0.05,
    hitbox = { width = 24, height = 52 },
    draw_debug = true,
    collision_detection_enabled = true,
  },
}

---@param type EntityTypes
---@return table
function EntityFactory:build(type)
  local new_entity = {}
  for k, v in pairs(self.entities[type]) do
    new_entity[k] = v
  end
  return new_entity
end

return EntityFactory
