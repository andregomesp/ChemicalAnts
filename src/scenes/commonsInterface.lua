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
M.params = nil
M.stageParameters = nil
M.vehicle = nil
M.countdownTimer = nil
M.totalTime = nil
M.meters = 0
M.carVelocity = 140

local backgroundFactory = require("src.domain.background")
local cannonFactory = require("src.domain.cannon")
local eventFactory = require("src.scenes.eventListeners")
local stageParameters = require("src.scenes.sceneParameters")
local vehicleFactory = require("src.domain.vehicle")
local hpBarFactory = require("src.domain.hpBar")

local function getStageParameters(stageNumber)
    local params = require("src.scenes.sceneParameters")
    M.params = params.getParameters(stageNumber)
end

local function initiateBackground()
    local backgroundImage = display.newImageRect(mainBackGroup, "assets/images/backgrounds/" .. M.params.background, 
    display.pixelHeight, display.pixelWidth)
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
    vehicleImage.myName = "vehicle"
    physics.addBody(vehicleImage, "dynamic", {isSensor = true})
    vehicleImage:toFront()
    M.vehicle = vehicleFactory:new(nil, vehicleImage, M.carVelocity)
end

local function updateMeasures(event, countdownText)
    M.countdownTimer = M.countdownTimer - 1
    countdownText.text = M.countdownTimer
    print(M.meters)
    M.meters = M.meters + M.vehicle.carVelocity
end

local function initiateUiElements(uiGroup, countdownTimer)
    M.hpBar = hpBarFactory:new()
    M.hpBar:drawBar(uiGroup)
    M.countdownTimer = countdownTimer
    M.totalTime = countdownTimer * 1
    local backCircle = display.newRoundedRect(uiGroup, display.contentCenterX - 20, 15, 60, 20, 10)
     backCircle:setFillColor(0, 0, 0, 0.3)
    local countdownText = display.newText({parent = uiGroup, text = M.countdownTimer, x = display.contentCenterX, y = 15,
    font = "DejaVuSansMono", width = 70})
    local updateMeasures = function() return updateMeasures(event, countdownText) end
    timer.performWithDelay(1000, updateMeasures, M.totalTime)
end

local function initiateBarriers(stageNumber, barrierGroup)
    local patternFilePath = "src.barrierPatterns.stage" .. tostring(stageNumber)
    local patternList = require(patternFilePath)
    local patterns = patternList:getPatterns()
    local barrierFactory = require("src.domain.barrier")
    local i = 1
    while i <= #patterns do
        local pattern = patterns[i]
        local time = patterns[i]["time"]
        local patternIndex = i * 1
        local newBarrier = function()
            local barrier = barrierFactory:new()
            barrier:drawBarrier(barrierGroup, pattern, M.carVelocity, barrier, patternIndex)
        end
        timer.performWithDelay(time, newBarrier)
        i = i + 1
    end
end

function M.initiateCommons(stageNumber, availableBallTypes, countdownTimer)
    getStageParameters(stageNumber)
    initiateBackground()
    initiateVehicle()
    initiateCannon(ballGroup, fireButtonGroup, shootGroup, effectsGroup)
    eventFactory:initiateCommonListeners(M, shootGroup, effectsGroup)
    initiateBarriers(stageNumber, barrierGroup)
    initiateUiElements(uiGroup, countdownTimer)

end

return M