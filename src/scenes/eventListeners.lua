local M = {}

function M:initiateCommonListeners(commons, effectsGroup, barrierGroup, backgroundUiGroup)


    local function controlVehicleMovement(event)
        commons.vehicle:controlMovement()
        return true
    end

    local function collisionCar(event)
        if commons.paused == false then
            if event.other.myName == "barrier" and event.other.isHittable == true then
                commons.vehicle:takeDamage(10, commons.hpBar, effectsGroup)
                -- Todo: ball hitting removed crashed object. Bugs happening.
                -- Possible solution: execute with delay
                event.other.isHittable = false
                display.remove(event.other)
                event.other = nil
            elseif event.other.myName == "explosion" then
                commons.vehicle:takeDamage(15, commons.hpBar, effectsGroup)
            end
        end 
        return true
    end

    local function doNothing(event)
        return true
    end

    local function handleBackground(event)
        local needToMoveGroup = commons.background:checkBackgroundNeedsRebuild()
        if needToMoveGroup ~= false then
            commons.background:moveBackgroundGroup(needToMoveGroup)
        end
        return true
    end

    local function moveVehicle(event)
        if commons.paused == false and commons.stopped == false then
            if (event.phase == "ended" and event.yStart - event.y > 30) then
                commons.vehicle:boost(event, commons.background, barrierGroup, effectsGroup)
            elseif (event.phase == "ended") then
                commons.vehicle:move(event)
            end
        end
        return true
    end

    commons.cannonUiBar:addEventListener("touch", doNothing)
    commons.miniStatusBar:addEventListener("touch", doNothing)
    commons.background.objectSecondaryBackGroup:addEventListener("touch", moveVehicle)
    commons.background.objectBackGroup:addEventListener("touch", moveVehicle)
    commons.background.image:addEventListener("touch", moveVehicle)
    commons.vehicle.image:addEventListener("collision", collisionCar)
    Runtime:addEventListener( "enterFrame", controlVehicleMovement )
    Runtime:addEventListener( "enterFrame", function (event) return handleBackground(event) end )
end

function M:removeEventListeners(commons)

end

return M