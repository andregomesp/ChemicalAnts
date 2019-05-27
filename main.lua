
-- Hide android bar
-- if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 then
-- 	native.setProperty( "androidSystemUiVisibility", "lowProfile" )
-- else
-- 	native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
-- end
local composer = require("composer")

-- Load all sounds
local sounds = require("src.engine.soundStash")
sounds:loadAllCommonSounds()

-- Open physics
local physicsStarter = require("src.engine.physics")
physicsStarter:startPhysics()

-- Open game
-- composer.gotoScene( "src.scenes.scene1")
-- composer.gotoScene( "src.scenes.scene3")
-- composer.gotoScene("src.scenes.gameover")
-- composer.gotoScene( "src.scenes.scene2")
composer.gotoScene("src.scenes.mainMenu")
-- composer.gotoScene("src.scenes.stageBetween", {params={screenStatus="pos", stageNumber="0"}})