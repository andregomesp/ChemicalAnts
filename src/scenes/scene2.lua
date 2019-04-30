local composer = require ("composer")
local scene = composer.newScene()
local physics = require("physics")
local isShowing = false

physics.start()
physics.setGravity(0, 0)
function scene:create( event )
end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        local sceneGroup = self.view -- add display objects to this group
        print("sgroup")
        print(sceneGroup)
        local stageNumber = 2
        local countDownTimer = 60
        local commons = require("src.scenes.commonsInterface")
        commons.initiateCommons(sceneGroup, stageNumber, countDownTimer)
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