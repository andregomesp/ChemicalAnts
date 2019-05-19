local WaterCurrent = {}

function WaterCurrent:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function WaterCurrent:createCurrent()
    self.image = display.newImage
end

return WaterCurrent