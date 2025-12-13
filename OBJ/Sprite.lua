Vector = require("OBJ.Vector")

Sprite = {}
Sprite.__index = Sprite

-- @param String path
function Sprite:new(path)
    local obj = {path = path}
    setmetatable(obj, self)
    self.img = love.graphics.newImage(path)
    return obj
end

function Sprite:load()
    self.img = love.graphics.newImage(self.path)
end

function Sprite:draw(posx, posy)
    love.graphics.draw(self.img, posx, posy)
end

function Sprite:unload()
    self.img = nil
end

function Sprite:getcenter()
    return Vector:new(self.img:getPixelWidth()/2, self.img:getPixelHeight()/2)
end

function Sprite:getBounds()
    return Vector:new(self.img:getWidth(), self.img:getHeight())
end

return Sprite