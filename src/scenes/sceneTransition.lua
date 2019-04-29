local composer = require ("composer")
local scene = composer.newScene()

local function drawBlackScreen(sceneGroup)
    local blackScreen = display.newRect(0, 0, display.viewableContentWidth, display.viewableContentHeight)
    blackScreen.anchorX = 0
    blackScreen.anchorY = 0
    blackScreen:setFillColor(0, 0, 0)
    sceneGroup:insert(blackScreen)
end

local function drawStageTransitionScene(stage)
    print("drawing")
end

local function selectScene(params)
    local scene = nil
    local stage = params.stage
    if params.goTo == "nextStage" then
        stage = stage + 1
        scene = "src.scenes.scene" .. tostring(stage)
        drawStageTransitionScene(stage)
    elseif params.goTo == "sameStage" then
        scene = "src.scenes.scene" .. tostring(stage)
        drawStageTransitionScene(stage)
    elseif params.goTo == "gameover" then
        scene = "src.scenes.gameover"
    elseif params.goTo == "end" then
        scene = "src.scenes.end"
    end
    return scene
end

local function goToStage()
end

function scene:create( event )
    
end

function scene:show(event)
    local sceneGroup = self.view
    drawBlackScreen(sceneGroup)
    local newScene = selectScene(event.params)
    local previousScene = composer.getSceneName("previous")
    composer.removeScene(previousScene)
    composer.gotoScene(newScene, {
        effect = "fade",
        time = 2500 
    })
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