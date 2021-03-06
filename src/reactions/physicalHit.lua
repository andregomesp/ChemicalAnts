local  M = {}


local function spriteHandler(event, sprite)
    if event.phase == "next" or event.phase == "began" then
        sprite.width = 65
        sprite.height = 25
    elseif event.phase == "ended" then
        display.remove(sprite)
        sprite = nil
    end
    return true
end

local function drawHit(effectsGroup, vehicleImage, sounds)
    local sheetOptions = {
        numFrames = 10,
        width = 64,
        height = 64
    }

    local hit_sheet = graphics.newImageSheet("assets/images/commons/reactions/hit/physical_hit.png",
    sheetOptions)
    local sequence_hit = {
        name = "hitAnimation",
        start = 1,
        count = 8,
        time= 1000,
        loopDirection = "foward",
        loopCount = 1
    }
    local hitAnimation = display.newSprite(effectsGroup, hit_sheet, sequence_hit)
    hitAnimation.x = vehicleImage.x
    hitAnimation.y = vehicleImage.y - vehicleImage.height / 2
    hitAnimation.myName = "hitAnimation"
    hitAnimation:play()
    sounds:playASound("wall_hit.mp3")
    physics.addBody(hitAnimation, "dynamic", {isSensor = true})
    local spriteListener = function(event) return spriteHandler(event, hitAnimation) end
    hitAnimation:addEventListener("sprite", spriteListener)
end

function M:initiateHitSequence(effectsGroup, vehicleImage, sounds)
    local hit = function() return drawHit(effectsGroup, vehicleImage, sounds) end
    timer.performWithDelay(40, hit)
end
return M