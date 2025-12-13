Body = require("OBJ.Body")
Windfield = require("libs.windfield")

ScoreLine = setmetatable({}, Entity)
ScoreLine.__index = ScoreLine

function ScoreLine:new(position, physicsWorld)
    local obj = Entity.new(self, position, nil)
    obj.centerX = position.x
    obj.timeElapsed = 0
    obj.physicsWorld = physicsWorld
    return obj
end

-- Essential Inherited Methods

function ScoreLine:update(dt) -- Make sure anything that inherits from body has the super function called after all extra velocity calculations
    self:lifeTime(dt)
    self:enterPlayer()
    Entity.update(self, dt)
end

function ScoreLine:load()
    --Entity.load(self)
end

function ScoreLine:draw()
    --Entity.draw(self)
    --love.graphics.line(-50, self.position.y, 410, self.position.y)
end

function ScoreLine:destroy()
    Entity.destroy(self)
end

-- Class Implementations

function ScoreLine:lifeTime(dt)
    self.timeElapsed = self.timeElapsed + dt    
    if self.timeElapsed >= 4 then
        --print("score line destroyed")
        self:destroy()
    end
end

function ScoreLine:enterPlayer()
    local players = self.physicsWorld:queryLine(
        -50, self.position.y,
        410, self.position.y,
        { "Player" }
    )

    if #players > 0 then
        print("Score incremented")
        _G.incScore()
        self:destroy()
    end
end


return ScoreLine