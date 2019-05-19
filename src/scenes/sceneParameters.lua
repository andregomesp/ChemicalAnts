local M = {}

local parameters = {
    [1] = {
        -- background = "grassBackgroundTemporary.jpg",
        color = {r = 0.435, g = 0.623, b= 0.196},
        availableBallTypes = {"water"},
        coolDownTime = {1000},
        leftWall = "assets/images/commons/scenario/trees.png",
        rightWall = "assets/images/commons/scenario/trees.png",
        stageNumber = 1
    },
    [2] = {
        color = {r = 0.929, g = 0.788, b = 0.686},
        availableBallTypes = {"hydrogen", "water"},
        coolDownTime = {4000, 2000},
        leftWall = "assets/images/commons/scenario/left-mountain-wall.png",
        rightWall = "assets/images/commons/scenario/right-sand-hole.png",
        stageNumber = 2
    },
    [3] = {
        -- background = "grassBackgroundTemporary.jpg",
        color = {r = 0.082, g = 0.423, b= 0.6},
        availableBallTypes = {"hydrogen", "water", "chlorideAcid"},
        coolDownTime = {4000, 2000, 8000},
        leftWall = "assets/images/commons/scenario/left-river-wall.png",
        rightWall = "assets/images/commons/scenario/right-river-wall.png",
        stageNumber = 3
    },
    [4] = {
        -- background = "grassBackgroundTemporary.jpg",
        color = {r = 0.317, g = 0.141, b= 0.023},
        availableBallTypes = {"hydrogen", "water", "chlorideAcid"},
        coolDownTime = {4000, 2000, 8000},
        leftWall = "assets/images/commons/scenario/left-cave-wall.png",
        rightWall = "assets/images/commons/scenario/right-cave-wall.png",
        stageNumber = 4
    },
    [5] = {
        color = {r = 0.415, g = 0.411, b= 0.486},
        availableBallTypes = {"hydrogen", "water", "chlorideAcid"},
        coolDownTime = {4000, 2000, 8000},
        leftWall = "assets/images/commons/scenario/autumn-trees.png",
        rightWall = "assets/images/commons/scenario/autumn-trees.png",
        stageNumber = 5
    },
    [6] = {
        -- background = "grassBackgroundTemporary.jpg",
        color = {r = 0.435, g = 0.623, b= 0.196},
        availableBallTypes = {"hydrogen", "water"},
        coolDownTime = {4000, 2000},
        leftWall = "assets/images/commons/scenario/trees.png",
        rightWall = "assets/images/commons/scenario/trees.png",
        stageNumber = 6
    },
}

function M.getParameters(stageNumber)
    return parameters[stageNumber]
end

return M