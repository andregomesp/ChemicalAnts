local Vehicle = {hp = 100, invulnerable = false, invulnerableTime = 1500}

function Vehicle:new(o, vehicleImage, carVelocity, stopped, backgroundObject, barrierGroup)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.hp = 100
    self.xDest = nil
    self.image = nil
    self.xMoveDirection = nil
    self.image = vehicleImage
    self.carVelocity = carVelocity
    self.boostStatus = 1
    self.boostTimer = 5
    self.stopped = stopped
    self.boostText = display.newText({parent = uiGroup, text = self.boostStatus, x = display.viewableContentWidth - 30, y = display.viewableContentHeight - 125,
    font = "DejaVuSansMono", width = 20})
    self.boostText:setFillColor(0, 0, 0)
    self.desaccelerationIteration = 0
    self.backgroundObject = backgroundObject
    self.barrierGroup = barrierGroup
    self.effectsGroup = effectsGroup
    return o
end

function Vehicle:makeMovement(event)
    local willMove = true
    if event.target.myName == "objectBackGroup" then
        if event.target.x < self.image.x then
            local leftBoundary = event.target.x + event.target.width / 2 + (self.image.width / 2)
            if leftBoundary < self.image.x then
                self.xDest = leftBoundary
            else
                willMove = false
            end
        elseif event.target.x > self.image.x then
            local rightBoundary = event.target.x - event.target.width / 2 - (self.image.width / 2)
            if rightBoundary > self.image.x then
                self.xDest = rightBoundary
            else
                willMove = false
            end
        end
    else
        self.xDest = event.x
    end

    if willMove == true then
        local objectXOffset = event.x - self.image.x
        local directionMultiplier = 0
        local vehicleAngularVelocity = 0
        if event.x > self.image.x then
            vehicleAngularVelocity = 35
            self.xMoveDirection = "right"
            directionMultiplier = 1

        elseif event.x < self.image.x then
            vehicleAngularVelocity = -35
            self.xMoveDirection = "left"
            directionMultiplier = -1
        end
        local vehicleXVelocity = (15 * (objectXOffset/40)) + 55 * directionMultiplier
        local vehicleYVelocity = 0

        if self.xMoveDirection == "right" then
            if self.image.rotation <= 15 and self.image.rotation >= 0 then
                self.image.angularVelocity = vehicleAngularVelocity
            elseif self.image.rotation >= -15 and self.image.rotation < 0 then
                self.image.angularVelocity = vehicleAngularVelocity
            end
        elseif self.xMoveDirection == "left" then
            if self.image.rotation >= -15 and self.image.rotation <= 0 then
                self.image.angularVelocity = vehicleAngularVelocity
            elseif self.image.rotation <= 15 and self.image.rotation > 0 then
                self.image.angularVelocity = vehicleAngularVelocity
            end
        end

        if event.x ~= self.image.x and willMove == true then
            self.image:setLinearVelocity(vehicleXVelocity, vehicleYVelocity)
        end
    end
    return true
end

function Vehicle:boost(event, backgroundObject, barrierGroup, effectsGroup)
    if self.carVelocity <= 315 then
        self.carVelocity = self.carVelocity + 35
        self.boostStatus = self.boostStatus + 1
        self.boostText.text = self.boostStatus
        self.boostTimer = 5
        backgroundObject.objectBackGroup:setLinearVelocity(0, self.carVelocity)
        backgroundObject.objectSecondaryBackGroup:setLinearVelocity(0, self.carVelocity)
        for i=1, barrierGroup.numChildren do
            if barrierGroup[i] ~= nil then
                barrierGroup[i]:setLinearVelocity(0, self.carVelocity) 
            end
        end
        for i=1, effectsGroup.numChildren do
            if effectsGroup[i] ~= nil then
                effectsGroup[i]:setLinearVelocity(0, self.carVelocity) 
            end
        end
    end
    return true
end

function Vehicle:boostcount(backgroundObject, barrierGroup, effectsGroup)
    if self.boostStatus ~= 1 and self.stopped == false then
        self.boostTimer = self.boostTimer - 1
        if self.boostTimer == 0 then
            self.boostTimer = 5
            self:ceaseBoost(backgroundObject, barrierGroup, effectsGroup)
        end
    end
end

function Vehicle:ceaseBoost(backgroundObject, barrierGroup, effectsGroup)
    self.carVelocity = self.carVelocity - 35
    self.boostStatus = self.boostStatus - 1
    self.boostText.text = self.boostStatus
    backgroundObject.objectBackGroup:setLinearVelocity(0, self.carVelocity)
    backgroundObject.objectSecondaryBackGroup:setLinearVelocity(0, self.carVelocity)
    for i=1, barrierGroup.numChildren do
        if barrierGroup[i] ~= nil then
            barrierGroup[i]:setLinearVelocity(0, self.carVelocity) 
        end
    end
    for i=1, effectsGroup.numChildren do
        if effectsGroup[i] ~= nil then
            effectsGroup[i]:setLinearVelocity(0, self.carVelocity) 
        end
    end
    return true
end

function Vehicle:controlMovement()
    if (self.xMoveDirection == "right" and self.xDest <= self.image.x) or
     (self.xMoveDirection == "left" and self.xDest >= self.image.x) then
        self.xMoveDirection = nil
        self.image:setLinearVelocity(0, 0)
        if self.image.rotation > 0 then
            self.image.angularVelocity = -55
        elseif self.image.rotation < 0 then
            self.image.angularVelocity = 55
        end

    end

    if self.image.rotation > 15 then
        self.image.rotation = 15
        self.image.angularVelocity = 0
    elseif self.image.rotation < -15 then
        self.image.rotation = -15
        self.image.angularVelocity = 0
    end

    if self.xMoveDirection ~= nil then
        if self.image.angularVelocity > 0 and (self.image.rotation < 15 and self.image.rotation >= 0) then
            local anglePerTick = self.image.angularVelocity/display.fps
            if (self.image.rotation + anglePerTick) > 15 then
                self.image.rotation = 15
                self.image.angularVelocity = 0
            end
        elseif self.image.angularVelocity < 0 and (self.image.rotation > -15 and self.image.rotation <= 0) then
            local anglePerTick = self.image.angularVelocity/display.fps
            if (self.image.rotation + anglePerTick) < -15 then
                self.image.rotation = -15
                self.image.angularVelocity = 0
            end
        end
    else
        if self.image.angularVelocity < 0 and (self.image.rotation <= 0) then
            local anglePerTick = self.image.angularVelocity/display.fps
            if (self.image.rotation + anglePerTick) < 0 then
                self.image.rotation = 0
                self.image.angularVelocity = 0
            end
        elseif self.image.angularVelocity > 0 and (self.image.rotation >= 0) then
            local anglePerTick = self.image.angularVelocity/display.fps
            if (self.image.rotation + anglePerTick) > 0 then
                self.image.rotation = 0
                self.image.angularVelocity = 0
            end
        end
    end
    return true
end

function Vehicle:initiateBoostLoop(backgroundObject, barrierGroup, effectsGroup)
    local boostcount = function() return self:boostcount(backgroundObject, barrierGroup, effectsGroup) end
    self.boostCount = timer.performWithDelay(500, boostcount, 0)
end

function Vehicle:move(event)
    self:makeMovement(event)
    return true
end


function Vehicle:turnOffInvulnerability()
    self.invulnerable = false
end

function Vehicle:adjustInvulnerability()
    self.invulnerable = true
    timer.performWithDelay(self.invulnerableTime, function() return self:turnOffInvulnerability() end)
end

function Vehicle:takeDamage(ammount, hpBar, effectsGroup)
    if self.invulnerable == false then
        local physicalHit = require("src.reactions.physicalHit")
        physicalHit:initiateHitSequence(effectsGroup, self)
        transition.blink(self.image, {time = 200, onCancel = function() self.image.alpha = 1.0 end})
        timer.performWithDelay(self.invulnerableTime - 100, function() transition.cancel(self.image) end)
        self:adjustInvulnerability()
        local ammountSubtracted = ammount
        if (self.hp - ammount < 0) then
            ammountSubtracted = self.hp
            self.hp = 0
        else
            self.hp = self.hp - ammount
        end
        hpBar:subtractHpAnimation(ammountSubtracted, self)
    end
end

function Vehicle:desaccelerateObjects(backgroundObject, barrierGroup, effectsGroup)
    self.desaccelerationIteration = self.desaccelerationIteration + 1
    if self.desaccelerationIteration == 10 then
        self.carVelocity = 0
    else
        self.carVelocity = self.carVelocity / 2
    end    
    print("desaccelerating " .. self.desaccelerationIteration)
    backgroundObject.objectBackGroup:setLinearVelocity(0, self.carVelocity)
    backgroundObject.objectSecondaryBackGroup:setLinearVelocity(0, self.carVelocity)
    for i=1, barrierGroup.numChildren do
        if barrierGroup[i] ~= nil then
            barrierGroup[i]:setLinearVelocity(0, self.carVelocity) 
        end
    end
    for i=1, effectsGroup.numChildren do
        if effectsGroup[i] ~= nil then
            effectsGroup[i]:setLinearVelocity(0, self.carVelocity) 
        end
    end
end

function Vehicle:desacceleratedStop(backgroundObject, barrierGroup, effectsGroup)
    print("desaccelerating")
    desaccelerate = function () return self:desaccelerateObjects(backgroundObject, barrierGroup, effectsGroup) end
    timer.performWithDelay(500, desaccelerate, 10)
end

function Vehicle:initiateDestroyedAnimation(backgroundObject, barrierGroup, effectsGroup)
    print("animation initiated") 
    self:desacceleratedStop(backgroundObject, barrierGroup, effectsGroup)
    

end

return Vehicle