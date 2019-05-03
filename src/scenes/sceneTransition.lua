local composer = require ("composer")
local scene = composer.newScene()
local isShowing = false
local sceneGroup = nil
local sceneTransitionName = "src.scenes.sceneTransition"

local function drawBlackScreen()
    local blackScreen = display.newRect(0, 0, display.viewableContentWidth, display.viewableContentHeight)
    blackScreen.anchorX = 0
    blackScreen.anchorY = 0
    blackScreen:setFillColor(0, 0, 0)
    sceneGroup:insert(blackScreen)
end

local function selectScene(params)
    local sceneName = nil
    local stage = params.stage
    if params.goTo == "stageBetween" then
        sceneName = "src.scenes.stageBetween"
    elseif params.goTo == "nextStage" then
        stage = stage + 1
        sceneName = "src.scenes.scene" .. tostring(stage)
    elseif params.goTo == "sameStage" then
        sceneName = "src.scenes.scene" .. tostring(stage)
    elseif params.goTo == "gameover" then
        sceneName = "src.scenes.gameover"
    elseif params.goTo == "end" then
        sceneName = "src.scenes.end"
    end
    return sceneName
end

local function goToStage(newScene, stageNo)
    local params = {}
    if newScene == "src.scenes.stageBetween" then
        local screenStatus = "pre"
        if stageNo == 0 then
            screenStatus = "pos"
        end
        print("printing pure stage number")
        params = {screenStatus = screenStatus, stageNumber=stageNo}
    end
    composer.gotoScene(newScene, {
        effect = "fade",
        time = 2500,
        params = params
    })
end

function scene:create( event )
    sceneGroup = self.view
end

local function removePreviousScene(event)
    local previousScene = composer.getSceneName("previous")
    composer.removeScene(previousScene)

end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        drawBlackScreen(sceneGroup)
        local newScene = selectScene(event.params)
        local sceneChanger = require("src.scenes.sceneChanger")
        timer.performWithDelay(2000, function() return sceneChanger:removePreviousScene() end)
        local openNewScene = function() return goToStage(newScene, event.params.stage) end
        timer.performWithDelay(3000, openNewScene)
    end
end
function scene:hide(event)
    
end
function scene:destroy(event)
    package.loaded[sceneTransitionName] = nil
end


scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
return scene