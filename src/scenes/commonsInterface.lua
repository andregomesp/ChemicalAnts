local M = {}
local mainBackGroup = display.newGroup()
local objectBackGroup = display.newGroup()
local shootGroup = display.newGroup()
local fireButtonGroup = display.newGroup()
local ballGroup = display.newGroup()
local commonsGroup = display.newGroup()
local coolDownSquareGroup = display.newGroup()
local uiGroup = display.newGroup()

M.background = nil
M.cannon = nil
M.hpBar = nil
M.hpBarImage = nil
M.params = nil
M.stageParameters = nil
M.vehicle = nil

local backgroundFactory = require("src.domain.background")
local cannonFactory = require("src.domain.cannon")
local eventFactory = require("src.scenes.eventListeners")
local stageParameters = require("src.scenes.sceneParameters")
local vehicleFactory = require("src.domain.vehicle")

local function getStageParameters(stageNumber)
    params = require("src.scenes.sceneParameters")
    M.params = params.getParameters(stageNumber)
end

local function initiateBackground()
    local backgroundImage = display.newImageRect(mainBackGroup, "assets/images/backgrounds/" .. M.params.background, display.pixelHeight, display.pixelWidth)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY
    physics.addBody(backgroundImage, "dynamic", { isSensor=true })

    local i = 0
    while i < 5 do
        local roadTile = display.newImageRect(objectBackGroup, "assets/images/backgrounds/smallDirtyRoadTile.png", 160, 200)
        roadTile.x = 160
        roadTile.y = -(200 * i) + 600
        i = i + 1
    end
    physics.addBody(objectBackGroup, "dynamic", {isSensor = true})
    M.background = backgroundFactory:new(nil, backgroundImage, objectBackGroup, mainBackGroup)
end

local function initiateCannon(ballGroup, fireButtonGroup, shootGroup)
    M.cannon = cannonFactory:new(nil, M.vehicle, shootGroup, coolDownSquareGroup)
    M.cannon:loadFiringButtons(M.params.availableBallTypes, ballGroup, fireButtonGroup)
end

local function initiateVehicle()
    local vehicleImage = display.newImageRect(commonsGroup, "assets/images/commons/tanktemporary.png", 55, 55)
    vehicleImage.x = 160
    vehicleImage.y = 400
    vehicleImage.myName = vehicleImage
    physics.addBody(vehicleImage, "dynamic")
    vehicleImage:toFront()
    M.vehicle = vehicleFactory:new(nil, vehicleImage)
end

function M.initiateCommons(stageNumber)
    getStageParameters(stageNumber)
    initiateBackground()
    initiateVehicle()
    initiateCannon(ballGroup, fireButtonGroup, shootGroup)
    eventFactory:initiateCommonListeners(M, shootGroup)
end

return M