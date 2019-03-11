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
    print("oi")
    local pretty = require("libraries.penlight.pretty")
    pretty.dump(element)
    print(parameters[element])
    return parameters[element].image
end

return M