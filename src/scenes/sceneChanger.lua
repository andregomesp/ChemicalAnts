local M = {}

local function restartScene(sceneNumber)
end

function M:gotoSceneTransition(eventFactory, timers, stageNumber, goTo)
    local composer = require("composer")
    composer.gotoScene("src.scenes.sceneTransition", {
        effect = "fade",
        time = 2500,
        params = {
            stage = stageNumber,
            goTo = goTo
        }
    })
end

return M