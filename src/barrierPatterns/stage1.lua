-- Min value: 50, max value: 240 (note: max is the right anchor. multiply value * pieceSize * numberOfPieces)
-- Variable time is not counting time, but rather distance. The name was not changed to avoid problems
-- Ant fixing car takes approximately 9 seconds
-- Drive speed is 140 pixels per second
local M = {}

local patterns = {
    -- [1] = {type = "machine", time = 300},
    [1] = {type = "sodium", time = 500, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [2] = {type = "sodium", time = 900, xAnchor = 65, pattern = {
        form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 2}}},
    [3] = {type = "sodium", time = 1000, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 7}},
    [4] = {type = "sodium", time = 1300, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 5}},
    [5] = {type = "sodium", time = 1700, xAnchor = 120, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [6] = {type = "sodium", time = 2000, xAnchor = 90, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 2}}},
    [7] = {type = "sodium", time = 2500, xAnchor = 80, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [8] = {type = "sodium", time = 2900, xAnchor = 125, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 5, y= 4}}},
    [9] = {type = "sodium", time = 3400, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 7}},
    [10] = {type = "sodium", time = 3800, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [11] = {type = "sodium", time = 3800, xAnchor = 165, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [12] = {type = "sodium", time = 4700, xAnchor = 125, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [13] = {type = "sodium", time = 5000, xAnchor = 140, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x = 3, y = 2}}},
    [14] = {type = "machine", time = 5700}
}

function M:getPatterns()
    return patterns

end

return M