local M = {}

local parameters = {
    [1] = {
        background = "grassBackgroundTemporary.jpg", 
        availableBallTypes = {"oxygen", "hydrogen"}
    }
}

function M.getParameters(stageNumber)
    return parameters[stageNumber]
end

return M