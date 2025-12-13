Entity = require("OBJ.Entity")
Vector = require("OBJ.Vector")
Windfield = require("libs.windfield")

Body = setmetatable({}, Entity)
Body.__index = Body

-- Constructor

function Body:new(position, sprite, gravityOn, collider)
    local obj = Entity.new(self, position, sprite)
    obj.velocity = Vector:new(0,0)
    obj.gravity = 9.81
    obj.terminalVelocity = 5
    obj.gravityScale = 1
    obj.gravityOn = gravityOn
    obj.collider = collider
    obj.colliderOverride = false
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
    self.collider:destroy()
    self.collider = nil
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
    self:updateCollider()
end

function Body:clampVelocityY()
    if self.velocity.y > self.terminalVelocity and self.gravityOn then
        self.velocity.y = self.terminalVelocity
    end
end

function Body:updateCollider()
    if not self.collider then return end

    local deltaVel = self.velocity

    if not self.colliderOverride then
        self.collider:setLinearVelocity(deltaVel.x, deltaVel.y)
    else
        self.collider:setPosition(self.position.x, self.position.y)
    end
    self.position.x = self.collider:getX()
    self.position.y = self.collider:getY()
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

function Body:setColliderOverride(toggle)
    self.colliderOverride = toggle
end

function Body:setPosition(pos)
    self.collider:setPosition(pos.x, pos.y)
    self.position = Vector:new(pos.x, pos.y)
end

return Body