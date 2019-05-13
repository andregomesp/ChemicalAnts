-- These areinitia the ghosts used in the 5th stage!!11!1!
local Ghost = {doPatterns = false}

function Ghost:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.doPatterns = false
    return o
end

function Ghost:setParameters(ghostGroup, ghostName)
    self.ghostGroup = ghostGroup
    self.ghostName = ghostName
end

function Ghost:createLightMask(x, y)
    local dynamicAccess = {}
    dynamicAccess[self.ghostName] = graphics.newMask("assets/images/commons/masks/lightmask3.png")
    self.ghostGroup:setMask(dynamicAccess[self.ghostName])
    self.ghostGroup.maskX = x
    self.ghostGroup.maskY = y
    local fieryIn = function () return transition.to(self.ghostGroup,
        {maskScaleX = 0.92, maskScaleY = 0.92, time = 400}) end
    local fieryOut = function () return transition.to(self.ghostGroup,
        {maskScaleX = 1, maskScaleY = 1, time = 400}) end
    timer.performWithDelay(500, fieryIn, 0)
    timer.performWithDelay(500, fieryOut, 0)
end

function Ghost:enablePatterns()
    self.doPatterns = true

end

function Ghost:initiatePatterns(type)
    self:enablePatterns()
    if type == "a" then
        self:doPattern(1, 1)
    else
        self:doPattern(1, 2)
    end
end

local patternList = {
    [1] = {
        [1] = function (context, ghostGroup, pattern, step) return transition.to(ghostGroup,
            {maskX = 70, time = 3000, delay = 800, tag="ghostMovement", onComplete=function() return context:doPattern(pattern, step+1) end}) end,
        [2] = function (context, ghostGroup, pattern, step) return transition.to(ghostGroup,
            {maskX = 240, time = 3000, delay = 800, tag="ghostMovement", onComplete=function() return context:doPattern(pattern, step-1) end}) end
    }
    -- [2] = 
    -- [3] =
    -- [4] = 
    -- [5] = 
}

function Ghost:getPattern(pattern)
    return patternList[pattern]
end

function Ghost:doPattern(pattern, step)
    local patterns = self:getPattern(pattern)
    patterns[step](self, self.ghostGroup, pattern, step)
end

function Ghost:stopPatterns()
    self.doPatterns = false
end

function Ghost:destroyGhost()
end

return Ghost