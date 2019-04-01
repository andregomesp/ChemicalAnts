local M = {}

local function getWallPiecesPosition(form, pieceSize, measures, numberOfPieces, xAnchor)
    local positions = {}
    local i = 1
    local row = 1
    while i <= numberOfPieces do 
        local x = nil
        local y = nil
        if (form == "line") then
            x = ((i - 1) * pieceSize) + xAnchor - 1
            y = -30
        elseif (form == "rectangle") then
            if (i % measures["x"] == 0) then
                row = row + 1
            end
            x = ((i - 1) * pieceSize) + xAnchor - 1
            y = (measures["y"] - row) * (pieceSize * -1) - 30 

        end
        local position = {xPos = x, yPos = y}
        table.insert(positions, position)
        i = i + 1
    end
    return positions    
end

function M:drawPattern(barrierGroup, pattern, pieceSize, carVelocity, barrier)
    local imageTable = {}
    local xAnchor = pattern["xAnchor"] 
    local type = pattern["type"]
    local form = pattern["pattern"]["form"]
    local dimensions = pattern["pattern"]["dimensions"]
    local numberOfPieces = nil
    local measures = nil
    if dimensions == 1 then
        numberOfPieces = pattern["pattern"]["numberOfPieces"]
    elseif dimensions == 2 then
        measures = pattern["pattern"]["numberOfPieces"]
        numberOfPieces = measures["x"] * measures["y"]
    end
    local positions = getWallPiecesPosition(form, pieceSize, measures, numberOfPieces, xAnchor)
    local measures = nil
    local i = 1
    local row = 1
    while i <= numberOfPieces do
        local piece = "middle"
        if (form == "line") then
            if (i == 1) then
                piece = "left-border"
            elseif (i == numberOfPieces) then
                piece = "right-border"
            end
        elseif (form == "rectangle") then
            local positionDefinition = i % measures["x"]
            local previousDefinition = ((i - 1) % measures["x"])
            if (i % measures["x"] == 0) then
                row = row + 1
            end
            if (((measures["x"] * row) - (measures["x"] - 1)) == i) then
            end
        end
        local image = display.newImageRect(barrierGroup, "assets/images/commons/barriers/" .. type .. "-" .. piece .. ".png", pieceSize, pieceSize)
        image.myName = "barrier"
        image.barrier = barrier
        image.element = type
        image.x = positions[i]["xPos"]
        image.y = positions[i]["yPos"]
        physics.addBody(image, "dynamic", {isSensor = true})
        image:setLinearVelocity(0, carVelocity - 5)
        table.insert(imageTable, image)
        i = i + 1
        
    end
    return {pieces = imageTable, type = type}
end

return M

