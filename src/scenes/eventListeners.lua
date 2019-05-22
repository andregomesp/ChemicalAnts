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

    local function testNormalCollision(event)
        if event.other.myName == "barrier" and event.other.isHittable == true then
            local damage = 20
            if event.other.element == "ferrum" then
                damage = 30
            end
            commons.vehicle:takeDamage(damage, commons.hpBar, effectsGroup)
            event.other.isHittable = false
            display.remove(event.other)
            event.other = nil
            return true
        elseif event.other.myName == "explosion" then
            commons.vehicle:takeDamage(25, commons.hpBar, effectsGroup)
            return true
        end
        return false
    end

    local function collisionCar(event)
        if commons.paused == false and commons.timeIsUp == false then
            testNormalCollision(event)
        end
        return true
    end

    local function collisionCar4thStage(event)
        if commons.paused == false and commons.timeIsUp == false then
            local normalCollision = testNormalCollision(event)
            if normalCollision == false then
                if event.other.myName == "bubbleHitBox" then
                    if (event.phase == "ended") then
                        commons.vehicle:cancelPushedByWaterCurrent()
                    else
                        commons.vehicle:isPushedByWaterCurrent(event.other.orientation)
                    end
                end
                -- elseif event.other.myName == "noLongerBubbleHit" then 
                --     commons.vehicle:cancelPushedByWaterCurrent()
                -- end
            end
        end
        return true
    end

    if commons.stageNumber == 4 then
        collisionTheCar = collisionCar4thStage
    else
        collisionTheCar = collisionCar
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
    commons.vehicle.image:addEventListener("collision", collisionTheCar)
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