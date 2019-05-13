local M = {}
local fileSoundsNames = {}
local fileSounds = {}

local function getFileSoundsNames()
    local path = system.pathForFile("assets/audio/sf/commonsSf")
    for file in lfs.dir(path) do
        if #file > 3 then
            table.insert(fileSoundsNames, file)
        end
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

            fileSounds[v] = audio.loadSound("assets/audio/sf/commonsSf/" .. v)
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