local BarrierDestroyer = {element = nil, image = nil}

function BarrierDestroyer:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local function destroyBarriers(event)
    if event.other.myName == "barrier" and event.other ~= nil then
        display.remove(event.other)
        event.target.other = nil
    end
end

function BarrierDestroyer:initiateBarrierDestroyer(backgroundGroup)
    local barrierDestroyer = display.newRect(backgroundGroup, 0, display.viewableContentHeight + 630, display.viewableContentWidth, 30)
    barrierDestroyer.anchorX = 0
    physics.addBody(barrierDestroyer, "dynamic", {isSensor=true})
    barrierDestroyer:addEventListener("collision", destroyBarriers)
end

return BarrierDestroyer