---@class CollisionGrid
local CollisionGrid = class('CollisionGrid') --[[@as CollisionGrid]]

function CollisionGrid:initialize(cell_size, width, height)
  self.grid = {}
  local offset = 5
  for y = -offset, width + offset, 1 do
    self.grid[y] = {}
    for x = -offset, height + offset, 1 do
      self.grid[y][x] = {}
    end
  end
  self.width = width
  self.height = height
  self.cell_size = cell_size
  -- cell_offset is needed because sprites in this game are rotated
  -- around artifical origin point at center of sprite.
  -- Typically we _draw_ an offset, and keep the collisions at
  -- the true x, y position.
  -- However, in this case, drawing at offset makes rotation
  -- calculation very difficult.  So, instead we'll apply this
  -- offset on the collision grid directly
  self.cell_offset = cell_size / 4
end

function CollisionGrid:to_grid(x, y)
  return math.floor((x + self.cell_offset) / self.cell_size), math.floor((y + self.cell_offset) / self.cell_size)
end

function CollisionGrid:get_rect(entity)
  local grid_x, grid_y = self:to_grid(entity.x, entity.y)
  return { x = grid_x * self.cell_size, y = grid_y * self.cell_size, width = self.cell_size, height = self.cell_size }
end

function CollisionGrid:register(entity)
  local grid_x, grid_y = self:to_grid(entity.x, entity.y)
  table.insert(self.grid[grid_y][grid_x], entity)
end

function CollisionGrid:remove(entity)
  local grid_x, grid_y = self:to_grid(entity.x, entity.y)
  for i, ent in ipairs(self.grid[grid_y][grid_x]) do
    if ent == entity then
      table.remove(self.grid[grid_y][grid_x], i)
    end
  end
end

function CollisionGrid:update(entity, new_x, new_y)
  local grid_x, grid_y = self:to_grid(entity.x, entity.y)
  local new_grid_x, new_grid_y = self:to_grid(new_x, new_y)
  -- do nothing if grid has not changed
  if grid_x == new_grid_x and grid_y == new_grid_y then
    return
  end
  for i, ent in ipairs(self.grid[grid_y][grid_x]) do
    if ent == entity then
      table.remove(self.grid[grid_y][grid_x], i)
    end
  end
  table.insert(self.grid[new_grid_y][new_grid_x], entity)
end

function CollisionGrid:single_query(x, y)
  local grid_x, grid_y = self:to_grid(x, y)
  return self.grid[grid_y][grid_x]
end
function CollisionGrid:query(x, y)
  local entities = {}
  local grid_x, grid_y = self:to_grid(x, y)
  -- Uh... is all this looping going to be okay?
  for _, ent in pairs(self.grid[grid_y - 1][grid_x - 1]) do
    table.insert(entities, ent)
  end
  for _, ent in pairs(self.grid[grid_y - 1][grid_x]) do
    table.insert(entities, ent)
  end
  for _, ent in pairs(self.grid[grid_y - 1][grid_x + 1]) do
    table.insert(entities, ent)
  end
  for _, ent in pairs(self.grid[grid_y][grid_x - 1]) do
    table.insert(entities, ent)
  end
  for _, ent in pairs(self.grid[grid_y][grid_x]) do
    table.insert(entities, ent)
  end
  for _, ent in pairs(self.grid[grid_y][grid_x + 1]) do
    table.insert(entities, ent)
  end
  for _, ent in pairs(self.grid[grid_y + 1][grid_x - 1]) do
    table.insert(entities, ent)
  end
  for _, ent in pairs(self.grid[grid_y + 1][grid_x]) do
    table.insert(entities, ent)
  end
  for _, ent in pairs(self.grid[grid_y + 1][grid_x + 1]) do
    table.insert(entities, ent)
  end
  return entities
end

return CollisionGrid
