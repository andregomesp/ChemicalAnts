Barrier = {pieces = {}, type = {}}

function Barrier:new(o, pieces, type)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.pieces = pieces
    self.type = type
end

function Barrier:drawBarrier()
end

function Barrier:destroyBarrier()
end

return Barrier