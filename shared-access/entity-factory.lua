---@class EntityFactory
local EntityFactory = class('EntityFactory') --[[@as EntityFactory]]
---@enum EntityTypes
local EntityTypes = {
  PLAYER = 'PLAYER',
  PLAYER_TRUCK = 'PLAYER_TRUCK',
  PLAYER_SPAWN = 'PLAYER_SPAWN',
  STATIONARY_TRUCK = 'STATIONARY_TRUCK',
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
    origin_offset = 16,
    rotation = 0,
    friction = 0.09,
    acceleration = 10,
    speed = 0,
    max_speed = 50,
    rotation_speed = 0.1,
    hitbox = { width = 16, height = 16 },
    draw_debug = true,
    collision_detection_enabled = true,
    collision_radius = 8,
  },
  [EntityTypes.STATIONARY_TRUCK] = {
    sprite = 'assets/player-truck.png',
    rotation = 0,
    hitbox = { width = 24, height = 52 },
    origin_offset = 32,
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
    origin_offset = 32,
    rotation = 0,
    friction = 0.9,
    acceleration = 5,
    speed = 0,
    max_speed = 100,
    rotation_speed = 0.025,
    hitbox = { width = 24, height = 52 },
    draw_debug = true,
    collision_detection_enabled = true,
    collision_radius = 16,
  },
  [EntityTypes.PLAYER_SPAWN] = {
    x = 0,
    y = 0,
    is_player_spawn = true,
  },
}

---@param type EntityTypes | string
---@return table
function EntityFactory:build(e)
  if type(e) == 'string' then
    local new_entity = {}
    for k, v in pairs(self.entities[e]) do
      new_entity[k] = v
    end
    return new_entity
  end

  if not self.entities[e.type] then
    print('NO ENTITY FOUND FOR TYPE: ' .. e.type)
    return {}
  end
  local new_entity = {}
  for k, v in pairs(self.entities[e.type]) do
    new_entity[k] = v
  end
  for k, v in pairs(e) do
    new_entity[k] = v
  end
  return new_entity
end

return EntityFactory
