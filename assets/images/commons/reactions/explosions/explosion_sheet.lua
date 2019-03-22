--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:b6219faa54524cb9a3b4de0d70a5bed3:ade3c8ea1a3835c561dd25497483f560:774ea1576e6b9a4dff1b29f3dd6f731a$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- bubble_explo1
            x=0,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bubble_explo2
            x=32,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bubble_explo3
            x=64,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bubble_explo4
            x=96,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bubble_explo5
            x=128,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bubble_explo6
            x=160,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bubble_explo7
            x=192,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bubble_explo8
            x=224,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bubble_explo9
            x=256,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bubble_exploA
            x=288,
            y=0,
            width=32,
            height=32,

        },
    },

    sheetContentWidth = 320,
    sheetContentHeight = 32
}

SheetInfo.frameIndex =
{

    ["bubble_explo1"] = 1,
    ["bubble_explo2"] = 2,
    ["bubble_explo3"] = 3,
    ["bubble_explo4"] = 4,
    ["bubble_explo5"] = 5,
    ["bubble_explo6"] = 6,
    ["bubble_explo7"] = 7,
    ["bubble_explo8"] = 8,
    ["bubble_explo9"] = 9,
    ["bubble_exploA"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
