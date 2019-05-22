local composer = require ("composer")
local scene = composer.newScene()
local backgroundGroup = display.newGroup()
local leftBackgroundGroup = display.newGroup()
local rightBackgroundGroup = display.newGroup()
local backScreenGroup = display.newGroup()
local textGroup = display.newGroup()
local sceneGroup = nil
local isShowing = false
local lines = {}

local function drawGameOverScene()
    -- local congrats = display.newText({parent = textGroup, text="Congratulations!",
    -- x=display.contentCenterX, y=display.contentCenterY})
end

local function drawCredits()
    local creditsFactory = require("src.engine.credits")
    local credits = creditsFactory:getCredits()
    local counter = 0
    for k, v in ipairs(credits) do
        local line = display.newText({parent=textGroup, text=v,
            font="ELDERWEISS-Regular", x=display.contentCenterX,
            y=display.viewableContentWidth * 2.2 + (50 * counter), fontSize = 20,
            height = 0, align="center"})
            line.anchorX = 0.5
        line:setFillColor(0.13, 0, 0.1)
        table.insert(lines, line)
        counter = counter + 1
    end
end

local function animateCredits()
    for k, v in ipairs(lines) do
        transition.to(v, {y=v.y - display.viewableContentWidth * 6.4, time=25200})
    end
end

local function drawBackground()
    local background = require("src.engine.animations")
    background:drawBackgroundScene(backgroundGroup, leftBackgroundGroup, rightBackgroundGroup)
end

function scene:create( event )
    sceneGroup = self.view -- add display objects to this group
end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        drawGameOverScene()
        drawCredits()
        animateCredits()
        drawBackground()
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