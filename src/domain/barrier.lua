Barrier = {pieces = {}, type = {}}

function Barrier:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
end

function Barrier:drawBarrier(stage, patternNumber, barrierGroup, xAnchor, yAnchor, pieceSize, carVelocity)
    local barrierGenerator = require("src.barrierPatterns.patternGenerator")
    local barrier = barrierGenerator:drawPattern(stage, patternNumber, barrierGroup, xAnchor, yAnchor, pieceSize, carVelocity)
    self.pieces = barrier["pieces"]
    self.type = barrier["type"]
end

function Barrier:destroyBarrier()
end

return Barrier