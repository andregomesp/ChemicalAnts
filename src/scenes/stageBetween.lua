local composer = require ("composer")
local scene = composer.newScene()
local physics = require("physics")
local isShowing = false
local sceneGroup = nil
physics.start()
physics.setGravity(0, 0)

local function drawScene()
    -- local sceneCompletedText = newText()
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