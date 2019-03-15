-- stage 1 has both Na and Cl as barriers

--
local M = {}

local patterns = {
    [0] = {type = "sodium", pattern = {patternType = "line", numberOfPieces = 3}},
    [1] = {type = "sodium", pattern = {patternType = "line", numberOfPieces = 4}},
    [2] = {type = "sodium", pattern = {patternType = "column", numberOfPieces = 4}},
    [3] = {type = "chlorine", pattern = {patternType = "line", numberOfPieces = 2}},
    [4] = {type = "chlorine", pattern = {patternType = "line", numberOfPieces = 5}},
    [5] = {type = "sodium", pattern = {patternType = "stair-left", numberOfPieces = 4}},
}

function M:getPattern(number)
    return patterns[number]

end

return M