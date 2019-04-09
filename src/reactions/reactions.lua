local M = {}
local reactionsList = {
    ["water"] = {sodium = "explosion"},
    ["oxygen"] = {sodium = "corrosion"}
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

local function corrosionCollision(event)
    if event.other.myName == "barrier" and event.other.isCorroding == false then
        event.other.isCorroding = true
        print("circle hit barrier")
        local directionX, directionY
        local effect = "filter.linearWipe"
        if event.other.x > event.target.x then
            directionX = -1
            if event.other.y > event.target.y then
                directionY = -1
            else
                directionY = 1
            end
        elseif event.other.x < event.target.x then
            directionX = 1
            if event.other.y > event.target.y then
                directionY = -1
            else
                directionY = 1
            end
        else
        -- x = 1, from right to left
        -- y = 1 from bottom to top
        -- x, y = 0, 0 does not do anything
            directionX, directionY = 0, 1
        end
        event.other.fill.effect = effect
        event.other.fill.effect.smoothness = 0.5
        event.other.fill.effect.direction = { directionX, directionY }
        event.other.fill.effect.progress = 1
        transition.to(event.other.fill.effect, {time = 1500, progress = 0})    
    end
    return true
end

local function lol()
    print("lol")
end

local function corrosion(event, effectsGroup, carVelocity)
    if event.other.myName == "barrier" then
        local acidArea = display.newCircle(effectsGroup, event.other.x, event.other.y, 5)
        physics.addBody(acidArea, "dynamic", {isSensor = true})
        acidArea:addEventListener("collision", function(event) return corrosionCollision(event) end)
        acidArea.alpha = 0.2
        acidArea.isTransitioning = false
        acidArea:setLinearVelocity(0, carVelocity)
        transition.to(acidArea.path, {time = 600, radius = 55, onStart= function() return lol() end})
    end
end

local function dissolution(event, effectsGroup, carVelocity)
    if event.other.myName == "barrier" then
        display.remove(event.target)
        event.target = nil
        for k, v in pairs(event.other.barrier.pieces) do
            if v.fill ~= nil then
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