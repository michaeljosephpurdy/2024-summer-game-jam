local System = tiny.processingSystem()
local rejection_filter = tiny.rejectAll()
System.filter = tiny.requireAll(rejection_filter)

function System:initialize() end

function System:onAdd(e) end

function System:onRemove(e) end

function System:process(e, dt) end

return System
