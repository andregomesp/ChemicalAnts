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
    [5] = {type = "sodium", time = 1800, xAnchor = 120, pattern = {form = "line", dimensions = 1, numberOfPieces = 3}},
    [6] = {type = "sodium", time = 2000, xAnchor = 90, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 4}}},
    [7] = {type = "chlorine", time = 2400, xAnchor = 80, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
    [8] = {type = "sodium", time = 2800, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 5, y= 2}}},
    [9] = {type = "sodium", time = 3300, xAnchor = 55, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 5}}},
    [10] = {type = "ferrum", time = 3800, xAnchor = 105, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 5}}},
    [11] = {type = "chlorine", time = 4200, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 3}}},
    [12] = {type = "ferrum", time = 4700, xAnchor = 97, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 2}}},
    [13] = {type = "chlorine", time = 5000, xAnchor = 137, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 4}}},
    [14] = {type = "sodium", time = 5400, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 1, y= 5}}},
    [15] = {type = "sodium", time = 5800, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 4, y= 2}}},
    [16] = {type = "sodium", time = 6200, xAnchor = 155, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 2}}},
    [17] = {type = "sodium", time = 6700, xAnchor = 100, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 3}}},
    [18] = {type = "sodium", time = 7400, xAnchor = 55, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x=8, y= 1}}},
    [19] = {type = "sodium", time = 7500, xAnchor = 115, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x=8, y= 1}}},
    [20] = {type = "sodium", time = 7600, xAnchor = 165, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x=8, y= 1}}},
    [21] = {type = "sodium", time = 7700, xAnchor = 200, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x=8, y= 1}}},
    [22] = {type = "sodium", time = 8300, xAnchor = 78, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x=8, y= 1}}},
    [23] = {type = "sodium", time = 8400, xAnchor = 185, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x=8, y= 1}}},
    [24] = {type = "machine", time = 9000}
}

function M:getPatterns()
    return patterns

end

return M