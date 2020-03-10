local util = require("util")

local base_decorative_sprite_priority = "extra-high"

data:extend{
	{
		name = "river-rock-medium",
		type = "optimized-decorative",
		order = "b[decorative]-l[river-rock]-c[medium]",
		collision_box = {{-1.1, -1.1}, {1.1, 1.1}},
		render_layer = "decorative",
		tile_layer= 59,
		pictures =
		{
			{
				filename = "__Ariamis__/graphics/decoratives/river-rock/hr-river-rock-medium-01.png",
				priority = base_decorative_sprite_priority,
				width = 89,
				height = 63,
				shift = {0.078125, 0.109375},
				hr_version = {
					filename = "__Ariamis__/graphics/decoratives/river-rock/hr-river-rock-medium-01.png",
					priority = base_decorative_sprite_priority,
					width = 89,
					height = 63,
					scale = 0.5,
					shift = {0.078125, 0.109375}
				}
			},
		}
	},
}

local riverDecalScale = 1.4
local riverDecalTint = {r=1, g=1, b=1, a=0.3}
data:extend({
	{
		name = "river-decal",
		type = "optimized-decorative",
		subgroup = "grass",
		order = "b[decorative]-b[river-decal]",
		collision_mask = {"not-colliding-with-itself"},
		collision_box = {{-4, -4}, {4, 4}},
		render_layer = "decals",
		tile_layer= 4,
		pictures = {
			{
				filename = "__Ariamis__/graphics/decoratives/river-decal/hr-river-decal-05.png",
				width = 512,
				height = 384,
				scale = riverDecalScale,
				shift = util.by_pixel(-0.5, 0.5),				
			},
			{
				filename = "__Ariamis__/graphics/decoratives/river-decal/hr-river-decal-06.png",
				width = 512,
				height = 384,
				scale = riverDecalScale * 0.8,
				shift = util.by_pixel(-0.5, 0.5),				
			},
			{
				filename = "__Ariamis__/graphics/decoratives/river-decal/hr-river-decal-07.png",
				width = 512,
				height = 384,
				scale = riverDecalScale * 0.65,
				shift = util.by_pixel(-0.5, 0.5),				
			},
			{
				filename = "__Ariamis__/graphics/decoratives/river-decal/hr-river-decal-08.png",
				width = 512,
				height = 384,
				scale = riverDecalScale * 0.5,
				shift = util.by_pixel(-0.5, 0.5),				
			},
			--[[{
				filename = "__Ariamis__/graphics/decoratives/river-decal/hr-river-decal-01.png",
				width = 612,
				height = 300,
				scale = riverDecalScale,
				shift = util.by_pixel(-0.5, 0.5),
				blend_mode = "additive-soft",
				tint = riverDecalTint,
			},
			{
				filename = "__Ariamis__/graphics/decoratives/river-decal/hr-river-decal-02.png",
				width = 612,
				height = 300,
				scale = riverDecalScale * 0.8,
				shift = util.by_pixel(-0.5, 0.5),
				blend_mode = "additive-soft",
				tint = riverDecalTint,
			},
			{
				filename = "__Ariamis__/graphics/decoratives/river-decal/hr-river-decal-03.png",
				width = 612,
				height = 300,
				scale = riverDecalScale * 0.65,
				shift = util.by_pixel(-0.5, 0.5),
				blend_mode = "additive-soft",
				tint = riverDecalTint,
			},
			{
				filename = "__Ariamis__/graphics/decoratives/river-decal/hr-river-decal-04.png",
				width = 612,
				height = 300,
				scale = riverDecalScale * 0.5,
				shift = util.by_pixel(-0.5, 0.5),
				blend_mode = "additive-soft",
				tint = riverDecalTint,
			},]]
		},
	}
})

data:extend({
	{
		name = "ice-cracks-decal",
		type = "optimized-decorative",
		subgroup = "grass",
		order = "b[decorative]-b[ice-cracks-decal]",
		collision_mask = {"not-colliding-with-itself"},
		collision_box = {{-4, -4}, {4, 4}},
		render_layer = "decals",
		tile_layer= 179,
		pictures = {
			{
				filename = "__Ariamis__/graphics/decoratives/ice-cracks-decal/ice-cracks-decal-01.png",
				width = 300,
				height = 180,
				scale = 1,
				shift = util.by_pixel(-0.5, 0.5),
			},
		},
	}
})
  

require("tiles")



data.raw["optimized-decorative"]["flower-bush-green-yellow"].tile_layer = data.raw["optimized-decorative"]["green-carpet-grass"].tile_layer + 1
data.raw["optimized-decorative"]["green-carpet-grass"].render_layer = "resource"
data.raw["optimized-decorative"]["carpet-grass-orange"].render_layer = "resource"
data.raw["optimized-decorative"]["carpet-grass-green"].render_layer = "resource"

--data.lua
data.raw["tile"]["water-shallow"].effect_color = {1, 0.3, 0.0}
data.raw["tile"]["water-shallow"].map_color = {1, 0.3, 0.0}

