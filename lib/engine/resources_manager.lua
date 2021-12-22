local ResourcesManager = require(_G.libDir .. "middleclass")("ResourcesManager")

function ResourcesManager:initialize()
    self.sounds = {}
    self.textures = {}
end

function ResourcesManager:addSound( soundId, soundPath )
    self.sounds[soundId] = love.audio.newSource(soundPath, "static");
end

function ResourcesManager:getTexture ( textureId )
    if self.textures[textureId] ~= nil then
        return self.textures[textureId]
    else
        return nil
    end
end

function ResourcesManager:addTexture( textureId, texturePath, opt )
    self.textures[textureId] = love.graphics.newImage(texturePath, opt or nil);
end

return ResourcesManager