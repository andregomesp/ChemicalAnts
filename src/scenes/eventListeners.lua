local M = {}

function M:initiateCommonListeners(commons, shootGroup)
    local function fire(event)
        commons.cannon:fire(commons.vehicle.image, shootGroup)
        return true
    end

    local function controlVehicleMovement(event)
        commons.vehicle:controlMovement()
        return true
    end

    local function moveVehicle(event)
        commons.vehicle:move(event)
        return true
    end

    local function moveBackground(event)
        commons.background:moveBackground()
        return true
    end


    commons.background.image:addEventListener("touch", moveVehicle)
    Runtime:addEventListener( "enterFrame", controlVehicleMovement )
    Runtime:addEventListener( "enterFrame", moveBackground )
end

return M