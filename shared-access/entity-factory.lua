---@class EntityFactory
local EntityFactory = class('EntityFactory') --[[@as EntityFactory]]
---@enum EntityTypes
local EntityTypes = {
  PLAYER = 'PLAYER',
  AMAZON_TRUCK = 'AMAZON_TRUCK',
  PLAYER_TRUCK = 'PLAYER_TRUCK',
  PLAYER_SPAWN = 'PLAYER_SPAWN',
  STATIONARY_TRUCK = 'STATIONARY_TRUCK',
  INVISIBLE_COLLIDER = 'INVISIBLE_COLLIDER',
}
EntityFactory.types = EntityTypes

---@private
---@type { [Entity]: table }
EntityFactory.entities = {
  [EntityTypes.INVISIBLE_COLLIDER] = {
    collision_radius = 8,
  },
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
    draw_debug = true,
    collision_detection_enabled = true,
    collision_radius = 8,
    revolve_around = true,
  },
  [EntityTypes.AMAZON_TRUCK] = {
    is_vehicle = true,
    is_truck = true,
    is_active = false,
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

---@param e EntityTypes | string
---@return table
function EntityFactory:build(e)
  if type(e) == 'string' then
    if not self.entities[e] then
      print('NO ENTITY FOUND FOR TYPE: ' .. e)
      return {}
    end
    local new_entity = {}
    for k, v in pairs(self.entities[e]) do
      new_entity[k] = v
    end
    new_entity.type = e
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
  new_entity.type = e.type
  return new_entity
end

return EntityFactory
