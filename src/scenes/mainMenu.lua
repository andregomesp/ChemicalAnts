local composer = require ("composer")
local scene = composer.newScene()
local textGroup = display.newGroup()
local flashGroup = display.newGroup()
local isShowing = false
local sceneGroup = nil
local logo = nil
local mask = nil
local lighter = nil


local function reAppearText()
    textGroup.alpha = 0
    textGroup:setMask(nil)
    transition.to(textGroup, {alpha=1, time=900})
end

local function verticalAnimation()
    transition.to(lighter, {height=display.viewableContentHeight, time=1000})
    transition.to(lighter, {delay=300, alpha=0, time=1000})
    timer.performWithDelay(1500, reAppearText)
end

local function drawLightAnimation()
    lighter = display.newRect(flashGroup, display.viewableContentWidth/2,
        display.viewableContentHeight/2, 0, 10)
    lighter:setFillColor(1, 1, 1)
    lighter.anchorX = 0.5
    lighter.anchorY = 0.5
    transition.to(lighter, {width=display.viewableContentWidth, time=800, onComplete=verticalAnimation})
end

local function drawMask()
    mask = graphics.newMask("assets/images/commons/masks/logoMask.png")
    textGroup:setMask(mask)
    textGroup.maskX = 150
    textGroup.maskY = 0
    transition.to(textGroup, {maskY=display.viewableContentHeight/2, time=3500, onComplete=drawLightAnimation})
end

local function drawLogoText()
    -- local shader = display.newRect(textGroup, 0, 0, display.viewableContentWidth, display.viewableContentHeight)
    -- shader:setFillColor(4, 4, 4, 0.98)
    -- shader.anchorX = 0
    -- shader.anchorY = 0
    logo = display.newText({parent=textGroup, text="Chemical Ants", x=245, y=45,
        width=display.viewableContentWidth / 1.5, height=display.viewableContentHeight / 2,
        font="ELDERWEISS-Regular", fontSize=45})
    logo:setFillColor(1, 1, 1)
    logo.anchorX = 1
    logo.anchorY = 0
end

local function animateLogoText(text)
end

local function initiateLogo()
    drawLogoText()
    drawMask()
end

function scene:create( event )
    sceneGroup = self.view
    sceneGroup:insert(textGroup)
    sceneGroup:insert(flashGroup)
end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        initiateLogo()
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