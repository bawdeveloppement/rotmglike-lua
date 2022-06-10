local Component = require(_G.libDir .. "component")
local Tileset = require(_G.libDir.."middleclass")("Tileset", Component);

local Vector2 = require(_G.libDir.."utils.Vector2");

function Tileset:initialize( parent , data)
    Component.initialize(self, parent)
    
    self.relativity = nil
    self.image = nil;
    self.transform = self.entity:getComponent("TransformComponent");

    self.scale = Vector2(55, 37);
    
    if data.relativity ~= nil then self:setRelativity(data.relativity) else
        self.relativity = Vector2(0, 0);
    end

    if data.scale ~= nil then self.scale = Vector2(data.scale.x, data.scale.y) end

    if data.imageUri ~= nil then self:setImage(data.imageUri) end
    
end

function Tileset:setRelativity(relativity)
    self.relativity = Vector2(relativity.x, relativity.y);
end

function Tileset:setImage(imageUri)
    self.image = love.graphics.newImage(imageUri);
end

function Tileset:draw()
    -- Soon draw all image on GameObject.layer
    -- & Insert the referrence of the methods in GameObject.layer {}
    love.graphics.setColor(1,1,1,1);
    if self.image ~= nil then
        love.graphics.draw(self.image, self:getTilesetIndex(0), self.transform.position.x, self.transform.position.y, 0, 2);
    else
        love.graphics.rectangle("fill",
            self.transform.position.x,
            self.transform.position.y,
            self.scale.x,
            self.scale.y
        );
    end
end

function Tileset:getTilesetIndex(x)
    return love.graphics.newQuad(x, x, self.scale.x, self.scale.y, self.image:getDimensions())
end

return  Tileset