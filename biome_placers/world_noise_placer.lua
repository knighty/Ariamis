local WorldNoise = require("world_noise")
local NoiseUtilities = require("lib/noise_utilities")
local noise = require("noise")
local tne = noise.to_noise_expression

-- Create some noise for blending biomes
local biomeBlendingNoise = NoiseUtilities.DeclareNoiseExpression("ta_biome_blending_noise", noise.clamp(
	NoiseUtilities.GetOctaveNoise(64, 0.5, 0, NoiseUtilities.GetOctavesForScale(64)),
	-0.99,
	1) * 0.5 + 0.5
)

local WorldNoiseBiomePlacer = {}

function WorldNoiseBiomePlacer.GetBiomeExpression(index, biome)
	local biomeExpression = tne(1)

	local hasBlending = false

	-- Go over each layer
	for worldNoiseLayerIndex,layerSettings in pairs(biome.layers) do

		-- Get layer properties
		local minThreshold = layerSettings[1] - 0.01
		local maxThreshold = layerSettings[2] + 0.001
		local thresholdDelta = maxThreshold - minThreshold
		local thresholdRadius = thresholdDelta / 2
		local thresholdMidpoint = minThreshold + thresholdRadius
		local layerRadiusMultiplier = layerSettings[3] or 1
		local radiusMultiplier = (biome.margin or 1) * layerRadiusMultiplier

		-- The ocean layer should always have a multiplier of 1 so it doesn't get dodgy edges
		if worldNoiseLayerIndex == "ocean" then
			--radiusMultiplier = 1
		end

		-- Any layers with a margin need to tell the code later to handle blendinhg
		if radiusMultiplier > 0 then
			hasBlending = true
		end

		-- Calculate the distance of the noise from the midpoint of the layer
		local layerNoiseExpression = NoiseUtilities.Saturate( tne(thresholdRadius) - noise.absolute_value( tne( thresholdMidpoint ) - WorldNoise.GetNoise(worldNoiseLayerIndex) ) / radiusMultiplier)
		layerNoiseExpression = layerNoiseExpression / thresholdRadius

		-- Work out the factor we need to multiply by to bring `midpoint - radius` values up to 1
		local factor = 1 - 1 / radiusMultiplier

		-- 0 will lead to a division by 0
		if radiusMultiplier ~= 1 then
			layerNoiseExpression = NoiseUtilities.Saturate(layerNoiseExpression / factor)
		else
			layerNoiseExpression = NoiseUtilities.ToBinary(layerNoiseExpression)
		end

		--  Apply this layer to our overall expression
		biomeExpression = biomeExpression * layerNoiseExpression
	end

	-- Blend the biome with other biomes with noise
	local threshold = tne(1) - biomeExpression
	if hasBlending then
		biomeExpression = biomeBlendingNoise - threshold
	end

	-- Convert to a binary value for returning
	return NoiseUtilities.ToBinary(biomeExpression)
end

function WorldNoiseBiomePlacer.Init()
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

	data.raw.tile["dirt-1"].autoplace = {
		probability_expression = tne(0.001)
	}
end

return WorldNoiseBiomePlacer