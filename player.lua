Body = require("OBJ.Body")
Vector = require("OBJ.Vector")

Player = setmetatable({}, Body)
Player.__index = Player

function Player:new(position, sprite, gravityOn)
    local obj = Body.new(self, position, sprite, gravityOn)
    obj.moveSpeed = 30
    obj.counterMovement = 10
    return obj
end

-- Essential Inherited Methods

function Player:update(dt) -- Make sure anything that inherits from body has the super function called after all extra velocity calculations
    self:handleMove(dt)
    self:counterMove(dt)
    Body.update(self,dt)
end

function Player:load()
    Body.load(self)
end

function Player:draw()
    Body.draw(self)
end

function Player:destroy()
    Body.destroy(self)
end

-- Implementations

function Player:handleMove(dt)
    self.velocity = self.velocity + self:getInputVector():normalize() * self.moveSpeed * dt
end

function Player:counterMove(dt)
    local damping = math.exp(-self.counterMovement * dt)
    self.velocity = self.velocity * damping
end

function Player:getInputVector()
    local xInput = 0
    local yInput = 0

    if love.keyboard.isDown("a") then
        xInput = xInput - 1
    end
    
    if love.keyboard.isDown("d")  then
        xInput = xInput + 1
    end
    
    if love.keyboard.isDown("w")  then
        yInput = yInput - 1
    end
    
    if love.keyboard.isDown("s")  then
        yInput = yInput + 1
    end

    return Vector:new(xInput, yInput)
end


return Player