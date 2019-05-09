local M = {}

function M:removePreviousScene()
    local composer = require('composer')
    local previousScene = composer.getSceneName("previous")
    if previousScene ~= nil then
        composer.removeScene(previousScene)
    end
end

function M:gotoSceneTransition(stageNumber, goTo)
    local composer = require("composer")
    local effects = ""
    if goTo == "nextStage" then
        effects = "zoomInOutFade"
    else
        effects = "fade"
    end
    composer.gotoScene("src.scenes.sceneTransition", {
        effect = effects,
        time = 2500,
        params = {
            stage = stageNumber,
            goTo = goTo
        }
    })
end

return M