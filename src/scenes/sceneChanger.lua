local M = {}

local function restartScene(sceneNumber)
end

local function cancelTimers(timers)
    for k, v in ipairs(timers) do
        timer.cancel(v)
    end
end

function M:destroyStageScene(eventFactory, timers, stageNumber, goTo)
    
    local composer = require("composer")
    eventFactory:removeEventListeners()
    cancelTimers(timers)
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