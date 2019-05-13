local M = {}

local parameters = {
    water = {
        image = "ball_blue.png"
    },
    oxygen = {
        image = "ball_red.png"
    },
    chlorideAcid = {
        image = "ball_yellow.png"
    }
}

function M.getImage(element)
    return parameters[element].image
end

return M