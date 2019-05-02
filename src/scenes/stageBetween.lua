local composer = require ("composer")
local scene = composer.newScene()
local physics = require("physics")
local isShowing = false
local sceneGroup = nil
local stageName = "1"
physics.start()
physics.setGravity(0, 0)

local function drawNextPhaseInfo()
    local nextPhaseName = "Stage " + tonumber(stageName) 
    local nextPhaseText = display.newText({parent=sceneGroup, text=nextPhaseName,
        x = display.viewableContentWidth / 2, y = display.viewableContentHeight / 2,
        fontSize = 35})
end

local function drawScene()
    local textStageCompleted = "Stage " .. stageName .. " completed!"
    local sceneCompletedText = display.newText({parent=sceneGroup, text=textStageCompleted,
        x = display.viewableContentWidth / 2, y = display.viewableContentHeight / 3,
        fontSize = 35})
    sceneCompletedText.anchorX = 0
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