Cannon = {availableShoots = {}, coolDown = nil, firingButtons = {}, associatedVehicle}
function Cannon:new(o, associatedVehicle, shootGroup)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.associatedVehicle = associatedVehicle
    self.shootGroup = shootGroup
    return o    
end

local function handlePress(event)
    print("pew")
    return true
end

local function handleRelease(event)
    self:fire()
    return true
end

function Cannon:fire()
    local ballFactory = require("src.domain.ball")
    local ballImage = display.newImageRect(self.shootGroup, "assets/images/commons/balls/ball_red.png", 25, 25)
    local firedBall = ballFactory:new(nil, "fuck", ballImage)
    physics.addBody(firedBall.image, "dynamic", { isSensor=true })
    firedBall.image.isBullet = true
    firedBall.image.myName = "shootBall"
    firedBall.image.x = self.associatedVehicle.image.x
    firedBall.image.y = self.associatedVehicle.image.y
    firedBall.image:toFront()
    firedBall.image:setLinearVelocity(0, -360)
    return true
end

function Cannon:loadFiringButtons(elementsAvailable, ballGroup)
    local widget = require("widget")
    local counter = 0
    print(#elementsAvailable)
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
                onPress = handlePress,
                onRelease = handleRelease
            }
        )
        elementIcon:toFront()
        table.insert(self.firingButtons, button)
        counter = counter + 1
    end
end

function Cannon:coolDown()


end

return Cannon