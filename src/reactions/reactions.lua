local M = {}
local reactionsList = {
    ["water"] = {sodium = "explosion"},
    ["oxygen"] = {sodium = "dissolution"}
}

local function analyseReaction(element1, element2)
    local reaction = reactionsList[element1][element2]
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

local function corrosion(event, effectsGroup, carVelocity)
    if event.other.myName == "barrier" then
    end
end

local function dissolution(event, effectsGroup, carVelocity)
    if event.other.myName == "barrier" then
        if event.target.myName == "shootBall" then
            display.remove(event.target)
            event.target = nil
        end
        event.other.pieceGroup
        -- for k, v in pairs(event.other.barrier.pieces) do
        --     if v ~= nil then
        --         v.fill.effect = "filter.bloom"
        --         v.fill.effect.levels.white = 1.0
        --         v.fill.effect.levels.black = 0.0
        --         v.fill.effect.levels.gamma = 1
        --         v.fill.effect.add.alpha = 0.8
        --     end
        -- end
    end
    -- for k, v in pairs(event.other.barrier.pieces) do
    --     if v ~= nil then
    --         transition.to(v, {time = 1000, transition=easing.inOutCubic, x = event.other.x})
    --     end
    -- end
end


local function explosionCollision(event)
    if event.other.myName == "barrier" then
        display.remove(event.other)
        event.other = nil
    end
    return true
end

local function explosion(event, effectsGroup, carVelocity)
    local sheetOptions = {
        numFrames = 10,
        width = 32,
        height = 32
    }

    local explosion_sheet = graphics.newImageSheet("assets/images/commons/reactions/explosions/explosion_sheet.png", 
    sheetOptions)
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
    explosionAnimation.myName = "explosion"
    explosionAnimation:play()
    physics.addBody(explosionAnimation, "dynamic", {isSensor = true})
    explosionAnimation:setLinearVelocity(0, carVelocity - 12)
    display.remove(event.other)
    explosionAnimation:addEventListener("collision", function(event) return explosionCollision(event) end)
    local spriteListener = function(event) return spriteHandler(event, explosionAnimation) end
    explosionAnimation:addEventListener("sprite", spriteListener)
    return true
end

function M.initiateReaction(event, effectsGroup, carVelocity)
    local reaction = analyseReaction(event.target.element, event.other.element)
    if reaction ~= nil then
        if reaction == "explosion" then
            display.remove(event.target)
            local explosion = function() return explosion(event, effectsGroup, carVelocity) end
            timer.performWithDelay(20, explosion)
        elseif reaction == "corrosion" then
            local corrosion = function() return corrosion(event, effectsGroup, carVelocity) end
            timer.performWithDelay(20, corrosion)
        elseif reaction == "dissolution" then
            local dissolution = function() return dissolution(event, effectsGroup, carVelocity) end
            timer.performWithDelay(20, dissolution)
        end
    end
    return true
end



return M