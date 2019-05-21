local composer = require ("composer")
local scene = composer.newScene()
local whiteScreenGroup = display.newGroup()
local textGroup = display.newGroup()
local isShowing = false

local function drawGameOverScene()
    local congrats = display.newText({parent = textGroup, text="Congratulations!", 
    x=display.contentCenterX, y=display.contentCenterY})
end

local function drawCredits()
    local creditsFactory = require("src.engine.credits")
    creditsFactory:getCredits()
end

function scene:create( event )
end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        drawGameOverScene()
        drawCredits()
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