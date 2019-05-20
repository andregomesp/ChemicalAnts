local composer = require ("composer")
local scene = composer.newScene()
local whiteScreenGroup = display.newGroup()
local textGroup = display.newGroup()
local isShowing = false

local function drawGameOverScene()
    local credits = display.newText({parent = textGroup, text="Congratulations!"})
end

local function initiateCurrents()
    local currentHandler = require("src.domain.waterCurrents")
    local waterCurrentA = currentHandler:new()
    waterCurrentA:createCurrent(textGroup, -1)
end

function scene:create( event )
end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        initiateCurrents()
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