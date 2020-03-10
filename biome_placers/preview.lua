local NoiseUtilities = require("lib/noise_utilities")
local noise = require("noise")
local tne = noise.to_noise_expression

local PreviewBiomePlacer = {}

function PreviewBiomePlacer.GetBiomeExpression(index, biome)
	local biomeExpression = tne(1)

	local size = 128
	local radius = size / 2
	local margin = 32
	local xStart = index * (size + margin)
	local xMidpoint = xStart + radius
	local y = 0

	local biomeExpression =
		NoiseUtilities.Saturate(tne(1 - noise.absolute_value(noise.var("x") - xMidpoint) / radius)) *
		NoiseUtilities.Saturate(tne(1 - noise.absolute_value(noise.var("y")) / radius))

	-- Convert to a binary value for returning
	return NoiseUtilities.ToBinary(biomeExpression)
end

function PreviewBiomePlacer.Init()
	for _, tile in pairs(data.raw.tile) do
		data.raw.tile[_].autoplace = nil
	end

	for _, decorative in pairs(data.raw["optimized-decorative"]) do
		data.raw["optimized-decorative"][_].autoplace = nil
	end

	for _, entity in pairs(data.raw["simple-entity"]) do
		data.raw["simple-entity"][_].autoplace = nil
	end

	for _, entity in pairs(data.raw["tree"]) do
		local ap = data.raw["tree"][_].autoplace
		if ap then
			ap.probability_expression = tne(0)
			ap.placement_density = 0
			ap.tile_restriction = {}
			ap.peaks = nil
		end
	end

	data.raw.tile["lab-dark-2"].autoplace = {
		probability_expression = tne(0.001)
	}

	for _,resource in pairs(data.raw.resource) do
		resource.autoplace = {}
	end
end

return PreviewBiomePlacer