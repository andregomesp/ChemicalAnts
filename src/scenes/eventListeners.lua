local M = {}
local controlTheVehicle = nil
local handleTheBackground = nil
local collisionTheCar = nil
local commons = nil

function M:initiateCommonListeners(commonsValues, effectsGroup, barrierGroup)
    commons = commonsValues
    local function controlVehicleMovement(event)
        commons.vehicle:controlMovement()
        return true
    end
    controlTheVehicle = controlVehicleMovement

    local function collisionCar(event)
        if commons.paused == false and commons.timeIsUp == false then
            if event.other.myName == "barrier" and event.other.isHittable == true then
                commons.vehicle:takeDamage(20, commons.hpBar, effectsGroup)
                event.other.isHittable = false
                display.remove(event.other)
                event.other = nil
            elseif event.other.myName == "explosion" then
                commons.vehicle:takeDamage(25, commons.hpBar, effectsGroup)
            end
        end 
        return true
    end

    collisionTheCar = collisionCar

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
    handleTheBackground = handleBackground

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
    Runtime:addEventListener( "enterFrame", handleBackground)
end

function M:removeEventListeners()
    Runtime:removeEventListener("enterFrame", controlTheVehicle)
    Runtime:removeEventListener("enterFrame", handleTheBackground)
end

function M:removeVehicleHitListener()
    commons.vehicle.image:removeEventListener("collision", collisionTheCar)
end

return M