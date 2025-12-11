Entity = require("OBJ.Entity")

Camera = setmetatable({}, Entity)
Camera.__index = Camera

function Camera:new(position, followTarget, scale)
    local obj = Entity.new(self, position, nil)
    obj.followTarget = followTarget -- Takes an Entity
    obj.scale = scale
    return obj
end

function Camera:update(dt)
    Entity.update(self, dt)
    self:follow()
end


function Camera:load()
    --Entity.load(self)
end

function Camera:draw()
    --Entity.draw(self)
end

function Camera:destroy()
    Entity.destroy(self)
end

function Camera:follow()
    if self.followTarget == nil then return end
    if self.followTarget.position == nil then return end
    
    self.position.x = self.followTarget.position.x
    self.position.y = self.followTarget.position.y

    print("Camera is following target")
end

function Camera:setFollowTarget(newFollowTarget)
    self.followTarget = newFollowTarget
end

function Camera:setScale(newScale)
    self.scale = newScale
end


return Camera