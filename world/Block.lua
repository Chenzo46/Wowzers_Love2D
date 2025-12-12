Body = require("OBJ.Body")
Windfield = require("libs.windfield")

Block = setmetatable({}, Body)
Block.__index = Block

function Block:new(position, sprite, collider, fallSpeed, displaceSpeed, displaceFactor)
    local obj = Body.new(self, position, sprite, false, collider)
    obj.fallSpeed = fallSpeed
    obj.centerX = position.x
    obj.displaceSpeed = displaceSpeed
    obj.displaceFactor = displaceFactor
    obj.timeElapsed = 0
    return obj
end

-- Essential Inherited Methods

function Block:update(dt) -- Make sure anything that inherits from body has the super function called after all extra velocity calculations
    self:displace(dt)
    self:fall(dt)
    Body.update(self, dt)
    self:lifeTime(dt)
end

function Block:load()
    Body.load(self)
    self.collider:setCollisionClass("Obstacle")
    self.collider:setFixedRotation(true)
    self.collider:setMass(500)
    self:setColliderOverride(true)
end

function Block:draw()
    Body.draw(self)
end

function Block:destroy()
    Body.destroy(self)
end

-- Class Implementations

function Block:displace(dt)
    self.position.x = self.centerX + self.displaceFactor * math.sin(self.timeElapsed * self.displaceSpeed)
end

function Block:fall(dt)
    self.position.y = self.position.y + self.fallSpeed * dt
end

function Block:lifeTime(dt)
    self.timeElapsed = self.timeElapsed + dt    
    if self.timeElapsed >= 4 then
        print("block destroyed")
        self:destroy()
    end
end

return Block