local composer = require ("composer")
local scene = composer.newScene()
local backgroundGroup = display.newGroup()
local leftBackgroundGroup = display.newGroup()
local rightBackgroundGroup = display.newGroup()
local textGroup = display.newGroup()
local polygonGroup = display.newGroup()
local objectsGroup = display.newGroup()
local flashGroup = display.newGroup()
local timers = {}
local sounds = require("src.engine.soundStash")
local backgroundFactory = require("src.domain.background")
local isShowing = false
local sceneGroup = nil
local logo = nil
local mask = nil
local lighter = nil
local barrier = nil
local ball = nil
local background = nil
local backgroundSong = nil

local function goToGame()
    local sceneChanger = require("src.scenes.sceneChanger")
    sceneChanger:gotoSceneTransition(0, "stageBetween")
end

local function initiateTouchListener()
    background.image:addEventListener("touch", goToGame)
end

local function startMusic()
    audio.setVolume(0.92, {channel=1})
    audio.play(backgroundSong, {channel = 1, fadein = 100, loops = -1})
end

local function drawTouchInfo()
    local animationStash = require("src.engine.animations")
    animationStash:drawTouchInfo(textGroup, timers)
    initiateTouchListener()
end

local function handleBackground(event)
    local needToMoveGroup = background:checkBackgroundNeedsRebuild()
    if needToMoveGroup ~= false then
        background:moveBackgroundGroupIntro(needToMoveGroup)
    end
    return true
end

local function initiateRuntimeBkground()
    Runtime:addEventListener( "enterFrame", handleBackground)
end

local function drawBackGround()
    local backgroundImage = display.newRect(backgroundGroup, display.contentCenterX,
        display.contentCenterY, display.viewableContentWidth, display.viewableContentHeight)
    backgroundImage:setFillColor(0.435, 0.623, 0.196)
    background = backgroundFactory:new(nil, backgroundImage, leftBackgroundGroup,
        rightBackgroundGroup, backgroundGroup)
    background:buildBackground(130, {leftWall="assets/images/commons/scenario/trees.png",
        rightWall="assets/images/commons/scenario/trees.png", stageNumber=0})
    initiateRuntimeBkground()
    timer.performWithDelay(400, drawTouchInfo())
end

local function hideQuickWhiteScreen()
    drawBackGround()
    transition.to(lighter, {alpha=0, time=300, onComplete=startMusic})
end

local function reappearQuickWhiteScreen()
    transition.to(lighter, {alpha=1, time=200, onComplete=hideQuickWhiteScreen})
end

local function movePolygon()
    local drawBackGroundFunction = function() return 1 end
    for i=1, polygonGroup.numChildren do
        if i == 3 then
            drawBackGroundFunction = function() return reappearQuickWhiteScreen() end
        end
        transition.to(polygonGroup[i], {x=textGroup.x + (textGroup.width / 1.5) + (i - 1) * 20,
        transition=easing.outBack, time=1500 + (i - 1) * 200, onComplete=drawBackGroundFunction})
    end
end

local function drawPolygon()
    local vertices = {0, 0, 80, -80, 80, 80}
    local triangleBlue = display.newPolygon(polygonGroup, display.viewableContentWidth + 200, display.viewableContentHeight / 5, vertices)
    local triangleYellow = display.newPolygon(polygonGroup, display.viewableContentWidth + 180, display.viewableContentHeight / 5, vertices)
    local triangleRed = display.newPolygon(polygonGroup, display.viewableContentWidth + 160, display.viewableContentHeight / 5, vertices)
    triangleBlue:setFillColor(0.2, 0.2, 1)
    triangleYellow:setFillColor(0.8, 0.8, 0)
    triangleRed:setFillColor(1, 0.2, 0.2)
end

local function reAppearText()
    textGroup.alpha = 0
    textGroup:setMask(nil)
    transition.to(textGroup, {alpha=1, time=900, onComplete=movePolygon})
end

local function verticalAnimation()
    transition.to(lighter, {height=display.viewableContentHeight, time=1000})
    transition.to(lighter, {delay=300, alpha=0, time=1000})
    timer.performWithDelay(1500, reAppearText)
end

local function drawLightAnimation()
    sounds:playASound("wind_howl.mp3")
    lighter = display.newRect(flashGroup, display.viewableContentWidth/2,
        display.viewableContentHeight/2, 0, 10)
    lighter:setFillColor(1, 1, 1)
    lighter.anchorX = 0.5
    lighter.anchorY = 0.5
    transition.to(lighter, {width=display.viewableContentWidth, time=800, onComplete=verticalAnimation})
end

local function collisionBallAndBarrier()
    display.remove(ball)
    display.remove(barrier)
    drawLightAnimation()
end

local function fireBall()
    sounds:playASound("misc_element_shot.mp3")
    transition.to(ball, {y=barrier.y, onComplete=collisionBallAndBarrier})
end

local function makeBarrierAppear()
    transition.to(barrier, {alpha = 1, time=800, onComplete=fireBall})
end

local function drawMask()
    mask = graphics.newMask("assets/images/commons/masks/logoMask.png")
    textGroup:setMask(mask)
    textGroup.maskX = 150
    textGroup.maskY = 0
    transition.to(textGroup, {maskY=display.viewableContentHeight/2, time=3500, onComplete=makeBarrierAppear})
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

local function drawBall()
    ball = display.newImageRect(objectsGroup, "assets/images/commons/balls/ball_red.png", 25, 25)
    ball.anchorX = 0.5
    ball.anchorY = 0.5
    ball.x = display.viewableContentWidth / 2
    ball.y = display.viewableContentHeight + 50
end

local function drawBarrier()
    barrier = display.newImageRect(objectsGroup, "assets/images/commons/barriers/sodium-middle.png", 50, 50)
    barrier.alpha = 0
    barrier.anchorX = 0.5
    barrier.anchorY = 0.5
    barrier.x = display.viewableContentWidth / 2
    barrier.y = display.viewableContentHeight / 2
    barrier.alpha = 0
end

local function initiateLogo()
    drawLogoText()
    drawPolygon()
    drawBarrier()
    drawMask()
    drawBarrier()
    drawBall()
end

function scene:create( event )
    sceneGroup = self.view
    sceneGroup:insert(backgroundGroup)
    sceneGroup:insert(leftBackgroundGroup)
    sceneGroup:insert(rightBackgroundGroup)
    sceneGroup:insert(objectsGroup)
    sceneGroup:insert(polygonGroup)
    sceneGroup:insert(textGroup)
    sceneGroup:insert(flashGroup)
    backgroundSong = audio.loadStream("assets/audio/songs/Daily Beetle.mp3")
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
    Runtime:removeEventListener("enterFrame", handleBackground)
    for k, v in ipairs(timers) do
        timer.cancel(v)
    end
    audio.fadeOut({channel=1, time=500})
    local disposeAudio = function () return audio.dispose(backgroundSong) end
    timer.performWithDelay(600, disposeAudio)
    package.loaded["src.scenes.mainMenu"] = nil
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
return scene