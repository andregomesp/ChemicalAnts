local M = {}

local parameters = {
    ["hydrogen"] = {
        image = "ball_red.svg"
    },
    ["oxygen"] = {
        image = "ball_blue.svg" 
    }
}

function M.getImage(element)
    return parameters[element]
end

return M