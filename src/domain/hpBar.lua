local hpBar = {boxImage = nil, boxBackgroundImage = nil, barImage = nil}

function hpBar:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function hpBar:drawBar(uiGroup)
    local hpBar = display.newRoundedRect(uiGroup, display.viewableContentWidth - 30, 60, 20, 60)
    local boxBackgroundImage = display.newRoundedRect(uiGroup, display.viewableContentWidth - 30, 60, 20, 60)
    local boxImage = display.newRoundedRect(uiGroup, display.viewableContentWidth - 30, 60, 20, 60)
    self.image = hpBar
    hpBar:setFillColor(0.22, 0.76, 0.16)
    boxBackgroundImage:setFillColor(13.33, 0.91, 0.94, 0.8)
    boxBackgroundImage.fill.effect = "filter.frostedGlass"
    object.fill.effect.scale = 80
    boxImage:setFillColor(1, 1, 1, 1)
    boxImage.strokeWidth = 3
    boxImage:setStrokeColor(1, 1, 1)
end

function hpBar:subtractHp()
end