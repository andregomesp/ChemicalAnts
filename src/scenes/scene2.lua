local composer = require ("composer")
local scene = composer.newScene()
local physics = require("physics")

physics.start()
physics.setGravity(0, 0)
function scene:create( event )
    local sceneGroup = self.view -- add display objects to this group
    local stageNumber = 2
    local countDownTimer = 60
    local commons = require("src.scenes.commonsInterface")
    commons.initiateCommons(sceneGroup, stageNumber, availableBallTypes, countDownTimer)
end

function scene:show(event)
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