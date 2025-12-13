Body = require("OBJ.Body")
Vector = require("OBJ.Vector")
Event = require("OBJ.Event")

Player = setmetatable({}, Body)
Player.__index = Player

function Player:new(position, sprite, gravityOn, collider)
    local obj = Body.new(self, position, sprite, gravityOn, collider)
    obj.moveSpeed = 3500
    obj.counterMovement = 10
    obj.onPlayerDie = Event:new()
    return obj
end

-- Essential Inherited Methods

function Player:update(dt) -- Make sure anything that inherits from body has the super function called after all extra velocity calculations
    self:handleMove(dt)
    self:counterMove(dt)
    self:listenForObstacles()
    self:outOfBoundsHandler()
    Body.update(self,dt)
end

function Player:load()
    Body.load(self)
    self.collider:setCollisionClass("Player")
    self.collider:setFixedRotation(true)
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

function Player:setSpeed(val)
    self.moveSpeed = val
end

function Player:listenForObstacles()
    if self.collider:enter("Obstacle") then
        self:die()
    end
end

function Player:outOfBoundsHandler()
    if (self.position.x < -10 or self.position.x > 370) or (self.position.y < -10 or self.position.y > 650) then
        self:die()
    end
end

function Player:die()
    self.onPlayerDie:emit()
    self:destroy()
end


return Player