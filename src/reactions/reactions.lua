local M = {}
local reactionsList = {
    ["hydrogen"] = {sodium = "explosion"},
    ["oxygen"] = {}
}

local function analyseReaction(element1, element2)
    reaction = reactionsList[element1][element2]
    return reaction
end

local function spriteHandler(event, sprite)
    if event.phase == "next" or event.phase == "began" then
        sprite.width = 100
        sprite.height = 100
    elseif event.phase == "ended" then
        display.remove(sprite)
        sprite = nil
    end    
end

local function corrosion()
end

local function explosion(event, effectsGroup)
    local sheetOptions = {
        numFrames = 10,
        width = 32,
        height = 32
    }

    local explosion_sheet = graphics.newImageSheet("assets/images/commons/reactions/explosions/explosion_sheet.png", sheetOptions)
    local sequence_explosion = {
        name = "explosionAnimation",
        start = 1,
        count = 10,
        time = 500,
        loopDirection = "forward",
        loopCount = 1
    }
    local explosionAnimation = display.newSprite(effectsGroup, explosion_sheet, sequence_explosion)
    explosionAnimation.x = event.other.x
    explosionAnimation.y = event.other.y
    explosionAnimation:play()
    physics.addBody(explosionAnimation, "dynamic")
    explosionAnimation:setLinearVelocity(0, 45)
    display.remove(event.other)
    local spriteListener = function(event) return spriteHandler(event, explosionAnimation) end 
    explosionAnimation:addEventListener("sprite", spriteListener) 
end



function M.initiateReaction(event, effectsGroup)
    reaction = analyseReaction(event.target.element, event.other.element)
    if reaction ~= nil then 
        if reaction == "explosion" then
            display.remove(event.target)
            local explosion = function() return explosion(event, effectsGroup) end
            timer.performWithDelay(40, explosion)
        end
    end
    return true
end



return M