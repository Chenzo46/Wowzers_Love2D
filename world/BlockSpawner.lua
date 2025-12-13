Block = require("world.Block")
Vector = require("OBJ.Vector")
Sprite = require("OBJ.Sprite")
Windfield = require("libs.windfield")
ScoreLine = require("world.ScoreLine")

BlockSpawner = setmetatable({}, Entity)
BlockSpawner.__index = BlockSpawner

function BlockSpawner:new(position, spawnTimer, maxSpawnTime, entityHierarchy, physicsWorld)
    local obj = Entity.new(self, position, nil) -- super()
    obj.spawnTimeRef = spawnTimer
    obj.spawnTime = spawnTimer
    obj.entityHierarchy = entityHierarchy
    obj.spawnPosCounts = {0, 0, 0}
    obj.physicsWorld = physicsWorld
    obj.minSpawnRate = spawnTimer
    obj.maxSpawnRate = maxSpawnTime
    return obj
end

function BlockSpawner:update(dt)
    Entity.update(self, dt)
    self:spawnTimer(dt)
    --print("BLST: " .. tostring(self.spawnTime))
end


function BlockSpawner:load()
    self:spawnBlock()
    --Entity.load(self)
end

function BlockSpawner:draw()
    --Entity.draw(self)
end

function BlockSpawner:destroy()
    --Entity.destroy(self)
end

-- Implementations

function BlockSpawner:spawnTimer(dt)
    if self.spawnTimeRef > 0 then
        self.spawnTimeRef = self.spawnTimeRef - dt
    else
        self.spawnTimeRef = self.spawnTime
        self:spawnBlock()
    end
end

function BlockSpawner:setSpawnTimer(val)
    self.spawnTime = val
end

function BlockSpawner:getMaxSpawnTime()
    return self.maxSpawnRate
end

function BlockSpawner:getMinSpawnTime()
    return self.minSpawnRate
end

function BlockSpawner:spawnBlock()
    local spawnOffsets = {Vector:new(-100, 0), Vector:new(100, 0), Vector:new(0,0)}
    local assignedOffset

    local randNum = math.random(3)

    self.spawnPosCounts[randNum] = self.spawnPosCounts[randNum] + 1

    for idx = 1, #spawnOffsets, 1 do
        if self.spawnPosCounts[idx] > 3 then
            self.spawnPosCounts[idx] = 0

            local nextElm = idx+1

            --print("Block spawn defferred from pos #" .. tostring(idx))
            if nextElm > #spawnOffsets then
                --print("Deferred from end, looping")
                nextElm = 1
            end

            assignedOffset = spawnOffsets[nextElm]
            break
        elseif randNum == idx then
            assignedOffset = spawnOffsets[idx]
            break
        elseif randNum ~= idx then
            self.spawnPosCounts[idx] = 0
        end
    end

    -- determine fair displace speed
    local displaceSpeed

    if assignedOffset.x == 0 then
        displaceSpeed = 5
    else
        displaceSpeed = 10
    end

    -- Instantiate block into entity hierarchy
    local spawnPosition = self.position + assignedOffset
    local blockSprite = Sprite:new("res/Sprites/Obstacles/block.png")
    blockSprite:load()
    local blockCollider = self.physicsWorld:newRectangleCollider(spawnPosition.x, spawnPosition.y, blockSprite:getBounds().x, blockSprite:getBounds().y)
    local block = Block:new(spawnPosition, blockSprite, blockCollider, 250, displaceSpeed, 50)
    block:load()
    table.insert(self.entityHierarchy, block)

    -- Assign Score marker
    --local scoreCol = self.physicsWorld:newRectangleCollider(spawnPosition.x - 300, spawnPosition.y, 640, blockSprite:getBounds().y)
    local sm = ScoreLine:new(block.position, self.physicsWorld)
    table.insert(self.entityHierarchy, sm)

    --scoreCol:setPreSolve(function(selfCollider, otherCollider, contact)
    -- Turn off Box2D collision response
    --contact:setEnabled(false)
--end)
end

return BlockSpawner