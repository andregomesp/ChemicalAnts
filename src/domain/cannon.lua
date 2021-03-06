local Cannon = {availableShoots = {}, coolDown = nil, firingButtons = {}, associatedVehicle = nil, shootGroup = nil, ballParametersList = nil, onCoolDown = {}, coolDownSquareGroup = nil, effectsGroup = nil}
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

function Cannon:drawCoolDownSquare(buttonId, coolDownTime, cooldownGroup)
    local coolDownSquare = display.newRoundedRect(cooldownGroup, 20 + (100 * buttonId), display.viewableContentHeight * 0.975, 80, 80, 6)
    coolDownSquare.anchorX, coolDownSquare.anchorY = 0, 1
    coolDownSquare:setFillColor(0.1,0.1,0.1,0.7)
    transition.to(coolDownSquare, {time=coolDownTime, height = 0})
end

function Cannon:fire(event, commons, sounds, cooldownGroup)
    if self.onCoolDown[event.target.id.element] == nil and commons.stopped == false and commons.paused == false then
        self:initiateCoolDown(event.target.id.element, event.target.id.buttonId, event.target.id.coolDown, cooldownGroup)
        local ballFactory = require("src.domain.ball")
        local ballColor = self.ballParametersList.getImage(event.target.id.element)
        local ballImage = display.newImageRect(self.shootGroup, "assets/images/commons/balls/" .. ballColor, 25, 25)
        local firedBall = ballFactory:new(nil, event.target.id.element, ballImage)
        physics.addBody(firedBall.image, "dynamic", { isSensor=true })
        firedBall.image.canColide = true
        firedBall.image.myName = "shootBall"
        firedBall.image.element = firedBall.element
        firedBall.image.x = self.associatedVehicle.image.x
        firedBall.image.y = self.associatedVehicle.image.y
        firedBall.image:toFront()
        firedBall.image:addEventListener("collision", function (event) return self:shootColision(event, sounds) end)
        firedBall.image:setLinearVelocity(0, -500)
        sounds:playASound("misc_element_shot.mp3")
    end
    return true
end

function Cannon:initiateCoolDown(bulletId, buttonId, coolDownTime, cooldownGroup)
    self.onCoolDown[bulletId] = true
    self:drawCoolDownSquare(buttonId, coolDownTime, cooldownGroup)
    timer.performWithDelay(coolDownTime, function(event) return self:closeCoolDown(event, bulletId) end)
end

function Cannon:loadFiringButtons(elementsAvailable, ballGroup, fireButtonGroup, commons, sounds, cooldownGroup)
    local widget = require("widget")
    local counter = 0
    -- todo: Elements available needs fixing, It is currently passing the whole list and not the stage parameters
    for key, value in pairs(elementsAvailable) do
        local ballColor = self.ballParametersList.getImage(value)
        local elementIcon = display.newImageRect(ballGroup, "assets/images/commons/balls/" .. ballColor, 30, 30)
        elementIcon.x = 60 + (100 * counter)
        local fireTheBall = function(event) return self:fire(event, commons, sounds, cooldownGroup) end
        local button = widget.newButton(
            {
                left = 20 + (100 * counter),
                top = display.viewableContentHeight * 0.825,
                height = 80,
                width = 80,
                id = {buttonId= counter, element= value, coolDown = commons['params']['coolDownTime'][counter + 1]},
                shape = "roundedRect",
                cornerRadius = 6,
                fillColor = { default={0.396,0.447,0.529,1}, over={1,0.1,0.7,1} },
                strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
                strokeWidth = 2,
                onRelease = fireTheBall
            }
        ) 
        elementIcon.y = button.y
        local text = nil
        if value == "water" then
            text = "Water"
        elseif value == "hydrogen" then
            text = "Hydrogen"
        elseif value == "chlorideAcid" then
            text = "Chloride Acid"
        end
        local elementText = display.newText({parent=ballGroup, text=text, x=60 + (100 * counter), y=button.y * 0.95, width=button.width * 0.9, height=0, align="center"})
        fireButtonGroup:insert(button)
        elementIcon:toFront()
        elementText:toFront()
        table.insert(fireButtonGroup, button)
        table.insert(self.firingButtons, button)
        counter = counter + 1
    end
    while counter < 3 do
        self:drawUselessButton(fireButtonGroup, ballGroup, counter, widget)
        counter = counter + 1
    end
end

function Cannon:drawUselessButton(fireButtonGroup, ballGroup, counter, widget)
    local XIcon = display.newImageRect(ballGroup, "assets/images/commons/ui/forbidden.png", 80, 80)
    XIcon.x = 60 + (100 * counter)

    local button = widget.newButton(
        {
            left = 20 + (100 * counter),
            top = display.viewableContentHeight * 0.825,
            height = 80,
            width = 80,
            shape = "roundedRect",
            cornerRadius = 6,
            fillColor = { default={0.396,0.447,0.529,1}, over={1,0.1,0.7,1} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 2
        }
    )
    XIcon.y = button.y
    fireButtonGroup:insert(button)
    XIcon:toFront()
    table.insert(fireButtonGroup, button)
    table.insert(self.firingButtons, button)
end

function Cannon:shootColision(event, sounds)
    if event.target.canColide == true then
        if (event.other.myName) == "barrier" and event.other.isHittable == true then
            event.target.canColide = false
            event.other.isHittable = false
            local reactions = require("src.reactions.reactions")
            reactions.initiateReaction(event, self.effectsGroup, self.associatedVehicle.carVelocity, sounds)
        end
    end
    return true
end

return Cannon