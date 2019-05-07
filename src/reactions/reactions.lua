local M = {}
local reactionsList = {
    ["water"] = {sodium = "explosion", ferrum = "nothing", chlorine = "dissolution"},
    ["oxygen"] = {sodium = "corrosion", ferrum = "nothing", chlorine = "corrosion"}
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
    return true
end

local function eraseCorroded(event)
    display.remove(event.other)
    event.other = nil
end

local function corrosionCollision(event)
    if event.other.myName == "barrier" and event.other.isCorroding == false then
        event.other.isHittable = false
        event.other.isCorroding = true
        local directionX, directionY
        local effect = "filter.linearWipe"
        -- todo: consider if leave the animation as it currently is or do a more accurate acid animation
        -- local distanceX, distanceY = 0, 0
        if event.other.x > event.target.x then
            directionX = -1
            -- distanceX = (event.other.x - event.target.x)/event.other.width
            if event.other.y > event.target.y then
                directionY = -1
                -- distanceY = (event.other.y - event.target.y)/event.target.height
            else
                directionY = 1
                -- distanceY = (event.target.y - event.other.y)/event.target.height
            end
        elseif event.other.x < event.target.x then
            directionX = 1
            -- distanceX = (event.target.x - event.other.x)/event.other.width
            if event.other.y > event.target.y then
                directionY = -1
                -- distanceY = (event.other.y - event.target.y)/event.target.height
            else
                directionY = 1
                -- distanceY = (event.target.y - event.other.y)/event.target.height
            end
        else
        -- x = 1, from right to left
        -- y = 1 from bottom to top
        -- x, y = 0, 0 does not do anything
            directionX, directionY = 0, 1
        end
        event.other.fill.effect = effect
        event.other.fill.effect.smoothness = 0.3
        event.other.fill.effect.direction = { directionX, directionY }
        event.other.fill.effect.progress = 1
        local eraseCorrodedFunction = function() return eraseCorroded(event) end
        transition.to(event.other.fill.effect, {time = 600, progress = 0,
         onComplete = eraseCorrodedFunction})
    end
    return true
end

local function corrosion(event, effectsGroup, carVelocity)
    if event.other.myName == "barrier" then
        display.remove(event.target)
        event.target = nil
        local acidArea = display.newCircle(effectsGroup, event.other.x, event.other.y, 5)
        local acidAreaHitBox = display.newCircle(effectsGroup, event.other.x, event.other.y, 55)
        physics.addBody(acidArea, "dynamic", {isSensor = true})
        physics.addBody(acidAreaHitBox, "dynamic", {isSensor = true})
        acidAreaHitBox:addEventListener("collision", function(event) return corrosionCollision(event) end)
        acidArea.alpha = 0
        acidAreaHitBox.alpha = 0
        acidArea:setLinearVelocity(0, carVelocity)
        acidAreaHitBox:setLinearVelocity(0, carVelocity)
        transition.to(acidArea.path, {time = 600, radius = 55})
    end
    return true
end

local function dissolution(event, effectsGroup, carVelocity)
    if event.other.myName == "barrier" then
        display.remove(event.target)
        event.target = nil
        for k, v in pairs(event.other.barrier.pieces) do
            if v.fill ~= nil then
                v.isHittable = false
                v.fill.effect = "filter.bloom"
                v.fill.effect.levels.white = 1.0
                v.fill.effect.levels.black = 0.0
                v.fill.effect.levels.gamma = 1
                v.fill.effect.add.alpha = 0.8
            end
        end
    end
    for k, v in pairs(event.other.barrier.pieces) do
        if v.fill ~= nil then
            transition.to(v, {time = 1000, transition=easing.inOutCubic, x = event.other.x, y = event.other.y})
        end
    end
    return true
end


local function explosionCollision(event)
    if event.other.myName == "barrier" then
        event.other.isHittable = false
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

local function doNothing(event)
    display.remove(event.target)
    event.target = nil
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
        else
            local doNothing = function() return doNothing(event) end
            timer.performWithDelay(20, doNothing)
        end
    end
    return true
end



return M