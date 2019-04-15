local M = {}

function M:initiateCommonListeners(commons, shootGroup, effectsGroup, barrierGroup)


    local function controlVehicleMovement(event)
        commons.vehicle:controlMovement()
        return true
    end

    local function collisionCar(event)
        if event.other.myName == "barrier" then
            commons.vehicle:takeDamage(10, commons.hpBar, effectsGroup)
            display.remove(event.other)
            event.other = nil
        elseif event.other.myName == "explosion" then
            commons.vehicle:takeDamage(15, commons.hpBar, effectsGroup)
        elseif event.other.myName == "objectBackGroup" then
            -- commons.vehicle:bounceOffWall()
        end 
        return true
    end

    local function handleBackground(event)
        needToMoveGroup = commons.background:checkBackgroundNeedsRebuild()
        if needToMoveGroup ~= false then
            commons.background:moveBackgroundGroup(needToMoveGroup)
        end
        return true
    end

    local function moveVehicle(event)
            if (event.phase == "ended" and event.yStart - event.y > 30) then
                commons.vehicle:boost(event, commons.background, barrierGroup)
            elseif (event.phase == "ended") then 
                commons.vehicle:move(event)
            end
        return true
    end


    commons.background.objectSecondaryBackGroup:addEventListener("touch", moveVehicle)
    commons.background.objectBackGroup:addEventListener("touch", moveVehicle)
    commons.background.image:addEventListener("touch", moveVehicle)
    commons.vehicle.image:addEventListener("collision", collisionCar)
    Runtime:addEventListener( "enterFrame", controlVehicleMovement )
    Runtime:addEventListener( "enterFrame", function (event) return handleBackground(event) end )
end

return M