local Component = require(_G.engineDir .. "component");
local Vector2 = require(_G.engineDir.."utils.Vector2");

local Sprite = require(_G.libDir.."middleclass")("SpriteComponent", Component);

function Sprite:initialize(parent, data)
    Component.initialize(self, parent)
    
    self.relativity = data.relativity or nil
    self.image = data.image or nil;
    self.transform = self.entity:getComponent("TransformComponent");

    self.scale = data.scale or 1

    self.rect  = data.rect or {
        width = 16,
        height = 16
    }

    self.tile = data.tile or {
        width = 8,
        height = 8
    }

    self.orientation = data.orientation or 0

    if self.rect.width > self.tile.width then
        self.scale = self.rect.width / self.tile.width
    end

    if data.relativity ~= nil then self:setRelativity(data.relativity) else
        self.relativity = Vector2(0, 0);
    end

    if data.scale ~= nil then self.scale = data.scale or 1 end

    if data.imageUri ~= nil then self:setImageUri(data.imageUri) end
    self.spriteIndex = data.spriteIndex or 0
end

function Sprite:setRelativity(relativity)
    self.relativity = Vector2(relativity.x, relativity.y);
end

function Sprite:setImageUri(imageUri)
    self.image = love.graphics.newImage(imageUri);
end

function Sprite:setImage( image )
    self.image = image;
end

function Sprite:setIndex( index)
    self.spriteIndex = index
end

function Sprite:draw()
    -- Soon draw all image on GameObject.layer
    -- & Insert the referrence of the methods in GameObject.layer {}
    love.graphics.setColor(1,1,1,1);
    local transform = self.entity:getComponent("TransformComponent");
    if self.image ~= nil then
        love.graphics.draw(self.image, self:getSpriteIndex(self.spriteIndex), transform.position.x, transform.position.y, self.orientation, self.scale);
    else
        love.graphics.rectangle("fill",
            transform.position.x,
            transform.position.y,
            self.rect.width,
            self.rect.height
        );
    end
end

function Sprite:getSpriteIndex(x)
    local imageW, imageH = self.image:getDimensions()
    return love.graphics.newQuad(
        self.tile.width * (x % (imageW / self.tile.width)),
        math.floor(x / (imageW / self.tile.width)) * self.tile.width,
        self.tile.width,
        self.tile.height,
        self.image:getDimensions()
    );
end

return  Sprite