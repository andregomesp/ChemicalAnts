local composer = require ("composer")
local scene = composer.newScene()
local isShowing = false

local function drawBlackScreen(sceneGroup)
    local blackScreen = display.newRect(0, 0, display.viewableContentWidth, display.viewableContentHeight)
    blackScreen.anchorX = 0
    blackScreen.anchorY = 0
    blackScreen:setFillColor(0, 0, 0)
    sceneGroup:insert(blackScreen)
end

local function drawStageTransitionScene(stage)
end

local function selectScene(params)
    local sceneName = nil
    local stage = params.stage
    if params.goTo == "nextStage" then
        stage = stage + 1
        sceneName = "src.scenes.scene" .. tostring(stage)
        drawStageTransitionScene(stage)
    elseif params.goTo == "sameStage" then
        sceneName = "src.scenes.scene" .. tostring(stage)
        drawStageTransitionScene(stage)
    elseif params.goTo == "gameover" then
        sceneName = "src.scenes.gameover"
    elseif params.goTo == "end" then
        sceneName = "src.scenes.end"
    end
    print(sceneName)
    return sceneName
end

local function goToStage()
end

function scene:create( event )
end

function scene:show(event)
    if isShowing == false then
        isShowing = true
        local sceneGroup = self.view
        local previousScene = composer.getSceneName("previous")
        print(previousScene)
        composer.removeScene(previousScene)
        drawBlackScreen(sceneGroup)
        local newScene = selectScene(event.params)
        -- local openNextScene = function () return  composer.gotoScene(newScene, {
        --     effect = "fade",
        --     time = 2500
        -- }) end
        -- timer.performWithDelay(500, openNextScene)

        composer.gotoScene(newScene, {
            effect = "fade",
            time = 2500
        })
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