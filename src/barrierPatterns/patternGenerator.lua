local M = {}



local function getWallPiecesPosition(patternType)
    if (patternType == "line") then
    end
end

function M:drawPattern(stage, patternNumber, wallGroup, xAnchor, yAnchor)
    local patternList = require("src.barrierPatterns.stage1")
    local pattern = patternList:getPattern(patternNumber)
    local i = 0
    while i < pattern["numberOfPieces"] do
        local border = ""
        if (i = 0) then
            border = "left-border"
        elseif (i = pattern["numberOfPieces"]) do
            border = "right-border"
        end
        display.newImageRect(objectBackGroup, "" .. pattern["type"] .. "-" .. border, 25, 25)
        i = i + 1
    end

end

return M

