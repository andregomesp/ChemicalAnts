local Background = {objectBackGroup = nil, mainBackGroup = nil}

function Background:new(o, background, objectBackGroup, objectSecondaryBackGroup, mainBackGroup)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.objectBackGroup = objectBackGroup
    self.objectSecondaryBackGroup = objectSecondaryBackGroup
    self.mainBackGroup = mainBackGroup
    self.image = background
    return o
end

function Background:buildBackground(carVelocity, stageParams)
    self.objectBackGroup.x = 0
    self.objectBackGroup.y = -160
    self.objectBackGroup.myName = "objectBackGroup"
    self.objectSecondaryBackGroup.x = 310
    self.objectSecondaryBackGroup.y = -160
    self.objectSecondaryBackGroup.myName = "objectBackGroup"
    local i = 0
    while i < 16 do
        local leftWall = display.newImageRect(self.objectBackGroup,
        stageParams.leftWall, 120, 120)
        local rightWall = display.newImageRect(self.objectSecondaryBackGroup,
        stageParams.rightWall, 120, 120)
        leftWall.y = 50 * i
        rightWall.y = 50 * i
        if (stageParams.stageNumber == 2) then
            rightWall:toBack()
            leftWall.y = 100 * i
            rightWall.y = 100 * i
        end
        
        i = i + 1
    end
    physics.addBody(self.objectBackGroup, "dynamic", {isSensor = true})
    physics.addBody(self.objectSecondaryBackGroup, "dynamic", {isSensor = true})
    self.objectBackGroup:setLinearVelocity(0, carVelocity)
    self.objectSecondaryBackGroup:setLinearVelocity(0, carVelocity)
    self.objectBackGroup:addEventListener("collision", function(event) return self:handleCollision(event) end)
    self.objectSecondaryBackGroup:addEventListener("collision", function(event) return self:handleCollision(event) end)
end

function Background:checkBackgroundNeedsRebuild()
    if self.objectSecondaryBackGroup.y > -10 then
        return true
    end
    return false
end

function Background:handleCollision(event)
end

function Background:moveBackgroundGroup(moveGroup)
    if moveGroup == true then
        self.objectBackGroup.y = -210
        self.objectSecondaryBackGroup.y = -210
    end
end

return Background