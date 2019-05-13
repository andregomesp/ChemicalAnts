-- Min value: 50, max value: 240 (note: max is the right anchor. multiply value * pieceSize * numberOfPieces)
--
local M = {}

local patterns = {
    -- [1] = {type = "machine", time = 200},
    [1] = {type = "sodium", time = 500, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [2] = {type = "sodium", time = 800, xAnchor = 65, pattern = {
        form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 7}}},
    [3] = {type = "chlorine", time = 1000, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 7}},
    [4] = {type = "chlorine", time = 1400, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 5}},
    [5] = {type = "chlorine", time = 1800, xAnchor = 120, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [6] = {type = "chlorine", time = 2000, xAnchor = 90, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 4}}},
    [7] = {type = "chlorine", time = 2400, xAnchor = 80, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [8] = {type = "sodium", time = 2800, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 2}}},
    [9] = {type = "sodium", time = 3300, xAnchor = 65, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 5}}},
    [10] = {type = "ferrum", time = 3800, xAnchor = 105, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 3}}},
    [11] = {type = "ferrum", time = 3800, xAnchor = 105, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 3}}},
    [12] = {type = "ferrum", time = 4300, xAnchor = 80, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 3}}},
    [13] = {type = "ferrum", time = 4700, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 3}}},
    [14] = {type = "machine", time = 5100}
}

function M:getPatterns()
    return patterns

end

return M