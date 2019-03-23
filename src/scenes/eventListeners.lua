local M = {}

function M:initiateCommonListeners(commons, shootGroup)
    local function controlVehicleMovement(event)
        commons.vehicle:controlMovement()
        return true
    end

    local function collisionCar(event)
        if event.other.class == "barrier" then
            print("bateu na barreira")
        end
        return true
    end

    local function handleBackground(event)
        moveGroup = commons.background:checkBackgroundNeedsRebuild()
        if moveGroup ~= false then
            commons.background:moveBackgroundGroup(moveGroup)
        end
        return true
    end

    local function moveVehicle(event)
        commons.vehicle:move(event)
        return true
    end

    commons.background.image:addEventListener("touch", moveVehicle)
    commons.vehicle.image:addEventListener("collision", collisionCar)
    Runtime:addEventListener( "enterFrame", controlVehicleMovement )
    Runtime:addEventListener( "enterFrame", function (event) return handleBackground(event) end )
end

return M