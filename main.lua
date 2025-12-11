-- Lib includes
Object = require("OBJ.Object")
Entity = require("OBJ.Entity")
Vector = require("OBJ.Vector")
Sprite = require("OBJ.Sprite")
Body = require("OBJ.Body")
Player = require("Player")

_G.love = require("love")

local r, g, b = love.math.colorFromBytes(130, 186, 151)
love.graphics.setBackgroundColor(r, g, b)

local centerPoint = Vector:new(love.graphics.getWidth()/2, love.graphics.getHeight()/2)

local testEntity = Entity:new(centerPoint, Sprite:new("res/Sprites/Tests/wow-this-guy.png"))
local myEntity = Player:new(Vector:new(30,30), Sprite:new("res/Sprites/Tests/Old_Wizardcore-Itch-single.png"), false)

local entityTable = {testEntity, myEntity}

function love.load()
    _G.number = 0;
    LoadEntities()
end

function love.update(dt)
    _G.number = _G.number + 1 * dt;
    UpdateEntites(dt)
end

function love.draw()
    -- Entity Layer
    love.graphics.setColor(1,1,1,255)
    DrawEntities()

    -- Gizmo Layer
    love.graphics.setColor(love.math.colorFromBytes(255, 0, 0))
    love.graphics.circle("line", myEntity.position.x, myEntity.position.y, 5)

    -- Text Layer
    love.graphics.setColor(0,0,0,255)
    love.graphics.print("The Lua program has been running for " .. tostring(math.floor(_G.number)) .. " seconds!\nFrame Rate: " .. tostring(love.timer.getFPS()), 5, 5)
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
        myEntity.position = Vector:new(math.random(100, love.graphics.getWidth()-100), math.random(100, love.graphics.getHeight()-100))
    end
end