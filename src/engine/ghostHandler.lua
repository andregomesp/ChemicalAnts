local M = {}
local ghostA = nil
local ghostB = nil
local ghostFactory = require("src.domain.ghost")

local function initiateGhostPatternSystem()
    ghostA:initiatePatterns("a")
    ghostB:initiatePatterns("b")
end

local function createLightMasks()
    ghostA:createLightMask(160, 80)
    ghostB:createLightMask(160, 330)
end

function M:initiateStageFiveGhosts(lightGroup, subLightGroup)
    ghostB = ghostFactory:new()
    ghostA = ghostFactory:new()
    ghostA:setParameters(lightGroup, "ghostA")
    ghostB:setParameters(subLightGroup, "ghostB")
    createLightMasks()
    initiateGhostPatternSystem()
end


return M