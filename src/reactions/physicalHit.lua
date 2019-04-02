local  M = {}


local function spriteHandler(event, sprite)
    if event.phase == "next" or event.phase == "began" then
        sprite.width = 15
        sprite.height = 15
    elseif event.phase == "ended" then
        display.remove(sprite)
        sprite = nil
    end
end

function M.drawHit(effectsGroup, vehicle)
    local sheetOptions = {
        numFrames = 10,
        width = 64,
        height = 64
    }

    local hit_sheet = graphics.newImageSheet("assets/images/commons/reactions/hit/physicalHit.png",
    sheetOptions)
    local sequence_hit = {
        name = "hitAnimation",
        start = 1,
        count = 8
    }
    local hitAnimation = display.newSprite(effectsGroup, hit_sheet, sequence_hit)
    hitAnimation.x = vehicle.image.x
    hitAnimation.y = vehicle.image.y
    hitAnimation.myName = "hitAnimation"
    hitAnimation.play()
    physics.addBody(explosionAnimation, "dynamic", {isSensor = true})
    explosionAnimation:setLinearVelocity(0, carVelocity - 12)
    local spriteListener = function(event) return spriteHandler(event, explosionAnimation) end
    explosionAnimation:addEventListener("sprite", spriteListener)
end

return M