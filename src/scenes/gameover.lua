local composer = require ("composer")
local scene = composer.newScene()
local backScreenGroup = display.newGroup()
local textGroup = display.newGroup()
local isShowing = false
local lines = {}

local function drawGameOverScene()
    local congrats = display.newText({parent = textGroup, text="Congratulations!", 
    x=display.contentCenterX, y=display.contentCenterY})
end

local function drawCredits()
    local creditsFactory = require("src.engine.credits")
    local credits = creditsFactory:getCredits()
    local counter = 0
    for k, v in ipairs(credits) do
        local line = display.newText({parent=textGroup, text=v, 
            font="ELDERWEISS-Regular", x=display.contentCenterX, 
            y=-100 + (20 * counter), fontSize = 25})
    end
    table:insert(lines, line)
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