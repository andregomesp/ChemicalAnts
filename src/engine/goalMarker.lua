local M = {}
local goalmarker = nil
local lastPattern = nil

local function getLastPattern(stageNumber)
    local patternsFile = require("src.barrierPatterns.stage" .. stageNumber)
    local patterns = patternsFile:getPatterns()
    lastPattern = patterns[#patterns]
end

function M:initiateGoalMarker(uiGroup, miniStatusBar, stageNumber)
    getLastPattern(stageNumber)
    goalmarker = display.newText({
        parent=uiGroup, text="0%", x = miniStatusBar.x + miniStatusBar.width / 1.8,
        y = miniStatusBar.y + miniStatusBar.height / 2, font = "DejaVuSansMono"
    })
    goalText = display.newText({
        parent=uiGroup, text="Goal", x = miniStatusBar.x + miniStatusBar.width / 2.4,
        y = miniStatusBar.y + miniStatusBar.height / 2, font = "DejaVuSansMono"
    })
    goalmarker:setFillColor(0, 0, 0)
    goalText:setFillColor(0, 0, 0)
end

function M:remarkGoal(currentMeters)
    local machineMeters = lastPattern['time']
    local delta = math.floor((currentMeters/machineMeters) * 100)
    if delta > 100 then
        delta = 100
    end
    goalmarker.text = delta .. "%"
end

return M