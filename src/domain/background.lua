Background = {objectBackGroup = nil, mainBackGroup = nil}

function Background:new(o, background, objectBackGroup, mainBackGroup)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.objectBackGroup = objectBackGroup
    self.mainBackGroup = mainBackGroup
    self.image = background
    return o    
end

function Background:moveBackground()
    local xv, xy = self.objectBackGroup:getLinearVelocity()
    if xy == 0 then
        self.objectBackGroup:setLinearVelocity(0, 45)
    end
    return true
end

return Background