-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 28 then
	native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
	native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
end

local composer = require("composer")
composer.gotoScene( "src.scenes.scene2")