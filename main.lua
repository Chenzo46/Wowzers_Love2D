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
Windfield = require("libs.windfield")

_G.love = require("love")
_G.score = 0

-- Global game vars

local bgShader
local world
local centerPoint = Vector:new(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
local spawnOffset = Vector:new(0, 150)
local playerSpawn = centerPoint + spawnOffset
local entityTable = {}
local canReset = false
local gameStarted = false
local gameFont
local scoreFont

-- Audio

local gameMusic
local scoreSFX
local startSFX
local dieSFX

-- Game Vars

local player
local blockSpawner
local gameLogo
local highScore
local isNewHighScore = false

local wglpath = "highscore.txt"

-- Gameplay loop

function love.load()
    
    highScore = LoadHighScore()

    local icon = love.image.newImageData("res/Sprites/Player/plr.png") -- must be an ImageData
    love.window.setIcon(icon)

    -- Random timer test
    _G.number = 0;
    
    -- Background
    bgShader = love.graphics.newShader("shaders/balatroBack.glsl")

    -- UI init
    gameFont = love.graphics.newFont("fonts/Born2bSportyFS.ttf", 22)
    scoreFont = love.graphics.newFont("fonts/Born2bSportyFS.ttf", 32)
    gameLogo = Entity:new(centerPoint - Vector:new(0,20), Sprite:new("res/Sprites/Text-Images/wl_gamelogo.png"))

    table.insert(entityTable, gameLogo)

    -- Physics World init
    world = Windfield.newWorld(0,0)
    world:addCollisionClass("Player", {ignores = {"Player"}})
    world:addCollisionClass("Obstacle", {ignores = {"Obstacle"}})
    world:addCollisionClass("ScoreLine", {ignores = {"ScoreLine", "Obstacle"}})


    -- Sound init
    gameMusic = love.audio.newSource("Sound/Music/Wowzers.ogg", "stream")
    gameMusic:play()
    gameMusic:setVolume(0.02)

    scoreSFX = love.audio.newSource("Sound/SFX/scoreInc.ogg", "static")
    startSFX = love.audio.newSource("Sound/SFX/startRun.ogg", "static")
    dieSFX = love.audio.newSource("Sound/SFX/wowzers_explode.ogg", "static")

    scoreSFX:setVolume(0.1)
    startSFX:setVolume(0.1)
    dieSFX:setVolume(0.1)

    -- Hierarchy init
    --InitLevel()

end

function love.update(dt)
    world:update(dt)
    _G.number = _G.number + 1 * dt;
    bgShader:send("time", love.timer.getTime())
    UpdateEntites(dt)
    LoopMusic()
    LerpDifficulty()
    --print("Lerp Test: " .. tostring(Lerp(0, 5, _G.number / 20))) -- 0 lerps to 5 in 20 seconds
end

function love.draw()
    love.graphics.push()

    --bg layer
    love.graphics.setColor(1,1,1,255)
    love.graphics.setShader(bgShader)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()

        
    love.graphics.pop()

    -- Entity Layer
    DrawEntities()

    -- Gizmo Layer
    --love.graphics.circle("line", playerSpawn.x, playerSpawn.y, 5)
    --world:draw() -- Draws Colliders (Leave commented out for release builds)


    -- Game Text Layer
    
    love.graphics.setColor(0,0,0,255)

    if canReset then
        love.graphics.setFont(gameFont)
        love.graphics.print("Press \"r\" to reset", playerSpawn.x - 65, playerSpawn.y)

        love.graphics.setFont(gameFont)
        love.graphics.print("High Score: " .. tostring(highScore), playerSpawn.x - 50, 50)
    end

    if canReset and isNewHighScore then
        love.graphics.setFont(scoreFont)
        love.graphics.print("New High Score!", playerSpawn.x - 85, 85)
        love.graphics.setColor(1,1,1,255)
        love.graphics.setFont(scoreFont)
        love.graphics.print("New High Score!", playerSpawn.x - 88, 80)
    end


    love.graphics.setColor(0,0,0,255)
    if not gameStarted then
        love.graphics.setFont(gameFont)
        love.graphics.print("Press \"E\" to start", playerSpawn.x - 65, playerSpawn.y)

        love.graphics.setFont(gameFont)
        love.graphics.print("High Score: " .. tostring(highScore), 5, 610)
    end

    if canReset or not gameStarted then 
        love.graphics.setFont(gameFont)
        --love.graphics.print("Press \"ESC\" to quit", 5, 5)-- Comment this out if building to webgl
    end

    if gameStarted then
        local scoreStr = tostring(_G.score)
        love.graphics.setFont(scoreFont)
        love.graphics.print(scoreStr, playerSpawn.x - 6, 20)
        love.graphics.setColor(1,1,1,255)
        love.graphics.setFont(scoreFont)
        love.graphics.print(scoreStr, playerSpawn.x - 4, 17)
    end

    -- Debug Text Layer
    --love.graphics.setColor(0,0,0,255)
    --love.graphics.print("The Lua program has been running for " .. tostring(math.floor(_G.number)) .. " seconds!\nFrame Rate: " .. tostring(love.timer.getFPS()), 5, 5)
end

function love.keypressed(key)
    --if key == "escape" then -- Comment this out if building to webgl
        --love.event.quit()
    --end

    HandleReset(key)

    ListenForGameStart(key)
end

-- Prefab Functions

function CreateNewPlayer()
    return Player:new(Vector:new(playerSpawn.x, playerSpawn.y), Sprite:new("res/Sprites/Player/plr.png"), false, world:newBSGRectangleCollider(playerSpawn.x, playerSpawn.y, 30,30, 5))
end

function CreateBlockSpawner()
    return BlockSpawner:new(centerPoint - Vector:new(0, 500), 2, 0.75, entityTable, world)
end

-- Assist Functions

function InitLevel()
    -- Object Reference Init
    player = CreateNewPlayer()
    blockSpawner = CreateBlockSpawner()
    table.insert(entityTable, blockSpawner)
    table.insert(entityTable, player)

    player:setPosition(playerSpawn)

    -- Event init
    PlayerDeathCallback()
    
    -- Entity init
    LoadEntities()

    _G.number = 0;
end

function PlayerDeathCallback()
    player.onPlayerDie:subscribe(function ()
        print("You lose!")
        dieSFX:play()
        canReset = true

        if _G.score > highScore then
            highScore = _G.score
            isNewHighScore = true
            SaveHighScore()
        else
            isNewHighScore = false
        end
    end)
end

function LoadEntities()
    for idx = 1, #entityTable, 1 do
        entityTable[idx]:load()
    end
end

function UpdateEntites(dt)
    for idx = #entityTable, 1, -1 do
        if entityTable[idx].destroyed then
            table.remove(entityTable, idx)
        else
            entityTable[idx]:update(dt)
        end
    end
end

function DrawEntities()
    for idx = 1, #entityTable, 1 do
        entityTable[idx]:draw()
    end
end

function UnloadLevel()
     for i = #entityTable, 1, -1 do
        entityTable[i]:destroy()
        table.remove(entityTable, i)
    end
end

function ResetLevel()
    UnloadLevel()
    InitLevel()
    canReset = false
    _G.number = 0
    _G.score = 0
end

function HandleReset(key)
    if key == "r" and canReset then
        startSFX:play()
        ResetLevel()
    end
end

function ListenForGameStart(key)
    if key == "e" and not gameStarted then
        gameStarted = true
        gameLogo:setEnabled(false)
        startSFX:play()
        InitLevel()
    end
end

function LoopMusic()
    if not gameMusic:isPlaying() then
        gameMusic:play()
    end
end

function SetRandomPos()
    if love.keyboard.isDown("r") then
        player.position = Vector:new(math.random(100, love.graphics.getWidth()-100), math.random(100, love.graphics.getHeight()-100))
    end
end

function Lerp(a, b, t)
    local tc = t

    if t > 1 then
        tc = 1
    elseif t < 0 then
        tc = 0
    end

    return tc * (b - a) + a
end

function LerpDifficulty()
    if gameStarted and not canReset then
        blockSpawner:setSpawnTimer(Lerp(blockSpawner:getMinSpawnTime(), blockSpawner:getMaxSpawnTime(), _G.number / 120))
        player:setSpeed(Lerp(3500, 6000,  _G.number / 120))
    end

end

function LoadHighScore()
    local score = 0
    if love.filesystem.getInfo(wglpath) then
        local contents = love.filesystem.read(wglpath) or ""
        score = tonumber(contents) or 0
    end
    return score
end

function SaveHighScore(score)
    love.filesystem.write(wglpath, tostring(score))
end
function _G.incScore()
    _G.score = _G.score + 1
    scoreSFX:play()
end