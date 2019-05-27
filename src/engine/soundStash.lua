local M = {}
local fileSoundsNames = {}
local fileSounds = {}

local function getFileSoundsNames()
    local soundFileFactory = require("src.engine.audioFileList")
    local soundFileNames = soundFileFactory:getList()
    for k, v in ipairs(soundFileNames) do
        table.insert(fileSoundsNames, v)
    end
end

local function stopCompletedAudio(event)
    audio.stop(event.channel)
end

function M:loadAllCommonSounds()
    if #fileSoundsNames == 0 then
        getFileSoundsNames()
    end
    if #fileSounds == 0 then
        for k, v in ipairs(fileSoundsNames) do
            fileSounds[v] = audio.loadSound("assets/audio/sf/commonssf/" .. v)
        end
    end
end

function M:playASound(soundName, repetition)
    local availableChannel = audio.findFreeChannel( 2 )
    audio.setVolume(1.0, {channel=availableChannel})
    if repetition == nil then
        repetition = 0
    end
    audio.play(fileSounds[soundName], {onComplete=stopCompletedAudio, loops=repetition, channel=availableChannel})
end

return M