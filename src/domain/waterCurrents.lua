local WaterCurrent = {}

function WaterCurrent:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.bubbleEmitter = nil
    self.bubbleHitBox = nil
    self.noLongerHitBoxLeft = nil
    self.noLongerHitBoxRight = nil
    self.noLongerHitBoxSouth = nil
    self.isEnabled = false
    return o
end

-- Orientation is either 1 (downward) or -1 (upward)
function WaterCurrent:createCurrent(currentsGroup, orientation, xPos, vehicleImage)
    if currentsGroup ~= nil then
        local vehicleWidth = vehicleImage.width
        self.isEnabled = true
        local yPos
        local yBubbleEmitterPos
        local anchorY
        local southY
        local southDestiny
        local southAnchorY
        local boxDestiny
        local transitionHeight = display.viewableContentHeight
        if orientation == 1 then
            anchorY = 1
            southAnchorY = 0
            yPos = 0
            yBubbleEmitterPos = - 40
            southY = display.contentCenterY * 0.5
            southDestiny = display.viewableContentHeight
        else
            anchorY = 0
            southAnchorY = 1
            yBubbleEmitterPos = display.viewableContentHeight + 40
            yPos = display.viewableContentHeight
            southY = display.viewableContentHeight
            southDestiny = 0
        end
        self.bubbleHitBox = display.newRect(currentsGroup, xPos, yPos, 50, display.viewableContentHeight)
        self.noLongerHitBoxLeft = display.newRect(currentsGroup,
            xPos - (self.bubbleHitBox.width / 2) - vehicleWidth - 0.1, yPos, 2, display.viewableContentHeight)
        self.noLongerHitBoxRight = display.newRect(currentsGroup,
            xPos + (self.bubbleHitBox.width / 2) + vehicleWidth + 0.1, yPos, 2, display.viewableContentHeight)
        self.noLongerHitBoxSouth = display.newRect(currentsGroup,
            0, southY, display.viewableContentWidth, 1)
        self.noLongerHitBoxSouth.anchorX = 0
        self.noLongerHitBoxLeft:setFillColor(1, 0, 0)
        self.noLongerHitBoxRight:setFillColor(0.3, 0.7, 0.6)
        self.noLongerHitBoxSouth:setFillColor(0.4, 0.9, 0.1)
        physics.addBody(self.bubbleHitBox, "dynamic", {isSensor=true, isBullet=true})
        physics.addBody(self.noLongerHitBoxLeft, "dynamic", {isSensor=true})
        physics.addBody(self.noLongerHitBoxRight, "dynamic", {isSensor=true})
        physics.addBody(self.noLongerHitBoxSouth, "dynamic", {isSensor=true})
        self.bubbleHitBox.myName = "bubbleHitBox"
        self.bubbleHitBox.orientation = orientation
        self.bubbleHitBox.anchorY = anchorY
        self.bubbleHitBox.alpha = 1
        self.noLongerHitBoxLeft.myName = "noLongerBubbleHit"
        self.noLongerHitBoxRight.myName = "noLongerBubbleHit"
        self.noLongerHitBoxSouth.myName = "noLongerBubbleHit"
        self.noLongerHitBoxLeft.anchorY = anchorY
        self.noLongerHitBoxRight.anchorY = anchorY
        self.noLongerHitBoxSouth.anchorY = southAnchorY
        self.noLongerHitBoxLeft.orientation = orientation
        self.noLongerHitBoxRight.orientation = orientation
        self.noLongerHitBoxSouth.orientation = orientation
        self.noLongerHitBoxLeft.alpha = 1
        self.noLongerHitBoxRight.alpha = 1
        self.noLongerHitBoxSouth.alpha = 1
        transition.to(self.bubbleHitBox, {y=southDestiny, time=2400})
        transition.to(self.noLongerHitBoxLeft, {y=southDestiny, time=2400})
        transition.to(self.noLongerHitBoxRight, {y=southDestiny, time=2400})
        local moveSouthBox = function() return transition.to(self.noLongerHitBoxSouth, {y=southDestiny, time=2400}) end
        timer.performWithDelay(4600, moveSouthBox)

        self.bubbleEmitter = display.newEmitter({
            -- Emitter / General
            textureFileName="assets/images/commons/bubble.png",
            maxParticles = 25,
            angle = -90,
            duration = -1,
            emitterType = 0,

            -- Emitter / Line
            sourcePositionVariancex = 25,
            speed = 35,
            speedVariance = 25,
            gravityy = 250 * orientation,

            -- Particle / General
            particleLifespan = 3.2,
            startParticleSize = 14,
            finishParticleSize = 14,

            -- Particle / Color&Alpha
            startColorBlue = 1,
            startColorGreen = 0.6,
            startColorRed = 0.2,
            finishColorBlue = 1,
            finishColorGreen = 0.6,
            finishColorRed = 0,
            startColorAlpha = 1,
            finishColorAlpha = 1,
            startColorVarianceAlpha = 0,
            finishColorVarianceAlpha = 0,

            -- Blend
            blendFuncSource = 1,
            blendFuncDestination = 775
        })
        currentsGroup:insert(self.bubbleEmitter)
        currentsGroup.absolutePosition = currentsGroup
        self.bubbleEmitter.x = xPos
        self.bubbleEmitter.y = yBubbleEmitterPos
    end
end

function WaterCurrent:destroyHitBoxAndEmitter()
    if self.bubbleHitBox ~= nil and self.bubbleEmitter ~= nil then
        self.bubbleHitBox = nil
        self.noLongerHitBoxLeft = nil
        self.noLongerHitBoxRight = nil
        self.bubbleEmitter = nil
    end
end

function WaterCurrent:destroyHitBox()
    if self.bubbleHitBox ~= nil then
        display.remove(self.bubbleHitBox)
        display.remove(self.noLongerHitBoxLeft)
        display.remove(self.noLongerHitBoxRight)
        self.bubbleHitBox = nil
        self.noLongerHitBoxLeft = nil
        self.noLongerHitBoxRight = nil
    end
end

function WaterCurrent:destroyEmitter()
    if self.bubbleEmitter ~= nil then
        self.bubbleEmitter = nil
    end
end

function WaterCurrent:stopWaterCurrent()
    self.bubbleEmitter:stop()
    self.bubbleHitBox.y = 0
end

function WaterCurrent:imediateDestroy()
    if self.isEnabled == true and self.bubbleEmitter ~= nil and self.bubbleHitBox ~= nil then
        self.bubbleEmitter:stop()
        display.remove(self.bubbleHitBox)
        display.remove(self.noLongerHitBoxLeft)
        display.remove(self.noLongerHitBoxRight)
        self:destroyHitBoxAndEmitter()
    end
end

function WaterCurrent:destroyWaterCurrent()
    if self.isEnabled == true and self.bubbleEmitter ~= nil and self.bubbleHitBox ~= nil then
        self.isEnabled = false
        self.bubbleEmitter:stop()
        local destroyingHitBox = function() return self:destroyHitBox() end
        timer.performWithDelay(1200, destroyingHitBox)
        local destroyingEmitter = function() return self:destroyEmitter() end
        timer.performWithDelay(50, destroyingEmitter)
    end
end
return WaterCurrent