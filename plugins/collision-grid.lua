---@class CollisionGrid
local collision_grid = {}

---@private
collision_grid.__VERSION = '0.0.1'
---@private
collision_grid.__DESCRIPTION = [[
  A lightweight library for grouping objects objects taht are close with eachother
  for fast retrieval.
]]
---@private
collision_grid.__URL = 'https://github.com/michaeljosephpurdy/collision-grid'
---@private
collision_grid.__LICENSE = [[
  Copyright (c) 2024 Michael Purdy

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

---@private
---@param cell_size number
---@param width number
---@param height number
function collision_grid:init(cell_size, width, height)
  ---@private
  self.grid = {}
  local offset = 5
  for y = -offset, width + offset, 1 do
    self.grid[y] = {}
    for x = -offset, height + offset, 1 do
      self.grid[y][x] = {}
    end
  end
  ---@private
  self.width = width
  ---@private
  self.height = height
  ---@private
  self.cell_size = cell_size
  -- cell_offset is needed because sprites in this game are rotated
  -- around artifical origin point at center of sprite.
  -- Typically we _draw_ an offset, and keep the collisions at
  -- the true x, y position.
  -- However, in this case, drawing at offset makes rotation
  -- calculation very difficult.  So, instead we'll apply this
  -- offset on the collision grid directly
  ---@private
  self.cell_offset = cell_size / 2
end

---@param x number in world space
---@param y number in world space
---@return integer in grid space
---@return integer in grid space
function collision_grid:to_grid(x, y)
  return math.floor((x + self.cell_offset) / self.cell_size), math.floor((y + self.cell_offset) / self.cell_size)
end

---@param entity { x: number, y: number }
---@return table
function collision_grid:get_rect(entity)
  local grid_x, grid_y = self:to_grid(entity.x, entity.y)
  return { x = grid_x * self.cell_size, y = grid_y * self.cell_size, width = self.cell_size, height = self.cell_size }
end

---registers an entity
---@param entity { x: number, y: number }
function collision_grid:register(entity)
  local grid_x, grid_y = self:to_grid(entity.x, entity.y)
  table.insert(self.grid[grid_y][grid_x], entity)
end

---@param entity { x: number, y: number }
---@return boolean flag if entity was successfully removed
function collision_grid:remove(entity)
  local grid_x, grid_y = self:to_grid(entity.x, entity.y)
  for i, ent in ipairs(self.grid[grid_y][grid_x]) do
    if ent == entity then
      table.remove(self.grid[grid_y][grid_x], i)
      return true
    end
  end
  return false
end

---Update the entity within the collision grid.
---This method expects `entity.x` and `enity.y` to be defined
---and to be where the entity **currently is**, and will 'move'
---the entity within the collision grid to `new_x` and `new_y`.
---@param entity { x: number, y: number }
---@param new_x number in world units
---@param new_y number in world units
function collision_grid:update(entity, new_x, new_y)
  local grid_x, grid_y = self:to_grid(entity.x, entity.y)
  local new_grid_x, new_grid_y = self:to_grid(new_x, new_y)
  -- do nothing if entity has not changed grid
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

---@param x number in world units
---@param y number in world units
---@return table
function collision_grid:single_query(x, y)
  local grid_x, grid_y = self:to_grid(x, y)
  return self.grid[grid_y][grid_x]
end

---@param x number in world units
---@param y number in world units
---@return table
function collision_grid:query(x, y)
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

---@param cell_size number
---@param width number
---@param height number
---@return CollisionGrid
function collision_grid.new(cell_size, width, height)
  local cg = setmetatable({}, {
    __index = collision_grid,
  })
  cg:init(cell_size, width, height)
  return cg
end

return collision_grid
