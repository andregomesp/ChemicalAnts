-- stage 1 has both Na, Cl and NaCl as barriers

--
local M = {}

local patterns = {
    [0] = {types = "sodium", pattern = {patternType = "line", size = "quarter"}},
    [1] = {types = "sodium", pattern = {patternType = "line", size = "half"}},
    [2] = {types = "sodium", pattern = {patternType = "column", size = "quarter"}},
    [3] = {types = "chlorine", pattern = {patternType = "line", size = "quarter"}},
    [4] = {types = "chlorine", pattern = {patternType = "line", size = "half"}},
    [5] = {types = "sodium", pattern = {patternType = "stair-left", size = "half"}},
}

function M:getPattern(number)
    local patternType = patterns[number]
    local specification = require("src.barrierPatterns.patternSpecification")
end

return M