local M = {}

function M:initiateCommonListeners(commons, shootGroup)
    local function controlVehicleMovement(event)
        commons.vehicle:controlMovement()
        return true
    end

    local function collisionCar(event)
        if event.other.myName == "barrier" then
            commons.vehicle:takeDamage(10)
        elseif event.other.myName == "explosion" then
            commons.vehicle:takeDamage(15)
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