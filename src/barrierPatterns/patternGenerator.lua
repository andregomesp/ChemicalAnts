local M = {}



local function getWallPiecesPosition(patternType, pieceNumber, numberOfPieces, xAnchor, yAnchor)
    local positions = {}
    while pieceNumber < numberOfPieces do 
        local x = nil
        local y = nil
        if (patternType == "line") then
            x = pieceNumber * xAnchor
            y = pieceNumber
        end
        local position = {xPos = x, yPos = y}
        positions.insert(position)
    end
    return positions    
end

function M:drawPattern(stage, patternNumber, barrierGroup, xAnchor, yAnchor, pieceSize, carVelocity)
    local stageFile = "src.barrierPatterns.stage" .. stage
    local patternList = require(stageFile)
    local pattern = patternList:getPattern(patternNumber)
    local i = 0
    local imageTable = {}
    local positions = getWallPiecePosition(pattern["type"], i, pattern["numberOfPieces"], xAnchor, yAnchor)
    while i < pattern["numberOfPieces"] do
        local piece = "middle"
        if (i == 0) then
            piece = "left-border"
        elseif (i == pattern["numberOfPieces"]) then
            piece = "right-border"
        end
        local image = display.newImageRect(barrierGroup, "assets/images/barriers/" .. pattern["type"] .. "-" .. piece, pieceSize, pieceSize)
        image.x = positions[i].xPos
        image.y = positions[i].yPos
        physics.addBody(image, "dynamic", {isSensor = true})
        image:setLinearVelocity(0, carVelocity * -1)
        imageTable.insert(image)
        i = i + 1
    end
    return {pieces = imageTable, type = pattern["type"]}
end

return M

