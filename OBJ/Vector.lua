local Vector = {}
Vector.__index = Vector

function Vector:new(x,y)
    local obj = {x = x, y = y}
    setmetatable(obj, self)
    return obj
end

-- @param Vector bVector
function Vector:Distance(bVector)
    local dx = (bVector.x - self.x)^2
    local dy = (bVector.y - self.y)^2

    return math.sqrt(dx + dy)
end

function Vector:normalize()
    local mag = self:magnitude()
    self.x = self.x / mag
    self.y = self.y / mag
end

function Vector:magnitude()
    return math.sqrt(self.x^2 + self.y^2)
end

function Vector.__add(a,b)
    return Vector:new(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a,b)
    return Vector:new(a.x - b.x, a.y - b.y)
end

function Vector.__mul(a,b)
    if type(b) == "number" then
        return Vector:new(a.x*b, a.y*b)
    else
        error("Cannot multiply type Vector with type \"" .. tostring(type(b)) .. "\"")
    end
end


return Vector