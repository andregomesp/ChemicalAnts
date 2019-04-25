local composer = require ("composer")
local scene = composer.newScene()
local physics = require("physics")
local previousScene = composer.getSceneName("previous")
print(previousScene)
composer.removeScene(previousScene)
return scene