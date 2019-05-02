local composer = require ("composer")
local scene = composer.newScene()
local preGroup = display.newGroup()
local nextPhaseGroup = display.newGroup()
local stageBetweenName = "src.scenes.stageBetween"
local isShowing = false
local sceneGroup = nil
local tapToAdvanceText = nil
local stageNumber = nil
local screenStatus = nil
local timers = {}

local function drawTouchInfo(group)
    tapToAdvanceText = display.newText({parent=group, text="Tap the screen to advance",
        x = display.viewableContentWidth / 5 , y = display.viewableContentHeight - 40,
        fontSize = 16})
    tapToAdvanceText.anchorX = 0
    
    local fadeInText = function () return transition.to(tapToAdvanceText, {time = 700,
        easing=easing.outInBack, alpha=1}) end
    local fadeOutText = function () return transition.to(tapToAdvanceText, {time = 700, 
        easing=easing.outInBack, alpha=0}) end
        local fadeOutTimer = timer.performWithDelay(700, fadeOutText, 0)
        local fadeInTimer = timer.performWithDelay(700, fadeInText, 0)
        table.insert(timers, fadeOutTimer)
        table.insert(timers, fadeInTimer)
end

local function drawNextPhase()
    display.remove(preGroup)
    for i=1, #timers do
        print("oi")
        timer.cancel(timers[i])    
    end  
    sceneGroup:insert(nextPhaseGroup)
    drawTouchInfo(nextPhaseGroup)
    nextPhaseGroup.alpha = 0
    local nextPhaseName = "Stage " .. (stageNumber + 1)
    local nextPhaseText = display.newText({parent=nextPhaseGroup, text=nextPhaseName,
        x = display.viewableContentWidth / 3, y = display.viewableContentHeight / 5,
        fontSize = 35})
    nextPhaseText.anchorX = 0
    local nextPhaseImage = display.newImage(nextPhaseGroup, "/assets/images/commons/stage_pics/stage 2.png",
        display.viewableContentWidth / 5, display.viewableContentHeight / 2)
    nextPhaseImage.anchorX = 0
    nextPhaseImage.width = 200
    nextPhaseImage.height = 200
    nextPhaseImage.strokeWidth = 2
    nextPhaseImage.stroke = { 1, 0.5, 0.3}
    transition.to(nextPhaseGroup, {time = 1000, alpha = 1})
    local drawTouch = function() return drawTouchInfo(nextPhaseGroup) end
    timer.performWithDelay(drawTouch)
    return true
end

local function drawNextPhaseTransition()
    transition.to(preGroup, {time = 1000, alpha = 0, onComplete = drawNextPhase})
end

local function goToNextPhase()
end

local function drawNextInformations()
    if screenStatus == "pre" then
        drawNextPhaseTransition()
    elseif screenStatus == "pos" then
        goToNextPhase()
    end  
end

local function drawBlackScreen()
    local blackScreen = display.newRect(preGroup, 0, 0, display.viewableContentWidth, display.viewableContentHeight)
    blackScreen.anchorX = 0
    blackScreen.anchorY = 0
    blackScreen:setFillColor(0, 0, 0)
    local drawNextInformation = function() return drawNextInformations() end 
    blackScreen:addEventListener("touch", drawNextInformation)
end

local function drawPreScene()
    drawBlackScreen()
    local textStageCompleted = "  Stage " .. stageNumber .. "\ncompleted!"
    local sceneCompletedText = display.newText({parent=preGroup, text=textStageCompleted,
        x = display.viewableContentWidth / 4, y = display.viewableContentHeight / 5,
        fontSize = 35})
    sceneCompletedText.anchorX = 0
    drawTouchInfo(preGroup)
end

function scene:create( event )
    sceneGroup = self.view -- add display objects to this group
    
end

function scene:show(event)
    if isShowing == false then
        stageNumber = event.params.stageNumber
        screenStatus = event.params.screenStatus
        sceneGroup:insert(preGroup)
        isShowing = true
        drawBlackScreen()
        if screenStatus == "pre" then
            drawPreScene()
        else
            drawNextPhaseTransition()
        end
    end
end
function scene:hide(event)
    
end
function scene:destroy(event)
    package.loaded[stageBetweenName] = nil
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
return scene