local M = {}

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

return M