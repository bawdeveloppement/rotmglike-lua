local ResourcesManager = require(_G.libDir .. "middleclass")("ResourcesManager")

function ResourcesManager:initialize()
    self.sounds = {}
    self.textures = {}
end

function ResourcesManager:addSound( soundId, soundPath )
    self.sounds[soundId] = love.audio.newSource(soundPath, "static");
end

function ResourcesManager:getSound ( soundId )
    if self.sounds[soundId] ~= nil then
        return self.sounds[soundId]
    else
        return nil
    end
end

function ResourcesManager:getOrAddSound ( soundId, path )
    local sound = self:getSound(soundId)
    if sound ~= nil then return sound
    else
        local exist = false
        for i, v in ipairs(require(_G.srcDir.."assets.".. (path or "sfx") ..".sounds")) do
            if soundId == v then
                exist = true
            end
        end
        if exist then
            self:addSound(soundId, "src/assets/".. (path or "sfx") .."/"..soundId)
            return self:getSound(soundId)
        else
            return nil
        end
    end
end

function ResourcesManager:getTexture ( textureId )
    if self.textures[textureId] ~= nil then
        return self.textures[textureId]
    else
        return nil
    end
end

function ResourcesManager:getOrAddTexture ( ... )
    -- body
end

function ResourcesManager:addTexture( textureId, texturePath, opt )
    self.textures[textureId] = love.graphics.newImage(texturePath, opt or nil);
end

return ResourcesManager