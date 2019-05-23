local composer = require ("composer")
local scene = composer.newScene()
local backgroundGroup = display.newGroup()
local leftBackgroundGroup = display.newGroup()
local rightBackgroundGroup = display.newGroup()
local backScreenGroup = display.newGroup()
local textGroup = display.newGroup()
local sceneGroup = nil
local isShowing = false
local backgroundSong = nil
local lines = {}
local timers = {}
local background = nil
local handleBackground = nil

local function drawCredits()
    local creditsFactory = require("src.engine.fileReader")
    local credits = creditsFactory:read_text_file("thanks.txt")
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

local function goToGame()
    local sceneChanger = require("src.scenes.sceneChanger")
    sceneChanger:gotoSceneTransition(0, "mainMenu")
end

local function initiateTouchListener()
    backgroundGroup:addEventListener("touch", goToGame)
end

local function drawClickAnimation()
    local animations = require("src.engine.animations")
    animations:drawTouchInfo(textGroup, timers)
    initiateTouchListener()
end

local function animateCredits()
    for i = 1, #lines - 1 do
        local line = lines[i]
        -- transition.to(v, {y=v.y - display.viewableContentWidth * 7.4, time=28900, onComplete=drawClickAnimation})
        transition.to(line, {y=line.y - display.viewableContentWidth * 7.4, time=28900})
    end
    local lastLine = lines[#lines]
    transition.to(lastLine, {y=lastLine.y - display.viewableContentWidth * 7.4, time=900, onComplete=drawClickAnimation})
end

local function drawBackground()
    local animationsFactory = require("src.engine.animations")
    local backgroundTable = animationsFactory:drawBackgroundScene(backgroundGroup, leftBackgroundGroup, rightBackgroundGroup)
    handleBackground = backgroundTable.handleBackground
end

function scene:create( event )
    sceneGroup = self.view -- add display objects to this group
    sceneGroup:insert(backgroundGroup)
    sceneGroup:insert(leftBackgroundGroup)
    sceneGroup:insert(rightBackgroundGroup)
    sceneGroup:insert(backScreenGroup)
    sceneGroup:insert(textGroup)
    backgroundSong = audio.loadStream("assets/audio/songs/Smooth Lovin.mp3")
end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        audio.setVolume(1.00, {channel=1})
        audio.play(backgroundSong, {channel = 1, fadein = 1500, loops = -1})
        drawCredits()
        animateCredits()
        drawBackground()
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
    timer.performWithDelay(2600, disposeAudio)
    package.loaded["src.scenes.gameover"] = nil
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene