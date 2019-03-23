local M = {}



local function getWallPiecesPosition(patternType, numberOfPieces, xAnchor, yAnchor, pieceSize)
    local positions = {} 
    local i = 0
    while i < numberOfPieces do 
        local x = nil
        local y = nil
        if (patternType == "line") then
            x = ((i + 1) * pieceSize) + xAnchor - 1
            y = yAnchor
        end
        local position = {xPos = x, yPos = y}
        table.insert(positions, position)
        i = i + 1
    end
    return positions    
end

function M:drawPattern(stage, patternNumber, barrierGroup, xAnchor, yAnchor, pieceSize, carVelocity, barrier)
    local pretty = require("libraries.penlight.pretty")
    local stageFile = "src.barrierPatterns.stage" .. stage
    local patternList = require(stageFile)
    local pattern = patternList:getPattern(patternNumber)
    local i = 0
    local imageTable = {}
    local numberOfPieces = pattern["pattern"]["numberOfPieces"]
    local positions = getWallPiecesPosition(pattern["pattern"]["form"], numberOfPieces, xAnchor, yAnchor, pieceSize)
    while i < numberOfPieces do
        local piece = "middle"
        if (i == 0) then
            piece = "left-border"
        elseif (i == numberOfPieces - 1) then
            piece = "right-border"
        end
        local image = display.newImageRect(barrierGroup, "assets/images/commons/barriers/" .. pattern["type"] .. "-" .. piece .. ".png", pieceSize, pieceSize)
        image.class = "barrier"
        image.barrier = barrier
        image.element = pattern["type"]
        image.x = positions[i+1]["xPos"]
        image.y = positions[i+1]["yPos"]
        physics.addBody(image, "dynamic", {isSensor = true})
        image:setLinearVelocity(0, carVelocity)
        table.insert(imageTable, image)
        i = i + 1
    end
    return {pieces = imageTable, type = pattern["type"]}
end

return M

