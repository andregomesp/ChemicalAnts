local Background = {objectBackGroup = nil, mainBackGroup = nil}

function Background:new(o, background, objectBackGroup, objectSecondaryBackGroup, mainBackGroup)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.objectBackGroup = objectBackGroup
    self.objectSecondaryBackGroup = objectSecondaryBackGroup
    self.mainBackGroup = mainBackGroup
    self.image = background
    return o
end

function Background:buildBackground(carVelocity, stageParams)
    self.stageNumber = stageParams.stageNumber
    self.objectBackGroup.x = 0
    self.objectBackGroup.y = -160
    self.objectBackGroup.myName = "objectBackGroup"
    self.objectSecondaryBackGroup.x = 310
    self.objectSecondaryBackGroup.y = -160
    self.objectSecondaryBackGroup.myName = "objectBackGroup"
    local i = 0
    while i < 16 do
        local leftWall = display.newImageRect(self.objectBackGroup,
        stageParams.leftWall, 120, 120)
        local rightWall = display.newImageRect(self.objectSecondaryBackGroup,
        stageParams.rightWall, 120, 120)
        if stageParams.stageNumber == 1 then
            leftWall.y = 50 * i
            rightWall.y = 50 * i
        elseif (stageParams.stageNumber == 2) then
            rightWall:toBack()
            leftWall.y = 100 * i
            rightWall.y = 100 * i
        elseif stageParams.stageNumber == 3 then
            leftWall:toBack()
            leftWall.height = 103
            leftWall.y = 100 * i
            rightWall.y = 100 * i
            leftWall.anchorX = 0.4
            rightWall.anchorX = 0.8
        elseif (stageParams.stageNumber == 5) then
            leftWall.width = 140
            leftWall.height = 140
            rightWall.width = 140
            rightWall.height = 140
            leftWall.y = 50 * i
            rightWall.y = 50 * i
        end
        
        i = i + 1
    end
    physics.addBody(self.objectBackGroup, "dynamic", {isSensor = true})
    physics.addBody(self.objectSecondaryBackGroup, "dynamic", {isSensor = true})
    self.objectBackGroup:setLinearVelocity(0, carVelocity)
    self.objectSecondaryBackGroup:setLinearVelocity(0, carVelocity)
    self.objectBackGroup:addEventListener("collision", function(event) return self:handleCollision(event) end)
    self.objectSecondaryBackGroup:addEventListener("collision", function(event) return self:handleCollision(event) end)
end

function Background:checkBackgroundNeedsRebuild()
    if self.objectSecondaryBackGroup.y > -10 then
        return true
    end
    return false
end

function Background:handleCollision(event)
end

function Background:moveBackgroundGroup(moveGroup)
    if moveGroup == true then
        if self.stageNumber ~= 3 then
        self.objectBackGroup.y = -210
        self.objectSecondaryBackGroup.y = -210
        else
            self.objectBackGroup.y = -210
            self.objectSecondaryBackGroup.y = -210
        end
    end
end

function Background:drawShader(shaderGroup)
    local subShaderGroup1 = display.newGroup()
    local subShaderGroup2 = display.newGroup()
    shaderGroup:insert(subShaderGroup1)
    subShaderGroup1:insert(subShaderGroup2)
    local shader = display.newRect(subShaderGroup2, 0, 0, display.viewableContentWidth, display.viewableContentHeight)
    local shader2 = display.newRect(subShaderGroup2, 0, 0, display.viewableContentWidth, display.viewableContentHeight)
    -- shader:setFillColor(0.0156, 0, 0.156, 0.7)
    shader:setFillColor(0, 0, 0, 0.8)
    -- shader2:setFillColor(0.0156, 0, 0.156, 0.7)
    shader2:setFillColor(0, 0, 0, 0.8)
    -- local compositePaint = {
    --     type="composite",
    --     paint1={ type="image", filename="assets/images/commons/scenario/trees.png" },
    --     paint2={ type="image", filename="assets/images/commons/masks/lightmask2.png" }
    -- }
    -- shader2.fill = compositePaint
    -- shader2.fill.effect = "composite.exclusion"
    shader.anchorX = 0
    shader.anchorY = 0
    shader2.anchorX = 0
    shader2.anchorY = 0
    -- shader2.fill.alpha = 0.2
    self:createLightMask(shaderGroup, subShaderGroup1, subShaderGroup2, shader, shader2)
end

function Background:createLightMask(shaderGroup, subShaderGroup1, subShaderGroup2, shader, shader2)
    local lightMask = graphics.newMask("assets/images/commons/masks/lightmask3.png")
    subShaderGroup1:setMask(lightMask)
    subShaderGroup1.maskX = 160
    subShaderGroup1.maskY = 360
    subShaderGroup1.maskScaleX = 0.4
    subShaderGroup1.maskScaleY = 0.4
    local lightMask2 = graphics.newMask("assets/images/commons/masks/lightmask3.png")
    shaderGroup:setMask(lightMask2)
    shaderGroup.maskX = 40
    shaderGroup.maskY = 60
end

return Background