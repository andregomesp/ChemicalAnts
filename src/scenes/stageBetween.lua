local composer = require ("composer")
local scene = composer.newScene()
local physics = require("physics")
local isShowing = false
local sceneGroup = nil
local stageName = 1
physics.start()
physics.setGravity(0, 0)
local tapToAdvanceText = nil

local function drawNextPhaseInfo(event)
    local nextPhaseGroup = display.newGroup()
    sceneGroup:insert(nextPhaseGroup)
    local nextPhaseName = "Stage " .. (stageName + 1)
    local nextPhaseText = display.newText({parent=nextPhaseGroup, text=nextPhaseName,
        x = display.viewableContentWidth / 3, y = display.viewableContentHeight / 5,
        fontSize = 35})
        nextPhaseText.anchorX = 0
    local nextPhaseImage = display.newImage(nextPhaseGroup)
    return true
end

local function drawScene()
    local blackScreen = display.newRect(0, 0, display.viewableContentWidth, display.viewableContentHeight)
    blackScreen.anchorX = 0
    blackScreen.anchorY = 0
    blackScreen:setFillColor(0, 0, 0)
    sceneGroup:insert(blackScreen)

    local textStageCompleted = "  Stage " .. stageName .. "\ncompleted!"
    local sceneCompletedText = display.newText({parent=sceneGroup, text=textStageCompleted,
        x = display.viewableContentWidth / 4, y = display.viewableContentHeight / 5,
        fontSize = 35})
    sceneCompletedText.anchorX = 0
    tapToAdvanceText = display.newText({parent=sceneGroup, text="Tap the screen to advance",
        x = display.viewableContentWidth / 5 , y = display.viewableContentHeight - 40,
        fontSize = 16})
    tapToAdvanceText.anchorX = 0
    blackScreen:addEventListener("touch", drawNextPhaseInfo)
end
function scene:create( event )
    sceneGroup = self.view -- add display objects to this group
end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        drawScene()
    end
end
function scene:hide(event)
    
end
function scene:destroy(event)
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
return scene