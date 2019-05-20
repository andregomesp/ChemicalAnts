-- Min value: 85, max value: 225 (note: max is the right anchor. multiply value * pieceSize * numberOfPieces)
-- Stage 5 has smaller space and darkness
local M = {}

local patterns = {
    -- [1] = {type = "machine", time = 200},
    [1] = {type = "ferrum", time = 500, xAnchor = 75, pattern = {form = "line", dimensions = 1, numberOfPieces = 4}},
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
    [12] = {type = "ferrum", time = 5000, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 28, y= 1}}},
    [13] = {type = "ferrum", time = 5100, xAnchor = 225, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 28, y= 1}}},
    [14] = {type = "sodium", time = 5500, xAnchor = 115, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 3}}},
    [15] = {type = "chlorine", time = 5700, xAnchor = 155, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 2}}},
    [16] = {type = "sodium", time = 6300, xAnchor = 125, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 4, y= 3}}},
    [17] = {type = "chlorine", time = 6700, xAnchor = 110, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 3}}},
    [18] = {type = "ferrum", time = 7100, xAnchor = 107, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 2}}},
    [19] = {type = "sodium", time = 7400, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 3}}},
    [20] = {type = "ferrum", time = 8000, xAnchor = 145, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 20, y= 1}}},
    [21] = {type = "chlorine", time = 8200, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 2}}},
    [22] = {type = "ferrum", time = 8300, xAnchor = 175, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 3, y= 3}}},
    [23] = {type = "chlorine", time = 8700, xAnchor = 85, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 2, y= 3}}},
    [24] = {type = "chlorine", time = 8800, xAnchor = 170, pattern = {form = "rectangle", dimensions = 2, numberOfPieces = {x= 4, y= 3}}},
    [25] = {type = "machine", time = 10000}
}

function M:getPatterns()
    return patterns

end

return M