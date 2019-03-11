Cannon = {availableShoots = {}, coolDown = nil, firingButtons = {}, associatedVehicle = nil, shootGroup = nil, ballParametersList = nil}
function Cannon:new(o, associatedVehicle, shootGroup)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.associatedVehicle = associatedVehicle
    self.shootGroup = shootGroup
    self.ballParametersList = require("src.scenes.ballParameters")
    return o    
end

function Cannon:fire(event)
    print(event.target.id)
    local ballFactory = require("src.domain.ball")
    local ballImage = display.newImageRect(self.shootGroup, "assets/images/commons/balls/" .. self.ballParametersList:getImage(event.target.id), 25, 25)
    local firedBall = ballFactory:new(nil, "anElement", ballImage)
    physics.addBody(firedBall.image, "dynamic", { isSensor=true })
    firedBall.image.isBullet = true
    firedBall.image.myName = "shootBall"
    firedBall.image.x = self.associatedVehicle.image.x
    firedBall.image.y = self.associatedVehicle.image.y
    firedBall.image:toFront()
    firedBall.image:setLinearVelocity(0, -360)
    return true
end

function Cannon:loadFiringButtons(elementsAvailable, ballGroup, fireButtonGroup)
    local widget = require("widget")
    local counter = 0
    local thisContext = self
    print(self)
    for key, value in pairs(elementsAvailable) do
        local elementIcon = display.newImageRect(ballGroup, "assets/images/commons/balls/ball_red.png", 30, 30)
        elementIcon.x = 60 + (100 * counter)
        elementIcon.y = 510
       
        local button = widget.newButton(
            {
                left = 20 + (100 * counter),
                top = 470,
                height = 80,
                width = 80,
                id = value,
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

function Cannon:coolDown()


end

return Cannon