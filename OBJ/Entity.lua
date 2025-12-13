Object = require("OBJ.Object")
Vector = require("OBJ.Vector")
Sprite = require("OBJ.Sprite")

Entity = setmetatable({}, Object) -- Entity extends Object
Entity.__index = Entity

-- @param Vector position
-- @param Sprite sprite
function Entity:new(position,sprite)
    local obj = Object.new(self, position) -- super()
    obj.sprite = sprite
    obj.enabled = true
    return obj
end

function Entity:update(dt)
    if not self.enabled then return end
    Object.update(self, dt)
end


function Entity:load()
    self.sprite:load()
end

function Entity:draw()
    if not self.enabled then return end
    local spriteCenter = self.sprite:getcenter()
    self.sprite:draw(self.position.x - spriteCenter.x, self.position.y - spriteCenter.y)
end

function Entity:destroy()
    self.sprite:unload()
    Object.destroy(self)
end

function Entity:setEnabled(enb)
    self.enabled = enb
end

function Entity:getCenter()
    return Vector:new(self.position.x + self.sprite:getCenter().x, self.position.y + self.sprite:getCenter().y)
end

return Entity