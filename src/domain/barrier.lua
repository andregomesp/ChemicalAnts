Barrier = {balls = {}}

function Barrier:new(o, balls, type)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.balls = balls
    self.type = type
end

function Barrier:drawBarrier()
end

function Barrier:destroyBarrier()
end

return Barrier