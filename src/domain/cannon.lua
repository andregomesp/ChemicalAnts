Cannon = {availableShoots = {}, coolDown = nil, firingButtons = {}, associatedVehicle = nil, shootGroup = nil, ballParametersList = nil, onCoolDown = {}, coolDownSquareGroup = nil, effectsGroup = nil}
function Cannon:new(o, associatedVehicle, shootGroup, coolDownSquareGroup, effectsGroup)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.associatedVehicle = associatedVehicle
    self.shootGroup = shootGroup
    self.coolDownSquareGroup = coolDownSquareGroup
    self.effectsGroup = effectsGroup
    self.ballParametersList = require("src.scenes.ballParameters")
    return o    
end

function Cannon:closeCoolDown(event, bulletId)
    self.onCoolDown[bulletId] = nil
    return true
end

function Cannon:drawCoolDownSquare(buttonId)
    local coolDownSquare = display.newRoundedRect(20 + (100 * buttonId), 550, 80, 80, 6)
    coolDownSquare.anchorX, coolDownSquare.anchorY = 0, 1
    coolDownSquare:setFillColor(0.1,0.1,0.1,0.3)
    transition.to(coolDownSquare, {time=2000, height = 0})
end

function Cannon:fire(event)
    if self.onCoolDown[event.target.id.element] == nil then
        self:initiateCoolDown(event.target.id.element, event.target.id.buttonId)
        local ballFactory = require("src.domain.ball")
        local ballColor = self.ballParametersList.getImage(event.target.id.element)
        local ballImage = display.newImageRect(self.shootGroup, "assets/images/commons/balls/" .. ballColor, 25, 25)
        local firedBall = ballFactory:new(nil, event.target.id.element, ballImage)
        physics.addBody(firedBall.image, "dynamic", { isSensor=true })
        firedBall.image.isBullet = true
        firedBall.image.myName = "shootBall"
        firedBall.image.element = firedBall.element
        firedBall.image.x = self.associatedVehicle.image.x
        firedBall.image.y = self.associatedVehicle.image.y
        firedBall.image:toFront()
        firedBall.image:addEventListener("collision", function (event) return self:shootColision(event) end)
        firedBall.image:setLinearVelocity(0, -360)
    end
    return true
end

function Cannon:initiateCoolDown(bulletId, buttonId)
    self.onCoolDown[bulletId] = true
    self:drawCoolDownSquare(buttonId)
    timer.performWithDelay(2000, function(event) return self:closeCoolDown(event, bulletId) end)
end

function Cannon:loadFiringButtons(elementsAvailable, ballGroup, fireButtonGroup)
    local widget = require("widget")
    local counter = 0
    -- todo: Elements available needs fixing, It is currently passing the whole list and not the stage parameters
    for key, value in pairs(elementsAvailable) do
        local ballColor = self.ballParametersList.getImage(value)
        local elementIcon = display.newImageRect(ballGroup, "assets/images/commons/balls/" .. ballColor, 30, 30)
        elementIcon.x = 60 + (100 * counter)
        elementIcon.y = 510
       
        local button = widget.newButton(
            {
                left = 20 + (100 * counter),
                top = 470,
                height = 80,
                width = 80,
                id = {buttonId= counter, element= value},
                shape = "roundedRect",
                cornerRadius = 6,
                fillColor = { default={0.396,0.447,0.529,1}, over={1,0.1,0.7,1} },
                strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
                strokeWidth = 2,
                onRelease = function(event) return self:fire(event) end
            }
        )
        fireButtonGroup:insert(button)
        elementIcon:toFront()
        table.insert(self.firingButtons, button)
        counter = counter + 1
    end
end

function Cannon:shootColision(event)
    local reactions = require("src.reactions.reactions")
    reactions.initiateReaction(event, self.effectsGroup)
    return true
end

return Cannon