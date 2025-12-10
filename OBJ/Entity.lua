Object = require("OBJ.Object")
Vector = require("OBJ.Vector")
Sprite = require("OBJ.Sprite")

Entity = setmetatable({}, {__index = Object}) -- Entity extends Object
Entity.__index = Entity

-- @param Vector position
-- @param Sprite sprite
function Entity:new(position,sprite)
    local obj = Object.new(self, position) -- super()
    obj.sprite = sprite
    return obj
end

function Entity:load()
    self.sprite:load()
end

function Entity:draw()
    local spriteCenter = self.sprite:getcenter()
    self.sprite:draw(self.position.x - spriteCenter.x, self.position.y - spriteCenter.y)
end

function Entity:Destroy()
    self.sprite.unload()

end

return Entity