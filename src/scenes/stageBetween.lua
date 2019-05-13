local composer = require ("composer")
local scene = composer.newScene()
local blackScreenGroup = display.newGroup()
local preGroup = display.newGroup()
preGroup:toFront()
local nextPhaseGroup = display.newGroup()
local stageBetweenName = "src.scenes.stageBetween"
local isShowing = false
local sceneGroup = nil
local tapToAdvanceText = nil
local stageNumber = nil
local screenStatus = nil
local posTouch = false
local preTouch = false
local backgroundSong = nil
local timers = {}
local blackScreen = nil
local blackScreenListener = nil
local backgroundSongPlay = nil

local function drawNextStageName()
    local stageNameTag = ""
    local nextStage = tonumber(stageNumber) + 1
    if nextStage == 1 then
        stageNameTag = "Antsy Forest"
    elseif nextStage == 2 then
        stageNameTag = "Defiant Desert"
    elseif nextStage == 3 then
        stageNameTag = "Antphibian Sea"
    elseif nextStage == 4 then
        stageNameTag = "Antique Caverns"
    elseif nextStage == 5 then
        stageNameTag = "???"
    end
    local stageNameDisplay = display.newText({parent=nextPhaseGroup, text = stageNameTag,
        x = display.viewableContentWidth / 3, y = display.viewableContentHeight / 1.3, fontSize = 18})
    stageNameDisplay.anchorX = 0
end

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
    if screenStatus == "pre" then
        display.remove(preGroup)
        for i=1, #timers do
            timer.cancel(timers[i])
        end
    end
    drawTouchInfo(nextPhaseGroup)
    nextPhaseGroup.alpha = 0
    local nextPhaseName = "Stage " .. (stageNumber + 1)
    local nextPhaseText = display.newText({parent=nextPhaseGroup, text=nextPhaseName,
        x = display.viewableContentWidth / 3, y = display.viewableContentHeight / 5,
        fontSize = 35})
    nextPhaseText.anchorX = 0
    local nextPhaseImage = display.newImage(nextPhaseGroup, "/assets/images/commons/stage_pics/stage" .. stageNumber + 1 .. ".png",
        display.viewableContentWidth / 5, display.viewableContentHeight / 2)
    nextPhaseImage.anchorX = 0
    nextPhaseImage.width = 200
    nextPhaseImage.height = 200
    nextPhaseImage.strokeWidth = 2
    nextPhaseImage.stroke = { 1, 0.5, 0.3}
    transition.to(nextPhaseGroup, {time = 1000, alpha = 1})
    local drawTouch = function() return drawTouchInfo(nextPhaseGroup) end
    timer.performWithDelay(drawTouch)
    drawNextStageName()
    screenStatus = "pos"
    blackScreen:addEventListener("touch", blackScreenListener)
    return true
end

local function drawNextPhaseTransition()
    blackScreen:removeEventListener("touch", blackScreenListener)
    transition.to(preGroup, {time = 1000, alpha = 0, onComplete = drawNextPhase})
end

local function nextPhaseTransitioning()
    local sceneChanger = require("src.scenes.sceneChanger")
    sceneChanger:gotoSceneTransition(tonumber(stageNumber), "nextStage")
end

local function goToNextPhase()
    local sceneChanger = require("src.scenes.sceneChanger")
    timer.performWithDelay(100, function() return sceneChanger:removePreviousScene() end)
    blackScreen:removeEventListener("touch", blackScreenListener)
    timer.performWithDelay(200, function() return nextPhaseTransitioning() end)
end

local function drawNextInformations()
    if screenStatus == "pre" and preTouch == false then
        preTouch = true
        drawNextPhaseTransition()
    elseif screenStatus == "pos" and posTouch == false then
        posTouch = true
        goToNextPhase()
    end
end

local function drawBlackScreen()
    blackScreen = display.newRect(blackScreenGroup, 0, 0, display.viewableContentWidth, display.viewableContentHeight)
    blackScreen.anchorX = 0
    blackScreen.anchorY = 0
    blackScreen:setFillColor(0, 0, 0)
    blackScreenListener = function() return drawNextInformations() end
    blackScreen:addEventListener("touch", blackScreenListener)
end

local function drawPreScene()
    local textStageCompleted = "  Stage " .. stageNumber .. "\ncompleted!"
    local sceneCompletedText = display.newText({parent=preGroup, text=textStageCompleted,
        x = display.viewableContentWidth / 4, y = display.viewableContentHeight / 5,
        fontSize = 35})
    sceneCompletedText.anchorX = 0
    drawTouchInfo(preGroup)
end

function scene:create( event )
    sceneGroup = self.view -- add display objects to this group
    sceneGroup:insert(blackScreenGroup)
    sceneGroup:insert(preGroup)
    sceneGroup:insert(nextPhaseGroup)
    backgroundSong = audio.loadStream("assets/audio/songs/Overworld.mp3")
end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        backgroundSongPlay = audio.play(backgroundSong, {channel = 1, loops = -1})
        audio.setVolume(1.0, {channel=1})
        stageNumber = event.params.stageNumber
        screenStatus = event.params.screenStatus
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
    audio.fadeOut({channel=1, time=500})
    for i=1, #timers do
        timer.cancel(timers[i])
    end
    package.loaded[stageBetweenName] = nil
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
return scene