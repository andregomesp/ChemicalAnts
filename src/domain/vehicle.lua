local Vehicle = {hp = 100}

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

function Vehicle:bounceOffWall()
    -- self.image:setLinearVelocity(0, 0)
    -- self.image.angularVelocity = 0
    -- self.image.rotation = 0
    return true
end

function Vehicle:makeMovement(event)
    print(event.target.myName)
    if event.target.myName == "objectBackGroup" then
        if event.target.x <= self.image.x then
            self.xDest = event.target.x + event.target.width / 2.1 + (self.image.width / 2) + 1
        else
            self.xDest = event.target.x - (self.image.width / 2) - 1
        end
    else
        self.xDest = event.x
    end
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

    if event.x ~= self.image.x then
        self.image:setLinearVelocity(vehicleXVelocity, vehicleYVelocity)
    end
end

function Vehicle:move(event)
    self:makeMovement(event)
    return true
end

function Vehicle:controlMovement()
    if (self.xMoveDirection == "right" and self.xDest <= self.image.x) or (self.xMoveDirection == "left" and self.xDest >= self.image.x) then
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
            anglePerTick = self.image.angularVelocity/display.fps
            if (self.image.rotation + anglePerTick) < 0 then
                self.image.rotation = 0
                self.image.angularVelocity = 0    
            end
        elseif self.image.angularVelocity > 0 and (self.image.rotation >= 0) then
            anglePerTick = self.image.angularVelocity/display.fps
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

function Vehicle:takeDamage(ammount)
    if (self.hp - ammount < 0) then
        self.hp = 0
    else
        self.hp = self.hp - ammount
    end
end

function Vehicle:destroy()
end

return Vehicle
