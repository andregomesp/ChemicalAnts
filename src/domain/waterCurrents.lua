local WaterCurrent = {}

function WaterCurrent:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.bubbleEmitter = nil
    self.bubbleHitBox = nil
    self.isEnabled = false
    return o
end
-- Orientation is either 1 (downward) or -1 (upward)
function WaterCurrent:createCurrent(currentsGroup, orientation, xPos)
    if currentsGroup ~= nil then
        self.isEnabled = true
        local yPos
        local yBubbleEmitterPos
        local anchorY
        local transitionHeight
        if orientation == 1 then
            anchorY = 0
            yPos = 0
            yBubbleEmitterPos = - 40
            transitionHeight = display.viewableContentHeight
        else
            anchorY = 1
            yBubbleEmitterPos = display.viewableContentHeight + 40
            yPos = display.viewableContentHeight
            transitionHeight = display.viewableContentHeight
        end
        self.bubbleHitBox = display.newRect(currentsGroup, xPos, yPos, 50, 0)
        physics.addBody(self.bubbleHitBox, "dynamic", {isSensor=true})
        self.bubbleHitBox.myName = "bubbleHitBox"
        self.bubbleHitBox.orientation = orientation
        self.bubbleHitBox.anchorY = anchorY
        self.bubbleHitBox.alpha = 0.05
        if orientation == 1 then
            transition.to(self.bubbleHitBox, {height=transitionHeight, time=2400})
        else
            transition.to(self.bubbleHitBox, {height=transitionHeight, time=2400})
        end

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
        self.bubbleEmitter = nil
    end
end

function WaterCurrent:destroyHitBox()
    if self.bubbleHitBox ~= nil then
        print("destruindo hit box")
        display.remove(self.bubbleHitBox)
        self.bubbleHitBox = nil
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