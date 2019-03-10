--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--
local aspectRatio = display.pixelHeight / display.pixelWidth
application =
{
	content =
	{
		width = aspectRatio > 1.5 and 320 or math.ceil( 480 / aspectRatio ),
      	height = aspectRatio < 1.5 and 480 or math.ceil( 320 * aspectRatio ),
      	scale = "letterBox",
      	fps = 30,
		
		imageSuffix =
		{
			    ["@2x"] = 1.8,
			    ["@4x"] = 3.6,
		},
	},
}
