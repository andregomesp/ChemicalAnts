-- stage 1 has both Na and Cl as barriers
-- Min value: 50, max value: 240 (note: max is the right anchor. multiply value * pieceSize * numberOfPieces)
--
local M = {}

local patterns = {
    -- [1] = {type = "machine", time = 200},
    [1] = {type = "sodium", time = 200, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [2] = {type = "sodium", time = 400, xAnchor = 65, pattern = {
        form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 7}}},
    [3] = {type = "sodium", time = 600, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 7}},
    [4] = {type = "sodium", time = 900, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 5}},
    [5] = {type = "sodium", time = 1200, xAnchor = 120, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [6] = {type = "sodium", time = 1500, xAnchor = 90, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 4}}},
    [7] = {type = "sodium", time = 1800, xAnchor = 80, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [8] = {type = "sodium", time = 2100, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 5, y= 2}}},
    [7] = {type = "sodium", time = 2500, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 7}},
    [9] = {type = "machine", time = 3300}
}

function M:getPatterns()
    return patterns

end

return M