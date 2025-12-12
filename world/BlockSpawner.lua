Block = require("world.Block")
Vector = require("OBJ.Vector")
Sprite = require("OBJ.Sprite")
Windfield = require("libs.windfield")

BlockSpawner = setmetatable({}, Entity)
BlockSpawner.__index = BlockSpawner

function BlockSpawner:new(position, spawnTimer, entityHierarchy, physicsWorld)
    local obj = Entity.new(self, position, nil) -- super()
    obj.spawnTime = spawnTimer
    obj.spawnTimeRef = spawnTimer
    obj.entityHierarchy = entityHierarchy
    obj.rightSpawn = 0
    obj.leftSpawn = 0
    obj.physicsWorld = physicsWorld
    return obj
end

function BlockSpawner:update(dt)
    Entity.update(self, dt)
    self:spawnTimer(dt)
end


function BlockSpawner:load()
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

function BlockSpawner:spawnBlock()
    local leftOffset = Vector:new(-100, 0)
    local rightOffset = Vector:new(100, 0)
    local assignedOffset

    local randNum = math.random(2)

    if randNum == 1  and self.leftSpawn < 3 then
        self.rightSpawn = 0
        assignedOffset = leftOffset
        self.leftSpawn = self.leftSpawn + 1
    elseif randNum == 1 then
        self.leftSpawn = 0
        assignedOffset = rightOffset
        self.rightSpawn = self.rightSpawn + 1
    end
    
    if randNum == 2 and self.rightSpawn < 3 then
        self.leftSpawn = 0
        assignedOffset = rightOffset
        self.rightSpawn = self.rightSpawn + 1
    elseif randNum == 2 then
        self.rightSpawn = 0
        assignedOffset = leftOffset
        self.leftSpawn = self.leftSpawn + 1
    end

    -- Instantiate block into entity hierarchy
    local spawnPosition = self.position + assignedOffset
    local blockSprite = Sprite:new("res/Sprites/Obstacles/block.png")
    blockSprite:load()
    local blockCollider = self.physicsWorld:newRectangleCollider(spawnPosition.x, spawnPosition.y, blockSprite:getBounds().x, blockSprite:getBounds().y)
    local block = Block:new(spawnPosition, blockSprite, blockCollider, 250, 6, 100)
    block:load()
    table.insert(self.entityHierarchy, block)

    --print("block spawned")
end

return BlockSpawner