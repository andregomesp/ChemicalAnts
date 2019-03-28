local Ball = {element = nil, image = nil}

function Ball:new(o, element, ballImage)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.element = element
    self.image = ballImage
    return o
end

return Ball

