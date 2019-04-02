local Vehicle = {hp = 100, invulnerable = false, invulnerableTime = 1500}

function Vehicle:new(o, vehicleImage, carVelocity)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.hp = 100
    self.xDest = nil
    self.image = nil
    self.xMoveDirection = nil
    self.image = vehicleImage
    self.carVelocity = carVelocity
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
end

function Vehicle:move(event)
    self:makeMovement(event)
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

function Vehicle:boost()
end

function Vehicle:turnOffInvulnerability()
    self.invulnerable = false
end

function Vehicle:adjustInvulnerability()
    self.invulnerable = true
    timer.performWithDelay(self.invulnerableTime, function() return self:turnOffInvulnerability() end)
end

function Vehicle:takeDamage(ammount, hpBar)
    if self.invulnerable == false then
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

function Vehicle:destroy()
end

return Vehicle
