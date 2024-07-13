local CollisionRegistrationSystem = tiny.processingSystem()
CollisionRegistrationSystem.filter = tiny.requireAll('hitbox', 'x', 'y')

function CollisionRegistrationSystem:initialize(props)
  self.bump_world = props.bump_world
end

function CollisionRegistrationSystem:onAdd(e)
  local hitbox = e.hitbox --[[@as Hitbox]]
  self.bump_world:add(e, e.x, e.y, hitbox.width, hitbox.height)
  e.bump_world = self.bump_world
end

function CollisionRegistrationSystem:onRemove(e)
  self.bump_world:remove(e)
end

return CollisionRegistrationSystem
