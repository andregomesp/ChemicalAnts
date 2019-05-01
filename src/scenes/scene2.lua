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
    backgroundSong = audio.loadStream("assets/audio/songs/Desert of Lost Souls.mp3")
end

function scene:show(event)
    if isShowing == false then
        local previousScene = composer.getSceneName("previous")
        composer.removeScene(previousScene)
        isShowing = true
        local stageNumber = 2
        local countDownTimer = 60
        commons = require(commonsInterfaceName)
        backgroundSongPlay = audio.play(backgroundSong, {fadein = 1500, loops = -1})
        print(audio.getVolume({channel = backgroundSongPlay}))
        audio.setVolume(1.0, {channel=backgroundSongPlay})
        commons.initiateCommons(sceneGroup, stageNumber, countDownTimer)
        print(backgroundSong)
        print(backgroundSongPlay)
    end
end
function scene:hide(event)
    
end
function scene:destroy(event)
    print(audio.getVolume({channel = backgroundSongPlay}))
    audio.fadeOut({channel=backgroundSongPlay, time=2000})
    commons.destroyCommons()
    package.loaded[commonsInterfaceName] = nil
    commons = nil
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
return scene