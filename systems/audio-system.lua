local AudioSystem = tiny.processingSystem()
AudioSystem.filter = tiny.requireAll('audio')

function AudioSystem:onAddToWorld()
  --self.world:addEntity(Audio('music'))
end

function AudioSystem:onAdd(e)
  e:play()
  if e.is_one_shot then
    self.world:removeEntity(e)
  end
end

function AudioSystem:onEntityRemove(e)
  self.world:addEntity(e)
end

return AudioSystem
