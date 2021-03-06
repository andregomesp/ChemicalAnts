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
local vehicleGroup = display.newGroup()
local uiGroup = display.newGroup()
local effectsGroup = display.newGroup()
local exitButtonGroup = display.newGroup()
local currentGroup = nil
local currentsTable = nil
local rainGroup = nil
local lightGroup = nil
local subLightGroup = nil
local shaderGroup = nil

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
M.machineReached = false    -- Machine was reached
M.paused = false            -- Game is currently paused
M.stopped = false           -- Car is stopped
M.timeIsUp = false          -- Time is up
M.timers = {}
M.machine = nil             -- Hold machine information when it appears
M.timerUpdateDecimal = 0    -- Measure milisecond in intervals until a second comes
M.goalMarker = require("src.engine.goalMarker")

local backgroundFactory = require("src.domain.background")
local cannonFactory = require("src.domain.cannon")
local eventFactory = require("src.scenes.eventListeners")
local vehicleFactory = require("src.domain.vehicle")
local hpBarFactory = require("src.domain.hpBar")
local sounds = require("src.engine.soundStash")

local function getStageParameters(stageNumber)
    local params = require("src.scenes.sceneParameters")
    M.params = params.getParameters(stageNumber)
end

local function drawCannonUI()
    local height = 110
    local miniHeight = 30
    local yPos = display.viewableContentHeight * 0.8
    local miniYPos = display.viewableContentHeight - height - miniHeight
    local cannonUI = display.newImageRect(backgroundUiGroup, "assets/images/commons/ui/cannon_ui_texture.png",
     display.viewableContentWidth,
        display.viewableContentHeight - yPos)
    cannonUI.x = 0
    cannonUI.y = yPos
    cannonUI.myName = "cannon"
    cannonUI.anchorX = 0
    cannonUI.anchorY = 0
    cannonUI:setFillColor(0.458, 0.686, 0.717)
    local miniStatusBar = display.newRect(backgroundUiGroup, 0, cannonUI.y * 0.94, display.viewableContentWidth,
     miniHeight)
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
    local backgroundImage = display.newRect(mainBackGroup, 0,
        0, display.viewableContentWidth, display.viewableContentHeight)
    backgroundImage.anchorX = 0
    backgroundImage.anchorY = 0
    backgroundImage:setFillColor(M.params.color.r, M.params.color.g, M.params.color.b)
    physics.addBody(backgroundImage, "dynamic", { isSensor=true })
    M.background = backgroundFactory:new(nil, backgroundImage, objectBackGroup, objectSecondaryBackGroup, mainBackGroup)
    M.background:buildBackground(M.carVelocity, M.params)
    if M.stageNumber == 4 then
        M.background:drawAquaShader(shaderGroup)
    elseif M.stageNumber == 5 then
        M.background:drawShader(shaderGroup)
    end
end

local function initiateCannon()
    M.cannon = cannonFactory:new(nil, M.vehicle, shootGroup, coolDownSquareGroup, effectsGroup)
    M.cannon:loadFiringButtons(M.params.availableBallTypes, ballGroup, fireButtonGroup, M, sounds, coolDownSquareGroup)
end

local function initiateVehicle()
    local vehicleImage = display.newImageRect(vehicleGroup, "assets/images/commons/tanktemporary.png", 45, 45)
    vehicleImage.x = display.contentCenterX
    vehicleImage.y = display.viewableContentHeight / 1.5
    vehicleImage.myName = "vehicle"
    physics.addBody(vehicleImage, "dynamic", {isSensor = true})
    vehicleImage:toFront()
    M.vehicle = vehicleFactory:new(nil, vehicleImage, barrierGroup, effectsGroup, antsGroup,
        uiGroup, M, sounds)
    M.carVelocity = M.vehicle.carVelocity
    M.vehicle:initiateBoostLoop(M.background, barrierGroup, effectsGroup)
end

local function initiateRain()
    M.rain = true
    local rainShader = display.newRect(rainGroup, 0, 0 , display.viewableContentWidth, display.viewableContentHeight)
    rainShader:setFillColor(0, 0, 0)
    rainShader.anchorX = 0
    rainShader.anchorY = 0
    rainShader.alpha = 0
    transition.to(rainShader, {alpha = 0.4, time = 2500})
    local cloudA = display.newImage(rainGroup, "assets/images/commons/clouds/cloud_01.png", display.viewableContentWidth + 180,
        4)
    local cloudB = display.newImage(rainGroup, "assets/images/commons/clouds/cloud_02.png", -160,
        3)
    local cloudC = display.newImage(rainGroup, "assets/images/commons/clouds/cloud_03.png", display.viewableContentWidth + 220,
        12)
    local cloudD = display.newImage(rainGroup, "assets/images/commons/clouds/cloud_04.png", - 180,
        10)

    cloudA.width = 220
    cloudA.height = 40
    cloudB.width = 250
    cloudB.height = 45
    cloudC.width = 260
    cloudC.height = 48
    cloudD.width = 250
    cloudD.height = 50

    sounds:playASound("thunder_clap.mp3")
    transition.to(cloudA, {time = 4500, x=display.viewableContentWidth / 1.8})
    transition.to(cloudB, {time = 4400, x=display.viewableContentWidth / 4.5})
    transition.to(cloudC, {time = 4600, x=display.viewableContentWidth / 1.4})
    transition.to(cloudD, {time = 4600, x=display.viewableContentWidth / 3.2})

end

local function timeIsUp()
    if M.timeIsUp == false and M.machineReached == false then
        M.stopped = true
        M.timeIsUp = true
        local stopVehicle = function () return M.vehicle:desaccelerateObjects() end
        local stopVehicleTimer = timer.performWithDelay(500, stopVehicle, 10)
        table.insert(M.timers, stopVehicleTimer)
        local miscMenus = require("src.engine.MiscMenus")
        miscMenus:drawTimeIsUpBox(exitButtonGroup, M.stageNumber)
        local failSong = function() return sounds:playASound("lose_game.mp3") end
        timer.performWithDelay(600, failSong)
    end
end

local function machineChecking()
    if M.timeIsUp == false and M.paused == false and M.stopped == false then
        if M.machine ~= nil then
            M.machineReached = true
        end
        if M.machine.y >= display.viewableContentWidth / 3 then
            M.stopped = true
            M.machine:setLinearVelocity(0, 0)
            eventFactory:removeVehicleHitListener()
            local sceneChanger = require("src.scenes.sceneChanger")
            local scene = "stageBetween"
            if M.stageNumber == 5 then
                scene = "gameover"
            end
            sceneChanger:gotoSceneTransition(M.stageNumber, scene)
        end
    end
end

local function initiateMachineCheck(countdownTimer)
    local machineTimer = timer.performWithDelay(100, machineChecking, countdownTimer * 10)
    table.insert(M.timers,machineTimer)
end

local function checkingDeath()
    if M.vehicle.hp == 0 and M.stopped == false then
        M.stopped = true
        M.vehicle:initiateDestroyedAnimation()
    end
end

local function initiateDeathChecker(countdownTimer)
    local deathTimer = timer.performWithDelay(500, checkingDeath, countdownTimer * 2)
    table.insert(M.timers, deathTimer)
end

local function updateMeasures(event, countdownText)
    M.timerUpdateDecimal = M.timerUpdateDecimal + 1
    if M.timerUpdateDecimal == 5 then
        M.countdownTimer = M.countdownTimer - 1
        M.timerUpdateDecimal = 0
        countdownText.text = M.countdownTimer
        M.goalMarker:remarkGoal(M.meters)
    end
    M.meters = M.meters + (M.vehicle.carVelocity / 5)
    if M.stageNumber ~= 4 and M.stageNumber ~= 5 and M.countdownTimer <= 30 and M.rain == nil and M.machineReached == false then
        initiateRain()
    end
    if M.countdownTimer == 0 and M.machineReached == false then
        timeIsUp()
    end
end

local function initiateUiElements(countdownTimer)
    -- CANNON UI
    drawCannonUI()

    -- HP Bar
    M.hpBar = hpBarFactory:new()
    M.hpBar:drawBar(uiGroup)

    -- Boost label
    local boostLabel = display.newText({parent = uiGroup, text = "Boost", x = M.miniStatusBar.x + M.miniStatusBar.width / 1.25,
        y = M.miniStatusBar.y + M.miniStatusBar.height / 2,
    font = "DejaVuSansMono", width = 70})
    boostLabel:setFillColor(0, 0, 0)

    -- Countdown Timer
    M.countdownTimer = countdownTimer
    M.totalTime = countdownTimer * 1
    local backCircle = display.newRoundedRect(uiGroup, display.contentCenterX - 20, 15, 60, 20, 10)
     backCircle:setFillColor(0, 0, 0, 0.3)
    local countdownText = display.newText({parent = uiGroup, text = M.countdownTimer, x = display.contentCenterX + 5, y = 15,
    font = "DejaVuSansMono", width = 70})
    local updateMeasures = function(event) return updateMeasures(event, countdownText) end
    local measurerTimer = timer.performWithDelay(200, updateMeasures, M.totalTime * 5)
    table.insert(M.timers, measurerTimer)
    M.goalMarker:initiateGoalMarker(uiGroup, M.miniStatusBar, M.stageNumber)
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
            M.machine.width = 150
            M.machine.height = 150
            M.machine.myName = "machine"
            physics.addBody(M.machine, "dynamic", {isSensor=true})
            M.machine:setLinearVelocity(0, M.vehicle.carVelocity)
        else
            local barrier = barrierFactory:new()
            barrier:drawBarrier(barrierGroup, pattern, M.vehicle.carVelocity, barrier)
        end
    end
end

local function initiateBarriers(stageNumber, countdownTimer)
    local patternFilePath = "src.barrierPatterns.stage" .. tostring(stageNumber)
    local patternList = require(patternFilePath)
    local patterns = patternList:getPatterns()
    local barrierFactory = require("src.domain.barrier")
    local positioningcheck = function() return positionCheck(patterns, barrierFactory, countdownTimer) end
    local positionChecker = timer.performWithDelay(100, positioningcheck, 0)
    table.insert(M.timers, positionChecker)
end

local function initiateShaderGroups(stageNumber)
    if stageNumber == 1 or stageNumber == 2 or stageNumber == 3 then
        rainGroup = display.newGroup()
    elseif stageNumber == 4 then
        shaderGroup = display.newGroup()
        currentGroup = display.newGroup()
    elseif stageNumber == 5 then
        lightGroup = display.newGroup()
        subLightGroup = display.newGroup()
        shaderGroup = display.newGroup()
    end
end

local function initiateCurrents()
    if M.stageNumber == 4 then
        local currentHandler = require("src.engine.currentHandler")
        local shuffling = function() return currentHandler:shuffleCurrents(M.countdownTimer,
            currentGroup, currentsTable, M.vehicle.image) end
        local runShuffle = timer.performWithDelay(2000, shuffling, -1)
        table.insert(M.timers, runShuffle)
    end
end

local function initiateGhosts()
    if M.stageNumber == 5 then
        local ghostHandler = require("src.engine.ghostHandler")
        ghostHandler:initiateStageFiveGhosts(lightGroup, subLightGroup)
    end
end

local function initiateBarrierDestroyer()
    local barrierDestroyerFactory = require("src.domain.barrierDestroyer")
    local barrierDestroyer = barrierDestroyerFactory:new()
    barrierDestroyer:initiateBarrierDestroyer(mainBackGroup)
end

local function fillGroupsIntoSceneGroup(sceneGroup)
    sceneGroup:insert(mainBackGroup)
    sceneGroup:insert(objectBackGroup)
    sceneGroup:insert(objectSecondaryBackGroup)
    sceneGroup:insert(barrierGroup)
    sceneGroup:insert(shootGroup)
    sceneGroup:insert(antsGroup)
    sceneGroup:insert(vehicleGroup)
    if M.stageNumber == 1 or M.stageNumber == 2 or M.stageNumber == 3 then
        sceneGroup:insert(rainGroup)
    elseif M.stageNumber == 4 then
        sceneGroup:insert(shaderGroup)
        sceneGroup:insert(currentGroup)
        currentsTable = {}
    elseif M.stageNumber == 5 then
        sceneGroup:insert(lightGroup)
        sceneGroup:insert(subLightGroup)
        sceneGroup:insert(shaderGroup)
        lightGroup:insert(subLightGroup)
        subLightGroup:insert(shaderGroup)
    end
    sceneGroup:insert(backgroundUiGroup)
    sceneGroup:insert(fireButtonGroup)
    sceneGroup:insert(ballGroup)
    sceneGroup:insert(uiGroup)
    sceneGroup:insert(coolDownSquareGroup)
    sceneGroup:insert(effectsGroup)
    sceneGroup:insert(exitButtonGroup)
end

function M.initiateCommons(sceneGroup, stageNumber, countdownTimer)
    M.stageNumber = stageNumber
    initiateShaderGroups(stageNumber)
    fillGroupsIntoSceneGroup(sceneGroup)
    getStageParameters(stageNumber)
    initiateBackground()
    initiateGhosts()
    initiateUiElements(countdownTimer)
    initiateCurrents()
    initiateVehicle()
    initiateCannon()
    initiateBarriers(stageNumber, countdownTimer)
    initiateBarrierDestroyer()
    initiateDeathChecker(countdownTimer)
    eventFactory:initiateCommonListeners(M, effectsGroup, barrierGroup)
end

function M.destroyCommons()
    if M.stageNumber == 4 then
        for i=1, #currentsTable do
            if currentsTable[i] ~= nil then
                currentsTable[i]:imediateDestroy()
            end
        end
    end
    eventFactory:removeEventListeners()
    for k, v in ipairs(M.timers) do
        timer.cancel(v)
    end

end

return M