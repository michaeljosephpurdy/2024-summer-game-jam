local CooldownSystem = tiny.processingSystem()
CooldownSystem.filter = tiny.requireAll('cooldown')

function CooldownSystem:process(e, dt)
  e:cooldown()
end

return CooldownSystem
