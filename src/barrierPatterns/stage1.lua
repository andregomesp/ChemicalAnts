-- stage 1 has both Na and Cl as barriers

--
local M = {}

local patterns = {
    -- [0] = {type = "sodium", pattern = {form = "line", numberOfPieces = 3}},
    -- [1] = {type = "sodium", pattern = {form = "line", numberOfPieces = 4}},
    -- [2] = {type = "sodium", pattern = {form = "column", numberOfPieces = 4}},
    -- [3] = {type = "chlorine", pattern = {form = "line", numberOfPieces = 2}},
    -- [4] = {type = "chlorine", pattern = {form = "line", numberOfPieces = 5}},
    -- [5] = {type = "sodium", pattern = {form = "stair-left", numberOfPieces = 4}},
    [0] = {type = "sodium", time = 200, xAnchor = 140, pattern = {form = "line", numberOfPieces = 3}},
    [1] = {type = "sodium", time = 1000, xAnchor = 240, pattern = {form = "line", numberOfPieces = 4}},
    [2] = {type = "sodium", time = 1400, xAnchor = 140, pattern = {form = "line", numberOfPieces = 4}},
    [3] = {type = "sodium", time = 2200, xAnchor = 200, pattern = {form = "line", numberOfPieces = 2}},
    [4] = {type = "sodium", time = 3500, xAnchor = 140, pattern = {form = "line", numberOfPieces = 5}},
    [5] = {type = "sodium", time = 5000, xAnchor = 160, pattern = {form = "line", numberOfPieces = 4}},
}

function M:getPatterns()
    return patterns

end

return M