local hpBar = {image = nil}

function hpBar:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function hpBar:drawBar(uiGroup)
    local hpBar = display.newRect(display.viewableContentWidth - 30, 60, 20, 60)
    hpBar:setFillColor(0.22, 0.76, 0.16)
    hpBar.strokeWidth = 3
    hpBar:setStrokeColor(1, 1, 1)
end

function hpBar:subtractHp()
end