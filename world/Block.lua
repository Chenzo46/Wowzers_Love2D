Body = require("OBJ.Body")


Block = setmetatable({}, Body)
Block.__index = Block

function Block:new(position, sprite, fallSpeed, displaceSpeed, displaceFactor)
    local obj = Body.new(self, position, sprite, false)
    obj.fallSpeed = fallSpeed
    obj.centerX = position.x
    obj.displaceSpeed = displaceSpeed
    obj.displaceFactor = displaceFactor
    obj.timeElapsed = 0
    return obj
end

-- Essential Inherited Methods

function Block:update(dt) -- Make sure anything that inherits from body has the super function called after all extra velocity calculations
    self.timeElapsed = self.timeElapsed + dt    
    self:displace(dt)
    self:fall(dt)
    Body.update(self, dt)
end

function Block:load()
    Body.load(self)
end

function Block:draw()
    Body.draw(self)
end

function Block:destroy()
    Body.destroy(self)
end

-- Class Implementations

function Block:displace(dt)
    self.position.x = self.centerX +  self.displaceFactor * math.sin(self.timeElapsed * self.displaceSpeed)
end

function Block:fall(dt)
    self.position = self.position + Vector:new(0, 1) * self.fallSpeed * dt
end

return Block