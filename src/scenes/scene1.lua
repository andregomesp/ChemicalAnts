local composer = require ("composer")
local scene = composer.newScene()
local physics = require("physics")


local pretty = require("libraries.penlight.pretty")

physics.start()
physics.setGravity(0, 0)

local availableBallTypes = {"oxygen", "water"}
local stageNumber = 1
local countDownTimer = 80

local commons = require("src.scenes.commonsInterface")
commons.initiateCommons(stageNumber, availableBallTypes, countDownTimer)

return scene