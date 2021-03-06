-- Path is set to work with X between 50 to 240
-- Current size is 70
-- Therefore, eligible size is 50 to 190
-- Size between them must be bigger than 46
local M = {}
local currentPattern = 0
local patternStage = 0
local currentFactory = require("src.domain.waterCurrents")

local function setNewCurrentVariable()
    return currentFactory:new()
end

local function destroyCurrentObject(current)
    current = nil
end

local function createCurrentInPattern(currentsGroup, orientation, xPos, currentsTable, vehicleImage)
    local current = setNewCurrentVariable()
    table.insert(currentsTable, current)
    current:createCurrent(currentsGroup, orientation, xPos, vehicleImage)
    local currentDestroyer = function() return current:destroyWaterCurrent() end
    local currentObjectDestroyer = function() return destroyCurrentObject(current) end
    timer.performWithDelay(4000, currentDestroyer)
    timer.performWithDelay(5000, currentObjectDestroyer)
end

function M:shuffleCurrents(currentTime, currentsGroup, currentsTable, vehicleImage)
    if currentPattern == 0 then
        if patternStage == 0 then
            createCurrentInPattern(currentsGroup, -1, 80, currentsTable, vehicleImage)
            patternStage = patternStage + 1
        elseif patternStage == 1 and currentTime <= 45 then
            createCurrentInPattern(currentsGroup, 1, 120, currentsTable, vehicleImage)
            currentPattern = currentPattern + 1
            patternStage = 0

        end
    elseif currentPattern == 1 then
        if patternStage == 0 and currentTime <= 35 then
            createCurrentInPattern(currentsGroup, -1, 60, currentsTable, vehicleImage)
            createCurrentInPattern(currentsGroup, -1, 60 + (vehicleImage.width * 3) + 2, currentsTable, vehicleImage)
            patternStage = patternStage + 1
        elseif patternStage == 1 and currentTime <= 30 then
            createCurrentInPattern(currentsGroup, 1, 110, currentsTable, vehicleImage)
            createCurrentInPattern(currentsGroup, 1, 110 + (vehicleImage.width * 3) + 2, currentsTable, vehicleImage)
            currentPattern = currentPattern + 1
            patternStage = 0
        end
    elseif currentPattern == 2 and currentTime <= 15 then
        createCurrentInPattern(currentsGroup, 1, 95, currentsTable, vehicleImage)
        createCurrentInPattern(currentsGroup, -1, 95 + (vehicleImage.width * 3.5) + 2, currentsTable, vehicleImage)
        currentPattern = currentPattern + 1
        patternStage = 0
    end
end

return M