-- Min value: 50, max value: 240 (note: max is the right anchor. multiply value * pieceSize * numberOfPieces)
-- Variable time is not counting time, but rather distance. The name was not changed to avoid problems
-- Ant fixing car takes approximately 9 seconds
-- Drive speed is 140 pixels per second
local M = {}

local patterns = {
    -- [1] = {type = "machine", time = 200},
    [1] = {type = "sodium", time = 500, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [2] = {type = "sodium", time = 800, xAnchor = 65, pattern = {
        form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 7}}},
    [3] = {type = "chlorine", time = 1000, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 7}},
    [4] = {type = "chlorine", time = 1300, xAnchor = 90, pattern = {form = "line", dimensions = 1, numberOfPieces = 5}},
    [5] = {type = "chlorine", time = 1400, xAnchor = 65, pattern = {form = "line", dimensions = 1, numberOfPieces = 5}},
    [6] = {type = "chlorine", time = 1800, xAnchor = 120, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [7] = {type = "chlorine", time = 2000, xAnchor = 90, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 4}}},
    [8] = {type = "chlorine", time = 2400, xAnchor = 80, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [9] = {type = "chlorine", time = 2600, xAnchor = 190, pattern = {form = "line", dimensions = 1, numberOfPieces = 2}},
    [10] = {type = "sodium", time = 2800, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 2}}},
    [11] = {type = "chlorine", time = 2400, xAnchor = 190, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y=2}}},
    [12] = {type = "sodium", time = 3300, xAnchor = 65, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 5}}},
    [13] = {type = "ferrum", time = 3800, xAnchor = 165, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 3}}},
    [14] = {type = "ferrum", time = 3800, xAnchor = 75, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 3}}},
    [15] = {type = "ferrum", time = 4300, xAnchor = 165, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 4}}},
    [16] = {type = "ferrum", time = 4700, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 3}}},
    [17] = {type = "chlorine", time = 5500, xAnchor = 60, pattern = {form = "line", dimensions = 1, numberOfPieces = 1}},
    [18] = {type = "chlorine", time = 5500, xAnchor = 95, pattern = {form = "line", dimensions = 1, numberOfPieces = 2}},
    [19] = {type = "chlorine", time = 5600, xAnchor = 130, pattern = {form = "line", dimensions = 1, numberOfPieces = 1}},
    [20] = {type = "chlorine", time = 5600, xAnchor = 165, pattern = {form = "line", dimensions = 1, numberOfPieces = 1}},
    [21] = {type = "chlorine", time = 5700, xAnchor = 60, pattern = {form = "line", dimensions = 1, numberOfPieces = 2}},
    [22] = {type = "chlorine", time = 5700, xAnchor = 180, pattern = {form = "line", dimensions = 1, numberOfPieces = 2}},
    [23] = {type = "chlorine", time = 6100, xAnchor = 130, pattern = {form = "line", dimensions = 1, numberOfPieces = 1}},
    [24] = {type = "chlorine", time = 6400, xAnchor = 60, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [25] = {type = "ferrum", time = 6400, xAnchor = 151, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [26] = {type = "ferrum", time = 6600, xAnchor = 60, pattern = {form = "line", dimensions = 1, numberOfPieces = 1}},
    [27] = {type = "ferrum", time = 6600, xAnchor = 190, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [28] = {type = "ferrum", time = 6700, xAnchor = 92, pattern = {form = "line", dimensions = 1, numberOfPieces = 1}},
    [29] = {type = "ferrum", time = 6700, xAnchor = 178, pattern = {form = "line", dimensions = 1, numberOfPieces = 2}},
    [30] = {type = "ferrum", time = 7200, xAnchor = 85, pattern = {form = "line", dimensions = 1, numberOfPieces = 7}},
    [31] = {type = "machine", time = 8000}
}

function M:getPatterns()
    return patterns

end

return M