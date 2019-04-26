local M = {}

local function restartScene(sceneNumber)
end

local function cancelTimers(timers)
    for k, v in ipairs(timers) do
        timer.cancel(v)
    end
end

function M:destroyScene(eventFactory, timers)
    
    local composer = require("composer")
    eventFactory:removeEventListeners()
    cancelTimers(timers)
    composer.gotoScene("src.scenes.sceneTransition", {
        effect = "crossFade",
        time = 1200
    })
end

return M