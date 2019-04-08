local Barrier = {pieces = {}, type = {}}

function Barrier:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Barrier:drawBarrier(pieceGroup, pattern, carVelocity, barrier, patternIndex)
    local pieceSize = 30
    local patternGenerator = require("src.barrierPatterns.patternGenerator")
    local aBarrier = patternGenerator:drawPattern(pieceGroup, pattern, pieceSize, carVelocity, barrier, patternIndex)
    self.pieces = aBarrier["pieces"]
    self.type = aBarrier["type"]
end

function Barrier:destroyBarrier()
end

return Barrier