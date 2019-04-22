local M = {}
local mainBackGroup = display.newGroup()
local objectBackGroup = display.newGroup()
local objectSecondaryBackGroup = display.newGroup()
local barrierGroup = display.newGroup()
local backgroundUiGroup = display.newGroup()
local shootGroup = display.newGroup()
local fireButtonGroup = display.newGroup()
local ballGroup = display.newGroup()
local coolDownSquareGroup = display.newGroup()
local commonsGroup = display.newGroup()
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
M.cannonUiBar = nil
M.cannonUiMiniBar = nil
M.nextBarrierIndex = 1

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

local function drawCannonUI()
    local height = 110
    local miniHeight = 30
    local yPos = display.viewableContentHeight - height
    local miniYPos = display.viewableContentHeight - height - miniHeight
    local cannonUI = display.newImageRect(backgroundUiGroup, "assets/images/commons/ui/cannon_ui_texture.png", display.viewableContentWidth,
        height)
    cannonUI.x = 0
    cannonUI.y = yPos
    cannonUI.myName = "cannon"
    cannonUI.anchorX = 0
    cannonUI.anchorY = 0
    cannonUI:setFillColor(0.458, 0.686, 0.717)
    local miniStatusBar = display.newRect(backgroundUiGroup, 0, yPos, display.viewableContentWidth,
     miniHeight)
     miniStatusBar.y = miniYPos
    miniStatusBar.anchorX = 0
    miniStatusBar.anchorY = 0
    local miniStatusGradient = {
        type="gradient",
        color1= {0.4, 0.4, 0.8}, color2={0.9, 0.9, 1}, direction="down"
    }
    miniStatusBar:setFillColor(miniStatusGradient)
    miniStatusBar:setStrokeColor(0, 0, 0)
    miniStatusBar.strokeWidth = 0
    M.cannonUiBar = cannonUI
    M.miniStatusBar = miniStatusBar
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
    vehicleImage.y = 370
    vehicleImage.myName = "vehicle"
    physics.addBody(vehicleImage, "dynamic", {isSensor = true})
    vehicleImage:toFront()
    M.vehicle = vehicleFactory:new(nil, vehicleImage, M.carVelocity, M.background, barrierGroup)
    M.carVelocity = M.vehicle.carVelocity
    M.vehicle:initiateBoostLoop(M.background, barrierGroup)
end

local function updateMeasures(event, countdownText)
    M.countdownTimer = M.countdownTimer - 1
    countdownText.text = M.countdownTimer
    M.meters = M.meters + M.vehicle.carVelocity
end

local function initiateUiElements(uiGroup, countdownTimer)
    -- CANNON UI
    drawCannonUI()

    -- HP Bar
    M.hpBar = hpBarFactory:new()
    M.hpBar:drawBar(uiGroup)

    -- Boost label
    local boostLabel = display.newText({parent = uiGroup, text = "Boost", x = display.viewableContentWidth - 80, y = display.viewableContentHeight - 125,
    font = "DejaVuSansMono", width = 70})
    boostLabel:setFillColor(0, 0, 0)
    -- Countdown Timer
    M.countdownTimer = countdownTimer
    M.totalTime = countdownTimer * 1
    local backCircle = display.newRoundedRect(uiGroup, display.contentCenterX - 20, 15, 60, 20, 10)
     backCircle:setFillColor(0, 0, 0, 0.3)
    local countdownText = display.newText({parent = uiGroup, text = M.countdownTimer, x = display.contentCenterX, y = 15,
    font = "DejaVuSansMono", width = 70})
    local updateMeasures = function() return updateMeasures(event, countdownText) end
    timer.performWithDelay(1000, updateMeasures, M.totalTime)
end

local function positionCheck(patterns, barrierFactory)
    if patterns[M.nextBarrierIndex] ~= nil and M.meters >= patterns[M.nextBarrierIndex]["time"] then
        local patternIndex = M.nextBarrierIndex * 1
        M.nextBarrierIndex = M.nextBarrierIndex + 1
        local pattern = patterns[patternIndex]
        local barrier = barrierFactory:new()
        barrier:drawBarrier(barrierGroup, pattern, M.carVelocity, barrier, patternIndex)
    end
end

local function initiateBarriers(stageNumber, barrierGroup)
    local patternFilePath = "src.barrierPatterns.stage" .. tostring(stageNumber)
    local patternList = require(patternFilePath)
    local patterns = patternList:getPatterns()
    local barrierFactory = require("src.domain.barrier")
    -- local i = 1
    local positioningcheck = function() return positionCheck(patterns, barrierFactory) end
    timer.performWithDelay(1000, positioningcheck, 0)
    -- while i <= #patterns do
    --     local pattern = patterns[i]
    --     local time = patterns[i]["time"]
    --     local patternIndex = i * 1
    --     local newBarrier = function()
    --         local barrier = barrierFactory:new()
    --         barrier:drawBarrier(barrierGroup, pattern, M.carVelocity, barrier, patternIndex)
    --     end
    --     timer.performWithDelay(time, newBarrier)
    --     i = i + 1
    -- end
end

function M.initiateCommons(stageNumber, availableBallTypes, countdownTimer)
    getStageParameters(stageNumber)
    initiateBackground()
    initiateUiElements(uiGroup, countdownTimer)
    initiateVehicle()
    initiateCannon(ballGroup, fireButtonGroup, shootGroup, effectsGroup)
    initiateBarriers(stageNumber, barrierGroup)
    eventFactory:initiateCommonListeners(M, effectsGroup, barrierGroup, backgroundUiGroup)
end

return M