-- Min value: 50, max value: 240 (note: max is the right anchor. multiply value * pieceSize * numberOfPieces)
-- Variable time is not counting time, but rather distance. The name was not changed to avoid problems
-- Ant fixing car takes approximately 9 seconds
-- Drive speed is 140 pixels per second
-- Piece size current set at 30
local M = {}

local patterns = {
    [1] = {type = "sodium", time = 500, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [2] = {type = "sodium", time = 800, xAnchor = 65, pattern = {
        form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 7}}},
    [3] = {type = "sodium", time = 1000, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 7}},
    [4] = {type = "chlorine", time = 1400, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 5}},
    [5] = {type = "chlorine", time = 1800, xAnchor = 120, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [6] = {type = "chlorine", time = 2000, xAnchor = 90, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 4}}},
    [7] = {type = "chlorine", time = 2400, xAnchor = 80, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [8] = {type = "sodium", time = 2800, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 5, y= 2}}},
    [9] = {type = "chlorine", time = 2900, xAnchor = 148, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 4, y= 3}}},
    [10] = {type = "chlorine", time = 3300, xAnchor = 55, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 5}}},
    [11] = {type = "chlorine", time = 3800, xAnchor = 105, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 5}}},
    [12] = {type = "sodium", time = 4000, xAnchor = 145, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 5}}},
    [13] = {type = "chlorine", time = 4200, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 3}}},
    [14] = {type = "sodium", time = 4600, xAnchor = 97, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [15] = {type = "sodium", time = 5300, xAnchor = 102, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 4}}},
    [16] = {type = "sodium", time = 5300, xAnchor = 102, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 4}}},
    [17] = {type = "chlorine", time = 5700, xAnchor = 140, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 4}}},
    [18] = {type = "sodium", time = 5800, xAnchor = 146, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 3}}},
    [19] = {type = "sodium", time = 6300, xAnchor = 60, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [20] = {type = "machine", time = 6600}
}

function M:getPatterns()
    return patterns

end

return M