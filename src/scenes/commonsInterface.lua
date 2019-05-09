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
local antsGroup = display.newGroup()
local commonsGroup = display.newGroup()
local uiGroup = display.newGroup()
local effectsGroup = display.newGroup()
local shaderGroup = display.newGroup()
local lightGroup = display.newGroup() 
local exitButtonGroup = display.newGroup()

M.background = nil
M.cannon = nil
M.hpBar = nil
M.params = nil
M.stageNumber = nil
M.vehicle = nil
M.countdownTimer = nil
M.totalTime = nil
M.meters = 0
M.carVelocity = 140
M.cannonUiBar = nil
M.cannonUiMiniBar = nil
M.rain = nil
M.nextBarrierIndex = 1
M.machineReached = false
M.paused = false
M.stopped = false
M.timers = {}
M.machine = nil
M.timerUpdateDecimal = 0

local backgroundFactory = require("src.domain.background")
local cannonFactory = require("src.domain.cannon")
local eventFactory = require("src.scenes.eventListeners")
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
    -- local backgroundImage = display.newImageRect(mainBackGroup, "assets/images/backgrounds/" .. M.params.background, 
    -- display.pixelHeight, display.pixelWidth)
    local backgroundImage = display.newRect(mainBackGroup, display.contentCenterX, display.contentCenterY, display.viewableContentWidth, display.viewableContentHeight)
    -- backgroundImage.x = display.contentCenterX
    -- backgroundImage.y = display.contentCenterY
    backgroundImage:setFillColor(M.params.color.r, M.params.color.g, M.params.color.b)
    physics.addBody(backgroundImage, "dynamic", { isSensor=true })
    M.background = backgroundFactory:new(nil, backgroundImage, objectBackGroup, objectSecondaryBackGroup, mainBackGroup)
    M.background:buildBackground(M.carVelocity, M.params)
    if M.stageNumber == 5 then
        M.background:drawShader(shaderGroup)
    end

end

local function initiateCannon(ballGroup, fireButtonGroup, shootGroup, effectsGroup)
    M.cannon = cannonFactory:new(nil, M.vehicle, shootGroup, coolDownSquareGroup, effectsGroup)
    M.cannon:loadFiringButtons(M.params.availableBallTypes, ballGroup, fireButtonGroup, M)
end

local function initiateVehicle()
    local vehicleImage = display.newImageRect(commonsGroup, "assets/images/commons/tanktemporary.png", 45, 45)
    vehicleImage.x = 160
    vehicleImage.y = 370
    vehicleImage.myName = "vehicle"
    physics.addBody(vehicleImage, "dynamic", {isSensor = true})
    vehicleImage:toFront()
    M.vehicle = vehicleFactory:new(nil, vehicleImage, M.carVelocity, M.background, barrierGroup, effectsGroup, antsGroup, uiGroup, M)
    M.carVelocity = M.vehicle.carVelocity
    M.vehicle:initiateBoostLoop(M.background, barrierGroup, effectsGroup)
end

local function initiateRain()
    M.rain = true
end

local function timeIsUp()
    if M.paused == false then
        M.paused = true
        M.stopped = true
        local isPausing = true
        local stop = function () return M.vehicle:desaccelerateObjects(isPausing) end
        local stopTimer = timer.performWithDelay(500, stop, 10)
        table.insert(M.timers, stopTimer)
        local questionBox = display.newRoundedRect(exitButtonGroup, 40,
        -270, display.viewableContentWidth - 80, 240, 12)
        questionBox:setFillColor(0.7, 0.4, 0.2)
        questionBox.anchorX = 0
        questionBox.anchorY = 0
        local timeisUpText = "Time is up!"
        local timeIsUpTag = display.newText({parent=exitButtonGroup,text=timeisUpText, x=questionBox.x + 40,
            y=questionBox.y + 35, fontSize=35})
        timeIsUpTag.anchorX = 0
        local widget = require("widget")
        local sceneChanger = require("src.scenes.sceneChanger")
        local restartGame = function() return sceneChanger:gotoSceneTransition(M.stageNumber, "sameStage") end
        local exitGame = function() return sceneChanger:gotoSceneTransition(M.stageNumber, "gameover") end
        local buttonRetry = widget.newButton(
            {
                left = questionBox.x + 30,
                top = questionBox.y + 120,
                -- left = 30,
                -- top = 30,
                height = 60,
                width = 60,
                cornerRadius = 22,
                shape = "roundedRect",
                fillColor = { default={0.396,0.447,0.529,1}, over={1,0.1,0.7,1} },
                strokeColor = { default={0, 0, 0.2,1}, over={0.8,0.8,1,1} },
                strokeWidth = 1,
                onRelease= restartGame
            }
        )
        exitButtonGroup:insert(buttonRetry)
        local exit = widget.newButton(
            {
                left = questionBox.x + 140,
                top = questionBox.y + 120,
                height = 60,
                width = 60,
                cornerRadius = 22,
                shape = "roundedRect",
                fillColor = { default={0.396,0.447,0.529,1}, over={1,0.1,0.7,1} },
                strokeColor = { default={0,0,0.2,1}, over={0.8,0.8,1,1} },
                strokeWidth = 1,
                onRelease = exitGame
            }
        )
        exitButtonGroup:insert(exit)
        local repeatIcon = display.newImage(exitButtonGroup, "assets/images/commons/ui/rep.png", buttonRetry.x, buttonRetry.y)
        local exitIcon = display.newImage(exitButtonGroup, "assets/images/commons/ui/x.png", exit.x,
        exit.y)

        transition.to(exitButtonGroup, {time=2000, y=(display.viewableContentHeight / 2) + 30 })
    end
end

local function machineChecking()
    if M.paused == false and M.stopped == false then
        if M.machine.y >= display.viewableContentWidth / 3 then
            M.stopped = true
            M.machine:setLinearVelocity(0, 0)
            eventFactory:removeVehicleHitListener()
            local sceneChanger = require("src.scenes.sceneChanger")
            sceneChanger:gotoSceneTransition(M.stageNumber, "stageBetween")
        end
    end
end

local function initiateMachineCheck(countdownTimer)
    local machineCheck = function() return machineChecking() end
    local machineTimer = timer.performWithDelay(100, machineCheck, countdownTimer * 10)
    table.insert(M.timers,machineTimer)
end

local function checkingDeath()
    if M.vehicle.hp == 0 and M.stopped == false then
        M.stopped = true
        M.vehicle:initiateDestroyedAnimation(M.background, barrierGroup, effectsGroup)
    end
end

local function initiateDeathChecker(countdownTimer)
    checkDeath = function() return checkingDeath() end
    local deathTimer = timer.performWithDelay(500, checkingDeath, countdownTimer * 2)
    table.insert(M.timers, deathTimer)
end

local function updateMeasures(event, countdownText)
    M.timerUpdateDecimal = M.timerUpdateDecimal + 1
    if M.timerUpdateDecimal == 5 then
        M.countdownTimer = M.countdownTimer - 1    
        M.timerUpdateDecimal = 0
        countdownText.text = M.countdownTimer
    end
    M.meters = M.meters + (M.vehicle.carVelocity / 5)
    if M.countdownTimer <= 30 and M.rain == nil and M.machineReached == false then
        initiateRain()
    end
    if M.countdownTimer == 0 and M.machineReached == false then
        timeIsUp()
    end
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
    local measurerTimer = timer.performWithDelay(200, updateMeasures, M.totalTime * 5)
    table.insert(M.timers, measurerTimer)
end

local function positionCheck(patterns, barrierFactory, countdownTimer)
    if patterns[M.nextBarrierIndex] ~= nil and M.meters >= patterns[M.nextBarrierIndex]["time"] then
        local patternIndex = M.nextBarrierIndex * 1
        M.nextBarrierIndex = M.nextBarrierIndex + 1
        local pattern = patterns[patternIndex]
        local type = pattern["type"]
        if type == "machine" then
            initiateMachineCheck(countdownTimer)
            M.machine = display.newImage(barrierGroup, "assets/images/commons/machine.png")
            M.machine.x = display.viewableContentWidth / 2
            M.machine.y = -260
            M.machine.myName = "machine"
            physics.addBody(M.machine, "dynamic", {isSensor=true})
            M.machine:setLinearVelocity(0, M.vehicle.carVelocity)
        else
            local barrier = barrierFactory:new()
            barrier:drawBarrier(barrierGroup, pattern, M.vehicle.carVelocity, barrier, patternIndex)
        end
    end
end

local function initiateBarriers(stageNumber, barrierGroup, countdownTimer)
    local patternFilePath = "src.barrierPatterns.stage" .. tostring(stageNumber)
    local patternList = require(patternFilePath)
    local patterns = patternList:getPatterns()
    local barrierFactory = require("src.domain.barrier")
    local positioningcheck = function() return positionCheck(patterns, barrierFactory, countdownTimer, eventFactory) end
    local positionChecker = timer.performWithDelay(200, positioningcheck, 0)
    table.insert(M.timers, positionChecker)
end

local function fillGroupsIntoSceneGroup(sceneGroup)
    sceneGroup:insert(mainBackGroup)
    sceneGroup:insert(objectBackGroup)
    sceneGroup:insert(objectSecondaryBackGroup)
    sceneGroup:insert(barrierGroup)
    sceneGroup:insert(backgroundUiGroup)
    sceneGroup:insert(shootGroup)
    sceneGroup:insert(fireButtonGroup)
    sceneGroup:insert(ballGroup)
    sceneGroup:insert(coolDownSquareGroup)
    sceneGroup:insert(antsGroup)
    sceneGroup:insert(commonsGroup)
    sceneGroup:insert(uiGroup)
    sceneGroup:insert(effectsGroup)
    sceneGroup:insert(shaderGroup)
    sceneGroup:insert(lightGroup)
    sceneGroup:insert(exitButtonGroup)
end

function M.initiateCommons(sceneGroup, stageNumber, countdownTimer)
    M.stageNumber = stageNumber
    fillGroupsIntoSceneGroup(sceneGroup)
    getStageParameters(stageNumber)
    initiateBackground()
    initiateUiElements(uiGroup, countdownTimer)
    initiateVehicle()
    initiateCannon(ballGroup, fireButtonGroup, shootGroup, effectsGroup)
    initiateBarriers(stageNumber, barrierGroup, countdownTimer)
    initiateDeathChecker(countdownTimer, barrierGroup, effectsGroup)
    eventFactory:initiateCommonListeners(M, effectsGroup, barrierGroup, backgroundUiGroup)
end

function M.destroyCommons()
    eventFactory:removeEventListeners()
    for k, v in ipairs(M.timers) do
        timer.cancel(v)
    end
end

return M