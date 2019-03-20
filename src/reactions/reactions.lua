local M = {}

local reactionsList = {
    ["hydrogen"] = {sodium = "explosion"},
    ["oxygen"] = {}
}

local function analyseReaction(element1, element2)
    reaction = reactionsList[element1][element2]
    return reaction
end

local function corrosion()
end

local function explosion()
end



function M.initiateReaction(event)
    reaction = analyseReaction(event.target.element, event.other.element)
    if reaction ~= nil and reaction == "explosion" then
        display.remove(event.target)
        display.remove(event.other)
    end
    print("tiro bateu")
    return true
end



return M