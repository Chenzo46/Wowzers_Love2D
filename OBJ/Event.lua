Event = {}

function Event:new()
    local obj = { listeners = {} }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Event:subscribe(callback)
    table.insert(self.listeners, callback)
end

function Event:emit(...)
    --print("Event Callback Triggered")
    for _, fn in ipairs(self.listeners) do
        fn(...)
    end
end

return Event