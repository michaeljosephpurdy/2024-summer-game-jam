local TriggerResettingSystem = tiny.processingSystem()
TriggerResettingSystem.filter = tiny.requireAll('is_trigger')

function TriggerResettingSystem:process(e, _)
  e.triggered = false
end

return TriggerResettingSystem
