-- Components
local Sprite = require(_G.engineDir.."components.sprite")
local Transform = require(_G.engineDir.."components.transform")
local Collision = require(_G.engineDir.."components.collision")

local Button = require(_G.engineDir.."game_objects.main").InterfaceElements.ButtonElement
local Entity = require(_G.engineDir.."entity")

local Portal = require(_G.libDir .. "middleclass")("Portal", Entity)

function Portal:initialize ( world, data )
    Entity.initialize(self, world, "Portal1", "Portal", {
        { class = Transform, data = { position = data.position  }},
        { class = Collision, data = { rect = { width = 8, height = 8 }, scale = data.scale}},
    });

    self.properties = data.properties

    self.playerInCollision = false
    local w, h = love.window.getMode()

    self.goToPortalButton = Button:new(data.properties.portalId, w - 100,  h - 50)

    self.goToPortalButton:addOnClickEvent("gotoworld", function ()
        self.world.screen:goToWorld(data.properties.portalId)
        -- _G.xle.goToWorld("play");
    end)
end

function Portal:update(...)
    Entity.update(self, ...)

    local sRect = self:getComponent("CollisionComponent"):getRect()
    local sPos = self:getComponent("TransformComponent").position

    local ents = self.world:getEntitiesByComponentName("CharacterComponent")
    for ie, ent in ipairs(ents) do
        if ent:getComponent("CharacterComponent").isPlayer then
            local rect = ent:getComponent("CollisionComponent").rect
            local pos = ent:getComponent("TransformComponent").position
            if pos.x < sPos.x + sRect.width and pos.x + rect.width > sPos.x and pos.y < sPos.y + sRect.height and pos.y + rect.height > sPos.y then
                self.playerInCollision = true
            else
                self.playerInCollision = false
            end
        end
    end  
end

function Portal:draw()
    Entity.draw(self)

    if self.playerInCollision then
        self.goToPortalButton:draw()
    end

    local pos = self:getComponent("TransformComponent").position
    -- local pos = self:getComponent("TransformComponent").position
end


function Portal:mousereleased(...)
    Entity.mousereleased(self, ...)
    local mx, my, button = ...
    if self.playerInCollision then
        self.goToPortalButton:mousepressed(...)
    end
end

function Portal:mousepressed(...)
    Entity.mousepressed(self, ...)
    local mx, my, button = ...
    -- if self.playerInCollision then
    --     self.goToPortalButton:mousepressed(...)
    -- end
end

return Portal