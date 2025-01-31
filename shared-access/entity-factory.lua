---@class EntityFactory
local EntityFactory = class('EntityFactory') --[[@as EntityFactory]]
---@enum EntityTypes
local EntityTypes = {
  PLAYER = 'PLAYER',
  AMAZON_TRUCK = 'AMAZON_TRUCK',
  TRUCK_COLLIDER = 'TRUCK_COLLIDER',
  PLAYER_SPAWN = 'PLAYER_SPAWN',
  INVISIBLE_COLLIDER = 'INVISIBLE_COLLIDER',
  VEHICLE_DOOR = 'VEHICLE_DOOR',
  TRUCK_BACK_DOOR = 'TRUCK_BACK_DOOR',
  BOX = 'BOX',
  CRUSHED_BOX = 'CRUSHED_BOX',
  BOX_TRIGGER = 'BOX_TRIGGER',
  STOP_SIGN = 'STOP_SIGN',
  CRUSHED_STOP_SIGN = 'CRUSHED_STOP_SIGN',
  DELIVERY_STOP = 'DELIVERY_STOP',
  INDICATOR = 'INDICATOR',
  WALKING_NPC = 'WALKING_NPC',
  --TRASH_CAN = 'TRASH_CAN',
}
EntityFactory.types = EntityTypes

local function random_npc_spritesheet()
  local i = math.random(1, 2)
  return {
    normal_idle_sprites = {
      love.graphics.newImage('assets/npc-' .. i .. '-idle.png'),
    },
    normal_walking_sprites = {
      love.graphics.newImage('assets/npc-' .. i .. '-walking-1.png'),
      love.graphics.newImage('assets/npc-' .. i .. '-walking-2.png'),
      love.graphics.newImage('assets/npc-' .. i .. '-walking-3.png'),
      love.graphics.newImage('assets/npc-' .. i .. '-walking-4.png'),
      love.graphics.newImage('assets/npc-' .. i .. '-walking-5.png'),
      love.graphics.newImage('assets/npc-' .. i .. '-walking-6.png'),
      love.graphics.newImage('assets/npc-' .. i .. '-walking-7.png'),
      love.graphics.newImage('assets/npc-' .. i .. '-walking-8.png'),
    },
    dead_sprite = love.graphics.newImage('assets/npc-' .. i .. '-dead.png'),
  }
end

---@private
---@type { [EntityTypes]: table }
EntityFactory.entities = {
  [EntityTypes.INVISIBLE_COLLIDER] = {
    collision_radius = 8,
    can_be_repelled = false,
  },
  [EntityTypes.INDICATOR] = {
    sprite = love.graphics.newImage('assets/indicator.png'),
    draw_ui = true,
    rotation = 0,
    z_index = 100,
  },
  [EntityTypes.STOP_SIGN] = {
    x = 0,
    y = 0,
    sprite = love.graphics.newImage('assets/stop-sign.png'),
    collision_radius = 4,
    origin_offset = 16,
    rotation = 0,
    draw_debug = true,
    lower_draw = true,
    can_repel = true,
    repel_force = 15,
    is_stop_sign = true,
    z_index = 100,
  },
  [EntityTypes.VEHICLE_DOOR] = {
    rotation = 0,
    collision_radius = 8,
    is_vehicle_door = true,
    is_trigger = true,
    revolve_around = true,
    pivot_offset = math.rad(-90),
    origin_offset = 16,
    draw_debug = true,
    z_index = 50,
  },
  [EntityTypes.TRUCK_BACK_DOOR] = {
    rotation = 0,
    collision_radius = 16,
    is_truck_back_door = true,
    is_trigger = true,
    revolve_around = true,
    pivot_offset = math.rad(-180),
    origin_offset = 32,
    draw_debug = true,
    boxes = {},
    z_index = 50,
  },
  [EntityTypes.CRUSHED_BOX] = {
    sprite = love.graphics.newImage('assets/box-crushed.png'),
    origin_offset = 8,
    lower_draw = true,
    z_index = -2,
  },
  [EntityTypes.CRUSHED_STOP_SIGN] = {
    sprite = love.graphics.newImage('assets/stop-sign-crushed.png'),
    origin_offset = 16,
    lower_draw = true,
    z_index = -2,
  },
  [EntityTypes.BOX] = {
    sprite = love.graphics.newImage('assets/box.png'),
    origin_offset = 8,
    rotation = 0,
    collision_radius = 5,
    is_box = true,
    revolve_around = true,
    pivot_offset = 0,
    lower_draw = true,
    debug_draw = true,
    can_be_repelled = true,
    repel_offset = 2,
    on_ground = true,
    z_index = -1,
  },
  [EntityTypes.BOX_TRIGGER] = {
    rotation = 0,
    collision_radius = 8,
    origin_offset = 0,
    draw_debug = true,
    revolve_around = true,
    pivot_offset = 0,
    is_trigger = true,
    can_be_repelled = false,
  },
  [EntityTypes.WALKING_NPC] = {
    is_character = true,
    x = 0,
    y = 0,
    dx = 0,
    dy = 0,
    sprite = love.graphics.newImage('assets/npc-1-idle.png'),
    animation_sprite = { love.graphics.newImage('assets/npc-1-idle.png') },
    animation_time = 1,
    walking_sprites_time = 10,
    animation_loop = true,
    normal_idle_sprites = true, -- will be randomized
    normal_walking_sprites = true, -- wil be randomized
    origin_offset = 16,
    rotation = 0,
    friction = 0.09,
    acceleration = 10,
    speed = 0,
    max_speed = 50,
    rotation_speed = 3,
    collision_radius = 8,
    revolve_around = true,
    pivot_offset = math.rad(-90),
    can_be_repelled = true,
    can_repel = true,
    repel_force = 3,
  },
  [EntityTypes.PLAYER] = {
    is_controllable = true,
    is_character = true,
    is_player = true,
    camera_follow = true,
    x = 50,
    y = 50,
    dx = 0,
    dy = 0,
    sprite = love.graphics.newImage('assets/player-idle.png'),
    animation_sprite = { love.graphics.newImage('assets/player-idle.png') },
    animation_time = 1,
    walking_sprites_time = 10,
    animation_loop = true,
    normal_idle_sprites = {
      love.graphics.newImage('assets/player-idle.png'),
    },
    carrying_idle_sprites = {
      love.graphics.newImage('assets/player-carrying-idle.png'),
    },
    carrying_walking_sprites = {
      love.graphics.newImage('assets/player-carrying-walking-1.png'),
      love.graphics.newImage('assets/player-carrying-walking-2.png'),
      love.graphics.newImage('assets/player-carrying-walking-3.png'),
      love.graphics.newImage('assets/player-carrying-walking-4.png'),
      love.graphics.newImage('assets/player-carrying-walking-5.png'),
      love.graphics.newImage('assets/player-carrying-walking-6.png'),
      love.graphics.newImage('assets/player-carrying-walking-7.png'),
      love.graphics.newImage('assets/player-carrying-walking-8.png'),
    },
    normal_walking_sprites = {
      love.graphics.newImage('assets/player-walking-1.png'),
      love.graphics.newImage('assets/player-walking-2.png'),
      love.graphics.newImage('assets/player-walking-3.png'),
      love.graphics.newImage('assets/player-walking-4.png'),
      love.graphics.newImage('assets/player-walking-5.png'),
      love.graphics.newImage('assets/player-walking-6.png'),
      love.graphics.newImage('assets/player-walking-7.png'),
      love.graphics.newImage('assets/player-walking-8.png'),
    },
    origin_offset = 16,
    rotation = 0,
    friction = 0.09,
    acceleration = 10,
    speed = 0,
    max_speed = 50,
    rotation_speed = 3,
    draw_debug = true,
    collision_detection_enabled = true,
    collision_radius = 8,
    revolve_around = true,
    pivot_offset = math.rad(-90),
    can_be_repelled = true,
    can_repel = true,
    repel_force = 3,
  },
  [EntityTypes.AMAZON_TRUCK] = {
    is_controllable = true,
    is_vehicle = true,
    is_truck = true,
    is_active = false,
    camera_follow = true,
    x = 150,
    y = 50,
    dx = 0,
    dy = 0,
    sprite = love.graphics.newImage('assets/player-truck-normal.png'),
    normal_sprite = love.graphics.newImage('assets/player-truck-normal.png'),
    driver_door_open_sprite = love.graphics.newImage('assets/player-truck-open-driver.png'),
    passenger_door_open_sprite = love.graphics.newImage('assets/player-truck-open-passenger.png'),
    trunk_door_open_sprite = love.graphics.newImage('assets/player-truck-open-trunk.png'),
    origin_offset = 32,
    rotation = 0,
    friction = 0.9,
    acceleration = 5,
    speed = 0,
    max_speed = 100,
    rotation_speed = 2,
    draw_debug = true,
    collision_detection_enabled = true,
    collision_radius = 16,
    upper_draw = true,
    repel_force = 30,
    can_repel = true,
    z_index = 50,
  },
  [EntityTypes.DELIVERY_STOP] = {
    xx = 0,
    yy = 0,
    collision_radius = 0,
    is_delivery_stop = true,
    sprite = love.graphics.newImage('assets/delivery-stop.png'),
    origin_offset = 32,
    rotation_speed = 2,
    lower_draw = true,
  },
  [EntityTypes.PLAYER_SPAWN] = {
    x = 0,
    y = 0,
    is_player_spawn = true,
  },
}

---@param e EntityTypes
---@return table
function EntityFactory:build(e)
  -- We're gonna do some weird overwriting of entity type here
  -- this is because during jam there was singular Entity object
  -- with inner entity type field
  -- Post-jam version though has different Entity object, which is
  -- helpful in LDtk because then fields (like 'path') can be on
  -- some entities and not all
  local type = e.id
  if type == 'Entity' then
    type = e.type
  end
  e.type = type
  local entity = self:build_single(e)
  entity.type = e.type
  if entity.is_player_spawn then
    local player = self:build_single({
      x = entity.x,
      y = entity.y,
      rotation = entity.rotation,
      is_active = true,
      type = 'PLAYER',
    })
    return { player }
  end
  -- if it's a box, we need to make an additional collider outside of the box
  -- to make sure player doesn't just push box around the whole time,
  -- and can actually pick it up
  if entity.is_box then
    entity.rotation = math.random() * 10
    local collider = self:build_single({
      x = entity.x,
      y = entity.y,
      type = 'BOX_TRIGGER',
      pivot_point = entity,
      trigger = entity,
    })
    entity.triggered_by = { collider }
    return { entity, collider }
  end
  -- if it's a vehicle, we need to add the door
  if entity.is_vehicle then
    local driver_door = self:build_single({
      x = entity.x,
      y = entity.y,
      rotation = entity.rotation,
      type = 'VEHICLE_DOOR',
      trigger = entity,
    })
    local passenger_door = self:build_single({
      x = entity.x,
      y = entity.y,
      rotation = entity.rotation,
      type = 'VEHICLE_DOOR',
      trigger = entity,
      pivot_offset = math.rad(90),
    })
    local back_door = self:build_single({
      x = entity.x,
      y = entity.y,
      rotation = entity.rotation,
      type = 'TRUCK_BACK_DOOR',
      trigger = entity,
    })
    entity.triggered_by = { driver_door, passenger_door, back_door }
    driver_door.pivot_point = entity
    passenger_door.pivot_point = entity
    back_door.pivot_point = entity
    entity.driver_door = driver_door
    entity.passenger_door = passenger_door
    entity.back_door = back_door
    driver_door.vehicle = entity
    passenger_door.vehicle = entity
    back_door.vehicle = entity
    return { entity, driver_door, passenger_door, back_door }
  end
  return { entity }
end

---@return table
function EntityFactory:build_single(e)
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
  new_entity.draw_debug = true
  if e.type == EntityTypes.WALKING_NPC then
    for k, v in pairs(random_npc_spritesheet()) do
      new_entity[k] = v
    end
  end
  return new_entity
end

return EntityFactory
