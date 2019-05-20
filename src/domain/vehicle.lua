local Vehicle = {hp = 100, invulnerable = false, invulnerableTime = 1500}

function Vehicle:new(o, vehicleImage, barrierGroup, effectsGroup, antsGroup, uiGroup, commons, sounds)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.hp = 100
    self.xDest = nil
    self.image = nil
    self.xMoveDirection = nil
    self.image = vehicleImage
    self.carVelocity = commons.carVelocity
    self.boostStatus = 1
    self.boostTimer = 5
    self.boostText = display.newText({parent = uiGroup, text = self.boostStatus,
        x = commons.miniStatusBar.x + commons.miniStatusBar.width / 1.1,
        y = commons.miniStatusBar.y + commons.miniStatusBar.height / 2, font = "DejaVuSansMono", width = 20})
    self.boostText:setFillColor(0, 0, 0)
    self.desaccelerationIteration = 0
    self.accelerationIteration = 0
    self.isFlyingSmokeAnimation = false
    self.smokeTimer = nil
    self.backgroundObject = commons.background
    self.barrierGroup = barrierGroup
    self.effectsGroup = effectsGroup
    self.antsGroup = antsGroup
    self.commons = commons
    self.wrench = nil
    self.sounds = sounds
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
    if self.carVelocity <= 315 and self.boostStatus <= 7 then
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
    if self.boostStatus ~= 1 then
        self.boostTimer = self.boostTimer - 1
        if self.boostTimer == 0 and self.commons.stopped == false then
            self.boostTimer = 5
            self:ceaseBoost(backgroundObject, barrierGroup, effectsGroup)
        elseif self.commons.stopped == true then
            self.boostStatus = 1
            self.boostText.text = self.boostStatus
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

function Vehicle:bornInvulnerability()
    self.invulnerable = true
end

function Vehicle:takeDamage(ammount, hpBar, effectsGroup)
    if self.invulnerable == false then
        local physicalHit = require("src.reactions.physicalHit")
        physicalHit:initiateHitSequence(effectsGroup, self.image, self.sounds)
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
        hpBar:subtractHpAnimation(ammountSubtracted, self.image)
    end
end

function Vehicle:desaccelerateObjects()
    self.desaccelerationIteration = self.desaccelerationIteration + 1
    if self.desaccelerationIteration == 10 then
        self.carVelocity = 0
    else
        self.carVelocity = self.carVelocity / 2
    end
    self.backgroundObject.objectBackGroup:setLinearVelocity(0, self.carVelocity)
    self.backgroundObject.objectSecondaryBackGroup:setLinearVelocity(0, self.carVelocity)
    for i=1, self.barrierGroup.numChildren do
        if self.barrierGroup[i] ~= nil then
            self.barrierGroup[i]:setLinearVelocity(0, self.carVelocity)
        end
    end
    for i=1, self.effectsGroup.numChildren do
        if self.effectsGroup[i] ~= nil and self.effectsGroup[i].isBodyActive ~= nil then
            self.effectsGroup[i]:setLinearVelocity(0, self.carVelocity)
        end
    end
    if self.desaccelerationIteration == 10 then
        if self.commons.timeIsUp == false then
            local fixingAnimation = function() return self:initiateFixingAnimation() end
            timer.performWithDelay(100, fixingAnimation)
        end
        self.desaccelerationIteration = 0
    end
end

function Vehicle:desacceleratedStop()
    local desaccelerate = function () return self:desaccelerateObjects() end
    timer.performWithDelay(500, desaccelerate, 10)
end


function Vehicle:accelerateObjects()
    if self.commons.timeIsUp == false then
        self.accelerationIteration = self.accelerationIteration + 1
        if self.accelerationIteration == 10 then
            self.carVelocity = 140
        else
            self.carVelocity = self.carVelocity + 14
        end
        self.backgroundObject.objectBackGroup:setLinearVelocity(0, self.carVelocity)
        self.backgroundObject.objectSecondaryBackGroup:setLinearVelocity(0, self.carVelocity)
        for i=1, self.barrierGroup.numChildren do
            if self.barrierGroup[i] ~= nil then
                self.barrierGroup[i]:setLinearVelocity(0, self.carVelocity)
            end
        end
        for i=1, self.effectsGroup.numChildren do
            if self.effectsGroup[i] ~= nil then
                self.effectsGroup[i]:setLinearVelocity(0, self.carVelocity) 
            end
        end
        if self.accelerationIteration == 10 then
            transition.cancel(self.image)
            self:turnOffInvulnerability()
            self.commons.stopped = false
            self.accelerationIteration = 0
        end
    end
end

function Vehicle:reAcceleratedStart()
    if self.commons.timeIsUp == false then
    transition.blink(self.image, {time = 200, onCancel = function() self.image.alpha = 1.0 end})
    self:bornInvulnerability()
    local accelerate = function() return self:accelerateObjects() end
    timer.performWithDelay(200, accelerate, 10)
    end
end

function Vehicle:eraseSmokePuff(smoke)
    display.remove(smoke)
    smoke = nil
    self.isFlyingSmokeAnimation = false
end

function Vehicle:flySmokePuff()
    if self.isFlyingSmokeAnimation == false then
        local smoke = display.newImage(self.effectsGroup, "assets/images/commons/carsmoke.png", self.image.x, self.image.y)
        physics.addBody(smoke, {})
        smoke.width = 25
        smoke.height = 25
        self.isFlyingSmokeAnimation = true
        local eraseSmoke = function() return self:eraseSmokePuff(smoke) end
        transition.to(smoke, {time = 500, x = smoke.x + 20, y = smoke.y - 40, alpha = 0,
         transition=easing.inQuint, onComplete=eraseSmoke})
    end
end

function Vehicle:rotateAnt(antA)
    antA.xScale = -1
end

function Vehicle:fixingAnimation()
    self.sounds:playASound("car_fix.mp3", 1)
    local drillSound = function() return self.sounds:playASound("car_fix_2.mp3") end
    timer.performWithDelay(50, drillSound)
    self.wrench = display.newImage(self.effectsGroup, "assets/images/commons/wrench.png", self.image.x, self.image.y)
    timer.cancel(self.smokeTimer)
    self.isFlyingSmokeAnimation = false
    self.hp = 100
    self.commons.hpBar:refillAllHpAnimation()
end

function Vehicle:restartCar(antA)
    display.remove(self.wrench)
    self.wrench = nil
    display.remove(antA)
    antA = nil
    self:reAcceleratedStart()
end

function Vehicle:jumpingOnCarAnimation(antA)
    transition.to(antA, {time=300, x = self.image.x, transition=easing.inQuad})
    local restart = function() return self:restartCar(antA) end
    transition.to(antA, {time=300, y = self.image.y, transition=easing.outQuart, onComplete=restart})
end

function Vehicle:initiateFixingAnimation()
    local antA = display.newImage(self.antsGroup, "assets/images/commons/ants/ant_left.png", self.image.x, self.image.y)
    antA.width = 22
    antA.height = 22
    transition.to(antA, {time=300, x = self.image.x - 35, transition=easing.outQuart})
    transition.to(antA, {time=300, y = self.image.y + 10, transition=easing.inQuad})
    local rotateAnt = function() return self:rotateAnt(antA) end
    timer.performWithDelay(400, rotateAnt)
    local fixAnimation = function() return self:fixingAnimation() end
    timer.performWithDelay(500, fixAnimation)
    local jumpOnCar = function() return self:jumpingOnCarAnimation(antA) end
    timer.performWithDelay(2500, jumpOnCar)
end

function Vehicle:initiateDestroyedAnimation()
    self:desacceleratedStop()
    local flySmoke = function() return self:flySmokePuff() end
    self.smokeTimer = timer.performWithDelay(550, flySmoke, 0)
    table.insert(self.commons.timers, self.smokeTimer)
    local carFail = function() return self.sounds:playASound("car_fail.mp3") end
    timer.performWithDelay(400, carFail)
end

function Vehicle:isPushedByWaterCurrent(orientation)
    -- if self.commons.stopped == false then
    --     for i=1, self.barrierGroup.numChildren do
    --         if self.barrierGroup[i] ~= nil then
    --             self.barrierGroup[i]:setLinearVelocity(0, self.carVelocity)
    --         end
    --     end
    --     for i=1, self.effectsGroup.numChildren do
    --         if self.effectsGroup[i] ~= nil and self.effectsGroup[i].isBodyActive ~= nil then
    --             self.effectsGroup[i]:setLinearVelocity(0, self.carVelocity)
    --         end
    --     end
    -- end
end

return Vehicle