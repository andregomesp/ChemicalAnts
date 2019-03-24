local M = {}
local mainBackGroup = display.newGroup()
local objectBackGroup = display.newGroup()
local objectSecondaryBackGroup = display.newGroup()
local barrierGroup = display.newGroup()
local shootGroup = display.newGroup()
local fireButtonGroup = display.newGroup()
local ballGroup = display.newGroup()
local commonsGroup = display.newGroup()
local coolDownSquareGroup = display.newGroup()
local uiGroup = display.newGroup()
local effectsGroup = display.newGroup()

M.background = nil
M.cannon = nil
M.hpBar = nil
M.hpBarImage = nil
M.params = nil
M.stageParameters = nil
M.vehicle = nil
M.carVelocity = 180

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
    M.background = backgroundFactory:new(nil, backgroundImage, objectBackGroup, objectSecondaryBackGroup, mainBackGroup)
    M.background:buildBackground(M.carVelocity)

end

local function initiateCannon(ballGroup, fireButtonGroup, shootGroup, effectsGroup)
    M.cannon = cannonFactory:new(nil, M.vehicle, shootGroup, coolDownSquareGroup, effectsGroup)
    M.cannon:loadFiringButtons(M.params.availableBallTypes, ballGroup, fireButtonGroup)
end

local function initiateVehicle()
    local vehicleImage = display.newImageRect(commonsGroup, "assets/images/commons/tanktemporary.png", 45, 45)
    vehicleImage.x = 160
    vehicleImage.y = 400
    vehicleImage.myName = vehicleImage
    physics.addBody(vehicleImage, "dynamic")
    vehicleImage:toFront()
    M.vehicle = vehicleFactory:new(nil, vehicleImage)
end

-- Temporary: delete as soon as test is ok
-- Todo: build real way of calling the barriers
local function initiateBarriers(stageNumber, barrierGroup)
    local patternFilePath = "src.domain.barrierPatterns.stage" .. tostring(stageNumber)
    local patterns = patternFilePath:getPatterns()
    local barrierFactory = require("src.domain.barrier")
    local barrier = barrierFactory:new()
    barrier:drawBarrier(stageNumber, 0, barrierGroup, 60, 20, 25, M.carVelocity, barrier)

end

function M.initiateCommons(stageNumber)
    getStageParameters(stageNumber)
    initiateBackground()
    initiateVehicle()
    initiateCannon(ballGroup, fireButtonGroup, shootGroup, effectsGroup)
    eventFactory:initiateCommonListeners(M, shootGroup)
    initiateBarriers(stageNumber, barrierGroup)

end

return M