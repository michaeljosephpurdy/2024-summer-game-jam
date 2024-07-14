local System = tiny.processingSystem()
System.filter = tiny.requireAll('is_player')

function System:initialize(props)
  self.bump_world = props.bump_world
end

function System:onAdd(e)
  self.true_x = e.x
  self.true_y = e.y
end

function System:process(e, dt)
  -- This system has one job:
  -- When the truck is active, keep the player at same position of the truck
  if e.is_truck and e.is_active then
    self.true_x = e.x + (math.cos(e.rotation - 1.5707963267949) * 25)
    self.true_y = e.y + (math.sin(e.rotation - 1.5707963267949) * 25)
  end
  if not e.is_truck and not e.is_active then
    self.bump_world:update(e, self.true_x, self.true_y)
    e.x = self.true_x
    e.y = self.true_y
  end
end

return System
