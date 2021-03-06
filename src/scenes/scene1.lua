local composer = require ("composer")
local scene = composer.newScene()
local physics = require("physics")
local isShowing = false
local sceneGroup = nil
local commons = nil
local commonsInterfaceName = "src.scenes.commonsInterface"
local backgroundSong = nil
physics.start()
physics.setGravity(0, 0)
function scene:create( event )
    sceneGroup = self.view -- add display objects to this group
    local sceneChanger = require("src.scenes.sceneChanger")
    backgroundSong = audio.loadStream("assets/audio/songs/Cyborg Ninja.mp3")
end

function scene:show(event)
    if isShowing == false then
        local previousScene = composer.getSceneName("previous")
        if previousScene ~= nil then
            composer.removeScene(previousScene)
        end
        isShowing = true
        local stageNumber = 1
        local countDownTimer = 60
        commons = require(commonsInterfaceName)
        audio.setVolume(0.92, {channel=1})
        audio.play(backgroundSong, {channel = 1, fadein = 1500, loops = -1})
        commons.initiateCommons(sceneGroup, stageNumber, countDownTimer)
    end
end
function scene:hide(event)
    if event.phase == "did" then
        composer.removeScene("src.scenes.scene1")
    end
end
function scene:destroy(event)
    audio.fadeOut({channel=1, time=500})
    local disposeAudio = function () return audio.dispose(backgroundSong) end
    timer.performWithDelay(2600, disposeAudio)
    commons.destroyCommons()
    package.loaded[commonsInterfaceName] = nil
    commons = nil
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
return scene