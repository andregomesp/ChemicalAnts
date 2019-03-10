local M = {}

function M.startPhysics()
    local physics = require("physics")
    physics.start()
    physics.setGravity( 0, 0 )
end

return M;