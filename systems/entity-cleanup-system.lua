local EntityCleanupSystem = tiny.processingSystem()
EntityCleanupSystem.filter = tiny.requireAll('time_to_live')

function EntityCleanupSystem:process(e, dt)
  e.time_to_live = e.time_to_live - dt
  if e.time_to_live < 0 then
    self.world:removeEntity(e)
  end
end

return EntityCleanupSystem
