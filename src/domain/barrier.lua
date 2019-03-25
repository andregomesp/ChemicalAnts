Barrier = {pieces = {}, type = {}}

function Barrier:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Barrier:drawBarrier(barrierGroup, pattern, carVelocity, barrier)
    local pieceSize = 25
    local patternGenerator = require("src.barrierPatterns.patternGenerator")
    local barrier = patternGenerator:drawPattern(barrierGroup, pattern, pieceSize, carVelocity, barrier)
    self.pieces = barrier["pieces"]
    self.type = barrier["type"]
end

function Barrier:destroyBarrier()
end

return Barrier