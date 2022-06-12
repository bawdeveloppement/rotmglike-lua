
local World = require(_G.engineDir .. "world");
local Realm = require(_G.libDir .. "middleclass")("Realm", World);
local RealmData = require(_G.srcDir .. "worlds.realm.data")

function Realm:initialize (screen, active)
  World.initialize(self, screen, active or false, "realm", RealmData, 4);

  self.nextWorldBossTimer = 100
  self.currentWorldBossTimer = self.nextWorldBossTimer
  self.worldBossList = { "boss1", "boss2" }
  self.worldBossDefeated = {}
  self.currentWorldBoss = nil

  self:addSystem("onUpdate", self.addWorldBossSytem)
end

function Realm:addWorldBossSytem (dt)
  if self.currentWorldBossTimer > 0 then
    self.currentWorldBossTimer = self.currentWorldBossTimer - dt
  end
  
  if self.currentWorldBossTimer < 0 and self.currentWorldBoss == nil then
    self.currentWorldBoss = self.worldBossList[1]
    table.remove(self.worldBossList, 1)
  end

  if self.currentWorldBoss ~= nil then
    local entity = self:getEntityById(currentWorldBoss)
    if entity == nil then 
      self.currentWorldBoss = nil
      self.currentWorldBossTimer = self.nextWorldBossTimer
    end
  end
end

return Realm
