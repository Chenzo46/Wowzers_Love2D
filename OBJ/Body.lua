Entity = require("OBJ.Entity")
Vector = require("OBJ.Vector")

Body = setmetatable({}, Entity)
Body.__index = Body

-- Constructor

function Body:new(position, sprite, gravityOn)
    local obj = Entity.new(self, position, sprite)
    obj.velocity = Vector:new(0,0)
    obj.gravity = 9.81
    obj.terminalVelocity = 5
    obj.gravityScale = 1
    obj.gravityOn = gravityOn
    return obj
end

-- Essential Inherited Methods

function Body:update(dt) -- Make sure anything that inherits from body has the super function called after all extra velocity calculations
    Entity.update(self, dt)
    self:applyVelocity(dt)
end

function Body:load()
    Entity.load(self)
end

function Body:draw()
    Entity.draw(self)
end

function Body:destroy()
    Entity.destroy(self)
end

-- Class Implementations

function Body:applyGravity(dt)
    if self.gravityOn then
        self.velocity = self.velocity + Vector:new(0, self.gravity * self.gravityScale) * dt
    end
end

function Body:applyVelocity(dt)
    self:applyGravity(dt)
    self:clampVelocityY()
    self.position = self.position + self.velocity
end

function Body:clampVelocityY()
    if self.velocity.y > self.terminalVelocity and self.gravityOn then
        self.velocity.y = self.terminalVelocity
    end
end

function Body:setGravityScale(newGravScale)
    self.gravityScale = newGravScale
end

function Body:setTerminalVelocity(newTermVel)
    self.terminalVelocity = newTermVel
end

function Body:setGravityOn(toggle)
    self.gravityOn = toggle
end


return Body