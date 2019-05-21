local M = {}

local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

local function lines_from(file)
    if not file_exists(file) then return {} end
    lines = {}
    for line in io.lines(file) do 
      lines[#lines + 1] = line
    end
    return lines
end

function M:getCredits()
    local file = system.pathForFile("thanks.txt")
    local lines = lines_from(file)
      -- print all line numbers and their contents
    return lines
end

return M