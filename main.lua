-- Lib includes
Object = require("OBJ.Object")
Entity = require("OBJ.Entity")
Vector = require("OBJ.Vector")
Sprite = require("OBJ.Sprite")
Body = require("OBJ.Body")
Player = require("Player")
Camera = require("world.Camera")
Block = require("world.Block")
BlockSpawner = require("world.BlockSpawner")

_G.love = require("love")

local bgShader
local r, g, b = love.math.colorFromBytes(130, 186, 151)
love.graphics.setBackgroundColor(r, g, b)

local centerPoint = Vector:new(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
local spawnOffset = Vector:new(0, 150)

local player = Player:new(centerPoint + spawnOffset, Sprite:new("res/Sprites/Player/plr.png"), false)
local camera = Camera:new(player.position - centerPoint - spawnOffset, player, 1)


local testEntity = Entity:new(centerPoint, Sprite:new("res/Sprites/Tests/wow-this-guy.png"))
local blockOne = Block:new(centerPoint + Vector:new(150, -100), Sprite:new("res/Sprites/Obstacles/block.png"), 100, 5, 80)

local entityTable = {Camera, player}

local blockSpawner = BlockSpawner:new(centerPoint - Vector:new(0, 500), 1, entityTable)

table.insert(entityTable, 1, blockSpawner)

function love.load()
    _G.number = 0;
    bgShader = love.graphics.newShader("shaders/balatroBack.glsl")
    --camera:setFollowTarget(myEntity)
    LoadEntities()
end

function love.update(dt)
    _G.number = _G.number + 1 * dt;
    bgShader:send("time", love.timer.getTime())
    UpdateEntites(dt)
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(camera.scale, camera.scale)
    love.graphics.translate(-camera.position.x, -camera.position.y)

    --bg layer
    love.graphics.setShader(bgShader)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()

    -- Entity Layer
    love.graphics.setColor(1,1,1,255)
    DrawEntities()

    -- Gizmo Layer
    --love.graphics.setColor(love.math.colorFromBytes(255, 0, 0))
    --love.graphics.circle("line", myEntity.position.x, myEntity.position.y, 5)

    -- Text Layer
    love.graphics.setColor(0,0,0,255)
    love.graphics.print("The Lua program has been running for " .. tostring(math.floor(_G.number)) .. " seconds!\nFrame Rate: " .. tostring(love.timer.getFPS()), 5, 5)

    love.graphics.pop()
end

function LoadEntities()
    for idx = 1, #entityTable, 1 do
        entityTable[idx]:load()
    end
end

function UpdateEntites(dt)
    for idx = 1, #entityTable, 1 do
        entityTable[idx]:update(dt)
    end
end

function DrawEntities()
    for idx = 1, #entityTable, 1 do
        entityTable[idx]:draw()
    end
end

function SetRandomPos()
    if love.keyboard.isDown("r") then
        player.position = Vector:new(math.random(100, love.graphics.getWidth()-100), math.random(100, love.graphics.getHeight()-100))
    end
end