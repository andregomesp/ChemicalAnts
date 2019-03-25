local M = {}



local function getWallPiecesPosition(pattern, pieceSize)
    local positions = {}
    local form = pattern["pattern"]["form"]
    local numberOfPieces = pattern["pattern"]["numberOfPieces"]
    local xAnchor = pattern["xAnchor"] 
    local i = 0
    while i < numberOfPieces do 
        local x = nil
        local y = nil
        if (form == "line") then
            x = ((i + 1) * pieceSize) + xAnchor - 1
            y = -30
        end
        local position = {xPos = x, yPos = y}
        table.insert(positions, position)
        i = i + 1
    end
    return positions    
end

function M:drawPattern(barrierGroup, pattern, pieceSize, carVelocity, barrier)
    local imageTable = {}
    local numberOfPieces = pattern["pattern"]["numberOfPieces"]
    local type = pattern["type"]
    local positions = getWallPiecesPosition(pattern, pieceSize)
    local i = 0
    while i < numberOfPieces do
        local piece = "middle"
        if (i == 0) then
            piece = "left-border"
        elseif (i == numberOfPieces - 1) then
            piece = "right-border"
        end
        local image = display.newImageRect(barrierGroup, "assets/images/commons/barriers/" .. type .. "-" .. piece .. ".png", pieceSize, pieceSize)
        image.myName = "barrier"
        image.barrier = barrier
        image.element = type
        image.x = positions[i+1]["xPos"]
        image.y = positions[i+1]["yPos"]
        physics.addBody(image, "dynamic", {isSensor = true})
        image:setLinearVelocity(0, carVelocity - 5)
        table.insert(imageTable, image)
        i = i + 1
    end
    return {pieces = imageTable, type = type}
end

return M

