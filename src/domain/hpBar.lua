local HpBar = {boxImage = nil, boxBackgroundImage = nil, barImage = nil}

function HpBar:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function HpBar:restoreBarColor()
    self.barImage:setFillColor(0.22, 0.76, 0.16)
end

function HpBar:drawBar(uiGroup)
    local barX = display.viewableContentWidth - 30
    local boxImage = display.newRoundedRect(uiGroup, barX, 60, 20, 90, 5)
    local boxBackgroundImage = display.newRoundedRect(uiGroup, barX, 60, 20, 90, 5)
    local hpBarImage = display.newRoundedRect(uiGroup, barX - 10, 105, 20, 90, 5)
    self.barImage = hpBarImage
    self.boxBackgroundImage = boxBackgroundImage
    self.boxImage = boxImage
    hpBarImage.anchorX, hpBarImage.anchorY = 0, 1
    boxBackgroundImage:setFillColor(0.133, 0.91, 0.94)
    boxBackgroundImage.fill.effect = "filter.frostedGlass"
    boxBackgroundImage.fill.effect.scale = 100
    hpBarImage:setFillColor(0.22, 0.76, 0.16)
    boxImage:setFillColor(1, 1, 1, 0)
    boxImage.strokeWidth = 3
    boxImage:setStrokeColor(0, 0, 0)
end

function HpBar:subtractHpAnimation(ammountSubtracted)
    self.barImage:setFillColor(0.858, 0.2, 0.082)
    local imageCurrentHeightPerCentToSubtract = (ammountSubtracted / 100) * self.boxImage.height
    transition.to(self.barImage, {time=200, height=self.barImage.height - imageCurrentHeightPerCentToSubtract,
    transition = "easing.outQuart", onComplete = function() return self:restoreBarColor() end})

end

return HpBar