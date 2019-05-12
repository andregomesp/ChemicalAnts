local M = {}
function M:drawTimeIsUpBox(exitButtonGroup, stageNumber)
    local questionBox = display.newRoundedRect(exitButtonGroup, 40,
    -270, display.viewableContentWidth - 80, 240, 12)
    questionBox:setFillColor(0.7, 0.4, 0.2)
    questionBox.anchorX = 0
    questionBox.anchorY = 0
    local timeisUpText = "Time is up!"
    local timeIsUpTag = display.newText({parent=exitButtonGroup,text=timeisUpText, x=questionBox.x + 40,
        y=questionBox.y + 35, fontSize=35})
    timeIsUpTag.anchorX = 0
    local widget = require("widget")
    local sceneChanger = require("src.scenes.sceneChanger")
    local restartGame = function() return sceneChanger:gotoSceneTransition(stageNumber, "sameStage") end
    local exitGame = function() return sceneChanger:gotoSceneTransition(stageNumber, "gameover") end
    local buttonRetry = widget.newButton(
        {
            left = questionBox.x + 30,
            top = questionBox.y + 120,
            height = 60,
            width = 60,
            cornerRadius = 22,
            shape = "roundedRect",
            fillColor = { default={0.396,0.447,0.529,1}, over={1,0.1,0.7,1} },
            strokeColor = { default={0, 0, 0.2,1}, over={0.8,0.8,1,1} },
            strokeWidth = 1,
            onRelease= restartGame
        }
    )
    exitButtonGroup:insert(buttonRetry)
    local exit = widget.newButton(
        {
            left = questionBox.x + 140,
            top = questionBox.y + 120,
            height = 60,
            width = 60,
            cornerRadius = 22,
            shape = "roundedRect",
            fillColor = { default={0.396,0.447,0.529,1}, over={1,0.1,0.7,1} },
            strokeColor = { default={0,0,0.2,1}, over={0.8,0.8,1,1} },
            strokeWidth = 1,
            onRelease = exitGame
        }
    )
    exitButtonGroup:insert(exit)
    display.newImage(exitButtonGroup, "assets/images/commons/ui/rep.png", buttonRetry.x, buttonRetry.y)
    display.newImage(exitButtonGroup, "assets/images/commons/ui/x.png", exit.x,
    exit.y)

    transition.to(exitButtonGroup, {time=2000, y=(display.viewableContentHeight / 2) + 30 })
end

return M