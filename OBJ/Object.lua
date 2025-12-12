Vector = require("OBJ.Vector")

local Object = {}
Object.__index = Object

-- @param Vector position
function Object:new(position)
    local obj = {position = position}
    self.destroyed = false
    setmetatable(obj, self)
    return obj
end


function Object:update(dt)
end

function Object:destroy()
    self.destroyed = true
    collectgarbage()
end


return Object