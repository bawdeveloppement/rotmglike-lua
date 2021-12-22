local SettingManager = require(_G.libDir .. "middleclass")("SettingManager")

function SettingManager:initialize()
    self.resolutionScale = 1
end

return SettingManager