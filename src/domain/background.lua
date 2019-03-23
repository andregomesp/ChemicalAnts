Background = {objectBackGroup = nil, mainBackGroup = nil}

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

function Background:buildBackground(carVelocity)
    self.objectBackGroup.y = -60
    self.objectBackGroup.myName = "objectBackGroup"
    self.objectSecondaryBackGroup.y = 540 
    self.objectSecondaryBackGroup.myName = "objectBackGroup"
    local i = 0
    local backGroup = self.objectBackGroup
    local yAdjuster = 0
    while i < 24 do
        if i > 11 then
            backGroup = self.objectSecondaryBackGroup
            yAdjuster = 12
        end
        local leftWall = display.newImageRect(backGroup, "assets/images/commons/scenario/trees.png", 120, 120)
        local rightWall = display.newImageRect(backGroup, "assets/images/commons/scenario/trees.png", 120, 120)
        leftWall.x = 10
        leftWall.y = 50 * (i - yAdjuster)
        rightWall.x = 310
        rightWall.y = 50 * (i - yAdjuster)
        i = i + 1
    end
    physics.addBody(self.objectBackGroup, "dynamic", {isSensor = true})
    physics.addBody(self.objectSecondaryBackGroup, "dynamic", {isSensor = true})
    self.objectBackGroup:setLinearVelocity(0, carVelocity)
    self.objectSecondaryBackGroup:setLinearVelocity(0, carVelocity)
    self.objectBackGroup:addEventListener("collision", function() return print("bateu") end)
    -- self.objectSecondaryBackGroup:addEventListener("collision", )
end

function Background:checkBackgroundNeedsRebuild()
    if self.objectSecondaryBackGroup.y > display.viewableContentHeight + 40 then
        return true
    end
    return false
end

function Background:moveBackgroundGroup(moveGroup)
    if moveGroup == true then
        self.objectBackGroup.y = self.objectBackGroup.y - 600
        self.objectSecondaryBackGroup.y = self.objectSecondaryBackGroup.y - 600 
    end
end

return Background