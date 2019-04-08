-- stage 1 has both Na and Cl as barriers
-- Min value: 50, max value: 240 (note: max is the right anchor. multiply value * pieceSize * numberOfPieces)
--
local M = {}

local patterns = {
    -- [0] = {type = "sodium", pattern = {form = "line", numberOfPieces = 3}},
    -- [1] = {type = "sodium", pattern = {form = "line", numberOfPieces = 4}},
    -- [2] = {type = "sodium", pattern = {form = "column", numberOfPieces = 4}},
    -- [3] = {type = "chlorine", pattern = {form = "line", numberOfPieces = 2}},
    -- [4] = {type = "chlorine", pattern = {form = "line", numberOfPieces = 5}},
    -- [5] = {type = "sodium", pattern = {form = "stair-left", numberOfPieces = 4}},
    [1] = {type = "sodium", time = 1500, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [2] = {type = "sodium", time = 3000, xAnchor = 65, pattern = {
        form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 7}}
    },
    -- [2] = {type = "sodium", time = 2000, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [3] = {type = "sodium", time = 6600, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 7}},
    [4] = {type = "sodium", time = 8100, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 5}},
    [5] = {type = "sodium", time = 10700, xAnchor = 120, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [6] = {type = "sodium", time = 13000, xAnchor = 100, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
}

function M:getPatterns()
    return patterns

end

return M