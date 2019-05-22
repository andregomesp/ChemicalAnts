local M = {}
local background = nil
function M:drawTouchInfo(group, timers)
    local tapToAdvanceText = display.newText({parent=group, text="Tap the screen to advance",
        x = display.viewableContentWidth / 5 , y = display.viewableContentHeight - 40,
        fontSize = 16})
    tapToAdvanceText.anchorX = 0
    
    local fadeInText = function () return transition.to(tapToAdvanceText, {time = 700,
        easing=easing.outInBack, alpha=1}) end
    local fadeOutText = function () return transition.to(tapToAdvanceText, {time = 700,
        easing=easing.outInBack, alpha=0}) end
        local fadeOutTimer = timer.performWithDelay(700, fadeOutText, 0)
        local fadeInTimer = timer.performWithDelay(700, fadeInText, 0)
        table.insert(timers, fadeOutTimer)
        table.insert(timers, fadeInTimer)
    return tapToAdvanceText
end

local function handleBackground(event)
    local needToMoveGroup = background:checkBackgroundNeedsRebuild()
    if needToMoveGroup ~= false then
        background:moveBackgroundGroupIntro(needToMoveGroup)
    end
    return true
end

local function initiateRuntimeBkground()
    Runtime:addEventListener( "enterFrame", handleBackground)
end

function M:drawBackgroundScene(backgroundGroup, leftBackgroundGroup, rightBackgroundGroup)
    local backgroundImage = display.newRect(backgroundGroup, display.contentCenterX,
    display.contentCenterY, display.viewableContentWidth, display.viewableContentHeight)
    backgroundImage:setFillColor(0.435, 0.623, 0.196)
    local backgroundFactory = require("src.domain.background")
    background = backgroundFactory:new(nil, backgroundImage, leftBackgroundGroup,
        rightBackgroundGroup, backgroundGroup)
    background:buildBackground(130, {leftWall="assets/images/commons/scenario/trees.png",
        rightWall="assets/images/commons/scenario/trees.png", stageNumber=0})
    initiateRuntimeBkground()

end

return M