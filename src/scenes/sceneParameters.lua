local M = {}

local parameters = {
    [1] = {
        background = "grassBackgroundTemporary.jpg", 
        availableBallTypes = {"oxygen", "water"}
    }
}

function M.getParameters(stageNumber)
    return parameters[stageNumber]
end

return M