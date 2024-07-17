local DelayedFunctionExecutionSystem = tiny.processingSystem()
DelayedFunctionExecutionSystem.filter = tiny.requireAll('time_to_live', 'fn')

function DelayedFunctionExecutionSystem:onRemove(e)
  e:fn()
end

return DelayedFunctionExecutionSystem
