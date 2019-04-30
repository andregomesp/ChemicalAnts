local M = {}

local parameters = {
    [1] = {
        -- background = "grassBackgroundTemporary.jpg",
        color = {r = 0.435, g = 0.623, b= 0.196},
        availableBallTypes = {"oxygen", "water"},
        leftWall = "assets/images/commons/scenario/trees.png",
        rightWall = "assets/images/commons/scenario/trees.png",
        stageNumber = 1
    },
    [2] = {
        color = {r = 0.929, g = 0.788, b = 0.686},
        -- color = {r = 0.760, g = 0.698, b = 0.501},
        availableBallTypes = {"oxygen", "water"},
        leftWall = "assets/images/commons/scenario/left-mountain-wall.png",
        rightWall = "assets/images/commons/scenario/right-sand-hole.png",
        stageNumber = 2
    }
}

function M.getParameters(stageNumber)
    return parameters[stageNumber]
end

return M