local composer = require ("composer")
local scene = composer.newScene()

function scene:create( event )

end

function scene:show(event)

end
function scene:hide(event)
    
end
function scene:destroy(event)

end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")
return scene