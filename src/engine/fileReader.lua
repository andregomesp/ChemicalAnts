local M = {}

local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

local function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file, "l") do
      lines[#lines + 1] = line
    end
    return lines
end

function M:read_text_file(path)
    local file = system.pathForFile(path)
    local lines = lines_from(file)
    return lines
end

return M