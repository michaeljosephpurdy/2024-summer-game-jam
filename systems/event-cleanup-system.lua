local EventCleanupSystem = tiny.processingSystem()
local rejection_filter = tiny.rejectAll('time_to_live')
EventCleanupSystem.filter = tiny.requireAll(rejection_filter, 'is_event')

function EventCleanupSystem:process(e, dt)
  self.world:removeEntity(e)
end

return EventCleanupSystem
