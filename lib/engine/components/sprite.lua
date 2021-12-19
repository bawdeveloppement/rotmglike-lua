local Component = require(_G.engineDir .. "component");
local Vector2 = require(_G.engineDir.."utils.Vector2");

local Sprite = require(_G.libDir.."middleclass")("SpriteComponent", Component);

function Sprite:initialize(parent, data)
    Component.initialize(self, parent)
    
    self.relativity = data.relativity or nil
    self.image = nil;
    self.transform = self.entity:getComponent("TransformComponent");

    self.rect  = data.rect or {
        width = 16,
        height = 16
    }

    self.scale = Vector2(data.width or 55, data.height or 37);
    
    if data.relativity ~= nil then self:setRelativity(data.relativity) else
        self.relativity = Vector2(0, 0);
    end

    if data.scale ~= nil then self.scale = Vector2(data.scale.x, data.scale.y) end

    if data.imageUri ~= nil then self:setImage(data.imageUri) end
    
end

function Sprite:setRelativity(relativity)
    self.relativity = Vector2(relativity.x, relativity.y);
end

function Sprite:setImage(imageUri)
    self.image = love.graphics.newImage(imageUri);
end

function Sprite:draw()
    -- Soon draw all image on GameObject.layer
    -- & Insert the referrence of the methods in GameObject.layer {}
    love.graphics.setColor(1,1,1,1);
    local transform = self.entity:getComponent("TransformComponent");
    if self.image ~= nil then
        love.graphics.draw(self.image, self:getSpriteIndex(0), transform.position.x, transform.position.y, 0, 2);
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
    return love.graphics.newQuad(x, x, self.rect.width, self.rect.height, self.image:getDimensions())
end

return  Sprite