-- stage 1 has both Na and Cl as barriers

--
local M = {}

local patterns = {
    [0] = {type = "sodium", pattern = {form = "line", numberOfPieces = 3}},
    [1] = {type = "sodium", pattern = {form = "line", numberOfPieces = 4}},
    [2] = {type = "sodium", pattern = {form = "column", numberOfPieces = 4}},
    [3] = {type = "chlorine", pattern = {form = "line", numberOfPieces = 2}},
    [4] = {type = "chlorine", pattern = {form = "line", numberOfPieces = 5}},
    [5] = {type = "sodium", pattern = {form = "stair-left", numberOfPieces = 4}},
}

function M:getPattern(number)
    return patterns[number]

end

return M