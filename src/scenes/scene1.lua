local composer = require ("composer")
local scene = composer.newScene()
local physics = require("physics")
local isShowing = false
local sceneGroup = nil
local commons = nil
local commonsInterfaceName = "src.scenes.commonsInterface"
local backgroundSong = nil
local backgroundSongPlay = nil
physics.start()
physics.setGravity(0, 0)
function scene:create( event )
    sceneGroup = self.view -- add display objects to this group
    backgroundSong = audio.loadStream("assets/audio/songs/Cyborg Ninja.mp3")
end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        local stageNumber = 1
        local countDownTimer = 50
        commons = require(commonsInterfaceName)
        backgroundSongPlay = audio.play(backgroundSong, {fadein = 1500, loops = -1})
        commons.initiateCommons(sceneGroup, stageNumber, countDownTimer)
        print(backgroundSong)
        print(backgroundSongPlay)
    end
end
function scene:hide(event)
    
end
function scene:destroy(event)
    audio.fadeOut({channel=backgroundSongPlay, time=2000})
    commons.destroyCommons()
    package.loaded[commonsInterfaceName] = nil
    commons = nil
    -- display.remove(sceneGroup)
    -- sceneGroup = nil
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
return scene