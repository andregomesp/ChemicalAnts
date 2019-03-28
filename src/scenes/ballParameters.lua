local M = {}

local parameters = {
    hydrogen = {
        image = "ball_blue.png"
    },
    oxygen = {
        image = "ball_red.png"
    }
}

function M.getImage(element)
    return parameters[element].image
end

return M