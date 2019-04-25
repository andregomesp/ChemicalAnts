local M = {}

local function restartScene(sceneNumber)
end

function M:destroyScene()
    local composer = require("composer")
    
    composer.gotoScene("src.scenes.sceneTransition", {
        effect = "crossFade",
        time = 1200
    })
end

return M